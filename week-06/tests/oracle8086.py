"""Independent oracle for the week-6 8086 subset (supplied; the learner does not write another one).

Two separate parts, neither of which decodes instructions the way the C decoder does:

1. ENCODER. For every form in the course table, every register choice, every d/s/w value and a fixed set of
   immediates, it builds the instruction's bytes FROM its operands and writes the canonical text. Expected text
   for a successful decode always comes from this table: bytes that the encoder never produced are never given a
   text by the oracle.
2. CLASSIFIER. For byte sequences that are not complete encodings, a separate documented rule table
   (FIRST_BYTE_FORMS, derived from the course table, below) says which status the decoder must report, following
   the plan's status order: unsupported opcode, truncated ModR/M, unsupported mode, unsupported operation,
   truncated immediate. If a sequence is long enough, supported and yet not in the encoder's table, the oracle
   raises Unsampled rather than guessing: that means the test chose an immediate the encoder did not enumerate.

The course table was checked entry by entry against the 8086 Family User's Manual (see instructor/validation.md).
"""
import itertools

REG8 = ['al', 'cl', 'dl', 'bl', 'ah', 'ch', 'dh', 'bh']
REG16 = ['ax', 'cx', 'dx', 'bx', 'sp', 'bp', 'si', 'di']
OPS = {'add': 0b000, 'sub': 0b101, 'cmp': 0b111}   # the shared 3-bit operation code
TRAILER = (0x34, 0x12)  # the bytes the exhaustive test appends after every two-byte prefix
# 16-bit immediates: boundaries, a deterministic sample, and every value the exhaustive test can form: 0x1234 (both
# trailer bytes) and 0x34XX (second byte XX, then the first trailer byte).
IMM16_SAMPLE = sorted({0, 1, 2, 12, 0x7F, 0x80, 0xFF, 0x100, 0x1234, 0x1389, 0x3412, 0x7FFF, 0x8000, 0x8001, 0xFFF4,
                       0xFFFE, 0xFFFF, 0x0180, 0x80FE, 0xFE80, 0xFEFE, 0x8080, 0xD989}
                      | {(i * 40503 + 12345) % 65536 for i in range(48)} | set(range(17)) | {0xF000, 0x0081, 0x00F6}
                      | {TRAILER[0] << 8 | x for x in range(256)})


class Unsampled(Exception):
    pass


def reg(wide, r):
    return (REG16 if wide else REG8)[r]


def signed(value, wide):
    """The signed value of an 8- or 16-bit pattern, by arithmetic (never a narrowing conversion)."""
    bits = 16 if wide else 8
    return value - (1 << bits) if value >= 1 << (bits - 1) else value


def modrm(mod, r, rm):
    return (mod << 6) | (r << 3) | rm


def le16(v):
    return [v & 0xFF, v >> 8]


def encodings():
    """Yield (bytes, text) for the whole enumerated subset."""
    for d, w, r, m in itertools.product((0, 1), (0, 1), range(8), range(8)):
        dst, src = (reg(w, r), reg(w, m)) if d else (reg(w, m), reg(w, r))
        yield bytes([0b10001000 | d << 1 | w, modrm(3, r, m)]), f'mov {dst}, {src}'
        for name, op in OPS.items():
            yield bytes([op << 3 | d << 1 | w, modrm(3, r, m)]), f'{name} {dst}, {src}'
    for w, r in itertools.product((0, 1), range(8)):
        for v in (range(256) if w == 0 else IMM16_SAMPLE):
            data = [v] if w == 0 else le16(v)
            yield bytes([0b10110000 | w << 3 | r] + data), f'mov {reg(w, r)}, {signed(v, w)}'
    for (name, op), m in itertools.product(OPS.items(), range(8)):
        for v in range(256):  # s:w = 00 (8-bit) and 11 (8-bit sign-extended to 16)
            yield bytes([0x80, modrm(3, op, m), v]), f'{name} {reg(0, m)}, {signed(v, 0)}'
            yield bytes([0x83, modrm(3, op, m), v]), f'{name} {reg(1, m)}, {signed(v, 0)}'
        for v in IMM16_SAMPLE:  # s:w = 01
            yield bytes([0x81, modrm(3, op, m)] + le16(v)), f'{name} {reg(1, m)}, {signed(v, 1)}'
    for name, op in OPS.items():
        for v in range(256):
            yield bytes([op << 3 | 0b100, v]), f'{name} al, {signed(v, 0)}'
        for v in IMM16_SAMPLE:
            yield bytes([op << 3 | 0b101] + le16(v)), f'{name} ax, {signed(v, 1)}'


TABLE = {}
for _b, _t in encodings():
    assert _b not in TABLE or TABLE[_b] == _t, f'two texts for one encoding {_b.hex()}'
    TABLE[_b] = _t

# The classifier's rule table: for each supported first byte, (needs ModR/M, immediate bytes as a function of the
# first byte, whether the ModR/M reg field selects the operation). Derived from the course table, written separately
# from the encoder above.
FIRST_BYTE_FORMS = {}
for b in range(0x88, 0x8C):
    FIRST_BYTE_FORMS[b] = ('modrm', 0, False)
for b in range(0xB0, 0xC0):
    FIRST_BYTE_FORMS[b] = ('none', 2 if b & 0b1000 else 1, False)
for base in (0x00, 0x28, 0x38):
    for low in range(4):
        FIRST_BYTE_FORMS[base | low] = ('modrm', 0, False)
    FIRST_BYTE_FORMS[base | 0b100] = ('none', 1, False)
    FIRST_BYTE_FORMS[base | 0b101] = ('none', 2, False)
FIRST_BYTE_FORMS[0x80] = ('modrm', 1, True)
FIRST_BYTE_FORMS[0x81] = ('modrm', 2, True)
FIRST_BYTE_FORMS[0x83] = ('modrm', 1, True)
# 0x82 (s:w = 10) is deliberately absent: the 1979 manual lists it, the course excludes it (a scope decision).


def expected(stream):
    """(status, length, text) for the first instruction of stream. length is 0 and text None on failure."""
    stream = bytes(stream)
    for n in (2, 3, 4):
        if stream[:n] in TABLE and len(stream) >= n:
            return 'DEC_OK', n, TABLE[stream[:n]]
    if len(stream) == 0:
        return 'DEC_TRUNCATED', 0, None
    form = FIRST_BYTE_FORMS.get(stream[0])
    if form is None:
        return 'DEC_UNSUPPORTED_OPCODE', 0, None
    kind, imm_bytes, op_in_reg = form
    need = 1 + imm_bytes
    if kind == 'modrm':
        if len(stream) < 2:
            return 'DEC_TRUNCATED', 0, None
        if stream[1] >> 6 != 0b11:
            return 'DEC_UNSUPPORTED_MODE', 0, None
        if op_in_reg and (stream[1] >> 3) & 7 not in OPS.values():
            return 'DEC_UNSUPPORTED_OPERATION', 0, None
        need += 1
    if len(stream) < need:
        return 'DEC_TRUNCATED', 0, None
    raise Unsampled(stream[:need].hex())


# ---- S01 (optional stretch): the twenty short branches, in the encoding direction ------------------------------------
# The course prints these mnemonics (NASM accepts all of them; objdump prints je/jne/jae/jge/loope/loopne for four of
# the aliases, and the cross-check maps them). The target is printed relative to the start of the instruction, like
# NASM's `$`: the displacement is relative to the NEXT instruction, which starts 2 bytes later, so `$+(2 + disp)`.
JUMPS = {0x70: 'jo', 0x71: 'jno', 0x72: 'jb', 0x73: 'jnb', 0x74: 'jz', 0x75: 'jnz', 0x76: 'jbe', 0x77: 'ja',
         0x78: 'js', 0x79: 'jns', 0x7A: 'jp', 0x7B: 'jnp', 0x7C: 'jl', 0x7D: 'jnl', 0x7E: 'jle', 0x7F: 'jg',
         0xE0: 'loopnz', 0xE1: 'loopz', 0xE2: 'loop', 0xE3: 'jcxz'}
OBJDUMP_ALIASES = {'je': 'jz', 'jne': 'jnz', 'jae': 'jnb', 'jge': 'jnl', 'loope': 'loopz', 'loopne': 'loopnz'}


def jump_encodings():
    for opcode, name in JUMPS.items():
        for disp in range(-128, 128):
            rel = 2 + disp
            yield bytes([opcode, disp & 0xFF]), f'{name} ${"+" if rel >= 0 else "-"}{abs(rel)}'


def self_test():
    # known answers checked by hand against the manual's encoding tables (validation.md)
    known = {'89d9': 'mov cx, bx', '8bcb': 'mov cx, bx', 'b10c': 'mov cl, 12', 'b9f4ff': 'mov cx, -12',
             '83c6fe': 'add si, -2', '81c6feff': 'add si, -2', '80c1fe': 'add cl, -2', '0405': 'add al, 5',
             '2d0001': 'sub ax, 256', '3cff': 'cmp al, -1', '28e0': 'sub al, ah', '88e4': 'mov ah, ah',
             '3bc3': 'cmp ax, bx', '81fe0080': 'cmp si, -32768', 'b88913': 'mov ax, 5001'}
    for hexbytes, text in known.items():
        assert expected(bytes.fromhex(hexbytes)) == ('DEC_OK', len(hexbytes) // 2, text), hexbytes
    assert expected(bytes.fromhex('82c105'))[0] == 'DEC_UNSUPPORTED_OPCODE'
    assert expected(bytes.fromhex('80c905'))[0] == 'DEC_UNSUPPORTED_OPERATION'
    assert expected(bytes.fromhex('8807'))[0] == 'DEC_UNSUPPORTED_MODE'
    assert expected(bytes.fromhex('81c6fe'))[0] == 'DEC_TRUNCATED'
    assert expected(b'\x89')[0] == 'DEC_TRUNCATED'
    assert expected(b'\x90')[0] == 'DEC_UNSUPPORTED_OPCODE'
    # the operation code is shared: bits 5..3 of the register/accumulator forms and reg of 0x80..0x83
    for name, op in OPS.items():
        assert TABLE[bytes([op << 3 | 1, 0xD9])].startswith(name) and TABLE[bytes([0x81, modrm(3, op, 1), 1, 0])].startswith(name)
    # prefix-free: no complete encoding is a proper prefix of another
    lengths = {}
    for b in TABLE:
        lengths.setdefault(b[:2], set()).add(len(b))
    assert all(len(v) == 1 for v in lengths.values()), 'length must be determined by the first two bytes'


if __name__ == '__main__':
    self_test()
    print(f'oracle self-test passed ({len(TABLE)} encodings)')
