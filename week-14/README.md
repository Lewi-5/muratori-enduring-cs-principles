# Week 14 · Nested and recursive profiling

Complete the typed learner scaffolds before opening the instructor package. Every question is original course work. The exact [API contract](include/profile.h) defines units, ownership, failures and bounds. [Exercises](learner/exercises.md), [practice](learner/practice.md), [notebook](learner/observations.md), [warm-ups](learner/warmups.md) and [rubric](rubric.md) define the submission.

## Prerequisites and outcomes

Bring Weeks 1–5 C arrays, checked unsigned arithmetic, compilation and experiment design, plus Week 11 object inspection and Week 12 whole-system evidence. Week 13 timing is required; support/clock.c pins its completed monotonic reader so profiling can be implemented independently.

You will attribute nested and recursive invocations, preserve state on failures and measure instrumentation perturbation. Correctness uses injected timestamps; real runs retain variable measurements without numeric pass thresholds.

## Work plan (unpiloted)

| Work | Minutes |
| --- | ---: |
| Assigned viewing and notes | 120 |
| E01–E04 implementation | 200 |
| Tests, warm-ups and practice | 120 |
| E05 measurement and notebook | 100 |
| Review against rubric | 60 |
| Core total | 600 |

Allow an additional 2–4 hours for beginner preparation if needed. These are planning estimates, not validated learner completion times. CE is a subscription resource; linked public pages establish title/runtime and topic, not access to paid episode contents.

## Build, test, inspect and measure

```sh
cd week-14
make
make test
make warmups
make inspect
make CC=clang MODE=optimized inspect
python3 tools/measure.py gcc optimized learner
# Separate reference package, after your attempt:
make verify
```

The default package is learner. Its unfinished typed stubs compile with strict warnings and intentionally fail correctness. Use PACKAGE=instructor for the complete reference. Linux/WSL GCC and Clang are supported; POSIX CLOCK_MONOTONIC is outside ISO C. Debug=-O0, optimized=-O2, sanitize=-O1 with ASan/UBSan. All use C11 and no LTO. Sanitizer times are correctness evidence and are unsuitable for performance comparisons.

`make verify` runs six reference compiler/mode combinations, four actual object inspections, learner scaffold checks, prompt inventory and exact beginner snippets. The profiler requires serialized use of each caller-owned instance; independent threads need independent storage.

## Programs and output

`playground` uses fixed timestamps; fixtures/playground.txt is an exact golden. `bench` initializes 512 points with IDs 1..512, warms the workload, executes 32 folds per batch, checks 4202496 and prints after measurement. Nine paired baseline/instrumented batches alternate order. The default nested batch has 33 completed scopes. Run `build/learner/gcc/debug/bench outer` for one outer scope over the same work, or capture it with `python3 tools/measure.py gcc optimized learner outer`; CSV fields are pair,index,baseline_ns,instrumented_ns,relative_difference,checksum,covered_ns,hits. NA means a zero baseline.

Check exit status, including write failures. No particular duration, counter frequency, slowdown or speedup is required. Capture raw data plus host/build context through tools/measure.py. Inspect manifests and disassembly under build/inspect; observations belong in [your notebook](learner/observations.md).

## Measurement limits

Inclusive totals count every invocation, including recursive overlap; self time subtracts only direct children. Covered time sums self across recorded roots and omits unrecorded gaps. Instrumentation changes instructions and memory traffic, so empty-hook subtraction is not an exact restoration of uninstrumented execution.

The reference [report](instructor/report.md), [answers](instructor/answers.md), [coverage](instructor/coverage.md) and [validation](instructor/validation.md) are separate spoilers. Primary references: [Linux clock manual](https://man7.org/linux/man-pages/man3/clock_gettime.3.html) and [Intel manuals, RDTSCP/LFENCE/CPUID entries](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html). Windows QPC material is a comparison, not the Linux contract.
