# Week 01 — C as an inspectable starting point

**Status:** Implemented. Start with [the weekly guide](README.md); learner exercises, compilable starters, deterministic tests, separate reference C solutions, complete written answers, practice/stretch solutions, and a report exemplar are present. See the [validation record](instructor/validation.md) for executed checks. The requirements below remain the acceptance specification.

**Parent plan:** [52-week syllabus](../PLAN.md). **Time budget:** 8–10 hours. **Audience:** Experienced programmers and C users; the exercises begin with elementary C to establish a common baseline. A new C learner can use this week as an introduction, but the later course assumes additional practice.

## Beginner section and further reading (added 2026-09-28)

Following the Week 3 pilot, Week 1 gains a beginner page (`docs/content/beginners/week-01.md`) and a further-reading page (`docs/content/further-reading/week-01.md`). The lesson, its 43 prompts, the rubric and the time budget are unchanged. Additions:

- The beginner page is written to [WRITINGFORBEGINNERS.md](../WRITINGFORBEGINNERS.md). Its concept sections cover: the C promise versus one build; a value, its bytes and its display; sizes as relationships; struct padding; failure as part of an interface; ownership of memory and files; translation units and linking; and what a single timing shows. It ends with a worked loop invariant and overflow bound. Its seven programs are in `docs/examples/week-01/`, verified with GCC and Clang at `-O0` and `-O2` by `tools/docs/verify-examples.py`.
- Four ungraded warm-ups, W01–W04 ([contracts](learner/warmups.md), [answers](instructor/warmups.md)): checked addition against a limit (E03, E04, E11, E13), a backward search with an unsigned index (E05, E06, E14), bytes and bits of a value (E09, E10), and owning a string copy (E11, E12). Scaffolds are `learner/src/w0N.c`, solutions `instructor/src/w0N.c`; `tests/warmups.c` and `tests/warmups.py` check them, with an injected `malloc` failure for W04. `make warmups` runs only these checks; `make test` and `make verify` include them.
- Six reading questions, F01–F06 ([questions](learner/reading-questions.md), [answers](instructor/reading-answers.md)), and a cross-reference generated from `tools/docs/readings.json` for the week's four Computer, Enhance! and Handmade Chat items.
- The inventory now also checks the 10 W and F IDs against their answers and the coverage checklist.

Estimated additional time: about 2–4 hours for the beginner section and its warm-ups, plus optional reading. This is unpiloted.

## Why this week exists

The course must begin with a small C vocabulary that students can use without thinking about syntax while investigating lower layers. Week 1 also establishes a habit that continues all year: state what the **C program guarantees**, predict one implementation's behavior, run it, and explain any difference. The “Waste” video motivates attention to work performed, but week 1 makes no speed claims from a single timing run.

By the end, a learner should be able to write and build a multi-file C11 program; use arrays, pointers, structs, allocated storage, files, and explicit error returns; avoid basic undefined behavior; inspect object representation without assuming an endian order or fixed `int` size; and produce a minimal repeatable timing observation. These are preparation for week 2's deeper study of object layout and storage duration.

## Required readings and viewing

The two Computer, Enhance! entries require a subscription. Link to them; do not copy their paid contents into course materials.

| Resource | Assigned portion | Purpose |
| --- | --- | --- |
| [Computer, Enhance! — Welcome to the Performance-Aware Programming Series!](https://www.computerenhance.com/p/welcome-to-the-performance-aware) | Full episode, 22:05 | Understand the course's performance-awareness motivation. |
| [Computer, Enhance! — Waste](https://www.computerenhance.com/p/waste) | Full episode, 32:56 | Recognize unnecessary work as something to identify and measure. |
| [Handmade Chat 011 — Undefined Behavior](https://guide.handmadehero.org/chat/chat011/) | Indexed segments **4:18–22:16** | Contrast intuitive machine stories with the rules of the language. Treat it as discussion, not the normative C specification. |
| [Handmade Chat 013 — Translation Units, Function Pointers, Compilation, Linking, and Execution](https://guide.handmadehero.org/chat/chat013/) | Indexed segments **15:39–32:42**, plus **38:58–48:55** if time permits | See compilation, translation units, linking, and object-file inspection. Examples in the talk use Windows/C++; the assignment uses C11 on Linux. An old C implicit-declaration example in the talk is **not valid practice for this course**. |
| [WG14 public C11 draft](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) | Consult relevant clauses on translation units, `sizeof`, object representations, and undefined behavior as questions arise | Resolve claims about C itself, distinct from a particular compiler result. |

Viewing is about **90–110 minutes** with the required Handmade Chat segments. The rest of the week is for implementation and explanation.

## Deliverable and working environment

The single graded assignment is a **C field notebook** containing all 15 micro-exercises below, their tests, and a short report. The implementation provides a learner package with exercise prompts and empty C starter files; complete reference C code **and a full written answer key** live in a separate instructor package. The answer key must answer every learner-facing “explain,” “predict,” “draw,” “compare,” and “interpret” request as well as every coding task. This file remains the specification for that work.

- Reference environment: x86-64 Linux, GCC and Clang, C11, `make`, standard C library. Use POSIX `clock_gettime(CLOCK_MONOTONIC)` only for exercise 15. Document any feature-test macro required to expose it.
- Required development build: `-std=c11 -Wall -Wextra -Wpedantic -Werror -O0`. Exercise 15 additionally compares an `-O2` build. The build must compile each exercise independently and the multi-file exercise as separate translation units.
- Each exercise has a small deterministic test. Tests may verify portable relationships and expected outputs; they must not hard-code `sizeof(int)`, pointer width, byte order, struct padding, or a timing threshold.
- Learner submission: source files, the build file, test output, and `observations.md`. The report records compiler versions and flags, answers the explanation prompts, and identifies **two observations that depend on this implementation** rather than on C11.
- Keep executable examples defined: no intentional dangling dereference, out-of-bounds access, signed overflow, invalid shift, or unsequenced modification. For undefined-behavior recognition, use written questions or diagnostic fixtures that are never required to run.

## The 15 micro-exercises

Each item below needs a learner prompt, a compilable starter, at least one success test and one boundary/error test where applicable, a complete C reference solution, and a **substantive worked explanation** of the mechanism and every associated question. Name the source files `ex01.c` through `ex15.c`, except exercise 14, which uses `ex14_main.c`, `ex14_count.c`, and `ex14_count.h`.

| # | Task to implement | Required observable result and explanation |
| --- | --- | --- |
| **01 — Integer values** | Print representative signed and unsigned values with format specifiers matched to their types. Explain range versus representation; do not demonstrate signed overflow. |
| **02 — `sizeof`** | Print `sizeof` for selected integer types, a pointer, and an array. Show that array length is computed with `sizeof array / sizeof array[0]` only where the array is still an array. No fixed-size expectations. |
| **03 — Loops** | Sum the integers `1..N` for a checked small `N` using a loop. Test `N=0`, `N=1`, and a normal value. State the loop invariant in one sentence. |
| **04 — Functions** | Write a function that clamps an integer to a supplied inclusive interval; reject a reversed interval through an explicit status result. Test boundaries and an interior value. |
| **05 — Arrays** | Find minimum, maximum, and count in an `int` array. Define and test the empty-array result rather than reading element zero. |
| **06 — Pointers** | Compute the same array sum once with indexing and once with a pointer advanced within array bounds. Test equality and explain what `p + 1` means. |
| **07 — Structs** | Define `GeoPoint` with `uint64_t id`, `double lat_deg`, and `double lon_deg`. Validate finite coordinates with latitude in `[-90,90]` and longitude in `[-180,180]`, then print a valid record. This is a precursor to `geolab`, not yet a geospatial algorithm. |
| **08 — Padding** | Print `sizeof` and `offsetof` for two structs with different field order. Draw one observed layout, identify padding, and distinguish observation from a universal layout rule. |
| **09 — Bytes** | Display the bytes of a `uint32_t` object through `unsigned char` access or `memcpy`. Report the observed byte order without assuming it; do not use pointer casts that violate aliasing rules. |
| **10 — Bit operations** | Set, test, toggle, and clear named flags in an unsigned integer using masks. Test every operation and explain why the unsigned type is used. |
| **11 — Allocation** | Allocate `N` integers after checking `N <= SIZE_MAX / sizeof(int)` and a course cap of one million elements; initialize and sum them, then free them exactly once. Treat `N=0` as an empty successful result without calling `malloc(0)`. Test zero, a normal `N`, and a rejected excessive request without requiring an allocation failure to occur. |
| **12 — File input** | Read a supplied small text file with C stdio and count bytes and newline characters. Distinguish a missing file from an empty file; check read and close errors. |
| **13 — Error returns** | Parse a nonnegative decimal argument with `strtoull`, reject empty text, trailing junk, range errors, and values above a documented limit. Return distinct success/failure status to the caller. |
| **14 — Separate compilation** | Declare `size_t count_equal(const int *values, size_t length, int target)` in `ex14_count.h`, define it in `ex14_count.c`, and call it from `ex14_main.c`. Compile two `.o` files and link them. Inspect symbols with `nm` or `readelf`, then explain declaration, definition, translation unit, and linker resolution. |
| **15 — First benchmark** | Time repeated summation of a fixed initialized array with `clock_gettime(CLOCK_MONOTONIC)` in both `-O0` and `-O2` builds. Validate the sum, record input size and iteration count, run at least five repetitions, and report median elapsed time plus variation. Explain why one result does not establish a general performance rule. |

## Practice problems and stretch work

The weekly package must include these **six ungraded practice problems**, with answer keys separate from the learner prompt:

1. Classify five statements as portable C guarantees, implementation-defined observations, or invalid/undefined operations; justify each classification.
2. Predict outputs and relevant `sizeof` values for an array in its defining scope versus a pointer parameter, then run a correct example.
3. Locate the off-by-one error in a supplied loop without executing an out-of-bounds access.
4. Explain which of two field orders may waste fewer bytes on the reference machine and why no specific byte count belongs in a portable test.
5. Sketch the compiler, object-file, linker, executable, and running-process stages for exercise 14.
6. Identify two ways exercise 15 could accidentally measure setup work or allow optimization to remove its intended calculation.

Include two optional stretch exercises: **(a)** inspect the assembly for exercise 06 at `-O0` and `-O2` and relate any difference to source semantics without asserting a fixed instruction sequence; **(b)** extend exercise 12 to count lines correctly when the last line has no terminating newline.

## Required answer key coverage

Assign stable IDs to every subquestion in the learner materials and use the same IDs in the instructor answer key. The answer key must contain annotated working C for each exercise **and** the following written explanations. A one-line result, test output, or “see source code” does not count as an answer. Explanations should walk through the reasoning with a concrete example, relevant edge case, and portability limit where applicable.

| Exercise | Written solution must cover |
| --- | --- |
| **01** | Integer **range versus representation**: mathematical values a type can hold, how this implementation represents them, what the C rules guarantee, and why signed overflow cannot be inferred from observed wraparound. |
| **02** | Why `sizeof` an array in its defining scope yields the whole array's size while a function parameter declared with array syntax is adjusted to a pointer; show the length calculation and its boundary. |
| **03** | The loop invariant, initialization, preservation, termination, and the `N=0` result; explain the chosen arithmetic bound. |
| **04** | The clamp's inclusive boundaries, the reversed-interval error, and why a status result is preferable to silently inventing a value. |
| **05** | Why min/max are undefined for an empty collection unless the API supplies a separate status or convention; walk through the chosen result contract. |
| **06** | Array indexing versus pointer traversal, scaling of `p + 1` by element size, bounds, and why equivalent C results do not require identical instructions. |
| **07** | Struct field meanings, finite-coordinate checks, latitude/longitude limits, and examples of valid and invalid records. |
| **08** | The observed offsets and padding diagram, the alignment reason for padding, and which specific layout facts are implementation-dependent. |
| **09** | Legal unsigned-character observation of object bytes, the observed endian order, and why byte order is not a fixed property of every C implementation. |
| **10** | Each mask operation bit by bit, the unsigned-type choice, and the error caused by an invalid or out-of-range shift. |
| **11** | Multiplication-overflow and course-cap checks, zero-length policy, allocation failure, ownership and exactly-once `free`; include a faulty approach and repair. |
| **12** | Byte count versus newline count, empty versus missing file, `EOF` versus read error, and why closing errors are checked. |
| **13** | Each rejected input class, `strtoull` end-pointer and `errno` checks, and how status reaches the caller. |
| **14** | Declaration versus definition, separate translation units, object files, unresolved/resolved symbols, the build commands, and why putting function definitions in a shared header can fail. |
| **15** | Timer units, result validation, repeated trials, median and variation calculation, `-O0`/`-O2` comparison, measurement overhead, and why a different machine can produce a different ranking. |

Provide **fully worked answers to all six practice problems and both optional stretch exercises**, including annotated assembly *examples* for the stretch task while accepting different valid compiler output. Provide a completed exemplar `observations.md` that answers every report prompt: build environment, predictions, observed outputs, two implementation-dependent observations, benchmark calculations, explanation, and limits. Use clearly labeled sample observations rather than presenting one machine's sizes, byte order, assembly, or timings as universal answers. Include a prompt-to-answer checklist so no explanatory or integration question is left without a solution.

## Assessment and acceptance criteria

- **Functional correctness (40%):** All 15 exercises compile and pass deterministic tests under GCC and Clang; errors are handled as specified.
- **C reasoning (25%):** The learner can explain arrays versus pointers, object bytes, translation units, allocation lifetime, and at least two implementation-dependent observations.
- **Experimental method (20%):** Exercise 15 reports reproducible build settings, multiple runs, correct-result checks, median and variation, and cautious interpretation.
- **Clarity (15%):** Source, prompts, test failures, and the report can be understood without the videos open beside them.

Acceptance checks for the agent implementing this week: every exercise has learner instructions, a tested reference C solution, and a full written answer to every question; all six practice problems, both stretch exercises, and every `observations.md` prompt have corresponding worked answers; the prompt-to-answer checklist has no gaps; strict development builds pass with both compilers; no test depends on one machine's layout or on a speed threshold; file and numeric error paths are covered; the week-one report template explicitly separates **prediction**, **observation**, and **explanation**; and the package fits the 8–10-hour workload. Do not add later-week topics such as allocators, cache mechanics, SIMD, atomics, or a full Haversine processor to week 1.
