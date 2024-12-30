
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
80100028:	bc 90 c6 10 80       	mov    $0x8010c690,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
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
80100044:	bb d4 c6 10 80       	mov    $0x8010c6d4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 78 10 80       	push   $0x801078c0
80100051:	68 a0 c6 10 80       	push   $0x8010c6a0
80100056:	e8 55 4a 00 00       	call   80104ab0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 ec 0d 11 80 9c 	movl   $0x80110d9c,0x80110dec
80100062:	0d 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 f0 0d 11 80 9c 	movl   $0x80110d9c,0x80110df0
8010006c:	0d 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 9c 0d 11 80       	mov    $0x80110d9c,%edx
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
8010008b:	c7 43 50 9c 0d 11 80 	movl   $0x80110d9c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 78 10 80       	push   $0x801078c7
80100097:	50                   	push   %eax
80100098:	e8 e3 48 00 00       	call   80104980 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 f0 0d 11 80       	mov    0x80110df0,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d f0 0d 11 80    	mov    %ebx,0x80110df0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 9c 0d 11 80       	cmp    $0x80110d9c,%eax
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
801000df:	68 a0 c6 10 80       	push   $0x8010c6a0
801000e4:	e8 07 4b 00 00       	call   80104bf0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d f0 0d 11 80    	mov    0x80110df0,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 9c 0d 11 80    	cmp    $0x80110d9c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 9c 0d 11 80    	cmp    $0x80110d9c,%ebx
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
80100120:	8b 1d ec 0d 11 80    	mov    0x80110dec,%ebx
80100126:	81 fb 9c 0d 11 80    	cmp    $0x80110d9c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 9c 0d 11 80    	cmp    $0x80110d9c,%ebx
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
8010015d:	68 a0 c6 10 80       	push   $0x8010c6a0
80100162:	e8 49 4b 00 00       	call   80104cb0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 48 00 00       	call   801049c0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
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
80100193:	68 ce 78 10 80       	push   $0x801078ce
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
801001ae:	e8 ad 48 00 00       	call   80104a60 <holdingsleep>
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
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 78 10 80       	push   $0x801078df
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
801001ef:	e8 6c 48 00 00       	call   80104a60 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 48 00 00       	call   80104a20 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 a0 c6 10 80 	movl   $0x8010c6a0,(%esp)
8010020b:	e8 e0 49 00 00       	call   80104bf0 <acquire>
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
80100232:	a1 f0 0d 11 80       	mov    0x80110df0,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 9c 0d 11 80 	movl   $0x80110d9c,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 f0 0d 11 80       	mov    0x80110df0,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d f0 0d 11 80    	mov    %ebx,0x80110df0
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 a0 c6 10 80 	movl   $0x8010c6a0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 4f 4a 00 00       	jmp    80104cb0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 78 10 80       	push   $0x801078e6
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
80100285:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010028c:	e8 5f 49 00 00       	call   80104bf0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 80 10 11 80    	mov    0x80111080,%edx
801002a7:	39 15 84 10 11 80    	cmp    %edx,0x80111084
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
801002bb:	68 e0 b5 10 80       	push   $0x8010b5e0
801002c0:	68 80 10 11 80       	push   $0x80111080
801002c5:	e8 36 3e 00 00       	call   80104100 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 80 10 11 80    	mov    0x80111080,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 84 10 11 80    	cmp    0x80111084,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 30 36 00 00       	call   80103910 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 e0 b5 10 80       	push   $0x8010b5e0
801002ef:	e8 bc 49 00 00       	call   80104cb0 <release>
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
80100313:	a3 80 10 11 80       	mov    %eax,0x80111080
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 00 10 11 80 	movsbl -0x7feef000(%eax),%eax
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
80100348:	68 e0 b5 10 80       	push   $0x8010b5e0
8010034d:	e8 5e 49 00 00       	call   80104cb0 <release>
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
80100372:	89 15 80 10 11 80    	mov    %edx,0x80111080
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
80100399:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 78 10 80       	push   $0x801078ed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 03 83 10 80 	movl   $0x80108303,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 f3 46 00 00       	call   80104ad0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 79 10 80       	push   $0x80107901
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 18 b6 10 80 01 	movl   $0x1,0x8010b618
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 18 b6 10 80    	mov    0x8010b618,%ecx
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
8010043a:	e8 91 60 00 00       	call   801064d0 <uartputc>
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
801004ec:	e8 df 5f 00 00       	call   801064d0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 d3 5f 00 00       	call   801064d0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 c7 5f 00 00       	call   801064d0 <uartputc>
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
80100524:	e8 87 48 00 00       	call   80104db0 <memmove>
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
80100541:	e8 ba 47 00 00       	call   80104d00 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 79 10 80       	push   $0x80107905
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
801005b1:	0f b6 92 30 79 10 80 	movzbl -0x7fef86d0(%edx),%edx
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
80100614:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010061b:	e8 d0 45 00 00       	call   80104bf0 <acquire>
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
80100642:	68 e0 b5 10 80       	push   $0x8010b5e0
80100647:	e8 64 46 00 00       	call   80104cb0 <release>
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
80100669:	a1 14 b6 10 80       	mov    0x8010b614,%eax
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
8010071a:	68 e0 b5 10 80       	push   $0x8010b5e0
8010071f:	e8 8c 45 00 00       	call   80104cb0 <release>
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
801007d0:	ba 18 79 10 80       	mov    $0x80107918,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 e0 b5 10 80       	push   $0x8010b5e0
801007f0:	e8 fb 43 00 00       	call   80104bf0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 79 10 80       	push   $0x8010791f
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
8010081e:	68 e0 b5 10 80       	push   $0x8010b5e0
80100823:	e8 c8 43 00 00       	call   80104bf0 <acquire>
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
80100851:	a1 88 10 11 80       	mov    0x80111088,%eax
80100856:	3b 05 84 10 11 80    	cmp    0x80111084,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 88 10 11 80       	mov    %eax,0x80111088
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
80100883:	68 e0 b5 10 80       	push   $0x8010b5e0
80100888:	e8 23 44 00 00       	call   80104cb0 <release>
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
801008a9:	a1 88 10 11 80       	mov    0x80111088,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 80 10 11 80    	sub    0x80111080,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 88 10 11 80    	mov    %edx,0x80111088
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 00 10 11 80    	mov    %cl,-0x7feef000(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 80 10 11 80       	mov    0x80111080,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 88 10 11 80    	cmp    %eax,0x80111088
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 84 10 11 80       	mov    %eax,0x80111084
          wakeup(&input.r);
80100911:	68 80 10 11 80       	push   $0x80111080
80100916:	e8 35 3a 00 00       	call   80104350 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 88 10 11 80       	mov    0x80111088,%eax
8010093d:	39 05 84 10 11 80    	cmp    %eax,0x80111084
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 88 10 11 80       	mov    %eax,0x80111088
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 88 10 11 80       	mov    0x80111088,%eax
80100964:	3b 05 84 10 11 80    	cmp    0x80111084,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 00 10 11 80 0a 	cmpb   $0xa,-0x7feef000(%edx)
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
80100997:	e9 64 3a 00 00       	jmp    80104400 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 00 10 11 80 0a 	movb   $0xa,-0x7feef000(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 88 10 11 80       	mov    0x80111088,%eax
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
801009c6:	68 28 79 10 80       	push   $0x80107928
801009cb:	68 e0 b5 10 80       	push   $0x8010b5e0
801009d0:	e8 db 40 00 00       	call   80104ab0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 4c 1a 11 80 00 	movl   $0x80100600,0x80111a4c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 48 1a 11 80 70 	movl   $0x80100270,0x80111a48
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
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
80100a1c:	e8 ef 2e 00 00       	call   80103910 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>

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
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
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
80100a94:	e8 87 6b 00 00       	call   80107620 <setupkvm>
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
80100af6:	e8 45 69 00 00       	call   80107440 <allocuvm>
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
80100b28:	e8 53 68 00 00       	call   80107380 <loaduvm>
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
80100b72:	e8 29 6a 00 00       	call   801075a0 <freevm>
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
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 91 68 00 00       	call   80107440 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 da 69 00 00       	call   801075a0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 41 79 10 80       	push   $0x80107941
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
80100c06:	e8 b5 6a 00 00       	call   801076c0 <clearpteu>
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
80100c39:	e8 e2 42 00 00       	call   80104f20 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 cf 42 00 00       	call   80104f20 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 be 6b 00 00       	call   80107820 <copyout>
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
80100cc7:	e8 54 6b 00 00       	call   80107820 <copyout>
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
80100d0a:	e8 d1 41 00 00       	call   80104ee0 <safestrcpy>
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
80100d34:	e8 b7 64 00 00       	call   801071f0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 5f 68 00 00       	call   801075a0 <freevm>
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
80100d66:	68 4d 79 10 80       	push   $0x8010794d
80100d6b:	68 a0 10 11 80       	push   $0x801110a0
80100d70:	e8 3b 3d 00 00       	call   80104ab0 <initlock>
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
80100d84:	bb d4 10 11 80       	mov    $0x801110d4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 a0 10 11 80       	push   $0x801110a0
80100d91:	e8 5a 3e 00 00       	call   80104bf0 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 34 1a 11 80    	cmp    $0x80111a34,%ebx
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
80100dbc:	68 a0 10 11 80       	push   $0x801110a0
80100dc1:	e8 ea 3e 00 00       	call   80104cb0 <release>
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
80100dd5:	68 a0 10 11 80       	push   $0x801110a0
80100dda:	e8 d1 3e 00 00       	call   80104cb0 <release>
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
80100dfa:	68 a0 10 11 80       	push   $0x801110a0
80100dff:	e8 ec 3d 00 00       	call   80104bf0 <acquire>
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
80100e17:	68 a0 10 11 80       	push   $0x801110a0
80100e1c:	e8 8f 3e 00 00       	call   80104cb0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 54 79 10 80       	push   $0x80107954
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
80100e4c:	68 a0 10 11 80       	push   $0x801110a0
80100e51:	e8 9a 3d 00 00       	call   80104bf0 <acquire>
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
80100e6e:	c7 45 08 a0 10 11 80 	movl   $0x801110a0,0x8(%ebp)
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
80100e7c:	e9 2f 3e 00 00       	jmp    80104cb0 <release>
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
80100ea0:	68 a0 10 11 80       	push   $0x801110a0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 03 3e 00 00       	call   80104cb0 <release>
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
80100ed1:	e8 7a 24 00 00       	call   80103350 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
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
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 5c 79 10 80       	push   $0x8010795c
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
80100fcd:	e9 2e 25 00 00       	jmp    80103500 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 66 79 10 80       	push   $0x80107966
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
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
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
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
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
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
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
801010ed:	e9 fe 22 00 00       	jmp    801033f0 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 6f 79 10 80       	push   $0x8010796f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 75 79 10 80       	push   $0x80107975
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
8010111a:	03 15 b8 1a 11 80    	add    0x80111ab8,%edx
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
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
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
80101173:	68 7f 79 10 80       	push   $0x8010797f
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
80101189:	8b 0d a0 1a 11 80    	mov    0x80111aa0,%ecx
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
801011ac:	03 05 b8 1a 11 80    	add    0x80111ab8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 a0 1a 11 80       	mov    0x80111aa0,%eax
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
80101219:	39 05 a0 1a 11 80    	cmp    %eax,0x80111aa0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 92 79 10 80       	push   $0x80107992
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
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
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
80101265:	e8 96 3a 00 00       	call   80104d00 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
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
8010129a:	bb f4 1a 11 80       	mov    $0x80111af4,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 c0 1a 11 80       	push   $0x80111ac0
801012aa:	e8 41 39 00 00       	call   80104bf0 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 14 37 11 80    	cmp    $0x80113714,%ebx
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
801012e8:	81 fb 14 37 11 80    	cmp    $0x80113714,%ebx
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
8010130a:	68 c0 1a 11 80       	push   $0x80111ac0
8010130f:	e8 9c 39 00 00       	call   80104cb0 <release>

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
80101335:	68 c0 1a 11 80       	push   $0x80111ac0
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 6e 39 00 00       	call   80104cb0 <release>
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
80101352:	68 a8 79 10 80       	push   $0x801079a8
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
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
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
80101427:	68 b8 79 10 80       	push   $0x801079b8
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
80101461:	e8 4a 39 00 00       	call   80104db0 <memmove>
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
80101484:	bb 00 1b 11 80       	mov    $0x80111b00,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 cb 79 10 80       	push   $0x801079cb
80101491:	68 c0 1a 11 80       	push   $0x80111ac0
80101496:	e8 15 36 00 00       	call   80104ab0 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 d2 79 10 80       	push   $0x801079d2
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 cc 34 00 00       	call   80104980 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 20 37 11 80    	cmp    $0x80113720,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 a0 1a 11 80       	push   $0x80111aa0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 b8 1a 11 80    	pushl  0x80111ab8
801014d5:	ff 35 b4 1a 11 80    	pushl  0x80111ab4
801014db:	ff 35 b0 1a 11 80    	pushl  0x80111ab0
801014e1:	ff 35 ac 1a 11 80    	pushl  0x80111aac
801014e7:	ff 35 a8 1a 11 80    	pushl  0x80111aa8
801014ed:	ff 35 a4 1a 11 80    	pushl  0x80111aa4
801014f3:	ff 35 a0 1a 11 80    	pushl  0x80111aa0
801014f9:	68 38 7a 10 80       	push   $0x80107a38
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
80101519:	83 3d a8 1a 11 80 01 	cmpl   $0x1,0x80111aa8
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
8010154f:	39 1d a8 1a 11 80    	cmp    %ebx,0x80111aa8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 b4 1a 11 80    	add    0x80111ab4,%eax
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
8010158e:	e8 6d 37 00 00       	call   80104d00 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
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
801015c3:	68 d8 79 10 80       	push   $0x801079d8
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
801015e4:	03 05 b4 1a 11 80    	add    0x80111ab4,%eax
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
80101631:	e8 7a 37 00 00       	call   80104db0 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
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
8010165a:	68 c0 1a 11 80       	push   $0x80111ac0
8010165f:	e8 8c 35 00 00       	call   80104bf0 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 c0 1a 11 80 	movl   $0x80111ac0,(%esp)
8010166f:	e8 3c 36 00 00       	call   80104cb0 <release>
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
801016a2:	e8 19 33 00 00       	call   801049c0 <acquiresleep>
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
801016c9:	03 05 b4 1a 11 80    	add    0x80111ab4,%eax
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
80101718:	e8 93 36 00 00       	call   80104db0 <memmove>
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
8010173d:	68 f0 79 10 80       	push   $0x801079f0
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 ea 79 10 80       	push   $0x801079ea
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
80101773:	e8 e8 32 00 00       	call   80104a60 <holdingsleep>
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
8010178f:	e9 8c 32 00 00       	jmp    80104a20 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 ff 79 10 80       	push   $0x801079ff
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
801017c0:	e8 fb 31 00 00       	call   801049c0 <acquiresleep>
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
801017da:	e8 41 32 00 00       	call   80104a20 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 c0 1a 11 80 	movl   $0x80111ac0,(%esp)
801017e6:	e8 05 34 00 00       	call   80104bf0 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 c0 1a 11 80 	movl   $0x80111ac0,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 ab 34 00 00       	jmp    80104cb0 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 c0 1a 11 80       	push   $0x80111ac0
80101810:	e8 db 33 00 00       	call   80104bf0 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 c0 1a 11 80 	movl   $0x80111ac0,(%esp)
8010181f:	e8 8c 34 00 00       	call   80104cb0 <release>
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
80101a07:	e8 a4 33 00 00       	call   80104db0 <memmove>
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
80101a3a:	8b 04 c5 40 1a 11 80 	mov    -0x7feee5c0(,%eax,8),%eax
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
80101b03:	e8 a8 32 00 00       	call   80104db0 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
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
80101b4a:	8b 04 c5 44 1a 11 80 	mov    -0x7feee5bc(,%eax,8),%eax
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
80101b9e:	e8 7d 32 00 00       	call   80104e20 <strncmp>
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
80101bfd:	e8 1e 32 00 00       	call   80104e20 <strncmp>
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
80101c42:	68 19 7a 10 80       	push   $0x80107a19
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 07 7a 10 80       	push   $0x80107a07
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
80101c79:	e8 92 1c 00 00       	call   80103910 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 c0 1a 11 80       	push   $0x80111ac0
80101c89:	e8 62 2f 00 00       	call   80104bf0 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 c0 1a 11 80 	movl   $0x80111ac0,(%esp)
80101c99:	e8 12 30 00 00       	call   80104cb0 <release>
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
80101cf5:	e8 b6 30 00 00       	call   80104db0 <memmove>
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
80101d88:	e8 23 30 00 00       	call   80104db0 <memmove>
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
80101e7d:	e8 fe 2f 00 00       	call   80104e80 <strncpy>
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
80101ebb:	68 28 7a 10 80       	push   $0x80107a28
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 ee 80 10 80       	push   $0x801080ee
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
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
    panic("incorrect blockno");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 94 7a 10 80       	push   $0x80107a94
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 8b 7a 10 80       	push   $0x80107a8b
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 a6 7a 10 80       	push   $0x80107aa6
8010200b:	68 40 b6 10 80       	push   $0x8010b640
80102010:	e8 9b 2a 00 00       	call   80104ab0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 e0 3d 11 80       	mov    0x80113de0,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
  for(i=0; i<1000; i++){
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
      havedisk1 = 1;
8010205a:	c7 05 20 b6 10 80 01 	movl   $0x1,0x8010b620
80102061:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
}
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	68 40 b6 10 80       	push   $0x8010b640
8010208e:	e8 5d 2b 00 00       	call   80104bf0 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d 24 b6 10 80    	mov    0x8010b624,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 24 b6 10 80       	mov    %eax,0x8010b624

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020f0:	53                   	push   %ebx
801020f1:	e8 5a 22 00 00       	call   80104350 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 24 b6 10 80       	mov    0x8010b624,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 40 b6 10 80       	push   $0x8010b640
8010210f:	e8 9c 2b 00 00       	call   80104cb0 <release>

  release(&idelock);
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 2d 29 00 00       	call   80104a60 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 20 b6 10 80       	mov    0x8010b620,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 40 b6 10 80       	push   $0x8010b640
80102168:	e8 83 2a 00 00       	call   80104bf0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 24 b6 10 80    	mov    0x8010b624,%edx
80102173:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102194:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102196:	39 1d 24 b6 10 80    	cmp    %ebx,0x8010b624
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 40 b6 10 80       	push   $0x8010b640
801021b8:	53                   	push   %ebx
801021b9:	e8 42 1f 00 00       	call   80104100 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 40 b6 10 80 	movl   $0x8010b640,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 d5 2a 00 00       	jmp    80104cb0 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba 24 b6 10 80       	mov    $0x8010b624,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 c0 7a 10 80       	push   $0x80107ac0
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 aa 7a 10 80       	push   $0x80107aaa
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 d5 7a 10 80       	push   $0x80107ad5
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102221:	c7 05 14 37 11 80 00 	movl   $0xfec00000,0x80113714
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 14 37 11 80       	mov    0x80113714,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d 14 37 11 80    	mov    0x80113714,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 40 38 11 80 	movzbl 0x80113840,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102254:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010225d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 f4 7a 10 80       	push   $0x80107af4
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d 14 37 11 80    	mov    0x80113714,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
{
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102290:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102292:	8b 0d 14 37 11 80    	mov    0x80113714,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022b0:	8b 0d 14 37 11 80    	mov    0x80113714,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
  ioapic->reg = reg;
801022d1:	8b 0d 14 37 11 80    	mov    0x80113714,%ecx
{
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e5:	8b 0d 14 37 11 80    	mov    0x80113714,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 14 37 11 80       	mov    0x80113714,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb 88 69 11 80    	cmp    $0x80116988,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 b9 29 00 00       	call   80104d00 <memset>

  if(kmem.use_lock)
80102347:	8b 15 54 37 11 80    	mov    0x80113754,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102354:	a1 58 37 11 80       	mov    0x80113758,%eax
80102359:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010235b:	a1 54 37 11 80       	mov    0x80113754,%eax
  kmem.freelist = r;
80102360:	89 1d 58 37 11 80    	mov    %ebx,0x80113758
  if(kmem.use_lock)
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
    release(&kmem.lock);
}
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
    release(&kmem.lock);
80102370:	c7 45 08 20 37 11 80 	movl   $0x80113720,0x8(%ebp)
}
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
    release(&kmem.lock);
8010237b:	e9 30 29 00 00       	jmp    80104cb0 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 20 37 11 80       	push   $0x80113720
80102388:	e8 63 28 00 00       	call   80104bf0 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 26 7b 10 80       	push   $0x80107b26
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
}
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 2c 7b 10 80       	push   $0x80107b2c
80102400:	68 20 37 11 80       	push   $0x80113720
80102405:	e8 a6 26 00 00       	call   80104ab0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102410:	c7 05 54 37 11 80 00 	movl   $0x0,0x80113754
80102417:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
    kfree(p);
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
}
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
801024a4:	c7 05 54 37 11 80 01 	movl   $0x1,0x80113754
801024ab:	00 00 00 
}
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024c0:	a1 54 37 11 80       	mov    0x80113754,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c9:	a1 58 37 11 80       	mov    0x80113758,%eax
  if(r)
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
    kmem.freelist = r->next;
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 58 37 11 80    	mov    %edx,0x80113758
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024ee:	68 20 37 11 80       	push   $0x80113720
801024f3:	e8 f8 26 00 00       	call   80104bf0 <acquire>
  r = kmem.freelist;
801024f8:	a1 58 37 11 80       	mov    0x80113758,%eax
  if(r)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 54 37 11 80    	mov    0x80113754,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
    kmem.freelist = r->next;
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d 58 37 11 80    	mov    %ecx,0x80113758
  if(kmem.use_lock)
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 20 37 11 80       	push   $0x80113720
80102521:	e8 8a 27 00 00       	call   80104cb0 <release>
  return (char*)r;
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102529:	83 c4 10             	add    $0x10,%esp
}
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d 74 b6 10 80    	mov    0x8010b674,%ecx

  if(data == 0xE0){
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102570:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102573:	0f b6 82 60 7c 10 80 	movzbl -0x7fef83a0(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 60 7b 10 80 	movzbl -0x7fef84a0(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102585:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102587:	89 0d 74 b6 10 80    	mov    %ecx,0x8010b674
  c = charcode[shift & (CTL | SHIFT)][data];
8010258d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102590:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102593:	8b 04 85 40 7b 10 80 	mov    -0x7fef84c0(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025b8:	0f b6 82 60 7c 10 80 	movzbl -0x7fef83a0(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
    return 0;
801025c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025cb:	89 0d 74 b6 10 80    	mov    %ecx,0x8010b674
}
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025dd:	89 0d 74 b6 10 80    	mov    %ecx,0x8010b674
    return 0;
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
}
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
}
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102630:	a1 5c 37 11 80       	mov    0x8011375c,%eax
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
  lapic[index] = value;
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102657:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102664:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102671:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
  lapic[index] = value;
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
  lapic[index] = value;
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102705:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102730:	8b 15 5c 37 11 80    	mov    0x8011375c,%edx
{
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
}
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102750:	a1 5c 37 11 80       	mov    0x8011375c,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102780:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027b0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027b3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027be:	a1 5c 37 11 80       	mov    0x8011375c,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102927:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 14 24 00 00       	call   80104d50 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a00:	8b 0d a8 37 11 80    	mov    0x801137a8,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
{
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	31 db                	xor    %ebx,%ebx
{
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a20:	a1 94 37 11 80       	mov    0x80113794,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 a4 37 11 80    	pushl  0x801137a4
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d ac 37 11 80 	pushl  -0x7feec854(,%ebx,4)
80102a44:	ff 35 a4 37 11 80    	pushl  0x801137a4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 47 23 00 00       	call   80104db0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d a8 37 11 80    	cmp    %ebx,0x801137a8
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
  }
}
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 94 37 11 80    	pushl  0x80113794
80102aae:	ff 35 a4 37 11 80    	pushl  0x801137a4
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ab9:	8b 1d a8 37 11 80    	mov    0x801137a8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102abf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ac6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ad0:	8b 8a ac 37 11 80    	mov    -0x7feec854(%edx),%ecx
80102ad6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
  }
  bwrite(buf);
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
}
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b0a:	68 60 7d 10 80       	push   $0x80107d60
80102b0f:	68 60 37 11 80       	push   $0x80113760
80102b14:	e8 97 1f 00 00       	call   80104ab0 <initlock>
  readsb(dev, &sb);
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b2b:	59                   	pop    %ecx
  log.dev = dev;
80102b2c:	89 1d a4 37 11 80    	mov    %ebx,0x801137a4
  log.size = sb.nlog;
80102b32:	89 15 98 37 11 80    	mov    %edx,0x80113798
  log.start = sb.logstart;
80102b38:	a3 94 37 11 80       	mov    %eax,0x80113794
  struct buf *buf = bread(log.dev, log.start);
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b4d:	89 1d a8 37 11 80    	mov    %ebx,0x801137a8
  for (i = 0; i < log.lh.n; i++) {
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a a8 37 11 80    	mov    %ecx,-0x7feec858(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
  brelse(buf);
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
  log.lh.n = 0;
80102b7f:	c7 05 a8 37 11 80 00 	movl   $0x0,0x801137a8
80102b86:	00 00 00 
  write_head(); // clear the log
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
}
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ba6:	68 60 37 11 80       	push   $0x80113760
80102bab:	e8 40 20 00 00       	call   80104bf0 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 60 37 11 80       	push   $0x80113760
80102bc0:	68 60 37 11 80       	push   $0x80113760
80102bc5:	e8 36 15 00 00       	call   80104100 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bcd:	a1 a0 37 11 80       	mov    0x801137a0,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd6:	a1 9c 37 11 80       	mov    0x8011379c,%eax
80102bdb:	8b 15 a8 37 11 80    	mov    0x801137a8,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bf2:	a3 9c 37 11 80       	mov    %eax,0x8011379c
      release(&log.lock);
80102bf7:	68 60 37 11 80       	push   $0x80113760
80102bfc:	e8 af 20 00 00       	call   80104cb0 <release>
      break;
    }
  }
}
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c19:	68 60 37 11 80       	push   $0x80113760
80102c1e:	e8 cd 1f 00 00       	call   80104bf0 <acquire>
  log.outstanding -= 1;
80102c23:	a1 9c 37 11 80       	mov    0x8011379c,%eax
  if(log.committing)
80102c28:	8b 35 a0 37 11 80    	mov    0x801137a0,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c36:	89 1d 9c 37 11 80    	mov    %ebx,0x8011379c
  if(log.committing)
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c4d:	c7 05 a0 37 11 80 01 	movl   $0x1,0x801137a0
80102c54:	00 00 00 
  release(&log.lock);
80102c57:	68 60 37 11 80       	push   $0x80113760
80102c5c:	e8 4f 20 00 00       	call   80104cb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c61:	8b 0d a8 37 11 80    	mov    0x801137a8,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c72:	a1 94 37 11 80       	mov    0x80113794,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 a4 37 11 80    	pushl  0x801137a4
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d ac 37 11 80 	pushl  -0x7feec854(,%ebx,4)
80102c96:	ff 35 a4 37 11 80    	pushl  0x801137a4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 f5 20 00 00       	call   80104db0 <memmove>
    bwrite(to);  // write the log
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d a8 37 11 80    	cmp    0x801137a8,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
    install_trans(); // Now install writes to home locations
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
    log.lh.n = 0;
80102ce8:	c7 05 a8 37 11 80 00 	movl   $0x0,0x801137a8
80102cef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
    acquire(&log.lock);
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 60 37 11 80       	push   $0x80113760
80102cff:	e8 ec 1e 00 00       	call   80104bf0 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
    log.committing = 0;
80102d0b:	c7 05 a0 37 11 80 00 	movl   $0x0,0x801137a0
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 36 16 00 00       	call   80104350 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
80102d21:	e8 8a 1f 00 00       	call   80104cb0 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
}
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 60 37 11 80       	push   $0x80113760
80102d40:	e8 0b 16 00 00       	call   80104350 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
80102d4c:	e8 5f 1f 00 00       	call   80104cb0 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
}
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
    panic("log.committing");
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 64 7d 10 80       	push   $0x80107d64
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	8b 15 a8 37 11 80    	mov    0x801137a8,%edx
{
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 98 37 11 80       	mov    0x80113798,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 9c 37 11 80       	mov    0x8011379c,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 60 37 11 80       	push   $0x80113760
80102dae:	e8 3d 1e 00 00       	call   80104bf0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db3:	8b 0d a8 37 11 80    	mov    0x801137a8,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc6:	3b 15 ac 37 11 80    	cmp    0x801137ac,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 ac 37 11 80 	cmp    %edx,-0x7feec854(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 14 85 ac 37 11 80 	mov    %edx,-0x7feec854(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 a8 37 11 80       	mov    %eax,0x801137a8
  b->flags |= B_DIRTY; // prevent eviction
80102def:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df2:	c7 45 08 60 37 11 80 	movl   $0x80113760,0x8(%ebp)
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
  release(&log.lock);
80102dfd:	e9 ae 1e 00 00       	jmp    80104cb0 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 14 85 ac 37 11 80 	mov    %edx,-0x7feec854(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 ac 37 11 80       	mov    %eax,0x801137ac
  if (i == log.lh.n)
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
    panic("too big a transaction");
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 73 7d 10 80       	push   $0x80107d73
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 89 7d 10 80       	push   $0x80107d89
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e47:	e8 a4 0a 00 00       	call   801038f0 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 9d 0a 00 00       	call   801038f0 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 a4 7d 10 80       	push   $0x80107da4
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 39 32 00 00       	call   801060a0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 04 0a 00 00       	call   80103870 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 81 0d 00 00       	call   80103c00 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 45 43 00 00       	call   801071d0 <switchkvm>
  seginit();
80102e8b:	e8 b0 42 00 00       	call   80107140 <seginit>
  lapicinit();
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
  mpmain();
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
{
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ea7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	53                   	push   %ebx
80102eae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	68 00 00 40 80       	push   $0x80400000
80102eb7:	68 88 69 11 80       	push   $0x80116988
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102ec1:	e8 da 47 00 00       	call   801076a0 <kvmalloc>
  mpinit();        // detect other processors
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102ed0:	e8 6b 42 00 00       	call   80107140 <seginit>
  picinit();       // disable pic
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ee4:	e8 27 35 00 00       	call   80106410 <uartinit>
  pinit();         // process table
80102ee9:	e8 62 09 00 00       	call   80103850 <pinit>
  tvinit();        // trap vectors
80102eee:	e8 2d 31 00 00       	call   80106020 <tvinit>
  binit();         // buffer cache
80102ef3:	e8 48 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ef8:	e8 63 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102efd:	e8 fe f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f02:	83 c4 0c             	add    $0xc,%esp
80102f05:	68 8a 00 00 00       	push   $0x8a
80102f0a:	68 4c b5 10 80       	push   $0x8010b54c
80102f0f:	68 00 70 00 80       	push   $0x80007000
80102f14:	e8 97 1e 00 00       	call   80104db0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f19:	69 05 e0 3d 11 80 b0 	imul   $0xb0,0x80113de0,%eax
80102f20:	00 00 00 
80102f23:	83 c4 10             	add    $0x10,%esp
80102f26:	05 60 38 11 80       	add    $0x80113860,%eax
80102f2b:	3d 60 38 11 80       	cmp    $0x80113860,%eax
80102f30:	76 71                	jbe    80102fa3 <main+0x103>
80102f32:	bb 60 38 11 80       	mov    $0x80113860,%ebx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f40:	e8 2b 09 00 00       	call   80103870 <mycpu>
80102f45:	39 d8                	cmp    %ebx,%eax
80102f47:	74 41                	je     80102f8a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f49:	e8 72 f5 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f4e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f53:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f5a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f5d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f64:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f67:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f6c:	0f b6 03             	movzbl (%ebx),%eax
80102f6f:	83 ec 08             	sub    $0x8,%esp
80102f72:	68 00 70 00 00       	push   $0x7000
80102f77:	50                   	push   %eax
80102f78:	e8 03 f8 ff ff       	call   80102780 <lapicstartap>
80102f7d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f80:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f86:	85 c0                	test   %eax,%eax
80102f88:	74 f6                	je     80102f80 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f8a:	69 05 e0 3d 11 80 b0 	imul   $0xb0,0x80113de0,%eax
80102f91:	00 00 00 
80102f94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f9a:	05 60 38 11 80       	add    $0x80113860,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 9d                	jb     80102f40 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fa3:	83 ec 08             	sub    $0x8,%esp
80102fa6:	68 00 00 00 8e       	push   $0x8e000000
80102fab:	68 00 00 40 80       	push   $0x80400000
80102fb0:	e8 ab f4 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102fb5:	e8 86 09 00 00       	call   80103940 <userinit>
  mpmain();        // finish this processor's setup
80102fba:	e8 81 fe ff ff       	call   80102e40 <mpmain>
80102fbf:	90                   	nop

80102fc0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fc5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fcb:	53                   	push   %ebx
  e = addr+len;
80102fcc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fcf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd2:	39 de                	cmp    %ebx,%esi
80102fd4:	72 10                	jb     80102fe6 <mpsearch1+0x26>
80102fd6:	eb 50                	jmp    80103028 <mpsearch1+0x68>
80102fd8:	90                   	nop
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe0:	39 fb                	cmp    %edi,%ebx
80102fe2:	89 fe                	mov    %edi,%esi
80102fe4:	76 42                	jbe    80103028 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe6:	83 ec 04             	sub    $0x4,%esp
80102fe9:	8d 7e 10             	lea    0x10(%esi),%edi
80102fec:	6a 04                	push   $0x4
80102fee:	68 b8 7d 10 80       	push   $0x80107db8
80102ff3:	56                   	push   %esi
80102ff4:	e8 57 1d 00 00       	call   80104d50 <memcmp>
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	75 e0                	jne    80102fe0 <mpsearch1+0x20>
80103000:	89 f1                	mov    %esi,%ecx
80103002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103008:	0f b6 11             	movzbl (%ecx),%edx
8010300b:	83 c1 01             	add    $0x1,%ecx
8010300e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103010:	39 f9                	cmp    %edi,%ecx
80103012:	75 f4                	jne    80103008 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103014:	84 c0                	test   %al,%al
80103016:	75 c8                	jne    80102fe0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010301b:	89 f0                	mov    %esi,%eax
8010301d:	5b                   	pop    %ebx
8010301e:	5e                   	pop    %esi
8010301f:	5f                   	pop    %edi
80103020:	5d                   	pop    %ebp
80103021:	c3                   	ret    
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010302b:	31 f6                	xor    %esi,%esi
}
8010302d:	89 f0                	mov    %esi,%eax
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
80103034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010303a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103040 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 38 ff ff ff       	call   80102fc0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010308d:	0f 84 3d 01 00 00    	je     801031d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103096:	8b 58 04             	mov    0x4(%eax),%ebx
80103099:	85 db                	test   %ebx,%ebx
8010309b:	0f 84 4f 01 00 00    	je     801031f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030a7:	83 ec 04             	sub    $0x4,%esp
801030aa:	6a 04                	push   $0x4
801030ac:	68 d5 7d 10 80       	push   $0x80107dd5
801030b1:	56                   	push   %esi
801030b2:	e8 99 1c 00 00       	call   80104d50 <memcmp>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c0                	test   %eax,%eax
801030bc:	0f 85 2e 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030c9:	3c 01                	cmp    $0x1,%al
801030cb:	0f 95 c2             	setne  %dl
801030ce:	3c 04                	cmp    $0x4,%al
801030d0:	0f 95 c0             	setne  %al
801030d3:	20 c2                	and    %al,%dl
801030d5:	0f 85 15 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030e2:	66 85 ff             	test   %di,%di
801030e5:	74 1a                	je     80103101 <mpinit+0xc1>
801030e7:	89 f0                	mov    %esi,%eax
801030e9:	01 f7                	add    %esi,%edi
  sum = 0;
801030eb:	31 d2                	xor    %edx,%edx
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801030f0:	0f b6 08             	movzbl (%eax),%ecx
801030f3:	83 c0 01             	add    $0x1,%eax
801030f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801030f8:	39 c7                	cmp    %eax,%edi
801030fa:	75 f4                	jne    801030f0 <mpinit+0xb0>
801030fc:	84 d2                	test   %dl,%dl
801030fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103101:	85 f6                	test   %esi,%esi
80103103:	0f 84 e7 00 00 00    	je     801031f0 <mpinit+0x1b0>
80103109:	84 d2                	test   %dl,%dl
8010310b:	0f 85 df 00 00 00    	jne    801031f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103111:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103117:	a3 5c 37 11 80       	mov    %eax,0x8011375c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010311c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103123:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103129:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312e:	01 d6                	add    %edx,%esi
80103130:	39 c6                	cmp    %eax,%esi
80103132:	76 23                	jbe    80103157 <mpinit+0x117>
    switch(*p){
80103134:	0f b6 10             	movzbl (%eax),%edx
80103137:	80 fa 04             	cmp    $0x4,%dl
8010313a:	0f 87 ca 00 00 00    	ja     8010320a <mpinit+0x1ca>
80103140:	ff 24 95 fc 7d 10 80 	jmp    *-0x7fef8204(,%edx,4)
80103147:	89 f6                	mov    %esi,%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103150:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103153:	39 c6                	cmp    %eax,%esi
80103155:	77 dd                	ja     80103134 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103157:	85 db                	test   %ebx,%ebx
80103159:	0f 84 9e 00 00 00    	je     801031fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103162:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103166:	74 15                	je     8010317d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103168:	b8 70 00 00 00       	mov    $0x70,%eax
8010316d:	ba 22 00 00 00       	mov    $0x22,%edx
80103172:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103173:	ba 23 00 00 00       	mov    $0x23,%edx
80103178:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103179:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010317c:	ee                   	out    %al,(%dx)
  }
}
8010317d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103180:	5b                   	pop    %ebx
80103181:	5e                   	pop    %esi
80103182:	5f                   	pop    %edi
80103183:	5d                   	pop    %ebp
80103184:	c3                   	ret    
80103185:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103188:	8b 0d e0 3d 11 80    	mov    0x80113de0,%ecx
8010318e:	83 f9 07             	cmp    $0x7,%ecx
80103191:	7f 19                	jg     801031ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103193:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103197:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010319d:	83 c1 01             	add    $0x1,%ecx
801031a0:	89 0d e0 3d 11 80    	mov    %ecx,0x80113de0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a6:	88 97 60 38 11 80    	mov    %dl,-0x7feec7a0(%edi)
      p += sizeof(struct mpproc);
801031ac:	83 c0 14             	add    $0x14,%eax
      continue;
801031af:	e9 7c ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031bf:	88 15 40 38 11 80    	mov    %dl,0x80113840
      continue;
801031c5:	e9 66 ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031da:	e8 e1 fd ff ff       	call   80102fc0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031e4:	0f 85 a9 fe ff ff    	jne    80103093 <mpinit+0x53>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 bd 7d 10 80       	push   $0x80107dbd
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 dc 7d 10 80       	push   $0x80107ddc
80103205:	e8 86 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010320a:	31 db                	xor    %ebx,%ebx
8010320c:	e9 26 ff ff ff       	jmp    80103137 <mpinit+0xf7>
80103211:	66 90                	xchg   %ax,%ax
80103213:	66 90                	xchg   %ax,%ax
80103215:	66 90                	xchg   %ax,%ax
80103217:	66 90                	xchg   %ax,%ax
80103219:	66 90                	xchg   %ax,%ax
8010321b:	66 90                	xchg   %ax,%ax
8010321d:	66 90                	xchg   %ax,%ax
8010321f:	90                   	nop

80103220 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103220:	55                   	push   %ebp
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	ba 21 00 00 00       	mov    $0x21,%edx
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	ee                   	out    %al,(%dx)
8010322e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103233:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103234:	5d                   	pop    %ebp
80103235:	c3                   	ret    
80103236:	66 90                	xchg   %ax,%ax
80103238:	66 90                	xchg   %ax,%ax
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010324f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103255:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010325b:	e8 20 db ff ff       	call   80100d80 <filealloc>
80103260:	85 c0                	test   %eax,%eax
80103262:	89 03                	mov    %eax,(%ebx)
80103264:	74 22                	je     80103288 <pipealloc+0x48>
80103266:	e8 15 db ff ff       	call   80100d80 <filealloc>
8010326b:	85 c0                	test   %eax,%eax
8010326d:	89 06                	mov    %eax,(%esi)
8010326f:	74 3f                	je     801032b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103271:	e8 4a f2 ff ff       	call   801024c0 <kalloc>
80103276:	85 c0                	test   %eax,%eax
80103278:	89 c7                	mov    %eax,%edi
8010327a:	75 54                	jne    801032d0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010327c:	8b 03                	mov    (%ebx),%eax
8010327e:	85 c0                	test   %eax,%eax
80103280:	75 34                	jne    801032b6 <pipealloc+0x76>
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103288:	8b 06                	mov    (%esi),%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	74 0c                	je     8010329a <pipealloc+0x5a>
    fileclose(*f1);
8010328e:	83 ec 0c             	sub    $0xc,%esp
80103291:	50                   	push   %eax
80103292:	e8 a9 db ff ff       	call   80100e40 <fileclose>
80103297:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010329a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010329d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5f                   	pop    %edi
801032a5:	5d                   	pop    %ebp
801032a6:	c3                   	ret    
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032b0:	8b 03                	mov    (%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 e4                	je     8010329a <pipealloc+0x5a>
    fileclose(*f0);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 81 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 c6                	jne    8010328e <pipealloc+0x4e>
801032c8:	eb d0                	jmp    8010329a <pipealloc+0x5a>
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032da:	00 00 00 
  p->writeopen = 1;
801032dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032e4:	00 00 00 
  p->nwrite = 0;
801032e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032ee:	00 00 00 
  p->nread = 0;
801032f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032f8:	00 00 00 
  initlock(&p->lock, "pipe");
801032fb:	68 10 7e 10 80       	push   $0x80107e10
80103300:	50                   	push   %eax
80103301:	e8 aa 17 00 00       	call   80104ab0 <initlock>
  (*f0)->type = FD_PIPE;
80103306:	8b 03                	mov    (%ebx),%eax
  return 0;
80103308:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010330b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103311:	8b 03                	mov    (%ebx),%eax
80103313:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103317:	8b 03                	mov    (%ebx),%eax
80103319:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010331d:	8b 03                	mov    (%ebx),%eax
8010331f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103322:	8b 06                	mov    (%esi),%eax
80103324:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010332a:	8b 06                	mov    (%esi),%eax
8010332c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103330:	8b 06                	mov    (%esi),%eax
80103332:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103336:	8b 06                	mov    (%esi),%eax
80103338:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010333b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010333e:	31 c0                	xor    %eax,%eax
}
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
80103345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103350 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	56                   	push   %esi
80103354:	53                   	push   %ebx
80103355:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103358:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010335b:	83 ec 0c             	sub    $0xc,%esp
8010335e:	53                   	push   %ebx
8010335f:	e8 8c 18 00 00       	call   80104bf0 <acquire>
  if(writable){
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 f6                	test   %esi,%esi
80103369:	74 45                	je     801033b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010336b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103371:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103374:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010337b:	00 00 00 
    wakeup(&p->nread);
8010337e:	50                   	push   %eax
8010337f:	e8 cc 0f 00 00       	call   80104350 <wakeup>
80103384:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103387:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338d:	85 d2                	test   %edx,%edx
8010338f:	75 0a                	jne    8010339b <pipeclose+0x4b>
80103391:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	74 35                	je     801033d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010339b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010339e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033a1:	5b                   	pop    %ebx
801033a2:	5e                   	pop    %esi
801033a3:	5d                   	pop    %ebp
    release(&p->lock);
801033a4:	e9 07 19 00 00       	jmp    80104cb0 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
    wakeup(&p->nwrite);
801033c3:	50                   	push   %eax
801033c4:	e8 87 0f 00 00       	call   80104350 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 d7 18 00 00       	call   80104cb0 <release>
    kfree((char*)p);
801033d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033dc:	83 c4 10             	add    $0x10,%esp
}
801033df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5d                   	pop    %ebp
    kfree((char*)p);
801033e5:	e9 26 ef ff ff       	jmp    80102310 <kfree>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 28             	sub    $0x28,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033fc:	53                   	push   %ebx
801033fd:	e8 ee 17 00 00       	call   80104bf0 <acquire>
  for(i = 0; i < n; i++){
80103402:	8b 45 10             	mov    0x10(%ebp),%eax
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 8e c9 00 00 00    	jle    801034d9 <pipewrite+0xe9>
80103410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103413:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103419:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010341f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103422:	03 4d 10             	add    0x10(%ebp),%ecx
80103425:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103428:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010342e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103434:	39 d0                	cmp    %edx,%eax
80103436:	75 71                	jne    801034a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103438:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010343e:	85 c0                	test   %eax,%eax
80103440:	74 4e                	je     80103490 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103442:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103448:	eb 3a                	jmp    80103484 <pipewrite+0x94>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	57                   	push   %edi
80103454:	e8 f7 0e 00 00       	call   80104350 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 9e 0c 00 00       	call   80104100 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103462:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103468:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	05 00 02 00 00       	add    $0x200,%eax
80103476:	39 c2                	cmp    %eax,%edx
80103478:	75 36                	jne    801034b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010347a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103480:	85 c0                	test   %eax,%eax
80103482:	74 0c                	je     80103490 <pipewrite+0xa0>
80103484:	e8 87 04 00 00       	call   80103910 <myproc>
80103489:	8b 40 24             	mov    0x24(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
        release(&p->lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 17 18 00 00       	call   80104cb0 <release>
        return -1;
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5f                   	pop    %edi
801034a7:	5d                   	pop    %ebp
801034a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a9:	89 c2                	mov    %eax,%edx
801034ab:	90                   	nop
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034b3:	8d 42 01             	lea    0x1(%edx),%eax
801034b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034c2:	83 c6 01             	add    $0x1,%esi
801034c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034d3:	0f 85 4f ff ff ff    	jne    80103428 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034df:	83 ec 0c             	sub    $0xc,%esp
801034e2:	50                   	push   %eax
801034e3:	e8 68 0e 00 00       	call   80104350 <wakeup>
  release(&p->lock);
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 c0 17 00 00       	call   80104cb0 <release>
  return n;
801034f0:	83 c4 10             	add    $0x10,%esp
801034f3:	8b 45 10             	mov    0x10(%ebp),%eax
801034f6:	eb a9                	jmp    801034a1 <pipewrite+0xb1>
801034f8:	90                   	nop
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103500 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 18             	sub    $0x18,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010350f:	56                   	push   %esi
80103510:	e8 db 16 00 00       	call   80104bf0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010351e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103524:	75 6a                	jne    80103590 <piperead+0x90>
80103526:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010352c:	85 db                	test   %ebx,%ebx
8010352e:	0f 84 c4 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103534:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010353a:	eb 2d                	jmp    80103569 <piperead+0x69>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103540:	83 ec 08             	sub    $0x8,%esp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	e8 b6 0b 00 00       	call   80104100 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103553:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
80103569:	e8 a2 03 00 00       	call   80103910 <myproc>
8010356e:	8b 48 24             	mov    0x24(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
      release(&p->lock);
80103575:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010357d:	56                   	push   %esi
8010357e:	e8 2d 17 00 00       	call   80104cb0 <release>
      return -1;
80103583:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103589:	89 d8                	mov    %ebx,%eax
8010358b:	5b                   	pop    %ebx
8010358c:	5e                   	pop    %esi
8010358d:	5f                   	pop    %edi
8010358e:	5d                   	pop    %ebp
8010358f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103590:	8b 45 10             	mov    0x10(%ebp),%eax
80103593:	85 c0                	test   %eax,%eax
80103595:	7e 61                	jle    801035f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103597:	31 db                	xor    %ebx,%ebx
80103599:	eb 13                	jmp    801035ae <piperead+0xae>
8010359b:	90                   	nop
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ac:	74 1f                	je     801035cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ae:	8d 41 01             	lea    0x1(%ecx),%eax
801035b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035c5:	83 c3 01             	add    $0x1,%ebx
801035c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035cb:	75 d3                	jne    801035a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	50                   	push   %eax
801035d7:	e8 74 0d 00 00       	call   80104350 <wakeup>
  release(&p->lock);
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 cc 16 00 00       	call   80104cb0 <release>
  return i;
801035e4:	83 c4 10             	add    $0x10,%esp
}
801035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ea:	89 d8                	mov    %ebx,%eax
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5f                   	pop    %edi
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035f8:	31 db                	xor    %ebx,%ebx
801035fa:	eb d1                	jmp    801035cd <piperead+0xcd>
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103600:	55                   	push   %ebp
  struct proc *p;
  int check = 0;
80103601:	31 c9                	xor    %ecx,%ecx
  // if there is no process in the RUNNABLE state
  // set the vruntime of curproc as 0
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103603:	ba 34 3e 11 80       	mov    $0x80113e34,%edx
{
80103608:	89 e5                	mov    %esp,%ebp
8010360a:	57                   	push   %edi
8010360b:	56                   	push   %esi
8010360c:	53                   	push   %ebx
    if (p->state == RUNNABLE) {
      check = 1;
8010360d:	bb 01 00 00 00       	mov    $0x1,%ebx
{
80103612:	83 ec 24             	sub    $0x24,%esp
80103615:	8d 76 00             	lea    0x0(%esi),%esi
      check = 1;
80103618:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
8010361c:	0f 44 cb             	cmove  %ebx,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010361f:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103625:	81 fa 34 61 11 80    	cmp    $0x80116134,%edx
8010362b:	72 eb                	jb     80103618 <wakeup1+0x18>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if (p->state == SLEEPING && p->chan == chan){
      p->state = RUNNABLE;
      int vruntime_tick = (1000*ticks*(int)ceil((double)1024/weights[p->nice]));

      if (min_vruntime <= vruntime_tick || !check) {
8010362d:	83 f1 01             	xor    $0x1,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103630:	ba 34 3e 11 80       	mov    $0x80113e34,%edx
      if (min_vruntime <= vruntime_tick || !check) {
80103635:	83 e1 01             	and    $0x1,%ecx
80103638:	eb 18                	jmp    80103652 <wakeup1+0x52>
8010363a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103640:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103646:	81 fa 34 61 11 80    	cmp    $0x80116134,%edx
8010364c:	0f 83 9a 00 00 00    	jae    801036ec <wakeup1+0xec>
    if (p->state == SLEEPING && p->chan == chan){
80103652:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103656:	75 e8                	jne    80103640 <wakeup1+0x40>
80103658:	39 42 20             	cmp    %eax,0x20(%edx)
8010365b:	75 e3                	jne    80103640 <wakeup1+0x40>
      int vruntime_tick = (1000*ticks*(int)ceil((double)1024/weights[p->nice]));
8010365d:	8b 5a 7c             	mov    0x7c(%edx),%ebx
      p->state = RUNNABLE;
80103660:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
      int vruntime_tick = (1000*ticks*(int)ceil((double)1024/weights[p->nice]));
80103667:	db 04 9d 20 b0 10 80 	fildl  -0x7fef4fe0(,%ebx,4)
8010366e:	d8 3d ec 7f 10 80    	fdivrs 0x80107fec
		    : "=t" (__value), "=&q" (__ignore), "=m" (__cwtmp),	      \
		      "=m" (__cw)					      \
		    : "0" (__x));					      \
  return __value)

__inline_mathcodeNP (ceil, __x, \
80103674:	d9 7d ec             	fnstcw -0x14(%ebp)
80103677:	0f b7 5d ec          	movzwl -0x14(%ebp),%ebx
8010367b:	81 e3 ff f3 00 00    	and    $0xf3ff,%ebx
80103681:	81 cb 00 08 00 00    	or     $0x800,%ebx
80103687:	66 89 5d ee          	mov    %bx,-0x12(%ebp)
8010368b:	d9 6d ee             	fldcw  -0x12(%ebp)
8010368e:	d9 fc                	frndint 
80103690:	d9 6d ec             	fldcw  -0x14(%ebp)
80103693:	d9 7d d6             	fnstcw -0x2a(%ebp)
80103696:	0f b7 75 d6          	movzwl -0x2a(%ebp),%esi
8010369a:	dd 5d d8             	fstpl  -0x28(%ebp)
8010369d:	69 3d 80 69 11 80 e8 	imul   $0x3e8,0x80116980,%edi
801036a4:	03 00 00 
801036a7:	dd 45 d8             	fldl   -0x28(%ebp)
801036aa:	66 81 ce 00 0c       	or     $0xc00,%si
801036af:	66 89 75 d4          	mov    %si,-0x2c(%ebp)
      if (min_vruntime <= vruntime_tick || !check) {
801036b3:	8b 35 80 b6 10 80    	mov    0x8010b680,%esi
      int vruntime_tick = (1000*ticks*(int)ceil((double)1024/weights[p->nice]));
801036b9:	d9 6d d4             	fldcw  -0x2c(%ebp)
801036bc:	db 5d d0             	fistpl -0x30(%ebp)
801036bf:	d9 6d d6             	fldcw  -0x2a(%ebp)
801036c2:	8b 5d d0             	mov    -0x30(%ebp),%ebx
801036c5:	0f af df             	imul   %edi,%ebx
      if (min_vruntime <= vruntime_tick || !check) {
801036c8:	84 c9                	test   %cl,%cl
801036ca:	75 04                	jne    801036d0 <wakeup1+0xd0>
801036cc:	39 de                	cmp    %ebx,%esi
801036ce:	7f 28                	jg     801036f8 <wakeup1+0xf8>
        p->vruntime = 0;
801036d0:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
801036d7:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036da:	81 c2 8c 00 00 00    	add    $0x8c,%edx
801036e0:	81 fa 34 61 11 80    	cmp    $0x80116134,%edx
801036e6:	0f 82 66 ff ff ff    	jb     80103652 <wakeup1+0x52>
      else {
        p->vruntime = min_vruntime - vruntime_tick;  
      }
    }
  }
}
801036ec:	83 c4 24             	add    $0x24,%esp
801036ef:	5b                   	pop    %ebx
801036f0:	5e                   	pop    %esi
801036f1:	5f                   	pop    %edi
801036f2:	5d                   	pop    %ebp
801036f3:	c3                   	ret    
801036f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->vruntime = min_vruntime - vruntime_tick;  
801036f8:	29 de                	sub    %ebx,%esi
801036fa:	89 b2 84 00 00 00    	mov    %esi,0x84(%edx)
80103700:	e9 3b ff ff ff       	jmp    80103640 <wakeup1+0x40>
80103705:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103710 <allocproc>:
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103714:	bb 34 3e 11 80       	mov    $0x80113e34,%ebx
{
80103719:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010371c:	68 00 3e 11 80       	push   $0x80113e00
80103721:	e8 ca 14 00 00       	call   80104bf0 <acquire>
80103726:	83 c4 10             	add    $0x10,%esp
80103729:	eb 17                	jmp    80103742 <allocproc+0x32>
8010372b:	90                   	nop
8010372c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103730:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103736:	81 fb 34 61 11 80    	cmp    $0x80116134,%ebx
8010373c:	0f 83 8e 00 00 00    	jae    801037d0 <allocproc+0xc0>
    if(p->state == UNUSED)
80103742:	8b 43 0c             	mov    0xc(%ebx),%eax
80103745:	85 c0                	test   %eax,%eax
80103747:	75 e7                	jne    80103730 <allocproc+0x20>
  p->pid = nextpid++;
80103749:	a1 c0 b0 10 80       	mov    0x8010b0c0,%eax
  release(&ptable.lock);
8010374e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103751:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->vruntime = 0;
80103758:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010375f:	00 00 00 
  p->pid = nextpid++;
80103762:	8d 50 01             	lea    0x1(%eax),%edx
80103765:	89 43 10             	mov    %eax,0x10(%ebx)
  p->startTime = 1000*ticks;
80103768:	69 05 80 69 11 80 e8 	imul   $0x3e8,0x80116980,%eax
8010376f:	03 00 00 
  p->pid = nextpid++;
80103772:	89 15 c0 b0 10 80    	mov    %edx,0x8010b0c0
  p->startTime = 1000*ticks;
80103778:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  release(&ptable.lock);
8010377e:	68 00 3e 11 80       	push   $0x80113e00
80103783:	e8 28 15 00 00       	call   80104cb0 <release>
  if((p->kstack = kalloc()) == 0){
80103788:	e8 33 ed ff ff       	call   801024c0 <kalloc>
8010378d:	83 c4 10             	add    $0x10,%esp
80103790:	85 c0                	test   %eax,%eax
80103792:	89 43 08             	mov    %eax,0x8(%ebx)
80103795:	74 52                	je     801037e9 <allocproc+0xd9>
  sp -= sizeof *p->tf;
80103797:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
8010379d:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801037a0:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801037a5:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801037a8:	c7 40 14 0d 60 10 80 	movl   $0x8010600d,0x14(%eax)
  p->context = (struct context*)sp;
801037af:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037b2:	6a 14                	push   $0x14
801037b4:	6a 00                	push   $0x0
801037b6:	50                   	push   %eax
801037b7:	e8 44 15 00 00       	call   80104d00 <memset>
  p->context->eip = (uint)forkret;
801037bc:	8b 43 1c             	mov    0x1c(%ebx),%eax
  return p;
801037bf:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801037c2:	c7 40 10 00 38 10 80 	movl   $0x80103800,0x10(%eax)
}
801037c9:	89 d8                	mov    %ebx,%eax
801037cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037ce:	c9                   	leave  
801037cf:	c3                   	ret    
  release(&ptable.lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801037d3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801037d5:	68 00 3e 11 80       	push   $0x80113e00
801037da:	e8 d1 14 00 00       	call   80104cb0 <release>
}
801037df:	89 d8                	mov    %ebx,%eax
  return 0;
801037e1:	83 c4 10             	add    $0x10,%esp
}
801037e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037e7:	c9                   	leave  
801037e8:	c3                   	ret    
    p->state = UNUSED;
801037e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801037f0:	31 db                	xor    %ebx,%ebx
801037f2:	eb d5                	jmp    801037c9 <allocproc+0xb9>
801037f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103800 <forkret>:
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103806:	68 00 3e 11 80       	push   $0x80113e00
8010380b:	e8 a0 14 00 00       	call   80104cb0 <release>
  if (first) {
80103810:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103815:	83 c4 10             	add    $0x10,%esp
80103818:	85 c0                	test   %eax,%eax
8010381a:	75 04                	jne    80103820 <forkret+0x20>
}
8010381c:	c9                   	leave  
8010381d:	c3                   	ret    
8010381e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103820:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103823:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010382a:	00 00 00 
    iinit(ROOTDEV);
8010382d:	6a 01                	push   $0x1
8010382f:	e8 4c dc ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103834:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010383b:	e8 c0 f2 ff ff       	call   80102b00 <initlog>
80103840:	83 c4 10             	add    $0x10,%esp
}
80103843:	c9                   	leave  
80103844:	c3                   	ret    
80103845:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103850 <pinit>:
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103856:	68 15 7e 10 80       	push   $0x80107e15
8010385b:	68 00 3e 11 80       	push   $0x80113e00
80103860:	e8 4b 12 00 00       	call   80104ab0 <initlock>
}
80103865:	83 c4 10             	add    $0x10,%esp
80103868:	c9                   	leave  
80103869:	c3                   	ret    
8010386a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103870 <mycpu>:
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	56                   	push   %esi
80103874:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103875:	9c                   	pushf  
80103876:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103877:	f6 c4 02             	test   $0x2,%ah
8010387a:	75 5e                	jne    801038da <mycpu+0x6a>
  apicid = lapicid();
8010387c:	e8 af ee ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103881:	8b 35 e0 3d 11 80    	mov    0x80113de0,%esi
80103887:	85 f6                	test   %esi,%esi
80103889:	7e 42                	jle    801038cd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010388b:	0f b6 15 60 38 11 80 	movzbl 0x80113860,%edx
80103892:	39 d0                	cmp    %edx,%eax
80103894:	74 30                	je     801038c6 <mycpu+0x56>
80103896:	b9 10 39 11 80       	mov    $0x80113910,%ecx
  for (i = 0; i < ncpu; ++i) {
8010389b:	31 d2                	xor    %edx,%edx
8010389d:	8d 76 00             	lea    0x0(%esi),%esi
801038a0:	83 c2 01             	add    $0x1,%edx
801038a3:	39 f2                	cmp    %esi,%edx
801038a5:	74 26                	je     801038cd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801038a7:	0f b6 19             	movzbl (%ecx),%ebx
801038aa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801038b0:	39 c3                	cmp    %eax,%ebx
801038b2:	75 ec                	jne    801038a0 <mycpu+0x30>
801038b4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801038ba:	05 60 38 11 80       	add    $0x80113860,%eax
}
801038bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038c2:	5b                   	pop    %ebx
801038c3:	5e                   	pop    %esi
801038c4:	5d                   	pop    %ebp
801038c5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801038c6:	b8 60 38 11 80       	mov    $0x80113860,%eax
      return &cpus[i];
801038cb:	eb f2                	jmp    801038bf <mycpu+0x4f>
  panic("unknown apicid\n");
801038cd:	83 ec 0c             	sub    $0xc,%esp
801038d0:	68 1c 7e 10 80       	push   $0x80107e1c
801038d5:	e8 b6 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	68 40 7f 10 80       	push   $0x80107f40
801038e2:	e8 a9 ca ff ff       	call   80100390 <panic>
801038e7:	89 f6                	mov    %esi,%esi
801038e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038f0 <cpuid>:
cpuid() {
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801038f6:	e8 75 ff ff ff       	call   80103870 <mycpu>
801038fb:	2d 60 38 11 80       	sub    $0x80113860,%eax
}
80103900:	c9                   	leave  
  return mycpu()-cpus;
80103901:	c1 f8 04             	sar    $0x4,%eax
80103904:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010390a:	c3                   	ret    
8010390b:	90                   	nop
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103910 <myproc>:
myproc(void) {
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	53                   	push   %ebx
80103914:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103917:	e8 04 12 00 00       	call   80104b20 <pushcli>
  c = mycpu();
8010391c:	e8 4f ff ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103921:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103927:	e8 34 12 00 00       	call   80104b60 <popcli>
}
8010392c:	83 c4 04             	add    $0x4,%esp
8010392f:	89 d8                	mov    %ebx,%eax
80103931:	5b                   	pop    %ebx
80103932:	5d                   	pop    %ebp
80103933:	c3                   	ret    
80103934:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010393a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103940 <userinit>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	53                   	push   %ebx
80103944:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103947:	e8 c4 fd ff ff       	call   80103710 <allocproc>
8010394c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010394e:	a3 84 b6 10 80       	mov    %eax,0x8010b684
  if((p->pgdir = setupkvm()) == 0)
80103953:	e8 c8 3c 00 00       	call   80107620 <setupkvm>
80103958:	85 c0                	test   %eax,%eax
8010395a:	89 43 04             	mov    %eax,0x4(%ebx)
8010395d:	0f 84 c4 00 00 00    	je     80103a27 <userinit+0xe7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103963:	83 ec 04             	sub    $0x4,%esp
80103966:	68 2c 00 00 00       	push   $0x2c
8010396b:	68 20 b5 10 80       	push   $0x8010b520
80103970:	50                   	push   %eax
80103971:	e8 8a 39 00 00       	call   80107300 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103976:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103979:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010397f:	6a 4c                	push   $0x4c
80103981:	6a 00                	push   $0x0
80103983:	ff 73 18             	pushl  0x18(%ebx)
80103986:	e8 75 13 00 00       	call   80104d00 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010398b:	8b 43 18             	mov    0x18(%ebx),%eax
8010398e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103993:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103998:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010399b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010399f:	8b 43 18             	mov    0x18(%ebx),%eax
801039a2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039a6:	8b 43 18             	mov    0x18(%ebx),%eax
801039a9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039ad:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039b1:	8b 43 18             	mov    0x18(%ebx),%eax
801039b4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039b8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039bc:	8b 43 18             	mov    0x18(%ebx),%eax
801039bf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039c6:	8b 43 18             	mov    0x18(%ebx),%eax
801039c9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039d0:	8b 43 18             	mov    0x18(%ebx),%eax
801039d3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039da:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039dd:	6a 10                	push   $0x10
801039df:	68 45 7e 10 80       	push   $0x80107e45
801039e4:	50                   	push   %eax
801039e5:	e8 f6 14 00 00       	call   80104ee0 <safestrcpy>
  p->cwd = namei("/");
801039ea:	c7 04 24 4e 7e 10 80 	movl   $0x80107e4e,(%esp)
801039f1:	e8 ea e4 ff ff       	call   80101ee0 <namei>
  p->nice = 20;
801039f6:	c7 43 7c 14 00 00 00 	movl   $0x14,0x7c(%ebx)
  p->cwd = namei("/");
801039fd:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a00:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80103a07:	e8 e4 11 00 00       	call   80104bf0 <acquire>
  p->state = RUNNABLE;
80103a0c:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a13:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80103a1a:	e8 91 12 00 00       	call   80104cb0 <release>
}
80103a1f:	83 c4 10             	add    $0x10,%esp
80103a22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a25:	c9                   	leave  
80103a26:	c3                   	ret    
    panic("userinit: out of memory?");
80103a27:	83 ec 0c             	sub    $0xc,%esp
80103a2a:	68 2c 7e 10 80       	push   $0x80107e2c
80103a2f:	e8 5c c9 ff ff       	call   80100390 <panic>
80103a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a40 <growproc>:
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	56                   	push   %esi
80103a44:	53                   	push   %ebx
80103a45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a48:	e8 d3 10 00 00       	call   80104b20 <pushcli>
  c = mycpu();
80103a4d:	e8 1e fe ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103a52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a58:	e8 03 11 00 00       	call   80104b60 <popcli>
  if(n > 0){
80103a5d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103a60:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a62:	7f 1c                	jg     80103a80 <growproc+0x40>
  } else if(n < 0){
80103a64:	75 3a                	jne    80103aa0 <growproc+0x60>
  switchuvm(curproc);
80103a66:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a69:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a6b:	53                   	push   %ebx
80103a6c:	e8 7f 37 00 00       	call   801071f0 <switchuvm>
  return 0;
80103a71:	83 c4 10             	add    $0x10,%esp
80103a74:	31 c0                	xor    %eax,%eax
}
80103a76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a79:	5b                   	pop    %ebx
80103a7a:	5e                   	pop    %esi
80103a7b:	5d                   	pop    %ebp
80103a7c:	c3                   	ret    
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a80:	83 ec 04             	sub    $0x4,%esp
80103a83:	01 c6                	add    %eax,%esi
80103a85:	56                   	push   %esi
80103a86:	50                   	push   %eax
80103a87:	ff 73 04             	pushl  0x4(%ebx)
80103a8a:	e8 b1 39 00 00       	call   80107440 <allocuvm>
80103a8f:	83 c4 10             	add    $0x10,%esp
80103a92:	85 c0                	test   %eax,%eax
80103a94:	75 d0                	jne    80103a66 <growproc+0x26>
      return -1;
80103a96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a9b:	eb d9                	jmp    80103a76 <growproc+0x36>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103aa0:	83 ec 04             	sub    $0x4,%esp
80103aa3:	01 c6                	add    %eax,%esi
80103aa5:	56                   	push   %esi
80103aa6:	50                   	push   %eax
80103aa7:	ff 73 04             	pushl  0x4(%ebx)
80103aaa:	e8 c1 3a 00 00       	call   80107570 <deallocuvm>
80103aaf:	83 c4 10             	add    $0x10,%esp
80103ab2:	85 c0                	test   %eax,%eax
80103ab4:	75 b0                	jne    80103a66 <growproc+0x26>
80103ab6:	eb de                	jmp    80103a96 <growproc+0x56>
80103ab8:	90                   	nop
80103ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ac0 <fork>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	57                   	push   %edi
80103ac4:	56                   	push   %esi
80103ac5:	53                   	push   %ebx
80103ac6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ac9:	e8 52 10 00 00       	call   80104b20 <pushcli>
  c = mycpu();
80103ace:	e8 9d fd ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103ad3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad9:	e8 82 10 00 00       	call   80104b60 <popcli>
  if((np = allocproc()) == 0){
80103ade:	e8 2d fc ff ff       	call   80103710 <allocproc>
80103ae3:	85 c0                	test   %eax,%eax
80103ae5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ae8:	0f 84 d7 00 00 00    	je     80103bc5 <fork+0x105>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103aee:	83 ec 08             	sub    $0x8,%esp
80103af1:	ff 33                	pushl  (%ebx)
80103af3:	ff 73 04             	pushl  0x4(%ebx)
80103af6:	89 c7                	mov    %eax,%edi
80103af8:	e8 f3 3b 00 00       	call   801076f0 <copyuvm>
80103afd:	83 c4 10             	add    $0x10,%esp
80103b00:	85 c0                	test   %eax,%eax
80103b02:	89 47 04             	mov    %eax,0x4(%edi)
80103b05:	0f 84 c1 00 00 00    	je     80103bcc <fork+0x10c>
  np->sz = curproc->sz;
80103b0b:	8b 03                	mov    (%ebx),%eax
80103b0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103b10:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103b15:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103b17:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103b1a:	8b 7a 18             	mov    0x18(%edx),%edi
80103b1d:	8b 73 18             	mov    0x18(%ebx),%esi
80103b20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b22:	31 f6                	xor    %esi,%esi
  np->nice = curproc->nice;
80103b24:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103b27:	89 42 7c             	mov    %eax,0x7c(%edx)
  np->vruntime = curproc->vruntime;
80103b2a:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103b30:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  np->startTime = 1000*ticks;
80103b36:	69 05 80 69 11 80 e8 	imul   $0x3e8,0x80116980,%eax
80103b3d:	03 00 00 
80103b40:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
  np->tf->eax = 0;
80103b46:	8b 42 18             	mov    0x18(%edx),%eax
80103b49:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b54:	85 c0                	test   %eax,%eax
80103b56:	74 13                	je     80103b6b <fork+0xab>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b58:	83 ec 0c             	sub    $0xc,%esp
80103b5b:	50                   	push   %eax
80103b5c:	e8 8f d2 ff ff       	call   80100df0 <filedup>
80103b61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b64:	83 c4 10             	add    $0x10,%esp
80103b67:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b6b:	83 c6 01             	add    $0x1,%esi
80103b6e:	83 fe 10             	cmp    $0x10,%esi
80103b71:	75 dd                	jne    80103b50 <fork+0x90>
  np->cwd = idup(curproc->cwd);
80103b73:	83 ec 0c             	sub    $0xc,%esp
80103b76:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b79:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b7c:	e8 cf da ff ff       	call   80101650 <idup>
80103b81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b84:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b87:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b8a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b8d:	6a 10                	push   $0x10
80103b8f:	53                   	push   %ebx
80103b90:	50                   	push   %eax
80103b91:	e8 4a 13 00 00       	call   80104ee0 <safestrcpy>
  pid = np->pid;
80103b96:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103b99:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80103ba0:	e8 4b 10 00 00       	call   80104bf0 <acquire>
  np->state = RUNNABLE;
80103ba5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bac:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80103bb3:	e8 f8 10 00 00       	call   80104cb0 <release>
  return pid;
80103bb8:	83 c4 10             	add    $0x10,%esp
}
80103bbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bbe:	89 d8                	mov    %ebx,%eax
80103bc0:	5b                   	pop    %ebx
80103bc1:	5e                   	pop    %esi
80103bc2:	5f                   	pop    %edi
80103bc3:	5d                   	pop    %ebp
80103bc4:	c3                   	ret    
    return -1;
80103bc5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bca:	eb ef                	jmp    80103bbb <fork+0xfb>
    kfree(np->kstack);
80103bcc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103bcf:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103bd2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103bd7:	ff 77 08             	pushl  0x8(%edi)
80103bda:	e8 31 e7 ff ff       	call   80102310 <kfree>
    np->kstack = 0;
80103bdf:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103be6:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103bed:	83 c4 10             	add    $0x10,%esp
80103bf0:	eb c9                	jmp    80103bbb <fork+0xfb>
80103bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c00 <scheduler>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	57                   	push   %edi
80103c04:	56                   	push   %esi
80103c05:	53                   	push   %ebx
  struct proc *shortestP = p;
80103c06:	bf 34 3e 11 80       	mov    $0x80113e34,%edi
{
80103c0b:	83 ec 3c             	sub    $0x3c,%esp
  struct cpu *c = mycpu();
80103c0e:	e8 5d fc ff ff       	call   80103870 <mycpu>
80103c13:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103c15:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c1c:	00 00 00 
  int totalWeight = weights[p->nice];
80103c1f:	a1 b0 3e 11 80       	mov    0x80113eb0,%eax
80103c24:	8b 34 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%esi
80103c2b:	8d 43 04             	lea    0x4(%ebx),%eax
80103c2e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  asm volatile("sti");
80103c31:	fb                   	sti    
    acquire(&ptable.lock);
80103c32:	83 ec 0c             	sub    $0xc,%esp
80103c35:	68 00 3e 11 80       	push   $0x80113e00
80103c3a:	e8 b1 0f 00 00       	call   80104bf0 <acquire>
80103c3f:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c42:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
80103c47:	eb 13                	jmp    80103c5c <scheduler+0x5c>
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c50:	05 8c 00 00 00       	add    $0x8c,%eax
80103c55:	3d 34 61 11 80       	cmp    $0x80116134,%eax
80103c5a:	73 4b                	jae    80103ca7 <scheduler+0xa7>
      if(p->state != RUNNABLE)
80103c5c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103c60:	75 ee                	jne    80103c50 <scheduler+0x50>
      for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c62:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
80103c67:	89 f6                	mov    %esi,%esi
80103c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (p->state == RUNNABLE && p->vruntime < shortestP->vruntime){
80103c70:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103c74:	75 19                	jne    80103c8f <scheduler+0x8f>
80103c76:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
80103c7c:	39 90 84 00 00 00    	cmp    %edx,0x84(%eax)
          totalWeight += weights[p->nice];
80103c82:	8b 48 7c             	mov    0x7c(%eax),%ecx
        if (p->state == RUNNABLE && p->vruntime < shortestP->vruntime){
80103c85:	0f 42 f8             	cmovb  %eax,%edi
          totalWeight += weights[p->nice];
80103c88:	03 34 8d 20 b0 10 80 	add    -0x7fef4fe0(,%ecx,4),%esi
      for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c8f:	05 8c 00 00 00       	add    $0x8c,%eax
80103c94:	3d 34 61 11 80       	cmp    $0x80116134,%eax
80103c99:	72 d5                	jb     80103c70 <scheduler+0x70>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c9b:	05 8c 00 00 00       	add    $0x8c,%eax
80103ca0:	3d 34 61 11 80       	cmp    $0x80116134,%eax
80103ca5:	72 b5                	jb     80103c5c <scheduler+0x5c>
      switchuvm(p);
80103ca7:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103caa:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
80103cb0:	57                   	push   %edi
80103cb1:	e8 3a 35 00 00       	call   801071f0 <switchuvm>
      min_vruntime = p->vruntime;
80103cb6:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
      p->timeslice = 10*1000*ticks * (int)ceil((double)weights[p->nice]/totalWeight); 
80103cbc:	89 75 c4             	mov    %esi,-0x3c(%ebp)
      p->state = RUNNING;
80103cbf:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      min_vruntime = p->vruntime;
80103cc6:	a3 80 b6 10 80       	mov    %eax,0x8010b680
      p->startTime = 1000*ticks;
80103ccb:	a1 80 69 11 80       	mov    0x80116980,%eax
80103cd0:	69 c8 e8 03 00 00    	imul   $0x3e8,%eax,%ecx
80103cd6:	89 8f 80 00 00 00    	mov    %ecx,0x80(%edi)
      p->timeslice = 10*1000*ticks * (int)ceil((double)weights[p->nice]/totalWeight); 
80103cdc:	8b 4f 7c             	mov    0x7c(%edi),%ecx
80103cdf:	db 04 8d 20 b0 10 80 	fildl  -0x7fef4fe0(,%ecx,4)
80103ce6:	db 45 c4             	fildl  -0x3c(%ebp)
80103ce9:	de f9                	fdivrp %st,%st(1)
80103ceb:	d9 7d e4             	fnstcw -0x1c(%ebp)
80103cee:	0f b7 4d e4          	movzwl -0x1c(%ebp),%ecx
80103cf2:	81 e1 ff f3 00 00    	and    $0xf3ff,%ecx
80103cf8:	81 c9 00 08 00 00    	or     $0x800,%ecx
80103cfe:	66 89 4d e6          	mov    %cx,-0x1a(%ebp)
80103d02:	d9 6d e6             	fldcw  -0x1a(%ebp)
80103d05:	d9 fc                	frndint 
80103d07:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103d0a:	d9 7d ce             	fnstcw -0x32(%ebp)
80103d0d:	69 c8 10 27 00 00    	imul   $0x2710,%eax,%ecx
80103d13:	0f b7 45 ce          	movzwl -0x32(%ebp),%eax
80103d17:	dd 5d d0             	fstpl  -0x30(%ebp)
80103d1a:	dd 45 d0             	fldl   -0x30(%ebp)
80103d1d:	80 cc 0c             	or     $0xc,%ah
80103d20:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
80103d24:	d9 6d cc             	fldcw  -0x34(%ebp)
80103d27:	db 5d c8             	fistpl -0x38(%ebp)
80103d2a:	d9 6d ce             	fldcw  -0x32(%ebp)
80103d2d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103d30:	0f af c1             	imul   %ecx,%eax
80103d33:	89 87 88 00 00 00    	mov    %eax,0x88(%edi)
      swtch(&(c->scheduler), p->context);
80103d39:	58                   	pop    %eax
80103d3a:	5a                   	pop    %edx
80103d3b:	ff 77 1c             	pushl  0x1c(%edi)
80103d3e:	ff 75 c0             	pushl  -0x40(%ebp)
80103d41:	e8 f5 11 00 00       	call   80104f3b <swtch>
      switchkvm();
80103d46:	e8 85 34 00 00       	call   801071d0 <switchkvm>
      c->proc = 0;
80103d4b:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103d52:	00 00 00 
    release(&ptable.lock);
80103d55:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80103d5c:	e8 4f 0f 00 00       	call   80104cb0 <release>
    sti();
80103d61:	83 c4 10             	add    $0x10,%esp
80103d64:	e9 c8 fe ff ff       	jmp    80103c31 <scheduler+0x31>
80103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d70 <sched>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	56                   	push   %esi
80103d74:	53                   	push   %ebx
  pushcli();
80103d75:	e8 a6 0d 00 00       	call   80104b20 <pushcli>
  c = mycpu();
80103d7a:	e8 f1 fa ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103d7f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d85:	e8 d6 0d 00 00       	call   80104b60 <popcli>
  if(!holding(&ptable.lock))
80103d8a:	83 ec 0c             	sub    $0xc,%esp
80103d8d:	68 00 3e 11 80       	push   $0x80113e00
80103d92:	e8 29 0e 00 00       	call   80104bc0 <holding>
80103d97:	83 c4 10             	add    $0x10,%esp
80103d9a:	85 c0                	test   %eax,%eax
80103d9c:	74 4f                	je     80103ded <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d9e:	e8 cd fa ff ff       	call   80103870 <mycpu>
80103da3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103daa:	75 68                	jne    80103e14 <sched+0xa4>
  if(p->state == RUNNING)
80103dac:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103db0:	74 55                	je     80103e07 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103db2:	9c                   	pushf  
80103db3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103db4:	f6 c4 02             	test   $0x2,%ah
80103db7:	75 41                	jne    80103dfa <sched+0x8a>
  intena = mycpu()->intena;
80103db9:	e8 b2 fa ff ff       	call   80103870 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dbe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103dc1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103dc7:	e8 a4 fa ff ff       	call   80103870 <mycpu>
80103dcc:	83 ec 08             	sub    $0x8,%esp
80103dcf:	ff 70 04             	pushl  0x4(%eax)
80103dd2:	53                   	push   %ebx
80103dd3:	e8 63 11 00 00       	call   80104f3b <swtch>
  mycpu()->intena = intena;
80103dd8:	e8 93 fa ff ff       	call   80103870 <mycpu>
}
80103ddd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103de0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103de6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103de9:	5b                   	pop    %ebx
80103dea:	5e                   	pop    %esi
80103deb:	5d                   	pop    %ebp
80103dec:	c3                   	ret    
    panic("sched ptable.lock");
80103ded:	83 ec 0c             	sub    $0xc,%esp
80103df0:	68 50 7e 10 80       	push   $0x80107e50
80103df5:	e8 96 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103dfa:	83 ec 0c             	sub    $0xc,%esp
80103dfd:	68 7c 7e 10 80       	push   $0x80107e7c
80103e02:	e8 89 c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103e07:	83 ec 0c             	sub    $0xc,%esp
80103e0a:	68 6e 7e 10 80       	push   $0x80107e6e
80103e0f:	e8 7c c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103e14:	83 ec 0c             	sub    $0xc,%esp
80103e17:	68 62 7e 10 80       	push   $0x80107e62
80103e1c:	e8 6f c5 ff ff       	call   80100390 <panic>
80103e21:	eb 0d                	jmp    80103e30 <exit>
80103e23:	90                   	nop
80103e24:	90                   	nop
80103e25:	90                   	nop
80103e26:	90                   	nop
80103e27:	90                   	nop
80103e28:	90                   	nop
80103e29:	90                   	nop
80103e2a:	90                   	nop
80103e2b:	90                   	nop
80103e2c:	90                   	nop
80103e2d:	90                   	nop
80103e2e:	90                   	nop
80103e2f:	90                   	nop

80103e30 <exit>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	57                   	push   %edi
80103e34:	56                   	push   %esi
80103e35:	53                   	push   %ebx
80103e36:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
80103e39:	e8 e2 0c 00 00       	call   80104b20 <pushcli>
  c = mycpu();
80103e3e:	e8 2d fa ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103e43:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e49:	e8 12 0d 00 00       	call   80104b60 <popcli>
  if(curproc == initproc)
80103e4e:	39 35 84 b6 10 80    	cmp    %esi,0x8010b684
80103e54:	8d 5e 28             	lea    0x28(%esi),%ebx
80103e57:	8d 7e 68             	lea    0x68(%esi),%edi
80103e5a:	0f 84 3b 01 00 00    	je     80103f9b <exit+0x16b>
    if(curproc->ofile[fd]){
80103e60:	8b 03                	mov    (%ebx),%eax
80103e62:	85 c0                	test   %eax,%eax
80103e64:	74 12                	je     80103e78 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103e66:	83 ec 0c             	sub    $0xc,%esp
80103e69:	50                   	push   %eax
80103e6a:	e8 d1 cf ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103e6f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103e75:	83 c4 10             	add    $0x10,%esp
80103e78:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103e7b:	39 df                	cmp    %ebx,%edi
80103e7d:	75 e1                	jne    80103e60 <exit+0x30>
  begin_op();
80103e7f:	e8 1c ed ff ff       	call   80102ba0 <begin_op>
  iput(curproc->cwd);
80103e84:	83 ec 0c             	sub    $0xc,%esp
80103e87:	ff 76 68             	pushl  0x68(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e8a:	bb 34 3e 11 80       	mov    $0x80113e34,%ebx
  iput(curproc->cwd);
80103e8f:	e8 1c d9 ff ff       	call   801017b0 <iput>
  end_op();
80103e94:	e8 77 ed ff ff       	call   80102c10 <end_op>
  curproc->cwd = 0;
80103e99:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103ea0:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80103ea7:	e8 44 0d 00 00       	call   80104bf0 <acquire>
  wakeup1(curproc->parent);
80103eac:	8b 46 14             	mov    0x14(%esi),%eax
80103eaf:	e8 4c f7 ff ff       	call   80103600 <wakeup1>
80103eb4:	83 c4 10             	add    $0x10,%esp
80103eb7:	eb 15                	jmp    80103ece <exit+0x9e>
80103eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103ec6:	81 fb 34 61 11 80    	cmp    $0x80116134,%ebx
80103ecc:	73 2a                	jae    80103ef8 <exit+0xc8>
    if(p->parent == curproc){
80103ece:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ed1:	75 ed                	jne    80103ec0 <exit+0x90>
      if(p->state == ZOMBIE)
80103ed3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
80103ed7:	a1 84 b6 10 80       	mov    0x8010b684,%eax
80103edc:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80103edf:	75 df                	jne    80103ec0 <exit+0x90>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee1:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
        wakeup1(initproc);
80103ee7:	e8 14 f7 ff ff       	call   80103600 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eec:	81 fb 34 61 11 80    	cmp    $0x80116134,%ebx
80103ef2:	72 da                	jb     80103ece <exit+0x9e>
80103ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int execVtime = (1000*ticks - curproc->startTime)*(int)ceil((double)1024/weights[curproc->nice]); 
80103ef8:	69 05 80 69 11 80 e8 	imul   $0x3e8,0x80116980,%eax
80103eff:	03 00 00 
80103f02:	2b 86 80 00 00 00    	sub    0x80(%esi),%eax
80103f08:	89 c2                	mov    %eax,%edx
80103f0a:	8b 46 7c             	mov    0x7c(%esi),%eax
80103f0d:	db 04 85 20 b0 10 80 	fildl  -0x7fef4fe0(,%eax,4)
80103f14:	d8 3d ec 7f 10 80    	fdivrs 0x80107fec
80103f1a:	d9 7d e4             	fnstcw -0x1c(%ebp)
80103f1d:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80103f21:	25 ff f3 00 00       	and    $0xf3ff,%eax
80103f26:	0d 00 08 00 00       	or     $0x800,%eax
80103f2b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
80103f2f:	d9 6d e6             	fldcw  -0x1a(%ebp)
80103f32:	d9 fc                	frndint 
80103f34:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103f37:	d9 7d ce             	fnstcw -0x32(%ebp)
80103f3a:	0f b7 45 ce          	movzwl -0x32(%ebp),%eax
80103f3e:	dd 5d d0             	fstpl  -0x30(%ebp)
80103f41:	dd 45 d0             	fldl   -0x30(%ebp)
80103f44:	80 cc 0c             	or     $0xc,%ah
80103f47:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
80103f4b:	d9 6d cc             	fldcw  -0x34(%ebp)
80103f4e:	db 5d c8             	fistpl -0x38(%ebp)
80103f51:	d9 6d ce             	fldcw  -0x32(%ebp)
80103f54:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103f57:	0f af c2             	imul   %edx,%eax
  if (execVtime > 0 && curproc->vruntime > UINT32_MAX - execVtime) {
80103f5a:	85 c0                	test   %eax,%eax
80103f5c:	7e 1e                	jle    80103f7c <exit+0x14c>
80103f5e:	8b 96 84 00 00 00    	mov    0x84(%esi),%edx
80103f64:	89 c1                	mov    %eax,%ecx
80103f66:	f7 d1                	not    %ecx
80103f68:	39 ca                	cmp    %ecx,%edx
80103f6a:	76 10                	jbe    80103f7c <exit+0x14c>
    overflow += curproc->vruntime + execVtime;
80103f6c:	31 db                	xor    %ebx,%ebx
80103f6e:	01 c2                	add    %eax,%edx
80103f70:	01 15 78 b6 10 80    	add    %edx,0x8010b678
80103f76:	11 1d 7c b6 10 80    	adc    %ebx,0x8010b67c
  curproc->vruntime += execVtime;
80103f7c:	01 86 84 00 00 00    	add    %eax,0x84(%esi)
  curproc->state = ZOMBIE;
80103f82:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103f89:	e8 e2 fd ff ff       	call   80103d70 <sched>
  panic("zombie exit");
80103f8e:	83 ec 0c             	sub    $0xc,%esp
80103f91:	68 9d 7e 10 80       	push   $0x80107e9d
80103f96:	e8 f5 c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103f9b:	83 ec 0c             	sub    $0xc,%esp
80103f9e:	68 90 7e 10 80       	push   $0x80107e90
80103fa3:	e8 e8 c3 ff ff       	call   80100390 <panic>
80103fa8:	90                   	nop
80103fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fb0 <yield>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	57                   	push   %edi
80103fb4:	56                   	push   %esi
80103fb5:	53                   	push   %ebx
80103fb6:	83 ec 2c             	sub    $0x2c,%esp
  int execVtime = (1000*ticks - myproc()->startTime)*(int)ceil((double)1024/weights[myproc()->nice]);
80103fb9:	69 35 80 69 11 80 e8 	imul   $0x3e8,0x80116980,%esi
80103fc0:	03 00 00 
  pushcli();
80103fc3:	e8 58 0b 00 00       	call   80104b20 <pushcli>
  c = mycpu();
80103fc8:	e8 a3 f8 ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103fcd:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80103fd3:	e8 88 0b 00 00       	call   80104b60 <popcli>
  int execVtime = (1000*ticks - myproc()->startTime)*(int)ceil((double)1024/weights[myproc()->nice]);
80103fd8:	2b b7 80 00 00 00    	sub    0x80(%edi),%esi
  pushcli();
80103fde:	e8 3d 0b 00 00       	call   80104b20 <pushcli>
  c = mycpu();
80103fe3:	e8 88 f8 ff ff       	call   80103870 <mycpu>
  p = c->proc;
80103fe8:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fee:	e8 6d 0b 00 00       	call   80104b60 <popcli>
  int execVtime = (1000*ticks - myproc()->startTime)*(int)ceil((double)1024/weights[myproc()->nice]);
80103ff3:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103ff6:	db 04 85 20 b0 10 80 	fildl  -0x7fef4fe0(,%eax,4)
80103ffd:	d8 3d ec 7f 10 80    	fdivrs 0x80107fec
80104003:	d9 7d e4             	fnstcw -0x1c(%ebp)
80104006:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010400a:	25 ff f3 00 00       	and    $0xf3ff,%eax
8010400f:	0d 00 08 00 00       	or     $0x800,%eax
80104014:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
80104018:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010401b:	d9 fc                	frndint 
8010401d:	d9 6d e4             	fldcw  -0x1c(%ebp)
80104020:	d9 7d ce             	fnstcw -0x32(%ebp)
80104023:	0f b7 45 ce          	movzwl -0x32(%ebp),%eax
80104027:	dd 5d d0             	fstpl  -0x30(%ebp)
8010402a:	dd 45 d0             	fldl   -0x30(%ebp)
8010402d:	80 cc 0c             	or     $0xc,%ah
80104030:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
80104034:	d9 6d cc             	fldcw  -0x34(%ebp)
80104037:	db 5d c8             	fistpl -0x38(%ebp)
8010403a:	d9 6d ce             	fldcw  -0x32(%ebp)
8010403d:	8b 5d c8             	mov    -0x38(%ebp),%ebx
80104040:	0f af de             	imul   %esi,%ebx
  if (execVtime > 0 && myproc()->vruntime > UINT32_MAX - execVtime) {
80104043:	85 db                	test   %ebx,%ebx
80104045:	7e 21                	jle    80104068 <yield+0xb8>
  pushcli();
80104047:	e8 d4 0a 00 00       	call   80104b20 <pushcli>
  c = mycpu();
8010404c:	e8 1f f8 ff ff       	call   80103870 <mycpu>
  p = c->proc;
80104051:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104057:	e8 04 0b 00 00       	call   80104b60 <popcli>
  if (execVtime > 0 && myproc()->vruntime > UINT32_MAX - execVtime) {
8010405c:	89 d8                	mov    %ebx,%eax
8010405e:	f7 d0                	not    %eax
80104060:	39 86 84 00 00 00    	cmp    %eax,0x84(%esi)
80104066:	77 68                	ja     801040d0 <yield+0x120>
  pushcli();
80104068:	e8 b3 0a 00 00       	call   80104b20 <pushcli>
  c = mycpu();
8010406d:	e8 fe f7 ff ff       	call   80103870 <mycpu>
  p = c->proc;
80104072:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104078:	e8 e3 0a 00 00       	call   80104b60 <popcli>
  acquire(&ptable.lock);  //DOC: yieldlock
8010407d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->vruntime += execVtime; 
80104080:	01 9e 84 00 00 00    	add    %ebx,0x84(%esi)
  acquire(&ptable.lock);  //DOC: yieldlock
80104086:	68 00 3e 11 80       	push   $0x80113e00
8010408b:	e8 60 0b 00 00       	call   80104bf0 <acquire>
  pushcli();
80104090:	e8 8b 0a 00 00       	call   80104b20 <pushcli>
  c = mycpu();
80104095:	e8 d6 f7 ff ff       	call   80103870 <mycpu>
  p = c->proc;
8010409a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040a0:	e8 bb 0a 00 00       	call   80104b60 <popcli>
  myproc()->state = RUNNABLE;
801040a5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040ac:	e8 bf fc ff ff       	call   80103d70 <sched>
  release(&ptable.lock);
801040b1:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
801040b8:	e8 f3 0b 00 00       	call   80104cb0 <release>
}
801040bd:	83 c4 10             	add    $0x10,%esp
801040c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040c3:	5b                   	pop    %ebx
801040c4:	5e                   	pop    %esi
801040c5:	5f                   	pop    %edi
801040c6:	5d                   	pop    %ebp
801040c7:	c3                   	ret    
801040c8:	90                   	nop
801040c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pushcli();
801040d0:	e8 4b 0a 00 00       	call   80104b20 <pushcli>
  c = mycpu();
801040d5:	e8 96 f7 ff ff       	call   80103870 <mycpu>
  p = c->proc;
801040da:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040e0:	e8 7b 0a 00 00       	call   80104b60 <popcli>
    overflow += myproc()->vruntime + execVtime;
801040e5:	31 d2                	xor    %edx,%edx
801040e7:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
801040ed:	01 d8                	add    %ebx,%eax
801040ef:	01 05 78 b6 10 80    	add    %eax,0x8010b678
801040f5:	11 15 7c b6 10 80    	adc    %edx,0x8010b67c
801040fb:	e9 68 ff ff ff       	jmp    80104068 <yield+0xb8>

80104100 <sleep>:
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	56                   	push   %esi
80104104:	53                   	push   %ebx
80104105:	83 ec 20             	sub    $0x20,%esp
80104108:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  pushcli();
8010410b:	e8 10 0a 00 00       	call   80104b20 <pushcli>
  c = mycpu();
80104110:	e8 5b f7 ff ff       	call   80103870 <mycpu>
  p = c->proc;
80104115:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010411b:	e8 40 0a 00 00       	call   80104b60 <popcli>
  if(p == 0)
80104120:	85 f6                	test   %esi,%esi
80104122:	0f 84 0f 01 00 00    	je     80104237 <sleep+0x137>
  if(lk == 0)
80104128:	85 db                	test   %ebx,%ebx
8010412a:	0f 84 fa 00 00 00    	je     8010422a <sleep+0x12a>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104130:	81 fb 00 3e 11 80    	cmp    $0x80113e00,%ebx
80104136:	74 18                	je     80104150 <sleep+0x50>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	68 00 3e 11 80       	push   $0x80113e00
80104140:	e8 ab 0a 00 00       	call   80104bf0 <acquire>
    release(lk);
80104145:	89 1c 24             	mov    %ebx,(%esp)
80104148:	e8 63 0b 00 00       	call   80104cb0 <release>
8010414d:	83 c4 10             	add    $0x10,%esp
  int execVtime = (1000*ticks - p->startTime)*(int)ceil((double)1024/weights[p->nice]);
80104150:	69 05 80 69 11 80 e8 	imul   $0x3e8,0x80116980,%eax
80104157:	03 00 00 
8010415a:	2b 86 80 00 00 00    	sub    0x80(%esi),%eax
80104160:	89 c2                	mov    %eax,%edx
80104162:	8b 46 7c             	mov    0x7c(%esi),%eax
80104165:	db 04 85 20 b0 10 80 	fildl  -0x7fef4fe0(,%eax,4)
8010416c:	d8 3d ec 7f 10 80    	fdivrs 0x80107fec
80104172:	d9 7d f4             	fnstcw -0xc(%ebp)
80104175:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
80104179:	25 ff f3 00 00       	and    $0xf3ff,%eax
8010417e:	0d 00 08 00 00       	or     $0x800,%eax
80104183:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80104187:	d9 6d f6             	fldcw  -0xa(%ebp)
8010418a:	d9 fc                	frndint 
8010418c:	d9 6d f4             	fldcw  -0xc(%ebp)
8010418f:	d9 7d de             	fnstcw -0x22(%ebp)
80104192:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
80104196:	dd 5d e0             	fstpl  -0x20(%ebp)
80104199:	dd 45 e0             	fldl   -0x20(%ebp)
8010419c:	80 cc 0c             	or     $0xc,%ah
8010419f:	66 89 45 dc          	mov    %ax,-0x24(%ebp)
801041a3:	d9 6d dc             	fldcw  -0x24(%ebp)
801041a6:	db 5d d8             	fistpl -0x28(%ebp)
801041a9:	d9 6d de             	fldcw  -0x22(%ebp)
801041ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
801041af:	0f af c2             	imul   %edx,%eax
  if (execVtime > 0 && p->vruntime > UINT32_MAX - execVtime) {
801041b2:	85 c0                	test   %eax,%eax
801041b4:	7e 6a                	jle    80104220 <sleep+0x120>
801041b6:	8b 96 84 00 00 00    	mov    0x84(%esi),%edx
801041bc:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
801041bf:	f7 d0                	not    %eax
801041c1:	39 c2                	cmp    %eax,%edx
801041c3:	77 4b                	ja     80104210 <sleep+0x110>
  p->chan = chan;
801041c5:	8b 45 08             	mov    0x8(%ebp),%eax
  p->vruntime += execVtime;
801041c8:	89 8e 84 00 00 00    	mov    %ecx,0x84(%esi)
  p->state = SLEEPING;
801041ce:	c7 46 0c 02 00 00 00 	movl   $0x2,0xc(%esi)
  p->chan = chan;
801041d5:	89 46 20             	mov    %eax,0x20(%esi)
  sched();
801041d8:	e8 93 fb ff ff       	call   80103d70 <sched>
  if(lk != &ptable.lock){  //DOC: sleeplock2
801041dd:	81 fb 00 3e 11 80    	cmp    $0x80113e00,%ebx
  p->chan = 0;
801041e3:	c7 46 20 00 00 00 00 	movl   $0x0,0x20(%esi)
  if(lk != &ptable.lock){  //DOC: sleeplock2
801041ea:	74 18                	je     80104204 <sleep+0x104>
    release(&ptable.lock);
801041ec:	83 ec 0c             	sub    $0xc,%esp
801041ef:	68 00 3e 11 80       	push   $0x80113e00
801041f4:	e8 b7 0a 00 00       	call   80104cb0 <release>
    acquire(lk);
801041f9:	89 1c 24             	mov    %ebx,(%esp)
801041fc:	e8 ef 09 00 00       	call   80104bf0 <acquire>
80104201:	83 c4 10             	add    $0x10,%esp
}
80104204:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104207:	5b                   	pop    %ebx
80104208:	5e                   	pop    %esi
80104209:	5d                   	pop    %ebp
8010420a:	c3                   	ret    
8010420b:	90                   	nop
8010420c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    overflow += p->vruntime + execVtime;
80104210:	31 d2                	xor    %edx,%edx
80104212:	01 0d 78 b6 10 80    	add    %ecx,0x8010b678
80104218:	11 15 7c b6 10 80    	adc    %edx,0x8010b67c
8010421e:	eb a5                	jmp    801041c5 <sleep+0xc5>
80104220:	03 86 84 00 00 00    	add    0x84(%esi),%eax
80104226:	89 c1                	mov    %eax,%ecx
80104228:	eb 9b                	jmp    801041c5 <sleep+0xc5>
    panic("sleep without lk");
8010422a:	83 ec 0c             	sub    $0xc,%esp
8010422d:	68 af 7e 10 80       	push   $0x80107eaf
80104232:	e8 59 c1 ff ff       	call   80100390 <panic>
    panic("sleep");
80104237:	83 ec 0c             	sub    $0xc,%esp
8010423a:	68 a9 7e 10 80       	push   $0x80107ea9
8010423f:	e8 4c c1 ff ff       	call   80100390 <panic>
80104244:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010424a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104250 <wait>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
  pushcli();
80104255:	e8 c6 08 00 00       	call   80104b20 <pushcli>
  c = mycpu();
8010425a:	e8 11 f6 ff ff       	call   80103870 <mycpu>
  p = c->proc;
8010425f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104265:	e8 f6 08 00 00       	call   80104b60 <popcli>
  acquire(&ptable.lock);
8010426a:	83 ec 0c             	sub    $0xc,%esp
8010426d:	68 00 3e 11 80       	push   $0x80113e00
80104272:	e8 79 09 00 00       	call   80104bf0 <acquire>
80104277:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010427a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010427c:	bb 34 3e 11 80       	mov    $0x80113e34,%ebx
80104281:	eb 13                	jmp    80104296 <wait+0x46>
80104283:	90                   	nop
80104284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104288:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010428e:	81 fb 34 61 11 80    	cmp    $0x80116134,%ebx
80104294:	73 1e                	jae    801042b4 <wait+0x64>
      if(p->parent != curproc)
80104296:	39 73 14             	cmp    %esi,0x14(%ebx)
80104299:	75 ed                	jne    80104288 <wait+0x38>
      if(p->state == ZOMBIE){
8010429b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010429f:	74 37                	je     801042d8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042a1:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
801042a7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042ac:	81 fb 34 61 11 80    	cmp    $0x80116134,%ebx
801042b2:	72 e2                	jb     80104296 <wait+0x46>
    if(!havekids || curproc->killed){
801042b4:	85 c0                	test   %eax,%eax
801042b6:	74 76                	je     8010432e <wait+0xde>
801042b8:	8b 46 24             	mov    0x24(%esi),%eax
801042bb:	85 c0                	test   %eax,%eax
801042bd:	75 6f                	jne    8010432e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801042bf:	83 ec 08             	sub    $0x8,%esp
801042c2:	68 00 3e 11 80       	push   $0x80113e00
801042c7:	56                   	push   %esi
801042c8:	e8 33 fe ff ff       	call   80104100 <sleep>
    havekids = 0;
801042cd:	83 c4 10             	add    $0x10,%esp
801042d0:	eb a8                	jmp    8010427a <wait+0x2a>
801042d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801042d8:	83 ec 0c             	sub    $0xc,%esp
801042db:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801042de:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801042e1:	e8 2a e0 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
801042e6:	5a                   	pop    %edx
801042e7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801042ea:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801042f1:	e8 aa 32 00 00       	call   801075a0 <freevm>
        release(&ptable.lock);
801042f6:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
        p->pid = 0;
801042fd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104304:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010430b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010430f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104316:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010431d:	e8 8e 09 00 00       	call   80104cb0 <release>
        return pid;
80104322:	83 c4 10             	add    $0x10,%esp
}
80104325:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104328:	89 f0                	mov    %esi,%eax
8010432a:	5b                   	pop    %ebx
8010432b:	5e                   	pop    %esi
8010432c:	5d                   	pop    %ebp
8010432d:	c3                   	ret    
      release(&ptable.lock);
8010432e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104331:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104336:	68 00 3e 11 80       	push   $0x80113e00
8010433b:	e8 70 09 00 00       	call   80104cb0 <release>
      return -1;
80104340:	83 c4 10             	add    $0x10,%esp
80104343:	eb e0                	jmp    80104325 <wait+0xd5>
80104345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104350 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 10             	sub    $0x10,%esp
80104357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010435a:	68 00 3e 11 80       	push   $0x80113e00
8010435f:	e8 8c 08 00 00       	call   80104bf0 <acquire>
  wakeup1(chan);
80104364:	89 d8                	mov    %ebx,%eax
80104366:	e8 95 f2 ff ff       	call   80103600 <wakeup1>
  release(&ptable.lock);
8010436b:	83 c4 10             	add    $0x10,%esp
8010436e:	c7 45 08 00 3e 11 80 	movl   $0x80113e00,0x8(%ebp)
}
80104375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104378:	c9                   	leave  
  release(&ptable.lock);
80104379:	e9 32 09 00 00       	jmp    80104cb0 <release>
8010437e:	66 90                	xchg   %ax,%ax

80104380 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
80104384:	83 ec 10             	sub    $0x10,%esp
80104387:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010438a:	68 00 3e 11 80       	push   $0x80113e00
8010438f:	e8 5c 08 00 00       	call   80104bf0 <acquire>
80104394:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104397:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
8010439c:	eb 0e                	jmp    801043ac <kill+0x2c>
8010439e:	66 90                	xchg   %ax,%ax
801043a0:	05 8c 00 00 00       	add    $0x8c,%eax
801043a5:	3d 34 61 11 80       	cmp    $0x80116134,%eax
801043aa:	73 34                	jae    801043e0 <kill+0x60>
    if(p->pid == pid){
801043ac:	39 58 10             	cmp    %ebx,0x10(%eax)
801043af:	75 ef                	jne    801043a0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043b1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043b5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043bc:	75 07                	jne    801043c5 <kill+0x45>
        p->state = RUNNABLE;
801043be:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043c5:	83 ec 0c             	sub    $0xc,%esp
801043c8:	68 00 3e 11 80       	push   $0x80113e00
801043cd:	e8 de 08 00 00       	call   80104cb0 <release>
      return 0;
801043d2:	83 c4 10             	add    $0x10,%esp
801043d5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801043d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043da:	c9                   	leave  
801043db:	c3                   	ret    
801043dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801043e0:	83 ec 0c             	sub    $0xc,%esp
801043e3:	68 00 3e 11 80       	push   $0x80113e00
801043e8:	e8 c3 08 00 00       	call   80104cb0 <release>
  return -1;
801043ed:	83 c4 10             	add    $0x10,%esp
801043f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043f8:	c9                   	leave  
801043f9:	c3                   	ret    
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104400 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	57                   	push   %edi
80104404:	56                   	push   %esi
80104405:	53                   	push   %ebx
80104406:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104409:	bb 34 3e 11 80       	mov    $0x80113e34,%ebx
{
8010440e:	83 ec 3c             	sub    $0x3c,%esp
80104411:	eb 27                	jmp    8010443a <procdump+0x3a>
80104413:	90                   	nop
80104414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104418:	83 ec 0c             	sub    $0xc,%esp
8010441b:	68 03 83 10 80       	push   $0x80108303
80104420:	e8 3b c2 ff ff       	call   80100660 <cprintf>
80104425:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104428:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010442e:	81 fb 34 61 11 80    	cmp    $0x80116134,%ebx
80104434:	0f 83 86 00 00 00    	jae    801044c0 <procdump+0xc0>
    if(p->state == UNUSED)
8010443a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010443d:	85 c0                	test   %eax,%eax
8010443f:	74 e7                	je     80104428 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104441:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104444:	ba c0 7e 10 80       	mov    $0x80107ec0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104449:	77 11                	ja     8010445c <procdump+0x5c>
8010444b:	8b 14 85 d4 7f 10 80 	mov    -0x7fef802c(,%eax,4),%edx
      state = "???";
80104452:	b8 c0 7e 10 80       	mov    $0x80107ec0,%eax
80104457:	85 d2                	test   %edx,%edx
80104459:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010445c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010445f:	50                   	push   %eax
80104460:	52                   	push   %edx
80104461:	ff 73 10             	pushl  0x10(%ebx)
80104464:	68 c4 7e 10 80       	push   $0x80107ec4
80104469:	e8 f2 c1 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010446e:	83 c4 10             	add    $0x10,%esp
80104471:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104475:	75 a1                	jne    80104418 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104477:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010447a:	83 ec 08             	sub    $0x8,%esp
8010447d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104480:	50                   	push   %eax
80104481:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104484:	8b 40 0c             	mov    0xc(%eax),%eax
80104487:	83 c0 08             	add    $0x8,%eax
8010448a:	50                   	push   %eax
8010448b:	e8 40 06 00 00       	call   80104ad0 <getcallerpcs>
80104490:	83 c4 10             	add    $0x10,%esp
80104493:	90                   	nop
80104494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104498:	8b 17                	mov    (%edi),%edx
8010449a:	85 d2                	test   %edx,%edx
8010449c:	0f 84 76 ff ff ff    	je     80104418 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044a2:	83 ec 08             	sub    $0x8,%esp
801044a5:	83 c7 04             	add    $0x4,%edi
801044a8:	52                   	push   %edx
801044a9:	68 01 79 10 80       	push   $0x80107901
801044ae:	e8 ad c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044b3:	83 c4 10             	add    $0x10,%esp
801044b6:	39 fe                	cmp    %edi,%esi
801044b8:	75 de                	jne    80104498 <procdump+0x98>
801044ba:	e9 59 ff ff ff       	jmp    80104418 <procdump+0x18>
801044bf:	90                   	nop
  }
}
801044c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044c3:	5b                   	pop    %ebx
801044c4:	5e                   	pop    %esi
801044c5:	5f                   	pop    %edi
801044c6:	5d                   	pop    %ebp
801044c7:	c3                   	ret    
801044c8:	90                   	nop
801044c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044d0 <getpname>:

int
getpname(int pid)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	53                   	push   %ebx
801044d4:	83 ec 10             	sub    $0x10,%esp
801044d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801044da:	68 00 3e 11 80       	push   $0x80113e00
801044df:	e8 0c 07 00 00       	call   80104bf0 <acquire>
801044e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044e7:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
801044ec:	eb 0e                	jmp    801044fc <getpname+0x2c>
801044ee:	66 90                	xchg   %ax,%ax
801044f0:	05 8c 00 00 00       	add    $0x8c,%eax
801044f5:	3d 34 61 11 80       	cmp    $0x80116134,%eax
801044fa:	73 34                	jae    80104530 <getpname+0x60>
    if(p->pid == pid){
801044fc:	39 58 10             	cmp    %ebx,0x10(%eax)
801044ff:	75 ef                	jne    801044f0 <getpname+0x20>
      cprintf("%s\n", p->name);
80104501:	83 ec 08             	sub    $0x8,%esp
80104504:	83 c0 6c             	add    $0x6c,%eax
80104507:	50                   	push   %eax
80104508:	68 cd 7e 10 80       	push   $0x80107ecd
8010450d:	e8 4e c1 ff ff       	call   80100660 <cprintf>
      release(&ptable.lock);
80104512:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80104519:	e8 92 07 00 00       	call   80104cb0 <release>
      return 0;
8010451e:	83 c4 10             	add    $0x10,%esp
80104521:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104523:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104526:	c9                   	leave  
80104527:	c3                   	ret    
80104528:	90                   	nop
80104529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104530:	83 ec 0c             	sub    $0xc,%esp
80104533:	68 00 3e 11 80       	push   $0x80113e00
80104538:	e8 73 07 00 00       	call   80104cb0 <release>
  return -1;
8010453d:	83 c4 10             	add    $0x10,%esp
80104540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104548:	c9                   	leave  
80104549:	c3                   	ret    
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104550 <getnice>:

int
getnice(int pid)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	8b 75 08             	mov    0x8(%ebp),%esi
  if(pid <= 0) return -1;
80104558:	85 f6                	test   %esi,%esi
8010455a:	7e 68                	jle    801045c4 <getnice+0x74>

  struct proc *p;
  acquire(&ptable.lock);
8010455c:	83 ec 0c             	sub    $0xc,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010455f:	bb 34 3e 11 80       	mov    $0x80113e34,%ebx
  acquire(&ptable.lock);
80104564:	68 00 3e 11 80       	push   $0x80113e00
80104569:	e8 82 06 00 00       	call   80104bf0 <acquire>
8010456e:	83 c4 10             	add    $0x10,%esp
80104571:	eb 13                	jmp    80104586 <getnice+0x36>
80104573:	90                   	nop
80104574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104578:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010457e:	81 fb 34 61 11 80    	cmp    $0x80116134,%ebx
80104584:	73 22                	jae    801045a8 <getnice+0x58>
    if(p->pid == pid){
80104586:	39 73 10             	cmp    %esi,0x10(%ebx)
80104589:	75 ed                	jne    80104578 <getnice+0x28>
      release(&ptable.lock);
8010458b:	83 ec 0c             	sub    $0xc,%esp
8010458e:	68 00 3e 11 80       	push   $0x80113e00
80104593:	e8 18 07 00 00       	call   80104cb0 <release>
      return p->nice;
80104598:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010459b:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
}
8010459e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045a1:	5b                   	pop    %ebx
801045a2:	5e                   	pop    %esi
801045a3:	5d                   	pop    %ebp
801045a4:	c3                   	ret    
801045a5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
801045a8:	83 ec 0c             	sub    $0xc,%esp
801045ab:	68 00 3e 11 80       	push   $0x80113e00
801045b0:	e8 fb 06 00 00       	call   80104cb0 <release>
  return -1;
801045b5:	83 c4 10             	add    $0x10,%esp
}
801045b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -1;
801045bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045c0:	5b                   	pop    %ebx
801045c1:	5e                   	pop    %esi
801045c2:	5d                   	pop    %ebp
801045c3:	c3                   	ret    
  if(pid <= 0) return -1;
801045c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045c9:	eb d3                	jmp    8010459e <getnice+0x4e>
801045cb:	90                   	nop
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045d0 <setnice>:

int
setnice(int pid, int value)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
801045d5:	8b 75 0c             	mov    0xc(%ebp),%esi
801045d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
   if (value < 0 || value >= 40 || pid <= 0) return -1;
801045db:	83 fe 27             	cmp    $0x27,%esi
801045de:	77 74                	ja     80104654 <setnice+0x84>
801045e0:	85 db                	test   %ebx,%ebx
801045e2:	7e 70                	jle    80104654 <setnice+0x84>

   struct proc *p;
   acquire(&ptable.lock);
801045e4:	83 ec 0c             	sub    $0xc,%esp
801045e7:	68 00 3e 11 80       	push   $0x80113e00
801045ec:	e8 ff 05 00 00       	call   80104bf0 <acquire>
801045f1:	83 c4 10             	add    $0x10,%esp
   
   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045f4:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
801045f9:	eb 11                	jmp    8010460c <setnice+0x3c>
801045fb:	90                   	nop
801045fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104600:	05 8c 00 00 00       	add    $0x8c,%eax
80104605:	3d 34 61 11 80       	cmp    $0x80116134,%eax
8010460a:	73 2c                	jae    80104638 <setnice+0x68>
      if(p->pid == pid){
8010460c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010460f:	75 ef                	jne    80104600 <setnice+0x30>
        p->nice = value;
	      release(&ptable.lock);
80104611:	83 ec 0c             	sub    $0xc,%esp
        p->nice = value;
80104614:	89 70 7c             	mov    %esi,0x7c(%eax)
	      release(&ptable.lock);
80104617:	68 00 3e 11 80       	push   $0x80113e00
8010461c:	e8 8f 06 00 00       	call   80104cb0 <release>
	      yield();
80104621:	e8 8a f9 ff ff       	call   80103fb0 <yield>
	      return 0;
80104626:	83 c4 10             	add    $0x10,%esp
80104629:	31 c0                	xor    %eax,%eax
      }
   }
   release(&ptable.lock);
   return -1;

}
8010462b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010462e:	5b                   	pop    %ebx
8010462f:	5e                   	pop    %esi
80104630:	5d                   	pop    %ebp
80104631:	c3                   	ret    
80104632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
   release(&ptable.lock);
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	68 00 3e 11 80       	push   $0x80113e00
80104640:	e8 6b 06 00 00       	call   80104cb0 <release>
   return -1;
80104645:	83 c4 10             	add    $0x10,%esp
}
80104648:	8d 65 f8             	lea    -0x8(%ebp),%esp
   return -1;
8010464b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104650:	5b                   	pop    %ebx
80104651:	5e                   	pop    %esi
80104652:	5d                   	pop    %ebp
80104653:	c3                   	ret    
   if (value < 0 || value >= 40 || pid <= 0) return -1;
80104654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104659:	eb d0                	jmp    8010462b <setnice+0x5b>
8010465b:	90                   	nop
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104660 <ps>:

void
ps(int pid)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	57                   	push   %edi
80104664:	56                   	push   %esi
80104665:	53                   	push   %ebx
80104666:	83 ec 38             	sub    $0x38,%esp
80104669:	8b 5d 08             	mov    0x8(%ebp),%ebx
  asm volatile("sti");
8010466c:	fb                   	sti    
   sti();
   struct proc *p = ptable.proc;
   acquire(&ptable.lock);
8010466d:	68 00 3e 11 80       	push   $0x80113e00
          cprintf("%*s\t%*i\t%*s\t%*i\t%*i\t%*i\t%*i\t%*i\n", -15, p->name, ppid, state, p->nice, rw, runtime, p->vruntime, totalTicks); 
        }
      }
   }
   else{
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104672:	bf 34 3e 11 80       	mov    $0x80113e34,%edi
   acquire(&ptable.lock);
80104677:	e8 74 05 00 00       	call   80104bf0 <acquire>
   int runtime = (1000*ticks - p->startTime);
8010467c:	69 05 80 69 11 80 e8 	imul   $0x3e8,0x80116980,%eax
80104683:	03 00 00 
   int rw = runtime/weights[p->nice];
80104686:	8b 35 b0 3e 11 80    	mov    0x80113eb0,%esi
   if(pid == 0){
8010468c:	83 c4 10             	add    $0x10,%esp
   int runtime = (1000*ticks - p->startTime);
8010468f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104692:	2b 05 b4 3e 11 80    	sub    0x80113eb4,%eax
   int rw = runtime/weights[p->nice];
80104698:	99                   	cltd   
   int runtime = (1000*ticks - p->startTime);
80104699:	89 45 d4             	mov    %eax,-0x2c(%ebp)
   int rw = runtime/weights[p->nice];
8010469c:	f7 3c b5 20 b0 10 80 	idivl  -0x7fef4fe0(,%esi,4)
   if(pid == 0){
801046a3:	85 db                	test   %ebx,%ebx
   int rw = runtime/weights[p->nice];
801046a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
   if(pid == 0){
801046a8:	75 18                	jne    801046c2 <ps+0x62>
801046aa:	e9 41 01 00 00       	jmp    801047f0 <ps+0x190>
801046af:	90                   	nop
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046b0:	81 c7 8c 00 00 00    	add    $0x8c,%edi
801046b6:	81 ff 34 61 11 80    	cmp    $0x80116134,%edi
801046bc:	0f 83 d3 00 00 00    	jae    80104795 <ps+0x135>
        if(p->pid == pid){
801046c2:	39 5f 10             	cmp    %ebx,0x10(%edi)
801046c5:	75 e9                	jne    801046b0 <ps+0x50>
            //cprintf("name\tpid\tstate\tpriority\n");
            cprintf("%*s\t%*s\t%*s\t%*s\t%*s\t%*s\t%*s\t%*s\n", -15, "name", "pid", "state", "priority", "runtime/weight", "runtime", "vruntime", "ticks");
801046c7:	83 ec 08             	sub    $0x8,%esp
801046ca:	68 f3 7e 10 80       	push   $0x80107ef3
801046cf:	68 f9 7e 10 80       	push   $0x80107ef9
801046d4:	68 fa 7e 10 80       	push   $0x80107efa
801046d9:	68 02 7f 10 80       	push   $0x80107f02
801046de:	68 11 7f 10 80       	push   $0x80107f11
801046e3:	68 1a 7f 10 80       	push   $0x80107f1a
801046e8:	68 20 7f 10 80       	push   $0x80107f20
801046ed:	68 24 7f 10 80       	push   $0x80107f24
801046f2:	6a f1                	push   $0xfffffff1
801046f4:	68 68 7f 10 80       	push   $0x80107f68
801046f9:	e8 62 bf ff ff       	call   80100660 <cprintf>
            char *state = "";
            int ppid;
            if      (p->state == EMBRYO) state = "embryo";
801046fe:	8b 47 0c             	mov    0xc(%edi),%eax
80104701:	83 c4 30             	add    $0x30,%esp
80104704:	83 f8 01             	cmp    $0x1,%eax
80104707:	0f 84 2f 02 00 00    	je     8010493c <ps+0x2dc>
            else if (p->state == SLEEPING) state = "sleep";
8010470d:	83 f8 02             	cmp    $0x2,%eax
80104710:	0f 84 56 02 00 00    	je     8010496c <ps+0x30c>
            else if (p->state == RUNNABLE) state = "runnable";
80104716:	83 f8 03             	cmp    $0x3,%eax
80104719:	0f 84 41 02 00 00    	je     80104960 <ps+0x300>
            else if (p->state == RUNNING)  state = "run";
8010471f:	83 f8 04             	cmp    $0x4,%eax
80104722:	0f 84 2c 02 00 00    	je     80104954 <ps+0x2f4>
            else if (p->state == ZOMBIE)   state = "zombie";
80104728:	83 f8 05             	cmp    $0x5,%eax
8010472b:	0f 84 17 02 00 00    	je     80104948 <ps+0x2e8>
            else if (p->state == UNUSED)   state = "unused";
80104731:	85 c0                	test   %eax,%eax
80104733:	0f 85 77 ff ff ff    	jne    801046b0 <ps+0x50>
80104739:	c7 45 dc ec 7e 10 80 	movl   $0x80107eec,-0x24(%ebp)
            else continue;

            if(p->parent->pid < 0) ppid = p->pid;
80104740:	8b 47 14             	mov    0x14(%edi),%eax
80104743:	8b 70 10             	mov    0x10(%eax),%esi
80104746:	85 f6                	test   %esi,%esi
80104748:	0f 88 92 00 00 00    	js     801047e0 <ps+0x180>
            else ppid = p->parent->pid;
            // cprintf("%s\t%d\t%s\t%d\n", p->name, ppid, state, p->nice);
            // cprintf("%*s\t%*i\t%*s\t%*i\t%*i\t%*i\t%*i\t%*i\n", -10, p->name, ppid, state, p->nice, rw, runtime, p->vruntime, totalTicks);
            if (overflow) {
8010474e:	a1 78 b6 10 80       	mov    0x8010b678,%eax
80104753:	8b 15 7c b6 10 80    	mov    0x8010b67c,%edx
80104759:	8d 4f 6c             	lea    0x6c(%edi),%ecx
8010475c:	8b 5f 7c             	mov    0x7c(%edi),%ebx
8010475f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104762:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104765:	89 c2                	mov    %eax,%edx
80104767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010476a:	09 d0                	or     %edx,%eax
8010476c:	74 42                	je     801047b0 <ps+0x150>
              cprintf("%*s\t%*i\t%*s\t%*i\t%*i\t%*i\t%*llu\t%*i\n", -15, p->name, ppid, state, p->nice, rw, runtime, (unsigned long long)overflow, totalTicks); 
8010476e:	83 ec 04             	sub    $0x4,%esp
80104771:	ff 75 d8             	pushl  -0x28(%ebp)
80104774:	ff 75 e4             	pushl  -0x1c(%ebp)
80104777:	ff 75 e0             	pushl  -0x20(%ebp)
8010477a:	ff 75 d4             	pushl  -0x2c(%ebp)
8010477d:	ff 75 d0             	pushl  -0x30(%ebp)
80104780:	53                   	push   %ebx
80104781:	ff 75 dc             	pushl  -0x24(%ebp)
80104784:	56                   	push   %esi
80104785:	51                   	push   %ecx
80104786:	6a f1                	push   $0xfffffff1
80104788:	68 8c 7f 10 80       	push   $0x80107f8c
8010478d:	e8 ce be ff ff       	call   80100660 <cprintf>
80104792:	83 c4 30             	add    $0x30,%esp
            }
            break;
	      }
      }
   }
   release(&ptable.lock);
80104795:	c7 45 08 00 3e 11 80 	movl   $0x80113e00,0x8(%ebp)
}
8010479c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010479f:	5b                   	pop    %ebx
801047a0:	5e                   	pop    %esi
801047a1:	5f                   	pop    %edi
801047a2:	5d                   	pop    %ebp
   release(&ptable.lock);
801047a3:	e9 08 05 00 00       	jmp    80104cb0 <release>
801047a8:	90                   	nop
801047a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
              cprintf("%*s\t%*i\t%*s\t%*i\t%*i\t%*i\t%*i\t%*i\n", -15, p->name, ppid, state, p->nice, rw, runtime, p->vruntime, totalTicks); 
801047b0:	83 ec 08             	sub    $0x8,%esp
801047b3:	ff 75 d8             	pushl  -0x28(%ebp)
801047b6:	ff b7 84 00 00 00    	pushl  0x84(%edi)
801047bc:	ff 75 d4             	pushl  -0x2c(%ebp)
801047bf:	ff 75 d0             	pushl  -0x30(%ebp)
801047c2:	53                   	push   %ebx
801047c3:	ff 75 dc             	pushl  -0x24(%ebp)
801047c6:	56                   	push   %esi
801047c7:	51                   	push   %ecx
801047c8:	6a f1                	push   $0xfffffff1
801047ca:	68 b0 7f 10 80       	push   $0x80107fb0
801047cf:	e8 8c be ff ff       	call   80100660 <cprintf>
801047d4:	83 c4 30             	add    $0x30,%esp
801047d7:	eb bc                	jmp    80104795 <ps+0x135>
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if(p->parent->pid < 0) ppid = p->pid;
801047e0:	8b 77 10             	mov    0x10(%edi),%esi
801047e3:	e9 66 ff ff ff       	jmp    8010474e <ps+0xee>
801047e8:	90                   	nop
801047e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("%*s\t%*s\t%*s\t%*s\t%*s\t%*s\t%*s\t%*s\n", -15, "name", "pid", "state", "priority", "runtime/weight", "runtime", "vruntime", "ticks");
801047f0:	83 ec 08             	sub    $0x8,%esp
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047f3:	89 fb                	mov    %edi,%ebx
      cprintf("%*s\t%*s\t%*s\t%*s\t%*s\t%*s\t%*s\t%*s\n", -15, "name", "pid", "state", "priority", "runtime/weight", "runtime", "vruntime", "ticks");
801047f5:	68 f3 7e 10 80       	push   $0x80107ef3
801047fa:	68 f9 7e 10 80       	push   $0x80107ef9
801047ff:	68 fa 7e 10 80       	push   $0x80107efa
80104804:	68 02 7f 10 80       	push   $0x80107f02
80104809:	68 11 7f 10 80       	push   $0x80107f11
8010480e:	68 1a 7f 10 80       	push   $0x80107f1a
80104813:	68 20 7f 10 80       	push   $0x80107f20
80104818:	68 24 7f 10 80       	push   $0x80107f24
8010481d:	6a f1                	push   $0xfffffff1
8010481f:	68 68 7f 10 80       	push   $0x80107f68
80104824:	e8 37 be ff ff       	call   80100660 <cprintf>
80104829:	83 c4 30             	add    $0x30,%esp
8010482c:	eb 3b                	jmp    80104869 <ps+0x209>
8010482e:	66 90                	xchg   %ax,%ax
          cprintf("%*s\t%*i\t%*s\t%*i\t%*i\t%*i\t%*llu\t%*i\n", -15, p->name, ppid, state, p->nice, rw, runtime, (unsigned long long)overflow, totalTicks); 
80104830:	83 ec 04             	sub    $0x4,%esp
80104833:	ff 75 d8             	pushl  -0x28(%ebp)
80104836:	ff 75 e4             	pushl  -0x1c(%ebp)
80104839:	ff 75 e0             	pushl  -0x20(%ebp)
8010483c:	ff 75 d4             	pushl  -0x2c(%ebp)
8010483f:	ff 75 d0             	pushl  -0x30(%ebp)
80104842:	57                   	push   %edi
80104843:	ff 75 dc             	pushl  -0x24(%ebp)
80104846:	51                   	push   %ecx
80104847:	56                   	push   %esi
80104848:	6a f1                	push   $0xfffffff1
8010484a:	68 8c 7f 10 80       	push   $0x80107f8c
8010484f:	e8 0c be ff ff       	call   80100660 <cprintf>
80104854:	83 c4 30             	add    $0x30,%esp
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104857:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010485d:	81 fb 34 61 11 80    	cmp    $0x80116134,%ebx
80104863:	0f 83 2c ff ff ff    	jae    80104795 <ps+0x135>
        if      (p->state == EMBRYO) state = "embryo";
80104869:	8b 43 0c             	mov    0xc(%ebx),%eax
8010486c:	83 f8 01             	cmp    $0x1,%eax
8010486f:	0f 84 8b 00 00 00    	je     80104900 <ps+0x2a0>
	      else if (p->state == SLEEPING) state = "sleep";
80104875:	83 f8 02             	cmp    $0x2,%eax
80104878:	0f 84 92 00 00 00    	je     80104910 <ps+0x2b0>
	      else if (p->state == RUNNABLE) state = "runnable";
8010487e:	83 f8 03             	cmp    $0x3,%eax
80104881:	0f 84 99 00 00 00    	je     80104920 <ps+0x2c0>
	      else if (p->state == RUNNING)  state = "run";
80104887:	83 f8 04             	cmp    $0x4,%eax
8010488a:	0f 84 a0 00 00 00    	je     80104930 <ps+0x2d0>
	      else if (p->state == ZOMBIE)   state = "zombie";
80104890:	83 f8 05             	cmp    $0x5,%eax
80104893:	75 c2                	jne    80104857 <ps+0x1f7>
80104895:	c7 45 dc e5 7e 10 80 	movl   $0x80107ee5,-0x24(%ebp)
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	      if(p->parent->pid < 0) ppid = p->pid;
801048a0:	8b 43 14             	mov    0x14(%ebx),%eax
801048a3:	8b 48 10             	mov    0x10(%eax),%ecx
801048a6:	85 c9                	test   %ecx,%ecx
801048a8:	79 03                	jns    801048ad <ps+0x24d>
801048aa:	8b 4b 10             	mov    0x10(%ebx),%ecx
        if (overflow) {
801048ad:	a1 78 b6 10 80       	mov    0x8010b678,%eax
801048b2:	8b 15 7c b6 10 80    	mov    0x8010b67c,%edx
801048b8:	8d 73 6c             	lea    0x6c(%ebx),%esi
801048bb:	8b 7b 7c             	mov    0x7c(%ebx),%edi
801048be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801048c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801048c4:	89 c2                	mov    %eax,%edx
801048c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801048c9:	09 d0                	or     %edx,%eax
801048cb:	0f 85 5f ff ff ff    	jne    80104830 <ps+0x1d0>
          cprintf("%*s\t%*i\t%*s\t%*i\t%*i\t%*i\t%*i\t%*i\n", -15, p->name, ppid, state, p->nice, rw, runtime, p->vruntime, totalTicks); 
801048d1:	83 ec 08             	sub    $0x8,%esp
801048d4:	ff 75 d8             	pushl  -0x28(%ebp)
801048d7:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
801048dd:	ff 75 d4             	pushl  -0x2c(%ebp)
801048e0:	ff 75 d0             	pushl  -0x30(%ebp)
801048e3:	57                   	push   %edi
801048e4:	ff 75 dc             	pushl  -0x24(%ebp)
801048e7:	51                   	push   %ecx
801048e8:	56                   	push   %esi
801048e9:	6a f1                	push   $0xfffffff1
801048eb:	68 b0 7f 10 80       	push   $0x80107fb0
801048f0:	e8 6b bd ff ff       	call   80100660 <cprintf>
801048f5:	83 c4 30             	add    $0x30,%esp
801048f8:	e9 5a ff ff ff       	jmp    80104857 <ps+0x1f7>
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
        if      (p->state == EMBRYO) state = "embryo";
80104900:	c7 45 dc d1 7e 10 80 	movl   $0x80107ed1,-0x24(%ebp)
80104907:	eb 97                	jmp    801048a0 <ps+0x240>
80104909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	      else if (p->state == SLEEPING) state = "sleep";
80104910:	c7 45 dc a9 7e 10 80 	movl   $0x80107ea9,-0x24(%ebp)
80104917:	eb 87                	jmp    801048a0 <ps+0x240>
80104919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	      else if (p->state == RUNNABLE) state = "runnable";
80104920:	c7 45 dc d8 7e 10 80 	movl   $0x80107ed8,-0x24(%ebp)
80104927:	e9 74 ff ff ff       	jmp    801048a0 <ps+0x240>
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	      else if (p->state == RUNNING)  state = "run";
80104930:	c7 45 dc e1 7e 10 80 	movl   $0x80107ee1,-0x24(%ebp)
80104937:	e9 64 ff ff ff       	jmp    801048a0 <ps+0x240>
            if      (p->state == EMBRYO) state = "embryo";
8010493c:	c7 45 dc d1 7e 10 80 	movl   $0x80107ed1,-0x24(%ebp)
80104943:	e9 f8 fd ff ff       	jmp    80104740 <ps+0xe0>
            else if (p->state == ZOMBIE)   state = "zombie";
80104948:	c7 45 dc e5 7e 10 80 	movl   $0x80107ee5,-0x24(%ebp)
8010494f:	e9 ec fd ff ff       	jmp    80104740 <ps+0xe0>
            else if (p->state == RUNNING)  state = "run";
80104954:	c7 45 dc e1 7e 10 80 	movl   $0x80107ee1,-0x24(%ebp)
8010495b:	e9 e0 fd ff ff       	jmp    80104740 <ps+0xe0>
            else if (p->state == RUNNABLE) state = "runnable";
80104960:	c7 45 dc d8 7e 10 80 	movl   $0x80107ed8,-0x24(%ebp)
80104967:	e9 d4 fd ff ff       	jmp    80104740 <ps+0xe0>
            else if (p->state == SLEEPING) state = "sleep";
8010496c:	c7 45 dc a9 7e 10 80 	movl   $0x80107ea9,-0x24(%ebp)
80104973:	e9 c8 fd ff ff       	jmp    80104740 <ps+0xe0>
80104978:	66 90                	xchg   %ax,%ax
8010497a:	66 90                	xchg   %ax,%ax
8010497c:	66 90                	xchg   %ax,%ax
8010497e:	66 90                	xchg   %ax,%ax

80104980 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	53                   	push   %ebx
80104984:	83 ec 0c             	sub    $0xc,%esp
80104987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010498a:	68 f0 7f 10 80       	push   $0x80107ff0
8010498f:	8d 43 04             	lea    0x4(%ebx),%eax
80104992:	50                   	push   %eax
80104993:	e8 18 01 00 00       	call   80104ab0 <initlock>
  lk->name = name;
80104998:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010499b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801049a1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801049a4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801049ab:	89 43 38             	mov    %eax,0x38(%ebx)
}
801049ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b1:	c9                   	leave  
801049b2:	c3                   	ret    
801049b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	53                   	push   %ebx
801049c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049c8:	83 ec 0c             	sub    $0xc,%esp
801049cb:	8d 73 04             	lea    0x4(%ebx),%esi
801049ce:	56                   	push   %esi
801049cf:	e8 1c 02 00 00       	call   80104bf0 <acquire>
  while (lk->locked) {
801049d4:	8b 13                	mov    (%ebx),%edx
801049d6:	83 c4 10             	add    $0x10,%esp
801049d9:	85 d2                	test   %edx,%edx
801049db:	74 16                	je     801049f3 <acquiresleep+0x33>
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801049e0:	83 ec 08             	sub    $0x8,%esp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	e8 16 f7 ff ff       	call   80104100 <sleep>
  while (lk->locked) {
801049ea:	8b 03                	mov    (%ebx),%eax
801049ec:	83 c4 10             	add    $0x10,%esp
801049ef:	85 c0                	test   %eax,%eax
801049f1:	75 ed                	jne    801049e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801049f3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801049f9:	e8 12 ef ff ff       	call   80103910 <myproc>
801049fe:	8b 40 10             	mov    0x10(%eax),%eax
80104a01:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a04:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a07:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a0a:	5b                   	pop    %ebx
80104a0b:	5e                   	pop    %esi
80104a0c:	5d                   	pop    %ebp
  release(&lk->lk);
80104a0d:	e9 9e 02 00 00       	jmp    80104cb0 <release>
80104a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a20 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a28:	83 ec 0c             	sub    $0xc,%esp
80104a2b:	8d 73 04             	lea    0x4(%ebx),%esi
80104a2e:	56                   	push   %esi
80104a2f:	e8 bc 01 00 00       	call   80104bf0 <acquire>
  lk->locked = 0;
80104a34:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a3a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a41:	89 1c 24             	mov    %ebx,(%esp)
80104a44:	e8 07 f9 ff ff       	call   80104350 <wakeup>
  release(&lk->lk);
80104a49:	89 75 08             	mov    %esi,0x8(%ebp)
80104a4c:	83 c4 10             	add    $0x10,%esp
}
80104a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a52:	5b                   	pop    %ebx
80104a53:	5e                   	pop    %esi
80104a54:	5d                   	pop    %ebp
  release(&lk->lk);
80104a55:	e9 56 02 00 00       	jmp    80104cb0 <release>
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a60 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	57                   	push   %edi
80104a64:	56                   	push   %esi
80104a65:	53                   	push   %ebx
80104a66:	31 ff                	xor    %edi,%edi
80104a68:	83 ec 18             	sub    $0x18,%esp
80104a6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a6e:	8d 73 04             	lea    0x4(%ebx),%esi
80104a71:	56                   	push   %esi
80104a72:	e8 79 01 00 00       	call   80104bf0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a77:	8b 03                	mov    (%ebx),%eax
80104a79:	83 c4 10             	add    $0x10,%esp
80104a7c:	85 c0                	test   %eax,%eax
80104a7e:	74 13                	je     80104a93 <holdingsleep+0x33>
80104a80:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a83:	e8 88 ee ff ff       	call   80103910 <myproc>
80104a88:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a8b:	0f 94 c0             	sete   %al
80104a8e:	0f b6 c0             	movzbl %al,%eax
80104a91:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104a93:	83 ec 0c             	sub    $0xc,%esp
80104a96:	56                   	push   %esi
80104a97:	e8 14 02 00 00       	call   80104cb0 <release>
  return r;
}
80104a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a9f:	89 f8                	mov    %edi,%eax
80104aa1:	5b                   	pop    %ebx
80104aa2:	5e                   	pop    %esi
80104aa3:	5f                   	pop    %edi
80104aa4:	5d                   	pop    %ebp
80104aa5:	c3                   	ret    
80104aa6:	66 90                	xchg   %ax,%ax
80104aa8:	66 90                	xchg   %ax,%ax
80104aaa:	66 90                	xchg   %ax,%ax
80104aac:	66 90                	xchg   %ax,%ax
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104ab9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104abf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104ac2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ac9:	5d                   	pop    %ebp
80104aca:	c3                   	ret    
80104acb:	90                   	nop
80104acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ad0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ad0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ad1:	31 d2                	xor    %edx,%edx
{
80104ad3:	89 e5                	mov    %esp,%ebp
80104ad5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104ad6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ad9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104adc:	83 e8 08             	sub    $0x8,%eax
80104adf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ae0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ae6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104aec:	77 1a                	ja     80104b08 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104aee:	8b 58 04             	mov    0x4(%eax),%ebx
80104af1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104af4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104af7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104af9:	83 fa 0a             	cmp    $0xa,%edx
80104afc:	75 e2                	jne    80104ae0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104afe:	5b                   	pop    %ebx
80104aff:	5d                   	pop    %ebp
80104b00:	c3                   	ret    
80104b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b08:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b0b:	83 c1 28             	add    $0x28,%ecx
80104b0e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104b10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104b16:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104b19:	39 c1                	cmp    %eax,%ecx
80104b1b:	75 f3                	jne    80104b10 <getcallerpcs+0x40>
}
80104b1d:	5b                   	pop    %ebx
80104b1e:	5d                   	pop    %ebp
80104b1f:	c3                   	ret    

80104b20 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	53                   	push   %ebx
80104b24:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b27:	9c                   	pushf  
80104b28:	5b                   	pop    %ebx
  asm volatile("cli");
80104b29:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b2a:	e8 41 ed ff ff       	call   80103870 <mycpu>
80104b2f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b35:	85 c0                	test   %eax,%eax
80104b37:	75 11                	jne    80104b4a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104b39:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b3f:	e8 2c ed ff ff       	call   80103870 <mycpu>
80104b44:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b4a:	e8 21 ed ff ff       	call   80103870 <mycpu>
80104b4f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b56:	83 c4 04             	add    $0x4,%esp
80104b59:	5b                   	pop    %ebx
80104b5a:	5d                   	pop    %ebp
80104b5b:	c3                   	ret    
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b60 <popcli>:

void
popcli(void)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b66:	9c                   	pushf  
80104b67:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b68:	f6 c4 02             	test   $0x2,%ah
80104b6b:	75 35                	jne    80104ba2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b6d:	e8 fe ec ff ff       	call   80103870 <mycpu>
80104b72:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b79:	78 34                	js     80104baf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b7b:	e8 f0 ec ff ff       	call   80103870 <mycpu>
80104b80:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b86:	85 d2                	test   %edx,%edx
80104b88:	74 06                	je     80104b90 <popcli+0x30>
    sti();
}
80104b8a:	c9                   	leave  
80104b8b:	c3                   	ret    
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b90:	e8 db ec ff ff       	call   80103870 <mycpu>
80104b95:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b9b:	85 c0                	test   %eax,%eax
80104b9d:	74 eb                	je     80104b8a <popcli+0x2a>
  asm volatile("sti");
80104b9f:	fb                   	sti    
}
80104ba0:	c9                   	leave  
80104ba1:	c3                   	ret    
    panic("popcli - interruptible");
80104ba2:	83 ec 0c             	sub    $0xc,%esp
80104ba5:	68 fb 7f 10 80       	push   $0x80107ffb
80104baa:	e8 e1 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104baf:	83 ec 0c             	sub    $0xc,%esp
80104bb2:	68 12 80 10 80       	push   $0x80108012
80104bb7:	e8 d4 b7 ff ff       	call   80100390 <panic>
80104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bc0 <holding>:
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	8b 75 08             	mov    0x8(%ebp),%esi
80104bc8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104bca:	e8 51 ff ff ff       	call   80104b20 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104bcf:	8b 06                	mov    (%esi),%eax
80104bd1:	85 c0                	test   %eax,%eax
80104bd3:	74 10                	je     80104be5 <holding+0x25>
80104bd5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104bd8:	e8 93 ec ff ff       	call   80103870 <mycpu>
80104bdd:	39 c3                	cmp    %eax,%ebx
80104bdf:	0f 94 c3             	sete   %bl
80104be2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104be5:	e8 76 ff ff ff       	call   80104b60 <popcli>
}
80104bea:	89 d8                	mov    %ebx,%eax
80104bec:	5b                   	pop    %ebx
80104bed:	5e                   	pop    %esi
80104bee:	5d                   	pop    %ebp
80104bef:	c3                   	ret    

80104bf0 <acquire>:
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104bf5:	e8 26 ff ff ff       	call   80104b20 <pushcli>
  if(holding(lk))
80104bfa:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bfd:	83 ec 0c             	sub    $0xc,%esp
80104c00:	53                   	push   %ebx
80104c01:	e8 ba ff ff ff       	call   80104bc0 <holding>
80104c06:	83 c4 10             	add    $0x10,%esp
80104c09:	85 c0                	test   %eax,%eax
80104c0b:	0f 85 83 00 00 00    	jne    80104c94 <acquire+0xa4>
80104c11:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104c13:	ba 01 00 00 00       	mov    $0x1,%edx
80104c18:	eb 09                	jmp    80104c23 <acquire+0x33>
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c20:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c23:	89 d0                	mov    %edx,%eax
80104c25:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104c28:	85 c0                	test   %eax,%eax
80104c2a:	75 f4                	jne    80104c20 <acquire+0x30>
  __sync_synchronize();
80104c2c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c34:	e8 37 ec ff ff       	call   80103870 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104c39:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104c3c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104c3f:	89 e8                	mov    %ebp,%eax
80104c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c48:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104c4e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104c54:	77 1a                	ja     80104c70 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104c56:	8b 48 04             	mov    0x4(%eax),%ecx
80104c59:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104c5c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104c5f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c61:	83 fe 0a             	cmp    $0xa,%esi
80104c64:	75 e2                	jne    80104c48 <acquire+0x58>
}
80104c66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c69:	5b                   	pop    %ebx
80104c6a:	5e                   	pop    %esi
80104c6b:	5d                   	pop    %ebp
80104c6c:	c3                   	ret    
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi
80104c70:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104c73:	83 c2 28             	add    $0x28,%edx
80104c76:	8d 76 00             	lea    0x0(%esi),%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104c80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104c86:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104c89:	39 d0                	cmp    %edx,%eax
80104c8b:	75 f3                	jne    80104c80 <acquire+0x90>
}
80104c8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c90:	5b                   	pop    %ebx
80104c91:	5e                   	pop    %esi
80104c92:	5d                   	pop    %ebp
80104c93:	c3                   	ret    
    panic("acquire");
80104c94:	83 ec 0c             	sub    $0xc,%esp
80104c97:	68 19 80 10 80       	push   $0x80108019
80104c9c:	e8 ef b6 ff ff       	call   80100390 <panic>
80104ca1:	eb 0d                	jmp    80104cb0 <release>
80104ca3:	90                   	nop
80104ca4:	90                   	nop
80104ca5:	90                   	nop
80104ca6:	90                   	nop
80104ca7:	90                   	nop
80104ca8:	90                   	nop
80104ca9:	90                   	nop
80104caa:	90                   	nop
80104cab:	90                   	nop
80104cac:	90                   	nop
80104cad:	90                   	nop
80104cae:	90                   	nop
80104caf:	90                   	nop

80104cb0 <release>:
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	53                   	push   %ebx
80104cb4:	83 ec 10             	sub    $0x10,%esp
80104cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104cba:	53                   	push   %ebx
80104cbb:	e8 00 ff ff ff       	call   80104bc0 <holding>
80104cc0:	83 c4 10             	add    $0x10,%esp
80104cc3:	85 c0                	test   %eax,%eax
80104cc5:	74 22                	je     80104ce9 <release+0x39>
  lk->pcs[0] = 0;
80104cc7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104cce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104cd5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104cda:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ce0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ce3:	c9                   	leave  
  popcli();
80104ce4:	e9 77 fe ff ff       	jmp    80104b60 <popcli>
    panic("release");
80104ce9:	83 ec 0c             	sub    $0xc,%esp
80104cec:	68 21 80 10 80       	push   $0x80108021
80104cf1:	e8 9a b6 ff ff       	call   80100390 <panic>
80104cf6:	66 90                	xchg   %ax,%ax
80104cf8:	66 90                	xchg   %ax,%ax
80104cfa:	66 90                	xchg   %ax,%ax
80104cfc:	66 90                	xchg   %ax,%ax
80104cfe:	66 90                	xchg   %ax,%ax

80104d00 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	53                   	push   %ebx
80104d05:	8b 55 08             	mov    0x8(%ebp),%edx
80104d08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104d0b:	f6 c2 03             	test   $0x3,%dl
80104d0e:	75 05                	jne    80104d15 <memset+0x15>
80104d10:	f6 c1 03             	test   $0x3,%cl
80104d13:	74 13                	je     80104d28 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104d15:	89 d7                	mov    %edx,%edi
80104d17:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d1a:	fc                   	cld    
80104d1b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104d1d:	5b                   	pop    %ebx
80104d1e:	89 d0                	mov    %edx,%eax
80104d20:	5f                   	pop    %edi
80104d21:	5d                   	pop    %ebp
80104d22:	c3                   	ret    
80104d23:	90                   	nop
80104d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104d28:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d2c:	c1 e9 02             	shr    $0x2,%ecx
80104d2f:	89 f8                	mov    %edi,%eax
80104d31:	89 fb                	mov    %edi,%ebx
80104d33:	c1 e0 18             	shl    $0x18,%eax
80104d36:	c1 e3 10             	shl    $0x10,%ebx
80104d39:	09 d8                	or     %ebx,%eax
80104d3b:	09 f8                	or     %edi,%eax
80104d3d:	c1 e7 08             	shl    $0x8,%edi
80104d40:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d42:	89 d7                	mov    %edx,%edi
80104d44:	fc                   	cld    
80104d45:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104d47:	5b                   	pop    %ebx
80104d48:	89 d0                	mov    %edx,%eax
80104d4a:	5f                   	pop    %edi
80104d4b:	5d                   	pop    %ebp
80104d4c:	c3                   	ret    
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi

80104d50 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	57                   	push   %edi
80104d54:	56                   	push   %esi
80104d55:	53                   	push   %ebx
80104d56:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d59:	8b 75 08             	mov    0x8(%ebp),%esi
80104d5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d5f:	85 db                	test   %ebx,%ebx
80104d61:	74 29                	je     80104d8c <memcmp+0x3c>
    if(*s1 != *s2)
80104d63:	0f b6 16             	movzbl (%esi),%edx
80104d66:	0f b6 0f             	movzbl (%edi),%ecx
80104d69:	38 d1                	cmp    %dl,%cl
80104d6b:	75 2b                	jne    80104d98 <memcmp+0x48>
80104d6d:	b8 01 00 00 00       	mov    $0x1,%eax
80104d72:	eb 14                	jmp    80104d88 <memcmp+0x38>
80104d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d78:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104d7c:	83 c0 01             	add    $0x1,%eax
80104d7f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104d84:	38 ca                	cmp    %cl,%dl
80104d86:	75 10                	jne    80104d98 <memcmp+0x48>
  while(n-- > 0){
80104d88:	39 d8                	cmp    %ebx,%eax
80104d8a:	75 ec                	jne    80104d78 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104d8c:	5b                   	pop    %ebx
  return 0;
80104d8d:	31 c0                	xor    %eax,%eax
}
80104d8f:	5e                   	pop    %esi
80104d90:	5f                   	pop    %edi
80104d91:	5d                   	pop    %ebp
80104d92:	c3                   	ret    
80104d93:	90                   	nop
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104d98:	0f b6 c2             	movzbl %dl,%eax
}
80104d9b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104d9c:	29 c8                	sub    %ecx,%eax
}
80104d9e:	5e                   	pop    %esi
80104d9f:	5f                   	pop    %edi
80104da0:	5d                   	pop    %ebp
80104da1:	c3                   	ret    
80104da2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104db0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
80104db5:	8b 45 08             	mov    0x8(%ebp),%eax
80104db8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104dbb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104dbe:	39 c3                	cmp    %eax,%ebx
80104dc0:	73 26                	jae    80104de8 <memmove+0x38>
80104dc2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104dc5:	39 c8                	cmp    %ecx,%eax
80104dc7:	73 1f                	jae    80104de8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104dc9:	85 f6                	test   %esi,%esi
80104dcb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104dce:	74 0f                	je     80104ddf <memmove+0x2f>
      *--d = *--s;
80104dd0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104dd4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104dd7:	83 ea 01             	sub    $0x1,%edx
80104dda:	83 fa ff             	cmp    $0xffffffff,%edx
80104ddd:	75 f1                	jne    80104dd0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104ddf:	5b                   	pop    %ebx
80104de0:	5e                   	pop    %esi
80104de1:	5d                   	pop    %ebp
80104de2:	c3                   	ret    
80104de3:	90                   	nop
80104de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104de8:	31 d2                	xor    %edx,%edx
80104dea:	85 f6                	test   %esi,%esi
80104dec:	74 f1                	je     80104ddf <memmove+0x2f>
80104dee:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104df0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104df4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104df7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104dfa:	39 d6                	cmp    %edx,%esi
80104dfc:	75 f2                	jne    80104df0 <memmove+0x40>
}
80104dfe:	5b                   	pop    %ebx
80104dff:	5e                   	pop    %esi
80104e00:	5d                   	pop    %ebp
80104e01:	c3                   	ret    
80104e02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104e13:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104e14:	eb 9a                	jmp    80104db0 <memmove>
80104e16:	8d 76 00             	lea    0x0(%esi),%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
80104e25:	8b 7d 10             	mov    0x10(%ebp),%edi
80104e28:	53                   	push   %ebx
80104e29:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104e2f:	85 ff                	test   %edi,%edi
80104e31:	74 2f                	je     80104e62 <strncmp+0x42>
80104e33:	0f b6 01             	movzbl (%ecx),%eax
80104e36:	0f b6 1e             	movzbl (%esi),%ebx
80104e39:	84 c0                	test   %al,%al
80104e3b:	74 37                	je     80104e74 <strncmp+0x54>
80104e3d:	38 c3                	cmp    %al,%bl
80104e3f:	75 33                	jne    80104e74 <strncmp+0x54>
80104e41:	01 f7                	add    %esi,%edi
80104e43:	eb 13                	jmp    80104e58 <strncmp+0x38>
80104e45:	8d 76 00             	lea    0x0(%esi),%esi
80104e48:	0f b6 01             	movzbl (%ecx),%eax
80104e4b:	84 c0                	test   %al,%al
80104e4d:	74 21                	je     80104e70 <strncmp+0x50>
80104e4f:	0f b6 1a             	movzbl (%edx),%ebx
80104e52:	89 d6                	mov    %edx,%esi
80104e54:	38 d8                	cmp    %bl,%al
80104e56:	75 1c                	jne    80104e74 <strncmp+0x54>
    n--, p++, q++;
80104e58:	8d 56 01             	lea    0x1(%esi),%edx
80104e5b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e5e:	39 fa                	cmp    %edi,%edx
80104e60:	75 e6                	jne    80104e48 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e62:	5b                   	pop    %ebx
    return 0;
80104e63:	31 c0                	xor    %eax,%eax
}
80104e65:	5e                   	pop    %esi
80104e66:	5f                   	pop    %edi
80104e67:	5d                   	pop    %ebp
80104e68:	c3                   	ret    
80104e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e70:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104e74:	29 d8                	sub    %ebx,%eax
}
80104e76:	5b                   	pop    %ebx
80104e77:	5e                   	pop    %esi
80104e78:	5f                   	pop    %edi
80104e79:	5d                   	pop    %ebp
80104e7a:	c3                   	ret    
80104e7b:	90                   	nop
80104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e80 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
80104e85:	8b 45 08             	mov    0x8(%ebp),%eax
80104e88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e8e:	89 c2                	mov    %eax,%edx
80104e90:	eb 19                	jmp    80104eab <strncpy+0x2b>
80104e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e98:	83 c3 01             	add    $0x1,%ebx
80104e9b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104e9f:	83 c2 01             	add    $0x1,%edx
80104ea2:	84 c9                	test   %cl,%cl
80104ea4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ea7:	74 09                	je     80104eb2 <strncpy+0x32>
80104ea9:	89 f1                	mov    %esi,%ecx
80104eab:	85 c9                	test   %ecx,%ecx
80104ead:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104eb0:	7f e6                	jg     80104e98 <strncpy+0x18>
    ;
  while(n-- > 0)
80104eb2:	31 c9                	xor    %ecx,%ecx
80104eb4:	85 f6                	test   %esi,%esi
80104eb6:	7e 17                	jle    80104ecf <strncpy+0x4f>
80104eb8:	90                   	nop
80104eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ec0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ec4:	89 f3                	mov    %esi,%ebx
80104ec6:	83 c1 01             	add    $0x1,%ecx
80104ec9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104ecb:	85 db                	test   %ebx,%ebx
80104ecd:	7f f1                	jg     80104ec0 <strncpy+0x40>
  return os;
}
80104ecf:	5b                   	pop    %ebx
80104ed0:	5e                   	pop    %esi
80104ed1:	5d                   	pop    %ebp
80104ed2:	c3                   	ret    
80104ed3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
80104ee5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80104eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104eee:	85 c9                	test   %ecx,%ecx
80104ef0:	7e 26                	jle    80104f18 <safestrcpy+0x38>
80104ef2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ef6:	89 c1                	mov    %eax,%ecx
80104ef8:	eb 17                	jmp    80104f11 <safestrcpy+0x31>
80104efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f00:	83 c2 01             	add    $0x1,%edx
80104f03:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104f07:	83 c1 01             	add    $0x1,%ecx
80104f0a:	84 db                	test   %bl,%bl
80104f0c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104f0f:	74 04                	je     80104f15 <safestrcpy+0x35>
80104f11:	39 f2                	cmp    %esi,%edx
80104f13:	75 eb                	jne    80104f00 <safestrcpy+0x20>
    ;
  *s = 0;
80104f15:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104f18:	5b                   	pop    %ebx
80104f19:	5e                   	pop    %esi
80104f1a:	5d                   	pop    %ebp
80104f1b:	c3                   	ret    
80104f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f20 <strlen>:

int
strlen(const char *s)
{
80104f20:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f21:	31 c0                	xor    %eax,%eax
{
80104f23:	89 e5                	mov    %esp,%ebp
80104f25:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104f28:	80 3a 00             	cmpb   $0x0,(%edx)
80104f2b:	74 0c                	je     80104f39 <strlen+0x19>
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
80104f30:	83 c0 01             	add    $0x1,%eax
80104f33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f37:	75 f7                	jne    80104f30 <strlen+0x10>
    ;
  return n;
}
80104f39:	5d                   	pop    %ebp
80104f3a:	c3                   	ret    

80104f3b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f3b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f3f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f43:	55                   	push   %ebp
  pushl %ebx
80104f44:	53                   	push   %ebx
  pushl %esi
80104f45:	56                   	push   %esi
  pushl %edi
80104f46:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f47:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f49:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f4b:	5f                   	pop    %edi
  popl %esi
80104f4c:	5e                   	pop    %esi
  popl %ebx
80104f4d:	5b                   	pop    %ebx
  popl %ebp
80104f4e:	5d                   	pop    %ebp
  ret
80104f4f:	c3                   	ret    

80104f50 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	53                   	push   %ebx
80104f54:	83 ec 04             	sub    $0x4,%esp
80104f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f5a:	e8 b1 e9 ff ff       	call   80103910 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f5f:	8b 00                	mov    (%eax),%eax
80104f61:	39 d8                	cmp    %ebx,%eax
80104f63:	76 1b                	jbe    80104f80 <fetchint+0x30>
80104f65:	8d 53 04             	lea    0x4(%ebx),%edx
80104f68:	39 d0                	cmp    %edx,%eax
80104f6a:	72 14                	jb     80104f80 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f6f:	8b 13                	mov    (%ebx),%edx
80104f71:	89 10                	mov    %edx,(%eax)
  return 0;
80104f73:	31 c0                	xor    %eax,%eax
}
80104f75:	83 c4 04             	add    $0x4,%esp
80104f78:	5b                   	pop    %ebx
80104f79:	5d                   	pop    %ebp
80104f7a:	c3                   	ret    
80104f7b:	90                   	nop
80104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f85:	eb ee                	jmp    80104f75 <fetchint+0x25>
80104f87:	89 f6                	mov    %esi,%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f90 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	53                   	push   %ebx
80104f94:	83 ec 04             	sub    $0x4,%esp
80104f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f9a:	e8 71 e9 ff ff       	call   80103910 <myproc>

  if(addr >= curproc->sz)
80104f9f:	39 18                	cmp    %ebx,(%eax)
80104fa1:	76 29                	jbe    80104fcc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104fa3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104fa6:	89 da                	mov    %ebx,%edx
80104fa8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104faa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104fac:	39 c3                	cmp    %eax,%ebx
80104fae:	73 1c                	jae    80104fcc <fetchstr+0x3c>
    if(*s == 0)
80104fb0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104fb3:	75 10                	jne    80104fc5 <fetchstr+0x35>
80104fb5:	eb 39                	jmp    80104ff0 <fetchstr+0x60>
80104fb7:	89 f6                	mov    %esi,%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fc0:	80 3a 00             	cmpb   $0x0,(%edx)
80104fc3:	74 1b                	je     80104fe0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104fc5:	83 c2 01             	add    $0x1,%edx
80104fc8:	39 d0                	cmp    %edx,%eax
80104fca:	77 f4                	ja     80104fc0 <fetchstr+0x30>
    return -1;
80104fcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104fd1:	83 c4 04             	add    $0x4,%esp
80104fd4:	5b                   	pop    %ebx
80104fd5:	5d                   	pop    %ebp
80104fd6:	c3                   	ret    
80104fd7:	89 f6                	mov    %esi,%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fe0:	83 c4 04             	add    $0x4,%esp
80104fe3:	89 d0                	mov    %edx,%eax
80104fe5:	29 d8                	sub    %ebx,%eax
80104fe7:	5b                   	pop    %ebx
80104fe8:	5d                   	pop    %ebp
80104fe9:	c3                   	ret    
80104fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104ff0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104ff2:	eb dd                	jmp    80104fd1 <fetchstr+0x41>
80104ff4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ffa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105000 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105005:	e8 06 e9 ff ff       	call   80103910 <myproc>
8010500a:	8b 40 18             	mov    0x18(%eax),%eax
8010500d:	8b 55 08             	mov    0x8(%ebp),%edx
80105010:	8b 40 44             	mov    0x44(%eax),%eax
80105013:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105016:	e8 f5 e8 ff ff       	call   80103910 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010501b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010501d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105020:	39 c6                	cmp    %eax,%esi
80105022:	73 1c                	jae    80105040 <argint+0x40>
80105024:	8d 53 08             	lea    0x8(%ebx),%edx
80105027:	39 d0                	cmp    %edx,%eax
80105029:	72 15                	jb     80105040 <argint+0x40>
  *ip = *(int*)(addr);
8010502b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010502e:	8b 53 04             	mov    0x4(%ebx),%edx
80105031:	89 10                	mov    %edx,(%eax)
  return 0;
80105033:	31 c0                	xor    %eax,%eax
}
80105035:	5b                   	pop    %ebx
80105036:	5e                   	pop    %esi
80105037:	5d                   	pop    %ebp
80105038:	c3                   	ret    
80105039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105045:	eb ee                	jmp    80105035 <argint+0x35>
80105047:	89 f6                	mov    %esi,%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	56                   	push   %esi
80105054:	53                   	push   %ebx
80105055:	83 ec 10             	sub    $0x10,%esp
80105058:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010505b:	e8 b0 e8 ff ff       	call   80103910 <myproc>
80105060:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105062:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105065:	83 ec 08             	sub    $0x8,%esp
80105068:	50                   	push   %eax
80105069:	ff 75 08             	pushl  0x8(%ebp)
8010506c:	e8 8f ff ff ff       	call   80105000 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105071:	83 c4 10             	add    $0x10,%esp
80105074:	85 c0                	test   %eax,%eax
80105076:	78 28                	js     801050a0 <argptr+0x50>
80105078:	85 db                	test   %ebx,%ebx
8010507a:	78 24                	js     801050a0 <argptr+0x50>
8010507c:	8b 16                	mov    (%esi),%edx
8010507e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105081:	39 c2                	cmp    %eax,%edx
80105083:	76 1b                	jbe    801050a0 <argptr+0x50>
80105085:	01 c3                	add    %eax,%ebx
80105087:	39 da                	cmp    %ebx,%edx
80105089:	72 15                	jb     801050a0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010508b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010508e:	89 02                	mov    %eax,(%edx)
  return 0;
80105090:	31 c0                	xor    %eax,%eax
}
80105092:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105095:	5b                   	pop    %ebx
80105096:	5e                   	pop    %esi
80105097:	5d                   	pop    %ebp
80105098:	c3                   	ret    
80105099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a5:	eb eb                	jmp    80105092 <argptr+0x42>
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801050b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050b9:	50                   	push   %eax
801050ba:	ff 75 08             	pushl  0x8(%ebp)
801050bd:	e8 3e ff ff ff       	call   80105000 <argint>
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	85 c0                	test   %eax,%eax
801050c7:	78 17                	js     801050e0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801050c9:	83 ec 08             	sub    $0x8,%esp
801050cc:	ff 75 0c             	pushl  0xc(%ebp)
801050cf:	ff 75 f4             	pushl  -0xc(%ebp)
801050d2:	e8 b9 fe ff ff       	call   80104f90 <fetchstr>
801050d7:	83 c4 10             	add    $0x10,%esp
}
801050da:	c9                   	leave  
801050db:	c3                   	ret    
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801050e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050e5:	c9                   	leave  
801050e6:	c3                   	ret    
801050e7:	89 f6                	mov    %esi,%esi
801050e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050f0 <syscall>:
[SYS_ps]      sys_ps,
};

void
syscall(void)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	53                   	push   %ebx
801050f4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801050f7:	e8 14 e8 ff ff       	call   80103910 <myproc>
801050fc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801050fe:	8b 40 18             	mov    0x18(%eax),%eax
80105101:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105104:	8d 50 ff             	lea    -0x1(%eax),%edx
80105107:	83 fa 18             	cmp    $0x18,%edx
8010510a:	77 1c                	ja     80105128 <syscall+0x38>
8010510c:	8b 14 85 60 80 10 80 	mov    -0x7fef7fa0(,%eax,4),%edx
80105113:	85 d2                	test   %edx,%edx
80105115:	74 11                	je     80105128 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105117:	ff d2                	call   *%edx
80105119:	8b 53 18             	mov    0x18(%ebx),%edx
8010511c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010511f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105122:	c9                   	leave  
80105123:	c3                   	ret    
80105124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105128:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105129:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010512c:	50                   	push   %eax
8010512d:	ff 73 10             	pushl  0x10(%ebx)
80105130:	68 29 80 10 80       	push   $0x80108029
80105135:	e8 26 b5 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010513a:	8b 43 18             	mov    0x18(%ebx),%eax
8010513d:	83 c4 10             	add    $0x10,%esp
80105140:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105147:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010514a:	c9                   	leave  
8010514b:	c3                   	ret    
8010514c:	66 90                	xchg   %ax,%ax
8010514e:	66 90                	xchg   %ax,%ax

80105150 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	57                   	push   %edi
80105154:	56                   	push   %esi
80105155:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105156:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105159:	83 ec 34             	sub    $0x34,%esp
8010515c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010515f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105162:	56                   	push   %esi
80105163:	50                   	push   %eax
{
80105164:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105167:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010516a:	e8 91 cd ff ff       	call   80101f00 <nameiparent>
8010516f:	83 c4 10             	add    $0x10,%esp
80105172:	85 c0                	test   %eax,%eax
80105174:	0f 84 46 01 00 00    	je     801052c0 <create+0x170>
    return 0;
  ilock(dp);
8010517a:	83 ec 0c             	sub    $0xc,%esp
8010517d:	89 c3                	mov    %eax,%ebx
8010517f:	50                   	push   %eax
80105180:	e8 fb c4 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105185:	83 c4 0c             	add    $0xc,%esp
80105188:	6a 00                	push   $0x0
8010518a:	56                   	push   %esi
8010518b:	53                   	push   %ebx
8010518c:	e8 1f ca ff ff       	call   80101bb0 <dirlookup>
80105191:	83 c4 10             	add    $0x10,%esp
80105194:	85 c0                	test   %eax,%eax
80105196:	89 c7                	mov    %eax,%edi
80105198:	74 36                	je     801051d0 <create+0x80>
    iunlockput(dp);
8010519a:	83 ec 0c             	sub    $0xc,%esp
8010519d:	53                   	push   %ebx
8010519e:	e8 6d c7 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
801051a3:	89 3c 24             	mov    %edi,(%esp)
801051a6:	e8 d5 c4 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801051ab:	83 c4 10             	add    $0x10,%esp
801051ae:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801051b3:	0f 85 97 00 00 00    	jne    80105250 <create+0x100>
801051b9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801051be:	0f 85 8c 00 00 00    	jne    80105250 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801051c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051c7:	89 f8                	mov    %edi,%eax
801051c9:	5b                   	pop    %ebx
801051ca:	5e                   	pop    %esi
801051cb:	5f                   	pop    %edi
801051cc:	5d                   	pop    %ebp
801051cd:	c3                   	ret    
801051ce:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
801051d0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801051d4:	83 ec 08             	sub    $0x8,%esp
801051d7:	50                   	push   %eax
801051d8:	ff 33                	pushl  (%ebx)
801051da:	e8 31 c3 ff ff       	call   80101510 <ialloc>
801051df:	83 c4 10             	add    $0x10,%esp
801051e2:	85 c0                	test   %eax,%eax
801051e4:	89 c7                	mov    %eax,%edi
801051e6:	0f 84 e8 00 00 00    	je     801052d4 <create+0x184>
  ilock(ip);
801051ec:	83 ec 0c             	sub    $0xc,%esp
801051ef:	50                   	push   %eax
801051f0:	e8 8b c4 ff ff       	call   80101680 <ilock>
  ip->major = major;
801051f5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801051f9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801051fd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105201:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105205:	b8 01 00 00 00       	mov    $0x1,%eax
8010520a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010520e:	89 3c 24             	mov    %edi,(%esp)
80105211:	e8 ba c3 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105216:	83 c4 10             	add    $0x10,%esp
80105219:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010521e:	74 50                	je     80105270 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105220:	83 ec 04             	sub    $0x4,%esp
80105223:	ff 77 04             	pushl  0x4(%edi)
80105226:	56                   	push   %esi
80105227:	53                   	push   %ebx
80105228:	e8 f3 cb ff ff       	call   80101e20 <dirlink>
8010522d:	83 c4 10             	add    $0x10,%esp
80105230:	85 c0                	test   %eax,%eax
80105232:	0f 88 8f 00 00 00    	js     801052c7 <create+0x177>
  iunlockput(dp);
80105238:	83 ec 0c             	sub    $0xc,%esp
8010523b:	53                   	push   %ebx
8010523c:	e8 cf c6 ff ff       	call   80101910 <iunlockput>
  return ip;
80105241:	83 c4 10             	add    $0x10,%esp
}
80105244:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105247:	89 f8                	mov    %edi,%eax
80105249:	5b                   	pop    %ebx
8010524a:	5e                   	pop    %esi
8010524b:	5f                   	pop    %edi
8010524c:	5d                   	pop    %ebp
8010524d:	c3                   	ret    
8010524e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105250:	83 ec 0c             	sub    $0xc,%esp
80105253:	57                   	push   %edi
    return 0;
80105254:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105256:	e8 b5 c6 ff ff       	call   80101910 <iunlockput>
    return 0;
8010525b:	83 c4 10             	add    $0x10,%esp
}
8010525e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105261:	89 f8                	mov    %edi,%eax
80105263:	5b                   	pop    %ebx
80105264:	5e                   	pop    %esi
80105265:	5f                   	pop    %edi
80105266:	5d                   	pop    %ebp
80105267:	c3                   	ret    
80105268:	90                   	nop
80105269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105270:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105275:	83 ec 0c             	sub    $0xc,%esp
80105278:	53                   	push   %ebx
80105279:	e8 52 c3 ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010527e:	83 c4 0c             	add    $0xc,%esp
80105281:	ff 77 04             	pushl  0x4(%edi)
80105284:	68 e4 80 10 80       	push   $0x801080e4
80105289:	57                   	push   %edi
8010528a:	e8 91 cb ff ff       	call   80101e20 <dirlink>
8010528f:	83 c4 10             	add    $0x10,%esp
80105292:	85 c0                	test   %eax,%eax
80105294:	78 1c                	js     801052b2 <create+0x162>
80105296:	83 ec 04             	sub    $0x4,%esp
80105299:	ff 73 04             	pushl  0x4(%ebx)
8010529c:	68 e3 80 10 80       	push   $0x801080e3
801052a1:	57                   	push   %edi
801052a2:	e8 79 cb ff ff       	call   80101e20 <dirlink>
801052a7:	83 c4 10             	add    $0x10,%esp
801052aa:	85 c0                	test   %eax,%eax
801052ac:	0f 89 6e ff ff ff    	jns    80105220 <create+0xd0>
      panic("create dots");
801052b2:	83 ec 0c             	sub    $0xc,%esp
801052b5:	68 d7 80 10 80       	push   $0x801080d7
801052ba:	e8 d1 b0 ff ff       	call   80100390 <panic>
801052bf:	90                   	nop
    return 0;
801052c0:	31 ff                	xor    %edi,%edi
801052c2:	e9 fd fe ff ff       	jmp    801051c4 <create+0x74>
    panic("create: dirlink");
801052c7:	83 ec 0c             	sub    $0xc,%esp
801052ca:	68 e6 80 10 80       	push   $0x801080e6
801052cf:	e8 bc b0 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	68 c8 80 10 80       	push   $0x801080c8
801052dc:	e8 af b0 ff ff       	call   80100390 <panic>
801052e1:	eb 0d                	jmp    801052f0 <argfd.constprop.0>
801052e3:	90                   	nop
801052e4:	90                   	nop
801052e5:	90                   	nop
801052e6:	90                   	nop
801052e7:	90                   	nop
801052e8:	90                   	nop
801052e9:	90                   	nop
801052ea:	90                   	nop
801052eb:	90                   	nop
801052ec:	90                   	nop
801052ed:	90                   	nop
801052ee:	90                   	nop
801052ef:	90                   	nop

801052f0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	56                   	push   %esi
801052f4:	53                   	push   %ebx
801052f5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801052f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801052fa:	89 d6                	mov    %edx,%esi
801052fc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052ff:	50                   	push   %eax
80105300:	6a 00                	push   $0x0
80105302:	e8 f9 fc ff ff       	call   80105000 <argint>
80105307:	83 c4 10             	add    $0x10,%esp
8010530a:	85 c0                	test   %eax,%eax
8010530c:	78 2a                	js     80105338 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010530e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105312:	77 24                	ja     80105338 <argfd.constprop.0+0x48>
80105314:	e8 f7 e5 ff ff       	call   80103910 <myproc>
80105319:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010531c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105320:	85 c0                	test   %eax,%eax
80105322:	74 14                	je     80105338 <argfd.constprop.0+0x48>
  if(pfd)
80105324:	85 db                	test   %ebx,%ebx
80105326:	74 02                	je     8010532a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105328:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010532a:	89 06                	mov    %eax,(%esi)
  return 0;
8010532c:	31 c0                	xor    %eax,%eax
}
8010532e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105331:	5b                   	pop    %ebx
80105332:	5e                   	pop    %esi
80105333:	5d                   	pop    %ebp
80105334:	c3                   	ret    
80105335:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533d:	eb ef                	jmp    8010532e <argfd.constprop.0+0x3e>
8010533f:	90                   	nop

80105340 <sys_dup>:
{
80105340:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105341:	31 c0                	xor    %eax,%eax
{
80105343:	89 e5                	mov    %esp,%ebp
80105345:	56                   	push   %esi
80105346:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105347:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010534a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010534d:	e8 9e ff ff ff       	call   801052f0 <argfd.constprop.0>
80105352:	85 c0                	test   %eax,%eax
80105354:	78 42                	js     80105398 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105356:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105359:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010535b:	e8 b0 e5 ff ff       	call   80103910 <myproc>
80105360:	eb 0e                	jmp    80105370 <sys_dup+0x30>
80105362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105368:	83 c3 01             	add    $0x1,%ebx
8010536b:	83 fb 10             	cmp    $0x10,%ebx
8010536e:	74 28                	je     80105398 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105370:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105374:	85 d2                	test   %edx,%edx
80105376:	75 f0                	jne    80105368 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105378:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010537c:	83 ec 0c             	sub    $0xc,%esp
8010537f:	ff 75 f4             	pushl  -0xc(%ebp)
80105382:	e8 69 ba ff ff       	call   80100df0 <filedup>
  return fd;
80105387:	83 c4 10             	add    $0x10,%esp
}
8010538a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010538d:	89 d8                	mov    %ebx,%eax
8010538f:	5b                   	pop    %ebx
80105390:	5e                   	pop    %esi
80105391:	5d                   	pop    %ebp
80105392:	c3                   	ret    
80105393:	90                   	nop
80105394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105398:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010539b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801053a0:	89 d8                	mov    %ebx,%eax
801053a2:	5b                   	pop    %ebx
801053a3:	5e                   	pop    %esi
801053a4:	5d                   	pop    %ebp
801053a5:	c3                   	ret    
801053a6:	8d 76 00             	lea    0x0(%esi),%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053b0 <sys_read>:
{
801053b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053b1:	31 c0                	xor    %eax,%eax
{
801053b3:	89 e5                	mov    %esp,%ebp
801053b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053bb:	e8 30 ff ff ff       	call   801052f0 <argfd.constprop.0>
801053c0:	85 c0                	test   %eax,%eax
801053c2:	78 4c                	js     80105410 <sys_read+0x60>
801053c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053c7:	83 ec 08             	sub    $0x8,%esp
801053ca:	50                   	push   %eax
801053cb:	6a 02                	push   $0x2
801053cd:	e8 2e fc ff ff       	call   80105000 <argint>
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	85 c0                	test   %eax,%eax
801053d7:	78 37                	js     80105410 <sys_read+0x60>
801053d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053dc:	83 ec 04             	sub    $0x4,%esp
801053df:	ff 75 f0             	pushl  -0x10(%ebp)
801053e2:	50                   	push   %eax
801053e3:	6a 01                	push   $0x1
801053e5:	e8 66 fc ff ff       	call   80105050 <argptr>
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	85 c0                	test   %eax,%eax
801053ef:	78 1f                	js     80105410 <sys_read+0x60>
  return fileread(f, p, n);
801053f1:	83 ec 04             	sub    $0x4,%esp
801053f4:	ff 75 f0             	pushl  -0x10(%ebp)
801053f7:	ff 75 f4             	pushl  -0xc(%ebp)
801053fa:	ff 75 ec             	pushl  -0x14(%ebp)
801053fd:	e8 5e bb ff ff       	call   80100f60 <fileread>
80105402:	83 c4 10             	add    $0x10,%esp
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

80105420 <sys_write>:
{
80105420:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105421:	31 c0                	xor    %eax,%eax
{
80105423:	89 e5                	mov    %esp,%ebp
80105425:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105428:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010542b:	e8 c0 fe ff ff       	call   801052f0 <argfd.constprop.0>
80105430:	85 c0                	test   %eax,%eax
80105432:	78 4c                	js     80105480 <sys_write+0x60>
80105434:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105437:	83 ec 08             	sub    $0x8,%esp
8010543a:	50                   	push   %eax
8010543b:	6a 02                	push   $0x2
8010543d:	e8 be fb ff ff       	call   80105000 <argint>
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	85 c0                	test   %eax,%eax
80105447:	78 37                	js     80105480 <sys_write+0x60>
80105449:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544c:	83 ec 04             	sub    $0x4,%esp
8010544f:	ff 75 f0             	pushl  -0x10(%ebp)
80105452:	50                   	push   %eax
80105453:	6a 01                	push   $0x1
80105455:	e8 f6 fb ff ff       	call   80105050 <argptr>
8010545a:	83 c4 10             	add    $0x10,%esp
8010545d:	85 c0                	test   %eax,%eax
8010545f:	78 1f                	js     80105480 <sys_write+0x60>
  return filewrite(f, p, n);
80105461:	83 ec 04             	sub    $0x4,%esp
80105464:	ff 75 f0             	pushl  -0x10(%ebp)
80105467:	ff 75 f4             	pushl  -0xc(%ebp)
8010546a:	ff 75 ec             	pushl  -0x14(%ebp)
8010546d:	e8 7e bb ff ff       	call   80100ff0 <filewrite>
80105472:	83 c4 10             	add    $0x10,%esp
}
80105475:	c9                   	leave  
80105476:	c3                   	ret    
80105477:	89 f6                	mov    %esi,%esi
80105479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105485:	c9                   	leave  
80105486:	c3                   	ret    
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105490 <sys_close>:
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105496:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105499:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010549c:	e8 4f fe ff ff       	call   801052f0 <argfd.constprop.0>
801054a1:	85 c0                	test   %eax,%eax
801054a3:	78 2b                	js     801054d0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801054a5:	e8 66 e4 ff ff       	call   80103910 <myproc>
801054aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801054ad:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801054b0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801054b7:	00 
  fileclose(f);
801054b8:	ff 75 f4             	pushl  -0xc(%ebp)
801054bb:	e8 80 b9 ff ff       	call   80100e40 <fileclose>
  return 0;
801054c0:	83 c4 10             	add    $0x10,%esp
801054c3:	31 c0                	xor    %eax,%eax
}
801054c5:	c9                   	leave  
801054c6:	c3                   	ret    
801054c7:	89 f6                	mov    %esi,%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801054d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054d5:	c9                   	leave  
801054d6:	c3                   	ret    
801054d7:	89 f6                	mov    %esi,%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054e0 <sys_fstat>:
{
801054e0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054e1:	31 c0                	xor    %eax,%eax
{
801054e3:	89 e5                	mov    %esp,%ebp
801054e5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054e8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801054eb:	e8 00 fe ff ff       	call   801052f0 <argfd.constprop.0>
801054f0:	85 c0                	test   %eax,%eax
801054f2:	78 2c                	js     80105520 <sys_fstat+0x40>
801054f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f7:	83 ec 04             	sub    $0x4,%esp
801054fa:	6a 14                	push   $0x14
801054fc:	50                   	push   %eax
801054fd:	6a 01                	push   $0x1
801054ff:	e8 4c fb ff ff       	call   80105050 <argptr>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	78 15                	js     80105520 <sys_fstat+0x40>
  return filestat(f, st);
8010550b:	83 ec 08             	sub    $0x8,%esp
8010550e:	ff 75 f4             	pushl  -0xc(%ebp)
80105511:	ff 75 f0             	pushl  -0x10(%ebp)
80105514:	e8 f7 b9 ff ff       	call   80100f10 <filestat>
80105519:	83 c4 10             	add    $0x10,%esp
}
8010551c:	c9                   	leave  
8010551d:	c3                   	ret    
8010551e:	66 90                	xchg   %ax,%ax
    return -1;
80105520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105525:	c9                   	leave  
80105526:	c3                   	ret    
80105527:	89 f6                	mov    %esi,%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <sys_link>:
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
80105535:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105536:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105539:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010553c:	50                   	push   %eax
8010553d:	6a 00                	push   $0x0
8010553f:	e8 6c fb ff ff       	call   801050b0 <argstr>
80105544:	83 c4 10             	add    $0x10,%esp
80105547:	85 c0                	test   %eax,%eax
80105549:	0f 88 fb 00 00 00    	js     8010564a <sys_link+0x11a>
8010554f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105552:	83 ec 08             	sub    $0x8,%esp
80105555:	50                   	push   %eax
80105556:	6a 01                	push   $0x1
80105558:	e8 53 fb ff ff       	call   801050b0 <argstr>
8010555d:	83 c4 10             	add    $0x10,%esp
80105560:	85 c0                	test   %eax,%eax
80105562:	0f 88 e2 00 00 00    	js     8010564a <sys_link+0x11a>
  begin_op();
80105568:	e8 33 d6 ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
8010556d:	83 ec 0c             	sub    $0xc,%esp
80105570:	ff 75 d4             	pushl  -0x2c(%ebp)
80105573:	e8 68 c9 ff ff       	call   80101ee0 <namei>
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	85 c0                	test   %eax,%eax
8010557d:	89 c3                	mov    %eax,%ebx
8010557f:	0f 84 ea 00 00 00    	je     8010566f <sys_link+0x13f>
  ilock(ip);
80105585:	83 ec 0c             	sub    $0xc,%esp
80105588:	50                   	push   %eax
80105589:	e8 f2 c0 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105596:	0f 84 bb 00 00 00    	je     80105657 <sys_link+0x127>
  ip->nlink++;
8010559c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801055a1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801055a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801055a7:	53                   	push   %ebx
801055a8:	e8 23 c0 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
801055ad:	89 1c 24             	mov    %ebx,(%esp)
801055b0:	e8 ab c1 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801055b5:	58                   	pop    %eax
801055b6:	5a                   	pop    %edx
801055b7:	57                   	push   %edi
801055b8:	ff 75 d0             	pushl  -0x30(%ebp)
801055bb:	e8 40 c9 ff ff       	call   80101f00 <nameiparent>
801055c0:	83 c4 10             	add    $0x10,%esp
801055c3:	85 c0                	test   %eax,%eax
801055c5:	89 c6                	mov    %eax,%esi
801055c7:	74 5b                	je     80105624 <sys_link+0xf4>
  ilock(dp);
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	50                   	push   %eax
801055cd:	e8 ae c0 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	8b 03                	mov    (%ebx),%eax
801055d7:	39 06                	cmp    %eax,(%esi)
801055d9:	75 3d                	jne    80105618 <sys_link+0xe8>
801055db:	83 ec 04             	sub    $0x4,%esp
801055de:	ff 73 04             	pushl  0x4(%ebx)
801055e1:	57                   	push   %edi
801055e2:	56                   	push   %esi
801055e3:	e8 38 c8 ff ff       	call   80101e20 <dirlink>
801055e8:	83 c4 10             	add    $0x10,%esp
801055eb:	85 c0                	test   %eax,%eax
801055ed:	78 29                	js     80105618 <sys_link+0xe8>
  iunlockput(dp);
801055ef:	83 ec 0c             	sub    $0xc,%esp
801055f2:	56                   	push   %esi
801055f3:	e8 18 c3 ff ff       	call   80101910 <iunlockput>
  iput(ip);
801055f8:	89 1c 24             	mov    %ebx,(%esp)
801055fb:	e8 b0 c1 ff ff       	call   801017b0 <iput>
  end_op();
80105600:	e8 0b d6 ff ff       	call   80102c10 <end_op>
  return 0;
80105605:	83 c4 10             	add    $0x10,%esp
80105608:	31 c0                	xor    %eax,%eax
}
8010560a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010560d:	5b                   	pop    %ebx
8010560e:	5e                   	pop    %esi
8010560f:	5f                   	pop    %edi
80105610:	5d                   	pop    %ebp
80105611:	c3                   	ret    
80105612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105618:	83 ec 0c             	sub    $0xc,%esp
8010561b:	56                   	push   %esi
8010561c:	e8 ef c2 ff ff       	call   80101910 <iunlockput>
    goto bad;
80105621:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105624:	83 ec 0c             	sub    $0xc,%esp
80105627:	53                   	push   %ebx
80105628:	e8 53 c0 ff ff       	call   80101680 <ilock>
  ip->nlink--;
8010562d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105632:	89 1c 24             	mov    %ebx,(%esp)
80105635:	e8 96 bf ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
8010563a:	89 1c 24             	mov    %ebx,(%esp)
8010563d:	e8 ce c2 ff ff       	call   80101910 <iunlockput>
  end_op();
80105642:	e8 c9 d5 ff ff       	call   80102c10 <end_op>
  return -1;
80105647:	83 c4 10             	add    $0x10,%esp
}
8010564a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010564d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105652:	5b                   	pop    %ebx
80105653:	5e                   	pop    %esi
80105654:	5f                   	pop    %edi
80105655:	5d                   	pop    %ebp
80105656:	c3                   	ret    
    iunlockput(ip);
80105657:	83 ec 0c             	sub    $0xc,%esp
8010565a:	53                   	push   %ebx
8010565b:	e8 b0 c2 ff ff       	call   80101910 <iunlockput>
    end_op();
80105660:	e8 ab d5 ff ff       	call   80102c10 <end_op>
    return -1;
80105665:	83 c4 10             	add    $0x10,%esp
80105668:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566d:	eb 9b                	jmp    8010560a <sys_link+0xda>
    end_op();
8010566f:	e8 9c d5 ff ff       	call   80102c10 <end_op>
    return -1;
80105674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105679:	eb 8f                	jmp    8010560a <sys_link+0xda>
8010567b:	90                   	nop
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105680 <sys_unlink>:
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	57                   	push   %edi
80105684:	56                   	push   %esi
80105685:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105686:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105689:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010568c:	50                   	push   %eax
8010568d:	6a 00                	push   $0x0
8010568f:	e8 1c fa ff ff       	call   801050b0 <argstr>
80105694:	83 c4 10             	add    $0x10,%esp
80105697:	85 c0                	test   %eax,%eax
80105699:	0f 88 77 01 00 00    	js     80105816 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010569f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801056a2:	e8 f9 d4 ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801056a7:	83 ec 08             	sub    $0x8,%esp
801056aa:	53                   	push   %ebx
801056ab:	ff 75 c0             	pushl  -0x40(%ebp)
801056ae:	e8 4d c8 ff ff       	call   80101f00 <nameiparent>
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	85 c0                	test   %eax,%eax
801056b8:	89 c6                	mov    %eax,%esi
801056ba:	0f 84 60 01 00 00    	je     80105820 <sys_unlink+0x1a0>
  ilock(dp);
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	50                   	push   %eax
801056c4:	e8 b7 bf ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801056c9:	58                   	pop    %eax
801056ca:	5a                   	pop    %edx
801056cb:	68 e4 80 10 80       	push   $0x801080e4
801056d0:	53                   	push   %ebx
801056d1:	e8 ba c4 ff ff       	call   80101b90 <namecmp>
801056d6:	83 c4 10             	add    $0x10,%esp
801056d9:	85 c0                	test   %eax,%eax
801056db:	0f 84 03 01 00 00    	je     801057e4 <sys_unlink+0x164>
801056e1:	83 ec 08             	sub    $0x8,%esp
801056e4:	68 e3 80 10 80       	push   $0x801080e3
801056e9:	53                   	push   %ebx
801056ea:	e8 a1 c4 ff ff       	call   80101b90 <namecmp>
801056ef:	83 c4 10             	add    $0x10,%esp
801056f2:	85 c0                	test   %eax,%eax
801056f4:	0f 84 ea 00 00 00    	je     801057e4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801056fa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801056fd:	83 ec 04             	sub    $0x4,%esp
80105700:	50                   	push   %eax
80105701:	53                   	push   %ebx
80105702:	56                   	push   %esi
80105703:	e8 a8 c4 ff ff       	call   80101bb0 <dirlookup>
80105708:	83 c4 10             	add    $0x10,%esp
8010570b:	85 c0                	test   %eax,%eax
8010570d:	89 c3                	mov    %eax,%ebx
8010570f:	0f 84 cf 00 00 00    	je     801057e4 <sys_unlink+0x164>
  ilock(ip);
80105715:	83 ec 0c             	sub    $0xc,%esp
80105718:	50                   	push   %eax
80105719:	e8 62 bf ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
8010571e:	83 c4 10             	add    $0x10,%esp
80105721:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105726:	0f 8e 10 01 00 00    	jle    8010583c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010572c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105731:	74 6d                	je     801057a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105733:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105736:	83 ec 04             	sub    $0x4,%esp
80105739:	6a 10                	push   $0x10
8010573b:	6a 00                	push   $0x0
8010573d:	50                   	push   %eax
8010573e:	e8 bd f5 ff ff       	call   80104d00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105743:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105746:	6a 10                	push   $0x10
80105748:	ff 75 c4             	pushl  -0x3c(%ebp)
8010574b:	50                   	push   %eax
8010574c:	56                   	push   %esi
8010574d:	e8 0e c3 ff ff       	call   80101a60 <writei>
80105752:	83 c4 20             	add    $0x20,%esp
80105755:	83 f8 10             	cmp    $0x10,%eax
80105758:	0f 85 eb 00 00 00    	jne    80105849 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010575e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105763:	0f 84 97 00 00 00    	je     80105800 <sys_unlink+0x180>
  iunlockput(dp);
80105769:	83 ec 0c             	sub    $0xc,%esp
8010576c:	56                   	push   %esi
8010576d:	e8 9e c1 ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105772:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105777:	89 1c 24             	mov    %ebx,(%esp)
8010577a:	e8 51 be ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
8010577f:	89 1c 24             	mov    %ebx,(%esp)
80105782:	e8 89 c1 ff ff       	call   80101910 <iunlockput>
  end_op();
80105787:	e8 84 d4 ff ff       	call   80102c10 <end_op>
  return 0;
8010578c:	83 c4 10             	add    $0x10,%esp
8010578f:	31 c0                	xor    %eax,%eax
}
80105791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105794:	5b                   	pop    %ebx
80105795:	5e                   	pop    %esi
80105796:	5f                   	pop    %edi
80105797:	5d                   	pop    %ebp
80105798:	c3                   	ret    
80105799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801057a4:	76 8d                	jbe    80105733 <sys_unlink+0xb3>
801057a6:	bf 20 00 00 00       	mov    $0x20,%edi
801057ab:	eb 0f                	jmp    801057bc <sys_unlink+0x13c>
801057ad:	8d 76 00             	lea    0x0(%esi),%esi
801057b0:	83 c7 10             	add    $0x10,%edi
801057b3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801057b6:	0f 83 77 ff ff ff    	jae    80105733 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057bc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801057bf:	6a 10                	push   $0x10
801057c1:	57                   	push   %edi
801057c2:	50                   	push   %eax
801057c3:	53                   	push   %ebx
801057c4:	e8 97 c1 ff ff       	call   80101960 <readi>
801057c9:	83 c4 10             	add    $0x10,%esp
801057cc:	83 f8 10             	cmp    $0x10,%eax
801057cf:	75 5e                	jne    8010582f <sys_unlink+0x1af>
    if(de.inum != 0)
801057d1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801057d6:	74 d8                	je     801057b0 <sys_unlink+0x130>
    iunlockput(ip);
801057d8:	83 ec 0c             	sub    $0xc,%esp
801057db:	53                   	push   %ebx
801057dc:	e8 2f c1 ff ff       	call   80101910 <iunlockput>
    goto bad;
801057e1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801057e4:	83 ec 0c             	sub    $0xc,%esp
801057e7:	56                   	push   %esi
801057e8:	e8 23 c1 ff ff       	call   80101910 <iunlockput>
  end_op();
801057ed:	e8 1e d4 ff ff       	call   80102c10 <end_op>
  return -1;
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057fa:	eb 95                	jmp    80105791 <sys_unlink+0x111>
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105800:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105805:	83 ec 0c             	sub    $0xc,%esp
80105808:	56                   	push   %esi
80105809:	e8 c2 bd ff ff       	call   801015d0 <iupdate>
8010580e:	83 c4 10             	add    $0x10,%esp
80105811:	e9 53 ff ff ff       	jmp    80105769 <sys_unlink+0xe9>
    return -1;
80105816:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581b:	e9 71 ff ff ff       	jmp    80105791 <sys_unlink+0x111>
    end_op();
80105820:	e8 eb d3 ff ff       	call   80102c10 <end_op>
    return -1;
80105825:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010582a:	e9 62 ff ff ff       	jmp    80105791 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010582f:	83 ec 0c             	sub    $0xc,%esp
80105832:	68 08 81 10 80       	push   $0x80108108
80105837:	e8 54 ab ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010583c:	83 ec 0c             	sub    $0xc,%esp
8010583f:	68 f6 80 10 80       	push   $0x801080f6
80105844:	e8 47 ab ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105849:	83 ec 0c             	sub    $0xc,%esp
8010584c:	68 1a 81 10 80       	push   $0x8010811a
80105851:	e8 3a ab ff ff       	call   80100390 <panic>
80105856:	8d 76 00             	lea    0x0(%esi),%esi
80105859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105860 <sys_open>:

int
sys_open(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
80105865:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105866:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105869:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010586c:	50                   	push   %eax
8010586d:	6a 00                	push   $0x0
8010586f:	e8 3c f8 ff ff       	call   801050b0 <argstr>
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	85 c0                	test   %eax,%eax
80105879:	0f 88 1d 01 00 00    	js     8010599c <sys_open+0x13c>
8010587f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105882:	83 ec 08             	sub    $0x8,%esp
80105885:	50                   	push   %eax
80105886:	6a 01                	push   $0x1
80105888:	e8 73 f7 ff ff       	call   80105000 <argint>
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	85 c0                	test   %eax,%eax
80105892:	0f 88 04 01 00 00    	js     8010599c <sys_open+0x13c>
    return -1;

  begin_op();
80105898:	e8 03 d3 ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
8010589d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058a1:	0f 85 a9 00 00 00    	jne    80105950 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058a7:	83 ec 0c             	sub    $0xc,%esp
801058aa:	ff 75 e0             	pushl  -0x20(%ebp)
801058ad:	e8 2e c6 ff ff       	call   80101ee0 <namei>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	89 c6                	mov    %eax,%esi
801058b9:	0f 84 b2 00 00 00    	je     80105971 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801058bf:	83 ec 0c             	sub    $0xc,%esp
801058c2:	50                   	push   %eax
801058c3:	e8 b8 bd ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058c8:	83 c4 10             	add    $0x10,%esp
801058cb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801058d0:	0f 84 aa 00 00 00    	je     80105980 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058d6:	e8 a5 b4 ff ff       	call   80100d80 <filealloc>
801058db:	85 c0                	test   %eax,%eax
801058dd:	89 c7                	mov    %eax,%edi
801058df:	0f 84 a6 00 00 00    	je     8010598b <sys_open+0x12b>
  struct proc *curproc = myproc();
801058e5:	e8 26 e0 ff ff       	call   80103910 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ea:	31 db                	xor    %ebx,%ebx
801058ec:	eb 0e                	jmp    801058fc <sys_open+0x9c>
801058ee:	66 90                	xchg   %ax,%ax
801058f0:	83 c3 01             	add    $0x1,%ebx
801058f3:	83 fb 10             	cmp    $0x10,%ebx
801058f6:	0f 84 ac 00 00 00    	je     801059a8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801058fc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105900:	85 d2                	test   %edx,%edx
80105902:	75 ec                	jne    801058f0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105904:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105907:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010590b:	56                   	push   %esi
8010590c:	e8 4f be ff ff       	call   80101760 <iunlock>
  end_op();
80105911:	e8 fa d2 ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80105916:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010591c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010591f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105922:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105925:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010592c:	89 d0                	mov    %edx,%eax
8010592e:	f7 d0                	not    %eax
80105930:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105933:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105936:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105939:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010593d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105940:	89 d8                	mov    %ebx,%eax
80105942:	5b                   	pop    %ebx
80105943:	5e                   	pop    %esi
80105944:	5f                   	pop    %edi
80105945:	5d                   	pop    %ebp
80105946:	c3                   	ret    
80105947:	89 f6                	mov    %esi,%esi
80105949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105950:	83 ec 0c             	sub    $0xc,%esp
80105953:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105956:	31 c9                	xor    %ecx,%ecx
80105958:	6a 00                	push   $0x0
8010595a:	ba 02 00 00 00       	mov    $0x2,%edx
8010595f:	e8 ec f7 ff ff       	call   80105150 <create>
    if(ip == 0){
80105964:	83 c4 10             	add    $0x10,%esp
80105967:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105969:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010596b:	0f 85 65 ff ff ff    	jne    801058d6 <sys_open+0x76>
      end_op();
80105971:	e8 9a d2 ff ff       	call   80102c10 <end_op>
      return -1;
80105976:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010597b:	eb c0                	jmp    8010593d <sys_open+0xdd>
8010597d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105980:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105983:	85 c9                	test   %ecx,%ecx
80105985:	0f 84 4b ff ff ff    	je     801058d6 <sys_open+0x76>
    iunlockput(ip);
8010598b:	83 ec 0c             	sub    $0xc,%esp
8010598e:	56                   	push   %esi
8010598f:	e8 7c bf ff ff       	call   80101910 <iunlockput>
    end_op();
80105994:	e8 77 d2 ff ff       	call   80102c10 <end_op>
    return -1;
80105999:	83 c4 10             	add    $0x10,%esp
8010599c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059a1:	eb 9a                	jmp    8010593d <sys_open+0xdd>
801059a3:	90                   	nop
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801059a8:	83 ec 0c             	sub    $0xc,%esp
801059ab:	57                   	push   %edi
801059ac:	e8 8f b4 ff ff       	call   80100e40 <fileclose>
801059b1:	83 c4 10             	add    $0x10,%esp
801059b4:	eb d5                	jmp    8010598b <sys_open+0x12b>
801059b6:	8d 76 00             	lea    0x0(%esi),%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059c6:	e8 d5 d1 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ce:	83 ec 08             	sub    $0x8,%esp
801059d1:	50                   	push   %eax
801059d2:	6a 00                	push   $0x0
801059d4:	e8 d7 f6 ff ff       	call   801050b0 <argstr>
801059d9:	83 c4 10             	add    $0x10,%esp
801059dc:	85 c0                	test   %eax,%eax
801059de:	78 30                	js     80105a10 <sys_mkdir+0x50>
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e6:	31 c9                	xor    %ecx,%ecx
801059e8:	6a 00                	push   $0x0
801059ea:	ba 01 00 00 00       	mov    $0x1,%edx
801059ef:	e8 5c f7 ff ff       	call   80105150 <create>
801059f4:	83 c4 10             	add    $0x10,%esp
801059f7:	85 c0                	test   %eax,%eax
801059f9:	74 15                	je     80105a10 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059fb:	83 ec 0c             	sub    $0xc,%esp
801059fe:	50                   	push   %eax
801059ff:	e8 0c bf ff ff       	call   80101910 <iunlockput>
  end_op();
80105a04:	e8 07 d2 ff ff       	call   80102c10 <end_op>
  return 0;
80105a09:	83 c4 10             	add    $0x10,%esp
80105a0c:	31 c0                	xor    %eax,%eax
}
80105a0e:	c9                   	leave  
80105a0f:	c3                   	ret    
    end_op();
80105a10:	e8 fb d1 ff ff       	call   80102c10 <end_op>
    return -1;
80105a15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a1a:	c9                   	leave  
80105a1b:	c3                   	ret    
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_mknod>:

int
sys_mknod(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a26:	e8 75 d1 ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a2b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a2e:	83 ec 08             	sub    $0x8,%esp
80105a31:	50                   	push   %eax
80105a32:	6a 00                	push   $0x0
80105a34:	e8 77 f6 ff ff       	call   801050b0 <argstr>
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	85 c0                	test   %eax,%eax
80105a3e:	78 60                	js     80105aa0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a40:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a43:	83 ec 08             	sub    $0x8,%esp
80105a46:	50                   	push   %eax
80105a47:	6a 01                	push   $0x1
80105a49:	e8 b2 f5 ff ff       	call   80105000 <argint>
  if((argstr(0, &path)) < 0 ||
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	85 c0                	test   %eax,%eax
80105a53:	78 4b                	js     80105aa0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a55:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a58:	83 ec 08             	sub    $0x8,%esp
80105a5b:	50                   	push   %eax
80105a5c:	6a 02                	push   $0x2
80105a5e:	e8 9d f5 ff ff       	call   80105000 <argint>
     argint(1, &major) < 0 ||
80105a63:	83 c4 10             	add    $0x10,%esp
80105a66:	85 c0                	test   %eax,%eax
80105a68:	78 36                	js     80105aa0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a6a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a6e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a71:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105a75:	ba 03 00 00 00       	mov    $0x3,%edx
80105a7a:	50                   	push   %eax
80105a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a7e:	e8 cd f6 ff ff       	call   80105150 <create>
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	85 c0                	test   %eax,%eax
80105a88:	74 16                	je     80105aa0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a8a:	83 ec 0c             	sub    $0xc,%esp
80105a8d:	50                   	push   %eax
80105a8e:	e8 7d be ff ff       	call   80101910 <iunlockput>
  end_op();
80105a93:	e8 78 d1 ff ff       	call   80102c10 <end_op>
  return 0;
80105a98:	83 c4 10             	add    $0x10,%esp
80105a9b:	31 c0                	xor    %eax,%eax
}
80105a9d:	c9                   	leave  
80105a9e:	c3                   	ret    
80105a9f:	90                   	nop
    end_op();
80105aa0:	e8 6b d1 ff ff       	call   80102c10 <end_op>
    return -1;
80105aa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aaa:	c9                   	leave  
80105aab:	c3                   	ret    
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_chdir>:

int
sys_chdir(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	56                   	push   %esi
80105ab4:	53                   	push   %ebx
80105ab5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ab8:	e8 53 de ff ff       	call   80103910 <myproc>
80105abd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105abf:	e8 dc d0 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac7:	83 ec 08             	sub    $0x8,%esp
80105aca:	50                   	push   %eax
80105acb:	6a 00                	push   $0x0
80105acd:	e8 de f5 ff ff       	call   801050b0 <argstr>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	78 77                	js     80105b50 <sys_chdir+0xa0>
80105ad9:	83 ec 0c             	sub    $0xc,%esp
80105adc:	ff 75 f4             	pushl  -0xc(%ebp)
80105adf:	e8 fc c3 ff ff       	call   80101ee0 <namei>
80105ae4:	83 c4 10             	add    $0x10,%esp
80105ae7:	85 c0                	test   %eax,%eax
80105ae9:	89 c3                	mov    %eax,%ebx
80105aeb:	74 63                	je     80105b50 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105aed:	83 ec 0c             	sub    $0xc,%esp
80105af0:	50                   	push   %eax
80105af1:	e8 8a bb ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105af6:	83 c4 10             	add    $0x10,%esp
80105af9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105afe:	75 30                	jne    80105b30 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	53                   	push   %ebx
80105b04:	e8 57 bc ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105b09:	58                   	pop    %eax
80105b0a:	ff 76 68             	pushl  0x68(%esi)
80105b0d:	e8 9e bc ff ff       	call   801017b0 <iput>
  end_op();
80105b12:	e8 f9 d0 ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80105b17:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b1a:	83 c4 10             	add    $0x10,%esp
80105b1d:	31 c0                	xor    %eax,%eax
}
80105b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b22:	5b                   	pop    %ebx
80105b23:	5e                   	pop    %esi
80105b24:	5d                   	pop    %ebp
80105b25:	c3                   	ret    
80105b26:	8d 76 00             	lea    0x0(%esi),%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	53                   	push   %ebx
80105b34:	e8 d7 bd ff ff       	call   80101910 <iunlockput>
    end_op();
80105b39:	e8 d2 d0 ff ff       	call   80102c10 <end_op>
    return -1;
80105b3e:	83 c4 10             	add    $0x10,%esp
80105b41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b46:	eb d7                	jmp    80105b1f <sys_chdir+0x6f>
80105b48:	90                   	nop
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b50:	e8 bb d0 ff ff       	call   80102c10 <end_op>
    return -1;
80105b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5a:	eb c3                	jmp    80105b1f <sys_chdir+0x6f>
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b60 <sys_exec>:

int
sys_exec(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
80105b65:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b66:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b6c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b72:	50                   	push   %eax
80105b73:	6a 00                	push   $0x0
80105b75:	e8 36 f5 ff ff       	call   801050b0 <argstr>
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	0f 88 87 00 00 00    	js     80105c0c <sys_exec+0xac>
80105b85:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b8b:	83 ec 08             	sub    $0x8,%esp
80105b8e:	50                   	push   %eax
80105b8f:	6a 01                	push   $0x1
80105b91:	e8 6a f4 ff ff       	call   80105000 <argint>
80105b96:	83 c4 10             	add    $0x10,%esp
80105b99:	85 c0                	test   %eax,%eax
80105b9b:	78 6f                	js     80105c0c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b9d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ba3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105ba6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105ba8:	68 80 00 00 00       	push   $0x80
80105bad:	6a 00                	push   $0x0
80105baf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105bb5:	50                   	push   %eax
80105bb6:	e8 45 f1 ff ff       	call   80104d00 <memset>
80105bbb:	83 c4 10             	add    $0x10,%esp
80105bbe:	eb 2c                	jmp    80105bec <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105bc0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bc6:	85 c0                	test   %eax,%eax
80105bc8:	74 56                	je     80105c20 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105bca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105bd0:	83 ec 08             	sub    $0x8,%esp
80105bd3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105bd6:	52                   	push   %edx
80105bd7:	50                   	push   %eax
80105bd8:	e8 b3 f3 ff ff       	call   80104f90 <fetchstr>
80105bdd:	83 c4 10             	add    $0x10,%esp
80105be0:	85 c0                	test   %eax,%eax
80105be2:	78 28                	js     80105c0c <sys_exec+0xac>
  for(i=0;; i++){
80105be4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105be7:	83 fb 20             	cmp    $0x20,%ebx
80105bea:	74 20                	je     80105c0c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105bf2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105bf9:	83 ec 08             	sub    $0x8,%esp
80105bfc:	57                   	push   %edi
80105bfd:	01 f0                	add    %esi,%eax
80105bff:	50                   	push   %eax
80105c00:	e8 4b f3 ff ff       	call   80104f50 <fetchint>
80105c05:	83 c4 10             	add    $0x10,%esp
80105c08:	85 c0                	test   %eax,%eax
80105c0a:	79 b4                	jns    80105bc0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c14:	5b                   	pop    %ebx
80105c15:	5e                   	pop    %esi
80105c16:	5f                   	pop    %edi
80105c17:	5d                   	pop    %ebp
80105c18:	c3                   	ret    
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105c20:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c26:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105c29:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c30:	00 00 00 00 
  return exec(path, argv);
80105c34:	50                   	push   %eax
80105c35:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c3b:	e8 d0 ad ff ff       	call   80100a10 <exec>
80105c40:	83 c4 10             	add    $0x10,%esp
}
80105c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c46:	5b                   	pop    %ebx
80105c47:	5e                   	pop    %esi
80105c48:	5f                   	pop    %edi
80105c49:	5d                   	pop    %ebp
80105c4a:	c3                   	ret    
80105c4b:	90                   	nop
80105c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c50 <sys_pipe>:

int
sys_pipe(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	57                   	push   %edi
80105c54:	56                   	push   %esi
80105c55:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c56:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c59:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c5c:	6a 08                	push   $0x8
80105c5e:	50                   	push   %eax
80105c5f:	6a 00                	push   $0x0
80105c61:	e8 ea f3 ff ff       	call   80105050 <argptr>
80105c66:	83 c4 10             	add    $0x10,%esp
80105c69:	85 c0                	test   %eax,%eax
80105c6b:	0f 88 ae 00 00 00    	js     80105d1f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c71:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c74:	83 ec 08             	sub    $0x8,%esp
80105c77:	50                   	push   %eax
80105c78:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c7b:	50                   	push   %eax
80105c7c:	e8 bf d5 ff ff       	call   80103240 <pipealloc>
80105c81:	83 c4 10             	add    $0x10,%esp
80105c84:	85 c0                	test   %eax,%eax
80105c86:	0f 88 93 00 00 00    	js     80105d1f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c8c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c8f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c91:	e8 7a dc ff ff       	call   80103910 <myproc>
80105c96:	eb 10                	jmp    80105ca8 <sys_pipe+0x58>
80105c98:	90                   	nop
80105c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105ca0:	83 c3 01             	add    $0x1,%ebx
80105ca3:	83 fb 10             	cmp    $0x10,%ebx
80105ca6:	74 60                	je     80105d08 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105ca8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105cac:	85 f6                	test   %esi,%esi
80105cae:	75 f0                	jne    80105ca0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105cb0:	8d 73 08             	lea    0x8(%ebx),%esi
80105cb3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cb7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105cba:	e8 51 dc ff ff       	call   80103910 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cbf:	31 d2                	xor    %edx,%edx
80105cc1:	eb 0d                	jmp    80105cd0 <sys_pipe+0x80>
80105cc3:	90                   	nop
80105cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cc8:	83 c2 01             	add    $0x1,%edx
80105ccb:	83 fa 10             	cmp    $0x10,%edx
80105cce:	74 28                	je     80105cf8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105cd0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105cd4:	85 c9                	test   %ecx,%ecx
80105cd6:	75 f0                	jne    80105cc8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105cd8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105cdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cdf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ce1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ce4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ce7:	31 c0                	xor    %eax,%eax
}
80105ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cec:	5b                   	pop    %ebx
80105ced:	5e                   	pop    %esi
80105cee:	5f                   	pop    %edi
80105cef:	5d                   	pop    %ebp
80105cf0:	c3                   	ret    
80105cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105cf8:	e8 13 dc ff ff       	call   80103910 <myproc>
80105cfd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d04:	00 
80105d05:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105d08:	83 ec 0c             	sub    $0xc,%esp
80105d0b:	ff 75 e0             	pushl  -0x20(%ebp)
80105d0e:	e8 2d b1 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105d13:	58                   	pop    %eax
80105d14:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d17:	e8 24 b1 ff ff       	call   80100e40 <fileclose>
    return -1;
80105d1c:	83 c4 10             	add    $0x10,%esp
80105d1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d24:	eb c3                	jmp    80105ce9 <sys_pipe+0x99>
80105d26:	66 90                	xchg   %ax,%ax
80105d28:	66 90                	xchg   %ax,%ax
80105d2a:	66 90                	xchg   %ax,%ax
80105d2c:	66 90                	xchg   %ax,%ax
80105d2e:	66 90                	xchg   %ax,%ax

80105d30 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105d33:	5d                   	pop    %ebp
  return fork();
80105d34:	e9 87 dd ff ff       	jmp    80103ac0 <fork>
80105d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d40 <sys_exit>:

int
sys_exit(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d46:	e8 e5 e0 ff ff       	call   80103e30 <exit>
  return 0;  // not reached
}
80105d4b:	31 c0                	xor    %eax,%eax
80105d4d:	c9                   	leave  
80105d4e:	c3                   	ret    
80105d4f:	90                   	nop

80105d50 <sys_wait>:

int
sys_wait(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105d53:	5d                   	pop    %ebp
  return wait();
80105d54:	e9 f7 e4 ff ff       	jmp    80104250 <wait>
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d60 <sys_kill>:

int
sys_kill(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d69:	50                   	push   %eax
80105d6a:	6a 00                	push   $0x0
80105d6c:	e8 8f f2 ff ff       	call   80105000 <argint>
80105d71:	83 c4 10             	add    $0x10,%esp
80105d74:	85 c0                	test   %eax,%eax
80105d76:	78 18                	js     80105d90 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d78:	83 ec 0c             	sub    $0xc,%esp
80105d7b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d7e:	e8 fd e5 ff ff       	call   80104380 <kill>
80105d83:	83 c4 10             	add    $0x10,%esp
}
80105d86:	c9                   	leave  
80105d87:	c3                   	ret    
80105d88:	90                   	nop
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d95:	c9                   	leave  
80105d96:	c3                   	ret    
80105d97:	89 f6                	mov    %esi,%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105da0 <sys_getpid>:

int
sys_getpid(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105da6:	e8 65 db ff ff       	call   80103910 <myproc>
80105dab:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dae:	c9                   	leave  
80105daf:	c3                   	ret    

80105db0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105db4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105db7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dba:	50                   	push   %eax
80105dbb:	6a 00                	push   $0x0
80105dbd:	e8 3e f2 ff ff       	call   80105000 <argint>
80105dc2:	83 c4 10             	add    $0x10,%esp
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	78 27                	js     80105df0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105dc9:	e8 42 db ff ff       	call   80103910 <myproc>
  if(growproc(n) < 0)
80105dce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105dd1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105dd3:	ff 75 f4             	pushl  -0xc(%ebp)
80105dd6:	e8 65 dc ff ff       	call   80103a40 <growproc>
80105ddb:	83 c4 10             	add    $0x10,%esp
80105dde:	85 c0                	test   %eax,%eax
80105de0:	78 0e                	js     80105df0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105de2:	89 d8                	mov    %ebx,%eax
80105de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105de7:	c9                   	leave  
80105de8:	c3                   	ret    
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105df0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105df5:	eb eb                	jmp    80105de2 <sys_sbrk+0x32>
80105df7:	89 f6                	mov    %esi,%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e00 <sys_sleep>:

int
sys_sleep(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e0a:	50                   	push   %eax
80105e0b:	6a 00                	push   $0x0
80105e0d:	e8 ee f1 ff ff       	call   80105000 <argint>
80105e12:	83 c4 10             	add    $0x10,%esp
80105e15:	85 c0                	test   %eax,%eax
80105e17:	0f 88 8a 00 00 00    	js     80105ea7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e1d:	83 ec 0c             	sub    $0xc,%esp
80105e20:	68 40 61 11 80       	push   $0x80116140
80105e25:	e8 c6 ed ff ff       	call   80104bf0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e2d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105e30:	8b 1d 80 69 11 80    	mov    0x80116980,%ebx
  while(ticks - ticks0 < n){
80105e36:	85 d2                	test   %edx,%edx
80105e38:	75 27                	jne    80105e61 <sys_sleep+0x61>
80105e3a:	eb 54                	jmp    80105e90 <sys_sleep+0x90>
80105e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e40:	83 ec 08             	sub    $0x8,%esp
80105e43:	68 40 61 11 80       	push   $0x80116140
80105e48:	68 80 69 11 80       	push   $0x80116980
80105e4d:	e8 ae e2 ff ff       	call   80104100 <sleep>
  while(ticks - ticks0 < n){
80105e52:	a1 80 69 11 80       	mov    0x80116980,%eax
80105e57:	83 c4 10             	add    $0x10,%esp
80105e5a:	29 d8                	sub    %ebx,%eax
80105e5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e5f:	73 2f                	jae    80105e90 <sys_sleep+0x90>
    if(myproc()->killed){
80105e61:	e8 aa da ff ff       	call   80103910 <myproc>
80105e66:	8b 40 24             	mov    0x24(%eax),%eax
80105e69:	85 c0                	test   %eax,%eax
80105e6b:	74 d3                	je     80105e40 <sys_sleep+0x40>
      release(&tickslock);
80105e6d:	83 ec 0c             	sub    $0xc,%esp
80105e70:	68 40 61 11 80       	push   $0x80116140
80105e75:	e8 36 ee ff ff       	call   80104cb0 <release>
      return -1;
80105e7a:	83 c4 10             	add    $0x10,%esp
80105e7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105e82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e85:	c9                   	leave  
80105e86:	c3                   	ret    
80105e87:	89 f6                	mov    %esi,%esi
80105e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105e90:	83 ec 0c             	sub    $0xc,%esp
80105e93:	68 40 61 11 80       	push   $0x80116140
80105e98:	e8 13 ee ff ff       	call   80104cb0 <release>
  return 0;
80105e9d:	83 c4 10             	add    $0x10,%esp
80105ea0:	31 c0                	xor    %eax,%eax
}
80105ea2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ea5:	c9                   	leave  
80105ea6:	c3                   	ret    
    return -1;
80105ea7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eac:	eb f4                	jmp    80105ea2 <sys_sleep+0xa2>
80105eae:	66 90                	xchg   %ax,%ax

80105eb0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	53                   	push   %ebx
80105eb4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105eb7:	68 40 61 11 80       	push   $0x80116140
80105ebc:	e8 2f ed ff ff       	call   80104bf0 <acquire>
  xticks = ticks;
80105ec1:	8b 1d 80 69 11 80    	mov    0x80116980,%ebx
  release(&tickslock);
80105ec7:	c7 04 24 40 61 11 80 	movl   $0x80116140,(%esp)
80105ece:	e8 dd ed ff ff       	call   80104cb0 <release>
  return xticks;
}
80105ed3:	89 d8                	mov    %ebx,%eax
80105ed5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ed8:	c9                   	leave  
80105ed9:	c3                   	ret    
80105eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ee0 <sys_getpname>:

int
sys_getpname(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  // Passing arguments from user-level functions 
  // to kernel-level functions cannot be done in XV6. 
  // XV6 has its own built-in functions for passing arguments into a kernel function.
  if(argint(0, &pid) < 0){
80105ee6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ee9:	50                   	push   %eax
80105eea:	6a 00                	push   $0x0
80105eec:	e8 0f f1 ff ff       	call   80105000 <argint>
80105ef1:	83 c4 10             	add    $0x10,%esp
80105ef4:	85 c0                	test   %eax,%eax
80105ef6:	78 18                	js     80105f10 <sys_getpname+0x30>
    return -1;
  }
  return getpname(pid);
80105ef8:	83 ec 0c             	sub    $0xc,%esp
80105efb:	ff 75 f4             	pushl  -0xc(%ebp)
80105efe:	e8 cd e5 ff ff       	call   801044d0 <getpname>
80105f03:	83 c4 10             	add    $0x10,%esp
}
80105f06:	c9                   	leave  
80105f07:	c3                   	ret    
80105f08:	90                   	nop
80105f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f15:	c9                   	leave  
80105f16:	c3                   	ret    
80105f17:	89 f6                	mov    %esi,%esi
80105f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f20 <sys_getnice>:

int
sys_getnice(void)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0){
80105f26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f29:	50                   	push   %eax
80105f2a:	6a 00                	push   $0x0
80105f2c:	e8 cf f0 ff ff       	call   80105000 <argint>
80105f31:	83 c4 10             	add    $0x10,%esp
80105f34:	85 c0                	test   %eax,%eax
80105f36:	78 18                	js     80105f50 <sys_getnice+0x30>
    return -1;
  }
  return getnice(pid);
80105f38:	83 ec 0c             	sub    $0xc,%esp
80105f3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f3e:	e8 0d e6 ff ff       	call   80104550 <getnice>
80105f43:	83 c4 10             	add    $0x10,%esp
}
80105f46:	c9                   	leave  
80105f47:	c3                   	ret    
80105f48:	90                   	nop
80105f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f55:	c9                   	leave  
80105f56:	c3                   	ret    
80105f57:	89 f6                	mov    %esi,%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f60 <sys_setnice>:

int
sys_setnice(void)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	83 ec 20             	sub    $0x20,%esp
  int pid, value;

  if(argint(0, &pid) < 0){
80105f66:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f69:	50                   	push   %eax
80105f6a:	6a 00                	push   $0x0
80105f6c:	e8 8f f0 ff ff       	call   80105000 <argint>
80105f71:	83 c4 10             	add    $0x10,%esp
80105f74:	85 c0                	test   %eax,%eax
80105f76:	78 28                	js     80105fa0 <sys_setnice+0x40>
    return -1;
  }
  if(argint(1, &value) < 0){
80105f78:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f7b:	83 ec 08             	sub    $0x8,%esp
80105f7e:	50                   	push   %eax
80105f7f:	6a 01                	push   $0x1
80105f81:	e8 7a f0 ff ff       	call   80105000 <argint>
80105f86:	83 c4 10             	add    $0x10,%esp
80105f89:	85 c0                	test   %eax,%eax
80105f8b:	78 13                	js     80105fa0 <sys_setnice+0x40>
    return -1;
  }
  return setnice(pid, value);
80105f8d:	83 ec 08             	sub    $0x8,%esp
80105f90:	ff 75 f4             	pushl  -0xc(%ebp)
80105f93:	ff 75 f0             	pushl  -0x10(%ebp)
80105f96:	e8 35 e6 ff ff       	call   801045d0 <setnice>
80105f9b:	83 c4 10             	add    $0x10,%esp
}
80105f9e:	c9                   	leave  
80105f9f:	c3                   	ret    
    return -1;
80105fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fa5:	c9                   	leave  
80105fa6:	c3                   	ret    
80105fa7:	89 f6                	mov    %esi,%esi
80105fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fb0 <sys_ps>:

void
sys_ps(void)
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0){
80105fb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fb9:	50                   	push   %eax
80105fba:	6a 00                	push   $0x0
80105fbc:	e8 3f f0 ff ff       	call   80105000 <argint>
80105fc1:	83 c4 10             	add    $0x10,%esp
80105fc4:	85 c0                	test   %eax,%eax
80105fc6:	78 18                	js     80105fe0 <sys_ps+0x30>
    exit(); // no return value
  }
  return ps(pid);
80105fc8:	83 ec 0c             	sub    $0xc,%esp
80105fcb:	ff 75 f4             	pushl  -0xc(%ebp)
80105fce:	e8 8d e6 ff ff       	call   80104660 <ps>
80105fd3:	83 c4 10             	add    $0x10,%esp
80105fd6:	c9                   	leave  
80105fd7:	c3                   	ret    
80105fd8:	90                   	nop
80105fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit(); // no return value
80105fe0:	e8 4b de ff ff       	call   80103e30 <exit>
  return ps(pid);
80105fe5:	83 ec 0c             	sub    $0xc,%esp
80105fe8:	ff 75 f4             	pushl  -0xc(%ebp)
80105feb:	e8 70 e6 ff ff       	call   80104660 <ps>
80105ff0:	83 c4 10             	add    $0x10,%esp
80105ff3:	c9                   	leave  
80105ff4:	c3                   	ret    

80105ff5 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105ff5:	1e                   	push   %ds
  pushl %es
80105ff6:	06                   	push   %es
  pushl %fs
80105ff7:	0f a0                	push   %fs
  pushl %gs
80105ff9:	0f a8                	push   %gs
  pushal
80105ffb:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ffc:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106000:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106002:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106004:	54                   	push   %esp
  call trap
80106005:	e8 c6 00 00 00       	call   801060d0 <trap>
  addl $4, %esp
8010600a:	83 c4 04             	add    $0x4,%esp

8010600d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010600d:	61                   	popa   
  popl %gs
8010600e:	0f a9                	pop    %gs
  popl %fs
80106010:	0f a1                	pop    %fs
  popl %es
80106012:	07                   	pop    %es
  popl %ds
80106013:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106014:	83 c4 08             	add    $0x8,%esp
  iret
80106017:	cf                   	iret   
80106018:	66 90                	xchg   %ax,%ax
8010601a:	66 90                	xchg   %ax,%ax
8010601c:	66 90                	xchg   %ax,%ax
8010601e:	66 90                	xchg   %ax,%ax

80106020 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106020:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106021:	31 c0                	xor    %eax,%eax
{
80106023:	89 e5                	mov    %esp,%ebp
80106025:	83 ec 08             	sub    $0x8,%esp
80106028:	90                   	nop
80106029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106030:	8b 14 85 c4 b0 10 80 	mov    -0x7fef4f3c(,%eax,4),%edx
80106037:	c7 04 c5 82 61 11 80 	movl   $0x8e000008,-0x7fee9e7e(,%eax,8)
8010603e:	08 00 00 8e 
80106042:	66 89 14 c5 80 61 11 	mov    %dx,-0x7fee9e80(,%eax,8)
80106049:	80 
8010604a:	c1 ea 10             	shr    $0x10,%edx
8010604d:	66 89 14 c5 86 61 11 	mov    %dx,-0x7fee9e7a(,%eax,8)
80106054:	80 
  for(i = 0; i < 256; i++)
80106055:	83 c0 01             	add    $0x1,%eax
80106058:	3d 00 01 00 00       	cmp    $0x100,%eax
8010605d:	75 d1                	jne    80106030 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010605f:	a1 c4 b1 10 80       	mov    0x8010b1c4,%eax

  initlock(&tickslock, "time");
80106064:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106067:	c7 05 82 63 11 80 08 	movl   $0xef000008,0x80116382
8010606e:	00 00 ef 
  initlock(&tickslock, "time");
80106071:	68 fd 7e 10 80       	push   $0x80107efd
80106076:	68 40 61 11 80       	push   $0x80116140
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010607b:	66 a3 80 63 11 80    	mov    %ax,0x80116380
80106081:	c1 e8 10             	shr    $0x10,%eax
80106084:	66 a3 86 63 11 80    	mov    %ax,0x80116386
  initlock(&tickslock, "time");
8010608a:	e8 21 ea ff ff       	call   80104ab0 <initlock>
}
8010608f:	83 c4 10             	add    $0x10,%esp
80106092:	c9                   	leave  
80106093:	c3                   	ret    
80106094:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010609a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801060a0 <idtinit>:

void
idtinit(void)
{
801060a0:	55                   	push   %ebp
  pd[0] = size-1;
801060a1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801060a6:	89 e5                	mov    %esp,%ebp
801060a8:	83 ec 10             	sub    $0x10,%esp
801060ab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801060af:	b8 80 61 11 80       	mov    $0x80116180,%eax
801060b4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801060b8:	c1 e8 10             	shr    $0x10,%eax
801060bb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801060bf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801060c2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801060c5:	c9                   	leave  
801060c6:	c3                   	ret    
801060c7:	89 f6                	mov    %esi,%esi
801060c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060d0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	57                   	push   %edi
801060d4:	56                   	push   %esi
801060d5:	53                   	push   %ebx
801060d6:	83 ec 1c             	sub    $0x1c,%esp
801060d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801060dc:	8b 47 30             	mov    0x30(%edi),%eax
801060df:	83 f8 40             	cmp    $0x40,%eax
801060e2:	0f 84 f0 00 00 00    	je     801061d8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801060e8:	83 e8 20             	sub    $0x20,%eax
801060eb:	83 f8 1f             	cmp    $0x1f,%eax
801060ee:	77 10                	ja     80106100 <trap+0x30>
801060f0:	ff 24 85 cc 81 10 80 	jmp    *-0x7fef7e34(,%eax,4)
801060f7:	89 f6                	mov    %esi,%esi
801060f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106100:	e8 0b d8 ff ff       	call   80103910 <myproc>
80106105:	85 c0                	test   %eax,%eax
80106107:	8b 5f 38             	mov    0x38(%edi),%ebx
8010610a:	0f 84 54 02 00 00    	je     80106364 <trap+0x294>
80106110:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106114:	0f 84 4a 02 00 00    	je     80106364 <trap+0x294>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010611a:	0f 20 d1             	mov    %cr2,%ecx
8010611d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106120:	e8 cb d7 ff ff       	call   801038f0 <cpuid>
80106125:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106128:	8b 47 34             	mov    0x34(%edi),%eax
8010612b:	8b 77 30             	mov    0x30(%edi),%esi
8010612e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106131:	e8 da d7 ff ff       	call   80103910 <myproc>
80106136:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106139:	e8 d2 d7 ff ff       	call   80103910 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010613e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106141:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106144:	51                   	push   %ecx
80106145:	53                   	push   %ebx
80106146:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106147:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010614a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010614d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010614e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106151:	52                   	push   %edx
80106152:	ff 70 10             	pushl  0x10(%eax)
80106155:	68 88 81 10 80       	push   $0x80108188
8010615a:	e8 01 a5 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010615f:	83 c4 20             	add    $0x20,%esp
80106162:	e8 a9 d7 ff ff       	call   80103910 <myproc>
80106167:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010616e:	e8 9d d7 ff ff       	call   80103910 <myproc>
80106173:	85 c0                	test   %eax,%eax
80106175:	74 1d                	je     80106194 <trap+0xc4>
80106177:	e8 94 d7 ff ff       	call   80103910 <myproc>
8010617c:	8b 48 24             	mov    0x24(%eax),%ecx
8010617f:	85 c9                	test   %ecx,%ecx
80106181:	74 11                	je     80106194 <trap+0xc4>
80106183:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106187:	83 e0 03             	and    $0x3,%eax
8010618a:	66 83 f8 03          	cmp    $0x3,%ax
8010618e:	0f 84 8c 01 00 00    	je     80106320 <trap+0x250>
    exit();

  // Check on clock tick if process has used up all its execution time
  // if so force process to yield
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106194:	e8 77 d7 ff ff       	call   80103910 <myproc>
80106199:	85 c0                	test   %eax,%eax
8010619b:	74 0b                	je     801061a8 <trap+0xd8>
8010619d:	e8 6e d7 ff ff       	call   80103910 <myproc>
801061a2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801061a6:	74 68                	je     80106210 <trap+0x140>
  // // If interrupts were on while locks held, would need to check nlock.
  // if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
  //   yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061a8:	e8 63 d7 ff ff       	call   80103910 <myproc>
801061ad:	85 c0                	test   %eax,%eax
801061af:	74 19                	je     801061ca <trap+0xfa>
801061b1:	e8 5a d7 ff ff       	call   80103910 <myproc>
801061b6:	8b 40 24             	mov    0x24(%eax),%eax
801061b9:	85 c0                	test   %eax,%eax
801061bb:	74 0d                	je     801061ca <trap+0xfa>
801061bd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801061c1:	83 e0 03             	and    $0x3,%eax
801061c4:	66 83 f8 03          	cmp    $0x3,%ax
801061c8:	74 37                	je     80106201 <trap+0x131>
    exit();
}
801061ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061cd:	5b                   	pop    %ebx
801061ce:	5e                   	pop    %esi
801061cf:	5f                   	pop    %edi
801061d0:	5d                   	pop    %ebp
801061d1:	c3                   	ret    
801061d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801061d8:	e8 33 d7 ff ff       	call   80103910 <myproc>
801061dd:	8b 70 24             	mov    0x24(%eax),%esi
801061e0:	85 f6                	test   %esi,%esi
801061e2:	0f 85 28 01 00 00    	jne    80106310 <trap+0x240>
    myproc()->tf = tf;
801061e8:	e8 23 d7 ff ff       	call   80103910 <myproc>
801061ed:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801061f0:	e8 fb ee ff ff       	call   801050f0 <syscall>
    if(myproc()->killed)
801061f5:	e8 16 d7 ff ff       	call   80103910 <myproc>
801061fa:	8b 58 24             	mov    0x24(%eax),%ebx
801061fd:	85 db                	test   %ebx,%ebx
801061ff:	74 c9                	je     801061ca <trap+0xfa>
}
80106201:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106204:	5b                   	pop    %ebx
80106205:	5e                   	pop    %esi
80106206:	5f                   	pop    %edi
80106207:	5d                   	pop    %ebp
      exit();
80106208:	e9 23 dc ff ff       	jmp    80103e30 <exit>
8010620d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106210:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106214:	75 92                	jne    801061a8 <trap+0xd8>
      myproc()->timeslice = myproc()->timeslice - myproc()->vruntime;
80106216:	e8 f5 d6 ff ff       	call   80103910 <myproc>
8010621b:	8b 98 88 00 00 00    	mov    0x88(%eax),%ebx
80106221:	e8 ea d6 ff ff       	call   80103910 <myproc>
80106226:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
8010622c:	e8 df d6 ff ff       	call   80103910 <myproc>
80106231:	29 f3                	sub    %esi,%ebx
80106233:	89 98 88 00 00 00    	mov    %ebx,0x88(%eax)
      if (myproc()->timeslice == 0)
80106239:	e8 d2 d6 ff ff       	call   80103910 <myproc>
8010623e:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80106244:	85 d2                	test   %edx,%edx
80106246:	0f 85 5c ff ff ff    	jne    801061a8 <trap+0xd8>
          yield();
8010624c:	e8 5f dd ff ff       	call   80103fb0 <yield>
80106251:	e9 52 ff ff ff       	jmp    801061a8 <trap+0xd8>
80106256:	8d 76 00             	lea    0x0(%esi),%esi
80106259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(cpuid() == 0){
80106260:	e8 8b d6 ff ff       	call   801038f0 <cpuid>
80106265:	85 c0                	test   %eax,%eax
80106267:	0f 84 c3 00 00 00    	je     80106330 <trap+0x260>
    lapiceoi();
8010626d:	e8 de c4 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106272:	e8 99 d6 ff ff       	call   80103910 <myproc>
80106277:	85 c0                	test   %eax,%eax
80106279:	0f 85 f8 fe ff ff    	jne    80106177 <trap+0xa7>
8010627f:	e9 10 ff ff ff       	jmp    80106194 <trap+0xc4>
80106284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106288:	e8 83 c3 ff ff       	call   80102610 <kbdintr>
    lapiceoi();
8010628d:	e8 be c4 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106292:	e8 79 d6 ff ff       	call   80103910 <myproc>
80106297:	85 c0                	test   %eax,%eax
80106299:	0f 85 d8 fe ff ff    	jne    80106177 <trap+0xa7>
8010629f:	e9 f0 fe ff ff       	jmp    80106194 <trap+0xc4>
801062a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801062a8:	e8 53 02 00 00       	call   80106500 <uartintr>
    lapiceoi();
801062ad:	e8 9e c4 ff ff       	call   80102750 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062b2:	e8 59 d6 ff ff       	call   80103910 <myproc>
801062b7:	85 c0                	test   %eax,%eax
801062b9:	0f 85 b8 fe ff ff    	jne    80106177 <trap+0xa7>
801062bf:	e9 d0 fe ff ff       	jmp    80106194 <trap+0xc4>
801062c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062c8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801062cc:	8b 77 38             	mov    0x38(%edi),%esi
801062cf:	e8 1c d6 ff ff       	call   801038f0 <cpuid>
801062d4:	56                   	push   %esi
801062d5:	53                   	push   %ebx
801062d6:	50                   	push   %eax
801062d7:	68 30 81 10 80       	push   $0x80108130
801062dc:	e8 7f a3 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801062e1:	e8 6a c4 ff ff       	call   80102750 <lapiceoi>
    break;
801062e6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062e9:	e8 22 d6 ff ff       	call   80103910 <myproc>
801062ee:	85 c0                	test   %eax,%eax
801062f0:	0f 85 81 fe ff ff    	jne    80106177 <trap+0xa7>
801062f6:	e9 99 fe ff ff       	jmp    80106194 <trap+0xc4>
801062fb:	90                   	nop
801062fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106300:	e8 7b bd ff ff       	call   80102080 <ideintr>
80106305:	e9 63 ff ff ff       	jmp    8010626d <trap+0x19d>
8010630a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106310:	e8 1b db ff ff       	call   80103e30 <exit>
80106315:	e9 ce fe ff ff       	jmp    801061e8 <trap+0x118>
8010631a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106320:	e8 0b db ff ff       	call   80103e30 <exit>
80106325:	e9 6a fe ff ff       	jmp    80106194 <trap+0xc4>
8010632a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106330:	83 ec 0c             	sub    $0xc,%esp
80106333:	68 40 61 11 80       	push   $0x80116140
80106338:	e8 b3 e8 ff ff       	call   80104bf0 <acquire>
      wakeup(&ticks);
8010633d:	c7 04 24 80 69 11 80 	movl   $0x80116980,(%esp)
      ticks++;
80106344:	83 05 80 69 11 80 01 	addl   $0x1,0x80116980
      wakeup(&ticks);
8010634b:	e8 00 e0 ff ff       	call   80104350 <wakeup>
      release(&tickslock);
80106350:	c7 04 24 40 61 11 80 	movl   $0x80116140,(%esp)
80106357:	e8 54 e9 ff ff       	call   80104cb0 <release>
8010635c:	83 c4 10             	add    $0x10,%esp
8010635f:	e9 09 ff ff ff       	jmp    8010626d <trap+0x19d>
80106364:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106367:	e8 84 d5 ff ff       	call   801038f0 <cpuid>
8010636c:	83 ec 0c             	sub    $0xc,%esp
8010636f:	56                   	push   %esi
80106370:	53                   	push   %ebx
80106371:	50                   	push   %eax
80106372:	ff 77 30             	pushl  0x30(%edi)
80106375:	68 54 81 10 80       	push   $0x80108154
8010637a:	e8 e1 a2 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010637f:	83 c4 14             	add    $0x14,%esp
80106382:	68 29 81 10 80       	push   $0x80108129
80106387:	e8 04 a0 ff ff       	call   80100390 <panic>
8010638c:	66 90                	xchg   %ax,%ax
8010638e:	66 90                	xchg   %ax,%ax

80106390 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106390:	a1 88 b6 10 80       	mov    0x8010b688,%eax
{
80106395:	55                   	push   %ebp
80106396:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106398:	85 c0                	test   %eax,%eax
8010639a:	74 1c                	je     801063b8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010639c:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063a1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801063a2:	a8 01                	test   $0x1,%al
801063a4:	74 12                	je     801063b8 <uartgetc+0x28>
801063a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063ab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801063ac:	0f b6 c0             	movzbl %al,%eax
}
801063af:	5d                   	pop    %ebp
801063b0:	c3                   	ret    
801063b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801063b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063bd:	5d                   	pop    %ebp
801063be:	c3                   	ret    
801063bf:	90                   	nop

801063c0 <uartputc.part.0>:
uartputc(int c)
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	57                   	push   %edi
801063c4:	56                   	push   %esi
801063c5:	53                   	push   %ebx
801063c6:	89 c7                	mov    %eax,%edi
801063c8:	bb 80 00 00 00       	mov    $0x80,%ebx
801063cd:	be fd 03 00 00       	mov    $0x3fd,%esi
801063d2:	83 ec 0c             	sub    $0xc,%esp
801063d5:	eb 1b                	jmp    801063f2 <uartputc.part.0+0x32>
801063d7:	89 f6                	mov    %esi,%esi
801063d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801063e0:	83 ec 0c             	sub    $0xc,%esp
801063e3:	6a 0a                	push   $0xa
801063e5:	e8 86 c3 ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063ea:	83 c4 10             	add    $0x10,%esp
801063ed:	83 eb 01             	sub    $0x1,%ebx
801063f0:	74 07                	je     801063f9 <uartputc.part.0+0x39>
801063f2:	89 f2                	mov    %esi,%edx
801063f4:	ec                   	in     (%dx),%al
801063f5:	a8 20                	test   $0x20,%al
801063f7:	74 e7                	je     801063e0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063f9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063fe:	89 f8                	mov    %edi,%eax
80106400:	ee                   	out    %al,(%dx)
}
80106401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106404:	5b                   	pop    %ebx
80106405:	5e                   	pop    %esi
80106406:	5f                   	pop    %edi
80106407:	5d                   	pop    %ebp
80106408:	c3                   	ret    
80106409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106410 <uartinit>:
{
80106410:	55                   	push   %ebp
80106411:	31 c9                	xor    %ecx,%ecx
80106413:	89 c8                	mov    %ecx,%eax
80106415:	89 e5                	mov    %esp,%ebp
80106417:	57                   	push   %edi
80106418:	56                   	push   %esi
80106419:	53                   	push   %ebx
8010641a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010641f:	89 da                	mov    %ebx,%edx
80106421:	83 ec 0c             	sub    $0xc,%esp
80106424:	ee                   	out    %al,(%dx)
80106425:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010642a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010642f:	89 fa                	mov    %edi,%edx
80106431:	ee                   	out    %al,(%dx)
80106432:	b8 0c 00 00 00       	mov    $0xc,%eax
80106437:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010643c:	ee                   	out    %al,(%dx)
8010643d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106442:	89 c8                	mov    %ecx,%eax
80106444:	89 f2                	mov    %esi,%edx
80106446:	ee                   	out    %al,(%dx)
80106447:	b8 03 00 00 00       	mov    $0x3,%eax
8010644c:	89 fa                	mov    %edi,%edx
8010644e:	ee                   	out    %al,(%dx)
8010644f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106454:	89 c8                	mov    %ecx,%eax
80106456:	ee                   	out    %al,(%dx)
80106457:	b8 01 00 00 00       	mov    $0x1,%eax
8010645c:	89 f2                	mov    %esi,%edx
8010645e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010645f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106464:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106465:	3c ff                	cmp    $0xff,%al
80106467:	74 5a                	je     801064c3 <uartinit+0xb3>
  uart = 1;
80106469:	c7 05 88 b6 10 80 01 	movl   $0x1,0x8010b688
80106470:	00 00 00 
80106473:	89 da                	mov    %ebx,%edx
80106475:	ec                   	in     (%dx),%al
80106476:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010647b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010647c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010647f:	bb 4c 82 10 80       	mov    $0x8010824c,%ebx
  ioapicenable(IRQ_COM1, 0);
80106484:	6a 00                	push   $0x0
80106486:	6a 04                	push   $0x4
80106488:	e8 43 be ff ff       	call   801022d0 <ioapicenable>
8010648d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106490:	b8 78 00 00 00       	mov    $0x78,%eax
80106495:	eb 13                	jmp    801064aa <uartinit+0x9a>
80106497:	89 f6                	mov    %esi,%esi
80106499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801064a0:	83 c3 01             	add    $0x1,%ebx
801064a3:	0f be 03             	movsbl (%ebx),%eax
801064a6:	84 c0                	test   %al,%al
801064a8:	74 19                	je     801064c3 <uartinit+0xb3>
  if(!uart)
801064aa:	8b 15 88 b6 10 80    	mov    0x8010b688,%edx
801064b0:	85 d2                	test   %edx,%edx
801064b2:	74 ec                	je     801064a0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801064b4:	83 c3 01             	add    $0x1,%ebx
801064b7:	e8 04 ff ff ff       	call   801063c0 <uartputc.part.0>
801064bc:	0f be 03             	movsbl (%ebx),%eax
801064bf:	84 c0                	test   %al,%al
801064c1:	75 e7                	jne    801064aa <uartinit+0x9a>
}
801064c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064c6:	5b                   	pop    %ebx
801064c7:	5e                   	pop    %esi
801064c8:	5f                   	pop    %edi
801064c9:	5d                   	pop    %ebp
801064ca:	c3                   	ret    
801064cb:	90                   	nop
801064cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801064d0 <uartputc>:
  if(!uart)
801064d0:	8b 15 88 b6 10 80    	mov    0x8010b688,%edx
{
801064d6:	55                   	push   %ebp
801064d7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801064d9:	85 d2                	test   %edx,%edx
{
801064db:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801064de:	74 10                	je     801064f0 <uartputc+0x20>
}
801064e0:	5d                   	pop    %ebp
801064e1:	e9 da fe ff ff       	jmp    801063c0 <uartputc.part.0>
801064e6:	8d 76 00             	lea    0x0(%esi),%esi
801064e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801064f0:	5d                   	pop    %ebp
801064f1:	c3                   	ret    
801064f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106500 <uartintr>:

void
uartintr(void)
{
80106500:	55                   	push   %ebp
80106501:	89 e5                	mov    %esp,%ebp
80106503:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106506:	68 90 63 10 80       	push   $0x80106390
8010650b:	e8 00 a3 ff ff       	call   80100810 <consoleintr>
}
80106510:	83 c4 10             	add    $0x10,%esp
80106513:	c9                   	leave  
80106514:	c3                   	ret    

80106515 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $0
80106517:	6a 00                	push   $0x0
  jmp alltraps
80106519:	e9 d7 fa ff ff       	jmp    80105ff5 <alltraps>

8010651e <vector1>:
.globl vector1
vector1:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $1
80106520:	6a 01                	push   $0x1
  jmp alltraps
80106522:	e9 ce fa ff ff       	jmp    80105ff5 <alltraps>

80106527 <vector2>:
.globl vector2
vector2:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $2
80106529:	6a 02                	push   $0x2
  jmp alltraps
8010652b:	e9 c5 fa ff ff       	jmp    80105ff5 <alltraps>

80106530 <vector3>:
.globl vector3
vector3:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $3
80106532:	6a 03                	push   $0x3
  jmp alltraps
80106534:	e9 bc fa ff ff       	jmp    80105ff5 <alltraps>

80106539 <vector4>:
.globl vector4
vector4:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $4
8010653b:	6a 04                	push   $0x4
  jmp alltraps
8010653d:	e9 b3 fa ff ff       	jmp    80105ff5 <alltraps>

80106542 <vector5>:
.globl vector5
vector5:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $5
80106544:	6a 05                	push   $0x5
  jmp alltraps
80106546:	e9 aa fa ff ff       	jmp    80105ff5 <alltraps>

8010654b <vector6>:
.globl vector6
vector6:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $6
8010654d:	6a 06                	push   $0x6
  jmp alltraps
8010654f:	e9 a1 fa ff ff       	jmp    80105ff5 <alltraps>

80106554 <vector7>:
.globl vector7
vector7:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $7
80106556:	6a 07                	push   $0x7
  jmp alltraps
80106558:	e9 98 fa ff ff       	jmp    80105ff5 <alltraps>

8010655d <vector8>:
.globl vector8
vector8:
  pushl $8
8010655d:	6a 08                	push   $0x8
  jmp alltraps
8010655f:	e9 91 fa ff ff       	jmp    80105ff5 <alltraps>

80106564 <vector9>:
.globl vector9
vector9:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $9
80106566:	6a 09                	push   $0x9
  jmp alltraps
80106568:	e9 88 fa ff ff       	jmp    80105ff5 <alltraps>

8010656d <vector10>:
.globl vector10
vector10:
  pushl $10
8010656d:	6a 0a                	push   $0xa
  jmp alltraps
8010656f:	e9 81 fa ff ff       	jmp    80105ff5 <alltraps>

80106574 <vector11>:
.globl vector11
vector11:
  pushl $11
80106574:	6a 0b                	push   $0xb
  jmp alltraps
80106576:	e9 7a fa ff ff       	jmp    80105ff5 <alltraps>

8010657b <vector12>:
.globl vector12
vector12:
  pushl $12
8010657b:	6a 0c                	push   $0xc
  jmp alltraps
8010657d:	e9 73 fa ff ff       	jmp    80105ff5 <alltraps>

80106582 <vector13>:
.globl vector13
vector13:
  pushl $13
80106582:	6a 0d                	push   $0xd
  jmp alltraps
80106584:	e9 6c fa ff ff       	jmp    80105ff5 <alltraps>

80106589 <vector14>:
.globl vector14
vector14:
  pushl $14
80106589:	6a 0e                	push   $0xe
  jmp alltraps
8010658b:	e9 65 fa ff ff       	jmp    80105ff5 <alltraps>

80106590 <vector15>:
.globl vector15
vector15:
  pushl $0
80106590:	6a 00                	push   $0x0
  pushl $15
80106592:	6a 0f                	push   $0xf
  jmp alltraps
80106594:	e9 5c fa ff ff       	jmp    80105ff5 <alltraps>

80106599 <vector16>:
.globl vector16
vector16:
  pushl $0
80106599:	6a 00                	push   $0x0
  pushl $16
8010659b:	6a 10                	push   $0x10
  jmp alltraps
8010659d:	e9 53 fa ff ff       	jmp    80105ff5 <alltraps>

801065a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801065a2:	6a 11                	push   $0x11
  jmp alltraps
801065a4:	e9 4c fa ff ff       	jmp    80105ff5 <alltraps>

801065a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801065a9:	6a 00                	push   $0x0
  pushl $18
801065ab:	6a 12                	push   $0x12
  jmp alltraps
801065ad:	e9 43 fa ff ff       	jmp    80105ff5 <alltraps>

801065b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $19
801065b4:	6a 13                	push   $0x13
  jmp alltraps
801065b6:	e9 3a fa ff ff       	jmp    80105ff5 <alltraps>

801065bb <vector20>:
.globl vector20
vector20:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $20
801065bd:	6a 14                	push   $0x14
  jmp alltraps
801065bf:	e9 31 fa ff ff       	jmp    80105ff5 <alltraps>

801065c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801065c4:	6a 00                	push   $0x0
  pushl $21
801065c6:	6a 15                	push   $0x15
  jmp alltraps
801065c8:	e9 28 fa ff ff       	jmp    80105ff5 <alltraps>

801065cd <vector22>:
.globl vector22
vector22:
  pushl $0
801065cd:	6a 00                	push   $0x0
  pushl $22
801065cf:	6a 16                	push   $0x16
  jmp alltraps
801065d1:	e9 1f fa ff ff       	jmp    80105ff5 <alltraps>

801065d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $23
801065d8:	6a 17                	push   $0x17
  jmp alltraps
801065da:	e9 16 fa ff ff       	jmp    80105ff5 <alltraps>

801065df <vector24>:
.globl vector24
vector24:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $24
801065e1:	6a 18                	push   $0x18
  jmp alltraps
801065e3:	e9 0d fa ff ff       	jmp    80105ff5 <alltraps>

801065e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801065e8:	6a 00                	push   $0x0
  pushl $25
801065ea:	6a 19                	push   $0x19
  jmp alltraps
801065ec:	e9 04 fa ff ff       	jmp    80105ff5 <alltraps>

801065f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801065f1:	6a 00                	push   $0x0
  pushl $26
801065f3:	6a 1a                	push   $0x1a
  jmp alltraps
801065f5:	e9 fb f9 ff ff       	jmp    80105ff5 <alltraps>

801065fa <vector27>:
.globl vector27
vector27:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $27
801065fc:	6a 1b                	push   $0x1b
  jmp alltraps
801065fe:	e9 f2 f9 ff ff       	jmp    80105ff5 <alltraps>

80106603 <vector28>:
.globl vector28
vector28:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $28
80106605:	6a 1c                	push   $0x1c
  jmp alltraps
80106607:	e9 e9 f9 ff ff       	jmp    80105ff5 <alltraps>

8010660c <vector29>:
.globl vector29
vector29:
  pushl $0
8010660c:	6a 00                	push   $0x0
  pushl $29
8010660e:	6a 1d                	push   $0x1d
  jmp alltraps
80106610:	e9 e0 f9 ff ff       	jmp    80105ff5 <alltraps>

80106615 <vector30>:
.globl vector30
vector30:
  pushl $0
80106615:	6a 00                	push   $0x0
  pushl $30
80106617:	6a 1e                	push   $0x1e
  jmp alltraps
80106619:	e9 d7 f9 ff ff       	jmp    80105ff5 <alltraps>

8010661e <vector31>:
.globl vector31
vector31:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $31
80106620:	6a 1f                	push   $0x1f
  jmp alltraps
80106622:	e9 ce f9 ff ff       	jmp    80105ff5 <alltraps>

80106627 <vector32>:
.globl vector32
vector32:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $32
80106629:	6a 20                	push   $0x20
  jmp alltraps
8010662b:	e9 c5 f9 ff ff       	jmp    80105ff5 <alltraps>

80106630 <vector33>:
.globl vector33
vector33:
  pushl $0
80106630:	6a 00                	push   $0x0
  pushl $33
80106632:	6a 21                	push   $0x21
  jmp alltraps
80106634:	e9 bc f9 ff ff       	jmp    80105ff5 <alltraps>

80106639 <vector34>:
.globl vector34
vector34:
  pushl $0
80106639:	6a 00                	push   $0x0
  pushl $34
8010663b:	6a 22                	push   $0x22
  jmp alltraps
8010663d:	e9 b3 f9 ff ff       	jmp    80105ff5 <alltraps>

80106642 <vector35>:
.globl vector35
vector35:
  pushl $0
80106642:	6a 00                	push   $0x0
  pushl $35
80106644:	6a 23                	push   $0x23
  jmp alltraps
80106646:	e9 aa f9 ff ff       	jmp    80105ff5 <alltraps>

8010664b <vector36>:
.globl vector36
vector36:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $36
8010664d:	6a 24                	push   $0x24
  jmp alltraps
8010664f:	e9 a1 f9 ff ff       	jmp    80105ff5 <alltraps>

80106654 <vector37>:
.globl vector37
vector37:
  pushl $0
80106654:	6a 00                	push   $0x0
  pushl $37
80106656:	6a 25                	push   $0x25
  jmp alltraps
80106658:	e9 98 f9 ff ff       	jmp    80105ff5 <alltraps>

8010665d <vector38>:
.globl vector38
vector38:
  pushl $0
8010665d:	6a 00                	push   $0x0
  pushl $38
8010665f:	6a 26                	push   $0x26
  jmp alltraps
80106661:	e9 8f f9 ff ff       	jmp    80105ff5 <alltraps>

80106666 <vector39>:
.globl vector39
vector39:
  pushl $0
80106666:	6a 00                	push   $0x0
  pushl $39
80106668:	6a 27                	push   $0x27
  jmp alltraps
8010666a:	e9 86 f9 ff ff       	jmp    80105ff5 <alltraps>

8010666f <vector40>:
.globl vector40
vector40:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $40
80106671:	6a 28                	push   $0x28
  jmp alltraps
80106673:	e9 7d f9 ff ff       	jmp    80105ff5 <alltraps>

80106678 <vector41>:
.globl vector41
vector41:
  pushl $0
80106678:	6a 00                	push   $0x0
  pushl $41
8010667a:	6a 29                	push   $0x29
  jmp alltraps
8010667c:	e9 74 f9 ff ff       	jmp    80105ff5 <alltraps>

80106681 <vector42>:
.globl vector42
vector42:
  pushl $0
80106681:	6a 00                	push   $0x0
  pushl $42
80106683:	6a 2a                	push   $0x2a
  jmp alltraps
80106685:	e9 6b f9 ff ff       	jmp    80105ff5 <alltraps>

8010668a <vector43>:
.globl vector43
vector43:
  pushl $0
8010668a:	6a 00                	push   $0x0
  pushl $43
8010668c:	6a 2b                	push   $0x2b
  jmp alltraps
8010668e:	e9 62 f9 ff ff       	jmp    80105ff5 <alltraps>

80106693 <vector44>:
.globl vector44
vector44:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $44
80106695:	6a 2c                	push   $0x2c
  jmp alltraps
80106697:	e9 59 f9 ff ff       	jmp    80105ff5 <alltraps>

8010669c <vector45>:
.globl vector45
vector45:
  pushl $0
8010669c:	6a 00                	push   $0x0
  pushl $45
8010669e:	6a 2d                	push   $0x2d
  jmp alltraps
801066a0:	e9 50 f9 ff ff       	jmp    80105ff5 <alltraps>

801066a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801066a5:	6a 00                	push   $0x0
  pushl $46
801066a7:	6a 2e                	push   $0x2e
  jmp alltraps
801066a9:	e9 47 f9 ff ff       	jmp    80105ff5 <alltraps>

801066ae <vector47>:
.globl vector47
vector47:
  pushl $0
801066ae:	6a 00                	push   $0x0
  pushl $47
801066b0:	6a 2f                	push   $0x2f
  jmp alltraps
801066b2:	e9 3e f9 ff ff       	jmp    80105ff5 <alltraps>

801066b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $48
801066b9:	6a 30                	push   $0x30
  jmp alltraps
801066bb:	e9 35 f9 ff ff       	jmp    80105ff5 <alltraps>

801066c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801066c0:	6a 00                	push   $0x0
  pushl $49
801066c2:	6a 31                	push   $0x31
  jmp alltraps
801066c4:	e9 2c f9 ff ff       	jmp    80105ff5 <alltraps>

801066c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801066c9:	6a 00                	push   $0x0
  pushl $50
801066cb:	6a 32                	push   $0x32
  jmp alltraps
801066cd:	e9 23 f9 ff ff       	jmp    80105ff5 <alltraps>

801066d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801066d2:	6a 00                	push   $0x0
  pushl $51
801066d4:	6a 33                	push   $0x33
  jmp alltraps
801066d6:	e9 1a f9 ff ff       	jmp    80105ff5 <alltraps>

801066db <vector52>:
.globl vector52
vector52:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $52
801066dd:	6a 34                	push   $0x34
  jmp alltraps
801066df:	e9 11 f9 ff ff       	jmp    80105ff5 <alltraps>

801066e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801066e4:	6a 00                	push   $0x0
  pushl $53
801066e6:	6a 35                	push   $0x35
  jmp alltraps
801066e8:	e9 08 f9 ff ff       	jmp    80105ff5 <alltraps>

801066ed <vector54>:
.globl vector54
vector54:
  pushl $0
801066ed:	6a 00                	push   $0x0
  pushl $54
801066ef:	6a 36                	push   $0x36
  jmp alltraps
801066f1:	e9 ff f8 ff ff       	jmp    80105ff5 <alltraps>

801066f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801066f6:	6a 00                	push   $0x0
  pushl $55
801066f8:	6a 37                	push   $0x37
  jmp alltraps
801066fa:	e9 f6 f8 ff ff       	jmp    80105ff5 <alltraps>

801066ff <vector56>:
.globl vector56
vector56:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $56
80106701:	6a 38                	push   $0x38
  jmp alltraps
80106703:	e9 ed f8 ff ff       	jmp    80105ff5 <alltraps>

80106708 <vector57>:
.globl vector57
vector57:
  pushl $0
80106708:	6a 00                	push   $0x0
  pushl $57
8010670a:	6a 39                	push   $0x39
  jmp alltraps
8010670c:	e9 e4 f8 ff ff       	jmp    80105ff5 <alltraps>

80106711 <vector58>:
.globl vector58
vector58:
  pushl $0
80106711:	6a 00                	push   $0x0
  pushl $58
80106713:	6a 3a                	push   $0x3a
  jmp alltraps
80106715:	e9 db f8 ff ff       	jmp    80105ff5 <alltraps>

8010671a <vector59>:
.globl vector59
vector59:
  pushl $0
8010671a:	6a 00                	push   $0x0
  pushl $59
8010671c:	6a 3b                	push   $0x3b
  jmp alltraps
8010671e:	e9 d2 f8 ff ff       	jmp    80105ff5 <alltraps>

80106723 <vector60>:
.globl vector60
vector60:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $60
80106725:	6a 3c                	push   $0x3c
  jmp alltraps
80106727:	e9 c9 f8 ff ff       	jmp    80105ff5 <alltraps>

8010672c <vector61>:
.globl vector61
vector61:
  pushl $0
8010672c:	6a 00                	push   $0x0
  pushl $61
8010672e:	6a 3d                	push   $0x3d
  jmp alltraps
80106730:	e9 c0 f8 ff ff       	jmp    80105ff5 <alltraps>

80106735 <vector62>:
.globl vector62
vector62:
  pushl $0
80106735:	6a 00                	push   $0x0
  pushl $62
80106737:	6a 3e                	push   $0x3e
  jmp alltraps
80106739:	e9 b7 f8 ff ff       	jmp    80105ff5 <alltraps>

8010673e <vector63>:
.globl vector63
vector63:
  pushl $0
8010673e:	6a 00                	push   $0x0
  pushl $63
80106740:	6a 3f                	push   $0x3f
  jmp alltraps
80106742:	e9 ae f8 ff ff       	jmp    80105ff5 <alltraps>

80106747 <vector64>:
.globl vector64
vector64:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $64
80106749:	6a 40                	push   $0x40
  jmp alltraps
8010674b:	e9 a5 f8 ff ff       	jmp    80105ff5 <alltraps>

80106750 <vector65>:
.globl vector65
vector65:
  pushl $0
80106750:	6a 00                	push   $0x0
  pushl $65
80106752:	6a 41                	push   $0x41
  jmp alltraps
80106754:	e9 9c f8 ff ff       	jmp    80105ff5 <alltraps>

80106759 <vector66>:
.globl vector66
vector66:
  pushl $0
80106759:	6a 00                	push   $0x0
  pushl $66
8010675b:	6a 42                	push   $0x42
  jmp alltraps
8010675d:	e9 93 f8 ff ff       	jmp    80105ff5 <alltraps>

80106762 <vector67>:
.globl vector67
vector67:
  pushl $0
80106762:	6a 00                	push   $0x0
  pushl $67
80106764:	6a 43                	push   $0x43
  jmp alltraps
80106766:	e9 8a f8 ff ff       	jmp    80105ff5 <alltraps>

8010676b <vector68>:
.globl vector68
vector68:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $68
8010676d:	6a 44                	push   $0x44
  jmp alltraps
8010676f:	e9 81 f8 ff ff       	jmp    80105ff5 <alltraps>

80106774 <vector69>:
.globl vector69
vector69:
  pushl $0
80106774:	6a 00                	push   $0x0
  pushl $69
80106776:	6a 45                	push   $0x45
  jmp alltraps
80106778:	e9 78 f8 ff ff       	jmp    80105ff5 <alltraps>

8010677d <vector70>:
.globl vector70
vector70:
  pushl $0
8010677d:	6a 00                	push   $0x0
  pushl $70
8010677f:	6a 46                	push   $0x46
  jmp alltraps
80106781:	e9 6f f8 ff ff       	jmp    80105ff5 <alltraps>

80106786 <vector71>:
.globl vector71
vector71:
  pushl $0
80106786:	6a 00                	push   $0x0
  pushl $71
80106788:	6a 47                	push   $0x47
  jmp alltraps
8010678a:	e9 66 f8 ff ff       	jmp    80105ff5 <alltraps>

8010678f <vector72>:
.globl vector72
vector72:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $72
80106791:	6a 48                	push   $0x48
  jmp alltraps
80106793:	e9 5d f8 ff ff       	jmp    80105ff5 <alltraps>

80106798 <vector73>:
.globl vector73
vector73:
  pushl $0
80106798:	6a 00                	push   $0x0
  pushl $73
8010679a:	6a 49                	push   $0x49
  jmp alltraps
8010679c:	e9 54 f8 ff ff       	jmp    80105ff5 <alltraps>

801067a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801067a1:	6a 00                	push   $0x0
  pushl $74
801067a3:	6a 4a                	push   $0x4a
  jmp alltraps
801067a5:	e9 4b f8 ff ff       	jmp    80105ff5 <alltraps>

801067aa <vector75>:
.globl vector75
vector75:
  pushl $0
801067aa:	6a 00                	push   $0x0
  pushl $75
801067ac:	6a 4b                	push   $0x4b
  jmp alltraps
801067ae:	e9 42 f8 ff ff       	jmp    80105ff5 <alltraps>

801067b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $76
801067b5:	6a 4c                	push   $0x4c
  jmp alltraps
801067b7:	e9 39 f8 ff ff       	jmp    80105ff5 <alltraps>

801067bc <vector77>:
.globl vector77
vector77:
  pushl $0
801067bc:	6a 00                	push   $0x0
  pushl $77
801067be:	6a 4d                	push   $0x4d
  jmp alltraps
801067c0:	e9 30 f8 ff ff       	jmp    80105ff5 <alltraps>

801067c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801067c5:	6a 00                	push   $0x0
  pushl $78
801067c7:	6a 4e                	push   $0x4e
  jmp alltraps
801067c9:	e9 27 f8 ff ff       	jmp    80105ff5 <alltraps>

801067ce <vector79>:
.globl vector79
vector79:
  pushl $0
801067ce:	6a 00                	push   $0x0
  pushl $79
801067d0:	6a 4f                	push   $0x4f
  jmp alltraps
801067d2:	e9 1e f8 ff ff       	jmp    80105ff5 <alltraps>

801067d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $80
801067d9:	6a 50                	push   $0x50
  jmp alltraps
801067db:	e9 15 f8 ff ff       	jmp    80105ff5 <alltraps>

801067e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801067e0:	6a 00                	push   $0x0
  pushl $81
801067e2:	6a 51                	push   $0x51
  jmp alltraps
801067e4:	e9 0c f8 ff ff       	jmp    80105ff5 <alltraps>

801067e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801067e9:	6a 00                	push   $0x0
  pushl $82
801067eb:	6a 52                	push   $0x52
  jmp alltraps
801067ed:	e9 03 f8 ff ff       	jmp    80105ff5 <alltraps>

801067f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801067f2:	6a 00                	push   $0x0
  pushl $83
801067f4:	6a 53                	push   $0x53
  jmp alltraps
801067f6:	e9 fa f7 ff ff       	jmp    80105ff5 <alltraps>

801067fb <vector84>:
.globl vector84
vector84:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $84
801067fd:	6a 54                	push   $0x54
  jmp alltraps
801067ff:	e9 f1 f7 ff ff       	jmp    80105ff5 <alltraps>

80106804 <vector85>:
.globl vector85
vector85:
  pushl $0
80106804:	6a 00                	push   $0x0
  pushl $85
80106806:	6a 55                	push   $0x55
  jmp alltraps
80106808:	e9 e8 f7 ff ff       	jmp    80105ff5 <alltraps>

8010680d <vector86>:
.globl vector86
vector86:
  pushl $0
8010680d:	6a 00                	push   $0x0
  pushl $86
8010680f:	6a 56                	push   $0x56
  jmp alltraps
80106811:	e9 df f7 ff ff       	jmp    80105ff5 <alltraps>

80106816 <vector87>:
.globl vector87
vector87:
  pushl $0
80106816:	6a 00                	push   $0x0
  pushl $87
80106818:	6a 57                	push   $0x57
  jmp alltraps
8010681a:	e9 d6 f7 ff ff       	jmp    80105ff5 <alltraps>

8010681f <vector88>:
.globl vector88
vector88:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $88
80106821:	6a 58                	push   $0x58
  jmp alltraps
80106823:	e9 cd f7 ff ff       	jmp    80105ff5 <alltraps>

80106828 <vector89>:
.globl vector89
vector89:
  pushl $0
80106828:	6a 00                	push   $0x0
  pushl $89
8010682a:	6a 59                	push   $0x59
  jmp alltraps
8010682c:	e9 c4 f7 ff ff       	jmp    80105ff5 <alltraps>

80106831 <vector90>:
.globl vector90
vector90:
  pushl $0
80106831:	6a 00                	push   $0x0
  pushl $90
80106833:	6a 5a                	push   $0x5a
  jmp alltraps
80106835:	e9 bb f7 ff ff       	jmp    80105ff5 <alltraps>

8010683a <vector91>:
.globl vector91
vector91:
  pushl $0
8010683a:	6a 00                	push   $0x0
  pushl $91
8010683c:	6a 5b                	push   $0x5b
  jmp alltraps
8010683e:	e9 b2 f7 ff ff       	jmp    80105ff5 <alltraps>

80106843 <vector92>:
.globl vector92
vector92:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $92
80106845:	6a 5c                	push   $0x5c
  jmp alltraps
80106847:	e9 a9 f7 ff ff       	jmp    80105ff5 <alltraps>

8010684c <vector93>:
.globl vector93
vector93:
  pushl $0
8010684c:	6a 00                	push   $0x0
  pushl $93
8010684e:	6a 5d                	push   $0x5d
  jmp alltraps
80106850:	e9 a0 f7 ff ff       	jmp    80105ff5 <alltraps>

80106855 <vector94>:
.globl vector94
vector94:
  pushl $0
80106855:	6a 00                	push   $0x0
  pushl $94
80106857:	6a 5e                	push   $0x5e
  jmp alltraps
80106859:	e9 97 f7 ff ff       	jmp    80105ff5 <alltraps>

8010685e <vector95>:
.globl vector95
vector95:
  pushl $0
8010685e:	6a 00                	push   $0x0
  pushl $95
80106860:	6a 5f                	push   $0x5f
  jmp alltraps
80106862:	e9 8e f7 ff ff       	jmp    80105ff5 <alltraps>

80106867 <vector96>:
.globl vector96
vector96:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $96
80106869:	6a 60                	push   $0x60
  jmp alltraps
8010686b:	e9 85 f7 ff ff       	jmp    80105ff5 <alltraps>

80106870 <vector97>:
.globl vector97
vector97:
  pushl $0
80106870:	6a 00                	push   $0x0
  pushl $97
80106872:	6a 61                	push   $0x61
  jmp alltraps
80106874:	e9 7c f7 ff ff       	jmp    80105ff5 <alltraps>

80106879 <vector98>:
.globl vector98
vector98:
  pushl $0
80106879:	6a 00                	push   $0x0
  pushl $98
8010687b:	6a 62                	push   $0x62
  jmp alltraps
8010687d:	e9 73 f7 ff ff       	jmp    80105ff5 <alltraps>

80106882 <vector99>:
.globl vector99
vector99:
  pushl $0
80106882:	6a 00                	push   $0x0
  pushl $99
80106884:	6a 63                	push   $0x63
  jmp alltraps
80106886:	e9 6a f7 ff ff       	jmp    80105ff5 <alltraps>

8010688b <vector100>:
.globl vector100
vector100:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $100
8010688d:	6a 64                	push   $0x64
  jmp alltraps
8010688f:	e9 61 f7 ff ff       	jmp    80105ff5 <alltraps>

80106894 <vector101>:
.globl vector101
vector101:
  pushl $0
80106894:	6a 00                	push   $0x0
  pushl $101
80106896:	6a 65                	push   $0x65
  jmp alltraps
80106898:	e9 58 f7 ff ff       	jmp    80105ff5 <alltraps>

8010689d <vector102>:
.globl vector102
vector102:
  pushl $0
8010689d:	6a 00                	push   $0x0
  pushl $102
8010689f:	6a 66                	push   $0x66
  jmp alltraps
801068a1:	e9 4f f7 ff ff       	jmp    80105ff5 <alltraps>

801068a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801068a6:	6a 00                	push   $0x0
  pushl $103
801068a8:	6a 67                	push   $0x67
  jmp alltraps
801068aa:	e9 46 f7 ff ff       	jmp    80105ff5 <alltraps>

801068af <vector104>:
.globl vector104
vector104:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $104
801068b1:	6a 68                	push   $0x68
  jmp alltraps
801068b3:	e9 3d f7 ff ff       	jmp    80105ff5 <alltraps>

801068b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801068b8:	6a 00                	push   $0x0
  pushl $105
801068ba:	6a 69                	push   $0x69
  jmp alltraps
801068bc:	e9 34 f7 ff ff       	jmp    80105ff5 <alltraps>

801068c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801068c1:	6a 00                	push   $0x0
  pushl $106
801068c3:	6a 6a                	push   $0x6a
  jmp alltraps
801068c5:	e9 2b f7 ff ff       	jmp    80105ff5 <alltraps>

801068ca <vector107>:
.globl vector107
vector107:
  pushl $0
801068ca:	6a 00                	push   $0x0
  pushl $107
801068cc:	6a 6b                	push   $0x6b
  jmp alltraps
801068ce:	e9 22 f7 ff ff       	jmp    80105ff5 <alltraps>

801068d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $108
801068d5:	6a 6c                	push   $0x6c
  jmp alltraps
801068d7:	e9 19 f7 ff ff       	jmp    80105ff5 <alltraps>

801068dc <vector109>:
.globl vector109
vector109:
  pushl $0
801068dc:	6a 00                	push   $0x0
  pushl $109
801068de:	6a 6d                	push   $0x6d
  jmp alltraps
801068e0:	e9 10 f7 ff ff       	jmp    80105ff5 <alltraps>

801068e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801068e5:	6a 00                	push   $0x0
  pushl $110
801068e7:	6a 6e                	push   $0x6e
  jmp alltraps
801068e9:	e9 07 f7 ff ff       	jmp    80105ff5 <alltraps>

801068ee <vector111>:
.globl vector111
vector111:
  pushl $0
801068ee:	6a 00                	push   $0x0
  pushl $111
801068f0:	6a 6f                	push   $0x6f
  jmp alltraps
801068f2:	e9 fe f6 ff ff       	jmp    80105ff5 <alltraps>

801068f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $112
801068f9:	6a 70                	push   $0x70
  jmp alltraps
801068fb:	e9 f5 f6 ff ff       	jmp    80105ff5 <alltraps>

80106900 <vector113>:
.globl vector113
vector113:
  pushl $0
80106900:	6a 00                	push   $0x0
  pushl $113
80106902:	6a 71                	push   $0x71
  jmp alltraps
80106904:	e9 ec f6 ff ff       	jmp    80105ff5 <alltraps>

80106909 <vector114>:
.globl vector114
vector114:
  pushl $0
80106909:	6a 00                	push   $0x0
  pushl $114
8010690b:	6a 72                	push   $0x72
  jmp alltraps
8010690d:	e9 e3 f6 ff ff       	jmp    80105ff5 <alltraps>

80106912 <vector115>:
.globl vector115
vector115:
  pushl $0
80106912:	6a 00                	push   $0x0
  pushl $115
80106914:	6a 73                	push   $0x73
  jmp alltraps
80106916:	e9 da f6 ff ff       	jmp    80105ff5 <alltraps>

8010691b <vector116>:
.globl vector116
vector116:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $116
8010691d:	6a 74                	push   $0x74
  jmp alltraps
8010691f:	e9 d1 f6 ff ff       	jmp    80105ff5 <alltraps>

80106924 <vector117>:
.globl vector117
vector117:
  pushl $0
80106924:	6a 00                	push   $0x0
  pushl $117
80106926:	6a 75                	push   $0x75
  jmp alltraps
80106928:	e9 c8 f6 ff ff       	jmp    80105ff5 <alltraps>

8010692d <vector118>:
.globl vector118
vector118:
  pushl $0
8010692d:	6a 00                	push   $0x0
  pushl $118
8010692f:	6a 76                	push   $0x76
  jmp alltraps
80106931:	e9 bf f6 ff ff       	jmp    80105ff5 <alltraps>

80106936 <vector119>:
.globl vector119
vector119:
  pushl $0
80106936:	6a 00                	push   $0x0
  pushl $119
80106938:	6a 77                	push   $0x77
  jmp alltraps
8010693a:	e9 b6 f6 ff ff       	jmp    80105ff5 <alltraps>

8010693f <vector120>:
.globl vector120
vector120:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $120
80106941:	6a 78                	push   $0x78
  jmp alltraps
80106943:	e9 ad f6 ff ff       	jmp    80105ff5 <alltraps>

80106948 <vector121>:
.globl vector121
vector121:
  pushl $0
80106948:	6a 00                	push   $0x0
  pushl $121
8010694a:	6a 79                	push   $0x79
  jmp alltraps
8010694c:	e9 a4 f6 ff ff       	jmp    80105ff5 <alltraps>

80106951 <vector122>:
.globl vector122
vector122:
  pushl $0
80106951:	6a 00                	push   $0x0
  pushl $122
80106953:	6a 7a                	push   $0x7a
  jmp alltraps
80106955:	e9 9b f6 ff ff       	jmp    80105ff5 <alltraps>

8010695a <vector123>:
.globl vector123
vector123:
  pushl $0
8010695a:	6a 00                	push   $0x0
  pushl $123
8010695c:	6a 7b                	push   $0x7b
  jmp alltraps
8010695e:	e9 92 f6 ff ff       	jmp    80105ff5 <alltraps>

80106963 <vector124>:
.globl vector124
vector124:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $124
80106965:	6a 7c                	push   $0x7c
  jmp alltraps
80106967:	e9 89 f6 ff ff       	jmp    80105ff5 <alltraps>

8010696c <vector125>:
.globl vector125
vector125:
  pushl $0
8010696c:	6a 00                	push   $0x0
  pushl $125
8010696e:	6a 7d                	push   $0x7d
  jmp alltraps
80106970:	e9 80 f6 ff ff       	jmp    80105ff5 <alltraps>

80106975 <vector126>:
.globl vector126
vector126:
  pushl $0
80106975:	6a 00                	push   $0x0
  pushl $126
80106977:	6a 7e                	push   $0x7e
  jmp alltraps
80106979:	e9 77 f6 ff ff       	jmp    80105ff5 <alltraps>

8010697e <vector127>:
.globl vector127
vector127:
  pushl $0
8010697e:	6a 00                	push   $0x0
  pushl $127
80106980:	6a 7f                	push   $0x7f
  jmp alltraps
80106982:	e9 6e f6 ff ff       	jmp    80105ff5 <alltraps>

80106987 <vector128>:
.globl vector128
vector128:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $128
80106989:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010698e:	e9 62 f6 ff ff       	jmp    80105ff5 <alltraps>

80106993 <vector129>:
.globl vector129
vector129:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $129
80106995:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010699a:	e9 56 f6 ff ff       	jmp    80105ff5 <alltraps>

8010699f <vector130>:
.globl vector130
vector130:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $130
801069a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801069a6:	e9 4a f6 ff ff       	jmp    80105ff5 <alltraps>

801069ab <vector131>:
.globl vector131
vector131:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $131
801069ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801069b2:	e9 3e f6 ff ff       	jmp    80105ff5 <alltraps>

801069b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $132
801069b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801069be:	e9 32 f6 ff ff       	jmp    80105ff5 <alltraps>

801069c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $133
801069c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801069ca:	e9 26 f6 ff ff       	jmp    80105ff5 <alltraps>

801069cf <vector134>:
.globl vector134
vector134:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $134
801069d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801069d6:	e9 1a f6 ff ff       	jmp    80105ff5 <alltraps>

801069db <vector135>:
.globl vector135
vector135:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $135
801069dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801069e2:	e9 0e f6 ff ff       	jmp    80105ff5 <alltraps>

801069e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $136
801069e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801069ee:	e9 02 f6 ff ff       	jmp    80105ff5 <alltraps>

801069f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $137
801069f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801069fa:	e9 f6 f5 ff ff       	jmp    80105ff5 <alltraps>

801069ff <vector138>:
.globl vector138
vector138:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $138
80106a01:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a06:	e9 ea f5 ff ff       	jmp    80105ff5 <alltraps>

80106a0b <vector139>:
.globl vector139
vector139:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $139
80106a0d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a12:	e9 de f5 ff ff       	jmp    80105ff5 <alltraps>

80106a17 <vector140>:
.globl vector140
vector140:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $140
80106a19:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a1e:	e9 d2 f5 ff ff       	jmp    80105ff5 <alltraps>

80106a23 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $141
80106a25:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a2a:	e9 c6 f5 ff ff       	jmp    80105ff5 <alltraps>

80106a2f <vector142>:
.globl vector142
vector142:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $142
80106a31:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106a36:	e9 ba f5 ff ff       	jmp    80105ff5 <alltraps>

80106a3b <vector143>:
.globl vector143
vector143:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $143
80106a3d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106a42:	e9 ae f5 ff ff       	jmp    80105ff5 <alltraps>

80106a47 <vector144>:
.globl vector144
vector144:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $144
80106a49:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106a4e:	e9 a2 f5 ff ff       	jmp    80105ff5 <alltraps>

80106a53 <vector145>:
.globl vector145
vector145:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $145
80106a55:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106a5a:	e9 96 f5 ff ff       	jmp    80105ff5 <alltraps>

80106a5f <vector146>:
.globl vector146
vector146:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $146
80106a61:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106a66:	e9 8a f5 ff ff       	jmp    80105ff5 <alltraps>

80106a6b <vector147>:
.globl vector147
vector147:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $147
80106a6d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106a72:	e9 7e f5 ff ff       	jmp    80105ff5 <alltraps>

80106a77 <vector148>:
.globl vector148
vector148:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $148
80106a79:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106a7e:	e9 72 f5 ff ff       	jmp    80105ff5 <alltraps>

80106a83 <vector149>:
.globl vector149
vector149:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $149
80106a85:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106a8a:	e9 66 f5 ff ff       	jmp    80105ff5 <alltraps>

80106a8f <vector150>:
.globl vector150
vector150:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $150
80106a91:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106a96:	e9 5a f5 ff ff       	jmp    80105ff5 <alltraps>

80106a9b <vector151>:
.globl vector151
vector151:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $151
80106a9d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106aa2:	e9 4e f5 ff ff       	jmp    80105ff5 <alltraps>

80106aa7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $152
80106aa9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106aae:	e9 42 f5 ff ff       	jmp    80105ff5 <alltraps>

80106ab3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $153
80106ab5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106aba:	e9 36 f5 ff ff       	jmp    80105ff5 <alltraps>

80106abf <vector154>:
.globl vector154
vector154:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $154
80106ac1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ac6:	e9 2a f5 ff ff       	jmp    80105ff5 <alltraps>

80106acb <vector155>:
.globl vector155
vector155:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $155
80106acd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ad2:	e9 1e f5 ff ff       	jmp    80105ff5 <alltraps>

80106ad7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $156
80106ad9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106ade:	e9 12 f5 ff ff       	jmp    80105ff5 <alltraps>

80106ae3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $157
80106ae5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106aea:	e9 06 f5 ff ff       	jmp    80105ff5 <alltraps>

80106aef <vector158>:
.globl vector158
vector158:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $158
80106af1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106af6:	e9 fa f4 ff ff       	jmp    80105ff5 <alltraps>

80106afb <vector159>:
.globl vector159
vector159:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $159
80106afd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b02:	e9 ee f4 ff ff       	jmp    80105ff5 <alltraps>

80106b07 <vector160>:
.globl vector160
vector160:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $160
80106b09:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106b0e:	e9 e2 f4 ff ff       	jmp    80105ff5 <alltraps>

80106b13 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $161
80106b15:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b1a:	e9 d6 f4 ff ff       	jmp    80105ff5 <alltraps>

80106b1f <vector162>:
.globl vector162
vector162:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $162
80106b21:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b26:	e9 ca f4 ff ff       	jmp    80105ff5 <alltraps>

80106b2b <vector163>:
.globl vector163
vector163:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $163
80106b2d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106b32:	e9 be f4 ff ff       	jmp    80105ff5 <alltraps>

80106b37 <vector164>:
.globl vector164
vector164:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $164
80106b39:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106b3e:	e9 b2 f4 ff ff       	jmp    80105ff5 <alltraps>

80106b43 <vector165>:
.globl vector165
vector165:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $165
80106b45:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106b4a:	e9 a6 f4 ff ff       	jmp    80105ff5 <alltraps>

80106b4f <vector166>:
.globl vector166
vector166:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $166
80106b51:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106b56:	e9 9a f4 ff ff       	jmp    80105ff5 <alltraps>

80106b5b <vector167>:
.globl vector167
vector167:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $167
80106b5d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106b62:	e9 8e f4 ff ff       	jmp    80105ff5 <alltraps>

80106b67 <vector168>:
.globl vector168
vector168:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $168
80106b69:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106b6e:	e9 82 f4 ff ff       	jmp    80105ff5 <alltraps>

80106b73 <vector169>:
.globl vector169
vector169:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $169
80106b75:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106b7a:	e9 76 f4 ff ff       	jmp    80105ff5 <alltraps>

80106b7f <vector170>:
.globl vector170
vector170:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $170
80106b81:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106b86:	e9 6a f4 ff ff       	jmp    80105ff5 <alltraps>

80106b8b <vector171>:
.globl vector171
vector171:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $171
80106b8d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106b92:	e9 5e f4 ff ff       	jmp    80105ff5 <alltraps>

80106b97 <vector172>:
.globl vector172
vector172:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $172
80106b99:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106b9e:	e9 52 f4 ff ff       	jmp    80105ff5 <alltraps>

80106ba3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $173
80106ba5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106baa:	e9 46 f4 ff ff       	jmp    80105ff5 <alltraps>

80106baf <vector174>:
.globl vector174
vector174:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $174
80106bb1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106bb6:	e9 3a f4 ff ff       	jmp    80105ff5 <alltraps>

80106bbb <vector175>:
.globl vector175
vector175:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $175
80106bbd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106bc2:	e9 2e f4 ff ff       	jmp    80105ff5 <alltraps>

80106bc7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $176
80106bc9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106bce:	e9 22 f4 ff ff       	jmp    80105ff5 <alltraps>

80106bd3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $177
80106bd5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106bda:	e9 16 f4 ff ff       	jmp    80105ff5 <alltraps>

80106bdf <vector178>:
.globl vector178
vector178:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $178
80106be1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106be6:	e9 0a f4 ff ff       	jmp    80105ff5 <alltraps>

80106beb <vector179>:
.globl vector179
vector179:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $179
80106bed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106bf2:	e9 fe f3 ff ff       	jmp    80105ff5 <alltraps>

80106bf7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $180
80106bf9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106bfe:	e9 f2 f3 ff ff       	jmp    80105ff5 <alltraps>

80106c03 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $181
80106c05:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c0a:	e9 e6 f3 ff ff       	jmp    80105ff5 <alltraps>

80106c0f <vector182>:
.globl vector182
vector182:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $182
80106c11:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c16:	e9 da f3 ff ff       	jmp    80105ff5 <alltraps>

80106c1b <vector183>:
.globl vector183
vector183:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $183
80106c1d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c22:	e9 ce f3 ff ff       	jmp    80105ff5 <alltraps>

80106c27 <vector184>:
.globl vector184
vector184:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $184
80106c29:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106c2e:	e9 c2 f3 ff ff       	jmp    80105ff5 <alltraps>

80106c33 <vector185>:
.globl vector185
vector185:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $185
80106c35:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106c3a:	e9 b6 f3 ff ff       	jmp    80105ff5 <alltraps>

80106c3f <vector186>:
.globl vector186
vector186:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $186
80106c41:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106c46:	e9 aa f3 ff ff       	jmp    80105ff5 <alltraps>

80106c4b <vector187>:
.globl vector187
vector187:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $187
80106c4d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106c52:	e9 9e f3 ff ff       	jmp    80105ff5 <alltraps>

80106c57 <vector188>:
.globl vector188
vector188:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $188
80106c59:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106c5e:	e9 92 f3 ff ff       	jmp    80105ff5 <alltraps>

80106c63 <vector189>:
.globl vector189
vector189:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $189
80106c65:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106c6a:	e9 86 f3 ff ff       	jmp    80105ff5 <alltraps>

80106c6f <vector190>:
.globl vector190
vector190:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $190
80106c71:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106c76:	e9 7a f3 ff ff       	jmp    80105ff5 <alltraps>

80106c7b <vector191>:
.globl vector191
vector191:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $191
80106c7d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106c82:	e9 6e f3 ff ff       	jmp    80105ff5 <alltraps>

80106c87 <vector192>:
.globl vector192
vector192:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $192
80106c89:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106c8e:	e9 62 f3 ff ff       	jmp    80105ff5 <alltraps>

80106c93 <vector193>:
.globl vector193
vector193:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $193
80106c95:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106c9a:	e9 56 f3 ff ff       	jmp    80105ff5 <alltraps>

80106c9f <vector194>:
.globl vector194
vector194:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $194
80106ca1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106ca6:	e9 4a f3 ff ff       	jmp    80105ff5 <alltraps>

80106cab <vector195>:
.globl vector195
vector195:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $195
80106cad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106cb2:	e9 3e f3 ff ff       	jmp    80105ff5 <alltraps>

80106cb7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $196
80106cb9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106cbe:	e9 32 f3 ff ff       	jmp    80105ff5 <alltraps>

80106cc3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $197
80106cc5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106cca:	e9 26 f3 ff ff       	jmp    80105ff5 <alltraps>

80106ccf <vector198>:
.globl vector198
vector198:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $198
80106cd1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106cd6:	e9 1a f3 ff ff       	jmp    80105ff5 <alltraps>

80106cdb <vector199>:
.globl vector199
vector199:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $199
80106cdd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ce2:	e9 0e f3 ff ff       	jmp    80105ff5 <alltraps>

80106ce7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $200
80106ce9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106cee:	e9 02 f3 ff ff       	jmp    80105ff5 <alltraps>

80106cf3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $201
80106cf5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106cfa:	e9 f6 f2 ff ff       	jmp    80105ff5 <alltraps>

80106cff <vector202>:
.globl vector202
vector202:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $202
80106d01:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d06:	e9 ea f2 ff ff       	jmp    80105ff5 <alltraps>

80106d0b <vector203>:
.globl vector203
vector203:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $203
80106d0d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d12:	e9 de f2 ff ff       	jmp    80105ff5 <alltraps>

80106d17 <vector204>:
.globl vector204
vector204:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $204
80106d19:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d1e:	e9 d2 f2 ff ff       	jmp    80105ff5 <alltraps>

80106d23 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $205
80106d25:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d2a:	e9 c6 f2 ff ff       	jmp    80105ff5 <alltraps>

80106d2f <vector206>:
.globl vector206
vector206:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $206
80106d31:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106d36:	e9 ba f2 ff ff       	jmp    80105ff5 <alltraps>

80106d3b <vector207>:
.globl vector207
vector207:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $207
80106d3d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106d42:	e9 ae f2 ff ff       	jmp    80105ff5 <alltraps>

80106d47 <vector208>:
.globl vector208
vector208:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $208
80106d49:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106d4e:	e9 a2 f2 ff ff       	jmp    80105ff5 <alltraps>

80106d53 <vector209>:
.globl vector209
vector209:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $209
80106d55:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106d5a:	e9 96 f2 ff ff       	jmp    80105ff5 <alltraps>

80106d5f <vector210>:
.globl vector210
vector210:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $210
80106d61:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106d66:	e9 8a f2 ff ff       	jmp    80105ff5 <alltraps>

80106d6b <vector211>:
.globl vector211
vector211:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $211
80106d6d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106d72:	e9 7e f2 ff ff       	jmp    80105ff5 <alltraps>

80106d77 <vector212>:
.globl vector212
vector212:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $212
80106d79:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106d7e:	e9 72 f2 ff ff       	jmp    80105ff5 <alltraps>

80106d83 <vector213>:
.globl vector213
vector213:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $213
80106d85:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106d8a:	e9 66 f2 ff ff       	jmp    80105ff5 <alltraps>

80106d8f <vector214>:
.globl vector214
vector214:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $214
80106d91:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106d96:	e9 5a f2 ff ff       	jmp    80105ff5 <alltraps>

80106d9b <vector215>:
.globl vector215
vector215:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $215
80106d9d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106da2:	e9 4e f2 ff ff       	jmp    80105ff5 <alltraps>

80106da7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $216
80106da9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106dae:	e9 42 f2 ff ff       	jmp    80105ff5 <alltraps>

80106db3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $217
80106db5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106dba:	e9 36 f2 ff ff       	jmp    80105ff5 <alltraps>

80106dbf <vector218>:
.globl vector218
vector218:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $218
80106dc1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106dc6:	e9 2a f2 ff ff       	jmp    80105ff5 <alltraps>

80106dcb <vector219>:
.globl vector219
vector219:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $219
80106dcd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106dd2:	e9 1e f2 ff ff       	jmp    80105ff5 <alltraps>

80106dd7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $220
80106dd9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106dde:	e9 12 f2 ff ff       	jmp    80105ff5 <alltraps>

80106de3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $221
80106de5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106dea:	e9 06 f2 ff ff       	jmp    80105ff5 <alltraps>

80106def <vector222>:
.globl vector222
vector222:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $222
80106df1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106df6:	e9 fa f1 ff ff       	jmp    80105ff5 <alltraps>

80106dfb <vector223>:
.globl vector223
vector223:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $223
80106dfd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e02:	e9 ee f1 ff ff       	jmp    80105ff5 <alltraps>

80106e07 <vector224>:
.globl vector224
vector224:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $224
80106e09:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106e0e:	e9 e2 f1 ff ff       	jmp    80105ff5 <alltraps>

80106e13 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $225
80106e15:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e1a:	e9 d6 f1 ff ff       	jmp    80105ff5 <alltraps>

80106e1f <vector226>:
.globl vector226
vector226:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $226
80106e21:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e26:	e9 ca f1 ff ff       	jmp    80105ff5 <alltraps>

80106e2b <vector227>:
.globl vector227
vector227:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $227
80106e2d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106e32:	e9 be f1 ff ff       	jmp    80105ff5 <alltraps>

80106e37 <vector228>:
.globl vector228
vector228:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $228
80106e39:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106e3e:	e9 b2 f1 ff ff       	jmp    80105ff5 <alltraps>

80106e43 <vector229>:
.globl vector229
vector229:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $229
80106e45:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106e4a:	e9 a6 f1 ff ff       	jmp    80105ff5 <alltraps>

80106e4f <vector230>:
.globl vector230
vector230:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $230
80106e51:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106e56:	e9 9a f1 ff ff       	jmp    80105ff5 <alltraps>

80106e5b <vector231>:
.globl vector231
vector231:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $231
80106e5d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106e62:	e9 8e f1 ff ff       	jmp    80105ff5 <alltraps>

80106e67 <vector232>:
.globl vector232
vector232:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $232
80106e69:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106e6e:	e9 82 f1 ff ff       	jmp    80105ff5 <alltraps>

80106e73 <vector233>:
.globl vector233
vector233:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $233
80106e75:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106e7a:	e9 76 f1 ff ff       	jmp    80105ff5 <alltraps>

80106e7f <vector234>:
.globl vector234
vector234:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $234
80106e81:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106e86:	e9 6a f1 ff ff       	jmp    80105ff5 <alltraps>

80106e8b <vector235>:
.globl vector235
vector235:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $235
80106e8d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106e92:	e9 5e f1 ff ff       	jmp    80105ff5 <alltraps>

80106e97 <vector236>:
.globl vector236
vector236:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $236
80106e99:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106e9e:	e9 52 f1 ff ff       	jmp    80105ff5 <alltraps>

80106ea3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $237
80106ea5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106eaa:	e9 46 f1 ff ff       	jmp    80105ff5 <alltraps>

80106eaf <vector238>:
.globl vector238
vector238:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $238
80106eb1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106eb6:	e9 3a f1 ff ff       	jmp    80105ff5 <alltraps>

80106ebb <vector239>:
.globl vector239
vector239:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $239
80106ebd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ec2:	e9 2e f1 ff ff       	jmp    80105ff5 <alltraps>

80106ec7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $240
80106ec9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ece:	e9 22 f1 ff ff       	jmp    80105ff5 <alltraps>

80106ed3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $241
80106ed5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106eda:	e9 16 f1 ff ff       	jmp    80105ff5 <alltraps>

80106edf <vector242>:
.globl vector242
vector242:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $242
80106ee1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ee6:	e9 0a f1 ff ff       	jmp    80105ff5 <alltraps>

80106eeb <vector243>:
.globl vector243
vector243:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $243
80106eed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ef2:	e9 fe f0 ff ff       	jmp    80105ff5 <alltraps>

80106ef7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $244
80106ef9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106efe:	e9 f2 f0 ff ff       	jmp    80105ff5 <alltraps>

80106f03 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $245
80106f05:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f0a:	e9 e6 f0 ff ff       	jmp    80105ff5 <alltraps>

80106f0f <vector246>:
.globl vector246
vector246:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $246
80106f11:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f16:	e9 da f0 ff ff       	jmp    80105ff5 <alltraps>

80106f1b <vector247>:
.globl vector247
vector247:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $247
80106f1d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f22:	e9 ce f0 ff ff       	jmp    80105ff5 <alltraps>

80106f27 <vector248>:
.globl vector248
vector248:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $248
80106f29:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106f2e:	e9 c2 f0 ff ff       	jmp    80105ff5 <alltraps>

80106f33 <vector249>:
.globl vector249
vector249:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $249
80106f35:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106f3a:	e9 b6 f0 ff ff       	jmp    80105ff5 <alltraps>

80106f3f <vector250>:
.globl vector250
vector250:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $250
80106f41:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106f46:	e9 aa f0 ff ff       	jmp    80105ff5 <alltraps>

80106f4b <vector251>:
.globl vector251
vector251:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $251
80106f4d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106f52:	e9 9e f0 ff ff       	jmp    80105ff5 <alltraps>

80106f57 <vector252>:
.globl vector252
vector252:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $252
80106f59:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106f5e:	e9 92 f0 ff ff       	jmp    80105ff5 <alltraps>

80106f63 <vector253>:
.globl vector253
vector253:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $253
80106f65:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106f6a:	e9 86 f0 ff ff       	jmp    80105ff5 <alltraps>

80106f6f <vector254>:
.globl vector254
vector254:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $254
80106f71:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106f76:	e9 7a f0 ff ff       	jmp    80105ff5 <alltraps>

80106f7b <vector255>:
.globl vector255
vector255:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $255
80106f7d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106f82:	e9 6e f0 ff ff       	jmp    80105ff5 <alltraps>
80106f87:	66 90                	xchg   %ax,%ax
80106f89:	66 90                	xchg   %ax,%ax
80106f8b:	66 90                	xchg   %ax,%ax
80106f8d:	66 90                	xchg   %ax,%ax
80106f8f:	90                   	nop

80106f90 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106f96:	89 d3                	mov    %edx,%ebx
{
80106f98:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106f9a:	c1 eb 16             	shr    $0x16,%ebx
80106f9d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106fa0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106fa3:	8b 06                	mov    (%esi),%eax
80106fa5:	a8 01                	test   $0x1,%al
80106fa7:	74 27                	je     80106fd0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fa9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106fb4:	c1 ef 0a             	shr    $0xa,%edi
}
80106fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106fba:	89 fa                	mov    %edi,%edx
80106fbc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106fc2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106fc5:	5b                   	pop    %ebx
80106fc6:	5e                   	pop    %esi
80106fc7:	5f                   	pop    %edi
80106fc8:	5d                   	pop    %ebp
80106fc9:	c3                   	ret    
80106fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106fd0:	85 c9                	test   %ecx,%ecx
80106fd2:	74 2c                	je     80107000 <walkpgdir+0x70>
80106fd4:	e8 e7 b4 ff ff       	call   801024c0 <kalloc>
80106fd9:	85 c0                	test   %eax,%eax
80106fdb:	89 c3                	mov    %eax,%ebx
80106fdd:	74 21                	je     80107000 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106fdf:	83 ec 04             	sub    $0x4,%esp
80106fe2:	68 00 10 00 00       	push   $0x1000
80106fe7:	6a 00                	push   $0x0
80106fe9:	50                   	push   %eax
80106fea:	e8 11 dd ff ff       	call   80104d00 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106fef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ff5:	83 c4 10             	add    $0x10,%esp
80106ff8:	83 c8 07             	or     $0x7,%eax
80106ffb:	89 06                	mov    %eax,(%esi)
80106ffd:	eb b5                	jmp    80106fb4 <walkpgdir+0x24>
80106fff:	90                   	nop
}
80107000:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107003:	31 c0                	xor    %eax,%eax
}
80107005:	5b                   	pop    %ebx
80107006:	5e                   	pop    %esi
80107007:	5f                   	pop    %edi
80107008:	5d                   	pop    %ebp
80107009:	c3                   	ret    
8010700a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107010 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107016:	89 d3                	mov    %edx,%ebx
80107018:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010701e:	83 ec 1c             	sub    $0x1c,%esp
80107021:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107024:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107028:	8b 7d 08             	mov    0x8(%ebp),%edi
8010702b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107030:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107033:	8b 45 0c             	mov    0xc(%ebp),%eax
80107036:	29 df                	sub    %ebx,%edi
80107038:	83 c8 01             	or     $0x1,%eax
8010703b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010703e:	eb 15                	jmp    80107055 <mappages+0x45>
    if(*pte & PTE_P)
80107040:	f6 00 01             	testb  $0x1,(%eax)
80107043:	75 45                	jne    8010708a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107045:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107048:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010704b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010704d:	74 31                	je     80107080 <mappages+0x70>
      break;
    a += PGSIZE;
8010704f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107058:	b9 01 00 00 00       	mov    $0x1,%ecx
8010705d:	89 da                	mov    %ebx,%edx
8010705f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107062:	e8 29 ff ff ff       	call   80106f90 <walkpgdir>
80107067:	85 c0                	test   %eax,%eax
80107069:	75 d5                	jne    80107040 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010706b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010706e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107073:	5b                   	pop    %ebx
80107074:	5e                   	pop    %esi
80107075:	5f                   	pop    %edi
80107076:	5d                   	pop    %ebp
80107077:	c3                   	ret    
80107078:	90                   	nop
80107079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107080:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107083:	31 c0                	xor    %eax,%eax
}
80107085:	5b                   	pop    %ebx
80107086:	5e                   	pop    %esi
80107087:	5f                   	pop    %edi
80107088:	5d                   	pop    %ebp
80107089:	c3                   	ret    
      panic("remap");
8010708a:	83 ec 0c             	sub    $0xc,%esp
8010708d:	68 54 82 10 80       	push   $0x80108254
80107092:	e8 f9 92 ff ff       	call   80100390 <panic>
80107097:	89 f6                	mov    %esi,%esi
80107099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070a0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801070a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070ac:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801070ae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070b4:	83 ec 1c             	sub    $0x1c,%esp
801070b7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801070ba:	39 d3                	cmp    %edx,%ebx
801070bc:	73 66                	jae    80107124 <deallocuvm.part.0+0x84>
801070be:	89 d6                	mov    %edx,%esi
801070c0:	eb 3d                	jmp    801070ff <deallocuvm.part.0+0x5f>
801070c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801070c8:	8b 10                	mov    (%eax),%edx
801070ca:	f6 c2 01             	test   $0x1,%dl
801070cd:	74 26                	je     801070f5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801070cf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801070d5:	74 58                	je     8010712f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801070d7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801070da:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801070e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801070e3:	52                   	push   %edx
801070e4:	e8 27 b2 ff ff       	call   80102310 <kfree>
      *pte = 0;
801070e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070ec:	83 c4 10             	add    $0x10,%esp
801070ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801070f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070fb:	39 f3                	cmp    %esi,%ebx
801070fd:	73 25                	jae    80107124 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801070ff:	31 c9                	xor    %ecx,%ecx
80107101:	89 da                	mov    %ebx,%edx
80107103:	89 f8                	mov    %edi,%eax
80107105:	e8 86 fe ff ff       	call   80106f90 <walkpgdir>
    if(!pte)
8010710a:	85 c0                	test   %eax,%eax
8010710c:	75 ba                	jne    801070c8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010710e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107114:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010711a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107120:	39 f3                	cmp    %esi,%ebx
80107122:	72 db                	jb     801070ff <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107124:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107127:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010712a:	5b                   	pop    %ebx
8010712b:	5e                   	pop    %esi
8010712c:	5f                   	pop    %edi
8010712d:	5d                   	pop    %ebp
8010712e:	c3                   	ret    
        panic("kfree");
8010712f:	83 ec 0c             	sub    $0xc,%esp
80107132:	68 26 7b 10 80       	push   $0x80107b26
80107137:	e8 54 92 ff ff       	call   80100390 <panic>
8010713c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107140 <seginit>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107146:	e8 a5 c7 ff ff       	call   801038f0 <cpuid>
8010714b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107151:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107156:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010715a:	c7 80 d8 38 11 80 ff 	movl   $0xffff,-0x7feec728(%eax)
80107161:	ff 00 00 
80107164:	c7 80 dc 38 11 80 00 	movl   $0xcf9a00,-0x7feec724(%eax)
8010716b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010716e:	c7 80 e0 38 11 80 ff 	movl   $0xffff,-0x7feec720(%eax)
80107175:	ff 00 00 
80107178:	c7 80 e4 38 11 80 00 	movl   $0xcf9200,-0x7feec71c(%eax)
8010717f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107182:	c7 80 e8 38 11 80 ff 	movl   $0xffff,-0x7feec718(%eax)
80107189:	ff 00 00 
8010718c:	c7 80 ec 38 11 80 00 	movl   $0xcffa00,-0x7feec714(%eax)
80107193:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107196:	c7 80 f0 38 11 80 ff 	movl   $0xffff,-0x7feec710(%eax)
8010719d:	ff 00 00 
801071a0:	c7 80 f4 38 11 80 00 	movl   $0xcff200,-0x7feec70c(%eax)
801071a7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801071aa:	05 d0 38 11 80       	add    $0x801138d0,%eax
  pd[1] = (uint)p;
801071af:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801071b3:	c1 e8 10             	shr    $0x10,%eax
801071b6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801071ba:	8d 45 f2             	lea    -0xe(%ebp),%eax
801071bd:	0f 01 10             	lgdtl  (%eax)
}
801071c0:	c9                   	leave  
801071c1:	c3                   	ret    
801071c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071d0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801071d0:	a1 84 69 11 80       	mov    0x80116984,%eax
{
801071d5:	55                   	push   %ebp
801071d6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801071d8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071dd:	0f 22 d8             	mov    %eax,%cr3
}
801071e0:	5d                   	pop    %ebp
801071e1:	c3                   	ret    
801071e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071f0 <switchuvm>:
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
801071f6:	83 ec 1c             	sub    $0x1c,%esp
801071f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801071fc:	85 db                	test   %ebx,%ebx
801071fe:	0f 84 cb 00 00 00    	je     801072cf <switchuvm+0xdf>
  if(p->kstack == 0)
80107204:	8b 43 08             	mov    0x8(%ebx),%eax
80107207:	85 c0                	test   %eax,%eax
80107209:	0f 84 da 00 00 00    	je     801072e9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010720f:	8b 43 04             	mov    0x4(%ebx),%eax
80107212:	85 c0                	test   %eax,%eax
80107214:	0f 84 c2 00 00 00    	je     801072dc <switchuvm+0xec>
  pushcli();
8010721a:	e8 01 d9 ff ff       	call   80104b20 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010721f:	e8 4c c6 ff ff       	call   80103870 <mycpu>
80107224:	89 c6                	mov    %eax,%esi
80107226:	e8 45 c6 ff ff       	call   80103870 <mycpu>
8010722b:	89 c7                	mov    %eax,%edi
8010722d:	e8 3e c6 ff ff       	call   80103870 <mycpu>
80107232:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107235:	83 c7 08             	add    $0x8,%edi
80107238:	e8 33 c6 ff ff       	call   80103870 <mycpu>
8010723d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107240:	83 c0 08             	add    $0x8,%eax
80107243:	ba 67 00 00 00       	mov    $0x67,%edx
80107248:	c1 e8 18             	shr    $0x18,%eax
8010724b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107252:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107259:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010725f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107264:	83 c1 08             	add    $0x8,%ecx
80107267:	c1 e9 10             	shr    $0x10,%ecx
8010726a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107270:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107275:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010727c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107281:	e8 ea c5 ff ff       	call   80103870 <mycpu>
80107286:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010728d:	e8 de c5 ff ff       	call   80103870 <mycpu>
80107292:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107296:	8b 73 08             	mov    0x8(%ebx),%esi
80107299:	e8 d2 c5 ff ff       	call   80103870 <mycpu>
8010729e:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072a4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072a7:	e8 c4 c5 ff ff       	call   80103870 <mycpu>
801072ac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801072b0:	b8 28 00 00 00       	mov    $0x28,%eax
801072b5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801072b8:	8b 43 04             	mov    0x4(%ebx),%eax
801072bb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072c0:	0f 22 d8             	mov    %eax,%cr3
}
801072c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072c6:	5b                   	pop    %ebx
801072c7:	5e                   	pop    %esi
801072c8:	5f                   	pop    %edi
801072c9:	5d                   	pop    %ebp
  popcli();
801072ca:	e9 91 d8 ff ff       	jmp    80104b60 <popcli>
    panic("switchuvm: no process");
801072cf:	83 ec 0c             	sub    $0xc,%esp
801072d2:	68 5a 82 10 80       	push   $0x8010825a
801072d7:	e8 b4 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801072dc:	83 ec 0c             	sub    $0xc,%esp
801072df:	68 85 82 10 80       	push   $0x80108285
801072e4:	e8 a7 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801072e9:	83 ec 0c             	sub    $0xc,%esp
801072ec:	68 70 82 10 80       	push   $0x80108270
801072f1:	e8 9a 90 ff ff       	call   80100390 <panic>
801072f6:	8d 76 00             	lea    0x0(%esi),%esi
801072f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107300 <inituvm>:
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	57                   	push   %edi
80107304:	56                   	push   %esi
80107305:	53                   	push   %ebx
80107306:	83 ec 1c             	sub    $0x1c,%esp
80107309:	8b 75 10             	mov    0x10(%ebp),%esi
8010730c:	8b 45 08             	mov    0x8(%ebp),%eax
8010730f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107312:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107318:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010731b:	77 49                	ja     80107366 <inituvm+0x66>
  mem = kalloc();
8010731d:	e8 9e b1 ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107322:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107325:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107327:	68 00 10 00 00       	push   $0x1000
8010732c:	6a 00                	push   $0x0
8010732e:	50                   	push   %eax
8010732f:	e8 cc d9 ff ff       	call   80104d00 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107334:	58                   	pop    %eax
80107335:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010733b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107340:	5a                   	pop    %edx
80107341:	6a 06                	push   $0x6
80107343:	50                   	push   %eax
80107344:	31 d2                	xor    %edx,%edx
80107346:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107349:	e8 c2 fc ff ff       	call   80107010 <mappages>
  memmove(mem, init, sz);
8010734e:	89 75 10             	mov    %esi,0x10(%ebp)
80107351:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107354:	83 c4 10             	add    $0x10,%esp
80107357:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010735a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010735d:	5b                   	pop    %ebx
8010735e:	5e                   	pop    %esi
8010735f:	5f                   	pop    %edi
80107360:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107361:	e9 4a da ff ff       	jmp    80104db0 <memmove>
    panic("inituvm: more than a page");
80107366:	83 ec 0c             	sub    $0xc,%esp
80107369:	68 99 82 10 80       	push   $0x80108299
8010736e:	e8 1d 90 ff ff       	call   80100390 <panic>
80107373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107380 <loaduvm>:
{
80107380:	55                   	push   %ebp
80107381:	89 e5                	mov    %esp,%ebp
80107383:	57                   	push   %edi
80107384:	56                   	push   %esi
80107385:	53                   	push   %ebx
80107386:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107389:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107390:	0f 85 91 00 00 00    	jne    80107427 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107396:	8b 75 18             	mov    0x18(%ebp),%esi
80107399:	31 db                	xor    %ebx,%ebx
8010739b:	85 f6                	test   %esi,%esi
8010739d:	75 1a                	jne    801073b9 <loaduvm+0x39>
8010739f:	eb 6f                	jmp    80107410 <loaduvm+0x90>
801073a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073ae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801073b4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801073b7:	76 57                	jbe    80107410 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801073b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801073bc:	8b 45 08             	mov    0x8(%ebp),%eax
801073bf:	31 c9                	xor    %ecx,%ecx
801073c1:	01 da                	add    %ebx,%edx
801073c3:	e8 c8 fb ff ff       	call   80106f90 <walkpgdir>
801073c8:	85 c0                	test   %eax,%eax
801073ca:	74 4e                	je     8010741a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801073cc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801073d1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801073d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801073db:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801073e1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073e4:	01 d9                	add    %ebx,%ecx
801073e6:	05 00 00 00 80       	add    $0x80000000,%eax
801073eb:	57                   	push   %edi
801073ec:	51                   	push   %ecx
801073ed:	50                   	push   %eax
801073ee:	ff 75 10             	pushl  0x10(%ebp)
801073f1:	e8 6a a5 ff ff       	call   80101960 <readi>
801073f6:	83 c4 10             	add    $0x10,%esp
801073f9:	39 f8                	cmp    %edi,%eax
801073fb:	74 ab                	je     801073a8 <loaduvm+0x28>
}
801073fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107405:	5b                   	pop    %ebx
80107406:	5e                   	pop    %esi
80107407:	5f                   	pop    %edi
80107408:	5d                   	pop    %ebp
80107409:	c3                   	ret    
8010740a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107410:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107413:	31 c0                	xor    %eax,%eax
}
80107415:	5b                   	pop    %ebx
80107416:	5e                   	pop    %esi
80107417:	5f                   	pop    %edi
80107418:	5d                   	pop    %ebp
80107419:	c3                   	ret    
      panic("loaduvm: address should exist");
8010741a:	83 ec 0c             	sub    $0xc,%esp
8010741d:	68 b3 82 10 80       	push   $0x801082b3
80107422:	e8 69 8f ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107427:	83 ec 0c             	sub    $0xc,%esp
8010742a:	68 54 83 10 80       	push   $0x80108354
8010742f:	e8 5c 8f ff ff       	call   80100390 <panic>
80107434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010743a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107440 <allocuvm>:
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	57                   	push   %edi
80107444:	56                   	push   %esi
80107445:	53                   	push   %ebx
80107446:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107449:	8b 7d 10             	mov    0x10(%ebp),%edi
8010744c:	85 ff                	test   %edi,%edi
8010744e:	0f 88 8e 00 00 00    	js     801074e2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107454:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107457:	0f 82 93 00 00 00    	jb     801074f0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010745d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107460:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107466:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010746c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010746f:	0f 86 7e 00 00 00    	jbe    801074f3 <allocuvm+0xb3>
80107475:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107478:	8b 7d 08             	mov    0x8(%ebp),%edi
8010747b:	eb 42                	jmp    801074bf <allocuvm+0x7f>
8010747d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107480:	83 ec 04             	sub    $0x4,%esp
80107483:	68 00 10 00 00       	push   $0x1000
80107488:	6a 00                	push   $0x0
8010748a:	50                   	push   %eax
8010748b:	e8 70 d8 ff ff       	call   80104d00 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107490:	58                   	pop    %eax
80107491:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107497:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010749c:	5a                   	pop    %edx
8010749d:	6a 06                	push   $0x6
8010749f:	50                   	push   %eax
801074a0:	89 da                	mov    %ebx,%edx
801074a2:	89 f8                	mov    %edi,%eax
801074a4:	e8 67 fb ff ff       	call   80107010 <mappages>
801074a9:	83 c4 10             	add    $0x10,%esp
801074ac:	85 c0                	test   %eax,%eax
801074ae:	78 50                	js     80107500 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801074b0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074b6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801074b9:	0f 86 81 00 00 00    	jbe    80107540 <allocuvm+0x100>
    mem = kalloc();
801074bf:	e8 fc af ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
801074c4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801074c6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801074c8:	75 b6                	jne    80107480 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801074ca:	83 ec 0c             	sub    $0xc,%esp
801074cd:	68 d1 82 10 80       	push   $0x801082d1
801074d2:	e8 89 91 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801074d7:	83 c4 10             	add    $0x10,%esp
801074da:	8b 45 0c             	mov    0xc(%ebp),%eax
801074dd:	39 45 10             	cmp    %eax,0x10(%ebp)
801074e0:	77 6e                	ja     80107550 <allocuvm+0x110>
}
801074e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801074e5:	31 ff                	xor    %edi,%edi
}
801074e7:	89 f8                	mov    %edi,%eax
801074e9:	5b                   	pop    %ebx
801074ea:	5e                   	pop    %esi
801074eb:	5f                   	pop    %edi
801074ec:	5d                   	pop    %ebp
801074ed:	c3                   	ret    
801074ee:	66 90                	xchg   %ax,%ax
    return oldsz;
801074f0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801074f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074f6:	89 f8                	mov    %edi,%eax
801074f8:	5b                   	pop    %ebx
801074f9:	5e                   	pop    %esi
801074fa:	5f                   	pop    %edi
801074fb:	5d                   	pop    %ebp
801074fc:	c3                   	ret    
801074fd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107500:	83 ec 0c             	sub    $0xc,%esp
80107503:	68 e9 82 10 80       	push   $0x801082e9
80107508:	e8 53 91 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010750d:	83 c4 10             	add    $0x10,%esp
80107510:	8b 45 0c             	mov    0xc(%ebp),%eax
80107513:	39 45 10             	cmp    %eax,0x10(%ebp)
80107516:	76 0d                	jbe    80107525 <allocuvm+0xe5>
80107518:	89 c1                	mov    %eax,%ecx
8010751a:	8b 55 10             	mov    0x10(%ebp),%edx
8010751d:	8b 45 08             	mov    0x8(%ebp),%eax
80107520:	e8 7b fb ff ff       	call   801070a0 <deallocuvm.part.0>
      kfree(mem);
80107525:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107528:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010752a:	56                   	push   %esi
8010752b:	e8 e0 ad ff ff       	call   80102310 <kfree>
      return 0;
80107530:	83 c4 10             	add    $0x10,%esp
}
80107533:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107536:	89 f8                	mov    %edi,%eax
80107538:	5b                   	pop    %ebx
80107539:	5e                   	pop    %esi
8010753a:	5f                   	pop    %edi
8010753b:	5d                   	pop    %ebp
8010753c:	c3                   	ret    
8010753d:	8d 76 00             	lea    0x0(%esi),%esi
80107540:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107543:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107546:	5b                   	pop    %ebx
80107547:	89 f8                	mov    %edi,%eax
80107549:	5e                   	pop    %esi
8010754a:	5f                   	pop    %edi
8010754b:	5d                   	pop    %ebp
8010754c:	c3                   	ret    
8010754d:	8d 76 00             	lea    0x0(%esi),%esi
80107550:	89 c1                	mov    %eax,%ecx
80107552:	8b 55 10             	mov    0x10(%ebp),%edx
80107555:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107558:	31 ff                	xor    %edi,%edi
8010755a:	e8 41 fb ff ff       	call   801070a0 <deallocuvm.part.0>
8010755f:	eb 92                	jmp    801074f3 <allocuvm+0xb3>
80107561:	eb 0d                	jmp    80107570 <deallocuvm>
80107563:	90                   	nop
80107564:	90                   	nop
80107565:	90                   	nop
80107566:	90                   	nop
80107567:	90                   	nop
80107568:	90                   	nop
80107569:	90                   	nop
8010756a:	90                   	nop
8010756b:	90                   	nop
8010756c:	90                   	nop
8010756d:	90                   	nop
8010756e:	90                   	nop
8010756f:	90                   	nop

80107570 <deallocuvm>:
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	8b 55 0c             	mov    0xc(%ebp),%edx
80107576:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107579:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010757c:	39 d1                	cmp    %edx,%ecx
8010757e:	73 10                	jae    80107590 <deallocuvm+0x20>
}
80107580:	5d                   	pop    %ebp
80107581:	e9 1a fb ff ff       	jmp    801070a0 <deallocuvm.part.0>
80107586:	8d 76 00             	lea    0x0(%esi),%esi
80107589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107590:	89 d0                	mov    %edx,%eax
80107592:	5d                   	pop    %ebp
80107593:	c3                   	ret    
80107594:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010759a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801075a0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	53                   	push   %ebx
801075a6:	83 ec 0c             	sub    $0xc,%esp
801075a9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801075ac:	85 f6                	test   %esi,%esi
801075ae:	74 59                	je     80107609 <freevm+0x69>
801075b0:	31 c9                	xor    %ecx,%ecx
801075b2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801075b7:	89 f0                	mov    %esi,%eax
801075b9:	e8 e2 fa ff ff       	call   801070a0 <deallocuvm.part.0>
801075be:	89 f3                	mov    %esi,%ebx
801075c0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801075c6:	eb 0f                	jmp    801075d7 <freevm+0x37>
801075c8:	90                   	nop
801075c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075d0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801075d3:	39 fb                	cmp    %edi,%ebx
801075d5:	74 23                	je     801075fa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801075d7:	8b 03                	mov    (%ebx),%eax
801075d9:	a8 01                	test   $0x1,%al
801075db:	74 f3                	je     801075d0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801075dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801075e2:	83 ec 0c             	sub    $0xc,%esp
801075e5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801075e8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801075ed:	50                   	push   %eax
801075ee:	e8 1d ad ff ff       	call   80102310 <kfree>
801075f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801075f6:	39 fb                	cmp    %edi,%ebx
801075f8:	75 dd                	jne    801075d7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801075fa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801075fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107600:	5b                   	pop    %ebx
80107601:	5e                   	pop    %esi
80107602:	5f                   	pop    %edi
80107603:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107604:	e9 07 ad ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80107609:	83 ec 0c             	sub    $0xc,%esp
8010760c:	68 05 83 10 80       	push   $0x80108305
80107611:	e8 7a 8d ff ff       	call   80100390 <panic>
80107616:	8d 76 00             	lea    0x0(%esi),%esi
80107619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107620 <setupkvm>:
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	56                   	push   %esi
80107624:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107625:	e8 96 ae ff ff       	call   801024c0 <kalloc>
8010762a:	85 c0                	test   %eax,%eax
8010762c:	89 c6                	mov    %eax,%esi
8010762e:	74 42                	je     80107672 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107630:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107633:	bb e0 b4 10 80       	mov    $0x8010b4e0,%ebx
  memset(pgdir, 0, PGSIZE);
80107638:	68 00 10 00 00       	push   $0x1000
8010763d:	6a 00                	push   $0x0
8010763f:	50                   	push   %eax
80107640:	e8 bb d6 ff ff       	call   80104d00 <memset>
80107645:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107648:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010764b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010764e:	83 ec 08             	sub    $0x8,%esp
80107651:	8b 13                	mov    (%ebx),%edx
80107653:	ff 73 0c             	pushl  0xc(%ebx)
80107656:	50                   	push   %eax
80107657:	29 c1                	sub    %eax,%ecx
80107659:	89 f0                	mov    %esi,%eax
8010765b:	e8 b0 f9 ff ff       	call   80107010 <mappages>
80107660:	83 c4 10             	add    $0x10,%esp
80107663:	85 c0                	test   %eax,%eax
80107665:	78 19                	js     80107680 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107667:	83 c3 10             	add    $0x10,%ebx
8010766a:	81 fb 20 b5 10 80    	cmp    $0x8010b520,%ebx
80107670:	75 d6                	jne    80107648 <setupkvm+0x28>
}
80107672:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107675:	89 f0                	mov    %esi,%eax
80107677:	5b                   	pop    %ebx
80107678:	5e                   	pop    %esi
80107679:	5d                   	pop    %ebp
8010767a:	c3                   	ret    
8010767b:	90                   	nop
8010767c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107680:	83 ec 0c             	sub    $0xc,%esp
80107683:	56                   	push   %esi
      return 0;
80107684:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107686:	e8 15 ff ff ff       	call   801075a0 <freevm>
      return 0;
8010768b:	83 c4 10             	add    $0x10,%esp
}
8010768e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107691:	89 f0                	mov    %esi,%eax
80107693:	5b                   	pop    %ebx
80107694:	5e                   	pop    %esi
80107695:	5d                   	pop    %ebp
80107696:	c3                   	ret    
80107697:	89 f6                	mov    %esi,%esi
80107699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076a0 <kvmalloc>:
{
801076a0:	55                   	push   %ebp
801076a1:	89 e5                	mov    %esp,%ebp
801076a3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801076a6:	e8 75 ff ff ff       	call   80107620 <setupkvm>
801076ab:	a3 84 69 11 80       	mov    %eax,0x80116984
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801076b0:	05 00 00 00 80       	add    $0x80000000,%eax
801076b5:	0f 22 d8             	mov    %eax,%cr3
}
801076b8:	c9                   	leave  
801076b9:	c3                   	ret    
801076ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801076c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076c1:	31 c9                	xor    %ecx,%ecx
{
801076c3:	89 e5                	mov    %esp,%ebp
801076c5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801076c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801076cb:	8b 45 08             	mov    0x8(%ebp),%eax
801076ce:	e8 bd f8 ff ff       	call   80106f90 <walkpgdir>
  if(pte == 0)
801076d3:	85 c0                	test   %eax,%eax
801076d5:	74 05                	je     801076dc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801076d7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801076da:	c9                   	leave  
801076db:	c3                   	ret    
    panic("clearpteu");
801076dc:	83 ec 0c             	sub    $0xc,%esp
801076df:	68 16 83 10 80       	push   $0x80108316
801076e4:	e8 a7 8c ff ff       	call   80100390 <panic>
801076e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801076f0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801076f0:	55                   	push   %ebp
801076f1:	89 e5                	mov    %esp,%ebp
801076f3:	57                   	push   %edi
801076f4:	56                   	push   %esi
801076f5:	53                   	push   %ebx
801076f6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801076f9:	e8 22 ff ff ff       	call   80107620 <setupkvm>
801076fe:	85 c0                	test   %eax,%eax
80107700:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107703:	0f 84 9f 00 00 00    	je     801077a8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107709:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010770c:	85 c9                	test   %ecx,%ecx
8010770e:	0f 84 94 00 00 00    	je     801077a8 <copyuvm+0xb8>
80107714:	31 ff                	xor    %edi,%edi
80107716:	eb 4a                	jmp    80107762 <copyuvm+0x72>
80107718:	90                   	nop
80107719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107720:	83 ec 04             	sub    $0x4,%esp
80107723:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107729:	68 00 10 00 00       	push   $0x1000
8010772e:	53                   	push   %ebx
8010772f:	50                   	push   %eax
80107730:	e8 7b d6 ff ff       	call   80104db0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107735:	58                   	pop    %eax
80107736:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010773c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107741:	5a                   	pop    %edx
80107742:	ff 75 e4             	pushl  -0x1c(%ebp)
80107745:	50                   	push   %eax
80107746:	89 fa                	mov    %edi,%edx
80107748:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010774b:	e8 c0 f8 ff ff       	call   80107010 <mappages>
80107750:	83 c4 10             	add    $0x10,%esp
80107753:	85 c0                	test   %eax,%eax
80107755:	78 61                	js     801077b8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107757:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010775d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107760:	76 46                	jbe    801077a8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107762:	8b 45 08             	mov    0x8(%ebp),%eax
80107765:	31 c9                	xor    %ecx,%ecx
80107767:	89 fa                	mov    %edi,%edx
80107769:	e8 22 f8 ff ff       	call   80106f90 <walkpgdir>
8010776e:	85 c0                	test   %eax,%eax
80107770:	74 61                	je     801077d3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107772:	8b 00                	mov    (%eax),%eax
80107774:	a8 01                	test   $0x1,%al
80107776:	74 4e                	je     801077c6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107778:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010777a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010777f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107788:	e8 33 ad ff ff       	call   801024c0 <kalloc>
8010778d:	85 c0                	test   %eax,%eax
8010778f:	89 c6                	mov    %eax,%esi
80107791:	75 8d                	jne    80107720 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107793:	83 ec 0c             	sub    $0xc,%esp
80107796:	ff 75 e0             	pushl  -0x20(%ebp)
80107799:	e8 02 fe ff ff       	call   801075a0 <freevm>
  return 0;
8010779e:	83 c4 10             	add    $0x10,%esp
801077a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801077a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ae:	5b                   	pop    %ebx
801077af:	5e                   	pop    %esi
801077b0:	5f                   	pop    %edi
801077b1:	5d                   	pop    %ebp
801077b2:	c3                   	ret    
801077b3:	90                   	nop
801077b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801077b8:	83 ec 0c             	sub    $0xc,%esp
801077bb:	56                   	push   %esi
801077bc:	e8 4f ab ff ff       	call   80102310 <kfree>
      goto bad;
801077c1:	83 c4 10             	add    $0x10,%esp
801077c4:	eb cd                	jmp    80107793 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801077c6:	83 ec 0c             	sub    $0xc,%esp
801077c9:	68 3a 83 10 80       	push   $0x8010833a
801077ce:	e8 bd 8b ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801077d3:	83 ec 0c             	sub    $0xc,%esp
801077d6:	68 20 83 10 80       	push   $0x80108320
801077db:	e8 b0 8b ff ff       	call   80100390 <panic>

801077e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801077e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077e1:	31 c9                	xor    %ecx,%ecx
{
801077e3:	89 e5                	mov    %esp,%ebp
801077e5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801077e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801077eb:	8b 45 08             	mov    0x8(%ebp),%eax
801077ee:	e8 9d f7 ff ff       	call   80106f90 <walkpgdir>
  if((*pte & PTE_P) == 0)
801077f3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801077f5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801077f6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801077f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801077fd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107800:	05 00 00 00 80       	add    $0x80000000,%eax
80107805:	83 fa 05             	cmp    $0x5,%edx
80107808:	ba 00 00 00 00       	mov    $0x0,%edx
8010780d:	0f 45 c2             	cmovne %edx,%eax
}
80107810:	c3                   	ret    
80107811:	eb 0d                	jmp    80107820 <copyout>
80107813:	90                   	nop
80107814:	90                   	nop
80107815:	90                   	nop
80107816:	90                   	nop
80107817:	90                   	nop
80107818:	90                   	nop
80107819:	90                   	nop
8010781a:	90                   	nop
8010781b:	90                   	nop
8010781c:	90                   	nop
8010781d:	90                   	nop
8010781e:	90                   	nop
8010781f:	90                   	nop

80107820 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107820:	55                   	push   %ebp
80107821:	89 e5                	mov    %esp,%ebp
80107823:	57                   	push   %edi
80107824:	56                   	push   %esi
80107825:	53                   	push   %ebx
80107826:	83 ec 1c             	sub    $0x1c,%esp
80107829:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010782c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010782f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107832:	85 db                	test   %ebx,%ebx
80107834:	75 40                	jne    80107876 <copyout+0x56>
80107836:	eb 70                	jmp    801078a8 <copyout+0x88>
80107838:	90                   	nop
80107839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107840:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107843:	89 f1                	mov    %esi,%ecx
80107845:	29 d1                	sub    %edx,%ecx
80107847:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010784d:	39 d9                	cmp    %ebx,%ecx
8010784f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107852:	29 f2                	sub    %esi,%edx
80107854:	83 ec 04             	sub    $0x4,%esp
80107857:	01 d0                	add    %edx,%eax
80107859:	51                   	push   %ecx
8010785a:	57                   	push   %edi
8010785b:	50                   	push   %eax
8010785c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010785f:	e8 4c d5 ff ff       	call   80104db0 <memmove>
    len -= n;
    buf += n;
80107864:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107867:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010786a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107870:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107872:	29 cb                	sub    %ecx,%ebx
80107874:	74 32                	je     801078a8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107876:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107878:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010787b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010787e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107884:	56                   	push   %esi
80107885:	ff 75 08             	pushl  0x8(%ebp)
80107888:	e8 53 ff ff ff       	call   801077e0 <uva2ka>
    if(pa0 == 0)
8010788d:	83 c4 10             	add    $0x10,%esp
80107890:	85 c0                	test   %eax,%eax
80107892:	75 ac                	jne    80107840 <copyout+0x20>
  }
  return 0;
}
80107894:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107897:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010789c:	5b                   	pop    %ebx
8010789d:	5e                   	pop    %esi
8010789e:	5f                   	pop    %edi
8010789f:	5d                   	pop    %ebp
801078a0:	c3                   	ret    
801078a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078ab:	31 c0                	xor    %eax,%eax
}
801078ad:	5b                   	pop    %ebx
801078ae:	5e                   	pop    %esi
801078af:	5f                   	pop    %edi
801078b0:	5d                   	pop    %ebp
801078b1:	c3                   	ret    
