# Validation record — week 5

Execution evidence for the week-5 package. Everything below was run by the implementing agent on 2026-09-22 on the reference machine:

- a 12th Gen Intel Core i7-12650H (16 logical CPUs) under WSL 2;
- kernel 6.18.33.2-microsoft-standard-WSL2, Ubuntu 22.04;
- GCC 11.4.0, Clang 14.0.0, glibc 2.35, Python 3.10.12, GNU binutils.

To avoid the slow OneDrive-backed `/mnt/c` checkout, the checks ran on a copy of the package in the WSL home directory. The final `make verify` result is recorded at the end. Numbers here are observations of this machine, not universal results.

## Build and test matrix

| Command | Result |
| --- | --- |
| `make PACKAGE=instructor test` (gcc debug) | PASS: oracle self-test; 3 C contract suites (cli: 8,750 oracle cases plus 38 named; query; bench) and 2 forced-skip builds; `generate`/`query`/`bench` command contract; 8 oracle query comparisons; 7 fixtures; symbol subset |
| `make PACKAGE=instructor checkpoint` | see “Final verification” |
| `tests/starters.py --cc gcc` and `--cc clang` | PASS: the learner scaffold compiles warning-clean, every contract suite compiles against it, and `check.py` reports 65 behavioral failures with no harness error |
| `tests/inventory.py` | PASS: 26 prompts, 26 answers, 26 checklist rows; supplied headers identical in both packages |

## Oracle self-test and known answers

`tests/oracle.py` checks itself before every run:

- **Analytic distances.** Eight analytic great-circle distances on the model sphere (a quarter meridian, pole to pole, the equatorial half circle, one degree across the antimeridian, identical points and others) agree within 1e−12 relative.
- **Digests.** The d1k and d100k files reproduce week 4's recorded SHA-256 digests, which week 4 checked against `bc`-derived known answers.
- **The d1m digest.** SHA-256 `513c44403bbc317fa715963d3dc675e46f298630002f2d26a1ff686ceaec0a42` (28,166,857 bytes) was recorded from the oracle on 2026-09-22 and is checked where the file is generated. `geolab generate --count 1000000 --seed 5` reproduces it: the protocol runner generates with the oracle and the digest matched.
- **Grammar spot checks.** The command-line grammar's spot checks cover `-0.0` giving +0.0, `90.000001` rejected, the sign rule and `0.1`.

## Tolerance for the oracle comparison

The program's haversine and the oracle's vector formula were compared on 909,000 point pairs: the d1k and d100k points against nine centers (0,0), (±90,0), (10,179.5), (0,180), (−33.8688,151.2093), (45,−122), (89.5,0) and (0.5,−0.25). The largest absolute disagreement by the haversine's distance band:

| Distance band (km) | Max measured difference (km) | Tolerance (km) | Margin |
| --- | --- | --- | --- |
| [0, 15,000) | 9.1e−12 | 1e−10 | 11× |
| [15,000, 19,900) | 8.8e−10 | 1e−8 | 11× |
| [19,900, π·R] | 4.1e−8 (at 20,014.95 km, a nearly antipodal pair) | 5e−7 | 12× |

The antipodal worst case is week 3's conditioning result: the haversine's final `asin` amplifies rounding near its argument 1. Printed distances are compared within 5e−7 (print rounding) plus the tolerance.

The printed-tie fixture was found by search:

| Identifier | Point | Distance from (0, 0), km | Printed |
| --- | --- | --- | --- |
| 1 | (0, 1) | 111.1950802335329 | `111.195080` |
| 2 | (0.600366, 0.79974) | 111.19507985186856 | `111.195080` |

The two differ by 3.8e−7 km, 3,800 times the tolerance in that band. The oracle gives the same two doubles as the program (measured). The gated `%.6f` check compared 8,886 printed distances with Python's correctly rounded formatting of the same doubles, and all agreed.

## Findings recorded as corrections in PLAN.md

- **`remove` after a failed write could delete a non-regular file.** `write_csv_file` removes its output only when `stat` reports a regular file.
  - *How it was found:* running `geolab generate --out /dev/stdout` in a pipe during development failed and attempted `remove("/dev/stdout")`, which was refused only because of permissions.
  - *Tests:* `/dev/full` (the device must survive) and a symbolic link to `/dev/full` owned by the test (the link must survive). The mutation check showed that without the link test, an unconditional `remove` was indistinguishable to a non-root test.
- **VEC=off and VEC=default are the same machine code for GCC 11.** `gcc -Q --help=optimizers -O2` reports `-ftree-loop-vectorize [disabled]` and `-ftree-slp-vectorize [disabled]`. Every GCC object in the two benchmark builds is byte-identical (`cmp`). For Clang 14, only `csv.o` differs; `geo.o`, `query.o` and `bench.o` are identical. The plan anticipated that the default might not vectorize; the package records it as the central S02 observation.
- **The E03 fixtures live in each package** (`learner/fixtures`, `instructor/fixtures`), and the E04 bench plumbing (option handling and printing) is supplied, so the learner writes the measurement kernel rather than the printing. Both are workload choices under A5.

## Protocol runs

The full protocol ([PROTOCOL.md](PROTOCOL.md)) ran for both compilers with `faults.txt` = none. Raw outputs are in [sample-results](sample-results). Headline medians of five process-run medians, gcc, `VEC=off`, in ns per point:

| Variant | d1k | d100k | d1m |
| --- | --- | --- | --- |
| distance | 33.69 | 44.14 | 44.69 |
| query | 34.56 | 47.36 | 49.90 |
| parse | — | 91.06 | — |

**Single-run smoke test** (`--quick`, one run, repeat 3, warm-up 1), before the full protocol. At d1k, `distance` measured 44.28 ns per point for `VEC=off` against 35.57 for `VEC=default`. Those are byte-identical executables apart from `envinfo.o`'s recorded flags. That is a 25% difference between identical machine code in one run.

**Size sweep**, taken while the mutation check was running on the same machine, so noisier than the protocol. Prefixes of d100k, gcc `VEC=off`, three runs each (ns per point):

| Points | Runs |
| --- | --- |
| 1,000 | 40.6, 57.3, 35.6 (d1k itself: 34.5, 34.3, 35.1) |
| 2,000 | 37.1, 38.7, 39.7 |
| 5,000 | 46.1, 44.5, 45.4 |
| 10,000 | 47.6, 49.3, 48.3 |
| 20,000 | 54.2, 51.2, 55.0 |
| 50,000 | 52.8, 48.3, 47.9 |
| 100,000 | 46.2, 47.9, 52.1 |

A single cold pass over 1,000 points (`--repeat 1 --warmup 0`) measured 74.5, 59.6 and 59.9 ns per point. These runs suggest that the lower cost at 1,000 points depends on size and on repetition rather than on the particular points. The answer key keeps the cause as a hypothesis (weeks 22 and 27).

## Mutation check of the harness

`make mutate` ([extras/mutate.py](extras/mutate.py)) applies one textual change at a time to the reference, rebuilds with gcc at `-O0`, and runs `tests/check.py`. The final run had **46 mutants and 4 survivors**, after the fixes below.

**Fixes made because of the mutation check:**

- *“Center not validated” survived the first run.* `query_points(NULL, 0, 95, …)` returned success, because the empty-input shortcut came before any distance was computed. The suite now requires that an empty dataset still has its center and radius validated. This was a real gap.
- *The unconditional-`remove` mutant survived.* The symbolic-link test above was added. This was a real gap; the mutant is now killed.
- *Three mutants had first failed only to compile* (unused variables under `-Werror`): “sign always allowed”, “upper middle as median” and “no clamp”. They were rewritten so they compile, and then judged on behavior.

**Survivors:**

| Mutant | Classification |
| --- | --- |
| Points not validated in `query_points` | Equivalent: `geo_distance_km` validates every point again and the query then fails the same way. The early loop exists so that nothing is allocated before validation; that is not observable except through allocation counts. |
| `cmd_query` leaks the points when `query_points` fails | Untested error path. `query_points` can fail after a successful load only on an allocation failure, and `check.py` does not inject allocation failures into the whole program. The contract suite covers `query_points`' own allocation failures; the command-level path is covered by reading, not by a test. |
| Short-sample boundary `<` changed to `<=` | Equivalent in practice: it differs only for a sample of exactly 1,000 × resolution nanoseconds, which no deterministic test can produce. |
| The backwards-clock check removed | Unreachable defensive code. `CLOCK_MONOTONIC` does not go backwards (POSIX/Linux); the check exists because the contract is cheap to enforce. |
| The haversine clamp removed | Not killed; kept by design. No test input produces `a` far enough above 1 for `sqrt(a)` to exceed 1. Week 3 found that `a` does exceed 1 by one ulp at some exact antipodes, but `sqrt(1 + 2^−52)` rounds to 1. This is an observation of this platform and these inputs, **not** a proof that the clamp is redundant for every input, rounding mode or `libm`, so the clamp stays (week 3, corrections A3). |

## Limits of this evidence

- The tests establish agreement with the specification, the oracle and the fixtures. They do not establish correctness on untested inputs, and they share the specification, the model constants and glibc's `libm` with the oracle (see E03.Q).
- Timing numbers come from one laptop under WSL on one day. The exemplar prediction was written after a smoke run had been seen (stated in the report).
- The ten-hour estimate is **unpiloted**. Agent execution time says nothing about learner completion time.
- The pilot procedure in PLAN.md is **pending**. No participant data exist.

## Final verification

`rm -rf build && make verify`, run on 2026-09-22 on a copy in the WSL home directory, finished with exit status 0 in 1 min 10 s. It ran eight stages:

1. `make PACKAGE=instructor checkpoint`: a clean rebuild, then `make test` with gcc debug, clang debug, gcc optimized, clang optimized and gcc sanitize, each ending `PASS: oracle self-test, 3 C contract suites + 2 forced-skip builds, generate/query/bench command contract, 8 oracle query comparisons, 7 fixtures, symbol subset` and preceded by the inventory `PASS`.
2. `tools/identity.py`: four queries on d100k, byte-identical across the four builds (SHA-256 prefixes `ea0c116d…`, `f8374493…`, `6997ccfb…`, `06038cd7…`).
3. The manifest: 27 files.
4. `make PACKAGE=instructor CC=clang MODE=sanitize test`: PASS.
5. `bench-bins` for both compilers.
6. The protocol smoke run: 4 raw files, faults 0.
7. `make starters`: both compilers' learner scaffolds compile and fail 65 behavioral checks.
8. `geolab generate --count 1000000 --seed 5` (gcc, optimized) reproduced the d1m digest `513c4440…0a42`.
