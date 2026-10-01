# Complete core, practice and stretch answers

### E01.C

Reference: src/stack.c. Validate low<high, SP within the inclusive pointer interval and at least two available bytes. The writable stack interval itself is half-open: high is an empty-stack pointer, never a byte written by PUSH. Compute SP−2 only after the availability check; store value&255 then value>>8, and finally commit SP. POP captures the word at the old SP before adding two, and writes the caller's separate output only on success. Invalid output pointers produce M_ARGUMENT; invalid window/depth produces M_STACK.

These checks also admit odd addresses, for which uint16_t pointer casts could violate alignment. Numeric byte encoding avoids host byte-order assumptions and type-punning issues. Exhaustive word patterns verify splitting/reassembly, but separate tests are still needed for exhaustion, ordering and unchanged state. A plausible bug subtracts first and tests wrapped SP afterward; another erases popped bytes and incorrectly makes memory part of the logical depth representation.

### E01.Q

All values below are hex. Starting SP=0100, PUSH 1234 makes SP=00FE and writes [00FE]=34, [00FF]=12. PUSH ABCD makes SP=00FC and writes [00FC]=CD, [00FD]=AB. Thus the live word at SP is ABCD, followed upward by 1234. The first POP returns ABCD and leaves SP=00FE; the second returns 1234 and leaves SP=0100. The bytes remain CD AB 34 12 in memory, but none are live stack words once SP reaches high.

```text
empty SP=0100
PUSH 1234: SP=00FE -> [34 12] at 00FE..00FF
PUSH ABCD: SP=00FC -> [CD AB] at 00FC..00FD -> [34 12] at 00FE..00FF
POP ABCD:  SP=00FE -> [34 12] at 00FE..00FF
POP 1234:  SP=0100 (empty; the bytes remain)
```

POP changes a register/pointer and retrieves data; its ISA operation does not clear the source. Old bits are not a lifetime guarantee. Casting a guest byte location to uint16_t* assumes host alignment and byte order and can violate C's access rules for a byte array. Shifts define the guest format regardless of those host properties.

### E02.C

Reference: src/decode.c. The opcode identifies a one-byte register PUSH/POP/INC/DEC or NOP/RET. Relative forms require two or three bytes before reading payloads. For an unsigned pattern p with width w, return p when p<2^(w−1), otherwise p−2^w; all results fit int32_t. A signed pattern is a mathematical interpretation, not a request for implementation-defined unsigned-to-signed narrowing. Construct a zero-initialized Decoded locally and assign out only after completion. Unrecognized extensions fall back to the pinned MOV/ADD/SUB/CMP decoder, whose accepted subset is unchanged.

Length must be known before reading a truncated suffix. A faulty approach reads bytes[2] then checks length. Another accepts 68 as immediate PUSH because it exists on later processors; this package deliberately targets a listed 8086 subset. The exhaustive rel16 test compares against a piecewise numeric range oracle, while separate register/truncation tests establish other fields.

### E02.Q

The first CALL starts at 0003, occupies three bytes, and pushes 0006. Its displacement is +2, so the callee starts at 0008. The second starts at 000C, pushes 000F, and uses +3 to reach 0012. Adding the displacement to the first opcode's IP would land three bytes too early: relative transfers are based on the following instruction's position.

E8 FF FF means −1. If the CALL begins at p, the target is p+3−1=p+2 modulo 65536, its high displacement byte. A full boundary map therefore rejects it with M_TARGET. Correct numeric range and correct instruction boundary are different checks.

### E03.C

Reference: src/execute.c. First build the boundary map from immutable code; require an executable initial IP. Decode the fetched instruction, copy the Machine, set tentative fall-through IP and switch on kind. Stack helpers operate only on that copy. For CALL validate the destination, then push fall-through IP, then select the target. RET pops from the copy and validates the candidate IP before committing the copy. Thus even a RET target failure preserves the original SP and all data bytes.

For baseline instructions capture both operands and destination effective address from pre-state. Use shared numeric register access and guest-width ALU; CMP skips the destination write. Word data accesses wrap at 65536, unlike stack helpers. Jcc tests the six modeled flags using independent predicates; INC/DEC use ADD/SUB by one, but replace only FLAG_ARITH except CF. This preserves opaque bits too. A plausible faulty approach commits POP then validates RET; another calls a host C function recursively and accidentally substitutes the host return stack for modeled data.

### E03.Q

The fixture's deepest live stack is SP=00FA: [00FA..00FB]=0F 00, inner return IP; [00FC..00FD]=34 12, saved outer AX; [00FE..00FF]=06 00, outer return IP. Inner RET obtains 000F and leaves SP=00FC. POP BX gets saved AX=1234 and leaves SP=00FE. Outer RET obtains 0006 and restores SP=0100. The routine leaves AX=5679 intentionally; saving a word and deciding which register to restore are software choices.

```text
SP=00FA -> inner return 000F -> saved AX 1234 -> outer return 0006 -> high=0100
RET     -> SP=00FC, IP=000F
POP BX  -> SP=00FE, BX=1234
RET     -> SP=0100, IP=0006
```

If outer RET executes without the intervening POP, it reads 1234 as an instruction pointer. That is outside this fixture, so M_TARGET results; on real hardware the corrupt transfer need not be detected this way. The ISA specifies CALL's saved position and PUSH/POP data motion; an ABI or hand-written convention specifies which registers a callee must preserve.

Original 8086 PUSH SP stores SP after decrement, so from 0100 it stores 00FE at 00FE. POP SP first reads and advances internally, then its register write makes the popped word the final SP; our window policy can reject that value atomically. INC preserves CF whereas ADD replaces it. Other five arithmetic flags still reflect the increment, so replacing the complete ADD flags word would be a bug.

### E04.C

Reference: src/run.c. Argument checks precede reads. A full decode pass builds boundaries and reports the first malformed byte offset with zero tentative steps. Initial IP must be a boundary. Execute a local Machine while IP differs from n; on each iteration record current IP, reject an exhausted budget, step and increment the successful-step count. When IP==n, assign the local Machine and return offset=n. A program reaching end on step limit succeeds because no further instruction is needed.

The transaction copies the byte array as well as CPU fields. Returning a failed result before assigning the local state prevents earlier successful stores from escaping. A wrong implementation copies only CPU or commits after every step. Boundary validation plus a finite instruction budget does not force stack balance or correct source-language behavior; those are separate explanations and tests.

### E04.Q

A failed machine_step changes nothing, including a tentative RET's popped SP. A failed machine_run restores its entire original input Machine, including stores from earlier successful tentative steps. Result.steps describes those attempted successful transitions, not committed history.

EB FE jumps from IP 0 through fall-through 2 back to 0. With budget three, result is M_LIMIT, offset=0, steps=3; caller state is unchanged. A malformed unreachable suffix is M_DECODE during predecode, offset at the suffix, steps=0. These policies simplify assignments and boundary tests: historical hardware can fetch only reached bytes, can execute self-modified memory and lacks this teaching window's stack error. Our immutable separate code prevents such behavior and is explicitly a model restriction.

### E05.C

Use fixtures/program.txt as the hand-derived ten-transition reference, not as a file generated by the reference executor during the test. The chronological IP sequence is 0000,0003,0008,0009,000C,0012,0013,000F,0010,0006,0014. Final AX=5679, BX=1234, SP=0100; all arithmetic flags are zero because INC 5678 produces low byte 79 with odd parity, no nibble carry, no sign/overflow and no zero.

A valid backward CALL program is `EB 03 40 C3 90 E8 FA FF 90`. IP 0 jumps to 5; CALL at 5 saves 8 and reaches 2; INC at 2 makes AX=1; RET at 3 reaches 8; NOP reaches halt at 9. It succeeds in five steps and restores SP. An invalid return example starts AX=2 and executes `50 B8 01 00 C3`: PUSH saves 2, MOV changes AX, RET selects byte 2 inside the immediate. The run fails M_TARGET at offset 4 after two successful steps and rolls back the full state.

Tests and notebook exemplars supply compiler evidence and failure interpretation. Different valid implementations need not print an identical host assembly listing; the guest trace is fixed by this contract. Any timing report must be labeled measured, never required to match an invented reference number.

### E05.Q

Preflight validates decoding, executable targets, stack operations and termination within the budget, with a complete state result. Replay of immutable input from identical initial state produces the same transitions. Printing only after preflight leaves stdout empty on model/input errors. An output stream error is different: bytes already written cannot be rolled back. A passing trace covers those instructions, not all opcodes, segmentation, performance or C pointer validity.

Correct replacement: `int good(int *out) { if (!out) return 0; *out=7; return 1; }`. The caller supplies a live int and retains ownership; the callee writes it before returning and returns only a status. An automatic local's lifetime ends when its block execution ends; a static local lasts through program execution; an allocated object's lifetime runs from allocation to deallocation. C permits a compiler to keep local in a register or eliminate it completely. Guest SP is an array-state value in this simulator and cannot determine any of those host C lifetimes. Returning static storage can also fix lifetime, but introduces shared state and different reentrancy/ownership semantics.

### P01

The window contains 0x80=128 bytes, so 64 word pushes fit. SP reaches 0080; the 65th returns M_STACK and preserves the entire Machine. Drain in reverse order; SP returns to 0100. The next POP is M_STACK, with Machine and separate output unchanged. This counts capacity, not hardware protection or a tagged stack depth.

### P02

Both results are 8000. Both set OF=1, SF=1, AF=1, PF=1 (low result byte zero) and ZF=0. INC retains input CF=1; ADD replaces CF with 0 because unsigned 32767+1 fits. A loop can update its counter with INC while preserving a carry from an earlier multiword calculation. Confusing CF and OF would incorrectly claim either operation has unsigned carry here.

### P03

Next IP is 0013. FFF0 represents −16, so target is 0003. These numbers alone do not establish membership in the code or an instruction boundary. The runner requires the code's actual boundary map. An in-range address can be an immediate byte.

### P04

POP BX then POP AX restores both, because the latest saved word is first read. POP AX then POP BX yields AX=ABCD and BX=1234, exchanging values. SP balances either way; stack balance alone cannot prove a correct register-preservation convention.

### P05

No. Architectural contents are stored bits; identifier scope is where a C name can be used; object lifetime is the interval in which its storage represents a usable object. A local's scope and lifetime have related block boundaries but are different rules. Once the automatic object ends, stale contents do not make dereferencing its returned address valid. Inspect guest bytes as bytes, not as evidence of a live host int. Use caller-owned storage or explicitly allocated storage with a deallocation contract.

### P06

MOV changes only data at that numeric address, because executable bytes are a disjoint immutable input. It cannot change CALL in code. A real 8086 uses segmented addresses into memory and can have data/code refer to the same bytes. This model deliberately excludes self-modifying programs and segmentation; numeric address equality across its two arrays does not imply aliasing.

### S01

Use `E8 FD FF`: CALL at zero saves 3 and transfers to zero. With the CLI window, SP(k)=0100−2k for k successful calls. At k=64, SP=0080; attempt 65 fails M_STACK at IP zero. With budget 100, result.steps=64, offset=0 and the caller remains the original empty Machine. Each tentative word stores 0003. C's runner loop handles all calls iteratively; no host C recursion is required. A budget of 64 would instead report M_LIMIT before attempting the failing push, demonstrating specified error precedence.

### S02

An acceptable design is a caller-owned `Program { const uint8_t *code; size_t length; uint8_t boundary[65536]; }` initialized by `MachineStatus program_prepare(Program *out, const uint8_t *code, size_t n)`. Validate arguments and build the map in a local Program, decoding from offset zero and setting boundary[n]=1; commit only on full success. The caller must keep code immutable and accessible for the Program's lifetime. `program_step(const Program *p, Machine *m)` can use p->boundary for initial IP and every taken target, while retaining machine_step's local-Machine transaction. `program_run` loops over this function with the same halt and budget order.

Concrete preparation pseudocode: reject n>65535 or missing objects; zero local.boundary; for pos=0 while pos<n set map[pos]=1, decode(code+pos,n−pos,&d), return on error, pos+=d.length; set map[n]=1, store code/length, assign out. After any allowed code edit, prepare a new Program; never reuse a stale map or merely assume equal length means equal boundaries. This design borrows bytes rather than owning them, so document lifetime and aliasing. Differential verification runs original and cached versions on the golden programs, all invalid targets and limits, comparing status, offset, steps and every Machine byte. The unchanged original is an oracle for contract equivalence, supplemented by the independent hand trace; no performance claim follows without measurements.
