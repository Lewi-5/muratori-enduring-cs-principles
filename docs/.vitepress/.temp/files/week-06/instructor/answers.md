# Answer key — 8086 subset decoder notebook

Every learner prompt has an entry with the same ID. Manual citations are to Intel, *The 8086 Family User's Manual* (9800722-03, October 1979), checked on 2026-09-22 against the scanned text; see [validation.md](validation.md). Toolchain output comes from GNU binutils `objdump` on Ubuntu 22.04 and is labelled as such.

C11 clauses (N1570):

- §6.2.6.1: object representations; byte order is not specified.
- §6.3.1.1: integer promotions.
- §6.3.1.3 ¶3: converting to a signed type a value it cannot represent is implementation-defined.
- §6.5.7 ¶4–5: shifts; right-shifting a negative value is implementation-defined.
- §7.20.1.1: exact-width types are optional.
- §7.21.7.1 and 7.21.10: `fgetc`, `feof`, `ferror`.

### E01.C

Reference: [src/ex01.c](src/ex01.c).

```c
ModRM split_modrm(uint8_t byte)
{
    ModRM m;
    m.mod = (unsigned)(byte >> 6) & 3u;
    m.reg = (unsigned)(byte >> 3) & 7u;
    m.rm = (unsigned)byte & 7u;
    return m;
}
unsigned bit_at(uint8_t byte, unsigned index)
{
    if (index > 7) return 0;
    return ((unsigned)byte >> index) & 1u;
}
```

**Why it is correct.** Each field is a shift that brings its lowest bit to position 0, then a mask as wide as the field. The contract test checks all 256 bytes against the oracle's field table, reassembles every byte from its fields, and checks every bit. The driver prints `byte=0xD9 mod=11 reg=011 rm=001` (`mov cx, bx`'s second byte), and likewise for `0xCB`, `0xC6` and `0x00`.

**Edge cases.** `index > 7` returns the documented 0 rather than shifting by 8 or more. A shift of an `unsigned` by its width or more would be undefined (§6.5.7 ¶3), so `UINT_MAX` must not reach the shift.

**Faulty approach.** `m.reg = byte >> 3;` keeps the two `mod` bits. For `0xD9` it gives 27 instead of 3, which then indexes past an 8-entry register table.

### E01.Q

**Layout.** ModR/M is `mod` (bits 7–6), `reg` (bits 5–3) and `r/m` (bits 2–0). Manual Tables 4-8 to 4-10, p. 4-20.

- `mod = 11` means register mode: `r/m` names a second register, with the same numbering as `reg`.
- `mod = 00`, `01` and `10` are memory modes: `r/m` selects an effective-address formula, followed by no displacement, an 8-bit displacement or a 16-bit displacement. The exception is `mod = 00, r/m = 110`, a direct 16-bit address. That is week 7.
- `reg` names a register operand, except in `0x80`–`0x83`, where it extends the opcode to choose the operation (p. 4-20: “REG is used as an extension of the opcode”).

**Promotion.** A `uint8_t` operand of `>>` is promoted to `int` (§6.3.1.1), and every value is 0–255, so every shift here is of a small nonnegative `int`. The cast to `unsigned` is for clarity and for `-Wsign-conversion`. The same promotion is a trap elsewhere. `byte << 24` promotes to a 32-bit `int`, and for `byte ≥ 0x80` the result 2^31 or more is not representable in `int`: that is undefined behavior (§6.5.7 ¶4). The fix is `(uint32_t)byte << 24`.

**Faulty unmasked shift.** Shown in E01.C: `0xD9 >> 3` is `0b11011` = 27, not 3.

### E02.C

Reference: [src/ex02.c](src/ex02.c). A constant `[2][8]` table indexed after checking `wide ≤ 1` and `reg ≤ 7`, so the index never leaves the table.

```c
static const char *const names[2][8] = {{"al", "cl", "dl", "bl", "ah", "ch", "dh", "bh"},
                                        {"ax", "cx", "dx", "bx", "sp", "bp", "si", "di"}};
if (wide > 1 || reg > 7) return NULL;
return names[wide][reg];
```

**Faulty approach.** A single 16-entry table indexed by `wide * 8 + reg` without the checks reads out of bounds for `reg = 8`.

### E02.Q

**Registers and halves** (Table 4-9, p. 4-20).

- With `w = 0` the field selects a byte register: `al`, `cl`, `dl` and `bl` are the low halves of `ax`, `cx`, `dx` and `bx`, and `ah`, `ch`, `dh` and `bh` are the high halves.
- The 8086 has byte halves only for those four general registers. So the byte encodings 4–7 are spent on the high halves, and `sp`, `bp`, `si` and `di`, the pointer and index registers, have no byte form.
- The same 3-bit value 4 therefore means `ah` for byte operations and `sp` for word operations. A decoder that ignores `w` prints the wrong register.

**x86-64** (a labelled ISA comparison, Intel SDM Vol. 2, §2.2.1 “REX Prefixes”; not implemented).

- A REX prefix (`0x40`–`0x4F`) adds a fourth bit to `reg`, `r/m` and the index, which gives 16 registers.
- REX.W selects 64-bit operands (`rax`…).
- With any REX prefix present, byte encodings 4–7 name `spl`, `bpl`, `sil` and `dil` instead of `ah`, `ch`, `dh` and `bh`.
- The ModR/M layout itself is unchanged, which is why this week's skills transfer (P06).

### E03.C

Reference: [src/ex03.c](src/ex03.c).

```c
if (bytes == NULL || out == NULL || (size != 1 && size != 2)) return 0;
if (offset > avail || size > avail - offset) return 0;
unsigned lo = bytes[offset], hi = bytes[offset + 1];     /* when size == 2 */
*out = (uint16_t)(lo | (hi << 8));
...
return value >= 0x8000u ? (int32_t)value - 0x10000 : (int32_t)value;   /* to_signed, wide == 1 */
return (uint16_t)(value & 0x80u ? 0xFF00u | value : value);          /* sign_extend8 */
```

**Why it is correct.** The bounds test evaluates `offset <= avail` first. If it holds, `avail - offset` cannot wrap, and `size <= avail - offset` is exactly “the bytes exist”.

- `lo | (hi << 8)` is at most 0xFFFF and fits every `int`.
- `(int32_t)value - 0x10000` is exact arithmetic on values in [0x8000, 0xFFFF], giving [−32768, −1].
- The tests check every 16-bit pattern for range and residue, and reads near `SIZE_MAX`.

**Faulty approaches.**

- `offset + size > avail` wraps when `offset` is `SIZE_MAX − 1` and accepts the read. The mutation record shows the test kills it.
- `memcpy(&v, bytes + offset, 2)` gives the host's byte order.
- `(int16_t)value` is implementation-defined.

### E03.Q

**Little-endian is a property of the encoding.** The manual says that “the second byte of a two-byte immediate value is the most significant” (p. 4-20). `B9 F4 FF` therefore means the value 0xFFF4 on every host. Assembling `lo | (hi << 8)` computes that *value* by arithmetic, which C defines independently of how the host stores integers. `memcpy` copies the bytes into an object whose byte order C leaves unspecified (§6.2.6.1). On a big-endian host the same call would produce 0xF4FF.

**Signed conversion.** `(int16_t)0xFFF4` converts 65524 to a type that cannot represent it. The result is implementation-defined, or an implementation-defined signal is raised (§6.3.1.3 ¶3). GCC documents wrapping modulo 2^16, but that is a compiler's promise, not C's. `v − 0x10000` for `v ≥ 0x8000` is ordinary arithmetic with a defined result.

**Sign extension, worked.**

| Step | Binary | Value |
| --- | --- | --- |
| `0xFE` | `1111 1110` | 254 unsigned; as 8-bit two's complement, 254 − 256 = −2 |
| sign-extended to 16 bits (copy bit 7 into bits 8–15) | `1111 1111 1111 1110` = `0xFFFE` | 65534 − 65536 = **−2** |
| `0x7E`, for contrast | high byte `0x00` | 126 |

Sign extension preserves the value and changes only the width. That is why the mutant that reads an `s = 1` byte as a signed 8-bit number, without extending, survives the mutation check: it is equivalent (validation.md).

**Bounds test.** Proved in E03.C. It never forms `offset + size`, so no input can make it wrap.

### E04.C

Reference: [src/ex04.c](src/ex04.c). The structure follows the forms:

```c
if ((b0 & 0xF0u) == 0xB0u) { /* mov reg, imm: 1011 w rrr */ ... }
if ((b0 & 0xC4u) == 0x04u) { /* op acc, imm: 00 ooo 10w; ooo must be add/sub/cmp and bit 1 clear */ ... }
reg_reg = (b0 & 0xFCu) == 0x88u;                         /* mov r/m, r: 100010dw */
if (!reg_reg && (b0 & 0xC4u) == 0x00u) { ... arith_op((b0 >> 3) & 7u, &op) ... }  /* 00 ooo 0dw */
if (reg_reg) { if (avail < 2) return DEC_TRUNCATED; ... if (m.mod != 3) return DEC_UNSUPPORTED_MODE; ... }
if (b0 == 0x80u || b0 == 0x81u || b0 == 0x83u) {
    if (avail < 2) return DEC_TRUNCATED;
    if (m.mod != 3) return DEC_UNSUPPORTED_MODE;
    if (!arith_op(m.reg, &op)) return DEC_UNSUPPORTED_OPERATION;
    size = (s == 0 && w == 1) ? 2 : 1;
    if (!read_imm(bytes, avail, 2, size, &raw)) return DEC_TRUNCATED;
    value = size == 2 ? to_signed(raw, 1) : (s && w ? to_signed(sign_extend8(raw), 1) : to_signed(raw, 0));
}
return DEC_UNSUPPORTED_OPCODE;
```

Every byte is read only after its existence is established, and `*out` is assigned only at a successful return.

**Evidence.** The E04 contract compares 224,962 cases with the oracle: every enumerated encoding, and every `(b0, b1)` with 0, 1 and 2 trailing bytes. It also checks that `*out` is byte-for-byte unchanged on every failure.

**Faulty approaches.** Four of them are in the mutation record, and each is killed:

- `if (b0 >= 0x80 && b0 <= 0x83)` accepts `0x82`;
- checking the operation before the mode reports `DEC_UNSUPPORTED_OPERATION` for `80 0F`, where the order requires `DEC_UNSUPPORTED_MODE`;
- `size = w ? 2 : 1` reads two immediate bytes for `0x83`;
- treating a missing ModR/M byte as zero turns truncation into a mode error.

### E04.Q

**The shared operation code** (Table 4-12, pp. 4-23 to 4-24; Table 4-13, pp. 4-27 to 4-31):

| Operation | Register form `00ooo0dw` | Accumulator form `00ooo10w` | `100000sw` reg field |
| --- | --- | --- | --- |
| add | `000` → `0x00`–`0x03` | `0x04`/`0x05` | `000` |
| sub | `101` → `0x28`–`0x2B` | `0x2C`/`0x2D` | `101` |
| cmp | `111` → `0x38`–`0x3B` | `0x3C`/`0x3D` | `111` |

The same three bits name the operation in bits 5–3 of the first byte and in the `reg` field of the immediate group. The other five values are `or` (`001`), `adc` (`010`), `sbb` (`011`), `and` (`100`) and `xor` (`110`), in the same places. The oracle's self-test checks the correspondence for all three operations.

**`d`, `w` and `s`** (Table 4-7, p. 4-19):

- `w` selects byte (0) or word (1) operands.
- `d = 1` means the `reg` field names the destination, and `d = 0` the source.
- `s = 1` with `w = 1` means “sign extend 8-bit immediate data to 16 bits”.

So `89 D9` and `8B CB` are both `mov cx, bx`. `83 C6 FE` carries one immediate byte, 0xFE, that stands for 0xFFFE, and `81 C6 FE FF` carries both.

**Status order.** Week 4 fixed the parser's error classes in an order for the same reason: a byte sequence can be wrong in several ways at once. For example, `80 0F` is a memory mode *and* `or`, and a truncated one. Without an order, two correct decoders could report different statuses and a test could not decide between them. The order also follows the reading: nothing is known about a later field until the earlier ones say what it is.

**How far “length depends only on the first byte” holds.** For every instruction this subset *accepts*, it does:

| First byte | Length |
| --- | --- |
| `0x88`–`0x8B` and the register forms | 2 |
| `0xB0`–`0xB7`, `0x04`, `0x2C`, `0x3C` | 2 |
| `0xB8`–`0xBF`, `0x05`, `0x2D`, `0x3D` | 3 |
| `0x80`, `0x83` | 3 |
| `0x81` | 4 |

The oracle's self-test checks the weaker property that length is a function of the first two bytes, and the exhaustive test covers every pair.

The claim fails for the **status**: `80 C0` starts an accepted `add al, imm8`, `80 C8` starts `or` (unsupported operation), and `80 00` a memory mode. The same first byte gives three statuses. It also fails for **length** once week 7 admits memory modes (Table 4-8): `88 07` is 2 bytes (`mod = 00`), `89 5E 02` is 3 (`mod = 01` adds one displacement byte), and `89 9E 34 12` is 4 (`mod = 10`), all with a first byte in `0x88`–`0x8B`. The accurate statement is that length is determined by the first byte and, from week 7, the `mod` and `r/m` fields.

**Faulty read-before-check.** `value = bytes[2];` followed by `if (avail < 3) return DEC_TRUNCATED;` reads one byte past the input when the stream ends early. That is undefined behavior at the end of a buffer, and AddressSanitizer reports it on `80 C1` with `avail == 2`.

### E05.C

Reference: [src/ex05.c](src/ex05.c).

```c
if (ins == NULL || out == NULL) return 0;
if (op not in {mov, add, sub, cmp}) return 0;
if (ins->dst.kind != OPERAND_REG || !valid_operand(&ins->dst, 0) || !valid_operand(&ins->src, 1)) return 0;
if (ins->src.wide != ins->dst.wide) return 0;
char text[DEC_MAX_TEXT];
n = snprintf(text, sizeof text, "%s %s, %ld", mnemonic, dst, (long)imm);   /* or "%s %s, %s" */
if (n < 0 || (size_t)n >= sizeof text) return 0;
if ((size_t)n + 1 > size) return 0;
memcpy(out, text, (size_t)n + 1);
```

`valid_operand` checks the register in 0–7, the width in 0–1, and the immediate in [−128, 127] or [−32768, 32767]. The caller's buffer is touched only by the final `memcpy`. A direct `snprintf(out, size, …)` would write a truncated prefix into `out` before the function could reject it; the plan review corrected exactly that.

**The longest text** is 14 characters. Every text is `mnemonic` (3) + space (1) + register (2) + `", "` (2) + source. The longest source is an immediate of six characters, `-32768` (a 16-bit value; 8-bit values have at most four, as in `-128`). So 3 + 1 + 2 + 2 + 6 = 14, for example `cmp ax, -32768`, and with the NUL it needs 15 bytes ≤ `DEC_MAX_TEXT` (32). The test checks size 15 (accepted) and 14 (rejected, buffer untouched).

### E05.Q

**Decoding is a function; assembling is not.** Every byte sequence the decoder accepts has exactly one text. The reverse relation has several preimages:

- `89 D9` and `8B CB` both print `mov cx, bx` (the `d` bit);
- `83 C6 FE` and `81 C6 FE FF` both print `add si, -2` (the `s` bit);
- `2C C8` and `80 E8 C8` both print `sub al, -56` (the accumulator form).

A round trip bytes → text → assembler → bytes can therefore change the bytes: NASM picks its preferred encoding, typically the shortest. Text preserves the *meaning* the course defines, not the encoding. Week 7's “round-trip canonical forms where possible” is limited by this.

**Signed printing.** The operand width fixes a bit pattern, and the canonical text prints its two's-complement value, so the immediate means what the arithmetic will do with it. `objdump` prints the unsigned pattern in hexadecimal (`add si,0xfffe`), which is a faithful rendering of the bits. Both are correct, but they differ as text, and the course's comparison normalizes `objdump`'s form. An unsigned choice would make `add si, 65534` and `add si, -2` different texts for the same encoding family, and would lose the fact that an `s = 1` byte is a small negative number.

**Locale.** Only `%s` and `%ld` are used. The locale affects the decimal point of floating conversions and the `'` flag; neither appears.

### E06.C

Reference: [src/decode.c](src/decode.c) and [src/decode8086.c](src/decode8086.c).

```c
if ((bytes == NULL && n > 0) || text == NULL || text_len == NULL || error_offset == NULL) return DEC_INVALID_ARGUMENT;
size_t need = 8;                                       /* "bits 16\n" */
for (pos = 0; pos < n; pos += ins.length) {
    s = decode_one(bytes + pos, n - pos, &ins);
    if (s != DEC_OK) { *error_offset = pos; return s; }
    format_instruction(&ins, line, sizeof line);
    if (need > SIZE_MAX - (strlen(line) + 1)) return DEC_OUTPUT_TOO_SMALL;
    need += strlen(line) + 1;
}
if (need >= text_size) return DEC_OUTPUT_TOO_SMALL;   /* need + 1 bytes, for the NUL */
... second pass: header, each line and '\n', NUL; *text_len = need; *error_offset = n;
```

`read_input` reads with `fgetc` into the caller's buffer and stops at `EOF`. There, `ferror` decides between end of file and a read error. Reaching `cap` bytes and then reading one more byte is `READ_TOO_LARGE`, and a failing `fclose` is `READ_ERROR`. `*n` is written only on success.

**Why it is correct.** Pass 1 and pass 2 perform the same deterministic decoding of the same bytes, so pass 2 cannot fail. The size arithmetic is checked before every addition, and the NUL is included in the final comparison. The contract covers all ten listings, the empty input, the exact 30/31-byte boundary with sentinels, invalid arguments, resynchronization, 65,536 and 65,537 bytes, a missing file, a directory (on Linux `fopen` succeeds and `fgetc` fails with `EISDIR`, so `ferror` catches it), and injected `fgetc`/`ferror`/`fclose` failures.

**Faulty approaches.** Four of them:

- `if (need > text_size)` leaves no room for the NUL and writes one byte past the buffer (killed);
- writing each line as it is decoded leaves a partial listing in the buffer when a later instruction fails;
- `while ((c = fgetc(f)) != EOF)` with `char c` cannot tell byte 0xFF from `EOF` where `char` is signed;
- calling `feof` instead of `ferror` misreports a read error as a short file.

### E06.Q

**Decoding from the start.** An instruction's length is known only after its own bytes are decoded, so the start of each instruction is defined by the previous one. `B8 89 D9` from offset 0 is one instruction, `mov ax, -9847` (immediate 0xD989). From offset 1, the bytes `89 D9` are `mov cx, bx`: valid, plausible, and wrong. Nothing in the bytes marks instruction boundaries, and the variable length is what makes this possible.

**Validate, then commit.** The caller either gets the complete listing or an unchanged buffer and a precise offset. A partial listing that stops silently in the middle would look like a successful short program. The command applies the same rule to standard output: nothing is printed until the whole file is decoded. Only a write error, which can happen after output has begun, can leave a partial stream, and that is reported as `decode8086: output error`.

**Bounded reading.** `fgetc` returns an `int`, so that `EOF` (negative) is distinct from every byte 0–255. At `EOF`, `ferror` distinguishes a read error from the end of the file (§7.21.10). The limit is enforced by counting, never by trusting a size obtained elsewhere, and one byte past the limit proves the file is too large.

**Offsets.** A decoding failure reports the offset of the failing instruction's first byte. `89 D9 88 07` fails at 2, not 0 (the start of the stream) and not 3 (the byte that revealed the problem). `DEC_OUTPUT_TOO_SMALL` and `DEC_INVALID_ARGUMENT` leave `*error_offset` unchanged, because they are not properties of the bytes. On success it is `n`, one past the last byte decoded.

### E07.C

**The five hand decodings** (checked against the oracle and `objdump`):

1. `83 C3 F6`: `1000 0011` means `s = 1`, `w = 1` in the immediate group. `C3` = `11 000 011`: `mod = 11`, `reg = 000` (add), `r/m = 011` (bx). The immediate `F6` = `1111 0110` is sign-extended to `FFF6` = −10. **`add bx, -10`**, length 3. (`objdump`: `add bx,0xfff6`.)
2. `89 C3`: `1000 1001` is `mov` with `d = 0`, `w = 1`. `C3`: `reg = 000` (ax) is the source, and `r/m = 011` (bx) the destination. **`mov bx, ax`**, length 2.
3. `8B C3`: the same ModR/M byte with `d = 1`, so `reg` (ax) is the destination. **`mov ax, bx`**, length 2. Items 2 and 3 differ only in the `d` bit.
4. `B4 81`: `1011 0 100` means `w = 0` and register 4, which is `ah`. The immediate `81` = `1000 0001` is 129 − 256 = −127. **`mov ah, -127`**, length 2.
5. `80 CB 01`: `1000 0000` is the immediate group with `s = 0`, `w = 0`. `CB` = `11 001 011`: `mod = 11`, so the mode is fine, but `reg = 001` is `or`, outside the subset. **`DEC_UNSUPPORTED_OPERATION` at offset 0.** (`objdump`: `or bl,0x1`.)

**Exemplar cases:** [cases.txt](cases.txt). Twelve cases, each with its reason. They cover sign extension against zero-width and 16-bit forms, the `d` pair, register 4 as `ah` and as `sp`, `or` in `0x80`, truncation of an 8-bit and a 16-bit immediate, the offset of a mid-stream failure, and a two-instruction chain ending in `cmp ax, -32768`. Accept any eight or more cases whose reasons name a distinct failure they would catch.

### E07.Q

**Independence.** The oracle ([tests/oracle8086.py](../tests/oracle8086.py)) never decodes. Its table is built by iterating over forms and operands and *constructing* bytes. For example, for `add bx, -10` with `s:w = 11` it emits `0x83`, then `modrm(3, 0, 3)` = `0xC3`, then `-10 & 0xFF` = `0xF6`, and records the text it formatted from those operands. A decoder bug in field extraction, sign handling or operand order cannot be shared with a program that never extracts fields.

For negative cases it uses `FIRST_BYTE_FORMS`, a separate rule table, and the plan's status order. When a supported sequence is long enough but its immediate was not enumerated, it raises `Unsampled` rather than guessing. The table was checked against the manual (validation.md). The trace for `83 C3 F6`:

1. `encodings()` reaches the `(add, m = 3)` iteration of the immediate group.
2. For `v = 0xF6` it yields `bytes([0x83, 0xC3, 0xF6])` with text `add bx, -10`, because `signed(0xF6, 0)` is −10.
3. `expected()` finds that 3-byte key in `TABLE`.

**`objdump`** is a second witness from a different project, with its own tables. Its conventions differ from the course's in three ways:

- it prints `mov cx,bx` without the space after the comma;
- it prints immediates in unsigned hexadecimal of the operand width (`0xfff6`);
- it decodes `0x82` and `or`/`adc`/`sbb`/`and`/`xor`, which the course rejects.

The cross-check normalizes the first two and excludes the third. For every one of the 28,098 enumerated encodings (a toolchain observation, 2026-09-22), `objdump` agreed.

**What neither can catch.**

- A misreading of the manual shared by the course table and the decoder: both were written from the same table and understanding. The manual cross-check is the only defense.
- Choices the course made on purpose, such as rejecting `0x82`.
- Anything outside decoding: speed, and behavior of the command beyond the tested paths.

### P01

1. **Implementation-defined.** 65524 is not representable in `int16_t`, so §6.3.1.3 ¶3 applies. Most implementations give −12, but C does not require it.
2. **False in general.** Exact-width types are optional (§7.20.1.1 ¶3): an implementation without an 8-bit type (for example with `CHAR_BIT == 16`) has no `uint8_t`. When one exists, it is exactly 8 bits with no padding.
3. **8086 ISA fact.** Manual p. 4-20: the second byte of a two-byte immediate is the most significant.
4. **False.** The expression is arithmetic on values, so its result is defined independently of the host's byte order. Only reinterpreting memory, with `memcpy` or a pointer cast, exposes the byte order (§6.2.6.1).
5. **False.** With `w = 0`, field value 4 names `ah` (Table 4-9). In the immediate group the `reg` field is not a register at all, but the operation.

### P02

| Bytes | Fields | Text | Length |
| --- | --- | --- | ---: |
| `B9 0C 00` | `1011 1 001`: `w = 1`, register 1 (cx); immediate `0C 00` little-endian = 0x000C | **`mov cx, 12`** | 3 |
| `29 D8` | `0010 1001`: sub (`101`) register form, `d = 0`, `w = 1`; `D8` = `11 011 000`: `reg` = bx (source), `r/m` = ax (destination) | **`sub ax, bx`** | 2 |
| `3C 7F` | `0011 1100`: cmp (`111`) accumulator form, `w = 0`; immediate 0x7F = 127, the largest positive 8-bit value | **`cmp al, 127`** | 2 |
| `81 EE 00 01` | `1000 0001`: `s = 0`, `w = 1`; `EE` = `11 101 110`: sub, si; immediate `00 01` = 0x0100 | **`sub si, 256`** | 4 |
| `02 E3` | `0000 0010`: add register form, `d = 1`, `w = 0`; `E3` = `11 100 011`: `reg` = ah (destination), `r/m` = bl (source) | **`add ah, bl`** | 2 |

All five agree with the oracle and with `objdump` (which prints `sub si,0x100`).

### P03

**`mov ax, bx`.** Two encodings, both 2 bytes and equally short:

- `89 D8`: `d = 0`, `reg` = bx `011` is the source, `r/m` = ax `000` is the destination, so ModR/M = `11 011 000`.
- `8B C3`: `d = 1`, `reg` = ax is the destination, so ModR/M = `11 000 011`.

**`add cl, 5`.** In the subset, only `80 C1 05` (3 bytes). There is no accumulator form because `cl` is not `al`, and `82 C1 05` (which the manual lists and `objdump` accepts) is outside the course subset.

**`cmp si, -1`.** `83 FE FF` (3 bytes, `s = 1` extends `FF` to `FFFF`) or `81 FE FF FF` (4 bytes). The 3-byte form is shortest.

**`sub al, 200`.** 200 is outside [−128, 127], the signed range of an 8-bit operand. The bit pattern 200 = `0xC8` is −56 as an 8-bit value, and the canonical text of that encoding is `sub al, -56`. An assembler accepts `sub al, 200` as the same bits, but the decoder prints −56. Encodings: `2C C8` (accumulator form, 2 bytes, shortest) and `80 E8 C8` (`E8` = `11 101 000`: sub, al; 3 bytes).

### P04

**`88 07`.** `mov` with `d = 0`, `w = 0`. ModR/M `07` = `00 000 111`: `mod = 00`, a memory mode with no displacement (Table 4-8), `reg = 000` (al, the source), and `r/m = 111`, which is `[bx]` in memory mode (Table 4-10). It is `mov byte [bx], al`, 2 bytes.

**`89 5E 02`.** `mov` with `d = 0`, `w = 1`. `5E` = `01 011 110`: `mod = 01`, so an 8-bit displacement follows; `reg = 011` (bx); `r/m = 110`, which is `[bp] + disp8`. The displacement `02` gives `mov word [bp+2], bx`, 3 bytes.

`objdump` agrees: `mov BYTE PTR [bx],al` and `mov WORD PTR [bp+0x2],bx`.

**What week 7 must add.**

- The effective-address table (eight `r/m` formulas).
- The displacement length by `mod`: 0, 1 or 2 bytes, plus the special case `mod = 00, r/m = 110`, a 16-bit direct address.
- Sign extension of an 8-bit displacement.
- Size keywords (`byte`/`word`) for memory operands with immediates.

**Why reject rather than guess.** The length of these instructions depends on `mod` and `r/m`. A decoder that assumed 2 bytes would start the next instruction in the middle of a displacement and print a plausible but false listing (P05). Rejecting with `DEC_UNSUPPORTED_MODE` at the correct offset is honest about the subset.

### P05

From offset 0, `B8 89 D9` is `mov ax, -9847`, one 3-byte instruction whose immediate is 0xD989 = 55689 − 65536. From offset 1, `89 D9` is `mov cx, bx`, a valid instruction the program never executes.

x86 machine code carries no boundary markers, so a byte sequence is ambiguous until you know where an instruction starts. A disassembler that starts in the middle of code, at a wrong symbol address, inside data mixed with code, or after a jump into an instruction's middle, can produce a plausible, wrong listing and may resynchronize by accident a few instructions later. Real disassemblers use known entry points, symbol tables and control-flow analysis. Weeks 11–12 read compiler output where those exist.

### P06

**Observation** (2026-09-22, week 5 reference, GCC 11.4, x86-64):

- `objdump -d -M intel` on `geo.o` built at `-O2` shows **no** integer `mov` with opcode `0x89` or `0x8B`. The haversine is all SSE2 floating-point instructions, such as `66 0f 28 e0 movapd xmm4,xmm0` and `66 0f 2f … comisd`.
- The `-O0` build does contain one: `48 89 e5  mov rbp,rsp` in each function's prologue.
- These are compiler-output observations and depend on the build.

**Byte fields for `48 89 E5`** (or the supplied `48 89 D8`):

- `48` is a REX prefix, `0100 WRXB` with W = 1 (64-bit operand size) and R = X = B = 0.
- `89` is `mov r/m, reg` with `d = 0`: the same opcode as the 8086's `mov r/m16, r16`, now with a 32-bit default operand size that REX.W widens to 64 bits.
- ModR/M `E5` = `11 100 101`: `mod = 11` (register), `reg = 100`, which is `rsp` (the 8086's `sp`) and is the source, and `r/m = 101`, which is `rbp` (`bp`) and is the destination. So `mov rbp, rsp`.
- For `48 89 D8`: `D8` = `11 011 000`, so `reg` = `rbx` (source) and `r/m` = `rax` (destination): `mov rax, rbx`.

The ISA facts are REX layout, operand-size rules and register numbering (Intel SDM Vol. 2, §2.1.5 and §2.2.1). The ModR/M reading is identical to this week's.

### S01

Reference: [extras/s01_jumps.c](extras/s01_jumps.c), linked with `decode.o`; `make test` runs it for the instructor package.

**The conversion.** The displacement `d8` is relative to the address of the *next* instruction (the short branch is 2 bytes). The target is `(start + 2) + disp`, which relative to the start is `$ + (2 + disp)`. For `75 FC`, disp = 0xFC − 256 = −4, so the target is `$ − 2`, which prints `jnz $-2`: a two-byte loop onto the instruction before it. `74 00` is `jz $+2`, the next instruction.

The displacement's sign is taken by arithmetic (`raw ≥ 0x80 ? raw − 0x100 : raw`), not by a cast.

**Mnemonics printed.** `jo jno jb jnb jz jnz jbe ja js jns jp jnp jl jnl jle jg loopnz loopz loop jcxz`. The manual lists alias pairs such as JE/JZ, JNE/JNZ, JAE/JNB, JGE/JNL and LOOPE/LOOPZ. `objdump` prints `je jne jae jge loope loopne`, and the cross-check maps those aliases.

**Evidence.** All 20 × 256 = 5,120 encodings agree with the oracle's independent branch table and with `objdump` after converting its absolute targets, computed as (target − address) mod 2^32 as a signed value (validation.md).

### S02

Reference: [extras/s02_table.c](extras/s02_table.c).

- A 256-entry table built from the manual's patterns holds, per first byte: the form, the operation, the width, the register (for `B0`–`BF`), the immediate size and whether to sign-extend.
- `F_NONE` marks everything outside the subset, including `0x82`.
- `decode_table` has a single dispatch on the form.

**The comparison covers the whole input domain.**

- Every first byte alone, and every (b0, b1) with 0, 1 and 2 trailing bytes.
- For every accepted 3-byte form with an 8-bit immediate (`0x80`, `0x83` with `mod = 11`), all 256 third bytes.
- For every 3-byte form with a 16-bit immediate (`B8`–`BF`, `05`, `2D`, `3D`), all 65,536 immediates.
- For every 4-byte form (`0x81`), all 65,536 immediates.

That is 2,502,912 comparisons of status and every field, all identical. Nothing after an instruction's last byte is read by either decoder (the contract tests check truncation at every point), so agreement on these inputs implies agreement on every input of every length.

**Trade-off** (no speed claim). The table puts the manual's first-byte knowledge in one place, the same shape as Table 4-13, which is organized by first byte. The branches express the *patterns* instead: `00ooo0dw` and the shared operation code are visible in the code, and that is what E04.Q asks learners to see. A table is easy to extend to the full instruction set (week 7 onward). Branches make the bit structure explicit and are easier to check against Table 4-12. Either is acceptable. What matters is that equivalence was established over the whole domain, not assumed.
