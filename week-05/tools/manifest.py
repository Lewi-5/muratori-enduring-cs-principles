"""E07: write build/PACKAGE/MANIFEST.txt, the list of submitted files with their SHA-256, and report missing items."""
import argparse
import hashlib
from pathlib import Path
import sys

root = Path(__file__).resolve().parents[1]
p = argparse.ArgumentParser()
p.add_argument('--package', default='learner')
a = p.parse_args()
pkg = root / a.package
required = [pkg / 'geolab' / 'src' / f'{u}.c' for u in ('csv', 'geo', 'query', 'cli', 'bench', 'main')]
required += [pkg / 'fixtures' / 'README.md', pkg / 'PROTOCOL.md', pkg / 'report.md', root / 'Makefile']
files = sorted(set(required) | set((pkg / 'geolab').rglob('*.[ch]')) | set((pkg / 'fixtures').rglob('*')))
results = root / 'results'
if results.is_dir():
    files += sorted(results.glob('*'))
lines, missing = [], []
for f in files:
    if f.is_file():
        lines.append(f'{hashlib.sha256(f.read_bytes()).hexdigest()}  {f.relative_to(root)}')
    elif f in required:
        missing.append(str(f.relative_to(root)))
out = root / 'build' / a.package / 'MANIFEST.txt'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text('\n'.join(lines) + '\n')
print(f'manifest: {len(lines)} files -> {out.relative_to(root)}')
if not results.is_dir():
    print('note: results/ does not exist yet; run make bench-data before submitting')
if missing:
    print('missing required files:', ', '.join(missing))
    sys.exit(1)
