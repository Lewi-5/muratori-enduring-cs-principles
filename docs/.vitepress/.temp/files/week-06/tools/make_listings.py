"""Write the supplied listing fixtures (fixtures/listings/NAME.bin and NAME.txt) from the oracle's ENCODING table.

Each listing is an original sequence of instructions chosen for this course. Every instruction's bytes are looked up
in tests/oracle8086.TABLE, which was built in the encoding direction, and its text comes from the same table; the
decoder under test plays no part. Error listings end with a case whose status the oracle's classifier gives.
Run: python3 tools/make_listings.py (the files are committed; tests check they still match)."""
from pathlib import Path
import sys

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'tests'))
import oracle8086 as o  # noqa: E402

LISTINGS = {
    # register-to-register moves: every 16-bit pair direction, both d values, and the 8-bit halves
    'registers': ['89d9', '8bcb', '89c0', '8bc0', '89e5', '8bec', '89f7', '8bfe', '88e0', '8ac4', '88c4', '8ae0',
                  '88fb', '8adf', '89d8', '8bc3', '88ed', '8aed'],
    # immediates at their boundaries: 8-bit and 16-bit, positive, negative, and the s bit
    'immediates': ['b000', 'b07f', 'b080', 'b0ff', 'b10c', 'b40c', 'b80000', 'b8ff7f', 'b80080', 'b8ffff', 'b9f4ff',
                   'bc3412', '80c07f', '80c080', '83c07f', '83c080', '81c00080', '81c0ff7f', '83c6fe', '81c6feff',
                   '80c1fe', '83fb01', '81eb0001'],
    # add, sub and cmp in their register, immediate-to-register and accumulator forms
    'arithmetic': ['01d9', '03cb', '29d9', '2bcb', '39d9', '3bcb', '00e0', '28e0', '38e0', '0405', '0500f0', '2cff',
                   '2d0100', '3c80', '3dfeff', '80c205', '80ea05', '80fa05', '81c20001', '81ea0001', '81fa0001'],
    # a small straight-line program: set up, accumulate, compare
    'program': ['b90a00', 'b80000', 'bb0300', '01d8', '01d8', '83e901', '39c8', '89c2', '2bd1', '80c403', '3d0900'],
}
ERRORS = {
    # (bytes, expected status, offset)
    'truncated_end': ('89d9b9f4', 'DEC_TRUNCATED', 2),
    'unsupported_middle': ('89d9829c0589d9', 'DEC_UNSUPPORTED_OPCODE', 2),
    'memory_mode': ('b10c8807', 'DEC_UNSUPPORTED_MODE', 2),
    'group_or': ('0405 80c9 01'.replace(' ', ''), 'DEC_UNSUPPORTED_OPERATION', 2),
    'jump': ('89d975fc', 'DEC_UNSUPPORTED_OPCODE', 2),
    'resync': ('b889d9', 'DEC_OK', 3),  # decodes as one instruction from 0; from 1 it would be mov cx, bx
}


def build():
    out = {}
    for name, items in LISTINGS.items():
        data = b''.join(bytes.fromhex(h) for h in items)
        lines = []
        for h in items:
            status, length, text = o.expected(bytes.fromhex(h))
            assert status == 'DEC_OK' and length == len(h) // 2, (name, h, status)
            lines.append(text)
        out[name] = (data, 'bits 16\n' + ''.join(l + '\n' for l in lines))
    for name, (h, status, offset) in ERRORS.items():
        data = bytes.fromhex(h)
        pos, lines = 0, []
        while pos < len(data):
            s, length, text = o.expected(data[pos:])
            if s != 'DEC_OK':
                break
            lines.append(text)
            pos += length
        if status == 'DEC_OK':
            assert pos == len(data)
            out[name] = (data, 'bits 16\n' + ''.join(l + '\n' for l in lines))
        else:
            assert (s, pos) == (status, offset), (name, s, pos)
            out[name] = (data, f'error {status} at offset {offset}\n')
    return out


if __name__ == '__main__':
    target = root / 'fixtures' / 'listings'
    target.mkdir(parents=True, exist_ok=True)
    for name, (data, text) in build().items():
        (target / f'{name}.bin').write_bytes(data)
        (target / f'{name}.txt').write_bytes(text.encode('ascii'))
        print(f'{name}: {len(data)} bytes')
