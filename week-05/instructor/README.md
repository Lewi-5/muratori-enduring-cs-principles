# Instructor materials — spoilers

This package contains:

- **[geolab](geolab):** the complete, annotated reference project.
- **[answers.md](answers.md):** the written answer key for all fourteen milestone prompts, five practice problems and both stretch exercises.
- **[PROTOCOL.md](PROTOCOL.md) and [report.md](report.md):** an exemplar protocol and report. The report is built from real runs recorded in [sample-results](sample-results): 70 raw outputs per compiler, with `index.csv`, `faults.txt` and `summary.md`.
- **[fixtures](fixtures/README.md):** the E03 exemplar fixtures.
- **Extras:** [extras/bytes_per_point.c](extras/bytes_per_point.c) implements S01, [extras/vec_report.sh](extras/vec_report.sh) implements S02, and [extras/mutate.py](extras/mutate.py) is the mutation check of the harness.
- **[coverage.md](coverage.md)** maps all 26 prompt IDs to their answers.
- **[validation.md](validation.md)** records actual execution evidence, the tolerance measurements and the mutation results.

```sh
make PACKAGE=instructor test
make PACKAGE=instructor checkpoint        # five configurations, cross-build identity, manifest
make PACKAGE=instructor bench-data        # the full protocol (several minutes)
make verify                               # everything, including the learner-scaffold check
make mutate                               # about 45 minutes; run it from a copy outside OneDrive
```

**How the tests work.** Python orchestrates; the program under test is C.

- **Supplied oracle.** The independent oracle in [tests/oracle.py](../tests/oracle.py) writes the datasets and the command-line number corpus.
- **Contract suites.** Three C suites in [tests/contracts.c](../tests/contracts.c) each include one module's source (so fault-injection macros reach only that module) and link it with the other objects. The `bench` suite's perturbation hook redirects `geo_distance_km` inside `bench.c` only.
- **Checks through the binary.** [tests/check.py](../tests/check.py) exercises the command-line contract through the built binary: exit codes, empty standard output on failure, `/dev/full` for output errors, and oracle comparisons of `query` output under the banded tolerance rule in [tests/fixture_lib.py](../tests/fixture_lib.py).
- **Symbols.** Every object's external symbols must be declared in a header.
- **No timings.** Nothing asserts a timing.
- **The scaffold.** [tests/starters.py](../tests/starters.py) confirms that the learner scaffold compiles under both compilers, that every contract suite compiles against it, and that it fails for behavioral reasons.

**What learners write and what is supplied.** The scaffold supplies the headers, `main.c`, the option scanner, `cli_check_future_options`, `bench_format_checksum` and the option handling and printing of `cmd_bench`. Learners write:

- `parse_cli_decimal`, `cmd_generate` and `cmd_query`;
- `query_hit_compare` and `query_points`;
- `summarize_ns` and `bench_measure`.

They also copy their week-3 and week-4 code into `geo.c` and `csv.c`. The plan says “implement the bench subcommand”. The package supplies its plumbing and keeps the measurement kernel as the learner's work; this is recorded as a workload correction in [PLAN.md](../PLAN.md).

**Grading.** Grade from the learner's own evidence: their protocol, their raw files, their report. The sample results are one machine's measurements. The most instructive observation in them is that the GCC `VEC=off` and `VEC=default` executables are byte-identical, yet a single run once showed a 25% difference between them. Use it when a learner claims a difference from one run. A learner whose newer GCC vectorizes something at `-O2` is reporting a different valid observation, not an error.

Passing the inventory proves structural coverage, not teaching quality. The time budget is unpiloted: do not claim that agent execution time or compiler verification establishes a ten-hour human completion time. The pilot procedure is at the end of [PLAN.md](../PLAN.md).
