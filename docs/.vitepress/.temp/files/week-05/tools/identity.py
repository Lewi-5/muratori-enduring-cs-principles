"""E07: `query` output must be byte-identical across GCC and Clang at -O0 and -O2 (a toolchain observation, not a C
guarantee; see the answer to E07.Q). Uses the executables `make checkpoint` just built."""
import argparse
import hashlib
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'tests'))
import oracle  # noqa: E402

p = argparse.ArgumentParser()
p.add_argument('--package', default='learner')
a = p.parse_args()
data = root / 'build' / 'data' / 'd100k.csv'
data.parent.mkdir(parents=True, exist_ok=True)
seed, count = oracle.DATASETS['d100k']
if not data.is_file() or hashlib.sha256(data.read_bytes()).hexdigest() != oracle.DIGESTS[(seed, count)]:
    data.write_bytes(oracle.generate(seed, count))
builds = [root / 'build' / a.package / cc / mode / 'geolab' for cc in ('gcc', 'clang') for mode in ('debug', 'optimized')]
queries = [('0', '0', '20016'), ('-33.8688', '151.2093', '2500'), ('89.5', '-120', '800'), ('10', '179.5', '5000')]
for lat, lon, radius in queries:
    digests = {}
    for exe in builds:
        assert exe.is_file(), f'missing {exe}'
        r = subprocess.run([str(exe), 'query', '--input', str(data), '--lat', lat, '--lon', lon, '--radius-km', radius],
                           capture_output=True)
        assert r.returncode == 0, (exe, r.stderr)
        digests[str(exe.relative_to(root))] = hashlib.sha256(r.stdout).hexdigest()
    assert len(set(digests.values())) == 1, f'query {lat} {lon} {radius} differs between builds: {digests}'
    print(f'identical across {len(builds)} builds: query {lat} {lon} {radius} sha256={next(iter(digests.values()))[:16]}')
print('PASS: query output byte-identical across gcc/clang x -O0/-O2')
