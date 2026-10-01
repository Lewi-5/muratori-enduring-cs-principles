"""Mutation check of the week-5 harness (make mutate). Each mutant is one textual change to the reference project;
the harness should reject it. Survivors are classified in instructor/validation.md as equivalent mutants (no
observable difference under the contract) or as real test gaps.

The script copies the week to a scratch directory, confirms the unmutated reference passes, then for each mutant
rebuilds (gcc, debug) and runs tests/check.py. Slow on a OneDrive-backed /mnt/c checkout; run it from a copy."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

MUTANTS = [
    # query.c
    ('query.c', 'if (d <= radius_km) ++selected;', 'if (d < radius_km) ++selected;', 'exclusive radius (count)'),
    ('query.c', 'if (dist[i] <= radius_km) {', 'if (dist[i] < radius_km) {', 'exclusive radius (copy)'),
    ('query.c', '    if (x->id < y->id) return -1;\n    if (x->id > y->id) return 1;', '    if (x->id > y->id) return -1;\n    if (x->id < y->id) return 1;', 'identifiers descending'),
    ('query.c', '    if (x->id < y->id) return -1;\n    if (x->id > y->id) return 1;\n', '', 'no identifier tie-break'),
    ('query.c', '    if (x->distance_km < y->distance_km) return -1;\n    if (x->distance_km > y->distance_km) return 1;',
     '    long long px = (long long)(x->distance_km * 1e6 + 0.5), py = (long long)(y->distance_km * 1e6 + 0.5);\n    if (px < py) return -1;\n    if (px > py) return 1;',
     'sort by the printed (rounded) distance'),
    ('query.c', 'qsort(out, selected, sizeof *out, query_hit_compare);', '', 'no sort'),
    ('query.c', 'radius_km > GEOLAB_MAX_RADIUS_KM', '0', 'no upper radius limit'),
    ('query.c', 'radius_km < 0.0 ||', '', 'negative radius accepted'),
    ('query.c', '!isfinite(radius_km) ||', '', 'non-finite radius accepted'),
    ('query.c', '        if (!geo_valid_position(points[i].lat_deg, points[i].lon_deg)) return 0;\n', '', 'points not validated'),
    ('query.c', 'if (!geo_valid_position(lat, lon)) return 0;', '', 'center not validated'),
    ('query.c', '    *hits = out;\n    *nhits = selected;', '    *hits = out;\n    *nhits = selected > 0 ? selected - 1 : 0;', 'count off by one'),
    ('query.c', 'out = malloc(selected * sizeof(QueryHit));', 'out = malloc(selected * sizeof(QueryHit));\n        if (selected > 3) --selected;', 'drops hits'),
    ('query.c', '    if (count == 0) {\n        *hits = NULL;\n        *nhits = 0;\n        return 1;\n    }\n', '    if (count == 0) return 0;\n', 'empty input rejected'),
    # cli.c
    ('cli.c', 'if (++digits > 6) return 0;', 'if (++digits > 7) return 0;', 'seven decimals accepted'),
    ('cli.c', 'if (digits == 0) return 0;', '', '"5." accepted'),
    ('cli.c', "if (s[0] == '0' && s[1] >= '0' && s[1] <= '9') return 0;", '', 'leading zero accepted'),
    ('cli.c', 'if (micro > limit_micro) return 0;', 'if (micro >= limit_micro) return 0;', 'limit exclusive'),
    ('cli.c', '*out = (negative && micro != 0) ? -value : value;', '*out = negative ? -value : value;', '-0.0 kept negative'),
    ('cli.c', 'if (!allow_sign) return 0;', '(void)allow_sign;', 'sign always allowed'),
    ('cli.c', 'double value = (double)micro / 1000000.0;', 'double value = (double)micro * 0.000001;', 'multiply by 1e-6 (double rounding)'),
    ('cli.c', 'if (fflush(stdout) != 0 || ferror(stdout)) wrote = 0;\n    if (!wrote) {\n        fprintf(stderr, "geolab: output error\\n");\n        return GEOLAB_EXIT_DATA;\n    }\n    return GEOLAB_EXIT_OK;\n}\n',
     'fflush(stdout);\n    (void)wrote;\n    return GEOLAB_EXIT_OK;\n}\n', 'query output errors ignored'),
    ('cli.c', 'return GEOLAB_EXIT_UNSUPPORTED;', 'return GEOLAB_EXIT_USAGE;', 'unsupported reported as usage'),
    ('cli.c', '|| t == 0)', ')', '--threads 0 accepted as unsupported'),
    ('cli.c', 'if (!parse_cli_u64(v[0], GEOLAB_MAX_ROWS, &count))', 'if (!parse_cli_u64(v[0], UINT64_MAX, &count))', 'count cap not checked by the CLI'),
    ('cli.c', '    free(points);\n    if (!ok) {', '    if (!ok) {', 'points leaked (sanitizer-only)'),
    # bench.c
    ('bench.c', 's.median_ns = lo + (hi - lo) / 2;', 's.median_ns = (lo + hi) / 2;', 'overflowing median'),
    ('bench.c', 's.median_ns = lo + (hi - lo) / 2;', 's.median_ns = hi;\n        (void)lo;', 'upper middle as median'),
    ('bench.c', 's.min_ns = scratch[0];\n    s.max_ns = scratch[n - 1];', 's.min_ns = scratch[n - 1];\n    s.max_ns = scratch[0];', 'min and max swapped'),
    ('bench.c', 'else if (c.count != first.count || c.value != first.value) status = BENCH_CHECKSUM_MISMATCH;', '', 'checksums not compared'),
    ('bench.c', 'c.count != first.count || c.value != first.value', 'c.count != first.count', 'checksum value not compared'),
    ('bench.c', 'unsigned total = spec->warmup + spec->repeat;', 'unsigned total = spec->repeat;', 'no warm-up repetitions'),
    ('bench.c', 'if (spec->count == 0) return BENCH_EMPTY;', '', 'empty distance/query input accepted'),
    ('bench.c', 'if (status == BENCH_OK && spec->variant == BENCH_PARSE && first.count == 0) status = BENCH_EMPTY;', '', 'empty parse input accepted'),
    ('bench.c', 'h = h * UINT64_C(1099511628211) + hits[i].id;', 'h = h + hits[i].id;', 'order-insensitive query checksum'),
    ('bench.c', 'for (size_t i = 0; i < count; ++i) c.value += points[i].id;', '', 'parse checksum without identifiers'),
    ('bench.c', 'samples[i] < resolution * BENCH_SHORT_FACTOR', 'samples[i] <= resolution * BENCH_SHORT_FACTOR', 'short-sample boundary inclusive'),
    ('bench.c', 'if (t1 < t0) return BENCH_CLOCK_ERROR;', '', 'backwards clock not detected'),
    ('bench.c', 'qsort(scratch, n, sizeof *scratch, compare_u64);', '(void)compare_u64;', 'samples not sorted'),
    ('bench.c', 'if (spec->repeat < 1 || spec->repeat > BENCH_MAX_REPEAT || spec->warmup > BENCH_MAX_WARMUP) return BENCH_INVALID;',
     'if (spec->repeat < 1) return BENCH_INVALID;', 'repeat/warmup limits unchecked in the kernel'),
    ('bench.c', 'if (fflush(stdout) != 0 || ferror(stdout)) wrote = 0;', '', 'bench flush errors ignored'),
    # geo.c and csv.c
    ('geo.c', 'lat_deg <= 90.0', 'lat_deg < 90.0', 'pole excluded'),
    ('geo.c', 'lon_deg >= -180.0', 'lon_deg > -180.0', 'antimeridian -180 excluded'),
    ('geo.c', 'clamp(a, 0.0, 1.0)', '((void)clamp, a)', 'no clamp'),
    ('csv.c', 'if (stat(path, &st) == 0 && S_ISREG(st.st_mode)) remove(path);', '(void)st;\n        remove(path);', 'remove any path after a failure'),
    ('csv.c', 'r = lcg_below(&state, 360000001u);           /* then longitude */', 'r = lcg_below(&state, 360000000u);', 'generator changed'),
]

week = Path(__file__).resolve().parents[2]
work = Path(tempfile.mkdtemp(prefix='w5mut-'))
shutil.copytree(week, work / 'w', ignore=shutil.ignore_patterns('build', 'results'))
w = work / 'w'
src = w / 'instructor' / 'geolab' / 'src'
FLAGS = '-std=c11 -Wall -Wextra -Wpedantic -Werror -ffp-contract=off -D_POSIX_C_SOURCE=200809L -O0'


def attempt():
    b = subprocess.run(['make', '-s', 'PACKAGE=instructor', 'all'], cwd=w, capture_output=True, text=True)
    if b.returncode != 0:
        return 'build failed'
    r = subprocess.run(['python3', 'tests/check.py', '--build', 'build/instructor/gcc/debug', '--package', 'instructor',
                        '--cc', 'gcc', '--flags', FLAGS, '--include', 'instructor/geolab/include'], cwd=w,
                       capture_output=True, text=True, timeout=1800)
    return 'passed' if r.returncode == 0 else 'killed: ' + next((l for l in r.stdout.splitlines() if l.startswith('FAIL')), '?')[:110]


only = sys.argv[1:]  # optional label substrings: run only the matching mutants
selected = [m for m in MUTANTS if not only or any(o in m[3] for o in only)]
assert attempt() == 'passed', 'the unmutated reference must pass first'
survivors = 0
for file, old, new, label in selected:
    path = src / file
    original = path.read_text()
    assert original.count(old) == 1, f'{label}: pattern must occur exactly once in {file}'
    path.write_text(original.replace(old, new))
    result = attempt()
    path.write_text(original)
    survivors += result == 'passed'
    print(f'{"SURVIVED" if result == "passed" else "killed  "}  {file:8} {label}: {result}', flush=True)
print(f'{len(selected)} mutants, {survivors} survived (classify each survivor in validation.md)')
shutil.rmtree(work)
