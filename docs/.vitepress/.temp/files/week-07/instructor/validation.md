# Week 7 validation

Checked on 2026-09-30 on x86-64 Linux under WSL2, kernel 6.18.40.1-microsoft-standard-WSL2. GCC 11.4.0, Clang 14.0.0, GNU Make 4.3, Python 3.10.12 and binutils 2.38. Documentation used Node 24.19.0 and VitePress 1.6.4 on Windows.

## Executed checks

- `make verify` passed: GCC and Clang, each in debug (`-O0`), optimized (`-O2`) and address/undefined sanitizer modes. Every reference build uses C11, Wall/Wextra/Wpedantic/Werror, Wconversion and Wsign-conversion. Shared objects use PIC; sanitizer executables use `-no-pie` on this Linux toolchain. The final log is locally retained in the ignored `build/verify.log`.
- Every reference configuration passed 13,892 independently encoded instruction cases, golden streams, five hand-derived cases, CLI failures, actual shared client execution from a different working directory, dependency/search-path checks and exactly four dynamic exports.
- The C contract harness passed instruction truncation, input arguments, operation precedence, malformed operands, exact-fit/too-small formatting, unchanged outputs and late stream failure. The three warm-ups passed their finite-table, signed-byte and bounded-offset checks.
- GCC and Clang learner scaffolds compiled without warnings. The starter gate confirmed that unfinished contract and warm-up work fails correctness checks; reference code is not linked into learner binaries.
- Both optional C solutions compiled and ran under GCC and Clang. Round-trip probes produced lengths 3, 4 and 2 with the same canonical text. Explicit loading returned revision 7, and a nonexistent-library path produced a diagnostic and nonzero exit.
- `objdump -D -b binary -m i8086 -M intel build/memory.bin` agreed with the four-case fixture at byte offsets 0, 3, 7 and 12. Its hexadecimal immediates, explicit PTR qualifiers and DS notation differ from our canonical text. This was a semantic and instruction-boundary comparison, not a literal text comparison.
- `python3 tools/docs/verify-examples.py` passed, including the checked-in Week 7 beginner snippet with GCC and Clang at both `-O0` and `-O2`. The page's source and displayed output matched the actual file and executions.
- `python3 tools/docs/check_readings.py` passed: 323 section entries, 211 checked against the four local book PDFs, 173 Muratori items and 220 cross-reference rows across 52 weeks. Week 7 covers all three assigned CE/HH items and adds Beej's snprintf reference.
- `npm run docs:check` passed: seven lessons, 232 prompt/answer pairs and 700 generated Markdown pages. The production documentation build passed rendered links, fragments and assets, with solution routes excluded from the search index.

Direct CE episode links/durations and HH assigned indexed segments were checked against the official guides. The Intel encoding tables and existing companion section/page records were reused from the verified course references. The course's original encoder oracle supplies automated expectations; the CE reference decoder is not installed or vendored.

## Corrections and limits

Initial validation found indented answer headings and an unused register-name helper copied into the learner decoder. Both were corrected, then coverage and starter checks passed. A wildcard in a stretch program's block comment triggered the strict comment warning; the example now uses line comments and both compiler checks passed. The registry's existing Dive Into Systems section URL was used in place of an initially mistyped companion URL.

The tests do not enumerate every 16-bit field combination, arbitrary instruction stream or unsupported ISA instruction. They do not establish memory execution, segment state, timing, or compatibility with another ABI/header layout. The subset excludes segment overrides and prefixes explicitly. No browser interaction or learner pilot was performed; the workload estimates remain unpiloted. The static production build emits VitePress's existing large-chunk notice; it does not fail validation.
