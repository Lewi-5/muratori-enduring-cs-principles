# Rubric — one notebook, 100 points

| Area | Points | Full-credit evidence |
| --- | ---: | --- |
| Functional correctness | 40 | Four per exercise: correct normal result, boundary/error handling, defined C operations and strict builds. E03/E04/E07 reject atomically without partial outputs. |
| Layout/storage reasoning | 25 | Five each: alignment/padding; arrays/pointers; duration/lifetime; linkage/translation; two qualified implementation observations. Worked examples matter more than terminology alone. |
| Prediction/observation method | 20 | Five each: recorded environment/flags; prior diagrams; honest reconciliation of predictions; correct C/ABI/compiler/toolchain/observation labels. |
| Clarity | 15 | Five each: readable source/diagnostics; explicit contracts and navigable IDs; coherent notebook understandable without videos. |

Award roughly half of an item for mostly correct work with a missing explanation or recoverable edge error; zero for missing work or explanations dependent on undefined behavior. Explain deductions concretely. Public tests are evidence, not proof of every precondition. Alternative correct implementations and observations receive credit. ABI-specific sample numbers are not portable grading constants, and a correct skipped target observation is not an error on another platform.

Practice is ungraded and stretch optional; both have complete answers. No points depend on speed or fitting an unvalidated time estimate. Learners should record overruns so the workload can be adjusted after a real pilot. Submission includes source, build recipe, test output and notebook.
