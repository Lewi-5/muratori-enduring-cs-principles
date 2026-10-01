# Week 14 reference report

## Prediction and deterministic observation

The fixed tree has root0 [0,100], outer1 [10,40], inner1 [20,30]. Root self 70 plus recursive-ID self 30 covers 100; inclusive 100+40=140 counts overlap. Region1 has two hits. Both different-ID UINT64_MAX nested intervals can fit their buckets while the combined inclusive report fails with output unchanged.

The exact playground output is checked against fixtures/playground.txt. The deterministic C tests include 10,000 three-invocation interval trees, capacity/boundary/error cases and failure snapshots. These tests cover the stated domains and are not a proof for every possible program.

## Actual host measurements

- [gcc/debug raw CSV](evidence/gcc-debug/raw.csv) and [manifest](evidence/gcc-debug/manifest.json); [outer-only CSV](evidence/gcc-debug/outer/raw.csv).
- [gcc/optimized raw CSV](evidence/gcc-optimized/raw.csv) and [manifest](evidence/gcc-optimized/manifest.json); [outer-only CSV](evidence/gcc-optimized/outer/raw.csv).
- [clang/debug raw CSV](evidence/clang-debug/raw.csv) and [manifest](evidence/clang-debug/manifest.json); [outer-only CSV](evidence/clang-debug/outer/raw.csv).
- [clang/optimized raw CSV](evidence/clang-optimized/raw.csv) and [manifest](evidence/clang-optimized/manifest.json); [outer-only CSV](evidence/clang-optimized/outer/raw.csv).

| Compiler/mode | Baseline lower median (ns) | Nested lower median (ns) | Outer-only comparison (ns) |
| --- | ---: | ---: | --- |
| gcc/debug | 34257 | 37707 | outer median 49793 ns; separately paired baseline 45938 ns |
| gcc/optimized | 3676 | 6374 | outer median 4680 ns; separately paired baseline 4572 ns |
| clang/debug | 10220 | 11914 | outer median 8925 ns; separately paired baseline 11985 ns |
| clang/optimized | 3350 | 6121 | outer median 3422 ns; separately paired baseline 3343 ns |

Host: `Linux-6.18.40.1-microsoft-standard-WSL2-x86_64-with-glibc2.35`; `model name	: 12th Gen Intel(R) Core(TM) i7-12650H`. GCC/Clang versions and complete source/binary/raw hashes are in each manifest. Workload: 512 points, 32 folds, checksum 4202496. Samples are nine per group, with all raw values retained; comparisons use lower ranked median. These are observations from this host, not goldens or pass thresholds.

Default batches report33 hits and outer batches one hit, with the same result. The profiler copies a complete bounded state on events to guarantee coherent failure behavior; those copies are part of this implementation’s measured perturbation. Nine separately paired observations do not establish a constant per-hook cost. Compare raw paired differences rather than subtracting independent group medians as if they were matched experiments. Covered time omits gaps outside scopes; inclusive totals overlap. Negative observations are valid data.

## Actual emitted code

The GCC 11.4 optimized profile_begin reserves 0x4a8 stack bytes in the captured object and emits repeated MOVS for state copy/publication. Clang 14’s version reserves 0x498 and uses its own copy lowering. GCC’s profile_end retains an R_X86_64_PLT32 relocation naming profile_accumulate. Debug artifacts expose local candidate/frame/duration operations more literally. All four manifests record source hashes, compiler, target and exact inspection flags; the copies remain real execution work even though the profiler arithmetic is correct.

Regenerate with `make PACKAGE=instructor CC=gcc MODE=optimized inspect` and the other compiler/mode choices. The relevant artifacts are in `build/instructor/COMPILER/MODE/inspection`. Offsets and instruction choices are observations of these actual objects, not required translations or cycle counts.

## Claim and next experiment

Supported: the event arithmetic handles nested/recursive invocations under its bounded serialized contract; the captured granularity variants expose actual observer work. Unsupported: instrumentation always costs the same fraction or can be exactly corrected by one subtraction. A next experiment would change placement/depth while preserving work and capture repeated paired observations under stated host conditions.
