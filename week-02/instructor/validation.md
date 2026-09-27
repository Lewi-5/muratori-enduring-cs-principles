# Validation record — Week 02

Reference environment inspected 2026-09-20: Ubuntu/WSL2 x86-64, Linux 6.18.33.2-microsoft-standard-WSL2, GCC 11.4.0-1ubuntu1~22.04.3, Clang 14.0.0-1ubuntu1.1 and GNU binutils 2.38. Scope is this week's package; no claim is made about implementing later weeks.

**Result: `make verify` completed with exit status 0.** All six reference configurations passed; both compilers accepted the learner scaffolds. No sanitizer errors were reported. The [symbol excerpt](symbol-observations.md) and E03/E04 observed layouts were captured from the GCC debug build.

| Configuration | GCC 11.4 | Clang 14 |
| --- | --- | --- |
| Strict debug (-O0) reference tests | PASS | PASS |
| Strict optimized (-O2) reference tests | PASS | PASS |
| ASan + UBSan reference tests | PASS | PASS |
| Strict debug learner scaffold compilation | PASS | PASS |

The full local transcript is in ignored `build/verification.log`. The 33-prompt/answer/checklist inventory passed, as did local Markdown destination and source-whitespace checks. The standalone symbol/inspection commands ran successfully. The default unfinished learner package correctly fails `make test`; its expected failure is retained in `build/starter-negative.log`.

`make verify` builds and checks GCC and Clang at -O0, -O2, and -O1 with AddressSanitizer/UndefinedBehaviorSanitizer; compiles learner scaffolds; and checks all 33 prompt IDs against answer headings and checklist links. Runtime suites include ten C API contracts, checked arithmetic, unchanged outputs on failure, CLI syntax errors, injected allocation failures, index cycles, target-ABI comparisons and forced skip branches. The permutation output is checked against an independent arithmetic enumeration.

Portable tests do not fix observed type sizes, alignments, offsets, addresses or byte order. Explicit numerical specs such as (1,1),(8,8),(4,4) are synthetic input data, not ABI assumptions. The labelled ABI checks are gated to LP64 x86-64 Linux; E07's numeric-address/64-byte observations are target-specific. Forced skips test control flow only, not another actual architecture. The C11 exact-width/uintptr_t types are available on the required target.

Reading links were revisited on 2026-09-20. CE's public entry and TOC confirm the title and 25:05 duration without reproducing paid material. HH guides supply the assigned segment boundaries. ABI §3.1.2 and the Linux/binutils references resolve. The C11 PDF resolved during the preceding review on the same date; subsequent retrieval attempts returned tool errors, so its clauses were checked against the already retrieved draft. Viewing and scaffolding estimates remain unpiloted; tests establish software correctness evidence, not human workload duration.

Sanitizer checks use `-g -fsanitize=address,undefined -fno-omit-frame-pointer -fno-pie` and link with `-no-pie` for this Linux configuration. These flags are tooling choices, not C language rules. Generated binaries and full local logs are under ignored build/.
