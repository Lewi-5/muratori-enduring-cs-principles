# Week 11 implementation specification

Parent: [course plan](../PLAN.md). Status: implemented; [validation](instructor/validation.md) records evidence. Workload remains unpiloted.

Compare completed geolab functions at O0/O2 under System V AMD64 LP64, preserving C behavior and independent compiler artifacts. Teach GP/SSE scalar argument classes, pointer outputs versus return registers, register ownership, entry versus post-prologue offsets, alignment, indirect calls, optimized-away locals, object relocations and return prediction versus architectural data.

Deliver four typed learner C modules, five paired core exercises, six practice, two stretch, five report prompts, three warm-ups and three reading questions with full separate code/written solutions. Supply at most one 10–20-line handwritten assembly probe (this package has one 16-line probe), all other substantial code in C, deterministic behavioral tests, exact checked beginner output, seven-text cross-reference and six reference configurations. Do not test a universal compiler listing, predictor size or speedup. The planner is deliberately restricted and must not claim aggregate/variadic ABI support.
