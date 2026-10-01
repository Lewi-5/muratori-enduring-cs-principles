# Warm-up answers

### W01

Check mode and rm first. Mode one always consumes one byte; mode two always consumes two. Mode zero consumes two only for rm six and otherwise consumes zero. w is absent because data width does not determine address width. The decoder describes an offset in the 8086 address space even for byte-sized data. w01.c implements the table; the warm-up harness covers all accepted pairs and invalid boundaries.

### W02

Unsigned raw 0..127 already represents its signed value. Values 128..255 subtract 256, so 128 becomes -128 and 255 becomes -1. FE becomes -2. The two-byte direct address FE FF is instead unsigned 254+256×255=65534. The encoding field determines which interpretation to use. w02.c implements the conversion and all 256 values are checked.

### W03

Reject offset above total, then compare length with total-offset. Only after that proof can offset+length be formed without exceeding total or overflowing size_t. Reject zero length to guarantee progress. The next instruction begins after the previous encoding, including displacement and immediate tails; a bad length can reinterpret a tail byte as a new opcode. w03.c commits once, and tests include exact end, one past end, SIZE_MAX and zero-length failures.
