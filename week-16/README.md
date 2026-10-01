# Week 16 — Object lifetimes and allocation ownership

[Lesson](../docs/content/weeks/week-16.md) · [Beginner section](../docs/content/beginners/week-16.md) · [Further reading](../docs/content/further-reading/week-16.md)

Trace automatic, static and allocated objects, repair returned-local and ownership mistakes, implement failure-atomic allocation operations and interpret isolated diagnostics.

Prerequisites: Week 2 objects/storage, Week 10 lifetime versus architectural stack, and Week 11 compiler/frame observations. Week 15’s sort scratch is an optional ownership example; no unfinished package is linked. This package has no link-time dependency on an unfinished week. Use x86-64 Linux/WSL, GCC/Clang, C11, make and Python 3.10+. All substantial code is C; solutions remain separate from typed learner stubs.

## Work locally

```sh
cd week-16
make
make test
make warmups
make PACKAGE=instructor test
make verify
make diagnose
```

Default learner stubs compile warning-clean but intentionally fail correctness until implemented. make verify checks both compilers at debug O0, optimized O2 and O1 with AddressSanitizer/UndefinedBehaviorSanitizer, plus negative starter gates and checked beginner examples. [lab.h](include/lab.h) defines exact domain, caller preconditions, output and error contracts. One graded submission includes E01–E05 and R01–R05. Six practice, two stretch, three warm-ups and three reading questions have complete separate answers. [Validation](instructor/validation.md) records actual checks.

## Read and watch

Direct episode URLs, durations and assigned indexed markers were checked on 2026-10-01. Required viewing: 79:45 of indexed viewing; allow 100–115 minutes with reference consultation. CE is subscription material; the assignments are original. The beginner path adds 2–4 hours to a 600-minute core estimate, unpiloted: viewing/reference 120, implementation 260, independent validation 100, notebook/practice 120. Optional stretch and deeper readings add time. Record actual learner workload.

- [CE: The Stack](https://www.computerenhance.com/p/the-stack): Full, 26:58. Saved machine continuations versus object lifetime
- [HH014: Platform-independent Game Memory](https://guide.handmadehero.org/code/day014/): 7:35–28:40. Ownership policy at a platform boundary
- [HH157: Introduction to General Purpose Allocation](https://guide.handmadehero.org/code/day157/): 2:36–34:18. Variable allocation and fragmentation
- [C11 N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf): §§6.2.4, 6.5.7, 7.22.3, 7.22.5.2. Object lifetime, defined shifts, allocation and sorting contracts.
- [malloc/free](https://man7.org/linux/man-pages/man3/malloc.3.html): Allocation/free/reallocation contracts; zero size excluded here. Platform contract and limitations distinguished from C11.

## Source → mechanism → observation

A pointer value does not extend an object’s lifetime. Explicit ownership and commit-after-success rules make allocation, resizing and release obligations observable. The C contracts state what is valid and unchanged on error; the tests exercise those obligations; observations support only the recorded workload and platform. The [rubric](rubric.md) accepts other correct designs and valid different observations.

Owner records must be empty or uniquely own an accessible same-allocator allocation. Shape checks do not validate arbitrary pointers. All borrows end on successful replacing resize/release; failure keeps the old object live. Zero resize is explicit release. Allocator callbacks can have effects even on failure. Do not shallow-copy owners. static_next is single-threaded mutable shared state. Intentionally invalid bugs/*.c are opt-in child processes in make diagnose, never linked into a normal playground; clean repaired runs and expected failing diagnostic runs are different evidence. Compiler/ASan coverage cannot prove all lifetime behavior safe.
