# Notebook — exemplar

An illustrative completed notebook. The toolchain output is real and was recorded on 2026-09-22. The “predictions” were written by the implementing agent from the manual before running the decoder, and are shown to illustrate the form; they are not evidence of a learner's blind prediction.

### R01

**Build environment.**

| Item | Value |
| --- | --- |
| Machine | x86-64, Ubuntu 22.04 under WSL 2 (kernel 6.18.33.2-microsoft-standard-WSL2) |
| Compilers | GCC 11.4.0; Clang 14.0.0 |
| binutils | GNU objdump 2.38, which supports `-m i8086` and `-m i386:x86-64` |
| Python (harness) | 3.10.12 |
| Debug flags | `-std=c11 -Wall -Wextra -Wpedantic -Werror -O0`; the reference adds `-Wconversion -Wsign-conversion` |
| Optimized flags | the same with `-O2` |
| Sanitizer flags | `-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer` |

### R02

**Prediction, observation, explanation.**

**E07 hand decodings, before running** (fields shown in [answers.md](answers.md#e07c)):

| Bytes | Prediction |
| --- | --- |
| `83 C3 F6` | `add bx, -10`, length 3 |
| `89 C3` | `mov bx, ax`, length 2 |
| `8B C3` | `mov ax, bx`, length 2 |
| `B4 81` | `mov ah, -127`, length 2 |
| `80 CB 01` | `DEC_UNSUPPORTED_OPERATION` at offset 0 |

**E05 prediction:** the longest text is `cmp ax, -32768` (or any 3-letter mnemonic with a 16-bit register and −32768), 14 characters, 15 bytes with the NUL.

| Exercise | Prediction | Observation | Explanation |
| --- | --- | --- | --- |
| E01 | `0xD9` splits into 11/011/001 | driver: `mod=11 reg=011 rm=001` | shifts and masks, Table 4-8 |
| E02 | field 4 is `ah`/`sp` | driver tables as predicted | Table 4-9: byte halves exist only for ax–bx |
| E03 | `FE FF` reads 0xFFFE, which is −2 | `read16@2=0xFFFE signed=-2` | little-endian (p. 4-20); two's complement by arithmetic |
| E04 | `83 C6 FE` is `add si, -2`, and `82 C1 05` is unsupported | as predicted; 224,962 exhaustive comparisons passed | s bit (Table 4-7); `0x82` is a scope decision |
| E05 | longest text is 14 characters | `cmp ax, -32768 length=14` | 3 + 1 + 2 + 2 + 6 |
| E06 | `B8 89 D9` differs from offset 1 | `mov ax, -9847` against `mov cx, bx` | no instruction boundaries in the bytes |
| E07 | the five decodings above | all five confirmed by the oracle and `objdump` | fields worked in the answer key |

### R03

**Claim ledger.**

| # | Claim | Label |
| ---: | --- | --- |
| 1 | `(int16_t)0xFFF4` has an implementation-defined value | C11 §6.3.1.3 ¶3 (implementation-defined) |
| 2 | `lo \| (hi << 8)` gives the same value on any host | C11 (arithmetic on values; §6.2.6.1 governs only representations) |
| 3 | A 16-bit immediate is stored low byte first | 8086 ISA, manual p. 4-20 |
| 4 | `s = 1, w = 1` sign-extends an 8-bit immediate | 8086 ISA, Table 4-7, p. 4-19 |
| 5 | Field value 4 is `ah` for `w = 0` and `sp` for `w = 1` | 8086 ISA, Table 4-9, p. 4-20 |
| 6 | `0x82` encodes ADD, ADC, SBB, SUB and CMP on bytes, with OR, AND and XOR “not used” | 8086 ISA, Table 4-13, p. 4-31 |
| 7 | REX.W selects a 64-bit operand; `48 89 D8` is `mov rax, rbx` | x86-64 ISA, Intel SDM Vol. 2 §2.2.1 |
| 8 | `objdump` prints `add si,0xfffe` for `83 C6 FE` | toolchain (binutils 2.38) |
| 9 | All 28,098 enumerated encodings agree between the oracle and `objdump` | oracle and toolchain, observed |
| 10 | `geo.o` at `-O2` contains no integer `89`/`8B` mov | observed on this machine (compiler output) |

### R04

**Three witnesses.**

| Bytes | Decoder | Oracle | `objdump` | Note |
| --- | --- | --- | --- | --- |
| `83 C3 F6` | `add bx, -10` | `add bx, -10` | `add bx,0xfff6` | Same bits. `objdump` prints the unsigned 16-bit pattern after sign extension; the course prints its signed value. A convention, not an error. |
| `80 CB 01` | `DEC_UNSUPPORTED_OPERATION` at 0 | the same, from its rule table | `or bl,0x1` | `objdump` decodes the full instruction set; `or` is outside the course subset. |
| `82 C1 05` | `DEC_UNSUPPORTED_OPCODE` | the same (0x82 absent from `FIRST_BYTE_FORMS`) | `add cl,0x5` | The manual lists `0x82` (p. 4-31); the course's rejection is a scope decision, documented in the plan. |

### R05

**Inventory:** `src/ex01.c`–`ex05.c`, `decode.h`, `decode.c`, `decode8086.c`, `cases.txt` (12 cases), the `make test` output for GCC and Clang, and this notebook.

**Defense (source → mechanism → observation).**

- **Source:** in `read_imm`, `(uint16_t)(lo | (hi << 8))` where `lo` and `hi` are the bytes at `offset` and `offset + 1`.
- **Mechanism:** the 8086 stores the low byte first (p. 4-20). Arithmetic on the byte values builds the number itself, independently of how the host would store it. `hi` is promoted to `int` and shifted by 8, which cannot overflow because it is at most 0xFF00.
- **Observation:** `B9 F4 FF` decodes as 0xFFF4 = −12 (`mov cx, -12`) on this little-endian host, and would on a big-endian one. The `memcpy` alternative would give 0xF4FF there.

**Open question for week 7.** How should the decoder learn the length of an instruction with a memory operand? `mod` and `r/m` decide whether 0, 1 or 2 displacement bytes follow, and `mod = 00, r/m = 110` is a special case. Where does that knowledge belong: in the table of forms, or in a separate effective-address decoder?
