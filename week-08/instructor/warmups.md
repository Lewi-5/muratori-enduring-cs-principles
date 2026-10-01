# Warmups — spoilers

### W01

A numeric AND with 255 preserves bits zero through seven and clears higher bits. It does not inspect the object’s storage bytes. Every word has exactly the remainder modulo 256 in those low bits, so the exhaustive test checks the whole domain. A byte pointer into a uint16_t would instead depend on which byte the host stores first.

### W02

Clear the old high bits by word & 255, shift the new uint8_t value left by eight after widening, then OR the pieces. The result from 1234 and FF is FF34. Widening makes the arithmetic bounds explicit; the shift count is below the chosen width. Tests vary every new high and preserved low byte. Assignment of high alone would erase the low byte.

### W03

The largest sum is 510, which fits the unsigned calculation type on the course target. A carry occurs when the full sum exceeds 255. Thus 127+1 has no carry and 255+1 has carry. Signed overflow asks whether the sum of signed interpretations lies outside -128..127, so it is a different predicate; the first case overflows signed range and the second does not. The warm-up function is intentionally limited to carry. All 65,536 byte pairs are checked.
