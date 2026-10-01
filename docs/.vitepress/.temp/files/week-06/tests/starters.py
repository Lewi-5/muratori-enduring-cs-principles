"""The unfinished learner scaffolds must compile warning-clean and must FAIL every contract suite for unimplemented
behavior: each suite compiles, runs, and does not pass; check.py completes without a Python traceback."""
import argparse
from pathlib import Path
import subprocess

p = argparse.ArgumentParser()
p.add_argument('--cc', required=True)
a = p.parse_args()
build = Path(f'build/learner/{a.cc}/debug')
r = subprocess.run(['python3', 'tests/check.py', '--build', str(build), '--source', 'learner/src', '--cc', a.cc,
                    '--flags', '-std=c11 -Wall -Wextra -Wpedantic -Werror -O0'], capture_output=True, text=True, timeout=1800)
out = r.stdout + r.stderr
assert r.returncode != 0, 'the unfinished learner package must fail its checks'
assert 'Traceback' not in out, f'the harness failed on the scaffold:\n{out[-3000:]}'
assert 'did not compile' not in out, f'a contract suite must compile against the scaffold:\n{out[-3000:]}'
assert 'contract passed' not in out and 'PASS:' not in out, 'no suite may pass against the unfinished scaffold'
for n in range(1, 7):
    assert f'contract E{n:02} failed' in out, f'the E{n:02} scaffold must fail its suite'
print(f'PASS: the {a.cc} learner scaffold compiles and fails all six contract suites and {out.count("FAIL:")} checks in total')
