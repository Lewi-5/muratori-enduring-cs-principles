"""E07: run the package's own test cases (PACKAGE/cases.txt) against the oracle AND the decoder.

Format, one case per line; blank lines and lines starting with # are ignored:
    HEX BYTES | EXPECTED | REASON
HEX BYTES are pairs of hexadecimal digits (spaces allowed). EXPECTED is either the canonical text of every
instruction in the stream, separated by "; ", or STATUS@OFFSET for a stream whose decoding fails (for example
DEC_TRUNCATED@2). REASON says in one line what the case would catch. At least eight cases, each with a reason of at
least ten characters, and no two with the same bytes. A case fails when the oracle disagrees with EXPECTED (the hand
derivation is wrong) or when decode8086 disagrees with it (the decoder is wrong)."""
import argparse
from pathlib import Path
import subprocess
import sys
import tempfile

sys.path.insert(0, str(Path(__file__).resolve().parent))
import oracle8086 as o  # noqa: E402

p = argparse.ArgumentParser()
p.add_argument('--cases', type=Path, required=True)
p.add_argument('--tool', type=Path, required=True)
a = p.parse_args()


def oracle_stream(data):
    pos, texts = 0, []
    while pos < len(data):
        status, length, text = o.expected(data[pos:])
        if status != 'DEC_OK':
            return f'{status}@{pos}'
        texts.append(text)
        pos += length
    return '; '.join(texts)


problems, seen, count = [], set(), 0
lines = a.cases.read_text(encoding='utf-8').splitlines() if a.cases.is_file() else []
for number, line in enumerate(lines, start=1):
    if not line.strip() or line.lstrip().startswith('#'):
        continue
    parts = [x.strip() for x in line.split('|')]
    if len(parts) != 3:
        problems.append(f'line {number}: expected "HEX | EXPECTED | REASON"')
        continue
    hexbytes, expected, reason = parts
    try:
        data = bytes.fromhex(hexbytes)
    except ValueError:
        problems.append(f'line {number}: bad hexadecimal {hexbytes!r}')
        continue
    count += 1
    if len(reason) < 10:
        problems.append(f'line {number}: the reason is missing or too short')
    if data in seen:
        problems.append(f'line {number}: duplicate bytes {data.hex()}')
    seen.add(data)
    try:
        truth = oracle_stream(data)
    except o.Unsampled as e:
        problems.append(f'line {number}: the oracle does not enumerate this 16-bit immediate ({e}); pick another value')
        continue
    if truth != expected:
        problems.append(f'line {number}: your expectation {expected!r} disagrees with the oracle {truth!r}')
        continue
    with tempfile.NamedTemporaryFile(suffix='.bin', delete=False) as f:
        f.write(data)
        path = f.name
    r = subprocess.run([str(a.tool), path], capture_output=True, text=True)
    Path(path).unlink()
    if '@' in expected:
        status, offset = expected.split('@')
        got = r.stderr == f'decode8086: {status} at offset {offset}\n' and r.returncode == 1 and r.stdout == ''
    else:
        got = r.returncode == 0 and r.stdout == 'bits 16\n' + ''.join(t + '\n' for t in expected.split('; '))
    if not got:
        problems.append(f'line {number}: decode8086 disagrees ({r.returncode}, {r.stdout!r}, {r.stderr!r})')
if count < 8:
    problems.append(f'{a.cases}: {count} cases; at least 8 are required')
for problem in problems:
    print('FAIL:', problem)
print(f'E07 cases: {count} cases, {len(problems)} problem(s)')
sys.exit(1 if problems else 0)
