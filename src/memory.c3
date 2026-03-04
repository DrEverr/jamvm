module memory;

import types;
import std::collections::map;
import std::core::mem;
import std::core::mem::mempool;
import std::io;

const PAGE_SIZE = 4096;
const PAGE_SIZE_SHIFT = 12;
const SEGMENT_SIZE = 65536;
const SEGMENT_SIZE_SHIFT = 16;
<* First 64 KB is inaccesible guard. *>
const RESERVED_MEMORY = 65536;
<* Full 32-bit address space. *>
const MEMORY_SIZE = 0x1_0000_0000;
const MAX_PAGES = MEMORY_SIZE / PAGE_SIZE;

<* WRITE implies READ as well. *>
enum Access: char {
  NONE,
  READ,
  WRITE,
}

alias PageIndex = uint;
alias Pages = HashMap { PageIndex, Page* };

<* Single Page implementation *>
struct Page {
  Access access;
  Byte[PAGE_SIZE] data;
}

fn bool Page.can_read(&self) {
  return self.access != Access.NONE;
}

fn bool Page.can_write(&self) {
  return self.access == Access.WRITE;
}

<* Pool of preallocated pages backed by std fixed-size block allocator. *>
struct Pool {
  mempool::FixedBlockPool pages;
  uint max_pages;
}

fn void Pool.init(&self, uint page_count = 0, uint max_pages = MAX_PAGES) {
  uint capped_max = max_pages > MAX_PAGES ? MAX_PAGES : max_pages;
  uint capped_count = page_count > capped_max ? capped_max : page_count;
  self.max_pages = capped_max;
  self.pages.init_for_type(mem, Page, capped_count);
}

fn void Pool.clean_pool(&self) {
  self.pages.free();
}

fn Page* Pool.acquire(&self, Access access = Access.NONE) {
  if ((uint)self.pages.used >= self.max_pages) {
    io::printn("ERR: page pool at maximum capacity, cannot acquire more pages.");
    return null;
  }
  if (self.pages.used == self.pages.allocated) {
    io::printn("WARN: page pool exhausted, allocating a new page chunk.");
  }
  Page* page = (Page*)self.pages.alloc();
  page.access = access;
  return page;
}

fn void Pool.release(&self, Page* page) {
  if (!page) return;
  // Clear all page bytes before putting it back on the freelist.
  mem::clear(&page.data, PAGE_SIZE);
  page.access = Access.NONE;
  self.pages.dealloc(page);
}

fn uint Pool.allocated(&self) {
  return (uint)self.pages.allocated;
}

fn uint Pool.in_use(&self) {
  return (uint)self.pages.used;
}

struct Memory {
  Pages pages;
  Pool pool;
  PageIndex sbrk;
  PageIndex max_address;
}

fn Memory init_memory(uint page_count = 0, PageIndex sbrk = 0, uint max_pages = MAX_PAGES) {
  Pool pool;
  pool.init(page_count, max_pages);
  PageIndex max_address = max_pages * PAGE_SIZE - 1;
  Memory mem;
  mem.pool = pool;
  mem.max_address = max_address;
  mem.sbrk = sbrk > max_address ? max_address : sbrk;
  return mem;
}

fn void Memory.setData(&self, PageIndex address, Bytes data, Access access = Access.READ) {
  PageIndex addr = address;
  Bytes d = data;
  while (d.len > 0) {
    Page* p = self.getPage(addr);
    p.access = access;
    PageIndex relAddr = addr % PAGE_SIZE;
    uint count = (uint)PAGE_SIZE - relAddr;
    uint len = d.len < count ? d.len : count;
    p.data[relAddr:len] = d[:len];

    addr += len;
    d = d[len..];
  }
}

fn Page* Memory.getPage(&self, PageIndex address) {
  PageIndex idx = address >> PAGE_SIZE_SHIFT;
  if (!self.pages.has_key(idx)) {
    self.pages[idx] = self.pool.acquire();
  }
  return self.pages[idx]!!;
}
