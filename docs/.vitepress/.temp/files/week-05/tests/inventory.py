"""Check stable IDs, the exact expected set of 26, answer headings, checklist links, identical supplied headers, the
source inventory and local Markdown links."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
pattern = re.compile(r'^### ((?:E\d{2}\.[CQ])|(?:[PSR]\d{2}))$', re.M)
expected = {f'E{i:02}.{suffix}' for i in range(1, 8) for suffix in ['C', 'Q']}
expected |= {f'P{i:02}' for i in range(1, 6)} | {'S01', 'S02'} | {f'R{i:02}' for i in range(1, 6)}
assert len(expected) == 26, 'the plan specifies exactly 26 IDs: 14 milestone, 5 practice, 2 stretch, 5 report'


def collect(files, min_len):
    found = {}
    for file in files:
        text = (root / file).read_text(encoding='utf-8')
        for item in pattern.finditer(text):
            key = item.group(1)
            assert key not in found, f'Duplicate ID: {key}'
            end = text.find('\n### ', item.end())
            body = text[item.end():end if end >= 0 else len(text)].strip()
            assert len(body) >= min_len, f'Empty/placeholder entry: {key} in {file}'
            found[key] = file
    assert set(found) == expected, f'Missing {expected - set(found)}; unexpected {set(found) - expected}'
    return found


collect(['learner/exercises.md', 'learner/practice.md', 'learner/report.md'], 80)
collect(['instructor/answers.md', 'instructor/report.md'], 200)
checklist = (root / 'instructor/coverage.md').read_text(encoding='utf-8')
rows = re.findall(r'^\| ((?:E\d{2}\.[CQ])|(?:[PSR]\d{2})) \|', checklist, re.M)
assert set(rows) == expected and len(rows) == len(expected), 'Checklist gaps/duplicates'
for link in re.findall(r'\]\(([^)]+)\)', checklist):
    path, _, anchor = link.partition('#')
    destination = root / 'instructor' / path
    assert destination.is_file(), f'Broken checklist path: {path}'
    if anchor:
        ids = pattern.findall(destination.read_text(encoding='utf-8'))
        assert anchor in {key.lower().replace('.', '') for key in ids}, f'Broken anchor: {link}'
units = ['csv', 'geo', 'query', 'cli', 'bench', 'main']
for package in ['learner', 'instructor']:
    for u in units:
        assert (root / package / 'geolab' / 'src' / f'{u}.c').is_file(), f'Missing {package}/geolab/src/{u}.c'
    for doc in ['PROTOCOL.md', 'report.md', 'fixtures/README.md']:
        assert (root / package / doc).is_file(), f'Missing {package}/{doc}'
for header in ['geolab.h', 'cli.h', 'bench.h']:
    a = (root / 'learner/geolab/include' / header).read_bytes()
    b = (root / 'instructor/geolab/include' / header).read_bytes()
    assert a == b, f'the supplied header {header} differs between the packages'
assert (root / 'learner/geolab/src/main.c').read_bytes() == (root / 'instructor/geolab/src/main.c').read_bytes()
for support in ['geolab_types.h', 'platform.h', 'monotonic.h', 'geo_consts.h', 'envinfo.h', 'envinfo.c']:
    assert (root / 'support' / support).is_file(), f'Missing support/{support}'
for tool in ['bench_data.py', 'expected.py', 'identity.py', 'manifest.py']:
    assert (root / 'tools' / tool).is_file(), f'Missing tools/{tool}'
for extra in ['bytes_per_point.c', 'vec_report.sh', 'mutate.py']:
    assert (root / 'instructor/extras' / extra).is_file(), f'Missing instructor extra {extra}'
for doc in root.rglob('*.md'):
    if 'build' in doc.parts or 'results' in doc.parts:
        continue
    for target in re.findall(r'\]\((?!https?:|#|mailto:)([^)#\s]+)', doc.read_text(encoding='utf-8')):
        resolved = (doc.parent / target).resolve()
        if root.resolve() not in resolved.parents and not (root.parent / 'PLAN.md').is_file():
            continue  # a link to another week, checked only inside the full course repository
        assert resolved.exists(), f'Broken link in {doc.relative_to(root)}: {target}'
print(f'PASS: {len(expected)} prompts, {len(expected)} written answers, {len(rows)} checklist entries; identical supplied '
      'headers; complete source inventories; local links resolve')
