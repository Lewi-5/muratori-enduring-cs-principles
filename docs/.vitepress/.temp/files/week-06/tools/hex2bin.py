"""Write hexadecimal bytes to a binary file for the playground: python3 tools/hex2bin.py OUT.bin 89 d9 83 c6 fe
Spaces are optional ("89d983c6fe" works too). Nothing but the given bytes is written: no newline, no header."""
import sys

if len(sys.argv) < 3:
    raise SystemExit('usage: hex2bin.py OUT.bin HEX [HEX ...]')
data = bytes.fromhex(''.join(sys.argv[2:]))
with open(sys.argv[1], 'wb') as f:
    f.write(data)
print(f'wrote {len(data)} bytes to {sys.argv[1]}')
