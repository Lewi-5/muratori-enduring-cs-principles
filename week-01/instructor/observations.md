# Completed exemplar field notebook

This is a **worked illustrative submission**, not a claim that these timings were measured. The actual compiler/check record is [validation.md](validation.md). The hypothetical size/layout observations below describe one ordinary x86-64 Linux configuration and are not grading constants. Code is supplied in [src](src); complete E01.C–E15.C and E01.Q–E15.Q responses appear in [answers.md](answers.md). P01–P06 and S01–S02 are also fully answered there.

### R01

Example environment entry: 2026-09-19, Intel Core i7-12650H exposed as 16 logical CPUs, x86-64 Ubuntu Linux under WSL2, kernel `6.18.33.2-microsoft-standard-WSL2`; GCC `11.4.0-1ubuntu1~22.04.3` and Clang `14.0.0-1ubuntu1.1`. Development flags are `-std=c11 -Wall -Wextra -Wpedantic -Werror -O0`, comparison identical except `-O2`. These environment fields match the inspected host; the timing trials below remain synthetic. Environment capture commands are `uname -a`, `lscpu`, `gcc --version` and `clang --version`. WSL shares host resources. For this illustrative experiment assume an editor and terminal open and no intentionally active competing workload; that assumption does not establish exclusive CPU access or verified host inactivity.

Commands: `make PACKAGE=instructor CC=gcc test`, then the Clang equivalent, `make PACKAGE=instructor bench`, `make PACKAGE=instructor symbols`, and `make verify`. Expected successful evidence is the 43-prompt inventory report, all executable/function/fault checks passing, both compilers accepting starters, and no sanitizer diagnostic. These are example report contents; consult validation.md for actual completion evidence and environment details.

### R02

The following predictions are phrased as things to write before running; observations are explicitly sample values. Each explanation links to the full worked exercise question so the short table does not replace the reasoning.

| Exercise | Prediction | Sample observation | Source → mechanism → explanation |
| --- | --- | --- | --- |
| E01 | Values survive formatting; this int is probably 32-bit. | -7,7,-42,42; int limits -2147483648..2147483647. | Matched variadic types print values; limits reveal range, not permission to overflow. [E01.Q](answers.md#e01q). |
| E02 | Five ints occupy five element sizes; parameter retains no extent. | array=20, element=4, length=5, pointer/parameter=8; playground array=12, length=3. | sizeof sees the caller's array but the helper's pointer. [E02.Q](answers.md#e02q). |
| E03 | N=0 gives zero and N=10 gives 55. | Both pass; 10001 fails. | A bounded prefix-sum loop proves the result independently of code generation. [E03.Q](answers.md#e03q). |
| E04 | Values beyond the interval reach an endpoint. | 12 in [-3,8] gives 8; reversed interval rejects. | Comparisons define an inclusive contract with separate status. [E04.Q](answers.md#e04q). |
| E05 | Nonempty extrema come from elements, not zero. | count=4, min=-2, max=7; empty returns failure/count zero. | Prefix extrema require a first element or an empty status. [E05.Q](answers.md#e05q). |
| E06 | Both traversals total 16; changing 4 to 5 yields 17. | Matching totals; empty NULL passes without an access. | Pointer advancement follows element extent; zero iterations avoid invalid arithmetic. [E06.Q](answers.md#e06q). |
| E07 | Boundaries are valid; NaN and infinity reject. | id=42, lat=45.5, lon=-73.5; invalid fixtures reject. | Fields plus finite range predicates represent a checked point. [E07.Q](answers.md#e07q). |
| E08 | B may use less space due to alignment. | A=24 at offsets 0,8,16; B=16 at 0,8,12. | See diagram below; compiler/ABI layout explains gaps. [E08.Q](answers.md#e08q). |
| E09 | On this expected target I predict little-endian integer bytes. | 04 03 02 01; order=little. | Unsigned character access exposes representation legally. [E09.Q](answers.md#e09q). |
| E10 | OR sets without disturbing other flags. | set=1 test=1 toggle=3 clear=2. | Masks operate on independent bits; unsigned does not legalize bad shifts. [E10.Q](answers.md#e10q). |
| E11 | N=5 totals ten; empty avoids allocation. | Count/sum tests and injected allocation failure pass. | Checked capacity precedes allocation; owner releases once. [E11.Q](answers.md#e11q). |
| E12 | Unterminated fixture has two lines but only one newline. | bytes=7 newlines=1; empty succeeds, missing fails. | Stream status distinguishes EOF/error, not merely a zero count. [E12.Q](answers.md#e12q). |
| E13 | Leading zeros are acceptable; sign and junk are not. | 00042 gives 42, -1 and 1x reject. | Grammar and conversion status enforce the complete contract. [E13.Q](answers.md#e13q). |
| E14 | The caller object will reference a definition elsewhere. | U count_equal in main.o, T in count.o and executable. | Linker resolves declaration-backed calls using the definition. [E14.Q](answers.md#e14q). |
| E15 | -O2 may reduce overhead but no ranking is guaranteed. | Synthetic trials below suggest a lower -O2 median. | Timed volatile reads and validated sums constrain interpretation. [E15.Q](answers.md#e15q). |

Sample A diagram: `[0 tag][1..7 pad][8..15 value][16..19 count][20..23 tail pad]`. Sample B: `[0..7 value][8..11 count][12 tag][13..15 tail pad]`. The tables predict and observe the same results here; an actual disagreement would be recorded rather than erasing the earlier prediction. For instance, expecting array length from the helper's sizeof would be repaired by recognizing parameter adjustment, not by guessing a different divisor.

### R03

Observation one: int occupies four bytes here. That is not a universal C11 size. The portable test uses `sizeof array == length * sizeof array[0]` and never asserts 20. Observation two: A has offsets 0,8,16 and total size 24. Other conforming layouts can differ; test member order and non-overlap rather than those numbers. Integer representation and documented type characteristics are implementation choices; padding byte contents themselves may be unspecified, so “implementation-dependent” in the report is broader than formally “implementation-defined.” A third observation, the uint32_t byte sequence 04 03 02 01, is also about this target, not every C execution environment.

### R04

Synthetic arithmetic example only. Both builds use 1024 elements initialized as `i % 100`, one untimed validated warm-up pass, 1000 passes per batch, and five batches. Each pass must sum to 49776 and each batch to 49776000. Setup and output are outside timing; volatile reads, accumulation and loop control are inside.

| Build | Raw elapsed seconds | Sorted elapsed seconds | Median | Min | Max | Range |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| -O0 | .0024, .0021, .0023, .0022, .0025 | .0021, .0022, .0023, .0024, .0025 | .0023 | .0021 | .0025 | .0004 |
| -O2 | .0008, .0007, .0009, .0008, .0010 | .0007, .0008, .0008, .0009, .0010 | .0008 | .0007 | .0010 | .0003 |

Median is the third sorted value for five samples; range is max minus min. A timestamp difference of 0 seconds and 2300000 nanoseconds is .0023 seconds (2.3 milliseconds). Crossing a second boundary requires combining both differences, e.g. (11s,100000000ns) minus (10s,900000000ns) = .2s. The example median ratio is .0023/.0008 = 2.875, about 2.9 times, for this hypothetical constrained workload only. It is not a measured speed claim.

An actual report should say “-O2 had a lower median in these trials,” not “-O2 is always faster.” Timer overhead, register allocation, inlining, scheduling and WSL host activity can affect results. Volatile makes loads observable but prevents some optimizations, so this experiment cannot rank unrestricted summation strategies. If actual trials reverse the ranking, report the reversal, verify outputs, inspect generated code and repeat under controlled conditions before explaining the cause. No particular ranking is needed for full credit.

### R05

Submission inventory: fifteen reference exercise implementations (sixteen .c files: fourteen single-file exercises plus two for ex14), ex14 header, supplied decimal helper, Makefile, test output and this report. The working code and detailed explanations are linked above; practice and stretch solutions are in answers.md and extras/. A learner submits their own corresponding files, not this exemplar.

A durable connection is E14: source declarations let compilation check a call, object symbols preserve the cross-file dependency, and linking supplies its target. Similar stages appear behind build tools in other compiled languages even when their syntax changes. An unresolved question for week 2 is how language storage duration differs from an actual optimized object's placement; these exercises do not establish that every local declaration creates a stack slot. That question preserves the course's aim of connecting layers while respecting what has not yet been observed.
