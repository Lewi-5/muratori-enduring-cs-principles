# My C field notebook

### R01

Record date, CPU/architecture, OS/kernel, GCC and Clang versions, build commands and flags, and test results. Note if WSL is used and what else was running during timing.

### R02

For each E01–E15, record a **prediction before running**, an **observed output or test result**, and an **explanation** connecting source → mechanism → observation. Answer each E01.Q–E15.Q explicitly, retaining those IDs. Include the E08 layout diagram and E14 symbol observations. Explain any failed prediction. Reference source filenames for E01.C–E15.C.

| Exercise | Prediction | Observation | Explanation / boundary |
| --- | --- | --- | --- |
| E01–E15 (expand to fifteen rows) | | | |

### R03

Identify two concrete observations that depend on this implementation. For each, contrast with a portable relationship that your tests use. Distinguish formally implementation-defined choices from merely unspecified or observed details when relevant.

### R04

Record E15 size, initialization, iterations, warm-up, checksum, all five raw times per build, median, min, max and range. Show one median calculation and elapsed-time unit conversion. Compare `-O0`/`-O2` with a cautiously worded conclusion, describe overhead and volatile-read limits, and state how another valid result would change your conclusion.

### R05

Submit source, the build recipe, test output and this report. Give a short defense of one source → mechanism → observation connection that would remain useful in another language, and name one unresolved question for later weeks. Include your six practice responses, and any optional stretch responses, under their stable IDs.
