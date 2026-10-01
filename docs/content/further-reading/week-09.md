# Week 9 further reading · A chosen instruction and an addressed byte

[Lesson](/weeks/week-09) · [Beginner section](/beginners/week-09)

You have a branch that returns to earlier bytes and a memory expression that names stored data. It is tempting to treat both as “moving to an address.” Read with two questions beside you: which number selects the next instruction, and which number selects the data an instruction reads? Keeping those roles separate makes the guest model easier to audit and prevents host pointer rules from slipping into guest arithmetic.

The required CE items introduce conditional transfer and memory access. Watch them in the lesson's viewing schedule first, then use this page to choose depth. The seven companion texts explain different layers rather than duplicating one authoritative emulator specification. Additional reading is optional time beyond the unpiloted ten-hour core; return to the warm-ups whenever notation becomes an obstacle.

## Start with a next instruction

You reach the bottom of a loop and need to know whether it repeats. Begin with J. Clark Scott's *But How Do It Know?*, “The Second Great Invention,” “Another Way to Jump” and “The Third Great Invention.” The verified cross-reference below gives exact PDF page locations. Look for the transition from instructions that advance in order to a next position chosen by a condition. This small teaching machine makes the need for jumps tangible without beginning with an x86 opcode chart.

Ask what comparison information survives until the jump reads it. Then use “The Comparator and Zero” if flags still feel like unexplained bits. Scott's machine has its own instruction set, so its diagrams are an introduction to the role of control flow. They do not specify the 8086's sixteen predicates, displacement widths or original byte encoding. Use the Intel instruction reference for those shared x86 semantics and the course header for the accepted subset.

## Keep C storage rules beside the guest array

You can draw a valid sixteen-bit guest address and still write an invalid C access. Read Beej's *Guide to C Programming* §6.4 “Out of Bounds!” and §14.1 “Signed and Unsigned Integers,” followed by §24.2 on shifts and §37 on fixed-width types. Your concrete task is to explain why offset FFFF is legal while a host word-shaped access starting at the last array byte is not. Numeric wrap and actual object extent are different rules.

The difficult point is that a C conversion and a guest signed interpretation need not be the same operation. Converting a negative integer to an unsigned type has a defined modulo result; converting an out-of-range unsigned pattern to a signed type can depend on the implementation. Our displacement decoder instead subtracts the appropriate modulus in int32_t. Read with W01 open and name the representable values at each stage, rather than guessing that a cast means “reinterpret these bits.”

Beej's *C Library Reference* §26.1, covering memcpy and memmove, helps when you reason about copying state for a transaction. A host buffer copy has source, destination and overlap requirements. It does not define little-endian guest words. A whole Machine assignment or correct byte copy can implement rollback, while a guest load still has to assemble separately indexed bytes in guest order. If you use memcpy elsewhere, retain the distinction between copying storage and assigning a numeric meaning to it.

## Connect a condition to a source loop

You recognize a C countdown, then see comparison and jump instructions instead of a `while` keyword. Use *Dive Into Systems* §7.4.1 “Preliminaries” and §7.4.3 “Loops” to connect source control structures to transfers. Write a two-column trace: value of the loop variable and next instruction position. The fixture's SUB CX,1 followed by JNE is a concrete case: the branch consumes the flags from the immediately preceding subtraction.

These chapters use x86-64 examples, so keep their wider registers and instruction spellings in a separate column. The common mechanism is a condition controlling a next fetch, not a requirement that an 8086 use the same encodings or address size. Finish the hand fixture before studying alternative loop arrangements; otherwise differences in compiler layout can distract from the state transition you are trying to understand.

The UIUC *CS 341 Coursebook* §§3.7.1–3.7.2 supplies the host pointer counterpart. Ask which actual C object a pointer can access and how arithmetic stays within that object. Read §3.8 “Common Bugs” alongside a wrapping-word test. A numeric guest address is not a pointer into the host process's virtual address space. Our array indexing is the explicit bridge. CS 341's later virtual-memory chapter is a different layer and is not needed to invent segmentation for this week.

## Derive the predicates before memorizing names

You compare byte patterns 80 and 01 and find that JB and JL disagree. CS:APP 3e §§3.6.1–3.6.3 provides condition codes and jump rules, while §3.6.7 shows loops built from them. Work through both mathematical interpretations: unsigned 128 versus 1, then signed -128 versus 1. Carry answers the first comparison; sign combined with overflow answers the second. Writing those questions first makes the flag formulas explainable rather than a collection of mnemonics.

The hard step is overflow correction. The stored subtraction result is 7F, whose sign bit is clear, but signed -129 is outside the byte range. Overflow tells the signed predicate that the result's stored sign is misleading. JL therefore uses SF different from OF. Reproduce this one example before proceeding to inclusive comparisons, which add the zero condition. CS:APP's modern context helps with reasoning but is not the authority for our code-length cap or failure status names.

## Compare instruction-set choices last

You can now explain one branch and one memory operand. Hennessy and Patterson 6e Appendix A.3 “Memory Addressing” and A.6 “Instructions for Control Flow” gives a broader comparison of how instruction sets express these operations. Look for the separation between an addressing mode's calculation and the control instruction's target selection. Read this after the worked examples; the taxonomy is useful once you have a concrete expression to place within it.

These appendices do not make every valid ISA address a valid host pointer, and they do not define our transactions. Full predecode, checked instruction boundaries, separate immutable code, halt at code length and a finite step budget are original course choices. Real machines can decode at different byte positions, use segments and fault under different rules. Name those gaps in your report instead of using a successful trace as proof of full hardware emulation.

## Cross-reference

Each required CE item below is tied to the matching mechanisms in the seven companions. Follow gentle-to-deep order and retain the stated gaps. Citations and page numbers come from the verified reading registry; no subscription transcript is reproduced.

<!-- crossref -->

## Reading questions

Write a concrete calculation and a portability/model limit for each answer, then compare the separate instructor key.

<!-- reading-questions -->
