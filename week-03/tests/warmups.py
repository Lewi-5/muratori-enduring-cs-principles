"""Check the four ungraded warm-ups. Run: make warmups (also part of make test)."""
import argparse
from pathlib import Path
import re
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

failed = []
for n in range(1, 5):
    try:
        # the supplied driver runs and prints its fixed lines
        out = run([a.build / f'w{n:02}']).splitlines()
        if n == 1 and out[0].endswith('checked'):
            assert out[1:] == ['value=1.0 bits=0x3FF0000000000000 memory=' + ('00 00 00 00 00 00 F0 3F' if out[1].endswith('3F') else '3F F0 00 00 00 00 00 00'),
                               'value=-2.0 bits=0xC000000000000000 memory=' + ('00 00 00 00 00 00 00 C0' if out[1].endswith('3F') else 'C0 00 00 00 00 00 00 00'),
                               'value=0.5 bits=0x3FE0000000000000 memory=' + ('00 00 00 00 00 00 E0 3F' if out[1].endswith('3F') else '3F E0 00 00 00 00 00 00')], out
        if n == 2 and out[0].endswith('checked'):
            assert out[1:] == ['x=1 gap=0x1p-52 absorbs_one=0', 'x=2 gap=0x1p-51 absorbs_one=0', 'x=1024 gap=0x1p-42 absorbs_one=0',
                               'x=2^52 gap=0x1p+0 absorbs_one=0', 'x=2^53 gap=0x1p+1 absorbs_one=1', 'x=-1 gap=0x1p-53 absorbs_one=0'], out
        if n == 3:
            assert out == ['wrap(0)=0', 'wrap(179)=179', 'wrap(180)=-180', 'wrap(190)=-170', 'wrap(-180)=-180',
                           'wrap(-190)=170', 'wrap(539)=179', 'wrap(-540)=-180'], out
        if n == 4:
            assert out == ['left=1', 'right=-1', 'collinear=0'], out
        # the contract checks
        binary = a.build / f'warmup{n:02}'
        run([a.cc, *flags, '-Isupport', f'-DSOURCE="{(a.source / f"w{n:02}.c").resolve()}"', f'-DWARMUP={n}',
             'tests/warmups.c', '-o', binary, '-lm'])
        result = run([binary])
        assert 'warm-up passed' in result, result
        if n in (1, 2):  # forced-skip build: tests the gating path, not another ABI
            skip = a.build / f'warmupskip{n:02}'
            run([a.cc, *flags, '-Isupport', '-DGEO_FORCE_NO_IEC', f'-DSOURCE="{(a.source / f"w{n:02}.c").resolve()}"',
                 f'-DWARMUP={n}', 'tests/warmups.c', '-o', skip, '-lm'])
            assert 'checks skipped' in run([skip]), 'forced-skip build did not take the skip path'
        print(f'W{n:02}: passed' + (' (binary64 checks skipped)' if 'skipped' in result else ''))
    except AssertionError as e:
        failed.append(n)
        print(f'W{n:02}: not yet passing: {str(e)[:300]}')
if failed:
    raise SystemExit(f'Warm-ups still to finish: {", ".join(f"W{n:02}" for n in failed)}')
print('PASS: all four warm-ups')
