# Week 07 implementation specification

**Parent:** [52-week syllabus](../PLAN.md). **Status:** implemented; actual checks and limitations are recorded in [validation](instructor/validation.md). Core ten-hour estimate and beginner 2–4-hour estimate are unpiloted.

## Continuity and scope

Week 6 rejected mod != 3 before reading displacements. Week 7 replaces that deliberate boundary with a typed memory operand and a shared-library API. Preserve all old accepted families and conventions. Add memory modes, C6/C7 /0 and A0–A3 as described in [the guide](README.md). Segment overrides remain outside this week's required subset; teach default segments conceptually without implying that a displacement alone is a physical address. No simulation, flags, branches or timing claims.

## Acceptance contract

- Public header documents every argument, validity domain, status order, ownership, unchanged-output rule, overlap restriction and ABI/version boundary. C source modules include that header.
- E01 decodes address tails independently of opcode and width. Direct addresses are unsigned; displacement sign uses wider arithmetic.
- E02 supports the exact opcode families and all four ModR/M modes. Unsupported group operation is determined before displacement availability. Missing opcode/ModR/M/address/immediate bytes produce ordered failures. Check every read before indexing; commit Instruction only on success.
- E03 validates operand combinations and formats via scratch storage. Reject memory-to-memory, invalid widths, bad indexes and out-of-range signed fields. Canonical zero displacements need not preserve encoded length.
- E04 builds a PIC shared object, limits exported names and calls it from a separately compiled C client using a relative loader search path. No instructor source is substituted in the learner build.
- E05 retains the whole-stream transaction, input cap, failure offset and file-error behavior. Learners supply five purposeful hand-derived cases, including failure boundaries, and a complete notebook.
- Provide six practice problems, two stretch exercises with executable C examples or complete derivations, five report prompts, three typed warm-ups with solutions and tests, and three reading questions. Match all prompt IDs to substantive separate answers.
- Beginner prose follows [WRITINGFORBEGINNERS](../WRITINGFORBEGINNERS.md) and the fixed eight-section shape. Every displayed concrete output has a checked-in standalone snippet and automated comparison.
- Further reading introduces the seven companion texts in order, uses the existing verified citation registry, maps every assigned CE/HH entry and states encoding gaps.
- Correctness includes independent encoding-direction expectations, all address/mode/register/direction/width combinations, sign boundaries, every proper prefix of representative instructions, output preservation, CLI failures, shared exports and an actual shared client.
- Verify GCC and Clang in debug, optimized and address/undefined sanitizer modes. Learner scaffolds compile under strict warnings and fail unfinished correctness gates. Documentation generation, answer coverage, snippets and production links pass.

## Package boundaries

Public types live in include/decode.h. support/address.h is an internal exercise interface; the exports map keeps it out of the dynamic symbol table. address.c owns address tails; decode.c owns form selection; format.c owns syntax; stream.c owns whole-stream output; decode8086.c owns files and diagnostics. client.c uses only the public API. Supplied stream and CLI derive from the tested Week 6 reference so the learner can focus on this week's changes.

Version 7 announces an incompatible Operand layout. It does not make an arbitrary external header safe. A dynamically linked client is the required build; optional dlopen shows a different loading point. Correctness tests use this course's independent oracle; the CE reference decoder is a viewing reference and is not vendored or required to run our tests.
