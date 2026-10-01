# Instructor materials — spoilers

The [answer key](answers.md) provides the reasoning for all coding, conceptual, practice and stretch prompts. [src](src) contains annotated, working reference C. [extras/stretch_edges.c](extras/stretch_edges.c) implements S01 and [extras/stretch_antipodal.c](extras/stretch_antipodal.c) implements S02; [extras/measure.c](extras/measure.c) records the maximum errors that justify every tolerance in [tests/tolerances.h](../tests/tolerances.h) and prints the recorded (not asserted) measurements the answer key quotes. [observations.md](observations.md) is a completed illustrative report, [coverage.md](coverage.md) maps all 27 prompt IDs, and [validation.md](validation.md) records actual execution evidence.

```sh
make PACKAGE=instructor test
make PACKAGE=instructor CC=clang MODE=optimized test
make PACKAGE=instructor symbols
make verify
```

The six configurations exercise the same API contracts, rejection paths, an independent integer segment oracle over 6,561 segment pairs, a modular-arithmetic oracle for `fmod`, the forced-skip gates and the symbol-subset check. The C tests include each reference source with its `main` renamed; E07 links `geomath.o` and includes only `geomath.h`. Python only orchestrates: it parses driver output, compiles and runs the C suites, applies the flag policy (it refuses forbidden floating-point flags), and checks that the tolerances used by the C tests are the ones in the header.

Scaffolds contain types, signatures and demonstration plumbing, with TODO mechanism bodies. Learners copy their own helpers between standalone files; the reference copies are intentionally visible rather than hidden behind a utility library. Review those copies when changing a contract: if you change `sin_deg`, change it in `ex03.c`, `ex04.c`, `ex05.c` and `geomath.c`.

Passing the ID inventory proves structural coverage, not teaching quality. Review every explanation and each learner's prediction/observation distinction. The time budget is unpiloted; do not claim that compiler verification establishes a ten-hour human completion time. During grading, use the learner's actual evidence and accept alternative correct implementations and justified tolerances; the sample error tables are one machine's measurements.
