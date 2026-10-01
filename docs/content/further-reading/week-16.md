# Week 16 further reading · Object lifetimes and allocation ownership

[Lesson](/weeks/week-16) · [Beginner section](/beginners/week-16)

You call a helper, receive a pointer and still see the old value in memory. That appearance is tempting, but a pointer’s bits cannot keep an object alive. Begin with Scott’s “Addresses” to separate a storage location from the data stored there. Its hardware account does not define C object lifetime, so carry the question into Beej.

Read Beej’s scope and storage-class discussion, then manual allocation. Name two objects whenever a pointer appears: the pointer variable and its pointee. The pointer may be automatic while the allocation persists beyond the helper. Use the C Library Reference malloc/free/realloc entries to follow success, failure and release. Do not infer automatic zeroing from a platform video; the core explicitly initializes new ints where it needs zeros.

Dive Into Systems’ program-memory and dynamic-allocation sections connect this model to typical process layouts. The hard part is treating a familiar stack/heap picture as the language rule. CS 341’s returned-automatic-pointer bug directly addresses that mistake; its process-contents section helps explain the layout without proving pointer validity. Draw valid access intervals before investigating addresses.

CS:APP’s local-storage and allocation sections then connect generated frames to library contracts, while its memory-error discussion provides a vocabulary for the diagnostic experiment. An ASan report demonstrates an exercised invalid access; absence of a report cannot legalize an expired pointer. These sections become easier with the repaired owner API and its failure-injection tests beside them.

Finally use Hennessy and Patterson’s quantitative design principles to reason about old-plus-new storage during replacement. That deeper account supports resource tradeoffs but does not define our single-owner protocol or say which allocator is universally best. HH’s platform policy and variable-allocation discussion are design examples, not C11 guarantees; CE’s architectural stack describes saved continuations, not source-object storage duration. Read the rows below in gentle-to-deep order and use the named C/library references for the exact boundary.

## Cross-reference

<!-- crossref -->

## Reading questions

<!-- reading-questions -->
