"""Orchestrate C contracts; Python is not the implementation. Run: make test (never with python -O)."""
import argparse
from pathlib import Path
import re
import shlex
import shutil
import subprocess

if not __debug__:
    raise SystemExit('Run checks without Python -O / PYTHONOPTIMIZE')
p = argparse.ArgumentParser()
p.add_argument('--build', type=Path, required=True)
p.add_argument('--source', type=Path, required=True)
p.add_argument('--cc', required=True)
p.add_argument('--flags', required=True)
a = p.parse_args()
FORBIDDEN = ['-ffast-math', '-Ofast', '-funsafe-math-optimizations', '-march=native', '-fassociative-math', '-ffp-contract=fast', '-mfma']
assert not any(f in a.flags for f in FORBIDDEN), 'a forbidden floating-point flag is in use'
assert '-ffp-contract=off' in a.flags, 'the Makefile must set -ffp-contract=off explicitly'
flags = shlex.split(a.flags)

def run(command, success=True, timeout=120):
    r = subprocess.run([str(x) for x in command], capture_output=True, text=True, timeout=timeout)
    assert (r.returncode == 0) == success, (command, r.returncode, r.stdout, r.stderr)
    return r.stdout

def ex(n, *args):
    return run([a.build / f'ex{n:02}', *args])

def fields(text):
    return dict(re.findall(r'(\w+)=([^\s]+)', text))

# Tolerances come from the single header the C tests also use.
tol = {k: float(v) for k, v in re.findall(r'#define (TOL_\w+)\s+([0-9.eE+-]+)', Path('tests/tolerances.h').read_text())}

def close(got, want, rel, floor=0.0):
    return abs(got - want) <= max(floor, rel * abs(want))

# ---- demo drivers -------------------------------------------------------------------------------
lines = ex(1).splitlines()
assert lines[0] in ('ieee754_binary64=checked', 'ieee754_binary64=skipped')
if lines[0].endswith('checked'):
    got = {fields(l)['value']: fields(l) for l in lines[1:]}
    want = {'1.0': (0, 1023, 0), '0.5': (0, 1022, 0), '-2.0': (1, 1024, 0), '0.1': (0, 1019, 0x999999999999A),
            '0.0': (0, 0, 0), '-0.0': (1, 0, 0), 'DBL_MIN': (0, 1, 0), 'DBL_TRUE_MIN': (0, 0, 1),
            'DBL_MAX': (0, 2046, 2**52 - 1), 'infinity': (0, 2047, 0)}
    assert len(lines) == 12 and set(got) == set(want) | {'nan'}
    for name, (s, e, f) in want.items():
        assert (int(got[name]['sign']), int(got[name]['exp']), int(got[name]['frac'], 16)) == (s, e, f), name
    assert got['nan']['class'] == 'nan' and got['nan']['exp'] == '2047'  # payload and sign are not asserted
    assert re.fullmatch(r'0x[0-9A-F]{13}', got['1.0']['frac'])
    assert [got[n]['class'] for n in ('0.0', 'DBL_TRUE_MIN', 'DBL_MIN', 'infinity')] == ['zero', 'subnormal', 'normal', 'infinite']
lines = ex(2).splitlines()
if lines[0].endswith('checked'):
    l1, l2 = fields(lines[1]), fields(lines[2])
    assert l1['ulps'] == '1' and l2['ulps'] == '1' and l1['left'] != l1['right'] and l2['sum'] != l2['target']
line = ex(3).strip()
f = fields(line)
assert line.startswith('wrap(180)=-180 delta(179,-179)=2 sin_deg(180)=0 sin(pi)=')
assert 'sin(pi)' in line  # the digits after it are an observation and are not asserted
lines = ex(4).splitlines()
assert len(lines) == 5
exact = {(0, 0): (1, 0, 0), (0, 90): (0, 1, 0), (90, 45): (0, 0, 1), (-90, -120): (0, 0, -1)}
for line in lines:
    f = fields(line)
    key = (int(f['lat']), int(f['lon'])); v = (float(f['x']), float(f['y']), float(f['z']))
    assert abs(v[0] ** 2 + v[1] ** 2 + v[2] ** 2 - 1) < 1e-8
    if key in exact:
        assert v == tuple(float(c) for c in exact[key]) and '-0.' not in line, line  # exact axes, no "-0"
    else:
        assert key == (45, 45) and abs(v[0] - 0.5) < 1e-9 and abs(v[1] - 0.5) < 1e-9 and abs(v[2] - 2 ** 0.5 / 2) < 1e-9
lines = ex(5).splitlines()
assert [fields(l)['case'] for l in lines] == ['identical', 'one_metre_equator', 'one_km_meridian', 'quarter_meridian', 'half_circle', 'antimeridian_pair']
for line in lines:
    f = fields(line)
    e, h, v, c = (float(f[k]) for k in ('expected_km', 'haversine_km', 'vector_km', 'cosines_km'))
    # nine printed decimals limit the comparison, so allow the print resolution as an absolute floor
    assert close(h, e, tol['TOL_DIST_REL'], 2e-9) and close(v, e, tol['TOL_DIST_REL'], 2e-9), line
    assert c >= 0.0 and c == c  # the law of cosines is only required to be finite and nonnegative here
expected6 = {
    'crossing': ('point', '(1,1)'), 'endpoint_touch': ('point', '(1,1)'), 't_junction': ('point', '(1,0)'),
    'parallel_disjoint': ('none', None), 'collinear_disjoint': ('none', None), 'collinear_touching': ('point', '(1,0)'),
    'collinear_overlap': ('overlap', '(1,0)'), 'point_on_segment': ('point', '(1,1)'), 'point_off_segment': ('none', None),
    'same_points': ('point', '(1,1)'), 'different_points': ('none', None), 'non_integer_crossing': ('point', '(1.5,0.5)')}
lines = ex(6).splitlines()
assert [fields(l)['case'] for l in lines] == list(expected6)
for line in lines:
    f = fields(line)
    kind, at = expected6[f['case']]
    assert f['kind'] == kind and (at is None or f['a'] == at), line
    if kind == 'overlap': assert f['b'] == '(2,0)'
lines = run([a.build / 'geomath_demo']).splitlines()
assert [fields(l)['case'] for l in lines] == ['identical', 'pole_to_pole', 'pole_to_equator', 'pole_all_longitudes',
                                              'antimeridian_equivalence', 'one_degree_equator', 'one_metre_equator']
assert all(fields(l)['ok'] == '1' for l in lines), lines

# ---- C contract suites --------------------------------------------------------------------------
def compile_contract(n, out, extra=(), objects=()):
    src = 'geomath.c' if n == 7 else f'ex{n:02}.c'
    command = [a.cc, *flags, '-Isupport', '-Itests', f'-I{a.source}', f'-DSOURCE="{(a.source / src).resolve()}"',
               f'-DEXERCISE={n}', *extra, 'tests/contracts.c', *objects, '-o', out, '-lm']
    run(command)

for n in range(1, 8):
    binary = a.build / f'contract{n:02}'
    compile_contract(n, binary, objects=[a.build / 'geomath.o'] if n == 7 else [])
    assert 'contract passed' in run([binary], timeout=300)

# ---- forced-skip builds: test the gating path, not another ABI ------------------------------------
for n, expected in [(1, 'ieee754_binary64=skipped'), (2, 'ieee754_binary64=skipped')]:
    binary = a.build / f'skip{n:02}'
    run([a.cc, *flags, '-Isupport', '-DGEO_FORCE_NO_IEC', a.source / f'ex{n:02}.c', '-o', binary, '-lm'])
    assert run([binary]).splitlines()[0] == expected
    binary = a.build / f'skipcontract{n:02}'
    compile_contract(n, binary, extra=['-DGEO_FORCE_NO_IEC'])
    assert 'checks skipped' in run([binary])

# ---- toolchain observation: global symbols of geomath.o are a subset of the header's names -------
header = (a.source / 'geomath.h').read_text()
header = re.sub(r'/\*.*?\*/', '', header, flags=re.S)
declared = set(re.findall(r'\b([A-Za-z_]\w*)\s*\(', header)) - {'sizeof'}
if shutil.which('nm'):
    defined = {l.split()[-1] for l in run(['nm', '--defined-only', '-g', a.build / 'geomath.o']).splitlines() if l.strip()}
    assert defined <= declared, f'geomath.o exports names missing from geomath.h: {sorted(defined - declared)}'
    print(f'symbol check (toolchain observation): {len(defined)} exported names, all declared in geomath.h')
else:
    print('symbol check skipped: nm not found')

# ---- instructor extras ---------------------------------------------------------------------------
if a.source.parts[0] == 'instructor':
    def build_extra(name, out):
        run([a.cc, *flags, '-Isupport', '-Itests', f'-I{a.source}', f'instructor/extras/{name}.c', a.build / 'geomath.o', '-o', a.build / out, '-lm'])
    build_extra('measure', 'measure')
    print(run([a.build / 'measure'], timeout=300), end='')
    build_extra('stretch_edges', 'stretch_edges')
    out = run([a.build / 'stretch_edges'], timeout=300).splitlines()
    cases = [fields(l) for l in out if l.startswith('case=')]
    assert len(cases) >= 10 and all(c['result'] == 'pass' for c in cases), out
    build_extra('stretch_antipodal', 'stretch_antipodal')
    rows = [fields(l) for l in run([a.build / 'stretch_antipodal']).splitlines() if l.startswith('k=')]
    assert [int(r['k']) for r in rows] == list(range(1, 13))
    for r in rows:  # structure only: the sweep's measured values are recorded, not asserted
        assert float(r['haversine_err_rad']) >= 0.0 and float(r['vector_err_rad']) >= 0.0
print('PASS: demos, seven C contract suites, forced-skip gates, symbol subset check' +
      ('; measured tolerances, edge-case suite and antipodal sweep' if a.source.parts[0] == 'instructor' else ''))
