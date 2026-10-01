# Completed exemplar — object-layout inspector notebook

The predictions in this document are **illustrative prior hypotheses**, not a claim that an automated agent performed a human learner's before/after exercise. The sample layouts agree with the actual reference build captured in [symbol-observations.md](symbol-observations.md) and [validation.md](validation.md). Different valid observations are accepted. Full E01.C–E10.C, E01.Q–E10.Q, P01–P06 and S01–S02 responses are in [answers.md](answers.md); this notebook integrates them rather than replacing them with a short output table.

### R01

Example environment: 2026-09-20, x86-64 Ubuntu under WSL2, Linux kernel 6.18.33.2-microsoft-standard-WSL2, Intel Core i7-12650H presented to the guest. Compiler versions: GCC 11.4.0-1ubuntu1~22.04.3 and Clang 14.0.0-1ubuntu1.1. GNU binutils 2.38 supplies nm, readelf, objdump and size. The kernel and tool versions were obtained from uname -r and the tools' --version output; the CPU is a machine observation, not a course requirement beyond the reference architecture.

Commands are `make PACKAGE=instructor CC=gcc test`, the Clang equivalent, each again with `MODE=optimized`, and `make verify` for the full suite plus sanitizer and scaffold checks. Strict flags are `-std=c11 -Wall -Wextra -Wpedantic -Werror -fno-common -O0`; optimized changes -O0 to -O2. Sanitizers use -O1, debug info, address/undefined checks and frame pointers, with a non-PIE executable in this Linux configuration. See the actual validation record and retained local logs for results. This week has no benchmark, background-load assertion or timing comparison.

### R02

Illustrative predictions are retained alongside observations. A learner would record their own predictions before reading the outputs.

| Exercise | Illustrative prediction | Reference/sample observation | Source → mechanism → explanation |
| --- | --- | --- | --- |
| E01 | Raw octets print without sign extension; endian order may differ. | raw=00 7f 80 ff; u32=04 03 02 01; i32=fe ff ff ff. | Unsigned character access observes representation, not a universal byte order. |
| E02 | sizeof must supply an aligned array stride. | char 1/1, int 4/4, double 8/8; relationship checks pass. | Complete-type extent includes enough padding to keep successive elements aligned. |
| E03 | A is 24 bytes; initially overlook Nested's tail and predict 27. | A=24; Nested=32 at offsets 0,8,24, alignment 8. | Correct the Nested prediction by rounding end 27 to 32; keep the original wrong prediction visible. |
| E04 | Maps mark immediate member extents; initially expect dots inside Nested.inner. | Nested's full 16-byte inner span is B, including its own padding. | Outer map uses sizeof(Inner), not a recursively flattened field list; draw the separate inner map. |
| E05 | recs[3].count uses three strides plus the member offset. | Offset 88 here; grid[2][3] offset 44; pointer equalities hold. | sizeof includes tail padding, and the grid uses row-major element numbers. |
| E06 | Static values persist, ordinary initialized locals restart. | static 1,2,3; automatic 1,1,1; live frame addresses distinguish objects; independent allocations. | Storage duration controls valid lifetime; the implementation can reuse sibling storage. Either auto_reuse outcome is acceptable. |
| E07 | Header then three aligned records should fit in 56 bytes on this target. | Exact-fit carve passes; one byte short and block+1 reject without stores. | Check extent and alignment before creating typed accesses; explicit stores initialize fields. |
| E08 | Indices retain meaning in a same-order copy, pointer links do not follow it. | chain=3 copy_chain=3 pointer_links_follow_copy=0 cycle_rejected=1. | Index resolution supplies the chosen table base; copying a pointer preserves its referent. |
| E09 | Caller references external data; private counters remain independent. | shared 7→8; hidden data 4/main 3; U shared_counter in caller, D in data object. | Linker resolves one external object; file-local definitions are distinct living objects. |
| E10 | Reordering double/int/char should reduce padding under this model. | 24-byte first order versus 16-byte reordered layout; padding 11 versus 3. | Natural-alignment placement and final rounding explain the difference; no speed claim follows. |

Illustrative pre-run drawings, followed by corrections:

```text
GeoPoint predicted/observed: [id 0..7][lat 8..15][lon 16..23], size 24
A predicted/observed: [tag 0][pad 1..7][double 8..15][int 16..19][tail 20..23]
Inner predicted/observed: [short 0..1][pad 2..7][double 8..15], size 16
Nested initial prediction: [tag 0][pad 1..7][Inner 8..23][bytes 24..26], size 27
Nested corrected: same member positions, plus [tail 27..31], size 32
E10 reordered prediction/observation: [double 0..7][int 8..11][char 12][tail 13..15]
```

Corresponding maps: GeoPoint `AAAAAAAABBBBBBBBCCCCCCCC`; A `A.......BBBBBBBBCCCC....`; Nested `A.......BBBBBBBBBBBBBBBBCCC.....`; E10 reordered `AAAAAAAABBBBC...`. Inner's separate map is `AA......BBBBBBBB`. My illustrative mistake was confusing nested padding with top-level padding and neglecting the outer stride rounding. Reconciliation identifies that rule rather than editing the prediction afterward.

The E06 storage table is:

| Object | Duration / linkage | Initial value | Lifetime end |
| --- | --- | --- | --- |
| file global=7 | static / external | 7 | program termination |
| file zero | static / external | 0 | program termination |
| static local | static / none | 0 | program termination |
| automatic=2 | automatic / none | 2 per entry | leaving block |
| malloc object before store | allocated / unnamed | indeterminate bytes | free or successful realloc of the original object |
| literal "hi" | static / unnamed | h, i, NUL | program termination |
| block compound literal (int){9} | automatic / unnamed | 9 | enclosing-block lifetime end |

“Unnamed” here means no identifier to carry linkage, not a fourth linkage kind. The allocated object's duration differs from the local pointer variable's duration. No stale pointer is compared in the example; only uintptr_t snapshots taken while the local was alive survive the sibling calls.

### R03

Observation one: A has size 24 and offsets 0,8,16 on this build. A portable span test instead checks member extents, order/non-overlap and containment; only the labelled ABI test compares against the natural-layout prediction. Observation two: int is four bytes and long is eight here. Array-address tests compute strides from sizeof rather than hard-code those numbers. Observation three: nm calls the static local local.0 in the captured GCC object; other compilers can use another name.

| Claim | Authority/category | Limit |
| --- | --- | --- |
| Character access can inspect representation. | C11 | Does not specify endian order or padding values. |
| Alignment rounding must not overflow size_t. | C11 arithmetic plus API contract | The API rejects instead of accepting modular wrap as an address. |
| A's reference layout follows natural member alignment. | System V ABI | Not a guarantee for every conforming C implementation. |
| Unneeded locals may be optimized away. | Compiler, subject to C observable behavior | A declaration does not require a stack slot. |
| .bss is NOBITS; nm reports local/global symbol categories. | ELF/binutils toolchain | Exact names and offsets vary. |
| Fresh anonymous pages on Linux are zero initialized. | Linux OS interface | The course uses malloc, whose storage is not promised zero. |
| Numeric integer snapshots happened to compare equal or unequal. | Observed on a machine/build | Either sibling reuse outcome is accepted. |

No POSIX timing fact is needed this week. The ledger's OS statement is contextual, not an experiment with mmap; page mapping is deferred. C's semantic zero values, calloc's all-zero bits and an OS page's byte contents are related only under explicitly stated representation assumptions.

### R04

HH014 illustrates keeping a platform allocation boundary separate from program-state organization. In the C11 exercise the block is allocated storage without a declared type, sufficiently sized/aligned, checked for arithmetic overflow, and populated through valid typed stores. The demonstration's chosen addresses and zeroed Windows pages are platform context, not facts implied by a C malloc call. Declaring a char buffer and casting it is not an equivalent C11 substitute, even after fixing alignment.

HH064 motivates storing a reference that can be resolved when used. E08 supplies direct evidence: the same three indices traverse either same-order table copy, but copied pointer links continue referring to the original. The preserved-slot condition is essential; compaction or reuse can change what index three means. Likewise saving raw struct bytes does not specify a portable file format. Index validity, object lifetime and serialization encoding are separate contracts.

The CE viewing motivates a boundary: sizes and offsets alone cannot predict a loop's speed because compiler instruction selection, data access behavior and execution dependencies also matter. Weeks 21–24 add data movement/locality experiments, and 27–29 add front-end and execution-resource reasoning. This week establishes representations that those later experiments can vary deliberately.

### R05

Submission inventory: ten exercises in eleven .c files (nine single-file exercises plus E09's two translation units), ex09_data.h, support/platform.h, the Makefile, test output and notebook. Instructor extras add permutations.c and the symbol observation excerpt. Full numbered explanation/practice/stretch answers are in answers.md; the coverage checklist maps every prompt. Learners submit their own corresponding completed sources and responses.

A durable defense is E09: an extern declaration makes a shared object usable from another translation unit; the object file records an unresolved symbol; linking resolves it to the data unit's single definition; the runtime identity comparison confirms both views name one live object. The syntax may change in another language, but the distinction between visibility, identity and lifetime remains useful.

An appropriate next question is how double's represented values and rounding affect coordinate calculations near numerical boundaries, which week three's geometry can test. For workload reporting, a hypothetical learner log might record 105 minutes reading, 20 setup, 165 E01–E05, 215 E06–E10, 75 report, and 65 practice/checks: 645 minutes, 45 over the core target. This log is **illustrative, not measured human completion data**. It shows how to record an overrun without dropping required work; the actual course estimate still needs a learner pilot. Optional stretch time would be recorded separately.
