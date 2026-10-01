# Week 15 beginner section · Put records in order

[Lesson](/weeks/week-15) · [Further reading](/further-reading/week-15)

## Purpose and prerequisites

You have four records and need the smaller keys first. Two records share a key. If a sort returns the right numbers but exchanges those records, did it do what you asked? This week starts with the meaning of a correct result before asking which method runs faster.

Bring arrays, loops, unsigned integers and Week 5's habit of checking correctness before timing. You do not need a completed timing package from another week: this one supplies its own harness. Finish this page able to follow one insertion, explain a merge and a digit pass, and distinguish operation growth from measured time. Allow 2–4 hours in addition to the unpiloted ten-hour core.

## Vocabulary

A **record** is the whole item you move. Our record has a **key**, the unsigned number used for ordering, and a **tag**, its original input position. The tag travels with the key; it lets us distinguish otherwise equal records.

**Stable** means equal keys keep their original relative order. A **permutation** contains exactly the original records, without losing or duplicating any. Correct sorting requires ordering and permutation; our contract also requires stability. A **comparison** asks which key is smaller. A **write** puts a whole record into an array slot under the lesson's explicit counting rule.

**Scratch** is extra caller-provided array storage used while sorting. A **pass** is one traversal stage. A **digit** here is one numeric eight-bit part of a uint32_t key, extracted by shifting and masking. **Complexity** describes how a defined cost grows with input size. **Big O** gives an asymptotic upper bound on that cost function; the function must say whether it describes worst-case, best-case or another workload.

A **trial** is one measured execution. The **minimum** is the smallest observed elapsed time; the **median** is the middle after ordering times; the **mean** is their arithmetic average. A **crossover** is a size where the measured ordering between implementations changes for a specified workload and environment.

## Concepts

### Keep the whole record

You write a validator that checks only whether keys increase. A broken program fills the array with zeros and passes that test. Ordering is therefore only one obligation. The result must also preserve every record. Tags let an independent oracle check the full record sequence, including equal-key order.

Think of sorting appointment cards by date. Each card must keep its patient's name; throwing away cards and writing ordered dates on blank cards does not satisfy the task. The analogy stops at the sorting agreement: the program works with numeric fields and explicit storage, and stability is required only because this API says so.

### Grow an ordered prefix

You have arranged the first few cards, then pick up the next one. Insertion sorting saves that record, shifts larger predecessors right and places the saved record into the gap. Before each insertion the prefix is ordered; afterward it is one record longer and still ordered.

The key detail is “larger.” Shifting an equal predecessor would put a later record before an earlier one. Already ordered input needs little shifting, while reversed input needs a growing number of moves. That explains why input shape matters before you look at a timer. The actual exercise defines exactly which comparisons and writes to count.

### Combine two ordered runs

You have two separately ordered piles and want one ordered pile. Merge sorting compares their front records and copies the smaller into scratch. When keys tie, choose the left run first: its records occurred earlier in the input. Continue until both runs are consumed.

The supplied contract builds runs of doubling width, including an uneven final run, then copies scratch back after each pass. It uses extra storage to make the rule easy to inspect. An in-place merge is a different algorithm with different movement obligations; the name “merge sort” alone does not settle memory cost.

### Group one digit at a time

You want to order unsigned keys without comparing each key against another. A radix pass counts one byte-sized digit, calculates where each group starts and scatters records into those positions. A later digit pass must preserve the order it receives within equal current digits, so earlier lower-digit decisions remain intact.

The core uses four least-significant-digit-first passes for a fixed 32-bit unsigned domain. Numeric shifting makes digit selection independent of host byte order. Sorting signed integers or floating numbers would require another stated key mapping; this lesson does not silently accept those types.

### Name the cost being observed

You time an insertion sort twice without restoring the original input. The second trial receives the sorted output of the first, which changes its work. Copy the original outside each timed interval, then check and consume the result afterward. The benchmark makes those boundaries explicit.

Operation counts describe one specified algorithm; elapsed nanoseconds include its generated code, counter instrumentation and the state of that execution. A favorable minimum and a middle trial answer different questions. Extra scratch traffic can suggest a locality hypothesis, but time alone does not identify cache misses. No fixed winning algorithm or crossover is required.

## Walk-through

The standalone example keeps parallel keys and tags to make record movement visible. In the core you will use a struct so they travel together. Read the while condition before compiling: it moves only strictly larger keys.

<!-- snippet:example -->
```c
#include <stdio.h>
int main(void)
{
    unsigned keys[]={3,1,3,0},tags[]={0,1,2,3};
    for (unsigned i=1;i<4;++i) {
        unsigned key=keys[i],tag=tags[i],j=i;
        while (j && keys[j-1]>key) { keys[j]=keys[j-1];tags[j]=tags[j-1];--j; }
        keys[j]=key;tags[j]=tag;
    }
    for (unsigned i=0;i<4;++i) printf("%u:%u%s",keys[i],tags[i],i==3 ? "\n":" ");
    return 0;
}
```

<!-- output:example -->
```text
0:3 1:1 3:0 3:2
```

The smallest key arrives first with its original tag. The two key-three records retain tags zero then two, demonstrating the required stable order. Merely seeing two threes would not expose an accidental reversal. The automatic snippet check compares the checked-in source and this exact output under both compilers at O0/O2; it is a correctness example, not a timing observation.

## Warm-ups

<!-- warmup:W01 -->
<!-- warmup:W02 -->
<!-- warmup:W03 -->

Run make warmups after implementing the three learner files. Preserve your predictions, including what an invalid digit or overflowing workspace request should leave unchanged.

## Check yourself

Explain why an ordered array of zeros can fail the assignment, why equal keys must retain their tags' order, and why numeric digit extraction differs from reading object bytes. Explain why representable workspace bytes do not guarantee allocation success. Answers are on the [instructor warm-up page](/materials/week-15/instructor/warmups) after your attempt.

## Ready for the lesson

You are ready when you can move a complete record through one insertion, merge two runs while preserving ties, and explain the stable-pass obligation. Keep output correctness, defined operation counts and observed time as separate claims. The [lesson](/weeks/week-15) expands these into three algorithms and a reproducible comparison.

## Read alongside

Start with Beej's function-pointer explanation and the library qsort contract, then Dive Into Systems' locality discussion. Use the [guided further reading](/further-reading/week-15) for all seven companion texts, exact registry citations and the verified HH/CE portions. Consult the named clock reference for the actual timer, rather than inferring its guarantees from an algorithm video.
