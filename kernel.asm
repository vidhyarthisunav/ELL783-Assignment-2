
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
8010004c:	68 40 73 10 80       	push   $0x80107340
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 e5 45 00 00       	call   80104640 <initlock>
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
80100092:	68 47 73 10 80       	push   $0x80107347
80100097:	50                   	push   %eax
80100098:	e8 73 44 00 00       	call   80104510 <initsleeplock>
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
801000e4:	e8 97 46 00 00       	call   80104780 <acquire>
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
80100162:	e8 d9 46 00 00       	call   80104840 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 43 00 00       	call   80104550 <acquiresleep>
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
80100193:	68 4e 73 10 80       	push   $0x8010734e
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
801001ae:	e8 3d 44 00 00       	call   801045f0 <holdingsleep>
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
801001cc:	68 5f 73 10 80       	push   $0x8010735f
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
801001ef:	e8 fc 43 00 00       	call   801045f0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 43 00 00       	call   801045b0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 70 45 00 00       	call   80104780 <acquire>
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
8010025c:	e9 df 45 00 00       	jmp    80104840 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 73 10 80       	push   $0x80107366
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
8010028c:	e8 ef 44 00 00       	call   80104780 <acquire>
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
801002c5:	e8 d6 3e 00 00       	call   801041a0 <sleep>
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
801002ef:	e8 4c 45 00 00       	call   80104840 <release>
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
8010034d:	e8 ee 44 00 00       	call   80104840 <release>
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
801003b2:	68 6d 73 10 80       	push   $0x8010736d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 d3 7c 10 80 	movl   $0x80107cd3,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 83 42 00 00       	call   80104660 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 81 73 10 80       	push   $0x80107381
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
8010043a:	e8 01 5b 00 00       	call   80105f40 <uartputc>
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
801004ec:	e8 4f 5a 00 00       	call   80105f40 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 43 5a 00 00       	call   80105f40 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 37 5a 00 00       	call   80105f40 <uartputc>
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
80100524:	e8 17 44 00 00       	call   80104940 <memmove>
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
80100541:	e8 4a 43 00 00       	call   80104890 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 85 73 10 80       	push   $0x80107385
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
801005b1:	0f b6 92 b0 73 10 80 	movzbl -0x7fef8c50(%edx),%edx
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
8010061b:	e8 60 41 00 00       	call   80104780 <acquire>
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
80100647:	e8 f4 41 00 00       	call   80104840 <release>
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
8010071f:	e8 1c 41 00 00       	call   80104840 <release>
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
801007d0:	ba 98 73 10 80       	mov    $0x80107398,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 8b 3f 00 00       	call   80104780 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 9f 73 10 80       	push   $0x8010739f
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
80100823:	e8 58 3f 00 00       	call   80104780 <acquire>
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
80100888:	e8 b3 3f 00 00       	call   80104840 <release>
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
80100916:	e8 45 3a 00 00       	call   80104360 <wakeup>
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
80100997:	e9 a4 3a 00 00       	jmp    80104440 <procdump>
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
801009c6:	68 a8 73 10 80       	push   $0x801073a8
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 6b 3c 00 00       	call   80104640 <initlock>

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
80100a94:	e8 f7 65 00 00       	call   80107090 <setupkvm>
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
80100af6:	e8 b5 63 00 00       	call   80106eb0 <allocuvm>
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
80100b28:	e8 c3 62 00 00       	call   80106df0 <loaduvm>
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
80100b72:	e8 99 64 00 00       	call   80107010 <freevm>
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
80100baa:	e8 01 63 00 00       	call   80106eb0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 4a 64 00 00       	call   80107010 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 c8 23 00 00       	call   80102fa0 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 c1 73 10 80       	push   $0x801073c1
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
80100c06:	e8 25 65 00 00       	call   80107130 <clearpteu>
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
80100c39:	e8 72 3e 00 00       	call   80104ab0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 5f 3e 00 00       	call   80104ab0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 2e 66 00 00       	call   80107290 <copyout>
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
80100cc7:	e8 c4 65 00 00       	call   80107290 <copyout>
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
80100d0a:	e8 61 3d 00 00       	call   80104a70 <safestrcpy>
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
80100d34:	e8 27 5f 00 00       	call   80106c60 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 cf 62 00 00       	call   80107010 <freevm>
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
80100d66:	68 cd 73 10 80       	push   $0x801073cd
80100d6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d70:	e8 cb 38 00 00       	call   80104640 <initlock>
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
80100d91:	e8 ea 39 00 00       	call   80104780 <acquire>
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
80100dc1:	e8 7a 3a 00 00       	call   80104840 <release>
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
80100dda:	e8 61 3a 00 00       	call   80104840 <release>
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
80100dff:	e8 7c 39 00 00       	call   80104780 <acquire>
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
80100e1c:	e8 1f 3a 00 00       	call   80104840 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 d4 73 10 80       	push   $0x801073d4
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
80100e51:	e8 2a 39 00 00       	call   80104780 <acquire>
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
80100e7c:	e9 bf 39 00 00       	jmp    80104840 <release>
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
80100ea8:	e8 93 39 00 00       	call   80104840 <release>
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
80100f02:	68 dc 73 10 80       	push   $0x801073dc
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
80100fe2:	68 e6 73 10 80       	push   $0x801073e6
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
801010f5:	68 ef 73 10 80       	push   $0x801073ef
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 f5 73 10 80       	push   $0x801073f5
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
80101173:	68 ff 73 10 80       	push   $0x801073ff
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
80101224:	68 12 74 10 80       	push   $0x80107412
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
80101265:	e8 26 36 00 00       	call   80104890 <memset>
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
801012aa:	e8 d1 34 00 00       	call   80104780 <acquire>
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
8010130f:	e8 2c 35 00 00       	call   80104840 <release>

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
8010133d:	e8 fe 34 00 00       	call   80104840 <release>
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
80101352:	68 28 74 10 80       	push   $0x80107428
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
80101427:	68 38 74 10 80       	push   $0x80107438
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
80101461:	e8 da 34 00 00       	call   80104940 <memmove>
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
8010148c:	68 4b 74 10 80       	push   $0x8010744b
80101491:	68 e0 09 11 80       	push   $0x801109e0
80101496:	e8 a5 31 00 00       	call   80104640 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 52 74 10 80       	push   $0x80107452
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 5c 30 00 00       	call   80104510 <initsleeplock>
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
801014f9:	68 fc 74 10 80       	push   $0x801074fc
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
8010158e:	e8 fd 32 00 00       	call   80104890 <memset>
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
801015c3:	68 58 74 10 80       	push   $0x80107458
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
80101631:	e8 0a 33 00 00       	call   80104940 <memmove>
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
8010165f:	e8 1c 31 00 00       	call   80104780 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010166f:	e8 cc 31 00 00       	call   80104840 <release>
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
801016a2:	e8 a9 2e 00 00       	call   80104550 <acquiresleep>
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
80101718:	e8 23 32 00 00       	call   80104940 <memmove>
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
8010173d:	68 70 74 10 80       	push   $0x80107470
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 6a 74 10 80       	push   $0x8010746a
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
80101773:	e8 78 2e 00 00       	call   801045f0 <holdingsleep>
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
8010178f:	e9 1c 2e 00 00       	jmp    801045b0 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 7f 74 10 80       	push   $0x8010747f
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
801017c0:	e8 8b 2d 00 00       	call   80104550 <acquiresleep>
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
801017da:	e8 d1 2d 00 00       	call   801045b0 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017e6:	e8 95 2f 00 00       	call   80104780 <acquire>
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
80101800:	e9 3b 30 00 00       	jmp    80104840 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 e0 09 11 80       	push   $0x801109e0
80101810:	e8 6b 2f 00 00       	call   80104780 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010181f:	e8 1c 30 00 00       	call   80104840 <release>
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
80101a07:	e8 34 2f 00 00       	call   80104940 <memmove>
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
80101b03:	e8 38 2e 00 00       	call   80104940 <memmove>
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
80101b9e:	e8 0d 2e 00 00       	call   801049b0 <strncmp>
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
80101bfd:	e8 ae 2d 00 00       	call   801049b0 <strncmp>
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
80101c42:	68 99 74 10 80       	push   $0x80107499
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 87 74 10 80       	push   $0x80107487
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
80101c89:	e8 f2 2a 00 00       	call   80104780 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c99:	e8 a2 2b 00 00       	call   80104840 <release>
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
80101cf5:	e8 46 2c 00 00       	call   80104940 <memmove>
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
80101d88:	e8 b3 2b 00 00       	call   80104940 <memmove>
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
80101e7d:	e8 8e 2b 00 00       	call   80104a10 <strncpy>
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
80101ebb:	68 a8 74 10 80       	push   $0x801074a8
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 ed 7a 10 80       	push   $0x80107aed
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
80101fc1:	68 b5 74 10 80       	push   $0x801074b5
80101fc6:	56                   	push   %esi
80101fc7:	e8 74 29 00 00       	call   80104940 <memmove>
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
80102022:	68 bd 74 10 80       	push   $0x801074bd
80102027:	53                   	push   %ebx
80102028:	e8 83 29 00 00       	call   801049b0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010202d:	83 c4 10             	add    $0x10,%esp
80102030:	85 c0                	test   %eax,%eax
80102032:	0f 84 f8 00 00 00    	je     80102130 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102038:	83 ec 04             	sub    $0x4,%esp
8010203b:	6a 0e                	push   $0xe
8010203d:	68 bc 74 10 80       	push   $0x801074bc
80102042:	53                   	push   %ebx
80102043:	e8 68 29 00 00       	call   801049b0 <strncmp>
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
80102097:	e8 f4 27 00 00       	call   80104890 <memset>
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
80102104:	e8 67 2f 00 00       	call   80105070 <isdirempty>
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
8010218c:	68 d1 74 10 80       	push   $0x801074d1
80102191:	e8 fa e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102196:	83 ec 0c             	sub    $0xc,%esp
80102199:	68 bf 74 10 80       	push   $0x801074bf
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
801021c0:	68 b5 74 10 80       	push   $0x801074b5
801021c5:	56                   	push   %esi
801021c6:	e8 75 27 00 00       	call   80104940 <memmove>
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
801021e5:	e8 96 30 00 00       	call   80105280 <create>
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
80102239:	68 e0 74 10 80       	push   $0x801074e0
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
8010236b:	68 58 75 10 80       	push   $0x80107558
80102370:	e8 1b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
80102375:	83 ec 0c             	sub    $0xc,%esp
80102378:	68 4f 75 10 80       	push   $0x8010754f
8010237d:	e8 0e e0 ff ff       	call   80100390 <panic>
80102382:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102390 <ideinit>:
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102396:	68 6a 75 10 80       	push   $0x8010756a
8010239b:	68 80 a5 10 80       	push   $0x8010a580
801023a0:	e8 9b 22 00 00       	call   80104640 <initlock>
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
8010241e:	e8 5d 23 00 00       	call   80104780 <acquire>

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
80102481:	e8 da 1e 00 00       	call   80104360 <wakeup>

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
8010249f:	e8 9c 23 00 00       	call   80104840 <release>

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
801024be:	e8 2d 21 00 00       	call   801045f0 <holdingsleep>
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
801024f8:	e8 83 22 00 00       	call   80104780 <acquire>

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
80102549:	e8 52 1c 00 00       	call   801041a0 <sleep>
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
80102566:	e9 d5 22 00 00       	jmp    80104840 <release>
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
8010258a:	68 84 75 10 80       	push   $0x80107584
8010258f:	e8 fc dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102594:	83 ec 0c             	sub    $0xc,%esp
80102597:	68 6e 75 10 80       	push   $0x8010756e
8010259c:	e8 ef dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801025a1:	83 ec 0c             	sub    $0xc,%esp
801025a4:	68 99 75 10 80       	push   $0x80107599
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
801025f7:	68 b8 75 10 80       	push   $0x801075b8
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
801026d2:	e8 b9 21 00 00       	call   80104890 <memset>

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
8010270b:	e9 30 21 00 00       	jmp    80104840 <release>
    acquire(&kmem.lock);
80102710:	83 ec 0c             	sub    $0xc,%esp
80102713:	68 40 26 11 80       	push   $0x80112640
80102718:	e8 63 20 00 00       	call   80104780 <acquire>
8010271d:	83 c4 10             	add    $0x10,%esp
80102720:	eb c2                	jmp    801026e4 <kfree+0x44>
    panic("kfree");
80102722:	83 ec 0c             	sub    $0xc,%esp
80102725:	68 ea 75 10 80       	push   $0x801075ea
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
8010278b:	68 f0 75 10 80       	push   $0x801075f0
80102790:	68 40 26 11 80       	push   $0x80112640
80102795:	e8 a6 1e 00 00       	call   80104640 <initlock>
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
80102883:	e8 f8 1e 00 00       	call   80104780 <acquire>
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
801028b1:	e8 8a 1f 00 00       	call   80104840 <release>
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
80102903:	0f b6 82 20 77 10 80 	movzbl -0x7fef88e0(%edx),%eax
8010290a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010290c:	0f b6 82 20 76 10 80 	movzbl -0x7fef89e0(%edx),%eax
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
80102923:	8b 04 85 00 76 10 80 	mov    -0x7fef8a00(,%eax,4),%eax
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
80102948:	0f b6 82 20 77 10 80 	movzbl -0x7fef88e0(%edx),%eax
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
80102cc7:	e8 14 1c 00 00       	call   801048e0 <memcmp>
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
80102df4:	e8 47 1b 00 00       	call   80104940 <memmove>
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
80102e9a:	68 20 78 10 80       	push   $0x80107820
80102e9f:	68 80 26 11 80       	push   $0x80112680
80102ea4:	e8 97 17 00 00       	call   80104640 <initlock>
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
80102f3b:	e8 40 18 00 00       	call   80104780 <acquire>
80102f40:	83 c4 10             	add    $0x10,%esp
80102f43:	eb 18                	jmp    80102f5d <begin_op+0x2d>
80102f45:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f48:	83 ec 08             	sub    $0x8,%esp
80102f4b:	68 80 26 11 80       	push   $0x80112680
80102f50:	68 80 26 11 80       	push   $0x80112680
80102f55:	e8 46 12 00 00       	call   801041a0 <sleep>
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
80102f8c:	e8 af 18 00 00       	call   80104840 <release>
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
80102fae:	e8 cd 17 00 00       	call   80104780 <acquire>
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
80102fec:	e8 4f 18 00 00       	call   80104840 <release>
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
80103046:	e8 f5 18 00 00       	call   80104940 <memmove>
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
8010308f:	e8 ec 16 00 00       	call   80104780 <acquire>
    wakeup(&log);
80103094:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
8010309b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
801030a2:	00 00 00 
    wakeup(&log);
801030a5:	e8 b6 12 00 00       	call   80104360 <wakeup>
    release(&log.lock);
801030aa:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801030b1:	e8 8a 17 00 00       	call   80104840 <release>
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
801030d0:	e8 8b 12 00 00       	call   80104360 <wakeup>
  release(&log.lock);
801030d5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801030dc:	e8 5f 17 00 00       	call   80104840 <release>
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
801030ef:	68 24 78 10 80       	push   $0x80107824
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
8010313e:	e8 3d 16 00 00       	call   80104780 <acquire>
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
8010318d:	e9 ae 16 00 00       	jmp    80104840 <release>
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
801031b9:	68 33 78 10 80       	push   $0x80107833
801031be:	e8 cd d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801031c3:	83 ec 0c             	sub    $0xc,%esp
801031c6:	68 49 78 10 80       	push   $0x80107849
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
801031e8:	68 64 78 10 80       	push   $0x80107864
801031ed:	e8 6e d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801031f2:	e8 59 29 00 00       	call   80105b50 <idtinit>
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
8010320a:	e8 b1 0c 00 00       	call   80103ec0 <scheduler>
8010320f:	90                   	nop

80103210 <mpenter>:
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103216:	e8 25 3a 00 00       	call   80106c40 <switchkvm>
  seginit();
8010321b:	e8 90 39 00 00       	call   80106bb0 <seginit>
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
80103251:	e8 ba 3e 00 00       	call   80107110 <kvmalloc>
  mpinit();        // detect other processors
80103256:	e8 75 01 00 00       	call   801033d0 <mpinit>
  lapicinit();     // interrupt controller
8010325b:	e8 60 f7 ff ff       	call   801029c0 <lapicinit>
  seginit();       // segment descriptors
80103260:	e8 4b 39 00 00       	call   80106bb0 <seginit>
  picinit();       // disable pic
80103265:	e8 46 03 00 00       	call   801035b0 <picinit>
  ioapicinit();    // another interrupt controller
8010326a:	e8 41 f3 ff ff       	call   801025b0 <ioapicinit>
  consoleinit();   // console hardware
8010326f:	e8 4c d7 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103274:	e8 07 2c 00 00       	call   80105e80 <uartinit>
  pinit();         // process table
80103279:	e8 c2 08 00 00       	call   80103b40 <pinit>
  tvinit();        // trap vectors
8010327e:	e8 4d 28 00 00       	call   80105ad0 <tvinit>
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
801032a4:	e8 97 16 00 00       	call   80104940 <memmove>

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
8010337e:	68 78 78 10 80       	push   $0x80107878
80103383:	56                   	push   %esi
80103384:	e8 57 15 00 00       	call   801048e0 <memcmp>
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
8010343c:	68 95 78 10 80       	push   $0x80107895
80103441:	56                   	push   %esi
80103442:	e8 99 14 00 00       	call   801048e0 <memcmp>
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
801034d0:	ff 24 95 bc 78 10 80 	jmp    *-0x7fef8744(,%edx,4)
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
80103583:	68 7d 78 10 80       	push   $0x8010787d
80103588:	e8 03 ce ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010358d:	83 ec 0c             	sub    $0xc,%esp
80103590:	68 9c 78 10 80       	push   $0x8010789c
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
8010368b:	68 d0 78 10 80       	push   $0x801078d0
80103690:	50                   	push   %eax
80103691:	e8 aa 0f 00 00       	call   80104640 <initlock>
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
801036ef:	e8 8c 10 00 00       	call   80104780 <acquire>
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
8010370f:	e8 4c 0c 00 00       	call   80104360 <wakeup>
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
80103734:	e9 07 11 00 00       	jmp    80104840 <release>
80103739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103740:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103746:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103749:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103750:	00 00 00 
    wakeup(&p->nwrite);
80103753:	50                   	push   %eax
80103754:	e8 07 0c 00 00       	call   80104360 <wakeup>
80103759:	83 c4 10             	add    $0x10,%esp
8010375c:	eb b9                	jmp    80103717 <pipeclose+0x37>
8010375e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	53                   	push   %ebx
80103764:	e8 d7 10 00 00       	call   80104840 <release>
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
8010378d:	e8 ee 0f 00 00       	call   80104780 <acquire>
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
801037e4:	e8 77 0b 00 00       	call   80104360 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037e9:	5a                   	pop    %edx
801037ea:	59                   	pop    %ecx
801037eb:	53                   	push   %ebx
801037ec:	56                   	push   %esi
801037ed:	e8 ae 09 00 00       	call   801041a0 <sleep>
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
80103824:	e8 17 10 00 00       	call   80104840 <release>
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
80103873:	e8 e8 0a 00 00       	call   80104360 <wakeup>
  release(&p->lock);
80103878:	89 1c 24             	mov    %ebx,(%esp)
8010387b:	e8 c0 0f 00 00       	call   80104840 <release>
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
801038a0:	e8 db 0e 00 00       	call   80104780 <acquire>
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
801038d5:	e8 c6 08 00 00       	call   801041a0 <sleep>
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
8010390e:	e8 2d 0f 00 00       	call   80104840 <release>
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
80103967:	e8 f4 09 00 00       	call   80104360 <wakeup>
  release(&p->lock);
8010396c:	89 34 24             	mov    %esi,(%esp)
8010396f:	e8 cc 0e 00 00       	call   80104840 <release>
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
801039a1:	e8 da 0d 00 00       	call   80104780 <acquire>
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
801039e9:	e8 52 0e 00 00       	call   80104840 <release>

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
80103a12:	c7 40 14 c2 5a 10 80 	movl   $0x80105ac2,0x14(%eax)
  p->context = (struct context*)sp;
80103a19:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a1c:	6a 14                	push   $0x14
80103a1e:	6a 00                	push   $0x0
80103a20:	50                   	push   %eax
80103a21:	e8 6a 0e 00 00       	call   80104890 <memset>
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
80103ad2:	e8 69 0d 00 00       	call   80104840 <release>
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
80103afb:	e8 40 0d 00 00       	call   80104840 <release>

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
80103b46:	68 d5 78 10 80       	push   $0x801078d5
80103b4b:	68 20 2d 11 80       	push   $0x80112d20
80103b50:	e8 eb 0a 00 00       	call   80104640 <initlock>
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
80103bc0:	68 dc 78 10 80       	push   $0x801078dc
80103bc5:	e8 c6 c7 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103bca:	83 ec 0c             	sub    $0xc,%esp
80103bcd:	68 b8 79 10 80       	push   $0x801079b8
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
80103c07:	e8 a4 0a 00 00       	call   801046b0 <pushcli>
  c = mycpu();
80103c0c:	e8 4f ff ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80103c11:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c17:	e8 d4 0a 00 00       	call   801046f0 <popcli>
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
80103c43:	e8 48 34 00 00       	call   80107090 <setupkvm>
80103c48:	85 c0                	test   %eax,%eax
80103c4a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c4d:	0f 84 bd 00 00 00    	je     80103d10 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c53:	83 ec 04             	sub    $0x4,%esp
80103c56:	68 2c 00 00 00       	push   $0x2c
80103c5b:	68 60 a4 10 80       	push   $0x8010a460
80103c60:	50                   	push   %eax
80103c61:	e8 0a 31 00 00       	call   80106d70 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c66:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c69:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c6f:	6a 4c                	push   $0x4c
80103c71:	6a 00                	push   $0x0
80103c73:	ff 73 18             	pushl  0x18(%ebx)
80103c76:	e8 15 0c 00 00       	call   80104890 <memset>
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
80103ccf:	68 05 79 10 80       	push   $0x80107905
80103cd4:	50                   	push   %eax
80103cd5:	e8 96 0d 00 00       	call   80104a70 <safestrcpy>
  p->cwd = namei("/");
80103cda:	c7 04 24 0e 79 10 80 	movl   $0x8010790e,(%esp)
80103ce1:	e8 fa e1 ff ff       	call   80101ee0 <namei>
80103ce6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ce9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cf0:	e8 8b 0a 00 00       	call   80104780 <acquire>
  p->state = RUNNABLE;
80103cf5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103cfc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d03:	e8 38 0b 00 00       	call   80104840 <release>
}
80103d08:	83 c4 10             	add    $0x10,%esp
80103d0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d0e:	c9                   	leave  
80103d0f:	c3                   	ret    
    panic("userinit: out of memory?");
80103d10:	83 ec 0c             	sub    $0xc,%esp
80103d13:	68 ec 78 10 80       	push   $0x801078ec
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
80103d28:	e8 83 09 00 00       	call   801046b0 <pushcli>
  c = mycpu();
80103d2d:	e8 2e fe ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80103d32:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d38:	e8 b3 09 00 00       	call   801046f0 <popcli>
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
80103d4c:	e8 0f 2f 00 00       	call   80106c60 <switchuvm>
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
80103d6a:	e8 41 31 00 00       	call   80106eb0 <allocuvm>
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
80103d8a:	e8 51 32 00 00       	call   80106fe0 <deallocuvm>
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
80103da6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103da9:	e8 02 09 00 00       	call   801046b0 <pushcli>
  c = mycpu();
80103dae:	e8 ad fd ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80103db3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103db9:	e8 32 09 00 00       	call   801046f0 <popcli>
  if((np = allocproc()) == 0){
80103dbe:	e8 cd fb ff ff       	call   80103990 <allocproc>
80103dc3:	85 c0                	test   %eax,%eax
80103dc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103dc8:	0f 84 b7 00 00 00    	je     80103e85 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dce:	83 ec 08             	sub    $0x8,%esp
80103dd1:	ff 33                	pushl  (%ebx)
80103dd3:	ff 73 04             	pushl  0x4(%ebx)
80103dd6:	89 c7                	mov    %eax,%edi
80103dd8:	e8 83 33 00 00       	call   80107160 <copyuvm>
80103ddd:	83 c4 10             	add    $0x10,%esp
80103de0:	85 c0                	test   %eax,%eax
80103de2:	89 47 04             	mov    %eax,0x4(%edi)
80103de5:	0f 84 a1 00 00 00    	je     80103e8c <fork+0xec>
  np->sz = curproc->sz;
80103deb:	8b 03                	mov    (%ebx),%eax
80103ded:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103df0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103df2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103df5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103df7:	8b 79 18             	mov    0x18(%ecx),%edi
80103dfa:	8b 73 18             	mov    0x18(%ebx),%esi
80103dfd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e04:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e06:	8b 40 18             	mov    0x18(%eax),%eax
80103e09:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103e10:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e14:	85 c0                	test   %eax,%eax
80103e16:	74 13                	je     80103e2b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e18:	83 ec 0c             	sub    $0xc,%esp
80103e1b:	50                   	push   %eax
80103e1c:	e8 cf cf ff ff       	call   80100df0 <filedup>
80103e21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e24:	83 c4 10             	add    $0x10,%esp
80103e27:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e2b:	83 c6 01             	add    $0x1,%esi
80103e2e:	83 fe 10             	cmp    $0x10,%esi
80103e31:	75 dd                	jne    80103e10 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e33:	83 ec 0c             	sub    $0xc,%esp
80103e36:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e39:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103e3c:	e8 0f d8 ff ff       	call   80101650 <idup>
80103e41:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e44:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e47:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e4a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e4d:	6a 10                	push   $0x10
80103e4f:	53                   	push   %ebx
80103e50:	50                   	push   %eax
80103e51:	e8 1a 0c 00 00       	call   80104a70 <safestrcpy>
  pid = np->pid;
80103e56:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103e59:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e60:	e8 1b 09 00 00       	call   80104780 <acquire>
  np->state = RUNNABLE;
80103e65:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103e6c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e73:	e8 c8 09 00 00       	call   80104840 <release>
  return pid;
80103e78:	83 c4 10             	add    $0x10,%esp
}
80103e7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e7e:	89 d8                	mov    %ebx,%eax
80103e80:	5b                   	pop    %ebx
80103e81:	5e                   	pop    %esi
80103e82:	5f                   	pop    %edi
80103e83:	5d                   	pop    %ebp
80103e84:	c3                   	ret    
    return -1;
80103e85:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e8a:	eb ef                	jmp    80103e7b <fork+0xdb>
    kfree(np->kstack);
80103e8c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e8f:	83 ec 0c             	sub    $0xc,%esp
80103e92:	ff 73 08             	pushl  0x8(%ebx)
80103e95:	e8 06 e8 ff ff       	call   801026a0 <kfree>
    np->kstack = 0;
80103e9a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103ea1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ea8:	83 c4 10             	add    $0x10,%esp
80103eab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103eb0:	eb c9                	jmp    80103e7b <fork+0xdb>
80103eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ec0 <scheduler>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ec9:	e8 92 fc ff ff       	call   80103b60 <mycpu>
80103ece:	8d 78 04             	lea    0x4(%eax),%edi
80103ed1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ed3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103eda:	00 00 00 
80103edd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103ee0:	fb                   	sti    
    acquire(&ptable.lock);
80103ee1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103ee9:	68 20 2d 11 80       	push   $0x80112d20
80103eee:	e8 8d 08 00 00       	call   80104780 <acquire>
80103ef3:	83 c4 10             	add    $0x10,%esp
80103ef6:	8d 76 00             	lea    0x0(%esi),%esi
80103ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103f00:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f04:	75 33                	jne    80103f39 <scheduler+0x79>
      switchuvm(p);
80103f06:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f09:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f0f:	53                   	push   %ebx
80103f10:	e8 4b 2d 00 00       	call   80106c60 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f15:	58                   	pop    %eax
80103f16:	5a                   	pop    %edx
80103f17:	ff 73 1c             	pushl  0x1c(%ebx)
80103f1a:	57                   	push   %edi
      p->state = RUNNING;
80103f1b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103f22:	e8 a4 0b 00 00       	call   80104acb <swtch>
      switchkvm();
80103f27:	e8 14 2d 00 00       	call   80106c40 <switchkvm>
      c->proc = 0;
80103f2c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f33:	00 00 00 
80103f36:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f39:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
80103f3f:	81 fb 54 e9 11 80    	cmp    $0x8011e954,%ebx
80103f45:	72 b9                	jb     80103f00 <scheduler+0x40>
    release(&ptable.lock);
80103f47:	83 ec 0c             	sub    $0xc,%esp
80103f4a:	68 20 2d 11 80       	push   $0x80112d20
80103f4f:	e8 ec 08 00 00       	call   80104840 <release>
    sti();
80103f54:	83 c4 10             	add    $0x10,%esp
80103f57:	eb 87                	jmp    80103ee0 <scheduler+0x20>
80103f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f60 <sched>:
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	56                   	push   %esi
80103f64:	53                   	push   %ebx
  pushcli();
80103f65:	e8 46 07 00 00       	call   801046b0 <pushcli>
  c = mycpu();
80103f6a:	e8 f1 fb ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80103f6f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f75:	e8 76 07 00 00       	call   801046f0 <popcli>
  if(!holding(&ptable.lock))
80103f7a:	83 ec 0c             	sub    $0xc,%esp
80103f7d:	68 20 2d 11 80       	push   $0x80112d20
80103f82:	e8 c9 07 00 00       	call   80104750 <holding>
80103f87:	83 c4 10             	add    $0x10,%esp
80103f8a:	85 c0                	test   %eax,%eax
80103f8c:	74 4f                	je     80103fdd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f8e:	e8 cd fb ff ff       	call   80103b60 <mycpu>
80103f93:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f9a:	75 68                	jne    80104004 <sched+0xa4>
  if(p->state == RUNNING)
80103f9c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fa0:	74 55                	je     80103ff7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fa2:	9c                   	pushf  
80103fa3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fa4:	f6 c4 02             	test   $0x2,%ah
80103fa7:	75 41                	jne    80103fea <sched+0x8a>
  intena = mycpu()->intena;
80103fa9:	e8 b2 fb ff ff       	call   80103b60 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fae:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103fb1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103fb7:	e8 a4 fb ff ff       	call   80103b60 <mycpu>
80103fbc:	83 ec 08             	sub    $0x8,%esp
80103fbf:	ff 70 04             	pushl  0x4(%eax)
80103fc2:	53                   	push   %ebx
80103fc3:	e8 03 0b 00 00       	call   80104acb <swtch>
  mycpu()->intena = intena;
80103fc8:	e8 93 fb ff ff       	call   80103b60 <mycpu>
}
80103fcd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103fd0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103fd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd9:	5b                   	pop    %ebx
80103fda:	5e                   	pop    %esi
80103fdb:	5d                   	pop    %ebp
80103fdc:	c3                   	ret    
    panic("sched ptable.lock");
80103fdd:	83 ec 0c             	sub    $0xc,%esp
80103fe0:	68 10 79 10 80       	push   $0x80107910
80103fe5:	e8 a6 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103fea:	83 ec 0c             	sub    $0xc,%esp
80103fed:	68 3c 79 10 80       	push   $0x8010793c
80103ff2:	e8 99 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80103ff7:	83 ec 0c             	sub    $0xc,%esp
80103ffa:	68 2e 79 10 80       	push   $0x8010792e
80103fff:	e8 8c c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104004:	83 ec 0c             	sub    $0xc,%esp
80104007:	68 22 79 10 80       	push   $0x80107922
8010400c:	e8 7f c3 ff ff       	call   80100390 <panic>
80104011:	eb 0d                	jmp    80104020 <exit>
80104013:	90                   	nop
80104014:	90                   	nop
80104015:	90                   	nop
80104016:	90                   	nop
80104017:	90                   	nop
80104018:	90                   	nop
80104019:	90                   	nop
8010401a:	90                   	nop
8010401b:	90                   	nop
8010401c:	90                   	nop
8010401d:	90                   	nop
8010401e:	90                   	nop
8010401f:	90                   	nop

80104020 <exit>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	57                   	push   %edi
80104024:	56                   	push   %esi
80104025:	53                   	push   %ebx
80104026:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104029:	e8 82 06 00 00       	call   801046b0 <pushcli>
  c = mycpu();
8010402e:	e8 2d fb ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80104033:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104039:	e8 b2 06 00 00       	call   801046f0 <popcli>
  if(curproc == initproc)
8010403e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80104044:	8d 5e 28             	lea    0x28(%esi),%ebx
80104047:	8d 7e 68             	lea    0x68(%esi),%edi
8010404a:	0f 84 f1 00 00 00    	je     80104141 <exit+0x121>
    if(curproc->ofile[fd]){
80104050:	8b 03                	mov    (%ebx),%eax
80104052:	85 c0                	test   %eax,%eax
80104054:	74 12                	je     80104068 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104056:	83 ec 0c             	sub    $0xc,%esp
80104059:	50                   	push   %eax
8010405a:	e8 e1 cd ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
8010405f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104065:	83 c4 10             	add    $0x10,%esp
80104068:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010406b:	39 fb                	cmp    %edi,%ebx
8010406d:	75 e1                	jne    80104050 <exit+0x30>
  begin_op();
8010406f:	e8 bc ee ff ff       	call   80102f30 <begin_op>
  iput(curproc->cwd);
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	ff 76 68             	pushl  0x68(%esi)
8010407a:	e8 31 d7 ff ff       	call   801017b0 <iput>
  end_op();
8010407f:	e8 1c ef ff ff       	call   80102fa0 <end_op>
  curproc->cwd = 0;
80104084:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010408b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104092:	e8 e9 06 00 00       	call   80104780 <acquire>
  wakeup1(curproc->parent);
80104097:	8b 56 14             	mov    0x14(%esi),%edx
8010409a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010409d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040a2:	eb 10                	jmp    801040b4 <exit+0x94>
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040a8:	05 f0 02 00 00       	add    $0x2f0,%eax
801040ad:	3d 54 e9 11 80       	cmp    $0x8011e954,%eax
801040b2:	73 1e                	jae    801040d2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
801040b4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040b8:	75 ee                	jne    801040a8 <exit+0x88>
801040ba:	3b 50 20             	cmp    0x20(%eax),%edx
801040bd:	75 e9                	jne    801040a8 <exit+0x88>
      p->state = RUNNABLE;
801040bf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c6:	05 f0 02 00 00       	add    $0x2f0,%eax
801040cb:	3d 54 e9 11 80       	cmp    $0x8011e954,%eax
801040d0:	72 e2                	jb     801040b4 <exit+0x94>
      p->parent = initproc;
801040d2:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040d8:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801040dd:	eb 0f                	jmp    801040ee <exit+0xce>
801040df:	90                   	nop
801040e0:	81 c2 f0 02 00 00    	add    $0x2f0,%edx
801040e6:	81 fa 54 e9 11 80    	cmp    $0x8011e954,%edx
801040ec:	73 3a                	jae    80104128 <exit+0x108>
    if(p->parent == curproc){
801040ee:	39 72 14             	cmp    %esi,0x14(%edx)
801040f1:	75 ed                	jne    801040e0 <exit+0xc0>
      if(p->state == ZOMBIE)
801040f3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801040f7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801040fa:	75 e4                	jne    801040e0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040fc:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104101:	eb 11                	jmp    80104114 <exit+0xf4>
80104103:	90                   	nop
80104104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104108:	05 f0 02 00 00       	add    $0x2f0,%eax
8010410d:	3d 54 e9 11 80       	cmp    $0x8011e954,%eax
80104112:	73 cc                	jae    801040e0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104114:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104118:	75 ee                	jne    80104108 <exit+0xe8>
8010411a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010411d:	75 e9                	jne    80104108 <exit+0xe8>
      p->state = RUNNABLE;
8010411f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104126:	eb e0                	jmp    80104108 <exit+0xe8>
  curproc->state = ZOMBIE;
80104128:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010412f:	e8 2c fe ff ff       	call   80103f60 <sched>
  panic("zombie exit");
80104134:	83 ec 0c             	sub    $0xc,%esp
80104137:	68 5d 79 10 80       	push   $0x8010795d
8010413c:	e8 4f c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104141:	83 ec 0c             	sub    $0xc,%esp
80104144:	68 50 79 10 80       	push   $0x80107950
80104149:	e8 42 c2 ff ff       	call   80100390 <panic>
8010414e:	66 90                	xchg   %ax,%ax

80104150 <yield>:
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104157:	68 20 2d 11 80       	push   $0x80112d20
8010415c:	e8 1f 06 00 00       	call   80104780 <acquire>
  pushcli();
80104161:	e8 4a 05 00 00       	call   801046b0 <pushcli>
  c = mycpu();
80104166:	e8 f5 f9 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
8010416b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104171:	e8 7a 05 00 00       	call   801046f0 <popcli>
  myproc()->state = RUNNABLE;
80104176:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010417d:	e8 de fd ff ff       	call   80103f60 <sched>
  release(&ptable.lock);
80104182:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104189:	e8 b2 06 00 00       	call   80104840 <release>
}
8010418e:	83 c4 10             	add    $0x10,%esp
80104191:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104194:	c9                   	leave  
80104195:	c3                   	ret    
80104196:	8d 76 00             	lea    0x0(%esi),%esi
80104199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041a0 <sleep>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	57                   	push   %edi
801041a4:	56                   	push   %esi
801041a5:	53                   	push   %ebx
801041a6:	83 ec 0c             	sub    $0xc,%esp
801041a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041af:	e8 fc 04 00 00       	call   801046b0 <pushcli>
  c = mycpu();
801041b4:	e8 a7 f9 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
801041b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041bf:	e8 2c 05 00 00       	call   801046f0 <popcli>
  if(p == 0)
801041c4:	85 db                	test   %ebx,%ebx
801041c6:	0f 84 87 00 00 00    	je     80104253 <sleep+0xb3>
  if(lk == 0)
801041cc:	85 f6                	test   %esi,%esi
801041ce:	74 76                	je     80104246 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041d0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801041d6:	74 50                	je     80104228 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041d8:	83 ec 0c             	sub    $0xc,%esp
801041db:	68 20 2d 11 80       	push   $0x80112d20
801041e0:	e8 9b 05 00 00       	call   80104780 <acquire>
    release(lk);
801041e5:	89 34 24             	mov    %esi,(%esp)
801041e8:	e8 53 06 00 00       	call   80104840 <release>
  p->chan = chan;
801041ed:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041f0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041f7:	e8 64 fd ff ff       	call   80103f60 <sched>
  p->chan = 0;
801041fc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104203:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010420a:	e8 31 06 00 00       	call   80104840 <release>
    acquire(lk);
8010420f:	89 75 08             	mov    %esi,0x8(%ebp)
80104212:	83 c4 10             	add    $0x10,%esp
}
80104215:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104218:	5b                   	pop    %ebx
80104219:	5e                   	pop    %esi
8010421a:	5f                   	pop    %edi
8010421b:	5d                   	pop    %ebp
    acquire(lk);
8010421c:	e9 5f 05 00 00       	jmp    80104780 <acquire>
80104221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104228:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010422b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104232:	e8 29 fd ff ff       	call   80103f60 <sched>
  p->chan = 0;
80104237:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010423e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104241:	5b                   	pop    %ebx
80104242:	5e                   	pop    %esi
80104243:	5f                   	pop    %edi
80104244:	5d                   	pop    %ebp
80104245:	c3                   	ret    
    panic("sleep without lk");
80104246:	83 ec 0c             	sub    $0xc,%esp
80104249:	68 6f 79 10 80       	push   $0x8010796f
8010424e:	e8 3d c1 ff ff       	call   80100390 <panic>
    panic("sleep");
80104253:	83 ec 0c             	sub    $0xc,%esp
80104256:	68 69 79 10 80       	push   $0x80107969
8010425b:	e8 30 c1 ff ff       	call   80100390 <panic>

80104260 <wait>:
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	56                   	push   %esi
80104264:	53                   	push   %ebx
  pushcli();
80104265:	e8 46 04 00 00       	call   801046b0 <pushcli>
  c = mycpu();
8010426a:	e8 f1 f8 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
8010426f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104275:	e8 76 04 00 00       	call   801046f0 <popcli>
  acquire(&ptable.lock);
8010427a:	83 ec 0c             	sub    $0xc,%esp
8010427d:	68 20 2d 11 80       	push   $0x80112d20
80104282:	e8 f9 04 00 00       	call   80104780 <acquire>
80104287:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010428a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010428c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104291:	eb 13                	jmp    801042a6 <wait+0x46>
80104293:	90                   	nop
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104298:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
8010429e:	81 fb 54 e9 11 80    	cmp    $0x8011e954,%ebx
801042a4:	73 1e                	jae    801042c4 <wait+0x64>
      if(p->parent != curproc)
801042a6:	39 73 14             	cmp    %esi,0x14(%ebx)
801042a9:	75 ed                	jne    80104298 <wait+0x38>
      if(p->state == ZOMBIE){
801042ab:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801042af:	74 37                	je     801042e8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b1:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
      havekids = 1;
801042b7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042bc:	81 fb 54 e9 11 80    	cmp    $0x8011e954,%ebx
801042c2:	72 e2                	jb     801042a6 <wait+0x46>
    if(!havekids || curproc->killed){
801042c4:	85 c0                	test   %eax,%eax
801042c6:	74 76                	je     8010433e <wait+0xde>
801042c8:	8b 46 24             	mov    0x24(%esi),%eax
801042cb:	85 c0                	test   %eax,%eax
801042cd:	75 6f                	jne    8010433e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801042cf:	83 ec 08             	sub    $0x8,%esp
801042d2:	68 20 2d 11 80       	push   $0x80112d20
801042d7:	56                   	push   %esi
801042d8:	e8 c3 fe ff ff       	call   801041a0 <sleep>
    havekids = 0;
801042dd:	83 c4 10             	add    $0x10,%esp
801042e0:	eb a8                	jmp    8010428a <wait+0x2a>
801042e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801042e8:	83 ec 0c             	sub    $0xc,%esp
801042eb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801042ee:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801042f1:	e8 aa e3 ff ff       	call   801026a0 <kfree>
        freevm(p->pgdir);
801042f6:	5a                   	pop    %edx
801042f7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801042fa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104301:	e8 0a 2d 00 00       	call   80107010 <freevm>
        release(&ptable.lock);
80104306:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
8010430d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104314:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010431b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010431f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104326:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010432d:	e8 0e 05 00 00       	call   80104840 <release>
        return pid;
80104332:	83 c4 10             	add    $0x10,%esp
}
80104335:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104338:	89 f0                	mov    %esi,%eax
8010433a:	5b                   	pop    %ebx
8010433b:	5e                   	pop    %esi
8010433c:	5d                   	pop    %ebp
8010433d:	c3                   	ret    
      release(&ptable.lock);
8010433e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104341:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104346:	68 20 2d 11 80       	push   $0x80112d20
8010434b:	e8 f0 04 00 00       	call   80104840 <release>
      return -1;
80104350:	83 c4 10             	add    $0x10,%esp
80104353:	eb e0                	jmp    80104335 <wait+0xd5>
80104355:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104360 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 10             	sub    $0x10,%esp
80104367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010436a:	68 20 2d 11 80       	push   $0x80112d20
8010436f:	e8 0c 04 00 00       	call   80104780 <acquire>
80104374:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104377:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010437c:	eb 0e                	jmp    8010438c <wakeup+0x2c>
8010437e:	66 90                	xchg   %ax,%ax
80104380:	05 f0 02 00 00       	add    $0x2f0,%eax
80104385:	3d 54 e9 11 80       	cmp    $0x8011e954,%eax
8010438a:	73 1e                	jae    801043aa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010438c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104390:	75 ee                	jne    80104380 <wakeup+0x20>
80104392:	3b 58 20             	cmp    0x20(%eax),%ebx
80104395:	75 e9                	jne    80104380 <wakeup+0x20>
      p->state = RUNNABLE;
80104397:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010439e:	05 f0 02 00 00       	add    $0x2f0,%eax
801043a3:	3d 54 e9 11 80       	cmp    $0x8011e954,%eax
801043a8:	72 e2                	jb     8010438c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801043aa:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801043b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b4:	c9                   	leave  
  release(&ptable.lock);
801043b5:	e9 86 04 00 00       	jmp    80104840 <release>
801043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 10             	sub    $0x10,%esp
801043c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043ca:	68 20 2d 11 80       	push   $0x80112d20
801043cf:	e8 ac 03 00 00       	call   80104780 <acquire>
801043d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801043dc:	eb 0e                	jmp    801043ec <kill+0x2c>
801043de:	66 90                	xchg   %ax,%ax
801043e0:	05 f0 02 00 00       	add    $0x2f0,%eax
801043e5:	3d 54 e9 11 80       	cmp    $0x8011e954,%eax
801043ea:	73 34                	jae    80104420 <kill+0x60>
    if(p->pid == pid){
801043ec:	39 58 10             	cmp    %ebx,0x10(%eax)
801043ef:	75 ef                	jne    801043e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043f1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043f5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043fc:	75 07                	jne    80104405 <kill+0x45>
        p->state = RUNNABLE;
801043fe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104405:	83 ec 0c             	sub    $0xc,%esp
80104408:	68 20 2d 11 80       	push   $0x80112d20
8010440d:	e8 2e 04 00 00       	call   80104840 <release>
      return 0;
80104412:	83 c4 10             	add    $0x10,%esp
80104415:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104417:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010441a:	c9                   	leave  
8010441b:	c3                   	ret    
8010441c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104420:	83 ec 0c             	sub    $0xc,%esp
80104423:	68 20 2d 11 80       	push   $0x80112d20
80104428:	e8 13 04 00 00       	call   80104840 <release>
  return -1;
8010442d:	83 c4 10             	add    $0x10,%esp
80104430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104435:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104438:	c9                   	leave  
80104439:	c3                   	ret    
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104440 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	57                   	push   %edi
80104444:	56                   	push   %esi
80104445:	53                   	push   %ebx
80104446:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104449:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010444e:	83 ec 3c             	sub    $0x3c,%esp
80104451:	eb 27                	jmp    8010447a <procdump+0x3a>
80104453:	90                   	nop
80104454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104458:	83 ec 0c             	sub    $0xc,%esp
8010445b:	68 d3 7c 10 80       	push   $0x80107cd3
80104460:	e8 fb c1 ff ff       	call   80100660 <cprintf>
80104465:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104468:	81 c3 f0 02 00 00    	add    $0x2f0,%ebx
8010446e:	81 fb 54 e9 11 80    	cmp    $0x8011e954,%ebx
80104474:	0f 83 86 00 00 00    	jae    80104500 <procdump+0xc0>
    if(p->state == UNUSED)
8010447a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010447d:	85 c0                	test   %eax,%eax
8010447f:	74 e7                	je     80104468 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104481:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104484:	ba 80 79 10 80       	mov    $0x80107980,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104489:	77 11                	ja     8010449c <procdump+0x5c>
8010448b:	8b 14 85 e0 79 10 80 	mov    -0x7fef8620(,%eax,4),%edx
      state = "???";
80104492:	b8 80 79 10 80       	mov    $0x80107980,%eax
80104497:	85 d2                	test   %edx,%edx
80104499:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010449c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010449f:	50                   	push   %eax
801044a0:	52                   	push   %edx
801044a1:	ff 73 10             	pushl  0x10(%ebx)
801044a4:	68 84 79 10 80       	push   $0x80107984
801044a9:	e8 b2 c1 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801044ae:	83 c4 10             	add    $0x10,%esp
801044b1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801044b5:	75 a1                	jne    80104458 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044b7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044ba:	83 ec 08             	sub    $0x8,%esp
801044bd:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044c0:	50                   	push   %eax
801044c1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801044c4:	8b 40 0c             	mov    0xc(%eax),%eax
801044c7:	83 c0 08             	add    $0x8,%eax
801044ca:	50                   	push   %eax
801044cb:	e8 90 01 00 00       	call   80104660 <getcallerpcs>
801044d0:	83 c4 10             	add    $0x10,%esp
801044d3:	90                   	nop
801044d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801044d8:	8b 17                	mov    (%edi),%edx
801044da:	85 d2                	test   %edx,%edx
801044dc:	0f 84 76 ff ff ff    	je     80104458 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044e2:	83 ec 08             	sub    $0x8,%esp
801044e5:	83 c7 04             	add    $0x4,%edi
801044e8:	52                   	push   %edx
801044e9:	68 81 73 10 80       	push   $0x80107381
801044ee:	e8 6d c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044f3:	83 c4 10             	add    $0x10,%esp
801044f6:	39 fe                	cmp    %edi,%esi
801044f8:	75 de                	jne    801044d8 <procdump+0x98>
801044fa:	e9 59 ff ff ff       	jmp    80104458 <procdump+0x18>
801044ff:	90                   	nop
  }
}
80104500:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104503:	5b                   	pop    %ebx
80104504:	5e                   	pop    %esi
80104505:	5f                   	pop    %edi
80104506:	5d                   	pop    %ebp
80104507:	c3                   	ret    
80104508:	66 90                	xchg   %ax,%ax
8010450a:	66 90                	xchg   %ax,%ax
8010450c:	66 90                	xchg   %ax,%ax
8010450e:	66 90                	xchg   %ax,%ax

80104510 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	53                   	push   %ebx
80104514:	83 ec 0c             	sub    $0xc,%esp
80104517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010451a:	68 f8 79 10 80       	push   $0x801079f8
8010451f:	8d 43 04             	lea    0x4(%ebx),%eax
80104522:	50                   	push   %eax
80104523:	e8 18 01 00 00       	call   80104640 <initlock>
  lk->name = name;
80104528:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010452b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104531:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104534:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010453b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010453e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104541:	c9                   	leave  
80104542:	c3                   	ret    
80104543:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104550 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104558:	83 ec 0c             	sub    $0xc,%esp
8010455b:	8d 73 04             	lea    0x4(%ebx),%esi
8010455e:	56                   	push   %esi
8010455f:	e8 1c 02 00 00       	call   80104780 <acquire>
  while (lk->locked) {
80104564:	8b 13                	mov    (%ebx),%edx
80104566:	83 c4 10             	add    $0x10,%esp
80104569:	85 d2                	test   %edx,%edx
8010456b:	74 16                	je     80104583 <acquiresleep+0x33>
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104570:	83 ec 08             	sub    $0x8,%esp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	e8 26 fc ff ff       	call   801041a0 <sleep>
  while (lk->locked) {
8010457a:	8b 03                	mov    (%ebx),%eax
8010457c:	83 c4 10             	add    $0x10,%esp
8010457f:	85 c0                	test   %eax,%eax
80104581:	75 ed                	jne    80104570 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104583:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104589:	e8 72 f6 ff ff       	call   80103c00 <myproc>
8010458e:	8b 40 10             	mov    0x10(%eax),%eax
80104591:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104594:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104597:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010459a:	5b                   	pop    %ebx
8010459b:	5e                   	pop    %esi
8010459c:	5d                   	pop    %ebp
  release(&lk->lk);
8010459d:	e9 9e 02 00 00       	jmp    80104840 <release>
801045a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
801045b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	8d 73 04             	lea    0x4(%ebx),%esi
801045be:	56                   	push   %esi
801045bf:	e8 bc 01 00 00       	call   80104780 <acquire>
  lk->locked = 0;
801045c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801045ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801045d1:	89 1c 24             	mov    %ebx,(%esp)
801045d4:	e8 87 fd ff ff       	call   80104360 <wakeup>
  release(&lk->lk);
801045d9:	89 75 08             	mov    %esi,0x8(%ebp)
801045dc:	83 c4 10             	add    $0x10,%esp
}
801045df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045e2:	5b                   	pop    %ebx
801045e3:	5e                   	pop    %esi
801045e4:	5d                   	pop    %ebp
  release(&lk->lk);
801045e5:	e9 56 02 00 00       	jmp    80104840 <release>
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	57                   	push   %edi
801045f4:	56                   	push   %esi
801045f5:	53                   	push   %ebx
801045f6:	31 ff                	xor    %edi,%edi
801045f8:	83 ec 18             	sub    $0x18,%esp
801045fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104601:	56                   	push   %esi
80104602:	e8 79 01 00 00       	call   80104780 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104607:	8b 03                	mov    (%ebx),%eax
80104609:	83 c4 10             	add    $0x10,%esp
8010460c:	85 c0                	test   %eax,%eax
8010460e:	74 13                	je     80104623 <holdingsleep+0x33>
80104610:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104613:	e8 e8 f5 ff ff       	call   80103c00 <myproc>
80104618:	39 58 10             	cmp    %ebx,0x10(%eax)
8010461b:	0f 94 c0             	sete   %al
8010461e:	0f b6 c0             	movzbl %al,%eax
80104621:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104623:	83 ec 0c             	sub    $0xc,%esp
80104626:	56                   	push   %esi
80104627:	e8 14 02 00 00       	call   80104840 <release>
  return r;
}
8010462c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010462f:	89 f8                	mov    %edi,%eax
80104631:	5b                   	pop    %ebx
80104632:	5e                   	pop    %esi
80104633:	5f                   	pop    %edi
80104634:	5d                   	pop    %ebp
80104635:	c3                   	ret    
80104636:	66 90                	xchg   %ax,%ax
80104638:	66 90                	xchg   %ax,%ax
8010463a:	66 90                	xchg   %ax,%ax
8010463c:	66 90                	xchg   %ax,%ax
8010463e:	66 90                	xchg   %ax,%ax

80104640 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104646:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104649:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010464f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104652:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104659:	5d                   	pop    %ebp
8010465a:	c3                   	ret    
8010465b:	90                   	nop
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104660 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104660:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104661:	31 d2                	xor    %edx,%edx
{
80104663:	89 e5                	mov    %esp,%ebp
80104665:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104666:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104669:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010466c:	83 e8 08             	sub    $0x8,%eax
8010466f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104670:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104676:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010467c:	77 1a                	ja     80104698 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010467e:	8b 58 04             	mov    0x4(%eax),%ebx
80104681:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104684:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104687:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104689:	83 fa 0a             	cmp    $0xa,%edx
8010468c:	75 e2                	jne    80104670 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010468e:	5b                   	pop    %ebx
8010468f:	5d                   	pop    %ebp
80104690:	c3                   	ret    
80104691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104698:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010469b:	83 c1 28             	add    $0x28,%ecx
8010469e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801046a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801046a6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801046a9:	39 c1                	cmp    %eax,%ecx
801046ab:	75 f3                	jne    801046a0 <getcallerpcs+0x40>
}
801046ad:	5b                   	pop    %ebx
801046ae:	5d                   	pop    %ebp
801046af:	c3                   	ret    

801046b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	53                   	push   %ebx
801046b4:	83 ec 04             	sub    $0x4,%esp
801046b7:	9c                   	pushf  
801046b8:	5b                   	pop    %ebx
  asm volatile("cli");
801046b9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801046ba:	e8 a1 f4 ff ff       	call   80103b60 <mycpu>
801046bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801046c5:	85 c0                	test   %eax,%eax
801046c7:	75 11                	jne    801046da <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801046c9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046cf:	e8 8c f4 ff ff       	call   80103b60 <mycpu>
801046d4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801046da:	e8 81 f4 ff ff       	call   80103b60 <mycpu>
801046df:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046e6:	83 c4 04             	add    $0x4,%esp
801046e9:	5b                   	pop    %ebx
801046ea:	5d                   	pop    %ebp
801046eb:	c3                   	ret    
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046f0 <popcli>:

void
popcli(void)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046f6:	9c                   	pushf  
801046f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046f8:	f6 c4 02             	test   $0x2,%ah
801046fb:	75 35                	jne    80104732 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046fd:	e8 5e f4 ff ff       	call   80103b60 <mycpu>
80104702:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104709:	78 34                	js     8010473f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010470b:	e8 50 f4 ff ff       	call   80103b60 <mycpu>
80104710:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104716:	85 d2                	test   %edx,%edx
80104718:	74 06                	je     80104720 <popcli+0x30>
    sti();
}
8010471a:	c9                   	leave  
8010471b:	c3                   	ret    
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104720:	e8 3b f4 ff ff       	call   80103b60 <mycpu>
80104725:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010472b:	85 c0                	test   %eax,%eax
8010472d:	74 eb                	je     8010471a <popcli+0x2a>
  asm volatile("sti");
8010472f:	fb                   	sti    
}
80104730:	c9                   	leave  
80104731:	c3                   	ret    
    panic("popcli - interruptible");
80104732:	83 ec 0c             	sub    $0xc,%esp
80104735:	68 03 7a 10 80       	push   $0x80107a03
8010473a:	e8 51 bc ff ff       	call   80100390 <panic>
    panic("popcli");
8010473f:	83 ec 0c             	sub    $0xc,%esp
80104742:	68 1a 7a 10 80       	push   $0x80107a1a
80104747:	e8 44 bc ff ff       	call   80100390 <panic>
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104750 <holding>:
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	8b 75 08             	mov    0x8(%ebp),%esi
80104758:	31 db                	xor    %ebx,%ebx
  pushcli();
8010475a:	e8 51 ff ff ff       	call   801046b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010475f:	8b 06                	mov    (%esi),%eax
80104761:	85 c0                	test   %eax,%eax
80104763:	74 10                	je     80104775 <holding+0x25>
80104765:	8b 5e 08             	mov    0x8(%esi),%ebx
80104768:	e8 f3 f3 ff ff       	call   80103b60 <mycpu>
8010476d:	39 c3                	cmp    %eax,%ebx
8010476f:	0f 94 c3             	sete   %bl
80104772:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104775:	e8 76 ff ff ff       	call   801046f0 <popcli>
}
8010477a:	89 d8                	mov    %ebx,%eax
8010477c:	5b                   	pop    %ebx
8010477d:	5e                   	pop    %esi
8010477e:	5d                   	pop    %ebp
8010477f:	c3                   	ret    

80104780 <acquire>:
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104785:	e8 26 ff ff ff       	call   801046b0 <pushcli>
  if(holding(lk))
8010478a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010478d:	83 ec 0c             	sub    $0xc,%esp
80104790:	53                   	push   %ebx
80104791:	e8 ba ff ff ff       	call   80104750 <holding>
80104796:	83 c4 10             	add    $0x10,%esp
80104799:	85 c0                	test   %eax,%eax
8010479b:	0f 85 83 00 00 00    	jne    80104824 <acquire+0xa4>
801047a1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801047a3:	ba 01 00 00 00       	mov    $0x1,%edx
801047a8:	eb 09                	jmp    801047b3 <acquire+0x33>
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047b3:	89 d0                	mov    %edx,%eax
801047b5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801047b8:	85 c0                	test   %eax,%eax
801047ba:	75 f4                	jne    801047b0 <acquire+0x30>
  __sync_synchronize();
801047bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047c4:	e8 97 f3 ff ff       	call   80103b60 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047c9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801047cc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801047cf:	89 e8                	mov    %ebp,%eax
801047d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047d8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801047de:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801047e4:	77 1a                	ja     80104800 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801047e6:	8b 48 04             	mov    0x4(%eax),%ecx
801047e9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801047ec:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801047ef:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047f1:	83 fe 0a             	cmp    $0xa,%esi
801047f4:	75 e2                	jne    801047d8 <acquire+0x58>
}
801047f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047f9:	5b                   	pop    %ebx
801047fa:	5e                   	pop    %esi
801047fb:	5d                   	pop    %ebp
801047fc:	c3                   	ret    
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
80104800:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104803:	83 c2 28             	add    $0x28,%edx
80104806:	8d 76 00             	lea    0x0(%esi),%esi
80104809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104810:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104816:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104819:	39 d0                	cmp    %edx,%eax
8010481b:	75 f3                	jne    80104810 <acquire+0x90>
}
8010481d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104820:	5b                   	pop    %ebx
80104821:	5e                   	pop    %esi
80104822:	5d                   	pop    %ebp
80104823:	c3                   	ret    
    panic("acquire");
80104824:	83 ec 0c             	sub    $0xc,%esp
80104827:	68 21 7a 10 80       	push   $0x80107a21
8010482c:	e8 5f bb ff ff       	call   80100390 <panic>
80104831:	eb 0d                	jmp    80104840 <release>
80104833:	90                   	nop
80104834:	90                   	nop
80104835:	90                   	nop
80104836:	90                   	nop
80104837:	90                   	nop
80104838:	90                   	nop
80104839:	90                   	nop
8010483a:	90                   	nop
8010483b:	90                   	nop
8010483c:	90                   	nop
8010483d:	90                   	nop
8010483e:	90                   	nop
8010483f:	90                   	nop

80104840 <release>:
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	53                   	push   %ebx
80104844:	83 ec 10             	sub    $0x10,%esp
80104847:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010484a:	53                   	push   %ebx
8010484b:	e8 00 ff ff ff       	call   80104750 <holding>
80104850:	83 c4 10             	add    $0x10,%esp
80104853:	85 c0                	test   %eax,%eax
80104855:	74 22                	je     80104879 <release+0x39>
  lk->pcs[0] = 0;
80104857:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010485e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104865:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010486a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104870:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104873:	c9                   	leave  
  popcli();
80104874:	e9 77 fe ff ff       	jmp    801046f0 <popcli>
    panic("release");
80104879:	83 ec 0c             	sub    $0xc,%esp
8010487c:	68 29 7a 10 80       	push   $0x80107a29
80104881:	e8 0a bb ff ff       	call   80100390 <panic>
80104886:	66 90                	xchg   %ax,%ax
80104888:	66 90                	xchg   %ax,%ax
8010488a:	66 90                	xchg   %ax,%ax
8010488c:	66 90                	xchg   %ax,%ax
8010488e:	66 90                	xchg   %ax,%ax

80104890 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	53                   	push   %ebx
80104895:	8b 55 08             	mov    0x8(%ebp),%edx
80104898:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010489b:	f6 c2 03             	test   $0x3,%dl
8010489e:	75 05                	jne    801048a5 <memset+0x15>
801048a0:	f6 c1 03             	test   $0x3,%cl
801048a3:	74 13                	je     801048b8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801048a5:	89 d7                	mov    %edx,%edi
801048a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801048aa:	fc                   	cld    
801048ab:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801048ad:	5b                   	pop    %ebx
801048ae:	89 d0                	mov    %edx,%eax
801048b0:	5f                   	pop    %edi
801048b1:	5d                   	pop    %ebp
801048b2:	c3                   	ret    
801048b3:	90                   	nop
801048b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801048b8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801048bc:	c1 e9 02             	shr    $0x2,%ecx
801048bf:	89 f8                	mov    %edi,%eax
801048c1:	89 fb                	mov    %edi,%ebx
801048c3:	c1 e0 18             	shl    $0x18,%eax
801048c6:	c1 e3 10             	shl    $0x10,%ebx
801048c9:	09 d8                	or     %ebx,%eax
801048cb:	09 f8                	or     %edi,%eax
801048cd:	c1 e7 08             	shl    $0x8,%edi
801048d0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801048d2:	89 d7                	mov    %edx,%edi
801048d4:	fc                   	cld    
801048d5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801048d7:	5b                   	pop    %ebx
801048d8:	89 d0                	mov    %edx,%eax
801048da:	5f                   	pop    %edi
801048db:	5d                   	pop    %ebp
801048dc:	c3                   	ret    
801048dd:	8d 76 00             	lea    0x0(%esi),%esi

801048e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	56                   	push   %esi
801048e5:	53                   	push   %ebx
801048e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801048e9:	8b 75 08             	mov    0x8(%ebp),%esi
801048ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048ef:	85 db                	test   %ebx,%ebx
801048f1:	74 29                	je     8010491c <memcmp+0x3c>
    if(*s1 != *s2)
801048f3:	0f b6 16             	movzbl (%esi),%edx
801048f6:	0f b6 0f             	movzbl (%edi),%ecx
801048f9:	38 d1                	cmp    %dl,%cl
801048fb:	75 2b                	jne    80104928 <memcmp+0x48>
801048fd:	b8 01 00 00 00       	mov    $0x1,%eax
80104902:	eb 14                	jmp    80104918 <memcmp+0x38>
80104904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104908:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010490c:	83 c0 01             	add    $0x1,%eax
8010490f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104914:	38 ca                	cmp    %cl,%dl
80104916:	75 10                	jne    80104928 <memcmp+0x48>
  while(n-- > 0){
80104918:	39 d8                	cmp    %ebx,%eax
8010491a:	75 ec                	jne    80104908 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010491c:	5b                   	pop    %ebx
  return 0;
8010491d:	31 c0                	xor    %eax,%eax
}
8010491f:	5e                   	pop    %esi
80104920:	5f                   	pop    %edi
80104921:	5d                   	pop    %ebp
80104922:	c3                   	ret    
80104923:	90                   	nop
80104924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104928:	0f b6 c2             	movzbl %dl,%eax
}
8010492b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010492c:	29 c8                	sub    %ecx,%eax
}
8010492e:	5e                   	pop    %esi
8010492f:	5f                   	pop    %edi
80104930:	5d                   	pop    %ebp
80104931:	c3                   	ret    
80104932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104940 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	8b 45 08             	mov    0x8(%ebp),%eax
80104948:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010494b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010494e:	39 c3                	cmp    %eax,%ebx
80104950:	73 26                	jae    80104978 <memmove+0x38>
80104952:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104955:	39 c8                	cmp    %ecx,%eax
80104957:	73 1f                	jae    80104978 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104959:	85 f6                	test   %esi,%esi
8010495b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010495e:	74 0f                	je     8010496f <memmove+0x2f>
      *--d = *--s;
80104960:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104964:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104967:	83 ea 01             	sub    $0x1,%edx
8010496a:	83 fa ff             	cmp    $0xffffffff,%edx
8010496d:	75 f1                	jne    80104960 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010496f:	5b                   	pop    %ebx
80104970:	5e                   	pop    %esi
80104971:	5d                   	pop    %ebp
80104972:	c3                   	ret    
80104973:	90                   	nop
80104974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104978:	31 d2                	xor    %edx,%edx
8010497a:	85 f6                	test   %esi,%esi
8010497c:	74 f1                	je     8010496f <memmove+0x2f>
8010497e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104980:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104984:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104987:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010498a:	39 d6                	cmp    %edx,%esi
8010498c:	75 f2                	jne    80104980 <memmove+0x40>
}
8010498e:	5b                   	pop    %ebx
8010498f:	5e                   	pop    %esi
80104990:	5d                   	pop    %ebp
80104991:	c3                   	ret    
80104992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801049a3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801049a4:	eb 9a                	jmp    80104940 <memmove>
801049a6:	8d 76 00             	lea    0x0(%esi),%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	56                   	push   %esi
801049b5:	8b 7d 10             	mov    0x10(%ebp),%edi
801049b8:	53                   	push   %ebx
801049b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801049bf:	85 ff                	test   %edi,%edi
801049c1:	74 2f                	je     801049f2 <strncmp+0x42>
801049c3:	0f b6 01             	movzbl (%ecx),%eax
801049c6:	0f b6 1e             	movzbl (%esi),%ebx
801049c9:	84 c0                	test   %al,%al
801049cb:	74 37                	je     80104a04 <strncmp+0x54>
801049cd:	38 c3                	cmp    %al,%bl
801049cf:	75 33                	jne    80104a04 <strncmp+0x54>
801049d1:	01 f7                	add    %esi,%edi
801049d3:	eb 13                	jmp    801049e8 <strncmp+0x38>
801049d5:	8d 76 00             	lea    0x0(%esi),%esi
801049d8:	0f b6 01             	movzbl (%ecx),%eax
801049db:	84 c0                	test   %al,%al
801049dd:	74 21                	je     80104a00 <strncmp+0x50>
801049df:	0f b6 1a             	movzbl (%edx),%ebx
801049e2:	89 d6                	mov    %edx,%esi
801049e4:	38 d8                	cmp    %bl,%al
801049e6:	75 1c                	jne    80104a04 <strncmp+0x54>
    n--, p++, q++;
801049e8:	8d 56 01             	lea    0x1(%esi),%edx
801049eb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801049ee:	39 fa                	cmp    %edi,%edx
801049f0:	75 e6                	jne    801049d8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801049f2:	5b                   	pop    %ebx
    return 0;
801049f3:	31 c0                	xor    %eax,%eax
}
801049f5:	5e                   	pop    %esi
801049f6:	5f                   	pop    %edi
801049f7:	5d                   	pop    %ebp
801049f8:	c3                   	ret    
801049f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a00:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104a04:	29 d8                	sub    %ebx,%eax
}
80104a06:	5b                   	pop    %ebx
80104a07:	5e                   	pop    %esi
80104a08:	5f                   	pop    %edi
80104a09:	5d                   	pop    %ebp
80104a0a:	c3                   	ret    
80104a0b:	90                   	nop
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a10 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	53                   	push   %ebx
80104a15:	8b 45 08             	mov    0x8(%ebp),%eax
80104a18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104a1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a1e:	89 c2                	mov    %eax,%edx
80104a20:	eb 19                	jmp    80104a3b <strncpy+0x2b>
80104a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a28:	83 c3 01             	add    $0x1,%ebx
80104a2b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104a2f:	83 c2 01             	add    $0x1,%edx
80104a32:	84 c9                	test   %cl,%cl
80104a34:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a37:	74 09                	je     80104a42 <strncpy+0x32>
80104a39:	89 f1                	mov    %esi,%ecx
80104a3b:	85 c9                	test   %ecx,%ecx
80104a3d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104a40:	7f e6                	jg     80104a28 <strncpy+0x18>
    ;
  while(n-- > 0)
80104a42:	31 c9                	xor    %ecx,%ecx
80104a44:	85 f6                	test   %esi,%esi
80104a46:	7e 17                	jle    80104a5f <strncpy+0x4f>
80104a48:	90                   	nop
80104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104a50:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104a54:	89 f3                	mov    %esi,%ebx
80104a56:	83 c1 01             	add    $0x1,%ecx
80104a59:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104a5b:	85 db                	test   %ebx,%ebx
80104a5d:	7f f1                	jg     80104a50 <strncpy+0x40>
  return os;
}
80104a5f:	5b                   	pop    %ebx
80104a60:	5e                   	pop    %esi
80104a61:	5d                   	pop    %ebp
80104a62:	c3                   	ret    
80104a63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a70 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
80104a75:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a78:	8b 45 08             	mov    0x8(%ebp),%eax
80104a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104a7e:	85 c9                	test   %ecx,%ecx
80104a80:	7e 26                	jle    80104aa8 <safestrcpy+0x38>
80104a82:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104a86:	89 c1                	mov    %eax,%ecx
80104a88:	eb 17                	jmp    80104aa1 <safestrcpy+0x31>
80104a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a90:	83 c2 01             	add    $0x1,%edx
80104a93:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104a97:	83 c1 01             	add    $0x1,%ecx
80104a9a:	84 db                	test   %bl,%bl
80104a9c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104a9f:	74 04                	je     80104aa5 <safestrcpy+0x35>
80104aa1:	39 f2                	cmp    %esi,%edx
80104aa3:	75 eb                	jne    80104a90 <safestrcpy+0x20>
    ;
  *s = 0;
80104aa5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104aa8:	5b                   	pop    %ebx
80104aa9:	5e                   	pop    %esi
80104aaa:	5d                   	pop    %ebp
80104aab:	c3                   	ret    
80104aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ab0 <strlen>:

int
strlen(const char *s)
{
80104ab0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ab1:	31 c0                	xor    %eax,%eax
{
80104ab3:	89 e5                	mov    %esp,%ebp
80104ab5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ab8:	80 3a 00             	cmpb   $0x0,(%edx)
80104abb:	74 0c                	je     80104ac9 <strlen+0x19>
80104abd:	8d 76 00             	lea    0x0(%esi),%esi
80104ac0:	83 c0 01             	add    $0x1,%eax
80104ac3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ac7:	75 f7                	jne    80104ac0 <strlen+0x10>
    ;
  return n;
}
80104ac9:	5d                   	pop    %ebp
80104aca:	c3                   	ret    

80104acb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104acb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104acf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ad3:	55                   	push   %ebp
  pushl %ebx
80104ad4:	53                   	push   %ebx
  pushl %esi
80104ad5:	56                   	push   %esi
  pushl %edi
80104ad6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ad7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ad9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104adb:	5f                   	pop    %edi
  popl %esi
80104adc:	5e                   	pop    %esi
  popl %ebx
80104add:	5b                   	pop    %ebx
  popl %ebp
80104ade:	5d                   	pop    %ebp
  ret
80104adf:	c3                   	ret    

80104ae0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
80104ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104aea:	e8 11 f1 ff ff       	call   80103c00 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104aef:	8b 00                	mov    (%eax),%eax
80104af1:	39 d8                	cmp    %ebx,%eax
80104af3:	76 1b                	jbe    80104b10 <fetchint+0x30>
80104af5:	8d 53 04             	lea    0x4(%ebx),%edx
80104af8:	39 d0                	cmp    %edx,%eax
80104afa:	72 14                	jb     80104b10 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104afc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aff:	8b 13                	mov    (%ebx),%edx
80104b01:	89 10                	mov    %edx,(%eax)
  return 0;
80104b03:	31 c0                	xor    %eax,%eax
}
80104b05:	83 c4 04             	add    $0x4,%esp
80104b08:	5b                   	pop    %ebx
80104b09:	5d                   	pop    %ebp
80104b0a:	c3                   	ret    
80104b0b:	90                   	nop
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b15:	eb ee                	jmp    80104b05 <fetchint+0x25>
80104b17:	89 f6                	mov    %esi,%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	53                   	push   %ebx
80104b24:	83 ec 04             	sub    $0x4,%esp
80104b27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b2a:	e8 d1 f0 ff ff       	call   80103c00 <myproc>

  if(addr >= curproc->sz)
80104b2f:	39 18                	cmp    %ebx,(%eax)
80104b31:	76 29                	jbe    80104b5c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104b33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104b36:	89 da                	mov    %ebx,%edx
80104b38:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104b3a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104b3c:	39 c3                	cmp    %eax,%ebx
80104b3e:	73 1c                	jae    80104b5c <fetchstr+0x3c>
    if(*s == 0)
80104b40:	80 3b 00             	cmpb   $0x0,(%ebx)
80104b43:	75 10                	jne    80104b55 <fetchstr+0x35>
80104b45:	eb 39                	jmp    80104b80 <fetchstr+0x60>
80104b47:	89 f6                	mov    %esi,%esi
80104b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104b50:	80 3a 00             	cmpb   $0x0,(%edx)
80104b53:	74 1b                	je     80104b70 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104b55:	83 c2 01             	add    $0x1,%edx
80104b58:	39 d0                	cmp    %edx,%eax
80104b5a:	77 f4                	ja     80104b50 <fetchstr+0x30>
    return -1;
80104b5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104b61:	83 c4 04             	add    $0x4,%esp
80104b64:	5b                   	pop    %ebx
80104b65:	5d                   	pop    %ebp
80104b66:	c3                   	ret    
80104b67:	89 f6                	mov    %esi,%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104b70:	83 c4 04             	add    $0x4,%esp
80104b73:	89 d0                	mov    %edx,%eax
80104b75:	29 d8                	sub    %ebx,%eax
80104b77:	5b                   	pop    %ebx
80104b78:	5d                   	pop    %ebp
80104b79:	c3                   	ret    
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104b80:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104b82:	eb dd                	jmp    80104b61 <fetchstr+0x41>
80104b84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104b90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b95:	e8 66 f0 ff ff       	call   80103c00 <myproc>
80104b9a:	8b 40 18             	mov    0x18(%eax),%eax
80104b9d:	8b 55 08             	mov    0x8(%ebp),%edx
80104ba0:	8b 40 44             	mov    0x44(%eax),%eax
80104ba3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ba6:	e8 55 f0 ff ff       	call   80103c00 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bab:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bad:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bb0:	39 c6                	cmp    %eax,%esi
80104bb2:	73 1c                	jae    80104bd0 <argint+0x40>
80104bb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bb7:	39 d0                	cmp    %edx,%eax
80104bb9:	72 15                	jb     80104bd0 <argint+0x40>
  *ip = *(int*)(addr);
80104bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bbe:	8b 53 04             	mov    0x4(%ebx),%edx
80104bc1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bc3:	31 c0                	xor    %eax,%eax
}
80104bc5:	5b                   	pop    %ebx
80104bc6:	5e                   	pop    %esi
80104bc7:	5d                   	pop    %ebp
80104bc8:	c3                   	ret    
80104bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bd5:	eb ee                	jmp    80104bc5 <argint+0x35>
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	56                   	push   %esi
80104be4:	53                   	push   %ebx
80104be5:	83 ec 10             	sub    $0x10,%esp
80104be8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104beb:	e8 10 f0 ff ff       	call   80103c00 <myproc>
80104bf0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104bf2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bf5:	83 ec 08             	sub    $0x8,%esp
80104bf8:	50                   	push   %eax
80104bf9:	ff 75 08             	pushl  0x8(%ebp)
80104bfc:	e8 8f ff ff ff       	call   80104b90 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c01:	83 c4 10             	add    $0x10,%esp
80104c04:	85 c0                	test   %eax,%eax
80104c06:	78 28                	js     80104c30 <argptr+0x50>
80104c08:	85 db                	test   %ebx,%ebx
80104c0a:	78 24                	js     80104c30 <argptr+0x50>
80104c0c:	8b 16                	mov    (%esi),%edx
80104c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c11:	39 c2                	cmp    %eax,%edx
80104c13:	76 1b                	jbe    80104c30 <argptr+0x50>
80104c15:	01 c3                	add    %eax,%ebx
80104c17:	39 da                	cmp    %ebx,%edx
80104c19:	72 15                	jb     80104c30 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104c1b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c1e:	89 02                	mov    %eax,(%edx)
  return 0;
80104c20:	31 c0                	xor    %eax,%eax
}
80104c22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c25:	5b                   	pop    %ebx
80104c26:	5e                   	pop    %esi
80104c27:	5d                   	pop    %ebp
80104c28:	c3                   	ret    
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c35:	eb eb                	jmp    80104c22 <argptr+0x42>
80104c37:	89 f6                	mov    %esi,%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c40 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104c46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c49:	50                   	push   %eax
80104c4a:	ff 75 08             	pushl  0x8(%ebp)
80104c4d:	e8 3e ff ff ff       	call   80104b90 <argint>
80104c52:	83 c4 10             	add    $0x10,%esp
80104c55:	85 c0                	test   %eax,%eax
80104c57:	78 17                	js     80104c70 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104c59:	83 ec 08             	sub    $0x8,%esp
80104c5c:	ff 75 0c             	pushl  0xc(%ebp)
80104c5f:	ff 75 f4             	pushl  -0xc(%ebp)
80104c62:	e8 b9 fe ff ff       	call   80104b20 <fetchstr>
80104c67:	83 c4 10             	add    $0x10,%esp
}
80104c6a:	c9                   	leave  
80104c6b:	c3                   	ret    
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c75:	c9                   	leave  
80104c76:	c3                   	ret    
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	53                   	push   %ebx
80104c84:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c87:	e8 74 ef ff ff       	call   80103c00 <myproc>
80104c8c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c8e:	8b 40 18             	mov    0x18(%eax),%eax
80104c91:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c94:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c97:	83 fa 14             	cmp    $0x14,%edx
80104c9a:	77 1c                	ja     80104cb8 <syscall+0x38>
80104c9c:	8b 14 85 60 7a 10 80 	mov    -0x7fef85a0(,%eax,4),%edx
80104ca3:	85 d2                	test   %edx,%edx
80104ca5:	74 11                	je     80104cb8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104ca7:	ff d2                	call   *%edx
80104ca9:	8b 53 18             	mov    0x18(%ebx),%edx
80104cac:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104caf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb2:	c9                   	leave  
80104cb3:	c3                   	ret    
80104cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104cb8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104cb9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104cbc:	50                   	push   %eax
80104cbd:	ff 73 10             	pushl  0x10(%ebx)
80104cc0:	68 31 7a 10 80       	push   $0x80107a31
80104cc5:	e8 96 b9 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104cca:	8b 43 18             	mov    0x18(%ebx),%eax
80104ccd:	83 c4 10             	add    $0x10,%esp
80104cd0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104cd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cda:	c9                   	leave  
80104cdb:	c3                   	ret    
80104cdc:	66 90                	xchg   %ax,%ax
80104cde:	66 90                	xchg   %ax,%ax

80104ce0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
80104ce5:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104ce7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104cea:	89 d6                	mov    %edx,%esi
80104cec:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cef:	50                   	push   %eax
80104cf0:	6a 00                	push   $0x0
80104cf2:	e8 99 fe ff ff       	call   80104b90 <argint>
80104cf7:	83 c4 10             	add    $0x10,%esp
80104cfa:	85 c0                	test   %eax,%eax
80104cfc:	78 2a                	js     80104d28 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cfe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d02:	77 24                	ja     80104d28 <argfd.constprop.0+0x48>
80104d04:	e8 f7 ee ff ff       	call   80103c00 <myproc>
80104d09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d0c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104d10:	85 c0                	test   %eax,%eax
80104d12:	74 14                	je     80104d28 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80104d14:	85 db                	test   %ebx,%ebx
80104d16:	74 02                	je     80104d1a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104d18:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
80104d1a:	89 06                	mov    %eax,(%esi)
  return 0;
80104d1c:	31 c0                	xor    %eax,%eax
}
80104d1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d21:	5b                   	pop    %ebx
80104d22:	5e                   	pop    %esi
80104d23:	5d                   	pop    %ebp
80104d24:	c3                   	ret    
80104d25:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d2d:	eb ef                	jmp    80104d1e <argfd.constprop.0+0x3e>
80104d2f:	90                   	nop

80104d30 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104d30:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104d31:	31 c0                	xor    %eax,%eax
{
80104d33:	89 e5                	mov    %esp,%ebp
80104d35:	56                   	push   %esi
80104d36:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104d37:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104d3a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104d3d:	e8 9e ff ff ff       	call   80104ce0 <argfd.constprop.0>
80104d42:	85 c0                	test   %eax,%eax
80104d44:	78 42                	js     80104d88 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104d46:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d49:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104d4b:	e8 b0 ee ff ff       	call   80103c00 <myproc>
80104d50:	eb 0e                	jmp    80104d60 <sys_dup+0x30>
80104d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d58:	83 c3 01             	add    $0x1,%ebx
80104d5b:	83 fb 10             	cmp    $0x10,%ebx
80104d5e:	74 28                	je     80104d88 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104d60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d64:	85 d2                	test   %edx,%edx
80104d66:	75 f0                	jne    80104d58 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104d68:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
80104d6c:	83 ec 0c             	sub    $0xc,%esp
80104d6f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d72:	e8 79 c0 ff ff       	call   80100df0 <filedup>
  return fd;
80104d77:	83 c4 10             	add    $0x10,%esp
}
80104d7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d7d:	89 d8                	mov    %ebx,%eax
80104d7f:	5b                   	pop    %ebx
80104d80:	5e                   	pop    %esi
80104d81:	5d                   	pop    %ebp
80104d82:	c3                   	ret    
80104d83:	90                   	nop
80104d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d88:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d90:	89 d8                	mov    %ebx,%eax
80104d92:	5b                   	pop    %ebx
80104d93:	5e                   	pop    %esi
80104d94:	5d                   	pop    %ebp
80104d95:	c3                   	ret    
80104d96:	8d 76 00             	lea    0x0(%esi),%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104da0 <sys_read>:

int
sys_read(void)
{
80104da0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104da1:	31 c0                	xor    %eax,%eax
{
80104da3:	89 e5                	mov    %esp,%ebp
80104da5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104da8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104dab:	e8 30 ff ff ff       	call   80104ce0 <argfd.constprop.0>
80104db0:	85 c0                	test   %eax,%eax
80104db2:	78 4c                	js     80104e00 <sys_read+0x60>
80104db4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104db7:	83 ec 08             	sub    $0x8,%esp
80104dba:	50                   	push   %eax
80104dbb:	6a 02                	push   $0x2
80104dbd:	e8 ce fd ff ff       	call   80104b90 <argint>
80104dc2:	83 c4 10             	add    $0x10,%esp
80104dc5:	85 c0                	test   %eax,%eax
80104dc7:	78 37                	js     80104e00 <sys_read+0x60>
80104dc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dcc:	83 ec 04             	sub    $0x4,%esp
80104dcf:	ff 75 f0             	pushl  -0x10(%ebp)
80104dd2:	50                   	push   %eax
80104dd3:	6a 01                	push   $0x1
80104dd5:	e8 06 fe ff ff       	call   80104be0 <argptr>
80104dda:	83 c4 10             	add    $0x10,%esp
80104ddd:	85 c0                	test   %eax,%eax
80104ddf:	78 1f                	js     80104e00 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104de1:	83 ec 04             	sub    $0x4,%esp
80104de4:	ff 75 f0             	pushl  -0x10(%ebp)
80104de7:	ff 75 f4             	pushl  -0xc(%ebp)
80104dea:	ff 75 ec             	pushl  -0x14(%ebp)
80104ded:	e8 6e c1 ff ff       	call   80100f60 <fileread>
80104df2:	83 c4 10             	add    $0x10,%esp
}
80104df5:	c9                   	leave  
80104df6:	c3                   	ret    
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e05:	c9                   	leave  
80104e06:	c3                   	ret    
80104e07:	89 f6                	mov    %esi,%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <sys_write>:

int
sys_write(void)
{
80104e10:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e11:	31 c0                	xor    %eax,%eax
{
80104e13:	89 e5                	mov    %esp,%ebp
80104e15:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e1b:	e8 c0 fe ff ff       	call   80104ce0 <argfd.constprop.0>
80104e20:	85 c0                	test   %eax,%eax
80104e22:	78 4c                	js     80104e70 <sys_write+0x60>
80104e24:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e27:	83 ec 08             	sub    $0x8,%esp
80104e2a:	50                   	push   %eax
80104e2b:	6a 02                	push   $0x2
80104e2d:	e8 5e fd ff ff       	call   80104b90 <argint>
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	85 c0                	test   %eax,%eax
80104e37:	78 37                	js     80104e70 <sys_write+0x60>
80104e39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e3c:	83 ec 04             	sub    $0x4,%esp
80104e3f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e42:	50                   	push   %eax
80104e43:	6a 01                	push   $0x1
80104e45:	e8 96 fd ff ff       	call   80104be0 <argptr>
80104e4a:	83 c4 10             	add    $0x10,%esp
80104e4d:	85 c0                	test   %eax,%eax
80104e4f:	78 1f                	js     80104e70 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104e51:	83 ec 04             	sub    $0x4,%esp
80104e54:	ff 75 f0             	pushl  -0x10(%ebp)
80104e57:	ff 75 f4             	pushl  -0xc(%ebp)
80104e5a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e5d:	e8 8e c1 ff ff       	call   80100ff0 <filewrite>
80104e62:	83 c4 10             	add    $0x10,%esp
}
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e75:	c9                   	leave  
80104e76:	c3                   	ret    
80104e77:	89 f6                	mov    %esi,%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e80 <sys_close>:

int
sys_close(void)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104e86:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e8c:	e8 4f fe ff ff       	call   80104ce0 <argfd.constprop.0>
80104e91:	85 c0                	test   %eax,%eax
80104e93:	78 2b                	js     80104ec0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104e95:	e8 66 ed ff ff       	call   80103c00 <myproc>
80104e9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e9d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ea0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ea7:	00 
  fileclose(f);
80104ea8:	ff 75 f4             	pushl  -0xc(%ebp)
80104eab:	e8 90 bf ff ff       	call   80100e40 <fileclose>
  return 0;
80104eb0:	83 c4 10             	add    $0x10,%esp
80104eb3:	31 c0                	xor    %eax,%eax
}
80104eb5:	c9                   	leave  
80104eb6:	c3                   	ret    
80104eb7:	89 f6                	mov    %esi,%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ec5:	c9                   	leave  
80104ec6:	c3                   	ret    
80104ec7:	89 f6                	mov    %esi,%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ed0 <sys_fstat>:

int
sys_fstat(void)
{
80104ed0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ed1:	31 c0                	xor    %eax,%eax
{
80104ed3:	89 e5                	mov    %esp,%ebp
80104ed5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ed8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104edb:	e8 00 fe ff ff       	call   80104ce0 <argfd.constprop.0>
80104ee0:	85 c0                	test   %eax,%eax
80104ee2:	78 2c                	js     80104f10 <sys_fstat+0x40>
80104ee4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ee7:	83 ec 04             	sub    $0x4,%esp
80104eea:	6a 14                	push   $0x14
80104eec:	50                   	push   %eax
80104eed:	6a 01                	push   $0x1
80104eef:	e8 ec fc ff ff       	call   80104be0 <argptr>
80104ef4:	83 c4 10             	add    $0x10,%esp
80104ef7:	85 c0                	test   %eax,%eax
80104ef9:	78 15                	js     80104f10 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104efb:	83 ec 08             	sub    $0x8,%esp
80104efe:	ff 75 f4             	pushl  -0xc(%ebp)
80104f01:	ff 75 f0             	pushl  -0x10(%ebp)
80104f04:	e8 07 c0 ff ff       	call   80100f10 <filestat>
80104f09:	83 c4 10             	add    $0x10,%esp
}
80104f0c:	c9                   	leave  
80104f0d:	c3                   	ret    
80104f0e:	66 90                	xchg   %ax,%ax
    return -1;
80104f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f15:	c9                   	leave  
80104f16:	c3                   	ret    
80104f17:	89 f6                	mov    %esi,%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
80104f25:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f26:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f29:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f2c:	50                   	push   %eax
80104f2d:	6a 00                	push   $0x0
80104f2f:	e8 0c fd ff ff       	call   80104c40 <argstr>
80104f34:	83 c4 10             	add    $0x10,%esp
80104f37:	85 c0                	test   %eax,%eax
80104f39:	0f 88 fb 00 00 00    	js     8010503a <sys_link+0x11a>
80104f3f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f42:	83 ec 08             	sub    $0x8,%esp
80104f45:	50                   	push   %eax
80104f46:	6a 01                	push   $0x1
80104f48:	e8 f3 fc ff ff       	call   80104c40 <argstr>
80104f4d:	83 c4 10             	add    $0x10,%esp
80104f50:	85 c0                	test   %eax,%eax
80104f52:	0f 88 e2 00 00 00    	js     8010503a <sys_link+0x11a>
    return -1;

  begin_op();
80104f58:	e8 d3 df ff ff       	call   80102f30 <begin_op>
  if((ip = namei(old)) == 0){
80104f5d:	83 ec 0c             	sub    $0xc,%esp
80104f60:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f63:	e8 78 cf ff ff       	call   80101ee0 <namei>
80104f68:	83 c4 10             	add    $0x10,%esp
80104f6b:	85 c0                	test   %eax,%eax
80104f6d:	89 c3                	mov    %eax,%ebx
80104f6f:	0f 84 ea 00 00 00    	je     8010505f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80104f75:	83 ec 0c             	sub    $0xc,%esp
80104f78:	50                   	push   %eax
80104f79:	e8 02 c7 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
80104f7e:	83 c4 10             	add    $0x10,%esp
80104f81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f86:	0f 84 bb 00 00 00    	je     80105047 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104f8c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f91:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104f94:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f97:	53                   	push   %ebx
80104f98:	e8 33 c6 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
80104f9d:	89 1c 24             	mov    %ebx,(%esp)
80104fa0:	e8 bb c7 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fa5:	58                   	pop    %eax
80104fa6:	5a                   	pop    %edx
80104fa7:	57                   	push   %edi
80104fa8:	ff 75 d0             	pushl  -0x30(%ebp)
80104fab:	e8 50 cf ff ff       	call   80101f00 <nameiparent>
80104fb0:	83 c4 10             	add    $0x10,%esp
80104fb3:	85 c0                	test   %eax,%eax
80104fb5:	89 c6                	mov    %eax,%esi
80104fb7:	74 5b                	je     80105014 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104fb9:	83 ec 0c             	sub    $0xc,%esp
80104fbc:	50                   	push   %eax
80104fbd:	e8 be c6 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104fc2:	83 c4 10             	add    $0x10,%esp
80104fc5:	8b 03                	mov    (%ebx),%eax
80104fc7:	39 06                	cmp    %eax,(%esi)
80104fc9:	75 3d                	jne    80105008 <sys_link+0xe8>
80104fcb:	83 ec 04             	sub    $0x4,%esp
80104fce:	ff 73 04             	pushl  0x4(%ebx)
80104fd1:	57                   	push   %edi
80104fd2:	56                   	push   %esi
80104fd3:	e8 48 ce ff ff       	call   80101e20 <dirlink>
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	85 c0                	test   %eax,%eax
80104fdd:	78 29                	js     80105008 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104fdf:	83 ec 0c             	sub    $0xc,%esp
80104fe2:	56                   	push   %esi
80104fe3:	e8 28 c9 ff ff       	call   80101910 <iunlockput>
  iput(ip);
80104fe8:	89 1c 24             	mov    %ebx,(%esp)
80104feb:	e8 c0 c7 ff ff       	call   801017b0 <iput>

  end_op();
80104ff0:	e8 ab df ff ff       	call   80102fa0 <end_op>

  return 0;
80104ff5:	83 c4 10             	add    $0x10,%esp
80104ff8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ffd:	5b                   	pop    %ebx
80104ffe:	5e                   	pop    %esi
80104fff:	5f                   	pop    %edi
80105000:	5d                   	pop    %ebp
80105001:	c3                   	ret    
80105002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105008:	83 ec 0c             	sub    $0xc,%esp
8010500b:	56                   	push   %esi
8010500c:	e8 ff c8 ff ff       	call   80101910 <iunlockput>
    goto bad;
80105011:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105014:	83 ec 0c             	sub    $0xc,%esp
80105017:	53                   	push   %ebx
80105018:	e8 63 c6 ff ff       	call   80101680 <ilock>
  ip->nlink--;
8010501d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105022:	89 1c 24             	mov    %ebx,(%esp)
80105025:	e8 a6 c5 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
8010502a:	89 1c 24             	mov    %ebx,(%esp)
8010502d:	e8 de c8 ff ff       	call   80101910 <iunlockput>
  end_op();
80105032:	e8 69 df ff ff       	call   80102fa0 <end_op>
  return -1;
80105037:	83 c4 10             	add    $0x10,%esp
}
8010503a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010503d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105042:	5b                   	pop    %ebx
80105043:	5e                   	pop    %esi
80105044:	5f                   	pop    %edi
80105045:	5d                   	pop    %ebp
80105046:	c3                   	ret    
    iunlockput(ip);
80105047:	83 ec 0c             	sub    $0xc,%esp
8010504a:	53                   	push   %ebx
8010504b:	e8 c0 c8 ff ff       	call   80101910 <iunlockput>
    end_op();
80105050:	e8 4b df ff ff       	call   80102fa0 <end_op>
    return -1;
80105055:	83 c4 10             	add    $0x10,%esp
80105058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505d:	eb 9b                	jmp    80104ffa <sys_link+0xda>
    end_op();
8010505f:	e8 3c df ff ff       	call   80102fa0 <end_op>
    return -1;
80105064:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105069:	eb 8f                	jmp    80104ffa <sys_link+0xda>
8010506b:	90                   	nop
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105070 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
80105075:	53                   	push   %ebx
80105076:	83 ec 1c             	sub    $0x1c,%esp
80105079:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010507c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105080:	76 3e                	jbe    801050c0 <isdirempty+0x50>
80105082:	bb 20 00 00 00       	mov    $0x20,%ebx
80105087:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010508a:	eb 0c                	jmp    80105098 <isdirempty+0x28>
8010508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105090:	83 c3 10             	add    $0x10,%ebx
80105093:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105096:	73 28                	jae    801050c0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105098:	6a 10                	push   $0x10
8010509a:	53                   	push   %ebx
8010509b:	57                   	push   %edi
8010509c:	56                   	push   %esi
8010509d:	e8 be c8 ff ff       	call   80101960 <readi>
801050a2:	83 c4 10             	add    $0x10,%esp
801050a5:	83 f8 10             	cmp    $0x10,%eax
801050a8:	75 23                	jne    801050cd <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801050aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801050af:	74 df                	je     80105090 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801050b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801050b4:	31 c0                	xor    %eax,%eax
}
801050b6:	5b                   	pop    %ebx
801050b7:	5e                   	pop    %esi
801050b8:	5f                   	pop    %edi
801050b9:	5d                   	pop    %ebp
801050ba:	c3                   	ret    
801050bb:	90                   	nop
801050bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801050c3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801050c8:	5b                   	pop    %ebx
801050c9:	5e                   	pop    %esi
801050ca:	5f                   	pop    %edi
801050cb:	5d                   	pop    %ebp
801050cc:	c3                   	ret    
      panic("isdirempty: readi");
801050cd:	83 ec 0c             	sub    $0xc,%esp
801050d0:	68 b8 7a 10 80       	push   $0x80107ab8
801050d5:	e8 b6 b2 ff ff       	call   80100390 <panic>
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050e0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	57                   	push   %edi
801050e4:	56                   	push   %esi
801050e5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801050e6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801050e9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801050ec:	50                   	push   %eax
801050ed:	6a 00                	push   $0x0
801050ef:	e8 4c fb ff ff       	call   80104c40 <argstr>
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	85 c0                	test   %eax,%eax
801050f9:	0f 88 51 01 00 00    	js     80105250 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801050ff:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105102:	e8 29 de ff ff       	call   80102f30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105107:	83 ec 08             	sub    $0x8,%esp
8010510a:	53                   	push   %ebx
8010510b:	ff 75 c0             	pushl  -0x40(%ebp)
8010510e:	e8 ed cd ff ff       	call   80101f00 <nameiparent>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	89 c6                	mov    %eax,%esi
8010511a:	0f 84 37 01 00 00    	je     80105257 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105120:	83 ec 0c             	sub    $0xc,%esp
80105123:	50                   	push   %eax
80105124:	e8 57 c5 ff ff       	call   80101680 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105129:	58                   	pop    %eax
8010512a:	5a                   	pop    %edx
8010512b:	68 bd 74 10 80       	push   $0x801074bd
80105130:	53                   	push   %ebx
80105131:	e8 5a ca ff ff       	call   80101b90 <namecmp>
80105136:	83 c4 10             	add    $0x10,%esp
80105139:	85 c0                	test   %eax,%eax
8010513b:	0f 84 d7 00 00 00    	je     80105218 <sys_unlink+0x138>
80105141:	83 ec 08             	sub    $0x8,%esp
80105144:	68 bc 74 10 80       	push   $0x801074bc
80105149:	53                   	push   %ebx
8010514a:	e8 41 ca ff ff       	call   80101b90 <namecmp>
8010514f:	83 c4 10             	add    $0x10,%esp
80105152:	85 c0                	test   %eax,%eax
80105154:	0f 84 be 00 00 00    	je     80105218 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010515a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010515d:	83 ec 04             	sub    $0x4,%esp
80105160:	50                   	push   %eax
80105161:	53                   	push   %ebx
80105162:	56                   	push   %esi
80105163:	e8 48 ca ff ff       	call   80101bb0 <dirlookup>
80105168:	83 c4 10             	add    $0x10,%esp
8010516b:	85 c0                	test   %eax,%eax
8010516d:	89 c3                	mov    %eax,%ebx
8010516f:	0f 84 a3 00 00 00    	je     80105218 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105175:	83 ec 0c             	sub    $0xc,%esp
80105178:	50                   	push   %eax
80105179:	e8 02 c5 ff ff       	call   80101680 <ilock>

  if(ip->nlink < 1)
8010517e:	83 c4 10             	add    $0x10,%esp
80105181:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105186:	0f 8e e4 00 00 00    	jle    80105270 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010518c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105191:	74 65                	je     801051f8 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105193:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105196:	83 ec 04             	sub    $0x4,%esp
80105199:	6a 10                	push   $0x10
8010519b:	6a 00                	push   $0x0
8010519d:	57                   	push   %edi
8010519e:	e8 ed f6 ff ff       	call   80104890 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051a3:	6a 10                	push   $0x10
801051a5:	ff 75 c4             	pushl  -0x3c(%ebp)
801051a8:	57                   	push   %edi
801051a9:	56                   	push   %esi
801051aa:	e8 b1 c8 ff ff       	call   80101a60 <writei>
801051af:	83 c4 20             	add    $0x20,%esp
801051b2:	83 f8 10             	cmp    $0x10,%eax
801051b5:	0f 85 a8 00 00 00    	jne    80105263 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801051bb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051c0:	74 6e                	je     80105230 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801051c2:	83 ec 0c             	sub    $0xc,%esp
801051c5:	56                   	push   %esi
801051c6:	e8 45 c7 ff ff       	call   80101910 <iunlockput>

  ip->nlink--;
801051cb:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051d0:	89 1c 24             	mov    %ebx,(%esp)
801051d3:	e8 f8 c3 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801051d8:	89 1c 24             	mov    %ebx,(%esp)
801051db:	e8 30 c7 ff ff       	call   80101910 <iunlockput>

  end_op();
801051e0:	e8 bb dd ff ff       	call   80102fa0 <end_op>

  return 0;
801051e5:	83 c4 10             	add    $0x10,%esp
801051e8:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801051ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051ed:	5b                   	pop    %ebx
801051ee:	5e                   	pop    %esi
801051ef:	5f                   	pop    %edi
801051f0:	5d                   	pop    %ebp
801051f1:	c3                   	ret    
801051f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
801051f8:	83 ec 0c             	sub    $0xc,%esp
801051fb:	53                   	push   %ebx
801051fc:	e8 6f fe ff ff       	call   80105070 <isdirempty>
80105201:	83 c4 10             	add    $0x10,%esp
80105204:	85 c0                	test   %eax,%eax
80105206:	75 8b                	jne    80105193 <sys_unlink+0xb3>
    iunlockput(ip);
80105208:	83 ec 0c             	sub    $0xc,%esp
8010520b:	53                   	push   %ebx
8010520c:	e8 ff c6 ff ff       	call   80101910 <iunlockput>
    goto bad;
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105218:	83 ec 0c             	sub    $0xc,%esp
8010521b:	56                   	push   %esi
8010521c:	e8 ef c6 ff ff       	call   80101910 <iunlockput>
  end_op();
80105221:	e8 7a dd ff ff       	call   80102fa0 <end_op>
  return -1;
80105226:	83 c4 10             	add    $0x10,%esp
80105229:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010522e:	eb ba                	jmp    801051ea <sys_unlink+0x10a>
    dp->nlink--;
80105230:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105235:	83 ec 0c             	sub    $0xc,%esp
80105238:	56                   	push   %esi
80105239:	e8 92 c3 ff ff       	call   801015d0 <iupdate>
8010523e:	83 c4 10             	add    $0x10,%esp
80105241:	e9 7c ff ff ff       	jmp    801051c2 <sys_unlink+0xe2>
80105246:	8d 76 00             	lea    0x0(%esi),%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105255:	eb 93                	jmp    801051ea <sys_unlink+0x10a>
    end_op();
80105257:	e8 44 dd ff ff       	call   80102fa0 <end_op>
    return -1;
8010525c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105261:	eb 87                	jmp    801051ea <sys_unlink+0x10a>
    panic("unlink: writei");
80105263:	83 ec 0c             	sub    $0xc,%esp
80105266:	68 d1 74 10 80       	push   $0x801074d1
8010526b:	e8 20 b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105270:	83 ec 0c             	sub    $0xc,%esp
80105273:	68 bf 74 10 80       	push   $0x801074bf
80105278:	e8 13 b1 ff ff       	call   80100390 <panic>
8010527d:	8d 76 00             	lea    0x0(%esi),%esi

80105280 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
80105285:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105286:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105289:	83 ec 34             	sub    $0x34,%esp
8010528c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010528f:	8b 55 10             	mov    0x10(%ebp),%edx
80105292:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105295:	56                   	push   %esi
80105296:	ff 75 08             	pushl  0x8(%ebp)
{
80105299:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010529c:	89 55 d0             	mov    %edx,-0x30(%ebp)
8010529f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801052a2:	e8 59 cc ff ff       	call   80101f00 <nameiparent>
801052a7:	83 c4 10             	add    $0x10,%esp
801052aa:	85 c0                	test   %eax,%eax
801052ac:	0f 84 4e 01 00 00    	je     80105400 <create+0x180>
    return 0;
  ilock(dp);
801052b2:	83 ec 0c             	sub    $0xc,%esp
801052b5:	89 c3                	mov    %eax,%ebx
801052b7:	50                   	push   %eax
801052b8:	e8 c3 c3 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801052bd:	83 c4 0c             	add    $0xc,%esp
801052c0:	6a 00                	push   $0x0
801052c2:	56                   	push   %esi
801052c3:	53                   	push   %ebx
801052c4:	e8 e7 c8 ff ff       	call   80101bb0 <dirlookup>
801052c9:	83 c4 10             	add    $0x10,%esp
801052cc:	85 c0                	test   %eax,%eax
801052ce:	89 c7                	mov    %eax,%edi
801052d0:	74 3e                	je     80105310 <create+0x90>
    iunlockput(dp);
801052d2:	83 ec 0c             	sub    $0xc,%esp
801052d5:	53                   	push   %ebx
801052d6:	e8 35 c6 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
801052db:	89 3c 24             	mov    %edi,(%esp)
801052de:	e8 9d c3 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801052eb:	0f 85 9f 00 00 00    	jne    80105390 <create+0x110>
801052f1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801052f6:	0f 85 94 00 00 00    	jne    80105390 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801052fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052ff:	89 f8                	mov    %edi,%eax
80105301:	5b                   	pop    %ebx
80105302:	5e                   	pop    %esi
80105303:	5f                   	pop    %edi
80105304:	5d                   	pop    %ebp
80105305:	c3                   	ret    
80105306:	8d 76 00             	lea    0x0(%esi),%esi
80105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105310:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105314:	83 ec 08             	sub    $0x8,%esp
80105317:	50                   	push   %eax
80105318:	ff 33                	pushl  (%ebx)
8010531a:	e8 f1 c1 ff ff       	call   80101510 <ialloc>
8010531f:	83 c4 10             	add    $0x10,%esp
80105322:	85 c0                	test   %eax,%eax
80105324:	89 c7                	mov    %eax,%edi
80105326:	0f 84 e8 00 00 00    	je     80105414 <create+0x194>
  ilock(ip);
8010532c:	83 ec 0c             	sub    $0xc,%esp
8010532f:	50                   	push   %eax
80105330:	e8 4b c3 ff ff       	call   80101680 <ilock>
  ip->major = major;
80105335:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105339:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010533d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105341:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105345:	b8 01 00 00 00       	mov    $0x1,%eax
8010534a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010534e:	89 3c 24             	mov    %edi,(%esp)
80105351:	e8 7a c2 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105356:	83 c4 10             	add    $0x10,%esp
80105359:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010535e:	74 50                	je     801053b0 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105360:	83 ec 04             	sub    $0x4,%esp
80105363:	ff 77 04             	pushl  0x4(%edi)
80105366:	56                   	push   %esi
80105367:	53                   	push   %ebx
80105368:	e8 b3 ca ff ff       	call   80101e20 <dirlink>
8010536d:	83 c4 10             	add    $0x10,%esp
80105370:	85 c0                	test   %eax,%eax
80105372:	0f 88 8f 00 00 00    	js     80105407 <create+0x187>
  iunlockput(dp);
80105378:	83 ec 0c             	sub    $0xc,%esp
8010537b:	53                   	push   %ebx
8010537c:	e8 8f c5 ff ff       	call   80101910 <iunlockput>
  return ip;
80105381:	83 c4 10             	add    $0x10,%esp
}
80105384:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105387:	89 f8                	mov    %edi,%eax
80105389:	5b                   	pop    %ebx
8010538a:	5e                   	pop    %esi
8010538b:	5f                   	pop    %edi
8010538c:	5d                   	pop    %ebp
8010538d:	c3                   	ret    
8010538e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	57                   	push   %edi
    return 0;
80105394:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105396:	e8 75 c5 ff ff       	call   80101910 <iunlockput>
    return 0;
8010539b:	83 c4 10             	add    $0x10,%esp
}
8010539e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053a1:	89 f8                	mov    %edi,%eax
801053a3:	5b                   	pop    %ebx
801053a4:	5e                   	pop    %esi
801053a5:	5f                   	pop    %edi
801053a6:	5d                   	pop    %ebp
801053a7:	c3                   	ret    
801053a8:	90                   	nop
801053a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801053b0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801053b5:	83 ec 0c             	sub    $0xc,%esp
801053b8:	53                   	push   %ebx
801053b9:	e8 12 c2 ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801053be:	83 c4 0c             	add    $0xc,%esp
801053c1:	ff 77 04             	pushl  0x4(%edi)
801053c4:	68 bd 74 10 80       	push   $0x801074bd
801053c9:	57                   	push   %edi
801053ca:	e8 51 ca ff ff       	call   80101e20 <dirlink>
801053cf:	83 c4 10             	add    $0x10,%esp
801053d2:	85 c0                	test   %eax,%eax
801053d4:	78 1c                	js     801053f2 <create+0x172>
801053d6:	83 ec 04             	sub    $0x4,%esp
801053d9:	ff 73 04             	pushl  0x4(%ebx)
801053dc:	68 bc 74 10 80       	push   $0x801074bc
801053e1:	57                   	push   %edi
801053e2:	e8 39 ca ff ff       	call   80101e20 <dirlink>
801053e7:	83 c4 10             	add    $0x10,%esp
801053ea:	85 c0                	test   %eax,%eax
801053ec:	0f 89 6e ff ff ff    	jns    80105360 <create+0xe0>
      panic("create dots");
801053f2:	83 ec 0c             	sub    $0xc,%esp
801053f5:	68 d9 7a 10 80       	push   $0x80107ad9
801053fa:	e8 91 af ff ff       	call   80100390 <panic>
801053ff:	90                   	nop
    return 0;
80105400:	31 ff                	xor    %edi,%edi
80105402:	e9 f5 fe ff ff       	jmp    801052fc <create+0x7c>
    panic("create: dirlink");
80105407:	83 ec 0c             	sub    $0xc,%esp
8010540a:	68 e5 7a 10 80       	push   $0x80107ae5
8010540f:	e8 7c af ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105414:	83 ec 0c             	sub    $0xc,%esp
80105417:	68 ca 7a 10 80       	push   $0x80107aca
8010541c:	e8 6f af ff ff       	call   80100390 <panic>
80105421:	eb 0d                	jmp    80105430 <sys_open>
80105423:	90                   	nop
80105424:	90                   	nop
80105425:	90                   	nop
80105426:	90                   	nop
80105427:	90                   	nop
80105428:	90                   	nop
80105429:	90                   	nop
8010542a:	90                   	nop
8010542b:	90                   	nop
8010542c:	90                   	nop
8010542d:	90                   	nop
8010542e:	90                   	nop
8010542f:	90                   	nop

80105430 <sys_open>:

int
sys_open(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	57                   	push   %edi
80105434:	56                   	push   %esi
80105435:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105436:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105439:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010543c:	50                   	push   %eax
8010543d:	6a 00                	push   $0x0
8010543f:	e8 fc f7 ff ff       	call   80104c40 <argstr>
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	85 c0                	test   %eax,%eax
80105449:	0f 88 1d 01 00 00    	js     8010556c <sys_open+0x13c>
8010544f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105452:	83 ec 08             	sub    $0x8,%esp
80105455:	50                   	push   %eax
80105456:	6a 01                	push   $0x1
80105458:	e8 33 f7 ff ff       	call   80104b90 <argint>
8010545d:	83 c4 10             	add    $0x10,%esp
80105460:	85 c0                	test   %eax,%eax
80105462:	0f 88 04 01 00 00    	js     8010556c <sys_open+0x13c>
    return -1;

  begin_op();
80105468:	e8 c3 da ff ff       	call   80102f30 <begin_op>

  if(omode & O_CREATE){
8010546d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105471:	0f 85 a9 00 00 00    	jne    80105520 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105477:	83 ec 0c             	sub    $0xc,%esp
8010547a:	ff 75 e0             	pushl  -0x20(%ebp)
8010547d:	e8 5e ca ff ff       	call   80101ee0 <namei>
80105482:	83 c4 10             	add    $0x10,%esp
80105485:	85 c0                	test   %eax,%eax
80105487:	89 c6                	mov    %eax,%esi
80105489:	0f 84 ac 00 00 00    	je     8010553b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
8010548f:	83 ec 0c             	sub    $0xc,%esp
80105492:	50                   	push   %eax
80105493:	e8 e8 c1 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105498:	83 c4 10             	add    $0x10,%esp
8010549b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054a0:	0f 84 aa 00 00 00    	je     80105550 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054a6:	e8 d5 b8 ff ff       	call   80100d80 <filealloc>
801054ab:	85 c0                	test   %eax,%eax
801054ad:	89 c7                	mov    %eax,%edi
801054af:	0f 84 a6 00 00 00    	je     8010555b <sys_open+0x12b>
  struct proc *curproc = myproc();
801054b5:	e8 46 e7 ff ff       	call   80103c00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054ba:	31 db                	xor    %ebx,%ebx
801054bc:	eb 0e                	jmp    801054cc <sys_open+0x9c>
801054be:	66 90                	xchg   %ax,%ax
801054c0:	83 c3 01             	add    $0x1,%ebx
801054c3:	83 fb 10             	cmp    $0x10,%ebx
801054c6:	0f 84 ac 00 00 00    	je     80105578 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801054cc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054d0:	85 d2                	test   %edx,%edx
801054d2:	75 ec                	jne    801054c0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054d4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054d7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801054db:	56                   	push   %esi
801054dc:	e8 7f c2 ff ff       	call   80101760 <iunlock>
  end_op();
801054e1:	e8 ba da ff ff       	call   80102fa0 <end_op>

  f->type = FD_INODE;
801054e6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054ef:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801054f2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801054f5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054fc:	89 d0                	mov    %edx,%eax
801054fe:	f7 d0                	not    %eax
80105500:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105503:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105506:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105509:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010550d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105510:	89 d8                	mov    %ebx,%eax
80105512:	5b                   	pop    %ebx
80105513:	5e                   	pop    %esi
80105514:	5f                   	pop    %edi
80105515:	5d                   	pop    %ebp
80105516:	c3                   	ret    
80105517:	89 f6                	mov    %esi,%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105520:	6a 00                	push   $0x0
80105522:	6a 00                	push   $0x0
80105524:	6a 02                	push   $0x2
80105526:	ff 75 e0             	pushl  -0x20(%ebp)
80105529:	e8 52 fd ff ff       	call   80105280 <create>
    if(ip == 0){
8010552e:	83 c4 10             	add    $0x10,%esp
80105531:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105533:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105535:	0f 85 6b ff ff ff    	jne    801054a6 <sys_open+0x76>
      end_op();
8010553b:	e8 60 da ff ff       	call   80102fa0 <end_op>
      return -1;
80105540:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105545:	eb c6                	jmp    8010550d <sys_open+0xdd>
80105547:	89 f6                	mov    %esi,%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105550:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105553:	85 c9                	test   %ecx,%ecx
80105555:	0f 84 4b ff ff ff    	je     801054a6 <sys_open+0x76>
    iunlockput(ip);
8010555b:	83 ec 0c             	sub    $0xc,%esp
8010555e:	56                   	push   %esi
8010555f:	e8 ac c3 ff ff       	call   80101910 <iunlockput>
    end_op();
80105564:	e8 37 da ff ff       	call   80102fa0 <end_op>
    return -1;
80105569:	83 c4 10             	add    $0x10,%esp
8010556c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105571:	eb 9a                	jmp    8010550d <sys_open+0xdd>
80105573:	90                   	nop
80105574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105578:	83 ec 0c             	sub    $0xc,%esp
8010557b:	57                   	push   %edi
8010557c:	e8 bf b8 ff ff       	call   80100e40 <fileclose>
80105581:	83 c4 10             	add    $0x10,%esp
80105584:	eb d5                	jmp    8010555b <sys_open+0x12b>
80105586:	8d 76 00             	lea    0x0(%esi),%esi
80105589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105590 <sys_mkdir>:

int
sys_mkdir(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105596:	e8 95 d9 ff ff       	call   80102f30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010559b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010559e:	83 ec 08             	sub    $0x8,%esp
801055a1:	50                   	push   %eax
801055a2:	6a 00                	push   $0x0
801055a4:	e8 97 f6 ff ff       	call   80104c40 <argstr>
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	85 c0                	test   %eax,%eax
801055ae:	78 30                	js     801055e0 <sys_mkdir+0x50>
801055b0:	6a 00                	push   $0x0
801055b2:	6a 00                	push   $0x0
801055b4:	6a 01                	push   $0x1
801055b6:	ff 75 f4             	pushl  -0xc(%ebp)
801055b9:	e8 c2 fc ff ff       	call   80105280 <create>
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	85 c0                	test   %eax,%eax
801055c3:	74 1b                	je     801055e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055c5:	83 ec 0c             	sub    $0xc,%esp
801055c8:	50                   	push   %eax
801055c9:	e8 42 c3 ff ff       	call   80101910 <iunlockput>
  end_op();
801055ce:	e8 cd d9 ff ff       	call   80102fa0 <end_op>
  return 0;
801055d3:	83 c4 10             	add    $0x10,%esp
801055d6:	31 c0                	xor    %eax,%eax
}
801055d8:	c9                   	leave  
801055d9:	c3                   	ret    
801055da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801055e0:	e8 bb d9 ff ff       	call   80102fa0 <end_op>
    return -1;
801055e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ea:	c9                   	leave  
801055eb:	c3                   	ret    
801055ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055f0 <sys_mknod>:

int
sys_mknod(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801055f6:	e8 35 d9 ff ff       	call   80102f30 <begin_op>
  if((argstr(0, &path)) < 0 ||
801055fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055fe:	83 ec 08             	sub    $0x8,%esp
80105601:	50                   	push   %eax
80105602:	6a 00                	push   $0x0
80105604:	e8 37 f6 ff ff       	call   80104c40 <argstr>
80105609:	83 c4 10             	add    $0x10,%esp
8010560c:	85 c0                	test   %eax,%eax
8010560e:	78 60                	js     80105670 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105610:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105613:	83 ec 08             	sub    $0x8,%esp
80105616:	50                   	push   %eax
80105617:	6a 01                	push   $0x1
80105619:	e8 72 f5 ff ff       	call   80104b90 <argint>
  if((argstr(0, &path)) < 0 ||
8010561e:	83 c4 10             	add    $0x10,%esp
80105621:	85 c0                	test   %eax,%eax
80105623:	78 4b                	js     80105670 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105625:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105628:	83 ec 08             	sub    $0x8,%esp
8010562b:	50                   	push   %eax
8010562c:	6a 02                	push   $0x2
8010562e:	e8 5d f5 ff ff       	call   80104b90 <argint>
     argint(1, &major) < 0 ||
80105633:	83 c4 10             	add    $0x10,%esp
80105636:	85 c0                	test   %eax,%eax
80105638:	78 36                	js     80105670 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010563a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010563e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
8010563f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105643:	50                   	push   %eax
80105644:	6a 03                	push   $0x3
80105646:	ff 75 ec             	pushl  -0x14(%ebp)
80105649:	e8 32 fc ff ff       	call   80105280 <create>
8010564e:	83 c4 10             	add    $0x10,%esp
80105651:	85 c0                	test   %eax,%eax
80105653:	74 1b                	je     80105670 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105655:	83 ec 0c             	sub    $0xc,%esp
80105658:	50                   	push   %eax
80105659:	e8 b2 c2 ff ff       	call   80101910 <iunlockput>
  end_op();
8010565e:	e8 3d d9 ff ff       	call   80102fa0 <end_op>
  return 0;
80105663:	83 c4 10             	add    $0x10,%esp
80105666:	31 c0                	xor    %eax,%eax
}
80105668:	c9                   	leave  
80105669:	c3                   	ret    
8010566a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105670:	e8 2b d9 ff ff       	call   80102fa0 <end_op>
    return -1;
80105675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010567a:	c9                   	leave  
8010567b:	c3                   	ret    
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105680 <sys_chdir>:

int
sys_chdir(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	56                   	push   %esi
80105684:	53                   	push   %ebx
80105685:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105688:	e8 73 e5 ff ff       	call   80103c00 <myproc>
8010568d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010568f:	e8 9c d8 ff ff       	call   80102f30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105694:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105697:	83 ec 08             	sub    $0x8,%esp
8010569a:	50                   	push   %eax
8010569b:	6a 00                	push   $0x0
8010569d:	e8 9e f5 ff ff       	call   80104c40 <argstr>
801056a2:	83 c4 10             	add    $0x10,%esp
801056a5:	85 c0                	test   %eax,%eax
801056a7:	78 77                	js     80105720 <sys_chdir+0xa0>
801056a9:	83 ec 0c             	sub    $0xc,%esp
801056ac:	ff 75 f4             	pushl  -0xc(%ebp)
801056af:	e8 2c c8 ff ff       	call   80101ee0 <namei>
801056b4:	83 c4 10             	add    $0x10,%esp
801056b7:	85 c0                	test   %eax,%eax
801056b9:	89 c3                	mov    %eax,%ebx
801056bb:	74 63                	je     80105720 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801056bd:	83 ec 0c             	sub    $0xc,%esp
801056c0:	50                   	push   %eax
801056c1:	e8 ba bf ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
801056c6:	83 c4 10             	add    $0x10,%esp
801056c9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056ce:	75 30                	jne    80105700 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	53                   	push   %ebx
801056d4:	e8 87 c0 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
801056d9:	58                   	pop    %eax
801056da:	ff 76 68             	pushl  0x68(%esi)
801056dd:	e8 ce c0 ff ff       	call   801017b0 <iput>
  end_op();
801056e2:	e8 b9 d8 ff ff       	call   80102fa0 <end_op>
  curproc->cwd = ip;
801056e7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801056ea:	83 c4 10             	add    $0x10,%esp
801056ed:	31 c0                	xor    %eax,%eax
}
801056ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056f2:	5b                   	pop    %ebx
801056f3:	5e                   	pop    %esi
801056f4:	5d                   	pop    %ebp
801056f5:	c3                   	ret    
801056f6:	8d 76 00             	lea    0x0(%esi),%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	53                   	push   %ebx
80105704:	e8 07 c2 ff ff       	call   80101910 <iunlockput>
    end_op();
80105709:	e8 92 d8 ff ff       	call   80102fa0 <end_op>
    return -1;
8010570e:	83 c4 10             	add    $0x10,%esp
80105711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105716:	eb d7                	jmp    801056ef <sys_chdir+0x6f>
80105718:	90                   	nop
80105719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105720:	e8 7b d8 ff ff       	call   80102fa0 <end_op>
    return -1;
80105725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010572a:	eb c3                	jmp    801056ef <sys_chdir+0x6f>
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_exec>:

int
sys_exec(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	57                   	push   %edi
80105734:	56                   	push   %esi
80105735:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105736:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010573c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105742:	50                   	push   %eax
80105743:	6a 00                	push   $0x0
80105745:	e8 f6 f4 ff ff       	call   80104c40 <argstr>
8010574a:	83 c4 10             	add    $0x10,%esp
8010574d:	85 c0                	test   %eax,%eax
8010574f:	0f 88 87 00 00 00    	js     801057dc <sys_exec+0xac>
80105755:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010575b:	83 ec 08             	sub    $0x8,%esp
8010575e:	50                   	push   %eax
8010575f:	6a 01                	push   $0x1
80105761:	e8 2a f4 ff ff       	call   80104b90 <argint>
80105766:	83 c4 10             	add    $0x10,%esp
80105769:	85 c0                	test   %eax,%eax
8010576b:	78 6f                	js     801057dc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010576d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105773:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105776:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105778:	68 80 00 00 00       	push   $0x80
8010577d:	6a 00                	push   $0x0
8010577f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105785:	50                   	push   %eax
80105786:	e8 05 f1 ff ff       	call   80104890 <memset>
8010578b:	83 c4 10             	add    $0x10,%esp
8010578e:	eb 2c                	jmp    801057bc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105790:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105796:	85 c0                	test   %eax,%eax
80105798:	74 56                	je     801057f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010579a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801057a0:	83 ec 08             	sub    $0x8,%esp
801057a3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801057a6:	52                   	push   %edx
801057a7:	50                   	push   %eax
801057a8:	e8 73 f3 ff ff       	call   80104b20 <fetchstr>
801057ad:	83 c4 10             	add    $0x10,%esp
801057b0:	85 c0                	test   %eax,%eax
801057b2:	78 28                	js     801057dc <sys_exec+0xac>
  for(i=0;; i++){
801057b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057b7:	83 fb 20             	cmp    $0x20,%ebx
801057ba:	74 20                	je     801057dc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057bc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057c2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801057c9:	83 ec 08             	sub    $0x8,%esp
801057cc:	57                   	push   %edi
801057cd:	01 f0                	add    %esi,%eax
801057cf:	50                   	push   %eax
801057d0:	e8 0b f3 ff ff       	call   80104ae0 <fetchint>
801057d5:	83 c4 10             	add    $0x10,%esp
801057d8:	85 c0                	test   %eax,%eax
801057da:	79 b4                	jns    80105790 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057e4:	5b                   	pop    %ebx
801057e5:	5e                   	pop    %esi
801057e6:	5f                   	pop    %edi
801057e7:	5d                   	pop    %ebp
801057e8:	c3                   	ret    
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801057f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801057f6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801057f9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105800:	00 00 00 00 
  return exec(path, argv);
80105804:	50                   	push   %eax
80105805:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010580b:	e8 00 b2 ff ff       	call   80100a10 <exec>
80105810:	83 c4 10             	add    $0x10,%esp
}
80105813:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105816:	5b                   	pop    %ebx
80105817:	5e                   	pop    %esi
80105818:	5f                   	pop    %edi
80105819:	5d                   	pop    %ebp
8010581a:	c3                   	ret    
8010581b:	90                   	nop
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105820 <sys_pipe>:

int
sys_pipe(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	57                   	push   %edi
80105824:	56                   	push   %esi
80105825:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105826:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105829:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010582c:	6a 08                	push   $0x8
8010582e:	50                   	push   %eax
8010582f:	6a 00                	push   $0x0
80105831:	e8 aa f3 ff ff       	call   80104be0 <argptr>
80105836:	83 c4 10             	add    $0x10,%esp
80105839:	85 c0                	test   %eax,%eax
8010583b:	0f 88 ae 00 00 00    	js     801058ef <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105841:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105844:	83 ec 08             	sub    $0x8,%esp
80105847:	50                   	push   %eax
80105848:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010584b:	50                   	push   %eax
8010584c:	e8 7f dd ff ff       	call   801035d0 <pipealloc>
80105851:	83 c4 10             	add    $0x10,%esp
80105854:	85 c0                	test   %eax,%eax
80105856:	0f 88 93 00 00 00    	js     801058ef <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010585c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010585f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105861:	e8 9a e3 ff ff       	call   80103c00 <myproc>
80105866:	eb 10                	jmp    80105878 <sys_pipe+0x58>
80105868:	90                   	nop
80105869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105870:	83 c3 01             	add    $0x1,%ebx
80105873:	83 fb 10             	cmp    $0x10,%ebx
80105876:	74 60                	je     801058d8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105878:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010587c:	85 f6                	test   %esi,%esi
8010587e:	75 f0                	jne    80105870 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105880:	8d 73 08             	lea    0x8(%ebx),%esi
80105883:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105887:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010588a:	e8 71 e3 ff ff       	call   80103c00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010588f:	31 d2                	xor    %edx,%edx
80105891:	eb 0d                	jmp    801058a0 <sys_pipe+0x80>
80105893:	90                   	nop
80105894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105898:	83 c2 01             	add    $0x1,%edx
8010589b:	83 fa 10             	cmp    $0x10,%edx
8010589e:	74 28                	je     801058c8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801058a0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801058a4:	85 c9                	test   %ecx,%ecx
801058a6:	75 f0                	jne    80105898 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801058a8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801058ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058af:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058b4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058b7:	31 c0                	xor    %eax,%eax
}
801058b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058bc:	5b                   	pop    %ebx
801058bd:	5e                   	pop    %esi
801058be:	5f                   	pop    %edi
801058bf:	5d                   	pop    %ebp
801058c0:	c3                   	ret    
801058c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801058c8:	e8 33 e3 ff ff       	call   80103c00 <myproc>
801058cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801058d4:	00 
801058d5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801058d8:	83 ec 0c             	sub    $0xc,%esp
801058db:	ff 75 e0             	pushl  -0x20(%ebp)
801058de:	e8 5d b5 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
801058e3:	58                   	pop    %eax
801058e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801058e7:	e8 54 b5 ff ff       	call   80100e40 <fileclose>
    return -1;
801058ec:	83 c4 10             	add    $0x10,%esp
801058ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f4:	eb c3                	jmp    801058b9 <sys_pipe+0x99>
801058f6:	66 90                	xchg   %ax,%ax
801058f8:	66 90                	xchg   %ax,%ax
801058fa:	66 90                	xchg   %ax,%ax
801058fc:	66 90                	xchg   %ax,%ax
801058fe:	66 90                	xchg   %ax,%ax

80105900 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105903:	5d                   	pop    %ebp
  return fork();
80105904:	e9 97 e4 ff ff       	jmp    80103da0 <fork>
80105909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_exit>:

int
sys_exit(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	83 ec 08             	sub    $0x8,%esp
  exit();
80105916:	e8 05 e7 ff ff       	call   80104020 <exit>
  return 0;  // not reached
}
8010591b:	31 c0                	xor    %eax,%eax
8010591d:	c9                   	leave  
8010591e:	c3                   	ret    
8010591f:	90                   	nop

80105920 <sys_wait>:

int
sys_wait(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105923:	5d                   	pop    %ebp
  return wait();
80105924:	e9 37 e9 ff ff       	jmp    80104260 <wait>
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105930 <sys_kill>:

int
sys_kill(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105936:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105939:	50                   	push   %eax
8010593a:	6a 00                	push   $0x0
8010593c:	e8 4f f2 ff ff       	call   80104b90 <argint>
80105941:	83 c4 10             	add    $0x10,%esp
80105944:	85 c0                	test   %eax,%eax
80105946:	78 18                	js     80105960 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	ff 75 f4             	pushl  -0xc(%ebp)
8010594e:	e8 6d ea ff ff       	call   801043c0 <kill>
80105953:	83 c4 10             	add    $0x10,%esp
}
80105956:	c9                   	leave  
80105957:	c3                   	ret    
80105958:	90                   	nop
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105970 <sys_getpid>:

int
sys_getpid(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105976:	e8 85 e2 ff ff       	call   80103c00 <myproc>
8010597b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010597e:	c9                   	leave  
8010597f:	c3                   	ret    

80105980 <sys_sbrk>:

int
sys_sbrk(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105984:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105987:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010598a:	50                   	push   %eax
8010598b:	6a 00                	push   $0x0
8010598d:	e8 fe f1 ff ff       	call   80104b90 <argint>
80105992:	83 c4 10             	add    $0x10,%esp
80105995:	85 c0                	test   %eax,%eax
80105997:	78 27                	js     801059c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105999:	e8 62 e2 ff ff       	call   80103c00 <myproc>
  if(growproc(n) < 0)
8010599e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059a1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059a3:	ff 75 f4             	pushl  -0xc(%ebp)
801059a6:	e8 75 e3 ff ff       	call   80103d20 <growproc>
801059ab:	83 c4 10             	add    $0x10,%esp
801059ae:	85 c0                	test   %eax,%eax
801059b0:	78 0e                	js     801059c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059b2:	89 d8                	mov    %ebx,%eax
801059b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059b7:	c9                   	leave  
801059b8:	c3                   	ret    
801059b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059c5:	eb eb                	jmp    801059b2 <sys_sbrk+0x32>
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059d0 <sys_sleep>:

int
sys_sleep(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801059d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059da:	50                   	push   %eax
801059db:	6a 00                	push   $0x0
801059dd:	e8 ae f1 ff ff       	call   80104b90 <argint>
801059e2:	83 c4 10             	add    $0x10,%esp
801059e5:	85 c0                	test   %eax,%eax
801059e7:	0f 88 8a 00 00 00    	js     80105a77 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801059ed:	83 ec 0c             	sub    $0xc,%esp
801059f0:	68 60 e9 11 80       	push   $0x8011e960
801059f5:	e8 86 ed ff ff       	call   80104780 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801059fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059fd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105a00:	8b 1d a0 f1 11 80    	mov    0x8011f1a0,%ebx
  while(ticks - ticks0 < n){
80105a06:	85 d2                	test   %edx,%edx
80105a08:	75 27                	jne    80105a31 <sys_sleep+0x61>
80105a0a:	eb 54                	jmp    80105a60 <sys_sleep+0x90>
80105a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a10:	83 ec 08             	sub    $0x8,%esp
80105a13:	68 60 e9 11 80       	push   $0x8011e960
80105a18:	68 a0 f1 11 80       	push   $0x8011f1a0
80105a1d:	e8 7e e7 ff ff       	call   801041a0 <sleep>
  while(ticks - ticks0 < n){
80105a22:	a1 a0 f1 11 80       	mov    0x8011f1a0,%eax
80105a27:	83 c4 10             	add    $0x10,%esp
80105a2a:	29 d8                	sub    %ebx,%eax
80105a2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a2f:	73 2f                	jae    80105a60 <sys_sleep+0x90>
    if(myproc()->killed){
80105a31:	e8 ca e1 ff ff       	call   80103c00 <myproc>
80105a36:	8b 40 24             	mov    0x24(%eax),%eax
80105a39:	85 c0                	test   %eax,%eax
80105a3b:	74 d3                	je     80105a10 <sys_sleep+0x40>
      release(&tickslock);
80105a3d:	83 ec 0c             	sub    $0xc,%esp
80105a40:	68 60 e9 11 80       	push   $0x8011e960
80105a45:	e8 f6 ed ff ff       	call   80104840 <release>
      return -1;
80105a4a:	83 c4 10             	add    $0x10,%esp
80105a4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105a52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a55:	c9                   	leave  
80105a56:	c3                   	ret    
80105a57:	89 f6                	mov    %esi,%esi
80105a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105a60:	83 ec 0c             	sub    $0xc,%esp
80105a63:	68 60 e9 11 80       	push   $0x8011e960
80105a68:	e8 d3 ed ff ff       	call   80104840 <release>
  return 0;
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	31 c0                	xor    %eax,%eax
}
80105a72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a75:	c9                   	leave  
80105a76:	c3                   	ret    
    return -1;
80105a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7c:	eb f4                	jmp    80105a72 <sys_sleep+0xa2>
80105a7e:	66 90                	xchg   %ax,%ax

80105a80 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	53                   	push   %ebx
80105a84:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a87:	68 60 e9 11 80       	push   $0x8011e960
80105a8c:	e8 ef ec ff ff       	call   80104780 <acquire>
  xticks = ticks;
80105a91:	8b 1d a0 f1 11 80    	mov    0x8011f1a0,%ebx
  release(&tickslock);
80105a97:	c7 04 24 60 e9 11 80 	movl   $0x8011e960,(%esp)
80105a9e:	e8 9d ed ff ff       	call   80104840 <release>
  return xticks;
}
80105aa3:	89 d8                	mov    %ebx,%eax
80105aa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105aa8:	c9                   	leave  
80105aa9:	c3                   	ret    

80105aaa <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105aaa:	1e                   	push   %ds
  pushl %es
80105aab:	06                   	push   %es
  pushl %fs
80105aac:	0f a0                	push   %fs
  pushl %gs
80105aae:	0f a8                	push   %gs
  pushal
80105ab0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ab1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ab5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ab7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ab9:	54                   	push   %esp
  call trap
80105aba:	e8 c1 00 00 00       	call   80105b80 <trap>
  addl $4, %esp
80105abf:	83 c4 04             	add    $0x4,%esp

80105ac2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ac2:	61                   	popa   
  popl %gs
80105ac3:	0f a9                	pop    %gs
  popl %fs
80105ac5:	0f a1                	pop    %fs
  popl %es
80105ac7:	07                   	pop    %es
  popl %ds
80105ac8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ac9:	83 c4 08             	add    $0x8,%esp
  iret
80105acc:	cf                   	iret   
80105acd:	66 90                	xchg   %ax,%ax
80105acf:	90                   	nop

80105ad0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ad0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ad1:	31 c0                	xor    %eax,%eax
{
80105ad3:	89 e5                	mov    %esp,%ebp
80105ad5:	83 ec 08             	sub    $0x8,%esp
80105ad8:	90                   	nop
80105ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ae0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105ae7:	c7 04 c5 a2 e9 11 80 	movl   $0x8e000008,-0x7fee165e(,%eax,8)
80105aee:	08 00 00 8e 
80105af2:	66 89 14 c5 a0 e9 11 	mov    %dx,-0x7fee1660(,%eax,8)
80105af9:	80 
80105afa:	c1 ea 10             	shr    $0x10,%edx
80105afd:	66 89 14 c5 a6 e9 11 	mov    %dx,-0x7fee165a(,%eax,8)
80105b04:	80 
  for(i = 0; i < 256; i++)
80105b05:	83 c0 01             	add    $0x1,%eax
80105b08:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b0d:	75 d1                	jne    80105ae0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b0f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105b14:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b17:	c7 05 a2 eb 11 80 08 	movl   $0xef000008,0x8011eba2
80105b1e:	00 00 ef 
  initlock(&tickslock, "time");
80105b21:	68 f5 7a 10 80       	push   $0x80107af5
80105b26:	68 60 e9 11 80       	push   $0x8011e960
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b2b:	66 a3 a0 eb 11 80    	mov    %ax,0x8011eba0
80105b31:	c1 e8 10             	shr    $0x10,%eax
80105b34:	66 a3 a6 eb 11 80    	mov    %ax,0x8011eba6
  initlock(&tickslock, "time");
80105b3a:	e8 01 eb ff ff       	call   80104640 <initlock>
}
80105b3f:	83 c4 10             	add    $0x10,%esp
80105b42:	c9                   	leave  
80105b43:	c3                   	ret    
80105b44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105b50 <idtinit>:

void
idtinit(void)
{
80105b50:	55                   	push   %ebp
  pd[0] = size-1;
80105b51:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b56:	89 e5                	mov    %esp,%ebp
80105b58:	83 ec 10             	sub    $0x10,%esp
80105b5b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b5f:	b8 a0 e9 11 80       	mov    $0x8011e9a0,%eax
80105b64:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b68:	c1 e8 10             	shr    $0x10,%eax
80105b6b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b6f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b72:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b75:	c9                   	leave  
80105b76:	c3                   	ret    
80105b77:	89 f6                	mov    %esi,%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b80 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	57                   	push   %edi
80105b84:	56                   	push   %esi
80105b85:	53                   	push   %ebx
80105b86:	83 ec 1c             	sub    $0x1c,%esp
80105b89:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105b8c:	8b 47 30             	mov    0x30(%edi),%eax
80105b8f:	83 f8 40             	cmp    $0x40,%eax
80105b92:	0f 84 f0 00 00 00    	je     80105c88 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b98:	83 e8 20             	sub    $0x20,%eax
80105b9b:	83 f8 1f             	cmp    $0x1f,%eax
80105b9e:	77 10                	ja     80105bb0 <trap+0x30>
80105ba0:	ff 24 85 9c 7b 10 80 	jmp    *-0x7fef8464(,%eax,4)
80105ba7:	89 f6                	mov    %esi,%esi
80105ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105bb0:	e8 4b e0 ff ff       	call   80103c00 <myproc>
80105bb5:	85 c0                	test   %eax,%eax
80105bb7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105bba:	0f 84 14 02 00 00    	je     80105dd4 <trap+0x254>
80105bc0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105bc4:	0f 84 0a 02 00 00    	je     80105dd4 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105bca:	0f 20 d1             	mov    %cr2,%ecx
80105bcd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bd0:	e8 0b e0 ff ff       	call   80103be0 <cpuid>
80105bd5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105bd8:	8b 47 34             	mov    0x34(%edi),%eax
80105bdb:	8b 77 30             	mov    0x30(%edi),%esi
80105bde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105be1:	e8 1a e0 ff ff       	call   80103c00 <myproc>
80105be6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105be9:	e8 12 e0 ff ff       	call   80103c00 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105bf1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105bf4:	51                   	push   %ecx
80105bf5:	53                   	push   %ebx
80105bf6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105bf7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bfa:	ff 75 e4             	pushl  -0x1c(%ebp)
80105bfd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105bfe:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c01:	52                   	push   %edx
80105c02:	ff 70 10             	pushl  0x10(%eax)
80105c05:	68 58 7b 10 80       	push   $0x80107b58
80105c0a:	e8 51 aa ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105c0f:	83 c4 20             	add    $0x20,%esp
80105c12:	e8 e9 df ff ff       	call   80103c00 <myproc>
80105c17:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c1e:	e8 dd df ff ff       	call   80103c00 <myproc>
80105c23:	85 c0                	test   %eax,%eax
80105c25:	74 1d                	je     80105c44 <trap+0xc4>
80105c27:	e8 d4 df ff ff       	call   80103c00 <myproc>
80105c2c:	8b 50 24             	mov    0x24(%eax),%edx
80105c2f:	85 d2                	test   %edx,%edx
80105c31:	74 11                	je     80105c44 <trap+0xc4>
80105c33:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105c37:	83 e0 03             	and    $0x3,%eax
80105c3a:	66 83 f8 03          	cmp    $0x3,%ax
80105c3e:	0f 84 4c 01 00 00    	je     80105d90 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c44:	e8 b7 df ff ff       	call   80103c00 <myproc>
80105c49:	85 c0                	test   %eax,%eax
80105c4b:	74 0b                	je     80105c58 <trap+0xd8>
80105c4d:	e8 ae df ff ff       	call   80103c00 <myproc>
80105c52:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c56:	74 68                	je     80105cc0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c58:	e8 a3 df ff ff       	call   80103c00 <myproc>
80105c5d:	85 c0                	test   %eax,%eax
80105c5f:	74 19                	je     80105c7a <trap+0xfa>
80105c61:	e8 9a df ff ff       	call   80103c00 <myproc>
80105c66:	8b 40 24             	mov    0x24(%eax),%eax
80105c69:	85 c0                	test   %eax,%eax
80105c6b:	74 0d                	je     80105c7a <trap+0xfa>
80105c6d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105c71:	83 e0 03             	and    $0x3,%eax
80105c74:	66 83 f8 03          	cmp    $0x3,%ax
80105c78:	74 37                	je     80105cb1 <trap+0x131>
    exit();
}
80105c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c7d:	5b                   	pop    %ebx
80105c7e:	5e                   	pop    %esi
80105c7f:	5f                   	pop    %edi
80105c80:	5d                   	pop    %ebp
80105c81:	c3                   	ret    
80105c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105c88:	e8 73 df ff ff       	call   80103c00 <myproc>
80105c8d:	8b 58 24             	mov    0x24(%eax),%ebx
80105c90:	85 db                	test   %ebx,%ebx
80105c92:	0f 85 e8 00 00 00    	jne    80105d80 <trap+0x200>
    myproc()->tf = tf;
80105c98:	e8 63 df ff ff       	call   80103c00 <myproc>
80105c9d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105ca0:	e8 db ef ff ff       	call   80104c80 <syscall>
    if(myproc()->killed)
80105ca5:	e8 56 df ff ff       	call   80103c00 <myproc>
80105caa:	8b 48 24             	mov    0x24(%eax),%ecx
80105cad:	85 c9                	test   %ecx,%ecx
80105caf:	74 c9                	je     80105c7a <trap+0xfa>
}
80105cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cb4:	5b                   	pop    %ebx
80105cb5:	5e                   	pop    %esi
80105cb6:	5f                   	pop    %edi
80105cb7:	5d                   	pop    %ebp
      exit();
80105cb8:	e9 63 e3 ff ff       	jmp    80104020 <exit>
80105cbd:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105cc0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105cc4:	75 92                	jne    80105c58 <trap+0xd8>
    yield();
80105cc6:	e8 85 e4 ff ff       	call   80104150 <yield>
80105ccb:	eb 8b                	jmp    80105c58 <trap+0xd8>
80105ccd:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105cd0:	e8 0b df ff ff       	call   80103be0 <cpuid>
80105cd5:	85 c0                	test   %eax,%eax
80105cd7:	0f 84 c3 00 00 00    	je     80105da0 <trap+0x220>
    lapiceoi();
80105cdd:	e8 fe cd ff ff       	call   80102ae0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ce2:	e8 19 df ff ff       	call   80103c00 <myproc>
80105ce7:	85 c0                	test   %eax,%eax
80105ce9:	0f 85 38 ff ff ff    	jne    80105c27 <trap+0xa7>
80105cef:	e9 50 ff ff ff       	jmp    80105c44 <trap+0xc4>
80105cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105cf8:	e8 a3 cc ff ff       	call   801029a0 <kbdintr>
    lapiceoi();
80105cfd:	e8 de cd ff ff       	call   80102ae0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d02:	e8 f9 de ff ff       	call   80103c00 <myproc>
80105d07:	85 c0                	test   %eax,%eax
80105d09:	0f 85 18 ff ff ff    	jne    80105c27 <trap+0xa7>
80105d0f:	e9 30 ff ff ff       	jmp    80105c44 <trap+0xc4>
80105d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d18:	e8 53 02 00 00       	call   80105f70 <uartintr>
    lapiceoi();
80105d1d:	e8 be cd ff ff       	call   80102ae0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d22:	e8 d9 de ff ff       	call   80103c00 <myproc>
80105d27:	85 c0                	test   %eax,%eax
80105d29:	0f 85 f8 fe ff ff    	jne    80105c27 <trap+0xa7>
80105d2f:	e9 10 ff ff ff       	jmp    80105c44 <trap+0xc4>
80105d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105d38:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105d3c:	8b 77 38             	mov    0x38(%edi),%esi
80105d3f:	e8 9c de ff ff       	call   80103be0 <cpuid>
80105d44:	56                   	push   %esi
80105d45:	53                   	push   %ebx
80105d46:	50                   	push   %eax
80105d47:	68 00 7b 10 80       	push   $0x80107b00
80105d4c:	e8 0f a9 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105d51:	e8 8a cd ff ff       	call   80102ae0 <lapiceoi>
    break;
80105d56:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d59:	e8 a2 de ff ff       	call   80103c00 <myproc>
80105d5e:	85 c0                	test   %eax,%eax
80105d60:	0f 85 c1 fe ff ff    	jne    80105c27 <trap+0xa7>
80105d66:	e9 d9 fe ff ff       	jmp    80105c44 <trap+0xc4>
80105d6b:	90                   	nop
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105d70:	e8 9b c6 ff ff       	call   80102410 <ideintr>
80105d75:	e9 63 ff ff ff       	jmp    80105cdd <trap+0x15d>
80105d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105d80:	e8 9b e2 ff ff       	call   80104020 <exit>
80105d85:	e9 0e ff ff ff       	jmp    80105c98 <trap+0x118>
80105d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105d90:	e8 8b e2 ff ff       	call   80104020 <exit>
80105d95:	e9 aa fe ff ff       	jmp    80105c44 <trap+0xc4>
80105d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	68 60 e9 11 80       	push   $0x8011e960
80105da8:	e8 d3 e9 ff ff       	call   80104780 <acquire>
      wakeup(&ticks);
80105dad:	c7 04 24 a0 f1 11 80 	movl   $0x8011f1a0,(%esp)
      ticks++;
80105db4:	83 05 a0 f1 11 80 01 	addl   $0x1,0x8011f1a0
      wakeup(&ticks);
80105dbb:	e8 a0 e5 ff ff       	call   80104360 <wakeup>
      release(&tickslock);
80105dc0:	c7 04 24 60 e9 11 80 	movl   $0x8011e960,(%esp)
80105dc7:	e8 74 ea ff ff       	call   80104840 <release>
80105dcc:	83 c4 10             	add    $0x10,%esp
80105dcf:	e9 09 ff ff ff       	jmp    80105cdd <trap+0x15d>
80105dd4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105dd7:	e8 04 de ff ff       	call   80103be0 <cpuid>
80105ddc:	83 ec 0c             	sub    $0xc,%esp
80105ddf:	56                   	push   %esi
80105de0:	53                   	push   %ebx
80105de1:	50                   	push   %eax
80105de2:	ff 77 30             	pushl  0x30(%edi)
80105de5:	68 24 7b 10 80       	push   $0x80107b24
80105dea:	e8 71 a8 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105def:	83 c4 14             	add    $0x14,%esp
80105df2:	68 fa 7a 10 80       	push   $0x80107afa
80105df7:	e8 94 a5 ff ff       	call   80100390 <panic>
80105dfc:	66 90                	xchg   %ax,%ax
80105dfe:	66 90                	xchg   %ax,%ax

80105e00 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e00:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105e05:	55                   	push   %ebp
80105e06:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105e08:	85 c0                	test   %eax,%eax
80105e0a:	74 1c                	je     80105e28 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e0c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e11:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e12:	a8 01                	test   $0x1,%al
80105e14:	74 12                	je     80105e28 <uartgetc+0x28>
80105e16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e1b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e1c:	0f b6 c0             	movzbl %al,%eax
}
80105e1f:	5d                   	pop    %ebp
80105e20:	c3                   	ret    
80105e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e2d:	5d                   	pop    %ebp
80105e2e:	c3                   	ret    
80105e2f:	90                   	nop

80105e30 <uartputc.part.0>:
uartputc(int c)
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	57                   	push   %edi
80105e34:	56                   	push   %esi
80105e35:	53                   	push   %ebx
80105e36:	89 c7                	mov    %eax,%edi
80105e38:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e3d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105e42:	83 ec 0c             	sub    $0xc,%esp
80105e45:	eb 1b                	jmp    80105e62 <uartputc.part.0+0x32>
80105e47:	89 f6                	mov    %esi,%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	6a 0a                	push   $0xa
80105e55:	e8 a6 cc ff ff       	call   80102b00 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e5a:	83 c4 10             	add    $0x10,%esp
80105e5d:	83 eb 01             	sub    $0x1,%ebx
80105e60:	74 07                	je     80105e69 <uartputc.part.0+0x39>
80105e62:	89 f2                	mov    %esi,%edx
80105e64:	ec                   	in     (%dx),%al
80105e65:	a8 20                	test   $0x20,%al
80105e67:	74 e7                	je     80105e50 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e69:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e6e:	89 f8                	mov    %edi,%eax
80105e70:	ee                   	out    %al,(%dx)
}
80105e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e74:	5b                   	pop    %ebx
80105e75:	5e                   	pop    %esi
80105e76:	5f                   	pop    %edi
80105e77:	5d                   	pop    %ebp
80105e78:	c3                   	ret    
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e80 <uartinit>:
{
80105e80:	55                   	push   %ebp
80105e81:	31 c9                	xor    %ecx,%ecx
80105e83:	89 c8                	mov    %ecx,%eax
80105e85:	89 e5                	mov    %esp,%ebp
80105e87:	57                   	push   %edi
80105e88:	56                   	push   %esi
80105e89:	53                   	push   %ebx
80105e8a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105e8f:	89 da                	mov    %ebx,%edx
80105e91:	83 ec 0c             	sub    $0xc,%esp
80105e94:	ee                   	out    %al,(%dx)
80105e95:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105e9a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e9f:	89 fa                	mov    %edi,%edx
80105ea1:	ee                   	out    %al,(%dx)
80105ea2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105ea7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105eac:	ee                   	out    %al,(%dx)
80105ead:	be f9 03 00 00       	mov    $0x3f9,%esi
80105eb2:	89 c8                	mov    %ecx,%eax
80105eb4:	89 f2                	mov    %esi,%edx
80105eb6:	ee                   	out    %al,(%dx)
80105eb7:	b8 03 00 00 00       	mov    $0x3,%eax
80105ebc:	89 fa                	mov    %edi,%edx
80105ebe:	ee                   	out    %al,(%dx)
80105ebf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ec4:	89 c8                	mov    %ecx,%eax
80105ec6:	ee                   	out    %al,(%dx)
80105ec7:	b8 01 00 00 00       	mov    $0x1,%eax
80105ecc:	89 f2                	mov    %esi,%edx
80105ece:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ecf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ed4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105ed5:	3c ff                	cmp    $0xff,%al
80105ed7:	74 5a                	je     80105f33 <uartinit+0xb3>
  uart = 1;
80105ed9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ee0:	00 00 00 
80105ee3:	89 da                	mov    %ebx,%edx
80105ee5:	ec                   	in     (%dx),%al
80105ee6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105eeb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105eec:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105eef:	bb 1c 7c 10 80       	mov    $0x80107c1c,%ebx
  ioapicenable(IRQ_COM1, 0);
80105ef4:	6a 00                	push   $0x0
80105ef6:	6a 04                	push   $0x4
80105ef8:	e8 63 c7 ff ff       	call   80102660 <ioapicenable>
80105efd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105f00:	b8 78 00 00 00       	mov    $0x78,%eax
80105f05:	eb 13                	jmp    80105f1a <uartinit+0x9a>
80105f07:	89 f6                	mov    %esi,%esi
80105f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105f10:	83 c3 01             	add    $0x1,%ebx
80105f13:	0f be 03             	movsbl (%ebx),%eax
80105f16:	84 c0                	test   %al,%al
80105f18:	74 19                	je     80105f33 <uartinit+0xb3>
  if(!uart)
80105f1a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105f20:	85 d2                	test   %edx,%edx
80105f22:	74 ec                	je     80105f10 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105f24:	83 c3 01             	add    $0x1,%ebx
80105f27:	e8 04 ff ff ff       	call   80105e30 <uartputc.part.0>
80105f2c:	0f be 03             	movsbl (%ebx),%eax
80105f2f:	84 c0                	test   %al,%al
80105f31:	75 e7                	jne    80105f1a <uartinit+0x9a>
}
80105f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f36:	5b                   	pop    %ebx
80105f37:	5e                   	pop    %esi
80105f38:	5f                   	pop    %edi
80105f39:	5d                   	pop    %ebp
80105f3a:	c3                   	ret    
80105f3b:	90                   	nop
80105f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f40 <uartputc>:
  if(!uart)
80105f40:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105f46:	55                   	push   %ebp
80105f47:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105f49:	85 d2                	test   %edx,%edx
{
80105f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105f4e:	74 10                	je     80105f60 <uartputc+0x20>
}
80105f50:	5d                   	pop    %ebp
80105f51:	e9 da fe ff ff       	jmp    80105e30 <uartputc.part.0>
80105f56:	8d 76 00             	lea    0x0(%esi),%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105f60:	5d                   	pop    %ebp
80105f61:	c3                   	ret    
80105f62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f70 <uartintr>:

void
uartintr(void)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f76:	68 00 5e 10 80       	push   $0x80105e00
80105f7b:	e8 90 a8 ff ff       	call   80100810 <consoleintr>
}
80105f80:	83 c4 10             	add    $0x10,%esp
80105f83:	c9                   	leave  
80105f84:	c3                   	ret    

80105f85 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f85:	6a 00                	push   $0x0
  pushl $0
80105f87:	6a 00                	push   $0x0
  jmp alltraps
80105f89:	e9 1c fb ff ff       	jmp    80105aaa <alltraps>

80105f8e <vector1>:
.globl vector1
vector1:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $1
80105f90:	6a 01                	push   $0x1
  jmp alltraps
80105f92:	e9 13 fb ff ff       	jmp    80105aaa <alltraps>

80105f97 <vector2>:
.globl vector2
vector2:
  pushl $0
80105f97:	6a 00                	push   $0x0
  pushl $2
80105f99:	6a 02                	push   $0x2
  jmp alltraps
80105f9b:	e9 0a fb ff ff       	jmp    80105aaa <alltraps>

80105fa0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105fa0:	6a 00                	push   $0x0
  pushl $3
80105fa2:	6a 03                	push   $0x3
  jmp alltraps
80105fa4:	e9 01 fb ff ff       	jmp    80105aaa <alltraps>

80105fa9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105fa9:	6a 00                	push   $0x0
  pushl $4
80105fab:	6a 04                	push   $0x4
  jmp alltraps
80105fad:	e9 f8 fa ff ff       	jmp    80105aaa <alltraps>

80105fb2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $5
80105fb4:	6a 05                	push   $0x5
  jmp alltraps
80105fb6:	e9 ef fa ff ff       	jmp    80105aaa <alltraps>

80105fbb <vector6>:
.globl vector6
vector6:
  pushl $0
80105fbb:	6a 00                	push   $0x0
  pushl $6
80105fbd:	6a 06                	push   $0x6
  jmp alltraps
80105fbf:	e9 e6 fa ff ff       	jmp    80105aaa <alltraps>

80105fc4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105fc4:	6a 00                	push   $0x0
  pushl $7
80105fc6:	6a 07                	push   $0x7
  jmp alltraps
80105fc8:	e9 dd fa ff ff       	jmp    80105aaa <alltraps>

80105fcd <vector8>:
.globl vector8
vector8:
  pushl $8
80105fcd:	6a 08                	push   $0x8
  jmp alltraps
80105fcf:	e9 d6 fa ff ff       	jmp    80105aaa <alltraps>

80105fd4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $9
80105fd6:	6a 09                	push   $0x9
  jmp alltraps
80105fd8:	e9 cd fa ff ff       	jmp    80105aaa <alltraps>

80105fdd <vector10>:
.globl vector10
vector10:
  pushl $10
80105fdd:	6a 0a                	push   $0xa
  jmp alltraps
80105fdf:	e9 c6 fa ff ff       	jmp    80105aaa <alltraps>

80105fe4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105fe4:	6a 0b                	push   $0xb
  jmp alltraps
80105fe6:	e9 bf fa ff ff       	jmp    80105aaa <alltraps>

80105feb <vector12>:
.globl vector12
vector12:
  pushl $12
80105feb:	6a 0c                	push   $0xc
  jmp alltraps
80105fed:	e9 b8 fa ff ff       	jmp    80105aaa <alltraps>

80105ff2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105ff2:	6a 0d                	push   $0xd
  jmp alltraps
80105ff4:	e9 b1 fa ff ff       	jmp    80105aaa <alltraps>

80105ff9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105ff9:	6a 0e                	push   $0xe
  jmp alltraps
80105ffb:	e9 aa fa ff ff       	jmp    80105aaa <alltraps>

80106000 <vector15>:
.globl vector15
vector15:
  pushl $0
80106000:	6a 00                	push   $0x0
  pushl $15
80106002:	6a 0f                	push   $0xf
  jmp alltraps
80106004:	e9 a1 fa ff ff       	jmp    80105aaa <alltraps>

80106009 <vector16>:
.globl vector16
vector16:
  pushl $0
80106009:	6a 00                	push   $0x0
  pushl $16
8010600b:	6a 10                	push   $0x10
  jmp alltraps
8010600d:	e9 98 fa ff ff       	jmp    80105aaa <alltraps>

80106012 <vector17>:
.globl vector17
vector17:
  pushl $17
80106012:	6a 11                	push   $0x11
  jmp alltraps
80106014:	e9 91 fa ff ff       	jmp    80105aaa <alltraps>

80106019 <vector18>:
.globl vector18
vector18:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $18
8010601b:	6a 12                	push   $0x12
  jmp alltraps
8010601d:	e9 88 fa ff ff       	jmp    80105aaa <alltraps>

80106022 <vector19>:
.globl vector19
vector19:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $19
80106024:	6a 13                	push   $0x13
  jmp alltraps
80106026:	e9 7f fa ff ff       	jmp    80105aaa <alltraps>

8010602b <vector20>:
.globl vector20
vector20:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $20
8010602d:	6a 14                	push   $0x14
  jmp alltraps
8010602f:	e9 76 fa ff ff       	jmp    80105aaa <alltraps>

80106034 <vector21>:
.globl vector21
vector21:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $21
80106036:	6a 15                	push   $0x15
  jmp alltraps
80106038:	e9 6d fa ff ff       	jmp    80105aaa <alltraps>

8010603d <vector22>:
.globl vector22
vector22:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $22
8010603f:	6a 16                	push   $0x16
  jmp alltraps
80106041:	e9 64 fa ff ff       	jmp    80105aaa <alltraps>

80106046 <vector23>:
.globl vector23
vector23:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $23
80106048:	6a 17                	push   $0x17
  jmp alltraps
8010604a:	e9 5b fa ff ff       	jmp    80105aaa <alltraps>

8010604f <vector24>:
.globl vector24
vector24:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $24
80106051:	6a 18                	push   $0x18
  jmp alltraps
80106053:	e9 52 fa ff ff       	jmp    80105aaa <alltraps>

80106058 <vector25>:
.globl vector25
vector25:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $25
8010605a:	6a 19                	push   $0x19
  jmp alltraps
8010605c:	e9 49 fa ff ff       	jmp    80105aaa <alltraps>

80106061 <vector26>:
.globl vector26
vector26:
  pushl $0
80106061:	6a 00                	push   $0x0
  pushl $26
80106063:	6a 1a                	push   $0x1a
  jmp alltraps
80106065:	e9 40 fa ff ff       	jmp    80105aaa <alltraps>

8010606a <vector27>:
.globl vector27
vector27:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $27
8010606c:	6a 1b                	push   $0x1b
  jmp alltraps
8010606e:	e9 37 fa ff ff       	jmp    80105aaa <alltraps>

80106073 <vector28>:
.globl vector28
vector28:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $28
80106075:	6a 1c                	push   $0x1c
  jmp alltraps
80106077:	e9 2e fa ff ff       	jmp    80105aaa <alltraps>

8010607c <vector29>:
.globl vector29
vector29:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $29
8010607e:	6a 1d                	push   $0x1d
  jmp alltraps
80106080:	e9 25 fa ff ff       	jmp    80105aaa <alltraps>

80106085 <vector30>:
.globl vector30
vector30:
  pushl $0
80106085:	6a 00                	push   $0x0
  pushl $30
80106087:	6a 1e                	push   $0x1e
  jmp alltraps
80106089:	e9 1c fa ff ff       	jmp    80105aaa <alltraps>

8010608e <vector31>:
.globl vector31
vector31:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $31
80106090:	6a 1f                	push   $0x1f
  jmp alltraps
80106092:	e9 13 fa ff ff       	jmp    80105aaa <alltraps>

80106097 <vector32>:
.globl vector32
vector32:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $32
80106099:	6a 20                	push   $0x20
  jmp alltraps
8010609b:	e9 0a fa ff ff       	jmp    80105aaa <alltraps>

801060a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $33
801060a2:	6a 21                	push   $0x21
  jmp alltraps
801060a4:	e9 01 fa ff ff       	jmp    80105aaa <alltraps>

801060a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $34
801060ab:	6a 22                	push   $0x22
  jmp alltraps
801060ad:	e9 f8 f9 ff ff       	jmp    80105aaa <alltraps>

801060b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $35
801060b4:	6a 23                	push   $0x23
  jmp alltraps
801060b6:	e9 ef f9 ff ff       	jmp    80105aaa <alltraps>

801060bb <vector36>:
.globl vector36
vector36:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $36
801060bd:	6a 24                	push   $0x24
  jmp alltraps
801060bf:	e9 e6 f9 ff ff       	jmp    80105aaa <alltraps>

801060c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $37
801060c6:	6a 25                	push   $0x25
  jmp alltraps
801060c8:	e9 dd f9 ff ff       	jmp    80105aaa <alltraps>

801060cd <vector38>:
.globl vector38
vector38:
  pushl $0
801060cd:	6a 00                	push   $0x0
  pushl $38
801060cf:	6a 26                	push   $0x26
  jmp alltraps
801060d1:	e9 d4 f9 ff ff       	jmp    80105aaa <alltraps>

801060d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $39
801060d8:	6a 27                	push   $0x27
  jmp alltraps
801060da:	e9 cb f9 ff ff       	jmp    80105aaa <alltraps>

801060df <vector40>:
.globl vector40
vector40:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $40
801060e1:	6a 28                	push   $0x28
  jmp alltraps
801060e3:	e9 c2 f9 ff ff       	jmp    80105aaa <alltraps>

801060e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $41
801060ea:	6a 29                	push   $0x29
  jmp alltraps
801060ec:	e9 b9 f9 ff ff       	jmp    80105aaa <alltraps>

801060f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801060f1:	6a 00                	push   $0x0
  pushl $42
801060f3:	6a 2a                	push   $0x2a
  jmp alltraps
801060f5:	e9 b0 f9 ff ff       	jmp    80105aaa <alltraps>

801060fa <vector43>:
.globl vector43
vector43:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $43
801060fc:	6a 2b                	push   $0x2b
  jmp alltraps
801060fe:	e9 a7 f9 ff ff       	jmp    80105aaa <alltraps>

80106103 <vector44>:
.globl vector44
vector44:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $44
80106105:	6a 2c                	push   $0x2c
  jmp alltraps
80106107:	e9 9e f9 ff ff       	jmp    80105aaa <alltraps>

8010610c <vector45>:
.globl vector45
vector45:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $45
8010610e:	6a 2d                	push   $0x2d
  jmp alltraps
80106110:	e9 95 f9 ff ff       	jmp    80105aaa <alltraps>

80106115 <vector46>:
.globl vector46
vector46:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $46
80106117:	6a 2e                	push   $0x2e
  jmp alltraps
80106119:	e9 8c f9 ff ff       	jmp    80105aaa <alltraps>

8010611e <vector47>:
.globl vector47
vector47:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $47
80106120:	6a 2f                	push   $0x2f
  jmp alltraps
80106122:	e9 83 f9 ff ff       	jmp    80105aaa <alltraps>

80106127 <vector48>:
.globl vector48
vector48:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $48
80106129:	6a 30                	push   $0x30
  jmp alltraps
8010612b:	e9 7a f9 ff ff       	jmp    80105aaa <alltraps>

80106130 <vector49>:
.globl vector49
vector49:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $49
80106132:	6a 31                	push   $0x31
  jmp alltraps
80106134:	e9 71 f9 ff ff       	jmp    80105aaa <alltraps>

80106139 <vector50>:
.globl vector50
vector50:
  pushl $0
80106139:	6a 00                	push   $0x0
  pushl $50
8010613b:	6a 32                	push   $0x32
  jmp alltraps
8010613d:	e9 68 f9 ff ff       	jmp    80105aaa <alltraps>

80106142 <vector51>:
.globl vector51
vector51:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $51
80106144:	6a 33                	push   $0x33
  jmp alltraps
80106146:	e9 5f f9 ff ff       	jmp    80105aaa <alltraps>

8010614b <vector52>:
.globl vector52
vector52:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $52
8010614d:	6a 34                	push   $0x34
  jmp alltraps
8010614f:	e9 56 f9 ff ff       	jmp    80105aaa <alltraps>

80106154 <vector53>:
.globl vector53
vector53:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $53
80106156:	6a 35                	push   $0x35
  jmp alltraps
80106158:	e9 4d f9 ff ff       	jmp    80105aaa <alltraps>

8010615d <vector54>:
.globl vector54
vector54:
  pushl $0
8010615d:	6a 00                	push   $0x0
  pushl $54
8010615f:	6a 36                	push   $0x36
  jmp alltraps
80106161:	e9 44 f9 ff ff       	jmp    80105aaa <alltraps>

80106166 <vector55>:
.globl vector55
vector55:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $55
80106168:	6a 37                	push   $0x37
  jmp alltraps
8010616a:	e9 3b f9 ff ff       	jmp    80105aaa <alltraps>

8010616f <vector56>:
.globl vector56
vector56:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $56
80106171:	6a 38                	push   $0x38
  jmp alltraps
80106173:	e9 32 f9 ff ff       	jmp    80105aaa <alltraps>

80106178 <vector57>:
.globl vector57
vector57:
  pushl $0
80106178:	6a 00                	push   $0x0
  pushl $57
8010617a:	6a 39                	push   $0x39
  jmp alltraps
8010617c:	e9 29 f9 ff ff       	jmp    80105aaa <alltraps>

80106181 <vector58>:
.globl vector58
vector58:
  pushl $0
80106181:	6a 00                	push   $0x0
  pushl $58
80106183:	6a 3a                	push   $0x3a
  jmp alltraps
80106185:	e9 20 f9 ff ff       	jmp    80105aaa <alltraps>

8010618a <vector59>:
.globl vector59
vector59:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $59
8010618c:	6a 3b                	push   $0x3b
  jmp alltraps
8010618e:	e9 17 f9 ff ff       	jmp    80105aaa <alltraps>

80106193 <vector60>:
.globl vector60
vector60:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $60
80106195:	6a 3c                	push   $0x3c
  jmp alltraps
80106197:	e9 0e f9 ff ff       	jmp    80105aaa <alltraps>

8010619c <vector61>:
.globl vector61
vector61:
  pushl $0
8010619c:	6a 00                	push   $0x0
  pushl $61
8010619e:	6a 3d                	push   $0x3d
  jmp alltraps
801061a0:	e9 05 f9 ff ff       	jmp    80105aaa <alltraps>

801061a5 <vector62>:
.globl vector62
vector62:
  pushl $0
801061a5:	6a 00                	push   $0x0
  pushl $62
801061a7:	6a 3e                	push   $0x3e
  jmp alltraps
801061a9:	e9 fc f8 ff ff       	jmp    80105aaa <alltraps>

801061ae <vector63>:
.globl vector63
vector63:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $63
801061b0:	6a 3f                	push   $0x3f
  jmp alltraps
801061b2:	e9 f3 f8 ff ff       	jmp    80105aaa <alltraps>

801061b7 <vector64>:
.globl vector64
vector64:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $64
801061b9:	6a 40                	push   $0x40
  jmp alltraps
801061bb:	e9 ea f8 ff ff       	jmp    80105aaa <alltraps>

801061c0 <vector65>:
.globl vector65
vector65:
  pushl $0
801061c0:	6a 00                	push   $0x0
  pushl $65
801061c2:	6a 41                	push   $0x41
  jmp alltraps
801061c4:	e9 e1 f8 ff ff       	jmp    80105aaa <alltraps>

801061c9 <vector66>:
.globl vector66
vector66:
  pushl $0
801061c9:	6a 00                	push   $0x0
  pushl $66
801061cb:	6a 42                	push   $0x42
  jmp alltraps
801061cd:	e9 d8 f8 ff ff       	jmp    80105aaa <alltraps>

801061d2 <vector67>:
.globl vector67
vector67:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $67
801061d4:	6a 43                	push   $0x43
  jmp alltraps
801061d6:	e9 cf f8 ff ff       	jmp    80105aaa <alltraps>

801061db <vector68>:
.globl vector68
vector68:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $68
801061dd:	6a 44                	push   $0x44
  jmp alltraps
801061df:	e9 c6 f8 ff ff       	jmp    80105aaa <alltraps>

801061e4 <vector69>:
.globl vector69
vector69:
  pushl $0
801061e4:	6a 00                	push   $0x0
  pushl $69
801061e6:	6a 45                	push   $0x45
  jmp alltraps
801061e8:	e9 bd f8 ff ff       	jmp    80105aaa <alltraps>

801061ed <vector70>:
.globl vector70
vector70:
  pushl $0
801061ed:	6a 00                	push   $0x0
  pushl $70
801061ef:	6a 46                	push   $0x46
  jmp alltraps
801061f1:	e9 b4 f8 ff ff       	jmp    80105aaa <alltraps>

801061f6 <vector71>:
.globl vector71
vector71:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $71
801061f8:	6a 47                	push   $0x47
  jmp alltraps
801061fa:	e9 ab f8 ff ff       	jmp    80105aaa <alltraps>

801061ff <vector72>:
.globl vector72
vector72:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $72
80106201:	6a 48                	push   $0x48
  jmp alltraps
80106203:	e9 a2 f8 ff ff       	jmp    80105aaa <alltraps>

80106208 <vector73>:
.globl vector73
vector73:
  pushl $0
80106208:	6a 00                	push   $0x0
  pushl $73
8010620a:	6a 49                	push   $0x49
  jmp alltraps
8010620c:	e9 99 f8 ff ff       	jmp    80105aaa <alltraps>

80106211 <vector74>:
.globl vector74
vector74:
  pushl $0
80106211:	6a 00                	push   $0x0
  pushl $74
80106213:	6a 4a                	push   $0x4a
  jmp alltraps
80106215:	e9 90 f8 ff ff       	jmp    80105aaa <alltraps>

8010621a <vector75>:
.globl vector75
vector75:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $75
8010621c:	6a 4b                	push   $0x4b
  jmp alltraps
8010621e:	e9 87 f8 ff ff       	jmp    80105aaa <alltraps>

80106223 <vector76>:
.globl vector76
vector76:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $76
80106225:	6a 4c                	push   $0x4c
  jmp alltraps
80106227:	e9 7e f8 ff ff       	jmp    80105aaa <alltraps>

8010622c <vector77>:
.globl vector77
vector77:
  pushl $0
8010622c:	6a 00                	push   $0x0
  pushl $77
8010622e:	6a 4d                	push   $0x4d
  jmp alltraps
80106230:	e9 75 f8 ff ff       	jmp    80105aaa <alltraps>

80106235 <vector78>:
.globl vector78
vector78:
  pushl $0
80106235:	6a 00                	push   $0x0
  pushl $78
80106237:	6a 4e                	push   $0x4e
  jmp alltraps
80106239:	e9 6c f8 ff ff       	jmp    80105aaa <alltraps>

8010623e <vector79>:
.globl vector79
vector79:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $79
80106240:	6a 4f                	push   $0x4f
  jmp alltraps
80106242:	e9 63 f8 ff ff       	jmp    80105aaa <alltraps>

80106247 <vector80>:
.globl vector80
vector80:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $80
80106249:	6a 50                	push   $0x50
  jmp alltraps
8010624b:	e9 5a f8 ff ff       	jmp    80105aaa <alltraps>

80106250 <vector81>:
.globl vector81
vector81:
  pushl $0
80106250:	6a 00                	push   $0x0
  pushl $81
80106252:	6a 51                	push   $0x51
  jmp alltraps
80106254:	e9 51 f8 ff ff       	jmp    80105aaa <alltraps>

80106259 <vector82>:
.globl vector82
vector82:
  pushl $0
80106259:	6a 00                	push   $0x0
  pushl $82
8010625b:	6a 52                	push   $0x52
  jmp alltraps
8010625d:	e9 48 f8 ff ff       	jmp    80105aaa <alltraps>

80106262 <vector83>:
.globl vector83
vector83:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $83
80106264:	6a 53                	push   $0x53
  jmp alltraps
80106266:	e9 3f f8 ff ff       	jmp    80105aaa <alltraps>

8010626b <vector84>:
.globl vector84
vector84:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $84
8010626d:	6a 54                	push   $0x54
  jmp alltraps
8010626f:	e9 36 f8 ff ff       	jmp    80105aaa <alltraps>

80106274 <vector85>:
.globl vector85
vector85:
  pushl $0
80106274:	6a 00                	push   $0x0
  pushl $85
80106276:	6a 55                	push   $0x55
  jmp alltraps
80106278:	e9 2d f8 ff ff       	jmp    80105aaa <alltraps>

8010627d <vector86>:
.globl vector86
vector86:
  pushl $0
8010627d:	6a 00                	push   $0x0
  pushl $86
8010627f:	6a 56                	push   $0x56
  jmp alltraps
80106281:	e9 24 f8 ff ff       	jmp    80105aaa <alltraps>

80106286 <vector87>:
.globl vector87
vector87:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $87
80106288:	6a 57                	push   $0x57
  jmp alltraps
8010628a:	e9 1b f8 ff ff       	jmp    80105aaa <alltraps>

8010628f <vector88>:
.globl vector88
vector88:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $88
80106291:	6a 58                	push   $0x58
  jmp alltraps
80106293:	e9 12 f8 ff ff       	jmp    80105aaa <alltraps>

80106298 <vector89>:
.globl vector89
vector89:
  pushl $0
80106298:	6a 00                	push   $0x0
  pushl $89
8010629a:	6a 59                	push   $0x59
  jmp alltraps
8010629c:	e9 09 f8 ff ff       	jmp    80105aaa <alltraps>

801062a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801062a1:	6a 00                	push   $0x0
  pushl $90
801062a3:	6a 5a                	push   $0x5a
  jmp alltraps
801062a5:	e9 00 f8 ff ff       	jmp    80105aaa <alltraps>

801062aa <vector91>:
.globl vector91
vector91:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $91
801062ac:	6a 5b                	push   $0x5b
  jmp alltraps
801062ae:	e9 f7 f7 ff ff       	jmp    80105aaa <alltraps>

801062b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $92
801062b5:	6a 5c                	push   $0x5c
  jmp alltraps
801062b7:	e9 ee f7 ff ff       	jmp    80105aaa <alltraps>

801062bc <vector93>:
.globl vector93
vector93:
  pushl $0
801062bc:	6a 00                	push   $0x0
  pushl $93
801062be:	6a 5d                	push   $0x5d
  jmp alltraps
801062c0:	e9 e5 f7 ff ff       	jmp    80105aaa <alltraps>

801062c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801062c5:	6a 00                	push   $0x0
  pushl $94
801062c7:	6a 5e                	push   $0x5e
  jmp alltraps
801062c9:	e9 dc f7 ff ff       	jmp    80105aaa <alltraps>

801062ce <vector95>:
.globl vector95
vector95:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $95
801062d0:	6a 5f                	push   $0x5f
  jmp alltraps
801062d2:	e9 d3 f7 ff ff       	jmp    80105aaa <alltraps>

801062d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $96
801062d9:	6a 60                	push   $0x60
  jmp alltraps
801062db:	e9 ca f7 ff ff       	jmp    80105aaa <alltraps>

801062e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801062e0:	6a 00                	push   $0x0
  pushl $97
801062e2:	6a 61                	push   $0x61
  jmp alltraps
801062e4:	e9 c1 f7 ff ff       	jmp    80105aaa <alltraps>

801062e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801062e9:	6a 00                	push   $0x0
  pushl $98
801062eb:	6a 62                	push   $0x62
  jmp alltraps
801062ed:	e9 b8 f7 ff ff       	jmp    80105aaa <alltraps>

801062f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $99
801062f4:	6a 63                	push   $0x63
  jmp alltraps
801062f6:	e9 af f7 ff ff       	jmp    80105aaa <alltraps>

801062fb <vector100>:
.globl vector100
vector100:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $100
801062fd:	6a 64                	push   $0x64
  jmp alltraps
801062ff:	e9 a6 f7 ff ff       	jmp    80105aaa <alltraps>

80106304 <vector101>:
.globl vector101
vector101:
  pushl $0
80106304:	6a 00                	push   $0x0
  pushl $101
80106306:	6a 65                	push   $0x65
  jmp alltraps
80106308:	e9 9d f7 ff ff       	jmp    80105aaa <alltraps>

8010630d <vector102>:
.globl vector102
vector102:
  pushl $0
8010630d:	6a 00                	push   $0x0
  pushl $102
8010630f:	6a 66                	push   $0x66
  jmp alltraps
80106311:	e9 94 f7 ff ff       	jmp    80105aaa <alltraps>

80106316 <vector103>:
.globl vector103
vector103:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $103
80106318:	6a 67                	push   $0x67
  jmp alltraps
8010631a:	e9 8b f7 ff ff       	jmp    80105aaa <alltraps>

8010631f <vector104>:
.globl vector104
vector104:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $104
80106321:	6a 68                	push   $0x68
  jmp alltraps
80106323:	e9 82 f7 ff ff       	jmp    80105aaa <alltraps>

80106328 <vector105>:
.globl vector105
vector105:
  pushl $0
80106328:	6a 00                	push   $0x0
  pushl $105
8010632a:	6a 69                	push   $0x69
  jmp alltraps
8010632c:	e9 79 f7 ff ff       	jmp    80105aaa <alltraps>

80106331 <vector106>:
.globl vector106
vector106:
  pushl $0
80106331:	6a 00                	push   $0x0
  pushl $106
80106333:	6a 6a                	push   $0x6a
  jmp alltraps
80106335:	e9 70 f7 ff ff       	jmp    80105aaa <alltraps>

8010633a <vector107>:
.globl vector107
vector107:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $107
8010633c:	6a 6b                	push   $0x6b
  jmp alltraps
8010633e:	e9 67 f7 ff ff       	jmp    80105aaa <alltraps>

80106343 <vector108>:
.globl vector108
vector108:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $108
80106345:	6a 6c                	push   $0x6c
  jmp alltraps
80106347:	e9 5e f7 ff ff       	jmp    80105aaa <alltraps>

8010634c <vector109>:
.globl vector109
vector109:
  pushl $0
8010634c:	6a 00                	push   $0x0
  pushl $109
8010634e:	6a 6d                	push   $0x6d
  jmp alltraps
80106350:	e9 55 f7 ff ff       	jmp    80105aaa <alltraps>

80106355 <vector110>:
.globl vector110
vector110:
  pushl $0
80106355:	6a 00                	push   $0x0
  pushl $110
80106357:	6a 6e                	push   $0x6e
  jmp alltraps
80106359:	e9 4c f7 ff ff       	jmp    80105aaa <alltraps>

8010635e <vector111>:
.globl vector111
vector111:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $111
80106360:	6a 6f                	push   $0x6f
  jmp alltraps
80106362:	e9 43 f7 ff ff       	jmp    80105aaa <alltraps>

80106367 <vector112>:
.globl vector112
vector112:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $112
80106369:	6a 70                	push   $0x70
  jmp alltraps
8010636b:	e9 3a f7 ff ff       	jmp    80105aaa <alltraps>

80106370 <vector113>:
.globl vector113
vector113:
  pushl $0
80106370:	6a 00                	push   $0x0
  pushl $113
80106372:	6a 71                	push   $0x71
  jmp alltraps
80106374:	e9 31 f7 ff ff       	jmp    80105aaa <alltraps>

80106379 <vector114>:
.globl vector114
vector114:
  pushl $0
80106379:	6a 00                	push   $0x0
  pushl $114
8010637b:	6a 72                	push   $0x72
  jmp alltraps
8010637d:	e9 28 f7 ff ff       	jmp    80105aaa <alltraps>

80106382 <vector115>:
.globl vector115
vector115:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $115
80106384:	6a 73                	push   $0x73
  jmp alltraps
80106386:	e9 1f f7 ff ff       	jmp    80105aaa <alltraps>

8010638b <vector116>:
.globl vector116
vector116:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $116
8010638d:	6a 74                	push   $0x74
  jmp alltraps
8010638f:	e9 16 f7 ff ff       	jmp    80105aaa <alltraps>

80106394 <vector117>:
.globl vector117
vector117:
  pushl $0
80106394:	6a 00                	push   $0x0
  pushl $117
80106396:	6a 75                	push   $0x75
  jmp alltraps
80106398:	e9 0d f7 ff ff       	jmp    80105aaa <alltraps>

8010639d <vector118>:
.globl vector118
vector118:
  pushl $0
8010639d:	6a 00                	push   $0x0
  pushl $118
8010639f:	6a 76                	push   $0x76
  jmp alltraps
801063a1:	e9 04 f7 ff ff       	jmp    80105aaa <alltraps>

801063a6 <vector119>:
.globl vector119
vector119:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $119
801063a8:	6a 77                	push   $0x77
  jmp alltraps
801063aa:	e9 fb f6 ff ff       	jmp    80105aaa <alltraps>

801063af <vector120>:
.globl vector120
vector120:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $120
801063b1:	6a 78                	push   $0x78
  jmp alltraps
801063b3:	e9 f2 f6 ff ff       	jmp    80105aaa <alltraps>

801063b8 <vector121>:
.globl vector121
vector121:
  pushl $0
801063b8:	6a 00                	push   $0x0
  pushl $121
801063ba:	6a 79                	push   $0x79
  jmp alltraps
801063bc:	e9 e9 f6 ff ff       	jmp    80105aaa <alltraps>

801063c1 <vector122>:
.globl vector122
vector122:
  pushl $0
801063c1:	6a 00                	push   $0x0
  pushl $122
801063c3:	6a 7a                	push   $0x7a
  jmp alltraps
801063c5:	e9 e0 f6 ff ff       	jmp    80105aaa <alltraps>

801063ca <vector123>:
.globl vector123
vector123:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $123
801063cc:	6a 7b                	push   $0x7b
  jmp alltraps
801063ce:	e9 d7 f6 ff ff       	jmp    80105aaa <alltraps>

801063d3 <vector124>:
.globl vector124
vector124:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $124
801063d5:	6a 7c                	push   $0x7c
  jmp alltraps
801063d7:	e9 ce f6 ff ff       	jmp    80105aaa <alltraps>

801063dc <vector125>:
.globl vector125
vector125:
  pushl $0
801063dc:	6a 00                	push   $0x0
  pushl $125
801063de:	6a 7d                	push   $0x7d
  jmp alltraps
801063e0:	e9 c5 f6 ff ff       	jmp    80105aaa <alltraps>

801063e5 <vector126>:
.globl vector126
vector126:
  pushl $0
801063e5:	6a 00                	push   $0x0
  pushl $126
801063e7:	6a 7e                	push   $0x7e
  jmp alltraps
801063e9:	e9 bc f6 ff ff       	jmp    80105aaa <alltraps>

801063ee <vector127>:
.globl vector127
vector127:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $127
801063f0:	6a 7f                	push   $0x7f
  jmp alltraps
801063f2:	e9 b3 f6 ff ff       	jmp    80105aaa <alltraps>

801063f7 <vector128>:
.globl vector128
vector128:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $128
801063f9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801063fe:	e9 a7 f6 ff ff       	jmp    80105aaa <alltraps>

80106403 <vector129>:
.globl vector129
vector129:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $129
80106405:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010640a:	e9 9b f6 ff ff       	jmp    80105aaa <alltraps>

8010640f <vector130>:
.globl vector130
vector130:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $130
80106411:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106416:	e9 8f f6 ff ff       	jmp    80105aaa <alltraps>

8010641b <vector131>:
.globl vector131
vector131:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $131
8010641d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106422:	e9 83 f6 ff ff       	jmp    80105aaa <alltraps>

80106427 <vector132>:
.globl vector132
vector132:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $132
80106429:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010642e:	e9 77 f6 ff ff       	jmp    80105aaa <alltraps>

80106433 <vector133>:
.globl vector133
vector133:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $133
80106435:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010643a:	e9 6b f6 ff ff       	jmp    80105aaa <alltraps>

8010643f <vector134>:
.globl vector134
vector134:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $134
80106441:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106446:	e9 5f f6 ff ff       	jmp    80105aaa <alltraps>

8010644b <vector135>:
.globl vector135
vector135:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $135
8010644d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106452:	e9 53 f6 ff ff       	jmp    80105aaa <alltraps>

80106457 <vector136>:
.globl vector136
vector136:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $136
80106459:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010645e:	e9 47 f6 ff ff       	jmp    80105aaa <alltraps>

80106463 <vector137>:
.globl vector137
vector137:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $137
80106465:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010646a:	e9 3b f6 ff ff       	jmp    80105aaa <alltraps>

8010646f <vector138>:
.globl vector138
vector138:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $138
80106471:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106476:	e9 2f f6 ff ff       	jmp    80105aaa <alltraps>

8010647b <vector139>:
.globl vector139
vector139:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $139
8010647d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106482:	e9 23 f6 ff ff       	jmp    80105aaa <alltraps>

80106487 <vector140>:
.globl vector140
vector140:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $140
80106489:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010648e:	e9 17 f6 ff ff       	jmp    80105aaa <alltraps>

80106493 <vector141>:
.globl vector141
vector141:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $141
80106495:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010649a:	e9 0b f6 ff ff       	jmp    80105aaa <alltraps>

8010649f <vector142>:
.globl vector142
vector142:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $142
801064a1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064a6:	e9 ff f5 ff ff       	jmp    80105aaa <alltraps>

801064ab <vector143>:
.globl vector143
vector143:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $143
801064ad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801064b2:	e9 f3 f5 ff ff       	jmp    80105aaa <alltraps>

801064b7 <vector144>:
.globl vector144
vector144:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $144
801064b9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801064be:	e9 e7 f5 ff ff       	jmp    80105aaa <alltraps>

801064c3 <vector145>:
.globl vector145
vector145:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $145
801064c5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801064ca:	e9 db f5 ff ff       	jmp    80105aaa <alltraps>

801064cf <vector146>:
.globl vector146
vector146:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $146
801064d1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801064d6:	e9 cf f5 ff ff       	jmp    80105aaa <alltraps>

801064db <vector147>:
.globl vector147
vector147:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $147
801064dd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801064e2:	e9 c3 f5 ff ff       	jmp    80105aaa <alltraps>

801064e7 <vector148>:
.globl vector148
vector148:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $148
801064e9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801064ee:	e9 b7 f5 ff ff       	jmp    80105aaa <alltraps>

801064f3 <vector149>:
.globl vector149
vector149:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $149
801064f5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801064fa:	e9 ab f5 ff ff       	jmp    80105aaa <alltraps>

801064ff <vector150>:
.globl vector150
vector150:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $150
80106501:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106506:	e9 9f f5 ff ff       	jmp    80105aaa <alltraps>

8010650b <vector151>:
.globl vector151
vector151:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $151
8010650d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106512:	e9 93 f5 ff ff       	jmp    80105aaa <alltraps>

80106517 <vector152>:
.globl vector152
vector152:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $152
80106519:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010651e:	e9 87 f5 ff ff       	jmp    80105aaa <alltraps>

80106523 <vector153>:
.globl vector153
vector153:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $153
80106525:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010652a:	e9 7b f5 ff ff       	jmp    80105aaa <alltraps>

8010652f <vector154>:
.globl vector154
vector154:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $154
80106531:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106536:	e9 6f f5 ff ff       	jmp    80105aaa <alltraps>

8010653b <vector155>:
.globl vector155
vector155:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $155
8010653d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106542:	e9 63 f5 ff ff       	jmp    80105aaa <alltraps>

80106547 <vector156>:
.globl vector156
vector156:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $156
80106549:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010654e:	e9 57 f5 ff ff       	jmp    80105aaa <alltraps>

80106553 <vector157>:
.globl vector157
vector157:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $157
80106555:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010655a:	e9 4b f5 ff ff       	jmp    80105aaa <alltraps>

8010655f <vector158>:
.globl vector158
vector158:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $158
80106561:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106566:	e9 3f f5 ff ff       	jmp    80105aaa <alltraps>

8010656b <vector159>:
.globl vector159
vector159:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $159
8010656d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106572:	e9 33 f5 ff ff       	jmp    80105aaa <alltraps>

80106577 <vector160>:
.globl vector160
vector160:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $160
80106579:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010657e:	e9 27 f5 ff ff       	jmp    80105aaa <alltraps>

80106583 <vector161>:
.globl vector161
vector161:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $161
80106585:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010658a:	e9 1b f5 ff ff       	jmp    80105aaa <alltraps>

8010658f <vector162>:
.globl vector162
vector162:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $162
80106591:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106596:	e9 0f f5 ff ff       	jmp    80105aaa <alltraps>

8010659b <vector163>:
.globl vector163
vector163:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $163
8010659d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065a2:	e9 03 f5 ff ff       	jmp    80105aaa <alltraps>

801065a7 <vector164>:
.globl vector164
vector164:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $164
801065a9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801065ae:	e9 f7 f4 ff ff       	jmp    80105aaa <alltraps>

801065b3 <vector165>:
.globl vector165
vector165:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $165
801065b5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801065ba:	e9 eb f4 ff ff       	jmp    80105aaa <alltraps>

801065bf <vector166>:
.globl vector166
vector166:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $166
801065c1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801065c6:	e9 df f4 ff ff       	jmp    80105aaa <alltraps>

801065cb <vector167>:
.globl vector167
vector167:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $167
801065cd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801065d2:	e9 d3 f4 ff ff       	jmp    80105aaa <alltraps>

801065d7 <vector168>:
.globl vector168
vector168:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $168
801065d9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801065de:	e9 c7 f4 ff ff       	jmp    80105aaa <alltraps>

801065e3 <vector169>:
.globl vector169
vector169:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $169
801065e5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801065ea:	e9 bb f4 ff ff       	jmp    80105aaa <alltraps>

801065ef <vector170>:
.globl vector170
vector170:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $170
801065f1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801065f6:	e9 af f4 ff ff       	jmp    80105aaa <alltraps>

801065fb <vector171>:
.globl vector171
vector171:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $171
801065fd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106602:	e9 a3 f4 ff ff       	jmp    80105aaa <alltraps>

80106607 <vector172>:
.globl vector172
vector172:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $172
80106609:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010660e:	e9 97 f4 ff ff       	jmp    80105aaa <alltraps>

80106613 <vector173>:
.globl vector173
vector173:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $173
80106615:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010661a:	e9 8b f4 ff ff       	jmp    80105aaa <alltraps>

8010661f <vector174>:
.globl vector174
vector174:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $174
80106621:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106626:	e9 7f f4 ff ff       	jmp    80105aaa <alltraps>

8010662b <vector175>:
.globl vector175
vector175:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $175
8010662d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106632:	e9 73 f4 ff ff       	jmp    80105aaa <alltraps>

80106637 <vector176>:
.globl vector176
vector176:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $176
80106639:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010663e:	e9 67 f4 ff ff       	jmp    80105aaa <alltraps>

80106643 <vector177>:
.globl vector177
vector177:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $177
80106645:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010664a:	e9 5b f4 ff ff       	jmp    80105aaa <alltraps>

8010664f <vector178>:
.globl vector178
vector178:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $178
80106651:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106656:	e9 4f f4 ff ff       	jmp    80105aaa <alltraps>

8010665b <vector179>:
.globl vector179
vector179:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $179
8010665d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106662:	e9 43 f4 ff ff       	jmp    80105aaa <alltraps>

80106667 <vector180>:
.globl vector180
vector180:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $180
80106669:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010666e:	e9 37 f4 ff ff       	jmp    80105aaa <alltraps>

80106673 <vector181>:
.globl vector181
vector181:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $181
80106675:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010667a:	e9 2b f4 ff ff       	jmp    80105aaa <alltraps>

8010667f <vector182>:
.globl vector182
vector182:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $182
80106681:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106686:	e9 1f f4 ff ff       	jmp    80105aaa <alltraps>

8010668b <vector183>:
.globl vector183
vector183:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $183
8010668d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106692:	e9 13 f4 ff ff       	jmp    80105aaa <alltraps>

80106697 <vector184>:
.globl vector184
vector184:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $184
80106699:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010669e:	e9 07 f4 ff ff       	jmp    80105aaa <alltraps>

801066a3 <vector185>:
.globl vector185
vector185:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $185
801066a5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066aa:	e9 fb f3 ff ff       	jmp    80105aaa <alltraps>

801066af <vector186>:
.globl vector186
vector186:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $186
801066b1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801066b6:	e9 ef f3 ff ff       	jmp    80105aaa <alltraps>

801066bb <vector187>:
.globl vector187
vector187:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $187
801066bd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801066c2:	e9 e3 f3 ff ff       	jmp    80105aaa <alltraps>

801066c7 <vector188>:
.globl vector188
vector188:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $188
801066c9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801066ce:	e9 d7 f3 ff ff       	jmp    80105aaa <alltraps>

801066d3 <vector189>:
.globl vector189
vector189:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $189
801066d5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801066da:	e9 cb f3 ff ff       	jmp    80105aaa <alltraps>

801066df <vector190>:
.globl vector190
vector190:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $190
801066e1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801066e6:	e9 bf f3 ff ff       	jmp    80105aaa <alltraps>

801066eb <vector191>:
.globl vector191
vector191:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $191
801066ed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801066f2:	e9 b3 f3 ff ff       	jmp    80105aaa <alltraps>

801066f7 <vector192>:
.globl vector192
vector192:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $192
801066f9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801066fe:	e9 a7 f3 ff ff       	jmp    80105aaa <alltraps>

80106703 <vector193>:
.globl vector193
vector193:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $193
80106705:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010670a:	e9 9b f3 ff ff       	jmp    80105aaa <alltraps>

8010670f <vector194>:
.globl vector194
vector194:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $194
80106711:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106716:	e9 8f f3 ff ff       	jmp    80105aaa <alltraps>

8010671b <vector195>:
.globl vector195
vector195:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $195
8010671d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106722:	e9 83 f3 ff ff       	jmp    80105aaa <alltraps>

80106727 <vector196>:
.globl vector196
vector196:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $196
80106729:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010672e:	e9 77 f3 ff ff       	jmp    80105aaa <alltraps>

80106733 <vector197>:
.globl vector197
vector197:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $197
80106735:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010673a:	e9 6b f3 ff ff       	jmp    80105aaa <alltraps>

8010673f <vector198>:
.globl vector198
vector198:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $198
80106741:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106746:	e9 5f f3 ff ff       	jmp    80105aaa <alltraps>

8010674b <vector199>:
.globl vector199
vector199:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $199
8010674d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106752:	e9 53 f3 ff ff       	jmp    80105aaa <alltraps>

80106757 <vector200>:
.globl vector200
vector200:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $200
80106759:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010675e:	e9 47 f3 ff ff       	jmp    80105aaa <alltraps>

80106763 <vector201>:
.globl vector201
vector201:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $201
80106765:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010676a:	e9 3b f3 ff ff       	jmp    80105aaa <alltraps>

8010676f <vector202>:
.globl vector202
vector202:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $202
80106771:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106776:	e9 2f f3 ff ff       	jmp    80105aaa <alltraps>

8010677b <vector203>:
.globl vector203
vector203:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $203
8010677d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106782:	e9 23 f3 ff ff       	jmp    80105aaa <alltraps>

80106787 <vector204>:
.globl vector204
vector204:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $204
80106789:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010678e:	e9 17 f3 ff ff       	jmp    80105aaa <alltraps>

80106793 <vector205>:
.globl vector205
vector205:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $205
80106795:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010679a:	e9 0b f3 ff ff       	jmp    80105aaa <alltraps>

8010679f <vector206>:
.globl vector206
vector206:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $206
801067a1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067a6:	e9 ff f2 ff ff       	jmp    80105aaa <alltraps>

801067ab <vector207>:
.globl vector207
vector207:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $207
801067ad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801067b2:	e9 f3 f2 ff ff       	jmp    80105aaa <alltraps>

801067b7 <vector208>:
.globl vector208
vector208:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $208
801067b9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801067be:	e9 e7 f2 ff ff       	jmp    80105aaa <alltraps>

801067c3 <vector209>:
.globl vector209
vector209:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $209
801067c5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801067ca:	e9 db f2 ff ff       	jmp    80105aaa <alltraps>

801067cf <vector210>:
.globl vector210
vector210:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $210
801067d1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801067d6:	e9 cf f2 ff ff       	jmp    80105aaa <alltraps>

801067db <vector211>:
.globl vector211
vector211:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $211
801067dd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801067e2:	e9 c3 f2 ff ff       	jmp    80105aaa <alltraps>

801067e7 <vector212>:
.globl vector212
vector212:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $212
801067e9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801067ee:	e9 b7 f2 ff ff       	jmp    80105aaa <alltraps>

801067f3 <vector213>:
.globl vector213
vector213:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $213
801067f5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801067fa:	e9 ab f2 ff ff       	jmp    80105aaa <alltraps>

801067ff <vector214>:
.globl vector214
vector214:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $214
80106801:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106806:	e9 9f f2 ff ff       	jmp    80105aaa <alltraps>

8010680b <vector215>:
.globl vector215
vector215:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $215
8010680d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106812:	e9 93 f2 ff ff       	jmp    80105aaa <alltraps>

80106817 <vector216>:
.globl vector216
vector216:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $216
80106819:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010681e:	e9 87 f2 ff ff       	jmp    80105aaa <alltraps>

80106823 <vector217>:
.globl vector217
vector217:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $217
80106825:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010682a:	e9 7b f2 ff ff       	jmp    80105aaa <alltraps>

8010682f <vector218>:
.globl vector218
vector218:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $218
80106831:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106836:	e9 6f f2 ff ff       	jmp    80105aaa <alltraps>

8010683b <vector219>:
.globl vector219
vector219:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $219
8010683d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106842:	e9 63 f2 ff ff       	jmp    80105aaa <alltraps>

80106847 <vector220>:
.globl vector220
vector220:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $220
80106849:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010684e:	e9 57 f2 ff ff       	jmp    80105aaa <alltraps>

80106853 <vector221>:
.globl vector221
vector221:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $221
80106855:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010685a:	e9 4b f2 ff ff       	jmp    80105aaa <alltraps>

8010685f <vector222>:
.globl vector222
vector222:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $222
80106861:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106866:	e9 3f f2 ff ff       	jmp    80105aaa <alltraps>

8010686b <vector223>:
.globl vector223
vector223:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $223
8010686d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106872:	e9 33 f2 ff ff       	jmp    80105aaa <alltraps>

80106877 <vector224>:
.globl vector224
vector224:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $224
80106879:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010687e:	e9 27 f2 ff ff       	jmp    80105aaa <alltraps>

80106883 <vector225>:
.globl vector225
vector225:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $225
80106885:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010688a:	e9 1b f2 ff ff       	jmp    80105aaa <alltraps>

8010688f <vector226>:
.globl vector226
vector226:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $226
80106891:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106896:	e9 0f f2 ff ff       	jmp    80105aaa <alltraps>

8010689b <vector227>:
.globl vector227
vector227:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $227
8010689d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068a2:	e9 03 f2 ff ff       	jmp    80105aaa <alltraps>

801068a7 <vector228>:
.globl vector228
vector228:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $228
801068a9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801068ae:	e9 f7 f1 ff ff       	jmp    80105aaa <alltraps>

801068b3 <vector229>:
.globl vector229
vector229:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $229
801068b5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801068ba:	e9 eb f1 ff ff       	jmp    80105aaa <alltraps>

801068bf <vector230>:
.globl vector230
vector230:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $230
801068c1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801068c6:	e9 df f1 ff ff       	jmp    80105aaa <alltraps>

801068cb <vector231>:
.globl vector231
vector231:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $231
801068cd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801068d2:	e9 d3 f1 ff ff       	jmp    80105aaa <alltraps>

801068d7 <vector232>:
.globl vector232
vector232:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $232
801068d9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801068de:	e9 c7 f1 ff ff       	jmp    80105aaa <alltraps>

801068e3 <vector233>:
.globl vector233
vector233:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $233
801068e5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801068ea:	e9 bb f1 ff ff       	jmp    80105aaa <alltraps>

801068ef <vector234>:
.globl vector234
vector234:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $234
801068f1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801068f6:	e9 af f1 ff ff       	jmp    80105aaa <alltraps>

801068fb <vector235>:
.globl vector235
vector235:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $235
801068fd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106902:	e9 a3 f1 ff ff       	jmp    80105aaa <alltraps>

80106907 <vector236>:
.globl vector236
vector236:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $236
80106909:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010690e:	e9 97 f1 ff ff       	jmp    80105aaa <alltraps>

80106913 <vector237>:
.globl vector237
vector237:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $237
80106915:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010691a:	e9 8b f1 ff ff       	jmp    80105aaa <alltraps>

8010691f <vector238>:
.globl vector238
vector238:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $238
80106921:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106926:	e9 7f f1 ff ff       	jmp    80105aaa <alltraps>

8010692b <vector239>:
.globl vector239
vector239:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $239
8010692d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106932:	e9 73 f1 ff ff       	jmp    80105aaa <alltraps>

80106937 <vector240>:
.globl vector240
vector240:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $240
80106939:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010693e:	e9 67 f1 ff ff       	jmp    80105aaa <alltraps>

80106943 <vector241>:
.globl vector241
vector241:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $241
80106945:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010694a:	e9 5b f1 ff ff       	jmp    80105aaa <alltraps>

8010694f <vector242>:
.globl vector242
vector242:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $242
80106951:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106956:	e9 4f f1 ff ff       	jmp    80105aaa <alltraps>

8010695b <vector243>:
.globl vector243
vector243:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $243
8010695d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106962:	e9 43 f1 ff ff       	jmp    80105aaa <alltraps>

80106967 <vector244>:
.globl vector244
vector244:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $244
80106969:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010696e:	e9 37 f1 ff ff       	jmp    80105aaa <alltraps>

80106973 <vector245>:
.globl vector245
vector245:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $245
80106975:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010697a:	e9 2b f1 ff ff       	jmp    80105aaa <alltraps>

8010697f <vector246>:
.globl vector246
vector246:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $246
80106981:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106986:	e9 1f f1 ff ff       	jmp    80105aaa <alltraps>

8010698b <vector247>:
.globl vector247
vector247:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $247
8010698d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106992:	e9 13 f1 ff ff       	jmp    80105aaa <alltraps>

80106997 <vector248>:
.globl vector248
vector248:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $248
80106999:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010699e:	e9 07 f1 ff ff       	jmp    80105aaa <alltraps>

801069a3 <vector249>:
.globl vector249
vector249:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $249
801069a5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069aa:	e9 fb f0 ff ff       	jmp    80105aaa <alltraps>

801069af <vector250>:
.globl vector250
vector250:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $250
801069b1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801069b6:	e9 ef f0 ff ff       	jmp    80105aaa <alltraps>

801069bb <vector251>:
.globl vector251
vector251:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $251
801069bd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801069c2:	e9 e3 f0 ff ff       	jmp    80105aaa <alltraps>

801069c7 <vector252>:
.globl vector252
vector252:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $252
801069c9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801069ce:	e9 d7 f0 ff ff       	jmp    80105aaa <alltraps>

801069d3 <vector253>:
.globl vector253
vector253:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $253
801069d5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801069da:	e9 cb f0 ff ff       	jmp    80105aaa <alltraps>

801069df <vector254>:
.globl vector254
vector254:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $254
801069e1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801069e6:	e9 bf f0 ff ff       	jmp    80105aaa <alltraps>

801069eb <vector255>:
.globl vector255
vector255:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $255
801069ed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801069f2:	e9 b3 f0 ff ff       	jmp    80105aaa <alltraps>
801069f7:	66 90                	xchg   %ax,%ax
801069f9:	66 90                	xchg   %ax,%ax
801069fb:	66 90                	xchg   %ax,%ax
801069fd:	66 90                	xchg   %ax,%ax
801069ff:	90                   	nop

80106a00 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	57                   	push   %edi
80106a04:	56                   	push   %esi
80106a05:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106a06:	89 d3                	mov    %edx,%ebx
{
80106a08:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106a0a:	c1 eb 16             	shr    $0x16,%ebx
80106a0d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106a10:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106a13:	8b 06                	mov    (%esi),%eax
80106a15:	a8 01                	test   $0x1,%al
80106a17:	74 27                	je     80106a40 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a19:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a1e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106a24:	c1 ef 0a             	shr    $0xa,%edi
}
80106a27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106a2a:	89 fa                	mov    %edi,%edx
80106a2c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106a32:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106a35:	5b                   	pop    %ebx
80106a36:	5e                   	pop    %esi
80106a37:	5f                   	pop    %edi
80106a38:	5d                   	pop    %ebp
80106a39:	c3                   	ret    
80106a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a40:	85 c9                	test   %ecx,%ecx
80106a42:	74 2c                	je     80106a70 <walkpgdir+0x70>
80106a44:	e8 07 be ff ff       	call   80102850 <kalloc>
80106a49:	85 c0                	test   %eax,%eax
80106a4b:	89 c3                	mov    %eax,%ebx
80106a4d:	74 21                	je     80106a70 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106a4f:	83 ec 04             	sub    $0x4,%esp
80106a52:	68 00 10 00 00       	push   $0x1000
80106a57:	6a 00                	push   $0x0
80106a59:	50                   	push   %eax
80106a5a:	e8 31 de ff ff       	call   80104890 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a5f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a65:	83 c4 10             	add    $0x10,%esp
80106a68:	83 c8 07             	or     $0x7,%eax
80106a6b:	89 06                	mov    %eax,(%esi)
80106a6d:	eb b5                	jmp    80106a24 <walkpgdir+0x24>
80106a6f:	90                   	nop
}
80106a70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106a73:	31 c0                	xor    %eax,%eax
}
80106a75:	5b                   	pop    %ebx
80106a76:	5e                   	pop    %esi
80106a77:	5f                   	pop    %edi
80106a78:	5d                   	pop    %ebp
80106a79:	c3                   	ret    
80106a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a80 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	57                   	push   %edi
80106a84:	56                   	push   %esi
80106a85:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106a86:	89 d3                	mov    %edx,%ebx
80106a88:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106a8e:	83 ec 1c             	sub    $0x1c,%esp
80106a91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a94:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106a98:	8b 7d 08             	mov    0x8(%ebp),%edi
80106a9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106aa6:	29 df                	sub    %ebx,%edi
80106aa8:	83 c8 01             	or     $0x1,%eax
80106aab:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106aae:	eb 15                	jmp    80106ac5 <mappages+0x45>
    if(*pte & PTE_P)
80106ab0:	f6 00 01             	testb  $0x1,(%eax)
80106ab3:	75 45                	jne    80106afa <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106ab5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106ab8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106abb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106abd:	74 31                	je     80106af0 <mappages+0x70>
      break;
    a += PGSIZE;
80106abf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ac5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ac8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106acd:	89 da                	mov    %ebx,%edx
80106acf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106ad2:	e8 29 ff ff ff       	call   80106a00 <walkpgdir>
80106ad7:	85 c0                	test   %eax,%eax
80106ad9:	75 d5                	jne    80106ab0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106adb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ade:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ae3:	5b                   	pop    %ebx
80106ae4:	5e                   	pop    %esi
80106ae5:	5f                   	pop    %edi
80106ae6:	5d                   	pop    %ebp
80106ae7:	c3                   	ret    
80106ae8:	90                   	nop
80106ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106af3:	31 c0                	xor    %eax,%eax
}
80106af5:	5b                   	pop    %ebx
80106af6:	5e                   	pop    %esi
80106af7:	5f                   	pop    %edi
80106af8:	5d                   	pop    %ebp
80106af9:	c3                   	ret    
      panic("remap");
80106afa:	83 ec 0c             	sub    $0xc,%esp
80106afd:	68 24 7c 10 80       	push   $0x80107c24
80106b02:	e8 89 98 ff ff       	call   80100390 <panic>
80106b07:	89 f6                	mov    %esi,%esi
80106b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b10 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	57                   	push   %edi
80106b14:	56                   	push   %esi
80106b15:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b16:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b1c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106b1e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b24:	83 ec 1c             	sub    $0x1c,%esp
80106b27:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b2a:	39 d3                	cmp    %edx,%ebx
80106b2c:	73 66                	jae    80106b94 <deallocuvm.part.0+0x84>
80106b2e:	89 d6                	mov    %edx,%esi
80106b30:	eb 3d                	jmp    80106b6f <deallocuvm.part.0+0x5f>
80106b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106b38:	8b 10                	mov    (%eax),%edx
80106b3a:	f6 c2 01             	test   $0x1,%dl
80106b3d:	74 26                	je     80106b65 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106b3f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106b45:	74 58                	je     80106b9f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106b47:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106b4a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106b50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106b53:	52                   	push   %edx
80106b54:	e8 47 bb ff ff       	call   801026a0 <kfree>
      *pte = 0;
80106b59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b5c:	83 c4 10             	add    $0x10,%esp
80106b5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106b65:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b6b:	39 f3                	cmp    %esi,%ebx
80106b6d:	73 25                	jae    80106b94 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106b6f:	31 c9                	xor    %ecx,%ecx
80106b71:	89 da                	mov    %ebx,%edx
80106b73:	89 f8                	mov    %edi,%eax
80106b75:	e8 86 fe ff ff       	call   80106a00 <walkpgdir>
    if(!pte)
80106b7a:	85 c0                	test   %eax,%eax
80106b7c:	75 ba                	jne    80106b38 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b7e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106b84:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b8a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b90:	39 f3                	cmp    %esi,%ebx
80106b92:	72 db                	jb     80106b6f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106b94:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b9a:	5b                   	pop    %ebx
80106b9b:	5e                   	pop    %esi
80106b9c:	5f                   	pop    %edi
80106b9d:	5d                   	pop    %ebp
80106b9e:	c3                   	ret    
        panic("kfree");
80106b9f:	83 ec 0c             	sub    $0xc,%esp
80106ba2:	68 ea 75 10 80       	push   $0x801075ea
80106ba7:	e8 e4 97 ff ff       	call   80100390 <panic>
80106bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106bb0 <seginit>:
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106bb6:	e8 25 d0 ff ff       	call   80103be0 <cpuid>
80106bbb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106bc1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106bc6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106bca:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106bd1:	ff 00 00 
80106bd4:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106bdb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106bde:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106be5:	ff 00 00 
80106be8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106bef:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106bf2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106bf9:	ff 00 00 
80106bfc:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106c03:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c06:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106c0d:	ff 00 00 
80106c10:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106c17:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c1a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106c1f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c23:	c1 e8 10             	shr    $0x10,%eax
80106c26:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c2a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c2d:	0f 01 10             	lgdtl  (%eax)
}
80106c30:	c9                   	leave  
80106c31:	c3                   	ret    
80106c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c40 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c40:	a1 a4 f1 11 80       	mov    0x8011f1a4,%eax
{
80106c45:	55                   	push   %ebp
80106c46:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c48:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c4d:	0f 22 d8             	mov    %eax,%cr3
}
80106c50:	5d                   	pop    %ebp
80106c51:	c3                   	ret    
80106c52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c60 <switchuvm>:
{
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	57                   	push   %edi
80106c64:	56                   	push   %esi
80106c65:	53                   	push   %ebx
80106c66:	83 ec 1c             	sub    $0x1c,%esp
80106c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106c6c:	85 db                	test   %ebx,%ebx
80106c6e:	0f 84 cb 00 00 00    	je     80106d3f <switchuvm+0xdf>
  if(p->kstack == 0)
80106c74:	8b 43 08             	mov    0x8(%ebx),%eax
80106c77:	85 c0                	test   %eax,%eax
80106c79:	0f 84 da 00 00 00    	je     80106d59 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106c7f:	8b 43 04             	mov    0x4(%ebx),%eax
80106c82:	85 c0                	test   %eax,%eax
80106c84:	0f 84 c2 00 00 00    	je     80106d4c <switchuvm+0xec>
  pushcli();
80106c8a:	e8 21 da ff ff       	call   801046b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c8f:	e8 cc ce ff ff       	call   80103b60 <mycpu>
80106c94:	89 c6                	mov    %eax,%esi
80106c96:	e8 c5 ce ff ff       	call   80103b60 <mycpu>
80106c9b:	89 c7                	mov    %eax,%edi
80106c9d:	e8 be ce ff ff       	call   80103b60 <mycpu>
80106ca2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ca5:	83 c7 08             	add    $0x8,%edi
80106ca8:	e8 b3 ce ff ff       	call   80103b60 <mycpu>
80106cad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106cb0:	83 c0 08             	add    $0x8,%eax
80106cb3:	ba 67 00 00 00       	mov    $0x67,%edx
80106cb8:	c1 e8 18             	shr    $0x18,%eax
80106cbb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106cc2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106cc9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ccf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cd4:	83 c1 08             	add    $0x8,%ecx
80106cd7:	c1 e9 10             	shr    $0x10,%ecx
80106cda:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106ce0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ce5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106cec:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106cf1:	e8 6a ce ff ff       	call   80103b60 <mycpu>
80106cf6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106cfd:	e8 5e ce ff ff       	call   80103b60 <mycpu>
80106d02:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d06:	8b 73 08             	mov    0x8(%ebx),%esi
80106d09:	e8 52 ce ff ff       	call   80103b60 <mycpu>
80106d0e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d14:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d17:	e8 44 ce ff ff       	call   80103b60 <mycpu>
80106d1c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d20:	b8 28 00 00 00       	mov    $0x28,%eax
80106d25:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d28:	8b 43 04             	mov    0x4(%ebx),%eax
80106d2b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d30:	0f 22 d8             	mov    %eax,%cr3
}
80106d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d36:	5b                   	pop    %ebx
80106d37:	5e                   	pop    %esi
80106d38:	5f                   	pop    %edi
80106d39:	5d                   	pop    %ebp
  popcli();
80106d3a:	e9 b1 d9 ff ff       	jmp    801046f0 <popcli>
    panic("switchuvm: no process");
80106d3f:	83 ec 0c             	sub    $0xc,%esp
80106d42:	68 2a 7c 10 80       	push   $0x80107c2a
80106d47:	e8 44 96 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106d4c:	83 ec 0c             	sub    $0xc,%esp
80106d4f:	68 55 7c 10 80       	push   $0x80107c55
80106d54:	e8 37 96 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106d59:	83 ec 0c             	sub    $0xc,%esp
80106d5c:	68 40 7c 10 80       	push   $0x80107c40
80106d61:	e8 2a 96 ff ff       	call   80100390 <panic>
80106d66:	8d 76 00             	lea    0x0(%esi),%esi
80106d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d70 <inituvm>:
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	83 ec 1c             	sub    $0x1c,%esp
80106d79:	8b 75 10             	mov    0x10(%ebp),%esi
80106d7c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d7f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106d82:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106d88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d8b:	77 49                	ja     80106dd6 <inituvm+0x66>
  mem = kalloc();
80106d8d:	e8 be ba ff ff       	call   80102850 <kalloc>
  memset(mem, 0, PGSIZE);
80106d92:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106d95:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d97:	68 00 10 00 00       	push   $0x1000
80106d9c:	6a 00                	push   $0x0
80106d9e:	50                   	push   %eax
80106d9f:	e8 ec da ff ff       	call   80104890 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106da4:	58                   	pop    %eax
80106da5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106dab:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106db0:	5a                   	pop    %edx
80106db1:	6a 06                	push   $0x6
80106db3:	50                   	push   %eax
80106db4:	31 d2                	xor    %edx,%edx
80106db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106db9:	e8 c2 fc ff ff       	call   80106a80 <mappages>
  memmove(mem, init, sz);
80106dbe:	89 75 10             	mov    %esi,0x10(%ebp)
80106dc1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106dc4:	83 c4 10             	add    $0x10,%esp
80106dc7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dcd:	5b                   	pop    %ebx
80106dce:	5e                   	pop    %esi
80106dcf:	5f                   	pop    %edi
80106dd0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106dd1:	e9 6a db ff ff       	jmp    80104940 <memmove>
    panic("inituvm: more than a page");
80106dd6:	83 ec 0c             	sub    $0xc,%esp
80106dd9:	68 69 7c 10 80       	push   $0x80107c69
80106dde:	e8 ad 95 ff ff       	call   80100390 <panic>
80106de3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106df0 <loaduvm>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106df9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106e00:	0f 85 91 00 00 00    	jne    80106e97 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106e06:	8b 75 18             	mov    0x18(%ebp),%esi
80106e09:	31 db                	xor    %ebx,%ebx
80106e0b:	85 f6                	test   %esi,%esi
80106e0d:	75 1a                	jne    80106e29 <loaduvm+0x39>
80106e0f:	eb 6f                	jmp    80106e80 <loaduvm+0x90>
80106e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e18:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e1e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106e24:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106e27:	76 57                	jbe    80106e80 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e29:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2f:	31 c9                	xor    %ecx,%ecx
80106e31:	01 da                	add    %ebx,%edx
80106e33:	e8 c8 fb ff ff       	call   80106a00 <walkpgdir>
80106e38:	85 c0                	test   %eax,%eax
80106e3a:	74 4e                	je     80106e8a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106e3c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e3e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106e41:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106e46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106e4b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e51:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e54:	01 d9                	add    %ebx,%ecx
80106e56:	05 00 00 00 80       	add    $0x80000000,%eax
80106e5b:	57                   	push   %edi
80106e5c:	51                   	push   %ecx
80106e5d:	50                   	push   %eax
80106e5e:	ff 75 10             	pushl  0x10(%ebp)
80106e61:	e8 fa aa ff ff       	call   80101960 <readi>
80106e66:	83 c4 10             	add    $0x10,%esp
80106e69:	39 f8                	cmp    %edi,%eax
80106e6b:	74 ab                	je     80106e18 <loaduvm+0x28>
}
80106e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e75:	5b                   	pop    %ebx
80106e76:	5e                   	pop    %esi
80106e77:	5f                   	pop    %edi
80106e78:	5d                   	pop    %ebp
80106e79:	c3                   	ret    
80106e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e83:	31 c0                	xor    %eax,%eax
}
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret    
      panic("loaduvm: address should exist");
80106e8a:	83 ec 0c             	sub    $0xc,%esp
80106e8d:	68 83 7c 10 80       	push   $0x80107c83
80106e92:	e8 f9 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106e97:	83 ec 0c             	sub    $0xc,%esp
80106e9a:	68 24 7d 10 80       	push   $0x80107d24
80106e9f:	e8 ec 94 ff ff       	call   80100390 <panic>
80106ea4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106eaa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106eb0 <allocuvm>:
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	57                   	push   %edi
80106eb4:	56                   	push   %esi
80106eb5:	53                   	push   %ebx
80106eb6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106eb9:	8b 7d 10             	mov    0x10(%ebp),%edi
80106ebc:	85 ff                	test   %edi,%edi
80106ebe:	0f 88 8e 00 00 00    	js     80106f52 <allocuvm+0xa2>
  if(newsz < oldsz)
80106ec4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ec7:	0f 82 93 00 00 00    	jb     80106f60 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ed0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106ed6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106edc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106edf:	0f 86 7e 00 00 00    	jbe    80106f63 <allocuvm+0xb3>
80106ee5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106ee8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106eeb:	eb 42                	jmp    80106f2f <allocuvm+0x7f>
80106eed:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106ef0:	83 ec 04             	sub    $0x4,%esp
80106ef3:	68 00 10 00 00       	push   $0x1000
80106ef8:	6a 00                	push   $0x0
80106efa:	50                   	push   %eax
80106efb:	e8 90 d9 ff ff       	call   80104890 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f00:	58                   	pop    %eax
80106f01:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106f07:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f0c:	5a                   	pop    %edx
80106f0d:	6a 06                	push   $0x6
80106f0f:	50                   	push   %eax
80106f10:	89 da                	mov    %ebx,%edx
80106f12:	89 f8                	mov    %edi,%eax
80106f14:	e8 67 fb ff ff       	call   80106a80 <mappages>
80106f19:	83 c4 10             	add    $0x10,%esp
80106f1c:	85 c0                	test   %eax,%eax
80106f1e:	78 50                	js     80106f70 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106f20:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f26:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106f29:	0f 86 81 00 00 00    	jbe    80106fb0 <allocuvm+0x100>
    mem = kalloc();
80106f2f:	e8 1c b9 ff ff       	call   80102850 <kalloc>
    if(mem == 0){
80106f34:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106f36:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106f38:	75 b6                	jne    80106ef0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f3a:	83 ec 0c             	sub    $0xc,%esp
80106f3d:	68 a1 7c 10 80       	push   $0x80107ca1
80106f42:	e8 19 97 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106f47:	83 c4 10             	add    $0x10,%esp
80106f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f4d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f50:	77 6e                	ja     80106fc0 <allocuvm+0x110>
}
80106f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106f55:	31 ff                	xor    %edi,%edi
}
80106f57:	89 f8                	mov    %edi,%eax
80106f59:	5b                   	pop    %ebx
80106f5a:	5e                   	pop    %esi
80106f5b:	5f                   	pop    %edi
80106f5c:	5d                   	pop    %ebp
80106f5d:	c3                   	ret    
80106f5e:	66 90                	xchg   %ax,%ax
    return oldsz;
80106f60:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f66:	89 f8                	mov    %edi,%eax
80106f68:	5b                   	pop    %ebx
80106f69:	5e                   	pop    %esi
80106f6a:	5f                   	pop    %edi
80106f6b:	5d                   	pop    %ebp
80106f6c:	c3                   	ret    
80106f6d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106f70:	83 ec 0c             	sub    $0xc,%esp
80106f73:	68 b9 7c 10 80       	push   $0x80107cb9
80106f78:	e8 e3 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106f7d:	83 c4 10             	add    $0x10,%esp
80106f80:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f83:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f86:	76 0d                	jbe    80106f95 <allocuvm+0xe5>
80106f88:	89 c1                	mov    %eax,%ecx
80106f8a:	8b 55 10             	mov    0x10(%ebp),%edx
80106f8d:	8b 45 08             	mov    0x8(%ebp),%eax
80106f90:	e8 7b fb ff ff       	call   80106b10 <deallocuvm.part.0>
      kfree(mem);
80106f95:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106f98:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106f9a:	56                   	push   %esi
80106f9b:	e8 00 b7 ff ff       	call   801026a0 <kfree>
      return 0;
80106fa0:	83 c4 10             	add    $0x10,%esp
}
80106fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fa6:	89 f8                	mov    %edi,%eax
80106fa8:	5b                   	pop    %ebx
80106fa9:	5e                   	pop    %esi
80106faa:	5f                   	pop    %edi
80106fab:	5d                   	pop    %ebp
80106fac:	c3                   	ret    
80106fad:	8d 76 00             	lea    0x0(%esi),%esi
80106fb0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fb6:	5b                   	pop    %ebx
80106fb7:	89 f8                	mov    %edi,%eax
80106fb9:	5e                   	pop    %esi
80106fba:	5f                   	pop    %edi
80106fbb:	5d                   	pop    %ebp
80106fbc:	c3                   	ret    
80106fbd:	8d 76 00             	lea    0x0(%esi),%esi
80106fc0:	89 c1                	mov    %eax,%ecx
80106fc2:	8b 55 10             	mov    0x10(%ebp),%edx
80106fc5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106fc8:	31 ff                	xor    %edi,%edi
80106fca:	e8 41 fb ff ff       	call   80106b10 <deallocuvm.part.0>
80106fcf:	eb 92                	jmp    80106f63 <allocuvm+0xb3>
80106fd1:	eb 0d                	jmp    80106fe0 <deallocuvm>
80106fd3:	90                   	nop
80106fd4:	90                   	nop
80106fd5:	90                   	nop
80106fd6:	90                   	nop
80106fd7:	90                   	nop
80106fd8:	90                   	nop
80106fd9:	90                   	nop
80106fda:	90                   	nop
80106fdb:	90                   	nop
80106fdc:	90                   	nop
80106fdd:	90                   	nop
80106fde:	90                   	nop
80106fdf:	90                   	nop

80106fe0 <deallocuvm>:
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fe6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106fec:	39 d1                	cmp    %edx,%ecx
80106fee:	73 10                	jae    80107000 <deallocuvm+0x20>
}
80106ff0:	5d                   	pop    %ebp
80106ff1:	e9 1a fb ff ff       	jmp    80106b10 <deallocuvm.part.0>
80106ff6:	8d 76 00             	lea    0x0(%esi),%esi
80106ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107000:	89 d0                	mov    %edx,%eax
80107002:	5d                   	pop    %ebp
80107003:	c3                   	ret    
80107004:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010700a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107010 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 0c             	sub    $0xc,%esp
80107019:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010701c:	85 f6                	test   %esi,%esi
8010701e:	74 59                	je     80107079 <freevm+0x69>
80107020:	31 c9                	xor    %ecx,%ecx
80107022:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107027:	89 f0                	mov    %esi,%eax
80107029:	e8 e2 fa ff ff       	call   80106b10 <deallocuvm.part.0>
8010702e:	89 f3                	mov    %esi,%ebx
80107030:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107036:	eb 0f                	jmp    80107047 <freevm+0x37>
80107038:	90                   	nop
80107039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107040:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107043:	39 fb                	cmp    %edi,%ebx
80107045:	74 23                	je     8010706a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107047:	8b 03                	mov    (%ebx),%eax
80107049:	a8 01                	test   $0x1,%al
8010704b:	74 f3                	je     80107040 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010704d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107052:	83 ec 0c             	sub    $0xc,%esp
80107055:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107058:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010705d:	50                   	push   %eax
8010705e:	e8 3d b6 ff ff       	call   801026a0 <kfree>
80107063:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107066:	39 fb                	cmp    %edi,%ebx
80107068:	75 dd                	jne    80107047 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010706a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010706d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107070:	5b                   	pop    %ebx
80107071:	5e                   	pop    %esi
80107072:	5f                   	pop    %edi
80107073:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107074:	e9 27 b6 ff ff       	jmp    801026a0 <kfree>
    panic("freevm: no pgdir");
80107079:	83 ec 0c             	sub    $0xc,%esp
8010707c:	68 d5 7c 10 80       	push   $0x80107cd5
80107081:	e8 0a 93 ff ff       	call   80100390 <panic>
80107086:	8d 76 00             	lea    0x0(%esi),%esi
80107089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107090 <setupkvm>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	56                   	push   %esi
80107094:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107095:	e8 b6 b7 ff ff       	call   80102850 <kalloc>
8010709a:	85 c0                	test   %eax,%eax
8010709c:	89 c6                	mov    %eax,%esi
8010709e:	74 42                	je     801070e2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801070a0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070a3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801070a8:	68 00 10 00 00       	push   $0x1000
801070ad:	6a 00                	push   $0x0
801070af:	50                   	push   %eax
801070b0:	e8 db d7 ff ff       	call   80104890 <memset>
801070b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801070b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801070bb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801070be:	83 ec 08             	sub    $0x8,%esp
801070c1:	8b 13                	mov    (%ebx),%edx
801070c3:	ff 73 0c             	pushl  0xc(%ebx)
801070c6:	50                   	push   %eax
801070c7:	29 c1                	sub    %eax,%ecx
801070c9:	89 f0                	mov    %esi,%eax
801070cb:	e8 b0 f9 ff ff       	call   80106a80 <mappages>
801070d0:	83 c4 10             	add    $0x10,%esp
801070d3:	85 c0                	test   %eax,%eax
801070d5:	78 19                	js     801070f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070d7:	83 c3 10             	add    $0x10,%ebx
801070da:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801070e0:	75 d6                	jne    801070b8 <setupkvm+0x28>
}
801070e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801070e5:	89 f0                	mov    %esi,%eax
801070e7:	5b                   	pop    %ebx
801070e8:	5e                   	pop    %esi
801070e9:	5d                   	pop    %ebp
801070ea:	c3                   	ret    
801070eb:	90                   	nop
801070ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801070f0:	83 ec 0c             	sub    $0xc,%esp
801070f3:	56                   	push   %esi
      return 0;
801070f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801070f6:	e8 15 ff ff ff       	call   80107010 <freevm>
      return 0;
801070fb:	83 c4 10             	add    $0x10,%esp
}
801070fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107101:	89 f0                	mov    %esi,%eax
80107103:	5b                   	pop    %ebx
80107104:	5e                   	pop    %esi
80107105:	5d                   	pop    %ebp
80107106:	c3                   	ret    
80107107:	89 f6                	mov    %esi,%esi
80107109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107110 <kvmalloc>:
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107116:	e8 75 ff ff ff       	call   80107090 <setupkvm>
8010711b:	a3 a4 f1 11 80       	mov    %eax,0x8011f1a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107120:	05 00 00 00 80       	add    $0x80000000,%eax
80107125:	0f 22 d8             	mov    %eax,%cr3
}
80107128:	c9                   	leave  
80107129:	c3                   	ret    
8010712a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107130 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107130:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107131:	31 c9                	xor    %ecx,%ecx
{
80107133:	89 e5                	mov    %esp,%ebp
80107135:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107138:	8b 55 0c             	mov    0xc(%ebp),%edx
8010713b:	8b 45 08             	mov    0x8(%ebp),%eax
8010713e:	e8 bd f8 ff ff       	call   80106a00 <walkpgdir>
  if(pte == 0)
80107143:	85 c0                	test   %eax,%eax
80107145:	74 05                	je     8010714c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107147:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010714a:	c9                   	leave  
8010714b:	c3                   	ret    
    panic("clearpteu");
8010714c:	83 ec 0c             	sub    $0xc,%esp
8010714f:	68 e6 7c 10 80       	push   $0x80107ce6
80107154:	e8 37 92 ff ff       	call   80100390 <panic>
80107159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107160 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	57                   	push   %edi
80107164:	56                   	push   %esi
80107165:	53                   	push   %ebx
80107166:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107169:	e8 22 ff ff ff       	call   80107090 <setupkvm>
8010716e:	85 c0                	test   %eax,%eax
80107170:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107173:	0f 84 9f 00 00 00    	je     80107218 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107179:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010717c:	85 c9                	test   %ecx,%ecx
8010717e:	0f 84 94 00 00 00    	je     80107218 <copyuvm+0xb8>
80107184:	31 ff                	xor    %edi,%edi
80107186:	eb 4a                	jmp    801071d2 <copyuvm+0x72>
80107188:	90                   	nop
80107189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107190:	83 ec 04             	sub    $0x4,%esp
80107193:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107199:	68 00 10 00 00       	push   $0x1000
8010719e:	53                   	push   %ebx
8010719f:	50                   	push   %eax
801071a0:	e8 9b d7 ff ff       	call   80104940 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801071a5:	58                   	pop    %eax
801071a6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801071ac:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071b1:	5a                   	pop    %edx
801071b2:	ff 75 e4             	pushl  -0x1c(%ebp)
801071b5:	50                   	push   %eax
801071b6:	89 fa                	mov    %edi,%edx
801071b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071bb:	e8 c0 f8 ff ff       	call   80106a80 <mappages>
801071c0:	83 c4 10             	add    $0x10,%esp
801071c3:	85 c0                	test   %eax,%eax
801071c5:	78 61                	js     80107228 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801071c7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801071cd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801071d0:	76 46                	jbe    80107218 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801071d2:	8b 45 08             	mov    0x8(%ebp),%eax
801071d5:	31 c9                	xor    %ecx,%ecx
801071d7:	89 fa                	mov    %edi,%edx
801071d9:	e8 22 f8 ff ff       	call   80106a00 <walkpgdir>
801071de:	85 c0                	test   %eax,%eax
801071e0:	74 61                	je     80107243 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801071e2:	8b 00                	mov    (%eax),%eax
801071e4:	a8 01                	test   $0x1,%al
801071e6:	74 4e                	je     80107236 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801071e8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801071ea:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801071ef:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801071f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801071f8:	e8 53 b6 ff ff       	call   80102850 <kalloc>
801071fd:	85 c0                	test   %eax,%eax
801071ff:	89 c6                	mov    %eax,%esi
80107201:	75 8d                	jne    80107190 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107203:	83 ec 0c             	sub    $0xc,%esp
80107206:	ff 75 e0             	pushl  -0x20(%ebp)
80107209:	e8 02 fe ff ff       	call   80107010 <freevm>
  return 0;
8010720e:	83 c4 10             	add    $0x10,%esp
80107211:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107218:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010721b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010721e:	5b                   	pop    %ebx
8010721f:	5e                   	pop    %esi
80107220:	5f                   	pop    %edi
80107221:	5d                   	pop    %ebp
80107222:	c3                   	ret    
80107223:	90                   	nop
80107224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107228:	83 ec 0c             	sub    $0xc,%esp
8010722b:	56                   	push   %esi
8010722c:	e8 6f b4 ff ff       	call   801026a0 <kfree>
      goto bad;
80107231:	83 c4 10             	add    $0x10,%esp
80107234:	eb cd                	jmp    80107203 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107236:	83 ec 0c             	sub    $0xc,%esp
80107239:	68 0a 7d 10 80       	push   $0x80107d0a
8010723e:	e8 4d 91 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107243:	83 ec 0c             	sub    $0xc,%esp
80107246:	68 f0 7c 10 80       	push   $0x80107cf0
8010724b:	e8 40 91 ff ff       	call   80100390 <panic>

80107250 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107250:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107251:	31 c9                	xor    %ecx,%ecx
{
80107253:	89 e5                	mov    %esp,%ebp
80107255:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107258:	8b 55 0c             	mov    0xc(%ebp),%edx
8010725b:	8b 45 08             	mov    0x8(%ebp),%eax
8010725e:	e8 9d f7 ff ff       	call   80106a00 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107263:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107265:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107266:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107268:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010726d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107270:	05 00 00 00 80       	add    $0x80000000,%eax
80107275:	83 fa 05             	cmp    $0x5,%edx
80107278:	ba 00 00 00 00       	mov    $0x0,%edx
8010727d:	0f 45 c2             	cmovne %edx,%eax
}
80107280:	c3                   	ret    
80107281:	eb 0d                	jmp    80107290 <copyout>
80107283:	90                   	nop
80107284:	90                   	nop
80107285:	90                   	nop
80107286:	90                   	nop
80107287:	90                   	nop
80107288:	90                   	nop
80107289:	90                   	nop
8010728a:	90                   	nop
8010728b:	90                   	nop
8010728c:	90                   	nop
8010728d:	90                   	nop
8010728e:	90                   	nop
8010728f:	90                   	nop

80107290 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	56                   	push   %esi
80107295:	53                   	push   %ebx
80107296:	83 ec 1c             	sub    $0x1c,%esp
80107299:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010729c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010729f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801072a2:	85 db                	test   %ebx,%ebx
801072a4:	75 40                	jne    801072e6 <copyout+0x56>
801072a6:	eb 70                	jmp    80107318 <copyout+0x88>
801072a8:	90                   	nop
801072a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801072b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801072b3:	89 f1                	mov    %esi,%ecx
801072b5:	29 d1                	sub    %edx,%ecx
801072b7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801072bd:	39 d9                	cmp    %ebx,%ecx
801072bf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801072c2:	29 f2                	sub    %esi,%edx
801072c4:	83 ec 04             	sub    $0x4,%esp
801072c7:	01 d0                	add    %edx,%eax
801072c9:	51                   	push   %ecx
801072ca:	57                   	push   %edi
801072cb:	50                   	push   %eax
801072cc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801072cf:	e8 6c d6 ff ff       	call   80104940 <memmove>
    len -= n;
    buf += n;
801072d4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801072d7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801072da:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801072e0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801072e2:	29 cb                	sub    %ecx,%ebx
801072e4:	74 32                	je     80107318 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801072e6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801072e8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801072eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801072ee:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801072f4:	56                   	push   %esi
801072f5:	ff 75 08             	pushl  0x8(%ebp)
801072f8:	e8 53 ff ff ff       	call   80107250 <uva2ka>
    if(pa0 == 0)
801072fd:	83 c4 10             	add    $0x10,%esp
80107300:	85 c0                	test   %eax,%eax
80107302:	75 ac                	jne    801072b0 <copyout+0x20>
  }
  return 0;
}
80107304:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107307:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010730c:	5b                   	pop    %ebx
8010730d:	5e                   	pop    %esi
8010730e:	5f                   	pop    %edi
8010730f:	5d                   	pop    %ebp
80107310:	c3                   	ret    
80107311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107318:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010731b:	31 c0                	xor    %eax,%eax
}
8010731d:	5b                   	pop    %ebx
8010731e:	5e                   	pop    %esi
8010731f:	5f                   	pop    %edi
80107320:	5d                   	pop    %ebp
80107321:	c3                   	ret    
