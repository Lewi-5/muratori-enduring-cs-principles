# Week 9 — Branches and bounded guest memory

[Lesson](../docs/content/weeks/week-09.md) · [Beginner section](../docs/content/beginners/week-09.md) · [Further reading](../docs/content/further-reading/week-09.md)

Week 8 could execute a stream only once from left to right. A loop needs to return to an earlier instruction, and a load needs to turn an address expression into actual data. This week makes those two changes explicit, using the existing register aliases and six arithmetic flags.

## Objectives and prerequisites

Predict taken and untaken transfers from flags; calculate displacement from the following instruction; evaluate every 8086 effective-address expression; read/write byte and little-endian word data without host pointer casts; distinguish guest wrapping from host bounds; report finite execution and preserve the entire state on failure. Bring [Week 7](../week-07/README.md)'s memory operand decoder, [Week 8](../week-08/README.md)'s registers/ALU and Week 1's arrays and error returns. Completed decoder and ALU snapshots are supplied in support; no Week 10 implementation is linked.

Use x86-64 Linux/WSL, C11, GCC, Clang, make and Python 3.10+. From this directory:

```sh
make
make test
make warmups
make PACKAGE=instructor test
make verify
python3 -c "from pathlib import Path; Path('build/program.bin').write_bytes(bytes.fromhex(Path('fixtures/program.hex').read_text()))"
build/learner/gcc/debug/sim8086 build/program.bin
build/learner/gcc/debug/playground
make PACKAGE=instructor extras
```

Learner builds compile but correctness gates fail until the four typed modules and three warm-ups are implemented. E05 uses the supplied CLI and playground; submit its trace and independent checks alongside E01–E04 and notebook R01–R05 as one graded assignment. Six practice problems and two optional stretches have separate solutions. Reference code is in instructor; default builds never link it.

Core budget: 600 minutes, unpiloted: viewing 85, address helpers 70, branches/decoding 95, execution 160, runner/trace 100, practice/notebook 90. Beginner work adds 2–4 hours; optional deeper reading/stretch adds more. Record actual time rather than treating this estimate as a pilot result.

## The teaching machine

[machine.h](include/machine.h) is the public contract. Machine contains Week 8 CpuState and exactly 65536 data bytes. Immutable code is a separate byte array at guest IP zero, with length 0..65535. Reaching IP equal to that length halts by course convention. Zero registers, flags, IP and data in the CLI are initial conditions for this exercise, not a hardware reset specification. The array is a flat sixteen-bit data-offset space: no CS/DS/SS segments, interrupts, ports, cycles, stack or self-modifying code. A numeric guest address is an array index, never a host pointer.

| Form | Accepted encoding | Change |
| --- | --- | --- |
| MOV/ADD/SUB/CMP | All revision-7 register, immediate and memory forms | Actual operand reads/writes, with Week 8 flags |
| Jcc rel8 | 70–7F plus signed byte | Test a condition, transfer if true |
| JMP rel8/rel16 | EB or E9 plus signed displacement | Unconditional relative transfer |

The base forms include C6/C7 /0, A0–A3, arithmetic group 80/81/83 for ADD/SUB/CMP, all ModR/M modes and signed displacements. Unsupported forms remain errors: LOOP/JCXZ, segment overrides/prefixes, CALL/RET, PUSH/POP, INC/DEC, NOP, indirect or far jumps. Week 10 adds its own explicitly specified subset.

The eight non-direct address expressions are BX+SI, BX+DI, BP+SI, BP+DI, SI, DI, BP and BX. Add the signed displacement and retain the low sixteen bits. The mod00/rm6 case is instead an unsigned direct address, already distinguished by the decoder. Address registers remain words even when the data width is one byte. BP does not select a separate segment in this flat model.

A word at address FFFF stores its low byte at FFFF and high byte at 0000. This is defined wrapping in the guest model; both host indices remain within the array. Never dereference a uint16_t pointer into the bytes: host endian, alignment and C aliasing rules do not define the guest encoding. Read both values and any destination address from the old state before writes, including MOV BX,[BX]. MOV and jumps preserve flags; CMP replaces arithmetic flags without writing data; ADD/SUB replace six flags and preserve other bits.

## All sixteen conditional predicates

The low opcode nibble selects these predicates. Names are conventional aliases; the bytes and formulas are authoritative. Flags are booleans here.

| Nibble | Name | Taken when |
| --- | --- | --- |
| 0 / 1 | JO / JNO | OF / !OF |
| 2 / 3 | JB / JAE | CF / !CF |
| 4 / 5 | JE / JNE | ZF / !ZF |
| 6 / 7 | JBE / JA | CF or ZF / neither |
| 8 / 9 | JS / JNS | SF / !SF |
| A / B | JP / JNP | PF / !PF |
| C / D | JL / JGE | SF differs from OF / equal |
| E / F | JLE / JG | ZF or SF differs from OF / neither |

After CMP, JB compares unsigned values, while JL compares signed interpretations of the same patterns. SF alone is insufficient because subtraction can overflow. A displacement is measured from IP after the complete jump instruction. Signed patterns are decoded mathematically to int32_t, avoiding an implementation-dependent out-of-range cast to int8_t/int16_t. Target arithmetic wraps modulo 65536.

## Boundaries, budget and failure

The whole code array is predecoded, even unreachable bytes. Taken branch destinations and initial IP must be instruction boundaries or the halt boundary. A position inside an immediate is rejected even though real 8086 hardware could begin decoding there. An untaken target is not validated. Separate code/data, full predecode, boundary checks, halt-at-end and transactions are deliberate teaching policies, not complete hardware behavior.

machine_step commits one complete state transition on success. machine_run commits registers, IP, flags and every data byte only if the entire run succeeds. M_DECODE reports malformed/unsupported code; M_TARGET a bad initial IP or taken destination; M_LIMIT a positive instruction budget exhausted before halt; M_ARGUMENT bad pointers, zero budget or oversized code. Returned offsets and tentative successful step counts describe the attempted run even when all state is rolled back. Decode validation happens before execution, so malformed unreachable bytes report zero steps. Halt reached on the last allowed step succeeds.

The supplied CLI validates with a 10000-step budget before replaying a trace. Each line prints old/new IP, AX, BX, CX, flags and memory[0100]; the final line reports the step count. Late input/model errors produce stderr and no stdout. Actual output write failures may leave partial text and return failure. Trace replay is deterministic because input remains immutable. Rebuilding a boundary map each step prioritizes clear ownership over throughput; it is not a performance claim.

## Read and watch

Direct pages checked on 2026-09-30; source lengths are listed in the official CE table of contents. Watch both in full (46:13), pause to draw the backward target and memory bytes, then replay the relevant examples. Allow 75–90 minutes including those pauses and about 15 minutes of primary-reference lookup; no invented extra video is required to reach the schedule. CE is subscription material; all package prose, assignments, fixtures and solutions are original.

- [Simulating Conditional Jumps](https://www.computerenhance.com/p/simulating-conditional-jumps), 19:41: promote a stream position to a next-fetch IP and interpret conditions.
- [Simulating Memory](https://www.computerenhance.com/p/simulating-memory), 26:32: turn decoded addresses into data accesses.
- [Intel manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html), Volume 2 Jcc/JMP/MOV/ADD/SUB/CMP operation/flags, Volume 1 basic addressing. These modern manuals clarify shared semantics; use our header for the exact historical subset and flat-model restrictions.
- [C11 N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf), §§6.3.1.3, 6.5.2.1, 6.5.7: unsigned conversion, array indices and shift requirements.

## Source → mechanism → observation

The decoder produces a signed branch distance and a memory expression. The executor evaluates the expression against old word registers, reads guest bytes, computes flags, then chooses the next IP. The original fixture increments data[0100] while subtracting one from CX and repeats through JNE. Predict all thirteen transitions before comparing [program.txt](fixtures/program.txt). It establishes this subset's architectural state and bounded execution, not CPU timing or real segmented-memory behavior. Week 10 uses the same memory and transfer ideas to store continuations on a stack.
