"""Regenerate (--write) or check (--check) PACKAGE/fixtures/expected/*.txt from the supplied oracle.

Expected outputs are ALWAYS computed by tests/oracle.py, never by the program under test. Run: make expected."""
import argparse
from pathlib import Path
import sys

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'tests'))
import fixture_lib  # noqa: E402

p = argparse.ArgumentParser()
p.add_argument('--package', default='learner')
p.add_argument('--write', action='store_true')
a = p.parse_args()
fixtures = root / a.package / 'fixtures'
rows = fixture_lib.parse_readme(fixtures / 'README.md')
(fixtures / 'expected').mkdir(exist_ok=True)
for name, purpose, arguments in rows:
    text = fixture_lib.expected_text(fixtures / name, arguments)
    target = fixtures / 'expected' / (Path(name).stem + '.txt')
    if a.write:
        target.write_bytes(text.encode('ascii'))
        print(f'wrote {target.relative_to(root)} ({purpose})')
    else:
        assert target.is_file() and target.read_bytes() == text.encode('ascii'), f'{target} differs from the oracle'
print(f'{len(rows)} fixtures')
