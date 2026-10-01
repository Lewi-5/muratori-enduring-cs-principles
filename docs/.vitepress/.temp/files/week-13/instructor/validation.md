# Week 13 validation — 2026-10-01

Executed in x86-64 WSL Linux with GCC 11.4.0, Clang 14.0.0 and Python 3.10.12.

- `make verify` passed GCC and Clang debug (-O0), optimized (-O2) and ASan/UBSan (-O1): six complete reference configurations.
- Each ran deterministic contracts, 10,000 calculated cases, warm-up boundary/bounded exhaustive gates, 29 prompt/answer inventory, exact playground and real measurement structure/checksum checks. `/dev/full` output failure is reported.
- Four actual source assembly/object-disassembly manifests were generated. Inspection results are observations, not instruction-count performance claims.
- Both learner packages compile warning clean and intentionally fail contract, warm-up and playground correctness checks.
- The standalone beginner snippet matched exact source and output with GCC/Clang at O0/O2.
- Four debug/optimized timing captures preserve raw CSV and source/build/host manifests in instructor/evidence. Both clocks include empty intervals when the counter is supported. Forced TIMING_NO_TSC GCC/Clang builds passed without executing RDTSCP.

Corrections during validation: Clang 14’s native CPUID inline assembly required native syntax for the counter source listing; object disassembly remains Intel syntax.

Course citation, snippet and documentation checks are recorded in docs/VALIDATION.md. No learner pilot, universal duration/frequency/slowdown, cross-core synchronization, shared-instance thread safety or interactive browser review is claimed. Compiler/runtime checks cover executed domains and do not prove all-input correctness.
