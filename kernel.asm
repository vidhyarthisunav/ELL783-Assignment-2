
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 32 10 80       	mov    $0x80103230,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 74 10 80       	push   $0x801074c0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 75 47 00 00       	call   801047d0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
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
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 74 10 80       	push   $0x801074c7
80100097:	50                   	push   %eax
80100098:	e8 03 46 00 00       	call   801046a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
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
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 27 48 00 00       	call   80104910 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 69 48 00 00       	call   801049d0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 45 00 00       	call   801046e0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 2d 23 00 00       	call   801024b0 <iderw>
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
80100193:	68 ce 74 10 80       	push   $0x801074ce
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
801001ae:	e8 cd 45 00 00       	call   80104780 <holdingsleep>
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
801001c4:	e9 e7 22 00 00       	jmp    801024b0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 74 10 80       	push   $0x801074df
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
801001ef:	e8 8c 45 00 00       	call   80104780 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 45 00 00       	call   80104740 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 00 47 00 00       	call   80104910 <acquire>
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
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 6f 47 00 00       	jmp    801049d0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 74 10 80       	push   $0x801074e6
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
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 7f 46 00 00       	call   80104910 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
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
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 66 40 00 00       	call   80104330 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 20 39 00 00       	call   80103c00 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 dc 46 00 00       	call   801049d0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
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
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
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
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 7e 46 00 00       	call   801049d0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
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
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
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
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 12 27 00 00       	call   80102ac0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 74 10 80       	push   $0x801074ed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 93 7e 10 80 	movl   $0x80107e93,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 13 44 00 00       	call   801047f0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 75 10 80       	push   $0x80107501
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
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
8010043a:	e8 91 5c 00 00       	call   801060d0 <uartputc>
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
801004ec:	e8 df 5b 00 00       	call   801060d0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 d3 5b 00 00       	call   801060d0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 c7 5b 00 00       	call   801060d0 <uartputc>
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
80100524:	e8 a7 45 00 00       	call   80104ad0 <memmove>
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
80100541:	e8 da 44 00 00       	call   80104a20 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 75 10 80       	push   $0x80107505
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
801005b1:	0f b6 92 30 75 10 80 	movzbl -0x7fef8ad0(%edx),%edx
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
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 f0 42 00 00       	call   80104910 <acquire>
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
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 84 43 00 00       	call   801049d0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

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
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
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
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 ac 42 00 00       	call   801049d0 <release>
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
801007d0:	ba 18 75 10 80       	mov    $0x80107518,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 1b 41 00 00       	call   80104910 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 75 10 80       	push   $0x8010751f
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
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 e8 40 00 00       	call   80104910 <acquire>
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
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
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
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 43 41 00 00       	call   801049d0 <release>
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
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 d5 3b 00 00       	call   801044f0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
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
80100997:	e9 34 3c 00 00       	jmp    801045d0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
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
801009c6:	68 28 75 10 80       	push   $0x80107528
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 fb 3d 00 00       	call   801047d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 62 1c 00 00       	call   80102660 <ioapicenable>
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
80100a1c:	e8 df 31 00 00       	call   80103c00 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 04 25 00 00       	call   80102f30 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 2c 25 00 00       	call   80102fa0 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 87 67 00 00       	call   80107220 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 45 65 00 00       	call   80107040 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 53 64 00 00       	call   80106f80 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 29 66 00 00       	call   801071a0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 01 24 00 00       	call   80102fa0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 91 64 00 00       	call   80107040 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 da 65 00 00       	call   801071a0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 c8 23 00 00       	call   80102fa0 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 41 75 10 80       	push   $0x80107541
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 b5 66 00 00       	call   801072c0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 02 40 00 00       	call   80104c40 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 ef 3f 00 00       	call   80104c40 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 be 67 00 00       	call   80107420 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 54 67 00 00       	call   80107420 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 f1 3e 00 00       	call   80104c00 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 b7 60 00 00       	call   80106df0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 5f 64 00 00       	call   801071a0 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 4d 75 10 80       	push   $0x8010754d
80100d6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d70:	e8 5b 3a 00 00       	call   801047d0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d91:	e8 7a 3b 00 00       	call   80104910 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc1:	e8 0a 3c 00 00       	call   801049d0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dda:	e8 f1 3b 00 00       	call   801049d0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dff:	e8 0c 3b 00 00       	call   80104910 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1c:	e8 af 3b 00 00       	call   801049d0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 54 75 10 80       	push   $0x80107554
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 ba 3a 00 00       	call   80104910 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 4f 3b 00 00       	jmp    801049d0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 23 3b 00 00       	call   801049d0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 0a 28 00 00       	call   801036e0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 4b 20 00 00       	call   80102f30 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 a1 20 00 00       	jmp    80102fa0 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 5c 75 10 80       	push   $0x8010755c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 be 28 00 00       	jmp    80103890 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 66 75 10 80       	push   $0x80107566
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 52 1f 00 00       	call   80102fa0 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 b5 1e 00 00       	call   80102f30 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 ee 1e 00 00       	call   80102fa0 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 8e 26 00 00       	jmp    80103780 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 6f 75 10 80       	push   $0x8010756f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 75 75 10 80       	push   $0x80107575
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 a2 1f 00 00       	call   80103100 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 7f 75 10 80       	push   $0x8010757f
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 92 75 10 80       	push   $0x80107592
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 be 1e 00 00       	call   80103100 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 b6 37 00 00       	call   80104a20 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 8e 1e 00 00       	call   80103100 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 e0 09 11 80       	push   $0x801109e0
801012aa:	e8 61 36 00 00       	call   80104910 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 e0 09 11 80       	push   $0x801109e0
8010130f:	e8 bc 36 00 00       	call   801049d0 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 8e 36 00 00       	call   801049d0 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 a8 75 10 80       	push   $0x801075a8
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 2d 1d 00 00       	call   80103100 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 b8 75 10 80       	push   $0x801075b8
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 6a 36 00 00       	call   80104ad0 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 cb 75 10 80       	push   $0x801075cb
80101491:	68 e0 09 11 80       	push   $0x801109e0
80101496:	e8 35 33 00 00       	call   801047d0 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 d2 75 10 80       	push   $0x801075d2
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 ec 31 00 00       	call   801046a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 c0 09 11 80       	push   $0x801109c0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014d5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014db:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014e1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014e7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014ed:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014f3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014f9:	68 7c 76 10 80       	push   $0x8010767c
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 8d 34 00 00       	call   80104a20 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 5b 1b 00 00       	call   80103100 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 d8 75 10 80       	push   $0x801075d8
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 9a 34 00 00       	call   80104ad0 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 c2 1a 00 00       	call   80103100 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 e0 09 11 80       	push   $0x801109e0
8010165f:	e8 ac 32 00 00       	call   80104910 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010166f:	e8 5c 33 00 00       	call   801049d0 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 39 30 00 00       	call   801046e0 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 b3 33 00 00       	call   80104ad0 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 f0 75 10 80       	push   $0x801075f0
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 ea 75 10 80       	push   $0x801075ea
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 08 30 00 00       	call   80104780 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 ac 2f 00 00       	jmp    80104740 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 ff 75 10 80       	push   $0x801075ff
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 1b 2f 00 00       	call   801046e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 61 2f 00 00       	call   80104740 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017e6:	e8 25 31 00 00       	call   80104910 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 cb 31 00 00       	jmp    801049d0 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 e0 09 11 80       	push   $0x801109e0
80101810:	e8 fb 30 00 00       	call   80104910 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010181f:	e8 ac 31 00 00       	call   801049d0 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 c4 30 00 00       	call   80104ad0 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 c8 2f 00 00       	call   80104ad0 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 f0 15 00 00       	call   80103100 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 9d 2f 00 00       	call   80104b40 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 3e 2f 00 00       	call   80104b40 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 19 76 10 80       	push   $0x80107619
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 07 76 10 80       	push   $0x80107607
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 82 1f 00 00       	call   80103c00 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 e0 09 11 80       	push   $0x801109e0
80101c89:	e8 82 2c 00 00       	call   80104910 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c99:	e8 32 2d 00 00       	call   801049d0 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 d6 2d 00 00       	call   80104ad0 <memmove>
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 43 2d 00 00       	call   80104ad0 <memmove>
    name[len] = 0;
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
      return 0;
80101dd3:	83 c4 10             	add    $0x10,%esp
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlock(ip);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dff:	83 c4 10             	add    $0x10,%esp
}
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    iput(ip);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
    return 0;
80101e10:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 1e 2d 00 00       	call   80104ba0 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 28 76 10 80       	push   $0x80107628
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 ad 7c 10 80       	push   $0x80107cad
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f20 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f20:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101f21:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80101f26:	89 e5                	mov    %esp,%ebp
80101f28:	57                   	push   %edi
80101f29:	56                   	push   %esi
80101f2a:	53                   	push   %ebx
80101f2b:	83 ec 10             	sub    $0x10,%esp
80101f2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101f31:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101f38:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101f3f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101f43:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101f47:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101f4a:	85 c9                	test   %ecx,%ecx
80101f4c:	79 0a                	jns    80101f58 <itoa+0x38>
80101f4e:	89 f0                	mov    %esi,%eax
80101f50:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80101f53:	f7 d9                	neg    %ecx
        *p++ = '-';
80101f55:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80101f58:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101f5a:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101f5f:	90                   	nop
80101f60:	89 d8                	mov    %ebx,%eax
80101f62:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80101f65:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101f68:	f7 ef                	imul   %edi
80101f6a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101f6d:	29 da                	sub    %ebx,%edx
80101f6f:	89 d3                	mov    %edx,%ebx
80101f71:	75 ed                	jne    80101f60 <itoa+0x40>
    *p = '\0';
80101f73:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f76:	bb 67 66 66 66       	mov    $0x66666667,%ebx
80101f7b:	90                   	nop
80101f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f80:	89 c8                	mov    %ecx,%eax
80101f82:	83 ee 01             	sub    $0x1,%esi
80101f85:	f7 eb                	imul   %ebx
80101f87:	89 c8                	mov    %ecx,%eax
80101f89:	c1 f8 1f             	sar    $0x1f,%eax
80101f8c:	c1 fa 02             	sar    $0x2,%edx
80101f8f:	29 c2                	sub    %eax,%edx
80101f91:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101f94:	01 c0                	add    %eax,%eax
80101f96:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80101f98:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
80101f9a:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80101f9f:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80101fa1:	88 06                	mov    %al,(%esi)
    }while(i);
80101fa3:	75 db                	jne    80101f80 <itoa+0x60>
    return b;
}
80101fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	5b                   	pop    %ebx
80101fac:	5e                   	pop    %esi
80101fad:	5f                   	pop    %edi
80101fae:	5d                   	pop    %ebp
80101faf:	c3                   	ret    

80101fb0 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101fb0:	55                   	push   %ebp
80101fb1:	89 e5                	mov    %esp,%ebp
80101fb3:	57                   	push   %edi
80101fb4:	56                   	push   %esi
80101fb5:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101fb6:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80101fb9:	83 ec 40             	sub    $0x40,%esp
80101fbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80101fbf:	6a 06                	push   $0x6
80101fc1:	68 35 76 10 80       	push   $0x80107635
80101fc6:	56                   	push   %esi
80101fc7:	e8 04 2b 00 00       	call   80104ad0 <memmove>
  itoa(p->pid, path+ 6);
80101fcc:	58                   	pop    %eax
80101fcd:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80101fd0:	5a                   	pop    %edx
80101fd1:	50                   	push   %eax
80101fd2:	ff 73 10             	pushl  0x10(%ebx)
80101fd5:	e8 46 ff ff ff       	call   80101f20 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
80101fda:	8b 43 7c             	mov    0x7c(%ebx),%eax
80101fdd:	83 c4 10             	add    $0x10,%esp
80101fe0:	85 c0                	test   %eax,%eax
80101fe2:	0f 84 88 01 00 00    	je     80102170 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80101fe8:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
80101feb:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
80101fee:	50                   	push   %eax
80101fef:	e8 4c ee ff ff       	call   80100e40 <fileclose>

  begin_op();
80101ff4:	e8 37 0f 00 00       	call   80102f30 <begin_op>
  return namex(path, 1, name);
80101ff9:	89 f0                	mov    %esi,%eax
80101ffb:	89 d9                	mov    %ebx,%ecx
80101ffd:	ba 01 00 00 00       	mov    $0x1,%edx
80102002:	e8 59 fc ff ff       	call   80101c60 <namex>
  if((dp = nameiparent(path, name)) == 0)
80102007:	83 c4 10             	add    $0x10,%esp
8010200a:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
8010200c:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
8010200e:	0f 84 66 01 00 00    	je     8010217a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102014:	83 ec 0c             	sub    $0xc,%esp
80102017:	50                   	push   %eax
80102018:	e8 63 f6 ff ff       	call   80101680 <ilock>
  return strncmp(s, t, DIRSIZ);
8010201d:	83 c4 0c             	add    $0xc,%esp
80102020:	6a 0e                	push   $0xe
80102022:	68 3d 76 10 80       	push   $0x8010763d
80102027:	53                   	push   %ebx
80102028:	e8 13 2b 00 00       	call   80104b40 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010202d:	83 c4 10             	add    $0x10,%esp
80102030:	85 c0                	test   %eax,%eax
80102032:	0f 84 f8 00 00 00    	je     80102130 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102038:	83 ec 04             	sub    $0x4,%esp
8010203b:	6a 0e                	push   $0xe
8010203d:	68 3c 76 10 80       	push   $0x8010763c
80102042:	53                   	push   %ebx
80102043:	e8 f8 2a 00 00       	call   80104b40 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102048:	83 c4 10             	add    $0x10,%esp
8010204b:	85 c0                	test   %eax,%eax
8010204d:	0f 84 dd 00 00 00    	je     80102130 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102053:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102056:	83 ec 04             	sub    $0x4,%esp
80102059:	50                   	push   %eax
8010205a:	53                   	push   %ebx
8010205b:	56                   	push   %esi
8010205c:	e8 4f fb ff ff       	call   80101bb0 <dirlookup>
80102061:	83 c4 10             	add    $0x10,%esp
80102064:	85 c0                	test   %eax,%eax
80102066:	89 c3                	mov    %eax,%ebx
80102068:	0f 84 c2 00 00 00    	je     80102130 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010206e:	83 ec 0c             	sub    $0xc,%esp
80102071:	50                   	push   %eax
80102072:	e8 09 f6 ff ff       	call   80101680 <ilock>

  if(ip->nlink < 1)
80102077:	83 c4 10             	add    $0x10,%esp
8010207a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010207f:	0f 8e 11 01 00 00    	jle    80102196 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102085:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010208a:	74 74                	je     80102100 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010208c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010208f:	83 ec 04             	sub    $0x4,%esp
80102092:	6a 10                	push   $0x10
80102094:	6a 00                	push   $0x0
80102096:	57                   	push   %edi
80102097:	e8 84 29 00 00       	call   80104a20 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010209c:	6a 10                	push   $0x10
8010209e:	ff 75 b8             	pushl  -0x48(%ebp)
801020a1:	57                   	push   %edi
801020a2:	56                   	push   %esi
801020a3:	e8 b8 f9 ff ff       	call   80101a60 <writei>
801020a8:	83 c4 20             	add    $0x20,%esp
801020ab:	83 f8 10             	cmp    $0x10,%eax
801020ae:	0f 85 d5 00 00 00    	jne    80102189 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801020b4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020b9:	0f 84 91 00 00 00    	je     80102150 <removeSwapFile+0x1a0>
  iunlock(ip);
801020bf:	83 ec 0c             	sub    $0xc,%esp
801020c2:	56                   	push   %esi
801020c3:	e8 98 f6 ff ff       	call   80101760 <iunlock>
  iput(ip);
801020c8:	89 34 24             	mov    %esi,(%esp)
801020cb:	e8 e0 f6 ff ff       	call   801017b0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801020d0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801020d5:	89 1c 24             	mov    %ebx,(%esp)
801020d8:	e8 f3 f4 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
801020dd:	89 1c 24             	mov    %ebx,(%esp)
801020e0:	e8 7b f6 ff ff       	call   80101760 <iunlock>
  iput(ip);
801020e5:	89 1c 24             	mov    %ebx,(%esp)
801020e8:	e8 c3 f6 ff ff       	call   801017b0 <iput>
  iunlockput(ip);

  end_op();
801020ed:	e8 ae 0e 00 00       	call   80102fa0 <end_op>

  return 0;
801020f2:	83 c4 10             	add    $0x10,%esp
801020f5:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801020f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fa:	5b                   	pop    %ebx
801020fb:	5e                   	pop    %esi
801020fc:	5f                   	pop    %edi
801020fd:	5d                   	pop    %ebp
801020fe:	c3                   	ret    
801020ff:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102100:	83 ec 0c             	sub    $0xc,%esp
80102103:	53                   	push   %ebx
80102104:	e8 f7 30 00 00       	call   80105200 <isdirempty>
80102109:	83 c4 10             	add    $0x10,%esp
8010210c:	85 c0                	test   %eax,%eax
8010210e:	0f 85 78 ff ff ff    	jne    8010208c <removeSwapFile+0xdc>
  iunlock(ip);
80102114:	83 ec 0c             	sub    $0xc,%esp
80102117:	53                   	push   %ebx
80102118:	e8 43 f6 ff ff       	call   80101760 <iunlock>
  iput(ip);
8010211d:	89 1c 24             	mov    %ebx,(%esp)
80102120:	e8 8b f6 ff ff       	call   801017b0 <iput>
80102125:	83 c4 10             	add    $0x10,%esp
80102128:	90                   	nop
80102129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102130:	83 ec 0c             	sub    $0xc,%esp
80102133:	56                   	push   %esi
80102134:	e8 27 f6 ff ff       	call   80101760 <iunlock>
  iput(ip);
80102139:	89 34 24             	mov    %esi,(%esp)
8010213c:	e8 6f f6 ff ff       	call   801017b0 <iput>
    end_op();
80102141:	e8 5a 0e 00 00       	call   80102fa0 <end_op>
    return -1;
80102146:	83 c4 10             	add    $0x10,%esp
80102149:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010214e:	eb a7                	jmp    801020f7 <removeSwapFile+0x147>
    dp->nlink--;
80102150:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102155:	83 ec 0c             	sub    $0xc,%esp
80102158:	56                   	push   %esi
80102159:	e8 72 f4 ff ff       	call   801015d0 <iupdate>
8010215e:	83 c4 10             	add    $0x10,%esp
80102161:	e9 59 ff ff ff       	jmp    801020bf <removeSwapFile+0x10f>
80102166:	8d 76 00             	lea    0x0(%esi),%esi
80102169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102175:	e9 7d ff ff ff       	jmp    801020f7 <removeSwapFile+0x147>
    end_op();
8010217a:	e8 21 0e 00 00       	call   80102fa0 <end_op>
    return -1;
8010217f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102184:	e9 6e ff ff ff       	jmp    801020f7 <removeSwapFile+0x147>
    panic("unlink: writei");
80102189:	83 ec 0c             	sub    $0xc,%esp
8010218c:	68 51 76 10 80       	push   $0x80107651
80102191:	e8 fa e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102196:	83 ec 0c             	sub    $0xc,%esp
80102199:	68 3f 76 10 80       	push   $0x8010763f
8010219e:	e8 ed e1 ff ff       	call   80100390 <panic>
801021a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021b0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801021b0:	55                   	push   %ebp
801021b1:	89 e5                	mov    %esp,%ebp
801021b3:	56                   	push   %esi
801021b4:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
801021b5:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
801021b8:	83 ec 14             	sub    $0x14,%esp
801021bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801021be:	6a 06                	push   $0x6
801021c0:	68 35 76 10 80       	push   $0x80107635
801021c5:	56                   	push   %esi
801021c6:	e8 05 29 00 00       	call   80104ad0 <memmove>
  itoa(p->pid, path+ 6);
801021cb:	58                   	pop    %eax
801021cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801021cf:	5a                   	pop    %edx
801021d0:	50                   	push   %eax
801021d1:	ff 73 10             	pushl  0x10(%ebx)
801021d4:	e8 47 fd ff ff       	call   80101f20 <itoa>

    begin_op();
801021d9:	e8 52 0d 00 00       	call   80102f30 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
801021de:	6a 00                	push   $0x0
801021e0:	6a 00                	push   $0x0
801021e2:	6a 02                	push   $0x2
801021e4:	56                   	push   %esi
801021e5:	e8 26 32 00 00       	call   80105410 <create>
  iunlock(in);
801021ea:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
801021ed:	89 c6                	mov    %eax,%esi
  iunlock(in);
801021ef:	50                   	push   %eax
801021f0:	e8 6b f5 ff ff       	call   80101760 <iunlock>

  p->swapFile = filealloc();
801021f5:	e8 86 eb ff ff       	call   80100d80 <filealloc>
  if (p->swapFile == 0)
801021fa:	83 c4 10             	add    $0x10,%esp
801021fd:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
801021ff:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102202:	74 32                	je     80102236 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102204:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
80102207:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010220a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102210:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102213:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010221a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010221d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102221:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102224:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102228:	e8 73 0d 00 00       	call   80102fa0 <end_op>

    return 0;
}
8010222d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102230:	31 c0                	xor    %eax,%eax
80102232:	5b                   	pop    %ebx
80102233:	5e                   	pop    %esi
80102234:	5d                   	pop    %ebp
80102235:	c3                   	ret    
    panic("no slot for files on /store");
80102236:	83 ec 0c             	sub    $0xc,%esp
80102239:	68 60 76 10 80       	push   $0x80107660
8010223e:	e8 4d e1 ff ff       	call   80100390 <panic>
80102243:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102250 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102256:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102259:	8b 50 7c             	mov    0x7c(%eax),%edx
8010225c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010225f:	8b 55 14             	mov    0x14(%ebp),%edx
80102262:	89 55 10             	mov    %edx,0x10(%ebp)
80102265:	8b 40 7c             	mov    0x7c(%eax),%eax
80102268:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010226b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010226c:	e9 7f ed ff ff       	jmp    80100ff0 <filewrite>
80102271:	eb 0d                	jmp    80102280 <readFromSwapFile>
80102273:	90                   	nop
80102274:	90                   	nop
80102275:	90                   	nop
80102276:	90                   	nop
80102277:	90                   	nop
80102278:	90                   	nop
80102279:	90                   	nop
8010227a:	90                   	nop
8010227b:	90                   	nop
8010227c:	90                   	nop
8010227d:	90                   	nop
8010227e:	90                   	nop
8010227f:	90                   	nop

80102280 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102280:	55                   	push   %ebp
80102281:	89 e5                	mov    %esp,%ebp
80102283:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102286:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102289:	8b 50 7c             	mov    0x7c(%eax),%edx
8010228c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010228f:	8b 55 14             	mov    0x14(%ebp),%edx
80102292:	89 55 10             	mov    %edx,0x10(%ebp)
80102295:	8b 40 7c             	mov    0x7c(%eax),%eax
80102298:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010229b:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
8010229c:	e9 bf ec ff ff       	jmp    80100f60 <fileread>
801022a1:	66 90                	xchg   %ax,%ax
801022a3:	66 90                	xchg   %ax,%ax
801022a5:	66 90                	xchg   %ax,%ax
801022a7:	66 90                	xchg   %ax,%ax
801022a9:	66 90                	xchg   %ax,%ax
801022ab:	66 90                	xchg   %ax,%ax
801022ad:	66 90                	xchg   %ax,%ax
801022af:	90                   	nop

801022b0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	57                   	push   %edi
801022b4:	56                   	push   %esi
801022b5:	53                   	push   %ebx
801022b6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801022b9:	85 c0                	test   %eax,%eax
801022bb:	0f 84 b4 00 00 00    	je     80102375 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022c1:	8b 58 08             	mov    0x8(%eax),%ebx
801022c4:	89 c6                	mov    %eax,%esi
801022c6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801022cc:	0f 87 96 00 00 00    	ja     80102368 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022d2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801022d7:	89 f6                	mov    %esi,%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801022e0:	89 ca                	mov    %ecx,%edx
801022e2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022e3:	83 e0 c0             	and    $0xffffffc0,%eax
801022e6:	3c 40                	cmp    $0x40,%al
801022e8:	75 f6                	jne    801022e0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022ea:	31 ff                	xor    %edi,%edi
801022ec:	ba f6 03 00 00       	mov    $0x3f6,%edx
801022f1:	89 f8                	mov    %edi,%eax
801022f3:	ee                   	out    %al,(%dx)
801022f4:	b8 01 00 00 00       	mov    $0x1,%eax
801022f9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801022fe:	ee                   	out    %al,(%dx)
801022ff:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102304:	89 d8                	mov    %ebx,%eax
80102306:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102307:	89 d8                	mov    %ebx,%eax
80102309:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010230e:	c1 f8 08             	sar    $0x8,%eax
80102311:	ee                   	out    %al,(%dx)
80102312:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102317:	89 f8                	mov    %edi,%eax
80102319:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010231a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010231e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102323:	c1 e0 04             	shl    $0x4,%eax
80102326:	83 e0 10             	and    $0x10,%eax
80102329:	83 c8 e0             	or     $0xffffffe0,%eax
8010232c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010232d:	f6 06 04             	testb  $0x4,(%esi)
80102330:	75 16                	jne    80102348 <idestart+0x98>
80102332:	b8 20 00 00 00       	mov    $0x20,%eax
80102337:	89 ca                	mov    %ecx,%edx
80102339:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010233a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010233d:	5b                   	pop    %ebx
8010233e:	5e                   	pop    %esi
8010233f:	5f                   	pop    %edi
80102340:	5d                   	pop    %ebp
80102341:	c3                   	ret    
80102342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102348:	b8 30 00 00 00       	mov    $0x30,%eax
8010234d:	89 ca                	mov    %ecx,%edx
8010234f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102350:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102355:	83 c6 5c             	add    $0x5c,%esi
80102358:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010235d:	fc                   	cld    
8010235e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102363:	5b                   	pop    %ebx
80102364:	5e                   	pop    %esi
80102365:	5f                   	pop    %edi
80102366:	5d                   	pop    %ebp
80102367:	c3                   	ret    
    panic("incorrect blockno");
80102368:	83 ec 0c             	sub    $0xc,%esp
8010236b:	68 d8 76 10 80       	push   $0x801076d8
80102370:	e8 1b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
80102375:	83 ec 0c             	sub    $0xc,%esp
80102378:	68 cf 76 10 80       	push   $0x801076cf
8010237d:	e8 0e e0 ff ff       	call   80100390 <panic>
80102382:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102390 <ideinit>:
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102396:	68 ea 76 10 80       	push   $0x801076ea
8010239b:	68 80 a5 10 80       	push   $0x8010a580
801023a0:	e8 2b 24 00 00       	call   801047d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023a5:	58                   	pop    %eax
801023a6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801023ab:	5a                   	pop    %edx
801023ac:	83 e8 01             	sub    $0x1,%eax
801023af:	50                   	push   %eax
801023b0:	6a 0e                	push   $0xe
801023b2:	e8 a9 02 00 00       	call   80102660 <ioapicenable>
801023b7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023ba:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023bf:	90                   	nop
801023c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023c1:	83 e0 c0             	and    $0xffffffc0,%eax
801023c4:	3c 40                	cmp    $0x40,%al
801023c6:	75 f8                	jne    801023c0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023c8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023cd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023d2:	ee                   	out    %al,(%dx)
801023d3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023d8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023dd:	eb 06                	jmp    801023e5 <ideinit+0x55>
801023df:	90                   	nop
  for(i=0; i<1000; i++){
801023e0:	83 e9 01             	sub    $0x1,%ecx
801023e3:	74 0f                	je     801023f4 <ideinit+0x64>
801023e5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023e6:	84 c0                	test   %al,%al
801023e8:	74 f6                	je     801023e0 <ideinit+0x50>
      havedisk1 = 1;
801023ea:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801023f1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023f4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801023f9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023fe:	ee                   	out    %al,(%dx)
}
801023ff:	c9                   	leave  
80102400:	c3                   	ret    
80102401:	eb 0d                	jmp    80102410 <ideintr>
80102403:	90                   	nop
80102404:	90                   	nop
80102405:	90                   	nop
80102406:	90                   	nop
80102407:	90                   	nop
80102408:	90                   	nop
80102409:	90                   	nop
8010240a:	90                   	nop
8010240b:	90                   	nop
8010240c:	90                   	nop
8010240d:	90                   	nop
8010240e:	90                   	nop
8010240f:	90                   	nop

80102410 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	57                   	push   %edi
80102414:	56                   	push   %esi
80102415:	53                   	push   %ebx
80102416:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102419:	68 80 a5 10 80       	push   $0x8010a580
8010241e:	e8 ed 24 00 00       	call   80104910 <acquire>

  if((b = idequeue) == 0){
80102423:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102429:	83 c4 10             	add    $0x10,%esp
8010242c:	85 db                	test   %ebx,%ebx
8010242e:	74 67                	je     80102497 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102430:	8b 43 58             	mov    0x58(%ebx),%eax
80102433:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102438:	8b 3b                	mov    (%ebx),%edi
8010243a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102440:	75 31                	jne    80102473 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102442:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102447:	89 f6                	mov    %esi,%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102450:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102451:	89 c6                	mov    %eax,%esi
80102453:	83 e6 c0             	and    $0xffffffc0,%esi
80102456:	89 f1                	mov    %esi,%ecx
80102458:	80 f9 40             	cmp    $0x40,%cl
8010245b:	75 f3                	jne    80102450 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010245d:	a8 21                	test   $0x21,%al
8010245f:	75 12                	jne    80102473 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102461:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102464:	b9 80 00 00 00       	mov    $0x80,%ecx
80102469:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010246e:	fc                   	cld    
8010246f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102471:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102473:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102476:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102479:	89 f9                	mov    %edi,%ecx
8010247b:	83 c9 02             	or     $0x2,%ecx
8010247e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102480:	53                   	push   %ebx
80102481:	e8 6a 20 00 00       	call   801044f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102486:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010248b:	83 c4 10             	add    $0x10,%esp
8010248e:	85 c0                	test   %eax,%eax
80102490:	74 05                	je     80102497 <ideintr+0x87>
    idestart(idequeue);
80102492:	e8 19 fe ff ff       	call   801022b0 <idestart>
    release(&idelock);
80102497:	83 ec 0c             	sub    $0xc,%esp
8010249a:	68 80 a5 10 80       	push   $0x8010a580
8010249f:	e8 2c 25 00 00       	call   801049d0 <release>

  release(&idelock);
}
801024a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024a7:	5b                   	pop    %ebx
801024a8:	5e                   	pop    %esi
801024a9:	5f                   	pop    %edi
801024aa:	5d                   	pop    %ebp
801024ab:	c3                   	ret    
801024ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024b0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	53                   	push   %ebx
801024b4:	83 ec 10             	sub    $0x10,%esp
801024b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801024ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801024bd:	50                   	push   %eax
801024be:	e8 bd 22 00 00       	call   80104780 <holdingsleep>
801024c3:	83 c4 10             	add    $0x10,%esp
801024c6:	85 c0                	test   %eax,%eax
801024c8:	0f 84 c6 00 00 00    	je     80102594 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024ce:	8b 03                	mov    (%ebx),%eax
801024d0:	83 e0 06             	and    $0x6,%eax
801024d3:	83 f8 02             	cmp    $0x2,%eax
801024d6:	0f 84 ab 00 00 00    	je     80102587 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024dc:	8b 53 04             	mov    0x4(%ebx),%edx
801024df:	85 d2                	test   %edx,%edx
801024e1:	74 0d                	je     801024f0 <iderw+0x40>
801024e3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801024e8:	85 c0                	test   %eax,%eax
801024ea:	0f 84 b1 00 00 00    	je     801025a1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801024f0:	83 ec 0c             	sub    $0xc,%esp
801024f3:	68 80 a5 10 80       	push   $0x8010a580
801024f8:	e8 13 24 00 00       	call   80104910 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024fd:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102503:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102506:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010250d:	85 d2                	test   %edx,%edx
8010250f:	75 09                	jne    8010251a <iderw+0x6a>
80102511:	eb 6d                	jmp    80102580 <iderw+0xd0>
80102513:	90                   	nop
80102514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102518:	89 c2                	mov    %eax,%edx
8010251a:	8b 42 58             	mov    0x58(%edx),%eax
8010251d:	85 c0                	test   %eax,%eax
8010251f:	75 f7                	jne    80102518 <iderw+0x68>
80102521:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102524:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102526:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010252c:	74 42                	je     80102570 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010252e:	8b 03                	mov    (%ebx),%eax
80102530:	83 e0 06             	and    $0x6,%eax
80102533:	83 f8 02             	cmp    $0x2,%eax
80102536:	74 23                	je     8010255b <iderw+0xab>
80102538:	90                   	nop
80102539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102540:	83 ec 08             	sub    $0x8,%esp
80102543:	68 80 a5 10 80       	push   $0x8010a580
80102548:	53                   	push   %ebx
80102549:	e8 e2 1d 00 00       	call   80104330 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010254e:	8b 03                	mov    (%ebx),%eax
80102550:	83 c4 10             	add    $0x10,%esp
80102553:	83 e0 06             	and    $0x6,%eax
80102556:	83 f8 02             	cmp    $0x2,%eax
80102559:	75 e5                	jne    80102540 <iderw+0x90>
  }


  release(&idelock);
8010255b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102565:	c9                   	leave  
  release(&idelock);
80102566:	e9 65 24 00 00       	jmp    801049d0 <release>
8010256b:	90                   	nop
8010256c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102570:	89 d8                	mov    %ebx,%eax
80102572:	e8 39 fd ff ff       	call   801022b0 <idestart>
80102577:	eb b5                	jmp    8010252e <iderw+0x7e>
80102579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102580:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102585:	eb 9d                	jmp    80102524 <iderw+0x74>
    panic("iderw: nothing to do");
80102587:	83 ec 0c             	sub    $0xc,%esp
8010258a:	68 04 77 10 80       	push   $0x80107704
8010258f:	e8 fc dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102594:	83 ec 0c             	sub    $0xc,%esp
80102597:	68 ee 76 10 80       	push   $0x801076ee
8010259c:	e8 ef dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801025a1:	83 ec 0c             	sub    $0xc,%esp
801025a4:	68 19 77 10 80       	push   $0x80107719
801025a9:	e8 e2 dd ff ff       	call   80100390 <panic>
801025ae:	66 90                	xchg   %ax,%ax

801025b0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025b0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025b1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801025b8:	00 c0 fe 
{
801025bb:	89 e5                	mov    %esp,%ebp
801025bd:	56                   	push   %esi
801025be:	53                   	push   %ebx
  ioapic->reg = reg;
801025bf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025c6:	00 00 00 
  return ioapic->data;
801025c9:	a1 34 26 11 80       	mov    0x80112634,%eax
801025ce:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801025d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801025d7:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025dd:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025e4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801025e7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025ea:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801025ed:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801025f0:	39 c2                	cmp    %eax,%edx
801025f2:	74 16                	je     8010260a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025f4:	83 ec 0c             	sub    $0xc,%esp
801025f7:	68 38 77 10 80       	push   $0x80107738
801025fc:	e8 5f e0 ff ff       	call   80100660 <cprintf>
80102601:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102607:	83 c4 10             	add    $0x10,%esp
8010260a:	83 c3 21             	add    $0x21,%ebx
{
8010260d:	ba 10 00 00 00       	mov    $0x10,%edx
80102612:	b8 20 00 00 00       	mov    $0x20,%eax
80102617:	89 f6                	mov    %esi,%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102620:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102622:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102628:	89 c6                	mov    %eax,%esi
8010262a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102630:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102633:	89 71 10             	mov    %esi,0x10(%ecx)
80102636:	8d 72 01             	lea    0x1(%edx),%esi
80102639:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010263c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010263e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102640:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102646:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010264d:	75 d1                	jne    80102620 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010264f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102652:	5b                   	pop    %ebx
80102653:	5e                   	pop    %esi
80102654:	5d                   	pop    %ebp
80102655:	c3                   	ret    
80102656:	8d 76 00             	lea    0x0(%esi),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102660:	55                   	push   %ebp
  ioapic->reg = reg;
80102661:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102667:	89 e5                	mov    %esp,%ebp
80102669:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010266c:	8d 50 20             	lea    0x20(%eax),%edx
8010266f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102673:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102675:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010267b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010267e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102681:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102684:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102686:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010268b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010268e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	66 90                	xchg   %ax,%ax
80102695:	66 90                	xchg   %ax,%ax
80102697:	66 90                	xchg   %ax,%ax
80102699:	66 90                	xchg   %ax,%ax
8010269b:	66 90                	xchg   %ax,%ax
8010269d:	66 90                	xchg   %ax,%ax
8010269f:	90                   	nop

801026a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	53                   	push   %ebx
801026a4:	83 ec 04             	sub    $0x4,%esp
801026a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801026b0:	75 70                	jne    80102722 <kfree+0x82>
801026b2:	81 fb a8 f1 11 80    	cmp    $0x8011f1a8,%ebx
801026b8:	72 68                	jb     80102722 <kfree+0x82>
801026ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026c5:	77 5b                	ja     80102722 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026c7:	83 ec 04             	sub    $0x4,%esp
801026ca:	68 00 10 00 00       	push   $0x1000
801026cf:	6a 01                	push   $0x1
801026d1:	53                   	push   %ebx
801026d2:	e8 49 23 00 00       	call   80104a20 <memset>

  if(kmem.use_lock)
801026d7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801026dd:	83 c4 10             	add    $0x10,%esp
801026e0:	85 d2                	test   %edx,%edx
801026e2:	75 2c                	jne    80102710 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026e4:	a1 78 26 11 80       	mov    0x80112678,%eax
801026e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026eb:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801026f0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801026f6:	85 c0                	test   %eax,%eax
801026f8:	75 06                	jne    80102700 <kfree+0x60>
    release(&kmem.lock);
}
801026fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026fd:	c9                   	leave  
801026fe:	c3                   	ret    
801026ff:	90                   	nop
    release(&kmem.lock);
80102700:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102707:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010270a:	c9                   	leave  
    release(&kmem.lock);
8010270b:	e9 c0 22 00 00       	jmp    801049d0 <release>
    acquire(&kmem.lock);
80102710:	83 ec 0c             	sub    $0xc,%esp
80102713:	68 40 26 11 80       	push   $0x80112640
80102718:	e8 f3 21 00 00       	call   80104910 <acquire>
8010271d:	83 c4 10             	add    $0x10,%esp
80102720:	eb c2                	jmp    801026e4 <kfree+0x44>
    panic("kfree");
80102722:	83 ec 0c             	sub    $0xc,%esp
80102725:	68 6a 77 10 80       	push   $0x8010776a
8010272a:	e8 61 dc ff ff       	call   80100390 <panic>
8010272f:	90                   	nop

80102730 <freerange>:
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	56                   	push   %esi
80102734:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102735:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102738:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010273b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102741:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102747:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010274d:	39 de                	cmp    %ebx,%esi
8010274f:	72 23                	jb     80102774 <freerange+0x44>
80102751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102758:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010275e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102761:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102767:	50                   	push   %eax
80102768:	e8 33 ff ff ff       	call   801026a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010276d:	83 c4 10             	add    $0x10,%esp
80102770:	39 f3                	cmp    %esi,%ebx
80102772:	76 e4                	jbe    80102758 <freerange+0x28>
}
80102774:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102777:	5b                   	pop    %ebx
80102778:	5e                   	pop    %esi
80102779:	5d                   	pop    %ebp
8010277a:	c3                   	ret    
8010277b:	90                   	nop
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <kinit1>:
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
80102783:	56                   	push   %esi
80102784:	53                   	push   %ebx
80102785:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102788:	83 ec 08             	sub    $0x8,%esp
8010278b:	68 70 77 10 80       	push   $0x80107770
80102790:	68 40 26 11 80       	push   $0x80112640
80102795:	e8 36 20 00 00       	call   801047d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010279a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010279d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801027a0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801027a7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801027aa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027bc:	39 de                	cmp    %ebx,%esi
801027be:	72 1c                	jb     801027dc <kinit1+0x5c>
    kfree(p);
801027c0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027c6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027cf:	50                   	push   %eax
801027d0:	e8 cb fe ff ff       	call   801026a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027d5:	83 c4 10             	add    $0x10,%esp
801027d8:	39 de                	cmp    %ebx,%esi
801027da:	73 e4                	jae    801027c0 <kinit1+0x40>
}
801027dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027df:	5b                   	pop    %ebx
801027e0:	5e                   	pop    %esi
801027e1:	5d                   	pop    %ebp
801027e2:	c3                   	ret    
801027e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027f0 <kinit2>:
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	56                   	push   %esi
801027f4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801027f5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801027f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801027fb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102801:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102807:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010280d:	39 de                	cmp    %ebx,%esi
8010280f:	72 23                	jb     80102834 <kinit2+0x44>
80102811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102818:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010281e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102821:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102827:	50                   	push   %eax
80102828:	e8 73 fe ff ff       	call   801026a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010282d:	83 c4 10             	add    $0x10,%esp
80102830:	39 de                	cmp    %ebx,%esi
80102832:	73 e4                	jae    80102818 <kinit2+0x28>
  kmem.use_lock = 1;
80102834:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010283b:	00 00 00 
}
8010283e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102841:	5b                   	pop    %ebx
80102842:	5e                   	pop    %esi
80102843:	5d                   	pop    %ebp
80102844:	c3                   	ret    
80102845:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102850 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102850:	a1 74 26 11 80       	mov    0x80112674,%eax
80102855:	85 c0                	test   %eax,%eax
80102857:	75 1f                	jne    80102878 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102859:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010285e:	85 c0                	test   %eax,%eax
80102860:	74 0e                	je     80102870 <kalloc+0x20>
    kmem.freelist = r->next;
80102862:	8b 10                	mov    (%eax),%edx
80102864:	89 15 78 26 11 80    	mov    %edx,0x80112678
8010286a:	c3                   	ret    
8010286b:	90                   	nop
8010286c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102870:	f3 c3                	repz ret 
80102872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102878:	55                   	push   %ebp
80102879:	89 e5                	mov    %esp,%ebp
8010287b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010287e:	68 40 26 11 80       	push   $0x80112640
80102883:	e8 88 20 00 00       	call   80104910 <acquire>
  r = kmem.freelist;
80102888:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010288d:	83 c4 10             	add    $0x10,%esp
80102890:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102896:	85 c0                	test   %eax,%eax
80102898:	74 08                	je     801028a2 <kalloc+0x52>
    kmem.freelist = r->next;
8010289a:	8b 08                	mov    (%eax),%ecx
8010289c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801028a2:	85 d2                	test   %edx,%edx
801028a4:	74 16                	je     801028bc <kalloc+0x6c>
    release(&kmem.lock);
801028a6:	83 ec 0c             	sub    $0xc,%esp
801028a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028ac:	68 40 26 11 80       	push   $0x80112640
801028b1:	e8 1a 21 00 00       	call   801049d0 <release>
  return (char*)r;
801028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801028b9:	83 c4 10             	add    $0x10,%esp
}
801028bc:	c9                   	leave  
801028bd:	c3                   	ret    
801028be:	66 90                	xchg   %ax,%ax

801028c0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c0:	ba 64 00 00 00       	mov    $0x64,%edx
801028c5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028c6:	a8 01                	test   $0x1,%al
801028c8:	0f 84 c2 00 00 00    	je     80102990 <kbdgetc+0xd0>
801028ce:	ba 60 00 00 00       	mov    $0x60,%edx
801028d3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801028d4:	0f b6 d0             	movzbl %al,%edx
801028d7:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
801028dd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801028e3:	0f 84 7f 00 00 00    	je     80102968 <kbdgetc+0xa8>
{
801028e9:	55                   	push   %ebp
801028ea:	89 e5                	mov    %esp,%ebp
801028ec:	53                   	push   %ebx
801028ed:	89 cb                	mov    %ecx,%ebx
801028ef:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028f2:	84 c0                	test   %al,%al
801028f4:	78 4a                	js     80102940 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028f6:	85 db                	test   %ebx,%ebx
801028f8:	74 09                	je     80102903 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028fa:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028fd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102900:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102903:	0f b6 82 a0 78 10 80 	movzbl -0x7fef8760(%edx),%eax
8010290a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010290c:	0f b6 82 a0 77 10 80 	movzbl -0x7fef8860(%edx),%eax
80102913:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102915:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102917:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010291d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102920:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102923:	8b 04 85 80 77 10 80 	mov    -0x7fef8880(,%eax,4),%eax
8010292a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010292e:	74 31                	je     80102961 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102930:	8d 50 9f             	lea    -0x61(%eax),%edx
80102933:	83 fa 19             	cmp    $0x19,%edx
80102936:	77 40                	ja     80102978 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102938:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010293b:	5b                   	pop    %ebx
8010293c:	5d                   	pop    %ebp
8010293d:	c3                   	ret    
8010293e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102940:	83 e0 7f             	and    $0x7f,%eax
80102943:	85 db                	test   %ebx,%ebx
80102945:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102948:	0f b6 82 a0 78 10 80 	movzbl -0x7fef8760(%edx),%eax
8010294f:	83 c8 40             	or     $0x40,%eax
80102952:	0f b6 c0             	movzbl %al,%eax
80102955:	f7 d0                	not    %eax
80102957:	21 c1                	and    %eax,%ecx
    return 0;
80102959:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010295b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102961:	5b                   	pop    %ebx
80102962:	5d                   	pop    %ebp
80102963:	c3                   	ret    
80102964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102968:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010296b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010296d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102973:	c3                   	ret    
80102974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102978:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010297b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010297e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010297f:	83 f9 1a             	cmp    $0x1a,%ecx
80102982:	0f 42 c2             	cmovb  %edx,%eax
}
80102985:	5d                   	pop    %ebp
80102986:	c3                   	ret    
80102987:	89 f6                	mov    %esi,%esi
80102989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102995:	c3                   	ret    
80102996:	8d 76 00             	lea    0x0(%esi),%esi
80102999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029a0 <kbdintr>:

void
kbdintr(void)
{
801029a0:	55                   	push   %ebp
801029a1:	89 e5                	mov    %esp,%ebp
801029a3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029a6:	68 c0 28 10 80       	push   $0x801028c0
801029ab:	e8 60 de ff ff       	call   80100810 <consoleintr>
}
801029b0:	83 c4 10             	add    $0x10,%esp
801029b3:	c9                   	leave  
801029b4:	c3                   	ret    
801029b5:	66 90                	xchg   %ax,%ax
801029b7:	66 90                	xchg   %ax,%ax
801029b9:	66 90                	xchg   %ax,%ax
801029bb:	66 90                	xchg   %ax,%ax
801029bd:	66 90                	xchg   %ax,%ax
801029bf:	90                   	nop

801029c0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801029c5:	55                   	push   %ebp
801029c6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029c8:	85 c0                	test   %eax,%eax
801029ca:	0f 84 c8 00 00 00    	je     80102a98 <lapicinit+0xd8>
  lapic[index] = value;
801029d0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029d7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029dd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ea:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029f1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029f4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029fe:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a01:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a04:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a0b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a11:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a18:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a1e:	8b 50 30             	mov    0x30(%eax),%edx
80102a21:	c1 ea 10             	shr    $0x10,%edx
80102a24:	80 fa 03             	cmp    $0x3,%dl
80102a27:	77 77                	ja     80102aa0 <lapicinit+0xe0>
  lapic[index] = value;
80102a29:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a30:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a33:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a36:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a3d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a40:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a43:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a4a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a50:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a57:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a5d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a64:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a67:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a6a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a71:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a74:	8b 50 20             	mov    0x20(%eax),%edx
80102a77:	89 f6                	mov    %esi,%esi
80102a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a80:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a86:	80 e6 10             	and    $0x10,%dh
80102a89:	75 f5                	jne    80102a80 <lapicinit+0xc0>
  lapic[index] = value;
80102a8b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a92:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a95:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a98:	5d                   	pop    %ebp
80102a99:	c3                   	ret    
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102aa0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102aa7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aaa:	8b 50 20             	mov    0x20(%eax),%edx
80102aad:	e9 77 ff ff ff       	jmp    80102a29 <lapicinit+0x69>
80102ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ac0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102ac0:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
80102ac6:	55                   	push   %ebp
80102ac7:	31 c0                	xor    %eax,%eax
80102ac9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102acb:	85 d2                	test   %edx,%edx
80102acd:	74 06                	je     80102ad5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102acf:	8b 42 20             	mov    0x20(%edx),%eax
80102ad2:	c1 e8 18             	shr    $0x18,%eax
}
80102ad5:	5d                   	pop    %ebp
80102ad6:	c3                   	ret    
80102ad7:	89 f6                	mov    %esi,%esi
80102ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ae0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ae0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102ae5:	55                   	push   %ebp
80102ae6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ae8:	85 c0                	test   %eax,%eax
80102aea:	74 0d                	je     80102af9 <lapiceoi+0x19>
  lapic[index] = value;
80102aec:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102af3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102af9:	5d                   	pop    %ebp
80102afa:	c3                   	ret    
80102afb:	90                   	nop
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
}
80102b03:	5d                   	pop    %ebp
80102b04:	c3                   	ret    
80102b05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b10 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b10:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b11:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b16:	ba 70 00 00 00       	mov    $0x70,%edx
80102b1b:	89 e5                	mov    %esp,%ebp
80102b1d:	53                   	push   %ebx
80102b1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b24:	ee                   	out    %al,(%dx)
80102b25:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b2a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b2f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b30:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b32:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b35:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b3b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b3d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102b40:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102b43:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b45:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b48:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b4e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102b53:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b59:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b5c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b63:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b66:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b69:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b70:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b73:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b76:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b7c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b7f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b85:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b88:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b8e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b91:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b97:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b9a:	5b                   	pop    %ebx
80102b9b:	5d                   	pop    %ebp
80102b9c:	c3                   	ret    
80102b9d:	8d 76 00             	lea    0x0(%esi),%esi

80102ba0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ba0:	55                   	push   %ebp
80102ba1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ba6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bab:	89 e5                	mov    %esp,%ebp
80102bad:	57                   	push   %edi
80102bae:	56                   	push   %esi
80102baf:	53                   	push   %ebx
80102bb0:	83 ec 4c             	sub    $0x4c,%esp
80102bb3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bb9:	ec                   	in     (%dx),%al
80102bba:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bbd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102bc2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102bc5:	8d 76 00             	lea    0x0(%esi),%esi
80102bc8:	31 c0                	xor    %eax,%eax
80102bca:	89 da                	mov    %ebx,%edx
80102bcc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bd2:	89 ca                	mov    %ecx,%edx
80102bd4:	ec                   	in     (%dx),%al
80102bd5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd8:	89 da                	mov    %ebx,%edx
80102bda:	b8 02 00 00 00       	mov    $0x2,%eax
80102bdf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be0:	89 ca                	mov    %ecx,%edx
80102be2:	ec                   	in     (%dx),%al
80102be3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be6:	89 da                	mov    %ebx,%edx
80102be8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bee:	89 ca                	mov    %ecx,%edx
80102bf0:	ec                   	in     (%dx),%al
80102bf1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf4:	89 da                	mov    %ebx,%edx
80102bf6:	b8 07 00 00 00       	mov    $0x7,%eax
80102bfb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfc:	89 ca                	mov    %ecx,%edx
80102bfe:	ec                   	in     (%dx),%al
80102bff:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c02:	89 da                	mov    %ebx,%edx
80102c04:	b8 08 00 00 00       	mov    $0x8,%eax
80102c09:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0a:	89 ca                	mov    %ecx,%edx
80102c0c:	ec                   	in     (%dx),%al
80102c0d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c0f:	89 da                	mov    %ebx,%edx
80102c11:	b8 09 00 00 00       	mov    $0x9,%eax
80102c16:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c17:	89 ca                	mov    %ecx,%edx
80102c19:	ec                   	in     (%dx),%al
80102c1a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c1c:	89 da                	mov    %ebx,%edx
80102c1e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c23:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c24:	89 ca                	mov    %ecx,%edx
80102c26:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c27:	84 c0                	test   %al,%al
80102c29:	78 9d                	js     80102bc8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c2b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c2f:	89 fa                	mov    %edi,%edx
80102c31:	0f b6 fa             	movzbl %dl,%edi
80102c34:	89 f2                	mov    %esi,%edx
80102c36:	0f b6 f2             	movzbl %dl,%esi
80102c39:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c3c:	89 da                	mov    %ebx,%edx
80102c3e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c41:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c44:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c48:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c4b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c4f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c52:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c56:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c59:	31 c0                	xor    %eax,%eax
80102c5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5c:	89 ca                	mov    %ecx,%edx
80102c5e:	ec                   	in     (%dx),%al
80102c5f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c62:	89 da                	mov    %ebx,%edx
80102c64:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c67:	b8 02 00 00 00       	mov    $0x2,%eax
80102c6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6d:	89 ca                	mov    %ecx,%edx
80102c6f:	ec                   	in     (%dx),%al
80102c70:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c73:	89 da                	mov    %ebx,%edx
80102c75:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c78:	b8 04 00 00 00       	mov    $0x4,%eax
80102c7d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7e:	89 ca                	mov    %ecx,%edx
80102c80:	ec                   	in     (%dx),%al
80102c81:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c84:	89 da                	mov    %ebx,%edx
80102c86:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c89:	b8 07 00 00 00       	mov    $0x7,%eax
80102c8e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8f:	89 ca                	mov    %ecx,%edx
80102c91:	ec                   	in     (%dx),%al
80102c92:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c95:	89 da                	mov    %ebx,%edx
80102c97:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c9a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c9f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ca0:	89 ca                	mov    %ecx,%edx
80102ca2:	ec                   	in     (%dx),%al
80102ca3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca6:	89 da                	mov    %ebx,%edx
80102ca8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102cab:	b8 09 00 00 00       	mov    $0x9,%eax
80102cb0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb1:	89 ca                	mov    %ecx,%edx
80102cb3:	ec                   	in     (%dx),%al
80102cb4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cb7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cbd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102cc0:	6a 18                	push   $0x18
80102cc2:	50                   	push   %eax
80102cc3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cc6:	50                   	push   %eax
80102cc7:	e8 a4 1d 00 00       	call   80104a70 <memcmp>
80102ccc:	83 c4 10             	add    $0x10,%esp
80102ccf:	85 c0                	test   %eax,%eax
80102cd1:	0f 85 f1 fe ff ff    	jne    80102bc8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102cd7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102cdb:	75 78                	jne    80102d55 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cdd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ce0:	89 c2                	mov    %eax,%edx
80102ce2:	83 e0 0f             	and    $0xf,%eax
80102ce5:	c1 ea 04             	shr    $0x4,%edx
80102ce8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ceb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cee:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cf1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cf4:	89 c2                	mov    %eax,%edx
80102cf6:	83 e0 0f             	and    $0xf,%eax
80102cf9:	c1 ea 04             	shr    $0x4,%edx
80102cfc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d02:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d05:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d08:	89 c2                	mov    %eax,%edx
80102d0a:	83 e0 0f             	and    $0xf,%eax
80102d0d:	c1 ea 04             	shr    $0x4,%edx
80102d10:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d13:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d16:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d1c:	89 c2                	mov    %eax,%edx
80102d1e:	83 e0 0f             	and    $0xf,%eax
80102d21:	c1 ea 04             	shr    $0x4,%edx
80102d24:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d27:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d2a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d2d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d30:	89 c2                	mov    %eax,%edx
80102d32:	83 e0 0f             	and    $0xf,%eax
80102d35:	c1 ea 04             	shr    $0x4,%edx
80102d38:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d3b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d3e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d41:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d44:	89 c2                	mov    %eax,%edx
80102d46:	83 e0 0f             	and    $0xf,%eax
80102d49:	c1 ea 04             	shr    $0x4,%edx
80102d4c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d4f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d52:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d55:	8b 75 08             	mov    0x8(%ebp),%esi
80102d58:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d5b:	89 06                	mov    %eax,(%esi)
80102d5d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d60:	89 46 04             	mov    %eax,0x4(%esi)
80102d63:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d66:	89 46 08             	mov    %eax,0x8(%esi)
80102d69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d6c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d72:	89 46 10             	mov    %eax,0x10(%esi)
80102d75:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d78:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d7b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d85:	5b                   	pop    %ebx
80102d86:	5e                   	pop    %esi
80102d87:	5f                   	pop    %edi
80102d88:	5d                   	pop    %ebp
80102d89:	c3                   	ret    
80102d8a:	66 90                	xchg   %ax,%ax
80102d8c:	66 90                	xchg   %ax,%ax
80102d8e:	66 90                	xchg   %ax,%ax

80102d90 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d90:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d96:	85 c9                	test   %ecx,%ecx
80102d98:	0f 8e 8a 00 00 00    	jle    80102e28 <install_trans+0x98>
{
80102d9e:	55                   	push   %ebp
80102d9f:	89 e5                	mov    %esp,%ebp
80102da1:	57                   	push   %edi
80102da2:	56                   	push   %esi
80102da3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102da4:	31 db                	xor    %ebx,%ebx
{
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102db0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102db5:	83 ec 08             	sub    $0x8,%esp
80102db8:	01 d8                	add    %ebx,%eax
80102dba:	83 c0 01             	add    $0x1,%eax
80102dbd:	50                   	push   %eax
80102dbe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102dc4:	e8 07 d3 ff ff       	call   801000d0 <bread>
80102dc9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dcb:	58                   	pop    %eax
80102dcc:	5a                   	pop    %edx
80102dcd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102dd4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dda:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ddd:	e8 ee d2 ff ff       	call   801000d0 <bread>
80102de2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102de4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102de7:	83 c4 0c             	add    $0xc,%esp
80102dea:	68 00 02 00 00       	push   $0x200
80102def:	50                   	push   %eax
80102df0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102df3:	50                   	push   %eax
80102df4:	e8 d7 1c 00 00       	call   80104ad0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102df9:	89 34 24             	mov    %esi,(%esp)
80102dfc:	e8 9f d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102e01:	89 3c 24             	mov    %edi,(%esp)
80102e04:	e8 d7 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102e09:	89 34 24             	mov    %esi,(%esp)
80102e0c:	e8 cf d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e11:	83 c4 10             	add    $0x10,%esp
80102e14:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102e1a:	7f 94                	jg     80102db0 <install_trans+0x20>
  }
}
80102e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e1f:	5b                   	pop    %ebx
80102e20:	5e                   	pop    %esi
80102e21:	5f                   	pop    %edi
80102e22:	5d                   	pop    %ebp
80102e23:	c3                   	ret    
80102e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e28:	f3 c3                	repz ret 
80102e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	56                   	push   %esi
80102e34:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102e35:	83 ec 08             	sub    $0x8,%esp
80102e38:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102e3e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e44:	e8 87 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e49:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102e4f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e52:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102e54:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102e56:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e59:	7e 16                	jle    80102e71 <write_head+0x41>
80102e5b:	c1 e3 02             	shl    $0x2,%ebx
80102e5e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102e60:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102e66:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102e6a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102e6d:	39 da                	cmp    %ebx,%edx
80102e6f:	75 ef                	jne    80102e60 <write_head+0x30>
  }
  bwrite(buf);
80102e71:	83 ec 0c             	sub    $0xc,%esp
80102e74:	56                   	push   %esi
80102e75:	e8 26 d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102e7a:	89 34 24             	mov    %esi,(%esp)
80102e7d:	e8 5e d3 ff ff       	call   801001e0 <brelse>
}
80102e82:	83 c4 10             	add    $0x10,%esp
80102e85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e88:	5b                   	pop    %ebx
80102e89:	5e                   	pop    %esi
80102e8a:	5d                   	pop    %ebp
80102e8b:	c3                   	ret    
80102e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e90 <initlog>:
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	53                   	push   %ebx
80102e94:	83 ec 2c             	sub    $0x2c,%esp
80102e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e9a:	68 a0 79 10 80       	push   $0x801079a0
80102e9f:	68 80 26 11 80       	push   $0x80112680
80102ea4:	e8 27 19 00 00       	call   801047d0 <initlock>
  readsb(dev, &sb);
80102ea9:	58                   	pop    %eax
80102eaa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ead:	5a                   	pop    %edx
80102eae:	50                   	push   %eax
80102eaf:	53                   	push   %ebx
80102eb0:	e8 8b e5 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102eb5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ebb:	59                   	pop    %ecx
  log.dev = dev;
80102ebc:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102ec2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102ec8:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102ecd:	5a                   	pop    %edx
80102ece:	50                   	push   %eax
80102ecf:	53                   	push   %ebx
80102ed0:	e8 fb d1 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102ed5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ed8:	83 c4 10             	add    $0x10,%esp
80102edb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102edd:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ee3:	7e 1c                	jle    80102f01 <initlog+0x71>
80102ee5:	c1 e3 02             	shl    $0x2,%ebx
80102ee8:	31 d2                	xor    %edx,%edx
80102eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102ef0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ef4:	83 c2 04             	add    $0x4,%edx
80102ef7:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102efd:	39 d3                	cmp    %edx,%ebx
80102eff:	75 ef                	jne    80102ef0 <initlog+0x60>
  brelse(buf);
80102f01:	83 ec 0c             	sub    $0xc,%esp
80102f04:	50                   	push   %eax
80102f05:	e8 d6 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f0a:	e8 81 fe ff ff       	call   80102d90 <install_trans>
  log.lh.n = 0;
80102f0f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102f16:	00 00 00 
  write_head(); // clear the log
80102f19:	e8 12 ff ff ff       	call   80102e30 <write_head>
}
80102f1e:	83 c4 10             	add    $0x10,%esp
80102f21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f24:	c9                   	leave  
80102f25:	c3                   	ret    
80102f26:	8d 76 00             	lea    0x0(%esi),%esi
80102f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f36:	68 80 26 11 80       	push   $0x80112680
80102f3b:	e8 d0 19 00 00       	call   80104910 <acquire>
80102f40:	83 c4 10             	add    $0x10,%esp
80102f43:	eb 18                	jmp    80102f5d <begin_op+0x2d>
80102f45:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f48:	83 ec 08             	sub    $0x8,%esp
80102f4b:	68 80 26 11 80       	push   $0x80112680
80102f50:	68 80 26 11 80       	push   $0x80112680
80102f55:	e8 d6 13 00 00       	call   80104330 <sleep>
80102f5a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f5d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102f62:	85 c0                	test   %eax,%eax
80102f64:	75 e2                	jne    80102f48 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f66:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f6b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f71:	83 c0 01             	add    $0x1,%eax
80102f74:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f77:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f7a:	83 fa 1e             	cmp    $0x1e,%edx
80102f7d:	7f c9                	jg     80102f48 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f7f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f82:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102f87:	68 80 26 11 80       	push   $0x80112680
80102f8c:	e8 3f 1a 00 00       	call   801049d0 <release>
      break;
    }
  }
}
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	c9                   	leave  
80102f95:	c3                   	ret    
80102f96:	8d 76 00             	lea    0x0(%esi),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fa0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	57                   	push   %edi
80102fa4:	56                   	push   %esi
80102fa5:	53                   	push   %ebx
80102fa6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fa9:	68 80 26 11 80       	push   $0x80112680
80102fae:	e8 5d 19 00 00       	call   80104910 <acquire>
  log.outstanding -= 1;
80102fb3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102fb8:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102fbe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fc1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102fc4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102fc6:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102fcc:	0f 85 1a 01 00 00    	jne    801030ec <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102fd2:	85 db                	test   %ebx,%ebx
80102fd4:	0f 85 ee 00 00 00    	jne    801030c8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fda:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102fdd:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102fe4:	00 00 00 
  release(&log.lock);
80102fe7:	68 80 26 11 80       	push   $0x80112680
80102fec:	e8 df 19 00 00       	call   801049d0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ff1:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ff7:	83 c4 10             	add    $0x10,%esp
80102ffa:	85 c9                	test   %ecx,%ecx
80102ffc:	0f 8e 85 00 00 00    	jle    80103087 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103002:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80103007:	83 ec 08             	sub    $0x8,%esp
8010300a:	01 d8                	add    %ebx,%eax
8010300c:	83 c0 01             	add    $0x1,%eax
8010300f:	50                   	push   %eax
80103010:	ff 35 c4 26 11 80    	pushl  0x801126c4
80103016:	e8 b5 d0 ff ff       	call   801000d0 <bread>
8010301b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010301d:	58                   	pop    %eax
8010301e:	5a                   	pop    %edx
8010301f:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80103026:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
8010302c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010302f:	e8 9c d0 ff ff       	call   801000d0 <bread>
80103034:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103036:	8d 40 5c             	lea    0x5c(%eax),%eax
80103039:	83 c4 0c             	add    $0xc,%esp
8010303c:	68 00 02 00 00       	push   $0x200
80103041:	50                   	push   %eax
80103042:	8d 46 5c             	lea    0x5c(%esi),%eax
80103045:	50                   	push   %eax
80103046:	e8 85 1a 00 00       	call   80104ad0 <memmove>
    bwrite(to);  // write the log
8010304b:	89 34 24             	mov    %esi,(%esp)
8010304e:	e8 4d d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103053:	89 3c 24             	mov    %edi,(%esp)
80103056:	e8 85 d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010305b:	89 34 24             	mov    %esi,(%esp)
8010305e:	e8 7d d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103063:	83 c4 10             	add    $0x10,%esp
80103066:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
8010306c:	7c 94                	jl     80103002 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010306e:	e8 bd fd ff ff       	call   80102e30 <write_head>
    install_trans(); // Now install writes to home locations
80103073:	e8 18 fd ff ff       	call   80102d90 <install_trans>
    log.lh.n = 0;
80103078:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
8010307f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103082:	e8 a9 fd ff ff       	call   80102e30 <write_head>
    acquire(&log.lock);
80103087:	83 ec 0c             	sub    $0xc,%esp
8010308a:	68 80 26 11 80       	push   $0x80112680
8010308f:	e8 7c 18 00 00       	call   80104910 <acquire>
    wakeup(&log);
80103094:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
8010309b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
801030a2:	00 00 00 
    wakeup(&log);
801030a5:	e8 46 14 00 00       	call   801044f0 <wakeup>
    release(&log.lock);
801030aa:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801030b1:	e8 1a 19 00 00       	call   801049d0 <release>
801030b6:	83 c4 10             	add    $0x10,%esp
}
801030b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030bc:	5b                   	pop    %ebx
801030bd:	5e                   	pop    %esi
801030be:	5f                   	pop    %edi
801030bf:	5d                   	pop    %ebp
801030c0:	c3                   	ret    
801030c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801030c8:	83 ec 0c             	sub    $0xc,%esp
801030cb:	68 80 26 11 80       	push   $0x80112680
801030d0:	e8 1b 14 00 00       	call   801044f0 <wakeup>
  release(&log.lock);
801030d5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801030dc:	e8 ef 18 00 00       	call   801049d0 <release>
801030e1:	83 c4 10             	add    $0x10,%esp
}
801030e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030e7:	5b                   	pop    %ebx
801030e8:	5e                   	pop    %esi
801030e9:	5f                   	pop    %edi
801030ea:	5d                   	pop    %ebp
801030eb:	c3                   	ret    
    panic("log.committing");
801030ec:	83 ec 0c             	sub    $0xc,%esp
801030ef:	68 a4 79 10 80       	push   $0x801079a4
801030f4:	e8 97 d2 ff ff       	call   80100390 <panic>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103100 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	53                   	push   %ebx
80103104:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103107:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
8010310d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103110:	83 fa 1d             	cmp    $0x1d,%edx
80103113:	0f 8f 9d 00 00 00    	jg     801031b6 <log_write+0xb6>
80103119:	a1 b8 26 11 80       	mov    0x801126b8,%eax
8010311e:	83 e8 01             	sub    $0x1,%eax
80103121:	39 c2                	cmp    %eax,%edx
80103123:	0f 8d 8d 00 00 00    	jge    801031b6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103129:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010312e:	85 c0                	test   %eax,%eax
80103130:	0f 8e 8d 00 00 00    	jle    801031c3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103136:	83 ec 0c             	sub    $0xc,%esp
80103139:	68 80 26 11 80       	push   $0x80112680
8010313e:	e8 cd 17 00 00       	call   80104910 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103143:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80103149:	83 c4 10             	add    $0x10,%esp
8010314c:	83 f9 00             	cmp    $0x0,%ecx
8010314f:	7e 57                	jle    801031a8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103151:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103154:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103156:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
8010315c:	75 0b                	jne    80103169 <log_write+0x69>
8010315e:	eb 38                	jmp    80103198 <log_write+0x98>
80103160:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80103167:	74 2f                	je     80103198 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103169:	83 c0 01             	add    $0x1,%eax
8010316c:	39 c1                	cmp    %eax,%ecx
8010316e:	75 f0                	jne    80103160 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103170:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103177:	83 c0 01             	add    $0x1,%eax
8010317a:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
8010317f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103182:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80103189:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010318c:	c9                   	leave  
  release(&log.lock);
8010318d:	e9 3e 18 00 00       	jmp    801049d0 <release>
80103192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103198:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
8010319f:	eb de                	jmp    8010317f <log_write+0x7f>
801031a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031a8:	8b 43 08             	mov    0x8(%ebx),%eax
801031ab:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
801031b0:	75 cd                	jne    8010317f <log_write+0x7f>
801031b2:	31 c0                	xor    %eax,%eax
801031b4:	eb c1                	jmp    80103177 <log_write+0x77>
    panic("too big a transaction");
801031b6:	83 ec 0c             	sub    $0xc,%esp
801031b9:	68 b3 79 10 80       	push   $0x801079b3
801031be:	e8 cd d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801031c3:	83 ec 0c             	sub    $0xc,%esp
801031c6:	68 c9 79 10 80       	push   $0x801079c9
801031cb:	e8 c0 d1 ff ff       	call   80100390 <panic>

801031d0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	53                   	push   %ebx
801031d4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031d7:	e8 04 0a 00 00       	call   80103be0 <cpuid>
801031dc:	89 c3                	mov    %eax,%ebx
801031de:	e8 fd 09 00 00       	call   80103be0 <cpuid>
801031e3:	83 ec 04             	sub    $0x4,%esp
801031e6:	53                   	push   %ebx
801031e7:	50                   	push   %eax
801031e8:	68 e4 79 10 80       	push   $0x801079e4
801031ed:	e8 6e d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801031f2:	e8 e9 2a 00 00       	call   80105ce0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031f7:	e8 64 09 00 00       	call   80103b60 <mycpu>
801031fc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031fe:	b8 01 00 00 00       	mov    $0x1,%eax
80103203:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010320a:	e8 41 0e 00 00       	call   80104050 <scheduler>
8010320f:	90                   	nop

80103210 <mpenter>:
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103216:	e8 b5 3b 00 00       	call   80106dd0 <switchkvm>
  seginit();
8010321b:	e8 20 3b 00 00       	call   80106d40 <seginit>
  lapicinit();
80103220:	e8 9b f7 ff ff       	call   801029c0 <lapicinit>
  mpmain();
80103225:	e8 a6 ff ff ff       	call   801031d0 <mpmain>
8010322a:	66 90                	xchg   %ax,%ax
8010322c:	66 90                	xchg   %ax,%ax
8010322e:	66 90                	xchg   %ax,%ax

80103230 <main>:
{
80103230:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103234:	83 e4 f0             	and    $0xfffffff0,%esp
80103237:	ff 71 fc             	pushl  -0x4(%ecx)
8010323a:	55                   	push   %ebp
8010323b:	89 e5                	mov    %esp,%ebp
8010323d:	53                   	push   %ebx
8010323e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010323f:	83 ec 08             	sub    $0x8,%esp
80103242:	68 00 00 40 80       	push   $0x80400000
80103247:	68 a8 f1 11 80       	push   $0x8011f1a8
8010324c:	e8 2f f5 ff ff       	call   80102780 <kinit1>
  kvmalloc();      // kernel page table
80103251:	e8 4a 40 00 00       	call   801072a0 <kvmalloc>
  mpinit();        // detect other processors
80103256:	e8 75 01 00 00       	call   801033d0 <mpinit>
  lapicinit();     // interrupt controller
8010325b:	e8 60 f7 ff ff       	call   801029c0 <lapicinit>
  seginit();       // segment descriptors
80103260:	e8 db 3a 00 00       	call   80106d40 <seginit>
  picinit();       // disable pic
80103265:	e8 46 03 00 00       	call   801035b0 <picinit>
  ioapicinit();    // another interrupt controller
8010326a:	e8 41 f3 ff ff       	call   801025b0 <ioapicinit>
  consoleinit();   // console hardware
8010326f:	e8 4c d7 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103274:	e8 97 2d 00 00       	call   80106010 <uartinit>
  pinit();         // process table
80103279:	e8 c2 08 00 00       	call   80103b40 <pinit>
  tvinit();        // trap vectors
8010327e:	e8 dd 29 00 00       	call   80105c60 <tvinit>
  binit();         // buffer cache
80103283:	e8 b8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103288:	e8 d3 da ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
8010328d:	e8 fe f0 ff ff       	call   80102390 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103292:	83 c4 0c             	add    $0xc,%esp
80103295:	68 8a 00 00 00       	push   $0x8a
8010329a:	68 8c a4 10 80       	push   $0x8010a48c
8010329f:	68 00 70 00 80       	push   $0x80007000
801032a4:	e8 27 18 00 00       	call   80104ad0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032a9:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801032b0:	00 00 00 
801032b3:	83 c4 10             	add    $0x10,%esp
801032b6:	05 80 27 11 80       	add    $0x80112780,%eax
801032bb:	3d 80 27 11 80       	cmp    $0x80112780,%eax
801032c0:	76 71                	jbe    80103333 <main+0x103>
801032c2:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801032c7:	89 f6                	mov    %esi,%esi
801032c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801032d0:	e8 8b 08 00 00       	call   80103b60 <mycpu>
801032d5:	39 d8                	cmp    %ebx,%eax
801032d7:	74 41                	je     8010331a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032d9:	e8 72 f5 ff ff       	call   80102850 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801032de:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801032e3:	c7 05 f8 6f 00 80 10 	movl   $0x80103210,0x80006ff8
801032ea:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032ed:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801032f4:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801032f7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801032fc:	0f b6 03             	movzbl (%ebx),%eax
801032ff:	83 ec 08             	sub    $0x8,%esp
80103302:	68 00 70 00 00       	push   $0x7000
80103307:	50                   	push   %eax
80103308:	e8 03 f8 ff ff       	call   80102b10 <lapicstartap>
8010330d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103310:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103316:	85 c0                	test   %eax,%eax
80103318:	74 f6                	je     80103310 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010331a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103321:	00 00 00 
80103324:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010332a:	05 80 27 11 80       	add    $0x80112780,%eax
8010332f:	39 c3                	cmp    %eax,%ebx
80103331:	72 9d                	jb     801032d0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103333:	83 ec 08             	sub    $0x8,%esp
80103336:	68 00 00 00 8e       	push   $0x8e000000
8010333b:	68 00 00 40 80       	push   $0x80400000
80103340:	e8 ab f4 ff ff       	call   801027f0 <kinit2>
  userinit();      // first user process
80103345:	e8 e6 08 00 00       	call   80103c30 <userinit>
  mpmain();        // finish this processor's setup
8010334a:	e8 81 fe ff ff       	call   801031d0 <mpmain>
8010334f:	90                   	nop

80103350 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	57                   	push   %edi
80103354:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103355:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010335b:	53                   	push   %ebx
  e = addr+len;
8010335c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010335f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103362:	39 de                	cmp    %ebx,%esi
80103364:	72 10                	jb     80103376 <mpsearch1+0x26>
80103366:	eb 50                	jmp    801033b8 <mpsearch1+0x68>
80103368:	90                   	nop
80103369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103370:	39 fb                	cmp    %edi,%ebx
80103372:	89 fe                	mov    %edi,%esi
80103374:	76 42                	jbe    801033b8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103376:	83 ec 04             	sub    $0x4,%esp
80103379:	8d 7e 10             	lea    0x10(%esi),%edi
8010337c:	6a 04                	push   $0x4
8010337e:	68 f8 79 10 80       	push   $0x801079f8
80103383:	56                   	push   %esi
80103384:	e8 e7 16 00 00       	call   80104a70 <memcmp>
80103389:	83 c4 10             	add    $0x10,%esp
8010338c:	85 c0                	test   %eax,%eax
8010338e:	75 e0                	jne    80103370 <mpsearch1+0x20>
80103390:	89 f1                	mov    %esi,%ecx
80103392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103398:	0f b6 11             	movzbl (%ecx),%edx
8010339b:	83 c1 01             	add    $0x1,%ecx
8010339e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801033a0:	39 f9                	cmp    %edi,%ecx
801033a2:	75 f4                	jne    80103398 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033a4:	84 c0                	test   %al,%al
801033a6:	75 c8                	jne    80103370 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033ab:	89 f0                	mov    %esi,%eax
801033ad:	5b                   	pop    %ebx
801033ae:	5e                   	pop    %esi
801033af:	5f                   	pop    %edi
801033b0:	5d                   	pop    %ebp
801033b1:	c3                   	ret    
801033b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033bb:	31 f6                	xor    %esi,%esi
}
801033bd:	89 f0                	mov    %esi,%eax
801033bf:	5b                   	pop    %ebx
801033c0:	5e                   	pop    %esi
801033c1:	5f                   	pop    %edi
801033c2:	5d                   	pop    %ebp
801033c3:	c3                   	ret    
801033c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801033d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	57                   	push   %edi
801033d4:	56                   	push   %esi
801033d5:	53                   	push   %ebx
801033d6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033e7:	c1 e0 08             	shl    $0x8,%eax
801033ea:	09 d0                	or     %edx,%eax
801033ec:	c1 e0 04             	shl    $0x4,%eax
801033ef:	85 c0                	test   %eax,%eax
801033f1:	75 1b                	jne    8010340e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801033f3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033fa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103401:	c1 e0 08             	shl    $0x8,%eax
80103404:	09 d0                	or     %edx,%eax
80103406:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103409:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010340e:	ba 00 04 00 00       	mov    $0x400,%edx
80103413:	e8 38 ff ff ff       	call   80103350 <mpsearch1>
80103418:	85 c0                	test   %eax,%eax
8010341a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010341d:	0f 84 3d 01 00 00    	je     80103560 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103426:	8b 58 04             	mov    0x4(%eax),%ebx
80103429:	85 db                	test   %ebx,%ebx
8010342b:	0f 84 4f 01 00 00    	je     80103580 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103431:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103437:	83 ec 04             	sub    $0x4,%esp
8010343a:	6a 04                	push   $0x4
8010343c:	68 15 7a 10 80       	push   $0x80107a15
80103441:	56                   	push   %esi
80103442:	e8 29 16 00 00       	call   80104a70 <memcmp>
80103447:	83 c4 10             	add    $0x10,%esp
8010344a:	85 c0                	test   %eax,%eax
8010344c:	0f 85 2e 01 00 00    	jne    80103580 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103452:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103459:	3c 01                	cmp    $0x1,%al
8010345b:	0f 95 c2             	setne  %dl
8010345e:	3c 04                	cmp    $0x4,%al
80103460:	0f 95 c0             	setne  %al
80103463:	20 c2                	and    %al,%dl
80103465:	0f 85 15 01 00 00    	jne    80103580 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010346b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103472:	66 85 ff             	test   %di,%di
80103475:	74 1a                	je     80103491 <mpinit+0xc1>
80103477:	89 f0                	mov    %esi,%eax
80103479:	01 f7                	add    %esi,%edi
  sum = 0;
8010347b:	31 d2                	xor    %edx,%edx
8010347d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103480:	0f b6 08             	movzbl (%eax),%ecx
80103483:	83 c0 01             	add    $0x1,%eax
80103486:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103488:	39 c7                	cmp    %eax,%edi
8010348a:	75 f4                	jne    80103480 <mpinit+0xb0>
8010348c:	84 d2                	test   %dl,%dl
8010348e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103491:	85 f6                	test   %esi,%esi
80103493:	0f 84 e7 00 00 00    	je     80103580 <mpinit+0x1b0>
80103499:	84 d2                	test   %dl,%dl
8010349b:	0f 85 df 00 00 00    	jne    80103580 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034a1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801034a7:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034ac:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801034b3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801034b9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034be:	01 d6                	add    %edx,%esi
801034c0:	39 c6                	cmp    %eax,%esi
801034c2:	76 23                	jbe    801034e7 <mpinit+0x117>
    switch(*p){
801034c4:	0f b6 10             	movzbl (%eax),%edx
801034c7:	80 fa 04             	cmp    $0x4,%dl
801034ca:	0f 87 ca 00 00 00    	ja     8010359a <mpinit+0x1ca>
801034d0:	ff 24 95 3c 7a 10 80 	jmp    *-0x7fef85c4(,%edx,4)
801034d7:	89 f6                	mov    %esi,%esi
801034d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034e0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034e3:	39 c6                	cmp    %eax,%esi
801034e5:	77 dd                	ja     801034c4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034e7:	85 db                	test   %ebx,%ebx
801034e9:	0f 84 9e 00 00 00    	je     8010358d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034f2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801034f6:	74 15                	je     8010350d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034f8:	b8 70 00 00 00       	mov    $0x70,%eax
801034fd:	ba 22 00 00 00       	mov    $0x22,%edx
80103502:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103503:	ba 23 00 00 00       	mov    $0x23,%edx
80103508:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103509:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010350c:	ee                   	out    %al,(%dx)
  }
}
8010350d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103510:	5b                   	pop    %ebx
80103511:	5e                   	pop    %esi
80103512:	5f                   	pop    %edi
80103513:	5d                   	pop    %ebp
80103514:	c3                   	ret    
80103515:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103518:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010351e:	83 f9 07             	cmp    $0x7,%ecx
80103521:	7f 19                	jg     8010353c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103523:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103527:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010352d:	83 c1 01             	add    $0x1,%ecx
80103530:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103536:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
8010353c:	83 c0 14             	add    $0x14,%eax
      continue;
8010353f:	e9 7c ff ff ff       	jmp    801034c0 <mpinit+0xf0>
80103544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103548:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010354c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010354f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103555:	e9 66 ff ff ff       	jmp    801034c0 <mpinit+0xf0>
8010355a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103560:	ba 00 00 01 00       	mov    $0x10000,%edx
80103565:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010356a:	e8 e1 fd ff ff       	call   80103350 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010356f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103571:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103574:	0f 85 a9 fe ff ff    	jne    80103423 <mpinit+0x53>
8010357a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	68 fd 79 10 80       	push   $0x801079fd
80103588:	e8 03 ce ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010358d:	83 ec 0c             	sub    $0xc,%esp
80103590:	68 1c 7a 10 80       	push   $0x80107a1c
80103595:	e8 f6 cd ff ff       	call   80100390 <panic>
      ismp = 0;
8010359a:	31 db                	xor    %ebx,%ebx
8010359c:	e9 26 ff ff ff       	jmp    801034c7 <mpinit+0xf7>
801035a1:	66 90                	xchg   %ax,%ax
801035a3:	66 90                	xchg   %ax,%ax
801035a5:	66 90                	xchg   %ax,%ax
801035a7:	66 90                	xchg   %ax,%ax
801035a9:	66 90                	xchg   %ax,%ax
801035ab:	66 90                	xchg   %ax,%ax
801035ad:	66 90                	xchg   %ax,%ax
801035af:	90                   	nop

801035b0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801035b0:	55                   	push   %ebp
801035b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035b6:	ba 21 00 00 00       	mov    $0x21,%edx
801035bb:	89 e5                	mov    %esp,%ebp
801035bd:	ee                   	out    %al,(%dx)
801035be:	ba a1 00 00 00       	mov    $0xa1,%edx
801035c3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035c4:	5d                   	pop    %ebp
801035c5:	c3                   	ret    
801035c6:	66 90                	xchg   %ax,%ax
801035c8:	66 90                	xchg   %ax,%ax
801035ca:	66 90                	xchg   %ax,%ax
801035cc:	66 90                	xchg   %ax,%ax
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 0c             	sub    $0xc,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801035e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035eb:	e8 90 d7 ff ff       	call   80100d80 <filealloc>
801035f0:	85 c0                	test   %eax,%eax
801035f2:	89 03                	mov    %eax,(%ebx)
801035f4:	74 22                	je     80103618 <pipealloc+0x48>
801035f6:	e8 85 d7 ff ff       	call   80100d80 <filealloc>
801035fb:	85 c0                	test   %eax,%eax
801035fd:	89 06                	mov    %eax,(%esi)
801035ff:	74 3f                	je     80103640 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103601:	e8 4a f2 ff ff       	call   80102850 <kalloc>
80103606:	85 c0                	test   %eax,%eax
80103608:	89 c7                	mov    %eax,%edi
8010360a:	75 54                	jne    80103660 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010360c:	8b 03                	mov    (%ebx),%eax
8010360e:	85 c0                	test   %eax,%eax
80103610:	75 34                	jne    80103646 <pipealloc+0x76>
80103612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103618:	8b 06                	mov    (%esi),%eax
8010361a:	85 c0                	test   %eax,%eax
8010361c:	74 0c                	je     8010362a <pipealloc+0x5a>
    fileclose(*f1);
8010361e:	83 ec 0c             	sub    $0xc,%esp
80103621:	50                   	push   %eax
80103622:	e8 19 d8 ff ff       	call   80100e40 <fileclose>
80103627:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010362a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010362d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103632:	5b                   	pop    %ebx
80103633:	5e                   	pop    %esi
80103634:	5f                   	pop    %edi
80103635:	5d                   	pop    %ebp
80103636:	c3                   	ret    
80103637:	89 f6                	mov    %esi,%esi
80103639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103640:	8b 03                	mov    (%ebx),%eax
80103642:	85 c0                	test   %eax,%eax
80103644:	74 e4                	je     8010362a <pipealloc+0x5a>
    fileclose(*f0);
80103646:	83 ec 0c             	sub    $0xc,%esp
80103649:	50                   	push   %eax
8010364a:	e8 f1 d7 ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010364f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103651:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103654:	85 c0                	test   %eax,%eax
80103656:	75 c6                	jne    8010361e <pipealloc+0x4e>
80103658:	eb d0                	jmp    8010362a <pipealloc+0x5a>
8010365a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103660:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103663:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010366a:	00 00 00 
  p->writeopen = 1;
8010366d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103674:	00 00 00 
  p->nwrite = 0;
80103677:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010367e:	00 00 00 
  p->nread = 0;
80103681:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103688:	00 00 00 
  initlock(&p->lock, "pipe");
8010368b:	68 50 7a 10 80       	push   $0x80107a50
80103690:	50                   	push   %eax
80103691:	e8 3a 11 00 00       	call   801047d0 <initlock>
  (*f0)->type = FD_PIPE;
80103696:	8b 03                	mov    (%ebx),%eax
  return 0;
80103698:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010369b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036a1:	8b 03                	mov    (%ebx),%eax
801036a3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036a7:	8b 03                	mov    (%ebx),%eax
801036a9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036ad:	8b 03                	mov    (%ebx),%eax
801036af:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036b2:	8b 06                	mov    (%esi),%eax
801036b4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036ba:	8b 06                	mov    (%esi),%eax
801036bc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036c0:	8b 06                	mov    (%esi),%eax
801036c2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036c6:	8b 06                	mov    (%esi),%eax
801036c8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801036cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036ce:	31 c0                	xor    %eax,%eax
}
801036d0:	5b                   	pop    %ebx
801036d1:	5e                   	pop    %esi
801036d2:	5f                   	pop    %edi
801036d3:	5d                   	pop    %ebp
801036d4:	c3                   	ret    
801036d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036e0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	56                   	push   %esi
801036e4:	53                   	push   %ebx
801036e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036eb:	83 ec 0c             	sub    $0xc,%esp
801036ee:	53                   	push   %ebx
801036ef:	e8 1c 12 00 00       	call   80104910 <acquire>
  if(writable){
801036f4:	83 c4 10             	add    $0x10,%esp
801036f7:	85 f6                	test   %esi,%esi
801036f9:	74 45                	je     80103740 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801036fb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103701:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103704:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010370b:	00 00 00 
    wakeup(&p->nread);
8010370e:	50                   	push   %eax
8010370f:	e8 dc 0d 00 00       	call   801044f0 <wakeup>
80103714:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103717:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010371d:	85 d2                	test   %edx,%edx
8010371f:	75 0a                	jne    8010372b <pipeclose+0x4b>
80103721:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103727:	85 c0                	test   %eax,%eax
80103729:	74 35                	je     80103760 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010372b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010372e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103731:	5b                   	pop    %ebx
80103732:	5e                   	pop    %esi
80103733:	5d                   	pop    %ebp
    release(&p->lock);
80103734:	e9 97 12 00 00       	jmp    801049d0 <release>
80103739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103740:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103746:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103749:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103750:	00 00 00 
    wakeup(&p->nwrite);
80103753:	50                   	push   %eax
80103754:	e8 97 0d 00 00       	call   801044f0 <wakeup>
80103759:	83 c4 10             	add    $0x10,%esp
8010375c:	eb b9                	jmp    80103717 <pipeclose+0x37>
8010375e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	53                   	push   %ebx
80103764:	e8 67 12 00 00       	call   801049d0 <release>
    kfree((char*)p);
80103769:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010376c:	83 c4 10             	add    $0x10,%esp
}
8010376f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103772:	5b                   	pop    %ebx
80103773:	5e                   	pop    %esi
80103774:	5d                   	pop    %ebp
    kfree((char*)p);
80103775:	e9 26 ef ff ff       	jmp    801026a0 <kfree>
8010377a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103780 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	57                   	push   %edi
80103784:	56                   	push   %esi
80103785:	53                   	push   %ebx
80103786:	83 ec 28             	sub    $0x28,%esp
80103789:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010378c:	53                   	push   %ebx
8010378d:	e8 7e 11 00 00       	call   80104910 <acquire>
  for(i = 0; i < n; i++){
80103792:	8b 45 10             	mov    0x10(%ebp),%eax
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	85 c0                	test   %eax,%eax
8010379a:	0f 8e c9 00 00 00    	jle    80103869 <pipewrite+0xe9>
801037a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801037a3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037a9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037af:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801037b2:	03 4d 10             	add    0x10(%ebp),%ecx
801037b5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037b8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801037be:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801037c4:	39 d0                	cmp    %edx,%eax
801037c6:	75 71                	jne    80103839 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801037c8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037ce:	85 c0                	test   %eax,%eax
801037d0:	74 4e                	je     80103820 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037d2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801037d8:	eb 3a                	jmp    80103814 <pipewrite+0x94>
801037da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801037e0:	83 ec 0c             	sub    $0xc,%esp
801037e3:	57                   	push   %edi
801037e4:	e8 07 0d 00 00       	call   801044f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037e9:	5a                   	pop    %edx
801037ea:	59                   	pop    %ecx
801037eb:	53                   	push   %ebx
801037ec:	56                   	push   %esi
801037ed:	e8 3e 0b 00 00       	call   80104330 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037f2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037f8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037fe:	83 c4 10             	add    $0x10,%esp
80103801:	05 00 02 00 00       	add    $0x200,%eax
80103806:	39 c2                	cmp    %eax,%edx
80103808:	75 36                	jne    80103840 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010380a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103810:	85 c0                	test   %eax,%eax
80103812:	74 0c                	je     80103820 <pipewrite+0xa0>
80103814:	e8 e7 03 00 00       	call   80103c00 <myproc>
80103819:	8b 40 24             	mov    0x24(%eax),%eax
8010381c:	85 c0                	test   %eax,%eax
8010381e:	74 c0                	je     801037e0 <pipewrite+0x60>
        release(&p->lock);
80103820:	83 ec 0c             	sub    $0xc,%esp
80103823:	53                   	push   %ebx
80103824:	e8 a7 11 00 00       	call   801049d0 <release>
        return -1;
80103829:	83 c4 10             	add    $0x10,%esp
8010382c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103831:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103834:	5b                   	pop    %ebx
80103835:	5e                   	pop    %esi
80103836:	5f                   	pop    %edi
80103837:	5d                   	pop    %ebp
80103838:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103839:	89 c2                	mov    %eax,%edx
8010383b:	90                   	nop
8010383c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103840:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103843:	8d 42 01             	lea    0x1(%edx),%eax
80103846:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010384c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103852:	83 c6 01             	add    $0x1,%esi
80103855:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103859:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010385c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010385f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103863:	0f 85 4f ff ff ff    	jne    801037b8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103869:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010386f:	83 ec 0c             	sub    $0xc,%esp
80103872:	50                   	push   %eax
80103873:	e8 78 0c 00 00       	call   801044f0 <wakeup>
  release(&p->lock);
80103878:	89 1c 24             	mov    %ebx,(%esp)
8010387b:	e8 50 11 00 00       	call   801049d0 <release>
  return n;
80103880:	83 c4 10             	add    $0x10,%esp
80103883:	8b 45 10             	mov    0x10(%ebp),%eax
80103886:	eb a9                	jmp    80103831 <pipewrite+0xb1>
80103888:	90                   	nop
80103889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103890 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	57                   	push   %edi
80103894:	56                   	push   %esi
80103895:	53                   	push   %ebx
80103896:	83 ec 18             	sub    $0x18,%esp
80103899:	8b 75 08             	mov    0x8(%ebp),%esi
8010389c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010389f:	56                   	push   %esi
801038a0:	e8 6b 10 00 00       	call   80104910 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801038ae:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801038b4:	75 6a                	jne    80103920 <piperead+0x90>
801038b6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801038bc:	85 db                	test   %ebx,%ebx
801038be:	0f 84 c4 00 00 00    	je     80103988 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038c4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038ca:	eb 2d                	jmp    801038f9 <piperead+0x69>
801038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038d0:	83 ec 08             	sub    $0x8,%esp
801038d3:	56                   	push   %esi
801038d4:	53                   	push   %ebx
801038d5:	e8 56 0a 00 00       	call   80104330 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038da:	83 c4 10             	add    $0x10,%esp
801038dd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801038e3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801038e9:	75 35                	jne    80103920 <piperead+0x90>
801038eb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801038f1:	85 d2                	test   %edx,%edx
801038f3:	0f 84 8f 00 00 00    	je     80103988 <piperead+0xf8>
    if(myproc()->killed){
801038f9:	e8 02 03 00 00       	call   80103c00 <myproc>
801038fe:	8b 48 24             	mov    0x24(%eax),%ecx
80103901:	85 c9                	test   %ecx,%ecx
80103903:	74 cb                	je     801038d0 <piperead+0x40>
      release(&p->lock);
80103905:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103908:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010390d:	56                   	push   %esi
8010390e:	e8 bd 10 00 00       	call   801049d0 <release>
      return -1;
80103913:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103916:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103919:	89 d8                	mov    %ebx,%eax
8010391b:	5b                   	pop    %ebx
8010391c:	5e                   	pop    %esi
8010391d:	5f                   	pop    %edi
8010391e:	5d                   	pop    %ebp
8010391f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103920:	8b 45 10             	mov    0x10(%ebp),%eax
80103923:	85 c0                	test   %eax,%eax
80103925:	7e 61                	jle    80103988 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103927:	31 db                	xor    %ebx,%ebx
80103929:	eb 13                	jmp    8010393e <piperead+0xae>
8010392b:	90                   	nop
8010392c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103930:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103936:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010393c:	74 1f                	je     8010395d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010393e:	8d 41 01             	lea    0x1(%ecx),%eax
80103941:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103947:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010394d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103952:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103955:	83 c3 01             	add    $0x1,%ebx
80103958:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010395b:	75 d3                	jne    80103930 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010395d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103963:	83 ec 0c             	sub    $0xc,%esp
80103966:	50                   	push   %eax
80103967:	e8 84 0b 00 00       	call   801044f0 <wakeup>
  release(&p->lock);
8010396c:	89 34 24             	mov    %esi,(%esp)
8010396f:	e8 5c 10 00 00       	call   801049d0 <release>
  return i;
80103974:	83 c4 10             	add    $0x10,%esp
}
80103977:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010397a:	89 d8                	mov    %ebx,%eax
8010397c:	5b                   	pop    %ebx
8010397d:	5e                   	pop    %esi
8010397e:	5f                   	pop    %edi
8010397f:	5d                   	pop    %ebp
80103980:	c3                   	ret    
80103981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103988:	31 db                	xor    %ebx,%ebx
8010398a:	eb d1                	jmp    8010395d <piperead+0xcd>
8010398c:	66 90                	xchg   %ax,%ax
8010398e:	66 90                	xchg   %ax,%ax

80103990 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103994:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103999:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010399c:	68 20 2d 11 80       	push   $0x80112d20
801039a1:	e8 6a 0f 00 00       	call   80104910 <acquire>
801039a6:	83 c4 10             	add    $0x10,%esp
801039a9:	eb 17                	jmp    801039c2 <allocproc+0x32>
801039ab:	90                   	nop
801039ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039b0:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
801039b6:	81 fb 54 e9 11 80    	cmp    $0x8011e954,%ebx
801039bc:	0f 83 06 01 00 00    	jae    80103ac8 <allocproc+0x138>
    if(p->state == UNUSED)
801039c2:	8b 43 0c             	mov    0xc(%ebx),%eax
801039c5:	85 c0                	test   %eax,%eax
801039c7:	75 e7                	jne    801039b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039c9:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801039ce:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039d1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801039d8:	8d 50 01             	lea    0x1(%eax),%edx
801039db:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801039de:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801039e3:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801039e9:	e8 e2 0f 00 00       	call   801049d0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039ee:	e8 5d ee ff ff       	call   80102850 <kalloc>
801039f3:	83 c4 10             	add    $0x10,%esp
801039f6:	85 c0                	test   %eax,%eax
801039f8:	89 43 08             	mov    %eax,0x8(%ebx)
801039fb:	0f 84 e0 00 00 00    	je     80103ae1 <allocproc+0x151>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a01:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a07:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a0a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a0f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a12:	c7 40 14 52 5c 10 80 	movl   $0x80105c52,0x14(%eax)
  p->context = (struct context*)sp;
80103a19:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a1c:	6a 14                	push   $0x14
80103a1e:	6a 00                	push   $0x0
80103a20:	50                   	push   %eax
80103a21:	e8 fa 0f 00 00       	call   80104a20 <memset>
  p->context->eip = (uint)forkret;
80103a26:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a29:	8d 93 bc 01 00 00    	lea    0x1bc(%ebx),%edx
80103a2f:	83 c4 10             	add    $0x10,%esp
80103a32:	c7 40 10 f0 3a 10 80 	movl   $0x80103af0,0x10(%eax)
80103a39:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80103a3f:	90                   	nop

  #ifndef NONE

    int i;
    for (i = 0; i < MAX_PSYC_PAGES; i++) {
      p->swappedPages[i].virtualAddress = (char*)0xffffffff;
80103a40:	c7 80 2c 01 00 00 ff 	movl   $0xffffffff,0x12c(%eax)
80103a47:	ff ff ff 
      p->swappedPages[i].swaploc = 0;
80103a4a:	c7 80 3c 01 00 00 00 	movl   $0x0,0x13c(%eax)
80103a51:	00 00 00 
80103a54:	83 c0 14             	add    $0x14,%eax
      p->swappedPages[i].age = 0;
80103a57:	c7 80 1c 01 00 00 00 	movl   $0x0,0x11c(%eax)
80103a5e:	00 00 00 
      p->freePages[i].virtualAddress = (char*)0xffffffff;
80103a61:	c7 40 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%eax)
      p->freePages[i].next = 0;
80103a68:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
      p->freePages[i].prev = 0;
80103a6f:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
      p->freePages[i].age = 0;
80103a76:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
    for (i = 0; i < MAX_PSYC_PAGES; i++) {
80103a7d:	39 d0                	cmp    %edx,%eax
80103a7f:	75 bf                	jne    80103a40 <allocproc+0xb0>
    }
    p->mainMemoryPageCount = 0;
80103a81:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103a88:	00 00 00 
    p->totalSwapCount = 0;
80103a8b:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103a92:	00 00 00 
    p->pageFaultCount = 0;   
80103a95:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103a9c:	00 00 00 
    p->swapFilePageCount = 0;
80103a9f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103aa6:	00 00 00 
    p->head = 0;
80103aa9:	c7 83 e8 02 00 00 00 	movl   $0x0,0x2e8(%ebx)
80103ab0:	00 00 00 
    p->tail = 0;
80103ab3:	c7 83 ec 02 00 00 00 	movl   $0x0,0x2ec(%ebx)
80103aba:	00 00 00 

  #endif

  return p;
}
80103abd:	89 d8                	mov    %ebx,%eax
80103abf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ac2:	c9                   	leave  
80103ac3:	c3                   	ret    
80103ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103ac8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103acb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103acd:	68 20 2d 11 80       	push   $0x80112d20
80103ad2:	e8 f9 0e 00 00       	call   801049d0 <release>
}
80103ad7:	89 d8                	mov    %ebx,%eax
  return 0;
80103ad9:	83 c4 10             	add    $0x10,%esp
}
80103adc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103adf:	c9                   	leave  
80103ae0:	c3                   	ret    
    p->state = UNUSED;
80103ae1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ae8:	31 db                	xor    %ebx,%ebx
80103aea:	eb d1                	jmp    80103abd <allocproc+0x12d>
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103af0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103af6:	68 20 2d 11 80       	push   $0x80112d20
80103afb:	e8 d0 0e 00 00       	call   801049d0 <release>

  if (first) {
80103b00:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103b05:	83 c4 10             	add    $0x10,%esp
80103b08:	85 c0                	test   %eax,%eax
80103b0a:	75 04                	jne    80103b10 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b0c:	c9                   	leave  
80103b0d:	c3                   	ret    
80103b0e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103b10:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103b13:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103b1a:	00 00 00 
    iinit(ROOTDEV);
80103b1d:	6a 01                	push   $0x1
80103b1f:	e8 5c d9 ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103b24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b2b:	e8 60 f3 ff ff       	call   80102e90 <initlog>
80103b30:	83 c4 10             	add    $0x10,%esp
}
80103b33:	c9                   	leave  
80103b34:	c3                   	ret    
80103b35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b40 <pinit>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b46:	68 55 7a 10 80       	push   $0x80107a55
80103b4b:	68 20 2d 11 80       	push   $0x80112d20
80103b50:	e8 7b 0c 00 00       	call   801047d0 <initlock>
}
80103b55:	83 c4 10             	add    $0x10,%esp
80103b58:	c9                   	leave  
80103b59:	c3                   	ret    
80103b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b60 <mycpu>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	56                   	push   %esi
80103b64:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b65:	9c                   	pushf  
80103b66:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b67:	f6 c4 02             	test   $0x2,%ah
80103b6a:	75 5e                	jne    80103bca <mycpu+0x6a>
  apicid = lapicid();
80103b6c:	e8 4f ef ff ff       	call   80102ac0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b71:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103b77:	85 f6                	test   %esi,%esi
80103b79:	7e 42                	jle    80103bbd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b7b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103b82:	39 d0                	cmp    %edx,%eax
80103b84:	74 30                	je     80103bb6 <mycpu+0x56>
80103b86:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
80103b8b:	31 d2                	xor    %edx,%edx
80103b8d:	8d 76 00             	lea    0x0(%esi),%esi
80103b90:	83 c2 01             	add    $0x1,%edx
80103b93:	39 f2                	cmp    %esi,%edx
80103b95:	74 26                	je     80103bbd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b97:	0f b6 19             	movzbl (%ecx),%ebx
80103b9a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103ba0:	39 c3                	cmp    %eax,%ebx
80103ba2:	75 ec                	jne    80103b90 <mycpu+0x30>
80103ba4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103baa:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103baf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bb2:	5b                   	pop    %ebx
80103bb3:	5e                   	pop    %esi
80103bb4:	5d                   	pop    %ebp
80103bb5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103bb6:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
80103bbb:	eb f2                	jmp    80103baf <mycpu+0x4f>
  panic("unknown apicid\n");
80103bbd:	83 ec 0c             	sub    $0xc,%esp
80103bc0:	68 5c 7a 10 80       	push   $0x80107a5c
80103bc5:	e8 c6 c7 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103bca:	83 ec 0c             	sub    $0xc,%esp
80103bcd:	68 38 7b 10 80       	push   $0x80107b38
80103bd2:	e8 b9 c7 ff ff       	call   80100390 <panic>
80103bd7:	89 f6                	mov    %esi,%esi
80103bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103be0 <cpuid>:
cpuid() {
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103be6:	e8 75 ff ff ff       	call   80103b60 <mycpu>
80103beb:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103bf0:	c9                   	leave  
  return mycpu()-cpus;
80103bf1:	c1 f8 04             	sar    $0x4,%eax
80103bf4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103bfa:	c3                   	ret    
80103bfb:	90                   	nop
80103bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c00 <myproc>:
myproc(void) {
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	53                   	push   %ebx
80103c04:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c07:	e8 34 0c 00 00       	call   80104840 <pushcli>
  c = mycpu();
80103c0c:	e8 4f ff ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80103c11:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c17:	e8 64 0c 00 00       	call   80104880 <popcli>
}
80103c1c:	83 c4 04             	add    $0x4,%esp
80103c1f:	89 d8                	mov    %ebx,%eax
80103c21:	5b                   	pop    %ebx
80103c22:	5d                   	pop    %ebp
80103c23:	c3                   	ret    
80103c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c30 <userinit>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	53                   	push   %ebx
80103c34:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103c37:	e8 54 fd ff ff       	call   80103990 <allocproc>
80103c3c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c3e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103c43:	e8 d8 35 00 00       	call   80107220 <setupkvm>
80103c48:	85 c0                	test   %eax,%eax
80103c4a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c4d:	0f 84 bd 00 00 00    	je     80103d10 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c53:	83 ec 04             	sub    $0x4,%esp
80103c56:	68 2c 00 00 00       	push   $0x2c
80103c5b:	68 60 a4 10 80       	push   $0x8010a460
80103c60:	50                   	push   %eax
80103c61:	e8 9a 32 00 00       	call   80106f00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c66:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c69:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c6f:	6a 4c                	push   $0x4c
80103c71:	6a 00                	push   $0x0
80103c73:	ff 73 18             	pushl  0x18(%ebx)
80103c76:	e8 a5 0d 00 00       	call   80104a20 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c7b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c7e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c83:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c88:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c8b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c8f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c92:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c96:	8b 43 18             	mov    0x18(%ebx),%eax
80103c99:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c9d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ca1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ca4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ca8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103cac:	8b 43 18             	mov    0x18(%ebx),%eax
80103caf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103cb6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cb9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103cc0:	8b 43 18             	mov    0x18(%ebx),%eax
80103cc3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cca:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ccd:	6a 10                	push   $0x10
80103ccf:	68 85 7a 10 80       	push   $0x80107a85
80103cd4:	50                   	push   %eax
80103cd5:	e8 26 0f 00 00       	call   80104c00 <safestrcpy>
  p->cwd = namei("/");
80103cda:	c7 04 24 8e 7a 10 80 	movl   $0x80107a8e,(%esp)
80103ce1:	e8 fa e1 ff ff       	call   80101ee0 <namei>
80103ce6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ce9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cf0:	e8 1b 0c 00 00       	call   80104910 <acquire>
  p->state = RUNNABLE;
80103cf5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103cfc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d03:	e8 c8 0c 00 00       	call   801049d0 <release>
}
80103d08:	83 c4 10             	add    $0x10,%esp
80103d0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d0e:	c9                   	leave  
80103d0f:	c3                   	ret    
    panic("userinit: out of memory?");
80103d10:	83 ec 0c             	sub    $0xc,%esp
80103d13:	68 6c 7a 10 80       	push   $0x80107a6c
80103d18:	e8 73 c6 ff ff       	call   80100390 <panic>
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi

80103d20 <growproc>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	56                   	push   %esi
80103d24:	53                   	push   %ebx
80103d25:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d28:	e8 13 0b 00 00       	call   80104840 <pushcli>
  c = mycpu();
80103d2d:	e8 2e fe ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80103d32:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d38:	e8 43 0b 00 00       	call   80104880 <popcli>
  if(n > 0){
80103d3d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103d40:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d42:	7f 1c                	jg     80103d60 <growproc+0x40>
  } else if(n < 0){
80103d44:	75 3a                	jne    80103d80 <growproc+0x60>
  switchuvm(curproc);
80103d46:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d49:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d4b:	53                   	push   %ebx
80103d4c:	e8 9f 30 00 00       	call   80106df0 <switchuvm>
  return 0;
80103d51:	83 c4 10             	add    $0x10,%esp
80103d54:	31 c0                	xor    %eax,%eax
}
80103d56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d59:	5b                   	pop    %ebx
80103d5a:	5e                   	pop    %esi
80103d5b:	5d                   	pop    %ebp
80103d5c:	c3                   	ret    
80103d5d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d60:	83 ec 04             	sub    $0x4,%esp
80103d63:	01 c6                	add    %eax,%esi
80103d65:	56                   	push   %esi
80103d66:	50                   	push   %eax
80103d67:	ff 73 04             	pushl  0x4(%ebx)
80103d6a:	e8 d1 32 00 00       	call   80107040 <allocuvm>
80103d6f:	83 c4 10             	add    $0x10,%esp
80103d72:	85 c0                	test   %eax,%eax
80103d74:	75 d0                	jne    80103d46 <growproc+0x26>
      return -1;
80103d76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d7b:	eb d9                	jmp    80103d56 <growproc+0x36>
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d80:	83 ec 04             	sub    $0x4,%esp
80103d83:	01 c6                	add    %eax,%esi
80103d85:	56                   	push   %esi
80103d86:	50                   	push   %eax
80103d87:	ff 73 04             	pushl  0x4(%ebx)
80103d8a:	e8 e1 33 00 00       	call   80107170 <deallocuvm>
80103d8f:	83 c4 10             	add    $0x10,%esp
80103d92:	85 c0                	test   %eax,%eax
80103d94:	75 b0                	jne    80103d46 <growproc+0x26>
80103d96:	eb de                	jmp    80103d76 <growproc+0x56>
80103d98:	90                   	nop
80103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103da0 <fork>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	81 ec 1c 08 00 00    	sub    $0x81c,%esp
  pushcli();
80103dac:	e8 8f 0a 00 00       	call   80104840 <pushcli>
  c = mycpu();
80103db1:	e8 aa fd ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80103db6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dbc:	e8 bf 0a 00 00       	call   80104880 <popcli>
  if((np = allocproc()) == 0){
80103dc1:	e8 ca fb ff ff       	call   80103990 <allocproc>
80103dc6:	85 c0                	test   %eax,%eax
80103dc8:	89 85 dc f7 ff ff    	mov    %eax,-0x824(%ebp)
80103dce:	0f 84 3c 02 00 00    	je     80104010 <fork+0x270>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dd4:	83 ec 08             	sub    $0x8,%esp
80103dd7:	ff 33                	pushl  (%ebx)
80103dd9:	ff 73 04             	pushl  0x4(%ebx)
80103ddc:	89 c7                	mov    %eax,%edi
80103dde:	e8 0d 35 00 00       	call   801072f0 <copyuvm>
80103de3:	83 c4 10             	add    $0x10,%esp
80103de6:	85 c0                	test   %eax,%eax
80103de8:	89 47 04             	mov    %eax,0x4(%edi)
80103deb:	0f 84 2e 02 00 00    	je     8010401f <fork+0x27f>
  np->sz = curproc->sz;
80103df1:	8b 03                	mov    (%ebx),%eax
80103df3:	8b 95 dc f7 ff ff    	mov    -0x824(%ebp),%edx
  *np->tf = *curproc->tf;
80103df9:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103dfe:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103e00:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103e03:	8b 7a 18             	mov    0x18(%edx),%edi
80103e06:	8b 73 18             	mov    0x18(%ebx),%esi
80103e09:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->swapFilePageCount = curproc->swapFilePageCount;
80103e0b:	89 d7                	mov    %edx,%edi
  for(i = 0; i < NOFILE; i++)
80103e0d:	31 f6                	xor    %esi,%esi
    np->mainMemoryPageCount = curproc->mainMemoryPageCount;
80103e0f:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103e15:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
    np->swapFilePageCount = curproc->swapFilePageCount;
80103e1b:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103e21:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  np->tf->eax = 0;
80103e27:	8b 42 18             	mov    0x18(%edx),%eax
80103e2a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103e38:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e3c:	85 c0                	test   %eax,%eax
80103e3e:	74 10                	je     80103e50 <fork+0xb0>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e40:	83 ec 0c             	sub    $0xc,%esp
80103e43:	50                   	push   %eax
80103e44:	e8 a7 cf ff ff       	call   80100df0 <filedup>
80103e49:	83 c4 10             	add    $0x10,%esp
80103e4c:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e50:	83 c6 01             	add    $0x1,%esi
80103e53:	83 fe 10             	cmp    $0x10,%esi
80103e56:	75 e0                	jne    80103e38 <fork+0x98>
  np->cwd = idup(curproc->cwd);
80103e58:	83 ec 0c             	sub    $0xc,%esp
80103e5b:	ff 73 68             	pushl  0x68(%ebx)
80103e5e:	e8 ed d7 ff ff       	call   80101650 <idup>
80103e63:	8b bd dc f7 ff ff    	mov    -0x824(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e69:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e6c:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e6f:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e72:	6a 10                	push   $0x10
80103e74:	50                   	push   %eax
80103e75:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e78:	50                   	push   %eax
80103e79:	e8 82 0d 00 00       	call   80104c00 <safestrcpy>
    if(curproc->pid > 2){
80103e7e:	83 c4 10             	add    $0x10,%esp
80103e81:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  pid = np->pid;
80103e85:	8b 47 10             	mov    0x10(%edi),%eax
80103e88:	89 85 d8 f7 ff ff    	mov    %eax,-0x828(%ebp)
    if(curproc->pid > 2){
80103e8e:	0f 8f fd 00 00 00    	jg     80103f91 <fork+0x1f1>
80103e94:	8b bd dc f7 ff ff    	mov    -0x824(%ebp),%edi
80103e9a:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80103ea0:	8d 8b bc 01 00 00    	lea    0x1bc(%ebx),%ecx
80103ea6:	81 c7 90 00 00 00    	add    $0x90,%edi
80103eac:	89 bd e0 f7 ff ff    	mov    %edi,-0x820(%ebp)
  for(i = 0; i < NOFILE; i++)
80103eb2:	89 fa                	mov    %edi,%edx
80103eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      np->freePages[i].virtualAddress = curproc->freePages[i].virtualAddress;
80103eb8:	8b 30                	mov    (%eax),%esi
80103eba:	83 c0 14             	add    $0x14,%eax
80103ebd:	83 c2 14             	add    $0x14,%edx
80103ec0:	89 72 ec             	mov    %esi,-0x14(%edx)
      np->freePages[i].age = curproc->freePages[i].age;
80103ec3:	8b 70 f0             	mov    -0x10(%eax),%esi
80103ec6:	89 72 f0             	mov    %esi,-0x10(%edx)
      np->swappedPages[i].virtualAddress = curproc->swappedPages[i].virtualAddress;
80103ec9:	8b b0 18 01 00 00    	mov    0x118(%eax),%esi
80103ecf:	89 b2 18 01 00 00    	mov    %esi,0x118(%edx)
      np->swappedPages[i].age = curproc->swappedPages[i].age;
80103ed5:	8b b0 1c 01 00 00    	mov    0x11c(%eax),%esi
80103edb:	89 b2 1c 01 00 00    	mov    %esi,0x11c(%edx)
      np->swappedPages[i].swaploc = curproc->swappedPages[i].swaploc;
80103ee1:	8b b0 28 01 00 00    	mov    0x128(%eax),%esi
80103ee7:	89 b2 28 01 00 00    	mov    %esi,0x128(%edx)
    for(i=0;i<MAX_PSYC_PAGES;i++){
80103eed:	39 c8                	cmp    %ecx,%eax
80103eef:	75 c7                	jne    80103eb8 <fork+0x118>
80103ef1:	8b 85 dc f7 ff ff    	mov    -0x824(%ebp),%eax
80103ef7:	8d 8b 9c 00 00 00    	lea    0x9c(%ebx),%ecx
80103efd:	8d b0 98 00 00 00    	lea    0x98(%eax),%esi
80103f03:	8d 98 c4 01 00 00    	lea    0x1c4(%eax),%ebx
80103f09:	8d b8 bc 01 00 00    	lea    0x1bc(%eax),%edi
80103f0f:	90                   	nop
  for(i = 0; i < NOFILE; i++)
80103f10:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
80103f16:	89 9d e4 f7 ff ff    	mov    %ebx,-0x81c(%ebp)
80103f1c:	eb 0f                	jmp    80103f2d <fork+0x18d>
80103f1e:	66 90                	xchg   %ax,%ax
        if(np->freePages[j].virtualAddress == curproc->freePages[i].prev->virtualAddress)
80103f20:	8b 19                	mov    (%ecx),%ebx
80103f22:	39 13                	cmp    %edx,(%ebx)
80103f24:	74 1a                	je     80103f40 <fork+0x1a0>
80103f26:	83 c0 14             	add    $0x14,%eax
      for(j=0;j<MAX_PSYC_PAGES;++j){
80103f29:	39 f8                	cmp    %edi,%eax
80103f2b:	74 1d                	je     80103f4a <fork+0x1aa>
        if(np->freePages[j].virtualAddress == curproc->freePages[i].next->virtualAddress)
80103f2d:	8b 59 fc             	mov    -0x4(%ecx),%ebx
80103f30:	8b 10                	mov    (%eax),%edx
80103f32:	3b 13                	cmp    (%ebx),%edx
80103f34:	75 ea                	jne    80103f20 <fork+0x180>
          np->freePages[i].next = &np->freePages[j];
80103f36:	89 06                	mov    %eax,(%esi)
        if(np->freePages[j].virtualAddress == curproc->freePages[i].prev->virtualAddress)
80103f38:	8b 19                	mov    (%ecx),%ebx
80103f3a:	8b 10                	mov    (%eax),%edx
80103f3c:	39 13                	cmp    %edx,(%ebx)
80103f3e:	75 e6                	jne    80103f26 <fork+0x186>
          np->freePages[i].prev = &np->freePages[j];
80103f40:	89 46 04             	mov    %eax,0x4(%esi)
80103f43:	83 c0 14             	add    $0x14,%eax
      for(j=0;j<MAX_PSYC_PAGES;++j){
80103f46:	39 f8                	cmp    %edi,%eax
80103f48:	75 e3                	jne    80103f2d <fork+0x18d>
80103f4a:	8b 9d e4 f7 ff ff    	mov    -0x81c(%ebp),%ebx
80103f50:	83 c6 14             	add    $0x14,%esi
80103f53:	83 c1 14             	add    $0x14,%ecx
    for(i = 0; i<MAX_PSYC_PAGES; i++){
80103f56:	39 de                	cmp    %ebx,%esi
80103f58:	75 b6                	jne    80103f10 <fork+0x170>
  acquire(&ptable.lock);
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	68 20 2d 11 80       	push   $0x80112d20
80103f62:	e8 a9 09 00 00       	call   80104910 <acquire>
  np->state = RUNNABLE;
80103f67:	8b 85 dc f7 ff ff    	mov    -0x824(%ebp),%eax
80103f6d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80103f74:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f7b:	e8 50 0a 00 00       	call   801049d0 <release>
  return pid;
80103f80:	83 c4 10             	add    $0x10,%esp
}
80103f83:	8b 85 d8 f7 ff ff    	mov    -0x828(%ebp),%eax
80103f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f8c:	5b                   	pop    %ebx
80103f8d:	5e                   	pop    %esi
80103f8e:	5f                   	pop    %edi
80103f8f:	5d                   	pop    %ebp
80103f90:	c3                   	ret    
      createSwapFile(np);
80103f91:	83 ec 0c             	sub    $0xc,%esp
80103f94:	ff b5 dc f7 ff ff    	pushl  -0x824(%ebp)
      char buf[PGSIZE/2] = "";
80103f9a:	8d bd ec f7 ff ff    	lea    -0x814(%ebp),%edi
80103fa0:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi
      createSwapFile(np);
80103fa6:	e8 05 e2 ff ff       	call   801021b0 <createSwapFile>
      char buf[PGSIZE/2] = "";
80103fab:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
80103fb0:	31 c0                	xor    %eax,%eax
80103fb2:	c7 85 e8 f7 ff ff 00 	movl   $0x0,-0x818(%ebp)
80103fb9:	00 00 00 
80103fbc:	f3 ab                	rep stos %eax,%es:(%edi)
80103fbe:	8b bd dc f7 ff ff    	mov    -0x824(%ebp),%edi
      while((nread == readFromSwapFile(curproc,buf, offset, PGSIZE/2))!=0)
80103fc4:	83 c4 10             	add    $0x10,%esp
80103fc7:	89 f6                	mov    %esi,%esi
80103fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103fd0:	68 00 08 00 00       	push   $0x800
80103fd5:	6a 00                	push   $0x0
80103fd7:	56                   	push   %esi
80103fd8:	53                   	push   %ebx
80103fd9:	e8 a2 e2 ff ff       	call   80102280 <readFromSwapFile>
80103fde:	83 c4 10             	add    $0x10,%esp
80103fe1:	85 c0                	test   %eax,%eax
80103fe3:	0f 85 ab fe ff ff    	jne    80103e94 <fork+0xf4>
        if(writeToSwapFile(np, buf, offset, nread) == -1){
80103fe9:	6a 00                	push   $0x0
80103feb:	6a 00                	push   $0x0
80103fed:	56                   	push   %esi
80103fee:	57                   	push   %edi
80103fef:	e8 5c e2 ff ff       	call   80102250 <writeToSwapFile>
80103ff4:	83 c4 10             	add    $0x10,%esp
80103ff7:	83 f8 ff             	cmp    $0xffffffff,%eax
80103ffa:	75 d4                	jne    80103fd0 <fork+0x230>
          panic("fork: error while copying the parent's swap file to the child");
80103ffc:	83 ec 0c             	sub    $0xc,%esp
80103fff:	68 60 7b 10 80       	push   $0x80107b60
80104004:	e8 87 c3 ff ff       	call   80100390 <panic>
80104009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104010:	c7 85 d8 f7 ff ff ff 	movl   $0xffffffff,-0x828(%ebp)
80104017:	ff ff ff 
8010401a:	e9 64 ff ff ff       	jmp    80103f83 <fork+0x1e3>
    kfree(np->kstack);
8010401f:	8b bd dc f7 ff ff    	mov    -0x824(%ebp),%edi
80104025:	83 ec 0c             	sub    $0xc,%esp
80104028:	ff 77 08             	pushl  0x8(%edi)
8010402b:	e8 70 e6 ff ff       	call   801026a0 <kfree>
    np->kstack = 0;
80104030:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80104037:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
8010403e:	83 c4 10             	add    $0x10,%esp
80104041:	c7 85 d8 f7 ff ff ff 	movl   $0xffffffff,-0x828(%ebp)
80104048:	ff ff ff 
8010404b:	e9 33 ff ff ff       	jmp    80103f83 <fork+0x1e3>

80104050 <scheduler>:
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104059:	e8 02 fb ff ff       	call   80103b60 <mycpu>
8010405e:	8d 78 04             	lea    0x4(%eax),%edi
80104061:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104063:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010406a:	00 00 00 
8010406d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104070:	fb                   	sti    
    acquire(&ptable.lock);
80104071:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104074:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80104079:	68 20 2d 11 80       	push   $0x80112d20
8010407e:	e8 8d 08 00 00       	call   80104910 <acquire>
80104083:	83 c4 10             	add    $0x10,%esp
80104086:	8d 76 00             	lea    0x0(%esi),%esi
80104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104090:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104094:	75 33                	jne    801040c9 <scheduler+0x79>
      switchuvm(p);
80104096:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104099:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010409f:	53                   	push   %ebx
801040a0:	e8 4b 2d 00 00       	call   80106df0 <switchuvm>
      swtch(&(c->scheduler), p->context);
801040a5:	58                   	pop    %eax
801040a6:	5a                   	pop    %edx
801040a7:	ff 73 1c             	pushl  0x1c(%ebx)
801040aa:	57                   	push   %edi
      p->state = RUNNING;
801040ab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801040b2:	e8 a4 0b 00 00       	call   80104c5b <swtch>
      switchkvm();
801040b7:	e8 14 2d 00 00       	call   80106dd0 <switchkvm>
      c->proc = 0;
801040bc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801040c3:	00 00 00 
801040c6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040c9:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
801040cf:	81 fb 54 e9 11 80    	cmp    $0x8011e954,%ebx
801040d5:	72 b9                	jb     80104090 <scheduler+0x40>
    release(&ptable.lock);
801040d7:	83 ec 0c             	sub    $0xc,%esp
801040da:	68 20 2d 11 80       	push   $0x80112d20
801040df:	e8 ec 08 00 00       	call   801049d0 <release>
    sti();
801040e4:	83 c4 10             	add    $0x10,%esp
801040e7:	eb 87                	jmp    80104070 <scheduler+0x20>
801040e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040f0 <sched>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	56                   	push   %esi
801040f4:	53                   	push   %ebx
  pushcli();
801040f5:	e8 46 07 00 00       	call   80104840 <pushcli>
  c = mycpu();
801040fa:	e8 61 fa ff ff       	call   80103b60 <mycpu>
  p = c->proc;
801040ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104105:	e8 76 07 00 00       	call   80104880 <popcli>
  if(!holding(&ptable.lock))
8010410a:	83 ec 0c             	sub    $0xc,%esp
8010410d:	68 20 2d 11 80       	push   $0x80112d20
80104112:	e8 c9 07 00 00       	call   801048e0 <holding>
80104117:	83 c4 10             	add    $0x10,%esp
8010411a:	85 c0                	test   %eax,%eax
8010411c:	74 4f                	je     8010416d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010411e:	e8 3d fa ff ff       	call   80103b60 <mycpu>
80104123:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010412a:	75 68                	jne    80104194 <sched+0xa4>
  if(p->state == RUNNING)
8010412c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104130:	74 55                	je     80104187 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104132:	9c                   	pushf  
80104133:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104134:	f6 c4 02             	test   $0x2,%ah
80104137:	75 41                	jne    8010417a <sched+0x8a>
  intena = mycpu()->intena;
80104139:	e8 22 fa ff ff       	call   80103b60 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010413e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104141:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104147:	e8 14 fa ff ff       	call   80103b60 <mycpu>
8010414c:	83 ec 08             	sub    $0x8,%esp
8010414f:	ff 70 04             	pushl  0x4(%eax)
80104152:	53                   	push   %ebx
80104153:	e8 03 0b 00 00       	call   80104c5b <swtch>
  mycpu()->intena = intena;
80104158:	e8 03 fa ff ff       	call   80103b60 <mycpu>
}
8010415d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104160:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104166:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104169:	5b                   	pop    %ebx
8010416a:	5e                   	pop    %esi
8010416b:	5d                   	pop    %ebp
8010416c:	c3                   	ret    
    panic("sched ptable.lock");
8010416d:	83 ec 0c             	sub    $0xc,%esp
80104170:	68 90 7a 10 80       	push   $0x80107a90
80104175:	e8 16 c2 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010417a:	83 ec 0c             	sub    $0xc,%esp
8010417d:	68 bc 7a 10 80       	push   $0x80107abc
80104182:	e8 09 c2 ff ff       	call   80100390 <panic>
    panic("sched running");
80104187:	83 ec 0c             	sub    $0xc,%esp
8010418a:	68 ae 7a 10 80       	push   $0x80107aae
8010418f:	e8 fc c1 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104194:	83 ec 0c             	sub    $0xc,%esp
80104197:	68 a2 7a 10 80       	push   $0x80107aa2
8010419c:	e8 ef c1 ff ff       	call   80100390 <panic>
801041a1:	eb 0d                	jmp    801041b0 <exit>
801041a3:	90                   	nop
801041a4:	90                   	nop
801041a5:	90                   	nop
801041a6:	90                   	nop
801041a7:	90                   	nop
801041a8:	90                   	nop
801041a9:	90                   	nop
801041aa:	90                   	nop
801041ab:	90                   	nop
801041ac:	90                   	nop
801041ad:	90                   	nop
801041ae:	90                   	nop
801041af:	90                   	nop

801041b0 <exit>:
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	57                   	push   %edi
801041b4:	56                   	push   %esi
801041b5:	53                   	push   %ebx
801041b6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801041b9:	e8 82 06 00 00       	call   80104840 <pushcli>
  c = mycpu();
801041be:	e8 9d f9 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
801041c3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041c9:	e8 b2 06 00 00       	call   80104880 <popcli>
  if(curproc == initproc)
801041ce:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
801041d4:	8d 5e 28             	lea    0x28(%esi),%ebx
801041d7:	8d 7e 68             	lea    0x68(%esi),%edi
801041da:	0f 84 f1 00 00 00    	je     801042d1 <exit+0x121>
    if(curproc->ofile[fd]){
801041e0:	8b 03                	mov    (%ebx),%eax
801041e2:	85 c0                	test   %eax,%eax
801041e4:	74 12                	je     801041f8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801041e6:	83 ec 0c             	sub    $0xc,%esp
801041e9:	50                   	push   %eax
801041ea:	e8 51 cc ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
801041ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801041f5:	83 c4 10             	add    $0x10,%esp
801041f8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
801041fb:	39 fb                	cmp    %edi,%ebx
801041fd:	75 e1                	jne    801041e0 <exit+0x30>
  begin_op();
801041ff:	e8 2c ed ff ff       	call   80102f30 <begin_op>
  iput(curproc->cwd);
80104204:	83 ec 0c             	sub    $0xc,%esp
80104207:	ff 76 68             	pushl  0x68(%esi)
8010420a:	e8 a1 d5 ff ff       	call   801017b0 <iput>
  end_op();
8010420f:	e8 8c ed ff ff       	call   80102fa0 <end_op>
  curproc->cwd = 0;
80104214:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010421b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104222:	e8 e9 06 00 00       	call   80104910 <acquire>
  wakeup1(curproc->parent);
80104227:	8b 56 14             	mov    0x14(%esi),%edx
8010422a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010422d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104232:	eb 10                	jmp    80104244 <exit+0x94>
80104234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104238:	05 f0 02 00 00       	add    $0x2f0,%eax
8010423d:	3d 54 e9 11 80       	cmp    $0x8011e954,%eax
80104242:	73 1e                	jae    80104262 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104244:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104248:	75 ee                	jne    80104238 <exit+0x88>
8010424a:	3b 50 20             	cmp    0x20(%eax),%edx
8010424d:	75 e9                	jne    80104238 <exit+0x88>
      p->state = RUNNABLE;
8010424f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104256:	05 f0 02 00 00       	add    $0x2f0,%eax
8010425b:	3d 54 e9 11 80       	cmp    $0x8011e954,%eax
80104260:	72 e2                	jb     80104244 <exit+0x94>
      p->parent = initproc;
80104262:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104268:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010426d:	eb 0f                	jmp    8010427e <exit+0xce>
8010426f:	90                   	nop
80104270:	81 c2 f0 02 00 00    	add    $0x2f0,%edx
80104276:	81 fa 54 e9 11 80    	cmp    $0x8011e954,%edx
8010427c:	73 3a                	jae    801042b8 <exit+0x108>
    if(p->parent == curproc){
8010427e:	39 72 14             	cmp    %esi,0x14(%edx)
80104281:	75 ed                	jne    80104270 <exit+0xc0>
      if(p->state == ZOMBIE)
80104283:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104287:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010428a:	75 e4                	jne    80104270 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010428c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104291:	eb 11                	jmp    801042a4 <exit+0xf4>
80104293:	90                   	nop
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104298:	05 f0 02 00 00       	add    $0x2f0,%eax
8010429d:	3d 54 e9 11 80       	cmp    $0x8011e954,%eax
801042a2:	73 cc                	jae    80104270 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801042a4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042a8:	75 ee                	jne    80104298 <exit+0xe8>
801042aa:	3b 48 20             	cmp    0x20(%eax),%ecx
801042ad:	75 e9                	jne    80104298 <exit+0xe8>
      p->state = RUNNABLE;
801042af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801042b6:	eb e0                	jmp    80104298 <exit+0xe8>
  curproc->state = ZOMBIE;
801042b8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801042bf:	e8 2c fe ff ff       	call   801040f0 <sched>
  panic("zombie exit");
801042c4:	83 ec 0c             	sub    $0xc,%esp
801042c7:	68 dd 7a 10 80       	push   $0x80107add
801042cc:	e8 bf c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
801042d1:	83 ec 0c             	sub    $0xc,%esp
801042d4:	68 d0 7a 10 80       	push   $0x80107ad0
801042d9:	e8 b2 c0 ff ff       	call   80100390 <panic>
801042de:	66 90                	xchg   %ax,%ax

801042e0 <yield>:
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801042e7:	68 20 2d 11 80       	push   $0x80112d20
801042ec:	e8 1f 06 00 00       	call   80104910 <acquire>
  pushcli();
801042f1:	e8 4a 05 00 00       	call   80104840 <pushcli>
  c = mycpu();
801042f6:	e8 65 f8 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
801042fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104301:	e8 7a 05 00 00       	call   80104880 <popcli>
  myproc()->state = RUNNABLE;
80104306:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010430d:	e8 de fd ff ff       	call   801040f0 <sched>
  release(&ptable.lock);
80104312:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104319:	e8 b2 06 00 00       	call   801049d0 <release>
}
8010431e:	83 c4 10             	add    $0x10,%esp
80104321:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104324:	c9                   	leave  
80104325:	c3                   	ret    
80104326:	8d 76 00             	lea    0x0(%esi),%esi
80104329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104330 <sleep>:
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	56                   	push   %esi
80104335:	53                   	push   %ebx
80104336:	83 ec 0c             	sub    $0xc,%esp
80104339:	8b 7d 08             	mov    0x8(%ebp),%edi
8010433c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010433f:	e8 fc 04 00 00       	call   80104840 <pushcli>
  c = mycpu();
80104344:	e8 17 f8 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80104349:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010434f:	e8 2c 05 00 00       	call   80104880 <popcli>
  if(p == 0)
80104354:	85 db                	test   %ebx,%ebx
80104356:	0f 84 87 00 00 00    	je     801043e3 <sleep+0xb3>
  if(lk == 0)
8010435c:	85 f6                	test   %esi,%esi
8010435e:	74 76                	je     801043d6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104360:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104366:	74 50                	je     801043b8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104368:	83 ec 0c             	sub    $0xc,%esp
8010436b:	68 20 2d 11 80       	push   $0x80112d20
80104370:	e8 9b 05 00 00       	call   80104910 <acquire>
    release(lk);
80104375:	89 34 24             	mov    %esi,(%esp)
80104378:	e8 53 06 00 00       	call   801049d0 <release>
  p->chan = chan;
8010437d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104380:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104387:	e8 64 fd ff ff       	call   801040f0 <sched>
  p->chan = 0;
8010438c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104393:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010439a:	e8 31 06 00 00       	call   801049d0 <release>
    acquire(lk);
8010439f:	89 75 08             	mov    %esi,0x8(%ebp)
801043a2:	83 c4 10             	add    $0x10,%esp
}
801043a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043a8:	5b                   	pop    %ebx
801043a9:	5e                   	pop    %esi
801043aa:	5f                   	pop    %edi
801043ab:	5d                   	pop    %ebp
    acquire(lk);
801043ac:	e9 5f 05 00 00       	jmp    80104910 <acquire>
801043b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801043b8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043bb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043c2:	e8 29 fd ff ff       	call   801040f0 <sched>
  p->chan = 0;
801043c7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801043ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043d1:	5b                   	pop    %ebx
801043d2:	5e                   	pop    %esi
801043d3:	5f                   	pop    %edi
801043d4:	5d                   	pop    %ebp
801043d5:	c3                   	ret    
    panic("sleep without lk");
801043d6:	83 ec 0c             	sub    $0xc,%esp
801043d9:	68 ef 7a 10 80       	push   $0x80107aef
801043de:	e8 ad bf ff ff       	call   80100390 <panic>
    panic("sleep");
801043e3:	83 ec 0c             	sub    $0xc,%esp
801043e6:	68 e9 7a 10 80       	push   $0x80107ae9
801043eb:	e8 a0 bf ff ff       	call   80100390 <panic>

801043f0 <wait>:
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	53                   	push   %ebx
  pushcli();
801043f5:	e8 46 04 00 00       	call   80104840 <pushcli>
  c = mycpu();
801043fa:	e8 61 f7 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
801043ff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104405:	e8 76 04 00 00       	call   80104880 <popcli>
  acquire(&ptable.lock);
8010440a:	83 ec 0c             	sub    $0xc,%esp
8010440d:	68 20 2d 11 80       	push   $0x80112d20
80104412:	e8 f9 04 00 00       	call   80104910 <acquire>
80104417:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010441a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010441c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104421:	eb 13                	jmp    80104436 <wait+0x46>
80104423:	90                   	nop
80104424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104428:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
8010442e:	81 fb 54 e9 11 80    	cmp    $0x8011e954,%ebx
80104434:	73 1e                	jae    80104454 <wait+0x64>
      if(p->parent != curproc)
80104436:	39 73 14             	cmp    %esi,0x14(%ebx)
80104439:	75 ed                	jne    80104428 <wait+0x38>
      if(p->state == ZOMBIE){
8010443b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010443f:	74 37                	je     80104478 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104441:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
      havekids = 1;
80104447:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010444c:	81 fb 54 e9 11 80    	cmp    $0x8011e954,%ebx
80104452:	72 e2                	jb     80104436 <wait+0x46>
    if(!havekids || curproc->killed){
80104454:	85 c0                	test   %eax,%eax
80104456:	74 76                	je     801044ce <wait+0xde>
80104458:	8b 46 24             	mov    0x24(%esi),%eax
8010445b:	85 c0                	test   %eax,%eax
8010445d:	75 6f                	jne    801044ce <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010445f:	83 ec 08             	sub    $0x8,%esp
80104462:	68 20 2d 11 80       	push   $0x80112d20
80104467:	56                   	push   %esi
80104468:	e8 c3 fe ff ff       	call   80104330 <sleep>
    havekids = 0;
8010446d:	83 c4 10             	add    $0x10,%esp
80104470:	eb a8                	jmp    8010441a <wait+0x2a>
80104472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104478:	83 ec 0c             	sub    $0xc,%esp
8010447b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010447e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104481:	e8 1a e2 ff ff       	call   801026a0 <kfree>
        freevm(p->pgdir);
80104486:	5a                   	pop    %edx
80104487:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010448a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104491:	e8 0a 2d 00 00       	call   801071a0 <freevm>
        release(&ptable.lock);
80104496:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
8010449d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801044a4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801044ab:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801044af:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801044b6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801044bd:	e8 0e 05 00 00       	call   801049d0 <release>
        return pid;
801044c2:	83 c4 10             	add    $0x10,%esp
}
801044c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044c8:	89 f0                	mov    %esi,%eax
801044ca:	5b                   	pop    %ebx
801044cb:	5e                   	pop    %esi
801044cc:	5d                   	pop    %ebp
801044cd:	c3                   	ret    
      release(&ptable.lock);
801044ce:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801044d1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801044d6:	68 20 2d 11 80       	push   $0x80112d20
801044db:	e8 f0 04 00 00       	call   801049d0 <release>
      return -1;
801044e0:	83 c4 10             	add    $0x10,%esp
801044e3:	eb e0                	jmp    801044c5 <wait+0xd5>
801044e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	53                   	push   %ebx
801044f4:	83 ec 10             	sub    $0x10,%esp
801044f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801044fa:	68 20 2d 11 80       	push   $0x80112d20
801044ff:	e8 0c 04 00 00       	call   80104910 <acquire>
80104504:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104507:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010450c:	eb 0e                	jmp    8010451c <wakeup+0x2c>
8010450e:	66 90                	xchg   %ax,%ax
80104510:	05 f0 02 00 00       	add    $0x2f0,%eax
80104515:	3d 54 e9 11 80       	cmp    $0x8011e954,%eax
8010451a:	73 1e                	jae    8010453a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010451c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104520:	75 ee                	jne    80104510 <wakeup+0x20>
80104522:	3b 58 20             	cmp    0x20(%eax),%ebx
80104525:	75 e9                	jne    80104510 <wakeup+0x20>
      p->state = RUNNABLE;
80104527:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010452e:	05 f0 02 00 00       	add    $0x2f0,%eax
80104533:	3d 54 e9 11 80       	cmp    $0x8011e954,%eax
80104538:	72 e2                	jb     8010451c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010453a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104544:	c9                   	leave  
  release(&ptable.lock);
80104545:	e9 86 04 00 00       	jmp    801049d0 <release>
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104550 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 10             	sub    $0x10,%esp
80104557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010455a:	68 20 2d 11 80       	push   $0x80112d20
8010455f:	e8 ac 03 00 00       	call   80104910 <acquire>
80104564:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104567:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010456c:	eb 0e                	jmp    8010457c <kill+0x2c>
8010456e:	66 90                	xchg   %ax,%ax
80104570:	05 f0 02 00 00       	add    $0x2f0,%eax
80104575:	3d 54 e9 11 80       	cmp    $0x8011e954,%eax
8010457a:	73 34                	jae    801045b0 <kill+0x60>
    if(p->pid == pid){
8010457c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010457f:	75 ef                	jne    80104570 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104581:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104585:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010458c:	75 07                	jne    80104595 <kill+0x45>
        p->state = RUNNABLE;
8010458e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104595:	83 ec 0c             	sub    $0xc,%esp
80104598:	68 20 2d 11 80       	push   $0x80112d20
8010459d:	e8 2e 04 00 00       	call   801049d0 <release>
      return 0;
801045a2:	83 c4 10             	add    $0x10,%esp
801045a5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801045a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045aa:	c9                   	leave  
801045ab:	c3                   	ret    
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801045b0:	83 ec 0c             	sub    $0xc,%esp
801045b3:	68 20 2d 11 80       	push   $0x80112d20
801045b8:	e8 13 04 00 00       	call   801049d0 <release>
  return -1;
801045bd:	83 c4 10             	add    $0x10,%esp
801045c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045c8:	c9                   	leave  
801045c9:	c3                   	ret    
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045d0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	56                   	push   %esi
801045d5:	53                   	push   %ebx
801045d6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045d9:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801045de:	83 ec 3c             	sub    $0x3c,%esp
801045e1:	eb 27                	jmp    8010460a <procdump+0x3a>
801045e3:	90                   	nop
801045e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801045e8:	83 ec 0c             	sub    $0xc,%esp
801045eb:	68 93 7e 10 80       	push   $0x80107e93
801045f0:	e8 6b c0 ff ff       	call   80100660 <cprintf>
801045f5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045f8:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
801045fe:	81 fb 54 e9 11 80    	cmp    $0x8011e954,%ebx
80104604:	0f 83 86 00 00 00    	jae    80104690 <procdump+0xc0>
    if(p->state == UNUSED)
8010460a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010460d:	85 c0                	test   %eax,%eax
8010460f:	74 e7                	je     801045f8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104611:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104614:	ba 00 7b 10 80       	mov    $0x80107b00,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104619:	77 11                	ja     8010462c <procdump+0x5c>
8010461b:	8b 14 85 a0 7b 10 80 	mov    -0x7fef8460(,%eax,4),%edx
      state = "???";
80104622:	b8 00 7b 10 80       	mov    $0x80107b00,%eax
80104627:	85 d2                	test   %edx,%edx
80104629:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010462c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010462f:	50                   	push   %eax
80104630:	52                   	push   %edx
80104631:	ff 73 10             	pushl  0x10(%ebx)
80104634:	68 04 7b 10 80       	push   $0x80107b04
80104639:	e8 22 c0 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010463e:	83 c4 10             	add    $0x10,%esp
80104641:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104645:	75 a1                	jne    801045e8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104647:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010464a:	83 ec 08             	sub    $0x8,%esp
8010464d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104650:	50                   	push   %eax
80104651:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104654:	8b 40 0c             	mov    0xc(%eax),%eax
80104657:	83 c0 08             	add    $0x8,%eax
8010465a:	50                   	push   %eax
8010465b:	e8 90 01 00 00       	call   801047f0 <getcallerpcs>
80104660:	83 c4 10             	add    $0x10,%esp
80104663:	90                   	nop
80104664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104668:	8b 17                	mov    (%edi),%edx
8010466a:	85 d2                	test   %edx,%edx
8010466c:	0f 84 76 ff ff ff    	je     801045e8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104672:	83 ec 08             	sub    $0x8,%esp
80104675:	83 c7 04             	add    $0x4,%edi
80104678:	52                   	push   %edx
80104679:	68 01 75 10 80       	push   $0x80107501
8010467e:	e8 dd bf ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104683:	83 c4 10             	add    $0x10,%esp
80104686:	39 fe                	cmp    %edi,%esi
80104688:	75 de                	jne    80104668 <procdump+0x98>
8010468a:	e9 59 ff ff ff       	jmp    801045e8 <procdump+0x18>
8010468f:	90                   	nop
  }
}
80104690:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104693:	5b                   	pop    %ebx
80104694:	5e                   	pop    %esi
80104695:	5f                   	pop    %edi
80104696:	5d                   	pop    %ebp
80104697:	c3                   	ret    
80104698:	66 90                	xchg   %ax,%ax
8010469a:	66 90                	xchg   %ax,%ax
8010469c:	66 90                	xchg   %ax,%ax
8010469e:	66 90                	xchg   %ax,%ax

801046a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	53                   	push   %ebx
801046a4:	83 ec 0c             	sub    $0xc,%esp
801046a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801046aa:	68 b8 7b 10 80       	push   $0x80107bb8
801046af:	8d 43 04             	lea    0x4(%ebx),%eax
801046b2:	50                   	push   %eax
801046b3:	e8 18 01 00 00       	call   801047d0 <initlock>
  lk->name = name;
801046b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801046bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801046c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801046c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801046cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801046ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046d1:	c9                   	leave  
801046d2:	c3                   	ret    
801046d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
801046e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046e8:	83 ec 0c             	sub    $0xc,%esp
801046eb:	8d 73 04             	lea    0x4(%ebx),%esi
801046ee:	56                   	push   %esi
801046ef:	e8 1c 02 00 00       	call   80104910 <acquire>
  while (lk->locked) {
801046f4:	8b 13                	mov    (%ebx),%edx
801046f6:	83 c4 10             	add    $0x10,%esp
801046f9:	85 d2                	test   %edx,%edx
801046fb:	74 16                	je     80104713 <acquiresleep+0x33>
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104700:	83 ec 08             	sub    $0x8,%esp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
80104705:	e8 26 fc ff ff       	call   80104330 <sleep>
  while (lk->locked) {
8010470a:	8b 03                	mov    (%ebx),%eax
8010470c:	83 c4 10             	add    $0x10,%esp
8010470f:	85 c0                	test   %eax,%eax
80104711:	75 ed                	jne    80104700 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104713:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104719:	e8 e2 f4 ff ff       	call   80103c00 <myproc>
8010471e:	8b 40 10             	mov    0x10(%eax),%eax
80104721:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104724:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104727:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010472a:	5b                   	pop    %ebx
8010472b:	5e                   	pop    %esi
8010472c:	5d                   	pop    %ebp
  release(&lk->lk);
8010472d:	e9 9e 02 00 00       	jmp    801049d0 <release>
80104732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104740 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104748:	83 ec 0c             	sub    $0xc,%esp
8010474b:	8d 73 04             	lea    0x4(%ebx),%esi
8010474e:	56                   	push   %esi
8010474f:	e8 bc 01 00 00       	call   80104910 <acquire>
  lk->locked = 0;
80104754:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010475a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104761:	89 1c 24             	mov    %ebx,(%esp)
80104764:	e8 87 fd ff ff       	call   801044f0 <wakeup>
  release(&lk->lk);
80104769:	89 75 08             	mov    %esi,0x8(%ebp)
8010476c:	83 c4 10             	add    $0x10,%esp
}
8010476f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104772:	5b                   	pop    %ebx
80104773:	5e                   	pop    %esi
80104774:	5d                   	pop    %ebp
  release(&lk->lk);
80104775:	e9 56 02 00 00       	jmp    801049d0 <release>
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104780 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	57                   	push   %edi
80104784:	56                   	push   %esi
80104785:	53                   	push   %ebx
80104786:	31 ff                	xor    %edi,%edi
80104788:	83 ec 18             	sub    $0x18,%esp
8010478b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010478e:	8d 73 04             	lea    0x4(%ebx),%esi
80104791:	56                   	push   %esi
80104792:	e8 79 01 00 00       	call   80104910 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104797:	8b 03                	mov    (%ebx),%eax
80104799:	83 c4 10             	add    $0x10,%esp
8010479c:	85 c0                	test   %eax,%eax
8010479e:	74 13                	je     801047b3 <holdingsleep+0x33>
801047a0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801047a3:	e8 58 f4 ff ff       	call   80103c00 <myproc>
801047a8:	39 58 10             	cmp    %ebx,0x10(%eax)
801047ab:	0f 94 c0             	sete   %al
801047ae:	0f b6 c0             	movzbl %al,%eax
801047b1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801047b3:	83 ec 0c             	sub    $0xc,%esp
801047b6:	56                   	push   %esi
801047b7:	e8 14 02 00 00       	call   801049d0 <release>
  return r;
}
801047bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047bf:	89 f8                	mov    %edi,%eax
801047c1:	5b                   	pop    %ebx
801047c2:	5e                   	pop    %esi
801047c3:	5f                   	pop    %edi
801047c4:	5d                   	pop    %ebp
801047c5:	c3                   	ret    
801047c6:	66 90                	xchg   %ax,%ax
801047c8:	66 90                	xchg   %ax,%ax
801047ca:	66 90                	xchg   %ax,%ax
801047cc:	66 90                	xchg   %ax,%ax
801047ce:	66 90                	xchg   %ax,%ax

801047d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801047d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801047d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801047df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801047e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801047e9:	5d                   	pop    %ebp
801047ea:	c3                   	ret    
801047eb:	90                   	nop
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801047f0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801047f1:	31 d2                	xor    %edx,%edx
{
801047f3:	89 e5                	mov    %esp,%ebp
801047f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801047f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801047f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801047fc:	83 e8 08             	sub    $0x8,%eax
801047ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104800:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104806:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010480c:	77 1a                	ja     80104828 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010480e:	8b 58 04             	mov    0x4(%eax),%ebx
80104811:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104814:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104817:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104819:	83 fa 0a             	cmp    $0xa,%edx
8010481c:	75 e2                	jne    80104800 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010481e:	5b                   	pop    %ebx
8010481f:	5d                   	pop    %ebp
80104820:	c3                   	ret    
80104821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104828:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010482b:	83 c1 28             	add    $0x28,%ecx
8010482e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104830:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104836:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104839:	39 c1                	cmp    %eax,%ecx
8010483b:	75 f3                	jne    80104830 <getcallerpcs+0x40>
}
8010483d:	5b                   	pop    %ebx
8010483e:	5d                   	pop    %ebp
8010483f:	c3                   	ret    

80104840 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	53                   	push   %ebx
80104844:	83 ec 04             	sub    $0x4,%esp
80104847:	9c                   	pushf  
80104848:	5b                   	pop    %ebx
  asm volatile("cli");
80104849:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010484a:	e8 11 f3 ff ff       	call   80103b60 <mycpu>
8010484f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104855:	85 c0                	test   %eax,%eax
80104857:	75 11                	jne    8010486a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104859:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010485f:	e8 fc f2 ff ff       	call   80103b60 <mycpu>
80104864:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010486a:	e8 f1 f2 ff ff       	call   80103b60 <mycpu>
8010486f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104876:	83 c4 04             	add    $0x4,%esp
80104879:	5b                   	pop    %ebx
8010487a:	5d                   	pop    %ebp
8010487b:	c3                   	ret    
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104880 <popcli>:

void
popcli(void)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104886:	9c                   	pushf  
80104887:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104888:	f6 c4 02             	test   $0x2,%ah
8010488b:	75 35                	jne    801048c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010488d:	e8 ce f2 ff ff       	call   80103b60 <mycpu>
80104892:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104899:	78 34                	js     801048cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010489b:	e8 c0 f2 ff ff       	call   80103b60 <mycpu>
801048a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801048a6:	85 d2                	test   %edx,%edx
801048a8:	74 06                	je     801048b0 <popcli+0x30>
    sti();
}
801048aa:	c9                   	leave  
801048ab:	c3                   	ret    
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048b0:	e8 ab f2 ff ff       	call   80103b60 <mycpu>
801048b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801048bb:	85 c0                	test   %eax,%eax
801048bd:	74 eb                	je     801048aa <popcli+0x2a>
  asm volatile("sti");
801048bf:	fb                   	sti    
}
801048c0:	c9                   	leave  
801048c1:	c3                   	ret    
    panic("popcli - interruptible");
801048c2:	83 ec 0c             	sub    $0xc,%esp
801048c5:	68 c3 7b 10 80       	push   $0x80107bc3
801048ca:	e8 c1 ba ff ff       	call   80100390 <panic>
    panic("popcli");
801048cf:	83 ec 0c             	sub    $0xc,%esp
801048d2:	68 da 7b 10 80       	push   $0x80107bda
801048d7:	e8 b4 ba ff ff       	call   80100390 <panic>
801048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048e0 <holding>:
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	8b 75 08             	mov    0x8(%ebp),%esi
801048e8:	31 db                	xor    %ebx,%ebx
  pushcli();
801048ea:	e8 51 ff ff ff       	call   80104840 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048ef:	8b 06                	mov    (%esi),%eax
801048f1:	85 c0                	test   %eax,%eax
801048f3:	74 10                	je     80104905 <holding+0x25>
801048f5:	8b 5e 08             	mov    0x8(%esi),%ebx
801048f8:	e8 63 f2 ff ff       	call   80103b60 <mycpu>
801048fd:	39 c3                	cmp    %eax,%ebx
801048ff:	0f 94 c3             	sete   %bl
80104902:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104905:	e8 76 ff ff ff       	call   80104880 <popcli>
}
8010490a:	89 d8                	mov    %ebx,%eax
8010490c:	5b                   	pop    %ebx
8010490d:	5e                   	pop    %esi
8010490e:	5d                   	pop    %ebp
8010490f:	c3                   	ret    

80104910 <acquire>:
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	56                   	push   %esi
80104914:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104915:	e8 26 ff ff ff       	call   80104840 <pushcli>
  if(holding(lk))
8010491a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010491d:	83 ec 0c             	sub    $0xc,%esp
80104920:	53                   	push   %ebx
80104921:	e8 ba ff ff ff       	call   801048e0 <holding>
80104926:	83 c4 10             	add    $0x10,%esp
80104929:	85 c0                	test   %eax,%eax
8010492b:	0f 85 83 00 00 00    	jne    801049b4 <acquire+0xa4>
80104931:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104933:	ba 01 00 00 00       	mov    $0x1,%edx
80104938:	eb 09                	jmp    80104943 <acquire+0x33>
8010493a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104940:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104943:	89 d0                	mov    %edx,%eax
80104945:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104948:	85 c0                	test   %eax,%eax
8010494a:	75 f4                	jne    80104940 <acquire+0x30>
  __sync_synchronize();
8010494c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104954:	e8 07 f2 ff ff       	call   80103b60 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104959:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010495c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010495f:	89 e8                	mov    %ebp,%eax
80104961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104968:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010496e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104974:	77 1a                	ja     80104990 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104976:	8b 48 04             	mov    0x4(%eax),%ecx
80104979:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010497c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010497f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104981:	83 fe 0a             	cmp    $0xa,%esi
80104984:	75 e2                	jne    80104968 <acquire+0x58>
}
80104986:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104989:	5b                   	pop    %ebx
8010498a:	5e                   	pop    %esi
8010498b:	5d                   	pop    %ebp
8010498c:	c3                   	ret    
8010498d:	8d 76 00             	lea    0x0(%esi),%esi
80104990:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104993:	83 c2 28             	add    $0x28,%edx
80104996:	8d 76 00             	lea    0x0(%esi),%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801049a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801049a6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801049a9:	39 d0                	cmp    %edx,%eax
801049ab:	75 f3                	jne    801049a0 <acquire+0x90>
}
801049ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049b0:	5b                   	pop    %ebx
801049b1:	5e                   	pop    %esi
801049b2:	5d                   	pop    %ebp
801049b3:	c3                   	ret    
    panic("acquire");
801049b4:	83 ec 0c             	sub    $0xc,%esp
801049b7:	68 e1 7b 10 80       	push   $0x80107be1
801049bc:	e8 cf b9 ff ff       	call   80100390 <panic>
801049c1:	eb 0d                	jmp    801049d0 <release>
801049c3:	90                   	nop
801049c4:	90                   	nop
801049c5:	90                   	nop
801049c6:	90                   	nop
801049c7:	90                   	nop
801049c8:	90                   	nop
801049c9:	90                   	nop
801049ca:	90                   	nop
801049cb:	90                   	nop
801049cc:	90                   	nop
801049cd:	90                   	nop
801049ce:	90                   	nop
801049cf:	90                   	nop

801049d0 <release>:
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	53                   	push   %ebx
801049d4:	83 ec 10             	sub    $0x10,%esp
801049d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801049da:	53                   	push   %ebx
801049db:	e8 00 ff ff ff       	call   801048e0 <holding>
801049e0:	83 c4 10             	add    $0x10,%esp
801049e3:	85 c0                	test   %eax,%eax
801049e5:	74 22                	je     80104a09 <release+0x39>
  lk->pcs[0] = 0;
801049e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801049ee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801049f5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801049fa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a03:	c9                   	leave  
  popcli();
80104a04:	e9 77 fe ff ff       	jmp    80104880 <popcli>
    panic("release");
80104a09:	83 ec 0c             	sub    $0xc,%esp
80104a0c:	68 e9 7b 10 80       	push   $0x80107be9
80104a11:	e8 7a b9 ff ff       	call   80100390 <panic>
80104a16:	66 90                	xchg   %ax,%ax
80104a18:	66 90                	xchg   %ax,%ax
80104a1a:	66 90                	xchg   %ax,%ax
80104a1c:	66 90                	xchg   %ax,%ax
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	57                   	push   %edi
80104a24:	53                   	push   %ebx
80104a25:	8b 55 08             	mov    0x8(%ebp),%edx
80104a28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104a2b:	f6 c2 03             	test   $0x3,%dl
80104a2e:	75 05                	jne    80104a35 <memset+0x15>
80104a30:	f6 c1 03             	test   $0x3,%cl
80104a33:	74 13                	je     80104a48 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104a35:	89 d7                	mov    %edx,%edi
80104a37:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a3a:	fc                   	cld    
80104a3b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a3d:	5b                   	pop    %ebx
80104a3e:	89 d0                	mov    %edx,%eax
80104a40:	5f                   	pop    %edi
80104a41:	5d                   	pop    %ebp
80104a42:	c3                   	ret    
80104a43:	90                   	nop
80104a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104a48:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a4c:	c1 e9 02             	shr    $0x2,%ecx
80104a4f:	89 f8                	mov    %edi,%eax
80104a51:	89 fb                	mov    %edi,%ebx
80104a53:	c1 e0 18             	shl    $0x18,%eax
80104a56:	c1 e3 10             	shl    $0x10,%ebx
80104a59:	09 d8                	or     %ebx,%eax
80104a5b:	09 f8                	or     %edi,%eax
80104a5d:	c1 e7 08             	shl    $0x8,%edi
80104a60:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104a62:	89 d7                	mov    %edx,%edi
80104a64:	fc                   	cld    
80104a65:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104a67:	5b                   	pop    %ebx
80104a68:	89 d0                	mov    %edx,%eax
80104a6a:	5f                   	pop    %edi
80104a6b:	5d                   	pop    %ebp
80104a6c:	c3                   	ret    
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi

80104a70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	56                   	push   %esi
80104a75:	53                   	push   %ebx
80104a76:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a79:	8b 75 08             	mov    0x8(%ebp),%esi
80104a7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a7f:	85 db                	test   %ebx,%ebx
80104a81:	74 29                	je     80104aac <memcmp+0x3c>
    if(*s1 != *s2)
80104a83:	0f b6 16             	movzbl (%esi),%edx
80104a86:	0f b6 0f             	movzbl (%edi),%ecx
80104a89:	38 d1                	cmp    %dl,%cl
80104a8b:	75 2b                	jne    80104ab8 <memcmp+0x48>
80104a8d:	b8 01 00 00 00       	mov    $0x1,%eax
80104a92:	eb 14                	jmp    80104aa8 <memcmp+0x38>
80104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a98:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104a9c:	83 c0 01             	add    $0x1,%eax
80104a9f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104aa4:	38 ca                	cmp    %cl,%dl
80104aa6:	75 10                	jne    80104ab8 <memcmp+0x48>
  while(n-- > 0){
80104aa8:	39 d8                	cmp    %ebx,%eax
80104aaa:	75 ec                	jne    80104a98 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104aac:	5b                   	pop    %ebx
  return 0;
80104aad:	31 c0                	xor    %eax,%eax
}
80104aaf:	5e                   	pop    %esi
80104ab0:	5f                   	pop    %edi
80104ab1:	5d                   	pop    %ebp
80104ab2:	c3                   	ret    
80104ab3:	90                   	nop
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104ab8:	0f b6 c2             	movzbl %dl,%eax
}
80104abb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104abc:	29 c8                	sub    %ecx,%eax
}
80104abe:	5e                   	pop    %esi
80104abf:	5f                   	pop    %edi
80104ac0:	5d                   	pop    %ebp
80104ac1:	c3                   	ret    
80104ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ad8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104adb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ade:	39 c3                	cmp    %eax,%ebx
80104ae0:	73 26                	jae    80104b08 <memmove+0x38>
80104ae2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104ae5:	39 c8                	cmp    %ecx,%eax
80104ae7:	73 1f                	jae    80104b08 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104ae9:	85 f6                	test   %esi,%esi
80104aeb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104aee:	74 0f                	je     80104aff <memmove+0x2f>
      *--d = *--s;
80104af0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104af4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104af7:	83 ea 01             	sub    $0x1,%edx
80104afa:	83 fa ff             	cmp    $0xffffffff,%edx
80104afd:	75 f1                	jne    80104af0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104aff:	5b                   	pop    %ebx
80104b00:	5e                   	pop    %esi
80104b01:	5d                   	pop    %ebp
80104b02:	c3                   	ret    
80104b03:	90                   	nop
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104b08:	31 d2                	xor    %edx,%edx
80104b0a:	85 f6                	test   %esi,%esi
80104b0c:	74 f1                	je     80104aff <memmove+0x2f>
80104b0e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104b10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b17:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104b1a:	39 d6                	cmp    %edx,%esi
80104b1c:	75 f2                	jne    80104b10 <memmove+0x40>
}
80104b1e:	5b                   	pop    %ebx
80104b1f:	5e                   	pop    %esi
80104b20:	5d                   	pop    %ebp
80104b21:	c3                   	ret    
80104b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b30 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104b33:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104b34:	eb 9a                	jmp    80104ad0 <memmove>
80104b36:	8d 76 00             	lea    0x0(%esi),%esi
80104b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b40 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	56                   	push   %esi
80104b45:	8b 7d 10             	mov    0x10(%ebp),%edi
80104b48:	53                   	push   %ebx
80104b49:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104b4f:	85 ff                	test   %edi,%edi
80104b51:	74 2f                	je     80104b82 <strncmp+0x42>
80104b53:	0f b6 01             	movzbl (%ecx),%eax
80104b56:	0f b6 1e             	movzbl (%esi),%ebx
80104b59:	84 c0                	test   %al,%al
80104b5b:	74 37                	je     80104b94 <strncmp+0x54>
80104b5d:	38 c3                	cmp    %al,%bl
80104b5f:	75 33                	jne    80104b94 <strncmp+0x54>
80104b61:	01 f7                	add    %esi,%edi
80104b63:	eb 13                	jmp    80104b78 <strncmp+0x38>
80104b65:	8d 76 00             	lea    0x0(%esi),%esi
80104b68:	0f b6 01             	movzbl (%ecx),%eax
80104b6b:	84 c0                	test   %al,%al
80104b6d:	74 21                	je     80104b90 <strncmp+0x50>
80104b6f:	0f b6 1a             	movzbl (%edx),%ebx
80104b72:	89 d6                	mov    %edx,%esi
80104b74:	38 d8                	cmp    %bl,%al
80104b76:	75 1c                	jne    80104b94 <strncmp+0x54>
    n--, p++, q++;
80104b78:	8d 56 01             	lea    0x1(%esi),%edx
80104b7b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104b7e:	39 fa                	cmp    %edi,%edx
80104b80:	75 e6                	jne    80104b68 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104b82:	5b                   	pop    %ebx
    return 0;
80104b83:	31 c0                	xor    %eax,%eax
}
80104b85:	5e                   	pop    %esi
80104b86:	5f                   	pop    %edi
80104b87:	5d                   	pop    %ebp
80104b88:	c3                   	ret    
80104b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b90:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104b94:	29 d8                	sub    %ebx,%eax
}
80104b96:	5b                   	pop    %ebx
80104b97:	5e                   	pop    %esi
80104b98:	5f                   	pop    %edi
80104b99:	5d                   	pop    %ebp
80104b9a:	c3                   	ret    
80104b9b:	90                   	nop
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ba0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	56                   	push   %esi
80104ba4:	53                   	push   %ebx
80104ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ba8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104bab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104bae:	89 c2                	mov    %eax,%edx
80104bb0:	eb 19                	jmp    80104bcb <strncpy+0x2b>
80104bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bb8:	83 c3 01             	add    $0x1,%ebx
80104bbb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104bbf:	83 c2 01             	add    $0x1,%edx
80104bc2:	84 c9                	test   %cl,%cl
80104bc4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104bc7:	74 09                	je     80104bd2 <strncpy+0x32>
80104bc9:	89 f1                	mov    %esi,%ecx
80104bcb:	85 c9                	test   %ecx,%ecx
80104bcd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104bd0:	7f e6                	jg     80104bb8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104bd2:	31 c9                	xor    %ecx,%ecx
80104bd4:	85 f6                	test   %esi,%esi
80104bd6:	7e 17                	jle    80104bef <strncpy+0x4f>
80104bd8:	90                   	nop
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104be0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104be4:	89 f3                	mov    %esi,%ebx
80104be6:	83 c1 01             	add    $0x1,%ecx
80104be9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104beb:	85 db                	test   %ebx,%ebx
80104bed:	7f f1                	jg     80104be0 <strncpy+0x40>
  return os;
}
80104bef:	5b                   	pop    %ebx
80104bf0:	5e                   	pop    %esi
80104bf1:	5d                   	pop    %ebp
80104bf2:	c3                   	ret    
80104bf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	56                   	push   %esi
80104c04:	53                   	push   %ebx
80104c05:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c08:	8b 45 08             	mov    0x8(%ebp),%eax
80104c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c0e:	85 c9                	test   %ecx,%ecx
80104c10:	7e 26                	jle    80104c38 <safestrcpy+0x38>
80104c12:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104c16:	89 c1                	mov    %eax,%ecx
80104c18:	eb 17                	jmp    80104c31 <safestrcpy+0x31>
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104c20:	83 c2 01             	add    $0x1,%edx
80104c23:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104c27:	83 c1 01             	add    $0x1,%ecx
80104c2a:	84 db                	test   %bl,%bl
80104c2c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104c2f:	74 04                	je     80104c35 <safestrcpy+0x35>
80104c31:	39 f2                	cmp    %esi,%edx
80104c33:	75 eb                	jne    80104c20 <safestrcpy+0x20>
    ;
  *s = 0;
80104c35:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104c38:	5b                   	pop    %ebx
80104c39:	5e                   	pop    %esi
80104c3a:	5d                   	pop    %ebp
80104c3b:	c3                   	ret    
80104c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c40 <strlen>:

int
strlen(const char *s)
{
80104c40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c41:	31 c0                	xor    %eax,%eax
{
80104c43:	89 e5                	mov    %esp,%ebp
80104c45:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c48:	80 3a 00             	cmpb   $0x0,(%edx)
80104c4b:	74 0c                	je     80104c59 <strlen+0x19>
80104c4d:	8d 76 00             	lea    0x0(%esi),%esi
80104c50:	83 c0 01             	add    $0x1,%eax
80104c53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c57:	75 f7                	jne    80104c50 <strlen+0x10>
    ;
  return n;
}
80104c59:	5d                   	pop    %ebp
80104c5a:	c3                   	ret    

80104c5b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104c63:	55                   	push   %ebp
  pushl %ebx
80104c64:	53                   	push   %ebx
  pushl %esi
80104c65:	56                   	push   %esi
  pushl %edi
80104c66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c69:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104c6b:	5f                   	pop    %edi
  popl %esi
80104c6c:	5e                   	pop    %esi
  popl %ebx
80104c6d:	5b                   	pop    %ebx
  popl %ebp
80104c6e:	5d                   	pop    %ebp
  ret
80104c6f:	c3                   	ret    

80104c70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	53                   	push   %ebx
80104c74:	83 ec 04             	sub    $0x4,%esp
80104c77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c7a:	e8 81 ef ff ff       	call   80103c00 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c7f:	8b 00                	mov    (%eax),%eax
80104c81:	39 d8                	cmp    %ebx,%eax
80104c83:	76 1b                	jbe    80104ca0 <fetchint+0x30>
80104c85:	8d 53 04             	lea    0x4(%ebx),%edx
80104c88:	39 d0                	cmp    %edx,%eax
80104c8a:	72 14                	jb     80104ca0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c8f:	8b 13                	mov    (%ebx),%edx
80104c91:	89 10                	mov    %edx,(%eax)
  return 0;
80104c93:	31 c0                	xor    %eax,%eax
}
80104c95:	83 c4 04             	add    $0x4,%esp
80104c98:	5b                   	pop    %ebx
80104c99:	5d                   	pop    %ebp
80104c9a:	c3                   	ret    
80104c9b:	90                   	nop
80104c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ca5:	eb ee                	jmp    80104c95 <fetchint+0x25>
80104ca7:	89 f6                	mov    %esi,%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	53                   	push   %ebx
80104cb4:	83 ec 04             	sub    $0x4,%esp
80104cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104cba:	e8 41 ef ff ff       	call   80103c00 <myproc>

  if(addr >= curproc->sz)
80104cbf:	39 18                	cmp    %ebx,(%eax)
80104cc1:	76 29                	jbe    80104cec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104cc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104cc6:	89 da                	mov    %ebx,%edx
80104cc8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104cca:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104ccc:	39 c3                	cmp    %eax,%ebx
80104cce:	73 1c                	jae    80104cec <fetchstr+0x3c>
    if(*s == 0)
80104cd0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104cd3:	75 10                	jne    80104ce5 <fetchstr+0x35>
80104cd5:	eb 39                	jmp    80104d10 <fetchstr+0x60>
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ce0:	80 3a 00             	cmpb   $0x0,(%edx)
80104ce3:	74 1b                	je     80104d00 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104ce5:	83 c2 01             	add    $0x1,%edx
80104ce8:	39 d0                	cmp    %edx,%eax
80104cea:	77 f4                	ja     80104ce0 <fetchstr+0x30>
    return -1;
80104cec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104cf1:	83 c4 04             	add    $0x4,%esp
80104cf4:	5b                   	pop    %ebx
80104cf5:	5d                   	pop    %ebp
80104cf6:	c3                   	ret    
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d00:	83 c4 04             	add    $0x4,%esp
80104d03:	89 d0                	mov    %edx,%eax
80104d05:	29 d8                	sub    %ebx,%eax
80104d07:	5b                   	pop    %ebx
80104d08:	5d                   	pop    %ebp
80104d09:	c3                   	ret    
80104d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104d10:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104d12:	eb dd                	jmp    80104cf1 <fetchstr+0x41>
80104d14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104d20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d25:	e8 d6 ee ff ff       	call   80103c00 <myproc>
80104d2a:	8b 40 18             	mov    0x18(%eax),%eax
80104d2d:	8b 55 08             	mov    0x8(%ebp),%edx
80104d30:	8b 40 44             	mov    0x44(%eax),%eax
80104d33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d36:	e8 c5 ee ff ff       	call   80103c00 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d3b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d3d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d40:	39 c6                	cmp    %eax,%esi
80104d42:	73 1c                	jae    80104d60 <argint+0x40>
80104d44:	8d 53 08             	lea    0x8(%ebx),%edx
80104d47:	39 d0                	cmp    %edx,%eax
80104d49:	72 15                	jb     80104d60 <argint+0x40>
  *ip = *(int*)(addr);
80104d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104d51:	89 10                	mov    %edx,(%eax)
  return 0;
80104d53:	31 c0                	xor    %eax,%eax
}
80104d55:	5b                   	pop    %ebx
80104d56:	5e                   	pop    %esi
80104d57:	5d                   	pop    %ebp
80104d58:	c3                   	ret    
80104d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d65:	eb ee                	jmp    80104d55 <argint+0x35>
80104d67:	89 f6                	mov    %esi,%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
80104d75:	83 ec 10             	sub    $0x10,%esp
80104d78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104d7b:	e8 80 ee ff ff       	call   80103c00 <myproc>
80104d80:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104d82:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d85:	83 ec 08             	sub    $0x8,%esp
80104d88:	50                   	push   %eax
80104d89:	ff 75 08             	pushl  0x8(%ebp)
80104d8c:	e8 8f ff ff ff       	call   80104d20 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d91:	83 c4 10             	add    $0x10,%esp
80104d94:	85 c0                	test   %eax,%eax
80104d96:	78 28                	js     80104dc0 <argptr+0x50>
80104d98:	85 db                	test   %ebx,%ebx
80104d9a:	78 24                	js     80104dc0 <argptr+0x50>
80104d9c:	8b 16                	mov    (%esi),%edx
80104d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da1:	39 c2                	cmp    %eax,%edx
80104da3:	76 1b                	jbe    80104dc0 <argptr+0x50>
80104da5:	01 c3                	add    %eax,%ebx
80104da7:	39 da                	cmp    %ebx,%edx
80104da9:	72 15                	jb     80104dc0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104dab:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dae:	89 02                	mov    %eax,(%edx)
  return 0;
80104db0:	31 c0                	xor    %eax,%eax
}
80104db2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104db5:	5b                   	pop    %ebx
80104db6:	5e                   	pop    %esi
80104db7:	5d                   	pop    %ebp
80104db8:	c3                   	ret    
80104db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc5:	eb eb                	jmp    80104db2 <argptr+0x42>
80104dc7:	89 f6                	mov    %esi,%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104dd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dd9:	50                   	push   %eax
80104dda:	ff 75 08             	pushl  0x8(%ebp)
80104ddd:	e8 3e ff ff ff       	call   80104d20 <argint>
80104de2:	83 c4 10             	add    $0x10,%esp
80104de5:	85 c0                	test   %eax,%eax
80104de7:	78 17                	js     80104e00 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104de9:	83 ec 08             	sub    $0x8,%esp
80104dec:	ff 75 0c             	pushl  0xc(%ebp)
80104def:	ff 75 f4             	pushl  -0xc(%ebp)
80104df2:	e8 b9 fe ff ff       	call   80104cb0 <fetchstr>
80104df7:	83 c4 10             	add    $0x10,%esp
}
80104dfa:	c9                   	leave  
80104dfb:	c3                   	ret    
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e05:	c9                   	leave  
80104e06:	c3                   	ret    
80104e07:	89 f6                	mov    %esi,%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	53                   	push   %ebx
80104e14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104e17:	e8 e4 ed ff ff       	call   80103c00 <myproc>
80104e1c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104e1e:	8b 40 18             	mov    0x18(%eax),%eax
80104e21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e27:	83 fa 14             	cmp    $0x14,%edx
80104e2a:	77 1c                	ja     80104e48 <syscall+0x38>
80104e2c:	8b 14 85 20 7c 10 80 	mov    -0x7fef83e0(,%eax,4),%edx
80104e33:	85 d2                	test   %edx,%edx
80104e35:	74 11                	je     80104e48 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104e37:	ff d2                	call   *%edx
80104e39:	8b 53 18             	mov    0x18(%ebx),%edx
80104e3c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e42:	c9                   	leave  
80104e43:	c3                   	ret    
80104e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e48:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e49:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e4c:	50                   	push   %eax
80104e4d:	ff 73 10             	pushl  0x10(%ebx)
80104e50:	68 f1 7b 10 80       	push   $0x80107bf1
80104e55:	e8 06 b8 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104e5a:	8b 43 18             	mov    0x18(%ebx),%eax
80104e5d:	83 c4 10             	add    $0x10,%esp
80104e60:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e6a:	c9                   	leave  
80104e6b:	c3                   	ret    
80104e6c:	66 90                	xchg   %ax,%ax
80104e6e:	66 90                	xchg   %ax,%ax

80104e70 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
80104e75:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104e77:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104e7a:	89 d6                	mov    %edx,%esi
80104e7c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e7f:	50                   	push   %eax
80104e80:	6a 00                	push   $0x0
80104e82:	e8 99 fe ff ff       	call   80104d20 <argint>
80104e87:	83 c4 10             	add    $0x10,%esp
80104e8a:	85 c0                	test   %eax,%eax
80104e8c:	78 2a                	js     80104eb8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e8e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e92:	77 24                	ja     80104eb8 <argfd.constprop.0+0x48>
80104e94:	e8 67 ed ff ff       	call   80103c00 <myproc>
80104e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e9c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104ea0:	85 c0                	test   %eax,%eax
80104ea2:	74 14                	je     80104eb8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80104ea4:	85 db                	test   %ebx,%ebx
80104ea6:	74 02                	je     80104eaa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104ea8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
80104eaa:	89 06                	mov    %eax,(%esi)
  return 0;
80104eac:	31 c0                	xor    %eax,%eax
}
80104eae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eb1:	5b                   	pop    %ebx
80104eb2:	5e                   	pop    %esi
80104eb3:	5d                   	pop    %ebp
80104eb4:	c3                   	ret    
80104eb5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ebd:	eb ef                	jmp    80104eae <argfd.constprop.0+0x3e>
80104ebf:	90                   	nop

80104ec0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104ec0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ec1:	31 c0                	xor    %eax,%eax
{
80104ec3:	89 e5                	mov    %esp,%ebp
80104ec5:	56                   	push   %esi
80104ec6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104ec7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104eca:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104ecd:	e8 9e ff ff ff       	call   80104e70 <argfd.constprop.0>
80104ed2:	85 c0                	test   %eax,%eax
80104ed4:	78 42                	js     80104f18 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104ed6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104ed9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104edb:	e8 20 ed ff ff       	call   80103c00 <myproc>
80104ee0:	eb 0e                	jmp    80104ef0 <sys_dup+0x30>
80104ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104ee8:	83 c3 01             	add    $0x1,%ebx
80104eeb:	83 fb 10             	cmp    $0x10,%ebx
80104eee:	74 28                	je     80104f18 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104ef0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ef4:	85 d2                	test   %edx,%edx
80104ef6:	75 f0                	jne    80104ee8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104ef8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
80104efc:	83 ec 0c             	sub    $0xc,%esp
80104eff:	ff 75 f4             	pushl  -0xc(%ebp)
80104f02:	e8 e9 be ff ff       	call   80100df0 <filedup>
  return fd;
80104f07:	83 c4 10             	add    $0x10,%esp
}
80104f0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f0d:	89 d8                	mov    %ebx,%eax
80104f0f:	5b                   	pop    %ebx
80104f10:	5e                   	pop    %esi
80104f11:	5d                   	pop    %ebp
80104f12:	c3                   	ret    
80104f13:	90                   	nop
80104f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f18:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f1b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f20:	89 d8                	mov    %ebx,%eax
80104f22:	5b                   	pop    %ebx
80104f23:	5e                   	pop    %esi
80104f24:	5d                   	pop    %ebp
80104f25:	c3                   	ret    
80104f26:	8d 76 00             	lea    0x0(%esi),%esi
80104f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f30 <sys_read>:

int
sys_read(void)
{
80104f30:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f31:	31 c0                	xor    %eax,%eax
{
80104f33:	89 e5                	mov    %esp,%ebp
80104f35:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f3b:	e8 30 ff ff ff       	call   80104e70 <argfd.constprop.0>
80104f40:	85 c0                	test   %eax,%eax
80104f42:	78 4c                	js     80104f90 <sys_read+0x60>
80104f44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f47:	83 ec 08             	sub    $0x8,%esp
80104f4a:	50                   	push   %eax
80104f4b:	6a 02                	push   $0x2
80104f4d:	e8 ce fd ff ff       	call   80104d20 <argint>
80104f52:	83 c4 10             	add    $0x10,%esp
80104f55:	85 c0                	test   %eax,%eax
80104f57:	78 37                	js     80104f90 <sys_read+0x60>
80104f59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f5c:	83 ec 04             	sub    $0x4,%esp
80104f5f:	ff 75 f0             	pushl  -0x10(%ebp)
80104f62:	50                   	push   %eax
80104f63:	6a 01                	push   $0x1
80104f65:	e8 06 fe ff ff       	call   80104d70 <argptr>
80104f6a:	83 c4 10             	add    $0x10,%esp
80104f6d:	85 c0                	test   %eax,%eax
80104f6f:	78 1f                	js     80104f90 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104f71:	83 ec 04             	sub    $0x4,%esp
80104f74:	ff 75 f0             	pushl  -0x10(%ebp)
80104f77:	ff 75 f4             	pushl  -0xc(%ebp)
80104f7a:	ff 75 ec             	pushl  -0x14(%ebp)
80104f7d:	e8 de bf ff ff       	call   80100f60 <fileread>
80104f82:	83 c4 10             	add    $0x10,%esp
}
80104f85:	c9                   	leave  
80104f86:	c3                   	ret    
80104f87:	89 f6                	mov    %esi,%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f95:	c9                   	leave  
80104f96:	c3                   	ret    
80104f97:	89 f6                	mov    %esi,%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fa0 <sys_write>:

int
sys_write(void)
{
80104fa0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fa1:	31 c0                	xor    %eax,%eax
{
80104fa3:	89 e5                	mov    %esp,%ebp
80104fa5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fa8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104fab:	e8 c0 fe ff ff       	call   80104e70 <argfd.constprop.0>
80104fb0:	85 c0                	test   %eax,%eax
80104fb2:	78 4c                	js     80105000 <sys_write+0x60>
80104fb4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fb7:	83 ec 08             	sub    $0x8,%esp
80104fba:	50                   	push   %eax
80104fbb:	6a 02                	push   $0x2
80104fbd:	e8 5e fd ff ff       	call   80104d20 <argint>
80104fc2:	83 c4 10             	add    $0x10,%esp
80104fc5:	85 c0                	test   %eax,%eax
80104fc7:	78 37                	js     80105000 <sys_write+0x60>
80104fc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fcc:	83 ec 04             	sub    $0x4,%esp
80104fcf:	ff 75 f0             	pushl  -0x10(%ebp)
80104fd2:	50                   	push   %eax
80104fd3:	6a 01                	push   $0x1
80104fd5:	e8 96 fd ff ff       	call   80104d70 <argptr>
80104fda:	83 c4 10             	add    $0x10,%esp
80104fdd:	85 c0                	test   %eax,%eax
80104fdf:	78 1f                	js     80105000 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104fe1:	83 ec 04             	sub    $0x4,%esp
80104fe4:	ff 75 f0             	pushl  -0x10(%ebp)
80104fe7:	ff 75 f4             	pushl  -0xc(%ebp)
80104fea:	ff 75 ec             	pushl  -0x14(%ebp)
80104fed:	e8 fe bf ff ff       	call   80100ff0 <filewrite>
80104ff2:	83 c4 10             	add    $0x10,%esp
}
80104ff5:	c9                   	leave  
80104ff6:	c3                   	ret    
80104ff7:	89 f6                	mov    %esi,%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105005:	c9                   	leave  
80105006:	c3                   	ret    
80105007:	89 f6                	mov    %esi,%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <sys_close>:

int
sys_close(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105016:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105019:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010501c:	e8 4f fe ff ff       	call   80104e70 <argfd.constprop.0>
80105021:	85 c0                	test   %eax,%eax
80105023:	78 2b                	js     80105050 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105025:	e8 d6 eb ff ff       	call   80103c00 <myproc>
8010502a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010502d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105030:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105037:	00 
  fileclose(f);
80105038:	ff 75 f4             	pushl  -0xc(%ebp)
8010503b:	e8 00 be ff ff       	call   80100e40 <fileclose>
  return 0;
80105040:	83 c4 10             	add    $0x10,%esp
80105043:	31 c0                	xor    %eax,%eax
}
80105045:	c9                   	leave  
80105046:	c3                   	ret    
80105047:	89 f6                	mov    %esi,%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105055:	c9                   	leave  
80105056:	c3                   	ret    
80105057:	89 f6                	mov    %esi,%esi
80105059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105060 <sys_fstat>:

int
sys_fstat(void)
{
80105060:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105061:	31 c0                	xor    %eax,%eax
{
80105063:	89 e5                	mov    %esp,%ebp
80105065:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105068:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010506b:	e8 00 fe ff ff       	call   80104e70 <argfd.constprop.0>
80105070:	85 c0                	test   %eax,%eax
80105072:	78 2c                	js     801050a0 <sys_fstat+0x40>
80105074:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105077:	83 ec 04             	sub    $0x4,%esp
8010507a:	6a 14                	push   $0x14
8010507c:	50                   	push   %eax
8010507d:	6a 01                	push   $0x1
8010507f:	e8 ec fc ff ff       	call   80104d70 <argptr>
80105084:	83 c4 10             	add    $0x10,%esp
80105087:	85 c0                	test   %eax,%eax
80105089:	78 15                	js     801050a0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010508b:	83 ec 08             	sub    $0x8,%esp
8010508e:	ff 75 f4             	pushl  -0xc(%ebp)
80105091:	ff 75 f0             	pushl  -0x10(%ebp)
80105094:	e8 77 be ff ff       	call   80100f10 <filestat>
80105099:	83 c4 10             	add    $0x10,%esp
}
8010509c:	c9                   	leave  
8010509d:	c3                   	ret    
8010509e:	66 90                	xchg   %ax,%ax
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050a5:	c9                   	leave  
801050a6:	c3                   	ret    
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050b0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	57                   	push   %edi
801050b4:	56                   	push   %esi
801050b5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050b6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050bc:	50                   	push   %eax
801050bd:	6a 00                	push   $0x0
801050bf:	e8 0c fd ff ff       	call   80104dd0 <argstr>
801050c4:	83 c4 10             	add    $0x10,%esp
801050c7:	85 c0                	test   %eax,%eax
801050c9:	0f 88 fb 00 00 00    	js     801051ca <sys_link+0x11a>
801050cf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050d2:	83 ec 08             	sub    $0x8,%esp
801050d5:	50                   	push   %eax
801050d6:	6a 01                	push   $0x1
801050d8:	e8 f3 fc ff ff       	call   80104dd0 <argstr>
801050dd:	83 c4 10             	add    $0x10,%esp
801050e0:	85 c0                	test   %eax,%eax
801050e2:	0f 88 e2 00 00 00    	js     801051ca <sys_link+0x11a>
    return -1;

  begin_op();
801050e8:	e8 43 de ff ff       	call   80102f30 <begin_op>
  if((ip = namei(old)) == 0){
801050ed:	83 ec 0c             	sub    $0xc,%esp
801050f0:	ff 75 d4             	pushl  -0x2c(%ebp)
801050f3:	e8 e8 cd ff ff       	call   80101ee0 <namei>
801050f8:	83 c4 10             	add    $0x10,%esp
801050fb:	85 c0                	test   %eax,%eax
801050fd:	89 c3                	mov    %eax,%ebx
801050ff:	0f 84 ea 00 00 00    	je     801051ef <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105105:	83 ec 0c             	sub    $0xc,%esp
80105108:	50                   	push   %eax
80105109:	e8 72 c5 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105116:	0f 84 bb 00 00 00    	je     801051d7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010511c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105121:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105124:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105127:	53                   	push   %ebx
80105128:	e8 a3 c4 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
8010512d:	89 1c 24             	mov    %ebx,(%esp)
80105130:	e8 2b c6 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105135:	58                   	pop    %eax
80105136:	5a                   	pop    %edx
80105137:	57                   	push   %edi
80105138:	ff 75 d0             	pushl  -0x30(%ebp)
8010513b:	e8 c0 cd ff ff       	call   80101f00 <nameiparent>
80105140:	83 c4 10             	add    $0x10,%esp
80105143:	85 c0                	test   %eax,%eax
80105145:	89 c6                	mov    %eax,%esi
80105147:	74 5b                	je     801051a4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105149:	83 ec 0c             	sub    $0xc,%esp
8010514c:	50                   	push   %eax
8010514d:	e8 2e c5 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105152:	83 c4 10             	add    $0x10,%esp
80105155:	8b 03                	mov    (%ebx),%eax
80105157:	39 06                	cmp    %eax,(%esi)
80105159:	75 3d                	jne    80105198 <sys_link+0xe8>
8010515b:	83 ec 04             	sub    $0x4,%esp
8010515e:	ff 73 04             	pushl  0x4(%ebx)
80105161:	57                   	push   %edi
80105162:	56                   	push   %esi
80105163:	e8 b8 cc ff ff       	call   80101e20 <dirlink>
80105168:	83 c4 10             	add    $0x10,%esp
8010516b:	85 c0                	test   %eax,%eax
8010516d:	78 29                	js     80105198 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010516f:	83 ec 0c             	sub    $0xc,%esp
80105172:	56                   	push   %esi
80105173:	e8 98 c7 ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105178:	89 1c 24             	mov    %ebx,(%esp)
8010517b:	e8 30 c6 ff ff       	call   801017b0 <iput>

  end_op();
80105180:	e8 1b de ff ff       	call   80102fa0 <end_op>

  return 0;
80105185:	83 c4 10             	add    $0x10,%esp
80105188:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010518a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010518d:	5b                   	pop    %ebx
8010518e:	5e                   	pop    %esi
8010518f:	5f                   	pop    %edi
80105190:	5d                   	pop    %ebp
80105191:	c3                   	ret    
80105192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105198:	83 ec 0c             	sub    $0xc,%esp
8010519b:	56                   	push   %esi
8010519c:	e8 6f c7 ff ff       	call   80101910 <iunlockput>
    goto bad;
801051a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051a4:	83 ec 0c             	sub    $0xc,%esp
801051a7:	53                   	push   %ebx
801051a8:	e8 d3 c4 ff ff       	call   80101680 <ilock>
  ip->nlink--;
801051ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051b2:	89 1c 24             	mov    %ebx,(%esp)
801051b5:	e8 16 c4 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801051ba:	89 1c 24             	mov    %ebx,(%esp)
801051bd:	e8 4e c7 ff ff       	call   80101910 <iunlockput>
  end_op();
801051c2:	e8 d9 dd ff ff       	call   80102fa0 <end_op>
  return -1;
801051c7:	83 c4 10             	add    $0x10,%esp
}
801051ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801051cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051d2:	5b                   	pop    %ebx
801051d3:	5e                   	pop    %esi
801051d4:	5f                   	pop    %edi
801051d5:	5d                   	pop    %ebp
801051d6:	c3                   	ret    
    iunlockput(ip);
801051d7:	83 ec 0c             	sub    $0xc,%esp
801051da:	53                   	push   %ebx
801051db:	e8 30 c7 ff ff       	call   80101910 <iunlockput>
    end_op();
801051e0:	e8 bb dd ff ff       	call   80102fa0 <end_op>
    return -1;
801051e5:	83 c4 10             	add    $0x10,%esp
801051e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ed:	eb 9b                	jmp    8010518a <sys_link+0xda>
    end_op();
801051ef:	e8 ac dd ff ff       	call   80102fa0 <end_op>
    return -1;
801051f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f9:	eb 8f                	jmp    8010518a <sys_link+0xda>
801051fb:	90                   	nop
801051fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105200 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
80105205:	53                   	push   %ebx
80105206:	83 ec 1c             	sub    $0x1c,%esp
80105209:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010520c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105210:	76 3e                	jbe    80105250 <isdirempty+0x50>
80105212:	bb 20 00 00 00       	mov    $0x20,%ebx
80105217:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010521a:	eb 0c                	jmp    80105228 <isdirempty+0x28>
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105220:	83 c3 10             	add    $0x10,%ebx
80105223:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105226:	73 28                	jae    80105250 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105228:	6a 10                	push   $0x10
8010522a:	53                   	push   %ebx
8010522b:	57                   	push   %edi
8010522c:	56                   	push   %esi
8010522d:	e8 2e c7 ff ff       	call   80101960 <readi>
80105232:	83 c4 10             	add    $0x10,%esp
80105235:	83 f8 10             	cmp    $0x10,%eax
80105238:	75 23                	jne    8010525d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010523a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010523f:	74 df                	je     80105220 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105241:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105244:	31 c0                	xor    %eax,%eax
}
80105246:	5b                   	pop    %ebx
80105247:	5e                   	pop    %esi
80105248:	5f                   	pop    %edi
80105249:	5d                   	pop    %ebp
8010524a:	c3                   	ret    
8010524b:	90                   	nop
8010524c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105253:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105258:	5b                   	pop    %ebx
80105259:	5e                   	pop    %esi
8010525a:	5f                   	pop    %edi
8010525b:	5d                   	pop    %ebp
8010525c:	c3                   	ret    
      panic("isdirempty: readi");
8010525d:	83 ec 0c             	sub    $0xc,%esp
80105260:	68 78 7c 10 80       	push   $0x80107c78
80105265:	e8 26 b1 ff ff       	call   80100390 <panic>
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105270 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	57                   	push   %edi
80105274:	56                   	push   %esi
80105275:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105276:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105279:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010527c:	50                   	push   %eax
8010527d:	6a 00                	push   $0x0
8010527f:	e8 4c fb ff ff       	call   80104dd0 <argstr>
80105284:	83 c4 10             	add    $0x10,%esp
80105287:	85 c0                	test   %eax,%eax
80105289:	0f 88 51 01 00 00    	js     801053e0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010528f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105292:	e8 99 dc ff ff       	call   80102f30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105297:	83 ec 08             	sub    $0x8,%esp
8010529a:	53                   	push   %ebx
8010529b:	ff 75 c0             	pushl  -0x40(%ebp)
8010529e:	e8 5d cc ff ff       	call   80101f00 <nameiparent>
801052a3:	83 c4 10             	add    $0x10,%esp
801052a6:	85 c0                	test   %eax,%eax
801052a8:	89 c6                	mov    %eax,%esi
801052aa:	0f 84 37 01 00 00    	je     801053e7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
801052b0:	83 ec 0c             	sub    $0xc,%esp
801052b3:	50                   	push   %eax
801052b4:	e8 c7 c3 ff ff       	call   80101680 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052b9:	58                   	pop    %eax
801052ba:	5a                   	pop    %edx
801052bb:	68 3d 76 10 80       	push   $0x8010763d
801052c0:	53                   	push   %ebx
801052c1:	e8 ca c8 ff ff       	call   80101b90 <namecmp>
801052c6:	83 c4 10             	add    $0x10,%esp
801052c9:	85 c0                	test   %eax,%eax
801052cb:	0f 84 d7 00 00 00    	je     801053a8 <sys_unlink+0x138>
801052d1:	83 ec 08             	sub    $0x8,%esp
801052d4:	68 3c 76 10 80       	push   $0x8010763c
801052d9:	53                   	push   %ebx
801052da:	e8 b1 c8 ff ff       	call   80101b90 <namecmp>
801052df:	83 c4 10             	add    $0x10,%esp
801052e2:	85 c0                	test   %eax,%eax
801052e4:	0f 84 be 00 00 00    	je     801053a8 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801052ea:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052ed:	83 ec 04             	sub    $0x4,%esp
801052f0:	50                   	push   %eax
801052f1:	53                   	push   %ebx
801052f2:	56                   	push   %esi
801052f3:	e8 b8 c8 ff ff       	call   80101bb0 <dirlookup>
801052f8:	83 c4 10             	add    $0x10,%esp
801052fb:	85 c0                	test   %eax,%eax
801052fd:	89 c3                	mov    %eax,%ebx
801052ff:	0f 84 a3 00 00 00    	je     801053a8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105305:	83 ec 0c             	sub    $0xc,%esp
80105308:	50                   	push   %eax
80105309:	e8 72 c3 ff ff       	call   80101680 <ilock>

  if(ip->nlink < 1)
8010530e:	83 c4 10             	add    $0x10,%esp
80105311:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105316:	0f 8e e4 00 00 00    	jle    80105400 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010531c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105321:	74 65                	je     80105388 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105323:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105326:	83 ec 04             	sub    $0x4,%esp
80105329:	6a 10                	push   $0x10
8010532b:	6a 00                	push   $0x0
8010532d:	57                   	push   %edi
8010532e:	e8 ed f6 ff ff       	call   80104a20 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105333:	6a 10                	push   $0x10
80105335:	ff 75 c4             	pushl  -0x3c(%ebp)
80105338:	57                   	push   %edi
80105339:	56                   	push   %esi
8010533a:	e8 21 c7 ff ff       	call   80101a60 <writei>
8010533f:	83 c4 20             	add    $0x20,%esp
80105342:	83 f8 10             	cmp    $0x10,%eax
80105345:	0f 85 a8 00 00 00    	jne    801053f3 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010534b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105350:	74 6e                	je     801053c0 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105352:	83 ec 0c             	sub    $0xc,%esp
80105355:	56                   	push   %esi
80105356:	e8 b5 c5 ff ff       	call   80101910 <iunlockput>

  ip->nlink--;
8010535b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105360:	89 1c 24             	mov    %ebx,(%esp)
80105363:	e8 68 c2 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105368:	89 1c 24             	mov    %ebx,(%esp)
8010536b:	e8 a0 c5 ff ff       	call   80101910 <iunlockput>

  end_op();
80105370:	e8 2b dc ff ff       	call   80102fa0 <end_op>

  return 0;
80105375:	83 c4 10             	add    $0x10,%esp
80105378:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010537a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010537d:	5b                   	pop    %ebx
8010537e:	5e                   	pop    %esi
8010537f:	5f                   	pop    %edi
80105380:	5d                   	pop    %ebp
80105381:	c3                   	ret    
80105382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105388:	83 ec 0c             	sub    $0xc,%esp
8010538b:	53                   	push   %ebx
8010538c:	e8 6f fe ff ff       	call   80105200 <isdirempty>
80105391:	83 c4 10             	add    $0x10,%esp
80105394:	85 c0                	test   %eax,%eax
80105396:	75 8b                	jne    80105323 <sys_unlink+0xb3>
    iunlockput(ip);
80105398:	83 ec 0c             	sub    $0xc,%esp
8010539b:	53                   	push   %ebx
8010539c:	e8 6f c5 ff ff       	call   80101910 <iunlockput>
    goto bad;
801053a1:	83 c4 10             	add    $0x10,%esp
801053a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801053a8:	83 ec 0c             	sub    $0xc,%esp
801053ab:	56                   	push   %esi
801053ac:	e8 5f c5 ff ff       	call   80101910 <iunlockput>
  end_op();
801053b1:	e8 ea db ff ff       	call   80102fa0 <end_op>
  return -1;
801053b6:	83 c4 10             	add    $0x10,%esp
801053b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053be:	eb ba                	jmp    8010537a <sys_unlink+0x10a>
    dp->nlink--;
801053c0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801053c5:	83 ec 0c             	sub    $0xc,%esp
801053c8:	56                   	push   %esi
801053c9:	e8 02 c2 ff ff       	call   801015d0 <iupdate>
801053ce:	83 c4 10             	add    $0x10,%esp
801053d1:	e9 7c ff ff ff       	jmp    80105352 <sys_unlink+0xe2>
801053d6:	8d 76 00             	lea    0x0(%esi),%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801053e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e5:	eb 93                	jmp    8010537a <sys_unlink+0x10a>
    end_op();
801053e7:	e8 b4 db ff ff       	call   80102fa0 <end_op>
    return -1;
801053ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f1:	eb 87                	jmp    8010537a <sys_unlink+0x10a>
    panic("unlink: writei");
801053f3:	83 ec 0c             	sub    $0xc,%esp
801053f6:	68 51 76 10 80       	push   $0x80107651
801053fb:	e8 90 af ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105400:	83 ec 0c             	sub    $0xc,%esp
80105403:	68 3f 76 10 80       	push   $0x8010763f
80105408:	e8 83 af ff ff       	call   80100390 <panic>
8010540d:	8d 76 00             	lea    0x0(%esi),%esi

80105410 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	57                   	push   %edi
80105414:	56                   	push   %esi
80105415:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105416:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105419:	83 ec 34             	sub    $0x34,%esp
8010541c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010541f:	8b 55 10             	mov    0x10(%ebp),%edx
80105422:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105425:	56                   	push   %esi
80105426:	ff 75 08             	pushl  0x8(%ebp)
{
80105429:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010542c:	89 55 d0             	mov    %edx,-0x30(%ebp)
8010542f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105432:	e8 c9 ca ff ff       	call   80101f00 <nameiparent>
80105437:	83 c4 10             	add    $0x10,%esp
8010543a:	85 c0                	test   %eax,%eax
8010543c:	0f 84 4e 01 00 00    	je     80105590 <create+0x180>
    return 0;
  ilock(dp);
80105442:	83 ec 0c             	sub    $0xc,%esp
80105445:	89 c3                	mov    %eax,%ebx
80105447:	50                   	push   %eax
80105448:	e8 33 c2 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
8010544d:	83 c4 0c             	add    $0xc,%esp
80105450:	6a 00                	push   $0x0
80105452:	56                   	push   %esi
80105453:	53                   	push   %ebx
80105454:	e8 57 c7 ff ff       	call   80101bb0 <dirlookup>
80105459:	83 c4 10             	add    $0x10,%esp
8010545c:	85 c0                	test   %eax,%eax
8010545e:	89 c7                	mov    %eax,%edi
80105460:	74 3e                	je     801054a0 <create+0x90>
    iunlockput(dp);
80105462:	83 ec 0c             	sub    $0xc,%esp
80105465:	53                   	push   %ebx
80105466:	e8 a5 c4 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
8010546b:	89 3c 24             	mov    %edi,(%esp)
8010546e:	e8 0d c2 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105473:	83 c4 10             	add    $0x10,%esp
80105476:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010547b:	0f 85 9f 00 00 00    	jne    80105520 <create+0x110>
80105481:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105486:	0f 85 94 00 00 00    	jne    80105520 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010548c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010548f:	89 f8                	mov    %edi,%eax
80105491:	5b                   	pop    %ebx
80105492:	5e                   	pop    %esi
80105493:	5f                   	pop    %edi
80105494:	5d                   	pop    %ebp
80105495:	c3                   	ret    
80105496:	8d 76 00             	lea    0x0(%esi),%esi
80105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
801054a0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801054a4:	83 ec 08             	sub    $0x8,%esp
801054a7:	50                   	push   %eax
801054a8:	ff 33                	pushl  (%ebx)
801054aa:	e8 61 c0 ff ff       	call   80101510 <ialloc>
801054af:	83 c4 10             	add    $0x10,%esp
801054b2:	85 c0                	test   %eax,%eax
801054b4:	89 c7                	mov    %eax,%edi
801054b6:	0f 84 e8 00 00 00    	je     801055a4 <create+0x194>
  ilock(ip);
801054bc:	83 ec 0c             	sub    $0xc,%esp
801054bf:	50                   	push   %eax
801054c0:	e8 bb c1 ff ff       	call   80101680 <ilock>
  ip->major = major;
801054c5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801054c9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801054cd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801054d1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801054d5:	b8 01 00 00 00       	mov    $0x1,%eax
801054da:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801054de:	89 3c 24             	mov    %edi,(%esp)
801054e1:	e8 ea c0 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801054e6:	83 c4 10             	add    $0x10,%esp
801054e9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801054ee:	74 50                	je     80105540 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
801054f0:	83 ec 04             	sub    $0x4,%esp
801054f3:	ff 77 04             	pushl  0x4(%edi)
801054f6:	56                   	push   %esi
801054f7:	53                   	push   %ebx
801054f8:	e8 23 c9 ff ff       	call   80101e20 <dirlink>
801054fd:	83 c4 10             	add    $0x10,%esp
80105500:	85 c0                	test   %eax,%eax
80105502:	0f 88 8f 00 00 00    	js     80105597 <create+0x187>
  iunlockput(dp);
80105508:	83 ec 0c             	sub    $0xc,%esp
8010550b:	53                   	push   %ebx
8010550c:	e8 ff c3 ff ff       	call   80101910 <iunlockput>
  return ip;
80105511:	83 c4 10             	add    $0x10,%esp
}
80105514:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105517:	89 f8                	mov    %edi,%eax
80105519:	5b                   	pop    %ebx
8010551a:	5e                   	pop    %esi
8010551b:	5f                   	pop    %edi
8010551c:	5d                   	pop    %ebp
8010551d:	c3                   	ret    
8010551e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	57                   	push   %edi
    return 0;
80105524:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105526:	e8 e5 c3 ff ff       	call   80101910 <iunlockput>
    return 0;
8010552b:	83 c4 10             	add    $0x10,%esp
}
8010552e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105531:	89 f8                	mov    %edi,%eax
80105533:	5b                   	pop    %ebx
80105534:	5e                   	pop    %esi
80105535:	5f                   	pop    %edi
80105536:	5d                   	pop    %ebp
80105537:	c3                   	ret    
80105538:	90                   	nop
80105539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105540:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105545:	83 ec 0c             	sub    $0xc,%esp
80105548:	53                   	push   %ebx
80105549:	e8 82 c0 ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010554e:	83 c4 0c             	add    $0xc,%esp
80105551:	ff 77 04             	pushl  0x4(%edi)
80105554:	68 3d 76 10 80       	push   $0x8010763d
80105559:	57                   	push   %edi
8010555a:	e8 c1 c8 ff ff       	call   80101e20 <dirlink>
8010555f:	83 c4 10             	add    $0x10,%esp
80105562:	85 c0                	test   %eax,%eax
80105564:	78 1c                	js     80105582 <create+0x172>
80105566:	83 ec 04             	sub    $0x4,%esp
80105569:	ff 73 04             	pushl  0x4(%ebx)
8010556c:	68 3c 76 10 80       	push   $0x8010763c
80105571:	57                   	push   %edi
80105572:	e8 a9 c8 ff ff       	call   80101e20 <dirlink>
80105577:	83 c4 10             	add    $0x10,%esp
8010557a:	85 c0                	test   %eax,%eax
8010557c:	0f 89 6e ff ff ff    	jns    801054f0 <create+0xe0>
      panic("create dots");
80105582:	83 ec 0c             	sub    $0xc,%esp
80105585:	68 99 7c 10 80       	push   $0x80107c99
8010558a:	e8 01 ae ff ff       	call   80100390 <panic>
8010558f:	90                   	nop
    return 0;
80105590:	31 ff                	xor    %edi,%edi
80105592:	e9 f5 fe ff ff       	jmp    8010548c <create+0x7c>
    panic("create: dirlink");
80105597:	83 ec 0c             	sub    $0xc,%esp
8010559a:	68 a5 7c 10 80       	push   $0x80107ca5
8010559f:	e8 ec ad ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801055a4:	83 ec 0c             	sub    $0xc,%esp
801055a7:	68 8a 7c 10 80       	push   $0x80107c8a
801055ac:	e8 df ad ff ff       	call   80100390 <panic>
801055b1:	eb 0d                	jmp    801055c0 <sys_open>
801055b3:	90                   	nop
801055b4:	90                   	nop
801055b5:	90                   	nop
801055b6:	90                   	nop
801055b7:	90                   	nop
801055b8:	90                   	nop
801055b9:	90                   	nop
801055ba:	90                   	nop
801055bb:	90                   	nop
801055bc:	90                   	nop
801055bd:	90                   	nop
801055be:	90                   	nop
801055bf:	90                   	nop

801055c0 <sys_open>:

int
sys_open(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	57                   	push   %edi
801055c4:	56                   	push   %esi
801055c5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801055c9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055cc:	50                   	push   %eax
801055cd:	6a 00                	push   $0x0
801055cf:	e8 fc f7 ff ff       	call   80104dd0 <argstr>
801055d4:	83 c4 10             	add    $0x10,%esp
801055d7:	85 c0                	test   %eax,%eax
801055d9:	0f 88 1d 01 00 00    	js     801056fc <sys_open+0x13c>
801055df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055e2:	83 ec 08             	sub    $0x8,%esp
801055e5:	50                   	push   %eax
801055e6:	6a 01                	push   $0x1
801055e8:	e8 33 f7 ff ff       	call   80104d20 <argint>
801055ed:	83 c4 10             	add    $0x10,%esp
801055f0:	85 c0                	test   %eax,%eax
801055f2:	0f 88 04 01 00 00    	js     801056fc <sys_open+0x13c>
    return -1;

  begin_op();
801055f8:	e8 33 d9 ff ff       	call   80102f30 <begin_op>

  if(omode & O_CREATE){
801055fd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105601:	0f 85 a9 00 00 00    	jne    801056b0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105607:	83 ec 0c             	sub    $0xc,%esp
8010560a:	ff 75 e0             	pushl  -0x20(%ebp)
8010560d:	e8 ce c8 ff ff       	call   80101ee0 <namei>
80105612:	83 c4 10             	add    $0x10,%esp
80105615:	85 c0                	test   %eax,%eax
80105617:	89 c6                	mov    %eax,%esi
80105619:	0f 84 ac 00 00 00    	je     801056cb <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
8010561f:	83 ec 0c             	sub    $0xc,%esp
80105622:	50                   	push   %eax
80105623:	e8 58 c0 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105628:	83 c4 10             	add    $0x10,%esp
8010562b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105630:	0f 84 aa 00 00 00    	je     801056e0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105636:	e8 45 b7 ff ff       	call   80100d80 <filealloc>
8010563b:	85 c0                	test   %eax,%eax
8010563d:	89 c7                	mov    %eax,%edi
8010563f:	0f 84 a6 00 00 00    	je     801056eb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105645:	e8 b6 e5 ff ff       	call   80103c00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010564a:	31 db                	xor    %ebx,%ebx
8010564c:	eb 0e                	jmp    8010565c <sys_open+0x9c>
8010564e:	66 90                	xchg   %ax,%ax
80105650:	83 c3 01             	add    $0x1,%ebx
80105653:	83 fb 10             	cmp    $0x10,%ebx
80105656:	0f 84 ac 00 00 00    	je     80105708 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010565c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105660:	85 d2                	test   %edx,%edx
80105662:	75 ec                	jne    80105650 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105664:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105667:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010566b:	56                   	push   %esi
8010566c:	e8 ef c0 ff ff       	call   80101760 <iunlock>
  end_op();
80105671:	e8 2a d9 ff ff       	call   80102fa0 <end_op>

  f->type = FD_INODE;
80105676:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010567c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010567f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105682:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105685:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010568c:	89 d0                	mov    %edx,%eax
8010568e:	f7 d0                	not    %eax
80105690:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105693:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105696:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105699:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010569d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056a0:	89 d8                	mov    %ebx,%eax
801056a2:	5b                   	pop    %ebx
801056a3:	5e                   	pop    %esi
801056a4:	5f                   	pop    %edi
801056a5:	5d                   	pop    %ebp
801056a6:	c3                   	ret    
801056a7:	89 f6                	mov    %esi,%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801056b0:	6a 00                	push   $0x0
801056b2:	6a 00                	push   $0x0
801056b4:	6a 02                	push   $0x2
801056b6:	ff 75 e0             	pushl  -0x20(%ebp)
801056b9:	e8 52 fd ff ff       	call   80105410 <create>
    if(ip == 0){
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801056c3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801056c5:	0f 85 6b ff ff ff    	jne    80105636 <sys_open+0x76>
      end_op();
801056cb:	e8 d0 d8 ff ff       	call   80102fa0 <end_op>
      return -1;
801056d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056d5:	eb c6                	jmp    8010569d <sys_open+0xdd>
801056d7:	89 f6                	mov    %esi,%esi
801056d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
801056e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056e3:	85 c9                	test   %ecx,%ecx
801056e5:	0f 84 4b ff ff ff    	je     80105636 <sys_open+0x76>
    iunlockput(ip);
801056eb:	83 ec 0c             	sub    $0xc,%esp
801056ee:	56                   	push   %esi
801056ef:	e8 1c c2 ff ff       	call   80101910 <iunlockput>
    end_op();
801056f4:	e8 a7 d8 ff ff       	call   80102fa0 <end_op>
    return -1;
801056f9:	83 c4 10             	add    $0x10,%esp
801056fc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105701:	eb 9a                	jmp    8010569d <sys_open+0xdd>
80105703:	90                   	nop
80105704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105708:	83 ec 0c             	sub    $0xc,%esp
8010570b:	57                   	push   %edi
8010570c:	e8 2f b7 ff ff       	call   80100e40 <fileclose>
80105711:	83 c4 10             	add    $0x10,%esp
80105714:	eb d5                	jmp    801056eb <sys_open+0x12b>
80105716:	8d 76 00             	lea    0x0(%esi),%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105720 <sys_mkdir>:

int
sys_mkdir(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105726:	e8 05 d8 ff ff       	call   80102f30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010572b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010572e:	83 ec 08             	sub    $0x8,%esp
80105731:	50                   	push   %eax
80105732:	6a 00                	push   $0x0
80105734:	e8 97 f6 ff ff       	call   80104dd0 <argstr>
80105739:	83 c4 10             	add    $0x10,%esp
8010573c:	85 c0                	test   %eax,%eax
8010573e:	78 30                	js     80105770 <sys_mkdir+0x50>
80105740:	6a 00                	push   $0x0
80105742:	6a 00                	push   $0x0
80105744:	6a 01                	push   $0x1
80105746:	ff 75 f4             	pushl  -0xc(%ebp)
80105749:	e8 c2 fc ff ff       	call   80105410 <create>
8010574e:	83 c4 10             	add    $0x10,%esp
80105751:	85 c0                	test   %eax,%eax
80105753:	74 1b                	je     80105770 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105755:	83 ec 0c             	sub    $0xc,%esp
80105758:	50                   	push   %eax
80105759:	e8 b2 c1 ff ff       	call   80101910 <iunlockput>
  end_op();
8010575e:	e8 3d d8 ff ff       	call   80102fa0 <end_op>
  return 0;
80105763:	83 c4 10             	add    $0x10,%esp
80105766:	31 c0                	xor    %eax,%eax
}
80105768:	c9                   	leave  
80105769:	c3                   	ret    
8010576a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105770:	e8 2b d8 ff ff       	call   80102fa0 <end_op>
    return -1;
80105775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010577a:	c9                   	leave  
8010577b:	c3                   	ret    
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_mknod>:

int
sys_mknod(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105786:	e8 a5 d7 ff ff       	call   80102f30 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010578b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010578e:	83 ec 08             	sub    $0x8,%esp
80105791:	50                   	push   %eax
80105792:	6a 00                	push   $0x0
80105794:	e8 37 f6 ff ff       	call   80104dd0 <argstr>
80105799:	83 c4 10             	add    $0x10,%esp
8010579c:	85 c0                	test   %eax,%eax
8010579e:	78 60                	js     80105800 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801057a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057a3:	83 ec 08             	sub    $0x8,%esp
801057a6:	50                   	push   %eax
801057a7:	6a 01                	push   $0x1
801057a9:	e8 72 f5 ff ff       	call   80104d20 <argint>
  if((argstr(0, &path)) < 0 ||
801057ae:	83 c4 10             	add    $0x10,%esp
801057b1:	85 c0                	test   %eax,%eax
801057b3:	78 4b                	js     80105800 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801057b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057b8:	83 ec 08             	sub    $0x8,%esp
801057bb:	50                   	push   %eax
801057bc:	6a 02                	push   $0x2
801057be:	e8 5d f5 ff ff       	call   80104d20 <argint>
     argint(1, &major) < 0 ||
801057c3:	83 c4 10             	add    $0x10,%esp
801057c6:	85 c0                	test   %eax,%eax
801057c8:	78 36                	js     80105800 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801057ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801057ce:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
801057cf:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
801057d3:	50                   	push   %eax
801057d4:	6a 03                	push   $0x3
801057d6:	ff 75 ec             	pushl  -0x14(%ebp)
801057d9:	e8 32 fc ff ff       	call   80105410 <create>
801057de:	83 c4 10             	add    $0x10,%esp
801057e1:	85 c0                	test   %eax,%eax
801057e3:	74 1b                	je     80105800 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057e5:	83 ec 0c             	sub    $0xc,%esp
801057e8:	50                   	push   %eax
801057e9:	e8 22 c1 ff ff       	call   80101910 <iunlockput>
  end_op();
801057ee:	e8 ad d7 ff ff       	call   80102fa0 <end_op>
  return 0;
801057f3:	83 c4 10             	add    $0x10,%esp
801057f6:	31 c0                	xor    %eax,%eax
}
801057f8:	c9                   	leave  
801057f9:	c3                   	ret    
801057fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105800:	e8 9b d7 ff ff       	call   80102fa0 <end_op>
    return -1;
80105805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010580a:	c9                   	leave  
8010580b:	c3                   	ret    
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_chdir>:

int
sys_chdir(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	56                   	push   %esi
80105814:	53                   	push   %ebx
80105815:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105818:	e8 e3 e3 ff ff       	call   80103c00 <myproc>
8010581d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010581f:	e8 0c d7 ff ff       	call   80102f30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105824:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105827:	83 ec 08             	sub    $0x8,%esp
8010582a:	50                   	push   %eax
8010582b:	6a 00                	push   $0x0
8010582d:	e8 9e f5 ff ff       	call   80104dd0 <argstr>
80105832:	83 c4 10             	add    $0x10,%esp
80105835:	85 c0                	test   %eax,%eax
80105837:	78 77                	js     801058b0 <sys_chdir+0xa0>
80105839:	83 ec 0c             	sub    $0xc,%esp
8010583c:	ff 75 f4             	pushl  -0xc(%ebp)
8010583f:	e8 9c c6 ff ff       	call   80101ee0 <namei>
80105844:	83 c4 10             	add    $0x10,%esp
80105847:	85 c0                	test   %eax,%eax
80105849:	89 c3                	mov    %eax,%ebx
8010584b:	74 63                	je     801058b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010584d:	83 ec 0c             	sub    $0xc,%esp
80105850:	50                   	push   %eax
80105851:	e8 2a be ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010585e:	75 30                	jne    80105890 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105860:	83 ec 0c             	sub    $0xc,%esp
80105863:	53                   	push   %ebx
80105864:	e8 f7 be ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105869:	58                   	pop    %eax
8010586a:	ff 76 68             	pushl  0x68(%esi)
8010586d:	e8 3e bf ff ff       	call   801017b0 <iput>
  end_op();
80105872:	e8 29 d7 ff ff       	call   80102fa0 <end_op>
  curproc->cwd = ip;
80105877:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010587a:	83 c4 10             	add    $0x10,%esp
8010587d:	31 c0                	xor    %eax,%eax
}
8010587f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105882:	5b                   	pop    %ebx
80105883:	5e                   	pop    %esi
80105884:	5d                   	pop    %ebp
80105885:	c3                   	ret    
80105886:	8d 76 00             	lea    0x0(%esi),%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105890:	83 ec 0c             	sub    $0xc,%esp
80105893:	53                   	push   %ebx
80105894:	e8 77 c0 ff ff       	call   80101910 <iunlockput>
    end_op();
80105899:	e8 02 d7 ff ff       	call   80102fa0 <end_op>
    return -1;
8010589e:	83 c4 10             	add    $0x10,%esp
801058a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a6:	eb d7                	jmp    8010587f <sys_chdir+0x6f>
801058a8:	90                   	nop
801058a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801058b0:	e8 eb d6 ff ff       	call   80102fa0 <end_op>
    return -1;
801058b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ba:	eb c3                	jmp    8010587f <sys_chdir+0x6f>
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_exec>:

int
sys_exec(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	57                   	push   %edi
801058c4:	56                   	push   %esi
801058c5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058c6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801058cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058d2:	50                   	push   %eax
801058d3:	6a 00                	push   $0x0
801058d5:	e8 f6 f4 ff ff       	call   80104dd0 <argstr>
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	85 c0                	test   %eax,%eax
801058df:	0f 88 87 00 00 00    	js     8010596c <sys_exec+0xac>
801058e5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801058eb:	83 ec 08             	sub    $0x8,%esp
801058ee:	50                   	push   %eax
801058ef:	6a 01                	push   $0x1
801058f1:	e8 2a f4 ff ff       	call   80104d20 <argint>
801058f6:	83 c4 10             	add    $0x10,%esp
801058f9:	85 c0                	test   %eax,%eax
801058fb:	78 6f                	js     8010596c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801058fd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105903:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105906:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105908:	68 80 00 00 00       	push   $0x80
8010590d:	6a 00                	push   $0x0
8010590f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105915:	50                   	push   %eax
80105916:	e8 05 f1 ff ff       	call   80104a20 <memset>
8010591b:	83 c4 10             	add    $0x10,%esp
8010591e:	eb 2c                	jmp    8010594c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105920:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105926:	85 c0                	test   %eax,%eax
80105928:	74 56                	je     80105980 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010592a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105930:	83 ec 08             	sub    $0x8,%esp
80105933:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105936:	52                   	push   %edx
80105937:	50                   	push   %eax
80105938:	e8 73 f3 ff ff       	call   80104cb0 <fetchstr>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	78 28                	js     8010596c <sys_exec+0xac>
  for(i=0;; i++){
80105944:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105947:	83 fb 20             	cmp    $0x20,%ebx
8010594a:	74 20                	je     8010596c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010594c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105952:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105959:	83 ec 08             	sub    $0x8,%esp
8010595c:	57                   	push   %edi
8010595d:	01 f0                	add    %esi,%eax
8010595f:	50                   	push   %eax
80105960:	e8 0b f3 ff ff       	call   80104c70 <fetchint>
80105965:	83 c4 10             	add    $0x10,%esp
80105968:	85 c0                	test   %eax,%eax
8010596a:	79 b4                	jns    80105920 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010596c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010596f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105974:	5b                   	pop    %ebx
80105975:	5e                   	pop    %esi
80105976:	5f                   	pop    %edi
80105977:	5d                   	pop    %ebp
80105978:	c3                   	ret    
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105980:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105986:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105989:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105990:	00 00 00 00 
  return exec(path, argv);
80105994:	50                   	push   %eax
80105995:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010599b:	e8 70 b0 ff ff       	call   80100a10 <exec>
801059a0:	83 c4 10             	add    $0x10,%esp
}
801059a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059a6:	5b                   	pop    %ebx
801059a7:	5e                   	pop    %esi
801059a8:	5f                   	pop    %edi
801059a9:	5d                   	pop    %ebp
801059aa:	c3                   	ret    
801059ab:	90                   	nop
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_pipe>:

int
sys_pipe(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	57                   	push   %edi
801059b4:	56                   	push   %esi
801059b5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059b6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801059b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059bc:	6a 08                	push   $0x8
801059be:	50                   	push   %eax
801059bf:	6a 00                	push   $0x0
801059c1:	e8 aa f3 ff ff       	call   80104d70 <argptr>
801059c6:	83 c4 10             	add    $0x10,%esp
801059c9:	85 c0                	test   %eax,%eax
801059cb:	0f 88 ae 00 00 00    	js     80105a7f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801059d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059d4:	83 ec 08             	sub    $0x8,%esp
801059d7:	50                   	push   %eax
801059d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059db:	50                   	push   %eax
801059dc:	e8 ef db ff ff       	call   801035d0 <pipealloc>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	85 c0                	test   %eax,%eax
801059e6:	0f 88 93 00 00 00    	js     80105a7f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801059ef:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801059f1:	e8 0a e2 ff ff       	call   80103c00 <myproc>
801059f6:	eb 10                	jmp    80105a08 <sys_pipe+0x58>
801059f8:	90                   	nop
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a00:	83 c3 01             	add    $0x1,%ebx
80105a03:	83 fb 10             	cmp    $0x10,%ebx
80105a06:	74 60                	je     80105a68 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105a08:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105a0c:	85 f6                	test   %esi,%esi
80105a0e:	75 f0                	jne    80105a00 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a10:	8d 73 08             	lea    0x8(%ebx),%esi
80105a13:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a1a:	e8 e1 e1 ff ff       	call   80103c00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a1f:	31 d2                	xor    %edx,%edx
80105a21:	eb 0d                	jmp    80105a30 <sys_pipe+0x80>
80105a23:	90                   	nop
80105a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a28:	83 c2 01             	add    $0x1,%edx
80105a2b:	83 fa 10             	cmp    $0x10,%edx
80105a2e:	74 28                	je     80105a58 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105a30:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105a34:	85 c9                	test   %ecx,%ecx
80105a36:	75 f0                	jne    80105a28 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105a38:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105a3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a3f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a41:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a44:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a47:	31 c0                	xor    %eax,%eax
}
80105a49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a4c:	5b                   	pop    %ebx
80105a4d:	5e                   	pop    %esi
80105a4e:	5f                   	pop    %edi
80105a4f:	5d                   	pop    %ebp
80105a50:	c3                   	ret    
80105a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105a58:	e8 a3 e1 ff ff       	call   80103c00 <myproc>
80105a5d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105a64:	00 
80105a65:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105a68:	83 ec 0c             	sub    $0xc,%esp
80105a6b:	ff 75 e0             	pushl  -0x20(%ebp)
80105a6e:	e8 cd b3 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105a73:	58                   	pop    %eax
80105a74:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a77:	e8 c4 b3 ff ff       	call   80100e40 <fileclose>
    return -1;
80105a7c:	83 c4 10             	add    $0x10,%esp
80105a7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a84:	eb c3                	jmp    80105a49 <sys_pipe+0x99>
80105a86:	66 90                	xchg   %ax,%ax
80105a88:	66 90                	xchg   %ax,%ax
80105a8a:	66 90                	xchg   %ax,%ax
80105a8c:	66 90                	xchg   %ax,%ax
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105a93:	5d                   	pop    %ebp
  return fork();
80105a94:	e9 07 e3 ff ff       	jmp    80103da0 <fork>
80105a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105aa0 <sys_exit>:

int
sys_exit(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105aa6:	e8 05 e7 ff ff       	call   801041b0 <exit>
  return 0;  // not reached
}
80105aab:	31 c0                	xor    %eax,%eax
80105aad:	c9                   	leave  
80105aae:	c3                   	ret    
80105aaf:	90                   	nop

80105ab0 <sys_wait>:

int
sys_wait(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105ab3:	5d                   	pop    %ebp
  return wait();
80105ab4:	e9 37 e9 ff ff       	jmp    801043f0 <wait>
80105ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <sys_kill>:

int
sys_kill(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ac6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac9:	50                   	push   %eax
80105aca:	6a 00                	push   $0x0
80105acc:	e8 4f f2 ff ff       	call   80104d20 <argint>
80105ad1:	83 c4 10             	add    $0x10,%esp
80105ad4:	85 c0                	test   %eax,%eax
80105ad6:	78 18                	js     80105af0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ad8:	83 ec 0c             	sub    $0xc,%esp
80105adb:	ff 75 f4             	pushl  -0xc(%ebp)
80105ade:	e8 6d ea ff ff       	call   80104550 <kill>
80105ae3:	83 c4 10             	add    $0x10,%esp
}
80105ae6:	c9                   	leave  
80105ae7:	c3                   	ret    
80105ae8:	90                   	nop
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105af5:	c9                   	leave  
80105af6:	c3                   	ret    
80105af7:	89 f6                	mov    %esi,%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b00 <sys_getpid>:

int
sys_getpid(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b06:	e8 f5 e0 ff ff       	call   80103c00 <myproc>
80105b0b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105b0e:	c9                   	leave  
80105b0f:	c3                   	ret    

80105b10 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b1a:	50                   	push   %eax
80105b1b:	6a 00                	push   $0x0
80105b1d:	e8 fe f1 ff ff       	call   80104d20 <argint>
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	85 c0                	test   %eax,%eax
80105b27:	78 27                	js     80105b50 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b29:	e8 d2 e0 ff ff       	call   80103c00 <myproc>
  if(growproc(n) < 0)
80105b2e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105b31:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105b33:	ff 75 f4             	pushl  -0xc(%ebp)
80105b36:	e8 e5 e1 ff ff       	call   80103d20 <growproc>
80105b3b:	83 c4 10             	add    $0x10,%esp
80105b3e:	85 c0                	test   %eax,%eax
80105b40:	78 0e                	js     80105b50 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105b42:	89 d8                	mov    %ebx,%eax
80105b44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b47:	c9                   	leave  
80105b48:	c3                   	ret    
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b50:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b55:	eb eb                	jmp    80105b42 <sys_sbrk+0x32>
80105b57:	89 f6                	mov    %esi,%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b60 <sys_sleep>:

int
sys_sleep(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b64:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b67:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b6a:	50                   	push   %eax
80105b6b:	6a 00                	push   $0x0
80105b6d:	e8 ae f1 ff ff       	call   80104d20 <argint>
80105b72:	83 c4 10             	add    $0x10,%esp
80105b75:	85 c0                	test   %eax,%eax
80105b77:	0f 88 8a 00 00 00    	js     80105c07 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	68 60 e9 11 80       	push   $0x8011e960
80105b85:	e8 86 ed ff ff       	call   80104910 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b8d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105b90:	8b 1d a0 f1 11 80    	mov    0x8011f1a0,%ebx
  while(ticks - ticks0 < n){
80105b96:	85 d2                	test   %edx,%edx
80105b98:	75 27                	jne    80105bc1 <sys_sleep+0x61>
80105b9a:	eb 54                	jmp    80105bf0 <sys_sleep+0x90>
80105b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ba0:	83 ec 08             	sub    $0x8,%esp
80105ba3:	68 60 e9 11 80       	push   $0x8011e960
80105ba8:	68 a0 f1 11 80       	push   $0x8011f1a0
80105bad:	e8 7e e7 ff ff       	call   80104330 <sleep>
  while(ticks - ticks0 < n){
80105bb2:	a1 a0 f1 11 80       	mov    0x8011f1a0,%eax
80105bb7:	83 c4 10             	add    $0x10,%esp
80105bba:	29 d8                	sub    %ebx,%eax
80105bbc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105bbf:	73 2f                	jae    80105bf0 <sys_sleep+0x90>
    if(myproc()->killed){
80105bc1:	e8 3a e0 ff ff       	call   80103c00 <myproc>
80105bc6:	8b 40 24             	mov    0x24(%eax),%eax
80105bc9:	85 c0                	test   %eax,%eax
80105bcb:	74 d3                	je     80105ba0 <sys_sleep+0x40>
      release(&tickslock);
80105bcd:	83 ec 0c             	sub    $0xc,%esp
80105bd0:	68 60 e9 11 80       	push   $0x8011e960
80105bd5:	e8 f6 ed ff ff       	call   801049d0 <release>
      return -1;
80105bda:	83 c4 10             	add    $0x10,%esp
80105bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105be2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105be5:	c9                   	leave  
80105be6:	c3                   	ret    
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	68 60 e9 11 80       	push   $0x8011e960
80105bf8:	e8 d3 ed ff ff       	call   801049d0 <release>
  return 0;
80105bfd:	83 c4 10             	add    $0x10,%esp
80105c00:	31 c0                	xor    %eax,%eax
}
80105c02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c05:	c9                   	leave  
80105c06:	c3                   	ret    
    return -1;
80105c07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c0c:	eb f4                	jmp    80105c02 <sys_sleep+0xa2>
80105c0e:	66 90                	xchg   %ax,%ax

80105c10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	53                   	push   %ebx
80105c14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c17:	68 60 e9 11 80       	push   $0x8011e960
80105c1c:	e8 ef ec ff ff       	call   80104910 <acquire>
  xticks = ticks;
80105c21:	8b 1d a0 f1 11 80    	mov    0x8011f1a0,%ebx
  release(&tickslock);
80105c27:	c7 04 24 60 e9 11 80 	movl   $0x8011e960,(%esp)
80105c2e:	e8 9d ed ff ff       	call   801049d0 <release>
  return xticks;
}
80105c33:	89 d8                	mov    %ebx,%eax
80105c35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c38:	c9                   	leave  
80105c39:	c3                   	ret    

80105c3a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c3a:	1e                   	push   %ds
  pushl %es
80105c3b:	06                   	push   %es
  pushl %fs
80105c3c:	0f a0                	push   %fs
  pushl %gs
80105c3e:	0f a8                	push   %gs
  pushal
80105c40:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c41:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c45:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c47:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c49:	54                   	push   %esp
  call trap
80105c4a:	e8 c1 00 00 00       	call   80105d10 <trap>
  addl $4, %esp
80105c4f:	83 c4 04             	add    $0x4,%esp

80105c52 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c52:	61                   	popa   
  popl %gs
80105c53:	0f a9                	pop    %gs
  popl %fs
80105c55:	0f a1                	pop    %fs
  popl %es
80105c57:	07                   	pop    %es
  popl %ds
80105c58:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c59:	83 c4 08             	add    $0x8,%esp
  iret
80105c5c:	cf                   	iret   
80105c5d:	66 90                	xchg   %ax,%ax
80105c5f:	90                   	nop

80105c60 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c60:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c61:	31 c0                	xor    %eax,%eax
{
80105c63:	89 e5                	mov    %esp,%ebp
80105c65:	83 ec 08             	sub    $0x8,%esp
80105c68:	90                   	nop
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c70:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105c77:	c7 04 c5 a2 e9 11 80 	movl   $0x8e000008,-0x7fee165e(,%eax,8)
80105c7e:	08 00 00 8e 
80105c82:	66 89 14 c5 a0 e9 11 	mov    %dx,-0x7fee1660(,%eax,8)
80105c89:	80 
80105c8a:	c1 ea 10             	shr    $0x10,%edx
80105c8d:	66 89 14 c5 a6 e9 11 	mov    %dx,-0x7fee165a(,%eax,8)
80105c94:	80 
  for(i = 0; i < 256; i++)
80105c95:	83 c0 01             	add    $0x1,%eax
80105c98:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c9d:	75 d1                	jne    80105c70 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c9f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105ca4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ca7:	c7 05 a2 eb 11 80 08 	movl   $0xef000008,0x8011eba2
80105cae:	00 00 ef 
  initlock(&tickslock, "time");
80105cb1:	68 b5 7c 10 80       	push   $0x80107cb5
80105cb6:	68 60 e9 11 80       	push   $0x8011e960
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cbb:	66 a3 a0 eb 11 80    	mov    %ax,0x8011eba0
80105cc1:	c1 e8 10             	shr    $0x10,%eax
80105cc4:	66 a3 a6 eb 11 80    	mov    %ax,0x8011eba6
  initlock(&tickslock, "time");
80105cca:	e8 01 eb ff ff       	call   801047d0 <initlock>
}
80105ccf:	83 c4 10             	add    $0x10,%esp
80105cd2:	c9                   	leave  
80105cd3:	c3                   	ret    
80105cd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105ce0 <idtinit>:

void
idtinit(void)
{
80105ce0:	55                   	push   %ebp
  pd[0] = size-1;
80105ce1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ce6:	89 e5                	mov    %esp,%ebp
80105ce8:	83 ec 10             	sub    $0x10,%esp
80105ceb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105cef:	b8 a0 e9 11 80       	mov    $0x8011e9a0,%eax
80105cf4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105cf8:	c1 e8 10             	shr    $0x10,%eax
80105cfb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105cff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d02:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d05:	c9                   	leave  
80105d06:	c3                   	ret    
80105d07:	89 f6                	mov    %esi,%esi
80105d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d10 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	57                   	push   %edi
80105d14:	56                   	push   %esi
80105d15:	53                   	push   %ebx
80105d16:	83 ec 1c             	sub    $0x1c,%esp
80105d19:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105d1c:	8b 47 30             	mov    0x30(%edi),%eax
80105d1f:	83 f8 40             	cmp    $0x40,%eax
80105d22:	0f 84 f0 00 00 00    	je     80105e18 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d28:	83 e8 20             	sub    $0x20,%eax
80105d2b:	83 f8 1f             	cmp    $0x1f,%eax
80105d2e:	77 10                	ja     80105d40 <trap+0x30>
80105d30:	ff 24 85 5c 7d 10 80 	jmp    *-0x7fef82a4(,%eax,4)
80105d37:	89 f6                	mov    %esi,%esi
80105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d40:	e8 bb de ff ff       	call   80103c00 <myproc>
80105d45:	85 c0                	test   %eax,%eax
80105d47:	8b 5f 38             	mov    0x38(%edi),%ebx
80105d4a:	0f 84 14 02 00 00    	je     80105f64 <trap+0x254>
80105d50:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105d54:	0f 84 0a 02 00 00    	je     80105f64 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d5a:	0f 20 d1             	mov    %cr2,%ecx
80105d5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d60:	e8 7b de ff ff       	call   80103be0 <cpuid>
80105d65:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d68:	8b 47 34             	mov    0x34(%edi),%eax
80105d6b:	8b 77 30             	mov    0x30(%edi),%esi
80105d6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105d71:	e8 8a de ff ff       	call   80103c00 <myproc>
80105d76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d79:	e8 82 de ff ff       	call   80103c00 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d81:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d84:	51                   	push   %ecx
80105d85:	53                   	push   %ebx
80105d86:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105d87:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d8a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d8d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d8e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d91:	52                   	push   %edx
80105d92:	ff 70 10             	pushl  0x10(%eax)
80105d95:	68 18 7d 10 80       	push   $0x80107d18
80105d9a:	e8 c1 a8 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105d9f:	83 c4 20             	add    $0x20,%esp
80105da2:	e8 59 de ff ff       	call   80103c00 <myproc>
80105da7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dae:	e8 4d de ff ff       	call   80103c00 <myproc>
80105db3:	85 c0                	test   %eax,%eax
80105db5:	74 1d                	je     80105dd4 <trap+0xc4>
80105db7:	e8 44 de ff ff       	call   80103c00 <myproc>
80105dbc:	8b 50 24             	mov    0x24(%eax),%edx
80105dbf:	85 d2                	test   %edx,%edx
80105dc1:	74 11                	je     80105dd4 <trap+0xc4>
80105dc3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105dc7:	83 e0 03             	and    $0x3,%eax
80105dca:	66 83 f8 03          	cmp    $0x3,%ax
80105dce:	0f 84 4c 01 00 00    	je     80105f20 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105dd4:	e8 27 de ff ff       	call   80103c00 <myproc>
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	74 0b                	je     80105de8 <trap+0xd8>
80105ddd:	e8 1e de ff ff       	call   80103c00 <myproc>
80105de2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105de6:	74 68                	je     80105e50 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105de8:	e8 13 de ff ff       	call   80103c00 <myproc>
80105ded:	85 c0                	test   %eax,%eax
80105def:	74 19                	je     80105e0a <trap+0xfa>
80105df1:	e8 0a de ff ff       	call   80103c00 <myproc>
80105df6:	8b 40 24             	mov    0x24(%eax),%eax
80105df9:	85 c0                	test   %eax,%eax
80105dfb:	74 0d                	je     80105e0a <trap+0xfa>
80105dfd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105e01:	83 e0 03             	and    $0x3,%eax
80105e04:	66 83 f8 03          	cmp    $0x3,%ax
80105e08:	74 37                	je     80105e41 <trap+0x131>
    exit();
}
80105e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e0d:	5b                   	pop    %ebx
80105e0e:	5e                   	pop    %esi
80105e0f:	5f                   	pop    %edi
80105e10:	5d                   	pop    %ebp
80105e11:	c3                   	ret    
80105e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105e18:	e8 e3 dd ff ff       	call   80103c00 <myproc>
80105e1d:	8b 58 24             	mov    0x24(%eax),%ebx
80105e20:	85 db                	test   %ebx,%ebx
80105e22:	0f 85 e8 00 00 00    	jne    80105f10 <trap+0x200>
    myproc()->tf = tf;
80105e28:	e8 d3 dd ff ff       	call   80103c00 <myproc>
80105e2d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105e30:	e8 db ef ff ff       	call   80104e10 <syscall>
    if(myproc()->killed)
80105e35:	e8 c6 dd ff ff       	call   80103c00 <myproc>
80105e3a:	8b 48 24             	mov    0x24(%eax),%ecx
80105e3d:	85 c9                	test   %ecx,%ecx
80105e3f:	74 c9                	je     80105e0a <trap+0xfa>
}
80105e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e44:	5b                   	pop    %ebx
80105e45:	5e                   	pop    %esi
80105e46:	5f                   	pop    %edi
80105e47:	5d                   	pop    %ebp
      exit();
80105e48:	e9 63 e3 ff ff       	jmp    801041b0 <exit>
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105e50:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105e54:	75 92                	jne    80105de8 <trap+0xd8>
    yield();
80105e56:	e8 85 e4 ff ff       	call   801042e0 <yield>
80105e5b:	eb 8b                	jmp    80105de8 <trap+0xd8>
80105e5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105e60:	e8 7b dd ff ff       	call   80103be0 <cpuid>
80105e65:	85 c0                	test   %eax,%eax
80105e67:	0f 84 c3 00 00 00    	je     80105f30 <trap+0x220>
    lapiceoi();
80105e6d:	e8 6e cc ff ff       	call   80102ae0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e72:	e8 89 dd ff ff       	call   80103c00 <myproc>
80105e77:	85 c0                	test   %eax,%eax
80105e79:	0f 85 38 ff ff ff    	jne    80105db7 <trap+0xa7>
80105e7f:	e9 50 ff ff ff       	jmp    80105dd4 <trap+0xc4>
80105e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e88:	e8 13 cb ff ff       	call   801029a0 <kbdintr>
    lapiceoi();
80105e8d:	e8 4e cc ff ff       	call   80102ae0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e92:	e8 69 dd ff ff       	call   80103c00 <myproc>
80105e97:	85 c0                	test   %eax,%eax
80105e99:	0f 85 18 ff ff ff    	jne    80105db7 <trap+0xa7>
80105e9f:	e9 30 ff ff ff       	jmp    80105dd4 <trap+0xc4>
80105ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ea8:	e8 53 02 00 00       	call   80106100 <uartintr>
    lapiceoi();
80105ead:	e8 2e cc ff ff       	call   80102ae0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eb2:	e8 49 dd ff ff       	call   80103c00 <myproc>
80105eb7:	85 c0                	test   %eax,%eax
80105eb9:	0f 85 f8 fe ff ff    	jne    80105db7 <trap+0xa7>
80105ebf:	e9 10 ff ff ff       	jmp    80105dd4 <trap+0xc4>
80105ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ec8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105ecc:	8b 77 38             	mov    0x38(%edi),%esi
80105ecf:	e8 0c dd ff ff       	call   80103be0 <cpuid>
80105ed4:	56                   	push   %esi
80105ed5:	53                   	push   %ebx
80105ed6:	50                   	push   %eax
80105ed7:	68 c0 7c 10 80       	push   $0x80107cc0
80105edc:	e8 7f a7 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105ee1:	e8 fa cb ff ff       	call   80102ae0 <lapiceoi>
    break;
80105ee6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ee9:	e8 12 dd ff ff       	call   80103c00 <myproc>
80105eee:	85 c0                	test   %eax,%eax
80105ef0:	0f 85 c1 fe ff ff    	jne    80105db7 <trap+0xa7>
80105ef6:	e9 d9 fe ff ff       	jmp    80105dd4 <trap+0xc4>
80105efb:	90                   	nop
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105f00:	e8 0b c5 ff ff       	call   80102410 <ideintr>
80105f05:	e9 63 ff ff ff       	jmp    80105e6d <trap+0x15d>
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f10:	e8 9b e2 ff ff       	call   801041b0 <exit>
80105f15:	e9 0e ff ff ff       	jmp    80105e28 <trap+0x118>
80105f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105f20:	e8 8b e2 ff ff       	call   801041b0 <exit>
80105f25:	e9 aa fe ff ff       	jmp    80105dd4 <trap+0xc4>
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105f30:	83 ec 0c             	sub    $0xc,%esp
80105f33:	68 60 e9 11 80       	push   $0x8011e960
80105f38:	e8 d3 e9 ff ff       	call   80104910 <acquire>
      wakeup(&ticks);
80105f3d:	c7 04 24 a0 f1 11 80 	movl   $0x8011f1a0,(%esp)
      ticks++;
80105f44:	83 05 a0 f1 11 80 01 	addl   $0x1,0x8011f1a0
      wakeup(&ticks);
80105f4b:	e8 a0 e5 ff ff       	call   801044f0 <wakeup>
      release(&tickslock);
80105f50:	c7 04 24 60 e9 11 80 	movl   $0x8011e960,(%esp)
80105f57:	e8 74 ea ff ff       	call   801049d0 <release>
80105f5c:	83 c4 10             	add    $0x10,%esp
80105f5f:	e9 09 ff ff ff       	jmp    80105e6d <trap+0x15d>
80105f64:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f67:	e8 74 dc ff ff       	call   80103be0 <cpuid>
80105f6c:	83 ec 0c             	sub    $0xc,%esp
80105f6f:	56                   	push   %esi
80105f70:	53                   	push   %ebx
80105f71:	50                   	push   %eax
80105f72:	ff 77 30             	pushl  0x30(%edi)
80105f75:	68 e4 7c 10 80       	push   $0x80107ce4
80105f7a:	e8 e1 a6 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105f7f:	83 c4 14             	add    $0x14,%esp
80105f82:	68 ba 7c 10 80       	push   $0x80107cba
80105f87:	e8 04 a4 ff ff       	call   80100390 <panic>
80105f8c:	66 90                	xchg   %ax,%ax
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f90:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105f95:	55                   	push   %ebp
80105f96:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105f98:	85 c0                	test   %eax,%eax
80105f9a:	74 1c                	je     80105fb8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f9c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fa1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105fa2:	a8 01                	test   $0x1,%al
80105fa4:	74 12                	je     80105fb8 <uartgetc+0x28>
80105fa6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105fac:	0f b6 c0             	movzbl %al,%eax
}
80105faf:	5d                   	pop    %ebp
80105fb0:	c3                   	ret    
80105fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fbd:	5d                   	pop    %ebp
80105fbe:	c3                   	ret    
80105fbf:	90                   	nop

80105fc0 <uartputc.part.0>:
uartputc(int c)
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	57                   	push   %edi
80105fc4:	56                   	push   %esi
80105fc5:	53                   	push   %ebx
80105fc6:	89 c7                	mov    %eax,%edi
80105fc8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fcd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105fd2:	83 ec 0c             	sub    $0xc,%esp
80105fd5:	eb 1b                	jmp    80105ff2 <uartputc.part.0+0x32>
80105fd7:	89 f6                	mov    %esi,%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	6a 0a                	push   $0xa
80105fe5:	e8 16 cb ff ff       	call   80102b00 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fea:	83 c4 10             	add    $0x10,%esp
80105fed:	83 eb 01             	sub    $0x1,%ebx
80105ff0:	74 07                	je     80105ff9 <uartputc.part.0+0x39>
80105ff2:	89 f2                	mov    %esi,%edx
80105ff4:	ec                   	in     (%dx),%al
80105ff5:	a8 20                	test   $0x20,%al
80105ff7:	74 e7                	je     80105fe0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ff9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ffe:	89 f8                	mov    %edi,%eax
80106000:	ee                   	out    %al,(%dx)
}
80106001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106004:	5b                   	pop    %ebx
80106005:	5e                   	pop    %esi
80106006:	5f                   	pop    %edi
80106007:	5d                   	pop    %ebp
80106008:	c3                   	ret    
80106009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106010 <uartinit>:
{
80106010:	55                   	push   %ebp
80106011:	31 c9                	xor    %ecx,%ecx
80106013:	89 c8                	mov    %ecx,%eax
80106015:	89 e5                	mov    %esp,%ebp
80106017:	57                   	push   %edi
80106018:	56                   	push   %esi
80106019:	53                   	push   %ebx
8010601a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010601f:	89 da                	mov    %ebx,%edx
80106021:	83 ec 0c             	sub    $0xc,%esp
80106024:	ee                   	out    %al,(%dx)
80106025:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010602a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010602f:	89 fa                	mov    %edi,%edx
80106031:	ee                   	out    %al,(%dx)
80106032:	b8 0c 00 00 00       	mov    $0xc,%eax
80106037:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010603c:	ee                   	out    %al,(%dx)
8010603d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106042:	89 c8                	mov    %ecx,%eax
80106044:	89 f2                	mov    %esi,%edx
80106046:	ee                   	out    %al,(%dx)
80106047:	b8 03 00 00 00       	mov    $0x3,%eax
8010604c:	89 fa                	mov    %edi,%edx
8010604e:	ee                   	out    %al,(%dx)
8010604f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106054:	89 c8                	mov    %ecx,%eax
80106056:	ee                   	out    %al,(%dx)
80106057:	b8 01 00 00 00       	mov    $0x1,%eax
8010605c:	89 f2                	mov    %esi,%edx
8010605e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010605f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106064:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106065:	3c ff                	cmp    $0xff,%al
80106067:	74 5a                	je     801060c3 <uartinit+0xb3>
  uart = 1;
80106069:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80106070:	00 00 00 
80106073:	89 da                	mov    %ebx,%edx
80106075:	ec                   	in     (%dx),%al
80106076:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010607b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010607c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010607f:	bb dc 7d 10 80       	mov    $0x80107ddc,%ebx
  ioapicenable(IRQ_COM1, 0);
80106084:	6a 00                	push   $0x0
80106086:	6a 04                	push   $0x4
80106088:	e8 d3 c5 ff ff       	call   80102660 <ioapicenable>
8010608d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106090:	b8 78 00 00 00       	mov    $0x78,%eax
80106095:	eb 13                	jmp    801060aa <uartinit+0x9a>
80106097:	89 f6                	mov    %esi,%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060a0:	83 c3 01             	add    $0x1,%ebx
801060a3:	0f be 03             	movsbl (%ebx),%eax
801060a6:	84 c0                	test   %al,%al
801060a8:	74 19                	je     801060c3 <uartinit+0xb3>
  if(!uart)
801060aa:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
801060b0:	85 d2                	test   %edx,%edx
801060b2:	74 ec                	je     801060a0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801060b4:	83 c3 01             	add    $0x1,%ebx
801060b7:	e8 04 ff ff ff       	call   80105fc0 <uartputc.part.0>
801060bc:	0f be 03             	movsbl (%ebx),%eax
801060bf:	84 c0                	test   %al,%al
801060c1:	75 e7                	jne    801060aa <uartinit+0x9a>
}
801060c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060c6:	5b                   	pop    %ebx
801060c7:	5e                   	pop    %esi
801060c8:	5f                   	pop    %edi
801060c9:	5d                   	pop    %ebp
801060ca:	c3                   	ret    
801060cb:	90                   	nop
801060cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060d0 <uartputc>:
  if(!uart)
801060d0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
801060d6:	55                   	push   %ebp
801060d7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801060d9:	85 d2                	test   %edx,%edx
{
801060db:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801060de:	74 10                	je     801060f0 <uartputc+0x20>
}
801060e0:	5d                   	pop    %ebp
801060e1:	e9 da fe ff ff       	jmp    80105fc0 <uartputc.part.0>
801060e6:	8d 76 00             	lea    0x0(%esi),%esi
801060e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060f0:	5d                   	pop    %ebp
801060f1:	c3                   	ret    
801060f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106100 <uartintr>:

void
uartintr(void)
{
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
80106103:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106106:	68 90 5f 10 80       	push   $0x80105f90
8010610b:	e8 00 a7 ff ff       	call   80100810 <consoleintr>
}
80106110:	83 c4 10             	add    $0x10,%esp
80106113:	c9                   	leave  
80106114:	c3                   	ret    

80106115 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $0
80106117:	6a 00                	push   $0x0
  jmp alltraps
80106119:	e9 1c fb ff ff       	jmp    80105c3a <alltraps>

8010611e <vector1>:
.globl vector1
vector1:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $1
80106120:	6a 01                	push   $0x1
  jmp alltraps
80106122:	e9 13 fb ff ff       	jmp    80105c3a <alltraps>

80106127 <vector2>:
.globl vector2
vector2:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $2
80106129:	6a 02                	push   $0x2
  jmp alltraps
8010612b:	e9 0a fb ff ff       	jmp    80105c3a <alltraps>

80106130 <vector3>:
.globl vector3
vector3:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $3
80106132:	6a 03                	push   $0x3
  jmp alltraps
80106134:	e9 01 fb ff ff       	jmp    80105c3a <alltraps>

80106139 <vector4>:
.globl vector4
vector4:
  pushl $0
80106139:	6a 00                	push   $0x0
  pushl $4
8010613b:	6a 04                	push   $0x4
  jmp alltraps
8010613d:	e9 f8 fa ff ff       	jmp    80105c3a <alltraps>

80106142 <vector5>:
.globl vector5
vector5:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $5
80106144:	6a 05                	push   $0x5
  jmp alltraps
80106146:	e9 ef fa ff ff       	jmp    80105c3a <alltraps>

8010614b <vector6>:
.globl vector6
vector6:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $6
8010614d:	6a 06                	push   $0x6
  jmp alltraps
8010614f:	e9 e6 fa ff ff       	jmp    80105c3a <alltraps>

80106154 <vector7>:
.globl vector7
vector7:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $7
80106156:	6a 07                	push   $0x7
  jmp alltraps
80106158:	e9 dd fa ff ff       	jmp    80105c3a <alltraps>

8010615d <vector8>:
.globl vector8
vector8:
  pushl $8
8010615d:	6a 08                	push   $0x8
  jmp alltraps
8010615f:	e9 d6 fa ff ff       	jmp    80105c3a <alltraps>

80106164 <vector9>:
.globl vector9
vector9:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $9
80106166:	6a 09                	push   $0x9
  jmp alltraps
80106168:	e9 cd fa ff ff       	jmp    80105c3a <alltraps>

8010616d <vector10>:
.globl vector10
vector10:
  pushl $10
8010616d:	6a 0a                	push   $0xa
  jmp alltraps
8010616f:	e9 c6 fa ff ff       	jmp    80105c3a <alltraps>

80106174 <vector11>:
.globl vector11
vector11:
  pushl $11
80106174:	6a 0b                	push   $0xb
  jmp alltraps
80106176:	e9 bf fa ff ff       	jmp    80105c3a <alltraps>

8010617b <vector12>:
.globl vector12
vector12:
  pushl $12
8010617b:	6a 0c                	push   $0xc
  jmp alltraps
8010617d:	e9 b8 fa ff ff       	jmp    80105c3a <alltraps>

80106182 <vector13>:
.globl vector13
vector13:
  pushl $13
80106182:	6a 0d                	push   $0xd
  jmp alltraps
80106184:	e9 b1 fa ff ff       	jmp    80105c3a <alltraps>

80106189 <vector14>:
.globl vector14
vector14:
  pushl $14
80106189:	6a 0e                	push   $0xe
  jmp alltraps
8010618b:	e9 aa fa ff ff       	jmp    80105c3a <alltraps>

80106190 <vector15>:
.globl vector15
vector15:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $15
80106192:	6a 0f                	push   $0xf
  jmp alltraps
80106194:	e9 a1 fa ff ff       	jmp    80105c3a <alltraps>

80106199 <vector16>:
.globl vector16
vector16:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $16
8010619b:	6a 10                	push   $0x10
  jmp alltraps
8010619d:	e9 98 fa ff ff       	jmp    80105c3a <alltraps>

801061a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801061a2:	6a 11                	push   $0x11
  jmp alltraps
801061a4:	e9 91 fa ff ff       	jmp    80105c3a <alltraps>

801061a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $18
801061ab:	6a 12                	push   $0x12
  jmp alltraps
801061ad:	e9 88 fa ff ff       	jmp    80105c3a <alltraps>

801061b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $19
801061b4:	6a 13                	push   $0x13
  jmp alltraps
801061b6:	e9 7f fa ff ff       	jmp    80105c3a <alltraps>

801061bb <vector20>:
.globl vector20
vector20:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $20
801061bd:	6a 14                	push   $0x14
  jmp alltraps
801061bf:	e9 76 fa ff ff       	jmp    80105c3a <alltraps>

801061c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $21
801061c6:	6a 15                	push   $0x15
  jmp alltraps
801061c8:	e9 6d fa ff ff       	jmp    80105c3a <alltraps>

801061cd <vector22>:
.globl vector22
vector22:
  pushl $0
801061cd:	6a 00                	push   $0x0
  pushl $22
801061cf:	6a 16                	push   $0x16
  jmp alltraps
801061d1:	e9 64 fa ff ff       	jmp    80105c3a <alltraps>

801061d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $23
801061d8:	6a 17                	push   $0x17
  jmp alltraps
801061da:	e9 5b fa ff ff       	jmp    80105c3a <alltraps>

801061df <vector24>:
.globl vector24
vector24:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $24
801061e1:	6a 18                	push   $0x18
  jmp alltraps
801061e3:	e9 52 fa ff ff       	jmp    80105c3a <alltraps>

801061e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801061e8:	6a 00                	push   $0x0
  pushl $25
801061ea:	6a 19                	push   $0x19
  jmp alltraps
801061ec:	e9 49 fa ff ff       	jmp    80105c3a <alltraps>

801061f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801061f1:	6a 00                	push   $0x0
  pushl $26
801061f3:	6a 1a                	push   $0x1a
  jmp alltraps
801061f5:	e9 40 fa ff ff       	jmp    80105c3a <alltraps>

801061fa <vector27>:
.globl vector27
vector27:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $27
801061fc:	6a 1b                	push   $0x1b
  jmp alltraps
801061fe:	e9 37 fa ff ff       	jmp    80105c3a <alltraps>

80106203 <vector28>:
.globl vector28
vector28:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $28
80106205:	6a 1c                	push   $0x1c
  jmp alltraps
80106207:	e9 2e fa ff ff       	jmp    80105c3a <alltraps>

8010620c <vector29>:
.globl vector29
vector29:
  pushl $0
8010620c:	6a 00                	push   $0x0
  pushl $29
8010620e:	6a 1d                	push   $0x1d
  jmp alltraps
80106210:	e9 25 fa ff ff       	jmp    80105c3a <alltraps>

80106215 <vector30>:
.globl vector30
vector30:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $30
80106217:	6a 1e                	push   $0x1e
  jmp alltraps
80106219:	e9 1c fa ff ff       	jmp    80105c3a <alltraps>

8010621e <vector31>:
.globl vector31
vector31:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $31
80106220:	6a 1f                	push   $0x1f
  jmp alltraps
80106222:	e9 13 fa ff ff       	jmp    80105c3a <alltraps>

80106227 <vector32>:
.globl vector32
vector32:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $32
80106229:	6a 20                	push   $0x20
  jmp alltraps
8010622b:	e9 0a fa ff ff       	jmp    80105c3a <alltraps>

80106230 <vector33>:
.globl vector33
vector33:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $33
80106232:	6a 21                	push   $0x21
  jmp alltraps
80106234:	e9 01 fa ff ff       	jmp    80105c3a <alltraps>

80106239 <vector34>:
.globl vector34
vector34:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $34
8010623b:	6a 22                	push   $0x22
  jmp alltraps
8010623d:	e9 f8 f9 ff ff       	jmp    80105c3a <alltraps>

80106242 <vector35>:
.globl vector35
vector35:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $35
80106244:	6a 23                	push   $0x23
  jmp alltraps
80106246:	e9 ef f9 ff ff       	jmp    80105c3a <alltraps>

8010624b <vector36>:
.globl vector36
vector36:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $36
8010624d:	6a 24                	push   $0x24
  jmp alltraps
8010624f:	e9 e6 f9 ff ff       	jmp    80105c3a <alltraps>

80106254 <vector37>:
.globl vector37
vector37:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $37
80106256:	6a 25                	push   $0x25
  jmp alltraps
80106258:	e9 dd f9 ff ff       	jmp    80105c3a <alltraps>

8010625d <vector38>:
.globl vector38
vector38:
  pushl $0
8010625d:	6a 00                	push   $0x0
  pushl $38
8010625f:	6a 26                	push   $0x26
  jmp alltraps
80106261:	e9 d4 f9 ff ff       	jmp    80105c3a <alltraps>

80106266 <vector39>:
.globl vector39
vector39:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $39
80106268:	6a 27                	push   $0x27
  jmp alltraps
8010626a:	e9 cb f9 ff ff       	jmp    80105c3a <alltraps>

8010626f <vector40>:
.globl vector40
vector40:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $40
80106271:	6a 28                	push   $0x28
  jmp alltraps
80106273:	e9 c2 f9 ff ff       	jmp    80105c3a <alltraps>

80106278 <vector41>:
.globl vector41
vector41:
  pushl $0
80106278:	6a 00                	push   $0x0
  pushl $41
8010627a:	6a 29                	push   $0x29
  jmp alltraps
8010627c:	e9 b9 f9 ff ff       	jmp    80105c3a <alltraps>

80106281 <vector42>:
.globl vector42
vector42:
  pushl $0
80106281:	6a 00                	push   $0x0
  pushl $42
80106283:	6a 2a                	push   $0x2a
  jmp alltraps
80106285:	e9 b0 f9 ff ff       	jmp    80105c3a <alltraps>

8010628a <vector43>:
.globl vector43
vector43:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $43
8010628c:	6a 2b                	push   $0x2b
  jmp alltraps
8010628e:	e9 a7 f9 ff ff       	jmp    80105c3a <alltraps>

80106293 <vector44>:
.globl vector44
vector44:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $44
80106295:	6a 2c                	push   $0x2c
  jmp alltraps
80106297:	e9 9e f9 ff ff       	jmp    80105c3a <alltraps>

8010629c <vector45>:
.globl vector45
vector45:
  pushl $0
8010629c:	6a 00                	push   $0x0
  pushl $45
8010629e:	6a 2d                	push   $0x2d
  jmp alltraps
801062a0:	e9 95 f9 ff ff       	jmp    80105c3a <alltraps>

801062a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $46
801062a7:	6a 2e                	push   $0x2e
  jmp alltraps
801062a9:	e9 8c f9 ff ff       	jmp    80105c3a <alltraps>

801062ae <vector47>:
.globl vector47
vector47:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $47
801062b0:	6a 2f                	push   $0x2f
  jmp alltraps
801062b2:	e9 83 f9 ff ff       	jmp    80105c3a <alltraps>

801062b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $48
801062b9:	6a 30                	push   $0x30
  jmp alltraps
801062bb:	e9 7a f9 ff ff       	jmp    80105c3a <alltraps>

801062c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $49
801062c2:	6a 31                	push   $0x31
  jmp alltraps
801062c4:	e9 71 f9 ff ff       	jmp    80105c3a <alltraps>

801062c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $50
801062cb:	6a 32                	push   $0x32
  jmp alltraps
801062cd:	e9 68 f9 ff ff       	jmp    80105c3a <alltraps>

801062d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $51
801062d4:	6a 33                	push   $0x33
  jmp alltraps
801062d6:	e9 5f f9 ff ff       	jmp    80105c3a <alltraps>

801062db <vector52>:
.globl vector52
vector52:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $52
801062dd:	6a 34                	push   $0x34
  jmp alltraps
801062df:	e9 56 f9 ff ff       	jmp    80105c3a <alltraps>

801062e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $53
801062e6:	6a 35                	push   $0x35
  jmp alltraps
801062e8:	e9 4d f9 ff ff       	jmp    80105c3a <alltraps>

801062ed <vector54>:
.globl vector54
vector54:
  pushl $0
801062ed:	6a 00                	push   $0x0
  pushl $54
801062ef:	6a 36                	push   $0x36
  jmp alltraps
801062f1:	e9 44 f9 ff ff       	jmp    80105c3a <alltraps>

801062f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $55
801062f8:	6a 37                	push   $0x37
  jmp alltraps
801062fa:	e9 3b f9 ff ff       	jmp    80105c3a <alltraps>

801062ff <vector56>:
.globl vector56
vector56:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $56
80106301:	6a 38                	push   $0x38
  jmp alltraps
80106303:	e9 32 f9 ff ff       	jmp    80105c3a <alltraps>

80106308 <vector57>:
.globl vector57
vector57:
  pushl $0
80106308:	6a 00                	push   $0x0
  pushl $57
8010630a:	6a 39                	push   $0x39
  jmp alltraps
8010630c:	e9 29 f9 ff ff       	jmp    80105c3a <alltraps>

80106311 <vector58>:
.globl vector58
vector58:
  pushl $0
80106311:	6a 00                	push   $0x0
  pushl $58
80106313:	6a 3a                	push   $0x3a
  jmp alltraps
80106315:	e9 20 f9 ff ff       	jmp    80105c3a <alltraps>

8010631a <vector59>:
.globl vector59
vector59:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $59
8010631c:	6a 3b                	push   $0x3b
  jmp alltraps
8010631e:	e9 17 f9 ff ff       	jmp    80105c3a <alltraps>

80106323 <vector60>:
.globl vector60
vector60:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $60
80106325:	6a 3c                	push   $0x3c
  jmp alltraps
80106327:	e9 0e f9 ff ff       	jmp    80105c3a <alltraps>

8010632c <vector61>:
.globl vector61
vector61:
  pushl $0
8010632c:	6a 00                	push   $0x0
  pushl $61
8010632e:	6a 3d                	push   $0x3d
  jmp alltraps
80106330:	e9 05 f9 ff ff       	jmp    80105c3a <alltraps>

80106335 <vector62>:
.globl vector62
vector62:
  pushl $0
80106335:	6a 00                	push   $0x0
  pushl $62
80106337:	6a 3e                	push   $0x3e
  jmp alltraps
80106339:	e9 fc f8 ff ff       	jmp    80105c3a <alltraps>

8010633e <vector63>:
.globl vector63
vector63:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $63
80106340:	6a 3f                	push   $0x3f
  jmp alltraps
80106342:	e9 f3 f8 ff ff       	jmp    80105c3a <alltraps>

80106347 <vector64>:
.globl vector64
vector64:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $64
80106349:	6a 40                	push   $0x40
  jmp alltraps
8010634b:	e9 ea f8 ff ff       	jmp    80105c3a <alltraps>

80106350 <vector65>:
.globl vector65
vector65:
  pushl $0
80106350:	6a 00                	push   $0x0
  pushl $65
80106352:	6a 41                	push   $0x41
  jmp alltraps
80106354:	e9 e1 f8 ff ff       	jmp    80105c3a <alltraps>

80106359 <vector66>:
.globl vector66
vector66:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $66
8010635b:	6a 42                	push   $0x42
  jmp alltraps
8010635d:	e9 d8 f8 ff ff       	jmp    80105c3a <alltraps>

80106362 <vector67>:
.globl vector67
vector67:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $67
80106364:	6a 43                	push   $0x43
  jmp alltraps
80106366:	e9 cf f8 ff ff       	jmp    80105c3a <alltraps>

8010636b <vector68>:
.globl vector68
vector68:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $68
8010636d:	6a 44                	push   $0x44
  jmp alltraps
8010636f:	e9 c6 f8 ff ff       	jmp    80105c3a <alltraps>

80106374 <vector69>:
.globl vector69
vector69:
  pushl $0
80106374:	6a 00                	push   $0x0
  pushl $69
80106376:	6a 45                	push   $0x45
  jmp alltraps
80106378:	e9 bd f8 ff ff       	jmp    80105c3a <alltraps>

8010637d <vector70>:
.globl vector70
vector70:
  pushl $0
8010637d:	6a 00                	push   $0x0
  pushl $70
8010637f:	6a 46                	push   $0x46
  jmp alltraps
80106381:	e9 b4 f8 ff ff       	jmp    80105c3a <alltraps>

80106386 <vector71>:
.globl vector71
vector71:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $71
80106388:	6a 47                	push   $0x47
  jmp alltraps
8010638a:	e9 ab f8 ff ff       	jmp    80105c3a <alltraps>

8010638f <vector72>:
.globl vector72
vector72:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $72
80106391:	6a 48                	push   $0x48
  jmp alltraps
80106393:	e9 a2 f8 ff ff       	jmp    80105c3a <alltraps>

80106398 <vector73>:
.globl vector73
vector73:
  pushl $0
80106398:	6a 00                	push   $0x0
  pushl $73
8010639a:	6a 49                	push   $0x49
  jmp alltraps
8010639c:	e9 99 f8 ff ff       	jmp    80105c3a <alltraps>

801063a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801063a1:	6a 00                	push   $0x0
  pushl $74
801063a3:	6a 4a                	push   $0x4a
  jmp alltraps
801063a5:	e9 90 f8 ff ff       	jmp    80105c3a <alltraps>

801063aa <vector75>:
.globl vector75
vector75:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $75
801063ac:	6a 4b                	push   $0x4b
  jmp alltraps
801063ae:	e9 87 f8 ff ff       	jmp    80105c3a <alltraps>

801063b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $76
801063b5:	6a 4c                	push   $0x4c
  jmp alltraps
801063b7:	e9 7e f8 ff ff       	jmp    80105c3a <alltraps>

801063bc <vector77>:
.globl vector77
vector77:
  pushl $0
801063bc:	6a 00                	push   $0x0
  pushl $77
801063be:	6a 4d                	push   $0x4d
  jmp alltraps
801063c0:	e9 75 f8 ff ff       	jmp    80105c3a <alltraps>

801063c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063c5:	6a 00                	push   $0x0
  pushl $78
801063c7:	6a 4e                	push   $0x4e
  jmp alltraps
801063c9:	e9 6c f8 ff ff       	jmp    80105c3a <alltraps>

801063ce <vector79>:
.globl vector79
vector79:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $79
801063d0:	6a 4f                	push   $0x4f
  jmp alltraps
801063d2:	e9 63 f8 ff ff       	jmp    80105c3a <alltraps>

801063d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $80
801063d9:	6a 50                	push   $0x50
  jmp alltraps
801063db:	e9 5a f8 ff ff       	jmp    80105c3a <alltraps>

801063e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801063e0:	6a 00                	push   $0x0
  pushl $81
801063e2:	6a 51                	push   $0x51
  jmp alltraps
801063e4:	e9 51 f8 ff ff       	jmp    80105c3a <alltraps>

801063e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $82
801063eb:	6a 52                	push   $0x52
  jmp alltraps
801063ed:	e9 48 f8 ff ff       	jmp    80105c3a <alltraps>

801063f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $83
801063f4:	6a 53                	push   $0x53
  jmp alltraps
801063f6:	e9 3f f8 ff ff       	jmp    80105c3a <alltraps>

801063fb <vector84>:
.globl vector84
vector84:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $84
801063fd:	6a 54                	push   $0x54
  jmp alltraps
801063ff:	e9 36 f8 ff ff       	jmp    80105c3a <alltraps>

80106404 <vector85>:
.globl vector85
vector85:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $85
80106406:	6a 55                	push   $0x55
  jmp alltraps
80106408:	e9 2d f8 ff ff       	jmp    80105c3a <alltraps>

8010640d <vector86>:
.globl vector86
vector86:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $86
8010640f:	6a 56                	push   $0x56
  jmp alltraps
80106411:	e9 24 f8 ff ff       	jmp    80105c3a <alltraps>

80106416 <vector87>:
.globl vector87
vector87:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $87
80106418:	6a 57                	push   $0x57
  jmp alltraps
8010641a:	e9 1b f8 ff ff       	jmp    80105c3a <alltraps>

8010641f <vector88>:
.globl vector88
vector88:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $88
80106421:	6a 58                	push   $0x58
  jmp alltraps
80106423:	e9 12 f8 ff ff       	jmp    80105c3a <alltraps>

80106428 <vector89>:
.globl vector89
vector89:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $89
8010642a:	6a 59                	push   $0x59
  jmp alltraps
8010642c:	e9 09 f8 ff ff       	jmp    80105c3a <alltraps>

80106431 <vector90>:
.globl vector90
vector90:
  pushl $0
80106431:	6a 00                	push   $0x0
  pushl $90
80106433:	6a 5a                	push   $0x5a
  jmp alltraps
80106435:	e9 00 f8 ff ff       	jmp    80105c3a <alltraps>

8010643a <vector91>:
.globl vector91
vector91:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $91
8010643c:	6a 5b                	push   $0x5b
  jmp alltraps
8010643e:	e9 f7 f7 ff ff       	jmp    80105c3a <alltraps>

80106443 <vector92>:
.globl vector92
vector92:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $92
80106445:	6a 5c                	push   $0x5c
  jmp alltraps
80106447:	e9 ee f7 ff ff       	jmp    80105c3a <alltraps>

8010644c <vector93>:
.globl vector93
vector93:
  pushl $0
8010644c:	6a 00                	push   $0x0
  pushl $93
8010644e:	6a 5d                	push   $0x5d
  jmp alltraps
80106450:	e9 e5 f7 ff ff       	jmp    80105c3a <alltraps>

80106455 <vector94>:
.globl vector94
vector94:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $94
80106457:	6a 5e                	push   $0x5e
  jmp alltraps
80106459:	e9 dc f7 ff ff       	jmp    80105c3a <alltraps>

8010645e <vector95>:
.globl vector95
vector95:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $95
80106460:	6a 5f                	push   $0x5f
  jmp alltraps
80106462:	e9 d3 f7 ff ff       	jmp    80105c3a <alltraps>

80106467 <vector96>:
.globl vector96
vector96:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $96
80106469:	6a 60                	push   $0x60
  jmp alltraps
8010646b:	e9 ca f7 ff ff       	jmp    80105c3a <alltraps>

80106470 <vector97>:
.globl vector97
vector97:
  pushl $0
80106470:	6a 00                	push   $0x0
  pushl $97
80106472:	6a 61                	push   $0x61
  jmp alltraps
80106474:	e9 c1 f7 ff ff       	jmp    80105c3a <alltraps>

80106479 <vector98>:
.globl vector98
vector98:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $98
8010647b:	6a 62                	push   $0x62
  jmp alltraps
8010647d:	e9 b8 f7 ff ff       	jmp    80105c3a <alltraps>

80106482 <vector99>:
.globl vector99
vector99:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $99
80106484:	6a 63                	push   $0x63
  jmp alltraps
80106486:	e9 af f7 ff ff       	jmp    80105c3a <alltraps>

8010648b <vector100>:
.globl vector100
vector100:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $100
8010648d:	6a 64                	push   $0x64
  jmp alltraps
8010648f:	e9 a6 f7 ff ff       	jmp    80105c3a <alltraps>

80106494 <vector101>:
.globl vector101
vector101:
  pushl $0
80106494:	6a 00                	push   $0x0
  pushl $101
80106496:	6a 65                	push   $0x65
  jmp alltraps
80106498:	e9 9d f7 ff ff       	jmp    80105c3a <alltraps>

8010649d <vector102>:
.globl vector102
vector102:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $102
8010649f:	6a 66                	push   $0x66
  jmp alltraps
801064a1:	e9 94 f7 ff ff       	jmp    80105c3a <alltraps>

801064a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $103
801064a8:	6a 67                	push   $0x67
  jmp alltraps
801064aa:	e9 8b f7 ff ff       	jmp    80105c3a <alltraps>

801064af <vector104>:
.globl vector104
vector104:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $104
801064b1:	6a 68                	push   $0x68
  jmp alltraps
801064b3:	e9 82 f7 ff ff       	jmp    80105c3a <alltraps>

801064b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $105
801064ba:	6a 69                	push   $0x69
  jmp alltraps
801064bc:	e9 79 f7 ff ff       	jmp    80105c3a <alltraps>

801064c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $106
801064c3:	6a 6a                	push   $0x6a
  jmp alltraps
801064c5:	e9 70 f7 ff ff       	jmp    80105c3a <alltraps>

801064ca <vector107>:
.globl vector107
vector107:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $107
801064cc:	6a 6b                	push   $0x6b
  jmp alltraps
801064ce:	e9 67 f7 ff ff       	jmp    80105c3a <alltraps>

801064d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $108
801064d5:	6a 6c                	push   $0x6c
  jmp alltraps
801064d7:	e9 5e f7 ff ff       	jmp    80105c3a <alltraps>

801064dc <vector109>:
.globl vector109
vector109:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $109
801064de:	6a 6d                	push   $0x6d
  jmp alltraps
801064e0:	e9 55 f7 ff ff       	jmp    80105c3a <alltraps>

801064e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $110
801064e7:	6a 6e                	push   $0x6e
  jmp alltraps
801064e9:	e9 4c f7 ff ff       	jmp    80105c3a <alltraps>

801064ee <vector111>:
.globl vector111
vector111:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $111
801064f0:	6a 6f                	push   $0x6f
  jmp alltraps
801064f2:	e9 43 f7 ff ff       	jmp    80105c3a <alltraps>

801064f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $112
801064f9:	6a 70                	push   $0x70
  jmp alltraps
801064fb:	e9 3a f7 ff ff       	jmp    80105c3a <alltraps>

80106500 <vector113>:
.globl vector113
vector113:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $113
80106502:	6a 71                	push   $0x71
  jmp alltraps
80106504:	e9 31 f7 ff ff       	jmp    80105c3a <alltraps>

80106509 <vector114>:
.globl vector114
vector114:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $114
8010650b:	6a 72                	push   $0x72
  jmp alltraps
8010650d:	e9 28 f7 ff ff       	jmp    80105c3a <alltraps>

80106512 <vector115>:
.globl vector115
vector115:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $115
80106514:	6a 73                	push   $0x73
  jmp alltraps
80106516:	e9 1f f7 ff ff       	jmp    80105c3a <alltraps>

8010651b <vector116>:
.globl vector116
vector116:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $116
8010651d:	6a 74                	push   $0x74
  jmp alltraps
8010651f:	e9 16 f7 ff ff       	jmp    80105c3a <alltraps>

80106524 <vector117>:
.globl vector117
vector117:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $117
80106526:	6a 75                	push   $0x75
  jmp alltraps
80106528:	e9 0d f7 ff ff       	jmp    80105c3a <alltraps>

8010652d <vector118>:
.globl vector118
vector118:
  pushl $0
8010652d:	6a 00                	push   $0x0
  pushl $118
8010652f:	6a 76                	push   $0x76
  jmp alltraps
80106531:	e9 04 f7 ff ff       	jmp    80105c3a <alltraps>

80106536 <vector119>:
.globl vector119
vector119:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $119
80106538:	6a 77                	push   $0x77
  jmp alltraps
8010653a:	e9 fb f6 ff ff       	jmp    80105c3a <alltraps>

8010653f <vector120>:
.globl vector120
vector120:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $120
80106541:	6a 78                	push   $0x78
  jmp alltraps
80106543:	e9 f2 f6 ff ff       	jmp    80105c3a <alltraps>

80106548 <vector121>:
.globl vector121
vector121:
  pushl $0
80106548:	6a 00                	push   $0x0
  pushl $121
8010654a:	6a 79                	push   $0x79
  jmp alltraps
8010654c:	e9 e9 f6 ff ff       	jmp    80105c3a <alltraps>

80106551 <vector122>:
.globl vector122
vector122:
  pushl $0
80106551:	6a 00                	push   $0x0
  pushl $122
80106553:	6a 7a                	push   $0x7a
  jmp alltraps
80106555:	e9 e0 f6 ff ff       	jmp    80105c3a <alltraps>

8010655a <vector123>:
.globl vector123
vector123:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $123
8010655c:	6a 7b                	push   $0x7b
  jmp alltraps
8010655e:	e9 d7 f6 ff ff       	jmp    80105c3a <alltraps>

80106563 <vector124>:
.globl vector124
vector124:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $124
80106565:	6a 7c                	push   $0x7c
  jmp alltraps
80106567:	e9 ce f6 ff ff       	jmp    80105c3a <alltraps>

8010656c <vector125>:
.globl vector125
vector125:
  pushl $0
8010656c:	6a 00                	push   $0x0
  pushl $125
8010656e:	6a 7d                	push   $0x7d
  jmp alltraps
80106570:	e9 c5 f6 ff ff       	jmp    80105c3a <alltraps>

80106575 <vector126>:
.globl vector126
vector126:
  pushl $0
80106575:	6a 00                	push   $0x0
  pushl $126
80106577:	6a 7e                	push   $0x7e
  jmp alltraps
80106579:	e9 bc f6 ff ff       	jmp    80105c3a <alltraps>

8010657e <vector127>:
.globl vector127
vector127:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $127
80106580:	6a 7f                	push   $0x7f
  jmp alltraps
80106582:	e9 b3 f6 ff ff       	jmp    80105c3a <alltraps>

80106587 <vector128>:
.globl vector128
vector128:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $128
80106589:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010658e:	e9 a7 f6 ff ff       	jmp    80105c3a <alltraps>

80106593 <vector129>:
.globl vector129
vector129:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $129
80106595:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010659a:	e9 9b f6 ff ff       	jmp    80105c3a <alltraps>

8010659f <vector130>:
.globl vector130
vector130:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $130
801065a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065a6:	e9 8f f6 ff ff       	jmp    80105c3a <alltraps>

801065ab <vector131>:
.globl vector131
vector131:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $131
801065ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065b2:	e9 83 f6 ff ff       	jmp    80105c3a <alltraps>

801065b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $132
801065b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065be:	e9 77 f6 ff ff       	jmp    80105c3a <alltraps>

801065c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $133
801065c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065ca:	e9 6b f6 ff ff       	jmp    80105c3a <alltraps>

801065cf <vector134>:
.globl vector134
vector134:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $134
801065d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801065d6:	e9 5f f6 ff ff       	jmp    80105c3a <alltraps>

801065db <vector135>:
.globl vector135
vector135:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $135
801065dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801065e2:	e9 53 f6 ff ff       	jmp    80105c3a <alltraps>

801065e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $136
801065e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801065ee:	e9 47 f6 ff ff       	jmp    80105c3a <alltraps>

801065f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $137
801065f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801065fa:	e9 3b f6 ff ff       	jmp    80105c3a <alltraps>

801065ff <vector138>:
.globl vector138
vector138:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $138
80106601:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106606:	e9 2f f6 ff ff       	jmp    80105c3a <alltraps>

8010660b <vector139>:
.globl vector139
vector139:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $139
8010660d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106612:	e9 23 f6 ff ff       	jmp    80105c3a <alltraps>

80106617 <vector140>:
.globl vector140
vector140:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $140
80106619:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010661e:	e9 17 f6 ff ff       	jmp    80105c3a <alltraps>

80106623 <vector141>:
.globl vector141
vector141:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $141
80106625:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010662a:	e9 0b f6 ff ff       	jmp    80105c3a <alltraps>

8010662f <vector142>:
.globl vector142
vector142:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $142
80106631:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106636:	e9 ff f5 ff ff       	jmp    80105c3a <alltraps>

8010663b <vector143>:
.globl vector143
vector143:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $143
8010663d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106642:	e9 f3 f5 ff ff       	jmp    80105c3a <alltraps>

80106647 <vector144>:
.globl vector144
vector144:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $144
80106649:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010664e:	e9 e7 f5 ff ff       	jmp    80105c3a <alltraps>

80106653 <vector145>:
.globl vector145
vector145:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $145
80106655:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010665a:	e9 db f5 ff ff       	jmp    80105c3a <alltraps>

8010665f <vector146>:
.globl vector146
vector146:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $146
80106661:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106666:	e9 cf f5 ff ff       	jmp    80105c3a <alltraps>

8010666b <vector147>:
.globl vector147
vector147:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $147
8010666d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106672:	e9 c3 f5 ff ff       	jmp    80105c3a <alltraps>

80106677 <vector148>:
.globl vector148
vector148:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $148
80106679:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010667e:	e9 b7 f5 ff ff       	jmp    80105c3a <alltraps>

80106683 <vector149>:
.globl vector149
vector149:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $149
80106685:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010668a:	e9 ab f5 ff ff       	jmp    80105c3a <alltraps>

8010668f <vector150>:
.globl vector150
vector150:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $150
80106691:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106696:	e9 9f f5 ff ff       	jmp    80105c3a <alltraps>

8010669b <vector151>:
.globl vector151
vector151:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $151
8010669d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066a2:	e9 93 f5 ff ff       	jmp    80105c3a <alltraps>

801066a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $152
801066a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066ae:	e9 87 f5 ff ff       	jmp    80105c3a <alltraps>

801066b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $153
801066b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066ba:	e9 7b f5 ff ff       	jmp    80105c3a <alltraps>

801066bf <vector154>:
.globl vector154
vector154:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $154
801066c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066c6:	e9 6f f5 ff ff       	jmp    80105c3a <alltraps>

801066cb <vector155>:
.globl vector155
vector155:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $155
801066cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801066d2:	e9 63 f5 ff ff       	jmp    80105c3a <alltraps>

801066d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $156
801066d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801066de:	e9 57 f5 ff ff       	jmp    80105c3a <alltraps>

801066e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $157
801066e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801066ea:	e9 4b f5 ff ff       	jmp    80105c3a <alltraps>

801066ef <vector158>:
.globl vector158
vector158:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $158
801066f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801066f6:	e9 3f f5 ff ff       	jmp    80105c3a <alltraps>

801066fb <vector159>:
.globl vector159
vector159:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $159
801066fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106702:	e9 33 f5 ff ff       	jmp    80105c3a <alltraps>

80106707 <vector160>:
.globl vector160
vector160:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $160
80106709:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010670e:	e9 27 f5 ff ff       	jmp    80105c3a <alltraps>

80106713 <vector161>:
.globl vector161
vector161:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $161
80106715:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010671a:	e9 1b f5 ff ff       	jmp    80105c3a <alltraps>

8010671f <vector162>:
.globl vector162
vector162:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $162
80106721:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106726:	e9 0f f5 ff ff       	jmp    80105c3a <alltraps>

8010672b <vector163>:
.globl vector163
vector163:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $163
8010672d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106732:	e9 03 f5 ff ff       	jmp    80105c3a <alltraps>

80106737 <vector164>:
.globl vector164
vector164:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $164
80106739:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010673e:	e9 f7 f4 ff ff       	jmp    80105c3a <alltraps>

80106743 <vector165>:
.globl vector165
vector165:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $165
80106745:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010674a:	e9 eb f4 ff ff       	jmp    80105c3a <alltraps>

8010674f <vector166>:
.globl vector166
vector166:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $166
80106751:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106756:	e9 df f4 ff ff       	jmp    80105c3a <alltraps>

8010675b <vector167>:
.globl vector167
vector167:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $167
8010675d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106762:	e9 d3 f4 ff ff       	jmp    80105c3a <alltraps>

80106767 <vector168>:
.globl vector168
vector168:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $168
80106769:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010676e:	e9 c7 f4 ff ff       	jmp    80105c3a <alltraps>

80106773 <vector169>:
.globl vector169
vector169:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $169
80106775:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010677a:	e9 bb f4 ff ff       	jmp    80105c3a <alltraps>

8010677f <vector170>:
.globl vector170
vector170:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $170
80106781:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106786:	e9 af f4 ff ff       	jmp    80105c3a <alltraps>

8010678b <vector171>:
.globl vector171
vector171:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $171
8010678d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106792:	e9 a3 f4 ff ff       	jmp    80105c3a <alltraps>

80106797 <vector172>:
.globl vector172
vector172:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $172
80106799:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010679e:	e9 97 f4 ff ff       	jmp    80105c3a <alltraps>

801067a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $173
801067a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067aa:	e9 8b f4 ff ff       	jmp    80105c3a <alltraps>

801067af <vector174>:
.globl vector174
vector174:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $174
801067b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067b6:	e9 7f f4 ff ff       	jmp    80105c3a <alltraps>

801067bb <vector175>:
.globl vector175
vector175:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $175
801067bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067c2:	e9 73 f4 ff ff       	jmp    80105c3a <alltraps>

801067c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $176
801067c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067ce:	e9 67 f4 ff ff       	jmp    80105c3a <alltraps>

801067d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $177
801067d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801067da:	e9 5b f4 ff ff       	jmp    80105c3a <alltraps>

801067df <vector178>:
.globl vector178
vector178:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $178
801067e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801067e6:	e9 4f f4 ff ff       	jmp    80105c3a <alltraps>

801067eb <vector179>:
.globl vector179
vector179:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $179
801067ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801067f2:	e9 43 f4 ff ff       	jmp    80105c3a <alltraps>

801067f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $180
801067f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801067fe:	e9 37 f4 ff ff       	jmp    80105c3a <alltraps>

80106803 <vector181>:
.globl vector181
vector181:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $181
80106805:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010680a:	e9 2b f4 ff ff       	jmp    80105c3a <alltraps>

8010680f <vector182>:
.globl vector182
vector182:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $182
80106811:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106816:	e9 1f f4 ff ff       	jmp    80105c3a <alltraps>

8010681b <vector183>:
.globl vector183
vector183:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $183
8010681d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106822:	e9 13 f4 ff ff       	jmp    80105c3a <alltraps>

80106827 <vector184>:
.globl vector184
vector184:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $184
80106829:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010682e:	e9 07 f4 ff ff       	jmp    80105c3a <alltraps>

80106833 <vector185>:
.globl vector185
vector185:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $185
80106835:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010683a:	e9 fb f3 ff ff       	jmp    80105c3a <alltraps>

8010683f <vector186>:
.globl vector186
vector186:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $186
80106841:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106846:	e9 ef f3 ff ff       	jmp    80105c3a <alltraps>

8010684b <vector187>:
.globl vector187
vector187:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $187
8010684d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106852:	e9 e3 f3 ff ff       	jmp    80105c3a <alltraps>

80106857 <vector188>:
.globl vector188
vector188:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $188
80106859:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010685e:	e9 d7 f3 ff ff       	jmp    80105c3a <alltraps>

80106863 <vector189>:
.globl vector189
vector189:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $189
80106865:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010686a:	e9 cb f3 ff ff       	jmp    80105c3a <alltraps>

8010686f <vector190>:
.globl vector190
vector190:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $190
80106871:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106876:	e9 bf f3 ff ff       	jmp    80105c3a <alltraps>

8010687b <vector191>:
.globl vector191
vector191:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $191
8010687d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106882:	e9 b3 f3 ff ff       	jmp    80105c3a <alltraps>

80106887 <vector192>:
.globl vector192
vector192:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $192
80106889:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010688e:	e9 a7 f3 ff ff       	jmp    80105c3a <alltraps>

80106893 <vector193>:
.globl vector193
vector193:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $193
80106895:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010689a:	e9 9b f3 ff ff       	jmp    80105c3a <alltraps>

8010689f <vector194>:
.globl vector194
vector194:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $194
801068a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068a6:	e9 8f f3 ff ff       	jmp    80105c3a <alltraps>

801068ab <vector195>:
.globl vector195
vector195:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $195
801068ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068b2:	e9 83 f3 ff ff       	jmp    80105c3a <alltraps>

801068b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $196
801068b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068be:	e9 77 f3 ff ff       	jmp    80105c3a <alltraps>

801068c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $197
801068c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068ca:	e9 6b f3 ff ff       	jmp    80105c3a <alltraps>

801068cf <vector198>:
.globl vector198
vector198:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $198
801068d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801068d6:	e9 5f f3 ff ff       	jmp    80105c3a <alltraps>

801068db <vector199>:
.globl vector199
vector199:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $199
801068dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801068e2:	e9 53 f3 ff ff       	jmp    80105c3a <alltraps>

801068e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $200
801068e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801068ee:	e9 47 f3 ff ff       	jmp    80105c3a <alltraps>

801068f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $201
801068f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801068fa:	e9 3b f3 ff ff       	jmp    80105c3a <alltraps>

801068ff <vector202>:
.globl vector202
vector202:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $202
80106901:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106906:	e9 2f f3 ff ff       	jmp    80105c3a <alltraps>

8010690b <vector203>:
.globl vector203
vector203:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $203
8010690d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106912:	e9 23 f3 ff ff       	jmp    80105c3a <alltraps>

80106917 <vector204>:
.globl vector204
vector204:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $204
80106919:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010691e:	e9 17 f3 ff ff       	jmp    80105c3a <alltraps>

80106923 <vector205>:
.globl vector205
vector205:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $205
80106925:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010692a:	e9 0b f3 ff ff       	jmp    80105c3a <alltraps>

8010692f <vector206>:
.globl vector206
vector206:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $206
80106931:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106936:	e9 ff f2 ff ff       	jmp    80105c3a <alltraps>

8010693b <vector207>:
.globl vector207
vector207:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $207
8010693d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106942:	e9 f3 f2 ff ff       	jmp    80105c3a <alltraps>

80106947 <vector208>:
.globl vector208
vector208:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $208
80106949:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010694e:	e9 e7 f2 ff ff       	jmp    80105c3a <alltraps>

80106953 <vector209>:
.globl vector209
vector209:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $209
80106955:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010695a:	e9 db f2 ff ff       	jmp    80105c3a <alltraps>

8010695f <vector210>:
.globl vector210
vector210:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $210
80106961:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106966:	e9 cf f2 ff ff       	jmp    80105c3a <alltraps>

8010696b <vector211>:
.globl vector211
vector211:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $211
8010696d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106972:	e9 c3 f2 ff ff       	jmp    80105c3a <alltraps>

80106977 <vector212>:
.globl vector212
vector212:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $212
80106979:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010697e:	e9 b7 f2 ff ff       	jmp    80105c3a <alltraps>

80106983 <vector213>:
.globl vector213
vector213:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $213
80106985:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010698a:	e9 ab f2 ff ff       	jmp    80105c3a <alltraps>

8010698f <vector214>:
.globl vector214
vector214:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $214
80106991:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106996:	e9 9f f2 ff ff       	jmp    80105c3a <alltraps>

8010699b <vector215>:
.globl vector215
vector215:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $215
8010699d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069a2:	e9 93 f2 ff ff       	jmp    80105c3a <alltraps>

801069a7 <vector216>:
.globl vector216
vector216:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $216
801069a9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069ae:	e9 87 f2 ff ff       	jmp    80105c3a <alltraps>

801069b3 <vector217>:
.globl vector217
vector217:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $217
801069b5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069ba:	e9 7b f2 ff ff       	jmp    80105c3a <alltraps>

801069bf <vector218>:
.globl vector218
vector218:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $218
801069c1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069c6:	e9 6f f2 ff ff       	jmp    80105c3a <alltraps>

801069cb <vector219>:
.globl vector219
vector219:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $219
801069cd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801069d2:	e9 63 f2 ff ff       	jmp    80105c3a <alltraps>

801069d7 <vector220>:
.globl vector220
vector220:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $220
801069d9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801069de:	e9 57 f2 ff ff       	jmp    80105c3a <alltraps>

801069e3 <vector221>:
.globl vector221
vector221:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $221
801069e5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801069ea:	e9 4b f2 ff ff       	jmp    80105c3a <alltraps>

801069ef <vector222>:
.globl vector222
vector222:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $222
801069f1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801069f6:	e9 3f f2 ff ff       	jmp    80105c3a <alltraps>

801069fb <vector223>:
.globl vector223
vector223:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $223
801069fd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a02:	e9 33 f2 ff ff       	jmp    80105c3a <alltraps>

80106a07 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $224
80106a09:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a0e:	e9 27 f2 ff ff       	jmp    80105c3a <alltraps>

80106a13 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $225
80106a15:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a1a:	e9 1b f2 ff ff       	jmp    80105c3a <alltraps>

80106a1f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $226
80106a21:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a26:	e9 0f f2 ff ff       	jmp    80105c3a <alltraps>

80106a2b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $227
80106a2d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a32:	e9 03 f2 ff ff       	jmp    80105c3a <alltraps>

80106a37 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $228
80106a39:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a3e:	e9 f7 f1 ff ff       	jmp    80105c3a <alltraps>

80106a43 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $229
80106a45:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a4a:	e9 eb f1 ff ff       	jmp    80105c3a <alltraps>

80106a4f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $230
80106a51:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a56:	e9 df f1 ff ff       	jmp    80105c3a <alltraps>

80106a5b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $231
80106a5d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a62:	e9 d3 f1 ff ff       	jmp    80105c3a <alltraps>

80106a67 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $232
80106a69:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a6e:	e9 c7 f1 ff ff       	jmp    80105c3a <alltraps>

80106a73 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $233
80106a75:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a7a:	e9 bb f1 ff ff       	jmp    80105c3a <alltraps>

80106a7f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $234
80106a81:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a86:	e9 af f1 ff ff       	jmp    80105c3a <alltraps>

80106a8b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $235
80106a8d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a92:	e9 a3 f1 ff ff       	jmp    80105c3a <alltraps>

80106a97 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $236
80106a99:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a9e:	e9 97 f1 ff ff       	jmp    80105c3a <alltraps>

80106aa3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $237
80106aa5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106aaa:	e9 8b f1 ff ff       	jmp    80105c3a <alltraps>

80106aaf <vector238>:
.globl vector238
vector238:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $238
80106ab1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ab6:	e9 7f f1 ff ff       	jmp    80105c3a <alltraps>

80106abb <vector239>:
.globl vector239
vector239:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $239
80106abd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ac2:	e9 73 f1 ff ff       	jmp    80105c3a <alltraps>

80106ac7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $240
80106ac9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ace:	e9 67 f1 ff ff       	jmp    80105c3a <alltraps>

80106ad3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $241
80106ad5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106ada:	e9 5b f1 ff ff       	jmp    80105c3a <alltraps>

80106adf <vector242>:
.globl vector242
vector242:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $242
80106ae1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ae6:	e9 4f f1 ff ff       	jmp    80105c3a <alltraps>

80106aeb <vector243>:
.globl vector243
vector243:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $243
80106aed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106af2:	e9 43 f1 ff ff       	jmp    80105c3a <alltraps>

80106af7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $244
80106af9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106afe:	e9 37 f1 ff ff       	jmp    80105c3a <alltraps>

80106b03 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $245
80106b05:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b0a:	e9 2b f1 ff ff       	jmp    80105c3a <alltraps>

80106b0f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $246
80106b11:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b16:	e9 1f f1 ff ff       	jmp    80105c3a <alltraps>

80106b1b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $247
80106b1d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b22:	e9 13 f1 ff ff       	jmp    80105c3a <alltraps>

80106b27 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $248
80106b29:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b2e:	e9 07 f1 ff ff       	jmp    80105c3a <alltraps>

80106b33 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $249
80106b35:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b3a:	e9 fb f0 ff ff       	jmp    80105c3a <alltraps>

80106b3f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $250
80106b41:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b46:	e9 ef f0 ff ff       	jmp    80105c3a <alltraps>

80106b4b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $251
80106b4d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b52:	e9 e3 f0 ff ff       	jmp    80105c3a <alltraps>

80106b57 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $252
80106b59:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b5e:	e9 d7 f0 ff ff       	jmp    80105c3a <alltraps>

80106b63 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $253
80106b65:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b6a:	e9 cb f0 ff ff       	jmp    80105c3a <alltraps>

80106b6f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $254
80106b71:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b76:	e9 bf f0 ff ff       	jmp    80105c3a <alltraps>

80106b7b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $255
80106b7d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b82:	e9 b3 f0 ff ff       	jmp    80105c3a <alltraps>
80106b87:	66 90                	xchg   %ax,%ax
80106b89:	66 90                	xchg   %ax,%ax
80106b8b:	66 90                	xchg   %ax,%ax
80106b8d:	66 90                	xchg   %ax,%ax
80106b8f:	90                   	nop

80106b90 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106b96:	89 d3                	mov    %edx,%ebx
{
80106b98:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106b9a:	c1 eb 16             	shr    $0x16,%ebx
80106b9d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106ba0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ba3:	8b 06                	mov    (%esi),%eax
80106ba5:	a8 01                	test   $0x1,%al
80106ba7:	74 27                	je     80106bd0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ba9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106bb4:	c1 ef 0a             	shr    $0xa,%edi
}
80106bb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106bba:	89 fa                	mov    %edi,%edx
80106bbc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106bc2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106bc5:	5b                   	pop    %ebx
80106bc6:	5e                   	pop    %esi
80106bc7:	5f                   	pop    %edi
80106bc8:	5d                   	pop    %ebp
80106bc9:	c3                   	ret    
80106bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106bd0:	85 c9                	test   %ecx,%ecx
80106bd2:	74 2c                	je     80106c00 <walkpgdir+0x70>
80106bd4:	e8 77 bc ff ff       	call   80102850 <kalloc>
80106bd9:	85 c0                	test   %eax,%eax
80106bdb:	89 c3                	mov    %eax,%ebx
80106bdd:	74 21                	je     80106c00 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106bdf:	83 ec 04             	sub    $0x4,%esp
80106be2:	68 00 10 00 00       	push   $0x1000
80106be7:	6a 00                	push   $0x0
80106be9:	50                   	push   %eax
80106bea:	e8 31 de ff ff       	call   80104a20 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bf5:	83 c4 10             	add    $0x10,%esp
80106bf8:	83 c8 07             	or     $0x7,%eax
80106bfb:	89 06                	mov    %eax,(%esi)
80106bfd:	eb b5                	jmp    80106bb4 <walkpgdir+0x24>
80106bff:	90                   	nop
}
80106c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106c03:	31 c0                	xor    %eax,%eax
}
80106c05:	5b                   	pop    %ebx
80106c06:	5e                   	pop    %esi
80106c07:	5f                   	pop    %edi
80106c08:	5d                   	pop    %ebp
80106c09:	c3                   	ret    
80106c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c10 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	57                   	push   %edi
80106c14:	56                   	push   %esi
80106c15:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106c16:	89 d3                	mov    %edx,%ebx
80106c18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c1e:	83 ec 1c             	sub    $0x1c,%esp
80106c21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c24:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c28:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c33:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c36:	29 df                	sub    %ebx,%edi
80106c38:	83 c8 01             	or     $0x1,%eax
80106c3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c3e:	eb 15                	jmp    80106c55 <mappages+0x45>
    if(*pte & PTE_P)
80106c40:	f6 00 01             	testb  $0x1,(%eax)
80106c43:	75 45                	jne    80106c8a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106c45:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106c48:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106c4b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c4d:	74 31                	je     80106c80 <mappages+0x70>
      break;
    a += PGSIZE;
80106c4f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c58:	b9 01 00 00 00       	mov    $0x1,%ecx
80106c5d:	89 da                	mov    %ebx,%edx
80106c5f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106c62:	e8 29 ff ff ff       	call   80106b90 <walkpgdir>
80106c67:	85 c0                	test   %eax,%eax
80106c69:	75 d5                	jne    80106c40 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c73:	5b                   	pop    %ebx
80106c74:	5e                   	pop    %esi
80106c75:	5f                   	pop    %edi
80106c76:	5d                   	pop    %ebp
80106c77:	c3                   	ret    
80106c78:	90                   	nop
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c83:	31 c0                	xor    %eax,%eax
}
80106c85:	5b                   	pop    %ebx
80106c86:	5e                   	pop    %esi
80106c87:	5f                   	pop    %edi
80106c88:	5d                   	pop    %ebp
80106c89:	c3                   	ret    
      panic("remap");
80106c8a:	83 ec 0c             	sub    $0xc,%esp
80106c8d:	68 e4 7d 10 80       	push   $0x80107de4
80106c92:	e8 f9 96 ff ff       	call   80100390 <panic>
80106c97:	89 f6                	mov    %esi,%esi
80106c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ca0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ca6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cac:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106cae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cb4:	83 ec 1c             	sub    $0x1c,%esp
80106cb7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106cba:	39 d3                	cmp    %edx,%ebx
80106cbc:	73 66                	jae    80106d24 <deallocuvm.part.0+0x84>
80106cbe:	89 d6                	mov    %edx,%esi
80106cc0:	eb 3d                	jmp    80106cff <deallocuvm.part.0+0x5f>
80106cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106cc8:	8b 10                	mov    (%eax),%edx
80106cca:	f6 c2 01             	test   $0x1,%dl
80106ccd:	74 26                	je     80106cf5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106ccf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106cd5:	74 58                	je     80106d2f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106cd7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106cda:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106ce3:	52                   	push   %edx
80106ce4:	e8 b7 b9 ff ff       	call   801026a0 <kfree>
      *pte = 0;
80106ce9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cec:	83 c4 10             	add    $0x10,%esp
80106cef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106cf5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cfb:	39 f3                	cmp    %esi,%ebx
80106cfd:	73 25                	jae    80106d24 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106cff:	31 c9                	xor    %ecx,%ecx
80106d01:	89 da                	mov    %ebx,%edx
80106d03:	89 f8                	mov    %edi,%eax
80106d05:	e8 86 fe ff ff       	call   80106b90 <walkpgdir>
    if(!pte)
80106d0a:	85 c0                	test   %eax,%eax
80106d0c:	75 ba                	jne    80106cc8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d0e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106d14:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d20:	39 f3                	cmp    %esi,%ebx
80106d22:	72 db                	jb     80106cff <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d2a:	5b                   	pop    %ebx
80106d2b:	5e                   	pop    %esi
80106d2c:	5f                   	pop    %edi
80106d2d:	5d                   	pop    %ebp
80106d2e:	c3                   	ret    
        panic("kfree");
80106d2f:	83 ec 0c             	sub    $0xc,%esp
80106d32:	68 6a 77 10 80       	push   $0x8010776a
80106d37:	e8 54 96 ff ff       	call   80100390 <panic>
80106d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d40 <seginit>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d46:	e8 95 ce ff ff       	call   80103be0 <cpuid>
80106d4b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106d51:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d5a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106d61:	ff 00 00 
80106d64:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106d6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d6e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106d75:	ff 00 00 
80106d78:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106d7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d82:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106d89:	ff 00 00 
80106d8c:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106d93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d96:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106d9d:	ff 00 00 
80106da0:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106da7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106daa:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106daf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106db3:	c1 e8 10             	shr    $0x10,%eax
80106db6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106dba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106dbd:	0f 01 10             	lgdtl  (%eax)
}
80106dc0:	c9                   	leave  
80106dc1:	c3                   	ret    
80106dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106dd0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dd0:	a1 a4 f1 11 80       	mov    0x8011f1a4,%eax
{
80106dd5:	55                   	push   %ebp
80106dd6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dd8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ddd:	0f 22 d8             	mov    %eax,%cr3
}
80106de0:	5d                   	pop    %ebp
80106de1:	c3                   	ret    
80106de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106df0 <switchuvm>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	83 ec 1c             	sub    $0x1c,%esp
80106df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106dfc:	85 db                	test   %ebx,%ebx
80106dfe:	0f 84 cb 00 00 00    	je     80106ecf <switchuvm+0xdf>
  if(p->kstack == 0)
80106e04:	8b 43 08             	mov    0x8(%ebx),%eax
80106e07:	85 c0                	test   %eax,%eax
80106e09:	0f 84 da 00 00 00    	je     80106ee9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106e0f:	8b 43 04             	mov    0x4(%ebx),%eax
80106e12:	85 c0                	test   %eax,%eax
80106e14:	0f 84 c2 00 00 00    	je     80106edc <switchuvm+0xec>
  pushcli();
80106e1a:	e8 21 da ff ff       	call   80104840 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e1f:	e8 3c cd ff ff       	call   80103b60 <mycpu>
80106e24:	89 c6                	mov    %eax,%esi
80106e26:	e8 35 cd ff ff       	call   80103b60 <mycpu>
80106e2b:	89 c7                	mov    %eax,%edi
80106e2d:	e8 2e cd ff ff       	call   80103b60 <mycpu>
80106e32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e35:	83 c7 08             	add    $0x8,%edi
80106e38:	e8 23 cd ff ff       	call   80103b60 <mycpu>
80106e3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e40:	83 c0 08             	add    $0x8,%eax
80106e43:	ba 67 00 00 00       	mov    $0x67,%edx
80106e48:	c1 e8 18             	shr    $0x18,%eax
80106e4b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106e52:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106e59:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e5f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e64:	83 c1 08             	add    $0x8,%ecx
80106e67:	c1 e9 10             	shr    $0x10,%ecx
80106e6a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106e70:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e75:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e7c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106e81:	e8 da cc ff ff       	call   80103b60 <mycpu>
80106e86:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e8d:	e8 ce cc ff ff       	call   80103b60 <mycpu>
80106e92:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e96:	8b 73 08             	mov    0x8(%ebx),%esi
80106e99:	e8 c2 cc ff ff       	call   80103b60 <mycpu>
80106e9e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ea4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ea7:	e8 b4 cc ff ff       	call   80103b60 <mycpu>
80106eac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106eb0:	b8 28 00 00 00       	mov    $0x28,%eax
80106eb5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106eb8:	8b 43 04             	mov    0x4(%ebx),%eax
80106ebb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ec0:	0f 22 d8             	mov    %eax,%cr3
}
80106ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ec6:	5b                   	pop    %ebx
80106ec7:	5e                   	pop    %esi
80106ec8:	5f                   	pop    %edi
80106ec9:	5d                   	pop    %ebp
  popcli();
80106eca:	e9 b1 d9 ff ff       	jmp    80104880 <popcli>
    panic("switchuvm: no process");
80106ecf:	83 ec 0c             	sub    $0xc,%esp
80106ed2:	68 ea 7d 10 80       	push   $0x80107dea
80106ed7:	e8 b4 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106edc:	83 ec 0c             	sub    $0xc,%esp
80106edf:	68 15 7e 10 80       	push   $0x80107e15
80106ee4:	e8 a7 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106ee9:	83 ec 0c             	sub    $0xc,%esp
80106eec:	68 00 7e 10 80       	push   $0x80107e00
80106ef1:	e8 9a 94 ff ff       	call   80100390 <panic>
80106ef6:	8d 76 00             	lea    0x0(%esi),%esi
80106ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f00 <inituvm>:
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 1c             	sub    $0x1c,%esp
80106f09:	8b 75 10             	mov    0x10(%ebp),%esi
80106f0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f0f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106f12:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106f18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f1b:	77 49                	ja     80106f66 <inituvm+0x66>
  mem = kalloc();
80106f1d:	e8 2e b9 ff ff       	call   80102850 <kalloc>
  memset(mem, 0, PGSIZE);
80106f22:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106f25:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f27:	68 00 10 00 00       	push   $0x1000
80106f2c:	6a 00                	push   $0x0
80106f2e:	50                   	push   %eax
80106f2f:	e8 ec da ff ff       	call   80104a20 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f34:	58                   	pop    %eax
80106f35:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f3b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f40:	5a                   	pop    %edx
80106f41:	6a 06                	push   $0x6
80106f43:	50                   	push   %eax
80106f44:	31 d2                	xor    %edx,%edx
80106f46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f49:	e8 c2 fc ff ff       	call   80106c10 <mappages>
  memmove(mem, init, sz);
80106f4e:	89 75 10             	mov    %esi,0x10(%ebp)
80106f51:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f54:	83 c4 10             	add    $0x10,%esp
80106f57:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f5d:	5b                   	pop    %ebx
80106f5e:	5e                   	pop    %esi
80106f5f:	5f                   	pop    %edi
80106f60:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f61:	e9 6a db ff ff       	jmp    80104ad0 <memmove>
    panic("inituvm: more than a page");
80106f66:	83 ec 0c             	sub    $0xc,%esp
80106f69:	68 29 7e 10 80       	push   $0x80107e29
80106f6e:	e8 1d 94 ff ff       	call   80100390 <panic>
80106f73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f80 <loaduvm>:
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
80106f86:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106f89:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106f90:	0f 85 91 00 00 00    	jne    80107027 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106f96:	8b 75 18             	mov    0x18(%ebp),%esi
80106f99:	31 db                	xor    %ebx,%ebx
80106f9b:	85 f6                	test   %esi,%esi
80106f9d:	75 1a                	jne    80106fb9 <loaduvm+0x39>
80106f9f:	eb 6f                	jmp    80107010 <loaduvm+0x90>
80106fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fa8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106fb4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106fb7:	76 57                	jbe    80107010 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80106fbf:	31 c9                	xor    %ecx,%ecx
80106fc1:	01 da                	add    %ebx,%edx
80106fc3:	e8 c8 fb ff ff       	call   80106b90 <walkpgdir>
80106fc8:	85 c0                	test   %eax,%eax
80106fca:	74 4e                	je     8010701a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106fcc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fce:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106fd1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106fd6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106fdb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106fe1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fe4:	01 d9                	add    %ebx,%ecx
80106fe6:	05 00 00 00 80       	add    $0x80000000,%eax
80106feb:	57                   	push   %edi
80106fec:	51                   	push   %ecx
80106fed:	50                   	push   %eax
80106fee:	ff 75 10             	pushl  0x10(%ebp)
80106ff1:	e8 6a a9 ff ff       	call   80101960 <readi>
80106ff6:	83 c4 10             	add    $0x10,%esp
80106ff9:	39 f8                	cmp    %edi,%eax
80106ffb:	74 ab                	je     80106fa8 <loaduvm+0x28>
}
80106ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107005:	5b                   	pop    %ebx
80107006:	5e                   	pop    %esi
80107007:	5f                   	pop    %edi
80107008:	5d                   	pop    %ebp
80107009:	c3                   	ret    
8010700a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107010:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107013:	31 c0                	xor    %eax,%eax
}
80107015:	5b                   	pop    %ebx
80107016:	5e                   	pop    %esi
80107017:	5f                   	pop    %edi
80107018:	5d                   	pop    %ebp
80107019:	c3                   	ret    
      panic("loaduvm: address should exist");
8010701a:	83 ec 0c             	sub    $0xc,%esp
8010701d:	68 43 7e 10 80       	push   $0x80107e43
80107022:	e8 69 93 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107027:	83 ec 0c             	sub    $0xc,%esp
8010702a:	68 e4 7e 10 80       	push   $0x80107ee4
8010702f:	e8 5c 93 ff ff       	call   80100390 <panic>
80107034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010703a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107040 <allocuvm>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107049:	8b 7d 10             	mov    0x10(%ebp),%edi
8010704c:	85 ff                	test   %edi,%edi
8010704e:	0f 88 8e 00 00 00    	js     801070e2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107054:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107057:	0f 82 93 00 00 00    	jb     801070f0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010705d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107060:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107066:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010706c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010706f:	0f 86 7e 00 00 00    	jbe    801070f3 <allocuvm+0xb3>
80107075:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107078:	8b 7d 08             	mov    0x8(%ebp),%edi
8010707b:	eb 42                	jmp    801070bf <allocuvm+0x7f>
8010707d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107080:	83 ec 04             	sub    $0x4,%esp
80107083:	68 00 10 00 00       	push   $0x1000
80107088:	6a 00                	push   $0x0
8010708a:	50                   	push   %eax
8010708b:	e8 90 d9 ff ff       	call   80104a20 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107090:	58                   	pop    %eax
80107091:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107097:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010709c:	5a                   	pop    %edx
8010709d:	6a 06                	push   $0x6
8010709f:	50                   	push   %eax
801070a0:	89 da                	mov    %ebx,%edx
801070a2:	89 f8                	mov    %edi,%eax
801070a4:	e8 67 fb ff ff       	call   80106c10 <mappages>
801070a9:	83 c4 10             	add    $0x10,%esp
801070ac:	85 c0                	test   %eax,%eax
801070ae:	78 50                	js     80107100 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801070b0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070b6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801070b9:	0f 86 81 00 00 00    	jbe    80107140 <allocuvm+0x100>
    mem = kalloc();
801070bf:	e8 8c b7 ff ff       	call   80102850 <kalloc>
    if(mem == 0){
801070c4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801070c6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801070c8:	75 b6                	jne    80107080 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801070ca:	83 ec 0c             	sub    $0xc,%esp
801070cd:	68 61 7e 10 80       	push   $0x80107e61
801070d2:	e8 89 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801070d7:	83 c4 10             	add    $0x10,%esp
801070da:	8b 45 0c             	mov    0xc(%ebp),%eax
801070dd:	39 45 10             	cmp    %eax,0x10(%ebp)
801070e0:	77 6e                	ja     80107150 <allocuvm+0x110>
}
801070e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801070e5:	31 ff                	xor    %edi,%edi
}
801070e7:	89 f8                	mov    %edi,%eax
801070e9:	5b                   	pop    %ebx
801070ea:	5e                   	pop    %esi
801070eb:	5f                   	pop    %edi
801070ec:	5d                   	pop    %ebp
801070ed:	c3                   	ret    
801070ee:	66 90                	xchg   %ax,%ax
    return oldsz;
801070f0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801070f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070f6:	89 f8                	mov    %edi,%eax
801070f8:	5b                   	pop    %ebx
801070f9:	5e                   	pop    %esi
801070fa:	5f                   	pop    %edi
801070fb:	5d                   	pop    %ebp
801070fc:	c3                   	ret    
801070fd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107100:	83 ec 0c             	sub    $0xc,%esp
80107103:	68 79 7e 10 80       	push   $0x80107e79
80107108:	e8 53 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010710d:	83 c4 10             	add    $0x10,%esp
80107110:	8b 45 0c             	mov    0xc(%ebp),%eax
80107113:	39 45 10             	cmp    %eax,0x10(%ebp)
80107116:	76 0d                	jbe    80107125 <allocuvm+0xe5>
80107118:	89 c1                	mov    %eax,%ecx
8010711a:	8b 55 10             	mov    0x10(%ebp),%edx
8010711d:	8b 45 08             	mov    0x8(%ebp),%eax
80107120:	e8 7b fb ff ff       	call   80106ca0 <deallocuvm.part.0>
      kfree(mem);
80107125:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107128:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010712a:	56                   	push   %esi
8010712b:	e8 70 b5 ff ff       	call   801026a0 <kfree>
      return 0;
80107130:	83 c4 10             	add    $0x10,%esp
}
80107133:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107136:	89 f8                	mov    %edi,%eax
80107138:	5b                   	pop    %ebx
80107139:	5e                   	pop    %esi
8010713a:	5f                   	pop    %edi
8010713b:	5d                   	pop    %ebp
8010713c:	c3                   	ret    
8010713d:	8d 76 00             	lea    0x0(%esi),%esi
80107140:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107143:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107146:	5b                   	pop    %ebx
80107147:	89 f8                	mov    %edi,%eax
80107149:	5e                   	pop    %esi
8010714a:	5f                   	pop    %edi
8010714b:	5d                   	pop    %ebp
8010714c:	c3                   	ret    
8010714d:	8d 76 00             	lea    0x0(%esi),%esi
80107150:	89 c1                	mov    %eax,%ecx
80107152:	8b 55 10             	mov    0x10(%ebp),%edx
80107155:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107158:	31 ff                	xor    %edi,%edi
8010715a:	e8 41 fb ff ff       	call   80106ca0 <deallocuvm.part.0>
8010715f:	eb 92                	jmp    801070f3 <allocuvm+0xb3>
80107161:	eb 0d                	jmp    80107170 <deallocuvm>
80107163:	90                   	nop
80107164:	90                   	nop
80107165:	90                   	nop
80107166:	90                   	nop
80107167:	90                   	nop
80107168:	90                   	nop
80107169:	90                   	nop
8010716a:	90                   	nop
8010716b:	90                   	nop
8010716c:	90                   	nop
8010716d:	90                   	nop
8010716e:	90                   	nop
8010716f:	90                   	nop

80107170 <deallocuvm>:
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	8b 55 0c             	mov    0xc(%ebp),%edx
80107176:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107179:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010717c:	39 d1                	cmp    %edx,%ecx
8010717e:	73 10                	jae    80107190 <deallocuvm+0x20>
}
80107180:	5d                   	pop    %ebp
80107181:	e9 1a fb ff ff       	jmp    80106ca0 <deallocuvm.part.0>
80107186:	8d 76 00             	lea    0x0(%esi),%esi
80107189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107190:	89 d0                	mov    %edx,%eax
80107192:	5d                   	pop    %ebp
80107193:	c3                   	ret    
80107194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010719a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071a0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
801071a6:	83 ec 0c             	sub    $0xc,%esp
801071a9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801071ac:	85 f6                	test   %esi,%esi
801071ae:	74 59                	je     80107209 <freevm+0x69>
801071b0:	31 c9                	xor    %ecx,%ecx
801071b2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801071b7:	89 f0                	mov    %esi,%eax
801071b9:	e8 e2 fa ff ff       	call   80106ca0 <deallocuvm.part.0>
801071be:	89 f3                	mov    %esi,%ebx
801071c0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071c6:	eb 0f                	jmp    801071d7 <freevm+0x37>
801071c8:	90                   	nop
801071c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071d0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801071d3:	39 fb                	cmp    %edi,%ebx
801071d5:	74 23                	je     801071fa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801071d7:	8b 03                	mov    (%ebx),%eax
801071d9:	a8 01                	test   $0x1,%al
801071db:	74 f3                	je     801071d0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801071e2:	83 ec 0c             	sub    $0xc,%esp
801071e5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071e8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801071ed:	50                   	push   %eax
801071ee:	e8 ad b4 ff ff       	call   801026a0 <kfree>
801071f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071f6:	39 fb                	cmp    %edi,%ebx
801071f8:	75 dd                	jne    801071d7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801071fa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801071fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107200:	5b                   	pop    %ebx
80107201:	5e                   	pop    %esi
80107202:	5f                   	pop    %edi
80107203:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107204:	e9 97 b4 ff ff       	jmp    801026a0 <kfree>
    panic("freevm: no pgdir");
80107209:	83 ec 0c             	sub    $0xc,%esp
8010720c:	68 95 7e 10 80       	push   $0x80107e95
80107211:	e8 7a 91 ff ff       	call   80100390 <panic>
80107216:	8d 76 00             	lea    0x0(%esi),%esi
80107219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107220 <setupkvm>:
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	56                   	push   %esi
80107224:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107225:	e8 26 b6 ff ff       	call   80102850 <kalloc>
8010722a:	85 c0                	test   %eax,%eax
8010722c:	89 c6                	mov    %eax,%esi
8010722e:	74 42                	je     80107272 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107230:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107233:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107238:	68 00 10 00 00       	push   $0x1000
8010723d:	6a 00                	push   $0x0
8010723f:	50                   	push   %eax
80107240:	e8 db d7 ff ff       	call   80104a20 <memset>
80107245:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107248:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010724b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010724e:	83 ec 08             	sub    $0x8,%esp
80107251:	8b 13                	mov    (%ebx),%edx
80107253:	ff 73 0c             	pushl  0xc(%ebx)
80107256:	50                   	push   %eax
80107257:	29 c1                	sub    %eax,%ecx
80107259:	89 f0                	mov    %esi,%eax
8010725b:	e8 b0 f9 ff ff       	call   80106c10 <mappages>
80107260:	83 c4 10             	add    $0x10,%esp
80107263:	85 c0                	test   %eax,%eax
80107265:	78 19                	js     80107280 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107267:	83 c3 10             	add    $0x10,%ebx
8010726a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107270:	75 d6                	jne    80107248 <setupkvm+0x28>
}
80107272:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107275:	89 f0                	mov    %esi,%eax
80107277:	5b                   	pop    %ebx
80107278:	5e                   	pop    %esi
80107279:	5d                   	pop    %ebp
8010727a:	c3                   	ret    
8010727b:	90                   	nop
8010727c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107280:	83 ec 0c             	sub    $0xc,%esp
80107283:	56                   	push   %esi
      return 0;
80107284:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107286:	e8 15 ff ff ff       	call   801071a0 <freevm>
      return 0;
8010728b:	83 c4 10             	add    $0x10,%esp
}
8010728e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107291:	89 f0                	mov    %esi,%eax
80107293:	5b                   	pop    %ebx
80107294:	5e                   	pop    %esi
80107295:	5d                   	pop    %ebp
80107296:	c3                   	ret    
80107297:	89 f6                	mov    %esi,%esi
80107299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072a0 <kvmalloc>:
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801072a6:	e8 75 ff ff ff       	call   80107220 <setupkvm>
801072ab:	a3 a4 f1 11 80       	mov    %eax,0x8011f1a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072b0:	05 00 00 00 80       	add    $0x80000000,%eax
801072b5:	0f 22 d8             	mov    %eax,%cr3
}
801072b8:	c9                   	leave  
801072b9:	c3                   	ret    
801072ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801072c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072c1:	31 c9                	xor    %ecx,%ecx
{
801072c3:	89 e5                	mov    %esp,%ebp
801072c5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801072c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072cb:	8b 45 08             	mov    0x8(%ebp),%eax
801072ce:	e8 bd f8 ff ff       	call   80106b90 <walkpgdir>
  if(pte == 0)
801072d3:	85 c0                	test   %eax,%eax
801072d5:	74 05                	je     801072dc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801072d7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801072da:	c9                   	leave  
801072db:	c3                   	ret    
    panic("clearpteu");
801072dc:	83 ec 0c             	sub    $0xc,%esp
801072df:	68 a6 7e 10 80       	push   $0x80107ea6
801072e4:	e8 a7 90 ff ff       	call   80100390 <panic>
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072f0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	57                   	push   %edi
801072f4:	56                   	push   %esi
801072f5:	53                   	push   %ebx
801072f6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801072f9:	e8 22 ff ff ff       	call   80107220 <setupkvm>
801072fe:	85 c0                	test   %eax,%eax
80107300:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107303:	0f 84 9f 00 00 00    	je     801073a8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107309:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010730c:	85 c9                	test   %ecx,%ecx
8010730e:	0f 84 94 00 00 00    	je     801073a8 <copyuvm+0xb8>
80107314:	31 ff                	xor    %edi,%edi
80107316:	eb 4a                	jmp    80107362 <copyuvm+0x72>
80107318:	90                   	nop
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107320:	83 ec 04             	sub    $0x4,%esp
80107323:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107329:	68 00 10 00 00       	push   $0x1000
8010732e:	53                   	push   %ebx
8010732f:	50                   	push   %eax
80107330:	e8 9b d7 ff ff       	call   80104ad0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107335:	58                   	pop    %eax
80107336:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010733c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107341:	5a                   	pop    %edx
80107342:	ff 75 e4             	pushl  -0x1c(%ebp)
80107345:	50                   	push   %eax
80107346:	89 fa                	mov    %edi,%edx
80107348:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010734b:	e8 c0 f8 ff ff       	call   80106c10 <mappages>
80107350:	83 c4 10             	add    $0x10,%esp
80107353:	85 c0                	test   %eax,%eax
80107355:	78 61                	js     801073b8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107357:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010735d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107360:	76 46                	jbe    801073a8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107362:	8b 45 08             	mov    0x8(%ebp),%eax
80107365:	31 c9                	xor    %ecx,%ecx
80107367:	89 fa                	mov    %edi,%edx
80107369:	e8 22 f8 ff ff       	call   80106b90 <walkpgdir>
8010736e:	85 c0                	test   %eax,%eax
80107370:	74 61                	je     801073d3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107372:	8b 00                	mov    (%eax),%eax
80107374:	a8 01                	test   $0x1,%al
80107376:	74 4e                	je     801073c6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107378:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010737a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010737f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107385:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107388:	e8 c3 b4 ff ff       	call   80102850 <kalloc>
8010738d:	85 c0                	test   %eax,%eax
8010738f:	89 c6                	mov    %eax,%esi
80107391:	75 8d                	jne    80107320 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107393:	83 ec 0c             	sub    $0xc,%esp
80107396:	ff 75 e0             	pushl  -0x20(%ebp)
80107399:	e8 02 fe ff ff       	call   801071a0 <freevm>
  return 0;
8010739e:	83 c4 10             	add    $0x10,%esp
801073a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801073a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ae:	5b                   	pop    %ebx
801073af:	5e                   	pop    %esi
801073b0:	5f                   	pop    %edi
801073b1:	5d                   	pop    %ebp
801073b2:	c3                   	ret    
801073b3:	90                   	nop
801073b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801073b8:	83 ec 0c             	sub    $0xc,%esp
801073bb:	56                   	push   %esi
801073bc:	e8 df b2 ff ff       	call   801026a0 <kfree>
      goto bad;
801073c1:	83 c4 10             	add    $0x10,%esp
801073c4:	eb cd                	jmp    80107393 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801073c6:	83 ec 0c             	sub    $0xc,%esp
801073c9:	68 ca 7e 10 80       	push   $0x80107eca
801073ce:	e8 bd 8f ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801073d3:	83 ec 0c             	sub    $0xc,%esp
801073d6:	68 b0 7e 10 80       	push   $0x80107eb0
801073db:	e8 b0 8f ff ff       	call   80100390 <panic>

801073e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801073e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801073e1:	31 c9                	xor    %ecx,%ecx
{
801073e3:	89 e5                	mov    %esp,%ebp
801073e5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801073e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801073eb:	8b 45 08             	mov    0x8(%ebp),%eax
801073ee:	e8 9d f7 ff ff       	call   80106b90 <walkpgdir>
  if((*pte & PTE_P) == 0)
801073f3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801073f5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801073f6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801073fd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107400:	05 00 00 00 80       	add    $0x80000000,%eax
80107405:	83 fa 05             	cmp    $0x5,%edx
80107408:	ba 00 00 00 00       	mov    $0x0,%edx
8010740d:	0f 45 c2             	cmovne %edx,%eax
}
80107410:	c3                   	ret    
80107411:	eb 0d                	jmp    80107420 <copyout>
80107413:	90                   	nop
80107414:	90                   	nop
80107415:	90                   	nop
80107416:	90                   	nop
80107417:	90                   	nop
80107418:	90                   	nop
80107419:	90                   	nop
8010741a:	90                   	nop
8010741b:	90                   	nop
8010741c:	90                   	nop
8010741d:	90                   	nop
8010741e:	90                   	nop
8010741f:	90                   	nop

80107420 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
80107426:	83 ec 1c             	sub    $0x1c,%esp
80107429:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010742c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010742f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107432:	85 db                	test   %ebx,%ebx
80107434:	75 40                	jne    80107476 <copyout+0x56>
80107436:	eb 70                	jmp    801074a8 <copyout+0x88>
80107438:	90                   	nop
80107439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107440:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107443:	89 f1                	mov    %esi,%ecx
80107445:	29 d1                	sub    %edx,%ecx
80107447:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010744d:	39 d9                	cmp    %ebx,%ecx
8010744f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107452:	29 f2                	sub    %esi,%edx
80107454:	83 ec 04             	sub    $0x4,%esp
80107457:	01 d0                	add    %edx,%eax
80107459:	51                   	push   %ecx
8010745a:	57                   	push   %edi
8010745b:	50                   	push   %eax
8010745c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010745f:	e8 6c d6 ff ff       	call   80104ad0 <memmove>
    len -= n;
    buf += n;
80107464:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107467:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010746a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107470:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107472:	29 cb                	sub    %ecx,%ebx
80107474:	74 32                	je     801074a8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107476:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107478:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010747b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010747e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107484:	56                   	push   %esi
80107485:	ff 75 08             	pushl  0x8(%ebp)
80107488:	e8 53 ff ff ff       	call   801073e0 <uva2ka>
    if(pa0 == 0)
8010748d:	83 c4 10             	add    $0x10,%esp
80107490:	85 c0                	test   %eax,%eax
80107492:	75 ac                	jne    80107440 <copyout+0x20>
  }
  return 0;
}
80107494:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107497:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010749c:	5b                   	pop    %ebx
8010749d:	5e                   	pop    %esi
8010749e:	5f                   	pop    %edi
8010749f:	5d                   	pop    %ebp
801074a0:	c3                   	ret    
801074a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074ab:	31 c0                	xor    %eax,%eax
}
801074ad:	5b                   	pop    %ebx
801074ae:	5e                   	pop    %esi
801074af:	5f                   	pop    %edi
801074b0:	5d                   	pop    %ebp
801074b1:	c3                   	ret    
