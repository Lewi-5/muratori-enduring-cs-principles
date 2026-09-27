"""Check stable IDs, explicit expected counts, answer headings and checklist links."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
pattern = re.compile(r'^### ((?:E\d{2}\.[CQ])|(?:[PSR]\d{2}))$', re.M)
expected = {f'E{i:02}.{suffix}' for i in range(1, 16) for suffix in ['C', 'Q']}
expected |= {f'P{i:02}' for i in range(1, 7)} | {'S01', 'S02'} | {f'R{i:02}' for i in range(1, 6)}

def collect(files):
    found = {}
    for file in files:
        text = (root / file).read_text(encoding='utf-8')
        for item in pattern.finditer(text):
            key = item.group(1)
            assert key not in found, f'Duplicate ID: {key}'
            end = text.find('\n### ', item.end())
            body = text[item.end():end if end >= 0 else len(text)].strip()
            assert len(body) >= 80, f'Empty/placeholder entry: {key}'
            found[key] = file
    assert set(found) == expected, f'Missing {expected - set(found)}; unexpected {set(found) - expected}'
    return found

collect(['learner/exercises.md', 'learner/practice.md', 'learner/observations.md'])
collect(['instructor/answers.md', 'instructor/observations.md'])
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
for package in ['learner', 'instructor']:
    for i in range(1, 16):
        names = ['ex14_main.c', 'ex14_count.c', 'ex14_count.h'] if i == 14 else [f'ex{i:02}.c']
        for name in names:
            assert (root / package / 'src' / name).is_file(), f'Missing {package}/{name}'
print(f'PASS: {len(expected)} prompts, {len(expected)} written answers, {len(rows)} checklist entries; complete source inventories')
