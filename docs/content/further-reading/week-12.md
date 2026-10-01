# Week 12 further reading · Audit the model and qualify the claim

[Lesson](/weeks/week-12) · [Beginner section](/beginners/week-12)

You have a complete trace and want to say “the simulator works.” Read with a narrower question: which specification, which tested states and which kind of evidence support that statement? Project 2 is a chance to make those answers explicit before the course begins measuring performance.

Watch the required CE code review and selected HH Chat 011 portions in the lesson schedule. The package is an original bounded subset with its own contracts, so reviewing another implementation should reveal questions and design choices rather than silently enlarge your assignment. Further reading is optional additional time beyond the unpiloted core budget. Work gentle to deep, returning to a fixture whenever a taxonomy becomes too abstract.

## Start with stored instructions and observable state

You recognize a source loop, then see its instruction pointer repeat byte positions. J. Clark Scott's *But How Do It Know?*, “Hardware and Software” and “Step by Step,” gives an accessible account of instructions, stored values and their changing state. Ask what a small CPU needs to complete the next instruction and how that differs from the program's intended higher-level task.

The hard step is resisting an overly broad analogy. Scott's teaching machine is not the 8086, and a drawing of control and data paths does not establish x64 cycle costs. Use its explanation to identify the architectural ingredients, then annotate which of them your trace actually records. Our prepared map, transactions and boundary rejection are course API policies rather than universal machine behavior.

## Read the implementing language as a separate contract

You want byte arithmetic to wrap and a borrowed CodeImage to remain usable. Beej's *Guide to C Programming* §14.1, “Signed and Unsigned Integers,” §24, “Bitwise Operations,” and §37, “Fixed Width Integer Types,” provides the host-C tools. Keep one actual calculation beside the text: byte 255+1 represented by a wider unsigned sum, mask and separately derived carry. A guest effect does not justify an invalid host arithmetic shortcut.

Use §6.4, “Out of Bounds!,” and §16.2, “Storage-Class Specifiers,” when checking wrapping bytes and borrowed code lifetime. The difficult distinction is numerical guest position versus actual accessible C storage. Masking the second guest offset keeps each byte access in the array; it does not allow reading memory[65536]. An old boundary table similarly cannot make a dead automatic byte array live again.

Beej's *C Library Reference* §26.1 covers memcpy/memmove and their storage/overlap rules. Read it while inspecting complete-state copies and disjoint trace outputs. A host buffer copy can preserve a snapshot, but it does not assign little-endian meaning to a guest word or establish a decoded boundary. Keep copying, decoding and interpreting numeric values as separate operations. The public header states the caller's disjoint-storage obligations.

HH Chat 011 revisits the gap between an intuitive hardware effect and the language specification. The assigned conversion and specification portions are a prompt for your reasoning, not an alternative authority to C11. State the exact host operation and the representable range before relying on wrap. The local primary-reference sections identify which conversions are defined and which object/lifetime rules still apply.

## Make diagnostics useful evidence

You pass a sanitizer and wonder whether that proves the whole model is valid. The UIUC *CS 341 Coursebook* §2.4.3, “Undefined Behavior Sanitizer,” and §3.8, “Common Bugs,” makes diagnostics concrete. Look for errors an instrumented run can catch, then name cases it did not exercise and ownership assumptions it cannot validate for you.

Record commands, tool versions and successful/failing cases rather than saying a tool “proved” correctness. A separate expected-value calculation is valuable when two implementations share helpers. The predecessor comparison checks regression behavior; hand-derived stack/word fixtures and mathematical flag cases supply different evidence. CS 341's lifetime discussion also helps when an optimized local has no storage slot: language lifetime and compiler layout remain different questions.

## Bridge from a state model to modern execution

You know the next register value but cannot infer how long it takes. *Dive Into Systems* §5.9, “Looking Ahead: CPUs Today,” is the accessible transition to modern mechanisms. Use §7.5 for the function/stack counterpart to your x64 comparison. Follow the architectural return word first, then ask which mechanisms a modern CPU may use to predict and overlap work. Those mechanisms are absent from the guest Machine.

Next read CS:APP 3e §4.4, “General Principles of Pipelining,” and §5.7, “Understanding Modern Processors.” The difficult step is that dependency and resource overlap make a static instruction count an incomplete cost description. Your trace preserves a sequential architectural account; a pipeline can arrange internal work differently while preserving required results. Read with one source/listing example rather than trying to assign a universal cost to every mnemonic.

For the ABI comparison, revisit CS:APP §§3.7.2–3.7.5 as needed: calls, data transfer and local storage. An optimized tail transfer can use a caller's existing continuation, and an optimized arithmetic local can lose its dedicated slot. Your compiler manifest and relocation records document the particular observation. The identified System V primary reference governs the scalar boundary, not the textbook's example register choices.

## End with the deeper taxonomy

You can now distinguish instruction effects from internal scheduling. Hennessy and Patterson 6e Appendix C.1, “Introduction,” and §3.1, “Instruction-Level Parallelism: Concepts and Challenges,” supplies a deeper framework for overlapping work and its limits. Appendix A.5 and A.6 keeps operations and control-flow choices tied to instruction-set design. Read after the concrete comparison, so each category answers a question already raised by your program.

These sections do not specify our immutable-code lifetime, 1024-record CLI capacity, finite budget, halt convention, stack window or transaction precedence. They also cannot derive modern predictor success from a correct guest return trace. The checkpoint report should name these gaps and hand off timing questions to Week 13's measurement protocol. A correct simulator remains useful precisely because its claims can be limited to the contract and evidence you can inspect.

## Cross-reference

Both assigned Muratori items are mapped below across the seven companions, gentle to deep. Verified registry citations supply section titles and page references. Each mapping states the remaining gaps instead of treating every text as an emulator specification.

<!-- crossref -->

## Reading questions

Give a concrete operation, the evidence that checks it, and a language/model limit before comparing the separate answer key.

<!-- reading-questions -->
