# Instructor materials — spoilers

This package contains:

- **[src](src):** annotated reference C for every exercise.
- **[answers.md](answers.md):** the written answer key for all fourteen exercise prompts, six practice problems and both stretch exercises.
- **[observations.md](observations.md):** an exemplar notebook.
- **[cases.txt](cases.txt):** twelve exemplar E07 cases.
- **Extras:** [extras/s01_jumps.c](extras/s01_jumps.c) implements S01 and [extras/s02_table.c](extras/s02_table.c) implements S02, a table decoder checked over the full input domain. [extras/mutate.py](extras/mutate.py) is the mutation check.
- **[coverage.md](coverage.md)** maps all 27 prompt IDs.
- **[validation.md](validation.md)** records the entry-by-entry check of the course table against the 1979 manual (with table and page numbers) and the execution evidence.

```sh
make PACKAGE=instructor test
make PACKAGE=instructor CC=clang MODE=sanitize test
make verify
make mutate          # a few minutes; run it from a copy outside OneDrive
```

**How the tests work.** Python orchestrates; the decoder under test is C.

- **Supplied oracle.** [tests/oracle8086.py](../tests/oracle8086.py) builds expected text only in the encoding direction and classifies failures from a separate rule table. It writes four files:
  - the ModR/M field table;
  - every encoding plus every two-byte prefix with 0–2 trailing bytes (224,962 lines);
  - the operand fields of every text;
  - the listing expectations.
- **Contract suites.** Six C suites in [tests/contracts.c](../tests/contracts.c) include each source with `main` renamed. E06 includes `decode.c` and `decode8086.c`, with `fgetc`, `ferror` and `fclose` failures injected into `read_input` only.
- **Checks through the binaries.** [tests/check.py](../tests/check.py) also checks the drivers, the `decode8086` command contract (including `/dev/full`), the `objdump` cross-check of all 28,098 encodings (gated on `i8086` support), the package's E07 cases through [tests/run_cases.py](../tests/run_cases.py), the exported symbols and, for the instructor package, S01 and S02.
- **Listings.** [tools/make_listings.py](../tools/make_listings.py) regenerates the supplied listings from the oracle; the test fails if a committed listing differs.

**What learners write.** The scaffolds contain the types, the header, the drivers, the `decode8086` argument handling and printing, and TODO bodies for:

- `split_modrm`, `bit_at`, `reg_name`, `read_imm`, `to_signed` and `sign_extend8`;
- `decode_one` and `format_instruction`;
- `decode_stream` and `read_input`.

Learners copy their helpers forward, keeping the copies non-static until `decode.c`, where they become `static`.

**Grading.** Grade the hand decodings for the fields shown, not only the final text. A learner who writes `add bx, 0xfff6` understood the bits but not the canonical format; half credit. Accept learner cases that differ from the exemplar if each reason names a distinct failure. The course's rejection of `0x82` is a scope decision, and a learner who notes that the manual lists it deserves credit, not a deduction.

Passing the inventory proves structural coverage, not teaching quality. The time budget is unpiloted; see the pilot procedure in [PLAN.md](../PLAN.md).
