# Week 8 validation

Checked on 2026-09-30 on x86-64 Linux under WSL2, using GCC 11.4.0, Clang 14.0.0, GNU Make 4.3, Python 3.10.12 and binutils 2.38. Site generation used Node 24.19.0 and VitePress 1.6.4 on Windows.

## Executed checks

- `make verify` passed GCC and Clang in debug, optimized and address/undefined sanitizer modes, plus both learner scaffold builds and their expected correctness failures. Reference and learner code use C11, Wall/Wextra/Wpedantic/Werror and Wconversion/Wsign-conversion. Sanitizer executables use `-no-pie` on the reference Linux toolchain. Local logs are retained under the ignored build directory.
- Each of the six configurations passed 209328 independent arithmetic cases: all byte pairs for ADD/SUB/CMP, the documented word boundary grid and deterministic word samples. The Python oracle derives flags mathematically rather than copying the reference C sign-bit formulas.
- Contracts passed all 512 operation/width/register-source/register-destination combinations, overlapping byte aliases, MOV flag preservation, CMP non-write, opaque flag-bit preservation, malformed requests, memory rejection, 83 sign extension, IP wrap, separate file progress and late whole-program rollback.
- Every configuration passed sixteen independently constructed immediate-program traces, the hand-derived seven-instruction golden program, the four-step playground and the CLI error cases. The three warm-ups passed their exhaustive finite byte/alias domains.
- The optional C predicate solution compiled and ran with GCC and Clang, confirming the distinction between signed and unsigned comparisons without implementing guest branches.
- `objdump -D -b binary -m i8086 -M intel build/program.bin` agreed with the golden fixture's MOV/ADD/CMP/SUB descriptions and starts at offsets 0, 3, 5, 7, 9, 11 and 14. The final encoded extent is 16 bytes. Tool hexadecimal immediates correspond to the course's signed decimal patterns; this comparison checks decoding, not simulation flags.
- `python3 tools/docs/verify-examples.py` passed the new standalone beginner snippet's source and exact displayed output with GCC/Clang at `-O0` and `-O2`, along with existing beginner examples.
- `python3 tools/docs/check_readings.py` passed 323 section records (211 checked against local PDFs), 173 Muratori items and 220 cross-reference rows across 52 weeks. Week 8 now has a complete mapped cross-reference for both CE episodes and all seven companion texts.
- `npm run docs:check` passed eight lessons, 261 prompt/answer pairs and 771 generated Markdown pages. Production documentation validation checks rendered links, fragments/assets and exclusion of solution routes from search.

CE direct pages and durations were checked against the official TOC. The ADD/SUB/CMP episode's actual slug is `simulating-add-jmp-and-cmp`; its title remains ADD/SUB/CMP. Book section IDs, titles and pages use the verified registry. Historical Intel instruction headings are paired with the official modern Intel manual index as a flag-semantics cross-reference; modern encodings are not added to this course subset.

## Corrections and limits

The expanded register-combination harness initially relied on integer promotion before a shift. GCC's sanitizer build exposed a sign-conversion warning; explicit uint32_t widening corrected it and the complete gate then passed. Citation validation rejected guessed CS 341 IDs before publication; the final map uses the existing verified C data types, Common Bugs and Undefined Behavior Sanitizer sections.

The mathematical oracle enumerates every byte operand pair, but samples word pairs and programs. Passing arithmetic checks alone does not establish alias writes or program sequencing; separate contract and trace checks cover those mechanisms. No guest branches, memory, interrupts, cycle estimation or modern microarchitecture are modeled. Opaque flag bits are preserved, not implemented, and CLI zero initialization is a course convention. No learner pilot or interactive browser review was performed.
