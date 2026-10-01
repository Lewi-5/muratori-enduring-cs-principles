"""Run the E05 timing protocol (make bench-data) and write raw outputs. Nothing about time is asserted.

The protocol, fixed before any data is collected (see PROTOCOL.md):
- datasets: the oracle's d1k (seed 1), d100k (seed 11400714819323198485) and d1m (seed 5), generated into build/data
  and checked against recorded SHA-256 digests;
- builds: -O2 with VEC=off and -O2 with VEC=default, at distinct paths;
- variants: distance and query at every size, parse at d100k; query center (10, 20), radius 2000 km;
- repeat 21, warm-up 3, five separate process runs;
- order: interleaved; within each run every (size, variant) pair runs both builds, and the build order alternates
  between runs so neither build always goes first;
- stopping rule: all five runs are reported as recorded; a run is repeated only for a documented fault (a nonzero
  exit, a checksum that differs between builds), and the fault is written to faults.txt.
The script checks the file set and that every line parses; it then writes summary.md (medians of medians, ranges).
"""
import argparse
import hashlib
from pathlib import Path
import re
import statistics
import subprocess
import sys

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'tests'))
import oracle  # noqa: E402

p = argparse.ArgumentParser()
p.add_argument('--package', default='learner')
p.add_argument('--cc', default='gcc')
p.add_argument('--out', type=Path, default=Path('results'))
p.add_argument('--quick', action='store_true', help='smoke test: one run, d1k only, repeat 3')
a = p.parse_args()

RUNS, REPEAT, WARMUP = (1, 3, 1) if a.quick else (5, 21, 3)
SIZES = ['d1k'] if a.quick else ['d1k', 'd100k', 'd1m']
BUILDS = ['vec-off', 'vec-default']
LINE_RE = re.compile(r'bench variant=(\w+) points=(\d+) warmup=(\d+) repeat=(\d+) resolution_ns=(\d+) min_ns=(\d+) '
                     r'median_ns=(\d+) max_ns=(\d+) median_ns_per_point=([\d.]+) short_samples=(\d+) checksum=(\S+)')

data_dir = root / 'build' / 'data'
data_dir.mkdir(parents=True, exist_ok=True)
paths = {}
for name in SIZES:
    seed, count = oracle.DATASETS[name]
    path = data_dir / f'{name}.csv'
    want = oracle.DIGESTS[(seed, count)]
    if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != want:
        path.write_bytes(oracle.generate(seed, count))
    assert hashlib.sha256(path.read_bytes()).hexdigest() == want, f'{name}: digest mismatch'
    paths[name] = path

exe = {b: root / 'build' / a.package / a.cc / f'bench-{b}' / 'geolab' for b in BUILDS}
for b, e in exe.items():
    assert e.is_file(), f'missing {e}: run make bench-bins first'
out = a.out if a.out.is_absolute() else root / a.out
out.mkdir(parents=True, exist_ok=True)

jobs = [(size, 'distance') for size in SIZES] + [(size, 'query') for size in SIZES]
if 'd100k' in SIZES:
    jobs.append(('d100k', 'parse'))
index, faults = [], []
for run in range(1, RUNS + 1):
    for size, variant in jobs:
        order = BUILDS if run % 2 == 1 else BUILDS[::-1]
        for build in order:
            argv = [str(exe[build]), 'bench', '--input', str(paths[size]), '--variant', variant, '--repeat', str(REPEAT),
                    '--warmup', str(WARMUP), '--lat', '10', '--lon', '20', '--radius-km', '2000']
            name = f'run{run}_{a.cc}_{build}_{variant}_{size}.txt'
            r = subprocess.run(argv, capture_output=True, text=True)
            (out / name).write_text(r.stdout + (f'# stderr: {r.stderr}' if r.stderr else ''))
            if r.returncode != 0:
                faults.append(f'{name}: exit {r.returncode}: {r.stderr.strip()}')
            index.append((name, run, a.cc, build, variant, size, ' '.join(argv[1:])))
(out / 'index.csv').write_text('file,run,cc,build,variant,size,command\n' +
                               ''.join(','.join(str(x) for x in row) + '\n' for row in index))

# Check the file set and parse every line; record faults.
rows = {}
for name, run, cc, build, variant, size, _cmd in index:
    lines = (out / name).read_text().splitlines()
    m = LINE_RE.fullmatch(lines[-1]) if lines else None
    if m is None:
        faults.append(f'{name}: no parsable bench line')
        continue
    assert all(l.startswith('env ') for l in lines[:-1]), name
    rows[name] = (run, build, variant, size, int(m.group(6)), int(m.group(7)), int(m.group(8)), float(m.group(9)),
                  int(m.group(10)), m.group(11))
checks = {}
for run, build, variant, size, *_rest, checksum in rows.values():
    checks.setdefault((variant, size), set()).add(checksum)
for key, values in checks.items():
    if len(values) != 1:
        faults.append(f'{key}: checksums differ between runs or builds: {sorted(values)}')
(out / 'faults.txt').write_text(''.join(f + '\n' for f in faults) or 'none\n')

# Summary: for each (variant, size, build) the five process-run medians (ns per point), their range, and the
# largest within-run spread (max - min) / median.
summary = ['| variant | size | build | run medians (ns/point) | median of runs | range of runs | max within-run spread | short samples |',
           '| --- | --- | --- | --- | --- | --- | --- | --- |']
for size, variant in jobs:
    for build in BUILDS:
        sel = [v for v in rows.values() if v[1] == build and v[2] == variant and v[3] == size]
        if not sel:
            continue
        per_point = [v[7] for v in sorted(sel)]
        spreads = [((v[6] - v[4]) / v[5]) if v[5] else float('nan') for v in sel]
        shorts = sum(v[8] for v in sel)
        summary.append(f'| {variant} | {size} | {build} | {", ".join(f"{x:.2f}" for x in per_point)} | '
                       f'{statistics.median(per_point):.2f} | {min(per_point):.2f}–{max(per_point):.2f} | '
                       f'{max(spreads):.3f} | {shorts} |')
(out / 'summary.md').write_text('\n'.join(summary) + '\n')
print('\n'.join(summary))
print(f'{len(index)} raw files in {out}; faults: {len(faults)}')
sys.exit(1 if faults or len(rows) != len(index) else 0)
