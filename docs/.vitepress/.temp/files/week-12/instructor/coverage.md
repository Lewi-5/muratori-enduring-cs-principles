# Prompt and artifact coverage

tests/inventory.py checks all 29 prompt IDs and matching answers. E01.C–E05.Q, P01–P06 and S01–S02 are in answers.md; R01–R05 in observations.md; W01–W03 in warmups.md with typed learner/reference C and exhaustive tests; F01–F03 in reading-answers.md. Beginner check-yourself answers are in warmups.md.

E01–E04 reference modules are prepare/execute/run/trace.c. E05 has CHECKPOINT-2.md, supplied drivers, three original hand-derived fixtures, independent Python combined traces, real inspection tooling and instructor/report.md. Both written stretches have complete designs/protocols; neither asks for an unprovided C implementation or fabricated timing. Every displayed beginner output is generated from docs/examples/week-12/evidence.c and checked by tests/snippets.py.
