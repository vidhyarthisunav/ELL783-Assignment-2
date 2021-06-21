#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "proc.h"
#include "kalloc.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

void updateNFUState(){

  struct proc *p;
  int i;
  pte_t *pte, *pde;

  acquire(&ptable.lock);
  for(p = ptable.proc; p< &ptable.proc[NPROC]; p++){
    if((p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)){
      for(i=0; i<MAX_PSYC_PAGES; i++){
        if(p->freePages[i].virtualAddress == (char*)0xffffffff)
          continue;
        p->freePages[i].age++;
        p->swappedPages[i].age++;

        pde = &p->pgdir[PDX(p->freePages[i].virtualAddress)];
        if(*pde & PTE_P){
          pte_t *pgtab;
          pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
          pte = &pgtab[PTX(p->freePages[i].virtualAddress)];
        }
        else pte = 0;
        if(pte){
          if(*pte & PTE_A){
            p->freePages[i].age = 0;
          }
        }
      }
    }
  }
  release(&ptable.lock);
}

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  // We initialize the metadata for the process if the NONE is not defined

  #ifndef NONE

    int i;
    for (i = 0; i < MAX_PSYC_PAGES; i++) {
      p->swappedPages[i].virtualAddress = (char*)0xffffffff;
      p->swappedPages[i].swaploc = 0;
      p->swappedPages[i].age = 0;
      p->freePages[i].virtualAddress = (char*)0xffffffff;
      p->freePages[i].next = 0;
      p->freePages[i].prev = 0;
      p->freePages[i].age = 0;
    }
    p->mainMemoryPageCount = 0;
    p->totalSwapCount = 0;
    p->pageFaultCount = 0;   
    p->swapFilePageCount = 0;
    p->head = 0;
    p->tail = 0;

  #endif

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// n is pagesize
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  #ifndef NONE

    np->mainMemoryPageCount = curproc->mainMemoryPageCount;
    np->swapFilePageCount = curproc->swapFilePageCount;

  #endif

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  #ifndef NONE
    if(curproc->pid > 2){
      createSwapFile(np);
      char buf[PGSIZE/2] = "";
      int offset = 0;
      int nread = 0;
      while((nread == readFromSwapFile(curproc,buf, offset, PGSIZE/2))!=0)
        if(writeToSwapFile(np, buf, offset, nread) == -1){
          panic("fork: error while copying the parent's swap file to the child");
        offset +=nread;
      }
    }

    for(i=0;i<MAX_PSYC_PAGES;i++){

      np->freePages[i].virtualAddress = curproc->freePages[i].virtualAddress;
      np->freePages[i].age = curproc->freePages[i].age;
      np->swappedPages[i].virtualAddress = curproc->swappedPages[i].virtualAddress;
      np->swappedPages[i].age = curproc->swappedPages[i].age;
      np->swappedPages[i].swaploc = curproc->swappedPages[i].swaploc;

    }


    int j;
    for(i = 0; i<MAX_PSYC_PAGES; i++){
      for(j=0;j<MAX_PSYC_PAGES;++j){
        if(np->freePages[j].virtualAddress == curproc->freePages[i].next->virtualAddress)
          np->freePages[i].next = &np->freePages[j];
        if(np->freePages[j].virtualAddress == curproc->freePages[i].prev->virtualAddress)
          np->freePages[i].prev = &np->freePages[j];
      }
    }  

    #if SCFIFO
      for (i = 0; i < MAX_PSYC_PAGES; i++) {
        if (curproc->head->virtualAddress == np->freePages[i].virtualAddress){
          np->head = &np->freePages[i];
        }
        if (curproc->tail->virtualAddress == np->freePages[i].virtualAddress){
          np->tail = &np->freePages[i];
        }
      }
    #elif FIFO
      for(i = 0;i<MAX_PSYC_PAGES;i++){
        if(curproc->head->virtualAddress == np->freePages[i].virtualAddress)
          np->head = &np->freePages[i];
        if(curproc->tail->virtualAddress == np->freePages[i].virtualAddress)
          np->tail = &np->freePages[i];
      }
    #endif
  #endif  

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

void printProcessDetails(struct proc *proc)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep",
  [RUNNABLE]  "runble",
  [RUNNING]   "run",
  [ZOMBIE]    "zombie"
  };
  int i;
  char *state;
  uint pc[10];
  if(proc->state >= 0 && proc->state < NELEM(states) && states[proc->state])
    state = states[proc->state];
  else
    state = "???";
  cprintf("\n<pid:%d> <state:%s> <name:%s> ", proc->pid, state, proc->name);
  cprintf("<allocated memory pages: %d> ", proc->mainMemoryPageCount);
  cprintf("<paged out: %d> ", proc->swapFilePageCount);
  cprintf("<page faults: %d> ", proc->pageFaultCount);
  cprintf("<totalnumber of pagedout: %d>\n", proc->totalSwapCount);
  if(proc->state == SLEEPING){
      getcallerpcs((uint*)proc->context->ebp+2, pc);
      int checker = 0;
      for(i=0; i<10 && pc[i] != 0; i++)
        {checker = 1; cprintf("%p ", pc[i]);}
      if(checker)
        cprintf("\n");
  }
  //cprintf("Count of paged out pages: %d,\n\n", proc->swapFilePageCount);

  cprintf("Main Memory Pages: ");
  for(int pop = 0 ; pop < proc->mainMemoryPageCount ; pop++){
        cprintf("0x%x ",(char*)proc->freePages[pop].virtualAddress);      
    
  }
  cprintf("\nswapFile Pages: ");
  for(int pop = 0 ; pop < proc->swapFilePageCount ; pop++){
    cprintf("0x%x ",(char*)proc->swappedPages[pop].virtualAddress);
  }
  if(proc->swapFilePageCount == 0) cprintf("swapFile Empty!");
  cprintf("\n");


  
}

int 
compute(const char *p, const char *q){
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  #ifndef NONE
    if(curproc->pid >2 &&  curproc->swapFile!=0 && curproc->swapFile->ref > 0)
    {
      removeSwapFile(curproc);
    }
  #endif
  #if TRUE
    if(compute(curproc->name,"sh") != 0)
      printProcessDetails(curproc);
  #endif

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  /*static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");*/
  struct proc *p;
  int percentage;
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    printProcessDetails(p);
  }
  percentage = (freePageCounts.currentFreePages*100)/freePageCounts.initFreePages;
  cprintf("\nNumber of free physical pages: %d/%d ~ %d%% \n",freePageCounts.currentFreePages,
    freePageCounts.initFreePages, percentage);
}


