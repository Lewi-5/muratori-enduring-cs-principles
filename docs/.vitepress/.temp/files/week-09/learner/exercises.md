# Graded assignment

## E01 — Numeric effective addresses

### E01.C

Implement machine_address in src/address.c exactly as machine.h specifies. Cover all eight expressions, signed displacement, direct addresses, invalid fields and unchanged output on failure.

### E01.Q

With BX=FFF0, SI=0030 and displacement -7, calculate [BX+SI-7]. Explain why a byte operand still uses word address registers and why direct FFFF differs from displacement -1.

## E02 — Decode and test conditional transfers

### E02.C

Implement machine_decode and machine_condition in src/decode.c. Reuse the supplied base decoder, accept exactly Jcc/short/near JMP, and interpret signed patterns mathematically.

### E02.Q

Calculate EB F8 at IP 000F. After CMP byte patterns 80 and 01, predict JB and JL and explain OF. Are jumps allowed to modify flags?

## E03 — Atomic memory and branch execution

### E03.C

Implement machine_step in src/execute.c. Predecode boundaries, read operands/addresses from old state, encode little-endian words with FFFF wrapping, update six arithmetic flags and validate only taken destinations. Preserve complete state on failure.

### E03.Q

Explain MOV BX,[BX] when BX=0100 and bytes there are 00,02. Then draw a word 1234 at FFFF and state which flags MOV and CMP preserve/change.

## E04 — A bounded program transaction

### E04.C

Implement machine_run in src/run.c. Validate the whole code first, check initial IP, enforce a positive budget and commit the whole Machine only on success. Report failing IP and tentative steps; end on the last allowed step succeeds.

### E04.Q

Predict EB FE with budget three, then an empty run. Compare predecode rejection of EB 01 FF with a late target failure after a memory store.

## E05 — Trace a memory loop

### E05.C

Use the supplied driver/playground after E01–E04. Before running, write every transition of fixtures/program.hex. Add independent tests for a word at FFFF, a signed/unsigned branch contrast and a late memory-write rollback. Compare the golden file and complete R01–R05. No CLI implementation is required.

### E05.Q

Explain how the fixture terminates and what the trace establishes. Would this successful model run establish real 8086 segment behavior or host CPU performance?
