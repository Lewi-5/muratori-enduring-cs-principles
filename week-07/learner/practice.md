# Practice and stretch

### P01

Fill the complete eight-entry r/m table for modes 00, 01 and 10. Mark the direct exception. Explain why `[bp]` needs a displacement encoding.

### P02

Hand-decode 8A 00, 89 5E 00, C6 06 00 80 FF and A3 FF FF. Give length and operands for each.

### P03

Classify 8B, 8B 06, C7 0E, C7 06 34 12 00 and 26 8B 07 under the public error order. Explain the first insufficient field or scope rejection.

### P04

Which default segment accompanies `[bx + si]`, `[bp + si]` and `[65534]` on the 8086? Does the decoder know their physical addresses?

### P05

A caller overlaps text with its input bytes and invokes decode_stream. Explain the problem and repair. A second caller shares one output buffer between threads. Is a stateless library enough?

### P06

Describe what nm -D, readelf -d and an actual client execution each establish. What happens when a new header adds a field to Operand without rebuilding the library?

### S01

Round-trip semantic forms: compile and run instructor/extras/roundtrip.c after attempting your own version. Compare 8B 40 00 with 8B 80 00 00, then decode the shortest supplied canonical encoding. State whether text, meaning and original bytes are preserved. Optionally assemble the text with NASM if installed; report an unavailable assembler honestly.

### S02

Load the library explicitly with dlopen and resolve decoder_api_version. Attempt this in C, then compare with instructor/extras/load.c. Compile with -ldl; run with an explicit path to your libdecode.so and with a nonexistent library. Explain symbol errors, function pointer lifetime and the C/POSIX boundary.
