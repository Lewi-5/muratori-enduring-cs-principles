# Rubric — one notebook, 100 points

| Area | Points | Full-credit evidence |
| --- | ---: | --- |
| Functional correctness | 40 | E01 4, E02 3, E03 6, E04 12, E05 5, E06 7, E07 3. Exact statuses, offsets and texts on every supplied case and every two-byte prefix. Outputs unchanged on rejection. No leak or unchecked library result on any error path. Strict builds under both compilers at `-O0` and `-O2`. |
| Encoding and C reasoning | 25 | Five each: bit fields and register selection; immediates, byte order and signed conversion; forms, operation codes and the status order; decoding versus assembling; oracle independence and its limits. |
| Prediction and evidence | 20 | Five each: hand decodings recorded **before** running; a claim ledger that labels C11, implementation-defined, 8086 ISA (manual), x86-64 ISA (SDM), toolchain, oracle and observed statements correctly; the decoder–oracle–`objdump` comparison; correct citation of the manual's tables and the C11 clauses. |
| Clarity | 15 | Five each: readable source and diagnostics; explicit contracts and navigable IDs; a coherent notebook understandable without the videos. |

Award roughly half of an item for mostly correct work with a missing explanation or a recoverable edge error. Award zero for missing work, for a claim no derivation or run supports, or for a solution that relies on a narrowing conversion to a signed type, a host-byte-order `memcpy`, or a read past the end of the input. Explain deductions concretely. The exhaustive tests are strong evidence for the decoding functions, but read the code for the error paths, and read the hand decodings for the reasoning.

Accept other correct designs, such as a table-driven decoder (S02), a different helper structure, or other purposeful E07 cases. Do not penalize a learner whose `objdump` version prints a different but equivalent form, or whose disassembly of `geo.o` for P06 differs from the exemplar.

There is no timing and no performance threshold this week. Practice is ungraded and stretch work optional; both have complete answers. No points depend on fitting an unvalidated time estimate: record overruns so the workload can be adjusted after a real pilot. Submission: source, build recipe, test output, `cases.txt` and the notebook.
