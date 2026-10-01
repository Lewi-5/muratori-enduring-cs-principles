"""The unfinished learner scaffolds must compile warning-clean and must FAIL every C contract suite."""
import argparse
from pathlib import Path
import subprocess
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
import oracle  # noqa: E402

p = argparse.ArgumentParser()
p.add_argument('--cc', required=True)
a = p.parse_args()
build = Path(f'build/learner/{a.cc}/debug').resolve()
tmp, orc = build / 'tmp', build / 'oracle'
tmp.mkdir(parents=True, exist_ok=True)
orc.mkdir(parents=True, exist_ok=True)
oracle.write_c_files(orc)
flags = ['-std=c11', '-Wall', '-Wextra', '-Wpedantic', '-Werror', '-ffp-contract=off', '-O0']
for n in range(1, 8):
    exe = build / f'starter_contract{n:02}'
    r = subprocess.run([a.cc, *flags, '-Isupport', '-Itests', f'-DSOURCE="{Path(f"learner/src/ex{n:02}.c").resolve()}"', f'-DEXERCISE={n}',
                        f'-DTEST_TMPDIR="{tmp}"', f'-DORACLE_DIR="{orc}"', f'-DFIXTURE_DIR="{Path("fixtures").resolve()}"',
                        'tests/contracts.c', '-o', str(exe), '-lm'], capture_output=True, text=True)
    assert r.returncode == 0, f'the contract suite must compile against the scaffold for E{n:02}:\n{r.stderr}'
    r = subprocess.run([str(exe)], capture_output=True, text=True, timeout=300)
    assert r.returncode != 0 and 'contract passed' not in r.stdout, f'the unfinished E{n:02} scaffold must fail its suite'
print('PASS: all seven learner scaffolds compile and fail their contract suites (as they must until implemented)')
