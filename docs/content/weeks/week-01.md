---
prev:
  text: How to do a week
  link: /guide/how-to-study
next:
  text: Week 2 · Objects, bytes, and storage
  link: /weeks/week-02
---

# Week 1 · C as an inspectable starting point

::: tip Want a slower way in?
Start with the [Week 1 beginner section](/beginners/week-01): it builds this week's way of looking at C from scratch, with checked examples and four short warm-ups. When you finish the lesson, the [further reading](/further-reading/week-01) introduces the seven companion texts the course uses all year.
:::

You write two loops that add the same array. They print the same answer. One uses an index; the other advances a pointer. Have you written the same program twice? At the level of the requested result, perhaps. At the level of generated instructions or execution time, you do not yet know.

That gap is the subject of this course. You will learn to connect what source code promises, the mechanism that carries out the work, and evidence from a particular run. C is useful here because a small program can lead you directly to bytes, object files, library calls, and machine instructions. It does not guarantee a one-to-one translation from a line of source to an instruction.

## Where this week takes you

The fifteen exercises form one field notebook. The early programs establish values and bounds. Arrays and structs introduce objects with extents. Allocation and files introduce resources whose lifetime you manage. Separate compilation exposes the boundary between a declaration and a working executable. Finally, a small timing experiment asks what an observation can legitimately tell you.

These are the tools Week 2 uses to investigate memory layout. The coordinate struct also starts the thread that becomes `geolab`, the course's geospatial engine. You are building habits as well as functions: predict, check boundaries, preserve failures, and explain the limits of the evidence.

You should already be able to follow variables, loops, and functions in some programming language. Use the companion readings for unfamiliar C syntax. The original nine-hour estimate assumes basic C experience; first-principles preparation is additional and has not been timed with learners.

## Concepts before the first build

### A value is not its display or its representation

You ask a program to print the integer seven. The stored object has bytes, while the terminal receives characters such as `7`. Those characters are a representation chosen for people; they need not resemble the object's memory bytes.

A **type** tells C what operations and value range an object supports. A **format string** tells `printf` how to interpret the arguments you supplied. The two descriptions must agree. `%zu`, for example, is used for `size_t`, the unsigned type returned by `sizeof`. Picking a format because the result looks small enough does not satisfy the call's contract.

An **object** is a region of storage used to hold a value. In `int count = 7`, `count` names an object whose type is `int`. A **pointer** is a value that can identify an object or a permitted position associated with it. `&count` obtains the address of `count`; given `int *p = &count`, the expression `*p` accesses that integer. The `*` in the declaration says what kind of variable `p` is; the `*` in an expression accesses its target. That target must still exist, and the access must be valid.

A byte is C's unit of object size. `sizeof(char)` is one by definition, while `CHAR_BIT` states how many bits that byte contains. Our target has the familiar eight-bit bytes, but an explanation should distinguish the target from the language rule.

### Bounds turn loops into arguments

You can run a summation on ten inputs and still have no explanation for the eleventh. An **invariant** is a statement that remains true at a chosen point in every iteration. For a running sum, it can describe exactly which prefix has already been included.

Think of crossing names off a checklist. Before the next name, the total accounts for every crossed-off entry and no others. The analogy describes progress, but the computer also has finite integer ranges: you must show that the accumulator can hold every permitted partial result.

The same discipline applies to arrays. An array has a fixed number of elements. A pointer identifies a position, but does not carry a general runtime length field. Forming the one-past position can be useful for stopping a traversal; reading an element there is invalid.

### Success and failure belong to the interface

You ask for a minimum from an empty array. Returning zero alone cannot say whether the minimum was zero or no minimum existed. This is why many exercises return a status and put a successful result in an output object through a pointer.

Read each contract carefully: some failures preserve the old output, while the empty statistics result has an explicitly different policy. Do not impose one remembered rule on every function. Test a failure with a recognizable sentinel value in the output so that an accidental write becomes visible.

For example, a call written `clamp_int(value, low, high, &answer)` gives the function a way to write the caller's `answer`. Inside the function, assigning to `*out` changes that object; assigning only to the local pointer variable `out` would change which target the function refers to. A **null pointer**, commonly written `NULL`, identifies no object and cannot be dereferenced. It is allowed only where the particular contract says so.

### From source file to running process

You call a function declared in a header and the compiler accepts the call. That does not mean its implementation has been found. A **translation unit** is the source being compiled after included text and preprocessing have been handled. Compilation produces an **object file** containing code and references. The linker combines definitions and references into an executable.

```text
source + included declarations → compiler → object file
object files + required libraries → linker → executable
executable + operating-system loading → running process
```

A header is like an agreed order form: it tells callers what they may request. That analogy stops before implementation; a declaration does not perform the work or reserve a definition in another file. E14 makes this distinction visible in symbol tables.

## Read and watch with a question

Watch the motivation material asking, “What work might my source hide?” Read the undefined-behavior discussion asking, “Which conclusions cannot be obtained by running an invalid program?” Return to the compilation discussion when you reach E14; its historical examples are not permission to use obsolete declarations in C11.

<!-- readings -->

## Tools and a first worked example

From your repository root, enter the package and compile the supplied learner files:

```sh
cd week-01
make
make test
```

`make` follows the build recipe. The first command should compile the scaffolds; the tests should fail until you implement the TODOs. A compiler error and a behavioral test failure are different events. Read the first diagnostic before changing code. The [setup guide](/guide/setup) explains the toolchain and terminal.

For the E06 input `{4, -2, 7, 7}`, the running totals are 4, 2, 9, and 16. Changing the first element to 5 changes the final result to 17. This prediction concerns the sum, not instruction count. Restore the original input for the required submission.

| Evidence | What it establishes | What it does not establish |
| --- | --- | --- |
| Successful compilation | The compiler accepts this build | Correct behavior on every input |
| A passing boundary test | That tested boundary behaves as expected | All untested boundaries behave correctly |
| A symbol listing | What this object or executable exposes | The runtime cost of the function |
| A measured duration | Elapsed time for the stated experiment | A universal property of the source |

The [supplied decimal helper](/source/week-01/support/decimal.h) handles command-line input for selected early exercises. Read its interface so you can focus on the new mechanism rather than inventing a second parser before E13. The [Makefile](/source/week-01/Makefile) records exact commands and flags.

## Guided exercises

Keep the original drivers unless an exercise asks you to change one. Implement the requested functions, record each prediction before running, and explain both successful and rejected inputs.

<!-- contract-intro -->
<!-- exercise:E01 -->
<!-- exercise:E02 -->
<!-- exercise:E03 -->
<!-- exercise:E04 -->
<!-- exercise:E05 -->
<!-- exercise:E06 -->
<!-- exercise:E07 -->
<!-- exercise:E08 -->
<!-- exercise:E09 -->
<!-- exercise:E10 -->
<!-- exercise:E11 -->
<!-- exercise:E12 -->
<!-- exercise:E13 -->
<!-- exercise:E14 -->
<!-- exercise:E15 -->

## Practice and stretch

<!-- practice -->

## Your notebook and the next question

Keep observation, explanation, and uncertainty in separate sentences. “The two sums were equal” reports evidence. “Both traversals included the same permitted elements” explains it. “I have not inspected their generated instructions” names a limit.

Week 2 takes the objects you have used and asks where their members lie, how long they exist, and which kinds of references remain valid when storage moves. Before continuing, you should be able to explain why a byte count, an address, and a value answer different questions.

<!-- report -->

## Going further

The [Week 1 further-reading page](/further-reading/week-01) introduces the course's seven companion texts, from *But How Do It Know?* to Hennessy and Patterson, and cross-references every video in this lesson to the sections that explain the same mechanism.
