
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 33 10 80       	mov    $0x80103350,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 7a 10 80       	push   $0x80107a20
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 35 4b 00 00       	call   80104b90 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 7a 10 80       	push   $0x80107a27
80100097:	50                   	push   %eax
80100098:	e8 c3 49 00 00       	call   80104a60 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 e7 4b 00 00       	call   80104cd0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 29 4c 00 00       	call   80104d90 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 49 00 00       	call   80104aa0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 fd 23 00 00       	call   80102580 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 7a 10 80       	push   $0x80107a2e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 8d 49 00 00       	call   80104b40 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 b7 23 00 00       	jmp    80102580 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 7a 10 80       	push   $0x80107a3f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 4c 49 00 00       	call   80104b40 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 fc 48 00 00       	call   80104b00 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 c0 4a 00 00       	call   80104cd0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 2f 4b 00 00       	jmp    80104d90 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 7a 10 80       	push   $0x80107a46
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 ab 15 00 00       	call   80101830 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 3f 4a 00 00       	call   80104cd0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002a7:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 a0 0f 11 80       	push   $0x80110fa0
801002c5:	e8 96 44 00 00       	call   80104760 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 00 3b 00 00       	call   80103de0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 9c 4a 00 00       	call   80104d90 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 54 14 00 00       	call   80101750 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 3e 4a 00 00       	call   80104d90 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 f6 13 00 00       	call   80101750 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 32 28 00 00       	call   80102be0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 7a 10 80       	push   $0x80107a4d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 e9 84 10 80 	movl   $0x801084e9,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 d3 47 00 00       	call   80104bb0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 7a 10 80       	push   $0x80107a61
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 81 60 00 00       	call   801064c0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 cf 5f 00 00       	call   801064c0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 c3 5f 00 00       	call   801064c0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 b7 5f 00 00       	call   801064c0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 67 49 00 00       	call   80104e90 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 9a 48 00 00       	call   80104de0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 7a 10 80       	push   $0x80107a65
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 90 7a 10 80 	movzbl -0x7fef8570(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 1c 12 00 00       	call   80101830 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 b0 46 00 00       	call   80104cd0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 44 47 00 00       	call   80104d90 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 fb 10 00 00       	call   80101750 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 6c 46 00 00       	call   80104d90 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 78 7a 10 80       	mov    $0x80107a78,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 db 44 00 00       	call   80104cd0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 7a 10 80       	push   $0x80107a7f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 a8 44 00 00       	call   80104cd0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100856:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 03 45 00 00       	call   80104d90 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100911:	68 a0 0f 11 80       	push   $0x80110fa0
80100916:	e8 05 40 00 00       	call   80104920 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010093d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100964:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 64 40 00 00       	jmp    80104a00 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 88 7a 10 80       	push   $0x80107a88
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 bb 41 00 00       	call   80104b90 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 32 1d 00 00       	call   80102730 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 bf 33 00 00       	call   80103de0 <myproc>
80100a21:	89 c7                	mov    %eax,%edi

  begin_op();
80100a23:	e8 28 26 00 00       	call   80103050 <begin_op>

  if((ip = namei(path)) == 0){
80100a28:	83 ec 0c             	sub    $0xc,%esp
80100a2b:	ff 75 08             	pushl  0x8(%ebp)
80100a2e:	e8 7d 15 00 00       	call   80101fb0 <namei>
80100a33:	83 c4 10             	add    $0x10,%esp
80100a36:	85 c0                	test   %eax,%eax
80100a38:	0f 84 3b 02 00 00    	je     80100c79 <exec+0x269>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a3e:	83 ec 0c             	sub    $0xc,%esp
80100a41:	89 c3                	mov    %eax,%ebx
80100a43:	50                   	push   %eax
80100a44:	e8 07 0d 00 00       	call   80101750 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a49:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a4f:	6a 34                	push   $0x34
80100a51:	6a 00                	push   $0x0
80100a53:	50                   	push   %eax
80100a54:	53                   	push   %ebx
80100a55:	e8 d6 0f 00 00       	call   80101a30 <readi>
80100a5a:	83 c4 20             	add    $0x20,%esp
80100a5d:	83 f8 34             	cmp    $0x34,%eax
80100a60:	74 26                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a62:	83 ec 0c             	sub    $0xc,%esp
80100a65:	53                   	push   %ebx
    end_op();
  }
  return -1;
80100a66:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    iunlockput(ip);
80100a6b:	e8 70 0f 00 00       	call   801019e0 <iunlockput>
    end_op();
80100a70:	e8 4b 26 00 00       	call   801030c0 <end_op>
80100a75:	83 c4 10             	add    $0x10,%esp
}
80100a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7b:	89 d8                	mov    %ebx,%eax
80100a7d:	5b                   	pop    %ebx
80100a7e:	5e                   	pop    %esi
80100a7f:	5f                   	pop    %edi
80100a80:	5d                   	pop    %ebp
80100a81:	c3                   	ret    
80100a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 ce                	jne    80100a62 <exec+0x52>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 97 6c 00 00       	call   80107730 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100aa1:	74 bf                	je     80100a62 <exec+0x52>
80100aa3:	8d 87 90 00 00 00    	lea    0x90(%edi),%eax
80100aa9:	8d 97 bc 01 00 00    	lea    0x1bc(%edi),%edx
80100aaf:	90                   	nop
      curproc->freePages[i].virtualAddress = (char*)0xffffffff;
80100ab0:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
      curproc->freePages[i].next = 0;
80100ab6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80100abd:	83 c0 14             	add    $0x14,%eax
      curproc->freePages[i].prev = 0;
80100ac0:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
      curproc->freePages[i].age = 0;
80100ac7:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
      curproc->swappedPages[i].age = 0;
80100ace:	c7 80 1c 01 00 00 00 	movl   $0x0,0x11c(%eax)
80100ad5:	00 00 00 
      curproc->swappedPages[i].virtualAddress = (char*)0xffffffff;
80100ad8:	c7 80 18 01 00 00 ff 	movl   $0xffffffff,0x118(%eax)
80100adf:	ff ff ff 
      curproc->swappedPages[i].swaploc = 0;
80100ae2:	c7 80 28 01 00 00 00 	movl   $0x0,0x128(%eax)
80100ae9:	00 00 00 
    for(int i=0;i < MAX_PSYC_PAGES; i++){
80100aec:	39 d0                	cmp    %edx,%eax
80100aee:	75 c0                	jne    80100ab0 <exec+0xa0>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100af0:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
    curproc->mainMemoryPageCount = 0;
80100af6:	c7 87 80 00 00 00 00 	movl   $0x0,0x80(%edi)
80100afd:	00 00 00 
    curproc->swapFilePageCount = 0;
80100b00:	c7 87 84 00 00 00 00 	movl   $0x0,0x84(%edi)
80100b07:	00 00 00 
    curproc->pageFaultCount = 0;
80100b0a:	c7 87 88 00 00 00 00 	movl   $0x0,0x88(%edi)
80100b11:	00 00 00 
    curproc->totalSwapCount = 0;
80100b14:	c7 87 8c 00 00 00 00 	movl   $0x0,0x8c(%edi)
80100b1b:	00 00 00 
    curproc->head = 0;
80100b1e:	c7 87 e8 02 00 00 00 	movl   $0x0,0x2e8(%edi)
80100b25:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b28:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  sz = 0;
80100b2e:	31 c0                	xor    %eax,%eax
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b30:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b37:	00 
    curproc->tail = 0;
80100b38:	c7 87 ec 02 00 00 00 	movl   $0x0,0x2ec(%edi)
80100b3f:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b42:	0f 84 bf 02 00 00    	je     80100e07 <exec+0x3f7>
80100b48:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100b4e:	31 f6                	xor    %esi,%esi
80100b50:	89 c7                	mov    %eax,%edi
80100b52:	eb 7e                	jmp    80100bd2 <exec+0x1c2>
80100b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100b58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b5f:	75 63                	jne    80100bc4 <exec+0x1b4>
    if(ph.memsz < ph.filesz)
80100b61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b6d:	0f 82 86 00 00 00    	jb     80100bf9 <exec+0x1e9>
80100b73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b79:	72 7e                	jb     80100bf9 <exec+0x1e9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b7b:	83 ec 04             	sub    $0x4,%esp
80100b7e:	50                   	push   %eax
80100b7f:	57                   	push   %edi
80100b80:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b86:	e8 e5 69 00 00       	call   80107570 <allocuvm>
80100b8b:	83 c4 10             	add    $0x10,%esp
80100b8e:	85 c0                	test   %eax,%eax
80100b90:	89 c7                	mov    %eax,%edi
80100b92:	74 65                	je     80100bf9 <exec+0x1e9>
    if(ph.vaddr % PGSIZE != 0)
80100b94:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b9a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b9f:	75 58                	jne    80100bf9 <exec+0x1e9>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ba1:	83 ec 0c             	sub    $0xc,%esp
80100ba4:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100baa:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100bb0:	53                   	push   %ebx
80100bb1:	50                   	push   %eax
80100bb2:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bb8:	e8 13 67 00 00       	call   801072d0 <loaduvm>
80100bbd:	83 c4 20             	add    $0x20,%esp
80100bc0:	85 c0                	test   %eax,%eax
80100bc2:	78 35                	js     80100bf9 <exec+0x1e9>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bc4:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bcb:	83 c6 01             	add    $0x1,%esi
80100bce:	39 f0                	cmp    %esi,%eax
80100bd0:	7e 3d                	jle    80100c0f <exec+0x1ff>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bd2:	89 f0                	mov    %esi,%eax
80100bd4:	6a 20                	push   $0x20
80100bd6:	c1 e0 05             	shl    $0x5,%eax
80100bd9:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100bdf:	50                   	push   %eax
80100be0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100be6:	50                   	push   %eax
80100be7:	53                   	push   %ebx
80100be8:	e8 43 0e 00 00       	call   80101a30 <readi>
80100bed:	83 c4 10             	add    $0x10,%esp
80100bf0:	83 f8 20             	cmp    $0x20,%eax
80100bf3:	0f 84 5f ff ff ff    	je     80100b58 <exec+0x148>
    freevm(pgdir);
80100bf9:	83 ec 0c             	sub    $0xc,%esp
80100bfc:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c02:	e8 a9 6a 00 00       	call   801076b0 <freevm>
80100c07:	83 c4 10             	add    $0x10,%esp
80100c0a:	e9 53 fe ff ff       	jmp    80100a62 <exec+0x52>
80100c0f:	89 f8                	mov    %edi,%eax
80100c11:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100c17:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c1c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100c21:	8d b0 00 20 00 00    	lea    0x2000(%eax),%esi
  iunlockput(ip);
80100c27:	83 ec 0c             	sub    $0xc,%esp
80100c2a:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c30:	53                   	push   %ebx
80100c31:	e8 aa 0d 00 00       	call   801019e0 <iunlockput>
  end_op();
80100c36:	e8 85 24 00 00       	call   801030c0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c3b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c41:	83 c4 0c             	add    $0xc,%esp
80100c44:	56                   	push   %esi
80100c45:	50                   	push   %eax
80100c46:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c4c:	e8 1f 69 00 00       	call   80107570 <allocuvm>
80100c51:	83 c4 10             	add    $0x10,%esp
80100c54:	85 c0                	test   %eax,%eax
80100c56:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c5c:	75 3a                	jne    80100c98 <exec+0x288>
    freevm(pgdir);
80100c5e:	83 ec 0c             	sub    $0xc,%esp
80100c61:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  return -1;
80100c67:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    freevm(pgdir);
80100c6c:	e8 3f 6a 00 00       	call   801076b0 <freevm>
80100c71:	83 c4 10             	add    $0x10,%esp
80100c74:	e9 ff fd ff ff       	jmp    80100a78 <exec+0x68>
    end_op();
80100c79:	e8 42 24 00 00       	call   801030c0 <end_op>
    cprintf("exec: fail\n");
80100c7e:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80100c81:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    cprintf("exec: fail\n");
80100c86:	68 a1 7a 10 80       	push   $0x80107aa1
80100c8b:	e8 d0 f9 ff ff       	call   80100660 <cprintf>
    return -1;
80100c90:	83 c4 10             	add    $0x10,%esp
80100c93:	e9 e0 fd ff ff       	jmp    80100a78 <exec+0x68>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c98:	89 c3                	mov    %eax,%ebx
80100c9a:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100ca0:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100ca3:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ca5:	50                   	push   %eax
80100ca6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cac:	e8 1f 6b 00 00       	call   801077d0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cb4:	83 c4 10             	add    $0x10,%esp
80100cb7:	8b 00                	mov    (%eax),%eax
80100cb9:	85 c0                	test   %eax,%eax
80100cbb:	0f 84 50 01 00 00    	je     80100e11 <exec+0x401>
80100cc1:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100cc7:	89 f7                	mov    %esi,%edi
80100cc9:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100ccf:	eb 0c                	jmp    80100cdd <exec+0x2cd>
80100cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100cd8:	83 ff 20             	cmp    $0x20,%edi
80100cdb:	74 81                	je     80100c5e <exec+0x24e>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cdd:	83 ec 0c             	sub    $0xc,%esp
80100ce0:	50                   	push   %eax
80100ce1:	e8 1a 43 00 00       	call   80105000 <strlen>
80100ce6:	f7 d0                	not    %eax
80100ce8:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cea:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ced:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cee:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cf1:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cf4:	e8 07 43 00 00       	call   80105000 <strlen>
80100cf9:	83 c0 01             	add    $0x1,%eax
80100cfc:	50                   	push   %eax
80100cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d00:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d03:	53                   	push   %ebx
80100d04:	56                   	push   %esi
80100d05:	e8 66 6c 00 00       	call   80107970 <copyout>
80100d0a:	83 c4 20             	add    $0x20,%esp
80100d0d:	85 c0                	test   %eax,%eax
80100d0f:	0f 88 49 ff ff ff    	js     80100c5e <exec+0x24e>
  for(argc = 0; argv[argc]; argc++) {
80100d15:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100d18:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100d1f:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100d22:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100d28:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d2b:	85 c0                	test   %eax,%eax
80100d2d:	75 a9                	jne    80100cd8 <exec+0x2c8>
80100d2f:	89 fe                	mov    %edi,%esi
80100d31:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d37:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100d3e:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d40:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100d47:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100d4b:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d52:	ff ff ff 
  ustack[1] = argc;
80100d55:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5b:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d5d:	83 c0 0c             	add    $0xc,%eax
80100d60:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d62:	50                   	push   %eax
80100d63:	52                   	push   %edx
80100d64:	53                   	push   %ebx
80100d65:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d6b:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d71:	e8 fa 6b 00 00       	call   80107970 <copyout>
80100d76:	83 c4 10             	add    $0x10,%esp
80100d79:	85 c0                	test   %eax,%eax
80100d7b:	0f 88 dd fe ff ff    	js     80100c5e <exec+0x24e>
  for(last=s=path; *s; s++)
80100d81:	8b 45 08             	mov    0x8(%ebp),%eax
80100d84:	0f b6 00             	movzbl (%eax),%eax
80100d87:	84 c0                	test   %al,%al
80100d89:	74 17                	je     80100da2 <exec+0x392>
80100d8b:	8b 55 08             	mov    0x8(%ebp),%edx
80100d8e:	89 d1                	mov    %edx,%ecx
80100d90:	83 c1 01             	add    $0x1,%ecx
80100d93:	3c 2f                	cmp    $0x2f,%al
80100d95:	0f b6 01             	movzbl (%ecx),%eax
80100d98:	0f 44 d1             	cmove  %ecx,%edx
80100d9b:	84 c0                	test   %al,%al
80100d9d:	75 f1                	jne    80100d90 <exec+0x380>
80100d9f:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100da2:	50                   	push   %eax
80100da3:	8d 47 6c             	lea    0x6c(%edi),%eax
80100da6:	6a 10                	push   $0x10
80100da8:	ff 75 08             	pushl  0x8(%ebp)
80100dab:	50                   	push   %eax
80100dac:	e8 0f 42 00 00       	call   80104fc0 <safestrcpy>
  curproc->pgdir = pgdir;
80100db1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100db7:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
80100dba:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80100dbd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100dc3:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100dc5:	8b 47 18             	mov    0x18(%edi),%eax
80100dc8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dce:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dd1:	8b 47 18             	mov    0x18(%edi),%eax
80100dd4:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dd7:	89 3c 24             	mov    %edi,(%esp)
  return 0;
80100dda:	31 db                	xor    %ebx,%ebx
  switchuvm(curproc);
80100ddc:	e8 5f 63 00 00       	call   80107140 <switchuvm>
  freevm(oldpgdir);
80100de1:	89 34 24             	mov    %esi,(%esp)
80100de4:	e8 c7 68 00 00       	call   801076b0 <freevm>
    if(curproc->pid > 2){
80100de9:	83 c4 10             	add    $0x10,%esp
80100dec:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80100df0:	0f 8e 82 fc ff ff    	jle    80100a78 <exec+0x68>
      createSwapFile(curproc);
80100df6:	83 ec 0c             	sub    $0xc,%esp
80100df9:	57                   	push   %edi
80100dfa:	e8 81 14 00 00       	call   80102280 <createSwapFile>
80100dff:	83 c4 10             	add    $0x10,%esp
80100e02:	e9 71 fc ff ff       	jmp    80100a78 <exec+0x68>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e07:	be 00 20 00 00       	mov    $0x2000,%esi
80100e0c:	e9 16 fe ff ff       	jmp    80100c27 <exec+0x217>
  for(argc = 0; argv[argc]; argc++) {
80100e11:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100e17:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100e1d:	e9 15 ff ff ff       	jmp    80100d37 <exec+0x327>
80100e22:	66 90                	xchg   %ax,%ax
80100e24:	66 90                	xchg   %ax,%ax
80100e26:	66 90                	xchg   %ax,%ax
80100e28:	66 90                	xchg   %ax,%ax
80100e2a:	66 90                	xchg   %ax,%ax
80100e2c:	66 90                	xchg   %ax,%ax
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e36:	68 ad 7a 10 80       	push   $0x80107aad
80100e3b:	68 c0 0f 11 80       	push   $0x80110fc0
80100e40:	e8 4b 3d 00 00       	call   80104b90 <initlock>
}
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	c9                   	leave  
80100e49:	c3                   	ret    
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e5c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e61:	e8 6a 3e 00 00       	call   80104cd0 <acquire>
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	eb 10                	jmp    80100e7b <filealloc+0x2b>
80100e6b:	90                   	nop
80100e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e79:	73 25                	jae    80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e91:	e8 fa 3e 00 00       	call   80104d90 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e96:	89 d8                	mov    %ebx,%eax
      return f;
80100e98:	83 c4 10             	add    $0x10,%esp
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave  
80100e9f:	c3                   	ret    
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ea3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ea5:	68 c0 0f 11 80       	push   $0x80110fc0
80100eaa:	e8 e1 3e 00 00       	call   80104d90 <release>
}
80100eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80100eb1:	83 c4 10             	add    $0x10,%esp
}
80100eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb7:	c9                   	leave  
80100eb8:	c3                   	ret    
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 10             	sub    $0x10,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eca:	68 c0 0f 11 80       	push   $0x80110fc0
80100ecf:	e8 fc 3d 00 00       	call   80104cd0 <acquire>
  if(f->ref < 1)
80100ed4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 1a                	jle    80100ef8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ede:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ee4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ee7:	68 c0 0f 11 80       	push   $0x80110fc0
80100eec:	e8 9f 3e 00 00       	call   80104d90 <release>
  return f;
}
80100ef1:	89 d8                	mov    %ebx,%eax
80100ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef6:	c9                   	leave  
80100ef7:	c3                   	ret    
    panic("filedup");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 b4 7a 10 80       	push   $0x80107ab4
80100f00:	e8 8b f4 ff ff       	call   80100390 <panic>
80100f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 28             	sub    $0x28,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f1c:	68 c0 0f 11 80       	push   $0x80110fc0
80100f21:	e8 aa 3d 00 00       	call   80104cd0 <acquire>
  if(f->ref < 1)
80100f26:	8b 43 04             	mov    0x4(%ebx),%eax
80100f29:	83 c4 10             	add    $0x10,%esp
80100f2c:	85 c0                	test   %eax,%eax
80100f2e:	0f 8e 9b 00 00 00    	jle    80100fcf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f34:	83 e8 01             	sub    $0x1,%eax
80100f37:	85 c0                	test   %eax,%eax
80100f39:	89 43 04             	mov    %eax,0x4(%ebx)
80100f3c:	74 1a                	je     80100f58 <fileclose+0x48>
    release(&ftable.lock);
80100f3e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f48:	5b                   	pop    %ebx
80100f49:	5e                   	pop    %esi
80100f4a:	5f                   	pop    %edi
80100f4b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f4c:	e9 3f 3e 00 00       	jmp    80104d90 <release>
80100f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100f58:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f5c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100f5e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f61:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100f64:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f6a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f6d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f70:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f75:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f78:	e8 13 3e 00 00       	call   80104d90 <release>
  if(ff.type == FD_PIPE)
80100f7d:	83 c4 10             	add    $0x10,%esp
80100f80:	83 ff 01             	cmp    $0x1,%edi
80100f83:	74 13                	je     80100f98 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100f85:	83 ff 02             	cmp    $0x2,%edi
80100f88:	74 26                	je     80100fb0 <fileclose+0xa0>
}
80100f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8d:	5b                   	pop    %ebx
80100f8e:	5e                   	pop    %esi
80100f8f:	5f                   	pop    %edi
80100f90:	5d                   	pop    %ebp
80100f91:	c3                   	ret    
80100f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f98:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f9c:	83 ec 08             	sub    $0x8,%esp
80100f9f:	53                   	push   %ebx
80100fa0:	56                   	push   %esi
80100fa1:	e8 5a 28 00 00       	call   80103800 <pipeclose>
80100fa6:	83 c4 10             	add    $0x10,%esp
80100fa9:	eb df                	jmp    80100f8a <fileclose+0x7a>
80100fab:	90                   	nop
80100fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100fb0:	e8 9b 20 00 00       	call   80103050 <begin_op>
    iput(ff.ip);
80100fb5:	83 ec 0c             	sub    $0xc,%esp
80100fb8:	ff 75 e0             	pushl  -0x20(%ebp)
80100fbb:	e8 c0 08 00 00       	call   80101880 <iput>
    end_op();
80100fc0:	83 c4 10             	add    $0x10,%esp
}
80100fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc6:	5b                   	pop    %ebx
80100fc7:	5e                   	pop    %esi
80100fc8:	5f                   	pop    %edi
80100fc9:	5d                   	pop    %ebp
    end_op();
80100fca:	e9 f1 20 00 00       	jmp    801030c0 <end_op>
    panic("fileclose");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 bc 7a 10 80       	push   $0x80107abc
80100fd7:	e8 b4 f3 ff ff       	call   80100390 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	53                   	push   %ebx
80100fe4:	83 ec 04             	sub    $0x4,%esp
80100fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fed:	75 31                	jne    80101020 <filestat+0x40>
    ilock(f->ip);
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	ff 73 10             	pushl  0x10(%ebx)
80100ff5:	e8 56 07 00 00       	call   80101750 <ilock>
    stati(f->ip, st);
80100ffa:	58                   	pop    %eax
80100ffb:	5a                   	pop    %edx
80100ffc:	ff 75 0c             	pushl  0xc(%ebp)
80100fff:	ff 73 10             	pushl  0x10(%ebx)
80101002:	e8 f9 09 00 00       	call   80101a00 <stati>
    iunlock(f->ip);
80101007:	59                   	pop    %ecx
80101008:	ff 73 10             	pushl  0x10(%ebx)
8010100b:	e8 20 08 00 00       	call   80101830 <iunlock>
    return 0;
80101010:	83 c4 10             	add    $0x10,%esp
80101013:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101025:	eb ee                	jmp    80101015 <filestat+0x35>
80101027:	89 f6                	mov    %esi,%esi
80101029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101030 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 0c             	sub    $0xc,%esp
80101039:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010103c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010103f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101042:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101046:	74 60                	je     801010a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101048:	8b 03                	mov    (%ebx),%eax
8010104a:	83 f8 01             	cmp    $0x1,%eax
8010104d:	74 41                	je     80101090 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104f:	83 f8 02             	cmp    $0x2,%eax
80101052:	75 5b                	jne    801010af <fileread+0x7f>
    ilock(f->ip);
80101054:	83 ec 0c             	sub    $0xc,%esp
80101057:	ff 73 10             	pushl  0x10(%ebx)
8010105a:	e8 f1 06 00 00       	call   80101750 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010105f:	57                   	push   %edi
80101060:	ff 73 14             	pushl  0x14(%ebx)
80101063:	56                   	push   %esi
80101064:	ff 73 10             	pushl  0x10(%ebx)
80101067:	e8 c4 09 00 00       	call   80101a30 <readi>
8010106c:	83 c4 20             	add    $0x20,%esp
8010106f:	85 c0                	test   %eax,%eax
80101071:	89 c6                	mov    %eax,%esi
80101073:	7e 03                	jle    80101078 <fileread+0x48>
      f->off += r;
80101075:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	ff 73 10             	pushl  0x10(%ebx)
8010107e:	e8 ad 07 00 00       	call   80101830 <iunlock>
    return r;
80101083:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	89 f0                	mov    %esi,%eax
8010108b:	5b                   	pop    %ebx
8010108c:	5e                   	pop    %esi
8010108d:	5f                   	pop    %edi
8010108e:	5d                   	pop    %ebp
8010108f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101090:	8b 43 0c             	mov    0xc(%ebx),%eax
80101093:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	5b                   	pop    %ebx
8010109a:	5e                   	pop    %esi
8010109b:	5f                   	pop    %edi
8010109c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010109d:	e9 0e 29 00 00       	jmp    801039b0 <piperead>
801010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ad:	eb d7                	jmp    80101086 <fileread+0x56>
  panic("fileread");
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 c6 7a 10 80       	push   $0x80107ac6
801010b7:	e8 d4 f2 ff ff       	call   80100390 <panic>
801010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	57                   	push   %edi
801010c4:	56                   	push   %esi
801010c5:	53                   	push   %ebx
801010c6:	83 ec 1c             	sub    $0x1c,%esp
801010c9:	8b 75 08             	mov    0x8(%ebp),%esi
801010cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801010cf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010d6:	8b 45 10             	mov    0x10(%ebp),%eax
801010d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010dc:	0f 84 aa 00 00 00    	je     8010118c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801010e2:	8b 06                	mov    (%esi),%eax
801010e4:	83 f8 01             	cmp    $0x1,%eax
801010e7:	0f 84 c3 00 00 00    	je     801011b0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ed:	83 f8 02             	cmp    $0x2,%eax
801010f0:	0f 85 d9 00 00 00    	jne    801011cf <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010f9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010fb:	85 c0                	test   %eax,%eax
801010fd:	7f 34                	jg     80101133 <filewrite+0x73>
801010ff:	e9 9c 00 00 00       	jmp    801011a0 <filewrite+0xe0>
80101104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101108:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101111:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101114:	e8 17 07 00 00       	call   80101830 <iunlock>
      end_op();
80101119:	e8 a2 1f 00 00       	call   801030c0 <end_op>
8010111e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101121:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101124:	39 c3                	cmp    %eax,%ebx
80101126:	0f 85 96 00 00 00    	jne    801011c2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010112c:	01 df                	add    %ebx,%edi
    while(i < n){
8010112e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101131:	7e 6d                	jle    801011a0 <filewrite+0xe0>
      int n1 = n - i;
80101133:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101136:	b8 00 06 00 00       	mov    $0x600,%eax
8010113b:	29 fb                	sub    %edi,%ebx
8010113d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101143:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101146:	e8 05 1f 00 00       	call   80103050 <begin_op>
      ilock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
8010114e:	ff 76 10             	pushl  0x10(%esi)
80101151:	e8 fa 05 00 00       	call   80101750 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101156:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101159:	53                   	push   %ebx
8010115a:	ff 76 14             	pushl  0x14(%esi)
8010115d:	01 f8                	add    %edi,%eax
8010115f:	50                   	push   %eax
80101160:	ff 76 10             	pushl  0x10(%esi)
80101163:	e8 c8 09 00 00       	call   80101b30 <writei>
80101168:	83 c4 20             	add    $0x20,%esp
8010116b:	85 c0                	test   %eax,%eax
8010116d:	7f 99                	jg     80101108 <filewrite+0x48>
      iunlock(f->ip);
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	ff 76 10             	pushl  0x10(%esi)
80101175:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101178:	e8 b3 06 00 00       	call   80101830 <iunlock>
      end_op();
8010117d:	e8 3e 1f 00 00       	call   801030c0 <end_op>
      if(r < 0)
80101182:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101185:	83 c4 10             	add    $0x10,%esp
80101188:	85 c0                	test   %eax,%eax
8010118a:	74 98                	je     80101124 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010118f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101194:	89 f8                	mov    %edi,%eax
80101196:	5b                   	pop    %ebx
80101197:	5e                   	pop    %esi
80101198:	5f                   	pop    %edi
80101199:	5d                   	pop    %ebp
8010119a:	c3                   	ret    
8010119b:	90                   	nop
8010119c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801011a0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801011a3:	75 e7                	jne    8010118c <filewrite+0xcc>
}
801011a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a8:	89 f8                	mov    %edi,%eax
801011aa:	5b                   	pop    %ebx
801011ab:	5e                   	pop    %esi
801011ac:	5f                   	pop    %edi
801011ad:	5d                   	pop    %ebp
801011ae:	c3                   	ret    
801011af:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801011b0:	8b 46 0c             	mov    0xc(%esi),%eax
801011b3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b9:	5b                   	pop    %ebx
801011ba:	5e                   	pop    %esi
801011bb:	5f                   	pop    %edi
801011bc:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011bd:	e9 de 26 00 00       	jmp    801038a0 <pipewrite>
        panic("short filewrite");
801011c2:	83 ec 0c             	sub    $0xc,%esp
801011c5:	68 cf 7a 10 80       	push   $0x80107acf
801011ca:	e8 c1 f1 ff ff       	call   80100390 <panic>
  panic("filewrite");
801011cf:	83 ec 0c             	sub    $0xc,%esp
801011d2:	68 d5 7a 10 80       	push   $0x80107ad5
801011d7:	e8 b4 f1 ff ff       	call   80100390 <panic>
801011dc:	66 90                	xchg   %ax,%ax
801011de:	66 90                	xchg   %ax,%ax

801011e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	56                   	push   %esi
801011e4:	53                   	push   %ebx
801011e5:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011e7:	c1 ea 0c             	shr    $0xc,%edx
801011ea:	03 15 d8 19 11 80    	add    0x801119d8,%edx
801011f0:	83 ec 08             	sub    $0x8,%esp
801011f3:	52                   	push   %edx
801011f4:	50                   	push   %eax
801011f5:	e8 d6 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011fa:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011fc:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011ff:	ba 01 00 00 00       	mov    $0x1,%edx
80101204:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101207:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010120d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101210:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101212:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101217:	85 d1                	test   %edx,%ecx
80101219:	74 25                	je     80101240 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010121b:	f7 d2                	not    %edx
8010121d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010121f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101222:	21 ca                	and    %ecx,%edx
80101224:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101228:	56                   	push   %esi
80101229:	e8 f2 1f 00 00       	call   80103220 <log_write>
  brelse(bp);
8010122e:	89 34 24             	mov    %esi,(%esp)
80101231:	e8 aa ef ff ff       	call   801001e0 <brelse>
}
80101236:	83 c4 10             	add    $0x10,%esp
80101239:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010123c:	5b                   	pop    %ebx
8010123d:	5e                   	pop    %esi
8010123e:	5d                   	pop    %ebp
8010123f:	c3                   	ret    
    panic("freeing free block");
80101240:	83 ec 0c             	sub    $0xc,%esp
80101243:	68 df 7a 10 80       	push   $0x80107adf
80101248:	e8 43 f1 ff ff       	call   80100390 <panic>
8010124d:	8d 76 00             	lea    0x0(%esi),%esi

80101250 <balloc>:
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010125f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 87 00 00 00    	je     801012f1 <balloc+0xa1>
8010126a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101271:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101274:	83 ec 08             	sub    $0x8,%esp
80101277:	89 f0                	mov    %esi,%eax
80101279:	c1 f8 0c             	sar    $0xc,%eax
8010127c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101282:	50                   	push   %eax
80101283:	ff 75 d8             	pushl  -0x28(%ebp)
80101286:	e8 45 ee ff ff       	call   801000d0 <bread>
8010128b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010128e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101293:	83 c4 10             	add    $0x10,%esp
80101296:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101299:	31 c0                	xor    %eax,%eax
8010129b:	eb 2f                	jmp    801012cc <balloc+0x7c>
8010129d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012a5:	bb 01 00 00 00       	mov    $0x1,%ebx
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012b9:	85 df                	test   %ebx,%edi
801012bb:	89 fa                	mov    %edi,%edx
801012bd:	74 41                	je     80101300 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 05                	je     801012d1 <balloc+0x81>
801012cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012cf:	77 cf                	ja     801012a0 <balloc+0x50>
    brelse(bp);
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012d7:	e8 04 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012e9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012ef:	77 80                	ja     80101271 <balloc+0x21>
  panic("balloc: out of blocks");
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 f2 7a 10 80       	push   $0x80107af2
801012f9:	e8 92 f0 ff ff       	call   80100390 <panic>
801012fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101303:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101306:	09 da                	or     %ebx,%edx
80101308:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010130c:	57                   	push   %edi
8010130d:	e8 0e 1f 00 00       	call   80103220 <log_write>
        brelse(bp);
80101312:	89 3c 24             	mov    %edi,(%esp)
80101315:	e8 c6 ee ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010131a:	58                   	pop    %eax
8010131b:	5a                   	pop    %edx
8010131c:	56                   	push   %esi
8010131d:	ff 75 d8             	pushl  -0x28(%ebp)
80101320:	e8 ab ed ff ff       	call   801000d0 <bread>
80101325:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101327:	8d 40 5c             	lea    0x5c(%eax),%eax
8010132a:	83 c4 0c             	add    $0xc,%esp
8010132d:	68 00 02 00 00       	push   $0x200
80101332:	6a 00                	push   $0x0
80101334:	50                   	push   %eax
80101335:	e8 a6 3a 00 00       	call   80104de0 <memset>
  log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 de 1e 00 00       	call   80103220 <log_write>
  brelse(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 96 ee ff ff       	call   801001e0 <brelse>
}
8010134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134d:	89 f0                	mov    %esi,%eax
8010134f:	5b                   	pop    %ebx
80101350:	5e                   	pop    %esi
80101351:	5f                   	pop    %edi
80101352:	5d                   	pop    %ebp
80101353:	c3                   	ret    
80101354:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010135a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101360 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101368:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010136f:	83 ec 28             	sub    $0x28,%esp
80101372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101375:	68 e0 19 11 80       	push   $0x801119e0
8010137a:	e8 51 39 00 00       	call   80104cd0 <acquire>
8010137f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101382:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101385:	eb 17                	jmp    8010139e <iget+0x3e>
80101387:	89 f6                	mov    %esi,%esi
80101389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101390:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101396:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010139c:	73 22                	jae    801013c0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010139e:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013a1:	85 c9                	test   %ecx,%ecx
801013a3:	7e 04                	jle    801013a9 <iget+0x49>
801013a5:	39 3b                	cmp    %edi,(%ebx)
801013a7:	74 4f                	je     801013f8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a9:	85 f6                	test   %esi,%esi
801013ab:	75 e3                	jne    80101390 <iget+0x30>
801013ad:	85 c9                	test   %ecx,%ecx
801013af:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013b8:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013be:	72 de                	jb     8010139e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c0:	85 f6                	test   %esi,%esi
801013c2:	74 5b                	je     8010141f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013c4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013c7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013cc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013d3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013da:	68 e0 19 11 80       	push   $0x801119e0
801013df:	e8 ac 39 00 00       	call   80104d90 <release>

  return ip;
801013e4:	83 c4 10             	add    $0x10,%esp
}
801013e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ea:	89 f0                	mov    %esi,%eax
801013ec:	5b                   	pop    %ebx
801013ed:	5e                   	pop    %esi
801013ee:	5f                   	pop    %edi
801013ef:	5d                   	pop    %ebp
801013f0:	c3                   	ret    
801013f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f8:	39 53 04             	cmp    %edx,0x4(%ebx)
801013fb:	75 ac                	jne    801013a9 <iget+0x49>
      release(&icache.lock);
801013fd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101400:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101403:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101405:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
8010140a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010140d:	e8 7e 39 00 00       	call   80104d90 <release>
      return ip;
80101412:	83 c4 10             	add    $0x10,%esp
}
80101415:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101418:	89 f0                	mov    %esi,%eax
8010141a:	5b                   	pop    %ebx
8010141b:	5e                   	pop    %esi
8010141c:	5f                   	pop    %edi
8010141d:	5d                   	pop    %ebp
8010141e:	c3                   	ret    
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 08 7b 10 80       	push   $0x80107b08
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	53                   	push   %ebx
80101436:	89 c6                	mov    %eax,%esi
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	77 18                	ja     80101458 <bmap+0x28>
80101440:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101443:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101446:	85 db                	test   %ebx,%ebx
80101448:	74 76                	je     801014c0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010144a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144d:	89 d8                	mov    %ebx,%eax
8010144f:	5b                   	pop    %ebx
80101450:	5e                   	pop    %esi
80101451:	5f                   	pop    %edi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret    
80101454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101458:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010145b:	83 fb 7f             	cmp    $0x7f,%ebx
8010145e:	0f 87 90 00 00 00    	ja     801014f4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101464:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010146a:	8b 00                	mov    (%eax),%eax
8010146c:	85 d2                	test   %edx,%edx
8010146e:	74 70                	je     801014e0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101470:	83 ec 08             	sub    $0x8,%esp
80101473:	52                   	push   %edx
80101474:	50                   	push   %eax
80101475:	e8 56 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010147a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010147e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101481:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101483:	8b 1a                	mov    (%edx),%ebx
80101485:	85 db                	test   %ebx,%ebx
80101487:	75 1d                	jne    801014a6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101489:	8b 06                	mov    (%esi),%eax
8010148b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010148e:	e8 bd fd ff ff       	call   80101250 <balloc>
80101493:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101496:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101499:	89 c3                	mov    %eax,%ebx
8010149b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010149d:	57                   	push   %edi
8010149e:	e8 7d 1d 00 00       	call   80103220 <log_write>
801014a3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801014a6:	83 ec 0c             	sub    $0xc,%esp
801014a9:	57                   	push   %edi
801014aa:	e8 31 ed ff ff       	call   801001e0 <brelse>
801014af:	83 c4 10             	add    $0x10,%esp
}
801014b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b5:	89 d8                	mov    %ebx,%eax
801014b7:	5b                   	pop    %ebx
801014b8:	5e                   	pop    %esi
801014b9:	5f                   	pop    %edi
801014ba:	5d                   	pop    %ebp
801014bb:	c3                   	ret    
801014bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801014c0:	8b 00                	mov    (%eax),%eax
801014c2:	e8 89 fd ff ff       	call   80101250 <balloc>
801014c7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801014ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801014cd:	89 c3                	mov    %eax,%ebx
}
801014cf:	89 d8                	mov    %ebx,%eax
801014d1:	5b                   	pop    %ebx
801014d2:	5e                   	pop    %esi
801014d3:	5f                   	pop    %edi
801014d4:	5d                   	pop    %ebp
801014d5:	c3                   	ret    
801014d6:	8d 76 00             	lea    0x0(%esi),%esi
801014d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014e0:	e8 6b fd ff ff       	call   80101250 <balloc>
801014e5:	89 c2                	mov    %eax,%edx
801014e7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014ed:	8b 06                	mov    (%esi),%eax
801014ef:	e9 7c ff ff ff       	jmp    80101470 <bmap+0x40>
  panic("bmap: out of range");
801014f4:	83 ec 0c             	sub    $0xc,%esp
801014f7:	68 18 7b 10 80       	push   $0x80107b18
801014fc:	e8 8f ee ff ff       	call   80100390 <panic>
80101501:	eb 0d                	jmp    80101510 <readsb>
80101503:	90                   	nop
80101504:	90                   	nop
80101505:	90                   	nop
80101506:	90                   	nop
80101507:	90                   	nop
80101508:	90                   	nop
80101509:	90                   	nop
8010150a:	90                   	nop
8010150b:	90                   	nop
8010150c:	90                   	nop
8010150d:	90                   	nop
8010150e:	90                   	nop
8010150f:	90                   	nop

80101510 <readsb>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	56                   	push   %esi
80101514:	53                   	push   %ebx
80101515:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101518:	83 ec 08             	sub    $0x8,%esp
8010151b:	6a 01                	push   $0x1
8010151d:	ff 75 08             	pushl  0x8(%ebp)
80101520:	e8 ab eb ff ff       	call   801000d0 <bread>
80101525:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101527:	8d 40 5c             	lea    0x5c(%eax),%eax
8010152a:	83 c4 0c             	add    $0xc,%esp
8010152d:	6a 1c                	push   $0x1c
8010152f:	50                   	push   %eax
80101530:	56                   	push   %esi
80101531:	e8 5a 39 00 00       	call   80104e90 <memmove>
  brelse(bp);
80101536:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101539:	83 c4 10             	add    $0x10,%esp
}
8010153c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010153f:	5b                   	pop    %ebx
80101540:	5e                   	pop    %esi
80101541:	5d                   	pop    %ebp
  brelse(bp);
80101542:	e9 99 ec ff ff       	jmp    801001e0 <brelse>
80101547:	89 f6                	mov    %esi,%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101550 <iinit>:
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	53                   	push   %ebx
80101554:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101559:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010155c:	68 2b 7b 10 80       	push   $0x80107b2b
80101561:	68 e0 19 11 80       	push   $0x801119e0
80101566:	e8 25 36 00 00       	call   80104b90 <initlock>
8010156b:	83 c4 10             	add    $0x10,%esp
8010156e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101570:	83 ec 08             	sub    $0x8,%esp
80101573:	68 32 7b 10 80       	push   $0x80107b32
80101578:	53                   	push   %ebx
80101579:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010157f:	e8 dc 34 00 00       	call   80104a60 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101584:	83 c4 10             	add    $0x10,%esp
80101587:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
8010158d:	75 e1                	jne    80101570 <iinit+0x20>
  readsb(dev, &sb);
8010158f:	83 ec 08             	sub    $0x8,%esp
80101592:	68 c0 19 11 80       	push   $0x801119c0
80101597:	ff 75 08             	pushl  0x8(%ebp)
8010159a:	e8 71 ff ff ff       	call   80101510 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010159f:	ff 35 d8 19 11 80    	pushl  0x801119d8
801015a5:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015ab:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015b1:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015b7:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015bd:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015c3:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015c9:	68 dc 7b 10 80       	push   $0x80107bdc
801015ce:	e8 8d f0 ff ff       	call   80100660 <cprintf>
}
801015d3:	83 c4 30             	add    $0x30,%esp
801015d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015d9:	c9                   	leave  
801015da:	c3                   	ret    
801015db:	90                   	nop
801015dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015e0 <ialloc>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	57                   	push   %edi
801015e4:	56                   	push   %esi
801015e5:	53                   	push   %ebx
801015e6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015e9:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
801015f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015f3:	8b 75 08             	mov    0x8(%ebp),%esi
801015f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015f9:	0f 86 91 00 00 00    	jbe    80101690 <ialloc+0xb0>
801015ff:	bb 01 00 00 00       	mov    $0x1,%ebx
80101604:	eb 21                	jmp    80101627 <ialloc+0x47>
80101606:	8d 76 00             	lea    0x0(%esi),%esi
80101609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101616:	57                   	push   %edi
80101617:	e8 c4 eb ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101625:	76 69                	jbe    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 d8                	mov    %ebx,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
8010163c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010163e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101640:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 7d 37 00 00       	call   80104de0 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 3c 24             	mov    %edi,(%esp)
80101670:	e8 ab 1b 00 00       	call   80103220 <log_write>
      brelse(bp);
80101675:	89 3c 24             	mov    %edi,(%esp)
80101678:	e8 63 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 da                	mov    %ebx,%edx
80101685:	89 f0                	mov    %esi,%eax
}
80101687:	5b                   	pop    %ebx
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 d0 fc ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 38 7b 10 80       	push   $0x80107b38
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	56                   	push   %esi
801016a4:	53                   	push   %ebx
801016a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016a8:	83 ec 08             	sub    $0x8,%esp
801016ab:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ae:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b1:	c1 e8 03             	shr    $0x3,%eax
801016b4:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016ba:	50                   	push   %eax
801016bb:	ff 73 a4             	pushl  -0x5c(%ebx)
801016be:	e8 0d ea ff ff       	call   801000d0 <bread>
801016c3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016c5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801016c8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016cf:	83 e0 07             	and    $0x7,%eax
801016d2:	c1 e0 06             	shl    $0x6,%eax
801016d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016d9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016dc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016e7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016eb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016ef:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016f7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fd:	6a 34                	push   $0x34
801016ff:	53                   	push   %ebx
80101700:	50                   	push   %eax
80101701:	e8 8a 37 00 00       	call   80104e90 <memmove>
  log_write(bp);
80101706:	89 34 24             	mov    %esi,(%esp)
80101709:	e8 12 1b 00 00       	call   80103220 <log_write>
  brelse(bp);
8010170e:	89 75 08             	mov    %esi,0x8(%ebp)
80101711:	83 c4 10             	add    $0x10,%esp
}
80101714:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101717:	5b                   	pop    %ebx
80101718:	5e                   	pop    %esi
80101719:	5d                   	pop    %ebp
  brelse(bp);
8010171a:	e9 c1 ea ff ff       	jmp    801001e0 <brelse>
8010171f:	90                   	nop

80101720 <idup>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	53                   	push   %ebx
80101724:	83 ec 10             	sub    $0x10,%esp
80101727:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010172a:	68 e0 19 11 80       	push   $0x801119e0
8010172f:	e8 9c 35 00 00       	call   80104cd0 <acquire>
  ip->ref++;
80101734:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101738:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010173f:	e8 4c 36 00 00       	call   80104d90 <release>
}
80101744:	89 d8                	mov    %ebx,%eax
80101746:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101749:	c9                   	leave  
8010174a:	c3                   	ret    
8010174b:	90                   	nop
8010174c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101750 <ilock>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101758:	85 db                	test   %ebx,%ebx
8010175a:	0f 84 b7 00 00 00    	je     80101817 <ilock+0xc7>
80101760:	8b 53 08             	mov    0x8(%ebx),%edx
80101763:	85 d2                	test   %edx,%edx
80101765:	0f 8e ac 00 00 00    	jle    80101817 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010176b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010176e:	83 ec 0c             	sub    $0xc,%esp
80101771:	50                   	push   %eax
80101772:	e8 29 33 00 00       	call   80104aa0 <acquiresleep>
  if(ip->valid == 0){
80101777:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010177a:	83 c4 10             	add    $0x10,%esp
8010177d:	85 c0                	test   %eax,%eax
8010177f:	74 0f                	je     80101790 <ilock+0x40>
}
80101781:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101784:	5b                   	pop    %ebx
80101785:	5e                   	pop    %esi
80101786:	5d                   	pop    %ebp
80101787:	c3                   	ret    
80101788:	90                   	nop
80101789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101790:	8b 43 04             	mov    0x4(%ebx),%eax
80101793:	83 ec 08             	sub    $0x8,%esp
80101796:	c1 e8 03             	shr    $0x3,%eax
80101799:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010179f:	50                   	push   %eax
801017a0:	ff 33                	pushl  (%ebx)
801017a2:	e8 29 e9 ff ff       	call   801000d0 <bread>
801017a7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017a9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ac:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017af:	83 e0 07             	and    $0x7,%eax
801017b2:	c1 e0 06             	shl    $0x6,%eax
801017b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017b9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017bc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017bf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017c3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017c7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017cb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017cf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017d3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017d7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017db:	8b 50 fc             	mov    -0x4(%eax),%edx
801017de:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017e1:	6a 34                	push   $0x34
801017e3:	50                   	push   %eax
801017e4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017e7:	50                   	push   %eax
801017e8:	e8 a3 36 00 00       	call   80104e90 <memmove>
    brelse(bp);
801017ed:	89 34 24             	mov    %esi,(%esp)
801017f0:	e8 eb e9 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801017f5:	83 c4 10             	add    $0x10,%esp
801017f8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017fd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101804:	0f 85 77 ff ff ff    	jne    80101781 <ilock+0x31>
      panic("ilock: no type");
8010180a:	83 ec 0c             	sub    $0xc,%esp
8010180d:	68 50 7b 10 80       	push   $0x80107b50
80101812:	e8 79 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101817:	83 ec 0c             	sub    $0xc,%esp
8010181a:	68 4a 7b 10 80       	push   $0x80107b4a
8010181f:	e8 6c eb ff ff       	call   80100390 <panic>
80101824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010182a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101830 <iunlock>:
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	56                   	push   %esi
80101834:	53                   	push   %ebx
80101835:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101838:	85 db                	test   %ebx,%ebx
8010183a:	74 28                	je     80101864 <iunlock+0x34>
8010183c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010183f:	83 ec 0c             	sub    $0xc,%esp
80101842:	56                   	push   %esi
80101843:	e8 f8 32 00 00       	call   80104b40 <holdingsleep>
80101848:	83 c4 10             	add    $0x10,%esp
8010184b:	85 c0                	test   %eax,%eax
8010184d:	74 15                	je     80101864 <iunlock+0x34>
8010184f:	8b 43 08             	mov    0x8(%ebx),%eax
80101852:	85 c0                	test   %eax,%eax
80101854:	7e 0e                	jle    80101864 <iunlock+0x34>
  releasesleep(&ip->lock);
80101856:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101859:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010185c:	5b                   	pop    %ebx
8010185d:	5e                   	pop    %esi
8010185e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010185f:	e9 9c 32 00 00       	jmp    80104b00 <releasesleep>
    panic("iunlock");
80101864:	83 ec 0c             	sub    $0xc,%esp
80101867:	68 5f 7b 10 80       	push   $0x80107b5f
8010186c:	e8 1f eb ff ff       	call   80100390 <panic>
80101871:	eb 0d                	jmp    80101880 <iput>
80101873:	90                   	nop
80101874:	90                   	nop
80101875:	90                   	nop
80101876:	90                   	nop
80101877:	90                   	nop
80101878:	90                   	nop
80101879:	90                   	nop
8010187a:	90                   	nop
8010187b:	90                   	nop
8010187c:	90                   	nop
8010187d:	90                   	nop
8010187e:	90                   	nop
8010187f:	90                   	nop

80101880 <iput>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	57                   	push   %edi
80101884:	56                   	push   %esi
80101885:	53                   	push   %ebx
80101886:	83 ec 28             	sub    $0x28,%esp
80101889:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010188c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010188f:	57                   	push   %edi
80101890:	e8 0b 32 00 00       	call   80104aa0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101895:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 d2                	test   %edx,%edx
8010189d:	74 07                	je     801018a6 <iput+0x26>
8010189f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018a4:	74 32                	je     801018d8 <iput+0x58>
  releasesleep(&ip->lock);
801018a6:	83 ec 0c             	sub    $0xc,%esp
801018a9:	57                   	push   %edi
801018aa:	e8 51 32 00 00       	call   80104b00 <releasesleep>
  acquire(&icache.lock);
801018af:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018b6:	e8 15 34 00 00       	call   80104cd0 <acquire>
  ip->ref--;
801018bb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018bf:	83 c4 10             	add    $0x10,%esp
801018c2:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018cc:	5b                   	pop    %ebx
801018cd:	5e                   	pop    %esi
801018ce:	5f                   	pop    %edi
801018cf:	5d                   	pop    %ebp
  release(&icache.lock);
801018d0:	e9 bb 34 00 00       	jmp    80104d90 <release>
801018d5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018d8:	83 ec 0c             	sub    $0xc,%esp
801018db:	68 e0 19 11 80       	push   $0x801119e0
801018e0:	e8 eb 33 00 00       	call   80104cd0 <acquire>
    int r = ip->ref;
801018e5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018e8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018ef:	e8 9c 34 00 00       	call   80104d90 <release>
    if(r == 1){
801018f4:	83 c4 10             	add    $0x10,%esp
801018f7:	83 fe 01             	cmp    $0x1,%esi
801018fa:	75 aa                	jne    801018a6 <iput+0x26>
801018fc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101902:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101905:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101908:	89 cf                	mov    %ecx,%edi
8010190a:	eb 0b                	jmp    80101917 <iput+0x97>
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101910:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101913:	39 fe                	cmp    %edi,%esi
80101915:	74 19                	je     80101930 <iput+0xb0>
    if(ip->addrs[i]){
80101917:	8b 16                	mov    (%esi),%edx
80101919:	85 d2                	test   %edx,%edx
8010191b:	74 f3                	je     80101910 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010191d:	8b 03                	mov    (%ebx),%eax
8010191f:	e8 bc f8 ff ff       	call   801011e0 <bfree>
      ip->addrs[i] = 0;
80101924:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010192a:	eb e4                	jmp    80101910 <iput+0x90>
8010192c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101930:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101936:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101939:	85 c0                	test   %eax,%eax
8010193b:	75 33                	jne    80101970 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010193d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101940:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101947:	53                   	push   %ebx
80101948:	e8 53 fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
8010194d:	31 c0                	xor    %eax,%eax
8010194f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101953:	89 1c 24             	mov    %ebx,(%esp)
80101956:	e8 45 fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
8010195b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101962:	83 c4 10             	add    $0x10,%esp
80101965:	e9 3c ff ff ff       	jmp    801018a6 <iput+0x26>
8010196a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101970:	83 ec 08             	sub    $0x8,%esp
80101973:	50                   	push   %eax
80101974:	ff 33                	pushl  (%ebx)
80101976:	e8 55 e7 ff ff       	call   801000d0 <bread>
8010197b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101981:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101984:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101987:	8d 70 5c             	lea    0x5c(%eax),%esi
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	89 cf                	mov    %ecx,%edi
8010198f:	eb 0e                	jmp    8010199f <iput+0x11f>
80101991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101998:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010199b:	39 fe                	cmp    %edi,%esi
8010199d:	74 0f                	je     801019ae <iput+0x12e>
      if(a[j])
8010199f:	8b 16                	mov    (%esi),%edx
801019a1:	85 d2                	test   %edx,%edx
801019a3:	74 f3                	je     80101998 <iput+0x118>
        bfree(ip->dev, a[j]);
801019a5:	8b 03                	mov    (%ebx),%eax
801019a7:	e8 34 f8 ff ff       	call   801011e0 <bfree>
801019ac:	eb ea                	jmp    80101998 <iput+0x118>
    brelse(bp);
801019ae:	83 ec 0c             	sub    $0xc,%esp
801019b1:	ff 75 e4             	pushl  -0x1c(%ebp)
801019b4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019b7:	e8 24 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019bc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019c2:	8b 03                	mov    (%ebx),%eax
801019c4:	e8 17 f8 ff ff       	call   801011e0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019c9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019d0:	00 00 00 
801019d3:	83 c4 10             	add    $0x10,%esp
801019d6:	e9 62 ff ff ff       	jmp    8010193d <iput+0xbd>
801019db:	90                   	nop
801019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019e0 <iunlockput>:
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	53                   	push   %ebx
801019e4:	83 ec 10             	sub    $0x10,%esp
801019e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019ea:	53                   	push   %ebx
801019eb:	e8 40 fe ff ff       	call   80101830 <iunlock>
  iput(ip);
801019f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019f3:	83 c4 10             	add    $0x10,%esp
}
801019f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019f9:	c9                   	leave  
  iput(ip);
801019fa:	e9 81 fe ff ff       	jmp    80101880 <iput>
801019ff:	90                   	nop

80101a00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	8b 55 08             	mov    0x8(%ebp),%edx
80101a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a09:	8b 0a                	mov    (%edx),%ecx
80101a0b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a0e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a11:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a14:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a18:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a1b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a1f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a23:	8b 52 58             	mov    0x58(%edx),%edx
80101a26:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a29:	5d                   	pop    %ebp
80101a2a:	c3                   	ret    
80101a2b:	90                   	nop
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a30 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	57                   	push   %edi
80101a34:	56                   	push   %esi
80101a35:	53                   	push   %ebx
80101a36:	83 ec 1c             	sub    $0x1c,%esp
80101a39:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a42:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a47:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101a4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a4d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a50:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a53:	0f 84 a7 00 00 00    	je     80101b00 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a5c:	8b 40 58             	mov    0x58(%eax),%eax
80101a5f:	39 c6                	cmp    %eax,%esi
80101a61:	0f 87 ba 00 00 00    	ja     80101b21 <readi+0xf1>
80101a67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a6a:	89 f9                	mov    %edi,%ecx
80101a6c:	01 f1                	add    %esi,%ecx
80101a6e:	0f 82 ad 00 00 00    	jb     80101b21 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a74:	89 c2                	mov    %eax,%edx
80101a76:	29 f2                	sub    %esi,%edx
80101a78:	39 c8                	cmp    %ecx,%eax
80101a7a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a7d:	31 ff                	xor    %edi,%edi
80101a7f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101a81:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a84:	74 6c                	je     80101af2 <readi+0xc2>
80101a86:	8d 76 00             	lea    0x0(%esi),%esi
80101a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a90:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a93:	89 f2                	mov    %esi,%edx
80101a95:	c1 ea 09             	shr    $0x9,%edx
80101a98:	89 d8                	mov    %ebx,%eax
80101a9a:	e8 91 f9 ff ff       	call   80101430 <bmap>
80101a9f:	83 ec 08             	sub    $0x8,%esp
80101aa2:	50                   	push   %eax
80101aa3:	ff 33                	pushl  (%ebx)
80101aa5:	e8 26 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aaa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aad:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aaf:	89 f0                	mov    %esi,%eax
80101ab1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ab6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101abb:	83 c4 0c             	add    $0xc,%esp
80101abe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ac0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101ac4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac7:	29 fb                	sub    %edi,%ebx
80101ac9:	39 d9                	cmp    %ebx,%ecx
80101acb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ace:	53                   	push   %ebx
80101acf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ad0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101ad2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ad5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ad7:	e8 b4 33 00 00       	call   80104e90 <memmove>
    brelse(bp);
80101adc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101adf:	89 14 24             	mov    %edx,(%esp)
80101ae2:	e8 f9 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aea:	83 c4 10             	add    $0x10,%esp
80101aed:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101af0:	77 9e                	ja     80101a90 <readi+0x60>
  }
  return n;
80101af2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101af5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101af8:	5b                   	pop    %ebx
80101af9:	5e                   	pop    %esi
80101afa:	5f                   	pop    %edi
80101afb:	5d                   	pop    %ebp
80101afc:	c3                   	ret    
80101afd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b04:	66 83 f8 09          	cmp    $0x9,%ax
80101b08:	77 17                	ja     80101b21 <readi+0xf1>
80101b0a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b11:	85 c0                	test   %eax,%eax
80101b13:	74 0c                	je     80101b21 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b1b:	5b                   	pop    %ebx
80101b1c:	5e                   	pop    %esi
80101b1d:	5f                   	pop    %edi
80101b1e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b1f:	ff e0                	jmp    *%eax
      return -1;
80101b21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b26:	eb cd                	jmp    80101af5 <readi+0xc5>
80101b28:	90                   	nop
80101b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101b30 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	57                   	push   %edi
80101b34:	56                   	push   %esi
80101b35:	53                   	push   %ebx
80101b36:	83 ec 1c             	sub    $0x1c,%esp
80101b39:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b42:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b47:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b4d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b50:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b53:	0f 84 b7 00 00 00    	je     80101c10 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b5f:	0f 82 eb 00 00 00    	jb     80101c50 <writei+0x120>
80101b65:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b68:	31 d2                	xor    %edx,%edx
80101b6a:	89 f8                	mov    %edi,%eax
80101b6c:	01 f0                	add    %esi,%eax
80101b6e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b71:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b76:	0f 87 d4 00 00 00    	ja     80101c50 <writei+0x120>
80101b7c:	85 d2                	test   %edx,%edx
80101b7e:	0f 85 cc 00 00 00    	jne    80101c50 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b84:	85 ff                	test   %edi,%edi
80101b86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b8d:	74 72                	je     80101c01 <writei+0xd1>
80101b8f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b90:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b93:	89 f2                	mov    %esi,%edx
80101b95:	c1 ea 09             	shr    $0x9,%edx
80101b98:	89 f8                	mov    %edi,%eax
80101b9a:	e8 91 f8 ff ff       	call   80101430 <bmap>
80101b9f:	83 ec 08             	sub    $0x8,%esp
80101ba2:	50                   	push   %eax
80101ba3:	ff 37                	pushl  (%edi)
80101ba5:	e8 26 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101baa:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101bad:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bb0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bb2:	89 f0                	mov    %esi,%eax
80101bb4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bb9:	83 c4 0c             	add    $0xc,%esp
80101bbc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bc1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bc3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bc7:	39 d9                	cmp    %ebx,%ecx
80101bc9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bcc:	53                   	push   %ebx
80101bcd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bd0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bd2:	50                   	push   %eax
80101bd3:	e8 b8 32 00 00       	call   80104e90 <memmove>
    log_write(bp);
80101bd8:	89 3c 24             	mov    %edi,(%esp)
80101bdb:	e8 40 16 00 00       	call   80103220 <log_write>
    brelse(bp);
80101be0:	89 3c 24             	mov    %edi,(%esp)
80101be3:	e8 f8 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101beb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bee:	83 c4 10             	add    $0x10,%esp
80101bf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bf4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bf7:	77 97                	ja     80101b90 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bf9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bfc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bff:	77 37                	ja     80101c38 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c01:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c07:	5b                   	pop    %ebx
80101c08:	5e                   	pop    %esi
80101c09:	5f                   	pop    %edi
80101c0a:	5d                   	pop    %ebp
80101c0b:	c3                   	ret    
80101c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c14:	66 83 f8 09          	cmp    $0x9,%ax
80101c18:	77 36                	ja     80101c50 <writei+0x120>
80101c1a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c21:	85 c0                	test   %eax,%eax
80101c23:	74 2b                	je     80101c50 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101c25:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c2b:	5b                   	pop    %ebx
80101c2c:	5e                   	pop    %esi
80101c2d:	5f                   	pop    %edi
80101c2e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c2f:	ff e0                	jmp    *%eax
80101c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c38:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c3b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c3e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c41:	50                   	push   %eax
80101c42:	e8 59 fa ff ff       	call   801016a0 <iupdate>
80101c47:	83 c4 10             	add    $0x10,%esp
80101c4a:	eb b5                	jmp    80101c01 <writei+0xd1>
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c55:	eb ad                	jmp    80101c04 <writei+0xd4>
80101c57:	89 f6                	mov    %esi,%esi
80101c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c60 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c66:	6a 0e                	push   $0xe
80101c68:	ff 75 0c             	pushl  0xc(%ebp)
80101c6b:	ff 75 08             	pushl  0x8(%ebp)
80101c6e:	e8 8d 32 00 00       	call   80104f00 <strncmp>
}
80101c73:	c9                   	leave  
80101c74:	c3                   	ret    
80101c75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c80 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	56                   	push   %esi
80101c85:	53                   	push   %ebx
80101c86:	83 ec 1c             	sub    $0x1c,%esp
80101c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c8c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c91:	0f 85 85 00 00 00    	jne    80101d1c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c97:	8b 53 58             	mov    0x58(%ebx),%edx
80101c9a:	31 ff                	xor    %edi,%edi
80101c9c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c9f:	85 d2                	test   %edx,%edx
80101ca1:	74 3e                	je     80101ce1 <dirlookup+0x61>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ca8:	6a 10                	push   $0x10
80101caa:	57                   	push   %edi
80101cab:	56                   	push   %esi
80101cac:	53                   	push   %ebx
80101cad:	e8 7e fd ff ff       	call   80101a30 <readi>
80101cb2:	83 c4 10             	add    $0x10,%esp
80101cb5:	83 f8 10             	cmp    $0x10,%eax
80101cb8:	75 55                	jne    80101d0f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101cba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cbf:	74 18                	je     80101cd9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101cc1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cc4:	83 ec 04             	sub    $0x4,%esp
80101cc7:	6a 0e                	push   $0xe
80101cc9:	50                   	push   %eax
80101cca:	ff 75 0c             	pushl  0xc(%ebp)
80101ccd:	e8 2e 32 00 00       	call   80104f00 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101cd2:	83 c4 10             	add    $0x10,%esp
80101cd5:	85 c0                	test   %eax,%eax
80101cd7:	74 17                	je     80101cf0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101cd9:	83 c7 10             	add    $0x10,%edi
80101cdc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101cdf:	72 c7                	jb     80101ca8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101ce4:	31 c0                	xor    %eax,%eax
}
80101ce6:	5b                   	pop    %ebx
80101ce7:	5e                   	pop    %esi
80101ce8:	5f                   	pop    %edi
80101ce9:	5d                   	pop    %ebp
80101cea:	c3                   	ret    
80101ceb:	90                   	nop
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101cf0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cf3:	85 c0                	test   %eax,%eax
80101cf5:	74 05                	je     80101cfc <dirlookup+0x7c>
        *poff = off;
80101cf7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cfa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cfc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d00:	8b 03                	mov    (%ebx),%eax
80101d02:	e8 59 f6 ff ff       	call   80101360 <iget>
}
80101d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0a:	5b                   	pop    %ebx
80101d0b:	5e                   	pop    %esi
80101d0c:	5f                   	pop    %edi
80101d0d:	5d                   	pop    %ebp
80101d0e:	c3                   	ret    
      panic("dirlookup read");
80101d0f:	83 ec 0c             	sub    $0xc,%esp
80101d12:	68 79 7b 10 80       	push   $0x80107b79
80101d17:	e8 74 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d1c:	83 ec 0c             	sub    $0xc,%esp
80101d1f:	68 67 7b 10 80       	push   $0x80107b67
80101d24:	e8 67 e6 ff ff       	call   80100390 <panic>
80101d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d30 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	57                   	push   %edi
80101d34:	56                   	push   %esi
80101d35:	53                   	push   %ebx
80101d36:	89 cf                	mov    %ecx,%edi
80101d38:	89 c3                	mov    %eax,%ebx
80101d3a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d3d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d40:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101d43:	0f 84 67 01 00 00    	je     80101eb0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d49:	e8 92 20 00 00       	call   80103de0 <myproc>
  acquire(&icache.lock);
80101d4e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101d51:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d54:	68 e0 19 11 80       	push   $0x801119e0
80101d59:	e8 72 2f 00 00       	call   80104cd0 <acquire>
  ip->ref++;
80101d5e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d62:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101d69:	e8 22 30 00 00       	call   80104d90 <release>
80101d6e:	83 c4 10             	add    $0x10,%esp
80101d71:	eb 08                	jmp    80101d7b <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101d78:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d7b:	0f b6 03             	movzbl (%ebx),%eax
80101d7e:	3c 2f                	cmp    $0x2f,%al
80101d80:	74 f6                	je     80101d78 <namex+0x48>
  if(*path == 0)
80101d82:	84 c0                	test   %al,%al
80101d84:	0f 84 ee 00 00 00    	je     80101e78 <namex+0x148>
  while(*path != '/' && *path != 0)
80101d8a:	0f b6 03             	movzbl (%ebx),%eax
80101d8d:	3c 2f                	cmp    $0x2f,%al
80101d8f:	0f 84 b3 00 00 00    	je     80101e48 <namex+0x118>
80101d95:	84 c0                	test   %al,%al
80101d97:	89 da                	mov    %ebx,%edx
80101d99:	75 09                	jne    80101da4 <namex+0x74>
80101d9b:	e9 a8 00 00 00       	jmp    80101e48 <namex+0x118>
80101da0:	84 c0                	test   %al,%al
80101da2:	74 0a                	je     80101dae <namex+0x7e>
    path++;
80101da4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101da7:	0f b6 02             	movzbl (%edx),%eax
80101daa:	3c 2f                	cmp    $0x2f,%al
80101dac:	75 f2                	jne    80101da0 <namex+0x70>
80101dae:	89 d1                	mov    %edx,%ecx
80101db0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101db2:	83 f9 0d             	cmp    $0xd,%ecx
80101db5:	0f 8e 91 00 00 00    	jle    80101e4c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101dbb:	83 ec 04             	sub    $0x4,%esp
80101dbe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101dc1:	6a 0e                	push   $0xe
80101dc3:	53                   	push   %ebx
80101dc4:	57                   	push   %edi
80101dc5:	e8 c6 30 00 00       	call   80104e90 <memmove>
    path++;
80101dca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101dcd:	83 c4 10             	add    $0x10,%esp
    path++;
80101dd0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101dd2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101dd5:	75 11                	jne    80101de8 <namex+0xb8>
80101dd7:	89 f6                	mov    %esi,%esi
80101dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101de0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101de3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101de6:	74 f8                	je     80101de0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	56                   	push   %esi
80101dec:	e8 5f f9 ff ff       	call   80101750 <ilock>
    if(ip->type != T_DIR){
80101df1:	83 c4 10             	add    $0x10,%esp
80101df4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101df9:	0f 85 91 00 00 00    	jne    80101e90 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dff:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e02:	85 d2                	test   %edx,%edx
80101e04:	74 09                	je     80101e0f <namex+0xdf>
80101e06:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e09:	0f 84 b7 00 00 00    	je     80101ec6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e0f:	83 ec 04             	sub    $0x4,%esp
80101e12:	6a 00                	push   $0x0
80101e14:	57                   	push   %edi
80101e15:	56                   	push   %esi
80101e16:	e8 65 fe ff ff       	call   80101c80 <dirlookup>
80101e1b:	83 c4 10             	add    $0x10,%esp
80101e1e:	85 c0                	test   %eax,%eax
80101e20:	74 6e                	je     80101e90 <namex+0x160>
  iunlock(ip);
80101e22:	83 ec 0c             	sub    $0xc,%esp
80101e25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e28:	56                   	push   %esi
80101e29:	e8 02 fa ff ff       	call   80101830 <iunlock>
  iput(ip);
80101e2e:	89 34 24             	mov    %esi,(%esp)
80101e31:	e8 4a fa ff ff       	call   80101880 <iput>
80101e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	89 c6                	mov    %eax,%esi
80101e3e:	e9 38 ff ff ff       	jmp    80101d7b <namex+0x4b>
80101e43:	90                   	nop
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101e48:	89 da                	mov    %ebx,%edx
80101e4a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101e4c:	83 ec 04             	sub    $0x4,%esp
80101e4f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e52:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e55:	51                   	push   %ecx
80101e56:	53                   	push   %ebx
80101e57:	57                   	push   %edi
80101e58:	e8 33 30 00 00       	call   80104e90 <memmove>
    name[len] = 0;
80101e5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e60:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e63:	83 c4 10             	add    $0x10,%esp
80101e66:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e6a:	89 d3                	mov    %edx,%ebx
80101e6c:	e9 61 ff ff ff       	jmp    80101dd2 <namex+0xa2>
80101e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e7b:	85 c0                	test   %eax,%eax
80101e7d:	75 5d                	jne    80101edc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e82:	89 f0                	mov    %esi,%eax
80101e84:	5b                   	pop    %ebx
80101e85:	5e                   	pop    %esi
80101e86:	5f                   	pop    %edi
80101e87:	5d                   	pop    %ebp
80101e88:	c3                   	ret    
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e90:	83 ec 0c             	sub    $0xc,%esp
80101e93:	56                   	push   %esi
80101e94:	e8 97 f9 ff ff       	call   80101830 <iunlock>
  iput(ip);
80101e99:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e9c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e9e:	e8 dd f9 ff ff       	call   80101880 <iput>
      return 0;
80101ea3:	83 c4 10             	add    $0x10,%esp
}
80101ea6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea9:	89 f0                	mov    %esi,%eax
80101eab:	5b                   	pop    %ebx
80101eac:	5e                   	pop    %esi
80101ead:	5f                   	pop    %edi
80101eae:	5d                   	pop    %ebp
80101eaf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101eb0:	ba 01 00 00 00       	mov    $0x1,%edx
80101eb5:	b8 01 00 00 00       	mov    $0x1,%eax
80101eba:	e8 a1 f4 ff ff       	call   80101360 <iget>
80101ebf:	89 c6                	mov    %eax,%esi
80101ec1:	e9 b5 fe ff ff       	jmp    80101d7b <namex+0x4b>
      iunlock(ip);
80101ec6:	83 ec 0c             	sub    $0xc,%esp
80101ec9:	56                   	push   %esi
80101eca:	e8 61 f9 ff ff       	call   80101830 <iunlock>
      return ip;
80101ecf:	83 c4 10             	add    $0x10,%esp
}
80101ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ed5:	89 f0                	mov    %esi,%eax
80101ed7:	5b                   	pop    %ebx
80101ed8:	5e                   	pop    %esi
80101ed9:	5f                   	pop    %edi
80101eda:	5d                   	pop    %ebp
80101edb:	c3                   	ret    
    iput(ip);
80101edc:	83 ec 0c             	sub    $0xc,%esp
80101edf:	56                   	push   %esi
    return 0;
80101ee0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ee2:	e8 99 f9 ff ff       	call   80101880 <iput>
    return 0;
80101ee7:	83 c4 10             	add    $0x10,%esp
80101eea:	eb 93                	jmp    80101e7f <namex+0x14f>
80101eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ef0 <dirlink>:
{
80101ef0:	55                   	push   %ebp
80101ef1:	89 e5                	mov    %esp,%ebp
80101ef3:	57                   	push   %edi
80101ef4:	56                   	push   %esi
80101ef5:	53                   	push   %ebx
80101ef6:	83 ec 20             	sub    $0x20,%esp
80101ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101efc:	6a 00                	push   $0x0
80101efe:	ff 75 0c             	pushl  0xc(%ebp)
80101f01:	53                   	push   %ebx
80101f02:	e8 79 fd ff ff       	call   80101c80 <dirlookup>
80101f07:	83 c4 10             	add    $0x10,%esp
80101f0a:	85 c0                	test   %eax,%eax
80101f0c:	75 67                	jne    80101f75 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f0e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f11:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f14:	85 ff                	test   %edi,%edi
80101f16:	74 29                	je     80101f41 <dirlink+0x51>
80101f18:	31 ff                	xor    %edi,%edi
80101f1a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f1d:	eb 09                	jmp    80101f28 <dirlink+0x38>
80101f1f:	90                   	nop
80101f20:	83 c7 10             	add    $0x10,%edi
80101f23:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f26:	73 19                	jae    80101f41 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f28:	6a 10                	push   $0x10
80101f2a:	57                   	push   %edi
80101f2b:	56                   	push   %esi
80101f2c:	53                   	push   %ebx
80101f2d:	e8 fe fa ff ff       	call   80101a30 <readi>
80101f32:	83 c4 10             	add    $0x10,%esp
80101f35:	83 f8 10             	cmp    $0x10,%eax
80101f38:	75 4e                	jne    80101f88 <dirlink+0x98>
    if(de.inum == 0)
80101f3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f3f:	75 df                	jne    80101f20 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f41:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f44:	83 ec 04             	sub    $0x4,%esp
80101f47:	6a 0e                	push   $0xe
80101f49:	ff 75 0c             	pushl  0xc(%ebp)
80101f4c:	50                   	push   %eax
80101f4d:	e8 0e 30 00 00       	call   80104f60 <strncpy>
  de.inum = inum;
80101f52:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f55:	6a 10                	push   $0x10
80101f57:	57                   	push   %edi
80101f58:	56                   	push   %esi
80101f59:	53                   	push   %ebx
  de.inum = inum;
80101f5a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f5e:	e8 cd fb ff ff       	call   80101b30 <writei>
80101f63:	83 c4 20             	add    $0x20,%esp
80101f66:	83 f8 10             	cmp    $0x10,%eax
80101f69:	75 2a                	jne    80101f95 <dirlink+0xa5>
  return 0;
80101f6b:	31 c0                	xor    %eax,%eax
}
80101f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f70:	5b                   	pop    %ebx
80101f71:	5e                   	pop    %esi
80101f72:	5f                   	pop    %edi
80101f73:	5d                   	pop    %ebp
80101f74:	c3                   	ret    
    iput(ip);
80101f75:	83 ec 0c             	sub    $0xc,%esp
80101f78:	50                   	push   %eax
80101f79:	e8 02 f9 ff ff       	call   80101880 <iput>
    return -1;
80101f7e:	83 c4 10             	add    $0x10,%esp
80101f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f86:	eb e5                	jmp    80101f6d <dirlink+0x7d>
      panic("dirlink read");
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	68 88 7b 10 80       	push   $0x80107b88
80101f90:	e8 fb e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f95:	83 ec 0c             	sub    $0xc,%esp
80101f98:	68 f5 82 10 80       	push   $0x801082f5
80101f9d:	e8 ee e3 ff ff       	call   80100390 <panic>
80101fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fb0 <namei>:

struct inode*
namei(char *path)
{
80101fb0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fb1:	31 d2                	xor    %edx,%edx
{
80101fb3:	89 e5                	mov    %esp,%ebp
80101fb5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fbe:	e8 6d fd ff ff       	call   80101d30 <namex>
}
80101fc3:	c9                   	leave  
80101fc4:	c3                   	ret    
80101fc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fd0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fd0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fd1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fd6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fdb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fde:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fdf:	e9 4c fd ff ff       	jmp    80101d30 <namex>
80101fe4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101ff0 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101ff0:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101ff1:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80101ff6:	89 e5                	mov    %esp,%ebp
80101ff8:	57                   	push   %edi
80101ff9:	56                   	push   %esi
80101ffa:	53                   	push   %ebx
80101ffb:	83 ec 10             	sub    $0x10,%esp
80101ffe:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80102001:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80102008:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
8010200f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80102013:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80102017:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
8010201a:	85 c9                	test   %ecx,%ecx
8010201c:	79 0a                	jns    80102028 <itoa+0x38>
8010201e:	89 f0                	mov    %esi,%eax
80102020:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80102023:	f7 d9                	neg    %ecx
        *p++ = '-';
80102025:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80102028:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010202a:	bf 67 66 66 66       	mov    $0x66666667,%edi
8010202f:	90                   	nop
80102030:	89 d8                	mov    %ebx,%eax
80102032:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80102035:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80102038:	f7 ef                	imul   %edi
8010203a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
8010203d:	29 da                	sub    %ebx,%edx
8010203f:	89 d3                	mov    %edx,%ebx
80102041:	75 ed                	jne    80102030 <itoa+0x40>
    *p = '\0';
80102043:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102046:	bb 67 66 66 66       	mov    $0x66666667,%ebx
8010204b:	90                   	nop
8010204c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102050:	89 c8                	mov    %ecx,%eax
80102052:	83 ee 01             	sub    $0x1,%esi
80102055:	f7 eb                	imul   %ebx
80102057:	89 c8                	mov    %ecx,%eax
80102059:	c1 f8 1f             	sar    $0x1f,%eax
8010205c:	c1 fa 02             	sar    $0x2,%edx
8010205f:	29 c2                	sub    %eax,%edx
80102061:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102064:	01 c0                	add    %eax,%eax
80102066:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80102068:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
8010206a:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
8010206f:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102071:	88 06                	mov    %al,(%esi)
    }while(i);
80102073:	75 db                	jne    80102050 <itoa+0x60>
    return b;
}
80102075:	8b 45 0c             	mov    0xc(%ebp),%eax
80102078:	83 c4 10             	add    $0x10,%esp
8010207b:	5b                   	pop    %ebx
8010207c:	5e                   	pop    %esi
8010207d:	5f                   	pop    %edi
8010207e:	5d                   	pop    %ebp
8010207f:	c3                   	ret    

80102080 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102086:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80102089:	83 ec 40             	sub    $0x40,%esp
8010208c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010208f:	6a 06                	push   $0x6
80102091:	68 95 7b 10 80       	push   $0x80107b95
80102096:	56                   	push   %esi
80102097:	e8 f4 2d 00 00       	call   80104e90 <memmove>
  itoa(p->pid, path+ 6);
8010209c:	58                   	pop    %eax
8010209d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
801020a0:	5a                   	pop    %edx
801020a1:	50                   	push   %eax
801020a2:	ff 73 10             	pushl  0x10(%ebx)
801020a5:	e8 46 ff ff ff       	call   80101ff0 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
801020aa:	8b 43 7c             	mov    0x7c(%ebx),%eax
801020ad:	83 c4 10             	add    $0x10,%esp
801020b0:	85 c0                	test   %eax,%eax
801020b2:	0f 84 88 01 00 00    	je     80102240 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
801020b8:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
801020bb:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
801020be:	50                   	push   %eax
801020bf:	e8 4c ee ff ff       	call   80100f10 <fileclose>

  begin_op();
801020c4:	e8 87 0f 00 00       	call   80103050 <begin_op>
  return namex(path, 1, name);
801020c9:	89 f0                	mov    %esi,%eax
801020cb:	89 d9                	mov    %ebx,%ecx
801020cd:	ba 01 00 00 00       	mov    $0x1,%edx
801020d2:	e8 59 fc ff ff       	call   80101d30 <namex>
  if((dp = nameiparent(path, name)) == 0)
801020d7:	83 c4 10             	add    $0x10,%esp
801020da:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
801020dc:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801020de:	0f 84 66 01 00 00    	je     8010224a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801020e4:	83 ec 0c             	sub    $0xc,%esp
801020e7:	50                   	push   %eax
801020e8:	e8 63 f6 ff ff       	call   80101750 <ilock>
  return strncmp(s, t, DIRSIZ);
801020ed:	83 c4 0c             	add    $0xc,%esp
801020f0:	6a 0e                	push   $0xe
801020f2:	68 9d 7b 10 80       	push   $0x80107b9d
801020f7:	53                   	push   %ebx
801020f8:	e8 03 2e 00 00       	call   80104f00 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801020fd:	83 c4 10             	add    $0x10,%esp
80102100:	85 c0                	test   %eax,%eax
80102102:	0f 84 f8 00 00 00    	je     80102200 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102108:	83 ec 04             	sub    $0x4,%esp
8010210b:	6a 0e                	push   $0xe
8010210d:	68 9c 7b 10 80       	push   $0x80107b9c
80102112:	53                   	push   %ebx
80102113:	e8 e8 2d 00 00       	call   80104f00 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102118:	83 c4 10             	add    $0x10,%esp
8010211b:	85 c0                	test   %eax,%eax
8010211d:	0f 84 dd 00 00 00    	je     80102200 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102123:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102126:	83 ec 04             	sub    $0x4,%esp
80102129:	50                   	push   %eax
8010212a:	53                   	push   %ebx
8010212b:	56                   	push   %esi
8010212c:	e8 4f fb ff ff       	call   80101c80 <dirlookup>
80102131:	83 c4 10             	add    $0x10,%esp
80102134:	85 c0                	test   %eax,%eax
80102136:	89 c3                	mov    %eax,%ebx
80102138:	0f 84 c2 00 00 00    	je     80102200 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010213e:	83 ec 0c             	sub    $0xc,%esp
80102141:	50                   	push   %eax
80102142:	e8 09 f6 ff ff       	call   80101750 <ilock>

  if(ip->nlink < 1)
80102147:	83 c4 10             	add    $0x10,%esp
8010214a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010214f:	0f 8e 11 01 00 00    	jle    80102266 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102155:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010215a:	74 74                	je     801021d0 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010215c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010215f:	83 ec 04             	sub    $0x4,%esp
80102162:	6a 10                	push   $0x10
80102164:	6a 00                	push   $0x0
80102166:	57                   	push   %edi
80102167:	e8 74 2c 00 00       	call   80104de0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010216c:	6a 10                	push   $0x10
8010216e:	ff 75 b8             	pushl  -0x48(%ebp)
80102171:	57                   	push   %edi
80102172:	56                   	push   %esi
80102173:	e8 b8 f9 ff ff       	call   80101b30 <writei>
80102178:	83 c4 20             	add    $0x20,%esp
8010217b:	83 f8 10             	cmp    $0x10,%eax
8010217e:	0f 85 d5 00 00 00    	jne    80102259 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102184:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102189:	0f 84 91 00 00 00    	je     80102220 <removeSwapFile+0x1a0>
  iunlock(ip);
8010218f:	83 ec 0c             	sub    $0xc,%esp
80102192:	56                   	push   %esi
80102193:	e8 98 f6 ff ff       	call   80101830 <iunlock>
  iput(ip);
80102198:	89 34 24             	mov    %esi,(%esp)
8010219b:	e8 e0 f6 ff ff       	call   80101880 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801021a0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801021a5:	89 1c 24             	mov    %ebx,(%esp)
801021a8:	e8 f3 f4 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801021ad:	89 1c 24             	mov    %ebx,(%esp)
801021b0:	e8 7b f6 ff ff       	call   80101830 <iunlock>
  iput(ip);
801021b5:	89 1c 24             	mov    %ebx,(%esp)
801021b8:	e8 c3 f6 ff ff       	call   80101880 <iput>
  iunlockput(ip);

  end_op();
801021bd:	e8 fe 0e 00 00       	call   801030c0 <end_op>

  return 0;
801021c2:	83 c4 10             	add    $0x10,%esp
801021c5:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801021c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021ca:	5b                   	pop    %ebx
801021cb:	5e                   	pop    %esi
801021cc:	5f                   	pop    %edi
801021cd:	5d                   	pop    %ebp
801021ce:	c3                   	ret    
801021cf:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
801021d0:	83 ec 0c             	sub    $0xc,%esp
801021d3:	53                   	push   %ebx
801021d4:	e8 e7 33 00 00       	call   801055c0 <isdirempty>
801021d9:	83 c4 10             	add    $0x10,%esp
801021dc:	85 c0                	test   %eax,%eax
801021de:	0f 85 78 ff ff ff    	jne    8010215c <removeSwapFile+0xdc>
  iunlock(ip);
801021e4:	83 ec 0c             	sub    $0xc,%esp
801021e7:	53                   	push   %ebx
801021e8:	e8 43 f6 ff ff       	call   80101830 <iunlock>
  iput(ip);
801021ed:	89 1c 24             	mov    %ebx,(%esp)
801021f0:	e8 8b f6 ff ff       	call   80101880 <iput>
801021f5:	83 c4 10             	add    $0x10,%esp
801021f8:	90                   	nop
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102200:	83 ec 0c             	sub    $0xc,%esp
80102203:	56                   	push   %esi
80102204:	e8 27 f6 ff ff       	call   80101830 <iunlock>
  iput(ip);
80102209:	89 34 24             	mov    %esi,(%esp)
8010220c:	e8 6f f6 ff ff       	call   80101880 <iput>
    end_op();
80102211:	e8 aa 0e 00 00       	call   801030c0 <end_op>
    return -1;
80102216:	83 c4 10             	add    $0x10,%esp
80102219:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010221e:	eb a7                	jmp    801021c7 <removeSwapFile+0x147>
    dp->nlink--;
80102220:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102225:	83 ec 0c             	sub    $0xc,%esp
80102228:	56                   	push   %esi
80102229:	e8 72 f4 ff ff       	call   801016a0 <iupdate>
8010222e:	83 c4 10             	add    $0x10,%esp
80102231:	e9 59 ff ff ff       	jmp    8010218f <removeSwapFile+0x10f>
80102236:	8d 76 00             	lea    0x0(%esi),%esi
80102239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102245:	e9 7d ff ff ff       	jmp    801021c7 <removeSwapFile+0x147>
    end_op();
8010224a:	e8 71 0e 00 00       	call   801030c0 <end_op>
    return -1;
8010224f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102254:	e9 6e ff ff ff       	jmp    801021c7 <removeSwapFile+0x147>
    panic("unlink: writei");
80102259:	83 ec 0c             	sub    $0xc,%esp
8010225c:	68 b1 7b 10 80       	push   $0x80107bb1
80102261:	e8 2a e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102266:	83 ec 0c             	sub    $0xc,%esp
80102269:	68 9f 7b 10 80       	push   $0x80107b9f
8010226e:	e8 1d e1 ff ff       	call   80100390 <panic>
80102273:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102280 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102280:	55                   	push   %ebp
80102281:	89 e5                	mov    %esp,%ebp
80102283:	56                   	push   %esi
80102284:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102285:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
80102288:	83 ec 14             	sub    $0x14,%esp
8010228b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010228e:	6a 06                	push   $0x6
80102290:	68 95 7b 10 80       	push   $0x80107b95
80102295:	56                   	push   %esi
80102296:	e8 f5 2b 00 00       	call   80104e90 <memmove>
  itoa(p->pid, path+ 6);
8010229b:	58                   	pop    %eax
8010229c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010229f:	5a                   	pop    %edx
801022a0:	50                   	push   %eax
801022a1:	ff 73 10             	pushl  0x10(%ebx)
801022a4:	e8 47 fd ff ff       	call   80101ff0 <itoa>

    begin_op();
801022a9:	e8 a2 0d 00 00       	call   80103050 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
801022ae:	6a 00                	push   $0x0
801022b0:	6a 00                	push   $0x0
801022b2:	6a 02                	push   $0x2
801022b4:	56                   	push   %esi
801022b5:	e8 16 35 00 00       	call   801057d0 <create>
  iunlock(in);
801022ba:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
801022bd:	89 c6                	mov    %eax,%esi
  iunlock(in);
801022bf:	50                   	push   %eax
801022c0:	e8 6b f5 ff ff       	call   80101830 <iunlock>

  p->swapFile = filealloc();
801022c5:	e8 86 eb ff ff       	call   80100e50 <filealloc>
  if (p->swapFile == 0)
801022ca:	83 c4 10             	add    $0x10,%esp
801022cd:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
801022cf:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801022d2:	74 32                	je     80102306 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801022d4:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801022d7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022da:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
801022e0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022e3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
801022ea:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022ed:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801022f1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022f4:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801022f8:	e8 c3 0d 00 00       	call   801030c0 <end_op>

    return 0;
}
801022fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102300:	31 c0                	xor    %eax,%eax
80102302:	5b                   	pop    %ebx
80102303:	5e                   	pop    %esi
80102304:	5d                   	pop    %ebp
80102305:	c3                   	ret    
    panic("no slot for files on /store");
80102306:	83 ec 0c             	sub    $0xc,%esp
80102309:	68 c0 7b 10 80       	push   $0x80107bc0
8010230e:	e8 7d e0 ff ff       	call   80100390 <panic>
80102313:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102320 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102326:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102329:	8b 50 7c             	mov    0x7c(%eax),%edx
8010232c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010232f:	8b 55 14             	mov    0x14(%ebp),%edx
80102332:	89 55 10             	mov    %edx,0x10(%ebp)
80102335:	8b 40 7c             	mov    0x7c(%eax),%eax
80102338:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010233b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010233c:	e9 7f ed ff ff       	jmp    801010c0 <filewrite>
80102341:	eb 0d                	jmp    80102350 <readFromSwapFile>
80102343:	90                   	nop
80102344:	90                   	nop
80102345:	90                   	nop
80102346:	90                   	nop
80102347:	90                   	nop
80102348:	90                   	nop
80102349:	90                   	nop
8010234a:	90                   	nop
8010234b:	90                   	nop
8010234c:	90                   	nop
8010234d:	90                   	nop
8010234e:	90                   	nop
8010234f:	90                   	nop

80102350 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102356:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102359:	8b 50 7c             	mov    0x7c(%eax),%edx
8010235c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010235f:	8b 55 14             	mov    0x14(%ebp),%edx
80102362:	89 55 10             	mov    %edx,0x10(%ebp)
80102365:	8b 40 7c             	mov    0x7c(%eax),%eax
80102368:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010236b:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
8010236c:	e9 bf ec ff ff       	jmp    80101030 <fileread>
80102371:	66 90                	xchg   %ax,%ax
80102373:	66 90                	xchg   %ax,%ax
80102375:	66 90                	xchg   %ax,%ax
80102377:	66 90                	xchg   %ax,%ax
80102379:	66 90                	xchg   %ax,%ax
8010237b:	66 90                	xchg   %ax,%ax
8010237d:	66 90                	xchg   %ax,%ax
8010237f:	90                   	nop

80102380 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	57                   	push   %edi
80102384:	56                   	push   %esi
80102385:	53                   	push   %ebx
80102386:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102389:	85 c0                	test   %eax,%eax
8010238b:	0f 84 b4 00 00 00    	je     80102445 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102391:	8b 58 08             	mov    0x8(%eax),%ebx
80102394:	89 c6                	mov    %eax,%esi
80102396:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010239c:	0f 87 96 00 00 00    	ja     80102438 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801023a7:	89 f6                	mov    %esi,%esi
801023a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801023b0:	89 ca                	mov    %ecx,%edx
801023b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023b3:	83 e0 c0             	and    $0xffffffc0,%eax
801023b6:	3c 40                	cmp    $0x40,%al
801023b8:	75 f6                	jne    801023b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023ba:	31 ff                	xor    %edi,%edi
801023bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801023c1:	89 f8                	mov    %edi,%eax
801023c3:	ee                   	out    %al,(%dx)
801023c4:	b8 01 00 00 00       	mov    $0x1,%eax
801023c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801023ce:	ee                   	out    %al,(%dx)
801023cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801023d4:	89 d8                	mov    %ebx,%eax
801023d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801023d7:	89 d8                	mov    %ebx,%eax
801023d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801023de:	c1 f8 08             	sar    $0x8,%eax
801023e1:	ee                   	out    %al,(%dx)
801023e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801023e7:	89 f8                	mov    %edi,%eax
801023e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801023ea:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801023ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023f3:	c1 e0 04             	shl    $0x4,%eax
801023f6:	83 e0 10             	and    $0x10,%eax
801023f9:	83 c8 e0             	or     $0xffffffe0,%eax
801023fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801023fd:	f6 06 04             	testb  $0x4,(%esi)
80102400:	75 16                	jne    80102418 <idestart+0x98>
80102402:	b8 20 00 00 00       	mov    $0x20,%eax
80102407:	89 ca                	mov    %ecx,%edx
80102409:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010240a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010240d:	5b                   	pop    %ebx
8010240e:	5e                   	pop    %esi
8010240f:	5f                   	pop    %edi
80102410:	5d                   	pop    %ebp
80102411:	c3                   	ret    
80102412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102418:	b8 30 00 00 00       	mov    $0x30,%eax
8010241d:	89 ca                	mov    %ecx,%edx
8010241f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102420:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102425:	83 c6 5c             	add    $0x5c,%esi
80102428:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010242d:	fc                   	cld    
8010242e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102430:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102433:	5b                   	pop    %ebx
80102434:	5e                   	pop    %esi
80102435:	5f                   	pop    %edi
80102436:	5d                   	pop    %ebp
80102437:	c3                   	ret    
    panic("incorrect blockno");
80102438:	83 ec 0c             	sub    $0xc,%esp
8010243b:	68 38 7c 10 80       	push   $0x80107c38
80102440:	e8 4b df ff ff       	call   80100390 <panic>
    panic("idestart");
80102445:	83 ec 0c             	sub    $0xc,%esp
80102448:	68 2f 7c 10 80       	push   $0x80107c2f
8010244d:	e8 3e df ff ff       	call   80100390 <panic>
80102452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <ideinit>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102466:	68 4a 7c 10 80       	push   $0x80107c4a
8010246b:	68 80 b5 10 80       	push   $0x8010b580
80102470:	e8 1b 27 00 00       	call   80104b90 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102475:	58                   	pop    %eax
80102476:	a1 20 3d 11 80       	mov    0x80113d20,%eax
8010247b:	5a                   	pop    %edx
8010247c:	83 e8 01             	sub    $0x1,%eax
8010247f:	50                   	push   %eax
80102480:	6a 0e                	push   $0xe
80102482:	e8 a9 02 00 00       	call   80102730 <ioapicenable>
80102487:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010248a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010248f:	90                   	nop
80102490:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102491:	83 e0 c0             	and    $0xffffffc0,%eax
80102494:	3c 40                	cmp    $0x40,%al
80102496:	75 f8                	jne    80102490 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102498:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010249d:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024a2:	ee                   	out    %al,(%dx)
801024a3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024a8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024ad:	eb 06                	jmp    801024b5 <ideinit+0x55>
801024af:	90                   	nop
  for(i=0; i<1000; i++){
801024b0:	83 e9 01             	sub    $0x1,%ecx
801024b3:	74 0f                	je     801024c4 <ideinit+0x64>
801024b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801024b6:	84 c0                	test   %al,%al
801024b8:	74 f6                	je     801024b0 <ideinit+0x50>
      havedisk1 = 1;
801024ba:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801024c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801024c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024ce:	ee                   	out    %al,(%dx)
}
801024cf:	c9                   	leave  
801024d0:	c3                   	ret    
801024d1:	eb 0d                	jmp    801024e0 <ideintr>
801024d3:	90                   	nop
801024d4:	90                   	nop
801024d5:	90                   	nop
801024d6:	90                   	nop
801024d7:	90                   	nop
801024d8:	90                   	nop
801024d9:	90                   	nop
801024da:	90                   	nop
801024db:	90                   	nop
801024dc:	90                   	nop
801024dd:	90                   	nop
801024de:	90                   	nop
801024df:	90                   	nop

801024e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	57                   	push   %edi
801024e4:	56                   	push   %esi
801024e5:	53                   	push   %ebx
801024e6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801024e9:	68 80 b5 10 80       	push   $0x8010b580
801024ee:	e8 dd 27 00 00       	call   80104cd0 <acquire>

  if((b = idequeue) == 0){
801024f3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801024f9:	83 c4 10             	add    $0x10,%esp
801024fc:	85 db                	test   %ebx,%ebx
801024fe:	74 67                	je     80102567 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102500:	8b 43 58             	mov    0x58(%ebx),%eax
80102503:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102508:	8b 3b                	mov    (%ebx),%edi
8010250a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102510:	75 31                	jne    80102543 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102512:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102517:	89 f6                	mov    %esi,%esi
80102519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102520:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102521:	89 c6                	mov    %eax,%esi
80102523:	83 e6 c0             	and    $0xffffffc0,%esi
80102526:	89 f1                	mov    %esi,%ecx
80102528:	80 f9 40             	cmp    $0x40,%cl
8010252b:	75 f3                	jne    80102520 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010252d:	a8 21                	test   $0x21,%al
8010252f:	75 12                	jne    80102543 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102531:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102534:	b9 80 00 00 00       	mov    $0x80,%ecx
80102539:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010253e:	fc                   	cld    
8010253f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102541:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102543:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102546:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102549:	89 f9                	mov    %edi,%ecx
8010254b:	83 c9 02             	or     $0x2,%ecx
8010254e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102550:	53                   	push   %ebx
80102551:	e8 ca 23 00 00       	call   80104920 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102556:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010255b:	83 c4 10             	add    $0x10,%esp
8010255e:	85 c0                	test   %eax,%eax
80102560:	74 05                	je     80102567 <ideintr+0x87>
    idestart(idequeue);
80102562:	e8 19 fe ff ff       	call   80102380 <idestart>
    release(&idelock);
80102567:	83 ec 0c             	sub    $0xc,%esp
8010256a:	68 80 b5 10 80       	push   $0x8010b580
8010256f:	e8 1c 28 00 00       	call   80104d90 <release>

  release(&idelock);
}
80102574:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102577:	5b                   	pop    %ebx
80102578:	5e                   	pop    %esi
80102579:	5f                   	pop    %edi
8010257a:	5d                   	pop    %ebp
8010257b:	c3                   	ret    
8010257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102580 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	53                   	push   %ebx
80102584:	83 ec 10             	sub    $0x10,%esp
80102587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010258a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010258d:	50                   	push   %eax
8010258e:	e8 ad 25 00 00       	call   80104b40 <holdingsleep>
80102593:	83 c4 10             	add    $0x10,%esp
80102596:	85 c0                	test   %eax,%eax
80102598:	0f 84 c6 00 00 00    	je     80102664 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010259e:	8b 03                	mov    (%ebx),%eax
801025a0:	83 e0 06             	and    $0x6,%eax
801025a3:	83 f8 02             	cmp    $0x2,%eax
801025a6:	0f 84 ab 00 00 00    	je     80102657 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801025ac:	8b 53 04             	mov    0x4(%ebx),%edx
801025af:	85 d2                	test   %edx,%edx
801025b1:	74 0d                	je     801025c0 <iderw+0x40>
801025b3:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801025b8:	85 c0                	test   %eax,%eax
801025ba:	0f 84 b1 00 00 00    	je     80102671 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801025c0:	83 ec 0c             	sub    $0xc,%esp
801025c3:	68 80 b5 10 80       	push   $0x8010b580
801025c8:	e8 03 27 00 00       	call   80104cd0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025cd:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801025d3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801025d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025dd:	85 d2                	test   %edx,%edx
801025df:	75 09                	jne    801025ea <iderw+0x6a>
801025e1:	eb 6d                	jmp    80102650 <iderw+0xd0>
801025e3:	90                   	nop
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025e8:	89 c2                	mov    %eax,%edx
801025ea:	8b 42 58             	mov    0x58(%edx),%eax
801025ed:	85 c0                	test   %eax,%eax
801025ef:	75 f7                	jne    801025e8 <iderw+0x68>
801025f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801025f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801025f6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801025fc:	74 42                	je     80102640 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801025fe:	8b 03                	mov    (%ebx),%eax
80102600:	83 e0 06             	and    $0x6,%eax
80102603:	83 f8 02             	cmp    $0x2,%eax
80102606:	74 23                	je     8010262b <iderw+0xab>
80102608:	90                   	nop
80102609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102610:	83 ec 08             	sub    $0x8,%esp
80102613:	68 80 b5 10 80       	push   $0x8010b580
80102618:	53                   	push   %ebx
80102619:	e8 42 21 00 00       	call   80104760 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010261e:	8b 03                	mov    (%ebx),%eax
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	83 e0 06             	and    $0x6,%eax
80102626:	83 f8 02             	cmp    $0x2,%eax
80102629:	75 e5                	jne    80102610 <iderw+0x90>
  }


  release(&idelock);
8010262b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102632:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102635:	c9                   	leave  
  release(&idelock);
80102636:	e9 55 27 00 00       	jmp    80104d90 <release>
8010263b:	90                   	nop
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102640:	89 d8                	mov    %ebx,%eax
80102642:	e8 39 fd ff ff       	call   80102380 <idestart>
80102647:	eb b5                	jmp    801025fe <iderw+0x7e>
80102649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102650:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102655:	eb 9d                	jmp    801025f4 <iderw+0x74>
    panic("iderw: nothing to do");
80102657:	83 ec 0c             	sub    $0xc,%esp
8010265a:	68 64 7c 10 80       	push   $0x80107c64
8010265f:	e8 2c dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102664:	83 ec 0c             	sub    $0xc,%esp
80102667:	68 4e 7c 10 80       	push   $0x80107c4e
8010266c:	e8 1f dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102671:	83 ec 0c             	sub    $0xc,%esp
80102674:	68 79 7c 10 80       	push   $0x80107c79
80102679:	e8 12 dd ff ff       	call   80100390 <panic>
8010267e:	66 90                	xchg   %ax,%ax

80102680 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102680:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102681:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102688:	00 c0 fe 
{
8010268b:	89 e5                	mov    %esp,%ebp
8010268d:	56                   	push   %esi
8010268e:	53                   	push   %ebx
  ioapic->reg = reg;
8010268f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102696:	00 00 00 
  return ioapic->data;
80102699:	a1 34 36 11 80       	mov    0x80113634,%eax
8010269e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801026a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801026a7:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801026ad:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801026b4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801026b7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801026ba:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801026bd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801026c0:	39 c2                	cmp    %eax,%edx
801026c2:	74 16                	je     801026da <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801026c4:	83 ec 0c             	sub    $0xc,%esp
801026c7:	68 98 7c 10 80       	push   $0x80107c98
801026cc:	e8 8f df ff ff       	call   80100660 <cprintf>
801026d1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801026d7:	83 c4 10             	add    $0x10,%esp
801026da:	83 c3 21             	add    $0x21,%ebx
{
801026dd:	ba 10 00 00 00       	mov    $0x10,%edx
801026e2:	b8 20 00 00 00       	mov    $0x20,%eax
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801026f0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801026f2:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801026f8:	89 c6                	mov    %eax,%esi
801026fa:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102700:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102703:	89 71 10             	mov    %esi,0x10(%ecx)
80102706:	8d 72 01             	lea    0x1(%edx),%esi
80102709:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010270c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010270e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102710:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102716:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010271d:	75 d1                	jne    801026f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010271f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102722:	5b                   	pop    %ebx
80102723:	5e                   	pop    %esi
80102724:	5d                   	pop    %ebp
80102725:	c3                   	ret    
80102726:	8d 76 00             	lea    0x0(%esi),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102730:	55                   	push   %ebp
  ioapic->reg = reg;
80102731:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
80102737:	89 e5                	mov    %esp,%ebp
80102739:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010273c:	8d 50 20             	lea    0x20(%eax),%edx
8010273f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102743:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102745:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010274b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010274e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102751:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102754:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102756:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010275b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010275e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102761:	5d                   	pop    %ebp
80102762:	c3                   	ret    
80102763:	66 90                	xchg   %ax,%ax
80102765:	66 90                	xchg   %ax,%ax
80102767:	66 90                	xchg   %ax,%ax
80102769:	66 90                	xchg   %ax,%ax
8010276b:	66 90                	xchg   %ax,%ax
8010276d:	66 90                	xchg   %ax,%ax
8010276f:	90                   	nop

80102770 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	53                   	push   %ebx
80102774:	83 ec 04             	sub    $0x4,%esp
80102777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010277a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102780:	0f 85 7c 00 00 00    	jne    80102802 <kfree+0x92>
80102786:	81 fb c8 01 12 80    	cmp    $0x801201c8,%ebx
8010278c:	72 74                	jb     80102802 <kfree+0x92>
8010278e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102794:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102799:	77 67                	ja     80102802 <kfree+0x92>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010279b:	83 ec 04             	sub    $0x4,%esp
8010279e:	68 00 10 00 00       	push   $0x1000
801027a3:	6a 01                	push   $0x1
801027a5:	53                   	push   %ebx
801027a6:	e8 35 26 00 00       	call   80104de0 <memset>

  if(kmem.use_lock)
801027ab:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801027b1:	83 c4 10             	add    $0x10,%esp
801027b4:	85 d2                	test   %edx,%edx
801027b6:	75 38                	jne    801027f0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801027b8:	a1 78 36 11 80       	mov    0x80113678,%eax
801027bd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  freePageCounts.currentFreePages++;
  if(kmem.use_lock)
801027bf:	a1 74 36 11 80       	mov    0x80113674,%eax
  freePageCounts.currentFreePages++;
801027c4:	83 05 7c 36 11 80 01 	addl   $0x1,0x8011367c
  kmem.freelist = r;
801027cb:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801027d1:	85 c0                	test   %eax,%eax
801027d3:	75 0b                	jne    801027e0 <kfree+0x70>
    release(&kmem.lock);
}
801027d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d8:	c9                   	leave  
801027d9:	c3                   	ret    
801027da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801027e0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801027e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ea:	c9                   	leave  
    release(&kmem.lock);
801027eb:	e9 a0 25 00 00       	jmp    80104d90 <release>
    acquire(&kmem.lock);
801027f0:	83 ec 0c             	sub    $0xc,%esp
801027f3:	68 40 36 11 80       	push   $0x80113640
801027f8:	e8 d3 24 00 00       	call   80104cd0 <acquire>
801027fd:	83 c4 10             	add    $0x10,%esp
80102800:	eb b6                	jmp    801027b8 <kfree+0x48>
    panic("kfree");
80102802:	83 ec 0c             	sub    $0xc,%esp
80102805:	68 ca 7c 10 80       	push   $0x80107cca
8010280a:	e8 81 db ff ff       	call   80100390 <panic>
8010280f:	90                   	nop

80102810 <freerange>:
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
80102813:	56                   	push   %esi
80102814:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102815:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102818:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010281b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102821:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102827:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010282d:	39 de                	cmp    %ebx,%esi
8010282f:	72 23                	jb     80102854 <freerange+0x44>
80102831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102838:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010283e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102841:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102847:	50                   	push   %eax
80102848:	e8 23 ff ff ff       	call   80102770 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010284d:	83 c4 10             	add    $0x10,%esp
80102850:	39 f3                	cmp    %esi,%ebx
80102852:	76 e4                	jbe    80102838 <freerange+0x28>
}
80102854:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102857:	5b                   	pop    %ebx
80102858:	5e                   	pop    %esi
80102859:	5d                   	pop    %ebp
8010285a:	c3                   	ret    
8010285b:	90                   	nop
8010285c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102860 <kinit1>:
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	57                   	push   %edi
80102864:	56                   	push   %esi
80102865:	53                   	push   %ebx
80102866:	83 ec 14             	sub    $0x14,%esp
80102869:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010286c:	68 d0 7c 10 80       	push   $0x80107cd0
80102871:	68 40 36 11 80       	push   $0x80113640
80102876:	e8 15 23 00 00       	call   80104b90 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010287b:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010287e:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102881:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102888:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010288b:	8d b8 ff 0f 00 00    	lea    0xfff(%eax),%edi
80102891:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102897:	8d 9f 00 10 00 00    	lea    0x1000(%edi),%ebx
8010289d:	39 de                	cmp    %ebx,%esi
8010289f:	72 23                	jb     801028c4 <kinit1+0x64>
801028a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801028a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028ae:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028b7:	50                   	push   %eax
801028b8:	e8 b3 fe ff ff       	call   80102770 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028bd:	83 c4 10             	add    $0x10,%esp
801028c0:	39 de                	cmp    %ebx,%esi
801028c2:	73 e4                	jae    801028a8 <kinit1+0x48>
  freePageCounts.initFreePages = (PGROUNDDOWN((uint)vend) - PGROUNDUP((uint)vstart)) / PGSIZE;
801028c4:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801028ca:	29 fe                	sub    %edi,%esi
801028cc:	c1 ee 0c             	shr    $0xc,%esi
801028cf:	89 35 80 36 11 80    	mov    %esi,0x80113680
}
801028d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028d8:	5b                   	pop    %ebx
801028d9:	5e                   	pop    %esi
801028da:	5f                   	pop    %edi
801028db:	5d                   	pop    %ebp
801028dc:	c3                   	ret    
801028dd:	8d 76 00             	lea    0x0(%esi),%esi

801028e0 <kinit2>:
{
801028e0:	55                   	push   %ebp
801028e1:	89 e5                	mov    %esp,%ebp
801028e3:	57                   	push   %edi
801028e4:	56                   	push   %esi
801028e5:	53                   	push   %ebx
801028e6:	83 ec 0c             	sub    $0xc,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801028e9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801028ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801028ef:	8d b8 ff 0f 00 00    	lea    0xfff(%eax),%edi
801028f5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028fb:	8d 9f 00 10 00 00    	lea    0x1000(%edi),%ebx
80102901:	39 de                	cmp    %ebx,%esi
80102903:	72 1f                	jb     80102924 <kinit2+0x44>
80102905:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102908:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010290e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102911:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102917:	50                   	push   %eax
80102918:	e8 53 fe ff ff       	call   80102770 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010291d:	83 c4 10             	add    $0x10,%esp
80102920:	39 de                	cmp    %ebx,%esi
80102922:	73 e4                	jae    80102908 <kinit2+0x28>
  freePageCounts.initFreePages += (PGROUNDDOWN((uint)vend) - PGROUNDUP((uint)vstart)) / PGSIZE;
80102924:	89 f0                	mov    %esi,%eax
  kmem.use_lock = 1;
80102926:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010292d:	00 00 00 
  freePageCounts.initFreePages += (PGROUNDDOWN((uint)vend) - PGROUNDUP((uint)vstart)) / PGSIZE;
80102930:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102935:	29 f8                	sub    %edi,%eax
80102937:	c1 e8 0c             	shr    $0xc,%eax
8010293a:	03 05 80 36 11 80    	add    0x80113680,%eax
80102940:	a3 80 36 11 80       	mov    %eax,0x80113680
  freePageCounts.currentFreePages = freePageCounts.initFreePages;
80102945:	a3 7c 36 11 80       	mov    %eax,0x8011367c
}
8010294a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010294d:	5b                   	pop    %ebx
8010294e:	5e                   	pop    %esi
8010294f:	5f                   	pop    %edi
80102950:	5d                   	pop    %ebp
80102951:	c3                   	ret    
80102952:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102960 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102960:	a1 74 36 11 80       	mov    0x80113674,%eax
80102965:	85 c0                	test   %eax,%eax
80102967:	75 27                	jne    80102990 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102969:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r){
8010296e:	85 c0                	test   %eax,%eax
80102970:	74 16                	je     80102988 <kalloc+0x28>
    kmem.freelist = r->next;
80102972:	8b 10                	mov    (%eax),%edx
    freePageCounts.currentFreePages--;
80102974:	83 2d 7c 36 11 80 01 	subl   $0x1,0x8011367c
    kmem.freelist = r->next;
8010297b:	89 15 78 36 11 80    	mov    %edx,0x80113678
80102981:	c3                   	ret    
80102982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102988:	f3 c3                	repz ret 
8010298a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102990:	55                   	push   %ebp
80102991:	89 e5                	mov    %esp,%ebp
80102993:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102996:	68 40 36 11 80       	push   $0x80113640
8010299b:	e8 30 23 00 00       	call   80104cd0 <acquire>
  r = kmem.freelist;
801029a0:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r){
801029a5:	83 c4 10             	add    $0x10,%esp
801029a8:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801029ae:	85 c0                	test   %eax,%eax
801029b0:	74 0f                	je     801029c1 <kalloc+0x61>
    kmem.freelist = r->next;
801029b2:	8b 08                	mov    (%eax),%ecx
    freePageCounts.currentFreePages--;
801029b4:	83 2d 7c 36 11 80 01 	subl   $0x1,0x8011367c
    kmem.freelist = r->next;
801029bb:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
801029c1:	85 d2                	test   %edx,%edx
801029c3:	74 16                	je     801029db <kalloc+0x7b>
    release(&kmem.lock);
801029c5:	83 ec 0c             	sub    $0xc,%esp
801029c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029cb:	68 40 36 11 80       	push   $0x80113640
801029d0:	e8 bb 23 00 00       	call   80104d90 <release>
  return (char*)r;
801029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801029d8:	83 c4 10             	add    $0x10,%esp
}
801029db:	c9                   	leave  
801029dc:	c3                   	ret    
801029dd:	66 90                	xchg   %ax,%ax
801029df:	90                   	nop

801029e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e0:	ba 64 00 00 00       	mov    $0x64,%edx
801029e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801029e6:	a8 01                	test   $0x1,%al
801029e8:	0f 84 c2 00 00 00    	je     80102ab0 <kbdgetc+0xd0>
801029ee:	ba 60 00 00 00       	mov    $0x60,%edx
801029f3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801029f4:	0f b6 d0             	movzbl %al,%edx
801029f7:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
801029fd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102a03:	0f 84 7f 00 00 00    	je     80102a88 <kbdgetc+0xa8>
{
80102a09:	55                   	push   %ebp
80102a0a:	89 e5                	mov    %esp,%ebp
80102a0c:	53                   	push   %ebx
80102a0d:	89 cb                	mov    %ecx,%ebx
80102a0f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102a12:	84 c0                	test   %al,%al
80102a14:	78 4a                	js     80102a60 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a16:	85 db                	test   %ebx,%ebx
80102a18:	74 09                	je     80102a23 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a1a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a1d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102a20:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102a23:	0f b6 82 00 7e 10 80 	movzbl -0x7fef8200(%edx),%eax
80102a2a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102a2c:	0f b6 82 00 7d 10 80 	movzbl -0x7fef8300(%edx),%eax
80102a33:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a35:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102a37:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102a3d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a40:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a43:	8b 04 85 e0 7c 10 80 	mov    -0x7fef8320(,%eax,4),%eax
80102a4a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102a4e:	74 31                	je     80102a81 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102a50:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a53:	83 fa 19             	cmp    $0x19,%edx
80102a56:	77 40                	ja     80102a98 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a58:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a5b:	5b                   	pop    %ebx
80102a5c:	5d                   	pop    %ebp
80102a5d:	c3                   	ret    
80102a5e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102a60:	83 e0 7f             	and    $0x7f,%eax
80102a63:	85 db                	test   %ebx,%ebx
80102a65:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102a68:	0f b6 82 00 7e 10 80 	movzbl -0x7fef8200(%edx),%eax
80102a6f:	83 c8 40             	or     $0x40,%eax
80102a72:	0f b6 c0             	movzbl %al,%eax
80102a75:	f7 d0                	not    %eax
80102a77:	21 c1                	and    %eax,%ecx
    return 0;
80102a79:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102a7b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102a81:	5b                   	pop    %ebx
80102a82:	5d                   	pop    %ebp
80102a83:	c3                   	ret    
80102a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102a88:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102a8b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a8d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102a98:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102a9b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102a9e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102a9f:	83 f9 1a             	cmp    $0x1a,%ecx
80102aa2:	0f 42 c2             	cmovb  %edx,%eax
}
80102aa5:	5d                   	pop    %ebp
80102aa6:	c3                   	ret    
80102aa7:	89 f6                	mov    %esi,%esi
80102aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ab5:	c3                   	ret    
80102ab6:	8d 76 00             	lea    0x0(%esi),%esi
80102ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ac0 <kbdintr>:

void
kbdintr(void)
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102ac6:	68 e0 29 10 80       	push   $0x801029e0
80102acb:	e8 40 dd ff ff       	call   80100810 <consoleintr>
}
80102ad0:	83 c4 10             	add    $0x10,%esp
80102ad3:	c9                   	leave  
80102ad4:	c3                   	ret    
80102ad5:	66 90                	xchg   %ax,%ax
80102ad7:	66 90                	xchg   %ax,%ax
80102ad9:	66 90                	xchg   %ax,%ax
80102adb:	66 90                	xchg   %ax,%ax
80102add:	66 90                	xchg   %ax,%ax
80102adf:	90                   	nop

80102ae0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102ae0:	a1 84 36 11 80       	mov    0x80113684,%eax
{
80102ae5:	55                   	push   %ebp
80102ae6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102ae8:	85 c0                	test   %eax,%eax
80102aea:	0f 84 c8 00 00 00    	je     80102bb8 <lapicinit+0xd8>
  lapic[index] = value;
80102af0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102af7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102afa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102afd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b04:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b07:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b0a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b11:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b14:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b17:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b1e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b21:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b24:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b2b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b31:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b38:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b3b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b3e:	8b 50 30             	mov    0x30(%eax),%edx
80102b41:	c1 ea 10             	shr    $0x10,%edx
80102b44:	80 fa 03             	cmp    $0x3,%dl
80102b47:	77 77                	ja     80102bc0 <lapicinit+0xe0>
  lapic[index] = value;
80102b49:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b50:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b53:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b56:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b5d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b60:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b63:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b6a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b6d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b70:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b77:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b7a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b7d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102b84:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b87:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b8a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102b91:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102b94:	8b 50 20             	mov    0x20(%eax),%edx
80102b97:	89 f6                	mov    %esi,%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ba0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ba6:	80 e6 10             	and    $0x10,%dh
80102ba9:	75 f5                	jne    80102ba0 <lapicinit+0xc0>
  lapic[index] = value;
80102bab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102bb2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102bc0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102bc7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bca:	8b 50 20             	mov    0x20(%eax),%edx
80102bcd:	e9 77 ff ff ff       	jmp    80102b49 <lapicinit+0x69>
80102bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102be0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102be0:	8b 15 84 36 11 80    	mov    0x80113684,%edx
{
80102be6:	55                   	push   %ebp
80102be7:	31 c0                	xor    %eax,%eax
80102be9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102beb:	85 d2                	test   %edx,%edx
80102bed:	74 06                	je     80102bf5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102bef:	8b 42 20             	mov    0x20(%edx),%eax
80102bf2:	c1 e8 18             	shr    $0x18,%eax
}
80102bf5:	5d                   	pop    %ebp
80102bf6:	c3                   	ret    
80102bf7:	89 f6                	mov    %esi,%esi
80102bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c00 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102c00:	a1 84 36 11 80       	mov    0x80113684,%eax
{
80102c05:	55                   	push   %ebp
80102c06:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102c08:	85 c0                	test   %eax,%eax
80102c0a:	74 0d                	je     80102c19 <lapiceoi+0x19>
  lapic[index] = value;
80102c0c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c13:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c16:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c19:	5d                   	pop    %ebp
80102c1a:	c3                   	ret    
80102c1b:	90                   	nop
80102c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c20 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
}
80102c23:	5d                   	pop    %ebp
80102c24:	c3                   	ret    
80102c25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c30 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c30:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c31:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c36:	ba 70 00 00 00       	mov    $0x70,%edx
80102c3b:	89 e5                	mov    %esp,%ebp
80102c3d:	53                   	push   %ebx
80102c3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c41:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c44:	ee                   	out    %al,(%dx)
80102c45:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c4a:	ba 71 00 00 00       	mov    $0x71,%edx
80102c4f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c50:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c52:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c55:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c5b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c5d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102c60:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102c63:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c65:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c68:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102c6e:	a1 84 36 11 80       	mov    0x80113684,%eax
80102c73:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c79:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c7c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102c83:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c86:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c89:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102c90:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c93:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c96:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c9c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c9f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ca5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ca8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cb1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cb7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102cba:	5b                   	pop    %ebx
80102cbb:	5d                   	pop    %ebp
80102cbc:	c3                   	ret    
80102cbd:	8d 76 00             	lea    0x0(%esi),%esi

80102cc0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102cc0:	55                   	push   %ebp
80102cc1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102cc6:	ba 70 00 00 00       	mov    $0x70,%edx
80102ccb:	89 e5                	mov    %esp,%ebp
80102ccd:	57                   	push   %edi
80102cce:	56                   	push   %esi
80102ccf:	53                   	push   %ebx
80102cd0:	83 ec 4c             	sub    $0x4c,%esp
80102cd3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd4:	ba 71 00 00 00       	mov    $0x71,%edx
80102cd9:	ec                   	in     (%dx),%al
80102cda:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cdd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ce2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ce5:	8d 76 00             	lea    0x0(%esi),%esi
80102ce8:	31 c0                	xor    %eax,%eax
80102cea:	89 da                	mov    %ebx,%edx
80102cec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ced:	b9 71 00 00 00       	mov    $0x71,%ecx
80102cf2:	89 ca                	mov    %ecx,%edx
80102cf4:	ec                   	in     (%dx),%al
80102cf5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf8:	89 da                	mov    %ebx,%edx
80102cfa:	b8 02 00 00 00       	mov    $0x2,%eax
80102cff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d00:	89 ca                	mov    %ecx,%edx
80102d02:	ec                   	in     (%dx),%al
80102d03:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d06:	89 da                	mov    %ebx,%edx
80102d08:	b8 04 00 00 00       	mov    $0x4,%eax
80102d0d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d0e:	89 ca                	mov    %ecx,%edx
80102d10:	ec                   	in     (%dx),%al
80102d11:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d14:	89 da                	mov    %ebx,%edx
80102d16:	b8 07 00 00 00       	mov    $0x7,%eax
80102d1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d1c:	89 ca                	mov    %ecx,%edx
80102d1e:	ec                   	in     (%dx),%al
80102d1f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d22:	89 da                	mov    %ebx,%edx
80102d24:	b8 08 00 00 00       	mov    $0x8,%eax
80102d29:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d2a:	89 ca                	mov    %ecx,%edx
80102d2c:	ec                   	in     (%dx),%al
80102d2d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d2f:	89 da                	mov    %ebx,%edx
80102d31:	b8 09 00 00 00       	mov    $0x9,%eax
80102d36:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d37:	89 ca                	mov    %ecx,%edx
80102d39:	ec                   	in     (%dx),%al
80102d3a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d3c:	89 da                	mov    %ebx,%edx
80102d3e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d44:	89 ca                	mov    %ecx,%edx
80102d46:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d47:	84 c0                	test   %al,%al
80102d49:	78 9d                	js     80102ce8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102d4b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102d4f:	89 fa                	mov    %edi,%edx
80102d51:	0f b6 fa             	movzbl %dl,%edi
80102d54:	89 f2                	mov    %esi,%edx
80102d56:	0f b6 f2             	movzbl %dl,%esi
80102d59:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d5c:	89 da                	mov    %ebx,%edx
80102d5e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102d61:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102d64:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102d68:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102d6b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102d6f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102d72:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102d76:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102d79:	31 c0                	xor    %eax,%eax
80102d7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d7c:	89 ca                	mov    %ecx,%edx
80102d7e:	ec                   	in     (%dx),%al
80102d7f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d82:	89 da                	mov    %ebx,%edx
80102d84:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102d87:	b8 02 00 00 00       	mov    $0x2,%eax
80102d8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d8d:	89 ca                	mov    %ecx,%edx
80102d8f:	ec                   	in     (%dx),%al
80102d90:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d93:	89 da                	mov    %ebx,%edx
80102d95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102d98:	b8 04 00 00 00       	mov    $0x4,%eax
80102d9d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d9e:	89 ca                	mov    %ecx,%edx
80102da0:	ec                   	in     (%dx),%al
80102da1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102da4:	89 da                	mov    %ebx,%edx
80102da6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102da9:	b8 07 00 00 00       	mov    $0x7,%eax
80102dae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102daf:	89 ca                	mov    %ecx,%edx
80102db1:	ec                   	in     (%dx),%al
80102db2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db5:	89 da                	mov    %ebx,%edx
80102db7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102dba:	b8 08 00 00 00       	mov    $0x8,%eax
80102dbf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dc0:	89 ca                	mov    %ecx,%edx
80102dc2:	ec                   	in     (%dx),%al
80102dc3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc6:	89 da                	mov    %ebx,%edx
80102dc8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102dcb:	b8 09 00 00 00       	mov    $0x9,%eax
80102dd0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd1:	89 ca                	mov    %ecx,%edx
80102dd3:	ec                   	in     (%dx),%al
80102dd4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102dd7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102dda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ddd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102de0:	6a 18                	push   $0x18
80102de2:	50                   	push   %eax
80102de3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102de6:	50                   	push   %eax
80102de7:	e8 44 20 00 00       	call   80104e30 <memcmp>
80102dec:	83 c4 10             	add    $0x10,%esp
80102def:	85 c0                	test   %eax,%eax
80102df1:	0f 85 f1 fe ff ff    	jne    80102ce8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102df7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102dfb:	75 78                	jne    80102e75 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102dfd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e00:	89 c2                	mov    %eax,%edx
80102e02:	83 e0 0f             	and    $0xf,%eax
80102e05:	c1 ea 04             	shr    $0x4,%edx
80102e08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e0e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e11:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e14:	89 c2                	mov    %eax,%edx
80102e16:	83 e0 0f             	and    $0xf,%eax
80102e19:	c1 ea 04             	shr    $0x4,%edx
80102e1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e22:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e25:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e28:	89 c2                	mov    %eax,%edx
80102e2a:	83 e0 0f             	and    $0xf,%eax
80102e2d:	c1 ea 04             	shr    $0x4,%edx
80102e30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e36:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e3c:	89 c2                	mov    %eax,%edx
80102e3e:	83 e0 0f             	and    $0xf,%eax
80102e41:	c1 ea 04             	shr    $0x4,%edx
80102e44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e4a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102e4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e50:	89 c2                	mov    %eax,%edx
80102e52:	83 e0 0f             	and    $0xf,%eax
80102e55:	c1 ea 04             	shr    $0x4,%edx
80102e58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102e61:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e64:	89 c2                	mov    %eax,%edx
80102e66:	83 e0 0f             	and    $0xf,%eax
80102e69:	c1 ea 04             	shr    $0x4,%edx
80102e6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e72:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102e75:	8b 75 08             	mov    0x8(%ebp),%esi
80102e78:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e7b:	89 06                	mov    %eax,(%esi)
80102e7d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e80:	89 46 04             	mov    %eax,0x4(%esi)
80102e83:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e86:	89 46 08             	mov    %eax,0x8(%esi)
80102e89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e8c:	89 46 0c             	mov    %eax,0xc(%esi)
80102e8f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e92:	89 46 10             	mov    %eax,0x10(%esi)
80102e95:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e98:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102e9b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ea5:	5b                   	pop    %ebx
80102ea6:	5e                   	pop    %esi
80102ea7:	5f                   	pop    %edi
80102ea8:	5d                   	pop    %ebp
80102ea9:	c3                   	ret    
80102eaa:	66 90                	xchg   %ax,%ax
80102eac:	66 90                	xchg   %ax,%ax
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102eb0:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102eb6:	85 c9                	test   %ecx,%ecx
80102eb8:	0f 8e 8a 00 00 00    	jle    80102f48 <install_trans+0x98>
{
80102ebe:	55                   	push   %ebp
80102ebf:	89 e5                	mov    %esp,%ebp
80102ec1:	57                   	push   %edi
80102ec2:	56                   	push   %esi
80102ec3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102ec4:	31 db                	xor    %ebx,%ebx
{
80102ec6:	83 ec 0c             	sub    $0xc,%esp
80102ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ed0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102ed5:	83 ec 08             	sub    $0x8,%esp
80102ed8:	01 d8                	add    %ebx,%eax
80102eda:	83 c0 01             	add    $0x1,%eax
80102edd:	50                   	push   %eax
80102ede:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102ee4:	e8 e7 d1 ff ff       	call   801000d0 <bread>
80102ee9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102eeb:	58                   	pop    %eax
80102eec:	5a                   	pop    %edx
80102eed:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102ef4:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102efa:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102efd:	e8 ce d1 ff ff       	call   801000d0 <bread>
80102f02:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f04:	8d 47 5c             	lea    0x5c(%edi),%eax
80102f07:	83 c4 0c             	add    $0xc,%esp
80102f0a:	68 00 02 00 00       	push   $0x200
80102f0f:	50                   	push   %eax
80102f10:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f13:	50                   	push   %eax
80102f14:	e8 77 1f 00 00       	call   80104e90 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f19:	89 34 24             	mov    %esi,(%esp)
80102f1c:	e8 7f d2 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102f21:	89 3c 24             	mov    %edi,(%esp)
80102f24:	e8 b7 d2 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102f29:	89 34 24             	mov    %esi,(%esp)
80102f2c:	e8 af d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f31:	83 c4 10             	add    $0x10,%esp
80102f34:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102f3a:	7f 94                	jg     80102ed0 <install_trans+0x20>
  }
}
80102f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f3f:	5b                   	pop    %ebx
80102f40:	5e                   	pop    %esi
80102f41:	5f                   	pop    %edi
80102f42:	5d                   	pop    %ebp
80102f43:	c3                   	ret    
80102f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f48:	f3 c3                	repz ret 
80102f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102f50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	56                   	push   %esi
80102f54:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102f55:	83 ec 08             	sub    $0x8,%esp
80102f58:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102f5e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102f64:	e8 67 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102f69:	8b 1d e8 36 11 80    	mov    0x801136e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f6f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f72:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102f74:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102f76:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102f79:	7e 16                	jle    80102f91 <write_head+0x41>
80102f7b:	c1 e3 02             	shl    $0x2,%ebx
80102f7e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102f80:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80102f86:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102f8a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102f8d:	39 da                	cmp    %ebx,%edx
80102f8f:	75 ef                	jne    80102f80 <write_head+0x30>
  }
  bwrite(buf);
80102f91:	83 ec 0c             	sub    $0xc,%esp
80102f94:	56                   	push   %esi
80102f95:	e8 06 d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102f9a:	89 34 24             	mov    %esi,(%esp)
80102f9d:	e8 3e d2 ff ff       	call   801001e0 <brelse>
}
80102fa2:	83 c4 10             	add    $0x10,%esp
80102fa5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102fa8:	5b                   	pop    %ebx
80102fa9:	5e                   	pop    %esi
80102faa:	5d                   	pop    %ebp
80102fab:	c3                   	ret    
80102fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fb0 <initlog>:
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 2c             	sub    $0x2c,%esp
80102fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102fba:	68 00 7f 10 80       	push   $0x80107f00
80102fbf:	68 a0 36 11 80       	push   $0x801136a0
80102fc4:	e8 c7 1b 00 00       	call   80104b90 <initlock>
  readsb(dev, &sb);
80102fc9:	58                   	pop    %eax
80102fca:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102fcd:	5a                   	pop    %edx
80102fce:	50                   	push   %eax
80102fcf:	53                   	push   %ebx
80102fd0:	e8 3b e5 ff ff       	call   80101510 <readsb>
  log.size = sb.nlog;
80102fd5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102fd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102fdb:	59                   	pop    %ecx
  log.dev = dev;
80102fdc:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102fe2:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  log.start = sb.logstart;
80102fe8:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  struct buf *buf = bread(log.dev, log.start);
80102fed:	5a                   	pop    %edx
80102fee:	50                   	push   %eax
80102fef:	53                   	push   %ebx
80102ff0:	e8 db d0 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102ff5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ff8:	83 c4 10             	add    $0x10,%esp
80102ffb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102ffd:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80103003:	7e 1c                	jle    80103021 <initlog+0x71>
80103005:	c1 e3 02             	shl    $0x2,%ebx
80103008:	31 d2                	xor    %edx,%edx
8010300a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103010:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103014:	83 c2 04             	add    $0x4,%edx
80103017:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010301d:	39 d3                	cmp    %edx,%ebx
8010301f:	75 ef                	jne    80103010 <initlog+0x60>
  brelse(buf);
80103021:	83 ec 0c             	sub    $0xc,%esp
80103024:	50                   	push   %eax
80103025:	e8 b6 d1 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010302a:	e8 81 fe ff ff       	call   80102eb0 <install_trans>
  log.lh.n = 0;
8010302f:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80103036:	00 00 00 
  write_head(); // clear the log
80103039:	e8 12 ff ff ff       	call   80102f50 <write_head>
}
8010303e:	83 c4 10             	add    $0x10,%esp
80103041:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103044:	c9                   	leave  
80103045:	c3                   	ret    
80103046:	8d 76 00             	lea    0x0(%esi),%esi
80103049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103050 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103056:	68 a0 36 11 80       	push   $0x801136a0
8010305b:	e8 70 1c 00 00       	call   80104cd0 <acquire>
80103060:	83 c4 10             	add    $0x10,%esp
80103063:	eb 18                	jmp    8010307d <begin_op+0x2d>
80103065:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103068:	83 ec 08             	sub    $0x8,%esp
8010306b:	68 a0 36 11 80       	push   $0x801136a0
80103070:	68 a0 36 11 80       	push   $0x801136a0
80103075:	e8 e6 16 00 00       	call   80104760 <sleep>
8010307a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010307d:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80103082:	85 c0                	test   %eax,%eax
80103084:	75 e2                	jne    80103068 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103086:	a1 dc 36 11 80       	mov    0x801136dc,%eax
8010308b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80103091:	83 c0 01             	add    $0x1,%eax
80103094:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103097:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010309a:	83 fa 1e             	cmp    $0x1e,%edx
8010309d:	7f c9                	jg     80103068 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010309f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801030a2:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
801030a7:	68 a0 36 11 80       	push   $0x801136a0
801030ac:	e8 df 1c 00 00       	call   80104d90 <release>
      break;
    }
  }
}
801030b1:	83 c4 10             	add    $0x10,%esp
801030b4:	c9                   	leave  
801030b5:	c3                   	ret    
801030b6:	8d 76 00             	lea    0x0(%esi),%esi
801030b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030c0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	57                   	push   %edi
801030c4:	56                   	push   %esi
801030c5:	53                   	push   %ebx
801030c6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801030c9:	68 a0 36 11 80       	push   $0x801136a0
801030ce:	e8 fd 1b 00 00       	call   80104cd0 <acquire>
  log.outstanding -= 1;
801030d3:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
801030d8:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
801030de:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801030e1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
801030e4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
801030e6:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
801030ec:	0f 85 1a 01 00 00    	jne    8010320c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
801030f2:	85 db                	test   %ebx,%ebx
801030f4:	0f 85 ee 00 00 00    	jne    801031e8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801030fa:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
801030fd:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80103104:	00 00 00 
  release(&log.lock);
80103107:	68 a0 36 11 80       	push   $0x801136a0
8010310c:	e8 7f 1c 00 00       	call   80104d90 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103111:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80103117:	83 c4 10             	add    $0x10,%esp
8010311a:	85 c9                	test   %ecx,%ecx
8010311c:	0f 8e 85 00 00 00    	jle    801031a7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103122:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80103127:	83 ec 08             	sub    $0x8,%esp
8010312a:	01 d8                	add    %ebx,%eax
8010312c:	83 c0 01             	add    $0x1,%eax
8010312f:	50                   	push   %eax
80103130:	ff 35 e4 36 11 80    	pushl  0x801136e4
80103136:	e8 95 cf ff ff       	call   801000d0 <bread>
8010313b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010313d:	58                   	pop    %eax
8010313e:	5a                   	pop    %edx
8010313f:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80103146:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010314c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010314f:	e8 7c cf ff ff       	call   801000d0 <bread>
80103154:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103156:	8d 40 5c             	lea    0x5c(%eax),%eax
80103159:	83 c4 0c             	add    $0xc,%esp
8010315c:	68 00 02 00 00       	push   $0x200
80103161:	50                   	push   %eax
80103162:	8d 46 5c             	lea    0x5c(%esi),%eax
80103165:	50                   	push   %eax
80103166:	e8 25 1d 00 00       	call   80104e90 <memmove>
    bwrite(to);  // write the log
8010316b:	89 34 24             	mov    %esi,(%esp)
8010316e:	e8 2d d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103173:	89 3c 24             	mov    %edi,(%esp)
80103176:	e8 65 d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010317b:	89 34 24             	mov    %esi,(%esp)
8010317e:	e8 5d d0 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103183:	83 c4 10             	add    $0x10,%esp
80103186:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
8010318c:	7c 94                	jl     80103122 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010318e:	e8 bd fd ff ff       	call   80102f50 <write_head>
    install_trans(); // Now install writes to home locations
80103193:	e8 18 fd ff ff       	call   80102eb0 <install_trans>
    log.lh.n = 0;
80103198:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
8010319f:	00 00 00 
    write_head();    // Erase the transaction from the log
801031a2:	e8 a9 fd ff ff       	call   80102f50 <write_head>
    acquire(&log.lock);
801031a7:	83 ec 0c             	sub    $0xc,%esp
801031aa:	68 a0 36 11 80       	push   $0x801136a0
801031af:	e8 1c 1b 00 00       	call   80104cd0 <acquire>
    wakeup(&log);
801031b4:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
801031bb:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
801031c2:	00 00 00 
    wakeup(&log);
801031c5:	e8 56 17 00 00       	call   80104920 <wakeup>
    release(&log.lock);
801031ca:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
801031d1:	e8 ba 1b 00 00       	call   80104d90 <release>
801031d6:	83 c4 10             	add    $0x10,%esp
}
801031d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031dc:	5b                   	pop    %ebx
801031dd:	5e                   	pop    %esi
801031de:	5f                   	pop    %edi
801031df:	5d                   	pop    %ebp
801031e0:	c3                   	ret    
801031e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801031e8:	83 ec 0c             	sub    $0xc,%esp
801031eb:	68 a0 36 11 80       	push   $0x801136a0
801031f0:	e8 2b 17 00 00       	call   80104920 <wakeup>
  release(&log.lock);
801031f5:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
801031fc:	e8 8f 1b 00 00       	call   80104d90 <release>
80103201:	83 c4 10             	add    $0x10,%esp
}
80103204:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103207:	5b                   	pop    %ebx
80103208:	5e                   	pop    %esi
80103209:	5f                   	pop    %edi
8010320a:	5d                   	pop    %ebp
8010320b:	c3                   	ret    
    panic("log.committing");
8010320c:	83 ec 0c             	sub    $0xc,%esp
8010320f:	68 04 7f 10 80       	push   $0x80107f04
80103214:	e8 77 d1 ff ff       	call   80100390 <panic>
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103220 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	53                   	push   %ebx
80103224:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103227:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
8010322d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103230:	83 fa 1d             	cmp    $0x1d,%edx
80103233:	0f 8f 9d 00 00 00    	jg     801032d6 <log_write+0xb6>
80103239:	a1 d8 36 11 80       	mov    0x801136d8,%eax
8010323e:	83 e8 01             	sub    $0x1,%eax
80103241:	39 c2                	cmp    %eax,%edx
80103243:	0f 8d 8d 00 00 00    	jge    801032d6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103249:	a1 dc 36 11 80       	mov    0x801136dc,%eax
8010324e:	85 c0                	test   %eax,%eax
80103250:	0f 8e 8d 00 00 00    	jle    801032e3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103256:	83 ec 0c             	sub    $0xc,%esp
80103259:	68 a0 36 11 80       	push   $0x801136a0
8010325e:	e8 6d 1a 00 00       	call   80104cd0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103263:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80103269:	83 c4 10             	add    $0x10,%esp
8010326c:	83 f9 00             	cmp    $0x0,%ecx
8010326f:	7e 57                	jle    801032c8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103271:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103274:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103276:	3b 15 ec 36 11 80    	cmp    0x801136ec,%edx
8010327c:	75 0b                	jne    80103289 <log_write+0x69>
8010327e:	eb 38                	jmp    801032b8 <log_write+0x98>
80103280:	39 14 85 ec 36 11 80 	cmp    %edx,-0x7feec914(,%eax,4)
80103287:	74 2f                	je     801032b8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103289:	83 c0 01             	add    $0x1,%eax
8010328c:	39 c1                	cmp    %eax,%ecx
8010328e:	75 f0                	jne    80103280 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103290:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103297:	83 c0 01             	add    $0x1,%eax
8010329a:	a3 e8 36 11 80       	mov    %eax,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
8010329f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801032a2:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
801032a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032ac:	c9                   	leave  
  release(&log.lock);
801032ad:	e9 de 1a 00 00       	jmp    80104d90 <release>
801032b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801032b8:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
801032bf:	eb de                	jmp    8010329f <log_write+0x7f>
801032c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032c8:	8b 43 08             	mov    0x8(%ebx),%eax
801032cb:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
801032d0:	75 cd                	jne    8010329f <log_write+0x7f>
801032d2:	31 c0                	xor    %eax,%eax
801032d4:	eb c1                	jmp    80103297 <log_write+0x77>
    panic("too big a transaction");
801032d6:	83 ec 0c             	sub    $0xc,%esp
801032d9:	68 13 7f 10 80       	push   $0x80107f13
801032de:	e8 ad d0 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801032e3:	83 ec 0c             	sub    $0xc,%esp
801032e6:	68 29 7f 10 80       	push   $0x80107f29
801032eb:	e8 a0 d0 ff ff       	call   80100390 <panic>

801032f0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	53                   	push   %ebx
801032f4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801032f7:	e8 c4 0a 00 00       	call   80103dc0 <cpuid>
801032fc:	89 c3                	mov    %eax,%ebx
801032fe:	e8 bd 0a 00 00       	call   80103dc0 <cpuid>
80103303:	83 ec 04             	sub    $0x4,%esp
80103306:	53                   	push   %ebx
80103307:	50                   	push   %eax
80103308:	68 44 7f 10 80       	push   $0x80107f44
8010330d:	e8 4e d3 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103312:	e8 b9 2d 00 00       	call   801060d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103317:	e8 24 0a 00 00       	call   80103d40 <mycpu>
8010331c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010331e:	b8 01 00 00 00       	mov    $0x1,%eax
80103323:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010332a:	e8 11 11 00 00       	call   80104440 <scheduler>
8010332f:	90                   	nop

80103330 <mpenter>:
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103336:	e8 e5 3d 00 00       	call   80107120 <switchkvm>
  seginit();
8010333b:	e8 50 3d 00 00       	call   80107090 <seginit>
  lapicinit();
80103340:	e8 9b f7 ff ff       	call   80102ae0 <lapicinit>
  mpmain();
80103345:	e8 a6 ff ff ff       	call   801032f0 <mpmain>
8010334a:	66 90                	xchg   %ax,%ax
8010334c:	66 90                	xchg   %ax,%ax
8010334e:	66 90                	xchg   %ax,%ax

80103350 <main>:
{
80103350:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103354:	83 e4 f0             	and    $0xfffffff0,%esp
80103357:	ff 71 fc             	pushl  -0x4(%ecx)
8010335a:	55                   	push   %ebp
8010335b:	89 e5                	mov    %esp,%ebp
8010335d:	53                   	push   %ebx
8010335e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010335f:	83 ec 08             	sub    $0x8,%esp
80103362:	68 00 00 40 80       	push   $0x80400000
80103367:	68 c8 01 12 80       	push   $0x801201c8
8010336c:	e8 ef f4 ff ff       	call   80102860 <kinit1>
  kvmalloc();      // kernel page table
80103371:	e8 3a 44 00 00       	call   801077b0 <kvmalloc>
  mpinit();        // detect other processors
80103376:	e8 75 01 00 00       	call   801034f0 <mpinit>
  lapicinit();     // interrupt controller
8010337b:	e8 60 f7 ff ff       	call   80102ae0 <lapicinit>
  seginit();       // segment descriptors
80103380:	e8 0b 3d 00 00       	call   80107090 <seginit>
  picinit();       // disable pic
80103385:	e8 46 03 00 00       	call   801036d0 <picinit>
  ioapicinit();    // another interrupt controller
8010338a:	e8 f1 f2 ff ff       	call   80102680 <ioapicinit>
  consoleinit();   // console hardware
8010338f:	e8 2c d6 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103394:	e8 67 30 00 00       	call   80106400 <uartinit>
  pinit();         // process table
80103399:	e8 82 09 00 00       	call   80103d20 <pinit>
  tvinit();        // trap vectors
8010339e:	e8 ad 2c 00 00       	call   80106050 <tvinit>
  binit();         // buffer cache
801033a3:	e8 98 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
801033a8:	e8 83 da ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk 
801033ad:	e8 ae f0 ff ff       	call   80102460 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801033b2:	83 c4 0c             	add    $0xc,%esp
801033b5:	68 8a 00 00 00       	push   $0x8a
801033ba:	68 8c b4 10 80       	push   $0x8010b48c
801033bf:	68 00 70 00 80       	push   $0x80007000
801033c4:	e8 c7 1a 00 00       	call   80104e90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801033c9:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
801033d0:	00 00 00 
801033d3:	83 c4 10             	add    $0x10,%esp
801033d6:	05 a0 37 11 80       	add    $0x801137a0,%eax
801033db:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
801033e0:	76 71                	jbe    80103453 <main+0x103>
801033e2:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
801033e7:	89 f6                	mov    %esi,%esi
801033e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801033f0:	e8 4b 09 00 00       	call   80103d40 <mycpu>
801033f5:	39 d8                	cmp    %ebx,%eax
801033f7:	74 41                	je     8010343a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801033f9:	e8 62 f5 ff ff       	call   80102960 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801033fe:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103403:	c7 05 f8 6f 00 80 30 	movl   $0x80103330,0x80006ff8
8010340a:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010340d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103414:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103417:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010341c:	0f b6 03             	movzbl (%ebx),%eax
8010341f:	83 ec 08             	sub    $0x8,%esp
80103422:	68 00 70 00 00       	push   $0x7000
80103427:	50                   	push   %eax
80103428:	e8 03 f8 ff ff       	call   80102c30 <lapicstartap>
8010342d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103430:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103436:	85 c0                	test   %eax,%eax
80103438:	74 f6                	je     80103430 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010343a:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103441:	00 00 00 
80103444:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010344a:	05 a0 37 11 80       	add    $0x801137a0,%eax
8010344f:	39 c3                	cmp    %eax,%ebx
80103451:	72 9d                	jb     801033f0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103453:	83 ec 08             	sub    $0x8,%esp
80103456:	68 00 00 00 8e       	push   $0x8e000000
8010345b:	68 00 00 40 80       	push   $0x80400000
80103460:	e8 7b f4 ff ff       	call   801028e0 <kinit2>
  userinit();      // first user process
80103465:	e8 a6 09 00 00       	call   80103e10 <userinit>
  mpmain();        // finish this processor's setup
8010346a:	e8 81 fe ff ff       	call   801032f0 <mpmain>
8010346f:	90                   	nop

80103470 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	57                   	push   %edi
80103474:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103475:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010347b:	53                   	push   %ebx
  e = addr+len;
8010347c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010347f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103482:	39 de                	cmp    %ebx,%esi
80103484:	72 10                	jb     80103496 <mpsearch1+0x26>
80103486:	eb 50                	jmp    801034d8 <mpsearch1+0x68>
80103488:	90                   	nop
80103489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103490:	39 fb                	cmp    %edi,%ebx
80103492:	89 fe                	mov    %edi,%esi
80103494:	76 42                	jbe    801034d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103496:	83 ec 04             	sub    $0x4,%esp
80103499:	8d 7e 10             	lea    0x10(%esi),%edi
8010349c:	6a 04                	push   $0x4
8010349e:	68 58 7f 10 80       	push   $0x80107f58
801034a3:	56                   	push   %esi
801034a4:	e8 87 19 00 00       	call   80104e30 <memcmp>
801034a9:	83 c4 10             	add    $0x10,%esp
801034ac:	85 c0                	test   %eax,%eax
801034ae:	75 e0                	jne    80103490 <mpsearch1+0x20>
801034b0:	89 f1                	mov    %esi,%ecx
801034b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801034b8:	0f b6 11             	movzbl (%ecx),%edx
801034bb:	83 c1 01             	add    $0x1,%ecx
801034be:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801034c0:	39 f9                	cmp    %edi,%ecx
801034c2:	75 f4                	jne    801034b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034c4:	84 c0                	test   %al,%al
801034c6:	75 c8                	jne    80103490 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801034c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034cb:	89 f0                	mov    %esi,%eax
801034cd:	5b                   	pop    %ebx
801034ce:	5e                   	pop    %esi
801034cf:	5f                   	pop    %edi
801034d0:	5d                   	pop    %ebp
801034d1:	c3                   	ret    
801034d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034db:	31 f6                	xor    %esi,%esi
}
801034dd:	89 f0                	mov    %esi,%eax
801034df:	5b                   	pop    %ebx
801034e0:	5e                   	pop    %esi
801034e1:	5f                   	pop    %edi
801034e2:	5d                   	pop    %ebp
801034e3:	c3                   	ret    
801034e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801034f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	57                   	push   %edi
801034f4:	56                   	push   %esi
801034f5:	53                   	push   %ebx
801034f6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801034f9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103500:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103507:	c1 e0 08             	shl    $0x8,%eax
8010350a:	09 d0                	or     %edx,%eax
8010350c:	c1 e0 04             	shl    $0x4,%eax
8010350f:	85 c0                	test   %eax,%eax
80103511:	75 1b                	jne    8010352e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103513:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010351a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103521:	c1 e0 08             	shl    $0x8,%eax
80103524:	09 d0                	or     %edx,%eax
80103526:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103529:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010352e:	ba 00 04 00 00       	mov    $0x400,%edx
80103533:	e8 38 ff ff ff       	call   80103470 <mpsearch1>
80103538:	85 c0                	test   %eax,%eax
8010353a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010353d:	0f 84 3d 01 00 00    	je     80103680 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103546:	8b 58 04             	mov    0x4(%eax),%ebx
80103549:	85 db                	test   %ebx,%ebx
8010354b:	0f 84 4f 01 00 00    	je     801036a0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103551:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103557:	83 ec 04             	sub    $0x4,%esp
8010355a:	6a 04                	push   $0x4
8010355c:	68 75 7f 10 80       	push   $0x80107f75
80103561:	56                   	push   %esi
80103562:	e8 c9 18 00 00       	call   80104e30 <memcmp>
80103567:	83 c4 10             	add    $0x10,%esp
8010356a:	85 c0                	test   %eax,%eax
8010356c:	0f 85 2e 01 00 00    	jne    801036a0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103572:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103579:	3c 01                	cmp    $0x1,%al
8010357b:	0f 95 c2             	setne  %dl
8010357e:	3c 04                	cmp    $0x4,%al
80103580:	0f 95 c0             	setne  %al
80103583:	20 c2                	and    %al,%dl
80103585:	0f 85 15 01 00 00    	jne    801036a0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010358b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103592:	66 85 ff             	test   %di,%di
80103595:	74 1a                	je     801035b1 <mpinit+0xc1>
80103597:	89 f0                	mov    %esi,%eax
80103599:	01 f7                	add    %esi,%edi
  sum = 0;
8010359b:	31 d2                	xor    %edx,%edx
8010359d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035a0:	0f b6 08             	movzbl (%eax),%ecx
801035a3:	83 c0 01             	add    $0x1,%eax
801035a6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801035a8:	39 c7                	cmp    %eax,%edi
801035aa:	75 f4                	jne    801035a0 <mpinit+0xb0>
801035ac:	84 d2                	test   %dl,%dl
801035ae:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801035b1:	85 f6                	test   %esi,%esi
801035b3:	0f 84 e7 00 00 00    	je     801036a0 <mpinit+0x1b0>
801035b9:	84 d2                	test   %dl,%dl
801035bb:	0f 85 df 00 00 00    	jne    801036a0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801035c1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801035c7:	a3 84 36 11 80       	mov    %eax,0x80113684
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035cc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801035d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801035d9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035de:	01 d6                	add    %edx,%esi
801035e0:	39 c6                	cmp    %eax,%esi
801035e2:	76 23                	jbe    80103607 <mpinit+0x117>
    switch(*p){
801035e4:	0f b6 10             	movzbl (%eax),%edx
801035e7:	80 fa 04             	cmp    $0x4,%dl
801035ea:	0f 87 ca 00 00 00    	ja     801036ba <mpinit+0x1ca>
801035f0:	ff 24 95 9c 7f 10 80 	jmp    *-0x7fef8064(,%edx,4)
801035f7:	89 f6                	mov    %esi,%esi
801035f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103600:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103603:	39 c6                	cmp    %eax,%esi
80103605:	77 dd                	ja     801035e4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103607:	85 db                	test   %ebx,%ebx
80103609:	0f 84 9e 00 00 00    	je     801036ad <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010360f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103612:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103616:	74 15                	je     8010362d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103618:	b8 70 00 00 00       	mov    $0x70,%eax
8010361d:	ba 22 00 00 00       	mov    $0x22,%edx
80103622:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103623:	ba 23 00 00 00       	mov    $0x23,%edx
80103628:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103629:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010362c:	ee                   	out    %al,(%dx)
  }
}
8010362d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103630:	5b                   	pop    %ebx
80103631:	5e                   	pop    %esi
80103632:	5f                   	pop    %edi
80103633:	5d                   	pop    %ebp
80103634:	c3                   	ret    
80103635:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103638:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
8010363e:	83 f9 07             	cmp    $0x7,%ecx
80103641:	7f 19                	jg     8010365c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103643:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103647:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010364d:	83 c1 01             	add    $0x1,%ecx
80103650:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103656:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
8010365c:	83 c0 14             	add    $0x14,%eax
      continue;
8010365f:	e9 7c ff ff ff       	jmp    801035e0 <mpinit+0xf0>
80103664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103668:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010366c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010366f:	88 15 80 37 11 80    	mov    %dl,0x80113780
      continue;
80103675:	e9 66 ff ff ff       	jmp    801035e0 <mpinit+0xf0>
8010367a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103680:	ba 00 00 01 00       	mov    $0x10000,%edx
80103685:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010368a:	e8 e1 fd ff ff       	call   80103470 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010368f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103691:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103694:	0f 85 a9 fe ff ff    	jne    80103543 <mpinit+0x53>
8010369a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	68 5d 7f 10 80       	push   $0x80107f5d
801036a8:	e8 e3 cc ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801036ad:	83 ec 0c             	sub    $0xc,%esp
801036b0:	68 7c 7f 10 80       	push   $0x80107f7c
801036b5:	e8 d6 cc ff ff       	call   80100390 <panic>
      ismp = 0;
801036ba:	31 db                	xor    %ebx,%ebx
801036bc:	e9 26 ff ff ff       	jmp    801035e7 <mpinit+0xf7>
801036c1:	66 90                	xchg   %ax,%ax
801036c3:	66 90                	xchg   %ax,%ax
801036c5:	66 90                	xchg   %ax,%ax
801036c7:	66 90                	xchg   %ax,%ax
801036c9:	66 90                	xchg   %ax,%ax
801036cb:	66 90                	xchg   %ax,%ax
801036cd:	66 90                	xchg   %ax,%ax
801036cf:	90                   	nop

801036d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801036d0:	55                   	push   %ebp
801036d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036d6:	ba 21 00 00 00       	mov    $0x21,%edx
801036db:	89 e5                	mov    %esp,%ebp
801036dd:	ee                   	out    %al,(%dx)
801036de:	ba a1 00 00 00       	mov    $0xa1,%edx
801036e3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801036e4:	5d                   	pop    %ebp
801036e5:	c3                   	ret    
801036e6:	66 90                	xchg   %ax,%ax
801036e8:	66 90                	xchg   %ax,%ax
801036ea:	66 90                	xchg   %ax,%ax
801036ec:	66 90                	xchg   %ax,%ax
801036ee:	66 90                	xchg   %ax,%ax

801036f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	57                   	push   %edi
801036f4:	56                   	push   %esi
801036f5:	53                   	push   %ebx
801036f6:	83 ec 0c             	sub    $0xc,%esp
801036f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801036ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103705:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010370b:	e8 40 d7 ff ff       	call   80100e50 <filealloc>
80103710:	85 c0                	test   %eax,%eax
80103712:	89 03                	mov    %eax,(%ebx)
80103714:	74 22                	je     80103738 <pipealloc+0x48>
80103716:	e8 35 d7 ff ff       	call   80100e50 <filealloc>
8010371b:	85 c0                	test   %eax,%eax
8010371d:	89 06                	mov    %eax,(%esi)
8010371f:	74 3f                	je     80103760 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103721:	e8 3a f2 ff ff       	call   80102960 <kalloc>
80103726:	85 c0                	test   %eax,%eax
80103728:	89 c7                	mov    %eax,%edi
8010372a:	75 54                	jne    80103780 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010372c:	8b 03                	mov    (%ebx),%eax
8010372e:	85 c0                	test   %eax,%eax
80103730:	75 34                	jne    80103766 <pipealloc+0x76>
80103732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103738:	8b 06                	mov    (%esi),%eax
8010373a:	85 c0                	test   %eax,%eax
8010373c:	74 0c                	je     8010374a <pipealloc+0x5a>
    fileclose(*f1);
8010373e:	83 ec 0c             	sub    $0xc,%esp
80103741:	50                   	push   %eax
80103742:	e8 c9 d7 ff ff       	call   80100f10 <fileclose>
80103747:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010374a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010374d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103752:	5b                   	pop    %ebx
80103753:	5e                   	pop    %esi
80103754:	5f                   	pop    %edi
80103755:	5d                   	pop    %ebp
80103756:	c3                   	ret    
80103757:	89 f6                	mov    %esi,%esi
80103759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103760:	8b 03                	mov    (%ebx),%eax
80103762:	85 c0                	test   %eax,%eax
80103764:	74 e4                	je     8010374a <pipealloc+0x5a>
    fileclose(*f0);
80103766:	83 ec 0c             	sub    $0xc,%esp
80103769:	50                   	push   %eax
8010376a:	e8 a1 d7 ff ff       	call   80100f10 <fileclose>
  if(*f1)
8010376f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103771:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103774:	85 c0                	test   %eax,%eax
80103776:	75 c6                	jne    8010373e <pipealloc+0x4e>
80103778:	eb d0                	jmp    8010374a <pipealloc+0x5a>
8010377a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103780:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103783:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010378a:	00 00 00 
  p->writeopen = 1;
8010378d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103794:	00 00 00 
  p->nwrite = 0;
80103797:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010379e:	00 00 00 
  p->nread = 0;
801037a1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801037a8:	00 00 00 
  initlock(&p->lock, "pipe");
801037ab:	68 b0 7f 10 80       	push   $0x80107fb0
801037b0:	50                   	push   %eax
801037b1:	e8 da 13 00 00       	call   80104b90 <initlock>
  (*f0)->type = FD_PIPE;
801037b6:	8b 03                	mov    (%ebx),%eax
  return 0;
801037b8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801037bb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801037c1:	8b 03                	mov    (%ebx),%eax
801037c3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801037c7:	8b 03                	mov    (%ebx),%eax
801037c9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801037cd:	8b 03                	mov    (%ebx),%eax
801037cf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801037d2:	8b 06                	mov    (%esi),%eax
801037d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801037da:	8b 06                	mov    (%esi),%eax
801037dc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801037e0:	8b 06                	mov    (%esi),%eax
801037e2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801037e6:	8b 06                	mov    (%esi),%eax
801037e8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801037eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801037ee:	31 c0                	xor    %eax,%eax
}
801037f0:	5b                   	pop    %ebx
801037f1:	5e                   	pop    %esi
801037f2:	5f                   	pop    %edi
801037f3:	5d                   	pop    %ebp
801037f4:	c3                   	ret    
801037f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103800 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
80103805:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103808:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010380b:	83 ec 0c             	sub    $0xc,%esp
8010380e:	53                   	push   %ebx
8010380f:	e8 bc 14 00 00       	call   80104cd0 <acquire>
  if(writable){
80103814:	83 c4 10             	add    $0x10,%esp
80103817:	85 f6                	test   %esi,%esi
80103819:	74 45                	je     80103860 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010381b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103821:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103824:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010382b:	00 00 00 
    wakeup(&p->nread);
8010382e:	50                   	push   %eax
8010382f:	e8 ec 10 00 00       	call   80104920 <wakeup>
80103834:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103837:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010383d:	85 d2                	test   %edx,%edx
8010383f:	75 0a                	jne    8010384b <pipeclose+0x4b>
80103841:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103847:	85 c0                	test   %eax,%eax
80103849:	74 35                	je     80103880 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010384b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010384e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103851:	5b                   	pop    %ebx
80103852:	5e                   	pop    %esi
80103853:	5d                   	pop    %ebp
    release(&p->lock);
80103854:	e9 37 15 00 00       	jmp    80104d90 <release>
80103859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103860:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103866:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103869:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103870:	00 00 00 
    wakeup(&p->nwrite);
80103873:	50                   	push   %eax
80103874:	e8 a7 10 00 00       	call   80104920 <wakeup>
80103879:	83 c4 10             	add    $0x10,%esp
8010387c:	eb b9                	jmp    80103837 <pipeclose+0x37>
8010387e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
80103883:	53                   	push   %ebx
80103884:	e8 07 15 00 00       	call   80104d90 <release>
    kfree((char*)p);
80103889:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010388c:	83 c4 10             	add    $0x10,%esp
}
8010388f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103892:	5b                   	pop    %ebx
80103893:	5e                   	pop    %esi
80103894:	5d                   	pop    %ebp
    kfree((char*)p);
80103895:	e9 d6 ee ff ff       	jmp    80102770 <kfree>
8010389a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	57                   	push   %edi
801038a4:	56                   	push   %esi
801038a5:	53                   	push   %ebx
801038a6:	83 ec 28             	sub    $0x28,%esp
801038a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801038ac:	53                   	push   %ebx
801038ad:	e8 1e 14 00 00       	call   80104cd0 <acquire>
  for(i = 0; i < n; i++){
801038b2:	8b 45 10             	mov    0x10(%ebp),%eax
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	85 c0                	test   %eax,%eax
801038ba:	0f 8e c9 00 00 00    	jle    80103989 <pipewrite+0xe9>
801038c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801038c3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801038c9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801038cf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801038d2:	03 4d 10             	add    0x10(%ebp),%ecx
801038d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038d8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801038de:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801038e4:	39 d0                	cmp    %edx,%eax
801038e6:	75 71                	jne    80103959 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801038e8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801038ee:	85 c0                	test   %eax,%eax
801038f0:	74 4e                	je     80103940 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801038f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801038f8:	eb 3a                	jmp    80103934 <pipewrite+0x94>
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103900:	83 ec 0c             	sub    $0xc,%esp
80103903:	57                   	push   %edi
80103904:	e8 17 10 00 00       	call   80104920 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103909:	5a                   	pop    %edx
8010390a:	59                   	pop    %ecx
8010390b:	53                   	push   %ebx
8010390c:	56                   	push   %esi
8010390d:	e8 4e 0e 00 00       	call   80104760 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103912:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103918:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010391e:	83 c4 10             	add    $0x10,%esp
80103921:	05 00 02 00 00       	add    $0x200,%eax
80103926:	39 c2                	cmp    %eax,%edx
80103928:	75 36                	jne    80103960 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010392a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103930:	85 c0                	test   %eax,%eax
80103932:	74 0c                	je     80103940 <pipewrite+0xa0>
80103934:	e8 a7 04 00 00       	call   80103de0 <myproc>
80103939:	8b 40 24             	mov    0x24(%eax),%eax
8010393c:	85 c0                	test   %eax,%eax
8010393e:	74 c0                	je     80103900 <pipewrite+0x60>
        release(&p->lock);
80103940:	83 ec 0c             	sub    $0xc,%esp
80103943:	53                   	push   %ebx
80103944:	e8 47 14 00 00       	call   80104d90 <release>
        return -1;
80103949:	83 c4 10             	add    $0x10,%esp
8010394c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103951:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103954:	5b                   	pop    %ebx
80103955:	5e                   	pop    %esi
80103956:	5f                   	pop    %edi
80103957:	5d                   	pop    %ebp
80103958:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103959:	89 c2                	mov    %eax,%edx
8010395b:	90                   	nop
8010395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103960:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103963:	8d 42 01             	lea    0x1(%edx),%eax
80103966:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010396c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103972:	83 c6 01             	add    $0x1,%esi
80103975:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103979:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010397c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010397f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103983:	0f 85 4f ff ff ff    	jne    801038d8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103989:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010398f:	83 ec 0c             	sub    $0xc,%esp
80103992:	50                   	push   %eax
80103993:	e8 88 0f 00 00       	call   80104920 <wakeup>
  release(&p->lock);
80103998:	89 1c 24             	mov    %ebx,(%esp)
8010399b:	e8 f0 13 00 00       	call   80104d90 <release>
  return n;
801039a0:	83 c4 10             	add    $0x10,%esp
801039a3:	8b 45 10             	mov    0x10(%ebp),%eax
801039a6:	eb a9                	jmp    80103951 <pipewrite+0xb1>
801039a8:	90                   	nop
801039a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	57                   	push   %edi
801039b4:	56                   	push   %esi
801039b5:	53                   	push   %ebx
801039b6:	83 ec 18             	sub    $0x18,%esp
801039b9:	8b 75 08             	mov    0x8(%ebp),%esi
801039bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801039bf:	56                   	push   %esi
801039c0:	e8 0b 13 00 00       	call   80104cd0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801039c5:	83 c4 10             	add    $0x10,%esp
801039c8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801039ce:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801039d4:	75 6a                	jne    80103a40 <piperead+0x90>
801039d6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801039dc:	85 db                	test   %ebx,%ebx
801039de:	0f 84 c4 00 00 00    	je     80103aa8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801039e4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801039ea:	eb 2d                	jmp    80103a19 <piperead+0x69>
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039f0:	83 ec 08             	sub    $0x8,%esp
801039f3:	56                   	push   %esi
801039f4:	53                   	push   %ebx
801039f5:	e8 66 0d 00 00       	call   80104760 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801039fa:	83 c4 10             	add    $0x10,%esp
801039fd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a03:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a09:	75 35                	jne    80103a40 <piperead+0x90>
80103a0b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103a11:	85 d2                	test   %edx,%edx
80103a13:	0f 84 8f 00 00 00    	je     80103aa8 <piperead+0xf8>
    if(myproc()->killed){
80103a19:	e8 c2 03 00 00       	call   80103de0 <myproc>
80103a1e:	8b 48 24             	mov    0x24(%eax),%ecx
80103a21:	85 c9                	test   %ecx,%ecx
80103a23:	74 cb                	je     801039f0 <piperead+0x40>
      release(&p->lock);
80103a25:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103a28:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103a2d:	56                   	push   %esi
80103a2e:	e8 5d 13 00 00       	call   80104d90 <release>
      return -1;
80103a33:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103a36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a39:	89 d8                	mov    %ebx,%eax
80103a3b:	5b                   	pop    %ebx
80103a3c:	5e                   	pop    %esi
80103a3d:	5f                   	pop    %edi
80103a3e:	5d                   	pop    %ebp
80103a3f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a40:	8b 45 10             	mov    0x10(%ebp),%eax
80103a43:	85 c0                	test   %eax,%eax
80103a45:	7e 61                	jle    80103aa8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103a47:	31 db                	xor    %ebx,%ebx
80103a49:	eb 13                	jmp    80103a5e <piperead+0xae>
80103a4b:	90                   	nop
80103a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a50:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a56:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a5c:	74 1f                	je     80103a7d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a5e:	8d 41 01             	lea    0x1(%ecx),%eax
80103a61:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103a67:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103a6d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103a72:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a75:	83 c3 01             	add    $0x1,%ebx
80103a78:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a7b:	75 d3                	jne    80103a50 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a7d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103a83:	83 ec 0c             	sub    $0xc,%esp
80103a86:	50                   	push   %eax
80103a87:	e8 94 0e 00 00       	call   80104920 <wakeup>
  release(&p->lock);
80103a8c:	89 34 24             	mov    %esi,(%esp)
80103a8f:	e8 fc 12 00 00       	call   80104d90 <release>
  return i;
80103a94:	83 c4 10             	add    $0x10,%esp
}
80103a97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a9a:	89 d8                	mov    %ebx,%eax
80103a9c:	5b                   	pop    %ebx
80103a9d:	5e                   	pop    %esi
80103a9e:	5f                   	pop    %edi
80103a9f:	5d                   	pop    %ebp
80103aa0:	c3                   	ret    
80103aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aa8:	31 db                	xor    %ebx,%ebx
80103aaa:	eb d1                	jmp    80103a7d <piperead+0xcd>
80103aac:	66 90                	xchg   %ax,%ax
80103aae:	66 90                	xchg   %ax,%ax

80103ab0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ab4:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
80103ab9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103abc:	68 40 3d 11 80       	push   $0x80113d40
80103ac1:	e8 0a 12 00 00       	call   80104cd0 <acquire>
80103ac6:	83 c4 10             	add    $0x10,%esp
80103ac9:	eb 17                	jmp    80103ae2 <allocproc+0x32>
80103acb:	90                   	nop
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ad0:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
80103ad6:	81 fb 74 f9 11 80    	cmp    $0x8011f974,%ebx
80103adc:	0f 83 06 01 00 00    	jae    80103be8 <allocproc+0x138>
    if(p->state == UNUSED)
80103ae2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103ae5:	85 c0                	test   %eax,%eax
80103ae7:	75 e7                	jne    80103ad0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103ae9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103aee:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103af1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103af8:	8d 50 01             	lea    0x1(%eax),%edx
80103afb:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103afe:	68 40 3d 11 80       	push   $0x80113d40
  p->pid = nextpid++;
80103b03:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103b09:	e8 82 12 00 00       	call   80104d90 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103b0e:	e8 4d ee ff ff       	call   80102960 <kalloc>
80103b13:	83 c4 10             	add    $0x10,%esp
80103b16:	85 c0                	test   %eax,%eax
80103b18:	89 43 08             	mov    %eax,0x8(%ebx)
80103b1b:	0f 84 e0 00 00 00    	je     80103c01 <allocproc+0x151>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b21:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103b27:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103b2a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103b2f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103b32:	c7 40 14 42 60 10 80 	movl   $0x80106042,0x14(%eax)
  p->context = (struct context*)sp;
80103b39:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103b3c:	6a 14                	push   $0x14
80103b3e:	6a 00                	push   $0x0
80103b40:	50                   	push   %eax
80103b41:	e8 9a 12 00 00       	call   80104de0 <memset>
  p->context->eip = (uint)forkret;
80103b46:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103b49:	8d 93 bc 01 00 00    	lea    0x1bc(%ebx),%edx
80103b4f:	83 c4 10             	add    $0x10,%esp
80103b52:	c7 40 10 10 3c 10 80 	movl   $0x80103c10,0x10(%eax)
80103b59:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80103b5f:	90                   	nop

  #ifndef NONE

    int i;
    for (i = 0; i < MAX_PSYC_PAGES; i++) {
      p->swappedPages[i].virtualAddress = (char*)0xffffffff;
80103b60:	c7 80 2c 01 00 00 ff 	movl   $0xffffffff,0x12c(%eax)
80103b67:	ff ff ff 
      p->swappedPages[i].swaploc = 0;
80103b6a:	c7 80 3c 01 00 00 00 	movl   $0x0,0x13c(%eax)
80103b71:	00 00 00 
80103b74:	83 c0 14             	add    $0x14,%eax
      p->swappedPages[i].age = 0;
80103b77:	c7 80 1c 01 00 00 00 	movl   $0x0,0x11c(%eax)
80103b7e:	00 00 00 
      p->freePages[i].virtualAddress = (char*)0xffffffff;
80103b81:	c7 40 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%eax)
      p->freePages[i].next = 0;
80103b88:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
      p->freePages[i].prev = 0;
80103b8f:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
      p->freePages[i].age = 0;
80103b96:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
    for (i = 0; i < MAX_PSYC_PAGES; i++) {
80103b9d:	39 d0                	cmp    %edx,%eax
80103b9f:	75 bf                	jne    80103b60 <allocproc+0xb0>
    }
    p->mainMemoryPageCount = 0;
80103ba1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103ba8:	00 00 00 
    p->totalSwapCount = 0;
80103bab:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103bb2:	00 00 00 
    p->pageFaultCount = 0;   
80103bb5:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103bbc:	00 00 00 
    p->swapFilePageCount = 0;
80103bbf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103bc6:	00 00 00 
    p->head = 0;
80103bc9:	c7 83 e8 02 00 00 00 	movl   $0x0,0x2e8(%ebx)
80103bd0:	00 00 00 
    p->tail = 0;
80103bd3:	c7 83 ec 02 00 00 00 	movl   $0x0,0x2ec(%ebx)
80103bda:	00 00 00 

  #endif

  return p;
}
80103bdd:	89 d8                	mov    %ebx,%eax
80103bdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103be2:	c9                   	leave  
80103be3:	c3                   	ret    
80103be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103be8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103beb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103bed:	68 40 3d 11 80       	push   $0x80113d40
80103bf2:	e8 99 11 00 00       	call   80104d90 <release>
}
80103bf7:	89 d8                	mov    %ebx,%eax
  return 0;
80103bf9:	83 c4 10             	add    $0x10,%esp
}
80103bfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bff:	c9                   	leave  
80103c00:	c3                   	ret    
    p->state = UNUSED;
80103c01:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103c08:	31 db                	xor    %ebx,%ebx
80103c0a:	eb d1                	jmp    80103bdd <allocproc+0x12d>
80103c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c10 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103c16:	68 40 3d 11 80       	push   $0x80113d40
80103c1b:	e8 70 11 00 00       	call   80104d90 <release>

  if (first) {
80103c20:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103c25:	83 c4 10             	add    $0x10,%esp
80103c28:	85 c0                	test   %eax,%eax
80103c2a:	75 04                	jne    80103c30 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103c2c:	c9                   	leave  
80103c2d:	c3                   	ret    
80103c2e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103c30:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103c33:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103c3a:	00 00 00 
    iinit(ROOTDEV);
80103c3d:	6a 01                	push   $0x1
80103c3f:	e8 0c d9 ff ff       	call   80101550 <iinit>
    initlog(ROOTDEV);
80103c44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c4b:	e8 60 f3 ff ff       	call   80102fb0 <initlog>
80103c50:	83 c4 10             	add    $0x10,%esp
}
80103c53:	c9                   	leave  
80103c54:	c3                   	ret    
80103c55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c60 <updateNFUState>:
void updateNFUState(){
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
80103c65:	53                   	push   %ebx
  for(p = ptable.proc; p< &ptable.proc[NPROC]; p++){
80103c66:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
void updateNFUState(){
80103c6b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80103c6e:	68 40 3d 11 80       	push   $0x80113d40
80103c73:	e8 58 10 00 00       	call   80104cd0 <acquire>
80103c78:	83 c4 10             	add    $0x10,%esp
80103c7b:	eb 11                	jmp    80103c8e <updateNFUState+0x2e>
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p< &ptable.proc[NPROC]; p++){
80103c80:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
80103c86:	81 fb 74 f9 11 80    	cmp    $0x8011f974,%ebx
80103c8c:	73 77                	jae    80103d05 <updateNFUState+0xa5>
    if((p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)){
80103c8e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103c91:	83 e8 02             	sub    $0x2,%eax
80103c94:	83 f8 02             	cmp    $0x2,%eax
80103c97:	77 e7                	ja     80103c80 <updateNFUState+0x20>
80103c99:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80103c9f:	8d b3 bc 01 00 00    	lea    0x1bc(%ebx),%esi
80103ca5:	8d 76 00             	lea    0x0(%esi),%esi
        if(p->freePages[i].virtualAddress == (char*)0xffffffff)
80103ca8:	8b 10                	mov    (%eax),%edx
80103caa:	83 fa ff             	cmp    $0xffffffff,%edx
80103cad:	74 41                	je     80103cf0 <updateNFUState+0x90>
        p->freePages[i].age++;
80103caf:	83 40 04 01          	addl   $0x1,0x4(%eax)
        p->swappedPages[i].age++;
80103cb3:	83 80 30 01 00 00 01 	addl   $0x1,0x130(%eax)
        pde = &p->pgdir[PDX(p->freePages[i].virtualAddress)];
80103cba:	89 d7                	mov    %edx,%edi
        if(*pde & PTE_P){
80103cbc:	8b 4b 04             	mov    0x4(%ebx),%ecx
        pde = &p->pgdir[PDX(p->freePages[i].virtualAddress)];
80103cbf:	c1 ef 16             	shr    $0x16,%edi
        if(*pde & PTE_P){
80103cc2:	8b 0c b9             	mov    (%ecx,%edi,4),%ecx
80103cc5:	f6 c1 01             	test   $0x1,%cl
80103cc8:	74 26                	je     80103cf0 <updateNFUState+0x90>
          pte = &pgtab[PTX(p->freePages[i].virtualAddress)];
80103cca:	c1 ea 0a             	shr    $0xa,%edx
          pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80103ccd:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
          pte = &pgtab[PTX(p->freePages[i].virtualAddress)];
80103cd3:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80103cd9:	8d 94 11 00 00 00 80 	lea    -0x80000000(%ecx,%edx,1),%edx
        if(pte){
80103ce0:	85 d2                	test   %edx,%edx
80103ce2:	74 0c                	je     80103cf0 <updateNFUState+0x90>
          if(*pte & PTE_A){
80103ce4:	f6 02 20             	testb  $0x20,(%edx)
80103ce7:	74 07                	je     80103cf0 <updateNFUState+0x90>
            p->freePages[i].age = 0;
80103ce9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80103cf0:	83 c0 14             	add    $0x14,%eax
      for(i=0; i<MAX_PSYC_PAGES; i++){
80103cf3:	39 f0                	cmp    %esi,%eax
80103cf5:	75 b1                	jne    80103ca8 <updateNFUState+0x48>
  for(p = ptable.proc; p< &ptable.proc[NPROC]; p++){
80103cf7:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
80103cfd:	81 fb 74 f9 11 80    	cmp    $0x8011f974,%ebx
80103d03:	72 89                	jb     80103c8e <updateNFUState+0x2e>
  release(&ptable.lock);
80103d05:	83 ec 0c             	sub    $0xc,%esp
80103d08:	68 40 3d 11 80       	push   $0x80113d40
80103d0d:	e8 7e 10 00 00       	call   80104d90 <release>
}
80103d12:	83 c4 10             	add    $0x10,%esp
80103d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d18:	5b                   	pop    %ebx
80103d19:	5e                   	pop    %esi
80103d1a:	5f                   	pop    %edi
80103d1b:	5d                   	pop    %ebp
80103d1c:	c3                   	ret    
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi

80103d20 <pinit>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103d26:	68 b5 7f 10 80       	push   $0x80107fb5
80103d2b:	68 40 3d 11 80       	push   $0x80113d40
80103d30:	e8 5b 0e 00 00       	call   80104b90 <initlock>
}
80103d35:	83 c4 10             	add    $0x10,%esp
80103d38:	c9                   	leave  
80103d39:	c3                   	ret    
80103d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d40 <mycpu>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	56                   	push   %esi
80103d44:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d45:	9c                   	pushf  
80103d46:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d47:	f6 c4 02             	test   $0x2,%ah
80103d4a:	75 5e                	jne    80103daa <mycpu+0x6a>
  apicid = lapicid();
80103d4c:	e8 8f ee ff ff       	call   80102be0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103d51:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
80103d57:	85 f6                	test   %esi,%esi
80103d59:	7e 42                	jle    80103d9d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103d5b:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103d62:	39 d0                	cmp    %edx,%eax
80103d64:	74 30                	je     80103d96 <mycpu+0x56>
80103d66:	b9 50 38 11 80       	mov    $0x80113850,%ecx
  for (i = 0; i < ncpu; ++i) {
80103d6b:	31 d2                	xor    %edx,%edx
80103d6d:	8d 76 00             	lea    0x0(%esi),%esi
80103d70:	83 c2 01             	add    $0x1,%edx
80103d73:	39 f2                	cmp    %esi,%edx
80103d75:	74 26                	je     80103d9d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103d77:	0f b6 19             	movzbl (%ecx),%ebx
80103d7a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103d80:	39 c3                	cmp    %eax,%ebx
80103d82:	75 ec                	jne    80103d70 <mycpu+0x30>
80103d84:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103d8a:	05 a0 37 11 80       	add    $0x801137a0,%eax
}
80103d8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d92:	5b                   	pop    %ebx
80103d93:	5e                   	pop    %esi
80103d94:	5d                   	pop    %ebp
80103d95:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103d96:	b8 a0 37 11 80       	mov    $0x801137a0,%eax
      return &cpus[i];
80103d9b:	eb f2                	jmp    80103d8f <mycpu+0x4f>
  panic("unknown apicid\n");
80103d9d:	83 ec 0c             	sub    $0xc,%esp
80103da0:	68 bc 7f 10 80       	push   $0x80107fbc
80103da5:	e8 e6 c5 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103daa:	83 ec 0c             	sub    $0xc,%esp
80103dad:	68 08 81 10 80       	push   $0x80108108
80103db2:	e8 d9 c5 ff ff       	call   80100390 <panic>
80103db7:	89 f6                	mov    %esi,%esi
80103db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dc0 <cpuid>:
cpuid() {
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103dc6:	e8 75 ff ff ff       	call   80103d40 <mycpu>
80103dcb:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103dd0:	c9                   	leave  
  return mycpu()-cpus;
80103dd1:	c1 f8 04             	sar    $0x4,%eax
80103dd4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103dda:	c3                   	ret    
80103ddb:	90                   	nop
80103ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103de0 <myproc>:
myproc(void) {
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	53                   	push   %ebx
80103de4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103de7:	e8 14 0e 00 00       	call   80104c00 <pushcli>
  c = mycpu();
80103dec:	e8 4f ff ff ff       	call   80103d40 <mycpu>
  p = c->proc;
80103df1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103df7:	e8 44 0e 00 00       	call   80104c40 <popcli>
}
80103dfc:	83 c4 04             	add    $0x4,%esp
80103dff:	89 d8                	mov    %ebx,%eax
80103e01:	5b                   	pop    %ebx
80103e02:	5d                   	pop    %ebp
80103e03:	c3                   	ret    
80103e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e10 <userinit>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	53                   	push   %ebx
80103e14:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103e17:	e8 94 fc ff ff       	call   80103ab0 <allocproc>
80103e1c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103e1e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103e23:	e8 08 39 00 00       	call   80107730 <setupkvm>
80103e28:	85 c0                	test   %eax,%eax
80103e2a:	89 43 04             	mov    %eax,0x4(%ebx)
80103e2d:	0f 84 bd 00 00 00    	je     80103ef0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e33:	83 ec 04             	sub    $0x4,%esp
80103e36:	68 2c 00 00 00       	push   $0x2c
80103e3b:	68 60 b4 10 80       	push   $0x8010b460
80103e40:	50                   	push   %eax
80103e41:	e8 0a 34 00 00       	call   80107250 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e46:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e49:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103e4f:	6a 4c                	push   $0x4c
80103e51:	6a 00                	push   $0x0
80103e53:	ff 73 18             	pushl  0x18(%ebx)
80103e56:	e8 85 0f 00 00       	call   80104de0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e5b:	8b 43 18             	mov    0x18(%ebx),%eax
80103e5e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e63:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e68:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e6b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e6f:	8b 43 18             	mov    0x18(%ebx),%eax
80103e72:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103e76:	8b 43 18             	mov    0x18(%ebx),%eax
80103e79:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e7d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103e81:	8b 43 18             	mov    0x18(%ebx),%eax
80103e84:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e88:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103e8c:	8b 43 18             	mov    0x18(%ebx),%eax
80103e8f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103e96:	8b 43 18             	mov    0x18(%ebx),%eax
80103e99:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ea0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ea3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103eaa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ead:	6a 10                	push   $0x10
80103eaf:	68 e5 7f 10 80       	push   $0x80107fe5
80103eb4:	50                   	push   %eax
80103eb5:	e8 06 11 00 00       	call   80104fc0 <safestrcpy>
  p->cwd = namei("/");
80103eba:	c7 04 24 ee 7f 10 80 	movl   $0x80107fee,(%esp)
80103ec1:	e8 ea e0 ff ff       	call   80101fb0 <namei>
80103ec6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ec9:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103ed0:	e8 fb 0d 00 00       	call   80104cd0 <acquire>
  p->state = RUNNABLE;
80103ed5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103edc:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103ee3:	e8 a8 0e 00 00       	call   80104d90 <release>
}
80103ee8:	83 c4 10             	add    $0x10,%esp
80103eeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eee:	c9                   	leave  
80103eef:	c3                   	ret    
    panic("userinit: out of memory?");
80103ef0:	83 ec 0c             	sub    $0xc,%esp
80103ef3:	68 cc 7f 10 80       	push   $0x80107fcc
80103ef8:	e8 93 c4 ff ff       	call   80100390 <panic>
80103efd:	8d 76 00             	lea    0x0(%esi),%esi

80103f00 <growproc>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	56                   	push   %esi
80103f04:	53                   	push   %ebx
80103f05:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f08:	e8 f3 0c 00 00       	call   80104c00 <pushcli>
  c = mycpu();
80103f0d:	e8 2e fe ff ff       	call   80103d40 <mycpu>
  p = c->proc;
80103f12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f18:	e8 23 0d 00 00       	call   80104c40 <popcli>
  if(n > 0){
80103f1d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103f20:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f22:	7f 1c                	jg     80103f40 <growproc+0x40>
  } else if(n < 0){
80103f24:	75 3a                	jne    80103f60 <growproc+0x60>
  switchuvm(curproc);
80103f26:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f29:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f2b:	53                   	push   %ebx
80103f2c:	e8 0f 32 00 00       	call   80107140 <switchuvm>
  return 0;
80103f31:	83 c4 10             	add    $0x10,%esp
80103f34:	31 c0                	xor    %eax,%eax
}
80103f36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f39:	5b                   	pop    %ebx
80103f3a:	5e                   	pop    %esi
80103f3b:	5d                   	pop    %ebp
80103f3c:	c3                   	ret    
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f40:	83 ec 04             	sub    $0x4,%esp
80103f43:	01 c6                	add    %eax,%esi
80103f45:	56                   	push   %esi
80103f46:	50                   	push   %eax
80103f47:	ff 73 04             	pushl  0x4(%ebx)
80103f4a:	e8 21 36 00 00       	call   80107570 <allocuvm>
80103f4f:	83 c4 10             	add    $0x10,%esp
80103f52:	85 c0                	test   %eax,%eax
80103f54:	75 d0                	jne    80103f26 <growproc+0x26>
      return -1;
80103f56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f5b:	eb d9                	jmp    80103f36 <growproc+0x36>
80103f5d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f60:	83 ec 04             	sub    $0x4,%esp
80103f63:	01 c6                	add    %eax,%esi
80103f65:	56                   	push   %esi
80103f66:	50                   	push   %eax
80103f67:	ff 73 04             	pushl  0x4(%ebx)
80103f6a:	e8 91 34 00 00       	call   80107400 <deallocuvm>
80103f6f:	83 c4 10             	add    $0x10,%esp
80103f72:	85 c0                	test   %eax,%eax
80103f74:	75 b0                	jne    80103f26 <growproc+0x26>
80103f76:	eb de                	jmp    80103f56 <growproc+0x56>
80103f78:	90                   	nop
80103f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f80 <fork>:
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	57                   	push   %edi
80103f84:	56                   	push   %esi
80103f85:	53                   	push   %ebx
80103f86:	81 ec 1c 08 00 00    	sub    $0x81c,%esp
  pushcli();
80103f8c:	e8 6f 0c 00 00       	call   80104c00 <pushcli>
  c = mycpu();
80103f91:	e8 aa fd ff ff       	call   80103d40 <mycpu>
  p = c->proc;
80103f96:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f9c:	e8 9f 0c 00 00       	call   80104c40 <popcli>
  if((np = allocproc()) == 0){
80103fa1:	e8 0a fb ff ff       	call   80103ab0 <allocproc>
80103fa6:	85 c0                	test   %eax,%eax
80103fa8:	89 85 dc f7 ff ff    	mov    %eax,-0x824(%ebp)
80103fae:	0f 84 3c 02 00 00    	je     801041f0 <fork+0x270>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103fb4:	83 ec 08             	sub    $0x8,%esp
80103fb7:	ff 33                	pushl  (%ebx)
80103fb9:	ff 73 04             	pushl  0x4(%ebx)
80103fbc:	89 c7                	mov    %eax,%edi
80103fbe:	e8 3d 38 00 00       	call   80107800 <copyuvm>
80103fc3:	83 c4 10             	add    $0x10,%esp
80103fc6:	85 c0                	test   %eax,%eax
80103fc8:	89 47 04             	mov    %eax,0x4(%edi)
80103fcb:	0f 84 2e 02 00 00    	je     801041ff <fork+0x27f>
  np->sz = curproc->sz;
80103fd1:	8b 03                	mov    (%ebx),%eax
80103fd3:	8b 95 dc f7 ff ff    	mov    -0x824(%ebp),%edx
  *np->tf = *curproc->tf;
80103fd9:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103fde:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103fe0:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103fe3:	8b 7a 18             	mov    0x18(%edx),%edi
80103fe6:	8b 73 18             	mov    0x18(%ebx),%esi
80103fe9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->swapFilePageCount = curproc->swapFilePageCount;
80103feb:	89 d7                	mov    %edx,%edi
  for(i = 0; i < NOFILE; i++)
80103fed:	31 f6                	xor    %esi,%esi
    np->mainMemoryPageCount = curproc->mainMemoryPageCount;
80103fef:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103ff5:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
    np->swapFilePageCount = curproc->swapFilePageCount;
80103ffb:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80104001:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  np->tf->eax = 0;
80104007:	8b 42 18             	mov    0x18(%edx),%eax
8010400a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80104011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104018:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010401c:	85 c0                	test   %eax,%eax
8010401e:	74 10                	je     80104030 <fork+0xb0>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104020:	83 ec 0c             	sub    $0xc,%esp
80104023:	50                   	push   %eax
80104024:	e8 97 ce ff ff       	call   80100ec0 <filedup>
80104029:	83 c4 10             	add    $0x10,%esp
8010402c:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104030:	83 c6 01             	add    $0x1,%esi
80104033:	83 fe 10             	cmp    $0x10,%esi
80104036:	75 e0                	jne    80104018 <fork+0x98>
  np->cwd = idup(curproc->cwd);
80104038:	83 ec 0c             	sub    $0xc,%esp
8010403b:	ff 73 68             	pushl  0x68(%ebx)
8010403e:	e8 dd d6 ff ff       	call   80101720 <idup>
80104043:	8b bd dc f7 ff ff    	mov    -0x824(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104049:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010404c:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010404f:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104052:	6a 10                	push   $0x10
80104054:	50                   	push   %eax
80104055:	8d 47 6c             	lea    0x6c(%edi),%eax
80104058:	50                   	push   %eax
80104059:	e8 62 0f 00 00       	call   80104fc0 <safestrcpy>
    if(curproc->pid > 2){
8010405e:	83 c4 10             	add    $0x10,%esp
80104061:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  pid = np->pid;
80104065:	8b 47 10             	mov    0x10(%edi),%eax
80104068:	89 85 d8 f7 ff ff    	mov    %eax,-0x828(%ebp)
    if(curproc->pid > 2){
8010406e:	0f 8f fd 00 00 00    	jg     80104171 <fork+0x1f1>
80104074:	8b bd dc f7 ff ff    	mov    -0x824(%ebp),%edi
8010407a:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80104080:	8d 8b bc 01 00 00    	lea    0x1bc(%ebx),%ecx
80104086:	81 c7 90 00 00 00    	add    $0x90,%edi
8010408c:	89 bd e0 f7 ff ff    	mov    %edi,-0x820(%ebp)
  for(i = 0; i < NOFILE; i++)
80104092:	89 fa                	mov    %edi,%edx
80104094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      np->freePages[i].virtualAddress = curproc->freePages[i].virtualAddress;
80104098:	8b 30                	mov    (%eax),%esi
8010409a:	83 c0 14             	add    $0x14,%eax
8010409d:	83 c2 14             	add    $0x14,%edx
801040a0:	89 72 ec             	mov    %esi,-0x14(%edx)
      np->freePages[i].age = curproc->freePages[i].age;
801040a3:	8b 70 f0             	mov    -0x10(%eax),%esi
801040a6:	89 72 f0             	mov    %esi,-0x10(%edx)
      np->swappedPages[i].virtualAddress = curproc->swappedPages[i].virtualAddress;
801040a9:	8b b0 18 01 00 00    	mov    0x118(%eax),%esi
801040af:	89 b2 18 01 00 00    	mov    %esi,0x118(%edx)
      np->swappedPages[i].age = curproc->swappedPages[i].age;
801040b5:	8b b0 1c 01 00 00    	mov    0x11c(%eax),%esi
801040bb:	89 b2 1c 01 00 00    	mov    %esi,0x11c(%edx)
      np->swappedPages[i].swaploc = curproc->swappedPages[i].swaploc;
801040c1:	8b b0 28 01 00 00    	mov    0x128(%eax),%esi
801040c7:	89 b2 28 01 00 00    	mov    %esi,0x128(%edx)
    for(i=0;i<MAX_PSYC_PAGES;i++){
801040cd:	39 c8                	cmp    %ecx,%eax
801040cf:	75 c7                	jne    80104098 <fork+0x118>
801040d1:	8b 85 dc f7 ff ff    	mov    -0x824(%ebp),%eax
801040d7:	8d 8b 9c 00 00 00    	lea    0x9c(%ebx),%ecx
801040dd:	8d b0 98 00 00 00    	lea    0x98(%eax),%esi
801040e3:	8d 98 c4 01 00 00    	lea    0x1c4(%eax),%ebx
801040e9:	8d b8 bc 01 00 00    	lea    0x1bc(%eax),%edi
801040ef:	90                   	nop
  for(i = 0; i < NOFILE; i++)
801040f0:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
801040f6:	89 9d e4 f7 ff ff    	mov    %ebx,-0x81c(%ebp)
801040fc:	eb 0f                	jmp    8010410d <fork+0x18d>
801040fe:	66 90                	xchg   %ax,%ax
        if(np->freePages[j].virtualAddress == curproc->freePages[i].prev->virtualAddress)
80104100:	8b 19                	mov    (%ecx),%ebx
80104102:	39 13                	cmp    %edx,(%ebx)
80104104:	74 1a                	je     80104120 <fork+0x1a0>
80104106:	83 c0 14             	add    $0x14,%eax
      for(j=0;j<MAX_PSYC_PAGES;++j){
80104109:	39 f8                	cmp    %edi,%eax
8010410b:	74 1d                	je     8010412a <fork+0x1aa>
        if(np->freePages[j].virtualAddress == curproc->freePages[i].next->virtualAddress)
8010410d:	8b 59 fc             	mov    -0x4(%ecx),%ebx
80104110:	8b 10                	mov    (%eax),%edx
80104112:	3b 13                	cmp    (%ebx),%edx
80104114:	75 ea                	jne    80104100 <fork+0x180>
          np->freePages[i].next = &np->freePages[j];
80104116:	89 06                	mov    %eax,(%esi)
        if(np->freePages[j].virtualAddress == curproc->freePages[i].prev->virtualAddress)
80104118:	8b 19                	mov    (%ecx),%ebx
8010411a:	8b 10                	mov    (%eax),%edx
8010411c:	39 13                	cmp    %edx,(%ebx)
8010411e:	75 e6                	jne    80104106 <fork+0x186>
          np->freePages[i].prev = &np->freePages[j];
80104120:	89 46 04             	mov    %eax,0x4(%esi)
80104123:	83 c0 14             	add    $0x14,%eax
      for(j=0;j<MAX_PSYC_PAGES;++j){
80104126:	39 f8                	cmp    %edi,%eax
80104128:	75 e3                	jne    8010410d <fork+0x18d>
8010412a:	8b 9d e4 f7 ff ff    	mov    -0x81c(%ebp),%ebx
80104130:	83 c6 14             	add    $0x14,%esi
80104133:	83 c1 14             	add    $0x14,%ecx
    for(i = 0; i<MAX_PSYC_PAGES; i++){
80104136:	39 de                	cmp    %ebx,%esi
80104138:	75 b6                	jne    801040f0 <fork+0x170>
  acquire(&ptable.lock);
8010413a:	83 ec 0c             	sub    $0xc,%esp
8010413d:	68 40 3d 11 80       	push   $0x80113d40
80104142:	e8 89 0b 00 00       	call   80104cd0 <acquire>
  np->state = RUNNABLE;
80104147:	8b 85 dc f7 ff ff    	mov    -0x824(%ebp),%eax
8010414d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104154:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010415b:	e8 30 0c 00 00       	call   80104d90 <release>
  return pid;
80104160:	83 c4 10             	add    $0x10,%esp
}
80104163:	8b 85 d8 f7 ff ff    	mov    -0x828(%ebp),%eax
80104169:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010416c:	5b                   	pop    %ebx
8010416d:	5e                   	pop    %esi
8010416e:	5f                   	pop    %edi
8010416f:	5d                   	pop    %ebp
80104170:	c3                   	ret    
      createSwapFile(np);
80104171:	83 ec 0c             	sub    $0xc,%esp
80104174:	ff b5 dc f7 ff ff    	pushl  -0x824(%ebp)
      char buf[PGSIZE/2] = "";
8010417a:	8d bd ec f7 ff ff    	lea    -0x814(%ebp),%edi
80104180:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi
      createSwapFile(np);
80104186:	e8 f5 e0 ff ff       	call   80102280 <createSwapFile>
      char buf[PGSIZE/2] = "";
8010418b:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
80104190:	31 c0                	xor    %eax,%eax
80104192:	c7 85 e8 f7 ff ff 00 	movl   $0x0,-0x818(%ebp)
80104199:	00 00 00 
8010419c:	f3 ab                	rep stos %eax,%es:(%edi)
8010419e:	8b bd dc f7 ff ff    	mov    -0x824(%ebp),%edi
      while((nread == readFromSwapFile(curproc,buf, offset, PGSIZE/2))!=0)
801041a4:	83 c4 10             	add    $0x10,%esp
801041a7:	89 f6                	mov    %esi,%esi
801041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801041b0:	68 00 08 00 00       	push   $0x800
801041b5:	6a 00                	push   $0x0
801041b7:	56                   	push   %esi
801041b8:	53                   	push   %ebx
801041b9:	e8 92 e1 ff ff       	call   80102350 <readFromSwapFile>
801041be:	83 c4 10             	add    $0x10,%esp
801041c1:	85 c0                	test   %eax,%eax
801041c3:	0f 85 ab fe ff ff    	jne    80104074 <fork+0xf4>
        if(writeToSwapFile(np, buf, offset, nread) == -1){
801041c9:	6a 00                	push   $0x0
801041cb:	6a 00                	push   $0x0
801041cd:	56                   	push   %esi
801041ce:	57                   	push   %edi
801041cf:	e8 4c e1 ff ff       	call   80102320 <writeToSwapFile>
801041d4:	83 c4 10             	add    $0x10,%esp
801041d7:	83 f8 ff             	cmp    $0xffffffff,%eax
801041da:	75 d4                	jne    801041b0 <fork+0x230>
          panic("fork: error while copying the parent's swap file to the child");
801041dc:	83 ec 0c             	sub    $0xc,%esp
801041df:	68 30 81 10 80       	push   $0x80108130
801041e4:	e8 a7 c1 ff ff       	call   80100390 <panic>
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801041f0:	c7 85 d8 f7 ff ff ff 	movl   $0xffffffff,-0x828(%ebp)
801041f7:	ff ff ff 
801041fa:	e9 64 ff ff ff       	jmp    80104163 <fork+0x1e3>
    kfree(np->kstack);
801041ff:	8b bd dc f7 ff ff    	mov    -0x824(%ebp),%edi
80104205:	83 ec 0c             	sub    $0xc,%esp
80104208:	ff 77 08             	pushl  0x8(%edi)
8010420b:	e8 60 e5 ff ff       	call   80102770 <kfree>
    np->kstack = 0;
80104210:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80104217:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
8010421e:	83 c4 10             	add    $0x10,%esp
80104221:	c7 85 d8 f7 ff ff ff 	movl   $0xffffffff,-0x828(%ebp)
80104228:	ff ff ff 
8010422b:	e9 33 ff ff ff       	jmp    80104163 <fork+0x1e3>

80104230 <printProcessDetails>:
{
80104230:	55                   	push   %ebp
80104231:	b8 f0 7f 10 80       	mov    $0x80107ff0,%eax
80104236:	89 e5                	mov    %esp,%ebp
80104238:	57                   	push   %edi
80104239:	56                   	push   %esi
8010423a:	53                   	push   %ebx
8010423b:	83 ec 3c             	sub    $0x3c,%esp
8010423e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(proc->state >= 0 && proc->state < NELEM(states) && states[proc->state])
80104241:	8b 53 0c             	mov    0xc(%ebx),%edx
80104244:	83 fa 05             	cmp    $0x5,%edx
80104247:	77 11                	ja     8010425a <printProcessDetails+0x2a>
80104249:	8b 04 95 e0 81 10 80 	mov    -0x7fef7e20(,%edx,4),%eax
    state = "???";
80104250:	ba f0 7f 10 80       	mov    $0x80107ff0,%edx
80104255:	85 c0                	test   %eax,%eax
80104257:	0f 44 c2             	cmove  %edx,%eax
  cprintf("\n<pid:%d> <state:%s> <name:%s> ", proc->pid, state, proc->name);
8010425a:	8d 53 6c             	lea    0x6c(%ebx),%edx
8010425d:	52                   	push   %edx
8010425e:	50                   	push   %eax
8010425f:	ff 73 10             	pushl  0x10(%ebx)
80104262:	68 70 81 10 80       	push   $0x80108170
80104267:	e8 f4 c3 ff ff       	call   80100660 <cprintf>
  cprintf("<allocated memory pages: %d> ", proc->mainMemoryPageCount);
8010426c:	5a                   	pop    %edx
8010426d:	59                   	pop    %ecx
8010426e:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104274:	68 f4 7f 10 80       	push   $0x80107ff4
80104279:	e8 e2 c3 ff ff       	call   80100660 <cprintf>
  cprintf("<paged out: %d> ", proc->swapFilePageCount);
8010427e:	5e                   	pop    %esi
8010427f:	5f                   	pop    %edi
80104280:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
80104286:	68 12 80 10 80       	push   $0x80108012
8010428b:	e8 d0 c3 ff ff       	call   80100660 <cprintf>
  cprintf("<page faults: %d> ", proc->pageFaultCount);
80104290:	58                   	pop    %eax
80104291:	5a                   	pop    %edx
80104292:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80104298:	68 23 80 10 80       	push   $0x80108023
8010429d:	e8 be c3 ff ff       	call   80100660 <cprintf>
  cprintf("<totalnumber of pagedout: %d>\n", proc->totalSwapCount);
801042a2:	59                   	pop    %ecx
801042a3:	5e                   	pop    %esi
801042a4:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
801042aa:	68 90 81 10 80       	push   $0x80108190
801042af:	e8 ac c3 ff ff       	call   80100660 <cprintf>
  if(proc->state == SLEEPING){
801042b4:	83 c4 10             	add    $0x10,%esp
801042b7:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801042bb:	0f 84 bf 00 00 00    	je     80104380 <printProcessDetails+0x150>
  cprintf("Main Memory Pages: ");
801042c1:	83 ec 0c             	sub    $0xc,%esp
801042c4:	68 3a 80 10 80       	push   $0x8010803a
801042c9:	e8 92 c3 ff ff       	call   80100660 <cprintf>
  for(int pop = 0 ; pop < proc->mainMemoryPageCount ; pop++){
801042ce:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801042d4:	83 c4 10             	add    $0x10,%esp
801042d7:	85 c0                	test   %eax,%eax
801042d9:	7e 2d                	jle    80104308 <printProcessDetails+0xd8>
801042db:	8d bb 90 00 00 00    	lea    0x90(%ebx),%edi
801042e1:	31 f6                	xor    %esi,%esi
801042e3:	90                   	nop
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("0x%x ",(char*)proc->freePages[pop].virtualAddress);      
801042e8:	83 ec 08             	sub    $0x8,%esp
801042eb:	ff 37                	pushl  (%edi)
  for(int pop = 0 ; pop < proc->mainMemoryPageCount ; pop++){
801042ed:	83 c6 01             	add    $0x1,%esi
        cprintf("0x%x ",(char*)proc->freePages[pop].virtualAddress);      
801042f0:	68 4e 80 10 80       	push   $0x8010804e
801042f5:	83 c7 14             	add    $0x14,%edi
801042f8:	e8 63 c3 ff ff       	call   80100660 <cprintf>
  for(int pop = 0 ; pop < proc->mainMemoryPageCount ; pop++){
801042fd:	83 c4 10             	add    $0x10,%esp
80104300:	39 b3 80 00 00 00    	cmp    %esi,0x80(%ebx)
80104306:	7f e0                	jg     801042e8 <printProcessDetails+0xb8>
  cprintf("\nswapFile Pages: ");
80104308:	83 ec 0c             	sub    $0xc,%esp
8010430b:	68 54 80 10 80       	push   $0x80108054
80104310:	e8 4b c3 ff ff       	call   80100660 <cprintf>
  for(int pop = 0 ; pop < proc->swapFilePageCount ; pop++){
80104315:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
8010431b:	83 c4 10             	add    $0x10,%esp
8010431e:	85 c0                	test   %eax,%eax
80104320:	7e 30                	jle    80104352 <printProcessDetails+0x122>
80104322:	8d bb bc 01 00 00    	lea    0x1bc(%ebx),%edi
80104328:	31 f6                	xor    %esi,%esi
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("0x%x ",(char*)proc->swappedPages[pop].virtualAddress);
80104330:	83 ec 08             	sub    $0x8,%esp
80104333:	ff 37                	pushl  (%edi)
  for(int pop = 0 ; pop < proc->swapFilePageCount ; pop++){
80104335:	83 c6 01             	add    $0x1,%esi
    cprintf("0x%x ",(char*)proc->swappedPages[pop].virtualAddress);
80104338:	68 4e 80 10 80       	push   $0x8010804e
8010433d:	83 c7 14             	add    $0x14,%edi
80104340:	e8 1b c3 ff ff       	call   80100660 <cprintf>
  for(int pop = 0 ; pop < proc->swapFilePageCount ; pop++){
80104345:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
8010434b:	83 c4 10             	add    $0x10,%esp
8010434e:	39 f0                	cmp    %esi,%eax
80104350:	7f de                	jg     80104330 <printProcessDetails+0x100>
  if(proc->swapFilePageCount == 0) cprintf("swapFile Empty!");
80104352:	85 c0                	test   %eax,%eax
80104354:	75 10                	jne    80104366 <printProcessDetails+0x136>
80104356:	83 ec 0c             	sub    $0xc,%esp
80104359:	68 66 80 10 80       	push   $0x80108066
8010435e:	e8 fd c2 ff ff       	call   80100660 <cprintf>
80104363:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80104366:	83 ec 0c             	sub    $0xc,%esp
80104369:	68 e9 84 10 80       	push   $0x801084e9
8010436e:	e8 ed c2 ff ff       	call   80100660 <cprintf>
}
80104373:	83 c4 10             	add    $0x10,%esp
80104376:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104379:	5b                   	pop    %ebx
8010437a:	5e                   	pop    %esi
8010437b:	5f                   	pop    %edi
8010437c:	5d                   	pop    %ebp
8010437d:	c3                   	ret    
8010437e:	66 90                	xchg   %ax,%ax
      getcallerpcs((uint*)proc->context->ebp+2, pc);
80104380:	8d 75 c0             	lea    -0x40(%ebp),%esi
80104383:	83 ec 08             	sub    $0x8,%esp
80104386:	8d 7d e8             	lea    -0x18(%ebp),%edi
80104389:	56                   	push   %esi
8010438a:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010438d:	8b 40 0c             	mov    0xc(%eax),%eax
80104390:	83 c0 08             	add    $0x8,%eax
80104393:	50                   	push   %eax
80104394:	e8 17 08 00 00       	call   80104bb0 <getcallerpcs>
80104399:	83 c4 10             	add    $0x10,%esp
      int checker = 0;
8010439c:	31 d2                	xor    %edx,%edx
8010439e:	66 90                	xchg   %ax,%ax
      for(i=0; i<10 && pc[i] != 0; i++)
801043a0:	8b 06                	mov    (%esi),%eax
801043a2:	85 c0                	test   %eax,%eax
801043a4:	74 3a                	je     801043e0 <printProcessDetails+0x1b0>
        {checker = 1; cprintf("%p ", pc[i]);}
801043a6:	83 ec 08             	sub    $0x8,%esp
801043a9:	83 c6 04             	add    $0x4,%esi
801043ac:	50                   	push   %eax
801043ad:	68 36 80 10 80       	push   $0x80108036
801043b2:	e8 a9 c2 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043b7:	83 c4 10             	add    $0x10,%esp
801043ba:	39 fe                	cmp    %edi,%esi
        {checker = 1; cprintf("%p ", pc[i]);}
801043bc:	ba 01 00 00 00       	mov    $0x1,%edx
      for(i=0; i<10 && pc[i] != 0; i++)
801043c1:	75 dd                	jne    801043a0 <printProcessDetails+0x170>
        cprintf("\n");
801043c3:	83 ec 0c             	sub    $0xc,%esp
801043c6:	68 e9 84 10 80       	push   $0x801084e9
801043cb:	e8 90 c2 ff ff       	call   80100660 <cprintf>
801043d0:	83 c4 10             	add    $0x10,%esp
801043d3:	e9 e9 fe ff ff       	jmp    801042c1 <printProcessDetails+0x91>
801043d8:	90                   	nop
801043d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(checker)
801043e0:	85 d2                	test   %edx,%edx
801043e2:	0f 84 d9 fe ff ff    	je     801042c1 <printProcessDetails+0x91>
801043e8:	eb d9                	jmp    801043c3 <printProcessDetails+0x193>
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <compute>:
compute(const char *p, const char *q){
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	8b 55 08             	mov    0x8(%ebp),%edx
801043f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
801043fa:	0f b6 02             	movzbl (%edx),%eax
801043fd:	0f b6 19             	movzbl (%ecx),%ebx
80104400:	84 c0                	test   %al,%al
80104402:	75 1c                	jne    80104420 <compute+0x30>
80104404:	eb 2a                	jmp    80104430 <compute+0x40>
80104406:	8d 76 00             	lea    0x0(%esi),%esi
80104409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
80104410:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
80104413:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
80104416:	83 c1 01             	add    $0x1,%ecx
80104419:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
8010441c:	84 c0                	test   %al,%al
8010441e:	74 10                	je     80104430 <compute+0x40>
80104420:	38 d8                	cmp    %bl,%al
80104422:	74 ec                	je     80104410 <compute+0x20>
  return (uchar)*p - (uchar)*q;
80104424:	29 d8                	sub    %ebx,%eax
}
80104426:	5b                   	pop    %ebx
80104427:	5d                   	pop    %ebp
80104428:	c3                   	ret    
80104429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104430:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
80104432:	29 d8                	sub    %ebx,%eax
}
80104434:	5b                   	pop    %ebx
80104435:	5d                   	pop    %ebp
80104436:	c3                   	ret    
80104437:	89 f6                	mov    %esi,%esi
80104439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104440 <scheduler>:
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	57                   	push   %edi
80104444:	56                   	push   %esi
80104445:	53                   	push   %ebx
80104446:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104449:	e8 f2 f8 ff ff       	call   80103d40 <mycpu>
8010444e:	8d 78 04             	lea    0x4(%eax),%edi
80104451:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104453:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010445a:	00 00 00 
8010445d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104460:	fb                   	sti    
    acquire(&ptable.lock);
80104461:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104464:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
    acquire(&ptable.lock);
80104469:	68 40 3d 11 80       	push   $0x80113d40
8010446e:	e8 5d 08 00 00       	call   80104cd0 <acquire>
80104473:	83 c4 10             	add    $0x10,%esp
80104476:	8d 76 00             	lea    0x0(%esi),%esi
80104479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104480:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104484:	75 33                	jne    801044b9 <scheduler+0x79>
      switchuvm(p);
80104486:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104489:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010448f:	53                   	push   %ebx
80104490:	e8 ab 2c 00 00       	call   80107140 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104495:	58                   	pop    %eax
80104496:	5a                   	pop    %edx
80104497:	ff 73 1c             	pushl  0x1c(%ebx)
8010449a:	57                   	push   %edi
      p->state = RUNNING;
8010449b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801044a2:	e8 74 0b 00 00       	call   8010501b <swtch>
      switchkvm();
801044a7:	e8 74 2c 00 00       	call   80107120 <switchkvm>
      c->proc = 0;
801044ac:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801044b3:	00 00 00 
801044b6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b9:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
801044bf:	81 fb 74 f9 11 80    	cmp    $0x8011f974,%ebx
801044c5:	72 b9                	jb     80104480 <scheduler+0x40>
    release(&ptable.lock);
801044c7:	83 ec 0c             	sub    $0xc,%esp
801044ca:	68 40 3d 11 80       	push   $0x80113d40
801044cf:	e8 bc 08 00 00       	call   80104d90 <release>
    sti();
801044d4:	83 c4 10             	add    $0x10,%esp
801044d7:	eb 87                	jmp    80104460 <scheduler+0x20>
801044d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044e0 <sched>:
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	56                   	push   %esi
801044e4:	53                   	push   %ebx
  pushcli();
801044e5:	e8 16 07 00 00       	call   80104c00 <pushcli>
  c = mycpu();
801044ea:	e8 51 f8 ff ff       	call   80103d40 <mycpu>
  p = c->proc;
801044ef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044f5:	e8 46 07 00 00       	call   80104c40 <popcli>
  if(!holding(&ptable.lock))
801044fa:	83 ec 0c             	sub    $0xc,%esp
801044fd:	68 40 3d 11 80       	push   $0x80113d40
80104502:	e8 99 07 00 00       	call   80104ca0 <holding>
80104507:	83 c4 10             	add    $0x10,%esp
8010450a:	85 c0                	test   %eax,%eax
8010450c:	74 4f                	je     8010455d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010450e:	e8 2d f8 ff ff       	call   80103d40 <mycpu>
80104513:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010451a:	75 68                	jne    80104584 <sched+0xa4>
  if(p->state == RUNNING)
8010451c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104520:	74 55                	je     80104577 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104522:	9c                   	pushf  
80104523:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104524:	f6 c4 02             	test   $0x2,%ah
80104527:	75 41                	jne    8010456a <sched+0x8a>
  intena = mycpu()->intena;
80104529:	e8 12 f8 ff ff       	call   80103d40 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010452e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104531:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104537:	e8 04 f8 ff ff       	call   80103d40 <mycpu>
8010453c:	83 ec 08             	sub    $0x8,%esp
8010453f:	ff 70 04             	pushl  0x4(%eax)
80104542:	53                   	push   %ebx
80104543:	e8 d3 0a 00 00       	call   8010501b <swtch>
  mycpu()->intena = intena;
80104548:	e8 f3 f7 ff ff       	call   80103d40 <mycpu>
}
8010454d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104550:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104556:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104559:	5b                   	pop    %ebx
8010455a:	5e                   	pop    %esi
8010455b:	5d                   	pop    %ebp
8010455c:	c3                   	ret    
    panic("sched ptable.lock");
8010455d:	83 ec 0c             	sub    $0xc,%esp
80104560:	68 76 80 10 80       	push   $0x80108076
80104565:	e8 26 be ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	68 a2 80 10 80       	push   $0x801080a2
80104572:	e8 19 be ff ff       	call   80100390 <panic>
    panic("sched running");
80104577:	83 ec 0c             	sub    $0xc,%esp
8010457a:	68 94 80 10 80       	push   $0x80108094
8010457f:	e8 0c be ff ff       	call   80100390 <panic>
    panic("sched locks");
80104584:	83 ec 0c             	sub    $0xc,%esp
80104587:	68 88 80 10 80       	push   $0x80108088
8010458c:	e8 ff bd ff ff       	call   80100390 <panic>
80104591:	eb 0d                	jmp    801045a0 <exit>
80104593:	90                   	nop
80104594:	90                   	nop
80104595:	90                   	nop
80104596:	90                   	nop
80104597:	90                   	nop
80104598:	90                   	nop
80104599:	90                   	nop
8010459a:	90                   	nop
8010459b:	90                   	nop
8010459c:	90                   	nop
8010459d:	90                   	nop
8010459e:	90                   	nop
8010459f:	90                   	nop

801045a0 <exit>:
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	56                   	push   %esi
801045a5:	53                   	push   %ebx
801045a6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801045a9:	e8 52 06 00 00       	call   80104c00 <pushcli>
  c = mycpu();
801045ae:	e8 8d f7 ff ff       	call   80103d40 <mycpu>
  p = c->proc;
801045b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045b9:	e8 82 06 00 00       	call   80104c40 <popcli>
  if(curproc == initproc)
801045be:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
801045c4:	8d 73 28             	lea    0x28(%ebx),%esi
801045c7:	8d 7b 68             	lea    0x68(%ebx),%edi
801045ca:	0f 84 27 01 00 00    	je     801046f7 <exit+0x157>
    if(curproc->ofile[fd]){
801045d0:	8b 06                	mov    (%esi),%eax
801045d2:	85 c0                	test   %eax,%eax
801045d4:	74 12                	je     801045e8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801045d6:	83 ec 0c             	sub    $0xc,%esp
801045d9:	50                   	push   %eax
801045da:	e8 31 c9 ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
801045df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801045e5:	83 c4 10             	add    $0x10,%esp
801045e8:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
801045eb:	39 fe                	cmp    %edi,%esi
801045ed:	75 e1                	jne    801045d0 <exit+0x30>
    if(curproc->pid >2 &&  curproc->swapFile!=0 && curproc->swapFile->ref > 0)
801045ef:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801045f3:	0f 8f d8 00 00 00    	jg     801046d1 <exit+0x131>
  begin_op();
801045f9:	e8 52 ea ff ff       	call   80103050 <begin_op>
  iput(curproc->cwd);
801045fe:	83 ec 0c             	sub    $0xc,%esp
80104601:	ff 73 68             	pushl  0x68(%ebx)
80104604:	e8 77 d2 ff ff       	call   80101880 <iput>
  end_op();
80104609:	e8 b2 ea ff ff       	call   801030c0 <end_op>
  curproc->cwd = 0;
8010460e:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104615:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010461c:	e8 af 06 00 00       	call   80104cd0 <acquire>
  wakeup1(curproc->parent);
80104621:	8b 53 14             	mov    0x14(%ebx),%edx
80104624:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104627:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010462c:	eb 0e                	jmp    8010463c <exit+0x9c>
8010462e:	66 90                	xchg   %ax,%ax
80104630:	05 f0 02 00 00       	add    $0x2f0,%eax
80104635:	3d 74 f9 11 80       	cmp    $0x8011f974,%eax
8010463a:	73 1e                	jae    8010465a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010463c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104640:	75 ee                	jne    80104630 <exit+0x90>
80104642:	3b 50 20             	cmp    0x20(%eax),%edx
80104645:	75 e9                	jne    80104630 <exit+0x90>
      p->state = RUNNABLE;
80104647:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010464e:	05 f0 02 00 00       	add    $0x2f0,%eax
80104653:	3d 74 f9 11 80       	cmp    $0x8011f974,%eax
80104658:	72 e2                	jb     8010463c <exit+0x9c>
      p->parent = initproc;
8010465a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104660:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
80104665:	eb 17                	jmp    8010467e <exit+0xde>
80104667:	89 f6                	mov    %esi,%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104670:	81 c2 f0 02 00 00    	add    $0x2f0,%edx
80104676:	81 fa 74 f9 11 80    	cmp    $0x8011f974,%edx
8010467c:	73 3a                	jae    801046b8 <exit+0x118>
    if(p->parent == curproc){
8010467e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104681:	75 ed                	jne    80104670 <exit+0xd0>
      if(p->state == ZOMBIE)
80104683:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104687:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010468a:	75 e4                	jne    80104670 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010468c:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104691:	eb 11                	jmp    801046a4 <exit+0x104>
80104693:	90                   	nop
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104698:	05 f0 02 00 00       	add    $0x2f0,%eax
8010469d:	3d 74 f9 11 80       	cmp    $0x8011f974,%eax
801046a2:	73 cc                	jae    80104670 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
801046a4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046a8:	75 ee                	jne    80104698 <exit+0xf8>
801046aa:	3b 48 20             	cmp    0x20(%eax),%ecx
801046ad:	75 e9                	jne    80104698 <exit+0xf8>
      p->state = RUNNABLE;
801046af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046b6:	eb e0                	jmp    80104698 <exit+0xf8>
  curproc->state = ZOMBIE;
801046b8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801046bf:	e8 1c fe ff ff       	call   801044e0 <sched>
  panic("zombie exit");
801046c4:	83 ec 0c             	sub    $0xc,%esp
801046c7:	68 c3 80 10 80       	push   $0x801080c3
801046cc:	e8 bf bc ff ff       	call   80100390 <panic>
    if(curproc->pid >2 &&  curproc->swapFile!=0 && curproc->swapFile->ref > 0)
801046d1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801046d4:	85 c0                	test   %eax,%eax
801046d6:	0f 84 1d ff ff ff    	je     801045f9 <exit+0x59>
801046dc:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
801046e0:	0f 8e 13 ff ff ff    	jle    801045f9 <exit+0x59>
      removeSwapFile(curproc);
801046e6:	83 ec 0c             	sub    $0xc,%esp
801046e9:	53                   	push   %ebx
801046ea:	e8 91 d9 ff ff       	call   80102080 <removeSwapFile>
801046ef:	83 c4 10             	add    $0x10,%esp
801046f2:	e9 02 ff ff ff       	jmp    801045f9 <exit+0x59>
    panic("init exiting");
801046f7:	83 ec 0c             	sub    $0xc,%esp
801046fa:	68 b6 80 10 80       	push   $0x801080b6
801046ff:	e8 8c bc ff ff       	call   80100390 <panic>
80104704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010470a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104710 <yield>:
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104717:	68 40 3d 11 80       	push   $0x80113d40
8010471c:	e8 af 05 00 00       	call   80104cd0 <acquire>
  pushcli();
80104721:	e8 da 04 00 00       	call   80104c00 <pushcli>
  c = mycpu();
80104726:	e8 15 f6 ff ff       	call   80103d40 <mycpu>
  p = c->proc;
8010472b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104731:	e8 0a 05 00 00       	call   80104c40 <popcli>
  myproc()->state = RUNNABLE;
80104736:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010473d:	e8 9e fd ff ff       	call   801044e0 <sched>
  release(&ptable.lock);
80104742:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104749:	e8 42 06 00 00       	call   80104d90 <release>
}
8010474e:	83 c4 10             	add    $0x10,%esp
80104751:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104754:	c9                   	leave  
80104755:	c3                   	ret    
80104756:	8d 76 00             	lea    0x0(%esi),%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104760 <sleep>:
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	57                   	push   %edi
80104764:	56                   	push   %esi
80104765:	53                   	push   %ebx
80104766:	83 ec 0c             	sub    $0xc,%esp
80104769:	8b 7d 08             	mov    0x8(%ebp),%edi
8010476c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010476f:	e8 8c 04 00 00       	call   80104c00 <pushcli>
  c = mycpu();
80104774:	e8 c7 f5 ff ff       	call   80103d40 <mycpu>
  p = c->proc;
80104779:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010477f:	e8 bc 04 00 00       	call   80104c40 <popcli>
  if(p == 0)
80104784:	85 db                	test   %ebx,%ebx
80104786:	0f 84 87 00 00 00    	je     80104813 <sleep+0xb3>
  if(lk == 0)
8010478c:	85 f6                	test   %esi,%esi
8010478e:	74 76                	je     80104806 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104790:	81 fe 40 3d 11 80    	cmp    $0x80113d40,%esi
80104796:	74 50                	je     801047e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104798:	83 ec 0c             	sub    $0xc,%esp
8010479b:	68 40 3d 11 80       	push   $0x80113d40
801047a0:	e8 2b 05 00 00       	call   80104cd0 <acquire>
    release(lk);
801047a5:	89 34 24             	mov    %esi,(%esp)
801047a8:	e8 e3 05 00 00       	call   80104d90 <release>
  p->chan = chan;
801047ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801047b7:	e8 24 fd ff ff       	call   801044e0 <sched>
  p->chan = 0;
801047bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801047c3:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801047ca:	e8 c1 05 00 00       	call   80104d90 <release>
    acquire(lk);
801047cf:	89 75 08             	mov    %esi,0x8(%ebp)
801047d2:	83 c4 10             	add    $0x10,%esp
}
801047d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047d8:	5b                   	pop    %ebx
801047d9:	5e                   	pop    %esi
801047da:	5f                   	pop    %edi
801047db:	5d                   	pop    %ebp
    acquire(lk);
801047dc:	e9 ef 04 00 00       	jmp    80104cd0 <acquire>
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801047e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801047f2:	e8 e9 fc ff ff       	call   801044e0 <sched>
  p->chan = 0;
801047f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801047fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104801:	5b                   	pop    %ebx
80104802:	5e                   	pop    %esi
80104803:	5f                   	pop    %edi
80104804:	5d                   	pop    %ebp
80104805:	c3                   	ret    
    panic("sleep without lk");
80104806:	83 ec 0c             	sub    $0xc,%esp
80104809:	68 d5 80 10 80       	push   $0x801080d5
8010480e:	e8 7d bb ff ff       	call   80100390 <panic>
    panic("sleep");
80104813:	83 ec 0c             	sub    $0xc,%esp
80104816:	68 cf 80 10 80       	push   $0x801080cf
8010481b:	e8 70 bb ff ff       	call   80100390 <panic>

80104820 <wait>:
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
  pushcli();
80104825:	e8 d6 03 00 00       	call   80104c00 <pushcli>
  c = mycpu();
8010482a:	e8 11 f5 ff ff       	call   80103d40 <mycpu>
  p = c->proc;
8010482f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104835:	e8 06 04 00 00       	call   80104c40 <popcli>
  acquire(&ptable.lock);
8010483a:	83 ec 0c             	sub    $0xc,%esp
8010483d:	68 40 3d 11 80       	push   $0x80113d40
80104842:	e8 89 04 00 00       	call   80104cd0 <acquire>
80104847:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010484a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010484c:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
80104851:	eb 13                	jmp    80104866 <wait+0x46>
80104853:	90                   	nop
80104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104858:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
8010485e:	81 fb 74 f9 11 80    	cmp    $0x8011f974,%ebx
80104864:	73 1e                	jae    80104884 <wait+0x64>
      if(p->parent != curproc)
80104866:	39 73 14             	cmp    %esi,0x14(%ebx)
80104869:	75 ed                	jne    80104858 <wait+0x38>
      if(p->state == ZOMBIE){
8010486b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010486f:	74 37                	je     801048a8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104871:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
      havekids = 1;
80104877:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010487c:	81 fb 74 f9 11 80    	cmp    $0x8011f974,%ebx
80104882:	72 e2                	jb     80104866 <wait+0x46>
    if(!havekids || curproc->killed){
80104884:	85 c0                	test   %eax,%eax
80104886:	74 76                	je     801048fe <wait+0xde>
80104888:	8b 46 24             	mov    0x24(%esi),%eax
8010488b:	85 c0                	test   %eax,%eax
8010488d:	75 6f                	jne    801048fe <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010488f:	83 ec 08             	sub    $0x8,%esp
80104892:	68 40 3d 11 80       	push   $0x80113d40
80104897:	56                   	push   %esi
80104898:	e8 c3 fe ff ff       	call   80104760 <sleep>
    havekids = 0;
8010489d:	83 c4 10             	add    $0x10,%esp
801048a0:	eb a8                	jmp    8010484a <wait+0x2a>
801048a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801048ae:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801048b1:	e8 ba de ff ff       	call   80102770 <kfree>
        freevm(p->pgdir);
801048b6:	5a                   	pop    %edx
801048b7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801048ba:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801048c1:	e8 ea 2d 00 00       	call   801076b0 <freevm>
        release(&ptable.lock);
801048c6:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
        p->pid = 0;
801048cd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801048d4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801048db:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801048df:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801048e6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801048ed:	e8 9e 04 00 00       	call   80104d90 <release>
        return pid;
801048f2:	83 c4 10             	add    $0x10,%esp
}
801048f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048f8:	89 f0                	mov    %esi,%eax
801048fa:	5b                   	pop    %ebx
801048fb:	5e                   	pop    %esi
801048fc:	5d                   	pop    %ebp
801048fd:	c3                   	ret    
      release(&ptable.lock);
801048fe:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104901:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104906:	68 40 3d 11 80       	push   $0x80113d40
8010490b:	e8 80 04 00 00       	call   80104d90 <release>
      return -1;
80104910:	83 c4 10             	add    $0x10,%esp
80104913:	eb e0                	jmp    801048f5 <wait+0xd5>
80104915:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104920 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 10             	sub    $0x10,%esp
80104927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010492a:	68 40 3d 11 80       	push   $0x80113d40
8010492f:	e8 9c 03 00 00       	call   80104cd0 <acquire>
80104934:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104937:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010493c:	eb 0e                	jmp    8010494c <wakeup+0x2c>
8010493e:	66 90                	xchg   %ax,%ax
80104940:	05 f0 02 00 00       	add    $0x2f0,%eax
80104945:	3d 74 f9 11 80       	cmp    $0x8011f974,%eax
8010494a:	73 1e                	jae    8010496a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010494c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104950:	75 ee                	jne    80104940 <wakeup+0x20>
80104952:	3b 58 20             	cmp    0x20(%eax),%ebx
80104955:	75 e9                	jne    80104940 <wakeup+0x20>
      p->state = RUNNABLE;
80104957:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010495e:	05 f0 02 00 00       	add    $0x2f0,%eax
80104963:	3d 74 f9 11 80       	cmp    $0x8011f974,%eax
80104968:	72 e2                	jb     8010494c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010496a:	c7 45 08 40 3d 11 80 	movl   $0x80113d40,0x8(%ebp)
}
80104971:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104974:	c9                   	leave  
  release(&ptable.lock);
80104975:	e9 16 04 00 00       	jmp    80104d90 <release>
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104980 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	53                   	push   %ebx
80104984:	83 ec 10             	sub    $0x10,%esp
80104987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010498a:	68 40 3d 11 80       	push   $0x80113d40
8010498f:	e8 3c 03 00 00       	call   80104cd0 <acquire>
80104994:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104997:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010499c:	eb 0e                	jmp    801049ac <kill+0x2c>
8010499e:	66 90                	xchg   %ax,%ax
801049a0:	05 f0 02 00 00       	add    $0x2f0,%eax
801049a5:	3d 74 f9 11 80       	cmp    $0x8011f974,%eax
801049aa:	73 34                	jae    801049e0 <kill+0x60>
    if(p->pid == pid){
801049ac:	39 58 10             	cmp    %ebx,0x10(%eax)
801049af:	75 ef                	jne    801049a0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801049b1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801049b5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801049bc:	75 07                	jne    801049c5 <kill+0x45>
        p->state = RUNNABLE;
801049be:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801049c5:	83 ec 0c             	sub    $0xc,%esp
801049c8:	68 40 3d 11 80       	push   $0x80113d40
801049cd:	e8 be 03 00 00       	call   80104d90 <release>
      return 0;
801049d2:	83 c4 10             	add    $0x10,%esp
801049d5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801049d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049da:	c9                   	leave  
801049db:	c3                   	ret    
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801049e0:	83 ec 0c             	sub    $0xc,%esp
801049e3:	68 40 3d 11 80       	push   $0x80113d40
801049e8:	e8 a3 03 00 00       	call   80104d90 <release>
  return -1;
801049ed:	83 c4 10             	add    $0x10,%esp
801049f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049f8:	c9                   	leave  
801049f9:	c3                   	ret    
801049fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a00 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	53                   	push   %ebx
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");*/
  struct proc *p;
  int percentage;
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
80104a04:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
80104a09:	83 ec 04             	sub    $0x4,%esp
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == UNUSED)
80104a10:	8b 43 0c             	mov    0xc(%ebx),%eax
80104a13:	85 c0                	test   %eax,%eax
80104a15:	74 0c                	je     80104a23 <procdump+0x23>
      continue;
    printProcessDetails(p);
80104a17:	83 ec 0c             	sub    $0xc,%esp
80104a1a:	53                   	push   %ebx
80104a1b:	e8 10 f8 ff ff       	call   80104230 <printProcessDetails>
80104a20:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
80104a23:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
80104a29:	81 fb 74 f9 11 80    	cmp    $0x8011f974,%ebx
80104a2f:	72 df                	jb     80104a10 <procdump+0x10>
  }
  percentage = (freePageCounts.currentFreePages*100)/freePageCounts.initFreePages;
80104a31:	8b 1d 7c 36 11 80    	mov    0x8011367c,%ebx
80104a37:	8b 0d 80 36 11 80    	mov    0x80113680,%ecx
80104a3d:	31 d2                	xor    %edx,%edx
80104a3f:	6b c3 64             	imul   $0x64,%ebx,%eax
80104a42:	f7 f1                	div    %ecx
  cprintf("\nNumber of free physical pages: %d/%d ~ %d%% \n",freePageCounts.currentFreePages,
80104a44:	50                   	push   %eax
80104a45:	51                   	push   %ecx
80104a46:	53                   	push   %ebx
80104a47:	68 b0 81 10 80       	push   $0x801081b0
80104a4c:	e8 0f bc ff ff       	call   80100660 <cprintf>
    freePageCounts.initFreePages, percentage);
}
80104a51:	83 c4 10             	add    $0x10,%esp
80104a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a57:	c9                   	leave  
80104a58:	c3                   	ret    
80104a59:	66 90                	xchg   %ax,%ax
80104a5b:	66 90                	xchg   %ax,%ax
80104a5d:	66 90                	xchg   %ax,%ax
80104a5f:	90                   	nop

80104a60 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	53                   	push   %ebx
80104a64:	83 ec 0c             	sub    $0xc,%esp
80104a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104a6a:	68 f8 81 10 80       	push   $0x801081f8
80104a6f:	8d 43 04             	lea    0x4(%ebx),%eax
80104a72:	50                   	push   %eax
80104a73:	e8 18 01 00 00       	call   80104b90 <initlock>
  lk->name = name;
80104a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104a7b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104a81:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104a84:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104a8b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104a8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a91:	c9                   	leave  
80104a92:	c3                   	ret    
80104a93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	53                   	push   %ebx
80104aa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104aa8:	83 ec 0c             	sub    $0xc,%esp
80104aab:	8d 73 04             	lea    0x4(%ebx),%esi
80104aae:	56                   	push   %esi
80104aaf:	e8 1c 02 00 00       	call   80104cd0 <acquire>
  while (lk->locked) {
80104ab4:	8b 13                	mov    (%ebx),%edx
80104ab6:	83 c4 10             	add    $0x10,%esp
80104ab9:	85 d2                	test   %edx,%edx
80104abb:	74 16                	je     80104ad3 <acquiresleep+0x33>
80104abd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104ac0:	83 ec 08             	sub    $0x8,%esp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
80104ac5:	e8 96 fc ff ff       	call   80104760 <sleep>
  while (lk->locked) {
80104aca:	8b 03                	mov    (%ebx),%eax
80104acc:	83 c4 10             	add    $0x10,%esp
80104acf:	85 c0                	test   %eax,%eax
80104ad1:	75 ed                	jne    80104ac0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104ad3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104ad9:	e8 02 f3 ff ff       	call   80103de0 <myproc>
80104ade:	8b 40 10             	mov    0x10(%eax),%eax
80104ae1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104ae4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104ae7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104aea:	5b                   	pop    %ebx
80104aeb:	5e                   	pop    %esi
80104aec:	5d                   	pop    %ebp
  release(&lk->lk);
80104aed:	e9 9e 02 00 00       	jmp    80104d90 <release>
80104af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
80104b05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b08:	83 ec 0c             	sub    $0xc,%esp
80104b0b:	8d 73 04             	lea    0x4(%ebx),%esi
80104b0e:	56                   	push   %esi
80104b0f:	e8 bc 01 00 00       	call   80104cd0 <acquire>
  lk->locked = 0;
80104b14:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b1a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104b21:	89 1c 24             	mov    %ebx,(%esp)
80104b24:	e8 f7 fd ff ff       	call   80104920 <wakeup>
  release(&lk->lk);
80104b29:	89 75 08             	mov    %esi,0x8(%ebp)
80104b2c:	83 c4 10             	add    $0x10,%esp
}
80104b2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b32:	5b                   	pop    %ebx
80104b33:	5e                   	pop    %esi
80104b34:	5d                   	pop    %ebp
  release(&lk->lk);
80104b35:	e9 56 02 00 00       	jmp    80104d90 <release>
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b40 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	56                   	push   %esi
80104b45:	53                   	push   %ebx
80104b46:	31 ff                	xor    %edi,%edi
80104b48:	83 ec 18             	sub    $0x18,%esp
80104b4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104b4e:	8d 73 04             	lea    0x4(%ebx),%esi
80104b51:	56                   	push   %esi
80104b52:	e8 79 01 00 00       	call   80104cd0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104b57:	8b 03                	mov    (%ebx),%eax
80104b59:	83 c4 10             	add    $0x10,%esp
80104b5c:	85 c0                	test   %eax,%eax
80104b5e:	74 13                	je     80104b73 <holdingsleep+0x33>
80104b60:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104b63:	e8 78 f2 ff ff       	call   80103de0 <myproc>
80104b68:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b6b:	0f 94 c0             	sete   %al
80104b6e:	0f b6 c0             	movzbl %al,%eax
80104b71:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104b73:	83 ec 0c             	sub    $0xc,%esp
80104b76:	56                   	push   %esi
80104b77:	e8 14 02 00 00       	call   80104d90 <release>
  return r;
}
80104b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b7f:	89 f8                	mov    %edi,%eax
80104b81:	5b                   	pop    %ebx
80104b82:	5e                   	pop    %esi
80104b83:	5f                   	pop    %edi
80104b84:	5d                   	pop    %ebp
80104b85:	c3                   	ret    
80104b86:	66 90                	xchg   %ax,%ax
80104b88:	66 90                	xchg   %ax,%ax
80104b8a:	66 90                	xchg   %ax,%ax
80104b8c:	66 90                	xchg   %ax,%ax
80104b8e:	66 90                	xchg   %ax,%ax

80104b90 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b96:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104b9f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104ba2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ba9:	5d                   	pop    %ebp
80104baa:	c3                   	ret    
80104bab:	90                   	nop
80104bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bb0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104bb0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104bb1:	31 d2                	xor    %edx,%edx
{
80104bb3:	89 e5                	mov    %esp,%ebp
80104bb5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104bb6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104bb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104bbc:	83 e8 08             	sub    $0x8,%eax
80104bbf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bc0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104bc6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104bcc:	77 1a                	ja     80104be8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104bce:	8b 58 04             	mov    0x4(%eax),%ebx
80104bd1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104bd4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104bd7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104bd9:	83 fa 0a             	cmp    $0xa,%edx
80104bdc:	75 e2                	jne    80104bc0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104bde:	5b                   	pop    %ebx
80104bdf:	5d                   	pop    %ebp
80104be0:	c3                   	ret    
80104be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104be8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104beb:	83 c1 28             	add    $0x28,%ecx
80104bee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104bf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104bf6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104bf9:	39 c1                	cmp    %eax,%ecx
80104bfb:	75 f3                	jne    80104bf0 <getcallerpcs+0x40>
}
80104bfd:	5b                   	pop    %ebx
80104bfe:	5d                   	pop    %ebp
80104bff:	c3                   	ret    

80104c00 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	53                   	push   %ebx
80104c04:	83 ec 04             	sub    $0x4,%esp
80104c07:	9c                   	pushf  
80104c08:	5b                   	pop    %ebx
  asm volatile("cli");
80104c09:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c0a:	e8 31 f1 ff ff       	call   80103d40 <mycpu>
80104c0f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c15:	85 c0                	test   %eax,%eax
80104c17:	75 11                	jne    80104c2a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104c19:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104c1f:	e8 1c f1 ff ff       	call   80103d40 <mycpu>
80104c24:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104c2a:	e8 11 f1 ff ff       	call   80103d40 <mycpu>
80104c2f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c36:	83 c4 04             	add    $0x4,%esp
80104c39:	5b                   	pop    %ebx
80104c3a:	5d                   	pop    %ebp
80104c3b:	c3                   	ret    
80104c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c40 <popcli>:

void
popcli(void)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c46:	9c                   	pushf  
80104c47:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c48:	f6 c4 02             	test   $0x2,%ah
80104c4b:	75 35                	jne    80104c82 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c4d:	e8 ee f0 ff ff       	call   80103d40 <mycpu>
80104c52:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104c59:	78 34                	js     80104c8f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c5b:	e8 e0 f0 ff ff       	call   80103d40 <mycpu>
80104c60:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c66:	85 d2                	test   %edx,%edx
80104c68:	74 06                	je     80104c70 <popcli+0x30>
    sti();
}
80104c6a:	c9                   	leave  
80104c6b:	c3                   	ret    
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c70:	e8 cb f0 ff ff       	call   80103d40 <mycpu>
80104c75:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c7b:	85 c0                	test   %eax,%eax
80104c7d:	74 eb                	je     80104c6a <popcli+0x2a>
  asm volatile("sti");
80104c7f:	fb                   	sti    
}
80104c80:	c9                   	leave  
80104c81:	c3                   	ret    
    panic("popcli - interruptible");
80104c82:	83 ec 0c             	sub    $0xc,%esp
80104c85:	68 03 82 10 80       	push   $0x80108203
80104c8a:	e8 01 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104c8f:	83 ec 0c             	sub    $0xc,%esp
80104c92:	68 1a 82 10 80       	push   $0x8010821a
80104c97:	e8 f4 b6 ff ff       	call   80100390 <panic>
80104c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ca0 <holding>:
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	53                   	push   %ebx
80104ca5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ca8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104caa:	e8 51 ff ff ff       	call   80104c00 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104caf:	8b 06                	mov    (%esi),%eax
80104cb1:	85 c0                	test   %eax,%eax
80104cb3:	74 10                	je     80104cc5 <holding+0x25>
80104cb5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104cb8:	e8 83 f0 ff ff       	call   80103d40 <mycpu>
80104cbd:	39 c3                	cmp    %eax,%ebx
80104cbf:	0f 94 c3             	sete   %bl
80104cc2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104cc5:	e8 76 ff ff ff       	call   80104c40 <popcli>
}
80104cca:	89 d8                	mov    %ebx,%eax
80104ccc:	5b                   	pop    %ebx
80104ccd:	5e                   	pop    %esi
80104cce:	5d                   	pop    %ebp
80104ccf:	c3                   	ret    

80104cd0 <acquire>:
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	56                   	push   %esi
80104cd4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104cd5:	e8 26 ff ff ff       	call   80104c00 <pushcli>
  if(holding(lk))
80104cda:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cdd:	83 ec 0c             	sub    $0xc,%esp
80104ce0:	53                   	push   %ebx
80104ce1:	e8 ba ff ff ff       	call   80104ca0 <holding>
80104ce6:	83 c4 10             	add    $0x10,%esp
80104ce9:	85 c0                	test   %eax,%eax
80104ceb:	0f 85 83 00 00 00    	jne    80104d74 <acquire+0xa4>
80104cf1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104cf3:	ba 01 00 00 00       	mov    $0x1,%edx
80104cf8:	eb 09                	jmp    80104d03 <acquire+0x33>
80104cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d00:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d03:	89 d0                	mov    %edx,%eax
80104d05:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104d08:	85 c0                	test   %eax,%eax
80104d0a:	75 f4                	jne    80104d00 <acquire+0x30>
  __sync_synchronize();
80104d0c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104d11:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d14:	e8 27 f0 ff ff       	call   80103d40 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104d19:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104d1c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104d1f:	89 e8                	mov    %ebp,%eax
80104d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d28:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104d2e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104d34:	77 1a                	ja     80104d50 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104d36:	8b 48 04             	mov    0x4(%eax),%ecx
80104d39:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104d3c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104d3f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d41:	83 fe 0a             	cmp    $0xa,%esi
80104d44:	75 e2                	jne    80104d28 <acquire+0x58>
}
80104d46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d49:	5b                   	pop    %ebx
80104d4a:	5e                   	pop    %esi
80104d4b:	5d                   	pop    %ebp
80104d4c:	c3                   	ret    
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
80104d50:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104d53:	83 c2 28             	add    $0x28,%edx
80104d56:	8d 76 00             	lea    0x0(%esi),%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104d60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d66:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104d69:	39 d0                	cmp    %edx,%eax
80104d6b:	75 f3                	jne    80104d60 <acquire+0x90>
}
80104d6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d70:	5b                   	pop    %ebx
80104d71:	5e                   	pop    %esi
80104d72:	5d                   	pop    %ebp
80104d73:	c3                   	ret    
    panic("acquire");
80104d74:	83 ec 0c             	sub    $0xc,%esp
80104d77:	68 21 82 10 80       	push   $0x80108221
80104d7c:	e8 0f b6 ff ff       	call   80100390 <panic>
80104d81:	eb 0d                	jmp    80104d90 <release>
80104d83:	90                   	nop
80104d84:	90                   	nop
80104d85:	90                   	nop
80104d86:	90                   	nop
80104d87:	90                   	nop
80104d88:	90                   	nop
80104d89:	90                   	nop
80104d8a:	90                   	nop
80104d8b:	90                   	nop
80104d8c:	90                   	nop
80104d8d:	90                   	nop
80104d8e:	90                   	nop
80104d8f:	90                   	nop

80104d90 <release>:
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	53                   	push   %ebx
80104d94:	83 ec 10             	sub    $0x10,%esp
80104d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104d9a:	53                   	push   %ebx
80104d9b:	e8 00 ff ff ff       	call   80104ca0 <holding>
80104da0:	83 c4 10             	add    $0x10,%esp
80104da3:	85 c0                	test   %eax,%eax
80104da5:	74 22                	je     80104dc9 <release+0x39>
  lk->pcs[0] = 0;
80104da7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104dae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104db5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104dba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104dc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc3:	c9                   	leave  
  popcli();
80104dc4:	e9 77 fe ff ff       	jmp    80104c40 <popcli>
    panic("release");
80104dc9:	83 ec 0c             	sub    $0xc,%esp
80104dcc:	68 29 82 10 80       	push   $0x80108229
80104dd1:	e8 ba b5 ff ff       	call   80100390 <panic>
80104dd6:	66 90                	xchg   %ax,%ax
80104dd8:	66 90                	xchg   %ax,%ax
80104dda:	66 90                	xchg   %ax,%ax
80104ddc:	66 90                	xchg   %ax,%ax
80104dde:	66 90                	xchg   %ax,%ax

80104de0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	57                   	push   %edi
80104de4:	53                   	push   %ebx
80104de5:	8b 55 08             	mov    0x8(%ebp),%edx
80104de8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104deb:	f6 c2 03             	test   $0x3,%dl
80104dee:	75 05                	jne    80104df5 <memset+0x15>
80104df0:	f6 c1 03             	test   $0x3,%cl
80104df3:	74 13                	je     80104e08 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104df5:	89 d7                	mov    %edx,%edi
80104df7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dfa:	fc                   	cld    
80104dfb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104dfd:	5b                   	pop    %ebx
80104dfe:	89 d0                	mov    %edx,%eax
80104e00:	5f                   	pop    %edi
80104e01:	5d                   	pop    %ebp
80104e02:	c3                   	ret    
80104e03:	90                   	nop
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104e08:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104e0c:	c1 e9 02             	shr    $0x2,%ecx
80104e0f:	89 f8                	mov    %edi,%eax
80104e11:	89 fb                	mov    %edi,%ebx
80104e13:	c1 e0 18             	shl    $0x18,%eax
80104e16:	c1 e3 10             	shl    $0x10,%ebx
80104e19:	09 d8                	or     %ebx,%eax
80104e1b:	09 f8                	or     %edi,%eax
80104e1d:	c1 e7 08             	shl    $0x8,%edi
80104e20:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104e22:	89 d7                	mov    %edx,%edi
80104e24:	fc                   	cld    
80104e25:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104e27:	5b                   	pop    %ebx
80104e28:	89 d0                	mov    %edx,%eax
80104e2a:	5f                   	pop    %edi
80104e2b:	5d                   	pop    %ebp
80104e2c:	c3                   	ret    
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi

80104e30 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	57                   	push   %edi
80104e34:	56                   	push   %esi
80104e35:	53                   	push   %ebx
80104e36:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104e39:	8b 75 08             	mov    0x8(%ebp),%esi
80104e3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e3f:	85 db                	test   %ebx,%ebx
80104e41:	74 29                	je     80104e6c <memcmp+0x3c>
    if(*s1 != *s2)
80104e43:	0f b6 16             	movzbl (%esi),%edx
80104e46:	0f b6 0f             	movzbl (%edi),%ecx
80104e49:	38 d1                	cmp    %dl,%cl
80104e4b:	75 2b                	jne    80104e78 <memcmp+0x48>
80104e4d:	b8 01 00 00 00       	mov    $0x1,%eax
80104e52:	eb 14                	jmp    80104e68 <memcmp+0x38>
80104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e58:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104e5c:	83 c0 01             	add    $0x1,%eax
80104e5f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104e64:	38 ca                	cmp    %cl,%dl
80104e66:	75 10                	jne    80104e78 <memcmp+0x48>
  while(n-- > 0){
80104e68:	39 d8                	cmp    %ebx,%eax
80104e6a:	75 ec                	jne    80104e58 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104e6c:	5b                   	pop    %ebx
  return 0;
80104e6d:	31 c0                	xor    %eax,%eax
}
80104e6f:	5e                   	pop    %esi
80104e70:	5f                   	pop    %edi
80104e71:	5d                   	pop    %ebp
80104e72:	c3                   	ret    
80104e73:	90                   	nop
80104e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104e78:	0f b6 c2             	movzbl %dl,%eax
}
80104e7b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104e7c:	29 c8                	sub    %ecx,%eax
}
80104e7e:	5e                   	pop    %esi
80104e7f:	5f                   	pop    %edi
80104e80:	5d                   	pop    %ebp
80104e81:	c3                   	ret    
80104e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
80104e95:	8b 45 08             	mov    0x8(%ebp),%eax
80104e98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e9b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e9e:	39 c3                	cmp    %eax,%ebx
80104ea0:	73 26                	jae    80104ec8 <memmove+0x38>
80104ea2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104ea5:	39 c8                	cmp    %ecx,%eax
80104ea7:	73 1f                	jae    80104ec8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104ea9:	85 f6                	test   %esi,%esi
80104eab:	8d 56 ff             	lea    -0x1(%esi),%edx
80104eae:	74 0f                	je     80104ebf <memmove+0x2f>
      *--d = *--s;
80104eb0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104eb4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104eb7:	83 ea 01             	sub    $0x1,%edx
80104eba:	83 fa ff             	cmp    $0xffffffff,%edx
80104ebd:	75 f1                	jne    80104eb0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104ebf:	5b                   	pop    %ebx
80104ec0:	5e                   	pop    %esi
80104ec1:	5d                   	pop    %ebp
80104ec2:	c3                   	ret    
80104ec3:	90                   	nop
80104ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104ec8:	31 d2                	xor    %edx,%edx
80104eca:	85 f6                	test   %esi,%esi
80104ecc:	74 f1                	je     80104ebf <memmove+0x2f>
80104ece:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104ed0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ed4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ed7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104eda:	39 d6                	cmp    %edx,%esi
80104edc:	75 f2                	jne    80104ed0 <memmove+0x40>
}
80104ede:	5b                   	pop    %ebx
80104edf:	5e                   	pop    %esi
80104ee0:	5d                   	pop    %ebp
80104ee1:	c3                   	ret    
80104ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ef0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104ef3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104ef4:	eb 9a                	jmp    80104e90 <memmove>
80104ef6:	8d 76 00             	lea    0x0(%esi),%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f00 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	57                   	push   %edi
80104f04:	56                   	push   %esi
80104f05:	8b 7d 10             	mov    0x10(%ebp),%edi
80104f08:	53                   	push   %ebx
80104f09:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104f0f:	85 ff                	test   %edi,%edi
80104f11:	74 2f                	je     80104f42 <strncmp+0x42>
80104f13:	0f b6 01             	movzbl (%ecx),%eax
80104f16:	0f b6 1e             	movzbl (%esi),%ebx
80104f19:	84 c0                	test   %al,%al
80104f1b:	74 37                	je     80104f54 <strncmp+0x54>
80104f1d:	38 c3                	cmp    %al,%bl
80104f1f:	75 33                	jne    80104f54 <strncmp+0x54>
80104f21:	01 f7                	add    %esi,%edi
80104f23:	eb 13                	jmp    80104f38 <strncmp+0x38>
80104f25:	8d 76 00             	lea    0x0(%esi),%esi
80104f28:	0f b6 01             	movzbl (%ecx),%eax
80104f2b:	84 c0                	test   %al,%al
80104f2d:	74 21                	je     80104f50 <strncmp+0x50>
80104f2f:	0f b6 1a             	movzbl (%edx),%ebx
80104f32:	89 d6                	mov    %edx,%esi
80104f34:	38 d8                	cmp    %bl,%al
80104f36:	75 1c                	jne    80104f54 <strncmp+0x54>
    n--, p++, q++;
80104f38:	8d 56 01             	lea    0x1(%esi),%edx
80104f3b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104f3e:	39 fa                	cmp    %edi,%edx
80104f40:	75 e6                	jne    80104f28 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104f42:	5b                   	pop    %ebx
    return 0;
80104f43:	31 c0                	xor    %eax,%eax
}
80104f45:	5e                   	pop    %esi
80104f46:	5f                   	pop    %edi
80104f47:	5d                   	pop    %ebp
80104f48:	c3                   	ret    
80104f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f50:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104f54:	29 d8                	sub    %ebx,%eax
}
80104f56:	5b                   	pop    %ebx
80104f57:	5e                   	pop    %esi
80104f58:	5f                   	pop    %edi
80104f59:	5d                   	pop    %ebp
80104f5a:	c3                   	ret    
80104f5b:	90                   	nop
80104f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f60 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
80104f65:	8b 45 08             	mov    0x8(%ebp),%eax
80104f68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104f6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f6e:	89 c2                	mov    %eax,%edx
80104f70:	eb 19                	jmp    80104f8b <strncpy+0x2b>
80104f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f78:	83 c3 01             	add    $0x1,%ebx
80104f7b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104f7f:	83 c2 01             	add    $0x1,%edx
80104f82:	84 c9                	test   %cl,%cl
80104f84:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f87:	74 09                	je     80104f92 <strncpy+0x32>
80104f89:	89 f1                	mov    %esi,%ecx
80104f8b:	85 c9                	test   %ecx,%ecx
80104f8d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104f90:	7f e6                	jg     80104f78 <strncpy+0x18>
    ;
  while(n-- > 0)
80104f92:	31 c9                	xor    %ecx,%ecx
80104f94:	85 f6                	test   %esi,%esi
80104f96:	7e 17                	jle    80104faf <strncpy+0x4f>
80104f98:	90                   	nop
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104fa0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104fa4:	89 f3                	mov    %esi,%ebx
80104fa6:	83 c1 01             	add    $0x1,%ecx
80104fa9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104fab:	85 db                	test   %ebx,%ebx
80104fad:	7f f1                	jg     80104fa0 <strncpy+0x40>
  return os;
}
80104faf:	5b                   	pop    %ebx
80104fb0:	5e                   	pop    %esi
80104fb1:	5d                   	pop    %ebp
80104fb2:	c3                   	ret    
80104fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fc0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
80104fc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80104fcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104fce:	85 c9                	test   %ecx,%ecx
80104fd0:	7e 26                	jle    80104ff8 <safestrcpy+0x38>
80104fd2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104fd6:	89 c1                	mov    %eax,%ecx
80104fd8:	eb 17                	jmp    80104ff1 <safestrcpy+0x31>
80104fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104fe0:	83 c2 01             	add    $0x1,%edx
80104fe3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104fe7:	83 c1 01             	add    $0x1,%ecx
80104fea:	84 db                	test   %bl,%bl
80104fec:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104fef:	74 04                	je     80104ff5 <safestrcpy+0x35>
80104ff1:	39 f2                	cmp    %esi,%edx
80104ff3:	75 eb                	jne    80104fe0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ff5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104ff8:	5b                   	pop    %ebx
80104ff9:	5e                   	pop    %esi
80104ffa:	5d                   	pop    %ebp
80104ffb:	c3                   	ret    
80104ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105000 <strlen>:

int
strlen(const char *s)
{
80105000:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105001:	31 c0                	xor    %eax,%eax
{
80105003:	89 e5                	mov    %esp,%ebp
80105005:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105008:	80 3a 00             	cmpb   $0x0,(%edx)
8010500b:	74 0c                	je     80105019 <strlen+0x19>
8010500d:	8d 76 00             	lea    0x0(%esi),%esi
80105010:	83 c0 01             	add    $0x1,%eax
80105013:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105017:	75 f7                	jne    80105010 <strlen+0x10>
    ;
  return n;
}
80105019:	5d                   	pop    %ebp
8010501a:	c3                   	ret    

8010501b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010501b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010501f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105023:	55                   	push   %ebp
  pushl %ebx
80105024:	53                   	push   %ebx
  pushl %esi
80105025:	56                   	push   %esi
  pushl %edi
80105026:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105027:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105029:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010502b:	5f                   	pop    %edi
  popl %esi
8010502c:	5e                   	pop    %esi
  popl %ebx
8010502d:	5b                   	pop    %ebx
  popl %ebp
8010502e:	5d                   	pop    %ebp
  ret
8010502f:	c3                   	ret    

80105030 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	53                   	push   %ebx
80105034:	83 ec 04             	sub    $0x4,%esp
80105037:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010503a:	e8 a1 ed ff ff       	call   80103de0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010503f:	8b 00                	mov    (%eax),%eax
80105041:	39 d8                	cmp    %ebx,%eax
80105043:	76 1b                	jbe    80105060 <fetchint+0x30>
80105045:	8d 53 04             	lea    0x4(%ebx),%edx
80105048:	39 d0                	cmp    %edx,%eax
8010504a:	72 14                	jb     80105060 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010504c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010504f:	8b 13                	mov    (%ebx),%edx
80105051:	89 10                	mov    %edx,(%eax)
  return 0;
80105053:	31 c0                	xor    %eax,%eax
}
80105055:	83 c4 04             	add    $0x4,%esp
80105058:	5b                   	pop    %ebx
80105059:	5d                   	pop    %ebp
8010505a:	c3                   	ret    
8010505b:	90                   	nop
8010505c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105065:	eb ee                	jmp    80105055 <fetchint+0x25>
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	53                   	push   %ebx
80105074:	83 ec 04             	sub    $0x4,%esp
80105077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010507a:	e8 61 ed ff ff       	call   80103de0 <myproc>

  if(addr >= curproc->sz)
8010507f:	39 18                	cmp    %ebx,(%eax)
80105081:	76 29                	jbe    801050ac <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105083:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105086:	89 da                	mov    %ebx,%edx
80105088:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010508a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010508c:	39 c3                	cmp    %eax,%ebx
8010508e:	73 1c                	jae    801050ac <fetchstr+0x3c>
    if(*s == 0)
80105090:	80 3b 00             	cmpb   $0x0,(%ebx)
80105093:	75 10                	jne    801050a5 <fetchstr+0x35>
80105095:	eb 39                	jmp    801050d0 <fetchstr+0x60>
80105097:	89 f6                	mov    %esi,%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801050a0:	80 3a 00             	cmpb   $0x0,(%edx)
801050a3:	74 1b                	je     801050c0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801050a5:	83 c2 01             	add    $0x1,%edx
801050a8:	39 d0                	cmp    %edx,%eax
801050aa:	77 f4                	ja     801050a0 <fetchstr+0x30>
    return -1;
801050ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801050b1:	83 c4 04             	add    $0x4,%esp
801050b4:	5b                   	pop    %ebx
801050b5:	5d                   	pop    %ebp
801050b6:	c3                   	ret    
801050b7:	89 f6                	mov    %esi,%esi
801050b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801050c0:	83 c4 04             	add    $0x4,%esp
801050c3:	89 d0                	mov    %edx,%eax
801050c5:	29 d8                	sub    %ebx,%eax
801050c7:	5b                   	pop    %ebx
801050c8:	5d                   	pop    %ebp
801050c9:	c3                   	ret    
801050ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801050d0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801050d2:	eb dd                	jmp    801050b1 <fetchstr+0x41>
801050d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801050e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050e5:	e8 f6 ec ff ff       	call   80103de0 <myproc>
801050ea:	8b 40 18             	mov    0x18(%eax),%eax
801050ed:	8b 55 08             	mov    0x8(%ebp),%edx
801050f0:	8b 40 44             	mov    0x44(%eax),%eax
801050f3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801050f6:	e8 e5 ec ff ff       	call   80103de0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050fb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050fd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105100:	39 c6                	cmp    %eax,%esi
80105102:	73 1c                	jae    80105120 <argint+0x40>
80105104:	8d 53 08             	lea    0x8(%ebx),%edx
80105107:	39 d0                	cmp    %edx,%eax
80105109:	72 15                	jb     80105120 <argint+0x40>
  *ip = *(int*)(addr);
8010510b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010510e:	8b 53 04             	mov    0x4(%ebx),%edx
80105111:	89 10                	mov    %edx,(%eax)
  return 0;
80105113:	31 c0                	xor    %eax,%eax
}
80105115:	5b                   	pop    %ebx
80105116:	5e                   	pop    %esi
80105117:	5d                   	pop    %ebp
80105118:	c3                   	ret    
80105119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105125:	eb ee                	jmp    80105115 <argint+0x35>
80105127:	89 f6                	mov    %esi,%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	56                   	push   %esi
80105134:	53                   	push   %ebx
80105135:	83 ec 10             	sub    $0x10,%esp
80105138:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010513b:	e8 a0 ec ff ff       	call   80103de0 <myproc>
80105140:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105142:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105145:	83 ec 08             	sub    $0x8,%esp
80105148:	50                   	push   %eax
80105149:	ff 75 08             	pushl  0x8(%ebp)
8010514c:	e8 8f ff ff ff       	call   801050e0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105151:	83 c4 10             	add    $0x10,%esp
80105154:	85 c0                	test   %eax,%eax
80105156:	78 28                	js     80105180 <argptr+0x50>
80105158:	85 db                	test   %ebx,%ebx
8010515a:	78 24                	js     80105180 <argptr+0x50>
8010515c:	8b 16                	mov    (%esi),%edx
8010515e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105161:	39 c2                	cmp    %eax,%edx
80105163:	76 1b                	jbe    80105180 <argptr+0x50>
80105165:	01 c3                	add    %eax,%ebx
80105167:	39 da                	cmp    %ebx,%edx
80105169:	72 15                	jb     80105180 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010516b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010516e:	89 02                	mov    %eax,(%edx)
  return 0;
80105170:	31 c0                	xor    %eax,%eax
}
80105172:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105175:	5b                   	pop    %ebx
80105176:	5e                   	pop    %esi
80105177:	5d                   	pop    %ebp
80105178:	c3                   	ret    
80105179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105185:	eb eb                	jmp    80105172 <argptr+0x42>
80105187:	89 f6                	mov    %esi,%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105190 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105196:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105199:	50                   	push   %eax
8010519a:	ff 75 08             	pushl  0x8(%ebp)
8010519d:	e8 3e ff ff ff       	call   801050e0 <argint>
801051a2:	83 c4 10             	add    $0x10,%esp
801051a5:	85 c0                	test   %eax,%eax
801051a7:	78 17                	js     801051c0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801051a9:	83 ec 08             	sub    $0x8,%esp
801051ac:	ff 75 0c             	pushl  0xc(%ebp)
801051af:	ff 75 f4             	pushl  -0xc(%ebp)
801051b2:	e8 b9 fe ff ff       	call   80105070 <fetchstr>
801051b7:	83 c4 10             	add    $0x10,%esp
}
801051ba:	c9                   	leave  
801051bb:	c3                   	ret    
801051bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c5:	c9                   	leave  
801051c6:	c3                   	ret    
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <syscall>:
[SYS_procDump]    sys_procDump,
};

void
syscall(void)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	53                   	push   %ebx
801051d4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801051d7:	e8 04 ec ff ff       	call   80103de0 <myproc>
801051dc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801051de:	8b 40 18             	mov    0x18(%eax),%eax
801051e1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801051e4:	8d 50 ff             	lea    -0x1(%eax),%edx
801051e7:	83 fa 16             	cmp    $0x16,%edx
801051ea:	77 1c                	ja     80105208 <syscall+0x38>
801051ec:	8b 14 85 60 82 10 80 	mov    -0x7fef7da0(,%eax,4),%edx
801051f3:	85 d2                	test   %edx,%edx
801051f5:	74 11                	je     80105208 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801051f7:	ff d2                	call   *%edx
801051f9:	8b 53 18             	mov    0x18(%ebx),%edx
801051fc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801051ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105202:	c9                   	leave  
80105203:	c3                   	ret    
80105204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105208:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105209:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010520c:	50                   	push   %eax
8010520d:	ff 73 10             	pushl  0x10(%ebx)
80105210:	68 31 82 10 80       	push   $0x80108231
80105215:	e8 46 b4 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010521a:	8b 43 18             	mov    0x18(%ebx),%eax
8010521d:	83 c4 10             	add    $0x10,%esp
80105220:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105227:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010522a:	c9                   	leave  
8010522b:	c3                   	ret    
8010522c:	66 90                	xchg   %ax,%ax
8010522e:	66 90                	xchg   %ax,%ax

80105230 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	56                   	push   %esi
80105234:	53                   	push   %ebx
80105235:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105237:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010523a:	89 d6                	mov    %edx,%esi
8010523c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010523f:	50                   	push   %eax
80105240:	6a 00                	push   $0x0
80105242:	e8 99 fe ff ff       	call   801050e0 <argint>
80105247:	83 c4 10             	add    $0x10,%esp
8010524a:	85 c0                	test   %eax,%eax
8010524c:	78 2a                	js     80105278 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010524e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105252:	77 24                	ja     80105278 <argfd.constprop.0+0x48>
80105254:	e8 87 eb ff ff       	call   80103de0 <myproc>
80105259:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010525c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105260:	85 c0                	test   %eax,%eax
80105262:	74 14                	je     80105278 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105264:	85 db                	test   %ebx,%ebx
80105266:	74 02                	je     8010526a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105268:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010526a:	89 06                	mov    %eax,(%esi)
  return 0;
8010526c:	31 c0                	xor    %eax,%eax
}
8010526e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105271:	5b                   	pop    %ebx
80105272:	5e                   	pop    %esi
80105273:	5d                   	pop    %ebp
80105274:	c3                   	ret    
80105275:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105278:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527d:	eb ef                	jmp    8010526e <argfd.constprop.0+0x3e>
8010527f:	90                   	nop

80105280 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105280:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105281:	31 c0                	xor    %eax,%eax
{
80105283:	89 e5                	mov    %esp,%ebp
80105285:	56                   	push   %esi
80105286:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105287:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010528a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010528d:	e8 9e ff ff ff       	call   80105230 <argfd.constprop.0>
80105292:	85 c0                	test   %eax,%eax
80105294:	78 42                	js     801052d8 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105296:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105299:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010529b:	e8 40 eb ff ff       	call   80103de0 <myproc>
801052a0:	eb 0e                	jmp    801052b0 <sys_dup+0x30>
801052a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801052a8:	83 c3 01             	add    $0x1,%ebx
801052ab:	83 fb 10             	cmp    $0x10,%ebx
801052ae:	74 28                	je     801052d8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801052b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052b4:	85 d2                	test   %edx,%edx
801052b6:	75 f0                	jne    801052a8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801052b8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
801052bc:	83 ec 0c             	sub    $0xc,%esp
801052bf:	ff 75 f4             	pushl  -0xc(%ebp)
801052c2:	e8 f9 bb ff ff       	call   80100ec0 <filedup>
  return fd;
801052c7:	83 c4 10             	add    $0x10,%esp
}
801052ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052cd:	89 d8                	mov    %ebx,%eax
801052cf:	5b                   	pop    %ebx
801052d0:	5e                   	pop    %esi
801052d1:	5d                   	pop    %ebp
801052d2:	c3                   	ret    
801052d3:	90                   	nop
801052d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801052db:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801052e0:	89 d8                	mov    %ebx,%eax
801052e2:	5b                   	pop    %ebx
801052e3:	5e                   	pop    %esi
801052e4:	5d                   	pop    %ebp
801052e5:	c3                   	ret    
801052e6:	8d 76 00             	lea    0x0(%esi),%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <sys_read>:

int
sys_read(void)
{
801052f0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052f1:	31 c0                	xor    %eax,%eax
{
801052f3:	89 e5                	mov    %esp,%ebp
801052f5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052f8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801052fb:	e8 30 ff ff ff       	call   80105230 <argfd.constprop.0>
80105300:	85 c0                	test   %eax,%eax
80105302:	78 4c                	js     80105350 <sys_read+0x60>
80105304:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105307:	83 ec 08             	sub    $0x8,%esp
8010530a:	50                   	push   %eax
8010530b:	6a 02                	push   $0x2
8010530d:	e8 ce fd ff ff       	call   801050e0 <argint>
80105312:	83 c4 10             	add    $0x10,%esp
80105315:	85 c0                	test   %eax,%eax
80105317:	78 37                	js     80105350 <sys_read+0x60>
80105319:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010531c:	83 ec 04             	sub    $0x4,%esp
8010531f:	ff 75 f0             	pushl  -0x10(%ebp)
80105322:	50                   	push   %eax
80105323:	6a 01                	push   $0x1
80105325:	e8 06 fe ff ff       	call   80105130 <argptr>
8010532a:	83 c4 10             	add    $0x10,%esp
8010532d:	85 c0                	test   %eax,%eax
8010532f:	78 1f                	js     80105350 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105331:	83 ec 04             	sub    $0x4,%esp
80105334:	ff 75 f0             	pushl  -0x10(%ebp)
80105337:	ff 75 f4             	pushl  -0xc(%ebp)
8010533a:	ff 75 ec             	pushl  -0x14(%ebp)
8010533d:	e8 ee bc ff ff       	call   80101030 <fileread>
80105342:	83 c4 10             	add    $0x10,%esp
}
80105345:	c9                   	leave  
80105346:	c3                   	ret    
80105347:	89 f6                	mov    %esi,%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105355:	c9                   	leave  
80105356:	c3                   	ret    
80105357:	89 f6                	mov    %esi,%esi
80105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105360 <sys_write>:

int
sys_write(void)
{
80105360:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105361:	31 c0                	xor    %eax,%eax
{
80105363:	89 e5                	mov    %esp,%ebp
80105365:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105368:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010536b:	e8 c0 fe ff ff       	call   80105230 <argfd.constprop.0>
80105370:	85 c0                	test   %eax,%eax
80105372:	78 4c                	js     801053c0 <sys_write+0x60>
80105374:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105377:	83 ec 08             	sub    $0x8,%esp
8010537a:	50                   	push   %eax
8010537b:	6a 02                	push   $0x2
8010537d:	e8 5e fd ff ff       	call   801050e0 <argint>
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	85 c0                	test   %eax,%eax
80105387:	78 37                	js     801053c0 <sys_write+0x60>
80105389:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010538c:	83 ec 04             	sub    $0x4,%esp
8010538f:	ff 75 f0             	pushl  -0x10(%ebp)
80105392:	50                   	push   %eax
80105393:	6a 01                	push   $0x1
80105395:	e8 96 fd ff ff       	call   80105130 <argptr>
8010539a:	83 c4 10             	add    $0x10,%esp
8010539d:	85 c0                	test   %eax,%eax
8010539f:	78 1f                	js     801053c0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801053a1:	83 ec 04             	sub    $0x4,%esp
801053a4:	ff 75 f0             	pushl  -0x10(%ebp)
801053a7:	ff 75 f4             	pushl  -0xc(%ebp)
801053aa:	ff 75 ec             	pushl  -0x14(%ebp)
801053ad:	e8 0e bd ff ff       	call   801010c0 <filewrite>
801053b2:	83 c4 10             	add    $0x10,%esp
}
801053b5:	c9                   	leave  
801053b6:	c3                   	ret    
801053b7:	89 f6                	mov    %esi,%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801053c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053c5:	c9                   	leave  
801053c6:	c3                   	ret    
801053c7:	89 f6                	mov    %esi,%esi
801053c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053d0 <sys_close>:

int
sys_close(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801053d6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801053d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053dc:	e8 4f fe ff ff       	call   80105230 <argfd.constprop.0>
801053e1:	85 c0                	test   %eax,%eax
801053e3:	78 2b                	js     80105410 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801053e5:	e8 f6 e9 ff ff       	call   80103de0 <myproc>
801053ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801053ed:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801053f0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801053f7:	00 
  fileclose(f);
801053f8:	ff 75 f4             	pushl  -0xc(%ebp)
801053fb:	e8 10 bb ff ff       	call   80100f10 <fileclose>
  return 0;
80105400:	83 c4 10             	add    $0x10,%esp
80105403:	31 c0                	xor    %eax,%eax
}
80105405:	c9                   	leave  
80105406:	c3                   	ret    
80105407:	89 f6                	mov    %esi,%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105415:	c9                   	leave  
80105416:	c3                   	ret    
80105417:	89 f6                	mov    %esi,%esi
80105419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105420 <sys_fstat>:

int
sys_fstat(void)
{
80105420:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105421:	31 c0                	xor    %eax,%eax
{
80105423:	89 e5                	mov    %esp,%ebp
80105425:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105428:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010542b:	e8 00 fe ff ff       	call   80105230 <argfd.constprop.0>
80105430:	85 c0                	test   %eax,%eax
80105432:	78 2c                	js     80105460 <sys_fstat+0x40>
80105434:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105437:	83 ec 04             	sub    $0x4,%esp
8010543a:	6a 14                	push   $0x14
8010543c:	50                   	push   %eax
8010543d:	6a 01                	push   $0x1
8010543f:	e8 ec fc ff ff       	call   80105130 <argptr>
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	85 c0                	test   %eax,%eax
80105449:	78 15                	js     80105460 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010544b:	83 ec 08             	sub    $0x8,%esp
8010544e:	ff 75 f4             	pushl  -0xc(%ebp)
80105451:	ff 75 f0             	pushl  -0x10(%ebp)
80105454:	e8 87 bb ff ff       	call   80100fe0 <filestat>
80105459:	83 c4 10             	add    $0x10,%esp
}
8010545c:	c9                   	leave  
8010545d:	c3                   	ret    
8010545e:	66 90                	xchg   %ax,%ax
    return -1;
80105460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105465:	c9                   	leave  
80105466:	c3                   	ret    
80105467:	89 f6                	mov    %esi,%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105470 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
80105475:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105476:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105479:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010547c:	50                   	push   %eax
8010547d:	6a 00                	push   $0x0
8010547f:	e8 0c fd ff ff       	call   80105190 <argstr>
80105484:	83 c4 10             	add    $0x10,%esp
80105487:	85 c0                	test   %eax,%eax
80105489:	0f 88 fb 00 00 00    	js     8010558a <sys_link+0x11a>
8010548f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105492:	83 ec 08             	sub    $0x8,%esp
80105495:	50                   	push   %eax
80105496:	6a 01                	push   $0x1
80105498:	e8 f3 fc ff ff       	call   80105190 <argstr>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	0f 88 e2 00 00 00    	js     8010558a <sys_link+0x11a>
    return -1;

  begin_op();
801054a8:	e8 a3 db ff ff       	call   80103050 <begin_op>
  if((ip = namei(old)) == 0){
801054ad:	83 ec 0c             	sub    $0xc,%esp
801054b0:	ff 75 d4             	pushl  -0x2c(%ebp)
801054b3:	e8 f8 ca ff ff       	call   80101fb0 <namei>
801054b8:	83 c4 10             	add    $0x10,%esp
801054bb:	85 c0                	test   %eax,%eax
801054bd:	89 c3                	mov    %eax,%ebx
801054bf:	0f 84 ea 00 00 00    	je     801055af <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
801054c5:	83 ec 0c             	sub    $0xc,%esp
801054c8:	50                   	push   %eax
801054c9:	e8 82 c2 ff ff       	call   80101750 <ilock>
  if(ip->type == T_DIR){
801054ce:	83 c4 10             	add    $0x10,%esp
801054d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054d6:	0f 84 bb 00 00 00    	je     80105597 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801054dc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801054e1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801054e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801054e7:	53                   	push   %ebx
801054e8:	e8 b3 c1 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801054ed:	89 1c 24             	mov    %ebx,(%esp)
801054f0:	e8 3b c3 ff ff       	call   80101830 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801054f5:	58                   	pop    %eax
801054f6:	5a                   	pop    %edx
801054f7:	57                   	push   %edi
801054f8:	ff 75 d0             	pushl  -0x30(%ebp)
801054fb:	e8 d0 ca ff ff       	call   80101fd0 <nameiparent>
80105500:	83 c4 10             	add    $0x10,%esp
80105503:	85 c0                	test   %eax,%eax
80105505:	89 c6                	mov    %eax,%esi
80105507:	74 5b                	je     80105564 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105509:	83 ec 0c             	sub    $0xc,%esp
8010550c:	50                   	push   %eax
8010550d:	e8 3e c2 ff ff       	call   80101750 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105512:	83 c4 10             	add    $0x10,%esp
80105515:	8b 03                	mov    (%ebx),%eax
80105517:	39 06                	cmp    %eax,(%esi)
80105519:	75 3d                	jne    80105558 <sys_link+0xe8>
8010551b:	83 ec 04             	sub    $0x4,%esp
8010551e:	ff 73 04             	pushl  0x4(%ebx)
80105521:	57                   	push   %edi
80105522:	56                   	push   %esi
80105523:	e8 c8 c9 ff ff       	call   80101ef0 <dirlink>
80105528:	83 c4 10             	add    $0x10,%esp
8010552b:	85 c0                	test   %eax,%eax
8010552d:	78 29                	js     80105558 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010552f:	83 ec 0c             	sub    $0xc,%esp
80105532:	56                   	push   %esi
80105533:	e8 a8 c4 ff ff       	call   801019e0 <iunlockput>
  iput(ip);
80105538:	89 1c 24             	mov    %ebx,(%esp)
8010553b:	e8 40 c3 ff ff       	call   80101880 <iput>

  end_op();
80105540:	e8 7b db ff ff       	call   801030c0 <end_op>

  return 0;
80105545:	83 c4 10             	add    $0x10,%esp
80105548:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010554a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010554d:	5b                   	pop    %ebx
8010554e:	5e                   	pop    %esi
8010554f:	5f                   	pop    %edi
80105550:	5d                   	pop    %ebp
80105551:	c3                   	ret    
80105552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105558:	83 ec 0c             	sub    $0xc,%esp
8010555b:	56                   	push   %esi
8010555c:	e8 7f c4 ff ff       	call   801019e0 <iunlockput>
    goto bad;
80105561:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105564:	83 ec 0c             	sub    $0xc,%esp
80105567:	53                   	push   %ebx
80105568:	e8 e3 c1 ff ff       	call   80101750 <ilock>
  ip->nlink--;
8010556d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105572:	89 1c 24             	mov    %ebx,(%esp)
80105575:	e8 26 c1 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
8010557a:	89 1c 24             	mov    %ebx,(%esp)
8010557d:	e8 5e c4 ff ff       	call   801019e0 <iunlockput>
  end_op();
80105582:	e8 39 db ff ff       	call   801030c0 <end_op>
  return -1;
80105587:	83 c4 10             	add    $0x10,%esp
}
8010558a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010558d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105592:	5b                   	pop    %ebx
80105593:	5e                   	pop    %esi
80105594:	5f                   	pop    %edi
80105595:	5d                   	pop    %ebp
80105596:	c3                   	ret    
    iunlockput(ip);
80105597:	83 ec 0c             	sub    $0xc,%esp
8010559a:	53                   	push   %ebx
8010559b:	e8 40 c4 ff ff       	call   801019e0 <iunlockput>
    end_op();
801055a0:	e8 1b db ff ff       	call   801030c0 <end_op>
    return -1;
801055a5:	83 c4 10             	add    $0x10,%esp
801055a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ad:	eb 9b                	jmp    8010554a <sys_link+0xda>
    end_op();
801055af:	e8 0c db ff ff       	call   801030c0 <end_op>
    return -1;
801055b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b9:	eb 8f                	jmp    8010554a <sys_link+0xda>
801055bb:	90                   	nop
801055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055c0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	57                   	push   %edi
801055c4:	56                   	push   %esi
801055c5:	53                   	push   %ebx
801055c6:	83 ec 1c             	sub    $0x1c,%esp
801055c9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801055cc:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801055d0:	76 3e                	jbe    80105610 <isdirempty+0x50>
801055d2:	bb 20 00 00 00       	mov    $0x20,%ebx
801055d7:	8d 7d d8             	lea    -0x28(%ebp),%edi
801055da:	eb 0c                	jmp    801055e8 <isdirempty+0x28>
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055e0:	83 c3 10             	add    $0x10,%ebx
801055e3:	3b 5e 58             	cmp    0x58(%esi),%ebx
801055e6:	73 28                	jae    80105610 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055e8:	6a 10                	push   $0x10
801055ea:	53                   	push   %ebx
801055eb:	57                   	push   %edi
801055ec:	56                   	push   %esi
801055ed:	e8 3e c4 ff ff       	call   80101a30 <readi>
801055f2:	83 c4 10             	add    $0x10,%esp
801055f5:	83 f8 10             	cmp    $0x10,%eax
801055f8:	75 23                	jne    8010561d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801055fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801055ff:	74 df                	je     801055e0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105601:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105604:	31 c0                	xor    %eax,%eax
}
80105606:	5b                   	pop    %ebx
80105607:	5e                   	pop    %esi
80105608:	5f                   	pop    %edi
80105609:	5d                   	pop    %ebp
8010560a:	c3                   	ret    
8010560b:	90                   	nop
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105610:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105613:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105618:	5b                   	pop    %ebx
80105619:	5e                   	pop    %esi
8010561a:	5f                   	pop    %edi
8010561b:	5d                   	pop    %ebp
8010561c:	c3                   	ret    
      panic("isdirempty: readi");
8010561d:	83 ec 0c             	sub    $0xc,%esp
80105620:	68 c0 82 10 80       	push   $0x801082c0
80105625:	e8 66 ad ff ff       	call   80100390 <panic>
8010562a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105630 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	57                   	push   %edi
80105634:	56                   	push   %esi
80105635:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105636:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105639:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010563c:	50                   	push   %eax
8010563d:	6a 00                	push   $0x0
8010563f:	e8 4c fb ff ff       	call   80105190 <argstr>
80105644:	83 c4 10             	add    $0x10,%esp
80105647:	85 c0                	test   %eax,%eax
80105649:	0f 88 51 01 00 00    	js     801057a0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010564f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105652:	e8 f9 d9 ff ff       	call   80103050 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105657:	83 ec 08             	sub    $0x8,%esp
8010565a:	53                   	push   %ebx
8010565b:	ff 75 c0             	pushl  -0x40(%ebp)
8010565e:	e8 6d c9 ff ff       	call   80101fd0 <nameiparent>
80105663:	83 c4 10             	add    $0x10,%esp
80105666:	85 c0                	test   %eax,%eax
80105668:	89 c6                	mov    %eax,%esi
8010566a:	0f 84 37 01 00 00    	je     801057a7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	50                   	push   %eax
80105674:	e8 d7 c0 ff ff       	call   80101750 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105679:	58                   	pop    %eax
8010567a:	5a                   	pop    %edx
8010567b:	68 9d 7b 10 80       	push   $0x80107b9d
80105680:	53                   	push   %ebx
80105681:	e8 da c5 ff ff       	call   80101c60 <namecmp>
80105686:	83 c4 10             	add    $0x10,%esp
80105689:	85 c0                	test   %eax,%eax
8010568b:	0f 84 d7 00 00 00    	je     80105768 <sys_unlink+0x138>
80105691:	83 ec 08             	sub    $0x8,%esp
80105694:	68 9c 7b 10 80       	push   $0x80107b9c
80105699:	53                   	push   %ebx
8010569a:	e8 c1 c5 ff ff       	call   80101c60 <namecmp>
8010569f:	83 c4 10             	add    $0x10,%esp
801056a2:	85 c0                	test   %eax,%eax
801056a4:	0f 84 be 00 00 00    	je     80105768 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801056aa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801056ad:	83 ec 04             	sub    $0x4,%esp
801056b0:	50                   	push   %eax
801056b1:	53                   	push   %ebx
801056b2:	56                   	push   %esi
801056b3:	e8 c8 c5 ff ff       	call   80101c80 <dirlookup>
801056b8:	83 c4 10             	add    $0x10,%esp
801056bb:	85 c0                	test   %eax,%eax
801056bd:	89 c3                	mov    %eax,%ebx
801056bf:	0f 84 a3 00 00 00    	je     80105768 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
801056c5:	83 ec 0c             	sub    $0xc,%esp
801056c8:	50                   	push   %eax
801056c9:	e8 82 c0 ff ff       	call   80101750 <ilock>

  if(ip->nlink < 1)
801056ce:	83 c4 10             	add    $0x10,%esp
801056d1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801056d6:	0f 8e e4 00 00 00    	jle    801057c0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801056dc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056e1:	74 65                	je     80105748 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801056e3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801056e6:	83 ec 04             	sub    $0x4,%esp
801056e9:	6a 10                	push   $0x10
801056eb:	6a 00                	push   $0x0
801056ed:	57                   	push   %edi
801056ee:	e8 ed f6 ff ff       	call   80104de0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056f3:	6a 10                	push   $0x10
801056f5:	ff 75 c4             	pushl  -0x3c(%ebp)
801056f8:	57                   	push   %edi
801056f9:	56                   	push   %esi
801056fa:	e8 31 c4 ff ff       	call   80101b30 <writei>
801056ff:	83 c4 20             	add    $0x20,%esp
80105702:	83 f8 10             	cmp    $0x10,%eax
80105705:	0f 85 a8 00 00 00    	jne    801057b3 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010570b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105710:	74 6e                	je     80105780 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105712:	83 ec 0c             	sub    $0xc,%esp
80105715:	56                   	push   %esi
80105716:	e8 c5 c2 ff ff       	call   801019e0 <iunlockput>

  ip->nlink--;
8010571b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105720:	89 1c 24             	mov    %ebx,(%esp)
80105723:	e8 78 bf ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105728:	89 1c 24             	mov    %ebx,(%esp)
8010572b:	e8 b0 c2 ff ff       	call   801019e0 <iunlockput>

  end_op();
80105730:	e8 8b d9 ff ff       	call   801030c0 <end_op>

  return 0;
80105735:	83 c4 10             	add    $0x10,%esp
80105738:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010573a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010573d:	5b                   	pop    %ebx
8010573e:	5e                   	pop    %esi
8010573f:	5f                   	pop    %edi
80105740:	5d                   	pop    %ebp
80105741:	c3                   	ret    
80105742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105748:	83 ec 0c             	sub    $0xc,%esp
8010574b:	53                   	push   %ebx
8010574c:	e8 6f fe ff ff       	call   801055c0 <isdirempty>
80105751:	83 c4 10             	add    $0x10,%esp
80105754:	85 c0                	test   %eax,%eax
80105756:	75 8b                	jne    801056e3 <sys_unlink+0xb3>
    iunlockput(ip);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	53                   	push   %ebx
8010575c:	e8 7f c2 ff ff       	call   801019e0 <iunlockput>
    goto bad;
80105761:	83 c4 10             	add    $0x10,%esp
80105764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105768:	83 ec 0c             	sub    $0xc,%esp
8010576b:	56                   	push   %esi
8010576c:	e8 6f c2 ff ff       	call   801019e0 <iunlockput>
  end_op();
80105771:	e8 4a d9 ff ff       	call   801030c0 <end_op>
  return -1;
80105776:	83 c4 10             	add    $0x10,%esp
80105779:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577e:	eb ba                	jmp    8010573a <sys_unlink+0x10a>
    dp->nlink--;
80105780:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105785:	83 ec 0c             	sub    $0xc,%esp
80105788:	56                   	push   %esi
80105789:	e8 12 bf ff ff       	call   801016a0 <iupdate>
8010578e:	83 c4 10             	add    $0x10,%esp
80105791:	e9 7c ff ff ff       	jmp    80105712 <sys_unlink+0xe2>
80105796:	8d 76 00             	lea    0x0(%esi),%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801057a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a5:	eb 93                	jmp    8010573a <sys_unlink+0x10a>
    end_op();
801057a7:	e8 14 d9 ff ff       	call   801030c0 <end_op>
    return -1;
801057ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b1:	eb 87                	jmp    8010573a <sys_unlink+0x10a>
    panic("unlink: writei");
801057b3:	83 ec 0c             	sub    $0xc,%esp
801057b6:	68 b1 7b 10 80       	push   $0x80107bb1
801057bb:	e8 d0 ab ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	68 9f 7b 10 80       	push   $0x80107b9f
801057c8:	e8 c3 ab ff ff       	call   80100390 <panic>
801057cd:	8d 76 00             	lea    0x0(%esi),%esi

801057d0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
801057d5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801057d6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801057d9:	83 ec 34             	sub    $0x34,%esp
801057dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801057df:	8b 55 10             	mov    0x10(%ebp),%edx
801057e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801057e5:	56                   	push   %esi
801057e6:	ff 75 08             	pushl  0x8(%ebp)
{
801057e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801057ec:	89 55 d0             	mov    %edx,-0x30(%ebp)
801057ef:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801057f2:	e8 d9 c7 ff ff       	call   80101fd0 <nameiparent>
801057f7:	83 c4 10             	add    $0x10,%esp
801057fa:	85 c0                	test   %eax,%eax
801057fc:	0f 84 4e 01 00 00    	je     80105950 <create+0x180>
    return 0;
  ilock(dp);
80105802:	83 ec 0c             	sub    $0xc,%esp
80105805:	89 c3                	mov    %eax,%ebx
80105807:	50                   	push   %eax
80105808:	e8 43 bf ff ff       	call   80101750 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
8010580d:	83 c4 0c             	add    $0xc,%esp
80105810:	6a 00                	push   $0x0
80105812:	56                   	push   %esi
80105813:	53                   	push   %ebx
80105814:	e8 67 c4 ff ff       	call   80101c80 <dirlookup>
80105819:	83 c4 10             	add    $0x10,%esp
8010581c:	85 c0                	test   %eax,%eax
8010581e:	89 c7                	mov    %eax,%edi
80105820:	74 3e                	je     80105860 <create+0x90>
    iunlockput(dp);
80105822:	83 ec 0c             	sub    $0xc,%esp
80105825:	53                   	push   %ebx
80105826:	e8 b5 c1 ff ff       	call   801019e0 <iunlockput>
    ilock(ip);
8010582b:	89 3c 24             	mov    %edi,(%esp)
8010582e:	e8 1d bf ff ff       	call   80101750 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105833:	83 c4 10             	add    $0x10,%esp
80105836:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010583b:	0f 85 9f 00 00 00    	jne    801058e0 <create+0x110>
80105841:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105846:	0f 85 94 00 00 00    	jne    801058e0 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010584c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010584f:	89 f8                	mov    %edi,%eax
80105851:	5b                   	pop    %ebx
80105852:	5e                   	pop    %esi
80105853:	5f                   	pop    %edi
80105854:	5d                   	pop    %ebp
80105855:	c3                   	ret    
80105856:	8d 76 00             	lea    0x0(%esi),%esi
80105859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105860:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105864:	83 ec 08             	sub    $0x8,%esp
80105867:	50                   	push   %eax
80105868:	ff 33                	pushl  (%ebx)
8010586a:	e8 71 bd ff ff       	call   801015e0 <ialloc>
8010586f:	83 c4 10             	add    $0x10,%esp
80105872:	85 c0                	test   %eax,%eax
80105874:	89 c7                	mov    %eax,%edi
80105876:	0f 84 e8 00 00 00    	je     80105964 <create+0x194>
  ilock(ip);
8010587c:	83 ec 0c             	sub    $0xc,%esp
8010587f:	50                   	push   %eax
80105880:	e8 cb be ff ff       	call   80101750 <ilock>
  ip->major = major;
80105885:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105889:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010588d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105891:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105895:	b8 01 00 00 00       	mov    $0x1,%eax
8010589a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010589e:	89 3c 24             	mov    %edi,(%esp)
801058a1:	e8 fa bd ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801058a6:	83 c4 10             	add    $0x10,%esp
801058a9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801058ae:	74 50                	je     80105900 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
801058b0:	83 ec 04             	sub    $0x4,%esp
801058b3:	ff 77 04             	pushl  0x4(%edi)
801058b6:	56                   	push   %esi
801058b7:	53                   	push   %ebx
801058b8:	e8 33 c6 ff ff       	call   80101ef0 <dirlink>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	85 c0                	test   %eax,%eax
801058c2:	0f 88 8f 00 00 00    	js     80105957 <create+0x187>
  iunlockput(dp);
801058c8:	83 ec 0c             	sub    $0xc,%esp
801058cb:	53                   	push   %ebx
801058cc:	e8 0f c1 ff ff       	call   801019e0 <iunlockput>
  return ip;
801058d1:	83 c4 10             	add    $0x10,%esp
}
801058d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058d7:	89 f8                	mov    %edi,%eax
801058d9:	5b                   	pop    %ebx
801058da:	5e                   	pop    %esi
801058db:	5f                   	pop    %edi
801058dc:	5d                   	pop    %ebp
801058dd:	c3                   	ret    
801058de:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	57                   	push   %edi
    return 0;
801058e4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801058e6:	e8 f5 c0 ff ff       	call   801019e0 <iunlockput>
    return 0;
801058eb:	83 c4 10             	add    $0x10,%esp
}
801058ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058f1:	89 f8                	mov    %edi,%eax
801058f3:	5b                   	pop    %ebx
801058f4:	5e                   	pop    %esi
801058f5:	5f                   	pop    %edi
801058f6:	5d                   	pop    %ebp
801058f7:	c3                   	ret    
801058f8:	90                   	nop
801058f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105900:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105905:	83 ec 0c             	sub    $0xc,%esp
80105908:	53                   	push   %ebx
80105909:	e8 92 bd ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010590e:	83 c4 0c             	add    $0xc,%esp
80105911:	ff 77 04             	pushl  0x4(%edi)
80105914:	68 9d 7b 10 80       	push   $0x80107b9d
80105919:	57                   	push   %edi
8010591a:	e8 d1 c5 ff ff       	call   80101ef0 <dirlink>
8010591f:	83 c4 10             	add    $0x10,%esp
80105922:	85 c0                	test   %eax,%eax
80105924:	78 1c                	js     80105942 <create+0x172>
80105926:	83 ec 04             	sub    $0x4,%esp
80105929:	ff 73 04             	pushl  0x4(%ebx)
8010592c:	68 9c 7b 10 80       	push   $0x80107b9c
80105931:	57                   	push   %edi
80105932:	e8 b9 c5 ff ff       	call   80101ef0 <dirlink>
80105937:	83 c4 10             	add    $0x10,%esp
8010593a:	85 c0                	test   %eax,%eax
8010593c:	0f 89 6e ff ff ff    	jns    801058b0 <create+0xe0>
      panic("create dots");
80105942:	83 ec 0c             	sub    $0xc,%esp
80105945:	68 e1 82 10 80       	push   $0x801082e1
8010594a:	e8 41 aa ff ff       	call   80100390 <panic>
8010594f:	90                   	nop
    return 0;
80105950:	31 ff                	xor    %edi,%edi
80105952:	e9 f5 fe ff ff       	jmp    8010584c <create+0x7c>
    panic("create: dirlink");
80105957:	83 ec 0c             	sub    $0xc,%esp
8010595a:	68 ed 82 10 80       	push   $0x801082ed
8010595f:	e8 2c aa ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105964:	83 ec 0c             	sub    $0xc,%esp
80105967:	68 d2 82 10 80       	push   $0x801082d2
8010596c:	e8 1f aa ff ff       	call   80100390 <panic>
80105971:	eb 0d                	jmp    80105980 <sys_open>
80105973:	90                   	nop
80105974:	90                   	nop
80105975:	90                   	nop
80105976:	90                   	nop
80105977:	90                   	nop
80105978:	90                   	nop
80105979:	90                   	nop
8010597a:	90                   	nop
8010597b:	90                   	nop
8010597c:	90                   	nop
8010597d:	90                   	nop
8010597e:	90                   	nop
8010597f:	90                   	nop

80105980 <sys_open>:

int
sys_open(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	57                   	push   %edi
80105984:	56                   	push   %esi
80105985:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105986:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105989:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010598c:	50                   	push   %eax
8010598d:	6a 00                	push   $0x0
8010598f:	e8 fc f7 ff ff       	call   80105190 <argstr>
80105994:	83 c4 10             	add    $0x10,%esp
80105997:	85 c0                	test   %eax,%eax
80105999:	0f 88 1d 01 00 00    	js     80105abc <sys_open+0x13c>
8010599f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059a2:	83 ec 08             	sub    $0x8,%esp
801059a5:	50                   	push   %eax
801059a6:	6a 01                	push   $0x1
801059a8:	e8 33 f7 ff ff       	call   801050e0 <argint>
801059ad:	83 c4 10             	add    $0x10,%esp
801059b0:	85 c0                	test   %eax,%eax
801059b2:	0f 88 04 01 00 00    	js     80105abc <sys_open+0x13c>
    return -1;

  begin_op();
801059b8:	e8 93 d6 ff ff       	call   80103050 <begin_op>

  if(omode & O_CREATE){
801059bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801059c1:	0f 85 a9 00 00 00    	jne    80105a70 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801059c7:	83 ec 0c             	sub    $0xc,%esp
801059ca:	ff 75 e0             	pushl  -0x20(%ebp)
801059cd:	e8 de c5 ff ff       	call   80101fb0 <namei>
801059d2:	83 c4 10             	add    $0x10,%esp
801059d5:	85 c0                	test   %eax,%eax
801059d7:	89 c6                	mov    %eax,%esi
801059d9:	0f 84 ac 00 00 00    	je     80105a8b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
801059df:	83 ec 0c             	sub    $0xc,%esp
801059e2:	50                   	push   %eax
801059e3:	e8 68 bd ff ff       	call   80101750 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801059e8:	83 c4 10             	add    $0x10,%esp
801059eb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801059f0:	0f 84 aa 00 00 00    	je     80105aa0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801059f6:	e8 55 b4 ff ff       	call   80100e50 <filealloc>
801059fb:	85 c0                	test   %eax,%eax
801059fd:	89 c7                	mov    %eax,%edi
801059ff:	0f 84 a6 00 00 00    	je     80105aab <sys_open+0x12b>
  struct proc *curproc = myproc();
80105a05:	e8 d6 e3 ff ff       	call   80103de0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a0a:	31 db                	xor    %ebx,%ebx
80105a0c:	eb 0e                	jmp    80105a1c <sys_open+0x9c>
80105a0e:	66 90                	xchg   %ax,%ax
80105a10:	83 c3 01             	add    $0x1,%ebx
80105a13:	83 fb 10             	cmp    $0x10,%ebx
80105a16:	0f 84 ac 00 00 00    	je     80105ac8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105a1c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105a20:	85 d2                	test   %edx,%edx
80105a22:	75 ec                	jne    80105a10 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a24:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105a27:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105a2b:	56                   	push   %esi
80105a2c:	e8 ff bd ff ff       	call   80101830 <iunlock>
  end_op();
80105a31:	e8 8a d6 ff ff       	call   801030c0 <end_op>

  f->type = FD_INODE;
80105a36:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a3f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105a42:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105a45:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105a4c:	89 d0                	mov    %edx,%eax
80105a4e:	f7 d0                	not    %eax
80105a50:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a53:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105a56:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a59:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105a5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a60:	89 d8                	mov    %ebx,%eax
80105a62:	5b                   	pop    %ebx
80105a63:	5e                   	pop    %esi
80105a64:	5f                   	pop    %edi
80105a65:	5d                   	pop    %ebp
80105a66:	c3                   	ret    
80105a67:	89 f6                	mov    %esi,%esi
80105a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105a70:	6a 00                	push   $0x0
80105a72:	6a 00                	push   $0x0
80105a74:	6a 02                	push   $0x2
80105a76:	ff 75 e0             	pushl  -0x20(%ebp)
80105a79:	e8 52 fd ff ff       	call   801057d0 <create>
    if(ip == 0){
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105a83:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105a85:	0f 85 6b ff ff ff    	jne    801059f6 <sys_open+0x76>
      end_op();
80105a8b:	e8 30 d6 ff ff       	call   801030c0 <end_op>
      return -1;
80105a90:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a95:	eb c6                	jmp    80105a5d <sys_open+0xdd>
80105a97:	89 f6                	mov    %esi,%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105aa0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105aa3:	85 c9                	test   %ecx,%ecx
80105aa5:	0f 84 4b ff ff ff    	je     801059f6 <sys_open+0x76>
    iunlockput(ip);
80105aab:	83 ec 0c             	sub    $0xc,%esp
80105aae:	56                   	push   %esi
80105aaf:	e8 2c bf ff ff       	call   801019e0 <iunlockput>
    end_op();
80105ab4:	e8 07 d6 ff ff       	call   801030c0 <end_op>
    return -1;
80105ab9:	83 c4 10             	add    $0x10,%esp
80105abc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ac1:	eb 9a                	jmp    80105a5d <sys_open+0xdd>
80105ac3:	90                   	nop
80105ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105ac8:	83 ec 0c             	sub    $0xc,%esp
80105acb:	57                   	push   %edi
80105acc:	e8 3f b4 ff ff       	call   80100f10 <fileclose>
80105ad1:	83 c4 10             	add    $0x10,%esp
80105ad4:	eb d5                	jmp    80105aab <sys_open+0x12b>
80105ad6:	8d 76 00             	lea    0x0(%esi),%esi
80105ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ae0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ae6:	e8 65 d5 ff ff       	call   80103050 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105aeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aee:	83 ec 08             	sub    $0x8,%esp
80105af1:	50                   	push   %eax
80105af2:	6a 00                	push   $0x0
80105af4:	e8 97 f6 ff ff       	call   80105190 <argstr>
80105af9:	83 c4 10             	add    $0x10,%esp
80105afc:	85 c0                	test   %eax,%eax
80105afe:	78 30                	js     80105b30 <sys_mkdir+0x50>
80105b00:	6a 00                	push   $0x0
80105b02:	6a 00                	push   $0x0
80105b04:	6a 01                	push   $0x1
80105b06:	ff 75 f4             	pushl  -0xc(%ebp)
80105b09:	e8 c2 fc ff ff       	call   801057d0 <create>
80105b0e:	83 c4 10             	add    $0x10,%esp
80105b11:	85 c0                	test   %eax,%eax
80105b13:	74 1b                	je     80105b30 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b15:	83 ec 0c             	sub    $0xc,%esp
80105b18:	50                   	push   %eax
80105b19:	e8 c2 be ff ff       	call   801019e0 <iunlockput>
  end_op();
80105b1e:	e8 9d d5 ff ff       	call   801030c0 <end_op>
  return 0;
80105b23:	83 c4 10             	add    $0x10,%esp
80105b26:	31 c0                	xor    %eax,%eax
}
80105b28:	c9                   	leave  
80105b29:	c3                   	ret    
80105b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105b30:	e8 8b d5 ff ff       	call   801030c0 <end_op>
    return -1;
80105b35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b3a:	c9                   	leave  
80105b3b:	c3                   	ret    
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b40 <sys_mknod>:

int
sys_mknod(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105b46:	e8 05 d5 ff ff       	call   80103050 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105b4b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b4e:	83 ec 08             	sub    $0x8,%esp
80105b51:	50                   	push   %eax
80105b52:	6a 00                	push   $0x0
80105b54:	e8 37 f6 ff ff       	call   80105190 <argstr>
80105b59:	83 c4 10             	add    $0x10,%esp
80105b5c:	85 c0                	test   %eax,%eax
80105b5e:	78 60                	js     80105bc0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105b60:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b63:	83 ec 08             	sub    $0x8,%esp
80105b66:	50                   	push   %eax
80105b67:	6a 01                	push   $0x1
80105b69:	e8 72 f5 ff ff       	call   801050e0 <argint>
  if((argstr(0, &path)) < 0 ||
80105b6e:	83 c4 10             	add    $0x10,%esp
80105b71:	85 c0                	test   %eax,%eax
80105b73:	78 4b                	js     80105bc0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105b75:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b78:	83 ec 08             	sub    $0x8,%esp
80105b7b:	50                   	push   %eax
80105b7c:	6a 02                	push   $0x2
80105b7e:	e8 5d f5 ff ff       	call   801050e0 <argint>
     argint(1, &major) < 0 ||
80105b83:	83 c4 10             	add    $0x10,%esp
80105b86:	85 c0                	test   %eax,%eax
80105b88:	78 36                	js     80105bc0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105b8a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105b8e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
80105b8f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105b93:	50                   	push   %eax
80105b94:	6a 03                	push   $0x3
80105b96:	ff 75 ec             	pushl  -0x14(%ebp)
80105b99:	e8 32 fc ff ff       	call   801057d0 <create>
80105b9e:	83 c4 10             	add    $0x10,%esp
80105ba1:	85 c0                	test   %eax,%eax
80105ba3:	74 1b                	je     80105bc0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105ba5:	83 ec 0c             	sub    $0xc,%esp
80105ba8:	50                   	push   %eax
80105ba9:	e8 32 be ff ff       	call   801019e0 <iunlockput>
  end_op();
80105bae:	e8 0d d5 ff ff       	call   801030c0 <end_op>
  return 0;
80105bb3:	83 c4 10             	add    $0x10,%esp
80105bb6:	31 c0                	xor    %eax,%eax
}
80105bb8:	c9                   	leave  
80105bb9:	c3                   	ret    
80105bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105bc0:	e8 fb d4 ff ff       	call   801030c0 <end_op>
    return -1;
80105bc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bca:	c9                   	leave  
80105bcb:	c3                   	ret    
80105bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <sys_chdir>:

int
sys_chdir(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	56                   	push   %esi
80105bd4:	53                   	push   %ebx
80105bd5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105bd8:	e8 03 e2 ff ff       	call   80103de0 <myproc>
80105bdd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105bdf:	e8 6c d4 ff ff       	call   80103050 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105be4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105be7:	83 ec 08             	sub    $0x8,%esp
80105bea:	50                   	push   %eax
80105beb:	6a 00                	push   $0x0
80105bed:	e8 9e f5 ff ff       	call   80105190 <argstr>
80105bf2:	83 c4 10             	add    $0x10,%esp
80105bf5:	85 c0                	test   %eax,%eax
80105bf7:	78 77                	js     80105c70 <sys_chdir+0xa0>
80105bf9:	83 ec 0c             	sub    $0xc,%esp
80105bfc:	ff 75 f4             	pushl  -0xc(%ebp)
80105bff:	e8 ac c3 ff ff       	call   80101fb0 <namei>
80105c04:	83 c4 10             	add    $0x10,%esp
80105c07:	85 c0                	test   %eax,%eax
80105c09:	89 c3                	mov    %eax,%ebx
80105c0b:	74 63                	je     80105c70 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c0d:	83 ec 0c             	sub    $0xc,%esp
80105c10:	50                   	push   %eax
80105c11:	e8 3a bb ff ff       	call   80101750 <ilock>
  if(ip->type != T_DIR){
80105c16:	83 c4 10             	add    $0x10,%esp
80105c19:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c1e:	75 30                	jne    80105c50 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c20:	83 ec 0c             	sub    $0xc,%esp
80105c23:	53                   	push   %ebx
80105c24:	e8 07 bc ff ff       	call   80101830 <iunlock>
  iput(curproc->cwd);
80105c29:	58                   	pop    %eax
80105c2a:	ff 76 68             	pushl  0x68(%esi)
80105c2d:	e8 4e bc ff ff       	call   80101880 <iput>
  end_op();
80105c32:	e8 89 d4 ff ff       	call   801030c0 <end_op>
  curproc->cwd = ip;
80105c37:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105c3a:	83 c4 10             	add    $0x10,%esp
80105c3d:	31 c0                	xor    %eax,%eax
}
80105c3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c42:	5b                   	pop    %ebx
80105c43:	5e                   	pop    %esi
80105c44:	5d                   	pop    %ebp
80105c45:	c3                   	ret    
80105c46:	8d 76 00             	lea    0x0(%esi),%esi
80105c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105c50:	83 ec 0c             	sub    $0xc,%esp
80105c53:	53                   	push   %ebx
80105c54:	e8 87 bd ff ff       	call   801019e0 <iunlockput>
    end_op();
80105c59:	e8 62 d4 ff ff       	call   801030c0 <end_op>
    return -1;
80105c5e:	83 c4 10             	add    $0x10,%esp
80105c61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c66:	eb d7                	jmp    80105c3f <sys_chdir+0x6f>
80105c68:	90                   	nop
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105c70:	e8 4b d4 ff ff       	call   801030c0 <end_op>
    return -1;
80105c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c7a:	eb c3                	jmp    80105c3f <sys_chdir+0x6f>
80105c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_exec>:

int
sys_exec(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	57                   	push   %edi
80105c84:	56                   	push   %esi
80105c85:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c86:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105c8c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c92:	50                   	push   %eax
80105c93:	6a 00                	push   $0x0
80105c95:	e8 f6 f4 ff ff       	call   80105190 <argstr>
80105c9a:	83 c4 10             	add    $0x10,%esp
80105c9d:	85 c0                	test   %eax,%eax
80105c9f:	0f 88 87 00 00 00    	js     80105d2c <sys_exec+0xac>
80105ca5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105cab:	83 ec 08             	sub    $0x8,%esp
80105cae:	50                   	push   %eax
80105caf:	6a 01                	push   $0x1
80105cb1:	e8 2a f4 ff ff       	call   801050e0 <argint>
80105cb6:	83 c4 10             	add    $0x10,%esp
80105cb9:	85 c0                	test   %eax,%eax
80105cbb:	78 6f                	js     80105d2c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105cbd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105cc3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105cc6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105cc8:	68 80 00 00 00       	push   $0x80
80105ccd:	6a 00                	push   $0x0
80105ccf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105cd5:	50                   	push   %eax
80105cd6:	e8 05 f1 ff ff       	call   80104de0 <memset>
80105cdb:	83 c4 10             	add    $0x10,%esp
80105cde:	eb 2c                	jmp    80105d0c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105ce0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105ce6:	85 c0                	test   %eax,%eax
80105ce8:	74 56                	je     80105d40 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105cea:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105cf0:	83 ec 08             	sub    $0x8,%esp
80105cf3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105cf6:	52                   	push   %edx
80105cf7:	50                   	push   %eax
80105cf8:	e8 73 f3 ff ff       	call   80105070 <fetchstr>
80105cfd:	83 c4 10             	add    $0x10,%esp
80105d00:	85 c0                	test   %eax,%eax
80105d02:	78 28                	js     80105d2c <sys_exec+0xac>
  for(i=0;; i++){
80105d04:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105d07:	83 fb 20             	cmp    $0x20,%ebx
80105d0a:	74 20                	je     80105d2c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d0c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d12:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105d19:	83 ec 08             	sub    $0x8,%esp
80105d1c:	57                   	push   %edi
80105d1d:	01 f0                	add    %esi,%eax
80105d1f:	50                   	push   %eax
80105d20:	e8 0b f3 ff ff       	call   80105030 <fetchint>
80105d25:	83 c4 10             	add    $0x10,%esp
80105d28:	85 c0                	test   %eax,%eax
80105d2a:	79 b4                	jns    80105ce0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105d2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d34:	5b                   	pop    %ebx
80105d35:	5e                   	pop    %esi
80105d36:	5f                   	pop    %edi
80105d37:	5d                   	pop    %ebp
80105d38:	c3                   	ret    
80105d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105d40:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105d46:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105d49:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105d50:	00 00 00 00 
  return exec(path, argv);
80105d54:	50                   	push   %eax
80105d55:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105d5b:	e8 b0 ac ff ff       	call   80100a10 <exec>
80105d60:	83 c4 10             	add    $0x10,%esp
}
80105d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d66:	5b                   	pop    %ebx
80105d67:	5e                   	pop    %esi
80105d68:	5f                   	pop    %edi
80105d69:	5d                   	pop    %ebp
80105d6a:	c3                   	ret    
80105d6b:	90                   	nop
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_pipe>:

int
sys_pipe(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	57                   	push   %edi
80105d74:	56                   	push   %esi
80105d75:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d76:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105d79:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d7c:	6a 08                	push   $0x8
80105d7e:	50                   	push   %eax
80105d7f:	6a 00                	push   $0x0
80105d81:	e8 aa f3 ff ff       	call   80105130 <argptr>
80105d86:	83 c4 10             	add    $0x10,%esp
80105d89:	85 c0                	test   %eax,%eax
80105d8b:	0f 88 ae 00 00 00    	js     80105e3f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105d91:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d94:	83 ec 08             	sub    $0x8,%esp
80105d97:	50                   	push   %eax
80105d98:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d9b:	50                   	push   %eax
80105d9c:	e8 4f d9 ff ff       	call   801036f0 <pipealloc>
80105da1:	83 c4 10             	add    $0x10,%esp
80105da4:	85 c0                	test   %eax,%eax
80105da6:	0f 88 93 00 00 00    	js     80105e3f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105dac:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105daf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105db1:	e8 2a e0 ff ff       	call   80103de0 <myproc>
80105db6:	eb 10                	jmp    80105dc8 <sys_pipe+0x58>
80105db8:	90                   	nop
80105db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105dc0:	83 c3 01             	add    $0x1,%ebx
80105dc3:	83 fb 10             	cmp    $0x10,%ebx
80105dc6:	74 60                	je     80105e28 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105dc8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105dcc:	85 f6                	test   %esi,%esi
80105dce:	75 f0                	jne    80105dc0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105dd0:	8d 73 08             	lea    0x8(%ebx),%esi
80105dd3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105dd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105dda:	e8 01 e0 ff ff       	call   80103de0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ddf:	31 d2                	xor    %edx,%edx
80105de1:	eb 0d                	jmp    80105df0 <sys_pipe+0x80>
80105de3:	90                   	nop
80105de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105de8:	83 c2 01             	add    $0x1,%edx
80105deb:	83 fa 10             	cmp    $0x10,%edx
80105dee:	74 28                	je     80105e18 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105df0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105df4:	85 c9                	test   %ecx,%ecx
80105df6:	75 f0                	jne    80105de8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105df8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105dfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105dff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105e01:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e04:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105e07:	31 c0                	xor    %eax,%eax
}
80105e09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e0c:	5b                   	pop    %ebx
80105e0d:	5e                   	pop    %esi
80105e0e:	5f                   	pop    %edi
80105e0f:	5d                   	pop    %ebp
80105e10:	c3                   	ret    
80105e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105e18:	e8 c3 df ff ff       	call   80103de0 <myproc>
80105e1d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105e24:	00 
80105e25:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105e28:	83 ec 0c             	sub    $0xc,%esp
80105e2b:	ff 75 e0             	pushl  -0x20(%ebp)
80105e2e:	e8 dd b0 ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
80105e33:	58                   	pop    %eax
80105e34:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e37:	e8 d4 b0 ff ff       	call   80100f10 <fileclose>
    return -1;
80105e3c:	83 c4 10             	add    $0x10,%esp
80105e3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e44:	eb c3                	jmp    80105e09 <sys_pipe+0x99>
80105e46:	66 90                	xchg   %ax,%ax
80105e48:	66 90                	xchg   %ax,%ax
80105e4a:	66 90                	xchg   %ax,%ax
80105e4c:	66 90                	xchg   %ax,%ax
80105e4e:	66 90                	xchg   %ax,%ax

80105e50 <sys_procDump>:
#include "mmu.h"
#include "proc.h"

int 
sys_procDump(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	83 ec 08             	sub    $0x8,%esp
  procdump();
80105e56:	e8 a5 eb ff ff       	call   80104a00 <procdump>
  return 0;
}
80105e5b:	31 c0                	xor    %eax,%eax
80105e5d:	c9                   	leave  
80105e5e:	c3                   	ret    
80105e5f:	90                   	nop

80105e60 <sys_printStats>:

int 
sys_printStats(void)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	83 ec 08             	sub    $0x8,%esp
  struct proc* proc = myproc();
80105e66:	e8 75 df ff ff       	call   80103de0 <myproc>
  printProcessDetails(proc);
80105e6b:	83 ec 0c             	sub    $0xc,%esp
80105e6e:	50                   	push   %eax
80105e6f:	e8 bc e3 ff ff       	call   80104230 <printProcessDetails>
  return 0;
}
80105e74:	31 c0                	xor    %eax,%eax
80105e76:	c9                   	leave  
80105e77:	c3                   	ret    
80105e78:	90                   	nop
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e80 <sys_fork>:

int
sys_fork(void)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105e83:	5d                   	pop    %ebp
  return fork();
80105e84:	e9 f7 e0 ff ff       	jmp    80103f80 <fork>
80105e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e90 <sys_exit>:

int
sys_exit(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e96:	e8 05 e7 ff ff       	call   801045a0 <exit>
  return 0;  // not reached
}
80105e9b:	31 c0                	xor    %eax,%eax
80105e9d:	c9                   	leave  
80105e9e:	c3                   	ret    
80105e9f:	90                   	nop

80105ea0 <sys_wait>:

int
sys_wait(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105ea3:	5d                   	pop    %ebp
  return wait();
80105ea4:	e9 77 e9 ff ff       	jmp    80104820 <wait>
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <sys_kill>:

int
sys_kill(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105eb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eb9:	50                   	push   %eax
80105eba:	6a 00                	push   $0x0
80105ebc:	e8 1f f2 ff ff       	call   801050e0 <argint>
80105ec1:	83 c4 10             	add    $0x10,%esp
80105ec4:	85 c0                	test   %eax,%eax
80105ec6:	78 18                	js     80105ee0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ec8:	83 ec 0c             	sub    $0xc,%esp
80105ecb:	ff 75 f4             	pushl  -0xc(%ebp)
80105ece:	e8 ad ea ff ff       	call   80104980 <kill>
80105ed3:	83 c4 10             	add    $0x10,%esp
}
80105ed6:	c9                   	leave  
80105ed7:	c3                   	ret    
80105ed8:	90                   	nop
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ee5:	c9                   	leave  
80105ee6:	c3                   	ret    
80105ee7:	89 f6                	mov    %esi,%esi
80105ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ef0 <sys_getpid>:

int
sys_getpid(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ef6:	e8 e5 de ff ff       	call   80103de0 <myproc>
80105efb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105efe:	c9                   	leave  
80105eff:	c3                   	ret    

80105f00 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f0a:	50                   	push   %eax
80105f0b:	6a 00                	push   $0x0
80105f0d:	e8 ce f1 ff ff       	call   801050e0 <argint>
80105f12:	83 c4 10             	add    $0x10,%esp
80105f15:	85 c0                	test   %eax,%eax
80105f17:	78 27                	js     80105f40 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f19:	e8 c2 de ff ff       	call   80103de0 <myproc>
  if(growproc(n) < 0)
80105f1e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105f21:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f23:	ff 75 f4             	pushl  -0xc(%ebp)
80105f26:	e8 d5 df ff ff       	call   80103f00 <growproc>
80105f2b:	83 c4 10             	add    $0x10,%esp
80105f2e:	85 c0                	test   %eax,%eax
80105f30:	78 0e                	js     80105f40 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105f32:	89 d8                	mov    %ebx,%eax
80105f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f37:	c9                   	leave  
80105f38:	c3                   	ret    
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f40:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f45:	eb eb                	jmp    80105f32 <sys_sbrk+0x32>
80105f47:	89 f6                	mov    %esi,%esi
80105f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f50 <sys_sleep>:

int
sys_sleep(void)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105f54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f5a:	50                   	push   %eax
80105f5b:	6a 00                	push   $0x0
80105f5d:	e8 7e f1 ff ff       	call   801050e0 <argint>
80105f62:	83 c4 10             	add    $0x10,%esp
80105f65:	85 c0                	test   %eax,%eax
80105f67:	0f 88 8a 00 00 00    	js     80105ff7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105f6d:	83 ec 0c             	sub    $0xc,%esp
80105f70:	68 80 f9 11 80       	push   $0x8011f980
80105f75:	e8 56 ed ff ff       	call   80104cd0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105f7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f7d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105f80:	8b 1d c0 01 12 80    	mov    0x801201c0,%ebx
  while(ticks - ticks0 < n){
80105f86:	85 d2                	test   %edx,%edx
80105f88:	75 27                	jne    80105fb1 <sys_sleep+0x61>
80105f8a:	eb 54                	jmp    80105fe0 <sys_sleep+0x90>
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105f90:	83 ec 08             	sub    $0x8,%esp
80105f93:	68 80 f9 11 80       	push   $0x8011f980
80105f98:	68 c0 01 12 80       	push   $0x801201c0
80105f9d:	e8 be e7 ff ff       	call   80104760 <sleep>
  while(ticks - ticks0 < n){
80105fa2:	a1 c0 01 12 80       	mov    0x801201c0,%eax
80105fa7:	83 c4 10             	add    $0x10,%esp
80105faa:	29 d8                	sub    %ebx,%eax
80105fac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105faf:	73 2f                	jae    80105fe0 <sys_sleep+0x90>
    if(myproc()->killed){
80105fb1:	e8 2a de ff ff       	call   80103de0 <myproc>
80105fb6:	8b 40 24             	mov    0x24(%eax),%eax
80105fb9:	85 c0                	test   %eax,%eax
80105fbb:	74 d3                	je     80105f90 <sys_sleep+0x40>
      release(&tickslock);
80105fbd:	83 ec 0c             	sub    $0xc,%esp
80105fc0:	68 80 f9 11 80       	push   $0x8011f980
80105fc5:	e8 c6 ed ff ff       	call   80104d90 <release>
      return -1;
80105fca:	83 c4 10             	add    $0x10,%esp
80105fcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105fd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fd5:	c9                   	leave  
80105fd6:	c3                   	ret    
80105fd7:	89 f6                	mov    %esi,%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	68 80 f9 11 80       	push   $0x8011f980
80105fe8:	e8 a3 ed ff ff       	call   80104d90 <release>
  return 0;
80105fed:	83 c4 10             	add    $0x10,%esp
80105ff0:	31 c0                	xor    %eax,%eax
}
80105ff2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ff5:	c9                   	leave  
80105ff6:	c3                   	ret    
    return -1;
80105ff7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ffc:	eb f4                	jmp    80105ff2 <sys_sleep+0xa2>
80105ffe:	66 90                	xchg   %ax,%ax

80106000 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	53                   	push   %ebx
80106004:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106007:	68 80 f9 11 80       	push   $0x8011f980
8010600c:	e8 bf ec ff ff       	call   80104cd0 <acquire>
  xticks = ticks;
80106011:	8b 1d c0 01 12 80    	mov    0x801201c0,%ebx
  release(&tickslock);
80106017:	c7 04 24 80 f9 11 80 	movl   $0x8011f980,(%esp)
8010601e:	e8 6d ed ff ff       	call   80104d90 <release>
  return xticks;
}
80106023:	89 d8                	mov    %ebx,%eax
80106025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106028:	c9                   	leave  
80106029:	c3                   	ret    

8010602a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010602a:	1e                   	push   %ds
  pushl %es
8010602b:	06                   	push   %es
  pushl %fs
8010602c:	0f a0                	push   %fs
  pushl %gs
8010602e:	0f a8                	push   %gs
  pushal
80106030:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106031:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106035:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106037:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106039:	54                   	push   %esp
  call trap
8010603a:	e8 c1 00 00 00       	call   80106100 <trap>
  addl $4, %esp
8010603f:	83 c4 04             	add    $0x4,%esp

80106042 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106042:	61                   	popa   
  popl %gs
80106043:	0f a9                	pop    %gs
  popl %fs
80106045:	0f a1                	pop    %fs
  popl %es
80106047:	07                   	pop    %es
  popl %ds
80106048:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106049:	83 c4 08             	add    $0x8,%esp
  iret
8010604c:	cf                   	iret   
8010604d:	66 90                	xchg   %ax,%ax
8010604f:	90                   	nop

80106050 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106050:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106051:	31 c0                	xor    %eax,%eax
{
80106053:	89 e5                	mov    %esp,%ebp
80106055:	83 ec 08             	sub    $0x8,%esp
80106058:	90                   	nop
80106059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106060:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106067:	c7 04 c5 c2 f9 11 80 	movl   $0x8e000008,-0x7fee063e(,%eax,8)
8010606e:	08 00 00 8e 
80106072:	66 89 14 c5 c0 f9 11 	mov    %dx,-0x7fee0640(,%eax,8)
80106079:	80 
8010607a:	c1 ea 10             	shr    $0x10,%edx
8010607d:	66 89 14 c5 c6 f9 11 	mov    %dx,-0x7fee063a(,%eax,8)
80106084:	80 
  for(i = 0; i < 256; i++)
80106085:	83 c0 01             	add    $0x1,%eax
80106088:	3d 00 01 00 00       	cmp    $0x100,%eax
8010608d:	75 d1                	jne    80106060 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010608f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80106094:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106097:	c7 05 c2 fb 11 80 08 	movl   $0xef000008,0x8011fbc2
8010609e:	00 00 ef 
  initlock(&tickslock, "time");
801060a1:	68 fd 82 10 80       	push   $0x801082fd
801060a6:	68 80 f9 11 80       	push   $0x8011f980
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060ab:	66 a3 c0 fb 11 80    	mov    %ax,0x8011fbc0
801060b1:	c1 e8 10             	shr    $0x10,%eax
801060b4:	66 a3 c6 fb 11 80    	mov    %ax,0x8011fbc6
  initlock(&tickslock, "time");
801060ba:	e8 d1 ea ff ff       	call   80104b90 <initlock>
}
801060bf:	83 c4 10             	add    $0x10,%esp
801060c2:	c9                   	leave  
801060c3:	c3                   	ret    
801060c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801060ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801060d0 <idtinit>:

void
idtinit(void)
{
801060d0:	55                   	push   %ebp
  pd[0] = size-1;
801060d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801060d6:	89 e5                	mov    %esp,%ebp
801060d8:	83 ec 10             	sub    $0x10,%esp
801060db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801060df:	b8 c0 f9 11 80       	mov    $0x8011f9c0,%eax
801060e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801060e8:	c1 e8 10             	shr    $0x10,%eax
801060eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801060ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801060f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801060f5:	c9                   	leave  
801060f6:	c3                   	ret    
801060f7:	89 f6                	mov    %esi,%esi
801060f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106100 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
80106103:	57                   	push   %edi
80106104:	56                   	push   %esi
80106105:	53                   	push   %ebx
80106106:	83 ec 1c             	sub    $0x1c,%esp
80106109:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010610c:	8b 47 30             	mov    0x30(%edi),%eax
8010610f:	83 f8 40             	cmp    $0x40,%eax
80106112:	0f 84 f0 00 00 00    	je     80106208 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106118:	83 e8 20             	sub    $0x20,%eax
8010611b:	83 f8 1f             	cmp    $0x1f,%eax
8010611e:	77 10                	ja     80106130 <trap+0x30>
80106120:	ff 24 85 a4 83 10 80 	jmp    *-0x7fef7c5c(,%eax,4)
80106127:	89 f6                	mov    %esi,%esi
80106129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106130:	e8 ab dc ff ff       	call   80103de0 <myproc>
80106135:	85 c0                	test   %eax,%eax
80106137:	8b 5f 38             	mov    0x38(%edi),%ebx
8010613a:	0f 84 14 02 00 00    	je     80106354 <trap+0x254>
80106140:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106144:	0f 84 0a 02 00 00    	je     80106354 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010614a:	0f 20 d1             	mov    %cr2,%ecx
8010614d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106150:	e8 6b dc ff ff       	call   80103dc0 <cpuid>
80106155:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106158:	8b 47 34             	mov    0x34(%edi),%eax
8010615b:	8b 77 30             	mov    0x30(%edi),%esi
8010615e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106161:	e8 7a dc ff ff       	call   80103de0 <myproc>
80106166:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106169:	e8 72 dc ff ff       	call   80103de0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010616e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106171:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106174:	51                   	push   %ecx
80106175:	53                   	push   %ebx
80106176:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106177:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010617a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010617d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010617e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106181:	52                   	push   %edx
80106182:	ff 70 10             	pushl  0x10(%eax)
80106185:	68 60 83 10 80       	push   $0x80108360
8010618a:	e8 d1 a4 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010618f:	83 c4 20             	add    $0x20,%esp
80106192:	e8 49 dc ff ff       	call   80103de0 <myproc>
80106197:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010619e:	e8 3d dc ff ff       	call   80103de0 <myproc>
801061a3:	85 c0                	test   %eax,%eax
801061a5:	74 1d                	je     801061c4 <trap+0xc4>
801061a7:	e8 34 dc ff ff       	call   80103de0 <myproc>
801061ac:	8b 50 24             	mov    0x24(%eax),%edx
801061af:	85 d2                	test   %edx,%edx
801061b1:	74 11                	je     801061c4 <trap+0xc4>
801061b3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801061b7:	83 e0 03             	and    $0x3,%eax
801061ba:	66 83 f8 03          	cmp    $0x3,%ax
801061be:	0f 84 4c 01 00 00    	je     80106310 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801061c4:	e8 17 dc ff ff       	call   80103de0 <myproc>
801061c9:	85 c0                	test   %eax,%eax
801061cb:	74 0b                	je     801061d8 <trap+0xd8>
801061cd:	e8 0e dc ff ff       	call   80103de0 <myproc>
801061d2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801061d6:	74 68                	je     80106240 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061d8:	e8 03 dc ff ff       	call   80103de0 <myproc>
801061dd:	85 c0                	test   %eax,%eax
801061df:	74 19                	je     801061fa <trap+0xfa>
801061e1:	e8 fa db ff ff       	call   80103de0 <myproc>
801061e6:	8b 40 24             	mov    0x24(%eax),%eax
801061e9:	85 c0                	test   %eax,%eax
801061eb:	74 0d                	je     801061fa <trap+0xfa>
801061ed:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801061f1:	83 e0 03             	and    $0x3,%eax
801061f4:	66 83 f8 03          	cmp    $0x3,%ax
801061f8:	74 37                	je     80106231 <trap+0x131>
    exit();
}
801061fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061fd:	5b                   	pop    %ebx
801061fe:	5e                   	pop    %esi
801061ff:	5f                   	pop    %edi
80106200:	5d                   	pop    %ebp
80106201:	c3                   	ret    
80106202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106208:	e8 d3 db ff ff       	call   80103de0 <myproc>
8010620d:	8b 58 24             	mov    0x24(%eax),%ebx
80106210:	85 db                	test   %ebx,%ebx
80106212:	0f 85 e8 00 00 00    	jne    80106300 <trap+0x200>
    myproc()->tf = tf;
80106218:	e8 c3 db ff ff       	call   80103de0 <myproc>
8010621d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106220:	e8 ab ef ff ff       	call   801051d0 <syscall>
    if(myproc()->killed)
80106225:	e8 b6 db ff ff       	call   80103de0 <myproc>
8010622a:	8b 48 24             	mov    0x24(%eax),%ecx
8010622d:	85 c9                	test   %ecx,%ecx
8010622f:	74 c9                	je     801061fa <trap+0xfa>
}
80106231:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106234:	5b                   	pop    %ebx
80106235:	5e                   	pop    %esi
80106236:	5f                   	pop    %edi
80106237:	5d                   	pop    %ebp
      exit();
80106238:	e9 63 e3 ff ff       	jmp    801045a0 <exit>
8010623d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106240:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106244:	75 92                	jne    801061d8 <trap+0xd8>
    yield();
80106246:	e8 c5 e4 ff ff       	call   80104710 <yield>
8010624b:	eb 8b                	jmp    801061d8 <trap+0xd8>
8010624d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106250:	e8 6b db ff ff       	call   80103dc0 <cpuid>
80106255:	85 c0                	test   %eax,%eax
80106257:	0f 84 c3 00 00 00    	je     80106320 <trap+0x220>
    lapiceoi();
8010625d:	e8 9e c9 ff ff       	call   80102c00 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106262:	e8 79 db ff ff       	call   80103de0 <myproc>
80106267:	85 c0                	test   %eax,%eax
80106269:	0f 85 38 ff ff ff    	jne    801061a7 <trap+0xa7>
8010626f:	e9 50 ff ff ff       	jmp    801061c4 <trap+0xc4>
80106274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106278:	e8 43 c8 ff ff       	call   80102ac0 <kbdintr>
    lapiceoi();
8010627d:	e8 7e c9 ff ff       	call   80102c00 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106282:	e8 59 db ff ff       	call   80103de0 <myproc>
80106287:	85 c0                	test   %eax,%eax
80106289:	0f 85 18 ff ff ff    	jne    801061a7 <trap+0xa7>
8010628f:	e9 30 ff ff ff       	jmp    801061c4 <trap+0xc4>
80106294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106298:	e8 53 02 00 00       	call   801064f0 <uartintr>
    lapiceoi();
8010629d:	e8 5e c9 ff ff       	call   80102c00 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062a2:	e8 39 db ff ff       	call   80103de0 <myproc>
801062a7:	85 c0                	test   %eax,%eax
801062a9:	0f 85 f8 fe ff ff    	jne    801061a7 <trap+0xa7>
801062af:	e9 10 ff ff ff       	jmp    801061c4 <trap+0xc4>
801062b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062b8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801062bc:	8b 77 38             	mov    0x38(%edi),%esi
801062bf:	e8 fc da ff ff       	call   80103dc0 <cpuid>
801062c4:	56                   	push   %esi
801062c5:	53                   	push   %ebx
801062c6:	50                   	push   %eax
801062c7:	68 08 83 10 80       	push   $0x80108308
801062cc:	e8 8f a3 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801062d1:	e8 2a c9 ff ff       	call   80102c00 <lapiceoi>
    break;
801062d6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062d9:	e8 02 db ff ff       	call   80103de0 <myproc>
801062de:	85 c0                	test   %eax,%eax
801062e0:	0f 85 c1 fe ff ff    	jne    801061a7 <trap+0xa7>
801062e6:	e9 d9 fe ff ff       	jmp    801061c4 <trap+0xc4>
801062eb:	90                   	nop
801062ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801062f0:	e8 eb c1 ff ff       	call   801024e0 <ideintr>
801062f5:	e9 63 ff ff ff       	jmp    8010625d <trap+0x15d>
801062fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106300:	e8 9b e2 ff ff       	call   801045a0 <exit>
80106305:	e9 0e ff ff ff       	jmp    80106218 <trap+0x118>
8010630a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106310:	e8 8b e2 ff ff       	call   801045a0 <exit>
80106315:	e9 aa fe ff ff       	jmp    801061c4 <trap+0xc4>
8010631a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106320:	83 ec 0c             	sub    $0xc,%esp
80106323:	68 80 f9 11 80       	push   $0x8011f980
80106328:	e8 a3 e9 ff ff       	call   80104cd0 <acquire>
      wakeup(&ticks);
8010632d:	c7 04 24 c0 01 12 80 	movl   $0x801201c0,(%esp)
      ticks++;
80106334:	83 05 c0 01 12 80 01 	addl   $0x1,0x801201c0
      wakeup(&ticks);
8010633b:	e8 e0 e5 ff ff       	call   80104920 <wakeup>
      release(&tickslock);
80106340:	c7 04 24 80 f9 11 80 	movl   $0x8011f980,(%esp)
80106347:	e8 44 ea ff ff       	call   80104d90 <release>
8010634c:	83 c4 10             	add    $0x10,%esp
8010634f:	e9 09 ff ff ff       	jmp    8010625d <trap+0x15d>
80106354:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106357:	e8 64 da ff ff       	call   80103dc0 <cpuid>
8010635c:	83 ec 0c             	sub    $0xc,%esp
8010635f:	56                   	push   %esi
80106360:	53                   	push   %ebx
80106361:	50                   	push   %eax
80106362:	ff 77 30             	pushl  0x30(%edi)
80106365:	68 2c 83 10 80       	push   $0x8010832c
8010636a:	e8 f1 a2 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010636f:	83 c4 14             	add    $0x14,%esp
80106372:	68 02 83 10 80       	push   $0x80108302
80106377:	e8 14 a0 ff ff       	call   80100390 <panic>
8010637c:	66 90                	xchg   %ax,%ax
8010637e:	66 90                	xchg   %ax,%ax

80106380 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106380:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106385:	55                   	push   %ebp
80106386:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106388:	85 c0                	test   %eax,%eax
8010638a:	74 1c                	je     801063a8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010638c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106391:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106392:	a8 01                	test   $0x1,%al
80106394:	74 12                	je     801063a8 <uartgetc+0x28>
80106396:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010639b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010639c:	0f b6 c0             	movzbl %al,%eax
}
8010639f:	5d                   	pop    %ebp
801063a0:	c3                   	ret    
801063a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801063a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063ad:	5d                   	pop    %ebp
801063ae:	c3                   	ret    
801063af:	90                   	nop

801063b0 <uartputc.part.0>:
uartputc(int c)
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	57                   	push   %edi
801063b4:	56                   	push   %esi
801063b5:	53                   	push   %ebx
801063b6:	89 c7                	mov    %eax,%edi
801063b8:	bb 80 00 00 00       	mov    $0x80,%ebx
801063bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801063c2:	83 ec 0c             	sub    $0xc,%esp
801063c5:	eb 1b                	jmp    801063e2 <uartputc.part.0+0x32>
801063c7:	89 f6                	mov    %esi,%esi
801063c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801063d0:	83 ec 0c             	sub    $0xc,%esp
801063d3:	6a 0a                	push   $0xa
801063d5:	e8 46 c8 ff ff       	call   80102c20 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063da:	83 c4 10             	add    $0x10,%esp
801063dd:	83 eb 01             	sub    $0x1,%ebx
801063e0:	74 07                	je     801063e9 <uartputc.part.0+0x39>
801063e2:	89 f2                	mov    %esi,%edx
801063e4:	ec                   	in     (%dx),%al
801063e5:	a8 20                	test   $0x20,%al
801063e7:	74 e7                	je     801063d0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063ee:	89 f8                	mov    %edi,%eax
801063f0:	ee                   	out    %al,(%dx)
}
801063f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063f4:	5b                   	pop    %ebx
801063f5:	5e                   	pop    %esi
801063f6:	5f                   	pop    %edi
801063f7:	5d                   	pop    %ebp
801063f8:	c3                   	ret    
801063f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106400 <uartinit>:
{
80106400:	55                   	push   %ebp
80106401:	31 c9                	xor    %ecx,%ecx
80106403:	89 c8                	mov    %ecx,%eax
80106405:	89 e5                	mov    %esp,%ebp
80106407:	57                   	push   %edi
80106408:	56                   	push   %esi
80106409:	53                   	push   %ebx
8010640a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010640f:	89 da                	mov    %ebx,%edx
80106411:	83 ec 0c             	sub    $0xc,%esp
80106414:	ee                   	out    %al,(%dx)
80106415:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010641a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010641f:	89 fa                	mov    %edi,%edx
80106421:	ee                   	out    %al,(%dx)
80106422:	b8 0c 00 00 00       	mov    $0xc,%eax
80106427:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010642c:	ee                   	out    %al,(%dx)
8010642d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106432:	89 c8                	mov    %ecx,%eax
80106434:	89 f2                	mov    %esi,%edx
80106436:	ee                   	out    %al,(%dx)
80106437:	b8 03 00 00 00       	mov    $0x3,%eax
8010643c:	89 fa                	mov    %edi,%edx
8010643e:	ee                   	out    %al,(%dx)
8010643f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106444:	89 c8                	mov    %ecx,%eax
80106446:	ee                   	out    %al,(%dx)
80106447:	b8 01 00 00 00       	mov    $0x1,%eax
8010644c:	89 f2                	mov    %esi,%edx
8010644e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010644f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106454:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106455:	3c ff                	cmp    $0xff,%al
80106457:	74 5a                	je     801064b3 <uartinit+0xb3>
  uart = 1;
80106459:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106460:	00 00 00 
80106463:	89 da                	mov    %ebx,%edx
80106465:	ec                   	in     (%dx),%al
80106466:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010646b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010646c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010646f:	bb 24 84 10 80       	mov    $0x80108424,%ebx
  ioapicenable(IRQ_COM1, 0);
80106474:	6a 00                	push   $0x0
80106476:	6a 04                	push   $0x4
80106478:	e8 b3 c2 ff ff       	call   80102730 <ioapicenable>
8010647d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106480:	b8 78 00 00 00       	mov    $0x78,%eax
80106485:	eb 13                	jmp    8010649a <uartinit+0x9a>
80106487:	89 f6                	mov    %esi,%esi
80106489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106490:	83 c3 01             	add    $0x1,%ebx
80106493:	0f be 03             	movsbl (%ebx),%eax
80106496:	84 c0                	test   %al,%al
80106498:	74 19                	je     801064b3 <uartinit+0xb3>
  if(!uart)
8010649a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801064a0:	85 d2                	test   %edx,%edx
801064a2:	74 ec                	je     80106490 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801064a4:	83 c3 01             	add    $0x1,%ebx
801064a7:	e8 04 ff ff ff       	call   801063b0 <uartputc.part.0>
801064ac:	0f be 03             	movsbl (%ebx),%eax
801064af:	84 c0                	test   %al,%al
801064b1:	75 e7                	jne    8010649a <uartinit+0x9a>
}
801064b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064b6:	5b                   	pop    %ebx
801064b7:	5e                   	pop    %esi
801064b8:	5f                   	pop    %edi
801064b9:	5d                   	pop    %ebp
801064ba:	c3                   	ret    
801064bb:	90                   	nop
801064bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801064c0 <uartputc>:
  if(!uart)
801064c0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801064c6:	55                   	push   %ebp
801064c7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801064c9:	85 d2                	test   %edx,%edx
{
801064cb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801064ce:	74 10                	je     801064e0 <uartputc+0x20>
}
801064d0:	5d                   	pop    %ebp
801064d1:	e9 da fe ff ff       	jmp    801063b0 <uartputc.part.0>
801064d6:	8d 76 00             	lea    0x0(%esi),%esi
801064d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801064e0:	5d                   	pop    %ebp
801064e1:	c3                   	ret    
801064e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064f0 <uartintr>:

void
uartintr(void)
{
801064f0:	55                   	push   %ebp
801064f1:	89 e5                	mov    %esp,%ebp
801064f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801064f6:	68 80 63 10 80       	push   $0x80106380
801064fb:	e8 10 a3 ff ff       	call   80100810 <consoleintr>
}
80106500:	83 c4 10             	add    $0x10,%esp
80106503:	c9                   	leave  
80106504:	c3                   	ret    

80106505 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106505:	6a 00                	push   $0x0
  pushl $0
80106507:	6a 00                	push   $0x0
  jmp alltraps
80106509:	e9 1c fb ff ff       	jmp    8010602a <alltraps>

8010650e <vector1>:
.globl vector1
vector1:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $1
80106510:	6a 01                	push   $0x1
  jmp alltraps
80106512:	e9 13 fb ff ff       	jmp    8010602a <alltraps>

80106517 <vector2>:
.globl vector2
vector2:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $2
80106519:	6a 02                	push   $0x2
  jmp alltraps
8010651b:	e9 0a fb ff ff       	jmp    8010602a <alltraps>

80106520 <vector3>:
.globl vector3
vector3:
  pushl $0
80106520:	6a 00                	push   $0x0
  pushl $3
80106522:	6a 03                	push   $0x3
  jmp alltraps
80106524:	e9 01 fb ff ff       	jmp    8010602a <alltraps>

80106529 <vector4>:
.globl vector4
vector4:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $4
8010652b:	6a 04                	push   $0x4
  jmp alltraps
8010652d:	e9 f8 fa ff ff       	jmp    8010602a <alltraps>

80106532 <vector5>:
.globl vector5
vector5:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $5
80106534:	6a 05                	push   $0x5
  jmp alltraps
80106536:	e9 ef fa ff ff       	jmp    8010602a <alltraps>

8010653b <vector6>:
.globl vector6
vector6:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $6
8010653d:	6a 06                	push   $0x6
  jmp alltraps
8010653f:	e9 e6 fa ff ff       	jmp    8010602a <alltraps>

80106544 <vector7>:
.globl vector7
vector7:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $7
80106546:	6a 07                	push   $0x7
  jmp alltraps
80106548:	e9 dd fa ff ff       	jmp    8010602a <alltraps>

8010654d <vector8>:
.globl vector8
vector8:
  pushl $8
8010654d:	6a 08                	push   $0x8
  jmp alltraps
8010654f:	e9 d6 fa ff ff       	jmp    8010602a <alltraps>

80106554 <vector9>:
.globl vector9
vector9:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $9
80106556:	6a 09                	push   $0x9
  jmp alltraps
80106558:	e9 cd fa ff ff       	jmp    8010602a <alltraps>

8010655d <vector10>:
.globl vector10
vector10:
  pushl $10
8010655d:	6a 0a                	push   $0xa
  jmp alltraps
8010655f:	e9 c6 fa ff ff       	jmp    8010602a <alltraps>

80106564 <vector11>:
.globl vector11
vector11:
  pushl $11
80106564:	6a 0b                	push   $0xb
  jmp alltraps
80106566:	e9 bf fa ff ff       	jmp    8010602a <alltraps>

8010656b <vector12>:
.globl vector12
vector12:
  pushl $12
8010656b:	6a 0c                	push   $0xc
  jmp alltraps
8010656d:	e9 b8 fa ff ff       	jmp    8010602a <alltraps>

80106572 <vector13>:
.globl vector13
vector13:
  pushl $13
80106572:	6a 0d                	push   $0xd
  jmp alltraps
80106574:	e9 b1 fa ff ff       	jmp    8010602a <alltraps>

80106579 <vector14>:
.globl vector14
vector14:
  pushl $14
80106579:	6a 0e                	push   $0xe
  jmp alltraps
8010657b:	e9 aa fa ff ff       	jmp    8010602a <alltraps>

80106580 <vector15>:
.globl vector15
vector15:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $15
80106582:	6a 0f                	push   $0xf
  jmp alltraps
80106584:	e9 a1 fa ff ff       	jmp    8010602a <alltraps>

80106589 <vector16>:
.globl vector16
vector16:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $16
8010658b:	6a 10                	push   $0x10
  jmp alltraps
8010658d:	e9 98 fa ff ff       	jmp    8010602a <alltraps>

80106592 <vector17>:
.globl vector17
vector17:
  pushl $17
80106592:	6a 11                	push   $0x11
  jmp alltraps
80106594:	e9 91 fa ff ff       	jmp    8010602a <alltraps>

80106599 <vector18>:
.globl vector18
vector18:
  pushl $0
80106599:	6a 00                	push   $0x0
  pushl $18
8010659b:	6a 12                	push   $0x12
  jmp alltraps
8010659d:	e9 88 fa ff ff       	jmp    8010602a <alltraps>

801065a2 <vector19>:
.globl vector19
vector19:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $19
801065a4:	6a 13                	push   $0x13
  jmp alltraps
801065a6:	e9 7f fa ff ff       	jmp    8010602a <alltraps>

801065ab <vector20>:
.globl vector20
vector20:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $20
801065ad:	6a 14                	push   $0x14
  jmp alltraps
801065af:	e9 76 fa ff ff       	jmp    8010602a <alltraps>

801065b4 <vector21>:
.globl vector21
vector21:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $21
801065b6:	6a 15                	push   $0x15
  jmp alltraps
801065b8:	e9 6d fa ff ff       	jmp    8010602a <alltraps>

801065bd <vector22>:
.globl vector22
vector22:
  pushl $0
801065bd:	6a 00                	push   $0x0
  pushl $22
801065bf:	6a 16                	push   $0x16
  jmp alltraps
801065c1:	e9 64 fa ff ff       	jmp    8010602a <alltraps>

801065c6 <vector23>:
.globl vector23
vector23:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $23
801065c8:	6a 17                	push   $0x17
  jmp alltraps
801065ca:	e9 5b fa ff ff       	jmp    8010602a <alltraps>

801065cf <vector24>:
.globl vector24
vector24:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $24
801065d1:	6a 18                	push   $0x18
  jmp alltraps
801065d3:	e9 52 fa ff ff       	jmp    8010602a <alltraps>

801065d8 <vector25>:
.globl vector25
vector25:
  pushl $0
801065d8:	6a 00                	push   $0x0
  pushl $25
801065da:	6a 19                	push   $0x19
  jmp alltraps
801065dc:	e9 49 fa ff ff       	jmp    8010602a <alltraps>

801065e1 <vector26>:
.globl vector26
vector26:
  pushl $0
801065e1:	6a 00                	push   $0x0
  pushl $26
801065e3:	6a 1a                	push   $0x1a
  jmp alltraps
801065e5:	e9 40 fa ff ff       	jmp    8010602a <alltraps>

801065ea <vector27>:
.globl vector27
vector27:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $27
801065ec:	6a 1b                	push   $0x1b
  jmp alltraps
801065ee:	e9 37 fa ff ff       	jmp    8010602a <alltraps>

801065f3 <vector28>:
.globl vector28
vector28:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $28
801065f5:	6a 1c                	push   $0x1c
  jmp alltraps
801065f7:	e9 2e fa ff ff       	jmp    8010602a <alltraps>

801065fc <vector29>:
.globl vector29
vector29:
  pushl $0
801065fc:	6a 00                	push   $0x0
  pushl $29
801065fe:	6a 1d                	push   $0x1d
  jmp alltraps
80106600:	e9 25 fa ff ff       	jmp    8010602a <alltraps>

80106605 <vector30>:
.globl vector30
vector30:
  pushl $0
80106605:	6a 00                	push   $0x0
  pushl $30
80106607:	6a 1e                	push   $0x1e
  jmp alltraps
80106609:	e9 1c fa ff ff       	jmp    8010602a <alltraps>

8010660e <vector31>:
.globl vector31
vector31:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $31
80106610:	6a 1f                	push   $0x1f
  jmp alltraps
80106612:	e9 13 fa ff ff       	jmp    8010602a <alltraps>

80106617 <vector32>:
.globl vector32
vector32:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $32
80106619:	6a 20                	push   $0x20
  jmp alltraps
8010661b:	e9 0a fa ff ff       	jmp    8010602a <alltraps>

80106620 <vector33>:
.globl vector33
vector33:
  pushl $0
80106620:	6a 00                	push   $0x0
  pushl $33
80106622:	6a 21                	push   $0x21
  jmp alltraps
80106624:	e9 01 fa ff ff       	jmp    8010602a <alltraps>

80106629 <vector34>:
.globl vector34
vector34:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $34
8010662b:	6a 22                	push   $0x22
  jmp alltraps
8010662d:	e9 f8 f9 ff ff       	jmp    8010602a <alltraps>

80106632 <vector35>:
.globl vector35
vector35:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $35
80106634:	6a 23                	push   $0x23
  jmp alltraps
80106636:	e9 ef f9 ff ff       	jmp    8010602a <alltraps>

8010663b <vector36>:
.globl vector36
vector36:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $36
8010663d:	6a 24                	push   $0x24
  jmp alltraps
8010663f:	e9 e6 f9 ff ff       	jmp    8010602a <alltraps>

80106644 <vector37>:
.globl vector37
vector37:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $37
80106646:	6a 25                	push   $0x25
  jmp alltraps
80106648:	e9 dd f9 ff ff       	jmp    8010602a <alltraps>

8010664d <vector38>:
.globl vector38
vector38:
  pushl $0
8010664d:	6a 00                	push   $0x0
  pushl $38
8010664f:	6a 26                	push   $0x26
  jmp alltraps
80106651:	e9 d4 f9 ff ff       	jmp    8010602a <alltraps>

80106656 <vector39>:
.globl vector39
vector39:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $39
80106658:	6a 27                	push   $0x27
  jmp alltraps
8010665a:	e9 cb f9 ff ff       	jmp    8010602a <alltraps>

8010665f <vector40>:
.globl vector40
vector40:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $40
80106661:	6a 28                	push   $0x28
  jmp alltraps
80106663:	e9 c2 f9 ff ff       	jmp    8010602a <alltraps>

80106668 <vector41>:
.globl vector41
vector41:
  pushl $0
80106668:	6a 00                	push   $0x0
  pushl $41
8010666a:	6a 29                	push   $0x29
  jmp alltraps
8010666c:	e9 b9 f9 ff ff       	jmp    8010602a <alltraps>

80106671 <vector42>:
.globl vector42
vector42:
  pushl $0
80106671:	6a 00                	push   $0x0
  pushl $42
80106673:	6a 2a                	push   $0x2a
  jmp alltraps
80106675:	e9 b0 f9 ff ff       	jmp    8010602a <alltraps>

8010667a <vector43>:
.globl vector43
vector43:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $43
8010667c:	6a 2b                	push   $0x2b
  jmp alltraps
8010667e:	e9 a7 f9 ff ff       	jmp    8010602a <alltraps>

80106683 <vector44>:
.globl vector44
vector44:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $44
80106685:	6a 2c                	push   $0x2c
  jmp alltraps
80106687:	e9 9e f9 ff ff       	jmp    8010602a <alltraps>

8010668c <vector45>:
.globl vector45
vector45:
  pushl $0
8010668c:	6a 00                	push   $0x0
  pushl $45
8010668e:	6a 2d                	push   $0x2d
  jmp alltraps
80106690:	e9 95 f9 ff ff       	jmp    8010602a <alltraps>

80106695 <vector46>:
.globl vector46
vector46:
  pushl $0
80106695:	6a 00                	push   $0x0
  pushl $46
80106697:	6a 2e                	push   $0x2e
  jmp alltraps
80106699:	e9 8c f9 ff ff       	jmp    8010602a <alltraps>

8010669e <vector47>:
.globl vector47
vector47:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $47
801066a0:	6a 2f                	push   $0x2f
  jmp alltraps
801066a2:	e9 83 f9 ff ff       	jmp    8010602a <alltraps>

801066a7 <vector48>:
.globl vector48
vector48:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $48
801066a9:	6a 30                	push   $0x30
  jmp alltraps
801066ab:	e9 7a f9 ff ff       	jmp    8010602a <alltraps>

801066b0 <vector49>:
.globl vector49
vector49:
  pushl $0
801066b0:	6a 00                	push   $0x0
  pushl $49
801066b2:	6a 31                	push   $0x31
  jmp alltraps
801066b4:	e9 71 f9 ff ff       	jmp    8010602a <alltraps>

801066b9 <vector50>:
.globl vector50
vector50:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $50
801066bb:	6a 32                	push   $0x32
  jmp alltraps
801066bd:	e9 68 f9 ff ff       	jmp    8010602a <alltraps>

801066c2 <vector51>:
.globl vector51
vector51:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $51
801066c4:	6a 33                	push   $0x33
  jmp alltraps
801066c6:	e9 5f f9 ff ff       	jmp    8010602a <alltraps>

801066cb <vector52>:
.globl vector52
vector52:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $52
801066cd:	6a 34                	push   $0x34
  jmp alltraps
801066cf:	e9 56 f9 ff ff       	jmp    8010602a <alltraps>

801066d4 <vector53>:
.globl vector53
vector53:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $53
801066d6:	6a 35                	push   $0x35
  jmp alltraps
801066d8:	e9 4d f9 ff ff       	jmp    8010602a <alltraps>

801066dd <vector54>:
.globl vector54
vector54:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $54
801066df:	6a 36                	push   $0x36
  jmp alltraps
801066e1:	e9 44 f9 ff ff       	jmp    8010602a <alltraps>

801066e6 <vector55>:
.globl vector55
vector55:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $55
801066e8:	6a 37                	push   $0x37
  jmp alltraps
801066ea:	e9 3b f9 ff ff       	jmp    8010602a <alltraps>

801066ef <vector56>:
.globl vector56
vector56:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $56
801066f1:	6a 38                	push   $0x38
  jmp alltraps
801066f3:	e9 32 f9 ff ff       	jmp    8010602a <alltraps>

801066f8 <vector57>:
.globl vector57
vector57:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $57
801066fa:	6a 39                	push   $0x39
  jmp alltraps
801066fc:	e9 29 f9 ff ff       	jmp    8010602a <alltraps>

80106701 <vector58>:
.globl vector58
vector58:
  pushl $0
80106701:	6a 00                	push   $0x0
  pushl $58
80106703:	6a 3a                	push   $0x3a
  jmp alltraps
80106705:	e9 20 f9 ff ff       	jmp    8010602a <alltraps>

8010670a <vector59>:
.globl vector59
vector59:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $59
8010670c:	6a 3b                	push   $0x3b
  jmp alltraps
8010670e:	e9 17 f9 ff ff       	jmp    8010602a <alltraps>

80106713 <vector60>:
.globl vector60
vector60:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $60
80106715:	6a 3c                	push   $0x3c
  jmp alltraps
80106717:	e9 0e f9 ff ff       	jmp    8010602a <alltraps>

8010671c <vector61>:
.globl vector61
vector61:
  pushl $0
8010671c:	6a 00                	push   $0x0
  pushl $61
8010671e:	6a 3d                	push   $0x3d
  jmp alltraps
80106720:	e9 05 f9 ff ff       	jmp    8010602a <alltraps>

80106725 <vector62>:
.globl vector62
vector62:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $62
80106727:	6a 3e                	push   $0x3e
  jmp alltraps
80106729:	e9 fc f8 ff ff       	jmp    8010602a <alltraps>

8010672e <vector63>:
.globl vector63
vector63:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $63
80106730:	6a 3f                	push   $0x3f
  jmp alltraps
80106732:	e9 f3 f8 ff ff       	jmp    8010602a <alltraps>

80106737 <vector64>:
.globl vector64
vector64:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $64
80106739:	6a 40                	push   $0x40
  jmp alltraps
8010673b:	e9 ea f8 ff ff       	jmp    8010602a <alltraps>

80106740 <vector65>:
.globl vector65
vector65:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $65
80106742:	6a 41                	push   $0x41
  jmp alltraps
80106744:	e9 e1 f8 ff ff       	jmp    8010602a <alltraps>

80106749 <vector66>:
.globl vector66
vector66:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $66
8010674b:	6a 42                	push   $0x42
  jmp alltraps
8010674d:	e9 d8 f8 ff ff       	jmp    8010602a <alltraps>

80106752 <vector67>:
.globl vector67
vector67:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $67
80106754:	6a 43                	push   $0x43
  jmp alltraps
80106756:	e9 cf f8 ff ff       	jmp    8010602a <alltraps>

8010675b <vector68>:
.globl vector68
vector68:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $68
8010675d:	6a 44                	push   $0x44
  jmp alltraps
8010675f:	e9 c6 f8 ff ff       	jmp    8010602a <alltraps>

80106764 <vector69>:
.globl vector69
vector69:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $69
80106766:	6a 45                	push   $0x45
  jmp alltraps
80106768:	e9 bd f8 ff ff       	jmp    8010602a <alltraps>

8010676d <vector70>:
.globl vector70
vector70:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $70
8010676f:	6a 46                	push   $0x46
  jmp alltraps
80106771:	e9 b4 f8 ff ff       	jmp    8010602a <alltraps>

80106776 <vector71>:
.globl vector71
vector71:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $71
80106778:	6a 47                	push   $0x47
  jmp alltraps
8010677a:	e9 ab f8 ff ff       	jmp    8010602a <alltraps>

8010677f <vector72>:
.globl vector72
vector72:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $72
80106781:	6a 48                	push   $0x48
  jmp alltraps
80106783:	e9 a2 f8 ff ff       	jmp    8010602a <alltraps>

80106788 <vector73>:
.globl vector73
vector73:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $73
8010678a:	6a 49                	push   $0x49
  jmp alltraps
8010678c:	e9 99 f8 ff ff       	jmp    8010602a <alltraps>

80106791 <vector74>:
.globl vector74
vector74:
  pushl $0
80106791:	6a 00                	push   $0x0
  pushl $74
80106793:	6a 4a                	push   $0x4a
  jmp alltraps
80106795:	e9 90 f8 ff ff       	jmp    8010602a <alltraps>

8010679a <vector75>:
.globl vector75
vector75:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $75
8010679c:	6a 4b                	push   $0x4b
  jmp alltraps
8010679e:	e9 87 f8 ff ff       	jmp    8010602a <alltraps>

801067a3 <vector76>:
.globl vector76
vector76:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $76
801067a5:	6a 4c                	push   $0x4c
  jmp alltraps
801067a7:	e9 7e f8 ff ff       	jmp    8010602a <alltraps>

801067ac <vector77>:
.globl vector77
vector77:
  pushl $0
801067ac:	6a 00                	push   $0x0
  pushl $77
801067ae:	6a 4d                	push   $0x4d
  jmp alltraps
801067b0:	e9 75 f8 ff ff       	jmp    8010602a <alltraps>

801067b5 <vector78>:
.globl vector78
vector78:
  pushl $0
801067b5:	6a 00                	push   $0x0
  pushl $78
801067b7:	6a 4e                	push   $0x4e
  jmp alltraps
801067b9:	e9 6c f8 ff ff       	jmp    8010602a <alltraps>

801067be <vector79>:
.globl vector79
vector79:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $79
801067c0:	6a 4f                	push   $0x4f
  jmp alltraps
801067c2:	e9 63 f8 ff ff       	jmp    8010602a <alltraps>

801067c7 <vector80>:
.globl vector80
vector80:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $80
801067c9:	6a 50                	push   $0x50
  jmp alltraps
801067cb:	e9 5a f8 ff ff       	jmp    8010602a <alltraps>

801067d0 <vector81>:
.globl vector81
vector81:
  pushl $0
801067d0:	6a 00                	push   $0x0
  pushl $81
801067d2:	6a 51                	push   $0x51
  jmp alltraps
801067d4:	e9 51 f8 ff ff       	jmp    8010602a <alltraps>

801067d9 <vector82>:
.globl vector82
vector82:
  pushl $0
801067d9:	6a 00                	push   $0x0
  pushl $82
801067db:	6a 52                	push   $0x52
  jmp alltraps
801067dd:	e9 48 f8 ff ff       	jmp    8010602a <alltraps>

801067e2 <vector83>:
.globl vector83
vector83:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $83
801067e4:	6a 53                	push   $0x53
  jmp alltraps
801067e6:	e9 3f f8 ff ff       	jmp    8010602a <alltraps>

801067eb <vector84>:
.globl vector84
vector84:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $84
801067ed:	6a 54                	push   $0x54
  jmp alltraps
801067ef:	e9 36 f8 ff ff       	jmp    8010602a <alltraps>

801067f4 <vector85>:
.globl vector85
vector85:
  pushl $0
801067f4:	6a 00                	push   $0x0
  pushl $85
801067f6:	6a 55                	push   $0x55
  jmp alltraps
801067f8:	e9 2d f8 ff ff       	jmp    8010602a <alltraps>

801067fd <vector86>:
.globl vector86
vector86:
  pushl $0
801067fd:	6a 00                	push   $0x0
  pushl $86
801067ff:	6a 56                	push   $0x56
  jmp alltraps
80106801:	e9 24 f8 ff ff       	jmp    8010602a <alltraps>

80106806 <vector87>:
.globl vector87
vector87:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $87
80106808:	6a 57                	push   $0x57
  jmp alltraps
8010680a:	e9 1b f8 ff ff       	jmp    8010602a <alltraps>

8010680f <vector88>:
.globl vector88
vector88:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $88
80106811:	6a 58                	push   $0x58
  jmp alltraps
80106813:	e9 12 f8 ff ff       	jmp    8010602a <alltraps>

80106818 <vector89>:
.globl vector89
vector89:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $89
8010681a:	6a 59                	push   $0x59
  jmp alltraps
8010681c:	e9 09 f8 ff ff       	jmp    8010602a <alltraps>

80106821 <vector90>:
.globl vector90
vector90:
  pushl $0
80106821:	6a 00                	push   $0x0
  pushl $90
80106823:	6a 5a                	push   $0x5a
  jmp alltraps
80106825:	e9 00 f8 ff ff       	jmp    8010602a <alltraps>

8010682a <vector91>:
.globl vector91
vector91:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $91
8010682c:	6a 5b                	push   $0x5b
  jmp alltraps
8010682e:	e9 f7 f7 ff ff       	jmp    8010602a <alltraps>

80106833 <vector92>:
.globl vector92
vector92:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $92
80106835:	6a 5c                	push   $0x5c
  jmp alltraps
80106837:	e9 ee f7 ff ff       	jmp    8010602a <alltraps>

8010683c <vector93>:
.globl vector93
vector93:
  pushl $0
8010683c:	6a 00                	push   $0x0
  pushl $93
8010683e:	6a 5d                	push   $0x5d
  jmp alltraps
80106840:	e9 e5 f7 ff ff       	jmp    8010602a <alltraps>

80106845 <vector94>:
.globl vector94
vector94:
  pushl $0
80106845:	6a 00                	push   $0x0
  pushl $94
80106847:	6a 5e                	push   $0x5e
  jmp alltraps
80106849:	e9 dc f7 ff ff       	jmp    8010602a <alltraps>

8010684e <vector95>:
.globl vector95
vector95:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $95
80106850:	6a 5f                	push   $0x5f
  jmp alltraps
80106852:	e9 d3 f7 ff ff       	jmp    8010602a <alltraps>

80106857 <vector96>:
.globl vector96
vector96:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $96
80106859:	6a 60                	push   $0x60
  jmp alltraps
8010685b:	e9 ca f7 ff ff       	jmp    8010602a <alltraps>

80106860 <vector97>:
.globl vector97
vector97:
  pushl $0
80106860:	6a 00                	push   $0x0
  pushl $97
80106862:	6a 61                	push   $0x61
  jmp alltraps
80106864:	e9 c1 f7 ff ff       	jmp    8010602a <alltraps>

80106869 <vector98>:
.globl vector98
vector98:
  pushl $0
80106869:	6a 00                	push   $0x0
  pushl $98
8010686b:	6a 62                	push   $0x62
  jmp alltraps
8010686d:	e9 b8 f7 ff ff       	jmp    8010602a <alltraps>

80106872 <vector99>:
.globl vector99
vector99:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $99
80106874:	6a 63                	push   $0x63
  jmp alltraps
80106876:	e9 af f7 ff ff       	jmp    8010602a <alltraps>

8010687b <vector100>:
.globl vector100
vector100:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $100
8010687d:	6a 64                	push   $0x64
  jmp alltraps
8010687f:	e9 a6 f7 ff ff       	jmp    8010602a <alltraps>

80106884 <vector101>:
.globl vector101
vector101:
  pushl $0
80106884:	6a 00                	push   $0x0
  pushl $101
80106886:	6a 65                	push   $0x65
  jmp alltraps
80106888:	e9 9d f7 ff ff       	jmp    8010602a <alltraps>

8010688d <vector102>:
.globl vector102
vector102:
  pushl $0
8010688d:	6a 00                	push   $0x0
  pushl $102
8010688f:	6a 66                	push   $0x66
  jmp alltraps
80106891:	e9 94 f7 ff ff       	jmp    8010602a <alltraps>

80106896 <vector103>:
.globl vector103
vector103:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $103
80106898:	6a 67                	push   $0x67
  jmp alltraps
8010689a:	e9 8b f7 ff ff       	jmp    8010602a <alltraps>

8010689f <vector104>:
.globl vector104
vector104:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $104
801068a1:	6a 68                	push   $0x68
  jmp alltraps
801068a3:	e9 82 f7 ff ff       	jmp    8010602a <alltraps>

801068a8 <vector105>:
.globl vector105
vector105:
  pushl $0
801068a8:	6a 00                	push   $0x0
  pushl $105
801068aa:	6a 69                	push   $0x69
  jmp alltraps
801068ac:	e9 79 f7 ff ff       	jmp    8010602a <alltraps>

801068b1 <vector106>:
.globl vector106
vector106:
  pushl $0
801068b1:	6a 00                	push   $0x0
  pushl $106
801068b3:	6a 6a                	push   $0x6a
  jmp alltraps
801068b5:	e9 70 f7 ff ff       	jmp    8010602a <alltraps>

801068ba <vector107>:
.globl vector107
vector107:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $107
801068bc:	6a 6b                	push   $0x6b
  jmp alltraps
801068be:	e9 67 f7 ff ff       	jmp    8010602a <alltraps>

801068c3 <vector108>:
.globl vector108
vector108:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $108
801068c5:	6a 6c                	push   $0x6c
  jmp alltraps
801068c7:	e9 5e f7 ff ff       	jmp    8010602a <alltraps>

801068cc <vector109>:
.globl vector109
vector109:
  pushl $0
801068cc:	6a 00                	push   $0x0
  pushl $109
801068ce:	6a 6d                	push   $0x6d
  jmp alltraps
801068d0:	e9 55 f7 ff ff       	jmp    8010602a <alltraps>

801068d5 <vector110>:
.globl vector110
vector110:
  pushl $0
801068d5:	6a 00                	push   $0x0
  pushl $110
801068d7:	6a 6e                	push   $0x6e
  jmp alltraps
801068d9:	e9 4c f7 ff ff       	jmp    8010602a <alltraps>

801068de <vector111>:
.globl vector111
vector111:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $111
801068e0:	6a 6f                	push   $0x6f
  jmp alltraps
801068e2:	e9 43 f7 ff ff       	jmp    8010602a <alltraps>

801068e7 <vector112>:
.globl vector112
vector112:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $112
801068e9:	6a 70                	push   $0x70
  jmp alltraps
801068eb:	e9 3a f7 ff ff       	jmp    8010602a <alltraps>

801068f0 <vector113>:
.globl vector113
vector113:
  pushl $0
801068f0:	6a 00                	push   $0x0
  pushl $113
801068f2:	6a 71                	push   $0x71
  jmp alltraps
801068f4:	e9 31 f7 ff ff       	jmp    8010602a <alltraps>

801068f9 <vector114>:
.globl vector114
vector114:
  pushl $0
801068f9:	6a 00                	push   $0x0
  pushl $114
801068fb:	6a 72                	push   $0x72
  jmp alltraps
801068fd:	e9 28 f7 ff ff       	jmp    8010602a <alltraps>

80106902 <vector115>:
.globl vector115
vector115:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $115
80106904:	6a 73                	push   $0x73
  jmp alltraps
80106906:	e9 1f f7 ff ff       	jmp    8010602a <alltraps>

8010690b <vector116>:
.globl vector116
vector116:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $116
8010690d:	6a 74                	push   $0x74
  jmp alltraps
8010690f:	e9 16 f7 ff ff       	jmp    8010602a <alltraps>

80106914 <vector117>:
.globl vector117
vector117:
  pushl $0
80106914:	6a 00                	push   $0x0
  pushl $117
80106916:	6a 75                	push   $0x75
  jmp alltraps
80106918:	e9 0d f7 ff ff       	jmp    8010602a <alltraps>

8010691d <vector118>:
.globl vector118
vector118:
  pushl $0
8010691d:	6a 00                	push   $0x0
  pushl $118
8010691f:	6a 76                	push   $0x76
  jmp alltraps
80106921:	e9 04 f7 ff ff       	jmp    8010602a <alltraps>

80106926 <vector119>:
.globl vector119
vector119:
  pushl $0
80106926:	6a 00                	push   $0x0
  pushl $119
80106928:	6a 77                	push   $0x77
  jmp alltraps
8010692a:	e9 fb f6 ff ff       	jmp    8010602a <alltraps>

8010692f <vector120>:
.globl vector120
vector120:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $120
80106931:	6a 78                	push   $0x78
  jmp alltraps
80106933:	e9 f2 f6 ff ff       	jmp    8010602a <alltraps>

80106938 <vector121>:
.globl vector121
vector121:
  pushl $0
80106938:	6a 00                	push   $0x0
  pushl $121
8010693a:	6a 79                	push   $0x79
  jmp alltraps
8010693c:	e9 e9 f6 ff ff       	jmp    8010602a <alltraps>

80106941 <vector122>:
.globl vector122
vector122:
  pushl $0
80106941:	6a 00                	push   $0x0
  pushl $122
80106943:	6a 7a                	push   $0x7a
  jmp alltraps
80106945:	e9 e0 f6 ff ff       	jmp    8010602a <alltraps>

8010694a <vector123>:
.globl vector123
vector123:
  pushl $0
8010694a:	6a 00                	push   $0x0
  pushl $123
8010694c:	6a 7b                	push   $0x7b
  jmp alltraps
8010694e:	e9 d7 f6 ff ff       	jmp    8010602a <alltraps>

80106953 <vector124>:
.globl vector124
vector124:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $124
80106955:	6a 7c                	push   $0x7c
  jmp alltraps
80106957:	e9 ce f6 ff ff       	jmp    8010602a <alltraps>

8010695c <vector125>:
.globl vector125
vector125:
  pushl $0
8010695c:	6a 00                	push   $0x0
  pushl $125
8010695e:	6a 7d                	push   $0x7d
  jmp alltraps
80106960:	e9 c5 f6 ff ff       	jmp    8010602a <alltraps>

80106965 <vector126>:
.globl vector126
vector126:
  pushl $0
80106965:	6a 00                	push   $0x0
  pushl $126
80106967:	6a 7e                	push   $0x7e
  jmp alltraps
80106969:	e9 bc f6 ff ff       	jmp    8010602a <alltraps>

8010696e <vector127>:
.globl vector127
vector127:
  pushl $0
8010696e:	6a 00                	push   $0x0
  pushl $127
80106970:	6a 7f                	push   $0x7f
  jmp alltraps
80106972:	e9 b3 f6 ff ff       	jmp    8010602a <alltraps>

80106977 <vector128>:
.globl vector128
vector128:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $128
80106979:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010697e:	e9 a7 f6 ff ff       	jmp    8010602a <alltraps>

80106983 <vector129>:
.globl vector129
vector129:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $129
80106985:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010698a:	e9 9b f6 ff ff       	jmp    8010602a <alltraps>

8010698f <vector130>:
.globl vector130
vector130:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $130
80106991:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106996:	e9 8f f6 ff ff       	jmp    8010602a <alltraps>

8010699b <vector131>:
.globl vector131
vector131:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $131
8010699d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801069a2:	e9 83 f6 ff ff       	jmp    8010602a <alltraps>

801069a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $132
801069a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801069ae:	e9 77 f6 ff ff       	jmp    8010602a <alltraps>

801069b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $133
801069b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801069ba:	e9 6b f6 ff ff       	jmp    8010602a <alltraps>

801069bf <vector134>:
.globl vector134
vector134:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $134
801069c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801069c6:	e9 5f f6 ff ff       	jmp    8010602a <alltraps>

801069cb <vector135>:
.globl vector135
vector135:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $135
801069cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801069d2:	e9 53 f6 ff ff       	jmp    8010602a <alltraps>

801069d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $136
801069d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801069de:	e9 47 f6 ff ff       	jmp    8010602a <alltraps>

801069e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $137
801069e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801069ea:	e9 3b f6 ff ff       	jmp    8010602a <alltraps>

801069ef <vector138>:
.globl vector138
vector138:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $138
801069f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801069f6:	e9 2f f6 ff ff       	jmp    8010602a <alltraps>

801069fb <vector139>:
.globl vector139
vector139:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $139
801069fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a02:	e9 23 f6 ff ff       	jmp    8010602a <alltraps>

80106a07 <vector140>:
.globl vector140
vector140:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $140
80106a09:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a0e:	e9 17 f6 ff ff       	jmp    8010602a <alltraps>

80106a13 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $141
80106a15:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a1a:	e9 0b f6 ff ff       	jmp    8010602a <alltraps>

80106a1f <vector142>:
.globl vector142
vector142:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $142
80106a21:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106a26:	e9 ff f5 ff ff       	jmp    8010602a <alltraps>

80106a2b <vector143>:
.globl vector143
vector143:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $143
80106a2d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106a32:	e9 f3 f5 ff ff       	jmp    8010602a <alltraps>

80106a37 <vector144>:
.globl vector144
vector144:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $144
80106a39:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106a3e:	e9 e7 f5 ff ff       	jmp    8010602a <alltraps>

80106a43 <vector145>:
.globl vector145
vector145:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $145
80106a45:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106a4a:	e9 db f5 ff ff       	jmp    8010602a <alltraps>

80106a4f <vector146>:
.globl vector146
vector146:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $146
80106a51:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106a56:	e9 cf f5 ff ff       	jmp    8010602a <alltraps>

80106a5b <vector147>:
.globl vector147
vector147:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $147
80106a5d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106a62:	e9 c3 f5 ff ff       	jmp    8010602a <alltraps>

80106a67 <vector148>:
.globl vector148
vector148:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $148
80106a69:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106a6e:	e9 b7 f5 ff ff       	jmp    8010602a <alltraps>

80106a73 <vector149>:
.globl vector149
vector149:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $149
80106a75:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106a7a:	e9 ab f5 ff ff       	jmp    8010602a <alltraps>

80106a7f <vector150>:
.globl vector150
vector150:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $150
80106a81:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106a86:	e9 9f f5 ff ff       	jmp    8010602a <alltraps>

80106a8b <vector151>:
.globl vector151
vector151:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $151
80106a8d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106a92:	e9 93 f5 ff ff       	jmp    8010602a <alltraps>

80106a97 <vector152>:
.globl vector152
vector152:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $152
80106a99:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106a9e:	e9 87 f5 ff ff       	jmp    8010602a <alltraps>

80106aa3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $153
80106aa5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106aaa:	e9 7b f5 ff ff       	jmp    8010602a <alltraps>

80106aaf <vector154>:
.globl vector154
vector154:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $154
80106ab1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ab6:	e9 6f f5 ff ff       	jmp    8010602a <alltraps>

80106abb <vector155>:
.globl vector155
vector155:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $155
80106abd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ac2:	e9 63 f5 ff ff       	jmp    8010602a <alltraps>

80106ac7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $156
80106ac9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106ace:	e9 57 f5 ff ff       	jmp    8010602a <alltraps>

80106ad3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $157
80106ad5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106ada:	e9 4b f5 ff ff       	jmp    8010602a <alltraps>

80106adf <vector158>:
.globl vector158
vector158:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $158
80106ae1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106ae6:	e9 3f f5 ff ff       	jmp    8010602a <alltraps>

80106aeb <vector159>:
.globl vector159
vector159:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $159
80106aed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106af2:	e9 33 f5 ff ff       	jmp    8010602a <alltraps>

80106af7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $160
80106af9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106afe:	e9 27 f5 ff ff       	jmp    8010602a <alltraps>

80106b03 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $161
80106b05:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b0a:	e9 1b f5 ff ff       	jmp    8010602a <alltraps>

80106b0f <vector162>:
.globl vector162
vector162:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $162
80106b11:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b16:	e9 0f f5 ff ff       	jmp    8010602a <alltraps>

80106b1b <vector163>:
.globl vector163
vector163:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $163
80106b1d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106b22:	e9 03 f5 ff ff       	jmp    8010602a <alltraps>

80106b27 <vector164>:
.globl vector164
vector164:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $164
80106b29:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106b2e:	e9 f7 f4 ff ff       	jmp    8010602a <alltraps>

80106b33 <vector165>:
.globl vector165
vector165:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $165
80106b35:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106b3a:	e9 eb f4 ff ff       	jmp    8010602a <alltraps>

80106b3f <vector166>:
.globl vector166
vector166:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $166
80106b41:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106b46:	e9 df f4 ff ff       	jmp    8010602a <alltraps>

80106b4b <vector167>:
.globl vector167
vector167:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $167
80106b4d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106b52:	e9 d3 f4 ff ff       	jmp    8010602a <alltraps>

80106b57 <vector168>:
.globl vector168
vector168:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $168
80106b59:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106b5e:	e9 c7 f4 ff ff       	jmp    8010602a <alltraps>

80106b63 <vector169>:
.globl vector169
vector169:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $169
80106b65:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106b6a:	e9 bb f4 ff ff       	jmp    8010602a <alltraps>

80106b6f <vector170>:
.globl vector170
vector170:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $170
80106b71:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106b76:	e9 af f4 ff ff       	jmp    8010602a <alltraps>

80106b7b <vector171>:
.globl vector171
vector171:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $171
80106b7d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106b82:	e9 a3 f4 ff ff       	jmp    8010602a <alltraps>

80106b87 <vector172>:
.globl vector172
vector172:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $172
80106b89:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106b8e:	e9 97 f4 ff ff       	jmp    8010602a <alltraps>

80106b93 <vector173>:
.globl vector173
vector173:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $173
80106b95:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106b9a:	e9 8b f4 ff ff       	jmp    8010602a <alltraps>

80106b9f <vector174>:
.globl vector174
vector174:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $174
80106ba1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ba6:	e9 7f f4 ff ff       	jmp    8010602a <alltraps>

80106bab <vector175>:
.globl vector175
vector175:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $175
80106bad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106bb2:	e9 73 f4 ff ff       	jmp    8010602a <alltraps>

80106bb7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $176
80106bb9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106bbe:	e9 67 f4 ff ff       	jmp    8010602a <alltraps>

80106bc3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $177
80106bc5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106bca:	e9 5b f4 ff ff       	jmp    8010602a <alltraps>

80106bcf <vector178>:
.globl vector178
vector178:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $178
80106bd1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106bd6:	e9 4f f4 ff ff       	jmp    8010602a <alltraps>

80106bdb <vector179>:
.globl vector179
vector179:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $179
80106bdd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106be2:	e9 43 f4 ff ff       	jmp    8010602a <alltraps>

80106be7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $180
80106be9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106bee:	e9 37 f4 ff ff       	jmp    8010602a <alltraps>

80106bf3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $181
80106bf5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106bfa:	e9 2b f4 ff ff       	jmp    8010602a <alltraps>

80106bff <vector182>:
.globl vector182
vector182:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $182
80106c01:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c06:	e9 1f f4 ff ff       	jmp    8010602a <alltraps>

80106c0b <vector183>:
.globl vector183
vector183:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $183
80106c0d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c12:	e9 13 f4 ff ff       	jmp    8010602a <alltraps>

80106c17 <vector184>:
.globl vector184
vector184:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $184
80106c19:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106c1e:	e9 07 f4 ff ff       	jmp    8010602a <alltraps>

80106c23 <vector185>:
.globl vector185
vector185:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $185
80106c25:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106c2a:	e9 fb f3 ff ff       	jmp    8010602a <alltraps>

80106c2f <vector186>:
.globl vector186
vector186:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $186
80106c31:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106c36:	e9 ef f3 ff ff       	jmp    8010602a <alltraps>

80106c3b <vector187>:
.globl vector187
vector187:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $187
80106c3d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106c42:	e9 e3 f3 ff ff       	jmp    8010602a <alltraps>

80106c47 <vector188>:
.globl vector188
vector188:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $188
80106c49:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106c4e:	e9 d7 f3 ff ff       	jmp    8010602a <alltraps>

80106c53 <vector189>:
.globl vector189
vector189:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $189
80106c55:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106c5a:	e9 cb f3 ff ff       	jmp    8010602a <alltraps>

80106c5f <vector190>:
.globl vector190
vector190:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $190
80106c61:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106c66:	e9 bf f3 ff ff       	jmp    8010602a <alltraps>

80106c6b <vector191>:
.globl vector191
vector191:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $191
80106c6d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106c72:	e9 b3 f3 ff ff       	jmp    8010602a <alltraps>

80106c77 <vector192>:
.globl vector192
vector192:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $192
80106c79:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106c7e:	e9 a7 f3 ff ff       	jmp    8010602a <alltraps>

80106c83 <vector193>:
.globl vector193
vector193:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $193
80106c85:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106c8a:	e9 9b f3 ff ff       	jmp    8010602a <alltraps>

80106c8f <vector194>:
.globl vector194
vector194:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $194
80106c91:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106c96:	e9 8f f3 ff ff       	jmp    8010602a <alltraps>

80106c9b <vector195>:
.globl vector195
vector195:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $195
80106c9d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ca2:	e9 83 f3 ff ff       	jmp    8010602a <alltraps>

80106ca7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $196
80106ca9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106cae:	e9 77 f3 ff ff       	jmp    8010602a <alltraps>

80106cb3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $197
80106cb5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106cba:	e9 6b f3 ff ff       	jmp    8010602a <alltraps>

80106cbf <vector198>:
.globl vector198
vector198:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $198
80106cc1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106cc6:	e9 5f f3 ff ff       	jmp    8010602a <alltraps>

80106ccb <vector199>:
.globl vector199
vector199:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $199
80106ccd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106cd2:	e9 53 f3 ff ff       	jmp    8010602a <alltraps>

80106cd7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $200
80106cd9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106cde:	e9 47 f3 ff ff       	jmp    8010602a <alltraps>

80106ce3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $201
80106ce5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106cea:	e9 3b f3 ff ff       	jmp    8010602a <alltraps>

80106cef <vector202>:
.globl vector202
vector202:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $202
80106cf1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106cf6:	e9 2f f3 ff ff       	jmp    8010602a <alltraps>

80106cfb <vector203>:
.globl vector203
vector203:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $203
80106cfd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d02:	e9 23 f3 ff ff       	jmp    8010602a <alltraps>

80106d07 <vector204>:
.globl vector204
vector204:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $204
80106d09:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d0e:	e9 17 f3 ff ff       	jmp    8010602a <alltraps>

80106d13 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $205
80106d15:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d1a:	e9 0b f3 ff ff       	jmp    8010602a <alltraps>

80106d1f <vector206>:
.globl vector206
vector206:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $206
80106d21:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106d26:	e9 ff f2 ff ff       	jmp    8010602a <alltraps>

80106d2b <vector207>:
.globl vector207
vector207:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $207
80106d2d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106d32:	e9 f3 f2 ff ff       	jmp    8010602a <alltraps>

80106d37 <vector208>:
.globl vector208
vector208:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $208
80106d39:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106d3e:	e9 e7 f2 ff ff       	jmp    8010602a <alltraps>

80106d43 <vector209>:
.globl vector209
vector209:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $209
80106d45:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106d4a:	e9 db f2 ff ff       	jmp    8010602a <alltraps>

80106d4f <vector210>:
.globl vector210
vector210:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $210
80106d51:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106d56:	e9 cf f2 ff ff       	jmp    8010602a <alltraps>

80106d5b <vector211>:
.globl vector211
vector211:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $211
80106d5d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106d62:	e9 c3 f2 ff ff       	jmp    8010602a <alltraps>

80106d67 <vector212>:
.globl vector212
vector212:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $212
80106d69:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106d6e:	e9 b7 f2 ff ff       	jmp    8010602a <alltraps>

80106d73 <vector213>:
.globl vector213
vector213:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $213
80106d75:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106d7a:	e9 ab f2 ff ff       	jmp    8010602a <alltraps>

80106d7f <vector214>:
.globl vector214
vector214:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $214
80106d81:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106d86:	e9 9f f2 ff ff       	jmp    8010602a <alltraps>

80106d8b <vector215>:
.globl vector215
vector215:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $215
80106d8d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106d92:	e9 93 f2 ff ff       	jmp    8010602a <alltraps>

80106d97 <vector216>:
.globl vector216
vector216:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $216
80106d99:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106d9e:	e9 87 f2 ff ff       	jmp    8010602a <alltraps>

80106da3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $217
80106da5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106daa:	e9 7b f2 ff ff       	jmp    8010602a <alltraps>

80106daf <vector218>:
.globl vector218
vector218:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $218
80106db1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106db6:	e9 6f f2 ff ff       	jmp    8010602a <alltraps>

80106dbb <vector219>:
.globl vector219
vector219:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $219
80106dbd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106dc2:	e9 63 f2 ff ff       	jmp    8010602a <alltraps>

80106dc7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $220
80106dc9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106dce:	e9 57 f2 ff ff       	jmp    8010602a <alltraps>

80106dd3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $221
80106dd5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106dda:	e9 4b f2 ff ff       	jmp    8010602a <alltraps>

80106ddf <vector222>:
.globl vector222
vector222:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $222
80106de1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106de6:	e9 3f f2 ff ff       	jmp    8010602a <alltraps>

80106deb <vector223>:
.globl vector223
vector223:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $223
80106ded:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106df2:	e9 33 f2 ff ff       	jmp    8010602a <alltraps>

80106df7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $224
80106df9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106dfe:	e9 27 f2 ff ff       	jmp    8010602a <alltraps>

80106e03 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $225
80106e05:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e0a:	e9 1b f2 ff ff       	jmp    8010602a <alltraps>

80106e0f <vector226>:
.globl vector226
vector226:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $226
80106e11:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e16:	e9 0f f2 ff ff       	jmp    8010602a <alltraps>

80106e1b <vector227>:
.globl vector227
vector227:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $227
80106e1d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106e22:	e9 03 f2 ff ff       	jmp    8010602a <alltraps>

80106e27 <vector228>:
.globl vector228
vector228:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $228
80106e29:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106e2e:	e9 f7 f1 ff ff       	jmp    8010602a <alltraps>

80106e33 <vector229>:
.globl vector229
vector229:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $229
80106e35:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106e3a:	e9 eb f1 ff ff       	jmp    8010602a <alltraps>

80106e3f <vector230>:
.globl vector230
vector230:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $230
80106e41:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106e46:	e9 df f1 ff ff       	jmp    8010602a <alltraps>

80106e4b <vector231>:
.globl vector231
vector231:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $231
80106e4d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106e52:	e9 d3 f1 ff ff       	jmp    8010602a <alltraps>

80106e57 <vector232>:
.globl vector232
vector232:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $232
80106e59:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106e5e:	e9 c7 f1 ff ff       	jmp    8010602a <alltraps>

80106e63 <vector233>:
.globl vector233
vector233:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $233
80106e65:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106e6a:	e9 bb f1 ff ff       	jmp    8010602a <alltraps>

80106e6f <vector234>:
.globl vector234
vector234:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $234
80106e71:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106e76:	e9 af f1 ff ff       	jmp    8010602a <alltraps>

80106e7b <vector235>:
.globl vector235
vector235:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $235
80106e7d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106e82:	e9 a3 f1 ff ff       	jmp    8010602a <alltraps>

80106e87 <vector236>:
.globl vector236
vector236:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $236
80106e89:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106e8e:	e9 97 f1 ff ff       	jmp    8010602a <alltraps>

80106e93 <vector237>:
.globl vector237
vector237:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $237
80106e95:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106e9a:	e9 8b f1 ff ff       	jmp    8010602a <alltraps>

80106e9f <vector238>:
.globl vector238
vector238:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $238
80106ea1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ea6:	e9 7f f1 ff ff       	jmp    8010602a <alltraps>

80106eab <vector239>:
.globl vector239
vector239:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $239
80106ead:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106eb2:	e9 73 f1 ff ff       	jmp    8010602a <alltraps>

80106eb7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $240
80106eb9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ebe:	e9 67 f1 ff ff       	jmp    8010602a <alltraps>

80106ec3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $241
80106ec5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106eca:	e9 5b f1 ff ff       	jmp    8010602a <alltraps>

80106ecf <vector242>:
.globl vector242
vector242:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $242
80106ed1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ed6:	e9 4f f1 ff ff       	jmp    8010602a <alltraps>

80106edb <vector243>:
.globl vector243
vector243:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $243
80106edd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ee2:	e9 43 f1 ff ff       	jmp    8010602a <alltraps>

80106ee7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $244
80106ee9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106eee:	e9 37 f1 ff ff       	jmp    8010602a <alltraps>

80106ef3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $245
80106ef5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106efa:	e9 2b f1 ff ff       	jmp    8010602a <alltraps>

80106eff <vector246>:
.globl vector246
vector246:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $246
80106f01:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f06:	e9 1f f1 ff ff       	jmp    8010602a <alltraps>

80106f0b <vector247>:
.globl vector247
vector247:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $247
80106f0d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f12:	e9 13 f1 ff ff       	jmp    8010602a <alltraps>

80106f17 <vector248>:
.globl vector248
vector248:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $248
80106f19:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106f1e:	e9 07 f1 ff ff       	jmp    8010602a <alltraps>

80106f23 <vector249>:
.globl vector249
vector249:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $249
80106f25:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106f2a:	e9 fb f0 ff ff       	jmp    8010602a <alltraps>

80106f2f <vector250>:
.globl vector250
vector250:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $250
80106f31:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106f36:	e9 ef f0 ff ff       	jmp    8010602a <alltraps>

80106f3b <vector251>:
.globl vector251
vector251:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $251
80106f3d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106f42:	e9 e3 f0 ff ff       	jmp    8010602a <alltraps>

80106f47 <vector252>:
.globl vector252
vector252:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $252
80106f49:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106f4e:	e9 d7 f0 ff ff       	jmp    8010602a <alltraps>

80106f53 <vector253>:
.globl vector253
vector253:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $253
80106f55:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106f5a:	e9 cb f0 ff ff       	jmp    8010602a <alltraps>

80106f5f <vector254>:
.globl vector254
vector254:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $254
80106f61:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106f66:	e9 bf f0 ff ff       	jmp    8010602a <alltraps>

80106f6b <vector255>:
.globl vector255
vector255:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $255
80106f6d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106f72:	e9 b3 f0 ff ff       	jmp    8010602a <alltraps>
80106f77:	66 90                	xchg   %ax,%ax
80106f79:	66 90                	xchg   %ax,%ax
80106f7b:	66 90                	xchg   %ax,%ax
80106f7d:	66 90                	xchg   %ax,%ax
80106f7f:	90                   	nop

80106f80 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106f86:	89 d3                	mov    %edx,%ebx
{
80106f88:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106f8a:	c1 eb 16             	shr    $0x16,%ebx
80106f8d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106f90:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106f93:	8b 06                	mov    (%esi),%eax
80106f95:	a8 01                	test   $0x1,%al
80106f97:	74 27                	je     80106fc0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f9e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106fa4:	c1 ef 0a             	shr    $0xa,%edi
}
80106fa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106faa:	89 fa                	mov    %edi,%edx
80106fac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106fb2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106fb5:	5b                   	pop    %ebx
80106fb6:	5e                   	pop    %esi
80106fb7:	5f                   	pop    %edi
80106fb8:	5d                   	pop    %ebp
80106fb9:	c3                   	ret    
80106fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106fc0:	85 c9                	test   %ecx,%ecx
80106fc2:	74 2c                	je     80106ff0 <walkpgdir+0x70>
80106fc4:	e8 97 b9 ff ff       	call   80102960 <kalloc>
80106fc9:	85 c0                	test   %eax,%eax
80106fcb:	89 c3                	mov    %eax,%ebx
80106fcd:	74 21                	je     80106ff0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106fcf:	83 ec 04             	sub    $0x4,%esp
80106fd2:	68 00 10 00 00       	push   $0x1000
80106fd7:	6a 00                	push   $0x0
80106fd9:	50                   	push   %eax
80106fda:	e8 01 de ff ff       	call   80104de0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106fdf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106fe5:	83 c4 10             	add    $0x10,%esp
80106fe8:	83 c8 07             	or     $0x7,%eax
80106feb:	89 06                	mov    %eax,(%esi)
80106fed:	eb b5                	jmp    80106fa4 <walkpgdir+0x24>
80106fef:	90                   	nop
}
80106ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ff3:	31 c0                	xor    %eax,%eax
}
80106ff5:	5b                   	pop    %ebx
80106ff6:	5e                   	pop    %esi
80106ff7:	5f                   	pop    %edi
80106ff8:	5d                   	pop    %ebp
80106ff9:	c3                   	ret    
80106ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107000 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	57                   	push   %edi
80107004:	56                   	push   %esi
80107005:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107006:	89 d3                	mov    %edx,%ebx
80107008:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010700e:	83 ec 1c             	sub    $0x1c,%esp
80107011:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107014:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107018:	8b 7d 08             	mov    0x8(%ebp),%edi
8010701b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107020:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107023:	8b 45 0c             	mov    0xc(%ebp),%eax
80107026:	29 df                	sub    %ebx,%edi
80107028:	83 c8 01             	or     $0x1,%eax
8010702b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010702e:	eb 15                	jmp    80107045 <mappages+0x45>
    if(*pte & PTE_P)
80107030:	f6 00 01             	testb  $0x1,(%eax)
80107033:	75 45                	jne    8010707a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107035:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107038:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010703b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010703d:	74 31                	je     80107070 <mappages+0x70>
      break;
    a += PGSIZE;
8010703f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107045:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107048:	b9 01 00 00 00       	mov    $0x1,%ecx
8010704d:	89 da                	mov    %ebx,%edx
8010704f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107052:	e8 29 ff ff ff       	call   80106f80 <walkpgdir>
80107057:	85 c0                	test   %eax,%eax
80107059:	75 d5                	jne    80107030 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010705b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010705e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107063:	5b                   	pop    %ebx
80107064:	5e                   	pop    %esi
80107065:	5f                   	pop    %edi
80107066:	5d                   	pop    %ebp
80107067:	c3                   	ret    
80107068:	90                   	nop
80107069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107070:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107073:	31 c0                	xor    %eax,%eax
}
80107075:	5b                   	pop    %ebx
80107076:	5e                   	pop    %esi
80107077:	5f                   	pop    %edi
80107078:	5d                   	pop    %ebp
80107079:	c3                   	ret    
      panic("remap");
8010707a:	83 ec 0c             	sub    $0xc,%esp
8010707d:	68 2c 84 10 80       	push   $0x8010842c
80107082:	e8 09 93 ff ff       	call   80100390 <panic>
80107087:	89 f6                	mov    %esi,%esi
80107089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107090 <seginit>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107096:	e8 25 cd ff ff       	call   80103dc0 <cpuid>
8010709b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801070a1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801070a6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070aa:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
801070b1:	ff 00 00 
801070b4:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
801070bb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070be:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
801070c5:	ff 00 00 
801070c8:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
801070cf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070d2:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
801070d9:	ff 00 00 
801070dc:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
801070e3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801070e6:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
801070ed:	ff 00 00 
801070f0:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
801070f7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801070fa:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
801070ff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107103:	c1 e8 10             	shr    $0x10,%eax
80107106:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010710a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010710d:	0f 01 10             	lgdtl  (%eax)
}
80107110:	c9                   	leave  
80107111:	c3                   	ret    
80107112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107120 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107120:	a1 c4 01 12 80       	mov    0x801201c4,%eax
{
80107125:	55                   	push   %ebp
80107126:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107128:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010712d:	0f 22 d8             	mov    %eax,%cr3
}
80107130:	5d                   	pop    %ebp
80107131:	c3                   	ret    
80107132:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107140 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 1c             	sub    $0x1c,%esp
80107149:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010714c:	85 db                	test   %ebx,%ebx
8010714e:	0f 84 cb 00 00 00    	je     8010721f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107154:	8b 43 08             	mov    0x8(%ebx),%eax
80107157:	85 c0                	test   %eax,%eax
80107159:	0f 84 da 00 00 00    	je     80107239 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010715f:	8b 43 04             	mov    0x4(%ebx),%eax
80107162:	85 c0                	test   %eax,%eax
80107164:	0f 84 c2 00 00 00    	je     8010722c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
8010716a:	e8 91 da ff ff       	call   80104c00 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010716f:	e8 cc cb ff ff       	call   80103d40 <mycpu>
80107174:	89 c6                	mov    %eax,%esi
80107176:	e8 c5 cb ff ff       	call   80103d40 <mycpu>
8010717b:	89 c7                	mov    %eax,%edi
8010717d:	e8 be cb ff ff       	call   80103d40 <mycpu>
80107182:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107185:	83 c7 08             	add    $0x8,%edi
80107188:	e8 b3 cb ff ff       	call   80103d40 <mycpu>
8010718d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107190:	83 c0 08             	add    $0x8,%eax
80107193:	ba 67 00 00 00       	mov    $0x67,%edx
80107198:	c1 e8 18             	shr    $0x18,%eax
8010719b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801071a2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801071a9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071af:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071b4:	83 c1 08             	add    $0x8,%ecx
801071b7:	c1 e9 10             	shr    $0x10,%ecx
801071ba:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801071c0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801071c5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801071cc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801071d1:	e8 6a cb ff ff       	call   80103d40 <mycpu>
801071d6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801071dd:	e8 5e cb ff ff       	call   80103d40 <mycpu>
801071e2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801071e6:	8b 73 08             	mov    0x8(%ebx),%esi
801071e9:	e8 52 cb ff ff       	call   80103d40 <mycpu>
801071ee:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071f4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071f7:	e8 44 cb ff ff       	call   80103d40 <mycpu>
801071fc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107200:	b8 28 00 00 00       	mov    $0x28,%eax
80107205:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107208:	8b 43 04             	mov    0x4(%ebx),%eax
8010720b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107210:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107213:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107216:	5b                   	pop    %ebx
80107217:	5e                   	pop    %esi
80107218:	5f                   	pop    %edi
80107219:	5d                   	pop    %ebp
  popcli();
8010721a:	e9 21 da ff ff       	jmp    80104c40 <popcli>
    panic("switchuvm: no process");
8010721f:	83 ec 0c             	sub    $0xc,%esp
80107222:	68 32 84 10 80       	push   $0x80108432
80107227:	e8 64 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010722c:	83 ec 0c             	sub    $0xc,%esp
8010722f:	68 5d 84 10 80       	push   $0x8010845d
80107234:	e8 57 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107239:	83 ec 0c             	sub    $0xc,%esp
8010723c:	68 48 84 10 80       	push   $0x80108448
80107241:	e8 4a 91 ff ff       	call   80100390 <panic>
80107246:	8d 76 00             	lea    0x0(%esi),%esi
80107249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107250 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
80107256:	83 ec 1c             	sub    $0x1c,%esp
80107259:	8b 75 10             	mov    0x10(%ebp),%esi
8010725c:	8b 45 08             	mov    0x8(%ebp),%eax
8010725f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107262:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107268:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010726b:	77 49                	ja     801072b6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010726d:	e8 ee b6 ff ff       	call   80102960 <kalloc>
  memset(mem, 0, PGSIZE);
80107272:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107275:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107277:	68 00 10 00 00       	push   $0x1000
8010727c:	6a 00                	push   $0x0
8010727e:	50                   	push   %eax
8010727f:	e8 5c db ff ff       	call   80104de0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107284:	58                   	pop    %eax
80107285:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010728b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107290:	5a                   	pop    %edx
80107291:	6a 06                	push   $0x6
80107293:	50                   	push   %eax
80107294:	31 d2                	xor    %edx,%edx
80107296:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107299:	e8 62 fd ff ff       	call   80107000 <mappages>
  memmove(mem, init, sz);
8010729e:	89 75 10             	mov    %esi,0x10(%ebp)
801072a1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801072a4:	83 c4 10             	add    $0x10,%esp
801072a7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801072aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ad:	5b                   	pop    %ebx
801072ae:	5e                   	pop    %esi
801072af:	5f                   	pop    %edi
801072b0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801072b1:	e9 da db ff ff       	jmp    80104e90 <memmove>
    panic("inituvm: more than a page");
801072b6:	83 ec 0c             	sub    $0xc,%esp
801072b9:	68 71 84 10 80       	push   $0x80108471
801072be:	e8 cd 90 ff ff       	call   80100390 <panic>
801072c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072d0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801072d0:	55                   	push   %ebp
801072d1:	89 e5                	mov    %esp,%ebp
801072d3:	57                   	push   %edi
801072d4:	56                   	push   %esi
801072d5:	53                   	push   %ebx
801072d6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801072d9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801072e0:	0f 85 91 00 00 00    	jne    80107377 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801072e6:	8b 75 18             	mov    0x18(%ebp),%esi
801072e9:	31 db                	xor    %ebx,%ebx
801072eb:	85 f6                	test   %esi,%esi
801072ed:	75 1a                	jne    80107309 <loaduvm+0x39>
801072ef:	eb 6f                	jmp    80107360 <loaduvm+0x90>
801072f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072f8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072fe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107304:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107307:	76 57                	jbe    80107360 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107309:	8b 55 0c             	mov    0xc(%ebp),%edx
8010730c:	8b 45 08             	mov    0x8(%ebp),%eax
8010730f:	31 c9                	xor    %ecx,%ecx
80107311:	01 da                	add    %ebx,%edx
80107313:	e8 68 fc ff ff       	call   80106f80 <walkpgdir>
80107318:	85 c0                	test   %eax,%eax
8010731a:	74 4e                	je     8010736a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010731c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010731e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107321:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107326:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010732b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107331:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107334:	01 d9                	add    %ebx,%ecx
80107336:	05 00 00 00 80       	add    $0x80000000,%eax
8010733b:	57                   	push   %edi
8010733c:	51                   	push   %ecx
8010733d:	50                   	push   %eax
8010733e:	ff 75 10             	pushl  0x10(%ebp)
80107341:	e8 ea a6 ff ff       	call   80101a30 <readi>
80107346:	83 c4 10             	add    $0x10,%esp
80107349:	39 f8                	cmp    %edi,%eax
8010734b:	74 ab                	je     801072f8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010734d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107355:	5b                   	pop    %ebx
80107356:	5e                   	pop    %esi
80107357:	5f                   	pop    %edi
80107358:	5d                   	pop    %ebp
80107359:	c3                   	ret    
8010735a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107360:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107363:	31 c0                	xor    %eax,%eax
}
80107365:	5b                   	pop    %ebx
80107366:	5e                   	pop    %esi
80107367:	5f                   	pop    %edi
80107368:	5d                   	pop    %ebp
80107369:	c3                   	ret    
      panic("loaduvm: address should exist");
8010736a:	83 ec 0c             	sub    $0xc,%esp
8010736d:	68 8b 84 10 80       	push   $0x8010848b
80107372:	e8 19 90 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107377:	83 ec 0c             	sub    $0xc,%esp
8010737a:	68 3c 85 10 80       	push   $0x8010853c
8010737f:	e8 0c 90 ff ff       	call   80100390 <panic>
80107384:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010738a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107390 <accessedBit>:

int accessedBit(char *va){
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	83 ec 08             	sub    $0x8,%esp
  struct proc *proc = myproc();
80107396:	e8 45 ca ff ff       	call   80103de0 <myproc>
  uint flag;
  pte_t *pte = walkpgdir(proc->pgdir,(void*)va,0);
8010739b:	8b 55 08             	mov    0x8(%ebp),%edx
8010739e:	8b 40 04             	mov    0x4(%eax),%eax
801073a1:	31 c9                	xor    %ecx,%ecx
801073a3:	e8 d8 fb ff ff       	call   80106f80 <walkpgdir>
  
  if(pte){
801073a8:	85 c0                	test   %eax,%eax
801073aa:	74 10                	je     801073bc <accessedBit+0x2c>
    flag = (*pte) & PTE_A;
801073ac:	8b 10                	mov    (%eax),%edx
    (*pte) &= ~PTE_A;
801073ae:	89 d1                	mov    %edx,%ecx
801073b0:	83 e1 df             	and    $0xffffffdf,%ecx
801073b3:	89 08                	mov    %ecx,(%eax)
    flag = (*pte) & PTE_A;
801073b5:	89 d0                	mov    %edx,%eax
801073b7:	83 e0 20             	and    $0x20,%eax
    return flag;  
  }
  else 
    panic("pte not found");
}
801073ba:	c9                   	leave  
801073bb:	c3                   	ret    
    panic("pte not found");
801073bc:	83 ec 0c             	sub    $0xc,%esp
801073bf:	68 a9 84 10 80       	push   $0x801084a9
801073c4:	e8 c7 8f ff ff       	call   80100390 <panic>
801073c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073d0 <writePageToSwapFile>:

struct freePage *writePageToSwapFile(char *va){
801073d0:	55                   	push   %ebp
  panic("writePagesToSwapFile: FIFO no slot for swapped page");
  
#endif

  return 0;  
}
801073d1:	31 c0                	xor    %eax,%eax
struct freePage *writePageToSwapFile(char *va){
801073d3:	89 e5                	mov    %esp,%ebp
}
801073d5:	5d                   	pop    %ebp
801073d6:	c3                   	ret    
801073d7:	89 f6                	mov    %esi,%esi
801073d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073e0 <recordNewPage>:

void recordNewPage(char *va){
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
    }
    cprintf("panic follows, pid:%d, name:%s\n", proc->pid, proc->name);
    panic("recordNewPage: no free pages"); 
  
  #endif
}
801073e3:	5d                   	pop    %ebp
801073e4:	c3                   	ret    
801073e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073f0 <swapAfterPageFault>:
    }
  }
  return newsz;
}

void swapAfterPageFault(uint addr){
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
      }
      i++;
    }
    panic("Problem in swappages");
  #endif
}
801073f3:	5d                   	pop    %ebp
  struct proc *proc = myproc();
801073f4:	e9 e7 c9 ff ff       	jmp    80103de0 <myproc>
801073f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107400 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
80107405:	53                   	push   %ebx
80107406:	83 ec 1c             	sub    $0x1c,%esp
80107409:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc* proc = myproc();
8010740c:	e8 cf c9 ff ff       	call   80103de0 <myproc>
80107411:	89 c6                	mov    %eax,%esi

  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107413:	8b 45 0c             	mov    0xc(%ebp),%eax
80107416:	39 45 10             	cmp    %eax,0x10(%ebp)
80107419:	0f 83 eb 00 00 00    	jae    8010750a <deallocuvm+0x10a>
    return oldsz;

  a = PGROUNDUP(newsz);
8010741f:	8b 45 10             	mov    0x10(%ebp),%eax
80107422:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107428:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010742e:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107431:	0f 86 d0 00 00 00    	jbe    80107507 <deallocuvm+0x107>
80107437:	8d 86 e8 02 00 00    	lea    0x2e8(%esi),%eax
8010743d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107440:	8d 86 bc 01 00 00    	lea    0x1bc(%esi),%eax
80107446:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107449:	eb 45                	jmp    80107490 <deallocuvm+0x90>
8010744b:	90                   	nop
8010744c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107450:	89 d1                	mov    %edx,%ecx
80107452:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80107458:	0f 84 f9 00 00 00    	je     80107557 <deallocuvm+0x157>
        panic("kfree");
      if(proc->pgdir == pgdir){
8010745e:	39 7e 04             	cmp    %edi,0x4(%esi)
80107461:	0f 84 b1 00 00 00    	je     80107518 <deallocuvm+0x118>
            proc->mainMemoryPageCount--;
          }    
        }
#endif
      }
      char *v = P2V(pa);
80107467:	8d 91 00 00 00 80    	lea    -0x80000000(%ecx),%edx
      kfree(v);
8010746d:	83 ec 0c             	sub    $0xc,%esp
80107470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107473:	52                   	push   %edx
80107474:	e8 f7 b2 ff ff       	call   80102770 <kfree>
      *pte = 0;
80107479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010747c:	83 c4 10             	add    $0x10,%esp
8010747f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107485:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010748b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
8010748e:	76 77                	jbe    80107507 <deallocuvm+0x107>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107490:	31 c9                	xor    %ecx,%ecx
80107492:	89 da                	mov    %ebx,%edx
80107494:	89 f8                	mov    %edi,%eax
80107496:	e8 e5 fa ff ff       	call   80106f80 <walkpgdir>
    if(!pte)
8010749b:	85 c0                	test   %eax,%eax
8010749d:	74 51                	je     801074f0 <deallocuvm+0xf0>
    else if((*pte & PTE_P) != 0){
8010749f:	8b 10                	mov    (%eax),%edx
801074a1:	f6 c2 01             	test   $0x1,%dl
801074a4:	75 aa                	jne    80107450 <deallocuvm+0x50>
    }
    else if((*pte & PTE_PG) && proc->pgdir == pgdir){
801074a6:	80 e6 02             	and    $0x2,%dh
801074a9:	74 da                	je     80107485 <deallocuvm+0x85>
801074ab:	39 7e 04             	cmp    %edi,0x4(%esi)
801074ae:	75 d5                	jne    80107485 <deallocuvm+0x85>
801074b0:	8d 86 bc 01 00 00    	lea    0x1bc(%esi),%eax
801074b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
801074b9:	eb 0c                	jmp    801074c7 <deallocuvm+0xc7>
801074bb:	90                   	nop
801074bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074c0:	83 c0 14             	add    $0x14,%eax
      for(i=0; i<MAX_PSYC_PAGES; i++){
801074c3:	39 d0                	cmp    %edx,%eax
801074c5:	74 be                	je     80107485 <deallocuvm+0x85>
        if(proc->swappedPages[i].virtualAddress == (char*)a){
801074c7:	3b 18                	cmp    (%eax),%ebx
801074c9:	75 f5                	jne    801074c0 <deallocuvm+0xc0>
          proc->swappedPages[i].virtualAddress = (char*) 0xffffffff;
801074cb:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
          proc->swappedPages[i].age = 0;
801074d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
          proc->swappedPages[i].swaploc = 0;
801074d8:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
          proc->swapFilePageCount--;     
801074df:	83 ae 84 00 00 00 01 	subl   $0x1,0x84(%esi)
801074e6:	eb d8                	jmp    801074c0 <deallocuvm+0xc0>
801074e8:	90                   	nop
801074e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801074f0:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801074f6:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801074fc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107502:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107505:	77 89                	ja     80107490 <deallocuvm+0x90>
        }
      }
    }
  }
  return newsz;
80107507:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010750a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010750d:	5b                   	pop    %ebx
8010750e:	5e                   	pop    %esi
8010750f:	5f                   	pop    %edi
80107510:	5d                   	pop    %ebp
80107511:	c3                   	ret    
80107512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107518:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010751b:	8d 96 90 00 00 00    	lea    0x90(%esi),%edx
80107521:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107524:	eb 11                	jmp    80107537 <deallocuvm+0x137>
80107526:	8d 76 00             	lea    0x0(%esi),%esi
80107529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107530:	83 c2 14             	add    $0x14,%edx
        for(i=0; i<MAX_PSYC_PAGES; i++){
80107533:	39 c2                	cmp    %eax,%edx
80107535:	74 18                	je     8010754f <deallocuvm+0x14f>
          if(proc->freePages[i].virtualAddress == (char*)a){
80107537:	3b 1a                	cmp    (%edx),%ebx
80107539:	75 f5                	jne    80107530 <deallocuvm+0x130>
            proc->freePages[i].virtualAddress = (char*)0xffffffff;
8010753b:	c7 02 ff ff ff ff    	movl   $0xffffffff,(%edx)
80107541:	83 c2 14             	add    $0x14,%edx
            proc->mainMemoryPageCount--;
80107544:	83 ae 80 00 00 00 01 	subl   $0x1,0x80(%esi)
        for(i=0; i<MAX_PSYC_PAGES; i++){
8010754b:	39 c2                	cmp    %eax,%edx
8010754d:	75 e8                	jne    80107537 <deallocuvm+0x137>
8010754f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107552:	e9 10 ff ff ff       	jmp    80107467 <deallocuvm+0x67>
        panic("kfree");
80107557:	83 ec 0c             	sub    $0xc,%esp
8010755a:	68 ca 7c 10 80       	push   $0x80107cca
8010755f:	e8 2c 8e ff ff       	call   80100390 <panic>
80107564:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010756a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107570 <allocuvm>:
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	57                   	push   %edi
80107574:	56                   	push   %esi
80107575:	53                   	push   %ebx
80107576:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107579:	8b 7d 10             	mov    0x10(%ebp),%edi
8010757c:	85 ff                	test   %edi,%edi
8010757e:	0f 88 cc 00 00 00    	js     80107650 <allocuvm+0xe0>
  if(newsz < oldsz)
80107584:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107587:	73 17                	jae    801075a0 <allocuvm+0x30>
    return oldsz;
80107589:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
8010758c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010758f:	89 f8                	mov    %edi,%eax
80107591:	5b                   	pop    %ebx
80107592:	5e                   	pop    %esi
80107593:	5f                   	pop    %edi
80107594:	5d                   	pop    %ebp
80107595:	c3                   	ret    
80107596:	8d 76 00             	lea    0x0(%esi),%esi
80107599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  a = PGROUNDUP(oldsz);
801075a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801075a3:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
    struct proc *proc = myproc();
801075a9:	e8 32 c8 ff ff       	call   80103de0 <myproc>
  a = PGROUNDUP(oldsz);
801075ae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801075b4:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801075b7:	76 d3                	jbe    8010758c <allocuvm+0x1c>
801075b9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801075bc:	89 c7                	mov    %eax,%edi
801075be:	eb 40                	jmp    80107600 <allocuvm+0x90>
    memset(mem, 0, PGSIZE);
801075c0:	83 ec 04             	sub    $0x4,%esp
801075c3:	68 00 10 00 00       	push   $0x1000
801075c8:	6a 00                	push   $0x0
801075ca:	50                   	push   %eax
801075cb:	e8 10 d8 ff ff       	call   80104de0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075d0:	58                   	pop    %eax
801075d1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801075d7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075dc:	5a                   	pop    %edx
801075dd:	6a 06                	push   $0x6
801075df:	50                   	push   %eax
801075e0:	89 da                	mov    %ebx,%edx
801075e2:	8b 45 08             	mov    0x8(%ebp),%eax
801075e5:	e8 16 fa ff ff       	call   80107000 <mappages>
801075ea:	83 c4 10             	add    $0x10,%esp
801075ed:	85 c0                	test   %eax,%eax
801075ef:	78 6f                	js     80107660 <allocuvm+0xf0>
  for(; a < newsz; a += PGSIZE){
801075f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075f7:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801075fa:	0f 86 90 00 00 00    	jbe    80107690 <allocuvm+0x120>
    if(proc->mainMemoryPageCount >= MAX_PSYC_PAGES && proc->pid > 2){
80107600:	83 bf 80 00 00 00 0e 	cmpl   $0xe,0x80(%edi)
80107607:	7e 0a                	jle    80107613 <allocuvm+0xa3>
80107609:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
8010760d:	0f 8f 85 00 00 00    	jg     80107698 <allocuvm+0x128>
    mem = kalloc();
80107613:	e8 48 b3 ff ff       	call   80102960 <kalloc>
    if(mem == 0){
80107618:	85 c0                	test   %eax,%eax
    mem = kalloc();
8010761a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010761c:	75 a2                	jne    801075c0 <allocuvm+0x50>
      cprintf("allocuvm out of memory\n");
8010761e:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107621:	31 ff                	xor    %edi,%edi
      cprintf("allocuvm out of memory\n");
80107623:	68 b7 84 10 80       	push   $0x801084b7
80107628:	e8 33 90 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010762d:	83 c4 0c             	add    $0xc,%esp
80107630:	ff 75 0c             	pushl  0xc(%ebp)
80107633:	ff 75 10             	pushl  0x10(%ebp)
80107636:	ff 75 08             	pushl  0x8(%ebp)
80107639:	e8 c2 fd ff ff       	call   80107400 <deallocuvm>
      return 0;
8010763e:	83 c4 10             	add    $0x10,%esp
80107641:	e9 46 ff ff ff       	jmp    8010758c <allocuvm+0x1c>
80107646:	8d 76 00             	lea    0x0(%esi),%esi
80107649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80107650:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107653:	31 ff                	xor    %edi,%edi
}
80107655:	89 f8                	mov    %edi,%eax
80107657:	5b                   	pop    %ebx
80107658:	5e                   	pop    %esi
80107659:	5f                   	pop    %edi
8010765a:	5d                   	pop    %ebp
8010765b:	c3                   	ret    
8010765c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80107660:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107663:	31 ff                	xor    %edi,%edi
      cprintf("allocuvm out of memory (2)\n");
80107665:	68 cf 84 10 80       	push   $0x801084cf
8010766a:	e8 f1 8f ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010766f:	83 c4 0c             	add    $0xc,%esp
80107672:	ff 75 0c             	pushl  0xc(%ebp)
80107675:	ff 75 10             	pushl  0x10(%ebp)
80107678:	ff 75 08             	pushl  0x8(%ebp)
8010767b:	e8 80 fd ff ff       	call   80107400 <deallocuvm>
      kfree(mem);
80107680:	89 34 24             	mov    %esi,(%esp)
80107683:	e8 e8 b0 ff ff       	call   80102770 <kfree>
      return 0;
80107688:	83 c4 10             	add    $0x10,%esp
8010768b:	e9 fc fe ff ff       	jmp    8010758c <allocuvm+0x1c>
80107690:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107693:	e9 f4 fe ff ff       	jmp    8010758c <allocuvm+0x1c>
        panic("Cannot write to swap file :: allocuvm");
80107698:	83 ec 0c             	sub    $0xc,%esp
8010769b:	68 60 85 10 80       	push   $0x80108560
801076a0:	e8 eb 8c ff ff       	call   80100390 <panic>
801076a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	57                   	push   %edi
801076b4:	56                   	push   %esi
801076b5:	53                   	push   %ebx
801076b6:	83 ec 0c             	sub    $0xc,%esp
801076b9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801076bc:	85 f6                	test   %esi,%esi
801076be:	74 59                	je     80107719 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
801076c0:	83 ec 04             	sub    $0x4,%esp
801076c3:	89 f3                	mov    %esi,%ebx
801076c5:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801076cb:	6a 00                	push   $0x0
801076cd:	68 00 00 00 80       	push   $0x80000000
801076d2:	56                   	push   %esi
801076d3:	e8 28 fd ff ff       	call   80107400 <deallocuvm>
801076d8:	83 c4 10             	add    $0x10,%esp
801076db:	eb 0a                	jmp    801076e7 <freevm+0x37>
801076dd:	8d 76 00             	lea    0x0(%esi),%esi
801076e0:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
801076e3:	39 fb                	cmp    %edi,%ebx
801076e5:	74 23                	je     8010770a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801076e7:	8b 03                	mov    (%ebx),%eax
801076e9:	a8 01                	test   $0x1,%al
801076eb:	74 f3                	je     801076e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801076f2:	83 ec 0c             	sub    $0xc,%esp
801076f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801076fd:	50                   	push   %eax
801076fe:	e8 6d b0 ff ff       	call   80102770 <kfree>
80107703:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107706:	39 fb                	cmp    %edi,%ebx
80107708:	75 dd                	jne    801076e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010770a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010770d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107710:	5b                   	pop    %ebx
80107711:	5e                   	pop    %esi
80107712:	5f                   	pop    %edi
80107713:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107714:	e9 57 b0 ff ff       	jmp    80102770 <kfree>
    panic("freevm: no pgdir");
80107719:	83 ec 0c             	sub    $0xc,%esp
8010771c:	68 eb 84 10 80       	push   $0x801084eb
80107721:	e8 6a 8c ff ff       	call   80100390 <panic>
80107726:	8d 76 00             	lea    0x0(%esi),%esi
80107729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107730 <setupkvm>:
{
80107730:	55                   	push   %ebp
80107731:	89 e5                	mov    %esp,%ebp
80107733:	56                   	push   %esi
80107734:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107735:	e8 26 b2 ff ff       	call   80102960 <kalloc>
8010773a:	85 c0                	test   %eax,%eax
8010773c:	89 c6                	mov    %eax,%esi
8010773e:	74 42                	je     80107782 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107740:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107743:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107748:	68 00 10 00 00       	push   $0x1000
8010774d:	6a 00                	push   $0x0
8010774f:	50                   	push   %eax
80107750:	e8 8b d6 ff ff       	call   80104de0 <memset>
80107755:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107758:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010775b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010775e:	83 ec 08             	sub    $0x8,%esp
80107761:	8b 13                	mov    (%ebx),%edx
80107763:	ff 73 0c             	pushl  0xc(%ebx)
80107766:	50                   	push   %eax
80107767:	29 c1                	sub    %eax,%ecx
80107769:	89 f0                	mov    %esi,%eax
8010776b:	e8 90 f8 ff ff       	call   80107000 <mappages>
80107770:	83 c4 10             	add    $0x10,%esp
80107773:	85 c0                	test   %eax,%eax
80107775:	78 19                	js     80107790 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107777:	83 c3 10             	add    $0x10,%ebx
8010777a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107780:	75 d6                	jne    80107758 <setupkvm+0x28>
}
80107782:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107785:	89 f0                	mov    %esi,%eax
80107787:	5b                   	pop    %ebx
80107788:	5e                   	pop    %esi
80107789:	5d                   	pop    %ebp
8010778a:	c3                   	ret    
8010778b:	90                   	nop
8010778c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107790:	83 ec 0c             	sub    $0xc,%esp
80107793:	56                   	push   %esi
      return 0;
80107794:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107796:	e8 15 ff ff ff       	call   801076b0 <freevm>
      return 0;
8010779b:	83 c4 10             	add    $0x10,%esp
}
8010779e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077a1:	89 f0                	mov    %esi,%eax
801077a3:	5b                   	pop    %ebx
801077a4:	5e                   	pop    %esi
801077a5:	5d                   	pop    %ebp
801077a6:	c3                   	ret    
801077a7:	89 f6                	mov    %esi,%esi
801077a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077b0 <kvmalloc>:
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077b6:	e8 75 ff ff ff       	call   80107730 <setupkvm>
801077bb:	a3 c4 01 12 80       	mov    %eax,0x801201c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077c0:	05 00 00 00 80       	add    $0x80000000,%eax
801077c5:	0f 22 d8             	mov    %eax,%cr3
}
801077c8:	c9                   	leave  
801077c9:	c3                   	ret    
801077ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801077d0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077d1:	31 c9                	xor    %ecx,%ecx
{
801077d3:	89 e5                	mov    %esp,%ebp
801077d5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801077d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801077db:	8b 45 08             	mov    0x8(%ebp),%eax
801077de:	e8 9d f7 ff ff       	call   80106f80 <walkpgdir>
  if(pte == 0)
801077e3:	85 c0                	test   %eax,%eax
801077e5:	74 05                	je     801077ec <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801077e7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801077ea:	c9                   	leave  
801077eb:	c3                   	ret    
    panic("clearpteu");
801077ec:	83 ec 0c             	sub    $0xc,%esp
801077ef:	68 fc 84 10 80       	push   $0x801084fc
801077f4:	e8 97 8b ff ff       	call   80100390 <panic>
801077f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107800 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	57                   	push   %edi
80107804:	56                   	push   %esi
80107805:	53                   	push   %ebx
80107806:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107809:	e8 22 ff ff ff       	call   80107730 <setupkvm>
8010780e:	85 c0                	test   %eax,%eax
80107810:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107813:	0f 84 b6 00 00 00    	je     801078cf <copyuvm+0xcf>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107819:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010781c:	85 c9                	test   %ecx,%ecx
8010781e:	0f 84 ab 00 00 00    	je     801078cf <copyuvm+0xcf>
80107824:	31 f6                	xor    %esi,%esi
80107826:	eb 69                	jmp    80107891 <copyuvm+0x91>
80107828:	90                   	nop
80107829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      // cprintf("copyuvm PTR_PG\n"); // TODO delete
      pte = walkpgdir(d, (void*) i, 1);
      *pte = PTE_U | PTE_W | PTE_PG;
      continue;
    }
    pa = PTE_ADDR(*pte);
80107830:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107832:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107837:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
8010783d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107840:	e8 1b b1 ff ff       	call   80102960 <kalloc>
80107845:	85 c0                	test   %eax,%eax
80107847:	89 c3                	mov    %eax,%ebx
80107849:	0f 84 9d 00 00 00    	je     801078ec <copyuvm+0xec>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010784f:	83 ec 04             	sub    $0x4,%esp
80107852:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107858:	68 00 10 00 00       	push   $0x1000
8010785d:	57                   	push   %edi
8010785e:	50                   	push   %eax
8010785f:	e8 2c d6 ff ff       	call   80104e90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107864:	58                   	pop    %eax
80107865:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010786b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107870:	5a                   	pop    %edx
80107871:	ff 75 e4             	pushl  -0x1c(%ebp)
80107874:	50                   	push   %eax
80107875:	89 f2                	mov    %esi,%edx
80107877:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010787a:	e8 81 f7 ff ff       	call   80107000 <mappages>
8010787f:	83 c4 10             	add    $0x10,%esp
80107882:	85 c0                	test   %eax,%eax
80107884:	78 5a                	js     801078e0 <copyuvm+0xe0>
  for(i = 0; i < sz; i += PGSIZE){
80107886:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010788c:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010788f:	76 3e                	jbe    801078cf <copyuvm+0xcf>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107891:	8b 45 08             	mov    0x8(%ebp),%eax
80107894:	31 c9                	xor    %ecx,%ecx
80107896:	89 f2                	mov    %esi,%edx
80107898:	e8 e3 f6 ff ff       	call   80106f80 <walkpgdir>
8010789d:	85 c0                	test   %eax,%eax
8010789f:	74 78                	je     80107919 <copyuvm+0x119>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
801078a1:	8b 00                	mov    (%eax),%eax
801078a3:	a9 01 02 00 00       	test   $0x201,%eax
801078a8:	74 62                	je     8010790c <copyuvm+0x10c>
    if (*pte & PTE_PG) {
801078aa:	f6 c4 02             	test   $0x2,%ah
801078ad:	74 81                	je     80107830 <copyuvm+0x30>
      pte = walkpgdir(d, (void*) i, 1);
801078af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078b2:	89 f2                	mov    %esi,%edx
801078b4:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(i = 0; i < sz; i += PGSIZE){
801078b9:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte = walkpgdir(d, (void*) i, 1);
801078bf:	e8 bc f6 ff ff       	call   80106f80 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE){
801078c4:	39 75 0c             	cmp    %esi,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
801078c7:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
801078cd:	77 c2                	ja     80107891 <copyuvm+0x91>
  return d;

bad:
  freevm(d);
  return 0;
}
801078cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078d5:	5b                   	pop    %ebx
801078d6:	5e                   	pop    %esi
801078d7:	5f                   	pop    %edi
801078d8:	5d                   	pop    %ebp
801078d9:	c3                   	ret    
801078da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      kfree(mem);
801078e0:	83 ec 0c             	sub    $0xc,%esp
801078e3:	53                   	push   %ebx
801078e4:	e8 87 ae ff ff       	call   80102770 <kfree>
      goto bad;
801078e9:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801078ec:	83 ec 0c             	sub    $0xc,%esp
801078ef:	ff 75 e0             	pushl  -0x20(%ebp)
801078f2:	e8 b9 fd ff ff       	call   801076b0 <freevm>
  return 0;
801078f7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801078fe:	83 c4 10             	add    $0x10,%esp
}
80107901:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107904:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107907:	5b                   	pop    %ebx
80107908:	5e                   	pop    %esi
80107909:	5f                   	pop    %edi
8010790a:	5d                   	pop    %ebp
8010790b:	c3                   	ret    
      panic("copyuvm: page not present");
8010790c:	83 ec 0c             	sub    $0xc,%esp
8010790f:	68 20 85 10 80       	push   $0x80108520
80107914:	e8 77 8a ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107919:	83 ec 0c             	sub    $0xc,%esp
8010791c:	68 06 85 10 80       	push   $0x80108506
80107921:	e8 6a 8a ff ff       	call   80100390 <panic>
80107926:	8d 76 00             	lea    0x0(%esi),%esi
80107929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107930 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107930:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107931:	31 c9                	xor    %ecx,%ecx
{
80107933:	89 e5                	mov    %esp,%ebp
80107935:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107938:	8b 55 0c             	mov    0xc(%ebp),%edx
8010793b:	8b 45 08             	mov    0x8(%ebp),%eax
8010793e:	e8 3d f6 ff ff       	call   80106f80 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107943:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107945:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107946:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107948:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010794d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107950:	05 00 00 00 80       	add    $0x80000000,%eax
80107955:	83 fa 05             	cmp    $0x5,%edx
80107958:	ba 00 00 00 00       	mov    $0x0,%edx
8010795d:	0f 45 c2             	cmovne %edx,%eax
}
80107960:	c3                   	ret    
80107961:	eb 0d                	jmp    80107970 <copyout>
80107963:	90                   	nop
80107964:	90                   	nop
80107965:	90                   	nop
80107966:	90                   	nop
80107967:	90                   	nop
80107968:	90                   	nop
80107969:	90                   	nop
8010796a:	90                   	nop
8010796b:	90                   	nop
8010796c:	90                   	nop
8010796d:	90                   	nop
8010796e:	90                   	nop
8010796f:	90                   	nop

80107970 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107970:	55                   	push   %ebp
80107971:	89 e5                	mov    %esp,%ebp
80107973:	57                   	push   %edi
80107974:	56                   	push   %esi
80107975:	53                   	push   %ebx
80107976:	83 ec 1c             	sub    $0x1c,%esp
80107979:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010797c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010797f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107982:	85 db                	test   %ebx,%ebx
80107984:	75 40                	jne    801079c6 <copyout+0x56>
80107986:	eb 70                	jmp    801079f8 <copyout+0x88>
80107988:	90                   	nop
80107989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107990:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107993:	89 f1                	mov    %esi,%ecx
80107995:	29 d1                	sub    %edx,%ecx
80107997:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010799d:	39 d9                	cmp    %ebx,%ecx
8010799f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801079a2:	29 f2                	sub    %esi,%edx
801079a4:	83 ec 04             	sub    $0x4,%esp
801079a7:	01 d0                	add    %edx,%eax
801079a9:	51                   	push   %ecx
801079aa:	57                   	push   %edi
801079ab:	50                   	push   %eax
801079ac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801079af:	e8 dc d4 ff ff       	call   80104e90 <memmove>
    len -= n;
    buf += n;
801079b4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801079b7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801079ba:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801079c0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801079c2:	29 cb                	sub    %ecx,%ebx
801079c4:	74 32                	je     801079f8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801079c6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801079c8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801079cb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801079ce:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801079d4:	56                   	push   %esi
801079d5:	ff 75 08             	pushl  0x8(%ebp)
801079d8:	e8 53 ff ff ff       	call   80107930 <uva2ka>
    if(pa0 == 0)
801079dd:	83 c4 10             	add    $0x10,%esp
801079e0:	85 c0                	test   %eax,%eax
801079e2:	75 ac                	jne    80107990 <copyout+0x20>
  }
  return 0;
}
801079e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079ec:	5b                   	pop    %ebx
801079ed:	5e                   	pop    %esi
801079ee:	5f                   	pop    %edi
801079ef:	5d                   	pop    %ebp
801079f0:	c3                   	ret    
801079f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079fb:	31 c0                	xor    %eax,%eax
}
801079fd:	5b                   	pop    %ebx
801079fe:	5e                   	pop    %esi
801079ff:	5f                   	pop    %edi
80107a00:	5d                   	pop    %ebp
80107a01:	c3                   	ret    
