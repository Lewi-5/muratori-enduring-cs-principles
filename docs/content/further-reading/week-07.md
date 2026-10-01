# Week 7 further reading · Addresses and compiled boundaries

[Lesson](/weeks/week-07) · [Beginner section](/beginners/week-07)

## Why these readings now

You can recognize a MOV but a bracketed operand makes its meaning less obvious. Start with a load/store explanation that separates the place from the value stored there. Then ask how C source files agree on the types used to describe that place. These two questions connect the decoder architecture to the library boundary.

The seven companion texts serve different jobs. Scott's *But How Do It Know?* gives the gentlest memory-operation picture without C. Beej's Guide to C chapter 17 then explains the multifile project you actually build. Beej's C Library Reference is useful when E03 needs the exact snprintf return convention: required visible characters exclude the terminating NUL. It does not cover the 8086 encoding or ELF loading. Consult its snprintf entry as a reference rather than reading the library guide end to end.

Dive Into Systems bridges the instruction and C-library viewpoints: §7.1 introduces x86 operands; §2.9.5 explains using libraries. Its modern x86 addressing examples are not the historical 8086 table. CS 341 §17.3 extends the compilation/linking explanation to the systems-programming workflow. Use it while recording E04's commands and distinguishing compiler errors, linker errors and load-time failures.

## An order from gentle to deep

Read Scott's load/store chapter before your first hand partition. Next read Beej chapter 17 and try compiling the separate client. Follow with Dive Into Systems' operand and library sections, then the CS 341 section while inspecting the build. Return to the Intel table whenever a book's explanation leaves you unsure which bits specify an 8086 address. No companion book replaces that exact table.

CS:APP §3.4.1 expresses operand locations as address formulas. Work one formula on paper, but leave modern scaled indexing out of our implementation. §§7.10–7.12 explain shared linking, explicit loading and PIC after you have a real library file to inspect. The difficult step is tracking which address or symbol is known at compile time, link time or load time. Name the stage before reasoning about it.

Hennessy and Patterson §§A.3 and K.3 provide the deepest architecture comparison. Use them after the decoder works to see addressing choices as instruction-set design decisions. Their discussion broadens the model; it does not enlarge this week's accepted opcode subset. There is no need to derive a performance ranking from their frequency or cost discussions here.

## Cross-reference

The generated tables give the registry's checked section titles and pages for each assigned CE or HH item. Online books are linked at section level; copyrighted books remain references to your own copy. The explicit gaps identify where our selected ISA manual or toolchain documentation must supply the mechanism.

<!-- crossref -->

## Reading questions

<!-- reading-questions -->
