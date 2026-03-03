module memory;

import types;
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

<* WRITE implies READ as well. *>
enum Access: char {
  NONE,
  READ,
  WRITE,
}

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
}

fn void Pool.init(&self, uint page_count = 0) {
  self.pages.init_for_type(mem, Page, page_count);
}

fn void Pool.clean_pool(&self) {
  self.pages.free();
}

fn Page* Pool.acquire(&self, Access access = Access.NONE) {
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
