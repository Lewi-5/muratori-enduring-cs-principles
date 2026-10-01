# Week 16 beginner section · Who keeps this object alive?

[Lesson](/weeks/week-16) · [Further reading](/further-reading/week-16)

## Purpose and prerequisites

A helper creates a number and returns a pointer to it. Your next print sometimes shows the expected number. It is tempting to conclude that the pointer works. The missing question is whether the object still exists when the caller uses it. This week follows that question through local values, static state and allocated storage.

Bring Week 2's object/pointer distinction and Week 10's warning that old stack bytes do not extend a C object's lifetime. You should recognize a function parameter and output pointer; no allocator internals are assumed. Finish able to label valid access intervals, name one owner for allocated storage and explain allocation failure without losing that owner. Allow 2–4 hours beyond the unpiloted ten-hour core.

## Vocabulary

An **object** is storage holding a value. A **pointer object** holds a pointer value; its **pointee** is the separate object that value designates. Their lifetimes need not match. **Lifetime** is the interval when an object exists and may be accessed according to the language rules. **Scope** is where an identifier can be used to name something.

**Automatic storage duration** usually follows entry and exit of a block in these examples. **Static storage duration** lasts for program execution, even if the identifier is visible only inside one function. **Allocated storage** is obtained through an allocator and lasts until it is released under that contract. A compiler's physical stack frame is one possible implementation of automatic objects, not their language definition.

An **owner** has the responsibility to release an allocation exactly once. A **borrow** permits temporary access without transferring that responsibility. A **deep copy** allocates distinct storage and copies values; a **shallow copy** copies the pointer and metadata. **Commit** means replacing the visible owner only after a requested operation has succeeded. A **diagnostic** is a tool report, such as a compiler warning or sanitizer error.

## Concepts

### Transfer a value while its object is live

You want a helper's calculation after it returns. Its automatic local ends when the helper's block ends, so returning its address does not transfer a live object to the caller. Instead, return the value or store it into a live object supplied by the caller. The copy happens before the helper ends.

Think of writing a result on your own notebook while someone briefly displays it on a whiteboard. Erasing that board does not erase your notebook. The analogy covers value copying, but C validity is governed by actual lifetimes and access rules; unchanged physical bytes after a function returns are not another copy you own.

### Follow each object separately

You place an allocated object's pointer into a helper's automatic variable. When the helper returns, that pointer variable ends, but the allocated object remains allocated until release. Losing the only route to it creates a leak. Keeping a pointer to it in a caller-owned record preserves a route and a release obligation.

The opposite mistake also happens: a pointer variable remains live after its pointee is released. That does not permit reading the former pointee. A diagram should show the two intervals separately. Do not use a printed address as a lifetime test or inspect an expired pointer to prove that its old storage still looks familiar.

### Static storage shares state

You want a helper to remember how many times it has been called. A function-local static counter retains its object across calls while keeping its name inside the helper. Its first initialization happens for the program, not freshly on each invocation.

This convenient persistence also means callers share one counter. It does not create independent results for two clients, and unsynchronized concurrent writes can be a data race. The core static exercise is explicitly single-threaded. For independent or reentrant state, provide a separate caller-owned object and state the access policy.

### Preserve ownership on failure

You own two allocated ints and request a larger buffer. Allocation can fail. If you overwrite the sole owning pointer before checking, you can lose the live original allocation even though it was never released. The lesson makes a safer sequence visible: allocate a candidate, copy the preserved prefix, initialize new ints, release the old object and commit the candidate.

While allocation is pending, the old owner remains unchanged. After a failed attempt it still owns its original data. After a successful replacement the old object's lifetime ends and old borrows become invalid. Take new borrows from the committed owner. The allocate-copy approach can temporarily need both buffers and is not a claim about optimal realloc performance.

### Release one allocation once

You copy an ownership struct into a second struct and release both. The copy duplicates metadata, not allocated storage; the second release targets an already released object. The API therefore forbids shallow copies of owners and requires empty destinations for newly allocated copies.

The repaired release operation frees the owned object and resets its sole record to empty. Releasing that empty record again makes no allocator call. This is a property of the wrapper, not a promise that calling free twice on the same non-NULL pointer is safe. Shape checks can reject inconsistent metadata but cannot prove an arbitrary pointer is live or belongs to this allocator.

### Interpret a report as evidence

You run a broken example under a sanitizer and receive an error. That demonstrates the exercised defect. The same example without a report would still need language-valid access; a tool cannot change the lifetime rule. The returned-local fixture is checked by compiler diagnostics, while use-after-free and double-free are isolated expected sanitizer failures.

The repaired library and playground are tested separately and must run clean. Broken fixtures are never linked into them. Exact report addresses and call frames vary by build, so tests check the kind of error and a failing child process, not one invented universal stack trace.

## Walk-through

The helper copies a live local value into caller storage. The static counter persists between two calls. A distinct allocation remains valid until free; the owner is then assigned NULL without reading its old value. Predict each printed field before running.

<!-- snippet:example -->
```c
#include <stdio.h>
#include <stdlib.h>
static int next(void) { static int count;return ++count; }
static void helper(int *out) { int local=40;*out=local+1; }
int main(void)
{
    int caller=0;helper(&caller);
    int *owner=malloc(sizeof *owner);if (!owner) return 1;
    *owner=7;
    int first=next(),second=next();
    printf("caller=%d static=%d,%d allocated=%d\n",caller,first,second,*owner);
    free(owner);owner=NULL;
    printf("owner cleared=%d\n",owner==NULL);
    return 0;
}
```

<!-- output:example -->
```text
caller=41 static=1,2 allocated=7
owner cleared=1
```

The successful-allocation path prints the copied caller value, two sequential static results and the still-live allocated int. Clearing the owner after release prevents this local record from retaining an apparent ownership obligation; other copied aliases would still need a defined invalidation policy. The snippet returns failure if allocation fails, and its exact successful output is checked under both compilers at O0/O2. It does not show a universal address or frame layout.

## Warm-ups

<!-- warmup:W01 -->
<!-- warmup:W02 -->
<!-- warmup:W03 -->

Run make warmups after completing the typed stubs. The event table is a teaching model, not a runtime test of arbitrary pointers. Preserve invalid-input expectations before looking at its reference answer.

## Check yourself

Name the pointer object and pointee in the example. Explain the difference between scope and storage duration, what a failed grow preserves, and which borrows a successful resize invalidates. Explain the static counter's sharing limit and why a missing sanitizer report is not proof of valid C. Answers are on the [instructor warm-up page](/materials/week-16/instructor/warmups).

## Ready for the lesson

You are ready when your diagram labels creation, helper return and release separately, and gives each allocation one release owner. Keep a valid old owner until a new allocation succeeds, then explain which access windows end. The [lesson](/weeks/week-16) turns that reasoning into a checked API and diagnostic exercise.

## Read alongside

Read Beej's allocation and scope explanations, then CS 341's returned-automatic-pointer bug. The [guided further reading](/further-reading/week-16) links all seven texts with precise citations and the assigned video segments. Use C11 and the platform allocation reference for contracts; a game/platform memory policy is an example of design, not a portable zero-initialization promise.
