"""Orchestrate the week-5 checks (make test). Python is the independent oracle and the test runner; the program
under test is C. Nothing here asserts a timing. Run through make; never with python -O."""
import argparse
import hashlib
import os
from pathlib import Path
import random
import re
import shlex
import shutil
import stat
import subprocess
import sys

if not __debug__:
    raise SystemExit('Run checks without Python -O / PYTHONOPTIMIZE')
sys.path.insert(0, str(Path(__file__).resolve().parent))
import fixture_lib  # noqa: E402
import oracle  # noqa: E402

p = argparse.ArgumentParser()
p.add_argument('--build', type=Path, required=True)
p.add_argument('--package', required=True)
p.add_argument('--cc', required=True)
p.add_argument('--flags', required=True)
p.add_argument('--include', type=Path, required=True)
a = p.parse_args()
FORBIDDEN = ['-ffast-math', '-Ofast', '-funsafe-math-optimizations', '-march=native', '-fassociative-math',
             '-ffp-contract=fast', '-mfma']
assert not any(f in a.flags for f in FORBIDDEN), 'a forbidden floating-point flag is in use'
assert '-ffp-contract=off' in a.flags, 'the Makefile must set -ffp-contract=off explicitly'
flags = shlex.split(a.flags)
oracle.self_test()

root = Path(__file__).resolve().parents[1]
build = a.build.resolve()
geolab = build / 'geolab'
tmp, orc = build / 'tmp', build / 'oracle'
for d in (tmp, orc):
    d.mkdir(parents=True, exist_ok=True)
failures = []


def run(argv, stdout=subprocess.PIPE, timeout=300):
    return subprocess.run([str(x) for x in argv], stdout=stdout, stderr=subprocess.PIPE, text=True, timeout=timeout,
                          errors='replace')


def check(condition, message):
    if not condition:
        failures.append(message)
        print('FAIL:', message, flush=True)
    return condition


# ---- oracle files -----------------------------------------------------------------------------------------------------
data = {}
for name, (seed, count) in (('d1k', oracle.DATASETS['d1k']), ('d100k', oracle.DATASETS['d100k'])):
    raw = oracle.generate(seed, count)
    assert hashlib.sha256(raw).hexdigest() == oracle.DIGESTS[(seed, count)]
    (orc / f'{name}.csv').write_bytes(raw)
    data[name] = oracle.load(raw)[1]
(orc / 'header_only.csv').write_bytes(b'id,lat_deg,lon_deg\n')


def cli_corpus():
    rng = random.Random(20260922)
    texts = ['0', '1', '9', '10', '89', '90', '91', '179', '180', '181', '1000', '99999', '100000', '100001']
    for base in list(texts):
        for frac in ('', '.0', '.5', '.000001', '.999999', '.123456', '.1234567', '.', '.00', '.100000'):
            texts.append(base + frac)
    for _ in range(1500):
        whole = rng.choice(['0', str(rng.randrange(1, 200)), str(rng.randrange(1, 10**6)), str(rng.randrange(10**9, 10**12))])
        frac = ''.join(rng.choice('0123456789') for _ in range(rng.randrange(0, 8)))
        texts.append(whole + ('.' + frac if frac or rng.random() < 0.1 else ''))
    for t in list(texts[:60]):
        texts += ['-' + t, '+' + t, '0' + t, t + ' ', t + 'e1']
    out = []
    for t in dict.fromkeys(texts):
        if ' ' in t:
            continue  # the case file is whitespace-separated; texts with spaces are named cases in contracts.c
        for sign, limit in ((1, 90000000), (1, 180000000), (0, 100000000000), (0, 10**15), (1, 0)):
            if not t:
                continue
            v = oracle.cli_decimal(t, bool(sign), limit)
            out.append(f'{t} {sign} {limit} {"REJECT" if v is None else v.hex()}\n')
    return ''.join(out)


(orc / 'cli_cases.txt').write_text(cli_corpus())

# ---- C contract suites --------------------------------------------------------------------------------------------------
objects = {o.stem: o for o in (build / 'obj').glob('*.o')}
assert {'csv', 'geo', 'query', 'cli', 'bench', 'main', 'envinfo'} <= set(objects), 'build the objects first (make all)'
src = root / a.package / 'geolab' / 'src'


def contract(module, extra=()):
    exe = build / f'contract_{module}{"_skip" if extra else ""}'
    others = [str(objects[n]) for n in objects if n not in ('main', module)]
    r = run([a.cc, *flags, f'-I{a.include}', '-Isupport', f'-I{build}', '-Itests', f'-DMODULE_{module.upper()}',
             f'-DSOURCE="{src / (module + ".c")}"', f'-DORACLE_DIR="{orc}"', f'-DTEST_TMPDIR="{tmp}"', *extra,
             'tests/contracts.c', *others, '-o', exe, '-lm'])
    if not check(r.returncode == 0, f'contract {module} did not compile:\n{r.stderr[-3000:]}'):
        return ''
    r = run([exe], timeout=900)
    check(r.returncode == 0 and 'contract passed' in r.stdout, f'contract {module} failed:\n{r.stdout[-1500:]}{r.stderr[-1500:]}')
    return r.stdout


for module in ('cli', 'query', 'bench'):
    out = contract(module)
    print(out.strip().splitlines()[-1] if out.strip() else f'{module}: no output', flush=True)
for module in ('cli', 'query'):  # forced-skip builds test the gating path, not another ABI
    out = contract(module, ['-DGEO_FORCE_NO_IEC'])
    check('gated checks skipped' in out, f'forced-skip {module} build did not skip its gated checks')

# Annex F.5 para 2 (gated): "%.6f" of a distance below 20,016 km is the correctly rounded decimal. Python's own
# formatting is correctly rounded, so it is an independent reference for the text C printed.
printed = tmp / 'printed_values.txt'
if printed.is_file() and '-DGEO_FORCE_NO_IEC' not in a.flags:
    lines = printed.read_text().splitlines()
    bad = [l for l in lines if f'{float.fromhex(l.split()[0]):.6f}' != l.split()[1]]
    check(len(lines) > 1000 and not bad, f'"%.6f" was not correctly rounded for {bad[:3]}')

# ---- generate ---------------------------------------------------------------------------------------------------------
for name in ('d1k', 'd100k'):
    seed, count = oracle.DATASETS[name]
    out = tmp / f'gen_{name}.csv'
    r = run([geolab, 'generate', '--out', out, '--seed', seed, '--count', count])
    check(r.returncode == 0 and r.stdout == '', f'generate {name}: {r.returncode} {r.stderr}')
    check(out.is_file() and hashlib.sha256(out.read_bytes()).hexdigest() == oracle.DIGESTS[(seed, count)],
          f'generate {name} bytes differ from the week-4 oracle')
r = run([geolab, 'generate', '--count', '0', '--seed', '5', '--out', tmp / 'gen0.csv'])
check(r.returncode == 0 and (tmp / 'gen0.csv').read_bytes() == b'id,lat_deg,lon_deg\n', 'generate --count 0')
untouched = tmp / 'never.csv'
for argv in (['--count', '5', '--seed', '1'], ['--count', '5', '--seed', '1', '--out', untouched, '--out', untouched],
             ['--count', '1000001', '--seed', '1', '--out', untouched], ['--count', '-1', '--seed', '1', '--out', untouched],
             ['--count', '5', '--seed', '18446744073709551616', '--out', untouched], ['--count', '5', '--sead', '1', '--out', untouched],
             ['--count', '5', '--seed', '1', '--out', untouched, 'extra'], ['--count', '5', '--seed', '1', '--out']):
    untouched.unlink(missing_ok=True)
    r = run([geolab, 'generate', *argv])
    check(r.returncode == 2 and not untouched.exists() and r.stderr.startswith('geolab:') and r.stdout == '',
          f'generate {argv}: expected usage error 2, got {r.returncode}')
r = run([geolab, 'generate', '--count', '5', '--seed', '1', '--out', tmp])
check(r.returncode == 1 and tmp.is_dir(), 'generate into a directory must fail with exit 1 and leave it')
if Path('/dev/full').exists():
    r = run([geolab, 'generate', '--count', '1000', '--seed', '1', '--out', '/dev/full'])
    check(r.returncode == 1 and stat.S_ISCHR(os.stat('/dev/full').st_mode), 'generate to /dev/full: exit 1, device kept')
    # A non-root test cannot tell whether /dev/full itself would have been removed, so the same case goes through a
    # symbolic link the test owns: stat() follows it to a character device, so the link must survive.
    link = tmp / 'full_link'
    link.unlink(missing_ok=True)
    link.symlink_to('/dev/full')
    r = run([geolab, 'generate', '--count', '1000', '--seed', '1', '--out', link])
    check(r.returncode == 1 and link.is_symlink(), 'generate through a link to /dev/full must leave the link (not a regular file)')

# ---- query --------------------------------------------------------------------------------------------------------------
queries = [('d1k', '0', '0', '2500'), ('d1k', '90', '0', '3000'), ('d1k', '-90', '0', '20016'), ('d1k', '10', '179.5', '5000'),
           ('d1k', '0', '-180', '0'), ('d100k', '-33.8688', '151.2093', '800'), ('d100k', '45', '-122', '250.5'),
           ('d100k', '0', '0', '20016')]
for name, lat, lon, radius in queries:
    r = run([geolab, 'query', '--input', orc / f'{name}.csv', '--lat', lat, '--lon', lon, '--radius-km', radius])
    if check(r.returncode == 0 and r.stderr == '', f'query {name} {lat} {lon} {radius}: exit {r.returncode} {r.stderr}'):
        problems = fixture_lib.compare_query(r.stdout, data[name], float(lat), float(lon), float(radius))
        check(not problems, f'query {name} {lat} {lon} {radius}: {problems[:3]}')
query_base = ['query', '--input', orc / 'd1k.csv', '--lat', '0', '--lon', '0', '--radius-km', '100']
r = run([geolab, 'query', '--radius-km', '100', '--lon', '0', '--input', orc / 'd1k.csv', '--lat', '0'])
check(r.returncode == 0 and r.stdout == run([geolab, *query_base]).stdout, 'query options in any order')
r = run([geolab, *query_base, '--threads', '1', '--backend', 'scalar', '--index', 'none'])
check(r.returncode == 0, 'the checkpoint-1 values of the future options are accepted')
for extra, code in ((['--threads', '4'], 3), (['--backend', 'simd'], 3), (['--index', 'grid'], 3), (['--index', 'kd'], 3),
                    (['--threads', '0'], 2), (['--threads', 'x'], 2), (['--backend', 'gpu'], 2), (['--index', 'tree'], 2),
                    (['--lat', '1'], 2), (['--color', 'red'], 2), (['stray'], 2)):
    r = run([geolab, *query_base, *extra])
    check(r.returncode == code and r.stdout == '' and r.stderr.startswith('geolab:'), f'query {extra}: expected {code}, got {r.returncode}')
for bad in (['--lat', '90.5'], ['--lat', '1e1'], ['--lon', '180.0000001'], ['--radius-km', '-1'], ['--radius-km', '100000.000001'],
            ['--lat', '+1'], ['--lat', '']):
    argv = list(query_base)
    argv[argv.index(bad[0]) + 1] = bad[1]
    r = run([geolab, *argv])
    check(r.returncode == 2 and r.stdout == '', f'query {bad}: expected usage error 2, got {r.returncode}')
r = run([geolab, 'query', '--input', orc / 'd1k.csv', '--lat', '-0.0', '--lon', '-0', '--radius-km', '100'])
check(r.returncode == 0 and r.stdout == run([geolab, *query_base]).stdout, 'query with -0.0 equals query with 0')
r = run([geolab, 'query', '--input', orc / 'd1k.csv', '--lat', '0', '--lon', '0'])
check(r.returncode == 2 and r.stdout == '', 'query without --radius-km')
for fixture, prefix in (('bad_lat.csv', 'geolab: PARSE_'), ('empty.csv', 'geolab: PARSE_MISSING_HEADER at line 1'),
                        ('nul_byte.csv', 'geolab: PARSE_NUL_BYTE'), ('crlf.csv', 'geolab: PARSE_BAD_HEADER at line 1')):
    r = run([geolab, 'query', '--input', root / 'fixtures' / fixture, '--lat', '0', '--lon', '0', '--radius-km', '100'])
    check(r.returncode == 1 and r.stdout == '' and r.stderr.startswith(prefix), f'query {fixture}: {r.returncode} {r.stderr!r}')
r = run([geolab, 'query', '--input', tmp / 'missing.csv', '--lat', '0', '--lon', '0', '--radius-km', '1'])
check(r.returncode == 1 and r.stdout == '' and 'PARSE_OPEN_ERROR' in r.stderr, 'query of a missing file')
r = run([geolab, 'query', '--input', orc / 'header_only.csv', '--lat', '0', '--lon', '0', '--radius-km', '1'])
check(r.returncode == 0 and r.stdout == 'id,distance_km\n', 'query of a header-only file prints the header only')
if Path('/dev/full').exists():
    with open('/dev/full', 'w') as full:
        r = run([geolab, *query_base[:-1], '20016'], stdout=full)
    check(r.returncode == 1 and 'geolab: output error' in r.stderr, f'query to /dev/full: {r.returncode} {r.stderr!r}')

# ---- bench --------------------------------------------------------------------------------------------------------------
BENCH_RE = re.compile(r'bench variant=(parse|distance|query) points=(\d+) warmup=(\d+) repeat=(\d+) resolution_ns=(\d+) '
                      r'min_ns=(\d+) median_ns=(\d+) max_ns=(\d+) median_ns_per_point=(\d+\.\d{3}) short_samples=(\d+) '
                      r'checksum=(\d+):(\S+)')
for variant, extra in (('parse', []), ('distance', ['--lat', '10', '--lon', '20']), ('query', ['--radius-km', '3000', '--lat', '10', '--lon', '20'])):
    r = run([geolab, 'bench', '--input', orc / 'd1k.csv', '--variant', variant, '--repeat', '7', '--warmup', '1', *extra])
    lines = r.stdout.splitlines()
    ok = check(r.returncode == 0 and len(lines) >= 2, f'bench {variant}: exit {r.returncode} {r.stderr}')
    if ok:
        check(all(l.startswith('env ') for l in lines[:-1]) and any('env flags=' in l for l in lines), f'bench {variant}: environment block')
        m = BENCH_RE.fullmatch(lines[-1])
        if check(m is not None, f'bench {variant}: unparsable line {lines[-1]!r}'):
            mn, med, mx = int(m.group(6)), int(m.group(7)), int(m.group(8))
            check(m.group(2) == '1000' and m.group(3) == '1' and m.group(4) == '7' and mn <= med <= mx and int(m.group(10)) <= 7,
                  f'bench {variant}: inconsistent fields {lines[-1]}')
            if variant == 'parse':
                check(m.group(11) == '1000' and m.group(12) == '500500', 'bench parse checksum is rows:idsum')
            if variant == 'distance':
                total = sum(oracle.distance_km(10.0, 20.0, la, lo) for _i, la, lo in data['d1k'])
                check(m.group(11) == '1000' and abs(float.fromhex(m.group(12)) - total) <= 1e-12 * total,
                      'bench distance checksum agrees with the oracle sum (relative 1e-12)')
            if variant == 'query':
                hits = oracle.query(data['d1k'], 10.0, 20.0, 3000.0)
                check(int(m.group(11)) == len(hits), 'bench query checksum counts the hits')
r = run([geolab, 'bench', '--input', orc / 'header_only.csv', '--variant', 'distance', '--repeat', '3'])
check(r.returncode == 1 and r.stdout == '' and r.stderr.strip() == 'geolab: empty benchmark input', f'bench header-only: {r.returncode} {r.stderr!r}')
r = run([geolab, 'bench', '--input', orc / 'header_only.csv', '--variant', 'parse', '--repeat', '3'])
check(r.returncode == 1 and r.stdout == '' and 'empty benchmark input' in r.stderr, 'bench parse of a header-only file')
for argv, code in ((['--variant', 'fast', '--repeat', '3'], 2), (['--variant', 'query', '--repeat', '0'], 2),
                   (['--variant', 'query', '--repeat', '1001'], 2), (['--variant', 'query', '--repeat', '3', '--warmup', '101'], 2),
                   (['--variant', 'query', '--repeat', '3', '--lat', '91'], 2), (['--variant', 'query'], 2),
                   (['--variant', 'query', '--repeat', '3', '--threads', '1'], 2)):
    r = run([geolab, 'bench', '--input', orc / 'd1k.csv', *argv])
    check(r.returncode == code and r.stdout == '', f'bench {argv}: expected {code}, got {r.returncode}')
r = run([geolab, 'bench', '--input', root / 'fixtures' / 'bad_lat.csv', '--variant', 'parse', '--repeat', '2'])
check(r.returncode == 1 and r.stdout == '' and 'PARSE_' in r.stderr, 'bench parse of a malformed file')
if Path('/dev/full').exists():
    with open('/dev/full', 'w') as full:
        r = run([geolab, 'bench', '--input', orc / 'd1k.csv', '--variant', 'distance', '--repeat', '2'], stdout=full)
    check(r.returncode == 1 and 'geolab: output error' in r.stderr, 'bench to /dev/full reports an output error')
for argv in ([], ['frobnicate']):
    r = run([geolab, *argv])
    check(r.returncode == 2 and r.stdout == '', f'geolab {argv}: usage error')

# ---- the package's fixtures (E03) -------------------------------------------------------------------------------------
fixtures = root / a.package / 'fixtures'
rows = fixture_lib.parse_readme(fixtures / 'README.md') if (fixtures / 'README.md').is_file() else []
purposes = {purpose for _n, purpose, _a in rows}
check(set(fixture_lib.REQUIRED_PURPOSES) <= purposes, f'fixtures/README.md lacks purposes {set(fixture_lib.REQUIRED_PURPOSES) - purposes}')
listed = {name for name, _p, _a in rows}
present = {f.name for f in fixtures.glob('*.csv')}
check(listed == present, f'fixtures listed but missing: {listed - present}; present but unlisted: {present - listed}')
for name, purpose, arguments in rows:
    path = fixtures / name
    if not path.is_file():
        continue
    expected = fixtures / 'expected' / (Path(name).stem + '.txt')
    check(expected.is_file() and expected.read_bytes() == fixture_lib.expected_text(path, arguments).encode('ascii'),
          f'{expected.name} is missing or differs from the oracle (run make expected)')
    code, out, err, params = fixture_lib.oracle_run(path, arguments)
    r = run([geolab, 'query', '--input', path, *shlex.split(arguments)])
    if code != 0:
        check(r.returncode == code and r.stdout == '' and r.stderr.startswith(err), f'fixture {name}: {r.returncode} {r.stderr!r}')
    elif check(r.returncode == 0, f'fixture {name}: exit {r.returncode} {r.stderr}'):
        problems = fixture_lib.compare_query(r.stdout, *params)
        check(not problems, f'fixture {name} ({purpose}): {problems}')

# ---- symbols (toolchain observation) ------------------------------------------------------------------------------------
if shutil.which('nm'):
    declared = set()
    for header in list(a.include.glob('*.h')) + [root / 'support' / 'envinfo.h']:
        declared |= set(re.findall(r'\b([A-Za-z_]\w*)\s*\(', header.read_text()))
    for name, obj in objects.items():
        r = run(['nm', '-g', '--defined-only', obj])
        syms = {line.split()[-1] for line in r.stdout.splitlines() if line.strip()}
        check(syms <= declared | {'main'}, f'{obj.name} exports undeclared symbols {sorted(syms - declared - {"main"})}')
else:
    print('symbol check skipped: nm not found (toolchain observation)')

if failures:
    print(f'{len(failures)} check(s) failed')
    sys.exit(1)
print(f'PASS: oracle self-test, 3 C contract suites + 2 forced-skip builds, generate/query/bench command contract, '
      f'{len(queries)} oracle query comparisons, {len(rows)} fixtures, symbol subset')
