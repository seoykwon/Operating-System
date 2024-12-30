#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "math.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"

#define MMAPBASE 0x40000000
struct mmap_area ma[64];

struct
{
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;
int min_vruntime = 0;
__uint64_t overflow = 0;
int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

int weight_table[40] = {
    /* 0 */ 88761, 71755, 56483, 46273, 36291,
    /* 5 */ 29154, 23254, 18705, 14949, 11916,
    /* 10 */ 9548, 7620, 6100, 4904, 3906,
    /* 15 */ 3121, 2501, 1991, 1586, 1277,
    /* 20 */ 1024, 820, 655, 526, 423,
    /* 25 */ 335, 272, 215, 172, 137,
    /* 30 */ 110, 87, 70, 56, 45,
    /* 35 */ 36, 29, 23, 18, 15};

void pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int cpuid()
{
  return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
// apic: advanced programmable interrupt controller
struct cpu *
mycpu(void)
{
  int apicid, i;

  if (readeflags() & FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i)
  {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void)
{
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

// PAGEBREAK: 32
//  Look in the process table for an UNUSED proc.
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  // p->startTime = 1000*ticks;
  // p->vruntime = 0;
  p->nice = 20;
  p->runtime = 0;
  p->vruntime = 0;
  p->time_slice = 0;
  p->run_d_w = 0;

  release(&ptable.lock);

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
  {
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe *)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

// PAGEBREAK: 32
//  Set up first user process.
void userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();

  initproc = p;
  if ((p->pgdir = setupkvm()) == 0)
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
  p->tf->eip = 0; // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");
  // p->nice = 20;

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if (n > 0)
  {
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  else if (n < 0)
  {
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
// int fork(void)
// {
//   int i, pid;
//   struct proc *np;
//   struct proc *curproc = myproc();

//   // Allocate process.
//   if ((np = allocproc()) == 0)
//   {
//     return -1;
//   }

//   // Copy process state from proc.
//   if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
//   {
//     kfree(np->kstack);
//     np->kstack = 0;
//     np->state = UNUSED;
//     return -1;
//   }
//   np->sz = curproc->sz;
//   np->parent = curproc;
//   *np->tf = *curproc->tf;

//   // Inherit the nice value & vruntime from parent
//   np->nice = curproc->nice;
//   np->vruntime = curproc->vruntime;

//   // // start timing from 0
//   // np->startTime = 1000 * ticks;

//   // Clear %eax so that fork returns 0 in the child.
//   np->tf->eax = 0;

//   for (i = 0; i < NOFILE; i++)
//     if (curproc->ofile[i])
//       np->ofile[i] = filedup(curproc->ofile[i]);
//   np->cwd = idup(curproc->cwd);

//   safestrcpy(np->name, curproc->name, sizeof(curproc->name));

//   pid = np->pid;

//   acquire(&ptable.lock);
//   np->state = RUNNABLE;
//   release(&ptable.lock);

//   return pid;
// }
int fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if ((np = allocproc()) == 0)
  {
    return -1;
  }

  // Copy process state from proc.
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
  {
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->vruntime = curproc->vruntime; //==========================================
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for (i = 0; i < NOFILE; i++)
    if (curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  for (int i = 0; i < 64; i++)
  {
    if ((ma[i].is_used == 1) && (ma[i].p == curproc))
    {
      for (int t = 0; t < 64; t++)
      {
        if (ma[t].is_used == 0)
        {
          ma[t].f = ma[i].f;
          ma[t].addr = ma[i].addr;
          ma[t].length = ma[i].length;
          ma[t].offset = ma[i].offset;
          ma[t].prot = ma[i].prot;
          ma[t].flags = ma[i].flags;
          ma[t].p = np;
          ma[t].is_used = ma[i].is_used;

          uint ptr = 0;
          uint addr = ma[i].addr;
          pte_t *pte;
          int prot_write = 0;

          char *mem = 0;

          for (ptr = addr; ptr < addr + ma[i].length; ptr += PGSIZE)
          {
            pte = walkpgdir(curproc->pgdir, (char *)(ptr), 0);
            if (!pte)
              continue; // not in pte pass
            if (!(*pte & PTE_P))
              continue;
            mem = kalloc();
            if (!mem)
              return 0;
            memset(mem, 0, PGSIZE);
            memmove(mem, (void *)ptr, PGSIZE);
            int perm = ma[i].prot | PTE_U;
            if (prot_write)
              perm = perm | PTE_W;
            int ret = mappages(np->pgdir, (void *)ptr, PGSIZE, V2P(mem), perm);
            if (ret == -1)
              return 0;
          }
          break;
        }
      }
    }
  }

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if (curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++)
  {
    if (curproc->ofile[fd])
    {
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->parent == curproc)
    {
      p->parent = initproc;
      if (p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }
  // check uint_32 overflow
  int execVtime = (1000 * ticks - curproc->startTime) * (int)ceil((double)1024 / weights[curproc->nice]);
  if (execVtime > 0 && curproc->vruntime > UINT32_MAX - execVtime)
  {
    overflow += curproc->vruntime + execVtime;
  }

  // update cpu time of current process
  // if overflowed, the number will wrap itself, meaning only remainders are left
  curproc->vruntime += execVtime;

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->parent != curproc)
        continue;
      havekids = 1;
      if (p->state == ZOMBIE)
      {
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
    if (!havekids || curproc->killed)
    {
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
  }
}

// PAGEBREAK: 42
//  Per-CPU process scheduler.
//  Each CPU calls scheduler() after setting itself up.
//  Scheduler never returns.  It loops, doing:
//   - choose a process to run
//   - swtch to start running that process
//   - eventually that process transfers control
//       via swtch back to the scheduler.
void scheduler(void)
{
  struct proc *p;
  struct proc *p1;
  struct proc *p2;
  struct proc *most_p;
  int total_weight;
  struct cpu *c = mycpu();
  c->proc = 0;

  for (;;)
  {
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->state != RUNNABLE)
        continue;

      total_weight = 0;
      for (p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++)
      {
        if (p1->state != RUNNABLE)
          continue;
        total_weight += weight_table[p1->nice];
      }

      most_p = p;
      for (p2 = ptable.proc; p2 < &ptable.proc[NPROC]; p2++)
      {
        if (p2->state != RUNNABLE)
          continue;
        if (most_p->vruntime > p2->vruntime)
        {
          most_p = p2;
        }
      }

      most_p->time_slice = ((10 * (weight_table[most_p->nice])) / total_weight) + ((10 * (weight_table[most_p->nice])) % total_weight != 0);

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = most_p;
      switchuvm(most_p);
      most_p->state = RUNNING;

      swtch(&(c->scheduler), most_p->context);
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
void sched(void)
{
  int intena;
  struct proc *p = myproc();

  if (!holding(&ptable.lock))
    panic("sched ptable.lock");
  if (mycpu()->ncli != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched running");
  if (readeflags() & FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void yield(void)
{
  // check vruntime overflow
  int execVtime = (1000 * ticks - myproc()->startTime) * (int)ceil((double)1024 / weights[myproc()->nice]);
  if (execVtime > 0 && myproc()->vruntime > UINT32_MAX - execVtime)
  {
    overflow += myproc()->vruntime + execVtime;
  }
  // update cpu time of current process
  myproc()->vruntime += execVtime;
  acquire(&ptable.lock); // DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first)
  {
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
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if (p == 0)
    panic("sleep");

  if (lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if (lk != &ptable.lock)
  {                        // DOC: sleeplock0
    acquire(&ptable.lock); // DOC: sleeplock1
    release(lk);
  }
  // check vruntime overflow
  int execVtime = (1000 * ticks - p->startTime) * (int)ceil((double)1024 / weights[p->nice]);
  if (execVtime > 0 && p->vruntime > UINT32_MAX - execVtime)
  {
    overflow += p->vruntime + execVtime;
  }
  // update cpu time of current process
  p->vruntime += execVtime;
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if (lk != &ptable.lock)
  { // DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

// PAGEBREAK!
//  Wake up all processes sleeping on chan.
//  The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  int min_vrun = 0;
  int is_run = 0;
  int vrun_1tick = 0;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == RUNNABLE)
    {
      is_run = 1;
      min_vrun = p->vruntime;
    }

  if (is_run == 1)
  {
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
      if (p->state == RUNNABLE)
      {
        if (min_vrun > p->vruntime)
          min_vrun = p->vruntime;
      }
  }

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->state == SLEEPING && p->chan == chan)
    {
      vrun_1tick = ((1000 * 1024) / (weight_table[p->nice]));
      if (min_vrun < vrun_1tick)
      {
        p->vruntime = 0;
      }
      else
      {
        p->vruntime = min_vrun - vrun_1tick;
        // cprintf("set %d-> vrun %d (%d - %d)\n",p->pid, p->vruntime, min_vrun, vrun_1tick);
      }
      p->state = RUNNABLE;
    }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
  static char *states[] = {
      [UNUSED] "unused",
      [EMBRYO] "embryo",
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if (p->state == SLEEPING)
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int getnice(int pid)
{
  if (pid <= 0)
    return -1;

  struct proc *p;
  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      release(&ptable.lock);
      return p->nice;
    }
  }
  release(&ptable.lock);
  return -1;
}

int setnice(int pid, int value)
{
  struct proc *p;
  acquire(&ptable.lock);

  if ((value < 0) || (value >= 40))
  {
    release(&ptable.lock);
    return -1;
  }
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == pid)
    {
      p->nice = value;
      release(&ptable.lock);
      return 0;
    }
  }

  release(&ptable.lock);
  return -1;
}

void ps(int pid)
{
  static char *states[] = {
      "UNUSED  ",
      "EMBRYO  ",
      "SLEEPING",
      "RUNNABLE",
      "RUNNING ",
      "ZOMBIE  "};

  struct proc *p;
  acquire(&ptable.lock);
  int valid_pid = 0;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if (p->pid == pid)
      valid_pid = 1;
  if (pid == 0)
    valid_pid = 1;

  if (valid_pid == 0)
  {
    release(&ptable.lock);
    return;
  }

  int getlens(char *s)
  {
    int len = 0;
    while (s[len])
      len++;
    return len;
  }

  int getleni(int n)
  {
    int len = 0;
    if (n == 0)
      return 1;
    while (n != 0)
    {
      n = n / 10;
      ++len;
    }
    return len;
  }

  int maxl_name = 0;
  int maxl_runtime = 0;
  int maxl_vruntime = 0;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if ((pid == 0) || (p->pid == pid))
    {
      if (p->state != 0)
      {
        int name_len = getlens(p->name);
        if (maxl_name < name_len)
          maxl_name = name_len;

        int runtime_len = getleni(p->runtime);
        if (maxl_runtime < runtime_len)
          maxl_runtime = runtime_len;

        int vruntime_len = getleni(p->vruntime);
        if (maxl_vruntime < vruntime_len)
          maxl_vruntime = vruntime_len;
      }
    }
  }

  if (maxl_runtime < 6)
    maxl_runtime = 6;
  if (maxl_vruntime < 6)
    maxl_vruntime = 6;
  int name_range = ((maxl_name / 6) + 1) * 6;
  int runtime_range = ((maxl_runtime / 6) + 1) * 6;
  int vruntime_range = ((maxl_vruntime / 6) + 1) * 6;

  cprintf("name");
  for (int i = 0; i < (name_range - 4); i++)
    cprintf(" ");
  cprintf("pid      ");
  cprintf("state       ");
  cprintf("priority    ");
  cprintf("runtime/weight    ");
  cprintf("runtime");
  for (int i = 0; i < (runtime_range - 7); i++)
    cprintf(" ");
  cprintf("vruntime");
  for (int i = 0; i < (vruntime_range - 8); i++)
    cprintf(" ");
  cprintf("tick %d", ticks * 1000);
  cprintf("\n");

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if ((pid == 0) || (p->pid == pid))
    {
      if (p->state != 0)
      {

        cprintf("%s", p->name);
        int l1 = getlens(p->name);
        for (int i = 0; i < (name_range - l1); i++)
          cprintf(" ");

        cprintf("%d", p->pid);
        int l2 = getleni(p->pid);
        for (int i = 0; i < (9 - l2); i++)
          cprintf(" ");

        cprintf("%s", states[p->state]);
        int l3 = getlens(states[p->state]);
        for (int i = 0; i < (12 - l3); i++)
          cprintf(" ");

        cprintf("%d", p->nice);
        int l4 = getleni(p->nice);
        for (int i = 0; i < (12 - l4); i++)
          cprintf(" ");

        cprintf("%d", p->run_d_w);
        int l5 = getleni(p->run_d_w);
        for (int i = 0; i < (18 - l5); i++)
          cprintf(" ");

        cprintf("%d", p->runtime);
        int l6 = getleni(p->runtime);
        for (int i = 0; i < (runtime_range - l6); i++)
          cprintf(" ");

        cprintf("%d", p->vruntime);
        int l7 = getleni(p->vruntime);
        for (int i = 0; i < (vruntime_range - l7); i++)
          cprintf(" ");
        cprintf("\n");
      }
    }
  }
  release(&ptable.lock);
  return;
}

uint mmap(uint addr, int length, int prot, int flags, int fd, int offset)
{
  // cprintf("addr: %d, length: %d, prot: %d, flags: %d, fd: %d, offset: %d\n", addr, length, prot, flags, fd, offset);

  struct proc *p = myproc();
  uint start_addr = addr + MMAPBASE;

  // cprintf("start_addr : %d\n",start_addr);

  struct file *f = 0;
  if (fd != -1)
  {
    f = p->ofile[fd];
  }

  int anony = 0;
  int populate = 0;
  int prot_read = 0;
  int prot_write = 0;
  char *mem = 0;

  if (flags & MAP_ANONYMOUS)
    anony = 1;
  if (flags & MAP_POPULATE)
    populate = 1;
  if (prot & PROT_READ)
    prot_read = 1;
  if (prot & PROT_WRITE)
    prot_write = 1;

  // cprintf("prot & PROT_READ: %d prot & PROT_WRITE: %d\n", prot & PROT_READ, prot & PROT_WRITE);

  if ((!anony) && (fd == -1))
  {
    // cprintf("error It's not anonymous, but when the fd is -1\n");
    return 0;
  }
  if (f != 0)
  {
    if (!(f->readable) && prot_read)
    {
      // cprintf("error protection of the file and the prot of the parameter are different\n");
      return 0;
    }
    if (!(f->writable) && prot_write)
    {
      // cprintf("error protection of the file and the prot of the parameter are different\n");
      return 0;
    }
  }

  int i = 0;
  while (ma[i].is_used != 0)
  {
    i++;
  }

  if (f)
  {
    f = filedup(f);
  }

  ma[i].f = f;
  ma[i].addr = start_addr;
  ma[i].length = length;
  ma[i].offset = offset;
  ma[i].prot = prot;
  ma[i].flags = flags;
  ma[i].p = p;
  ma[i].is_used = 1;

  if ((!anony) && (!populate))
  {
    // cprintf("it's not ANONY, not POPULATE\n");
    return start_addr;
    // to page fault, late phy mem alloc
  }

  if ((anony) && (!populate))
  {
    // cprintf("it's ANONY, not POPULATE\n");
    return start_addr;
    // to page fault, late phy mem alloc
  }

  if ((!anony) && (populate))
  {
    // cprintf("it's not ANONY, POPULATE\n");
    f->off = offset;
    uint ptr = 0;

    for (ptr = start_addr; ptr < start_addr + length; ptr += PGSIZE)
    {
      mem = kalloc();
      if (!mem)
        return 0;
      memset(mem, 0, PGSIZE);
      fileread(f, mem, PGSIZE);
      int perm = prot | PTE_U;
      int ret = mappages(p->pgdir, (void *)(ptr), PGSIZE, V2P(mem), perm);
      if (ret == -1)
        return 0;
    }
    return start_addr;
  }

  if ((anony) && (populate))
  {
    // cprintf("it's ANONY, POPULATE\n");
    uint ptr = 0;
    for (ptr = start_addr; ptr < start_addr + length; ptr += PGSIZE)
    {
      mem = kalloc();
      if (!mem)
        return 0;
      memset(mem, 0, PGSIZE);
      int perm = prot | PTE_U;
      int ret = mappages(p->pgdir, (void *)(ptr), PGSIZE, V2P(mem), perm);
      if (ret == -1)
        return 0;
    }
    return start_addr;
  }

  return start_addr;
}

int pfh(uint addr, uint err)
{
  struct proc *p = myproc();
  int find_idx = -1;

  for (int t = 0; t < 64; t++)
  {
    if (((ma[t].addr + ma[t].length) > addr) && (addr >= ma[t].addr))
    {
      if ((ma[t].p == p) && (ma[t].is_used == 1))
      {
        find_idx = t;
        break;
      }
    }
  }

  if (find_idx == -1)
  {
    // cprintf("pfh error: no such address!\n");
    return -1;
  }

  int anony = 0;
  int prot_write = 0;
  char *mem = 0;

  if (ma[find_idx].flags & MAP_ANONYMOUS)
    anony = 1;
  if (ma[find_idx].prot & PROT_WRITE)
    prot_write = 1;

  // can't write(it is read) but try to write
  if ((prot_write == 0) && ((err & 2) != 0))
  {
    // cprintf("error: can't write but try to write\n");
    return -1;
  }

  cprintf("\npage fault ... %x\n", addr);

  uint start_addr = ma[find_idx].addr;
  uint length = ma[find_idx].length;
  uint ptr = 0;

  if (!anony)
  {
    // cprintf("\tit's not ANONY, POPULATE\n");
    struct file *f = ma[find_idx].f;
    f->off = ma[find_idx].offset;
    for (ptr = start_addr; ptr < start_addr + length; ptr += PGSIZE)
    {
      if ((ptr <= addr) && (addr < ptr + PGSIZE))
      {
        mem = kalloc();
        if (!mem)
          return 0;
        memset(mem, 0, PGSIZE);
        fileread(f, mem, PGSIZE);
        int perm = ma[find_idx].prot | PTE_U;
        if (prot_write)
          perm = perm | PTE_W;
        int ret = mappages(p->pgdir, (void *)ptr, PGSIZE, V2P(mem), perm);
        if (ret == -1)
          return 0;
      }
      f->off += PGSIZE;
    }
  }
  else
  {
    // cprintf("it's ANONY, POPULATE\n");
    for (ptr = start_addr; ptr < start_addr + length; ptr += PGSIZE)
    {
      if ((ptr <= addr) && (addr < ptr + PGSIZE))
      {
        mem = kalloc();
        if (!mem)
          return 0;
        memset(mem, 0, PGSIZE);
        int perm = ma[find_idx].prot | PTE_U;
        if (prot_write)
          perm = perm | PTE_W;
        int ret = mappages(p->pgdir, (void *)ptr, PGSIZE, V2P(mem), perm);
        if (ret == -1)
          return 0;
      }
    }
  }

  return 0;
}

int munmap(uint addr)
{
  struct proc *p = myproc();
  int find_idx = -1;

  for (int t = 0; t < 64; t++)
  {
    if (addr == ma[t].addr)
    {
      if ((ma[t].p == p) && (ma[t].is_used == 1))
      {
        find_idx = t;
        break;
      }
    }
  }

  if (find_idx == -1)
  {
    // cprintf("error: unmap no such address!\n");
    return -1;
  }

  uint ptr = 0;
  pte_t *pte;

  for (ptr = addr; ptr < addr + ma[find_idx].length; ptr += PGSIZE)
  {
    pte = walkpgdir(p->pgdir, (char *)(ptr), 0);
    if (!pte)
      continue; // page fault has not been occurred on that address, just remove mmap_area structure.
    if (!(*pte & PTE_P))
      continue;
    uint paddr = PTE_ADDR(*pte);
    char *v = P2V(paddr);
    kfree(v);
    *pte = 0;
  }
  ma[find_idx].f = 0;
  ma[find_idx].addr = 0;
  ma[find_idx].length = 0;
  ma[find_idx].offset = 0;
  ma[find_idx].prot = 0;
  ma[find_idx].flags = 0;
  ma[find_idx].p = 0;
  ma[find_idx].is_used = 0;
  return 1;
}

int freemem()
{
  return freememCount();
}