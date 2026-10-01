# Week 10 rubric

One graded assignment combines E01–E05 and R01–R05. Correctness and explanation determine the grade; there is no speed threshold. Beginner warm-ups and further-reading questions are ungraded; practice and stretch provide preparation.

| Criterion | Points | Evidence |
| --- | --- | --- |
| Stack word order and bounds | 20 | Little-endian bytes, reserve/read order, odd SP, exhaustion, untouched outputs |
| Decode and transfer rules | 20 | Signed rel16/rel8, correct next IP, CALL/RET targets, original PUSH SP and POP SP |
| State integrity | 20 | Flag preservation, INC/DEC CF, memory effects, atomic step and run failures |
| Program validation and CLI | 15 | Boundary map, instruction budget, empty input, golden trace, empty stdout on model failure |
| Written reasoning and evidence | 25 | Hand stack diagrams, lifetime repair, tool limitations, tests and actual workload |

Award alternative implementations full credit when they meet the public contract and explain their tradeoffs. A host pointer cast used as a guest address, undefined signed overflow, or an escaped tentative memory write requires correction before a correctness pass. An ordinary tested timing difference is neither required nor a failure. A trace without a prediction earns less explanatory credit than a complete hand derivation.
