# Validation record — week 6

Execution evidence for the week-6 package, run by the implementing agent on 2026-09-22 on x86-64 Ubuntu 22.04 under WSL 2 (kernel 6.18.33.2-microsoft-standard-WSL2), with GCC 11.4.0, Clang 14.0.0, GNU binutils 2.38 (`objdump`) and Python 3.10.12. The checks ran on a copy in the WSL home directory to avoid the slow OneDrive-backed `/mnt/c` checkout.

## The course table against the 1979 manual

Source: Intel, *The 8086 Family User's Manual*, 9800722-03, October 1979. The copy was downloaded from bitsavers' mirror `bitsavers.trailing-edge.com`, because the main site answered `403` to a scripted request. It is 62,967,963 bytes and 748 pages; its OCR text layer was extracted with `pypdf`. Printed page numbers are the manual's own (chapter 4, “Hardware Reference Information”); the OCR text was read line by line.

| Course table entry | Manual | Page | Agrees |
| --- | --- | --- | --- |
| `s`, `w`, `d` meanings: `s = 1` sign-extends an 8-bit immediate to 16 bits if `w = 1`; `w` byte/word; `d = 1` destination in REG | Table 4-7, Single-Bit Field Encoding | 4-19 | yes |
| `mod = 11` is register mode; 00/01/10 are memory modes with 0, 8-bit or 16-bit displacement (with the `r/m = 110` exception) | Table 4-8, MOD Field Encoding | 4-20 | yes |
| REG numbering `al cl dl bl ah ch dh bh` / `ax cx dx bx sp bp si di` | Table 4-9, REG Field Encoding | 4-20 | yes |
| R/M with `mod = 11` uses the same numbering | Table 4-10 | 4-20 | yes |
| A two-byte immediate stores its most significant byte second; REG extends the opcode in the immediate group | text above Table 4-12 | 4-20 | yes |
| `mov` register/memory to/from register `100010dw`; immediate to register `1011 w reg` | Table 4-12, 8086 Instruction Encoding | 4-22 | yes |
| `add` `000000dw`; immediate to register/memory `100000sw` with REG `000`; immediate to accumulator `0000010w` | Table 4-12 | 4-23 | yes |
| `sub` `001010dw`; `100000sw` with REG `101`; accumulator `0010110w` | Table 4-12 | 4-24 | yes |
| `cmp` `001110dw`; `100000sw` with REG `111`; accumulator `0011110w` | Table 4-12 | 4-24 | yes |
| First bytes `00`–`05` (add forms) | Table 4-13, Machine Instruction Decoding Guide | 4-27 | yes |
| First bytes `28`–`2D` (sub forms) | Table 4-13 | 4-28 | yes |
| First bytes `38`–`3D` (cmp forms) | Table 4-13 | 4-29 | yes |
| `80` and `81` rows: ADD, OR, ADC, SBB, AND, SUB, XOR, CMP by REG | Table 4-13 | 4-30 (the `81` rows continue on 4-31) | yes |
| **`82` rows:** ADD, ADC, SBB, SUB and CMP REG8/MEM8,IMMED8 are listed; REG `001`, `100` and `110` are “(not used)” | Table 4-13 | 4-31 | the course rejects `0x82` by scope |
| **`83` rows:** ADD, ADC, SBB, SUB and CMP REG16/MEM16,IMMED8; REG `001`, `100` and `110` are “(not used)” | Table 4-13 | 4-31 | yes; the subset uses only `000`, `101` and `111` |
| `88`–`8B` MOV rows | Table 4-13 | 4-31 | yes |
| `B0`–`BB` MOV register, immediate rows | Table 4-13 | 4-32 | yes |
| `BC`–`BF` | Table 4-13 | 4-33 | yes |

Two findings go beyond the plan:

- The manual marks OR, AND and XOR “(not used)” in **both** `0x82` and `0x83`. The course subset never uses them, so nothing changes, but the answer key mentions it.
- The plan review's statement that the decoding guide lists `0x82` as an 8-bit group-one form is confirmed, with the precision that three of its eight REG values are listed as not used.

## Test matrix

| Command | Result |
| --- | --- |
| `make PACKAGE=instructor test` (gcc debug, with `-Wconversion -Wsign-conversion`) | PASS: oracle self-test (28,098 encodings); 5 drivers; contracts E01–E03; E04 224,962 encodings and prefixes; E05 25,264 texts; E06 10 listings plus boundaries and fault injection; `decode8086` command contract; `objdump` cross-check of all 28,098 encodings; S01 5,120 branches against the oracle and `objdump`; S02 `table_decoder_agrees=1 compared=2502912`; E07 12 cases; symbols |
| `tests/starters.py --cc gcc` and `--cc clang` | PASS: both learner scaffolds compile warning-clean, all six contract suites compile against them and fail, and `check.py` finishes without a harness error (27 behavioral failures) |
| `make verify` | see “Final verification” |

## The oracle

- **Direction.** The table is built in the encoding direction: forms × registers × `d` × immediates, where the immediates are every 8-bit value and a 16-bit set of 342 values. That set covers the boundaries, a deterministic sample, and every value the exhaustive test can form with its trailer bytes `34 12`.
- **Self-test.** The self-test checks 15 hand-derived known answers from the manual's tables, 6 classifier cases, the shared operation code, and that length is determined by the first two bytes over the whole table.
- **Unsampled immediates.** An immediate outside the enumeration raises `Unsampled`, and no expected text is ever guessed. The exhaustive E04 file is generated without any `Unsampled`, which demonstrates that the sample covers the test's domain.
- **`objdump`.** It agrees with the oracle on every one of the 28,098 encodings after normalizing its unsigned hexadecimal immediates and its comma spacing. It is a toolchain witness (binutils 2.38), gated on `-m i8086` support.

## Mutation check of the harness

`make mutate` ([extras/mutate.py](extras/mutate.py)) applies each of **37** mutants to the reference, rebuilds with GCC and `-Wconversion -Wsign-conversion` at `-O0`, and runs `tests/check.py`. **36 were killed and 1 survived.**

| Survivor | Classification |
| --- | --- |
| In `0x83`, reading the 8-bit immediate as a signed byte instead of sign-extending it to 16 bits and reading that | **Equivalent.** Sign extension preserves the value: for every byte b, `to_signed(sign_extend8(b), 1) == to_signed(b, 0)`. The E03 contract checks exactly this identity for all 256 bytes. The answer key uses it to explain that sign extension changes the width, not the value. |

The contract suites killed most mutants. The drivers killed some the suites could not reach from their own files: `mov` shifted by 5 bits, and big-endian assembly in E03. The `decode8086` command test killed “output errors ignored”.

## Limits of this evidence

- Exhaustive over the subset means over every first and second byte with fixed trailing bytes, plus the full enumeration. The S02 comparison extends the reference decoder's self-agreement to every immediate. None of this protects against a misreading of the manual shared by the course table and the decoder, which is why the manual check above was done by reading the manual, not by testing.
- The `objdump` agreement is an observation of binutils 2.38.
- The ten-hour estimate is **unpiloted**; agent execution time says nothing about learner completion time. The pilot procedure in PLAN.md is **pending**, and no participant data exist.

## Final verification

`rm -rf build && make verify`, run on 2026-09-22 on a copy in the WSL home directory, finished with exit status 0 in 52 s:

- `make PACKAGE=instructor test` passed in all six configurations: gcc and clang, each in debug, optimized and sanitize. Each ended with the inventory `PASS` and `PASS: oracle self-test, 5 demo drivers, 6 C contract suites (all encodings and every two-byte prefix), decode8086 command contract, objdump cross-check, E07 cases, symbols`.
- `make starters` passed: the gcc and clang learner scaffolds compile and fail all six contract suites (27 checks).
