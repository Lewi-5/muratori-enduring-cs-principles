"""Check stable IDs, the exact expected set of 27, answer headings, checklist links, the identical supplied header,
the source inventory, the fixtures and local Markdown links."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
pattern = re.compile(r'^### ((?:E\d{2}\.[CQ])|(?:[PSR]\d{2}))$', re.M)
expected = {f'E{i:02}.{suffix}' for i in range(1, 8) for suffix in ['C', 'Q']}
expected |= {f'P{i:02}' for i in range(1, 7)} | {'S01', 'S02'} | {f'R{i:02}' for i in range(1, 6)}
assert len(expected) == 27, 'the plan specifies exactly 27 IDs: 14 exercise, 6 practice, 2 stretch, 5 report'


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


collect(['learner/exercises.md', 'learner/practice.md', 'learner/observations.md'], 80)
collect(['instructor/answers.md', 'instructor/observations.md'], 200)
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
sources = [f'ex0{i}.c' for i in range(1, 6)] + ['decode.h', 'decode.c', 'decode8086.c']
for package in ['learner', 'instructor']:
    for name in sources:
        assert (root / package / 'src' / name).is_file(), f'Missing {package}/src/{name}'
    assert (root / package / 'cases.txt').is_file(), f'Missing {package}/cases.txt'
assert (root / 'learner/src/decode.h').read_bytes() == (root / 'instructor/src/decode.h').read_bytes(), 'decode.h differs'
for extra in ['s01_jumps.c', 's02_table.c', 'mutate.py']:
    assert (root / 'instructor/extras' / extra).is_file(), f'Missing instructor extra {extra}'
for name in ['registers', 'immediates', 'arithmetic', 'program', 'truncated_end', 'unsupported_middle', 'memory_mode',
             'group_or', 'jump', 'resync']:
    for ext in ('bin', 'txt'):
        assert (root / 'fixtures/listings' / f'{name}.{ext}').is_file(), f'Missing listing {name}.{ext}'
assert (root / 'fixtures/x64_mov.bin').read_bytes() == bytes.fromhex('4889d8'), 'fixtures/x64_mov.bin must be 48 89 D8'
for doc in root.rglob('*.md'):
    if 'build' in doc.parts:
        continue
    for target in re.findall(r'\]\((?!https?:|#|mailto:)([^)#\s]+)', doc.read_text(encoding='utf-8')):
        resolved = (doc.parent / target).resolve()
        if root.resolve() not in resolved.parents and not (root.parent / 'PLAN.md').is_file():
            continue  # a link to another week, checked only inside the full course repository
        assert resolved.exists(), f'Broken link in {doc.relative_to(root)}: {target}'
print(f'PASS: {len(expected)} prompts, {len(expected)} written answers, {len(rows)} checklist entries; identical supplied '
      'header; complete source, case and listing inventories; local links resolve')
