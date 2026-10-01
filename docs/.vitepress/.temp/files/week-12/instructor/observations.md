# Notebook exemplar answers

### R01

Exemplar: use fixtures/program.txt as the hand-calculated sequence, then attach actual CLI output. Setup reaches IP 0008 with BX = 0100, CX = 3, AX = 0. Each of three iterations executes seven instructions: CALL, PUSH, ADD, POP, RET, DEC, JNE. Three setup instructions plus 21 loop instructions plus one final JMP total 25. Data[0100] reaches 3; CX is zero; AX remains zero; SP returns to 0100; flags are 0044. Repeated return/saved-zero stores need not produce repeated deltas. Preserve a wrong prediction and explain the corrected instruction count.

### R02

Exemplar: a valid two-record run with capacity one returns M_CAPACITY and required count two, preserving sentinel trace/count/state. Store-seven then bad jump returns M_TARGET after one tentative step and rolls back data. Recursive NOP/CALL with the [0080,0100) window holds 64 return words; it executes 65 NOPs and 64 successful CALLs before stack failure at CALL offset 1, with 129 tentative steps. Record actual outputs and confirm all fields remain unchanged; budget must exceed 129 to observe the stack error rather than M_LIMIT.

### R03

Exemplar: derive little-endian bytes by quotient/remainder 256, arithmetic flags from mathematical unsigned/signed ranges and low-byte parity, and stack words from following-IP/SP equations. Python checks all register/flag/delta fields for 128 countdown programs. A pinned Week 10 comparison shares decoder, ALU and stack helpers, so agreement alone cannot prove those helpers are right. Use hand goldens and the 196608 mathematical byte arithmetic cases to support the shared mechanisms. None of these is a full physical 8086 oracle.

### R04

Exemplar: instructor/report.md includes actual GCC 11.4.0 object excerpts and analysis of checkpoint_local and checkpoint_distance. Attach your own four inspection manifests and relevant excerpts. Identify RDI/XMM argument locations, RAX/EAX results, stack preservation, CALL versus a tail transfer and the external relocation. Another compiler may choose different registers or retain a frame; explain how it satisfies the same source effects and ABI. An optimized-away local is not an expired pointer or proof that C requires stack allocation.

### R05

Exemplar: the model implements a specific historical subset with bounded data and stack policies. It omits segmentation, interrupt/device state, predictor/cache/pipeline effects and timing. Defined host C remains required even when the guest wraps. List real commands, compiler targets and source hashes, attach validation logs and record your own workload; no learner time is supplied. Week 13 introduces a monotonic timing harness and a counter comparison, where measured variation and clock choice become explicit. Passing state tests is a prerequisite for such a benchmark, not its result.
