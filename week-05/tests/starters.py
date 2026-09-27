"""The unfinished learner project must compile warning-clean and must FAIL `make test` for unimplemented behavior:
every contract suite compiles, check.py runs to completion (no Python traceback), and it reports failures."""
import argparse
from pathlib import Path
import subprocess

p = argparse.ArgumentParser()
p.add_argument('--cc', required=True)
a = p.parse_args()
build = Path(f'build/learner/{a.cc}/debug')
flags = '-std=c11 -Wall -Wextra -Wpedantic -Werror -ffp-contract=off -D_POSIX_C_SOURCE=200809L -O0'
r = subprocess.run(['python3', 'tests/check.py', '--build', str(build), '--package', 'learner', '--cc', a.cc,
                    '--flags', flags, '--include', 'learner/geolab/include'], capture_output=True, text=True, timeout=1800)
out = r.stdout + r.stderr
assert r.returncode != 0, 'the unfinished learner project must fail its checks'
assert 'Traceback' not in out, f'the harness itself failed on the scaffold:\n{out[-3000:]}'
assert 'did not compile' not in out, f'a contract suite must compile against the scaffold:\n{out[-3000:]}'
assert 'contract passed' not in out, 'no contract suite may pass against the unfinished scaffold'
fails = out.count('FAIL:')
print(f'PASS: the {a.cc} learner scaffold compiles and fails {fails} behavioral checks (as it must until implemented)')
