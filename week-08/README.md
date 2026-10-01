# Week 08 — Register state and arithmetic flags

[Full lesson](../docs/content/weeks/week-08.md) · [Beginner section](../docs/content/beginners/week-08.md) · [Further reading](../docs/content/further-reading/week-08.md)

Turn Week 7's decoded register operands into state transitions. Prerequisites are [Week 6](../week-06/README.md) for bit fields and signed patterns, [Week 7](../week-07/README.md) for the decoder API, and Week 1's unsigned arithmetic and checked output contracts. The [course plan](../PLAN.md) supplies the sequence; [the week specification](PLAN.md) supplies acceptance criteria.

You will model shared byte/word register storage, implement guest-width arithmetic without host signed overflow, distinguish carry from signed overflow, update six status flags, and explain why CMP changes flags without changing its operands. The C playground follows one byte through MOV, ADD, CMP and a write to the other half of AX.

## Work locally

Use x86-64 Linux/WSL, GCC, Clang, C11, make, Python 3.10+ and binutils. From week-08:

```sh
make
make test
make CC=clang test
make MODE=optimized test
make MODE=sanitize test
make warmups
python3 tools/hex2bin.py sample.bin b0 7f 04 01 3c 80 b4 12
build/learner/gcc/debug/sim8086 sample.bin
```

The default build compiles learner scaffolds and a supplied driver; it fails meaningful correctness gates until E01–E04 and the warm-ups are implemented. The [pinned decoder](support/decoder/README.md) is completed prerequisite code shared by both packages. No Week 8 instructor simulation code is compiled into the learner build. Four learner modules own registers, ALU, execution and program sequencing. The public [simulator header](include/sim.h) documents all contracts.

One graded assignment combines E01–E05 with the [notebook](learner/observations.md): working simulator, deterministic traces, hand predictions, test evidence and reasoning. [Exercise contracts](learner/exercises.md), [practice](learner/practice.md) and [rubric](rubric.md) explain the work. [Instructor materials](instructor/README.md) contain complete separate solutions. `make verify` runs the six reference configurations and starter checks.

## State and supported execution

CpuState stores eight 16-bit words in decoder code order: AX, CX, DX, BX, SP, BP, SI, DI. Byte codes 0–3 are AL, CL, DL, BL; codes 4–7 are AH, CH, DH, BH. Each byte write preserves the other byte of its word. The byte code four is AH, not an 8-bit SP. Arithmetic is performed on numerical guest values rather than the byte representation of the host struct.

Execute every register/register or register/immediate MOV, ADD, SUB and CMP form accepted by the supplied Week 7 decoder, including C6/C7 /0 register mode and 83's sign-extended byte immediate. The decoder continues to recognize memory operands, but execution rejects them with SIM_UNSUPPORTED_OPERAND. Other instructions, jumps, memory, stack, segments, interrupts and cycle estimates belong to later weeks.

MOV changes its destination and advances IP while preserving all flags. ADD and SUB wrap to eight or sixteen bits and replace CF, PF, AF, ZF, SF and OF. CMP computes subtraction flags with no destination write. Other bits in the flags word are preserved; they are opaque state, not implemented processor behavior. Initial CLI registers, flags and IP are zero as a course convention, not an 8086 hardware reset claim.

| Flag | Mask | Meaning for this model |
| --- | --- | --- |
| CF | 0001 | Unsigned carry for addition; borrow for subtraction/CMP |
| PF | 0004 | Even count of one bits in the low result byte, including zero |
| AF | 0010 | Carry or borrow across the low four-bit boundary |
| ZF | 0040 | The result at the selected width is zero |
| SF | 0080 | The result's top bit at the selected width is set |
| OF | 0800 | The mathematical signed result is outside that width's signed range |

The guest IP is 16-bit and wraps modulo 65536. A separate size_t file cursor locates the next encoded instruction and does not wrap. This week's runner is sequential; it never fetches bytes by using guest IP as an array index. A successful step advances IP by the decoded length; a failing step leaves every state field unchanged.

sim_run executes into local state and commits only when the entire input succeeds. Its return record names the first failing file offset and the successful tentative step count, even though caller state rolls back. Decode errors and unsupported execution are different statuses. Empty input succeeds unchanged; library and CLI input are capped at 65536 bytes. Input and output objects must be disjoint and the input immutable throughout each call.

## Trace and error behavior

The supplied CLI accepts one binary path, validates and tentatively runs the whole program, then replays it from zero state to print one line per instruction and a final state. Each line contains a decimal file offset, canonical instruction text, all eight words, guest IP and the flags word in four-digit hexadecimal. Flag masks above interpret that word. A late decode or execution failure prints a stderr status and its first instruction byte offset, exits nonzero and leaves stdout empty. File, argument and oversized-input failures also produce no stdout. Output-write errors may leave partial output and are reported separately.

The [short fixture](fixtures/program.hex) exercises byte aliases, signed overflow, CMP flag updates, MOV preservation and a word subtraction. [Expected trace](fixtures/program.txt) was derived independently by hand. The mathematical oracle constructs expected flags from signed ranges, remainder arithmetic, nibble carry/borrow and parity counting; it does not copy the executor's bitwise formulas.

## Read and watch

CE page URLs and durations were checked against the official TOC on 2026-09-30. CE is required subscription material; all course code, fixtures and explanations are original. The two episodes total 43:56. Schedule a 60–75-minute viewing session: watch them, pause on each state change, and replay about twenty minutes while making your own register/flag table. Spend a further thirty minutes consulting the named Intel and C sections.

- [CE: Simulating Non-memory MOVs](https://www.computerenhance.com/p/simulating-non-memory-movs): Full, 18:00. Connect a decoded operand to guest register storage, including the byte aliases.
- [CE: Simulating ADD, SUB, and CMP](https://www.computerenhance.com/p/simulating-add-jmp-and-cmp): Full, 25:56. Arithmetic changes flags as well as a destination. The official page URL contains add-jmp despite the ADD/SUB/CMP title.
- [Intel 8086 Family User’s Manual, October 1979](http://www.bitsavers.org/components/intel/8086/9800722-03_The_8086_Family_Users_Manual_Oct79.pdf): Chapter 2, General Registers and Flags; Chapter 3, data transfer and ADD/SUB/CMP descriptions; Table 4-12 for the encoded inputs. ISA authority: register aliases, MOV flag preservation and the six arithmetic flags. Consult exact headings rather than reading the whole manual.
- [Intel software developer manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html): Volume 2, ADD, SUB, CMP and MOV: operation and flags-affected sections. Accessible primary cross-reference for these flag semantics; modern prefixes/addressing are outside this historical subset.
- [C11 draft N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf): §§6.2.5, 6.3.1.1, 6.3.1.3, 6.5.7, 7.20.1.1. Unsigned arithmetic, promotions, narrowing conversions, shifts and exact-width types.

Core target is ten hours, unpiloted: viewing/reference work 95 minutes; E01 70; E02 150; E03 100; E04/E05 100; notebook and practice 85. Beginner work adds about 2–4 hours. Stretch work is additional. Record the actual time and difficulties.

## Source → mechanism → observation

The C ALU widens the operands before arithmetic, masks the result to guest width and computes flags from both the operands and result. The executor applies that result to the selected register view. A trace records the next state. The same eight bits can have signed or unsigned interpretations, so carry and overflow answer different questions about one calculation. Week 9 will use those flags for conditional jumps and add guest memory.
