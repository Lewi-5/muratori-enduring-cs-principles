# Week 10 further reading · A saved continuation and a live object

[Lesson](/weeks/week-10) · [Beginner section](/beginners/week-10)

You see a return word survive POP and want to connect that observation to a C function. Read in two passes: first the saved-continuation mechanism, then the language-lifetime rules. They meet in compiled programs, but one cannot substitute for the other. Allow optional additional reading time beyond the unpiloted ten-hour core estimate; choose the depth appropriate to the question you are trying to answer.

Start with J. Clark Scott's *But How Do It Know?*, “The Load and Store Instructions” (PDF p. 98) and “Another Way to Jump” (PDF p. 105). Look for a data address versus a code continuation. Its simple machine makes those roles accessible, but does not define 8086 near-call encodings or a C stack frame. Follow with Beej's §13 “Scope” and §16.2 “Storage-Class Specifiers”: identify where a name is visible and how its object's lifetime is determined. The difficult part is resisting the shorthand that every local “is a stack value.” C makes no such universal placement promise.

Use Beej's *C Library Reference* §26.1 for memcpy/memmove when thinking about transaction copies. It explains host buffer operations; it does not implement a guest PUSH or validate a return address. Do not transplant a host word representation into guest memory just because copying bytes is convenient. Assignment to the whole Machine or a well-specified buffer copy is a rollback implementation detail, while guest byte order is an ISA rule.

Next use *Dive Into Systems* §2.1 for program memory and §7.5 for functions in assembly. These bridge source-level blocks to real call instructions and frames. Keep a separate column for x64 details: register names, word size and argument conventions differ from this week's sixteen-bit subset. Read the UIUC *CS 341 Coursebook* §3.8.3 alongside the automatic-local example. It gives a direct reason returning a local address fails. A program that appears to print the expected value after return has not established a valid lifetime; do not make that undefined execution a required experiment.

Then turn to CS:APP 3e §§3.7.1–3.7.2: follow the stack before CALL, at the callee and after RET. These chapters add the machinery needed for Week 11, but use their own x64 ABI context. Their diagrams are a way to reason about generated programs, not a requirement that every C local occupy a drawn slot. If the convention details feel dense, finish the three warm-ups and the hand fixture first, then return with one concrete register-preservation question.

Finally, Hennessy and Patterson 6e Appendix A.6 places control transfers among ISA design choices. Read it after you can explain a single return word. It is the deeper comparison, not the source for our exact PUSH SP quirk or deterministic transaction policy. No companion fully specifies this model's bounded stack errors, immutable separate code, all-boundary validation or budget: those are original teaching contracts. Intel is the primary reference for the instruction-specific historical difference. The cross-reference below names these gaps explicitly rather than claiming every book covers the whole mechanism.

## Cross-reference

<!-- crossref -->

## Reading questions

<!-- reading-questions -->
