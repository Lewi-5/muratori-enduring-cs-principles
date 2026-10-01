# Worked notebook — spoilers

Actual execution details are recorded in validation.md; these worked derivations explain the expected evidence.

### R01

Identify x86-64 Linux/WSL, C11 and the actual GCC/Clang/binutils versions from their outputs. Retain make command lines showing debug/optimized/sanitizer modes and conversion warnings. The supplied decoder revision is 7; this week adds a separate simulator API and does not silently change that layout. Validation.md supplies actual execution evidence for the reference. Record learner study time rather than treating the unpiloted ten-hour estimate as a measurement.

### R02

The fixture encodes MOV AX,4660 (3 bytes); MOV AH,-1 (2); MOV AL,127 (2); ADD AL,1 (2); CMP AL,-128 (2); MOV BX,1 (3); SUB AX,BX (2). Starts are 0,3,5,7,9,11,14. AX progresses 1234,FF34,FF7F,FF80,FF80,FF80,FF7F. BX becomes 0001 at offset 11. IP progresses 3,5,7,9,11,14,16; flags progress 0000,0000,0000,0890,0044,0044,0090. All other words remain zero. Golden text is in fixtures/program.txt; it is evidence to compare with your prediction, not a substitute for deriving it.

### R03

Byte FF+01 produces zero with CF=1 and OF=0: unsigned 255+1 exceeds 255, while signed -1+1=0 fits. Byte 7F+01 produces 80 with CF=0 and OF=1: unsigned 128 fits, while signed 127+1 exceeds 127. Word 0101 has low-byte odd parity despite two ones in the whole word, so PF=0. CMP 80 with 80 gives zero subtraction flags PF/ZF but preserves the register value 80. Use the oracle and contract harness to identify these cases and explain how a faulty single-overflow-flag design or whole-word parity counter would fail.

### R04

B8 34 12 B9 56 completes one tentative MOV, then lacks the high immediate byte at offset 3. Result is SIM_DECODE_ERROR with DEC_TRUNCATED, one tentative step and caller state unchanged. B8 34 12 8B 07 also tentatively executes one MOV, then rejects a valid memory MOV at offset 3 as SIM_UNSUPPORTED_OPERAND with DEC_OK. Both CLI invocations produce empty stdout and a nonzero exit. A successful sim_step commits once; sim_run commits a whole program; the CLI validates the complete run before its printing pass. A stdout write failure may still leave partial text.

### R05

Writing AH masks AX’s low byte, shifts the new high byte and merges them. The guest mechanism is two named views sharing one word; the observed fixture transition 1234→FF34 confirms the selected bytes for that case. Mathematical oracle checks cover all byte operand pairs and selected word inputs, not all arbitrary programs. Independent traces check state sequencing; neither replaces validation of malformed objects and bounds. Week 9 must evaluate condition predicates to choose a next guest instruction and add a bounded guest memory/address model, instead of treating the sequential file cursor or a host C pointer as those mechanisms.
