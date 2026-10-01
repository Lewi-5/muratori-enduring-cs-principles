# Week 14 validation — 2026-10-01

Executed in x86-64 WSL Linux with GCC 11.4.0, Clang 14.0.0 and Python 3.10.12.

- `make verify` passed GCC and Clang debug (-O0), optimized (-O2) and ASan/UBSan (-O1): six complete reference configurations.
- Each ran deterministic contracts, 10,000 calculated cases, warm-up boundary/bounded exhaustive gates, 29 prompt/answer inventory, exact playground and real measurement structure/checksum checks. `/dev/full` output failure is reported.
- Four actual source assembly/object-disassembly manifests were generated. Inspection results are observations, not instruction-count performance claims.
- Both learner packages compile warning clean and intentionally fail contract, warm-up and playground correctness checks.
- The standalone beginner snippet matched exact source and output with GCC/Clang at O0/O2.
- Four debug/optimized timing captures preserve raw CSV and source/build/host manifests in instructor/evidence. Four additional outer-only captures compare one hit with 33 nested hits on unchanged work. Negative differences are retained; zero-baseline ratios report NA.

Corrections during validation: The pinned timing header excludes Week 13 warm-up declarations to avoid conflicting independent Week 14 warm-up names.

Course citation, snippet and documentation checks are recorded in docs/VALIDATION.md. No learner pilot, universal duration/frequency/slowdown, cross-core synchronization, shared-instance thread safety or interactive browser review is claimed. Compiler/runtime checks cover executed domains and do not prove all-input correctness.
