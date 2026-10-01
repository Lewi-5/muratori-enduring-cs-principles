# Week 8 exercise contracts

One graded assignment combines E01–E05 and R01–R05. The public header and package guide are normative.

### E01.C

**One bank, several register views.** Implement sim_read_register and sim_write_register in registers.c. Use the exact public contract: word and byte code tables, NULL/width/index checks, byte-value range, unchanged outputs on failure, and preservation of the other half on success. Use masks and shifts rather than host-memory byte casts.

### E01.Q

Starting with AX=1234 hex, write AH=FF, then AL=80. Derive the word and both byte values after each step. Explain why byte code four is AH rather than an eight-bit SP.

### E02.C

**Guest arithmetic and flags.** Implement sim_alu in alu.c for ADD, SUB and CMP. Validate operation, width, operands and out first. Return the masked result and exactly six flags with no other bits. Include subtraction borrow, low-byte parity, nibble carry/borrow and signed overflow at both widths. Preserve the result object on rejection.

### E02.Q

Give result, CF/PF/AF/ZF/SF/OF for byte 127+1, 255+1, 0-1, and word 32767+1. Explain why C signed overflow is unnecessary and why PF ignores the high result byte.

### E03.C

**A state transition.** Implement sim_step in execute.c. Validate the whole instruction before executing; valid memory operands are unsupported. Read operands from pre-state, convert signed immediate patterns to guest bits, build a temporary state, apply MOV or arithmetic/CMP, preserve opaque flag bits and advance IP. Commit only on success.

### E03.Q

For AX=1234 hex and all six arithmetic flags initially set, execute mov al,ah, cmp al,18 and mov ah,0. Derive AX and modeled flags after each. Explain read-before-write, MOV flag preservation, CMP non-write and the distinction between decoder support and executor support.

### E04.C

**A program as one transaction.** Implement sim_run in run.c under the public contract. Decode at a size_t file cursor, execute a local state, report the failing first-byte offset and tentative step count, and commit only on total success. Keep guest IP separate, accept an empty input unchanged, enforce the input cap before reading, and preserve caller state on every failure.

### E04.Q

Derive the result of B8 34 12 8B 07 and B8 34 12 B9 56: status, decode status, offset, tentative steps and caller-state effect. Explain why guest IP wrap cannot be used to decide which input byte comes next.

### E05.C

**Trace, test and explain.** Use the supplied CLI and playground with your modules. Predict each state in fixtures/program.hex before running, compare all trace fields with the golden fixture, and record the six reference/learner checks appropriate to your submission. Complete R01–R05. Your single graded submission is the simulator, trace evidence and notebook, with the five E reasoning answers.

### E05.Q

Explain why the CLI validates before tracing, what a late failure changes, and why a passing arithmetic oracle or disassembler alone cannot prove a whole simulated program correct. State the extra mechanism Week 9 must introduce.
