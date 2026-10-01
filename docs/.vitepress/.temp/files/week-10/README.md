# Week 10 — Stack discipline, calls and lifetimes

[Lesson](../docs/content/weeks/week-10.md) · [Beginner section](../docs/content/beginners/week-10.md) · [Further reading](../docs/content/further-reading/week-10.md)

You can follow a branch and calculate a memory address. Now a routine must return to the instruction after its caller, even when the routine calls another routine. A stack saves those return positions in last-in, first-out order. This week implements that mechanism in C and separates it from the language rules that determine how long C objects exist.

Prerequisites: [Week 7](../week-07/README.md)'s decoder API and [Week 8](../week-08/README.md)'s register aliases and arithmetic flags; Week 9's control-flow and guest-memory concepts. Week 10 is independently buildable during parallel course development: the revision-7 decoder and Week 8 register/ALU functions are pinned completed prerequisite code in support. The original extension executor includes bounded control flow and flat guest memory so it does not depend on an unfinished Week 9 package. This snapshot is a source contract, not binary ABI compatibility with a future Week 9 header. Week 11 can use the resulting trace to compare historical near calls with generated x64 assembly.

## Work locally

Use Linux or WSL with GCC, Clang, C11, Python 3.10+ and make. From week-10:

```sh
make
make test
make warmups
make PACKAGE=instructor test
make verify
python3 -c "from pathlib import Path; Path('program.bin').write_bytes(bytes.fromhex(Path('fixtures/program.hex').read_text()))"
build/learner/gcc/debug/sim8086 program.bin
build/learner/gcc/debug/playground
```

The default build compiles learner stubs cleanly; its correctness tests fail until you implement them. Learners implement four modules and three warm-ups. Both packages use the supplied CLI and playground, with no Week 10 instructor implementation linked into learner executables. Build paths include package, compiler and mode. `make verify` runs six reference configurations and checks that untouched scaffolds fail meaningful gates. See [validation](instructor/validation.md) for actual evidence, rather than treating a command list as proof it ran.

Submit one graded assignment: E01–E05, the deterministic nested-call trace and R01–R05. Work through six practice problems and two optional stretches. All code, written predictions and interpretation requests have separate instructor answers. Core estimate: ten hours, unpiloted (viewing 90 minutes, stack helpers 80, decoding 80, execution 160, runner/CLI 90, notebook/practice 100). Beginner work adds 2–4 hours; stretch is additional. Record actual time.

## Exact teaching model

The [public header](include/machine.h) is authoritative. `Machine` contains the Week 8 CPU state, 65536 data bytes and an explicit stack window `[stack_low,stack_high)`. Code is a separate immutable byte array starting at guest IP zero. No host pointer is a guest address. This flat model omits CS/DS/SS segmentation, interrupts, timing, self-modifying code and far calls. Memory operands use the revision-7 decoder's full effective-address expressions; ordinary word memory accesses wrap FFFF → 0000. Stack words must fit the configured window and never wrap. Odd SP values are accepted.

The CLI initializes SP=0100 hex and the window [0080,0100); other registers, flags, IP and data bytes start at zero as course conventions. An empty stack means SP equals stack_high. PUSH subtracts two before storing the low and high bytes. POP reads those bytes and adds two, without erasing memory. The helpers preserve IP and flags. General data writes can alter stack bytes: return positions are ordinary guest data, with no hidden tagged return stack.

| Added form | Encoding | Effect |
| --- | --- | --- |
| PUSH r16 / POP r16 | 50–57 / 58–5F | Save/restore one word; preserve flags |
| CALL rel16 | E8 + low/high displacement | Push IP after CALL, then transfer within this code region |
| RET | C3 | Pop next IP; require a known instruction or halt boundary |
| JMP rel8 / rel16 | EB / E9 + displacement | Transfer relative to IP after the instruction |
| Jcc rel8 | 70–7F + displacement | Test Week 8 flags; preserve them |
| INC / DEC r16 | 40–47 / 48–4F | Add/subtract one; preserve CF, replace the other five arithmetic flags |
| NOP | 90 | Advance IP without other changes |

Original 8086 `PUSH SP` stores the decremented SP; modern x86 stores the pre-decrement value. `POP SP` replaces SP with the popped value after the internal increment; this model rejects a popped SP outside its window. Near transfers keep the conceptual code segment fixed. Immediate PUSH, FF-group stack/transfers, segment pushes, far transfers, RET with cleanup, prefixes, HLT and other instructions are unsupported. Retaining a narrowly specified subset makes tests and explanations reviewable; “Other Common Instructions” is reading, not an obligation to implement the whole ISA.

All relative displacements are decoded mathematically into int32_t. Target calculation wraps modulo 65536, but a target must be a decoded boundary in this code array, or exactly its length. Maximum code length is 65535. Reaching IP equal to that length is the course halt rule, including a return to that position. No automatic stack-balance requirement is imposed: explain a program that halts with live words rather than assuming the runner rejects it.

## Failure and trace contracts

The runner predecodes the entire code region, including unreachable bytes, before executing. This is a course validation policy; real hardware decodes bytes reached by control flow. An initial IP inside an immediate is rejected. Each step and the whole run commit only on success. Failure preserves all registers, flags, IP and data bytes. Returned offsets and successful tentative step counts describe the attempt. A positive instruction budget prevents infinite loops; reaching the end on the last allowed step succeeds.

`M_DECODE` identifies unsupported/truncated bytes; `M_TARGET` identifies a non-boundary transfer; `M_STACK` identifies stack-window failure; `M_LIMIT` identifies exhausted steps; `M_ARGUMENT` identifies invalid pointers, zero budget or oversized code. `machine_step` at the halt boundary returns M_TARGET; `machine_run` recognizes the halt without stepping.

The CLI validates a run with a 10000-step budget before replaying it. It prints before/after IP, AX, BX, SP and flags for each instruction, then final values and step count. Late model/input failures emit a stderr diagnostic and leave stdout empty. An output-write failure can leave partial output. Golden text is independently hand-derived in [program.txt](fixtures/program.txt); [program.hex](fixtures/program.hex) contains nested calls and a saved register. A trace shows architectural state, not host performance or complete ISA coverage.

## Read and watch

Direct CE pages and lengths were verified against the official TOC on 2026-09-30. View the three CE items in full (62:43) and the HH segment below (5:36), pausing to draw the word order. Allow 80–100 minutes with replays. CE is required subscription material; the package is original.

- [CE: Simulating Real Programs](https://www.computerenhance.com/p/simulating-real-programs), 16:02: connect separate instruction effects into a bounded program trace.
- [CE: Other Common Instructions](https://www.computerenhance.com/p/other-common-instructions), 19:43: distinguish instruction-specific flag/write rules; implement only the listed subset.
- [CE: The Stack](https://www.computerenhance.com/p/the-stack), 26:58: track SP, saved data and control transfer.
- [Handmade Chat 013](https://guide.handmadehero.org/chat/chat013/), 3:50:01–3:55:37: the indexed RIP and RSP discussion. Windows/x64 observations are a comparison; they do not define 8086 semantics.
- [Intel manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html), Volume 2 PUSH/POP/CALL/RET and INC/DEC operations and flags. PUSH explicitly documents the original 8086 SP difference; modern addressing and protection exceptions are outside this model.
- [C11 N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf), §§6.2.4 and 6.2.1: object lifetime/storage duration and identifier scope; §6.5.2.2 for C function calls. C does not require automatic variables to occupy a processor stack.

## Source → mechanism → observation

The C decoder extracts a signed displacement. The executor obtains the IP after CALL, stores that number as two guest data bytes at SP−2, and fetches the callee. RET reads those bytes, restores SP and sets IP. Nested calls work because the newest return word lies at the current SP. Seeing stale bytes after POP proves those bytes were not erased; it cannot extend the lifetime of a C local. Week 11 adds an ABI comparison, where register ownership, arguments and alignment are separate conventions layered onto instruction behavior.
