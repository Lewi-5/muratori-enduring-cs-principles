# Warm-up answers

### W01

Reference src/w01.c. For p<32768, p is its signed value. Otherwise subtract 65536 in int32_t: 0000→0, 7FFF→32767, 8000→−32768, FFFF→−1. This interprets a width-specific pattern without narrowing an out-of-range value to int16_t. Validate p and output before assigning; tests compare all patterns and sentinel preservation. A faulty approach casts first and relies on host conversion behavior.

### W02

Reference src/w02.c. Validate high<=65535 and SP<=high, then compute unsigned (high−SP)/2. High=256 and SP=250 gives three complete words; an odd difference rounds down because two bytes make a word. The stack accepts odd addresses, but an odd byte distance need not describe a fully balanced sequence of word pushes from that high. This helper counts capacity-derived words and cannot classify their contents as return addresses. A subtraction before validation would wrap and manufacture a huge depth.

### W03

Reference src/w03.c. Widen bytes[1] before shifting by eight and OR it with bytes[0]; assign the uint16_t result after NULL checks. Bytes 34,12 yield word 1234. Numeric operations express guest little-endian format independently of host byte order or alignment. NULL checks do not establish that two bytes are accessible; that extent is part of the caller contract. Exhaustive patterns verify reconstruction; no pointer cast is needed.

## Beginner check-yourself answers

PUSH reserves first because the current SP of an empty stack points just beyond its bytes; writing there would cross high. CALL stores the following IP so RET continues after the completed call. POP removes a word from the live interval without deleting bytes. Guest memory contents and host C object lifetime are separate rules; only a live object may be dereferenced through a valid pointer. INC preserves an existing CF by definition, so reusing all ADD flags would be wrong. These are instruction and language contracts, not timing measurements.
