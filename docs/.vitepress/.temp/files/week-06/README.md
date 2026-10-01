# Week 06 — Bytes to instructions: starting an 8086 decoder

<!-- companion-navigation -->
**[Read the full Week 6 companion chapter](../docs/content/weeks/week-06.md).** Learn how a specified sequence of bytes becomes instruction text. The companion explains fields, widths, byte order, status precedence, and evidence from independent witnesses.

The chapter is designed for programmers new to systems concepts. Run the VitePress site from the repository root to see imported exercise contracts, source listings, readings, hints, and separate solution pages. The original package instructions and requirements below remain authoritative.
<!-- /companion-navigation -->

Build an **8086 subset decoder notebook**: seven C exercises that go from the bit fields of one byte to a command, `decode8086`, which turns a file of machine code into NASM-compatible text. The subset is `mov`, `add`, `sub` and `cmp` with register and immediate operands. Memory operands and displacements are week 7, and simulation is weeks 8–10.

The C lessons are exact:

- read bytes with unsigned types;
- extract fields with shifts and masks;
- assemble little-endian values independently of the host's byte order;
- read a two's-complement pattern without an implementation-defined conversion;
- decode a stream with bounds checks and explicit statuses.

The architectural lesson: decoding is a function from bytes to text, but assembling is not its inverse, because one text can have several encodings. **Hand-decode before you run.** This week makes no timing or performance claim.

Prerequisites are [week five](../week-05/README.md) (a multi-file program with a contract), [week four](../week-04/README.md) (strict parsers with ordered error classes and bounded reading), and weeks 1–2 (bit operations, object representation and byte order). Week 5's closing question, “which machine instructions does the distance loop actually execute?”, motivates the section. The [course syllabus](../PLAN.md) gives the sequence, and the [week-six specification](PLAN.md) records every requirement and the corrections found while implementing it.

## Working through the package

Use x86-64 Linux/WSL with GCC, Clang, make, Python 3 and binutils. `objdump` with `i8086` support is used as a cross-check; it is present on the reference Ubuntu image, and the check is skipped with a message where it is not. From `week-06`:

```sh
make                              # warning-clean learner scaffolds
make test                         # fails until you implement the TODO functions
make CC=clang MODE=optimized test
make symbols                      # external symbols of decode.o and decode8086.o
python3 tools/hex2bin.py t.bin 89 d9 83 c6 fe && build/learner/gcc/debug/decode8086 t.bin
objdump -D -b binary -m i8086 -M intel t.bin
```

Read [the exercise contracts](learner/exercises.md), work in [learner/src](learner/src), add your cases to [learner/cases.txt](learner/cases.txt) (E07), and complete [the notebook](learner/observations.md). [Practice and stretch work](learner/practice.md) extends the reasoning, and [the rubric](rubric.md) explains assessment.

E01–E05 are standalone `exNN.c` files with supplied drivers. Later exercises copy the helpers you wrote earlier; the copies stay non-static, so an unused copy does not break `-Werror`. E06 assembles them into [decode.c](learner/src/decode.c) behind the supplied [decode.h](learner/src/decode.h). The command `decode8086` is built from `decode.c` and [decode8086.c](learner/src/decode8086.c), whose argument handling and printing are supplied. **Record your hand decodings (E07) and your longest-text prediction (E05) before you run anything.**

**The oracles.** [tests/oracle8086.py](tests/oracle8086.py) builds its expectations in the **encoding** direction: from operands to bytes, never by decoding. Failures are classified by a separate documented rule table. Its course table was checked entry by entry against the 1979 Intel manual. `objdump` is a second, toolchain-level witness with its own conventions: unsigned hexadecimal immediates, and acceptance of `0x82`. The tests compare against both. You explain them; you do not write another decoder or an encoder. Fixed expected text is legitimate here, because the instruction encoding is fully specified and platform-independent.

Reference flags are `-std=c11 -Wall -Wextra -Wpedantic -Werror` at `-O0` and `-O2`, with sanitizers in instructor verification. The reference solution also builds with `-Wconversion -Wsign-conversion`.

## Readings and workload

Links were checked on 2026-09-22. CE is subscription material; the subset, output format, test listings and decoder here are original, and the paid episodes' homework and reference decoder are not reproduced.

| Resource | Assigned portion | Purpose |
| --- | --- | --- |
| [CE: Instruction Decoding on the 8086](https://www.computerenhance.com/p/instruction-decoding-on-the-8086) | Full episode, 28:28, duration from the [official TOC](https://www.computerenhance.com/p/table-of-contents) | Registers, the register-to-register `mov` encoding, and the `d` and `w` bits. |
| [CE: Decoding Multiple Instructions and Suffixes](https://www.computerenhance.com/p/decoding-multiple-instructions-and) | Full episode, 43:51 | Variable-length instructions, immediates and the `mod` field. Memory modes are watched now and implemented in week 7. |
| [CE: Opcode Patterns in 8086 Arithmetic](https://www.computerenhance.com/p/opcode-patterns-in-8086-arithmetic) | Full episode, 20:01 | The shared encoding patterns of `add`, `sub` and `cmp`. Its conditional jumps are the optional stretch S01. |
| [Intel, The 8086 Family User's Manual (October 1979)](http://www.bitsavers.org/components/intel/8086/9800722-03_The_8086_Family_Users_Manual_Oct79.pdf) | Table 4-7 (single-bit fields, p. 4-19); Tables 4-8 to 4-10 (MOD, REG and R/M fields, p. 4-20); Table 4-12 (instruction encoding: MOV p. 4-22, ADD p. 4-23, SUB and CMP p. 4-24); Table 4-13 (machine instruction decoding guide, pp. 4-27 to 4-33) | The primary reference for every encoding in the subset. |
| [C11 draft N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) | §6.2.6.1 (object representations), §6.3.1.1 (integer promotions), §6.3.1.3 (conversions to signed types), §6.5.7 (shifts), §7.20.1.1 (exact-width types), §7.21.7.1 and 7.21.10 (`fgetc`, `feof`, `ferror`) | The C side of decoding. |
| [GNU binutils: objdump](https://sourceware.org/binutils/docs/binutils/objdump.html) | `-D`, `-b binary`, `-m i8086`, `-M intel` | The toolchain cross-check. |

Required viewing is about 92 minutes, plus about 33 minutes with the manual's tables and the C11 clauses, for about **125 minutes**. The **core target is ten hours**:

| Activity | Minutes |
| --- | ---: |
| Readings | 125 |
| Setup | 15 |
| E01–E07 (30, 25, 40, 80, 45, 55, 40) | 315 |
| Report | 55 |
| Practice | 45 |
| Debugging | 45 |

The playground is part of E07's time, and stretch work is additional. **This estimate has not been piloted with learners.** Record overruns rather than cutting correctness or explanations to fit it.

## Instructor entry

[Instructor materials](instructor/README.md) contain spoilers: annotated reference C, the complete written answers, an exemplar notebook, the exemplar E07 cases, the S01/S02 programs and the mutation check. `make verify` runs six reference configurations (both compilers, debug/optimized/sanitized) and then the learner-scaffold check. The [validation record](instructor/validation.md) holds the manual cross-check with table and page numbers, and the execution evidence.
