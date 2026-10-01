# Prompt and artifact coverage

tests/inventory.py checks all29 stable prompt IDs and matching separate answers: E01.C–E05.Q, P01–P06 and S01–S02 in answers.md; R01–R05 in observations.md; W01–W03 in warmups.md with typed learner/reference C and exhaustive tests; F01–F03 in reading-answers.md. Beginner check-yourself answers are in warmups.md.

E01–E04 reference code is src/address.c,decode.c,execute.c,run.c; E05 has supplied driver/playground and hand-derived fixture plus independent Python trace oracle. S01 has extras/predicates.c; S02 asks a written design and receives a complete ownership, invalidation, preparation, execution and equivalence-testing design. Every output on the beginner page comes from checked-in docs/examples/week-09/flow.c. No exercise requires unfinished Week10 code.
