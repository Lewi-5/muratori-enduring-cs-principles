---
prev:
  text: Week 4 · Deterministic data
  link: /weeks/week-04
next:
  text: Week 6 · Bytes to instructions
  link: /weeks/week-06
---

# Week 5 · A validated scalar geolab baseline

You run the processor twice and the second run is faster. You have changed no code. If one unchanged program can produce two durations, how should you compare two different builds?

This checkpoint treats measurement as an experiment. You first integrate a correct scalar program, then define exactly what is timed, record predictions, and preserve repeated observations. The deliverable is a trustworthy baseline for later optimization. A speedup is not required.

## What the first checkpoint joins together

Week 1 introduced explicit failures and a small timer. Week 2 supplied storage and interface reasoning. Week 3 supplied numerical contracts; Week 4 supplied reproducible datasets and a checked processor. Now those pieces become `geolab generate`, `geolab query`, and `geolab bench`.

The supplied headers, main program, option scanner, and output plumbing establish the scaffold. You implement the specified mechanisms behind those boundaries. Read the [checkpoint requirements](/materials/week-05/CHECKPOINT-1) before changing code so you know which CLI features are supported now and which are reserved for later work.

Your outcomes are a validated command-line program, a protocol another person can repeat, and a report that distinguishes a prediction from a measured result and a proposed explanation. **Scalar** means the baseline expresses work on individual values; it does not prove that a compiler generated only scalar machine instructions. Work through integration and correctness before the timing milestones.

The existing core estimate is ten hours for an experienced C programmer, with about 160 minutes assigned to viewing and reference consultation. It has not been learner-piloted. Do not drop correctness checks to make the clock match the estimate.

## A baseline begins with a precise answer

### The displayed number is not the ordering key

You see two query results that both print the same six-decimal distance. It is natural to call them tied. Internally, the distances may differ below the displayed precision. Sorting by the text would change the meaning of the query.

The result order is defined by the unrounded distance, then the identifier for an exact distance tie. `qsort` is not promised to be stable, but the comparator gives all observably distinct rows an explicit order. For a true coordinate tie, changing the identifier changes the secondary key. For a printed tie, the primary distances still decide.

`qsort` is C's library sorting function. You supply a **comparator**, a function reporting which of two records precedes the other or whether their ordering keys are equal. A **stable** sort preserves the original order of equal keys; this interface does not promise that property. The exercise therefore defines the keys rather than relying on input order to settle a visible tie.

This is Week 3's representation distinction again: a value and a selected display of that value are not interchangeable. Tests use fixtures that isolate both kinds of tie so one cannot accidentally stand in for the other.

### The command line is another interface

You pass `--threads 8` to the baseline and get an unsupported-feature response. That is different from a malformed number or a file-read error. A CLI contract includes accepted options, exit codes, output channels, and what is left behind on failure.

The CSV grammar remains canonical. The command-line grammar intentionally accepts some different spellings, including normalization of negative zero. Keep those policies separate instead of making one parser silently define both formats.

## Decide what the timer encloses

### One clock, three experiments

You time a whole command that reads a file, calculates distances, sorts hits, and prints them. The duration cannot tell you how much any one stage cost. The benchmark variants make the timed boundary explicit.

| Variant | Timed work | Interpretation limit |
| --- | --- | --- |
| `parse` | Loading, allocation, parsing, and close | Includes input and resource-management costs |
| `distance` | The distance loop and prescribed accumulation | Does not include loading or presentation |
| `query` | The complete query operation | Includes the query's allocation and ordering work |

Initialization, warm-up, checksum calculation, and reporting follow the prescribed placement. Moving one operation across the timer changes the question, even if the executable still prints a duration.

`CLOCK_MONOTONIC` supplies elapsed-time readings under the POSIX/Linux contract. It is not a processor cycle counter. A nominal CPU frequency can support a labelled estimate of cycles; frequency changes and scheduling prevent treating that conversion as a direct measurement.

### Results must remain meaningful

You might make a benchmark dramatically faster by accidentally skipping the work. The exercise validates results and compares repetition checksums. This catches changes in results, but a checksum has collisions and does not prove that every imagined source operation survived compilation.

That limit matters. The compiler may legally transform computations while preserving observable behavior. Later weeks inspect elimination and vectorization directly. For now, state what the harness checks and avoid claiming more.

## Variation is data

### Keep the raw samples

Suppose five durations are 10, 11, 12, 13, and 100 units. Their median is 12 and their mean is 29.2. The example is arithmetic illustration, not a course timing measurement. It shows why one long interruption can move the mean much more than the middle sample.

The minimum, median, maximum, and spread answer different questions. None licenses deleting inconvenient observations without a declared rule. Within-process repetition variation and variation between fresh process runs should both remain visible.

### Write the protocol before seeing the outcome

You alternate builds instead of timing every run of one build before every run of the other. This makes a gradual environmental change less likely to align completely with one build. You also choose a stopping rule in advance, avoiding a search for the first pleasing comparison.

Warm-up may affect caches, pages, and other mechanisms. At this stage those are plausible explanations, not causes established by this experiment. WSL, background activity, and different core types can contribute variation. Naming a possible cause is the start of a new test, not the end of the analysis.

## Read and watch with a question

The SIMD and caching episodes preview mechanisms you will investigate later. Use them to ask better questions about the scalar baseline, not to claim those mechanisms caused a timing result. HH010 and HH112–113 help you turn units and rough cost assumptions into a prediction.

<!-- readings -->

## Tools and experiment order

```sh
cd week-05
make
make test
make symbols
```

After implementing and validating the program, complete the learner protocol and record the E06 predictions. Only then run:

```sh
make bench-data
make checkpoint
```

The [monotonic clock helper](/source/week-05/support/monotonic.h) checks time conversion, while [environment reporting](/source/week-05/support/envinfo.c) describes the actual build. The [benchmark runner](/source/week-05/tools/bench_data.py) collects the prescribed outputs. Read their responsibilities so supplied infrastructure does not become unexplained magic.

Do not copy the instructor report's numbers into your observation table. Those are historical runs on its recorded machine. Your report must preserve your own dataset identities, commands, raw outputs, and compiler information.

## Guided exercises

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

## Your report and the next question

If two ranges of process-run medians overlap, report no clear separation under the course rule. If they do not overlap, describe the separation in these runs without calling it a significance test or assigning a cause. A reader should be able to distinguish your prediction, measurement, and explanation without guessing which sentence belongs to which.

Week 6 begins opening the machine-instruction layer. The 8086 decoder is deliberately small enough to reason about by hand. It develops the habit of reading encodings before later weeks return to the modern instruction stream generated for your baseline.

<!-- report -->
