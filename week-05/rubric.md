# Rubric — Project 1 (`geolab` checkpoint 1), 100 points

**Pass gate.** The checkpoint passes only if `make checkpoint` succeeds with the learner's code, every command meets [its contract](CHECKPOINT-1.md), and the report keeps correctness, prediction, observation and uncertainty in separate sections. A project that fails the gate is returned for revision before it is scored.

| Area | Points | Full-credit evidence |
| --- | ---: | --- |
| Functional correctness | 40 | E01 6, E02 12, E03 4, E04 8, E05 3, E06 2, E07 5. Correct results, statuses, exit codes and diagnostics. Outputs unchanged on rejection. No leak on any error path. Strict builds on both compilers. |
| Measurement method | 25 | Five each: a protocol written before data collection, then followed; the environment and both build variants recorded; correctness established before timing, with checksums enforced; variation measured and reported with the range comparison and its limits; honest handling of short samples and outliers. |
| Reasoning and explanation | 20 | Five each: the query's ordering argument; the oracle and fixture reasoning; the prediction model; a claim ledger that labels C11, POSIX/Linux, compiler, hardware and observed statements correctly. |
| Clarity | 15 | Five each: readable source and diagnostics; explicit contracts and navigable IDs; a protocol and report understandable without the videos. |

Award roughly half of an item for mostly correct work with a missing explanation or a recoverable edge error. Award zero for missing work, for a claim that no derivation or recorded run supports, or for a solution that depends on undefined behavior, a forbidden flag, a leak, or an unchecked library result on an error path. Explain deductions concretely. Public tests are evidence, not proof: read the code as well as the test result.

**No points depend on speed**, on a prediction being accurate, or on matching the exemplar's numbers. A prediction that missed and was reconciled honestly earns full credit. A comparison that reports a difference between builds without stating whether the ranges overlap loses the variation point. A comparison that treats non-overlapping ranges as proof of a cause also loses it. Do not penalize a learner whose machine gives different timings, a different `libm` in the last digit, or different compiler diagnostics.

Practice is ungraded and stretch work optional; both have complete answers. The time estimate is unpiloted: learners should record overruns so the workload can be adjusted after a real pilot. Submission: the `geolab` tree, the build file, test output, `PROTOCOL.md`, the raw `results/`, and `report.md`.
