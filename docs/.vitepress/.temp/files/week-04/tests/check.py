"""Orchestrate the week-4 checks. Python is the independent oracle (tests/oracle.py) and the test runner; the
implementation under test is C. Run: make test (never with python -O)."""
import argparse
import hashlib
import math
from pathlib import Path
import re
import shlex
import subprocess
import sys

if not __debug__:
    raise SystemExit('Run checks without Python -O / PYTHONOPTIMIZE')
sys.path.insert(0, str(Path(__file__).resolve().parent))
import oracle  # noqa: E402

p = argparse.ArgumentParser()
p.add_argument('--build', type=Path, required=True)
p.add_argument('--source', type=Path, required=True)
p.add_argument('--cc', required=True)
p.add_argument('--flags', required=True)
a = p.parse_args()
FORBIDDEN = ['-ffast-math', '-Ofast', '-funsafe-math-optimizations', '-march=native', '-fassociative-math',
             '-ffp-contract=fast', '-mfma']
assert not any(f in a.flags for f in FORBIDDEN), 'a forbidden floating-point flag is in use'
assert '-ffp-contract=off' in a.flags, 'the Makefile must set -ffp-contract=off explicitly'
flags = shlex.split(a.flags)
INSTRUCTOR = a.source.parts[0] == 'instructor'
oracle.self_test()  # the oracle is checked against fixed known-answer vectors before anything is compared with it

build = a.build.resolve()
tmp = build / 'tmp'
orc = build / 'oracle'
fixtures = Path('fixtures').resolve()
tmp.mkdir(parents=True, exist_ok=True)
orc.mkdir(parents=True, exist_ok=True)


def run(command, success=True, timeout=300):
    r = subprocess.run([str(x) for x in command], capture_output=True, text=True, timeout=timeout, errors='replace')
    assert (r.returncode == 0) == success, (command, r.returncode, r.stdout[-2000:], r.stderr[-2000:])
    return r.stdout


def ex(n, *args, success=True):
    return run([build / f'ex{n:02}', *args], success=success)


def fields(text):
    return dict(re.findall(r'(\w+)=([^\s]+)', text))


# ---- files written by the oracle for the C suites ---------------------------------------------------------------------
valid_cases = oracle.write_c_files(orc)

# ---- demo drivers vs the oracle -----------------------------------------------------------------------------------------
# E01
lines = ex(1).splitlines()
rng = oracle.Lcg(0)
first = [rng.next() for _ in range(3)]
assert lines[0] == 'seed=0 first=' + ','.join(f'{v:08X}' for v in first), lines[0]
rng = oracle.Lcg(0)
assert lines[1] == 'bound7=' + ','.join(str(rng.below(7)) for _ in range(10)), lines[1]
assert len(lines) == 2
# E02
records = [(1, 0, 0), (7, -5, 10), (42, 45123456, -122654321), (0, 999999, -1000000),
           (2 ** 64 - 1, -90000000, -180000000), (123456789, 90000000, 180000000)]
assert ex(2) == ''.join('line=' + oracle.format_record(*r) for r in records)
# E03: byte-identical files, recorded digests, size prediction, and the option-parsing contract
for (seed, count), want in oracle.DIGESTS.items():
    out = tmp / f'driver_{count}.csv'
    out.unlink(missing_ok=True)
    ex(3, '--seed', str(seed), '--out', str(out), '--count', str(count))  # any option order
    data = out.read_bytes()
    assert data == oracle.generate(seed, count) and hashlib.sha256(data).hexdigest() == want, (seed, count)
    assert b'\r' not in data and data.endswith(b'\n') and data.startswith(b'id,lat_deg,lon_deg\n')
    if count == 1000:  # 19-byte header plus, per row, digits(id) + 19 (shortest) .. + 24 (longest) bytes
        digits = 9 * 1 + 90 * 2 + 900 * 3 + 4
        low, high = 19 + 1000 * 19 + digits, 19 + 1000 * 24 + digits
        assert low <= len(data) <= high and (low, high) == (21912, 26912), (len(data), low, high)
empty = tmp / 'driver_empty.csv'
ex(3, '--count', '0', '--seed', '5', '--out', str(empty))
assert empty.read_bytes() == b'id,lat_deg,lon_deg\n'
edge = tmp / 'driver_edge.csv'
ex(3, '--count', '3', '--seed', '18446744073709551615', '--out', str(edge))
assert edge.read_bytes() == oracle.generate(2 ** 64 - 1, 3)
untouched = tmp / 'driver_bad.csv'
untouched.unlink(missing_ok=True)
for argv in (['--count', '5', '--seed', '1'], ['--seed', '1', '--out', str(untouched)], ['--count', '5', '--out', str(untouched)],
             ['--count', '5', '--count', '6', '--seed', '1', '--out', str(untouched)],
             ['--count', '5', '--seed', '1', '--seed', '2', '--out', str(untouched)],
             ['--count', '5', '--seed', '1', '--out', str(untouched), '--out', str(untouched)],
             ['--count', '5', '--sead', '1', '--out', str(untouched)], ['--count', '-1', '--seed', '1', '--out', str(untouched)],
             ['--count', ' 5', '--seed', '1', '--out', str(untouched)], ['--count', '5', '--seed', '+1', '--out', str(untouched)],
             ['--count', '5', '--seed', '1.5', '--out', str(untouched)], ['--count', '', '--seed', '1', '--out', str(untouched)],
             ['--count', '5', '--seed', '18446744073709551616', '--out', str(untouched)],
             ['--count', '1000001', '--seed', '1', '--out', str(untouched)], ['--count', '5', '--seed', '1', '--out'],
             ['--count', '5', '--seed', '1', '--out', str(untouched), 'extra']):
    assert not untouched.exists() or untouched.read_bytes() == b'', argv
    ex(3, *argv, success=False)
    assert not untouched.exists(), argv  # a rejected command line writes nothing
ex(3, '--count', '5', '--seed', '1', '--out', str(tmp), success=False)  # a directory cannot be written
assert tmp.is_dir()
# E04: every printed line agrees with the oracle classification
lines = ex(4).splitlines()
assert len(lines) == 11
for line in lines:
    m = re.fullmatch(r'line="(.*)" status=(\w+)(?: id=(\d+) lat=(\S+) lon=(\S+))?', line)
    assert m, line
    status, ident, lat, lon = oracle.classify(m.group(1))
    assert m.group(2) == status, line
    if status == 'PARSE_OK':
        assert (int(m.group(3)), m.group(4), m.group(5)) == (ident, f'{lat / 1e6:.6f}', f'{lon / 1e6:.6f}'), line
# E05
for name, want, rc in [('good.csv', 'rows=5 first_id=1 last_id=5', 0), ('header_only.csv', 'rows=0', 0),
                       ('no_final_newline.csv', 'rows=3 first_id=1 last_id=3', 0),
                       ('bad_id.csv', 'error line=4 status=PARSE_BAD_ID', 1), ('empty.csv', 'error line=1 status=PARSE_MISSING_HEADER', 1),
                       ('crlf.csv', 'error line=1 status=PARSE_BAD_HEADER', 1), ('nul_byte.csv', 'error line=3 status=PARSE_NUL_BYTE', 1),
                       ('long_line.csv', 'error line=3 status=PARSE_LINE_TOO_LONG', 1)]:
    assert ex(5, str(fixtures / name), success=rc == 0).strip() == want, name
assert ex(5, str(orc / 'gen_7_3000.csv')).strip() == 'rows=3000 first_id=1 last_id=3000'
assert ex(5, str(tmp / 'missing.csv'), success=False).strip() == 'error line=0 status=PARSE_OPEN_ERROR'
# E06: the built-in dataset against analytic values (six printed decimals limit the comparison)
line = ex(6).strip()
f = fields(line)
R, rad = 6371.0088, math.pi / 180
assert line.startswith('points=12 within=5 sum_km=') and f['points'] == '12' and f['within'] == '5'
assert abs(float(f['sum_km']) - R * (rad * 19 + 3 * math.pi + math.pi / 3)) < 2e-6
assert float(f['min_km']) == 0.0 and abs(float(f['max_km']) - math.pi * R) < 2e-6
assert float(f['reference_max_abs_diff_km']) < 1e-9 and f['within_equal'] == '1'
# E07: the driver's numbers are reproduced exactly by an independent Python implementation of the same algorithms
lines = ex(7).splitlines()
assert [fields(l).get('case') for l in lines[:4]] == ['cancel', 'tenths', 'ramp', 'hashed'] and len(lines) == 5
table = []
for line in lines[:4]:
    f = fields(line)
    values = oracle.inputs(f['case'])
    exact = oracle.exact_sum(values)
    n_, p_, m_ = oracle.naive(values), oracle.pairwise(values), oracle.neumaier(values)
    assert (float(f['naive']), float(f['pairwise']), float(f['neumaier'])) == (n_, p_, m_), line  # same IEEE operations
    ulp = math.ulp(exact) if exact else math.ulp(1.0)
    abs_sum = math.fsum(abs(x) for x in values)
    n = len(values)
    assert abs(n_ - exact) <= oracle.gamma(n - 1) * abs_sum + oracle.U * abs(exact)  # naive bound (Higham 4.2)
    assert abs(p_ - exact) <= oracle.gamma(oracle.pairwise_k(n)) * abs_sum + oracle.U * abs(exact)  # pairwise bound
    assert abs(m_ - exact) <= 2 * oracle.U * abs(exact) + oracle.gamma(n - 1) ** 2 * abs_sum  # Ogita-Rump-Oishi Sum2 bound
    assert abs(m_ - exact) <= 2 * ulp, line  # the plan's stated tolerance: within 2 ulps
    table.append((f['case'], exact, n_, p_, m_, ulp))
    if f['case'] == 'ramp':
        assert n_ == p_ == m_ == exact == 500000500000.0
    if f['case'] == 'cancel':
        assert m_ == 2.0 and exact == 2.0
f = fields(lines[4])
acc, exp_err_acc = 0.0, 0.0
worst_acc = worst_exp = 0.0
x = 0.0
for i in range(1, 1000001):
    x += 0.1
    ref = i / 10.0
    e1 = abs(x - ref) / ref
    e2 = abs((0.0 + float(i) * 0.1) - ref) / ref
    worst_acc, worst_exp = max(worst_acc, e1), max(worst_exp, e2)
assert f['accumulated_max_rel_err'] == f'{worst_acc:.6e}' and f['explicit_max_rel_err'] == f'{worst_exp:.6e}', lines[4]
assert worst_exp <= 2.5 * oracle.U * (1 + 1e-15) and worst_acc <= 1e6 * oracle.U * 1.0001  # derived bounds (answer key E07.Q)

# ---- C contract suites --------------------------------------------------------------------------------------------------
def compile_contract(n, out, extra=()):
    command = [a.cc, *flags, '-Isupport', '-Itests', f'-DSOURCE="{(a.source / f"ex{n:02}.c").resolve()}"',
               f'-DEXERCISE={n}', f'-DTEST_TMPDIR="{tmp}"', f'-DORACLE_DIR="{orc}"', f'-DFIXTURE_DIR="{fixtures}"',
               *extra, 'tests/contracts.c', '-o', out, '-lm']
    run(command)


variants = [(n, (), f'contract{n:02}') for n in range(1, 8)]
variants += [(3, ('-DGEOLAB_MAX_ROWS=10',), 'contract03_cap10'), (5, ('-DGEOLAB_MAX_ROWS=8',), 'contract05_cap8'),
             (5, ('-DGEOLAB_MAX_ROWS=1500',), 'contract05_cap1500')]
for n, extra, name in variants:
    binary = build / name
    compile_contract(n, binary, extra)
    out = run([binary], timeout=600)
    assert 'contract passed' in out, (name, out)
    if n in (4, 7):
        print(out.strip().splitlines()[-2] if len(out.strip().splitlines()) > 1 else '', flush=True)

# ---- forced-skip builds: test the gating path, not another ABI ---------------------------------------------------------
for n in (4, 7):
    binary = build / f'skipcontract{n:02}'
    compile_contract(n, binary, extra=['-DGEO_FORCE_NO_IEC'])
    out = run([binary], timeout=600)
    assert 'gated checks skipped' in out and 'contract passed' in out, (n, out)

# ---- instructor extras ---------------------------------------------------------------------------------------------------
if INSTRUCTOR:
    def build_extra(name, out, *objs):
        run([a.cc, *flags, '-Isupport', '-Itests', f'-DEXTRA_TMPDIR="{tmp}"', f'instructor/extras/{name}.c', *objs, '-o', build / out, '-lm'])
    build_extra('measure', 'measure')
    print(run([build / 'measure'], timeout=900), end='')
    build_extra('stretch_layout', 'stretch_layout')
    out = run([build / 'stretch_layout'])
    assert 'layout_identical=1' in out and 'soa_bitwise_equal=1' in out, out
    print(out, end='')
    print('E07 error table (measured here; not asserted beyond the derived bounds):')
    for case, exact, n_, p_, m_, ulp in table:
        print(f'  {case:7} exact={exact:.17g} naive_ulps={abs(n_ - exact) / ulp:.3g} pairwise_ulps={abs(p_ - exact) / ulp:.3g} neumaier_ulps={abs(m_ - exact) / ulp:.3g}')
print(f'PASS: demos, {len(variants)} C contract builds, oracle corpus ({valid_cases} valid lines), forced-skip gates' +
      ('; measured tolerances and stretch programs' if INSTRUCTOR else ''))
