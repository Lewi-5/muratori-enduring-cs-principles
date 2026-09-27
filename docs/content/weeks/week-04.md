---
prev:
  text: Week 3 · Numbers in a box
  link: /weeks/week-03
next:
  text: Week 5 · A validated scalar baseline
  link: /weeks/week-05
---

# Week 4 · Deterministic data and a reference processor

You send a colleague a seed and a command that generates a thousand points. They run the command, but their file differs from yours. Was the random-number generator different? Did the decimal separator change? Were latitude and longitude drawn in a different order?

A reproducible experiment needs more than the word “seed.” It needs a defined sequence of choices all the way from state updates to bytes on disk. This week builds that path, then reads the file back under an explicit grammar and processes it with checked numerical routines.

## Why this comes before measurement

Week 3 established a distance library and the limits of numerical agreement. Before timing a processor in Week 5, you need to know that the inputs are identical, that malformed input is rejected, and that the calculated result is worth timing.

E01–E03 construct a deterministic dataset. E04–E05 turn bytes into owned point objects. E06 processes those objects; E07 investigates the accumulation of many numerical contributions. Work in this order so each layer has a contract before the next depends on it. This week makes no performance claim.

You should finish able to explain why a seed produces particular file bytes, demonstrate exact rejection of malformed records, trace who owns each allocation, and compare accumulated results against a justified reference. Bring Week 1's file and allocation reasoning and Week 3's finite-input and distance contracts.

The core time estimate is ten hours for experienced C programmers using the supplied scaffolds. Readings, debugging, and report work all count. The expanded preparation is additional; record the time you actually need rather than treating the estimate as a deadline.

## Reproducibility is a chain of decisions

### A pseudorandom generator is a state machine

You press “next” and receive a number. Internally, a deterministic **pseudorandom number generator** changes its state by a fixed recurrence. The seed supplies the initial state. The same state and recurrence produce the same subsequent states.

That is useful for repeatable test data, but it is not evidence of unpredictability. The course generator is deliberately simple and is replaced later. Its unsigned arithmetic has defined wraparound; substituting a signed type would change the language rules.

To see modulo bias without enormous numbers, imagine eight equally likely inputs numbered 0–7 and map each with remainder modulo three. Residues 0 and 1 occur three times each; residue 2 occurs twice. Rejecting inputs 0 and 1 leaves six inputs, two for each residue. The exercise applies the same counting idea to the full raw range.

### A microdegree is an integer unit

You need exactly six decimal places in the file. A **microdegree** is one millionth of a degree, so the stored generation value `-5` means `-0.000005` degrees. Integer division and remainder can choose the exact digits without first approximating the value in binary floating point.

For example, the specified record `(id 7, latitude -5 microdegrees, longitude 10 microdegrees)` becomes:

```text
7,-0.000005,0.000010
```

The line contains 20 visible characters and one LF byte under the ASCII format. A C string holding that line also needs its terminating NUL, which is not written to the file. Keeping file bytes and string capacity separate prevents a common off-by-one error.

The file spelling is exact under the format. The parsed `double` is still generally an approximation to the decimal rational. Those statements do not contradict each other: they describe different representations.

### Sequencing matters even before threads

You call the generator twice inside one larger expression. If the order of those calls is not specified by C, the same two draws can be assigned to different coordinates. Separate statements establish the intended latitude-then-longitude order.

The file contract also specifies LF endings, the header, field spelling, and draw order. Byte identity is a consequence of the complete chain. A hash comparison checks the final artifact for one case; the explanation of the chain tells you why the implementation aims to repeat it.

## Parsing means recognizing a language

### A useful number can still be invalid input

You enter `1e2` and a general conversion function gives you 100. That does not make the spelling valid CSV v1. The **grammar** is the set of accepted forms; the **range** limits the values those forms may denote.

This distinction affects diagnostics. A latitude with too many integer digits can fail the grammar before range checking. A well-formed `91.000000` fails the latitude range. When several fields are wrong, the specified error order selects the first report, making behavior repeatable.

Think of a form with fixed fields. A box containing the right information in the wrong spelling can still be rejected by the agreed interchange rules. The analogy stops at leniency: a human clerk may infer intent, while this parser deliberately accepts only the declared grammar.

### Validate, then commit

You parse the identifier successfully and then find an invalid longitude. If you have already changed the caller's output object, it now contains a mixture of new and old data. Building a temporary result and publishing it only after all checks preserves the rejection contract.

The loader extends this principle across a file. It owns a stream and a growing array. An allocation failure must not erase the pointer needed to free the old array. A read error must not masquerade as normal end-of-file. Even a final close failure can invalidate an otherwise successful read.

```text
file bytes → bounded line → grammar and range checks → temporary point
temporary point → owned point array → validated processing → result
```

Every arrow has a possible failure. Knowing who owns each resource at that point is more useful than scattering cleanup calls until the happy path runs.

## A reference needs independent support

You compare the processor with another implementation and they agree. That is valuable when the second implementation takes a different route, but both still depend on some shared specification. The supplied oracle uses independent arithmetic and parsing logic; the distance reference uses a different formula. Known-answer fixtures and analytic reasoning add further checks.

Summation adds a new numerical issue. After a large partial sum, a small contribution can be rounded away. Pairwise and compensated methods change the route through additions. Compare their actual errors with references and bounds, keeping the required compiler flags. Do not turn a smaller observed error on one dataset into a universal ranking.

## Read and watch with a question

Watch the generator and processor material for the shape of the task, not for code to copy. The course's CSV and generator contracts are original. HH146 supplies the question behind E07: why might repeated accumulation drift differently from computing a quantity directly?

<!-- readings -->

## Tools and local workflow

```sh
cd week-04
make
make test
make CC=clang MODE=optimized test
```

The [shared types](/source/week-04/support/geolab_types.h) define the format-facing interface. The [reference distance](/source/week-04/support/reference_distance.h) supplies a different numerical witness. Read the [oracle](/source/week-04/tests/oracle.py) to understand what is checked independently; you are not being asked to write a second oracle.

Fixtures are byte-exact files. View them without re-saving them in an editor that may alter line endings. The tests intentionally distinguish LF, CR, NUL, an empty file, and a header-only file. Preserve those differences rather than “cleaning up” the data.

## Guided exercises

Keep the supplied drivers and named function interfaces. Record the E03 file-size prediction and E04 status predictions before running; they are part of the evidence, not optional decoration.

<!-- contract-intro -->
<!-- exercise:E01 -->
<!-- exercise:E02 -->
<!-- exercise:E03 -->
<!-- exercise:E04 -->
<!-- exercise:E05 -->
<!-- exercise:E06 -->
<!-- exercise:E07 -->

## Practice and stretch

<!-- practice -->

## Your notebook and the next question

You should now be able to hand a reviewer a seed, a count, a format contract, and a tested processor. Explain which results are required byte-for-byte and which require a numerical tolerance. A format promise and a machine observation belong in different columns of your claim ledger.

Week 5 asks how to time this work. Before proceeding, identify the pieces you would need to keep constant: input bytes, computation, output requirements, compiler policy, and the work included in the timed interval.

<!-- report -->
