# Notebook — 8086 subset decoder

Keep **prediction**, **observation** and **explanation** separate. Record predictions before running anything; do not edit them afterwards.

### R01

**Build environment.** Record:

- your compilers and their versions;
- binutils (`objdump --version`) and Python;
- the flags you used for debug, optimized and sanitizer builds;
- whether `objdump` supports `-m i8086` on your machine.

### R02

**Prediction, observation, explanation.** Give one row for each of E01–E07. Record *before running*:

- the E07 hand decodings of the five supplied sequences, showing every field;
- your E05 prediction of the longest canonical text and its length.

Then record what the tests and drivers showed, and explain every difference between prediction and observation.

### R03

**Claim ledger.** At least eight statements, each labelled as one of: C11, implementation-defined, 8086 ISA (manual, with table and page), x86-64 ISA (Intel SDM), toolchain (`objdump`), oracle, or observed on this machine.

### R04

**Three witnesses.** Pick three byte sequences and compare what your decoder, the supplied oracle and `objdump` say about each. Include at least one where `objdump`'s text differs from the canonical text, and explain why the difference is a convention rather than an error.

### R05

**Defense and handoff.** Give:

- the submission inventory (source files, `cases.txt`, test output, this notebook);
- one durable source → mechanism → observation defense, from a C expression in your decoder to the bits it reads;
- one open question for week 7 (for example, how the decoder should learn the length of an instruction with a memory operand).
