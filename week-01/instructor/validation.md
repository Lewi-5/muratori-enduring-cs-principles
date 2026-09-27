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
