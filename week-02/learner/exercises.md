# Assignment — object-layout inspector notebook

Complete ten programs and the notebook. Retain each public function signature and type in `src`; the test harness includes each source with main renamed. Supplied drivers are scaffolding, not functions you must rewrite. Every `.C` prompt requires code plus success and boundary tests; every `.Q` requires a worked explanation. Make predictions before running. Reference [the rubric](../rubric.md) when preparing the single graded submission.

General contract: supplied pointers designate accessible storage of the stated extent. Output objects are distinct, non-overlapping and do not overlap input arrays/strings or the carved block. Functions reject listed errors without changing output objects; validate all inputs before committing results. Input objects may be NULL only where explicitly permitted below. These preconditions avoid making alias-handling an unrelated project. CLI failures print a diagnostic to stderr and return nonzero; success returns zero. Do not execute invalid casts, stale pointers or overflow to discover an answer.

### E01.C

Implement `format_bytes(object,size,out,out_size)` in the supplied signature. On 8-bit-byte implementations, write two lowercase hex digits per byte, separated by spaces and followed by NUL. For n>0 require 3n output bytes without overflowing that calculation; for zero require one byte. Reject NULL output, a NULL nonempty input, insufficient capacity and unsupported `CHAR_BIT`. Zero input may be NULL and produces an empty string. The supplied main prints raw bytes `00 7f 80 ff`, then the representation of uint32_t 0x01020304 and int32_t -2. Test exact versus one-byte-short capacity, zero and an excessive size without reading it. Input/output do not overlap.

### E01.Q

Explain object representation versus value, why unsigned-character access is legal, the risk of sign extension when formatting, buffer arithmetic, and why double bytes or padding are observations. Explain why `memcmp` cannot generally stand in for member-wise struct equality. If using `%02x`, explicitly cast the byte to unsigned; explain promotions rather than relying on a variadic type mismatch.

### E02.C

Implement `is_power_of_two` and `align_up` as declared. Zero is not a power of two. Round value to the smallest multiple of a nonzero power-of-two alignment, returning 1; reject invalid alignment, overflow or NULL output with 0 unchanged. The supplied main prints type/size/alignment for char, short, int, long, long long, float, double, long double, void pointer and max_align_t. Test alignment 8 with values 0,1,8,9; its largest representable multiple; one beyond that; alignments 0,3; and SIZE_MAX with alignment 1.

### E02.Q

Explain alignment, valid power-of-two requirements, fundamental versus extended alignment, and why an ordinary complete type's size must accommodate an aligned contiguous array stride. Derive a division-based and a mask-based rounding formula and show where unchecked addition can overflow. Interpret your type table without assuming universal sizes.

### E03.C

Implement `predict_layout` for `MemberSpec {size,align}`. Reject zero count, zero member size, invalid alignment, size not divisible by alignment, NULL required pointers, or overflow. Offsets, size and align all remain unchanged on error, including a late error. Round each running end up to the next alignment, add the member size, and finally round to the maximum alignment. Use two passes so validation does not partially modify offsets. The driver compares GeoPoint, A and Nested against `sizeof`, `_Alignof`, `offsetof`. GeoPoint contains uint64_t id and two doubles; A contains char/double/int; Nested contains char, Inner(short/double), and unsigned char[3]. Tests of explicit specs are portable arithmetic; compiler comparison is a separately labelled ABI check. Playground: predict a reordered A and explain the resulting size before restoring the submitted driver.

### E03.Q

Work through specs (1,1),(8,8),(4,4), drawing internal and tail padding. Draw the three actual types before running, including the nested member's inner layout. Distinguish C's guarantees from the System V model. Explain the two-pass error contract, tail-overflow case and why summing member sizes is insufficient. Explain what a mismatch on another ABI means.

### E04.C

Implement `layout_map` for `FieldSpan {offset,size}`. Mark member i with the corresponding letter from `ABCDEFGHIJKLMNOPQRSTUVWXYZ`; mark top-level padding with dots. Require positive object size, at most 26 fields, positive field sizes, non-overlapping spans within the object, sufficient output including NUL, and valid non-NULL pointers except fields may be NULL at count zero. Unsorted spans are valid; labels follow input order, not address order. Count zero produces all dots. Reject before writing, including SIZE_MAX object size. The supplied driver uses actual offsetof/member-size information for E03's types. Test synthetic map `A.......BBBBBBBBCCCC....`, adjacent and unsorted fields, exact object endpoint and invalid extents. Playground: add a char after A's int, predict whether size grows, and draw its map before running a modified driver.

### E04.Q

Explain validation, including safe endpoint calculations and pairwise overlap checks. Draw maps for GeoPoint, A and Nested, distinguishing top-level padding from padding inside Inner. Why can padding not be discovered by looking for a particular byte value? Explain how a reordered span list changes labels without changing physical positions.

### E05.C

Implement `member_offset` and `grid_offset`. Reject zero element/member sizes, invalid indices/coordinates, a member that does not fit, a NULL output, and unrepresentable products or additions. Also reject an unrepresentable total array extent, even if the requested early element's offset would fit. For a member compute index*element_size+within; for a grid compute (row*cols+col)*element_size. The driver checks addresses for A recs[4] and int grid[3][4] using equality with byte arithmetic starting at `&recs`/`&grid`, the whole arrays. Test last-valid versus one-past indices and huge numeric requests without allocating huge arrays.

### E05.Q

Explain array stride, tail padding, row-major order, and why typed pointer addition and byte addition use different units. Work out recs[3].count and grid[2][3] symbolically, then with your observed sizes. Distinguish forming one-past, dereferencing it, equality, relational comparison and subtraction. Explain why checking only multiplication is insufficient and how the whole-extent check helps.

### E06.C

Implement the supplied lifetime functions. `counter_bump` returns 1 after incrementing, or 0 unchanged for NULL/INT_MAX. `next_static` returns 1 through INT_MAX and then 0 on every call without overflow; use the checked increment. `next_automatic` returns 1 each call. `frames_distinct` recursively compares simultaneously live child/parent local int addresses, returning 1 for depths 0..1000 and 0 above that. `counter_create(start)` allocates/initializes one int or returns NULL; destroy accepts NULL and frees a successful allocation exactly once. Main demonstrates independent counters and compares two integer address snapshots from sibling calls; both `auto_reuse=yes` and `no` are acceptable. Test INT_MIN, INT_MAX-1, INT_MAX, NULL, depth endpoints, independent counters and injected allocation failure. Sequence stateful calls before printing their values.

### E06.Q

Explain scope versus lifetime versus storage duration. Provide the seven-object table from P02. Why must simultaneously live recursive locals be distinguishable, while sibling calls may reuse storage? Why are integer snapshots taken before return? Explain ownership, checked exhaustion, allocation failure, and the fault in returning an automatic object's pointer for later use. Do observed addresses prove that all locals occupy stack slots?

### E07.C

Implement `is_aligned`, `alloc_aligned` and `carve` using the supplied Header/Record definitions. Numeric address divisibility is a reference-target assumption; reject NULL and invalid alignment in is_aligned. Allocation accepts only `alignof(max_align_t)` and, on the reference target, 64. Reject size zero and all other alignments; round with checked arithmetic before calling aligned_alloc.

For carve require live malloc/aligned_alloc storage with no declared type, alignment suitable for both Header and Record, capacity<=UINT32_MAX, and sufficient extent for Header rounded up to Record alignment plus capacity*Record size. Check all arithmetic before typed casts or writes. Initialize Header to `{0,capacity}` and record i to `{i,0,0.0}`. Zero capacity succeeds with a header, NULL records, and the rounded-header extent. Invalid requests leave both outputs and the block unchanged. Do not carve a declared aligned byte array. The supplied demo's declared 64-aligned arrays are used only to observe alignment. Test exact fit, one byte short, zero capacity, capacity narrowing, block+1 rejection, overflow, allocation failure and 100 writable bytes from alloc_aligned(100,64). Caller owns and frees the allocation; carve does not allocate or free.

### E07.Q

Explain fundamental versus extended alignment, original C11 aligned_alloc preconditions, the whitelist and rounding policy. Explain check-before-cast and why alignment alone does not legalize accessing declared character storage as a struct. Trace the Header/Record layout and initialization. Contrast malloc, calloc and newly supplied OS pages, including the difference between all-zero bytes and semantic zero. Repair the size expression `int bytes = 1024*1024*1024*4` without first overflowing int.

### E08.C

Implement node_at and chain_length. Reserve slot zero for no reference. node_at returns NULL for NULL table, index zero or index>=count. chain_length rejects NULL output, count>1048576, NULL table with nonzero count, out-of-range links and cycles; output is unchanged on rejection. NULL/zero/head-zero is an empty successful chain. Follow at most count-1 usable slots; another nonzero step implies repetition. The supplied driver copies a 1→3→2 index chain and a separate pointer-linked table while both originals are alive. Test empty, valid, out-of-range, self-cycle and two-node cycle. Explain each driver equality instead of dereferencing stale pointers.

### E08.Q

Explain why index links resolve within the copied table but copied pointers still reference the original. Analyze realloc, file loading, undo copies, and reordering/deletion. State the preserved-slot-identity condition and why raw struct copying is not a portable file format. What work does index resolution add, and what does reserving zero cost? Prove that the step bound detects cycles in this finite table.

### E09.C

Complete ex09_data.c using its header and the supplied main. Define shared_counter=7, shared_zero (zero-initialized), shared_limit=100 with external linkage, hidden_counter=3 with internal linkage, and a static local in next_local. The driver has a distinct hidden_counter=3. bump_shared/bump_hidden return 1 after increment or 0 unchanged at INT_MAX; next_local returns successive positives then zero on exhaustion. Accessors return the designated live object addresses; hidden_address is pointer-to-const. Compile two objects and link. Record `make symbols` and `make inspect` observations. Test values, object identity, persistence and the accessible shared-counter overflow boundary.

### E09.Q

Explain declarations/definitions, external/internal/no linkage, static duration and zero initialization. Explain each requested symbol's typical section and nm letter, why file-scope const has external linkage in C, and why include guards do not fix multiple data definitions across translation units. What role does -fno-common play for tentative definitions? Show the separate compile/link commands; distinguish tool observations from language rules.

### E10.C

Complete main by composing your copied E02–E04 helpers with the supplied parse_types. Accept exactly one list of 1..26 names from `char short int long llong float double ldouble ptr`. The parser rejects empty elements, unknown names, whitespace, extra commas and too many fields without committing outputs. Main allocates a map only after a valid representable layout; clean it up on all later exits. Print `members=N size=S align=A padding=P`, one `A char offset=O size=S align=A`-style line per field, then `map=...`. Test both char,double,int and double,int,char, singleton, all scalar vocabulary, 26 fields, 27 fields, missing/extra arguments and malformed tokens. Draw both field-order diagrams before running.

### E10.Q

Explain how arithmetic, layout and map contracts compose; why lookup sizes/alignments are platform-dependent; and how padding=size-sum(member sizes) is justified. Walk through a valid request and every error class. Compare your predicted diagrams to output, and explain why the prediction/reconciliation rather than merely obtaining the tool's output demonstrates understanding.
