"""Shared by tests/check.py and tools/expected.py: the tolerance rule, the query comparison, and the fixture table.

Tolerance rule (justified in instructor/validation.md): the program's haversine and the oracle's vector formula
were compared on 909,000 point pairs (the 1,000- and 100,000-row datasets against nine centers). The largest
disagreement in each distance band was 9.1e-12 km below 15,000 km, 8.8e-10 km below 19,900 km and 4.1e-8 km above
(nearly antipodal points, where the haversine's final asin is ill-conditioned, week 3 E05). The tolerance is at
least eleven times each measured maximum."""
from pathlib import Path
import re
import shlex

import oracle

PRINT_HALF_UNIT = 5e-7  # "%.6f" rounds to the nearest 1e-6 km
REQUIRED_PURPOSES = ['pole', 'antimeridian', 'exact-tie', 'printed-tie', 'empty', 'malformed']


def tol(d):
    if d < 15000.0:
        return 1e-10
    if d < 19900.0:
        return 1e-8
    return 5e-7


def compare_query(stdout, points, lat, lon, radius):
    """Compare a `geolab query` output with the oracle. Returns a list of problems (empty when it agrees).
    Identifiers and order are compared exactly only where the oracle's distances are separated from the radius and
    from each other by more than the tolerance; every printed distance is compared within print rounding plus the
    tolerance."""
    problems = []
    lines = stdout.split('\n')
    if not stdout.endswith('\n') or lines[0] != 'id,distance_km':
        return ['output must start with the header line and end with a newline']
    rows = []
    for line in lines[1:-1]:
        m = re.fullmatch(r'(0|[1-9][0-9]*),([0-9]+\.[0-9]{6})', line)
        if not m:
            return [f'malformed output line {line!r}']
        rows.append((int(m.group(1)), float(m.group(2))))
    by_id = {}
    for ident, plat, plon in points:
        by_id.setdefault(ident, []).append((oracle.distance_km(lat, lon, plat, plon), plat, plon))
    boundary = {i for i, entries in by_id.items() for d, _a, _b in entries if abs(d - radius) <= tol(radius)}
    want = sorted(i for i, entries in by_id.items() for d, _a, _b in entries if d <= radius and i not in boundary)
    got = sorted(i for i, _d in rows if i not in boundary)
    if want != got:
        missing, extra = set(want) - set(got), set(got) - set(want)
        problems.append(f'membership differs: missing {sorted(missing)[:5]}, extra {sorted(extra)[:5]}')
    for ident, printed in rows:
        entries = by_id.get(ident)
        if not entries:
            problems.append(f'id {ident} is not in the input')
            continue
        if not any(abs(printed - d) <= PRINT_HALF_UNIT + tol(d) + 1e-12 for d, _a, _b in entries):
            problems.append(f'id {ident}: printed {printed:.6f}, oracle {entries[0][0]:.9f}')
    for (ia, _pa), (ib, _pb) in zip(rows, rows[1:]):
        ea, eb = by_id.get(ia), by_id.get(ib)
        if not ea or not eb or len(ea) > 1 or len(eb) > 1:
            continue  # duplicate identifiers: order among equal lines is unobservable
        (da, lata, lona), (db, latb, lonb) = ea[0], eb[0]
        if db < da - 2 * tol(max(da, db)):
            problems.append(f'order: id {ia} ({da:.9f}) printed before id {ib} ({db:.9f})')
        if (lata, lona) == (latb, lonb) and ia > ib:
            problems.append(f'exact tie at identical coordinates must be in identifier order: {ia} before {ib}')
    return problems


def parse_readme(path):
    """Rows of the fixture table: (file, purpose, arguments). The table has a header row naming Fixture, Purpose and
    Arguments; every later row with a backquoted file name is a fixture."""
    rows = []
    for line in Path(path).read_text(encoding='utf-8').splitlines():
        m = re.fullmatch(r'\|\s*`([^`]+)`\s*\|\s*([a-z-]+)\s*\|\s*`([^`]*)`\s*\|.*', line.rstrip())  # an indented (code-block) row is only an example
        if m:
            rows.append((m.group(1), m.group(2), m.group(3)))
    return rows


def oracle_run(fixture_path, arguments):
    """What `geolab query --input FIXTURE ARGS` must do, computed by the oracle. Returns (exit, stdout, stderr_prefix,
    parameters) where parameters is (points, lat, lon, radius) for a successful query."""
    args = shlex.split(arguments)
    opts = dict(zip(args[0::2], args[1::2]))
    assert len(args) % 2 == 0 and set(opts) <= {'--lat', '--lon', '--radius-km'} and len(opts) == 3, arguments
    lat = oracle.cli_decimal(opts['--lat'], True, 90000000)
    lon = oracle.cli_decimal(opts['--lon'], True, 180000000)
    radius = oracle.cli_decimal(opts['--radius-km'], False, 100000000000)
    assert None not in (lat, lon, radius), f'fixture arguments must be valid: {arguments}'
    status, result = oracle.load(Path(fixture_path).read_bytes())
    if status != 'PARSE_OK':
        return 1, '', f'geolab: {status} at line {result}', None
    hits = oracle.query(result, lat, lon, radius)
    out = 'id,distance_km\n' + ''.join(f'{ident},{d:.6f}\n' for d, ident in hits)
    return 0, out, '', (result, lat, lon, radius)


def expected_text(fixture_path, arguments):
    code, out, err, _p = oracle_run(fixture_path, arguments)
    if code != 0:
        return f'exit={code}\nstderr-prefix={err}\n'
    return f'exit=0\nstdout:\n{out}'
