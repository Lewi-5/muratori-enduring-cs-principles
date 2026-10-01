"""Check stable IDs, explicit expected counts, answer headings, checklist links and source inventories."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
pattern = re.compile(r'^### ((?:E\d{2}\.[CQ])|(?:[PSRWF]\d{2}))$', re.M)
expected = {f'E{i:02}.{suffix}' for i in range(1, 8) for suffix in ['C', 'Q']}
expected |= {f'P{i:02}' for i in range(1, 7)} | {'S01', 'S02'} | {f'R{i:02}' for i in range(1, 6)}
assert len(expected) == 27, 'the plan specifies exactly 27 IDs: 14 exercise, 6 practice, 2 stretch, 5 report'
# Beginner-section warm-ups (W) and further-reading questions (F) are ungraded and listed separately.
companion = {f'W{i:02}' for i in range(1, 5)} | {f'F{i:02}' for i in range(1, 7)}

def collect(files, expected=expected):
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
collect(['learner/warmups.md', 'learner/reading-questions.md'], companion)
collect(['instructor/warmups.md', 'instructor/reading-answers.md'], companion)
checklist = (root / 'instructor/coverage.md').read_text(encoding='utf-8')
rows = re.findall(r'^\| ((?:E\d{2}\.[CQ])|(?:[PSRWF]\d{2})) \|', checklist, re.M)
assert set(rows) == expected | companion and len(rows) == len(expected | companion), 'Checklist gaps/duplicates'
for link in re.findall(r'\]\(([^)]+)\)', checklist):
    path, _, anchor = link.partition('#')
    destination = root / 'instructor' / path
    assert destination.is_file(), f'Broken checklist path: {path}'
    if anchor:
        ids = pattern.findall(destination.read_text(encoding='utf-8'))
        assert anchor in {key.lower().replace('.', '') for key in ids}, f'Broken anchor: {link}'
sources = [f'ex0{i}.c' for i in range(1, 7)] + ['geomath.h', 'geomath.c', 'geomath_demo.c'] + [f'w0{i}.c' for i in range(1, 5)]
for package in ['learner', 'instructor']:
    for name in sources:
        assert (root / package / 'src' / name).is_file(), f'Missing {package}/{name}'
for extra in ['measure.c', 'stretch_edges.c', 'stretch_antipodal.c']:
    assert (root / 'instructor/extras' / extra).is_file(), f'Missing instructor extra {extra}'
# Every local Markdown link in the week's documents must resolve.
for doc in root.rglob('*.md'):
    if 'build' in doc.parts:
        continue
    for target in re.findall(r'\]\((?!https?:|#|mailto:)([^)#\s]+)', doc.read_text(encoding='utf-8')):
        assert (doc.parent / target).exists(), f'Broken link in {doc.relative_to(root)}: {target}'
print(f'PASS: {len(expected)} prompts and {len(companion)} warm-up/reading questions, each with a written answer; {len(rows)} checklist entries; complete source inventories; local links resolve')
