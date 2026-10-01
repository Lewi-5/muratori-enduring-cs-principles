# Warm-up and check-yourself answers

### W01

Use one swap only when a.key>b.key; equality makes no swap, preserving tag order. Reject NULL before touching either item. Aliased a==b is harmless, but caller objects must be accessible. Tags do not participate in the key comparison.

### W02

Check pass<4 before shifting by pass*8. Mask the unsigned shifted value with 255. Numeric digits are independent of object endian order. Invalid pass or NULL fails without writing; a shift by 32 would be undefined for this 32-bit value.

### W03

Check out and count<=SIZE_MAX/sizeof(Item) before multiplying. Zero is a valid zero-byte count. Preserve the old output on failure. A successful arithmetic check only establishes representable bytes; it does not establish allocation success or available physical memory.

Check yourself: Ordered output can lose records; compare records against the oracle. Equal keys must retain original input order. Four uint32_t passes sort all digits; signed and floating keys need different explicitly specified mappings. Representable workspace bytes do not guarantee allocation success.
