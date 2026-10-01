# Completed prerequisites and comparison subjects

decoder and alu are completed Week 7/8 snapshots. machine/decode.c and stack.c are the Week 10 completed decoder and stack helpers. Their source is unchanged; include/machine.h extends the common status list with M_CAPACITY and directs new execution through project.h.

oracle/execute.c and run.c are pinned Week 10 comparison implementations. They are linked only into the contract harness, never learner or production executables. A comparison against these shares helpers and reasoning, so it is supplemented by mathematical cases and hand-derived traces rather than claimed as an independent hardware oracle.

geolab supplies the Week 5 geo/query implementation already pinned in Week 11. compare.c is an original defined-C comparison subject, not a simulator solution. All simulator and substantial assignment software remains C; no new handwritten assembly is introduced.
