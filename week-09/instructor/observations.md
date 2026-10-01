# Notebook exemplar answers

### R01

Exemplar: predict the hand golden in fixtures/program.txt, then preserve actual output from the supplied CLI. Setup reaches IP 0009 with CX = 3, BX = 0100 and data[0100] = 0. The loop's three passes reach data values 1, 2 and 3 and CX values 2, 1 and 0. ADD on the third pass sets PF; the final SUB sets PF | ZF = 0044; JNE leaves flags alone. AX becomes 3 at the final load. Matching the golden output is correctness evidence for the model, not an observation of modern instruction execution.

### R02

Exemplar: write 34 hex at FFFF and 12 at 0000 for word 1234, then read both indices in a checked test. Guest offset FFFF is valid because it is less than 65536; host memory[65536] is invalid. Mask the second-byte index before access. Record the test name and actual result. A successful explicit-byte test does not establish that a cast to a host word pointer would satisfy C's bounds, alignment or object-access rules.

### R03

Exemplar: the unsigned program halts with M_OK after three steps and AL = 80 hex. The signed program returns M_LIMIT after six tentative steps, at offset 4, with caller state unchanged. The runner's count describes attempted work, not a committed prefix. A finite budget provides a reproducible failure for this loop; it does not prove that all accepted programs terminate.

### R04

Exemplar: unsupported unreachable suffix EB 01 FF returns M_DECODE at offset 2 with zero steps. Storing seven followed by EB FA returns M_TARGET at offset 5 after one tentative step and rolls back memory. EB FE with budget three returns M_LIMIT at offset 0 after three steps. The supplied tests capture empty stdout for each CLI failure. If your program leaks text or data bytes, inspect its validation and commit order. Preserve a different actual result as evidence to investigate, then record the correction.

### R05

Exemplar report: list OS and CPU, GCC and Clang versions, exact make verify command, snippet check and independent test commands. Attach logs, then record time spent viewing, implementing, debugging and writing. Counts and machine details should describe actual evidence; no learner timing is supplied. A valid inference is that the tested states match the chosen ISA subset. Limits include omitted segmentation, stricter instruction boundaries than hardware, no microarchitecture model and unpiloted workload. Week 10 adds a stack window and saves the following IP as guest data on CALL. This week explains the offset calculation and word encoding that operation needs.
