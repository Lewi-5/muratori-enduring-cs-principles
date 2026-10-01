# Week 8 complete worked answers — spoilers

Annotated reference C lives in src. Each derivation below explains the mechanism, edge cases and plausible mistakes; different correct implementations are accepted.

### E01.C

registers.c uses code & 3 to locate a byte alias’s word and code<4 to choose shift zero versus eight. Read shifts and masks a numeric value; write clears only that byte’s mask before merging the new value. Validation precedes every lookup or write. A whole-word write directly replaces one word. An invalid byte value above 255 fails rather than silently truncating caller input. Output preservation is checked with initialized snapshots. Using eight independent byte variables would let AH/AL diverge from AX; accessing host storage through a byte pointer would make the mapping depend on host byte order.

### E01.Q

AX=1234 has AH=12 and AL=34 hex. AH=FF yields AX=FF34, AH=FF, AL=34. AL=80 then yields AX=FF80, AH=FF, AL=80. The byte-code table selects the high halves of AX/CX/DX/BX at codes 4–7, whereas the word-code table selects SP/BP/SI/DI there. The width selects the table. There is no byte view of SP in this historical subset. This is guest ISA aliasing, not C type aliasing or an ABI layout rule.

### E02.C

alu.c validates first and widens both values into uint32_t. ADD’s maximum full word sum is 131070, which fits. SUB’s unsigned underflow is defined and masking retains the guest-width result. CF uses full sum>mask for ADD and a<b for SUB/CMP. OF compares operand/result sign relationships: same-sign addition with changed sign, or different-sign subtraction with changed destination sign. AF uses the bit-four carry relation a^b^result. ZF and SF inspect the masked result. PF counts only bits zero through seven; zero has even parity. A local AluResult is committed at the end. Negative guest patterns never require an overflowing C signed calculation. The Python oracle independently derives OF from signed mathematical ranges and AF from nibble arithmetic, reducing shared-formula risk.

### E02.Q

In CF/PF/AF/ZF/SF/OF order: byte 127+1 gives 128 and flags 0/0/1/0/1/1 (0890 hex); 255+1 gives 0 and 1/1/1/1/0/0 (0055); 0-1 gives 255 and 1/1/1/0/1/0 (0095); word 32767+1 gives 32768 and 0/1/1/0/1/1 (0894). The word result has low byte zero, so PF=1 even though its high byte has one set bit. Work with wider unsigned values and mask after calculation; signed host int16_t arithmetic would add promotion/narrowing concerns without teaching the guest rule. Full-result parity is an incorrect substitute for the ISA’s low-byte rule.

### E03.C

execute.c validates operation, length and both operand descriptions, including immediate range, address normalization and matching widths. Well-formed memory operands return UNSUPPORTED_OPERAND; malformed objects return INVALID_INSTRUCTION. It captures both values from original state before any write, converts an immediate through defined unsigned conversion and a width mask, then changes a local CpuState. MOV stores only the selected destination. Arithmetic replaces the six flag bits and preserves all others. CMP shares subtraction computation but skips the register write. IP is widened, advanced and masked to sixteen bits. Only the final state assignment commits. A formatter is not used as an execution engine, and a guest memory operand is never cast to a host pointer.

### E03.Q

MOV AL,AH reads original AH=12 and writes AL=12, so AX=1212. All six initially set flags remain set (modeled mask 08D5). CMP AL,18 compares 12 hex with immediate decimal 18, the same pattern: AX stays 1212 and the modeled flags become PF/ZF only, 0044. MOV AH,0 yields AX=0012 and flags remain 0044. IP advances on each success. Both register operands are read before the destination is changed, so overlap is well defined. Decoder acceptance of a memory description establishes what it means; it does not supply the memory state or executor support needed to run it.

### E04.C

run.c checks pointers and the input cap before reading. A local state represents tentative execution, and a size_t offset selects each next byte extent with n-offset. decode_one’s status is preserved in a structured decode failure; sim_step’s rejection is a different status. Successful local steps increment the tentative count and file cursor, while sim_step advances guest IP separately. Any failure returns before the caller-state assignment. An empty stream performs no reads and commits an identical state. This is a sequential finite-input model: no jump target or instruction-fetch mapping is implied. A common fault is mutating caller state during the loop and returning an error after earlier registers have already changed.

### E04.Q

B8 34 12 decodes and tentatively executes MOV AX,4660, consuming three bytes. In B8 34 12 8B 07 the next instruction is a valid memory MOV, so the run returns SIM_UNSUPPORTED_OPERAND, decode_status DEC_OK, offset 3, steps 1; caller state is unchanged. In B8 34 12 B9 56, the next MOV immediate lacks one byte, returning SIM_DECODE_ERROR with DEC_TRUNCATED, offset 3, steps 1; caller state is again unchanged. A starting IP near 65535 can wrap after a valid instruction while the file cursor simply increases. Using IP to index this file would revisit earlier bytes or skip valid input, conflating architectural state with the course’s sequential input framing.

### E05.C

The supplied sim8086.c keeps file handling outside the library and uses the same zero starting state for validation and trace replay. It prints only after sim_run succeeds. Each trace state is recorded after its instruction; the final state and step count come from the complete run. The golden fixture is hand-derived, while generated traces are produced by an independent encoding/state oracle. The playground isolates ADD overflow, CMP non-write and MOV flag preservation. The six reference modes and starter-negative gate make the package reproducible without compiling instructor simulation code into learner binaries. Different correct implementations may organize helpers differently while keeping all public contracts.

### E05.Q

Whole-program validation prevents an early trace from looking like a successful partial execution after a late failure. sim_run’s caller state and CLI stdout are preserved on decode/execution failure; the returned record and stderr explain where tentative execution stopped. Output-write failure has its own boundary and may leave partial text. The arithmetic oracle establishes result/flag agreement for tested operand pairs, not correct alias writes or instruction sequencing. A disassembler establishes decoded operands and lengths under a selected ISA, not CPU-state transitions. Week 9 must add condition-controlled instruction selection and a bounded guest memory/address model.

### P01

AX/CX/DX/BX each have a low and high byte; SP/BP/SI/DI have word views only in this subset. AH receives BL=34 hex, so AX becomes 34CD while BX remains 1234. BL then receives AL=CD, so BX becomes 12CD and AX stays 34CD. Each source is captured before the destination write. The destination byte’s companion and all unrelated words are preserved. A host union layout is not required to express these numeric views.

### P02

80-01 produces 7F: unsigned 128-1=127 has no borrow (CF=0); signed -128-1=-129 lies outside the byte range, so OF=1. AF=1 because low nibble zero borrows from bit four; SF=0, ZF=0, PF=0 because 7F has seven one bits. 00-01 produces FF: CF=1, AF=1, SF=1, ZF=0, PF=1 because FF has eight ones, OF=0 because signed 0-1=-1 fits. A sign change by itself is not an overflow rule.

### P03

The subtraction flags are CF=0, SF=0, OF=1 (plus AF=1, PF=ZF=0). Unsigned less uses CF, yielding false for 128<1. Signed less uses SF != OF, yielding true for -128<1. CMP sets both kinds of evidence; a later condition decides which interpretation to use. CMP leaves AL and BL unchanged. ZF alone answers equality and cannot decide either ordering.

### P04

PF counts only the low eight bits. 0001 and 0101 both have low byte 01 with one one bit, so PF=0. 0000 and 0100 both have low byte 00 with zero one bits, an even count, so PF=1. ZF differs for 0000 versus 0100 because it tests the entire selected-width result. Counting all sixteen bits changes PF for 0101 and is a plausible word-only bug.

### P05

After the first instruction guest IP wraps to 0000 and the file cursor is 2; after the second guest IP is 0002 and cursor is 4. The cursor measures progress through the supplied input, while IP models a guest architectural field. A third partial instruction fails at file offset 4; sim_run reports two tentative steps and leaves the original caller state, including FFFE IP, unchanged. Individual successful sim_step calls would already have committed each state: those are different transaction boundaries.

### P06

83 C0 FE is `add ax, -2`, length 3. The decoder interprets FE as signed -2 for a word operation; the executor converts that value to guest pattern FFFE using defined unsigned conversion and a width mask. 0001+FFFE produces FFFF. CF=0, PF=1, AF=0, ZF=0, SF=1, OF=0: signed 1+(-2)=-1 fits and no low-nibble carry occurs. The host need not perform an overflowing signed word addition. A subsequent MOV preserves those flags while changing its destination and IP.

### S01

The supplied C probe computes CMP flags for raw byte operands 128 and 1, then derives unsigned-less from CF and signed-less from SF != OF. It requires false and true respectively. For equal operands the subtraction is zero, CF=SF=OF=0 and ZF=1; both strict-less predicates are false. Add equality through ZF when making less-or-equal predicates. This teaches flags as evidence without prematurely adding Week 9’s branch/fetch mechanism. The two interpretations compare different mathematical values encoded by the same patterns.

### S02

Create a binary from the fixture hex, then run objdump -D -b binary -m i8086 -M intel on it. Instruction starts must be 0,3,5,7,9,11,14; the final encoded extent is 16. Compare the MOV/ADD/CMP/SUB operands and widths, allowing hexadecimal immediate patterns instead of signed decimal and tool-specific formatting. B4 FF and 3C 80 may print FF and 80 while our canonical text prints -1 and -128. The disassembler checks byte interpretation and lengths, not register writes, six flags, rollback or initial state. If a trusted decoder is unavailable, record that limit and rely on the supplied encoding/manual expectations; do not fabricate differential evidence.
