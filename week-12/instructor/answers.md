# Complete Project 2 worked answers

### E01.C

Reference: src/prepare.c. Build a zero-initialized candidate containing the borrowed bytes and length. Decode sequentially through the completed helper, mark each start and finally the end. Return the first failing opcode without publishing any candidate fields; unused map entries stay zero. A successful preparation validates the encoding region, not a particular run's transfers or stack. Code and image must remain alive and immutable; no hash or retained pointer can make dangling storage valid. A faulty early assignment would publish a partially prepared map after a malformed suffix.

### E01.Q

Starts are 0 and 3, with halt at 5. The decoder accepts the stream; JMP at 3 has following position 5 and FC = -4, so target 1 is inside MOV's immediate and execution rejects it. The map's validity is tied to the exact immutable bytes, not merely a pointer value. Mutating those bytes can change lengths and boundaries while leaving the pointer unchanged. Retire the old image, then prepare again with the new bytes before execution.

### E02.C

Reference: src/execute.c. The executor adapts the Week 10 subset but uses the prepared boundary map. Read operands and destination addresses from the old Machine, copy Machine, apply one instruction and commit only on success. Explicit bytes define little endian and modulo data offsets; stack helpers enforce their window before writes. Validate a taken relative/return target before committing a push/pop effect. Original PUSH SP uses the decremented value, while POP SP's final destination is the popped word. INC/DEC preserve old CF and update the other five flags. A shortcut using a later-x86 PUSH rule or unconditional ADD flags fails the historical contract. tests/contracts.c checks actual transitions and complete rollback.

### E02.Q

Main CALL at 0008 follows at 000B. It pushes word 000B at 00FE, SP becomes 00FE, and transfers to 0010. PUSH AX saves 0000 at 00FC, SP becomes 00FC. POP AX restores SP to 00FE without erasing the bytes; RET reads 000B and restores SP to 0100. INC/DEC preserve CF rather than adopting ADD/SUB's carry, while updating the other arithmetic flags. Data words at FFFF wrap through index zero; stack words must fit the configured contiguous window and never wrap. These distinct checks are deliberate course policies.

### E03.C

Reference: src/run.c. Check arguments and initial boundary, then execute a local Machine while its IP is not the halt boundary. Before each instruction, test the positive budget; after success increment the tentative count. Commit at halt. The loop condition precedes the budget rejection, so exact-budget completion succeeds. Returning an error after assigning each successful step to caller state would leak an earlier memory store. The pinned predecessor comparison checks regression equivalence and the separately derived arithmetic/fixture tests cover shared-assumption risk.

### E03.Q

EB FE repeats at IP zero. Budget three returns M_LIMIT, offset zero, steps three, and complete state remains original. A valid store followed by a jump into an immediate returns M_TARGET at the jump opcode with one tentative step and no committed store. Empty prepared code at IP zero with positive budget succeeds at offset zero with zero steps and unchanged state. Step counts describe attempted work; they are not a committed prefix.

### E04.C

Reference: src/trace.c. Copy the initial Machine, validate a complete run, then reject insufficient record capacity before touching output. Replay from the original state and compare old/new memory bytes numerically for each instruction. Initialize unused delta entries; every accepted instruction writes at most one word, so no more than two bytes can change. Publish records only after all fallible execution/capacity checks; unchanged input guarantees identical replay. Commit final Machine/count last. A one-pass writer leaks trace records on a late failure; a complete memory snapshot per record is correct in principle but not this public record format. Tests check sentinel outputs, same-value stores, wrap ordering and execution-error precedence.

### E04.Q

A first store of 1234 to initially zero data changes address 0000 to 12 and FFFF to 34; the record lists 0000 first because its address is numerically smaller. The second identical store produces no changed bytes despite executing a store. POP changes registers/SP but leaves its saved bytes, so it also has no memory delta. Delta records describe state differences rather than all accesses. Every accepted instruction can store at most one byte or word: base data destination or a PUSH/CALL word. No accepted instruction writes two separate words, so two byte entries suffice.

### E05.C

Exemplar package: CHECKPOINT-2.md, fixtures/program.hex/.txt, wrap.hex/.txt, push-sp.hex/.txt, tests/contracts.c, tests/check.py and instructor/report.md. The three fixtures are hand-derived; the Python oracle independently computes all fields for 128 combined call/loop/stack/data programs. The contract suite has a separately calculated nested-call result and pinned-predecessor comparisons. tools/inspect.py generates real artifacts and manifests for two compilers/modes. The report gives actual excerpts and accepts a different valid listing when the learner explains source effects, ABI locations, relocations and limits. This is a complete exemplar deliverable set, not a claim that our particular internal code layout is required.

### E05.Q

The guest trace establishes the chosen ISA subset under its initial state and course restrictions. Full predecode, checked boundaries, immutable separate code, stack window, halt convention and rollback are teaching policy. Host C validity constrains lifetime, arithmetic and accessible objects. The System V ABI constrains argument/result locations and preservation; optimization chooses an implementation satisfying defined C effects. Modern prediction, pipelines, caches and scheduling affect timing but are absent from the guest state. Neither the 25-step count nor a compact x64 listing measures cycles or prediction success. Report an actual timing experiment only once a timing protocol exists.

### P01

The map stores valid start positions but the image also borrows bytes used to decode reached instructions. Returning from the block ends the array's lifetime; project_run then reads invalid host storage regardless of old contents. Repair by keeping code in a caller-owned array alive through all runs, using static constant storage for a fixed fixture, or owning a buffer until the image is retired. Heap allocation is one choice, not a universal requirement. Re-preparing a dangling pointer is still invalid.

### P02

For byte 80 - 01, the stored result is 7F, CF = 0, SF = 0, OF = 1 and ZF = 0. JB is false because unsigned 128 is not below 1; JL is true because signed -128 is less than 1. Host signed overflow is undefined C behavior and cannot serve as a reliable guest wrap operation. Use widened unsigned arithmetic/masks, or representable signed intermediates and explicit modulo/range logic. sim_alu uses defined operations; tests independently use mathematical range checks.

### P03

CALL saves 000B at 00FE/00FF, then PUSH AX saves 0000 at 00FC/00FD. SP moves 0100→00FE→00FC. Omitting POP makes RET consume 0000 as a target. Here zero is a valid code boundary, so it can restart setup instead of returning to the intended caller; target checks do not establish stack discipline or tag a word as a return address. The outcome is a different state/loop and may eventually hit a budget or stack error. Restore the saved register before consuming the continuation.

### P04

If execution is valid and requires two records, capacity one returns M_CAPACITY with steps two and end offset; caller count, trace array and Machine remain unchanged. If execution instead fails at a taken target, M_TARGET and its attempted IP/count take precedence even with capacity one or zero. Validate the full run before deciding capacity. A sentinel-filled trace and nonzero initial count catch partial output leaks that final-register checks miss.

### P05

The first store reports addresses 0000:12 and FFFF:34 in that order, assuming both bytes were zero. The second reports no changes. Numeric ordering is unrelated to little-endian significance: low byte 34 still resides at the starting address FFFF. A delta trace can establish equality of before/after memory but cannot establish that no store occurred or infer memory traffic.

### P06

At a debug ordinary CALL, hardware pushes the wrapper's following return position before entering geo_distance_km, then the wrapper resumes and returns to its own caller. An optimized tail JMP can enter geo_distance_km with the original caller's continuation already on the stack; the target's RET returns there directly. Both can implement the wrapper's defined result if arguments, stack alignment and preserved registers satisfy the ABI. R_X86_64_PLT32 names the external target in an unresolved object. A zero displacement before relocation does not mean the actual transfer lands at the next instruction.

### S01

Complete design: instrument the executor's centralized byte-write helper so each successful instruction records requested addresses, old/new values and issue order, even if values match. PUSH/CALL must use the same instrumentation path; register-only operations have zero write events. Each accepted instruction has at most two events. Unlike architectural delta order, a wrapping word's event order starts at FFFF then 0000. Buffer a local step event record and commit it only with the successful Machine step. For a whole trace, first validate execution/count/capacity, then replay immutable code and initial state with instrumentation, publishing only after validation. Define capacity in records or events explicitly; reject before caller output. Compare full final state and all error results with the delta implementation, then derive each delta by removing events with equal old/new bytes and sorting remaining addresses. Test same-value stores, FFFF wrap, stack operations, bad RET and late failures. This design changes observability, not ISA semantics; it remains unable to describe cache traffic or speculation.

### S02

Complete protocol: first verify both implementations have identical status, offset, tentative steps and complete state on golden/independent/error cases. Choose fixed immutable code and initial Machine plus a loop bound; record hashes, compiler/version/flags, CPU/OS and budget. Measure separately preparation plus execution for one run, and one preparation amortized across multiple runs versus repeated map parsing. Include state-copy/reset cost consistently, avoid CLI printing inside timed regions, and consume/check final results so work cannot disappear. Use a monotonic host clock, warm-up, repeated samples and medians/spread; report timer overhead and workload size. Preparation overhead may dominate a small one-shot run; repeated loops may amortize it. A slower prepared implementation can still be correct, and either result requires actual observations. Host elapsed time is not guest 8086 cycles, modern predictor success or a universal speedup. Week 13 supplies the timing harness rather than pretending a measurement has already been made.
