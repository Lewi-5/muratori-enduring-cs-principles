# Timing protocol — exemplar (E05.C)

Written 2026-09-22, before the recorded runs in [sample-results](sample-results). It is the default configuration of [tools/bench_data.py](../tools/bench_data.py).

## Question

What is the scalar baseline cost per point of `distance`, `query` and `parse` on this machine? Does it change with dataset size, or between the `VEC=off` and `VEC=default` builds?

## Fixed before collecting data

- **Datasets:** the oracle's d1k (seed 1, 1,000 rows), d100k (seed 11400714819323198485, 100,000 rows) and d1m (seed 5, 1,000,000 rows). They are generated into `build/data` and checked against the SHA-256 digests recorded in `tests/oracle.py`.
- **Builds:** one per compiler (GCC 11.4.0, Clang 14.0.0) and variant.
  - `-O2 VEC=off` adds `-fno-tree-vectorize` for GCC and `-fno-vectorize -fno-slp-vectorize` for Clang. It lives at `build/instructor/CC/bench-vec-off/geolab`.
  - `-O2 VEC=default` lives at `build/instructor/CC/bench-vec-default/geolab`.
  - Both share the base flags `-std=c11 -Wall -Wextra -Wpedantic -Werror -ffp-contract=off -D_POSIX_C_SOURCE=200809L`. The full command is printed in every output's `env flags=` line.
- **Variants and parameters:** `distance` and `query` at every size, and `parse` at d100k. The center is (10, 20) and the query radius 2,000 km. Each run uses `--repeat 21 --warmup 3`.
- **Process runs:** five per (compiler, variant, size, build).
- **Order:** within each run, every (size, variant) pair runs both builds back to back. The build order is `vec-off` first in odd runs and `vec-default` first in even runs. GCC's five runs are collected first, then Clang's; the two compilers are reported separately and not compared with each other.
- **Held constant:** the laptop on mains power; no other interactive programs; the same WSL session; no CPU pinning. Inside WSL, `taskset` pins only to a virtual CPU, so pinning would not remove the hypervisor's scheduling and was not used.
- **Recorded:** each invocation's complete output (the `env` block and the `bench` line) in its own file named by run, compiler, build, variant and size; `index.csv` with every command; `faults.txt`; and `summary.md`.
- **Stopping rule:** the five runs are reported as recorded. A run would be repeated only for a documented fault: a nonzero exit, or a checksum that differs between runs or builds. Any such rerun would be listed in `faults.txt` and here. No other reason justifies a rerun.
- **Comparison rule:** for two conditions, compare the ranges (minimum to maximum) of their five process-run medians. Overlapping ranges mean no clear separation. Non-overlapping ranges describe these runs; they are not a significance test and do not identify a cause.

## Deviations

None. Both compilers' runs completed with `faults.txt` = `none`. A separate single-run smoke test and a size sweep taken while other work was running are recorded in [validation.md](validation.md), not mixed into these results.
