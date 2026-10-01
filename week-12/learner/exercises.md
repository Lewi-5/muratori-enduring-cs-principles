# Graded assignment — Project 2

## E01 — Prepare immutable code

### E01.C

Implement project_prepare in prepare.c. Mark every start and the halt boundary, initialize unused map entries and preserve the image on invalid arguments or a malformed unreachable suffix. Document borrowed-code lifetime and immutable-image ownership.

### E01.Q

For B8 34 12 EB FC, list boundaries and distinguish decoding success from later target failure. Explain why replacing bytes at the same host pointer requires preparation again.

## E02 — Audit the complete subset

### E02.C

Implement project_step in execute.c for exactly the specified subset. Use the prepared map, pre-state operands/addresses, explicit guest bytes and instruction-specific flags. Cover PUSH SP, POP SP, calls/returns, wrapping data and checked stack bounds. Every failed step is atomic.

### E02.Q

Draw the main fixture's CALL/PUSH/POP/RET words and SP positions. Explain why INC/DEC cannot copy every ADD/SUB flag, and why data-word wrap differs from stack bounds.

## E03 — Commit a bounded run

### E03.C

Implement project_run in run.c with a positive budget, valid initial boundary, halt-before-budget rejection and full-Machine commit only on success. Compare statuses, offsets, tentative counts and complete state against the pinned predecessor, plus independently derived cases.

### E03.Q

Predict EB FE at budget three; a valid step followed by a bad target; and an empty prepared image. Does a nonzero error step count imply that earlier stores committed?

## E04 — Publish a complete state trace

### E04.C

Implement project_trace in trace.c. Validate the entire run and capacity before writing records, count or state; replay immutable input; initialize every record; report only changed bytes, numerically ordered. Test zero steps, exact/insufficient capacity, same-value stores, FFFF wrap and error precedence.

### E04.Q

Predict trace deltas for writing 1234 at FFFF twice, then POP. Explain the difference between changed bytes and a log of all writes, and justify the maximum of two changed bytes per accepted instruction.

## E05 — Defend Project 2

### E05.C

Deliver CHECKPOINT-2.md's manifest, three predicted/golden byte streams and R01–R05. Run make inspect for both compilers at debug/optimized; annotate checkpoint_local and checkpoint_distance or query_hit_compare, with real ABI/relocation evidence. Add one independent combined-subset test. All code is C; no new handwritten assembly is needed.

### E05.Q

Defend the distinction between ISA semantics, teaching policies, C validity, ABI conventions, compiler choices and modern microarchitecture. Explain why a successful 25-step historical trace and a short optimized x64 listing do not establish cycles or predictor success.
