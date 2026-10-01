# Complete core, practice and stretch answers

### E01.C

Reference src/local.c checks NULL and INT_MAX, calculates a local value while its lifetime is valid, then stores into the caller’s live output. INT_MIN+1 is allowed. Returned-local bugs are repaired by transferring the value, not merely renaming the pointer. Tests use ordinary and signed boundary cases and verify rejected outputs unchanged. Returning the value directly could also work under a different interface.

### E01.Q

Timeline: helper local exists only inside helper; caller result remains live through its caller block; static counter exists for process execution; allocated ints survive helper return and end at explicit release or successful replacing resize. Owner metadata can itself be automatic while its allocated pointee survives. After resize, read only the newly committed owner. A stack slot is one compiler realization, not the C lifetime definition.

### E02.C

Reference src/static.c uses one zero-initialized static uint64_t counter, rejects NULL before increment and commits the next value. Unsigned wrap is defined. The tests call NULL first then verify the sequence one through one hundred. Scope limits the identifier’s visibility; static duration makes its object survive calls. Sequential correctness does not establish thread safety or independent per-caller state.

### E02.Q

The mutable static counter is shared by every caller and retains process state. Unsynchronized concurrent increments can be a C data race; a sequential pass supplies no synchronization. Two independent clients also do not get independent counters. For reentrant state, pass a separate caller-owned counter, define access policy and synchronize if shared. This week explicitly restricts static_next to single-threaded use.

### E03.C

Reference src/owner.c checks a complete allocator, empty owner, source/count and product bound before allocation. On positive n it allocates fresh aligned storage and copies the values, then commits pointer/count. Empty input succeeds without an allocation. Failure injection verifies no owner mutation; modifying the original source proves the copy is independent. A shallow assignment would preserve the alias and transfer no independently releasable allocation.

### E03.Q

The caller owns its source array for that array's lifetime. owned_copy creates a distinct allocated array and commits a pointer/count into an initially empty owner record. Modifying the source afterward does not modify the allocated copy. The owner record can itself be automatic while the allocation persists until explicit release; each object has a separate lifetime.

Exemplar diagram: caller source [4,7] --copy values--> allocation A [4,7], with owner metadata {data=A,count=2} naming A. The owner alone releases A through its original allocator. Borrows access A only while it is live and within count. Assigning that metadata into another owner duplicates a pointer, not allocation A, and creates a double-release risk. A transfer must clear the source record; an independent clone must allocate fresh storage. The notebook supplies a full event timeline.

### E04.C

Reference src/owner.c validates owner shape and allocator first. Equal count succeeds without callbacks; zero explicitly frees an existing buffer and clears metadata. Positive resizing allocates before touching the owner, preserves min(old,new) ints, writes zero to the new tail, frees the old storage and commits. Allocation failure leaves old pointer/count/elements live and unchanged. owned_release resets one owner and accepts repeated empty cleanup. Tests assert exact release counts and no outstanding allocations.

### E04.Q

Start with owner A holding [4,7]. A failed request for three ints leaves A, count two and both values unchanged; old borrows remain valid. A successful grow allocates B, copies [4,7], writes the new tail as zero, releases A and commits owner B/count three. At that release every borrow of A ends, even if a future allocation reuses the address. A later release ends B and resets the record to empty; a repeat empty release makes no allocator call.

The same allocator must release what it allocated. Shape checks cannot establish allocation origin, accessible live storage or unique ownership; ordering unrelated pointers is not a provenance test. These remain caller obligations. Overflow is rejected before allocation, zero size explicitly releases, and equal count preserves the existing object. Reason from labeled lifetime events rather than inspecting an expired pointer.

### E05.C

tests/diagnose.py runs intentionally invalid fixtures only as isolated child programs, outside normal lab linkage. Both compilers must emit a returned-local-address warning under -Werror; both ASan builds must report heap-use-after-free and double-free with nonzero exit. Recorded logs contain actual platform-specific frames and addresses, not expected fixed output. The repaired caller-value and owner operations pass clean tests separately; a missing diagnostic would not turn invalid C into valid C.

### E05.Q

Exemplar report has a clean-reference table for GCC/Clang debug, optimized and ASan/UBSan, plus a separate expected-failure table for the two compiler warnings and four ASan child runs. Passing these tests establishes the exercised behavior and contracts, not arbitrary-pointer validity, concurrency safety or all possible call sequences. Absence of a warning or ASan report does not legalize undefined behavior.

### P01

The automatic pointer object ends at block/function exit. The separately allocated object remains allocated until explicitly released, even if the program lost its only pointer to it. That loss is a leak, not automatic reclamation. Return the ownership record or store it in caller-provided storage and name the recipient’s release obligation. Storage duration belongs to each object separately.

### P02

A struct assignment copies pointer bits and count, creating two records that appear to own the same allocation. The second release then violates the one-release obligation. Exemplar move protocol: require destination empty, assign its metadata from source, immediately reset source to {NULL,0}, and prohibit concurrent observers during transfer. A deep copy instead requires fresh allocation and copying elements. The core API does not silently provide move semantics.

### P03

On nonzero realloc failure, the old allocation remains valid and the function returns NULL; overwriting the only pointer loses the route to free it. Keep a temporary result and commit on success. This week uses allocate/copy/free to expose that transaction and zero new ints explicitly. It can temporarily require old+new storage and is not identical in performance to in-place realloc. Zero-size behavior is avoided by an explicit release path.

### P04

The header’s invariant permits exactly NULL/zero or non-NULL/positive representable count. NULL/four violates it and fails without changing metadata or invoking callbacks. Shape validation cannot prove the pointer refers to accessible live storage, belongs to this allocator, or is uniquely owned. Those remain caller preconditions. Attempting to dereference an arbitrary pointer to validate it would itself be unsafe.

### P05

No. Successful resizing releases the old object under this API and invalidates all old borrows. Address reuse does not re-establish an old pointer’s provenance or lifetime. Obtain a new borrow from the committed owner and its new count. Do not even print or compare a pointer value after the pointed-to object’s lifetime ends as evidence of validity; reason from labeled lifetime events.

### P06

The mutable static counter is shared by every caller and retains process state. Unsynchronized concurrent increments can be a C data race; a sequential pass supplies no synchronization. Two independent clients also do not get independent counters. For reentrant state, pass a separate caller-owned counter, define access policy and synchronize if shared. This week explicitly restricts static_next to single-threaded use.

### S01

Exemplar move(dst,src): require distinct valid records and empty dst; validate before writes; assign dst=*src then set src={NULL,0}. Empty source succeeds, no allocation/free occurs, and failure leaves both unchanged. Track allocator identity separately or require both records share the same documented allocator; pointer equality does not prove this. Test occupied destination, NULLs, identical records, empty source, populated transfer and one final release through the destination. Diagram: one allocation changes its sole owning metadata record, while existing borrows follow an explicitly stated policy.

### S02

Exemplar handles contain owner ID, generation and index, not a raw data pointer. A stable control record stores current pointer/count/generation and liveness. Resolve checks matching ID/generation plus index<count before reading current data. Increment generation after every successful resize/release, including same-size operation only if the chosen API invalidates borrows; our core same-size path does not. A failed resize retains generation. Prevent generation wrap from revalidating ancient handles by exhausting IDs or rejecting rollover. The control record itself must outlive handles, and concurrency needs locking. It detects modeled stale handles, not arbitrary copied raw pointers.

Additional conceptual notes: The first static calls produce 1 then 2, and a fresh process starts again from zero initialization. A failed grow preserves old borrows; successful grow ends their object lifetime. malloc alignment and allocator provenance are contractual preconditions, not properties inferred by ordering unrelated pointers. The language distinguishes storage duration from identifier scope; stale bytes and address reuse do not extend either.
