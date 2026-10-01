# Week 8 further reading · Stored bits and evidence from arithmetic

[Lesson](/weeks/week-08) · [Beginner section](/beginners/week-08)

## Start with the question in your trace

You see AX change while a flag word changes differently, and a CMP leaves AX alone. Begin by asking which values are stored and which facts the operation saves. Scott’s “The Comparator and Zero” introduces the gentlest version of that question. “The Clear Flags Instruction” helps you think of flags as persistent state, but Scott builds a different teaching processor. Do not import that instruction, its register organization or its initial-state rules into the 8086.

Beej’s Guide to C §14.1 explains the signed and unsigned interpretations of integer types. Chapter 24 explains the masks and shifts used for register views, and chapter 37 identifies the exact-width types used in our model. Read these while implementing E01; the guest’s aliasing rules come from the ISA, while C’s numeric operations provide a way to express them.

Beej’s C Library Reference §23.10 is a useful reference when reading the trace driver’s printf formats: the format string chooses a display, not the register’s meaning. Printing the word in hexadecimal does not decide whether a later comparison is signed. The library text supplies output-function contracts; it does not specify instruction effects or the meaning of any 8086 flag.

## From operations to condition codes

Dive Into Systems §7.3 shows modern x86 arithmetic through instructions and compiler output. Use it as a bridge from C calculations to architectural effects. The examples use modern registers and often source-before-destination AT&T syntax. Our decoder uses a historical operand table and destination-before-source canonical syntax, so copy the idea rather than the spellings.

CS:APP §2.3.2 derives two’s-complement addition. Work the byte 7F+01 example in both mathematical ranges before moving to §3.6.1, “Condition Codes.” Then read §3.6.2, “Accessing the Condition Codes,” as preparation for Week 9. This week records flags but does not implement the conditional-control mechanism shown there. The difficult point is that one arithmetic result supports both signed and unsigned comparisons; name the interpretation before choosing a predicate.

The CS 341 Coursebook’s §3.3.2, “C data types,” and §3.8, “Common Bugs,” are practical companions while you write the simulator. Use the type discussion to keep guest patterns distinct from host types and the bug discussion to review your implementation. A guest processor’s specified wraparound does not authorize undefined arithmetic in the host implementation. Its §2.4.3, “Undefined Behavior Sanitizer,” explains a useful check, but a clean sanitizer run does not prove the flags are correct.

## Read from gentle to deep

Read Scott’s comparator chapter, then Beej’s signed/unsigned and bitwise sections before the CE MOV episode. Implement register views and verify the preserved bytes. Watch the ADD/SUB/CMP episode with a table of operand patterns, result patterns and six flags. Consult the Intel instruction descriptions for every claimed flag effect.

Next read Dive Into Systems’ arithmetic section and the CS 341 host-language sections while testing your implementation. Read CS:APP’s addition and condition-code sections to explain mismatches in your predictions. Hennessy and Patterson §A.5 is the deepest rung: it places operations in an instruction-set design context. Use it after you have a working trace. It does not make the simulator’s step count a cycle estimate or describe the exact 8086 register/flag table we implement.

## Cross-reference

Both assigned CE entries are mapped below. The tables retain the verified titles and pages from the shared citation registry. The gaps distinguish gentle teaching-machine concepts, modern x86 examples and the exact historical semantics supplied by Intel. Copyrighted books remain citations to your own copies.

<!-- crossref -->

## Reading questions

<!-- reading-questions -->
