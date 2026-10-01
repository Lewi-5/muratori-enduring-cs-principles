"""Dependency-free orchestration only; all exercise implementations are C."""
import argparse
import math
from pathlib import Path
import re
import shlex
import statistics
import subprocess
import tempfile

p = argparse.ArgumentParser()
p.add_argument('--build', type=Path, required=True)
p.add_argument('--source', type=Path, required=True)
p.add_argument('--cc', required=True)
p.add_argument('--flags', required=True)
a = p.parse_args()

def run(command, success=True):
    result = subprocess.run([str(x) for x in command], capture_output=True, text=True, timeout=30)
    assert (result.returncode == 0) == success, (command, result.returncode, result.stdout, result.stderr)
    if not success:
        assert result.stderr.strip(), (command, 'missing error message')
    return result.stdout

def ex(number, *args, success=True):
    return run([a.build / f'ex{number:02}', *args], success)

def fields(text):
    return dict(re.findall(r'(\w+)=([^\s]+)', text))

assert ex(1).splitlines()[0] == 'signed=-7 unsigned=7 long=-42 ull=42'
r = {k: int(v) for k, v in fields(ex(1)).items()}
assert r['int_min'] <= -32767 and r['int_max'] >= 32767 and r['uint_max'] >= 65535
r = {k: int(v) for k, v in fields(ex(2)).items()}
assert r['char'] == 1 and 1 <= r['short'] <= r['int'] <= r['long']
assert r['array'] == 5 * r['element'] and r['element'] == r['int'] and r['length'] == 5
assert r['parameter'] == r['pointer'] and r['pointer'] > 0
for n, expected in [('0', 0), ('1', 1), ('10', 55), ('10000', 50005000)]:
    assert ex(3, n).strip() == f'sum={expected}'
for bad in ['', '-1', '+1', '1x', '10001', '9999999999999999999999999999999']:
    ex(3, bad, success=False)
ex(3, success=False)
assert ex(4).strip() == 'clamped=8'
assert ex(5).strip() == 'count=4 min=-2 max=7'
assert ex(6).strip() == 'index=16 pointer=16'
assert ex(7).strip() == 'id=42 lat=45.5 lon=-73.5'
lines = ex(8).splitlines()
sizes = {k: int(v) for k, v in fields(lines[0]).items()}
for line, order in zip(lines[1:], [('tag', 'value', 'count'), ('value', 'count', 'tag')]):
    layout = {k: int(v) for k, v in fields(line).items()}
    widths = {'tag': sizes['char'], 'value': sizes['double'], 'count': sizes['int']}
    assert layout[order[0]] == 0
    for left, right in zip(order, order[1:]):
        assert layout[right] >= layout[left] + widths[left]
    assert layout['size'] >= layout[order[-1]] + widths[order[-1]]
lines = ex(9).splitlines()
r = fields(lines[0])
bytes_ = [int(x, 16) for x in lines[1].split()]
assert len(bytes_) == int(r['bytes']) and int(r['char_bits']) * len(bytes_) == 32
assert all(0 <= x < 2 ** int(r['char_bits']) for x in bytes_)
order = fields(lines[2])['order']
if int(r['char_bits']) == 8:
    assert sorted(bytes_) == [1, 2, 3, 4]
    expected_order = 'little' if bytes_ == [4, 3, 2, 1] else 'big' if bytes_ == [1, 2, 3, 4] else 'other'
    assert order == expected_order
assert ex(10).strip() == 'set=1 test=1 toggle=3 clear=2'
for n, total in [(0, 0), (1, 0), (5, 10), (101, 4950), (1000000, 49500000)]:
    assert ex(11, str(n)).strip() == f'count={n} sum={total}'
for bad in ['1000001', '-1', '', '9999999999999999999999999999999']:
    ex(11, bad, success=False)
ex(11, success=False)
with tempfile.TemporaryDirectory() as directory:
    root = Path(directory)
    for name, data in [('empty', b''), ('normal', b'one\ntwo\n'), ('tail', b'one\ntwo'), ('binary', b'\x00\xff\n')]:
        path = root / name
        path.write_bytes(data)
        assert ex(12, path).strip() == f'bytes={len(data)} newlines={data.count(bytes([10]))}'
    ex(12, root / 'missing', success=False)
    # On Linux fopen(directory) can succeed, but reading it reports an error.
    ex(12, root, success=False)
ex(12, success=False)
for text, value in [('0', 0), ('00042', 42), ('1000000', 1000000)]:
    assert ex(13, text).strip() == f'value={value}'
for bad in ['', '-1', '+1', ' 1', '1 ', '1x', '0x10', '1000001', '9999999999999999999999999999999']:
    ex(13, bad, success=False)
ex(13, success=False)
assert ex(14).strip() == 'matches=3'
lines = ex(15).splitlines()
assert fields(lines[0]) == dict(size='1024', iterations='1000', trials='5', expected='49776')
assert len(lines) == 7
samples = []
for i, line in enumerate(lines[1:6], 1):
    r = fields(line)
    assert int(r['trial']) == i and int(r['checksum']) == 49776000
    elapsed = float(r['seconds'])
    assert math.isfinite(elapsed) and elapsed >= 0
    samples.append(elapsed)
summary = {k: float(v) for k, v in fields(lines[-1]).items()}
for key, value in dict(median=statistics.median(samples), min=min(samples), max=max(samples), range=max(samples)-min(samples)).items():
    assert abs(summary[key] - value) <= 2e-9
for n in [3, 4, 5, 6, 7, 10, 11, 13, 14]:
    source = a.source / ('ex14_count.c' if n == 14 else f'ex{n:02}.c')
    binary = a.build / f'contract{n:02}'
    run([a.cc, *shlex.split(a.flags), '-Isupport', f'-DSOURCE="{source.resolve()}"', f'-DEXERCISE={n}', 'tests/contracts.c', '-o', binary])
    run([binary])
for n in [11, 12]:
    source = a.source / f'ex{n:02}.c'
    binary = a.build / f'fault{n:02}'
    run([a.cc, *shlex.split(a.flags), '-Isupport', f'-DSOURCE="{source.resolve()}"', f'-DEXERCISE={n}', 'tests/faults.c', '-o', binary])
    run([binary])
if a.source.parts[0] == 'instructor':
    for name in ['practice_sizeof', 'stretch_lines']:
        run([a.cc, *shlex.split(a.flags), f'instructor/extras/{name}.c', '-o', a.build / name])
    lines = run([a.build / 'practice_sizeof']).splitlines()
    r = {k: int(v) for k, v in fields(lines[0]).items()}
    assert r['array'] == 3 * r['element'] and r['length'] == 3
    assert fields(lines[1])['first'] == '2' and lines[2] == 'sum=12'
    with tempfile.TemporaryDirectory() as directory:
        path = Path(directory) / 'input'
        for data, count in [(b'', 0), (b'\n', 1), (b'one\ntwo\n', 2), (b'one\ntwo', 2), (b'a\n\n', 2), (b'x', 1)]:
            path.write_bytes(data)
            assert run([a.build / 'stretch_lines', path]).strip() == f'bytes={len(data)} newlines={data.count(bytes([10]))} lines={count}'
        run([a.build / 'stretch_lines', Path(directory) / 'missing'], success=False)
        run([a.build / 'stretch_lines', directory], success=False)
print('PASS: 15 executable contracts; 9 C boundary suites; allocation/read/close faults; numeric errors; benchmark statistics; instructor extras where applicable')
