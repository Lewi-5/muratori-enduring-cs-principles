# Week 10 implementation specification

Parent: [course plan](../PLAN.md). Status: implemented; see [validation](instructor/validation.md). Workload estimates are unpiloted.

Implement register PUSH/POP, near relative CALL and plain RET in C, using explicit guest bytes rather than host recursion or a second hidden return stack. Include INC/DEC, NOP and bounded branches to support original real-program fixtures. Preserve completed decoder/register/ALU prerequisites in an independent snapshot while Weeks 9–11 are authored concurrently.

Require defined unsigned guest-width arithmetic; signed displacement decoding without implementation-defined narrowing; original 8086 PUSH SP behavior; POP SP final-write behavior; odd addresses; boundary validation; budgeted execution; atomic step and whole-program rollback including data memory. Explain every course restriction separately from the historical ISA and C language rules.

Deliver five core exercises, six practice prompts, two stretch prompts, five notebook prompts, three typed beginner warm-ups and three reading questions, with matching complete written solutions and working C reference code. Include a beginner page, checked output snippet, seven-text reading cross-reference, deterministic nested trace, invalid transfer/stack tests, independent arithmetic expectations, six GCC/Clang configurations and meaningful starter failures. No universal timing or speed requirement applies.
