# Graded assignment — A routine can return

Implement the four modules under [machine.h](../include/machine.h), use the supplied driver and playground, and submit E01–E05 with R01–R05. Keep predictions before running. The support code is completed prerequisite material. Do not compile instructor modules into your learner submission.

### E01.C

Implement machine_push and machine_pop in stack.c. Validate a nonempty window and SP inside it, reserve/read exactly two bytes, encode words numerically, preserve flags/IP and leave state/output unchanged on error. Odd SP is valid. Test every word pattern, both ends of the window, NULL arguments, complete exhaustion and retained bytes after POP.

### E01.Q

Starting with SP=0100, push 1234 then ABCD, then pop twice. Draw addresses and bytes after each operation. Explain why a POP does not erase memory and why casting memory+SP to uint16_t* is a faulty implementation.

### E02.C

Implement machine_decode in decode.c. Reuse decode_one for the existing subset; add exactly the forms in the public header. Capture lengths before reading operands; decode negative displacement patterns into int32_t; preserve out on failure. Reject truncated CALL/JMP/Jcc, 80186 immediate PUSH, far returns and unsupported prefixes. Enumerate all 65536 rel16 patterns in a test.

### E02.Q

At IP=0003, decode E8 02 00; at IP=000C, decode E8 03 00. Calculate the return word and target for each. Explain why the displacement base is after the instruction and why an E8 FF FF target may fall inside its own encoding.

### E03.C

Implement machine_step in execute.c: predecode code boundaries, fetch by guest IP, execute one instruction into a temporary Machine and commit only on success. Support baseline memory/register operations, Jcc/JMP and the new forms. Handle original 8086 PUSH SP, POP SP final-write behavior, RET validation, preserved flags, and INC/DEC's preserved CF. Failed transfers must preserve memory as well as CPU state.

### E03.Q

Trace nested CALLs with a saved AX. Explain which word RET sees if the callee forgets to pop AX. Contrast ISA rules with register-preservation conventions. Explain PUSH SP versus POP SP ordering and INC versus ADD's carry behavior.

### E04.C

Implement machine_run in run.c. Validate the whole code, even unreachable bytes, before executing. Enforce positive budget, initial boundary, maximum length and end-boundary halt. Return status, failing IP and tentative successful step count while rolling back all caller state on failure. Check termination before enforcing the next step's budget.

### E04.Q

Explain what changes after a failed RET during machine_step versus a failed run that previously stored data. Predict EB FE with budget three and a malformed unreachable suffix. State why the immutable-code and boundary policies are course restrictions rather than full 8086 hardware behavior.

### E05.C

Use the supplied CLI and playground with your modules. Produce the fixture's complete hand-derived trace, compare it to fixtures/program.txt, and run your learner correctness checks under both compilers and all three modes. Add one valid backward CALL program and one invalid return target. Complete R01–R05; submit source, trace evidence, written answers and test outcomes.

### E05.Q

Explain what the CLI preflight establishes, why errors produce empty stdout, and why trace success cannot establish performance or all ISA behavior. Repair `int *bad(void) { int local=7; return &local; }` with a caller-owned output contract; describe automatic, static and allocated storage duration and their independence from guest SP.
