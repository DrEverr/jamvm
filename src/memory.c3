module memory;

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
  WIRTE,
}
