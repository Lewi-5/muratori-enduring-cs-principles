---
prev:
  text: How to do a week
  link: /guide/how-to-study
next:
  text: Week 1 lesson
  link: /weeks/week-01
---

# Week 1 beginner section · C as an inspectable starting point

[All beginner sections](/beginners/) · [Week 1 lesson](/weeks/week-01) · [Week 1 further reading](/further-reading/week-01)

## Purpose and prerequisites

Week 1 is fifteen short C exercises. If you have written C before, most of them will look familiar, and that is exactly the risk: this week is less about syntax than about a way of looking at a program that most C programmers were never taught. This section builds that way of looking, slowly and with real output, before you start the notebook. It does not replace the lesson or change any of its exercises.

**By the end you should be able to:** say, for any claim about a C program, whether it comes from the C standard, from one compiler's choices or from one run on one machine; tell a value from its bytes and from the characters that display it; predict a few sizes and struct offsets and say which of them are portable; design a function that reports failure without damaging its output; state an invariant for a loop and use it to rule out overflow; say who owns an allocation or an open file; explain what the compiler and the linker each check; and say what a single timing can and cannot show.

**Time:** about 2–4 hours in short sessions: roughly 90 minutes reading and running the examples, and 60–90 minutes for the four warm-ups. This is in addition to the lesson's own budget, and like every estimate in the course it has not yet been checked by a learner pilot.

**You need:** to be able to read and write small C programs: variables, loops, functions, arrays and `printf`. Beej's Guide to C covers any syntax that is rusty; the further-reading page lists the chapters. You also need the course's WSL setup from [Local setup](/guide/setup).

Every program on this page is a file in `docs/examples/week-01/`. Each was compiled with both GCC 11.4 and Clang 14 using the course flags (`-std=c11 -Wall -Wextra -Wpedantic -Werror`) at `-O0` and `-O2` on x86-64 Linux under WSL2, and all four builds printed the output shown. A site check recompiles them and fails if the output changes. Some outputs, such as sizes, are true of this platform and not of every platform; the text says which.

## Vocabulary

| Term | Plain meaning | Where you meet it |
| --- | --- | --- |
| **object** | A region of memory that holds a value, such as the storage behind `int count` | Every exercise |
| **type** | What C knows about an object: its range of values and the operations allowed on it | E01, E02 |
| **representation** | The actual bytes that encode a value in memory | E09 |
| **display** | The characters a program prints for a value, chosen by a format such as `%d` or `%x` | E01 |
| **undefined behaviour (UB)** | A program action the C standard places no requirement on at all, such as signed overflow or reading past an array | E01, E06, Chat 011 |
| **implementation-defined** | Something each compiler and platform must choose and document, such as the size of `int` | E01, E02, E08 |
| **abstract machine** | The idealized computer the C standard describes; a real compiler must produce the same observable results as it, not the same steps | The whole course |
| **`size_t`** | The unsigned type that `sizeof` produces and that sizes and indexes should use | E02, E03, E06 |
| **alignment and padding** | The address multiple a type must start at, and the unused bytes a struct inserts to honour it | E08 |
| **status return** | A return value that says whether a function succeeded, separate from the result it produces | E03, E04, E11–E13 |
| **invariant** | A statement that stays true every time a loop reaches a chosen point | E03, E06 |
| **ownership** | Which part of a program is responsible for releasing a resource such as memory or an open file | E11, E12 |
| **translation unit** | One `.c` file after its `#include`s are pasted in; the unit the compiler works on | E14, Chat 013 |
| **declaration / definition** | A declaration says a name exists and what type it has; a definition creates the object or function body | E14 |
| **linker** | The program that joins object files and resolves each name used in one file to its definition in another | E14 |
| **monotonic clock** | A clock that only moves forward, suitable for measuring intervals | E15 |

## Concepts

### What C promises, and what one build did

You write a small program. It works when compiled with `-O0`, and prints something different, or crashes, at `-O2`. It is tempting to blame the optimizer. Usually the optimizer is right and the program was never valid.

The C standard does not describe machine instructions. It describes an **abstract machine** and the results a program must produce on it. A compiler may generate any instructions it likes, as long as a correct program's observable behaviour matches that abstract machine: its output, its file writes and its accesses to `volatile` objects. The `-O0` and `-O2` builds are two different, equally legal translations of the same promise.

That promise has holes on purpose. For some operations the standard says nothing at all about the result: this is **undefined behaviour**. Signed integer overflow is one:

<!-- snippet:wrap -->
```c
#include <limits.h>
#include <stdio.h>

int main(void)
{
    unsigned int top = UINT_MAX;
    unsigned int next = top + 1u;        /* defined: unsigned arithmetic wraps modulo UINT_MAX + 1 */
    printf("UINT_MAX = %u, UINT_MAX + 1u = %u\n", top, next);
    printf("INT_MAX  = %d\n", INT_MAX);  /* INT_MAX + 1 would be undefined: this program never computes it */
    return 0;
}
```

<!-- output:wrap -->
```text
UINT_MAX = 4294967295, UINT_MAX + 1u = 0
INT_MAX  = 2147483647
```

Unsigned arithmetic is *defined* to wrap around, like a car's odometer rolling past 999999 back to 000000, so `UINT_MAX + 1u` is exactly 0 everywhere. Signed arithmetic is not. `INT_MAX + 1` has no meaning in C, and the compiler may assume it never happens. For example, it may simplify `x + 1 > x` to "always true". Running such code to "see what happens" teaches you only what one build did that day, which is why this course never does it. It reasons about the code instead, and uses UBSan to catch mistakes.

Three kinds of claim sound alike and must be kept apart. The lesson calls writing them down with their source a **claim ledger**:

| Kind of claim | Example | Where it comes from | Holds on |
| --- | --- | --- | --- |
| Language guarantee | `UINT_MAX + 1u == 0`; `sizeof(char) == 1` | The C11 standard | Every conforming implementation |
| Implementation choice | `int` is 32 bits; this struct has 4 bytes of padding | The compiler and the platform's ABI | This compiler and platform, documented |
| Observation | This loop took 0.8 µs in this run | One execution | That run, on that machine |

**Read alongside:** Beej's Guide to C [§6.4 Out of Bounds!](https://beej.us/guide/bgc/html/split/arrays.html#out-of-bounds) for a friendly first example of undefined behaviour; *Dive Into Systems* [§4.5 Overflow](https://diveintosystems.org/book/C4-Binary/overflow.html) for what the hardware does, which is exactly what C declines to promise for signed types.

### A value, its bytes, and its display

You print the number 42 and see the characters `4` and `2` on the screen. Is that what is stored in memory?

No. Three different things are involved, and confusing them causes a whole family of bugs:

<!-- snippet:display -->
```c
#include <stdio.h>

int main(void)
{
    int answer = 42;
    char digit = '4';
    printf("answer as %%d: %d  as %%x: %x  as %%o: %o\n", answer, answer, answer);
    printf("digit as %%c: %c  as %%d: %d\n", digit, digit);
    printf("digit - '0' = %d\n", digit - '0');
    return 0;
}
```

<!-- output:display -->
```text
answer as %d: 42  as %x: 2a  as %o: 52
digit as %c: 4  as %d: 52
digit - '0' = 4
```

The **value** is the abstract number forty-two. The same value can be *displayed* as `42`, `2a` or `52`, depending only on the format you give `printf`. The character `'4'` is a different value altogether: in ASCII it is the number 52, which `%c` draws as the glyph "4". Subtracting `'0'` converts a digit character to the number it names, which is exactly what the supplied `decimal.h` does for E03. Underneath all of this, the `int` object holding 42 is stored as bytes in memory, its **representation**. E09 looks at those bytes directly.

A **format string** is a contract: each `%` conversion promises `printf` an argument of a particular type. `%d` expects an `int`, `%u` an `unsigned int`, `%zu` a `size_t`, `%llu` an `unsigned long long`. Passing the wrong type is undefined behaviour even when the output happens to look right. E01 asks you to match all four.

**Read alongside:** *But How Do It Know?*, “Codes” (PDF p. 30) on how letters become numbers; CS:APP §2.1.3 Addressing and Byte Ordering (p. 78, PDF p. 71) on representation.

### Sizes are relationships, not constants

You pass an array to a function and ask `sizeof` for its size, and get a much smaller number than you expected.

<!-- snippet:array_size -->
```c
#include <stdio.h>

/* Written as the pointer it really is. Declaring the parameter as double values[4] changes
   nothing: C adjusts an array parameter to a pointer (and GCC warns about sizeof on it). */
static size_t size_inside(const double *values)
{
    return sizeof values;
}

int main(void)
{
    double values[4] = {1.0, 2.0, 3.0, 4.0};
    printf("sizeof values in main:     %zu\n", sizeof values);
    printf("sizeof values[0]:          %zu\n", sizeof values[0]);
    printf("number of elements:        %zu\n", sizeof values / sizeof values[0]);
    printf("sizeof values in function: %zu\n", size_inside(values));
    return 0;
}
```

<!-- output:array_size -->
```text
sizeof values in main:     32
sizeof values[0]:          8
number of elements:        4
sizeof values in function: 8
```

Inside `main`, `values` names the whole array object: four doubles, 32 bytes on this platform. Almost everywhere else, including when it is passed to a function, an array expression is converted to a pointer to its first element. A function parameter declared as `double values[4]` is quietly treated as `double *values`. That is why `sizeof` inside the function gives the size of a pointer, 8 bytes on x86-64, and why every function in the notebook takes a separate `length`. The first draft of this example declared the parameter as an array, and GCC rejected it under the course flags with a warning that `sizeof` would return the size of `double *`. It was right.

Which of these numbers are portable? `sizeof(char)` is 1 by definition. The *relationships* hold everywhere: an array's size is its length times its element size, and `sizeof values / sizeof values[0]` is its length. The particular values, 8 for a `double` and 8 for a pointer, are choices of this platform. E02 asks you to test relationships rather than byte counts for exactly this reason.

**Read alongside:** Beej's Guide to C [§5.7 sizeof and Pointers](https://beej.us/guide/bgc/html/split/pointers.html#sizeof-and-pointers) and [§6.6 Arrays and Pointers](https://beej.us/guide/bgc/html/split/arrays.html#arrays-and-pointers).

### Where the gaps in a struct come from

You declare a struct with a `char`, an `int` and another `char`, six bytes of data in all, and `sizeof` says 12.

<!-- snippet:layout -->
```c
#include <stddef.h>
#include <stdio.h>

struct Loose { char first; int number; char last; };
struct Tight { int number; char first; char last; };

int main(void)
{
    printf("Loose: size=%zu first=%zu number=%zu last=%zu\n", sizeof(struct Loose),
           offsetof(struct Loose, first), offsetof(struct Loose, number), offsetof(struct Loose, last));
    printf("Tight: size=%zu number=%zu first=%zu last=%zu\n", sizeof(struct Tight),
           offsetof(struct Tight, number), offsetof(struct Tight, first), offsetof(struct Tight, last));
    return 0;
}
```

<!-- output:layout -->
```text
Loose: size=12 first=0 number=4 last=8
Tight: size=8 number=0 first=4 last=5
```

The problem the gaps solve: processors read memory most efficiently, and on some machines only, when a 4-byte integer starts at an address that is a multiple of 4. That multiple is the type's **alignment**. On x86-64 Linux an `int` has alignment 4, so in `Loose` three **padding** bytes sit after `first` to push `number` to offset 4. Three more follow `last`, because the size of a struct must be a multiple of its alignment: in an array of `Loose`, every element's `number` must be aligned too. `Tight` lists the same members in a different order, and needs only two bytes of padding at the end.

A picture of `Loose`, one character per byte (`f` first, `n` number, `l` last, `.` padding):

```text
offset: 0 1 2 3 4 5 6 7 8 9 10 11
        f . . . n n n n l .  .  .
```

C guarantees only that members appear in the order declared, that the first is at offset 0, and that `offsetof` reports the real positions. The amount of padding is the platform's choice. E08 has you measure two field orders of a different struct and explain, not assume, what you find. Week 2 turns this into a full layout inspector.

**Read alongside:** Beej's Guide to C [§20.5 Padding Bytes](https://beej.us/guide/bgc/html/split/structs-ii-more-fun-with-structs.html#struct-padding-bytes); CS:APP §3.9.3 Data Alignment (p. 309, PDF p. 301).

### Failure is part of the interface

You call a function that divides two numbers. What should it do when asked to divide by zero?

Crashing is unhelpful, and returning a special number such as -1 is ambiguous, because -1 might be a real answer. The notebook's functions all follow one convention instead. They **return a status**, 1 for success and 0 for failure, deliver the result through an output pointer, and **leave the output untouched when they fail**:

<!-- snippet:safe_divide -->
```c
#include <limits.h>
#include <stdio.h>

/* Returns 1 and stores a / b on success. Returns 0 and leaves *out untouched when the
   division is not defined: b == 0, or INT_MIN / -1 (the true result does not fit in int). */
static int safe_divide(int a, int b, int *out)
{
    if (b == 0 || (a == INT_MIN && b == -1)) return 0;
    *out = a / b;
    return 1;
}

int main(void)
{
    const int cases[][2] = {{7, 2}, {-7, 2}, {7, 0}, {INT_MIN, -1}};
    for (int i = 0; i < 4; ++i) {
        int out = 42; /* a sentinel: if it survives, the function did not write */
        int ok = safe_divide(cases[i][0], cases[i][1], &out);
        printf("%d / %d -> ok=%d out=%d\n", cases[i][0], cases[i][1], ok, out);
    }
    return 0;
}
```

<!-- output:safe_divide -->
```text
7 / 2 -> ok=1 out=3
-7 / 2 -> ok=1 out=-3
7 / 0 -> ok=0 out=42
-2147483648 / -1 -> ok=0 out=42
```

Three details repay attention:

- **The checks come first.** Division by zero is undefined, and so is `INT_MIN / -1`, whose true answer, 2147483648, does not fit in an `int`. The function refuses both *before* dividing.
- **The sentinel proves the contract.** The caller sets `out` to 42 before each call, and the 42 survives both refusals. Tests in this course use sentinels in exactly this way.
- **Integer division truncates toward zero.** `-7 / 2` is `-3`, not `-4`. C99 fixed this rule and C11 keeps it; C89 left the direction to the implementation.

Checking before operating is the most important habit of the week. E03, E11 and E13 need it for sums, allocation sizes and parsed numbers, and warm-up W01 practises it on addition.

**Read alongside:** CS 341 Coursebook §3.5.1 Handling Errors (p. 52, PDF p. 66).

### Who owns this memory, and this file?

You allocate an array with `malloc`, and an early `return` on an error path skips the `free`. Nothing crashes. The memory is simply never given back.

Some resources have to be released explicitly: allocated memory with `free`, an open file with `fclose`. For each one, exactly one part of the program must be responsible for the release. That responsibility is **ownership**. The notebook's rules are simple and strict:

| Resource | Acquire | Check | Release | Mistakes to avoid |
| --- | --- | --- | --- | --- |
| Allocated memory | `malloc(n)` | The result may be NULL | `free(p)` exactly once | Freeing twice, using after `free`, leaking on an error path |
| Open file | `fopen(path, "rb")` | The result may be NULL | `fclose(f)` exactly once; its result can report an error | Returning without closing; ignoring a read error |

Allocation sizes are arithmetic too, so the same overflow thinking applies: E11 rejects a request before computing `n * sizeof(int)` if that product could overflow. E12 counts bytes in a file and must close the file on *every* path, including the error paths, which the tests reach by injecting failures.

Warm-up W04 practises ownership on a copy of a string, including the easily forgotten extra byte for the terminating NUL.

**Read alongside:** Beej's Guide to C [§12 Manual Memory Allocation](https://beej.us/guide/bgc/html/split/manual-memory-allocation.html#manual-memory-allocation) and [§9 File Input/Output](https://beej.us/guide/bgc/html/split/file-inputoutput.html#file-inputoutput); CS 341 Coursebook §3.8 Common Bugs (p. 67, PDF p. 81).

### Two files, one program

You split a program into `main.c` and `count.c`, compile, and get an error that mentions neither file's source: "undefined reference to `count_equal`".

That message comes from a different program from the compiler. Building a C program happens in stages, and each stage sees a different amount of the program:

| Stage | Input | Output | What it can check |
| --- | --- | --- | --- |
| Preprocessor | `main.c` and the headers it includes | One **translation unit** of plain C text | Include paths and macro syntax |
| Compiler | One translation unit | Assembly for that unit | Types, and whether each call matches a *declaration* |
| Assembler | Assembly | An **object file** (`.o`) with a symbol table | Nothing about other files |
| Linker | All the object files and libraries | An executable | That every name used somewhere is *defined* exactly once |

The compiler works on one translation unit at a time. When `main.c` calls `count_equal`, the compiler needs only a **declaration**, usually from a header: the function's name, parameter types and return type. It does not need the body, which is the **definition** and lives in another file. The object file records the call as an unresolved name. The linker later finds the definition in `count.o` and connects the two. If no object file defines the name, only the linker can notice, hence the error.

E14 has you build the two object files separately, link them, and look at their symbol tables with `nm`: the name appears as undefined (`U`) in one and defined in code (`T`) in the other. Handmade Chat 013's assigned segment walks through the same pipeline.

**Read alongside:** Beej's Guide to C [§17.4 Compiling with Object Files](https://beej.us/guide/bgc/html/split/multifile-projects.html#compiling-with-object-files); CS:APP §1.2 (p. 40, PDF p. 34) and §7.1–§7.2 (p. 707, PDF p. 698).

### What one timing can tell you

You time a loop and it takes 812 nanoseconds. You run it again: 790. Again: 1,340. Which is the answer?

None of them alone. A timing is an **observation** about one run on one machine, disturbed by everything else the machine was doing. E15 therefore times five trials and reports the median, minimum, maximum and range, so that variation is visible rather than hidden. It also uses a **monotonic** clock, `CLOCK_MONOTONIC`, which only moves forward. The wall clock (`CLOCK_REALTIME`) can jump when the system adjusts the time, which would corrupt an interval.

<!-- snippet:clock_res -->
```c
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <time.h>

int main(void)
{
    struct timespec res;
    if (clock_getres(CLOCK_MONOTONIC, &res) != 0) {
        perror("clock_getres");
        return 1;
    }
    printf("CLOCK_MONOTONIC resolution: %ld s + %ld ns\n", (long)res.tv_sec, res.tv_nsec);
    return 0;
}
```

<!-- output:clock_res -->
```text
CLOCK_MONOTONIC resolution: 0 s + 1 ns
```

That "1 ns" is easy to over-read. It is the clock's **resolution**, the unit in which it reports time on this Linux system. It is not its accuracy, and it is not the cost of reading it; each call to `clock_gettime` itself takes time. `clock_gettime` also comes from POSIX, not ISO C, which is why the program has to request POSIX declarations with `_POSIX_C_SOURCE`.

There is one more trap. An optimizing compiler may notice that a timed loop's result is never used, or is known in advance, and remove the loop. E15 reads its array through `volatile` to prevent that. The price is that its `-O2` build is not a normal `-O2` loop, and the exercise asks you to say so. A measurement is only as good as your account of what it measured.

**Read alongside:** *Dive Into Systems* [§17.10 Timing](https://diveintosystems.org/book/Appendix2/timing.html); CS:APP §1.9.1 Amdahl's Law (p. 58, PDF p. 52) for why a faster loop may matter less than it seems.

## Walk-through: following one loop from promise to evidence

E03 and E06 both sum numbers in a loop. Here is the reasoning they expect, worked on a small example.

**Step 1: state what the loop is for, as an invariant.** "Each time the loop reaches its end, `sum` holds the total of the elements seen so far." Before the loop, "the elements seen so far" is the empty prefix, so the total is 0. After the last iteration, the prefix is the whole array, so the invariant *becomes* the result.

**Step 2: watch it hold.**

<!-- snippet:trace -->
```c
#include <stdio.h>

int main(void)
{
    const int values[] = {3, 5, -1};
    const size_t length = sizeof values / sizeof values[0];
    long sum = 0;
    printf("before the loop: sum=%ld (the empty prefix)\n", sum);
    for (size_t i = 0; i < length; ++i) {
        sum += values[i];
        printf("after i=%zu: sum=%ld covers values[0..%zu]\n", i, sum, i);
    }
    return 0;
}
```

<!-- output:trace -->
```text
before the loop: sum=0 (the empty prefix)
after i=0: sum=3 covers values[0..0]
after i=1: sum=8 covers values[0..1]
after i=2: sum=7 covers values[0..2]
```

**Step 3: bound every value the invariant can take.** A trace checks one input; a bound covers all of them. E06's precondition allows at most 10,000 elements, each between −1,000 and 1,000. Every prefix sum therefore lies between −10,000,000 and 10,000,000. C guarantees that a `long` holds at least ±2,147,483,647, so no partial sum can overflow, on *any* conforming platform, not just this one. E03's sum of 1 to 10,000 is at most 50,005,000, and the same argument applies to its `unsigned long long`.

**Step 4: label each claim.** "The sum is 7" is an observation of this run. "No prefix sum can overflow" is a language guarantee plus arithmetic. "The `-O2` build keeps `sum` in a register" would be an observation about one compiler, true only once you have looked at its assembly. The lesson's notebook asks you to keep these three apart, and this is what that looks like in practice.

## Warm-ups

Four short programs, each practising a habit several exercises depend on. The scaffolds are in `week-01/learner/src/w01.c` to `w04.c`, each with a supplied `main`. From `week-01`, run `make warmups` to build and check only the warm-ups. It names each one that is not yet passing. They are ungraded, but the notebook assumes you can do them.

<!-- warmup:W01 -->

<!-- warmup:W02 -->

<!-- warmup:W03 -->

<!-- warmup:W04 -->

## Check yourself

Try each question before opening its answer.

1. Which of these is guaranteed by C itself: `sizeof(int) == 4`, `sizeof(char) == 1`, `UINT_MAX + 1u == 0`, `INT_MAX + 1 == INT_MIN`?

   ::: details Answer
   `sizeof(char) == 1` and `UINT_MAX + 1u == 0`. The size of `int` is implementation-defined (4 on x86-64 Linux). `INT_MAX + 1` is undefined behaviour, so it is not "equal" to anything.
   :::

2. A function takes `int values[10]` as a parameter. What does `sizeof values` give inside it on this platform, and why?

   ::: details Answer
   8, the size of a pointer. An array parameter is adjusted to a pointer to its element type, so `values` is really an `int *`.
   :::

3. Why does `struct { char a; double b; }` usually take 16 bytes on x86-64, not 9?

   ::: details Answer
   `double` has alignment 8 there, so seven padding bytes follow `a` to place `b` at offset 8. The total, 16, is already a multiple of the struct's alignment of 8, so no padding is needed at the end.
   :::

4. A parsing function fails halfway through and has already written a partial number to `*out`. Which part of the notebook's contract did it break, and why does that matter to the caller?

   ::: details Answer
   "On failure, leave the output unchanged." The caller may be holding a previous valid value in that variable, or relying on a sentinel to detect failure. Validate everything first, and write the output last.
   :::

5. A loop adds up to 1,000,000 values, each between 0 and 5,000, into an `int`. Can it overflow on a platform with a 32-bit `int`? What about on every conforming platform?

   ::: details Answer
   The largest possible sum is 5,000,000,000, well above `INT_MAX` = 2,147,483,647, so yes, even with a 32-bit `int`. C only guarantees that `int` holds ±32,767, so it can overflow on some platforms at far smaller totals. `long long` (at least 64 bits) holds it everywhere.
   :::

6. `main.c` includes `count.h` and calls `count_equal`, but `count.c` was left out of the build. Which stage reports the problem?

   ::: details Answer
   The linker. The compiler is satisfied by the declaration in `count.h`; only the linker notices that no object file defines `count_equal`.
   :::

7. E15 reports five timings with a median of 0.00081 s. What can you conclude, and what can you not?

   ::: details Answer
   You can say how long that loop took in those runs, on that machine and build, and how much the runs varied. You cannot say it will take that long elsewhere, that `-O2` "is N times faster" in general, or what fraction of a real program's time such a loop would be.
   :::

## Ready for the lesson

You are ready for the [Week 1 lesson](/weeks/week-01) when you can do each of these without looking back:

- Match `printf` formats to types, and say which integer limits C guarantees (prepares **E01**).
- Explain why `sizeof` of an array parameter is the size of a pointer, and test size relationships rather than byte counts (prepares **E02**).
- Write a function that checks its inputs before operating, returns a status and leaves its output untouched on failure (prepares **E03**, **E04**, **E11** and **E13**).
- State a loop invariant and use a bound to rule out overflow (prepares **E05** and **E06**).
- Validate a coordinate, including NaN and infinity, before using it (prepares **E07**; the lesson explains the floating-point part).
- Explain where struct padding comes from and which parts of a layout are portable (prepares **E08**).
- Tell a value's bytes from its display, and a byte of the value from a byte in memory (prepares **E09** and **E10**).
- Say who frees an allocation and who closes a file, on every path (prepares **E11** and **E12**).
- Say what the compiler checks and what only the linker can check (prepares **E14**).
- Say what one timing shows and what it does not (prepares **E15**).

All four warm-ups should pass `make warmups`. If one resists, its written answer on the [solutions page](/solutions/week-01#w01) explains the reasoning, not just the code.

## Read alongside

The [further-reading page](/further-reading/week-01) introduces each companion text and gives a full cross-reference from every video in this week to the sections that explain the same mechanism. If you only have time for three readings this week, take them in this order:

1. *But How Do It Know?*, “Speed” (PDF p. 7): a computer does a few simple things very fast, which is the frame for everything Computer, Enhance! calls waste.
2. CS 341 Coursebook §3.8 Common Bugs (p. 67, PDF p. 81): short, concrete C mistakes, most of them undefined behaviour.
3. CS:APP §1.2 (p. 40, PDF p. 34) and §7.1–§7.2 (p. 707, PDF p. 698): how source files become one program.
