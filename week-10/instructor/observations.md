# Notebook exemplar

### R01

At deepest nesting SP=00FA. From low to high: 00FA:0F,00FB:00 (return after CALL at 000C); 00FC:34,00FD:12 (AX saved by PUSH at 0008); 00FE:06,00FF:00 (return after CALL at 0003). The newest return is at SP. The ten transitions and final line are fixtures/program.txt; each line corresponds to the IP sequence in E05.C. Matching this table tests our predicted write order. A mismatch in bytes but correct words suggests host-endian encoding; a mismatch in return IP by three suggests using the CALL's first byte as the relative base.

### R02

Invalid-return exemplar: initial empty window and AX=2; bytes 50 B8 01 00 C3. Two tentative instructions succeed; RET at 4 proposes target 2 in MOV's immediate. Result M_TARGET, offset=4, steps=2; caller AX remains 2, SP=0100, IP=0 and all original memory unchanged. Loop exemplar EB FE with budget three: M_LIMIT, offset=0, steps=3, caller unchanged. To verify rollback, copy the full Machine before execution and compare every byte afterward; checking only SP can miss leaked stores.

### R03

For each call, an automatic local begins lifetime on block entry and ends on block exit; the next call creates a distinct lifetime even if storage is reused. A static local exists once throughout execution and retains changes between calls. Allocation creates a separate lifetime until free, potentially across both calls. Use `good(int *out)` from E05.Q with a caller-owned live object. A pointer name's scope does not own the pointee's lifetime. C's observable behavior, not a required stack slot, is the compiler contract; a constant local may be folded or held in a register. Never run the invalid dereference to manufacture a required observed value.

```text
time:       start -> call 1 entry -> call 1 exit -> call 2 entry -> call 2 exit -> end
automatic:          [ lifetime 1 ]                [ lifetime 2 ]
static:     [----------------- one program-duration lifetime ------------------]
allocated:             malloc -> [ live across calls ] -> free
```

The allocated line is one valid ownership choice, not a requirement to allocate at those call boundaries. Name visibility belongs to source blocks, while the diagram follows execution time.

### R04

Report compiler version lines, OS, command, exit status and useful failure output. Actual package validation is recorded separately in validation.md. Debug checks expose program behavior with little optimization; optimized checks can reveal dependence on undefined behavior but their passing cannot prove its absence; ASan/UBSan check instrumented cases for supported memory/undefined behavior failures. Strict conversion warnings help examine integer interpretation. Remaining uncertainties include unimplemented segments/opcodes and untested arbitrary instruction combinations. A deterministic test is evidence, not a proof of the full ISA.

### R05

A complete report leaves actual workload cells to the learner's recorded experience: viewing __, E01 __, E02 __, E03 __, E04/E05 __, notebook/practice __; total __. Do not replace missing pilot measurements with the syllabus estimate. Example conceptual difficulties are RET's read-before-target-check and PUSH SP's historical difference. Week 11 adds System V register ownership, argument/result placement and stack alignment, then examines actual debug/optimized host instructions. Near CALL alone does not define that ABI or instruction timing.
