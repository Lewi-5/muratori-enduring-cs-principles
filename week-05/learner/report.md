# Project 1 report — `geolab` checkpoint 1

Keep the sections separate: correctness is established before any timing, predictions are recorded before the runs, and every timing is labelled with its machine, build and date. Label every claim as C11, POSIX/Linux, compiler, hardware, oracle, or observed on this machine.

### R01

**Environment.**

- Hardware and virtualization: CPU model, core count, and whether this is a VM or WSL.
- OS and kernel.
- Compilers and versions, and the glibc version.
- The complete flags of each build variant (copy them from the `env` block).
- The clock and its reported resolution.
- Confirmation that no forbidden flag appears.

### R02

**Correctness, before any timing.**

- Which checks passed: `make checkpoint`, the contract suites, the oracle comparisons, your fixtures, the sanitizer run, and the cross-build identity.
- What that evidence covers.
- What it does not cover.

### R03

**Prediction**, recorded before `make bench-data` and not edited afterwards.

- Your model: the `libm` calls and other work per point, and the per-call cost range you assume.
- The predicted `median_ns_per_point` for `distance` and `query` at 1,000, 100,000 and 1,000,000 points.
- Whether you expect the cost per point to stay constant as the dataset grows, and why.

### R04

**Observation and uncertainty.**

- The observation table: for each variant, size and build, the five process-run medians and their range, and the largest within-run spread.
- The number of short samples.
- Between-run versus within-run variation.
- Each comparison you make, stating whether the ranges overlap. Do not treat non-overlap alone as a significance test or as evidence of a cause.
- A claim ledger of at least eight statements, each labelled C11, POSIX/Linux, compiler, hardware, oracle, or observed.
- The conclusions the evidence permits, and those it does not.

### R05

**Defense and handoff.**

- The submission manifest (`build/learner/MANIFEST.txt`).
- One source → mechanism → observation defense.
- The scalar baseline later weeks will compare against: the dataset, build, command and recorded medians.
- One open question for week 6.
