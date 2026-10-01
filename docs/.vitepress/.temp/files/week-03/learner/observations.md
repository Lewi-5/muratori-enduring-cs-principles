# My geospatial math library notebook

### R01

Record the date, CPU, OS/kernel (and WSL if applicable), GCC and Clang versions, the glibc version, the exact build and test commands, and the floating-point flags. Confirm in one sentence that none of `-ffast-math`, `-Ofast`, `-funsafe-math-optimizations` or `-march=native` appears in any command. Attach test output for both optimization levels and both compilers. Identify the source of each recorded fact.

### R02

Before running, write predictions for E01–E07; for E02, E03 and E05 the predictions must include **numbers**: the expected ulp distances, the sign and magnitude of `sin(GEO_PI)`, and which distance formula is worst on which case and by roughly how much. After running, preserve those predictions and add observations and explanations. Answer E01.Q–E07.Q under their IDs, referencing the corresponding source for E01.C–E07.C. Do not silently replace a failed prediction.

| Exercise (expand to seven rows) | Prediction before run | Observed output/test | Explanation and boundary |
| --- | --- | --- | --- |
| E01–E07 | | | |

### R03

Give at least two implementation-dependent observations (for example the last digits of `sin(GEO_PI)` or of some other libm result, or the exact NaN bit pattern), each contrasted with a portable relationship that your tests use instead. Create a claim ledger with at least six statements, each labelled C11, Annex F / IEC 60559, glibc/libm, compiler, or observed on this machine. Explain why those categories are not interchangeable.

### R04

Give an error table. For the E05 driver cases, and for either the E02 sums or the S02 sweep if you attempted it, record the measured absolute and relative error of each formulation against its analytic reference, the tolerance you chose, and the reasoning that justifies it. Label measured values as measured, with the compiler and libm version. State a cautious conclusion that does not claim one formula is "best".

### R05

List the submitted sources, header, build recipe, test logs and this notebook. Defend one durable source → mechanism → observation connection that would remain useful in another language. State one unresolved question for week 4 (for example, how the rounding of six-decimal text coordinates and the accumulation of many distances affect a sum). Record actual time spent versus the unpiloted ten-hour core estimate. Include your P01–P06 responses and any optional S01/S02 work.
