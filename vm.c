#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"

#define BUFFER_SIZE PGSIZE/4

extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}

int checkAccesedBit(char *va){
  struct proc *proc = myproc();
  uint flag;

  pte_t *pte = walkpgdir(proc->pgdir,(void*)va,0);

  if(!pte)
    panic("checkAccesedBit: pte not found");
  
  flag = (*pte) & PTE_A;
  (*pte) &= ~PTE_A;
  return flag;
}

int exactWriteToSwapFile(int i, struct proc* proc, char *va){

  int check = writeToSwapFile(proc, (char*)PTE_ADDR(va), i * PGSIZE, PGSIZE);
  if(check == 0)
    return 0;
  pte_t *pte1 = walkpgdir(proc->pgdir, (void*)va, 0);
  if(!*pte1)
    panic("exactWriteToSwapFile: page table entry does not exist");      
  kfree((char*)PTE_ADDR(P2V_WO(*walkpgdir(proc->pgdir, va, 0))));
  *pte1 = PTE_W | PTE_U | PTE_PG;
  ++proc->totalSwapCount;
  ++proc->swapFilePageCount;
  lcr3(V2P(proc->pgdir));
  return 1;
}

struct freePage *swaptoSwapFile(char *virtualAddress){
#if NFU
  struct proc *proc = myproc();
  
  uint tempAge = 0; //maximum age
  uint tempIndex = -1; //maximum index
  
  struct freePage *temp;
  for(int i = 0 ; i < MAX_PSYC_PAGES ; i++){
    if(proc->swappedPages[i].virtualAddress == (char*)0xffffffff){
      for(int j = 0; j < MAX_PSYC_PAGES ; j++)
        if(proc->freePages[j].virtualAddress != (char*)0xffffffff)
          if(proc->freePages[j].age > tempAge){
            tempAge = proc->freePages[j].age;
            tempIndex = j;
          }
    
      
      if(tempIndex == -1)
        panic("swaptoSwapFile #NFU: no free page");
      temp = &proc->freePages[tempIndex];
      pte_t *pte1 = walkpgdir(proc->pgdir, (void*)temp->virtualAddress, 0);
      if(!pte1)
        panic("swapToSwapFile #NFU: pte1 could not be found");

      acquire(&tickslock);
      if((*pte1) && PTE_A){
        temp->age+=1;;
        *pte1 &= ~PTE_A;
      }
      release(&tickslock);
      proc->swappedPages[i].virtualAddress = temp->virtualAddress;

      int check = exactWriteToSwapFile(i, proc, temp->virtualAddress);
      if(check == 0)
          return 0;

      temp->virtualAddress = virtualAddress;
      return temp;
    }
  }

#elif SCFIFO
  struct proc *proc = myproc();
  struct freePage *iterator, *init_iterator;
  for(int i = 0 ; i<MAX_PSYC_PAGES ; i++)
    if(proc->swappedPages[i].virtualAddress == (char*)0xffffffff){
      if(!(proc->head == 0 || proc->head->next == 0)){
              
        iterator = proc->tail;
        init_iterator = proc->tail;
        for(;;){
          proc->tail = proc->tail->prev;
          proc->tail->next = 0;
          iterator->prev = 0;
          iterator->next = proc->head;
          proc->head->prev = iterator;
          proc->head = iterator;
          iterator = proc->tail;
          if(!checkAccesedBit(proc->head->virtualAddress) && iterator !=init_iterator) break;
        }
      
        proc->swappedPages[i].virtualAddress = proc->head->virtualAddress;
  
        int check = exactWriteToSwapFile(i, proc, proc->head->virtualAddress);
        if(check == 0)
            return 0;
  
        proc->head->virtualAddress = virtualAddress;
        return proc->head;
      } else {
        panic("swaptoSwapFile #SCFIFO: memory pages not enough!");
      }      
    }

#elif FIFO
  struct proc *proc = myproc();
  struct freePage *temp, *last;
  for(int i = 0 ; i<MAX_PSYC_PAGES ; i++)
    if(proc->swappedPages[i].virtualAddress == (char*)0xffffffff){
      temp = proc->head;
      if(temp == 0)
        panic("swaptoSwapFile #FIFO: temp is null");
      if(temp->next == 0)
        panic("swaptoSwapFile #FIFO: memory has one page only!");
      while(temp->next->next!=0)
        temp = temp->next;
      last = temp->next;
      temp->next = 0;
      proc->swappedPages[i].virtualAddress = last->virtualAddress;

      int check = exactWriteToSwapFile(i, proc, last->virtualAddress);
      if(check == 0)
          return 0;

      return last;
    }
  
#endif
  panic("swaptoSwapFile: no free pages avirtualAddressilable!");
  return 0;  
}

void fillMetadata(char *virtualAddress){
  #if NFU
    struct proc *proc = myproc();
    for(int i = 0 ; i<MAX_PSYC_PAGES ; i++)
      if(proc->freePages[i].virtualAddress == (char*)0xffffffff){
         proc->freePages[i].virtualAddress = virtualAddress;
         proc->mainMemoryPageCount++;
         return;
      }
  
  #elif SCFIFO
    struct proc *proc = myproc();
    for(int i = 0 ; i<MAX_PSYC_PAGES ; i++)
      if (proc->freePages[i].virtualAddress == (char*)0xffffffff){
        proc->freePages[i].virtualAddress = virtualAddress;
        proc->freePages[i].next = proc->head;
        proc->freePages[i].prev = 0;
        if(!proc->head)
          proc->tail = &proc->freePages[i];
        else
          proc->head->prev = &proc->freePages[i];
        proc->head = &proc->freePages[i];
        proc->mainMemoryPageCount++;
        return;
      }

    cprintf("panic follows, pid:%d, name:%s\n", proc->pid, proc->name);
  
  #elif FIFO 
    //cprintf("FIFO" );
    struct proc *proc = myproc();
    for(int i = 0 ; i<MAX_PSYC_PAGES ; i++)
      if(proc->freePages[i].virtualAddress == (char*)0xffffffff){
        proc->freePages[i].virtualAddress = virtualAddress;
        proc->freePages[i].next = proc->head;
        proc->head = &proc->freePages[i];
        proc->mainMemoryPageCount++;
        return;
      }

    cprintf("panic follows, pid:%d, name:%s\n", proc->pid, proc->name);  
  #endif
    panic("fillMetadata: no free pages");
}
// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);

  #ifndef NONE
    struct proc *proc = myproc();
  #endif

  for(; a < newsz; a += PGSIZE){

    #ifndef NONE
      struct freePage *last;
      uint page = 1;
      if(proc->mainMemoryPageCount >= MAX_PSYC_PAGES && proc->pid > 2){
        last = swaptoSwapFile((char*)a);
        if(last){
          #if FIFO
          //cprintf("should be called fifo part\n");
            last->virtualAddress = (char*)a;
            last->next = proc->head;
            proc->head = last;
          #endif
          page = 0;
        } else {
          panic("Cannot write to swap file :: allocuvm");
        }        
      } if(page){
        fillMetadata((char*)a);
      }
    #endif

    mem = kalloc();  

    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }  

    memset(mem, 0, PGSIZE);

    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}

void exactForSwapAfterPageFault(struct proc* proc, int i, pte_t *pte1, pte_t *pte2, uint address){

  
  if (!*pte1)
    panic("exactForSwapAfterPageFault: pte1 is empty");
  if (!*pte2)
    panic("exactForSwapAfterPageFault: pte2 is empty");
  *pte2 = PTE_ADDR(*pte1) | PTE_U | PTE_W | PTE_P;

  char buf[BUFFER_SIZE];

  for(int j = 0; j < 4 ;j++){
    int vaoffset = ((PGSIZE / 4) * j);
    int location = (i * PGSIZE) + ((PGSIZE / 4) * j);
    memset(buf, 0, BUFFER_SIZE);
    readFromSwapFile(proc, buf, location, BUFFER_SIZE);
    writeToSwapFile(proc, (char*)(P2V_WO(PTE_ADDR(*pte1)) + vaoffset), location, BUFFER_SIZE);
    memmove((void*)(PTE_ADDR(address) + vaoffset), (void*)buf, BUFFER_SIZE);
  }
  *pte1 = PTE_U | PTE_W | PTE_PG;
  lcr3(V2P(proc->pgdir));
  proc->totalSwapCount++;

}

void swapAfterPageFault(uint address){
  struct proc *proc = myproc();
  if (proc->pid <2) {
    return;
  }
  #if NFU 
    
    uint tempAge = 0; //maximum age
    uint tempIndex = -1; //maximum index
    struct freePage *temp; //candidate page
    for(int j = 0; j < MAX_PSYC_PAGES ; j++){
      if (proc->freePages[j].virtualAddress != (char*)0xffffffff && proc->freePages[j].age > tempAge){
        tempAge = proc->freePages[j].age;
        tempIndex = j;
      }
    }
    if(!tempIndex)
      panic("swapAfterPageFault #NFU: No free page available!");
    else
      temp = &proc->freePages[tempIndex];
    
    pte_t *pte1 = walkpgdir(proc->pgdir, (void*)temp->virtualAddress, 0);
    if(!*pte1)
      panic("swapAfterPageFault #NFU: page table entry empty!");
    acquire(&tickslock);
    if((*pte1) & PTE_A){
      temp->age++;
      *pte1 &= ~PTE_A;
    }
    release(&tickslock);
    for(int i = 0 ; i < MAX_PSYC_PAGES ; i++){
      if (proc->swappedPages[i].virtualAddress == (char*)PTE_ADDR(address)){
        proc->swappedPages[i].virtualAddress = temp->virtualAddress;
        exactForSwapAfterPageFault(proc, i,
          pte1, 
          walkpgdir(proc->pgdir, (void*)address, 0), address);
        proc->head->virtualAddress = (char*)PTE_ADDR(address);
        return;
      }
    }
  #elif SCFIFO
    struct freePage *itr, *init_itr;
    if (proc->head == 0)
      panic("swapAfterPageFault #SCFIFO: proc's head is null!");
    if (proc->head->next == 0)
      panic("swapAfterPageFault #SCFIFO: only one page in memory!");
    itr = proc->tail;
    init_itr = proc->tail;
    for(;;){
      proc->tail = proc->tail->prev;
      proc->tail->next = 0;
      itr->prev = 0;
      itr->next = proc->head;
      proc->head->prev = itr;
      proc->head = itr;
      itr = proc->tail;
      if(!checkAccesedBit(proc->head->virtualAddress) && itr != init_itr) break;
    }
    for(int i = 0 ; i < MAX_PSYC_PAGES ; i++){
      if (proc->swappedPages[i].virtualAddress == (char*)PTE_ADDR(address)){
        proc->swappedPages[i].virtualAddress = proc->head->virtualAddress;
        exactForSwapAfterPageFault(proc, i,
          walkpgdir(proc->pgdir, (void*)proc->head->virtualAddress, 0), 
          walkpgdir(proc->pgdir, (void*)address, 0), address);
        proc->head->virtualAddress = (char*)PTE_ADDR(address);
        return; 
      }
    }
  #elif FIFO
    int i;
    struct freePage *temp = proc->head;
    struct freePage *tail;
    if(temp == 0)
      panic("Proc->head is NULL :: fifo :: swapPages");
    if (temp->next == 0)
      panic("Single page in phys mem :: fifo :: swapPages");
    // find the before-tail link in the used pages list
    while (temp->next->next != 0)
      temp = temp->next;
    tail = temp->next;
    temp->next = 0;
    i = 0;
    while(i<MAX_PSYC_PAGES){
      
      if(proc->swappedPages[i].virtualAddress == (char*)PTE_ADDR(address)){
        proc->swappedPages[i].virtualAddress = tail->virtualAddress;
        exactForSwapAfterPageFault(proc, i,
          walkpgdir(proc->pgdir, (void*)tail->virtualAddress, 0), 
          walkpgdir(proc->pgdir, (void*)address, 0), address);
        tail->next = proc->head;
        proc->head = tail;
        tail->virtualAddress = (char*)PTE_ADDR(address);
        return; 
      }
      i++;
    }
    panic("Problem in swappages");
  #endif
    panic("swapAfterPageFault: No free page Problem in swapping after page fault");
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  int i;
  struct proc* proc = myproc();

  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
      if(proc->pgdir == pgdir){
#ifndef NONE
        for(i=0; i<MAX_PSYC_PAGES; i++){
          if(proc->freePages[i].virtualAddress == (char*)a){
            proc->freePages[i].virtualAddress = (char*)0xffffffff;
  #if FIFO
            if (proc->head == &proc->freePages[i])
              proc->head = proc->freePages[i].next;
            else {
              struct freePage *last = proc->head;
              while (last->next != &proc->freePages[i])
              last = last->next;
              last->next = proc->freePages[i].next;
            }
            proc->freePages[i].next = 0;
  #elif SCFIFO
            if (proc->head == &proc->freePages[i]){
              proc->head = proc->freePages[i].next;
              if(proc->head != 0)
                proc->head->prev = 0;
              proc->freePages[i].next = 0;
              proc->freePages[i].prev = 0;
            }
            if (proc->tail == &proc->freePages[i]){
              proc->tail = proc->freePages[i].prev;
              proc->freePages[i].next = 0;
              proc->freePages[i].prev = 0;
            }
            struct freePage *last = proc->head;
            while (last->next != 0 && last->next != &proc->freePages[i]){
              last = last->next;
            }
            last->next = proc->freePages[i].next;
            if (proc->freePages[i].next != 0){
              proc->freePages[i].next->prev = last;
            }
  #endif     
            proc->mainMemoryPageCount--;
          }    
        }
#endif
      }
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
    else if((*pte & PTE_PG) && proc->pgdir == pgdir){
      for(i=0; i<MAX_PSYC_PAGES; i++){
        if(proc->swappedPages[i].virtualAddress == (char*)a){
          proc->swappedPages[i].virtualAddress = (char*) 0xffffffff;
          proc->swappedPages[i].age = 0;
          proc->swappedPages[i].swaploc = 0;
          proc->swapFilePageCount--;     
        }
      }
    }
  }
  return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
  *pte &= ~PTE_U;
}

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
      panic("copyuvm: page not present");
    if (*pte & PTE_PG) {
      // cprintf("copyuvm PTR_PG\n"); // TODO delete
      pte = walkpgdir(d, (void*) i, 1);
      *pte = PTE_U | PTE_W | PTE_PG;
      continue;
    }
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
      goto bad;
    }
  }
  return d;

bad:
  freevm(d);
  return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}

//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.

