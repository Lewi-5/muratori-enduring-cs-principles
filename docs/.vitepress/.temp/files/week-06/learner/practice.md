# Practice (ungraded) and stretch work (optional)

Answers are in the instructor package. Work each problem before you look.

### P01

Classify each statement as an ISO C guarantee, implementation-defined behavior, an 8086 ISA fact, or false in general, and justify each with a clause, a manual table or a counterexample:

1. `(int16_t)0xFFF4` is −12 on every C implementation.
2. `uint8_t` exists on every C implementation.
3. The 8086 stores the low byte of a 16-bit immediate first.
4. `(b0 | (b1 << 8))` with `uint8_t` operands depends on the host's byte order.
5. The 8086 register field value 4 always names `sp`.

### P02

By hand, decode these five sequences in the subset. For each, show the opcode bits, `d`/`w`/`s`, `mod`/`reg`/`r/m`, the immediate bytes and the length, then write the canonical text. Compare with `decode8086` afterwards.

1. `B9 0C 00`
2. `29 D8`
3. `3C 7F`
4. `81 EE 00 01`
5. `02 E3`

### P03

Encode by hand. Give every encoding *in the course subset* of each instruction, and say which is shortest:

1. `mov ax, bx`
2. `add cl, 5`
3. `cmp si, -1`
4. `sub al, 200`

If `200` is not representable as the operand's signed value, say what the canonical text of the encoded instruction must be instead.

### P04

Decode two memory-mode ModR/M bytes as far as the fields go: `88 07` (`mod = 00`) and `89 5E 02` (`mod = 01`). State what information week 7 must add to finish them, and why this week's decoder must reject them rather than guess their length.

### P05

Explain, with the stream `B8 89 D9`, why decoding from offset 1 instead of offset 0 can produce a different but valid-looking instruction sequence. What does this imply for a disassembler that starts in the middle of code?

### P06

Run `objdump -d -M intel` on week 5's `geo.o` (x86-64). Find a `mov` whose opcode byte is `0x89` or `0x8B`, if the build contains one, and identify its ModR/M byte and any REX prefix.

If neither opcode occurs, record that observation. Then disassemble the supplied three-byte binary [fixtures/x64_mov.bin](../fixtures/x64_mov.bin) (`48 89 D8`) with `objdump -D -b binary -m i386:x86-64 -M intel` and do the same byte-field analysis.

Label x86-64 ISA facts (cite the Intel SDM). Call a finding a compiler-output observation only when it came from `geo.o`.

### S01

**Conditional jumps and loops.** Extend `decode_one` to the twenty short-branch opcodes, `0x70`–`0x7F` and `0xE0`–`0xE3`, each followed by a signed 8-bit displacement. Print the target relative to the start of the instruction, NASM-style: `75 FC` prints `jnz $-2`. Derive that conversion from the fact that the displacement is relative to the *next* instruction. State which mnemonic of each alias pair you print. Test against the oracle's branch table and against `objdump`, which prints absolute targets and some other aliases.

### S02

**A decoding table.** Replace E04's branch structure with a 256-entry table indexed by the first byte: the form, the operation, and where the width comes from. Compare the two decoders exhaustively:

- on all two-byte prefixes;
- on all 8-bit immediate values;
- on all 65,536 16-bit immediate values for each applicable form, or give a reasoned proof that both use identical byte assembly, sign conversion and formatting over the full 16-bit domain.

A two-byte-prefix test alone does not prove equivalence for later immediate bytes. Discuss the trade-off between the manual's bit patterns and a table, without making a speed claim.
