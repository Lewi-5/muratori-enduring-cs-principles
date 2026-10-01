# Week 08 implementation specification

**Parent:** [52-week syllabus](../PLAN.md). **Status:** implemented; actual evidence is recorded in [validation](instructor/validation.md). Workload estimates remain unpiloted.

## Continuity

Week 7 produces instruction descriptions and a documented decoder API. Week 8 consumes that unchanged revision through a pinned prerequisite decoder. A new simulator API introduces word register state, byte aliases, arithmetic results and flags. It executes only register/immediate operands. Week 9 owns jumps, memory and effective addresses; no host pointer is a guest address.

## Acceptance requirements

- Keep the eight-word bank and byte aliases consistent with the 8086. Read operands before writing any alias. Byte writes preserve the other half and unrelated words.
- Implement ADD, SUB and CMP at eight and sixteen bits with defined host arithmetic. Track CF/PF/AF/ZF/SF/OF exactly; parity uses only the low byte. Preserve opaque flag bits and MOV flags. CMP never stores the subtraction result.
- Validate API arguments, decoded operand fields, widths, immediate ranges and length metadata. Unsupported valid memory operands differ from malformed objects and byte-decode errors. A step failure preserves all state.
- Advance guest IP modulo 65536, while the file cursor uses size_t and stays inside the input. Program execution has a whole-stream commit boundary. Returned error offset/step count describe tentative execution without leaking a partial state.
- Supply warning-clean typed learner stubs, a C playground, deterministic CLI trace driver, golden fixtures, complete annotated reference C, explanations for five core exercises, six practice problems, two stretch exercises and five report prompts. Three beginner warm-ups and three reading questions have separate complete answers.
- The beginner page follows WRITINGFORBEGINNERS.md and its eight-section shape. Every shown concrete output has a checked-in standalone snippet and compiler/output comparison. Further reading covers both assigned CE entries and all seven companion texts, with exact registry citations and explicit differences from the historical ISA.
- Test all byte operand pairs for three arithmetic operations with an independent mathematical oracle; word boundaries and deterministic samples; byte aliases and register combinations; signed/unsigned edge cases; 83 sign extension; full traces; MOV/CMP rules; invalid arguments; late rollback; IP wrap; and CLI errors.
- Run GCC and Clang under strict conversion warnings in debug, optimized and address/undefined sanitizer modes. Learner stubs compile cleanly but fail correctness gates. Production documentation, snippet checks, reading coverage and stable prompt IDs pass.

The simulator is an ISA teaching model, not a modern processor model or a claim about hardware reset state. No speed or cycle requirement applies. Reference-decoder comparisons are optional diagnostic evidence; their output establishes instruction descriptions rather than simulated flags.
