"""Check the four ungraded warm-ups. Run: make warmups (also part of make test)."""
import argparse
from pathlib import Path
import shlex
import subprocess

if not __debug__:
    raise SystemExit('Run checks without Python -O / PYTHONOPTIMIZE')
p = argparse.ArgumentParser()
p.add_argument('--build', type=Path, required=True)
p.add_argument('--source', type=Path, required=True)
p.add_argument('--cc', required=True)
p.add_argument('--flags', required=True)
a = p.parse_args()
flags = shlex.split(a.flags)

def run(command, timeout=60):
    r = subprocess.run([str(x) for x in command], capture_output=True, text=True, timeout=timeout)
    assert r.returncode == 0, (command, r.returncode, r.stdout, r.stderr)
    return r.stdout

expected = {
    1: ['add(2, 3, limit=10) -> ok=1 out=5', 'add(7, 3, limit=10) -> ok=1 out=10', 'add(7, 4, limit=10) -> ok=0 out=99',
        'add(18446744073709551615, 1, limit=18446744073709551615) -> ok=0 out=99'],
    2: ['last 7 -> found=1 index=3', 'last 4 -> found=1 index=0', 'last 1 -> found=1 index=4', 'last 9 -> found=0 index=99'],
    3: ['value=0x01020304 bytes (least significant first): 04 03 02 01', 'bits set: 5 in 0x01020304, 32 in 0xFFFFFFFF, 0 in 0'],
    4: ['copy=Geolab length=6'],
}
failed = []
for n in range(1, 5):
    try:
        out = run([a.build / f'w{n:02}']).splitlines()
        if n == 1:  # the fourth line prints ULLONG_MAX, which is platform-dependent; its verdict is not
            assert out[:3] == expected[1][:3] and len(out) == 4 and out[3].endswith(', 1, limit=' + out[3].split('(')[1].split(',')[0] + ') -> ok=0 out=99'), out
        else:
            assert out == expected[n], out
        binary = a.build / f'warmup{n:02}'
        run([a.cc, *flags, '-Isupport', f'-DSOURCE="{(a.source / f"w{n:02}.c").resolve()}"', f'-DWARMUP={n}',
             'tests/warmups.c', '-o', binary])
        assert 'warm-up passed' in run([binary])
        print(f'W{n:02}: passed')
    except AssertionError as e:
        failed.append(n)
        print(f'W{n:02}: not yet passing: {str(e)[:300]}')
if failed:
    raise SystemExit(f'Warm-ups still to finish: {", ".join(f"W{n:02}" for n in failed)}')
print('PASS: all four warm-ups')
