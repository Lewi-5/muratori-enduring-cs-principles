# Instructor package — spoilers

Read only after attempting the learner assignment. [answers.md](answers.md) explains every coding and reasoning prompt; [observations.md](observations.md) is a completed illustrative report; [coverage.md](coverage.md) maps all prompts to answers. Annotated reference implementations are in [src](src), with runnable practice/stretch examples in [extras](extras).

From `week-01`:

```sh
make PACKAGE=instructor test
make PACKAGE=instructor CC=clang test
make PACKAGE=instructor bench
make PACKAGE=instructor symbols
make PACKAGE=instructor assembly
make verify
```

The executable contracts and C function tests are shared with learners. Additional fault-injection tests exercise allocation failure and file read/close failures without relying on a real out-of-memory event or damaging a file. They wrap library calls only in the test translation unit. No failure fixture executes undefined behavior.

The [validation record](validation.md) records the real environment and checks. The illustrative report's benchmark numbers are explicitly synthetic, so they teach arithmetic without claiming a measurement that was never taken. During grading, use the learner's actual evidence and accept alternative correct implementations; the inventory checks presence and uniqueness, not the quality of reasoning.
