# Reading answers

### F01

Architectural PUSH/CALL/RET manipulate machine storage and saved continuations; C specifies object lifetimes independently. An automatic local may occupy registers or vanish under optimization, while static and allocated storage have different duration rules. Read CS:APP frames for a compiler example and CS 341’s returned-local bug for the language error; do not infer legality from old stack contents.

### F02

HH demonstrates a game/platform allocation policy and later general allocator reasoning. C malloc provides uninitialized suitably aligned allocated storage for an appropriate request, with NULL failure; it does not promise the platform’s pages always start zero. Our resize zeros newly added ints explicitly. free releases an owned allocation; caller metadata reset is our API policy, not something free performs automatically.

### F03

Failed nonzero replacement leaves the old live allocation and its borrows valid under our contract. Successful replacement frees it and commits a new object, invalidating old borrows. Use Beej’s allocation pages and C11 §7.22.3 for language/library rules, CS 341 and CS:APP for bugs. The companion accounts do not define our callback allocator, empty-owner invariant or generation-handle extension.
