# Week 16 validation

Validated 2026-10-01 in x86-64 Linux/WSL, GCC 11.4.0, Clang 14.0.0 and Python 3.12.1. Workload estimates remain unpiloted.

make verify completed successfully in all six reference modes: GCC/Clang debug O0, optimized O2 and O1 with AddressSanitizer/UndefinedBehaviorSanitizer. Each mode passed caller-owned value boundary checks, the first hundred static-counter calls, NULL no-effect behavior, deep-copy independence, failed allocation and failed grow rollback, overflow/invalid metadata rejection, equal-size no-allocation, successful grow/zero-tail/shrink/zero release, repeated empty cleanup and growing counts through 128. The tracking allocator checks live allocations and exact once-only release, ending with allocations equal releases and no live slots.

Three warm-ups, deterministic lifetime playground, 29 matching prompts/answers and both warning-clean untouched starter failures passed. The standalone beginner source and exact displayed successful-allocation output passed GCC/Clang O0/O2. Tests do not access or compare old pointers after successful replacement/release.

make diagnose separately passed two compiler expected failures for returned automatic-local addresses and four isolated ASan expected failures: heap-use-after-free and double-free under both compilers. Actual warning/error-category excerpts are in diagnostic-examples.md; full variable-address/frame reports regenerate in build/diagnostics. These intentionally invalid fixtures are never linked into normal lab binaries. Diagnostics establish exercised violations, not arbitrary-pointer validity or proof of every lifetime path.

The reading checker passed 323 sections (211 checked against local PDFs), 173 Muratori entries and 220 cross-reference rows across 52 weeks. Initial integrated checks passed 14 lessons and 435 prompt/answer pairs; the final registered-source snapshot passed 16 lessons and 493 pairs after concurrent Weeks 13/14 registration. Primary URLs and assigned episode markers were checked against official sources. No concurrency, allocator-internals implementation or learner pilot is claimed.

The fixed snapshot in Week 15's build/site-validation passed npm run docs:build in 325.97 seconds: 1374 rendered pages and 123311 internal links/fragments/assets, with solution routes absent from search. The existing bundle-size warning remains. This isolates generated output from concurrent course builds while retaining actual registered sources and the normal generator/compiler/checker.

The main lesson and beginner page were inspected in the in-app browser. At a temporary 390-pixel viewport the beginner document had equal 375-pixel client and scroll widths after the scrollbar, with readable wrapping and no horizontal page overflow. The viewport was reset and preview closed. Only evidence-record prose changed after this production snapshot; no C implementation, lesson content or site adapter changes followed it.
