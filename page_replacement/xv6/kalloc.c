// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"

uint freememC;

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld

struct run
{
  struct run *next;
};

struct
{
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
} kmem;

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}

void kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
}

void freerange(void *vstart, void *vend)
{
  char *p;
  p = (char *)PGROUNDUP((uint)vstart);
  for (; p + PGSIZE <= (char *)vend; p += PGSIZE)
    kfree(p);
}
// PAGEBREAK: 21
//  Free the page of physical memory pointed at by v,
//  which normally should have been returned by a
//  call to kalloc().  (The exception is when
//  initializing the allocator; see kinit above.)
void kfree(char *v)
{
  struct run *r;

  if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
  freememC++;

  if (kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run *)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if (kmem.use_lock)
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char *
kalloc(void)
{
  struct run *r;
  freememC--;

try_again:
  if (kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;

  if (!r)
  {
    if (kmem.use_lock)
      release(&kmem.lock);
    if (reclaim())
    {
      goto try_again;
    }
    else
    {
      cprintf("error: OOM!\n");
      return 0;
    }
    if (kmem.use_lock)
      acquire(&kmem.lock);
  }

  if (r)
    kmem.freelist = r->next;
  if (kmem.use_lock)
    release(&kmem.lock);
  return (char *)r;
}

int freememCount(void)
{
  return freememC;
}

int find_free_page()
{
  int i;
  for (i = 0; i < PHYSTOP / PGSIZE; i++)
  {
    if (pages[i].vaddr == 0 && pages[i].pgdir == 0)
    {
      break;
    }
  }
  if (i == PHYSTOP / PGSIZE)
  {
    return -1;
  }
  return i;
}

int find_page(pde_t *pgdir, char *va)
{
  int i;
  for (i = 0; i < PHYSTOP / PGSIZE; i++)
  {
    if (pages[i].pgdir == pgdir && pages[i].vaddr == va)
    {
      break;
    }
  }
  if (i == PHYSTOP / PGSIZE)
  {
    return -1;
  }
  return i;
}

void manage_pages(int ope, pde_t *pgdir, char *va)
{
  if (ope == 1)
  { // add ------------------------------------------

    int idx = find_free_page();
    if (idx == -1)
      return;
    struct page *tmp = &pages[idx];

    if (num_lru_pages == 0)
    { // first add
      page_lru_head = tmp;
      tmp->vaddr = va;
      tmp->pgdir = pgdir;
      tmp->prev = page_lru_head;
      tmp->next = page_lru_head;
    }
    else
    {
      // print_lru();
      tmp->vaddr = va;
      tmp->pgdir = pgdir;

      struct page *cur = page_lru_head;
      while (cur->next != page_lru_head)
      {
        cur = cur->next;
      }

      tmp->next = page_lru_head;
      page_lru_head->prev = tmp;

      tmp->prev = cur;
      cur->next = tmp;
    }
    num_lru_pages++;
    num_free_pages--;
  }

  if (ope == 0)
  { // remove --------------------------------------------------
    // cprintf("remove %x %x\n", pgdir, va);
    int idx = find_page(pgdir, va);
    if (idx == -1)
      return;
    struct page *tmp = &pages[idx];
    // cprintf("temp %x %x %x\n", tmp, tmp->pgdir, tmp->vaddr);
    if (!tmp)
    {
      // cprintf("tmp is zero\n");
      return;
    }
    // cprintf("tmp is not zero\n");
    if (num_lru_pages == 1)
    {
      tmp->vaddr = 0;
      tmp->pgdir = 0;
      tmp->prev = 0;
      tmp->next = 0;
      page_lru_head = 0;
    }
    else
    {
      struct page *prev_tmp = tmp->prev;
      struct page *next_tmp = tmp->next;
      prev_tmp->next = next_tmp;
      next_tmp->prev = prev_tmp;

      if (tmp == page_lru_head)
      {
        page_lru_head = page_lru_head->next;
      }

      tmp->vaddr = 0;
      tmp->pgdir = 0;
      tmp->prev = 0;
      tmp->next = 0;
    }
  }
  // print_lru();
}

int reclaim()
{
  // cprintf("\nreclaim().... now head is : pgdir: %x pgaddr: %x --------------------- \n", page_lru_head->pgdir, page_lru_head->vaddr);
  if (num_lru_pages == 0)
  {
    return 0;
  }
  // print_lru();

  int find = 0;
  pte_t *pte;
  char *va;
  pde_t *pgdir;

  while (!find)
  {

    va = page_lru_head->vaddr;
    pgdir = page_lru_head->pgdir;
    pte = walkpgdir(pgdir, va, 0);

    if (*pte & PTE_A)
    { // 한번 넘어감
      // cprintf("pgdir: %x pgaddr: %x is PTE_A ok .. pass\n", page_lru_head->pgdir, page_lru_head->vaddr);
      *pte = ((*pte) & (~PTE_A));
      page_lru_head = page_lru_head->next;
    }
    else
    {
      // cprintf("pgdir: %x pgaddr: %x is PTE_A not ok .. find!\n", page_lru_head->pgdir, page_lru_head->vaddr);
      find = 1;
    }
  }

  // evict 시작
  num_lru_pages--;
  num_free_pages++;

  struct page *old_head = page_lru_head;
  struct page *prev_head = page_lru_head->prev;
  page_lru_head = page_lru_head->next;

  prev_head->next = page_lru_head;
  page_lru_head->prev = prev_head;

  pte = walkpgdir(old_head->pgdir, old_head->vaddr, 0);
  // cprintf("old_head->pgdir: %x old_head->vaddr: %x\n",old_head->pgdir,old_head->vaddr);

  uint pa = PTE_ADDR(*pte);
  int offset = find_free_offset();
  bitmap[offset] = 1;
  // cprintf("offset: %x P2V(pa): %x\n",offset,P2V(pa));
  swapwrite((char *)P2V(pa), offset);
  kfree(P2V(pa));
  // cprintf("\npte=%x\n", *pte);

  *pte = ((*pte) & (~PTE_P));
  *pte = (*pte & 0xfff) | (offset << 12);

  // cprintf("\npte=%x\n", *pte);
  old_head->vaddr = 0;
  old_head->pgdir = 0;
  old_head->prev = 0;
  old_head->next = 0;
  // print_lru();
  return 1;
}