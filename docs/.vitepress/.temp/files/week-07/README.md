# Week 07 — Memory operands and a decoder API

[Full lesson](../docs/content/weeks/week-07.md) · [Beginner section](../docs/content/beginners/week-07.md) · [Further reading](../docs/content/further-reading/week-07.md)

Extend Week 6's decoder to describe memory operands, then call it across a documented C library boundary. Prerequisites: [Week 6](../week-06/README.md), especially E04–E06; [Week 2](../week-02/README.md), especially E09. The [course plan](../PLAN.md) governs the sequence and [this week's plan](PLAN.md) records acceptance requirements.

Objectives: derive instruction length from fields; distinguish signed displacement from unsigned direct address; preserve outputs on failure; separate parsing, formatting and file I/O; compile independent translation units; inspect and run a shared-library client. The original C playground compares four deliberately similar byte sequences. No register state, flags, effective-address evaluation or memory execution is required yet.

## Build and work

On x86-64 Linux/WSL with GCC, Clang, make, Python 3 and binutils:

```sh
cd week-07
make
make test
make CC=clang test
make MODE=optimized test
make MODE=sanitize test
make symbols
```

The default build uses learner sources. It compiles before implementation; correctness checks fail until the TODOs are complete. Week 6's register decoder, two-pass stream function, CLI and playground driver are supplied. E01–E03 implement addressing, extend opcode decoding and format memory operands. E04 completes the independent shared client. E05 integrates the stream and the notebook. Three separate warm-ups support the beginner section.

Read [contracts](learner/exercises.md), [practice](learner/practice.md), [notebook](learner/observations.md) and [rubric](rubric.md). The graded assignment is one package: decoder library, CLI, client, hand-derived cases and notebook. Commit code and evidence, including predictions made before running. [Instructor materials](instructor/README.md) are separate spoilers.

## Exact scope and conventions

Preserve Week 6's B0–BF register-immediate MOV; 88–8B MOV; 00–03 ADD, 28–2B SUB, 38–3B CMP; accumulator-immediate 04/05, 2C/2D, 3C/3D; and group 80/81/83 with /0 ADD, /5 SUB, /7 CMP. Extend every ModR/M form to modes 00, 01 and 10. Add C6/C7 /0 MOV immediate-to-register-or-memory and A0–A3 direct-address accumulator MOV. The longest accepted instruction is six bytes.

Other opcodes, including 82, segment overrides, other prefixes, segment-register MOV, jumps and memory execution remain outside this package. Prefixes are rejected as unsupported opcodes at their own starting offset. This is a course subset choice, not a statement that those encodings are invalid 8086 instructions. The 1979 manual includes 82; our subset intentionally excludes it. Segment defaults are discussed in P04, with no segment state in the decoder API.

Address formulas indexed by r/m: `bx + si`, `bx + di`, `bp + si`, `bp + di`, `si`, `di`, `bp`, `bx`. Mode 00 has zero displacement except r/m=6, which reads an unsigned direct 16-bit address. Mode 01 reads one signed byte; mode 10 reads two signed bytes. Mode 11 uses Week 6's width-dependent registers. Address registers stay 16-bit even when data is a byte. Displacement precedes immediate. Direction chooses operand order.

Text is lower case, signed decimal immediates, unsigned decimal direct addresses, and bracketed formulas. Omit zero displacement; use ` + N` or ` - N` for nonzero displacement. Memory-immediate forms explicitly print `byte` or `word`; register width disambiguates the other forms. No claim of preserving the original encoding is made. `mov ax, [bp]` can have an encoded zero displacement. NASM-style text is a course convention; objdump prints a different syntax.

The [public header](include/decode.h) documents ownership, aliasing, capacities, return values, version and error precedence. There is no allocation, I/O, hidden mutable state or process exit in the library. Scalar outputs and buffers must not overlap. Library and clients must use this header and compatible ABI. Version 7 is a deliberate new layout, not binary compatibility with Week 6.

The CLI inherits Week 6's 65,536-byte cap and read/write diagnostics. It validates the entire input before writing stdout. A failed output write may leave a partial output and is reported separately. Argument, input and decode failures exit nonzero; byte failures name the first byte of the failing instruction. The library's stream function itself has no input cap.

## Read and watch

Direct CE links and durations and HH indexed segments checked against the official guides on 2026-09-30. CE is a required subscription resource; course code and explanations are original. Required viewing: 110:15 total. Optional function-pointer segment adds 10:17. Consult the Intel and C references during exercises rather than reading entire manuals.

- [CE: 8086 Decoder Code Review](https://www.computerenhance.com/p/8086-decoder-code-review): Full, 1:17:49. Review field-driven decoding and the separation of instruction description from presentation.
- [CE: Using the Reference Decoder as a Shared Library](https://www.computerenhance.com/p/using-the-reference-decoder-as-a): Full, 8:48. Watch for the C boundary and client/library responsibilities; build our original library.
- [HH Chat 013: Translation Units, Function Pointers, Compilation, Linking, and Execution](https://guide.handmadehero.org/chat/chat013/): 15:39–32:42 (compilation and translation units); 38:58–45:33 (linking). Optional: 1:39:15–1:49:32 (function pointers). Adapt Windows/C++ examples to C11 and Linux. C11 requires a function declaration before a call; the discussion at 32:42 includes older C behavior.
- [Intel 8086 Family User’s Manual, October 1979](http://www.bitsavers.org/components/intel/8086/9800722-03_The_8086_Family_Users_Manual_Oct79.pdf): Tables 4-8 to 4-10 (MOD, REG and R/M, p. 4-20); Table 4-12 (MOV, ADD, SUB, CMP, pp. 4-22 to 4-24). Authority for address forms, direct-address exception, byte order and displacement widths.
- [C11 draft N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf): §§6.2.2, 6.3.1.3, 6.5.7, 6.9 and 7.21.6.5. Linkage, safe conversions, shifts, external definitions and snprintf.
- [GCC code generation options](https://gcc.gnu.org/onlinedocs/gcc/Code-Gen-Options.html): -fPIC; consult [GNU ld options](https://sourceware.org/binutils/docs/ld/Options.html) for -shared, -rpath and --version-script. Build mechanics are Linux/toolchain contracts, not ISO C promises.

Core target: ten hours for experienced C programmers, unpiloted. Viewing and consultation 125 minutes; E01 55; E02 130; E03 70; E04 55; E05 and report 105; practice and checks 60. Beginner work takes another 2–4 hours. Stretch work is additional. Record actual time and difficulties.

## Mechanism and handoff

Source masks select the mode and r/m fields. The mode controls the following byte count; a helper builds an address description. Formatting turns that description into brackets and signed adjustments. The playground and tests expose both the meaning and the consumed length. Week 8 adds state transitions for register-only operations; Week 9 evaluates address descriptions against register and memory state.
