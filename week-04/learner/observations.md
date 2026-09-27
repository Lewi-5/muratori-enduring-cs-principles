# My `geolab` data-pipeline notebook

### R01

Record the date, CPU, OS/kernel (and WSL if applicable), GCC and Clang versions, the glibc version, the Python version, the exact build and test commands, and the floating-point flags. Confirm in one sentence that none of `-ffast-math`, `-Ofast`, `-funsafe-math-optimizations` or `-march=native` appears in any command. Attach test output for both optimization levels and both compilers. Identify the source of each recorded fact.

### R02

Before running, write predictions for E01–E07. For E03 the prediction must be **the exact byte-size range of a generated 1,000-row file**, derived from the minimum and maximum line lengths; for E04 it must be **the parse status of five lines you chose by hand**. After running, preserve those predictions and add observations and explanations. Answer E01.Q–E07.Q under their IDs, referencing the corresponding source for E01.C–E07.C. Do not silently replace a failed prediction.

| Exercise (expand to seven rows) | Prediction before run | Observed output/test | Explanation and boundary |
| --- | --- | --- | --- |
| E01–E07 | | | |

### R03

Give at least two implementation-dependent observations (for example the last digits of a summed distance, or whether `char` is signed), each contrasted with a portable relationship that your tests use instead. Create a claim ledger with at least six statements, each labelled C11, Annex F / IEC 60559, POSIX/Linux, glibc, oracle, or observed on this machine. Explain why those categories are not interchangeable.

### R04

Give an error table. For the E07 cases, and for the E06 processor's differential comparison against the reference distance, record the measured error of each method against its exact or reference value, the tolerance you chose, and the reasoning that justifies it. Label measured values as measured, with the compiler and libm version. State a cautious conclusion that does not rank the methods beyond the evidence.

### R05

List the submitted sources, build recipe, test logs and this notebook. Defend one durable source → mechanism → observation connection that would remain useful in another language. State one unresolved question for week 5 (for example, what would have to be controlled to time the processor fairly). Record actual time spent versus the unpiloted ten-hour core estimate. Include your P01–P06 responses and any optional S01/S02 work.
