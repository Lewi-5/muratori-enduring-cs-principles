"""Check stable IDs, explicit expected counts, answer headings, checklist links and source inventories."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
pattern = re.compile(r'^### ((?:E\d{2}\.[CQ])|(?:[PSR]\d{2}))$', re.M)
expected = {f'E{i:02}.{suffix}' for i in range(1, 8) for suffix in ['C', 'Q']}
expected |= {f'P{i:02}' for i in range(1, 7)} | {'S01', 'S02'} | {f'R{i:02}' for i in range(1, 6)}
assert len(expected) == 27, 'the plan specifies exactly 27 IDs: 14 exercise, 6 practice, 2 stretch, 5 report'

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
sources = [f'ex0{i}.c' for i in range(1, 8)]
for package in ['learner', 'instructor']:
    for name in sources:
        assert (root / package / 'src' / name).is_file(), f'Missing {package}/{name}'
for extra in ['measure.c', 'stretch_layout.c', 'repro_audit.py']:
    assert (root / 'instructor/extras' / extra).is_file(), f'Missing instructor extra {extra}'
for support in ['geolab_types.h', 'reference_distance.h', 'platform.h']:
    assert (root / 'support' / support).is_file(), f'Missing support/{support}'
for name in ['good.csv', 'header_only.csv', 'empty.csv', 'no_final_newline.csv', 'bad_header.csv', 'bad_id.csv',
             'field_count.csv', 'bad_lat.csv', 'lat_range.csv', 'bad_lon.csv', 'lon_range.csv', 'blank_middle.csv',
             'blank_last.csv', 'crlf.csv', 'crlf_rows.csv', 'nul_byte.csv', 'long_line.csv', 'line_127.csv',
             'line_128.csv', 'high_byte.csv', 'newline_only.csv', 'header_no_newline.csv']:
    assert (root / 'fixtures' / name).is_file(), f'Missing fixture {name}'
# Every local Markdown link in the week's documents must resolve.
for doc in root.rglob('*.md'):
    if 'build' in doc.parts:
        continue
    for target in re.findall(r'\]\((?!https?:|#|mailto:)([^)#\s]+)', doc.read_text(encoding='utf-8')):
        assert (doc.parent / target).exists(), f'Broken link in {doc.relative_to(root)}: {target}'
print(f'PASS: {len(expected)} prompts, {len(expected)} written answers, {len(rows)} checklist entries; complete source inventories; local links resolve')
