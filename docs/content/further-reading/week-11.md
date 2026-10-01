# Week 11 further reading · Separate the four contracts

[Lesson](/weeks/week-11) · [Beginner section](/beginners/week-11)

You see a register move, a stack slot and a return in one listing. Ask four separate questions: what the instruction means, what the ABI requires, what this compiler chose, and what the processor might speculate or spend time doing. Read in that order, with the source signature beside you. Optional deeper reading adds time beyond the unpiloted ten-hour core budget.

Start with Scott's *But How Do It Know?*, “Instructions” and “Another Way to Jump.” It offers a gentle distinction between an operation and a code destination. Its teaching machine is not AMD64 and supplies no System V register table. Then use Beej's multifile-project section and pointers-to-functions section. Locate a declaration shared by caller and callee, and explain why a callback signature must match. Syntax can be the difficult part here; follow keep_across_call with a single callback before reading a long disassembly.

Beej's *C Library Reference* qsort section explains the comparator callback contract used by the real query routine. It settles the function's semantic obligation, not where its two arguments arrive on this machine. Use the ABI for that boundary. *Dive Into Systems* §2.9.7 explains generating/assembling code and §7.5 connects calls to frames. This is the bridge into tool output: compiler text retains symbolic operands, while object disassembly needs relocation information. Do not infer a resolved target from an unlinked CALL's placeholder bytes.

Read the UIUC *CS 341 Coursebook* lifetime bug section as a counterweight to physical frame diagrams. A compiler may remove an automatic local's storage while preserving its result; unchanged old memory cannot make a returned local pointer valid. The coursebook is useful for language/ownership reasoning, but does not supply the entire AMD64 classification algorithm or return-predictor details.

Now read CS:APP 3e §§3.7.3–3.7.5 for data transfer and local storage in stack or registers. Annotate a real geolab boundary and the seed kept across an indirect call. The difficulty is distinguishing the example compiler's particular register choice from the ABI's restoration requirement. Revisit §§3.7.1–3.7.2 if the entry/prologue offset difference remains unclear.

Finally use Hennessy and Patterson 6e Appendix K.3 for the x86 lineage and Appendix C.1 for pipeline reasoning, then §3.3 for branch costs. These deeper sections explain why a modern performance question involves dependencies, speculation and resources. They cannot give one universal cycle value for this C function. Intel's primary optimization discussion supplies a processor-specific return-prediction account; our simulator and ABI planner do not model it. No companion defines this original restricted planner, manifest format or learner error transaction. Those contracts live in lab.h, and the full ABI includes aggregate/variadic cases this week's planner explicitly omits.

## Cross-reference

<!-- crossref -->

## Reading questions

<!-- reading-questions -->
