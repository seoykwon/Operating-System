#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

int weight_table2[40] = {
    /* 0 */ 88761, 71755, 56483, 46273, 36291,
    /* 5 */ 29154, 23254, 18705, 14949, 11916,
    /* 10 */ 9548, 7620, 6100, 4904, 3906,
    /* 15 */ 3121, 2501, 1991, 1586, 1277,
    /* 20 */ 1024, 820, 655, 526, 423,
    /* 25 */ 335, 272, 215, 172, 137,
    /* 30 */ 110, 87, 70, 56, 45,
    /* 35 */ 36, 29, 23, 18, 15};

void tvinit(void)
{
  int i;

  for (i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void idtinit(void)
{
  lidt(idt, sizeof(idt));
}

// PAGEBREAK: 41
void trap(struct trapframe *tf)
{
  if (tf->trapno == T_SYSCALL)
  {
    if (myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
  {
  case T_IRQ0 + IRQ_TIMER:
    if (cpuid() == 0)
    {
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE + 1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  // page fault case
  case T_PGFLT:
  {
    uint va = rcr2(); // 페이지 폴트가 발생한 가상 주소
    pte_t *pte = walkpgdir(myproc()->pgdir, (void *)va, 0);

    if (pte && (*pte & PTE_A))
    {                                    // PTE_A로 스왑 상태 확인
      uint swap_offset = PTE_ADDR(*pte); // 스왑된 데이터의 오프셋

      // 빈 물리 페이지를 할당
      char *mem = kalloc();
      if (mem == 0)
      {
        cprintf("swapin: out of memory\n");
        myproc()->killed = 1;
        break;
      }

      // 스왑된 데이터를 읽어옴
      if (swapread(mem, swap_offset) < 0)
      {
        cprintf("swapin: failed to read from swap\n");
        kfree(mem);
        myproc()->killed = 1;
        break;
      }

      // 페이지 테이블 업데이트
      memset(mem, 0, PGSIZE);                  // 페이지를 0으로 초기화
      *pte = V2P(mem) | PTE_P | PTE_W | PTE_U; // PTE_P 설정 및 PTE_A 제거
      lcr3(V2P(myproc()->pgdir));              // 페이지 디렉터리 다시 로드

      break;
    }
    else
    {
      // 페이지 폴트 처리 실패 시 기본 동작 수행
      cprintf("page fault: invalid access at 0x%x\n", va);
      myproc()->killed = 1;
      break;
    }
  }

    // if (kalloc(rcr2(), tf->err) != -1)
    // {
    //   break;
    // }

  // PAGEBREAK: 13
  default:
    if (myproc() == 0 || (tf->cs & 3) == 0)
    {
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
    exit();

  // Check on clock tick if process has used up all its execution time
  // if so force process to yield
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER)
  {
    myproc()->runtime = myproc()->runtime + 1000;
    myproc()->vruntime = myproc()->vruntime + ((1000 * 1024) / (weight_table2[myproc()->nice]));
    myproc()->run_d_w = myproc()->runtime / weight_table2[myproc()->nice];
    myproc()->time_slice--;
    if (myproc()->time_slice <= 0)
    {
      myproc()->time_slice = 0;
      yield();
    }
  }
  // // Force process to give up CPU on clock tick.
  // // If interrupts were on while locks held, would need to check nlock.
  // if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
  //   yield();

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
    exit();
}
