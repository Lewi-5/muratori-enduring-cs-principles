# Rubric — one notebook, 100 points

The beginner section's warm-ups (W01–W04) and the further-reading questions (F01–F06) are ungraded. They have worked answers in the instructor package and are not part of the 100 points.

| Area | Points | Full-credit evidence |
| --- | ---: | --- |
| Functional correctness | 40 | E01 4, E02 4, E03 5, E04 6, E05 8, E06 7, E07 6. Correct normal results, boundary and error handling (rejected calls leave outputs unchanged), defined C operations, and strict builds under both compilers at `-O0` and `-O2` with `-ffp-contract=off`. |
| Numerical and geometric reasoning | 25 | Five each: representation and special values; comparison, rounding and error measures; conditioning and choice of formula; spherical conversion plus a worked orthonormal basis change, vectors and segment predicates; two qualified implementation-dependent observations. E06 includes explaining and tracing the supplied independent oracle and adding purposeful boundary tests. Worked examples and derivations matter more than terminology alone. |
| Prediction and measurement method | 20 | Five each: environment and flags (including that no fast-math flag was used); predictions recorded **before** running (with numbers for E02, E03 and E05); error measured against an analytic or exact reference with a justified tolerance; correct labelling of each claim as C11, IEC 60559, libm, compiler or observed. |
| Clarity | 15 | Five each: readable source and diagnostics; explicit contracts and navigable IDs; a coherent notebook understandable without the videos. |

Award roughly half of an item for mostly correct work with a missing explanation or a recoverable edge error; zero for missing work, for a claim that no derivation or recorded run supports, or for a solution that depends on undefined behavior or on a forbidden compiler flag. Explain deductions concretely. Public tests are evidence, not proof of every precondition: read the code as well as the test result. Alternative correct implementations, tolerances and observations receive credit provided the tolerance is justified. Do not penalize a learner because their machine's `libm` differs from the exemplar in the last digits, or because a reference-platform check is correctly skipped on another platform.

There is no timing and no performance threshold this week. Practice is ungraded and stretch optional; both have complete answers. No points depend on fitting an unvalidated time estimate; learners should record overruns so the workload can be adjusted after a real pilot. Submission includes source, build recipe, test output and notebook.
