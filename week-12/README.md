# Week 12 — Project 2: a specified simulator and a defensible comparison

[Lesson](../docs/content/weeks/week-12.md) · [Beginner section](../docs/content/beginners/week-12.md) · [Further reading](../docs/content/further-reading/week-12.md)

You can decode an operand, execute a branch, save a return word and read an x64 listing. Project 2 asks whether these pieces form one reviewable system. Deliver a specified C decoder/simulator subset, golden byte streams, complete state traces, failure evidence and a short comparison with actual debug/optimized x64 disassembly. The project passes on correctness and explanation, not a speedup or a claim to emulate every 8086 instruction.

Prerequisites: [Week 7](../week-07/README.md)'s decoder, [Week 8](../week-08/README.md)'s flags, [Week 9](../week-09/README.md)'s memory/branches, [Week 10](../week-10/README.md)'s stack/calls and [Week 11](../week-11/README.md)'s ABI and generated listings. The package pins completed decoding, arithmetic and stack helpers so it builds independently. Learners own prepared-code validation, execution, bounded runs and transactional traces; no new reference implementation is linked into their executables.

## Build and inspect

Use x86-64 Linux/WSL, C11, GCC, Clang, make, Python 3.10+ and binutils. From week-12:

```sh
make
make test
make warmups
make inspect
make CC=clang MODE=optimized inspect
make PACKAGE=instructor test
make verify
python3 -c "from pathlib import Path; Path('build/program.bin').write_bytes(bytes.fromhex(Path('fixtures/program.hex').read_text()))"
build/learner/gcc/debug/sim8086 build/program.bin
build/learner/gcc/debug/playground
```

Default typed scaffolds compile cleanly and fail correctness gates until completed. Build paths include package/compiler/mode. `make verify` checks six reference combinations, warning-clean failing starters, warm-ups, exact beginner output and four actual inspection sets. Tests link a pinned predecessor only as a comparison; the production/learner driver does not. See [actual validation](instructor/validation.md).

Submit E01–E05 and R01–R05 as the single Project 2 assignment, including [CHECKPOINT-2.md](CHECKPOINT-2.md)'s deliverable manifest, three golden fixtures and a report. Practice has six problems and two optional stretches. Core estimate: 600 minutes, unpiloted (view/reference 90, prepare 60, executor audit 130, run 70, trace/fixtures 100, comparison/report/practice 150). Beginner work adds 2–4 hours; optional further reading/stretch adds time. Record actual workload.

## Public contracts and ownership

[project.h](include/project.h) is authoritative. CodeImage borrows immutable code bytes and owns a 65536-byte boundary map. `project_prepare` predecodes the whole stream, including unreachable bytes, then publishes the image only on success. Mark every instruction start and the end; initialize unused map entries to zero. The caller keeps both code and image alive and unchanged during their use. Editing code requires new preparation, even at the same host address. A map is host validation metadata, not guest state or a branch predictor.

`project_step` checks the prepared map instead of decoding the entire region again. It executes one instruction atomically. `project_run` works on a full local Machine and commits only at halt, with a positive step budget. `project_trace` first validates the run, checks record capacity, then deterministically replays and publishes all records, count and final state. Failures preserve every output. Keeping source immutable is necessary for these passes to describe the same computation.

| Result | Meaning |
| --- | --- |
| M_ARGUMENT | Invalid pointers, extents or zero run budget |
| M_DECODE | Unsupported or truncated instruction during preparation |
| M_TARGET | Initial IP or taken transfer is not an accepted boundary |
| M_STACK | Stack window cannot satisfy the operation |
| M_LIMIT | Budget exhausted before halt |
| M_CAPACITY | Valid run needs more trace records than the caller supplied |

Preparation failures report the offending opcode and zero steps. Execution failures report attempted IP and tentative successful steps. Capacity failure reports end offset and required record count; it preserves state, trace bytes and count. Execution errors take precedence over trace capacity. Reaching halt on the final allowed step succeeds. Empty prepared code at IP zero succeeds with zero steps, including a zero-capacity trace.

## Exact subset and teaching restrictions

Machine contains eight word registers, modeled flags, IP, 65536 data bytes and stack window [low,high). Code is a separate immutable array at guest IP zero; length is 0..65535, and IP equal to length is the course halt rule. The CLI initializes SP=0100, window [0080,0100), and all other CPU/data fields to zero. Those are course initial conditions, not a processor reset specification. All storage is caller-owned and disjoint; no allocation, I/O or hidden global state belongs in the library.

| Accepted family | Bytes/forms |
| --- | --- |
| MOV/ADD/SUB/CMP | Revision-7 register/immediate/memory forms, all ModR/M modes/displacements, C6/C7 /0, A0–A3, 80/81/83 /0,/5,/7 |
| Jcc | 70–7F rel8, all sixteen Week 9 predicates |
| JMP | EB rel8 and E9 rel16 |
| PUSH/POP | 50–57 and 58–5F word registers |
| CALL/RET | E8 rel16 and C3 near return |
| INC/DEC | 40–47 and 48–4F word registers |
| NOP | 90 |

No segment prefixes/overrides or CS/DS/SS registers, indirect/far transfers, LOOP/JCXZ, immediate PUSH, FF groups, RET cleanup, interrupts, ports, HLT, self-modification, cycle estimation or predictor simulation. The model is deliberately narrower than either complete 8086 hardware or CE's reference. The primary reference supplies instruction semantics, while this header specifies our bounded policy.

Effective addresses use old word registers plus signed displacement modulo 65536; direct offsets are unsigned. Little-endian data words wrap FFFF→0000 through separate valid array indices. Stack words must fit the window and never wrap; odd SP is accepted. PUSH SP uses original 8086 semantics and stores decremented SP. POP SP's final destination is its popped word, required to remain in the window. CALL pushes the following IP, and RET pops a validated boundary. Return words are ordinary data, not hidden tagged continuations.

MOV and stack/transfers preserve flags; arithmetic replaces six modeled flags and preserves other bits. CMP writes no data. INC/DEC preserve CF and replace the other five flags. Signed JL uses SF != OF, unsigned JB uses CF; PF observes only the low byte. Evaluate source values and destination addresses before writes. Host signed overflow, unaligned word casts and treating guest offsets as host pointers are invalid implementation shortcuts.

Prepared maps, full predecode, boundary rejection, separate code/data, halt-at-end, stack-window errors and rollback are course policies. Real hardware may decode a target that this model rejects and does not atomically undo a whole program after a later fault.

## A trace is a state record

Each TraceRecord contains pre-IP, all post CPU fields, and up to two changed data bytes in increasing numeric address order. A same-value store has no delta. POP does not erase bytes. A word store at FFFF may report 0000 before FFFF because ordering is numeric; the ordering does not reverse endian. Trace records describe architectural state changes, not all attempted writes, instruction timings or speculative activity.

The supplied CLI has a 10000-step execution budget and 1024-record capacity. It validates before printing, so model/input/capacity failure leaves stdout empty. Write failure may leave partial output and returns an error. The original main fixture combines a countdown, near call, saved AX and a byte memory increment; it executes 25 instructions. Additional golden fixtures cover wrapping words and original PUSH SP. Predict them before reading the expected files.

## Actual modern comparison

`make inspect` compiles the supplied defined-C comparison subjects plus real geolab geo/query functions. It writes compiler `.s`, relocated object disassembly `.txt` and a manifest with versions, target, flags and source SHA-256. GCC/Clang at -O0/-O2 are observations, not a required universal instruction sequence. No LTO, fast-math or handwritten assembly is introduced.

Explain two source mechanisms and their ABI obligations. Compare `checkpoint_local` at debug/optimized and `checkpoint_distance` or `query_hit_compare` against the System V AMD64 LP64 convention. Identify argument/result locations, ordinary CALL versus an observed tail transfer, an optimized-away local, and the relocation needed to name an unresolved target. The [complete exemplar report](instructor/report.md) records actual listings and accepts different correct compiler results. Guest instruction count cannot supply x64 cycles or return-prediction success.

## Read and watch

Checked official direct pages/markers on 2026-10-01. View [CE: 8086 Simulation Code Review](https://www.computerenhance.com/p/8086-simulation-code-review), full 33:05, then [HH Chat 011](https://guide.handmadehero.org/chat/chat011/) at 4:18–15:54 and 34:42–45:00 (21:54 total). Schedule 75–95 minutes with pauses and primary-reference consultation. CE is subscription material; the package is original and does not reproduce its code/transcript. Review the source's design choices without treating its larger subset as this assignment's contract.

Primary references: [C11 N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf), §§6.2.4, 6.3.1.3, 6.5 and 6.5.7 for lifetime, conversions, object access and shifts; [Intel manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html) Volume 2 instruction operations and original PUSH SP distinction; [System V AMD64 ABI draft 0.21](https://refspecs.linuxbase.org/elf/x86_64-SysV-psABI.pdf) §§3.2.1–3.2.3 for the identified scalar comparison. The draft is historical; later extensions are outside this scalar task.

## Source → mechanism → observation

C preparation constructs a host boundary map. C execution interprets bytes into guest state transitions, and transactional replay records those transitions. Separate compilation produces actual x64 code obeying an ABI; it can remove a local or replace a call/return sequence while preserving defined C results. Golden state, disassembly, semantics, conventions and microarchitecture answer different questions. The project report names which evidence supports each claim. Week 13 begins measuring time explicitly rather than deriving it from these traces.
