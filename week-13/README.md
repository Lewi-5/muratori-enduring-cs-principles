# Week 13 · Clocks and repeatable timing

Complete the typed learner scaffolds before opening the instructor package. Every question is original course work. The exact [API contract](include/timing.h) defines units, ownership, failures and bounds. [Exercises](learner/exercises.md), [practice](learner/practice.md), [notebook](learner/observations.md), [warm-ups](learner/warmups.md) and [rubric](rubric.md) define the submission.

## Prerequisites and outcomes

Bring Weeks 1–5 C arrays, checked unsigned arithmetic, compilation and experiment design, plus Week 11 object inspection and Week 12 whole-system evidence. The Week 12 simulator remains a correctness checkpoint; this week measures a real C workload rather than guest instruction counts.

You will convert checked clock readings, retain raw intervals and qualify counter calibration. Correctness uses injected timestamps; real runs retain variable measurements without numeric pass thresholds.

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
cd week-13
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

`make verify` runs six reference compiler/mode combinations, four actual object inspections, learner scaffold checks, prompt inventory and exact beginner snippets. It also compiles/runs TIMING_NO_TSC with both compilers to check capability absence.

## Programs and output

`playground` uses fixed timestamps; fixtures/playground.txt is an exact golden. `bench` initializes 512 points with IDs 1..512, warms the workload, executes 32 folds per batch, checks 4202496 and prints after measurement. Nine work and empty samples per available clock are retained; counter rows appear only when supported. Calibration labels ns, ticks and empirical ticks/sec separately.

Check exit status, including write failures. No particular duration, counter frequency, slowdown or speedup is required. Capture raw data plus host/build context through tools/measure.py. Inspect manifests and disassembly under build/inspect; observations belong in [your notebook](learner/observations.md).

## Measurement limits

Linux monotonic elapsed time includes preemption while awake and excludes suspend; repeated values are allowed. Counter ticks are not core cycles. The optional x86-64 fenced RDTSCP path uses Intel ordering assumptions, advertised user-mode access, CPUID capability and AUX diagnostics. Equal AUX cannot prove no migration. Store visibility, VM fidelity and cross-core synchronization are outside this experiment’s guarantees.

The reference [report](instructor/report.md), [answers](instructor/answers.md), [coverage](instructor/coverage.md) and [validation](instructor/validation.md) are separate spoilers. Primary references: [Linux clock manual](https://man7.org/linux/man-pages/man3/clock_gettime.3.html) and [Intel manuals, RDTSCP/LFENCE/CPUID entries](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html). Windows QPC material is a comparison, not the Linux contract.
