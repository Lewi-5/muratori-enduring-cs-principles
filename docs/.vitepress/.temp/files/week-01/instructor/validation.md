# Validation record

Validation date: 2026-09-19. Scope: the implemented week-one package, not the remaining 51 planned weeks.

Actual environment inspected locally:

- Ubuntu under WSL2, x86-64, Linux `6.18.33.2-microsoft-standard-WSL2`.
- CPU reported to the guest: Intel Core i7-12650H, 16 logical CPUs; Microsoft hypervisor.
- GCC `11.4.0-1ubuntu1~22.04.3` and Clang `14.0.0-1ubuntu1.1`.
- Strict flags: `-std=c11 -Wall -Wextra -Wpedantic -Werror`, with `-O0` or `-O2`.
- Sanitizer configuration: `-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer -fno-pie`, linking with `-no-pie`. Non-PIE executables keep this Linux/WSL sanitizer configuration reproducible; these flags are not C requirements.

The verification command is `make verify` from week-01. It checks the reference exercises at debug, optimized and sanitizer settings under both compilers, including C boundary tests and injected allocation/read/close failures, then checks that all learner starters compile under both compilers. Starter correctness tests are expected to fail until learners implement the exercises.

**Result: `make verify` completed with exit status 0.** All six reference configurations passed the fifteen executable contracts, nine C function/boundary suites, allocation/read/close fault tests, numeric error cases, benchmark checksum/statistic checks, and runnable practice/stretch solutions. No sanitizer errors were reported.

| Configuration | GCC 11.4 | Clang 14 |
| --- | --- | --- |
| Reference, strict -O0 | PASS | PASS |
| Reference, strict -O2 | PASS | PASS |
| Reference, ASan + UBSan | PASS | PASS |
| Empty learner starters, strict -O0 compilation | PASS | PASS |

The full local run transcript is retained in the ignored `week-01/build/verification.log`; repeat `make verify` to reproduce the checks in another checkout. All local week-one Markdown link destinations and source inventories were checked. Generated executables, object files and inspection logs stay under the ignored build directory.

The automated written-coverage inventory checks **43 prompts, 43 written answers and 43 checklist entries**: 15 coding prompts, 15 explanation prompts, six practice questions, two stretch exercises and five report prompts. The count is a structural check; the explanations were also reviewed against the week specification.

`make PACKAGE=instructor CC=gcc symbols assembly` was executed successfully. The caller object reports `U count_equal`, its implementation object reports `T count_equal`, and the executable contains the resolved definition. Both requested exercise-06 assembly files were generated. No exact assembly is a grading requirement.

Actual size/representation observations from that GCC debug build:

```text
char=1 short=2 int=4 long=8 pointer=8
array=20 element=4 length=5 parameter=8
members char=1 double=8 int=4
A size=24 tag=0 value=8 count=16
B size=16 value=0 count=8 tag=12
char_bits=8 bytes=4
04 03 02 01
order=little
```

These observations support this one machine's layout explanation only. Correctness checks instead use relationships, boundary contracts and checksum/statistic consistency. There is no universal speed threshold. The exemplar report's numerical timing table is explicitly synthetic; replace it with learner measurements when grading.

The four viewing links, C11 draft and clock_gettime reference resolved on the validation date. Public CE pages confirm the entry titles and subscription access; paid content was not reproduced. The plan's CE durations remain planning estimates because the public pages did not expose playback durations. Handmade Chat indexed segments were checked against the public guides.

## Beginner section, warm-ups and further reading (2026-09-28)

Environment as above (GCC 11.4.0, Clang 14.0.0, glibc 2.35, Python 3.10.12, WSL 2). Checks ran on a copy of the repository in the WSL home directory, excluding build products and the book PDFs.

- `make verify` passed: all six reference configurations ran `PASS: all four warm-ups` before the existing contract suites, and `make starters` compiled the learner scaffolds, including `w01.c`–`w04.c`, warning-clean under both compilers. The inventory reported 43 graded prompts plus 10 warm-up and reading questions, each with a written answer, and 53 checklist entries.
- Learner-negative check: `make PACKAGE=learner warmups` compiled every scaffold and reported all four warm-ups as "not yet passing" with the failing driver output, not a build or harness error.
- W04's test replaces `malloc` in the included source only. It checks the requested size (`strlen + 1`) and forces one allocation failure.
- Mutation check of the warm-up tests: 16 textual mutants of the reference warm-ups were each rebuilt with ASan/UBSan and run through `make warmups`. They were: an overflow-prone `a + b > limit` test, an off-by-one limit, removed guards, a forward instead of backward search, an unshifted index, a wrong byte shift and mask, a wrong bit-count step, and a missing `+ 1` in the allocation or the copy. All 16 were killed. Two first appeared to survive because the replaced text also occurred in a comment; retargeted to the code, both were killed.
- *Observed while writing W02's answer:* the loop `for (size_t i = n - 1; i >= 0; --i)` is rejected by GCC 11.4 under the course flags (`-Wtype-limits`, enabled by `-Wextra`) and accepted silently by Clang 14 with `-Wall -Wextra`.
- Every program shown on the beginner page (`wrap`, `display`, `array_size`, `layout`, `safe_divide`, `trace`, `clock_res`) printed the page's output byte for byte under GCC and Clang at `-O0` and `-O2` (`tools/docs/verify-examples.py`). A first draft of `array_size.c` applied `sizeof` to an array parameter; GCC rejected it with `-Werror=sizeof-array-argument`, and the page now reports that.
- `tools/docs/check_readings.py` confirmed every book citation against the PDFs, including the newly added CS:APP §1.9.1 and CS 341 §3.6.2, §3.7.1 and §3.8.6. It also confirmed that the week's four CE and Handmade Chat items each have a cross-reference row. The C11 clauses quoted in the warm-up and reading answers were read in the N1570 text.

Limits: the added time estimate (about 2–4 hours) is unpiloted. The sizes, offsets and clock resolution printed on the beginner page are observations of x86-64 Linux and are labelled as such there.
