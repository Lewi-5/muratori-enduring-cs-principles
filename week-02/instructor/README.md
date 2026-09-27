# Instructor materials — spoilers

The [answer key](answers.md) provides the reasoning for all coding, conceptual, practice and stretch prompts. [src](src) contains annotated, working reference C; [extras/permutations.c](extras/permutations.c) implements S01. [observations.md](observations.md) is a completed illustrative report, [coverage.md](coverage.md) maps all 33 prompt IDs, and [validation.md](validation.md) records actual execution evidence. S02 has a captured toolchain excerpt, separately labelled as one build.

```sh
make PACKAGE=instructor test
make PACKAGE=instructor CC=clang MODE=optimized test
make PACKAGE=instructor symbols inspect
make verify
```

The six configurations exercise the same API contracts, CLI failures, two allocation-fault adapters and architecture-skip paths. The C tests include the reference source with its main renamed; E09 still builds two separate objects for the production executable. Test adapters alone replace allocation calls; shipped programs use the real C library. Python only orchestrates checks and compares permutation results to an independent small oracle.

Scaffolds contain types, signatures and demonstration plumbing, with TODO mechanism bodies. Learners copy their own helpers between standalone files. E10 token parsing is supplied to keep this week focused on layout. The reference copies are intentionally visible rather than hidden behind a utility library. Review those copies when changing a contract.

Passing the ID inventory proves structural coverage, not teaching quality. Review every explanation and learner's prediction/observation distinction. The corrected plan's time budget is unpiloted; do not claim that compiler verification establishes a ten-hour human completion time.
