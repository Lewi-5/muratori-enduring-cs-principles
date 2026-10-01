# Notebook exemplar

### R01

Timeline: helper local exists only inside helper; caller result remains live through its caller block; static counter exists for process execution; allocated ints survive helper return and end at explicit release or successful replacing resize. Owner metadata can itself be automatic while its allocated pointee survives. After resize, read only the newly committed owner. A stack slot is one compiler realization, not the C lifetime definition.

### R02

Returned-local fixture: compiler rejects returning an address of an automatic local; local_value writes into storage that belongs to the caller. Use-after-free fixture: ASan identifies a read after free; retain ownership while reading or copy the needed value before release. Double-free fixture: ASan identifies releasing the allocation twice; owned_release resets the sole owner and repeats empty release without calling the allocator. Record actual tool-specific reports; exact addresses and frames are not golden output.

### R03

The tracking allocator records attempts separately from successful allocations, tracks each live pointer and asserts each release belongs to a live slot. Failure injection returns NULL without an allocation. Before/after checks compare owner pointer/count and elements only while that old object is still live. Successful resize releases exactly once and produces preserved prefix plus zero tail. At final cleanup allocations==releases and all live slots are empty; failed attempts are not counted as owned objects.

### R04

Exemplar report has a clean-reference table for GCC/Clang debug, optimized and ASan/UBSan, plus a separate expected-failure table for the two compiler warnings and four ASan child runs. Passing these tests establishes the exercised behavior and contracts, not arbitrary-pointer validity, concurrency safety or all possible call sequences. Absence of a warning or ASan report does not legalize undefined behavior.

### R05

Allocate-copy resize temporarily retains old_count*sizeof(int)+new_count*sizeof(int) element storage, excluding allocator metadata. A clear API can require empty destinations, forbid shallow owner copies and document borrow invalidation at each commit. Later arenas can group release obligations but cannot make a pointer outlive released arena storage. Fill actual learner times rather than using the unpiloted estimate as evidence.


Lifetime/ownership diagram (labels, not physical addresses):

`	ext
caller result:  create ---- helper stores ---- helper returns ---- caller block exits
helper local:                 create--copy--end
static state:  program initialization --------------------------- program ends
source array:  caller owns -------------------------- caller block exits
owner record:  empty --> allocation A --> failed grow (still A) --> allocation B --> empty
allocation A:          create ------------------------- release at successful grow
allocation B:                                          create -------- release
borrow of A:           valid only while A is live ----- invalid after replacement
`

The pointer field in the owner and the allocated int array are separate objects. Failed grow preserves both A and its borrows. Successful grow copies values into B before ending A, then commits the new owner. No old pointer is evaluated after that event; take a fresh borrow from B. This diagram represents C/API obligations, not one compiler stack layout.
