# Instructor materials — spoilers

Reference C is in src; the learner build never uses these files. [Answers](answers.md) cover all exercise, practice and stretch prompts. [Notebook](observations.md), [warm-ups](warmups.md) and [reading answers](reading-answers.md) complete the written coverage. [Validation](validation.md) records actual checks and [coverage](coverage.md) states their limits.

```sh
make verify
make PACKAGE=instructor symbols
```

tests/oracle.py creates bytes from independently chosen semantic fields. It is not a copy of the decoder. Golden text and the four-case playground make failures readable; contracts.c checks transactional failures. Learner stubs compile cleanly and intentionally fail correctness gates. Use the same public header across clients and library. This week changes the Operand layout from Week 6 and makes no binary compatibility promise with it.

Optional reference probes in extras demonstrate equivalent encodings and explicit POSIX loading. They are not required to build the learner solution; compile instructions are at the top of each file.
