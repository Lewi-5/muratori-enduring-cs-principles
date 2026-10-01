# Assignment — 8086 subset decoder notebook

Complete seven exercises and the notebook. Keep every public function signature and type: the harness includes each source with its `main` renamed, so the named functions and types are the contract. Supplied drivers and plumbing are scaffolding, not functions you rewrite. Every `.C` prompt needs code plus the tests that come with it, and every `.Q` a worked explanation in [observations.md](observations.md) or a notes file. See [the rubric](../rubric.md).

## The course subset and output format (used by every exercise)

The primary reference is the Intel 8086 Family User's Manual (1979): Table 4-12 (encoding), Table 4-13 (decoding guide), and Tables 4-7 to 4-9 (fields and registers). Byte patterns are written most-significant bit first.

| Form | First byte | Then | Bytes |
| --- | --- | --- | --- |
| `mov` register to register | `100010dw` (`0x88`–`0x8B`) | ModR/M | 2 |
| `mov` immediate to register | `1011wrrr` (`0xB0`–`0xBF`) | 8-bit (`w = 0`) or 16-bit (`w = 1`) immediate | 2 or 3 |
| `add`/`sub`/`cmp` register with register | `00ooo0dw`: `ooo` = `000` add (`0x00`–`0x03`), `101` sub (`0x28`–`0x2B`), `111` cmp (`0x38`–`0x3B`) | ModR/M | 2 |
| `add`/`sub`/`cmp` immediate to register | `100000sw` (`0x80`, `0x81`, `0x83`) | ModR/M whose `reg` field is `000`, `101` or `111`, then a 16-bit immediate when `s:w = 01`, otherwise 8 bits, sign-extended to 16 bits when `s:w = 11` | 3 or 4 |
| `add`/`sub`/`cmp` immediate to accumulator | `00ooo10w` (`0x04`/`0x05`, `0x2C`/`0x2D`, `0x3C`/`0x3D`) | 8- or 16-bit immediate; the destination is `al` or `ax` | 2 or 3 |

- **ModR/M:** `mod` is bits 7–6, `reg` bits 5–3, `r/m` bits 2–0. This week only `mod = 11` (register mode) is decoded. `d = 1` makes `reg` the destination; `d = 0` makes `r/m` the destination. Registers are `al cl dl bl ah ch dh bh` for `w = 0` and `ax cx dx bx sp bp si di` for `w = 1`. A 16-bit immediate is stored low byte first.
- **Outside the subset, with statuses from [support/decode_types.h](../support/decode_types.h):** a recognized form with `mod != 11` is `DEC_UNSUPPORTED_MODE` (memory operands are week 7). `0x80`–`0x83` with a `reg` field other than `000`, `101` or `111` (`or`, `adc`, `sbb`, `and`, `xor`) is `DEC_UNSUPPORTED_OPERATION`. `0x82` and every other first byte are `DEC_UNSUPPORTED_OPCODE`. The manual lists `0x82`; excluding it is this course's scope decision.
- **Status order** for one instruction:
  1. No byte: `DEC_TRUNCATED`.
  2. Opcode outside the subset: `DEC_UNSUPPORTED_OPCODE`.
  3. A ModR/M byte is needed but missing: `DEC_TRUNCATED`.
  4. `mod != 11`: `DEC_UNSUPPORTED_MODE`.
  5. The `reg` field is not an operation in the subset: `DEC_UNSUPPORTED_OPERATION`.
  6. Immediate bytes missing: `DEC_TRUNCATED`.

  A failure is reported at the offset of the instruction's first byte.
- **Canonical text:** lowercase mnemonic, a space, the destination, `", "`, the source: `mov cx, bx`, `add si, -2`, `cmp al, 12`. Immediates are printed in signed decimal **as a value of the operand's width**. A stream starts with the line `bits 16`, and every line ends in `\n`.

General contract. A rejected call leaves every output unchanged. Read bytes as `uint8_t`, never plain `char`. Assemble 16-bit values from bytes by arithmetic, never by `memcpy` into a `uint16_t`. Convert bit patterns to signed values by arithmetic, never by a narrowing cast. Check that every byte exists before you read it.

**Predict before you run.** Record your E07 hand decodings and your E05 longest-text prediction in the notebook first. **Playground:** write bytes with `python3 tools/hex2bin.py t.bin 89 d9`, predict the text, run `decode8086 t.bin`, and compare with `objdump -D -b binary -m i8086 -M intel t.bin`.

### E01.C

In [ex01.c](src/ex01.c), with `typedef struct { unsigned mod, reg, rm; } ModRM;`, implement:

- `ModRM split_modrm(uint8_t byte)`: bits 7–6, 5–3 and 2–0.
- `unsigned bit_at(uint8_t byte, unsigned index)`: returns 0 for `index > 7`, as documented.

Use unsigned shifts and masks only. The driver prints the fields of `0xD9`, `0xCB`, `0xC6` and `0x00` in binary. Tests cover all 256 bytes against the oracle's field table, the reassembly `mod << 6 | reg << 3 | rm == byte`, every bit, and indices 8 and `UINT_MAX`.

### E01.Q

Explain:

- The ModR/M layout, and what each field means in the subset, including what `mod` would mean in week 7.
- Why the shifts are safe: a `uint8_t` is promoted to `int` before shifting (C11 §6.3.1.1). This is safe here, and would not be for `byte << 24` on a 32-bit `int`.
- A faulty `byte >> 3` without a mask, and the byte on which it goes wrong.

### E02.C

In [ex02.c](src/ex02.c), implement `const char *reg_name(unsigned wide, unsigned reg)`. It returns the canonical name, or NULL when `wide > 1` or `reg > 7`. The driver prints both tables. Tests cover all 16 names and the rejected values.

### E02.Q

Explain:

- Why field value 4 means `ah` when `w = 0` but `sp` when `w = 1`: `al`/`ah` are the low and high halves of `ax`, and so on for `cx`, `dx` and `bx`.
- Why `sp`, `bp`, `si` and `di` have no 8-bit halves on the 8086.
- As a labelled comparison you check in the Intel SDM (do not implement it), what x86-64 changed: REX prefixes, `spl`/`sil`, and 64-bit registers.

### E03.C

In [ex03.c](src/ex03.c), implement three functions.

- `int read_imm(const uint8_t *bytes, size_t avail, size_t offset, unsigned size, uint16_t *out)` reads 1 or 2 bytes, little-endian. It rejects a size other than 1 or 2, NULL pointers, and any read past `avail`, testing `offset <= avail && size <= avail - offset` so that `offset + size` is never evaluated.
- `int32_t to_signed(uint16_t value, unsigned wide)` returns the signed value of an 8- or 16-bit pattern. Precondition: `wide` is 0 or 1, and `value <= 0xFF` when `wide` is 0.
- `uint16_t sign_extend8(uint8_t value)`.

Tests:

- `34 12` reads as `0x1234`, and the reads at the last valid offset and one past it behave correctly.
- An offset near `SIZE_MAX` is rejected, and outputs are unchanged on rejection.
- Every 16-bit pattern's signed value lies in range with the right residue; every 8-bit value is checked with both functions.

### E03.Q

Explain:

- Little-endian order as a property of the 8086's encoding (manual p. 4-20: “the second byte of a two-byte immediate value is the most significant”), not of the host.
- Why assembling from bytes is host-independent while `memcpy` into a `uint16_t` is not (C11 §6.2.6.1).
- Why `(int16_t)0xFFF4` is implementation-defined (§6.3.1.3 ¶3), and your arithmetic replacement.
- Two's-complement sign extension, worked in binary for `0xFE → 0xFFFE → −2`.
- Why your bounds test cannot overflow.

### E04.C

In [ex04.c](src/ex04.c), implement `DecodeStatus decode_one(const uint8_t *bytes, size_t avail, Instruction *out)` for the subset.

- Follow the status order and set `length`.
- A NULL `out`, or NULL `bytes` with `avail > 0`, is `DEC_INVALID_ARGUMENT`, with nothing written.
- `*out` is written only on `DEC_OK`.

Copy your E01–E03 helpers into the file. Tests:

- every one of about 28,000 enumerated encodings from the oracle;
- **every** two-byte prefix `(b0, b1)` with 0, 1 and 2 following bytes, compared for status, length and decoded fields;
- `0x82`; `or` in `0x80`; `mod = 00`; each truncation point;
- `83 C6 FE` (`add si, -2`) and `80 C1 FE` (`add cl, -2`);
- `89 D9` and `8B CB`, which must both decode to `mov cx, bx`.

### E04.Q

Explain:

- The three `add`/`sub`/`cmp` forms and the shared 3-bit operation code. Tabulate it: bits 5–3 of the first byte in the register and accumulator forms, and the `reg` field in `0x80`–`0x83`. Check it against the manual.
- The roles of `d`, `w` and `s` (manual Table 4-7).
- The status order, and why an ordered list makes diagnostics deterministic (week 4).
- Exactly how far “an instruction's length depends only on its first byte” holds. Is it true for the instructions this subset accepts? Is it true for the *status*? Does it survive week 7's memory modes? Show the evidence.
- A faulty decoder that reads the immediate before checking `avail`.

### E05.C

In [ex05.c](src/ex05.c), implement `int format_instruction(const Instruction *ins, char *out, size_t size)`.

- It writes the canonical text and a NUL.
- It rejects a NULL pointer, any invalid field (operation, operand kinds, registers, widths, a destination that is not a register, mismatched widths, an immediate outside its width's signed range), and a `size` smaller than the text length plus one.
- Format into a local `DEC_MAX_TEXT` buffer, check `snprintf`'s result, and copy only a complete text that fits.

**Before running**, predict the longest text any instruction in the subset can produce, and its length. Tests: every oracle text (about 25,000), the longest text at its exact buffer size and at one byte less, and eleven invalid instructions against a sentinel-filled buffer.

### E05.Q

Explain:

- Why decoding is a function but assembling is not: `89 D9` and `8B CB`; `81 C6 FE FF` and `83 C6 FE`. So a text round trip cannot recover the bytes.
- Why immediates are printed as signed values of their width, and what `objdump`'s unsigned choice (`add si,0xfffe`) would change.
- Your longest-text derivation.
- Why `snprintf` of an integer does not depend on the locale's decimal point.

### E06.C

In [decode.c](src/decode.c), paste your E04 and E05 code (helpers `static`) and implement `decode_stream` as documented in [decode.h](src/decode.h).

- It decodes every instruction and writes `bits 16` and one line per instruction only if the whole stream decodes and fits.
- NULL `bytes` is valid only when `n == 0`.
- A first pass validates and counts the text with checked `size_t` arithmetic; only then does a second pass write.
- On a byte-decoding failure, `text` and `*text_len` stay unchanged and `*error_offset` is the failing instruction's first byte.
- On `DEC_OUTPUT_TOO_SMALL` or `DEC_INVALID_ARGUMENT`, every output stays unchanged.
- On success, `*text_len` counts the visible bytes and `*error_offset` is `n`.

In [decode8086.c](src/decode8086.c), implement `read_input`. Read with `fgetc`, telling end of file from `ferror`. More than `DEC_MAX_INPUT` bytes is `READ_TOO_LARGE`. A failing `fopen` or `fclose` is `READ_ERROR`. On any failure `*n` stays unchanged. The supplied `main` prints:

- `decode8086: input error`, `decode8086: input too large` or `decode8086: output error` for command-level failures;
- `decode8086: STATUS at offset N` for decoding failures.

Every error exits 1, and standard output is empty unless the write itself fails.

Tests:

- The ten supplied [listings](../fixtures/listings) decode to their expected text or error.
- An empty file prints `bits 16` alone.
- Exactly 65,536 bytes succeed and 65,537 are too large.
- A too-small buffer keeps its sentinel.
- The same bytes decode differently from offset 1.
- A missing file and a directory are rejected; `fgetc`, `ferror` and `fclose` failures are injected in the test translation unit; output to `/dev/full` is reported.

### E06.Q

Explain:

- Why an instruction stream must be decoded from its start. Use `B8 89 D9`, which is `mov ax, -9847` from offset 0 but `mov cx, bx` from offset 1.
- Validate-then-commit for the text.
- Bounded reading with `EOF` versus `ferror`.
- The offset reported for each kind of error.

### E07.C

**Before running anything**, hand-decode these five sequences in your notebook. For each, show every applicable bit field, then give the text and length, or the status and failing offset:

1. `83 C3 F6`
2. `89 C3`
3. `8B C3`
4. `B4 81`
5. `80 CB 01`

Then add at least **eight** purposeful cases to [cases.txt](cases.txt), one per line: `HEX BYTES | EXPECTED | REASON`, where EXPECTED is the text of every instruction separated by `"; "`, or `STATUS@OFFSET`. The supplied runner fails a case when the oracle disagrees with your expectation (the derivation is wrong) or when your decoder does (the decoder is wrong).

### E07.Q

Explain:

- Why the supplied oracle is independent of your decoder: it never decodes, but enumerates encodings from a table checked against the manual, and classifies failures by a separate rule table. Trace one of your cases through its construction.
- Why the `objdump` cross-check is a second, toolchain-level witness, and which of its conventions differ from the course's.
- What neither witness can catch.
