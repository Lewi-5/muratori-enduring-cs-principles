# Instructor worked answers

### E01.C

Reference: src/address.c. The ISA table selects one or two word registers, then defined unsigned conversion and a mask implement offset arithmetic modulo 65536. A direct address bypasses the table. Validate before writing out, including malformed direct tags and displacements. At FFF0+0030-7 the mathematical sum is 65561, whose low word is 0019. Testing every displacement for every expression prevents a swapped SI/DI entry from surviving. A faulty byte-wide address calculation would lose upper register bits; a faulty direct cast to a host pointer leaves the guest model entirely.

### E01.Q

FFF0+0030-7=10019 hex; modulo 10000 gives 0019. Data width chooses one or two stored bytes, while BX and SI contribute full word addresses. Direct FFFF is numeric offset 65535; displacement -1 subtracts from a computed base and has a different role. A direct FFFF word spans FFFF and 0000 by this model's explicit rule; that does not license an out-of-bounds C array access.

### E02.C

Reference: src/decode.c. Read an opcode only when at least one byte is available, then check the full displacement extent before reading it. Decode a high-bit pattern as value minus 256 or 65536 using representable int32_t arithmetic. Delegate other bytes to revision 7; unsupported opcodes remain errors. Construct a local Decoded and commit only after success. The condition table uses independent booleans; invalid codes return -1. Testing every flag word checks opaque-bit independence. Returning SF for JL is wrong when OF is set.

### E02.Q

At IP 000F, EB occupies two bytes, so following IP=0011 and F8 denotes -8. Target is 0009. CMP 80-01 yields 7F: CF=0, ZF=0, SF=0, OF=1 (also AF=1, PF=0). Unsigned 128<1 is false, so JB is untaken. Signed -128<1 is true, so JL tests SF!=OF and is taken. SF alone would incorrectly say the signed result is positive. All jumps preserve flags, even when untaken.

### E03.C

Reference: src/execute.c. Build a complete boundary map in local storage, decode the instruction at old IP and copy Machine. Read both operand values and any memory destination address from the old Machine. Assemble a word from two valid array indices and write its low/high bytes explicitly. MOV preserves flags; ALU output replaces the modeled six bits, and CMP omits the write. Following IP is computed before branch displacement; only a taken branch checks its destination. Commit the copied Machine only after success. A write-before-read approach corrupts aliasing cases; a direct host word load fails endian/alignment/aliasing requirements.

### E03.Q

BX initially selects address 0100; bytes 00,02 represent word 0200. Capture the address and value before assigning BX=0200. Word 1234 at FFFF puts 34 at FFFF and 12 at 0000, with both host indices valid. MOV preserves every flag. CMP computes arithmetic flags and preserves opaque bits but leaves both operand storage locations unchanged. A raw host word cast can violate alignment and aliasing rules and depends on endian.

### E04.C

Reference: src/run.c. Predecode the whole stream and mark the end boundary, then validate initial IP. Execute a local complete Machine until end, checking the positive budget before each step and halt before the next budget rejection. Report the failing opcode for decode and the attempted current IP for execution errors. A copy of only CpuState would leak earlier memory stores on failure. A budget check ahead of the halt test rejects valid programs finishing exactly on their last allowed step. Tests compare every byte of initialized old/new state.

### E04.Q

EB FE jumps from following 0002 back to 0000. Three successful tentative jumps precede M_LIMIT at offset zero; committed Machine remains the original. Empty input with IP=0 and positive budget succeeds with zero steps. EB 01 FF has an unsupported opcode at offset two, so full predecode returns M_DECODE/steps=0 even though the jump would skip it. A valid store followed by a jump to an immediate passes predecode but returns M_TARGET after one successful tentative step; the stored byte still rolls back.

### E05.C

Reference: support/driver.c, support/playground.c, fixtures/program.txt and tests/check.py. The fixture establishes CX=3, BX=0100 and byte data=0, then repeats ADD memory by one, SUB CX by one and JNE backward. Three setup steps, nine loop steps and one final load total thirteen. Python computes independent arithmetic flags and all trace fields for initial counts 1..255. The hand golden is separate from that oracle and the simulator. contracts.c includes wrapping words and late rollback; extras/predicates.c provides the requested interpretation contrast. These are working exemplar independent checks; a learner can add equivalent cases.

### E05.Q

SUB CX,1 produces zero on the third iteration, sets ZF and makes JNE fall through. Memory[0100] is 3 and MOV AL,[BX] loads it into AX=0003 while preserving the final flags=0044. The trace proves the specified values under this subset and initial state. Separate immutable code and flat data omit real segments and self-modification; boundary checks and halt are teaching policies. Execution counts and host replay speed are not measured processor cycles.

### P01

0010+FFFF-0010=FFFF. Address sum wraps modulo 65536; DI is a full word. Real BP-based addressing normally uses SS by default, but this model has one data array and no segment registers. Do not infer a physical segmented address from this offset.

### P02

80 minus 01 hex gives 7F, with CF = 0, ZF = 0, SF = 0 and OF = 1. JB and JBE are false; JA and JAE are true. JL and JLE are true; JG and JGE are false. SF XOR OF corrects the overflowed sign. Reading only SF would reverse this signed comparison. The same byte patterns answer different comparison questions without any contradiction.

### P03

Boundaries are 0, 3 and 5. JMP at position 3 has following position 5; FC denotes -4, so its target is 1. Although position 1 lies inside the array, it is the low immediate byte of MOV AX,1234 and fails with M_TARGET. The preceding MOV is tentative and rolls back in a whole run. Hardware can decode from other positions; this model deliberately rejects them.

### P04

Initially data[FFFF] = CD and data[0000] = AB, in hex. After changing byte 0000 to 12, a word load at FFFF yields 12CD. The high byte remains at wrapped index 0. A host pointer cast at the last byte cannot provide a valid contiguous two-byte C object within the array, and it brings alignment, object-access and endian requirements. Explicit byte indices and shifts define the guest result.

### P05

Old BX = 0100 selects byte 20 hex before BL is overwritten. Final BX = 0120 because BL replaces only its low eight bits. Calculating the address after the destination update would fetch from 0120 instead, which changes the operation. tests/contracts.c also exercises MOV BX,[BX] to catch the corresponding word case.

### P06

Predecode succeeds if all bytes encode accepted forms; then the store is one tentative step. The invalid transfer returns M_TARGET, offset of its opcode, steps=1; caller memory remains its original contents and the CLI emits zero stdout. Initialize all memory nontrivially and compare complete snapshots to catch an executor that rolls back only registers.

### S01

extras/predicates.c supplies complete reference C. MOV AL,80; CMP AL,1; JB -4 halts after three steps because unsigned 128 < 1 is false. Replacing JB (opcode 72) with JL (7C) keeps branching from following position 6 to CMP at position 2. AL never changes, so a budget of six returns M_LIMIT after six tentative steps, at offset 4. The whole Machine rolls back to its initial zero state. This behavior follows from the comparison choice and unchanged operand; other signed loops can terminate normally.

### S02

Exemplar preparation algorithm: receive immutable code and its length, validate n <= 65535, decode sequentially and store one byte of boundary information for every offset plus the end. On failure, return the offending opcode offset without publishing a partial prepared object.

The caller owns code and map and must keep both unchanged for execution. Store the length and an association with the specific code object and its lifetime. Replacing or editing code requires new preparation; merely retaining the same pointer value is insufficient.

A step uses the prepared map for current-IP and taken-target checks, decodes only the reached instruction and performs the same local-state commit. A run still copies the entire Machine and enforces its budget. Preserve validation before execution and the existing error precedence; otherwise malformed unreachable suffixes would behave differently.

Equivalence tests compare complete state, statuses, offsets and tentative steps against the uncached executor across golden loops, taken and untaken targets, malformed suffixes, maximum code, empty runs and programs halting on the last allowed step. Benchmark preparation separately from repeated execution and record compiler and CPU. Different valid timings do not invalidate semantic equivalence. This is a complete written stretch design; no cache or speedup is required in the core.
