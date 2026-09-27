# Instructor materials — spoilers

The [answer key](answers.md) provides the reasoning for all coding, conceptual, practice and stretch prompts. [src](src) contains annotated, working reference C. [extras/stretch_layout.c](extras/stretch_layout.c) implements S01 and [extras/repro_audit.py](extras/repro_audit.py) implements S02; [extras/measure.c](extras/measure.c) records the maxima that justify tolerances in [tests/tolerances.h](../tests/tolerances.h) and prints the recorded (not asserted) measurements the answer key quotes. [observations.md](observations.md) is a completed illustrative report, [coverage.md](coverage.md) maps all 27 prompt IDs, and [validation.md](validation.md) records actual execution evidence.

```sh
make PACKAGE=instructor test
make PACKAGE=instructor CC=clang MODE=optimized test
make audit
make verify
```

The six configurations exercise the same contracts: an independent Python oracle for the generator, the formatter, the grammar and exact summation; 8,510 differential parse cases; byte-exact fixtures; fault injection (`malloc`, `realloc`, `fgetc`, `ferror`, `fclose`, `fflush`, `remove`) applied in the test translation unit only; three cap-lowered builds (`GEOLAB_MAX_ROWS` 10, 8 and 1500) that make growth, clamping and the row limit reachable with small files; the forced-skip gates; and, for the instructor package, the measurement program, the layout comparison and the reproducibility audit. The C tests include each reference source with its `main` renamed, so reference and learner code are tested identically. Python orchestrates: it writes the oracle's files, runs the drivers and compares their output with the oracle (and, for the summations, with an independent Python re-implementation of the same operations that must reproduce every printed digit), compiles and runs the C suites, and applies the flag policy (it refuses forbidden floating-point flags).

Scaffolds contain types, signatures and demonstration plumbing, with TODO mechanism bodies. Learners copy their own helpers between standalone files; the reference copies are intentionally visible rather than hidden behind a utility library. Review those copies when changing a contract: if you change `lcg_below`, change it in `ex01.c` and `ex03.c`; `parse_record` in `ex04.c` and `ex05.c`; `haversine_km` in `ex06.c`.

Passing the ID inventory proves structural coverage, not teaching quality. Review every explanation and each learner's prediction/observation distinction. The time budget is unpiloted; do not claim that compiler verification establishes a ten-hour human completion time. During grading use the learner's actual evidence and accept alternative correct implementations and justified tolerances; the sample error tables are one machine's measurements. The [mutation record](validation.md#mutation-check-of-the-harness) lists which behavioral mutants the harness kills and why the survivors are equivalent.
