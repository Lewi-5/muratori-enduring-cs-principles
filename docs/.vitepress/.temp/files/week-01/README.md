# Week 01 — C as an inspectable starting point

<!-- companion-navigation -->
**[Read the full Week 1 companion chapter](../docs/content/weeks/week-01.md).** Use fifteen small programs to separate language rules, generated mechanisms, and observations. Read the companion before starting the field notebook; it explains the purpose and evidence for every exercise.

The chapter is designed for programmers new to systems concepts. Run the VitePress site from the repository root to see imported exercise contracts, source listings, readings, hints, and separate solution pages. The original package instructions and requirements below remain authoritative.
<!-- /companion-navigation -->

Complete one graded **C field notebook**: fifteen small programs and a report that connects C source, a mechanism, and an observation. This week prepares you for object layout and storage duration in week 2. It does not require a particular speedup or a memorized assembly listing.

Prerequisites: prior programming and basic C experience, a terminal, and willingness to distinguish a language guarantee from an observation. Review the [course syllabus](../PLAN.md), [qualified thesis and course context](../solPlan.md), and [transcript analysis](../analysis.md). The [week specification](PLAN.md) records the requirements implemented here.

After this week you can build separate C11 translation units; use arrays, pointers, structs, allocation, files and explicit error returns; inspect bytes without aliasing violations; and report repeatable measurements with limitations.

## Beginner section and warm-ups

The site's [Week 1 beginner section](../docs/content/beginners/week-01.md) builds this week's way of looking at C from scratch, with checked example programs, and adds four ungraded warm-ups (W01–W04) that practise habits several exercises depend on: [contracts](learner/warmups.md), scaffolds in `learner/src/w01.c`–`w04.c`, and `make warmups` to check only them (`make test` checks them first). After the lesson, the [further-reading page](../docs/content/further-reading/week-01.md) introduces the seven companion texts, cross-references every video below to the matching book sections, and asks six [reading questions](learner/reading-questions.md) (F01–F06). Both are outside the graded 43 prompts and the core time budget.

## Start here

Use **x86-64 Linux or Ubuntu under WSL**, with GCC, Clang, make, Python 3 (test orchestration only), and binutils (`nm`). From this directory:

```sh
make                          # compile the empty learner starters
make test                     # deliberately fails until you implement them
make CC=clang test            # test your completed solutions with the other compiler
make bench                    # run your ex15 at -O0 and -O2
make symbols                  # inspect exercise 14 objects and executable
make assembly                 # produce exercise 06 assembly at both levels
```

Work in [learner/src](learner/src). Read [the assignment and exact contracts](learner/exercises.md), then complete [practice and stretch work](learner/practice.md). Copy [the report template](learner/observations.md) to your submission. The [rubric](rubric.md) explains grading. Tests are public; they are evidence, not a substitute for explaining correctness. Invalid-lifetime and out-of-bounds examples appear only as text to reason about, never as required runnable programs.

All exercises build independently, except ex14, which explicitly compiles two `.o` files before linking. Flags are `-std=c11 -Wall -Wextra -Wpedantic -Werror -O0`; optimized mode uses `-O2`. Exercise 15 defines `_POSIX_C_SOURCE=200809L` before its headers to expose `clock_gettime`. Build directories separate package, compiler, and mode. Changing custom toolchain contents requires `make clean` before rebuilding. The default build never opens or compiles instructor solutions.

## Reading and time budget

Links checked on 2026-09-19. Computer, Enhance! requires a subscription; these original exercises do not reproduce its paid assignments or transcripts.

| Resource | Portion | Purpose |
| --- | --- | --- |
| [CE: Welcome](https://www.computerenhance.com/p/welcome-to-the-performance-aware) | Full, plan budget 22:05 | Performance-awareness motivation |
| [CE: Waste](https://www.computerenhance.com/p/waste) | Full, plan budget 32:56 | Notice work before trying to improve it |
| [Handmade Chat 011: Undefined Behavior](https://guide.handmadehero.org/chat/chat011/) | 4:18–22:16 | Separate intuitive machine stories from C rules |
| [Handmade Chat 013: Translation Units, Function Pointers, Compilation, Linking, and Execution](https://guide.handmadehero.org/chat/chat013/) | 15:39–32:42; optional 38:58–48:55 | Compilation and linking; adapt Windows/C++ discussion to C11/Linux |
| [C11 public draft N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) | Consult §§6.2.6, 6.5, 6.5.3.4, 6.7.6.3, 6.9, 7.21, 7.22 as needed | Primary authority for language/library claims |
| [Linux clock_gettime manual](https://man7.org/linux/man-pages/man3/clock_gettime.3.html) | Clock and return-value sections | POSIX timer contract, outside ISO C |

The CE durations are planning estimates carried from the specification; the public subscription pages do not expose playback durations. HH required segments plus those estimates total about 90 minutes (100 with the optional segment). Do not adopt the talk's historical implicit function declaration as valid C11 practice.

| Activity | Minutes |
| --- | ---: |
| Viewing and focused reference consultation | 100 |
| Setup and playground (E02/E06) | 25 |
| E01–E10, including explanations | 120 |
| E11–E14, including explanations | 95 |
| E15 and report | 80 |
| Six practice questions and submission checks | 60 |
| Optional stretch / debugging reserve | 60 |
| Total | 540 (9 hours) |

The playground is the E02/E06 pair: change array length and values within their contracts, predict output, run, and relate the observations to object extent and pointer traversal. It feeds the notebook rather than adding a second graded assignment.

## Instructor use

Solutions are deliberately separate in [instructor](instructor/README.md). `make verify` builds and tests all references at both optimization levels and under AddressSanitizer/UndefinedBehaviorSanitizer with both compilers, then checks starter compilation. `make inventory` checks every numbered prompt against the written answer headings and coverage checklist. The [validation record](instructor/validation.md) distinguishes actual local checks from illustrative report data.
