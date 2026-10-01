# Worked answers — objects, bytes, and storage

The linked C files are complete annotated implementations, not pseudocode. Each coding answer explains correctness, boundaries and a plausible faulty approach; each question answer supplies the reasoning independently of test output. The weekly guide links primary C11, ABI and tool references. Numeric examples below are explicitly either synthetic model inputs or ordinary x86-64 Linux observations, never universal layout constants.

### E01.C

[ex01.c](src/ex01.c) validates every rejection condition before writing output. For four bytes the text occupies 11 visible characters and one NUL, exactly 12 bytes; one byte needs two digits and NUL. Zero input instead needs one NUL. Comparing size to SIZE_MAX/3 before computing 3*size prevents overflow. The loop selects high/low nibbles from an unsigned byte using a hexadecimal alphabet, so 0x80 becomes `80`, not a sign-extended integer. Its last separator is replaced with NUL. A faulty implementation checks `out_size < 3*size` after that product has wrapped or writes some bytes before discovering insufficient space. The preflight fixes both. For unsupported CHAR_BIT the routine rejects without access, and main labels the demonstration skipped.

### E01.Q

A value is the mathematical content of an object; representation is the sequence of bytes storing it. uint32_t 0x01020304 has the same value on two machines that show `04 03 02 01` and `01 02 03 04` respectively. Character lvalues may inspect any object's representation without violating effective-type access rules. Using unsigned char also avoids interpreting 0x80 as a negative signed character. If printing with `%02x`, use `(unsigned)bytes[i]` because the format requests unsigned int; small unsigned characters commonly promote to int in variadic calls, and explicit conversion makes the correspondence clear. The reference avoids printf conversion entirely while constructing the string.

int32_t, when provided, has no padding and a two's-complement representation even under C11; -2 therefore has the octet multiset fe/ff/ff/ff on our 8-bit-byte target. That does not extend to every signed C type. Floating encodings, byte order and aggregate padding are separate matters. Structs with equal member values can have different padding, so memcmp can report a difference unrelated to the logical fields. Floating members can also have multiple representations of values comparing equal, such as signed zero. Compare logical members under the intended equality policy, not raw storage. Reading bytes is a representation observation, not a portable serialization scheme.

### E02.C

[ex02.c](src/ex02.c) identifies a nonzero power of two by testing whether clearing its lowest set bit yields zero. For alignment a, let mask=a-1; after verifying the addition fits, `(value+mask)&~mask` rounds up. Inputs 0,1,8,9 at alignment 8 yield 0,8,8,16. The largest representable aligned value succeeds; the next value fails rather than returning a small wrapped offset. Alignment 1 accepts SIZE_MAX unchanged. The output is assigned only after validation, so a rejected request retains its caller's sentinel. A common wrong version omits the value<=SIZE_MAX-mask check. Another treats zero as a power of two; the initial nonzero condition is essential.

### E02.Q

Alignment constrains the addresses at which a type's objects can reside. C11's valid alignment values are powers of two; this does not mean every power of two is supported. Fundamental alignments are at most alignof(max_align_t); extended alignment support and contexts are implementation-defined. For an ordinary complete type, sizeof must provide a stride that preserves alignment in an array, whose elements are contiguous. Thus the table tests size modulo alignment and relative relationships, not particular numbers. Typical long and void-pointer size/alignment 8/8 are ABI observations.

Mathematically rounding up is `ceil(value/a)*a`, often written `(value+a-1)/a*a`; the intermediate addition needs checking. A safer division-based formulation computes remainder=value%a and, if nonzero, adds a-remainder after checking capacity. For power-of-two a, the low bits identify the same remainder, enabling the mask version. With value=9,a=8, add seven to get 16 and clear the bottom three bits, leaving 16. Near SIZE_MAX, blindly adding seven would wrap and could make a later buffer check falsely succeed. Arithmetic proofs must include intermediate values, not only the intended final answer.

### E03.C

[ex03.c](src/ex03.c) performs a complete dry run, checking each member and all arithmetic including final tail rounding. A second pass commits offsets only after success is known. This avoids temporary heap storage and preserves all outputs on a late failure. Input/output disjointness is a documented precondition; changing the input through an aliased offset would invalidate the second-pass proof. Explicit specs (1,1),(8,8),(4,4) produce offsets 0,8,16, maximum alignment 8, end 20 and total size 24. A 64/64 member after a char gives offset 64 and total 128; this is a numeric-model test, not a claim that any compiler supports such a type. The faulty single-pass implementation writes offset[0] and only then rejects member[2], breaking the unchanged-on-error promise.

### E03.Q

For the synthetic three-member input, char spans byte 0, bytes 1..7 pad to alignment 8, the next member spans 8..15 and the four-byte member spans 16..19. Bytes 20..23 make the stride a multiple of eight. Summing the sizes gives 13 and misses both gaps. The typical reference diagrams are:

```text
GeoPoint: [0..7 id][8..15 lat_deg][16..23 lon_deg]       size 24, alignment 8
A:        [0 tag][1..7 pad][8..15 value][16..19 count][20..23 tail]  size 24
Inner:    [0..1 code][2..7 pad][8..15 value]             size 16, alignment 8
Nested:   [0 tag][1..7 pad][8..23 Inner][24..26 bytes][27..31 tail] size 32
```

Inner enters the outer model with its whole size 16 and alignment 8, including its internal padding. The model does not flatten the nested members. Reordering A to double/int/char yields offsets 0,8,12 and total 16 on this ABI. C specifies ordered ordinary members, suitable alignment and no initial struct padding, but not all those numeric positions or the minimum-padding algorithm. The System V reference explains this compiler observation. An ABI mismatch elsewhere means the model needs another policy, not that the C implementation is broken. Even a final tail alignment can overflow after every member fits, for example an end at SIZE_MAX needing alignment 2; the dry run catches it before output commit.

### E04.C

[ex04.c](src/ex04.c) first validates object/buffer extents and all spans. It checks `size <= object_size-offset` before computing an endpoint, then compares each span against earlier spans to detect overlap. With at most 26 fields, the small pairwise scan is understandable and sufficient. Only after validation does memset fill the map with dots and overwrite member spans. Input order controls label identity, so spans {2,2},{0,2} produce BBAA. A zero-field positive-size object maps entirely to dots, but a zero-size object is rejected by policy. A faulty approach sorts spans without retaining their original labels, or writes a map while still checking later spans. Both violate the specified observable contract.

### E04.Q

The reference top-level maps corresponding to the previous diagrams are:

```text
GeoPoint: AAAAAAAABBBBBBBBCCCCCCCC
A:        A.......BBBBBBBBCCCC....
Nested:   A.......BBBBBBBBBBBBBBBBCCC.....
Inner:    AA......BBBBBBBB       (separate nested detail)
```

All 16 bytes of Nested.inner are marked B, including that member's own padding. Dots in the outer map mean only bytes outside its immediate members. Map construction uses declared offsets/extents, never the stored byte values. The driver's SPAN macro uses a null-based member expression only as the unevaluated operand of sizeof for these fixed-size members; it does not actually dereference NULL. A store to a struct or member can leave padding bytes unspecified; zero-valued members also contain zero bytes, so “zero byte means padding” fails in both directions. Adjacent spans are allowed because overlap uses strict endpoint inequalities. A span ending exactly at object_size fits; one byte beyond fails. Out_size must exceed object_size to leave room for NUL, and SIZE_MAX cannot have an additional representable byte. In the playground, adding char after A.count uses byte 20 and still leaves total 24 on the reference ABI; it replaces one tail-padding byte with a real member. Other ABIs may differ.

### E05.C

[ex05.c](src/ex05.c) rejects invalid dimensions and checks the whole array extent before deriving the selected offset. The member calculation then validates that within+member_size fits without first evaluating a possibly overflowing addition. The final base+within also has an explicit check. For a grid, validate rows*cols, total byte extent, row*cols+col and then the element stride. This somewhat redundant arithmetic makes the proof local. It rejects impossible huge-array requests even when row zero would give offset zero. A faulty implementation verifies only `index<count` and then lets index*element_size wrap; the synthetic tests catch this without allocating huge storage. No output changes on failure.

### E05.Q

The symbolic member address is `3*sizeof(struct A)+offsetof(struct A,count)`, giving 3*24+16=88 in the sample layout. A's tail padding is included in every 24-byte stride. grid[2][3] has element number 2*4+3=11, hence offset 11*sizeof(int), ordinarily 44 bytes. `recs+1` advances a whole struct, while a pointer to its unsigned-character representation advances one C byte. Starting from `(unsigned char *)&recs` names the representation of the whole array, allowing offsets across its elements without treating one element's representation as the whole allocation.

One-past an array may be formed for a boundary but not dereferenced; farther arithmetic is not justified. Equality can compare pointers across objects, while arbitrary relational comparison and subtraction cannot order unrelated allocations portably. Subtraction within one array gives element units and requires representability in ptrdiff_t. Checking a product alone is insufficient: on a 64-bit size_t, index=SIZE_MAX/3 and element_size=3 produce a fitting product equal to SIZE_MAX, but adding within=1 overflows. Rejecting the impossible whole extent and checking addition prevent that failure. Numeric-address stories do not replace the language's object boundaries.

### E06.C

[ex06.c](src/ex06.c) centralizes safe increment in counter_bump. It returns a status, not the new value: at INT_MAX it leaves the counter untouched; at INT_MIN it safely advances by one. next_static uses that helper and returns zero once its positive sequence is exhausted. The recursion passes a live local's address only down to a callee that finishes before the parent's return. Depths over 1000 are rejected before recursion. Allocated counters are separately owned and initialized; partial allocation failure in main frees whichever allocation succeeded. The supplied snapshots convert addresses to uintptr_t before each local dies. A faulty printf containing several next_static calls does not guarantee left-to-right argument evaluation; the driver obtains the values in sequenced initializers before printing. Fault tests force allocation failure and count successful releases.

### E06.Q

Storage duration describes how long storage is retained; lifetime describes when a particular object may be used; scope describes where a name is visible. A static local has block scope but static storage duration and retains values across calls. An automatic local is a fresh object on each entry. The P02 table below provides all seven requested cases. Recursively active caller/child locals are distinct live int objects whose addresses can be compared. Sibling calls need not coexist and may use the same address; an integer snapshot records that target observation without evaluating an expired pointer. A pointer value becomes indeterminate when the object it points to reaches lifetime end, so saving an int * and printing it after return is not the required safe experiment.

An allocated counter persists until free, independently of the scope of the pointer variable returned by create. Only its owner releases it, exactly once; destroy(NULL) has the library's harmless-null behavior. Returning `&local` to a caller that later accesses it is faulty because the object has already died. Neither the language's automatic duration nor a printed address establishes that every local occupies a stack slot: an optimizer can use a register, fold a value or erase an object when allowed. Even the recursive demonstration can be simplified if its observable result is preserved. The INT_MAX tests exercise the same checked helper used by next_static; they do not perform billions of calls to reach exhaustion.

### E07.C

[ex07.c](src/ex07.c) separates acquisition from carving. alloc_aligned accepts only documented alignment choices, rejects zero, rounds safely and forwards allocation failure. On the reference target, 100 at alignment 64 requests 128 bytes. carve validates pointers, capacity narrowing, base alignment, offset rounding, multiplication/addition and available extent before any typed store. With the sample Header size 8/alignment 4 and Record size 16/alignment 8, records begin at offset 8 and capacity three needs 56 bytes. Header becomes count=0/capacity=3; records get ids 0,1,2, next=0 and weight=0.0. Capacity zero needs eight bytes here and returns a NULL Record pointer, avoiding formation of a needless one-past typed pointer. Record ids are slots here, not a persistent identity system.

Failure leaves the supplied block and output pointers unchanged. Tests prefill raw allocated bytes to verify this, including one-byte-short and block+1 cases. A faulty implementation casts first, checks afterward, then truncates size_t capacity into uint32_t; validate before both conversion and narrowing instead. The block remains owned by the caller, and returned interior pointers are never separately freed. Numeric uintptr_t divisibility and extended alignment demonstrations are explicitly reference-target observations.

### E07.Q

malloc supplies alignment for fundamental types; it does not promise every extended alignment. The original C11 aligned_alloc contract requires a supported alignment and size divisible by that alignment. Rejecting arbitrary requests before the call avoids relying on later defect-correction behavior for invalid arguments. The whitelist is a deliberately small course API, not a discovery algorithm for every platform alignment. The byte-offset pointer is formed only after checking the needed size; conversion to Record * happens only at a known aligned position. Outputs must be separate from the carved block so initialization cannot overwrite them.

Allocated storage has no declared type: storing Header/Record values through typed lvalues establishes the effective type for those accesses. A declared unsigned char buffer instead has a declared character-array type; adding `_Alignas` fixes possible alignment but does not turn it into a declared State object or untyped allocated storage. Use a real State, or malloc storage, rather than casting that declaration. malloc bytes are indeterminate. calloc initializes all bits to zero, which does not universally guarantee floating 0.0 or a null pointer representation. Fresh OS pages in the video's environment may arrive zeroed under that platform contract; that is not a malloc guarantee. The reference initializes weight with the C value 0.0 explicitly.

`1024*1024*1024*4` can overflow int before an assignment to a larger type; widening the destination is too late. Start with size_t and check every multiplication, e.g. a helper verifies `factor <= SIZE_MAX/value` before `value*=factor`, starting from value=1. On a 32-bit size_t the requested four GiB still cannot fit and should reject; on the reference target it fits. Correct intermediate arithmetic and representable final size are separate requirements.

### E08.C

[ex08.c](src/ex08.c) treats zero as a terminal index and validates each nonzero link before dereferencing. Because only count-1 slots are usable, encountering another nonzero link after that many visits proves repetition. It commits the resulting length only on successful termination. The cap bounds worst-case work; a supplied count is not used to bypass pointer validity. NULL with zero count and zero head gives length zero; NULL with nonzero count rejects even with an empty head. The demo's copied indices resolve against the copy, but its copied pointer links still compare equal to original addresses while both arrays remain alive. A faulty implementation frees the original before making those pointer comparisons or follows links forever; the reference does neither.

### E08.Q

In slots 1→3→2→0 the sequence of integers contains no base address. Replacing the base while retaining those slots produces the same length three. A pointer-linked copy instead contains the old address of original[3]; memcpy does not rewrite pointer referents. Successful realloc ends the original allocation's lifetime, even if the returned allocation uses the same numeric address, so use the returned base and recompute references. Index meaning survives only if rows keep their identities at those indices. Reordering or recycling slot 3 can silently redirect an index to another record; bounds checks alone cannot detect that semantic error.

Saving indices removes process-address dependence but does not define integer byte order, struct padding, versions or validation rules. Portable file formats need explicit encoding and checked reconstruction. Undo copies can use indices against the selected snapshot; copied raw pointers still refer to the original snapshot unless rebuilt. Resolving an index adds validation plus base/stride calculation, and slot zero sacrifices one addressable row for a simple sentinel. The step-limit proof uses the pigeonhole principle: a nonterminating walk through at most count-1 usable nodes must revisit one. No hash table or visited allocation is necessary for this bounded singly linked walk.

### E09.C

[ex09_data.h](src/ex09_data.h), [ex09_data.c](src/ex09_data.c) and [ex09_main.c](src/ex09_main.c) put declarations, definitions and a caller in separate files. The driver stores the before value, increments explicitly, and records two next_local calls before formatting. shared_address equals the caller's &shared_counter, while the two live hidden_counter objects have distinct addresses and independent values. Tests also set the accessible shared counter to INT_MAX and verify failure leaves it unchanged. A faulty header defines `int shared_counter=7` in every translation unit; declare it extern in the header and define it once in data.c.

Equivalent strict commands from week-02 are:

```sh
mkdir -p build/manual
gcc -std=c11 -Wall -Wextra -Wpedantic -Werror -fno-common -O0 -c instructor/src/ex09_main.c -o build/manual/main.o
gcc -std=c11 -Wall -Wextra -Wpedantic -Werror -fno-common -O0 -c instructor/src/ex09_data.c -o build/manual/data.o
gcc build/manual/main.o build/manual/data.o -o build/manual/ex09
nm build/manual/main.o build/manual/data.o build/manual/ex09
```

The Makefile performs the same separate-object process with compiler/mode-specific paths.

### E09.Q

A declaration states a name and type; a definition supplies an object. External linkage lets declarations in different translation units denote shared_counter. Internal linkage keeps each file's hidden_counter private, so matching spelling does not make them the same object. The static local has no linkage but static duration; static duration does not imply external visibility. Uninitialized static-duration integers are initialized to zero by C, regardless of whether the toolchain uses .bss to implement that. File-scope const in C retains external linkage unless otherwise specified, unlike the common C++ rule.

Typical nm results are D for initialized shared_counter, B for shared_zero, R for shared_limit, d for each hidden_counter and b with a generated name for the zero-initialized local. Lowercase normally denotes a local symbol for these categories, uppercase global; nm has exceptions for other symbol kinds, so this is not a complete universal letter rule. ELF sections and compiler naming are implementation mechanisms, not C concepts. Include guards stop repeated text inclusion within a translation unit, not duplicate definitions across units. `int shared_zero;` at file scope is a tentative definition, not the same as `extern int shared_zero;`. Historical common-symbol behavior sometimes merged such definitions; -fno-common exposes erroneous multiple definitions instead. It does not change C's intended single-definition discipline.

### E10.C

[ex10.c](src/ex10.c) composes the validated helpers. The supplied parser tokenizes without modifying input, accepts exact vocabulary entries, and commits at most 26 specs/names only after validating the whole string. Main predicts layout before allocating size+1 bytes, builds spans from accepted offsets, then renders and prints. The sum of member sizes is bounded by the successful total layout, so subtracting it gives nonnegative padding. It frees the map after use and on map failure. A faulty parser based on tokenization that silently skips empty comma fields might accept `char,,int`; the supplied parser deliberately rejects it. A faulty main adds one to SIZE_MAX or prints a map after allocation failure; the reference checks before both operations.

### E10.Q

On the sample ABI, char,double,int yields size=24,align=8,padding=11 and map `A.......BBBBBBBBCCCC....`; double,int,char yields size=16,align=8,padding=3 and map `AAAAAAAABBBBC...`. Both have the same 13 member bytes. Type lookup derives actual sizeof/_Alignof values from this compiler. A single char needs no model padding; 26 chars fit the label alphabet, while 27 are rejected rather than producing an invalid label. Missing/extra CLI arguments, an empty string, leading/trailing/doubled commas, spaces or unknown/case-mismatched names all fail before layout output. Alignment/extent overflow and map-allocation failure are separate later errors.

Contract composition matters: a successful predictor yields nonoverlapping valid spans whose total fits, allowing the map preconditions to be met. Passing arbitrary unvalidated offsets would break that reasoning. The output is evidence to compare with a prior diagram; copying the output into the prediction column afterward would demonstrate only tool use. A failed prediction should identify its mistaken rule, such as omitting tail padding, then correct the explanation without erasing the original hypothesis.

### P01

(a) Portable relationship for an ordinary complete struct type: arrays require an aligned stride, including tail padding. (b) An ABI observation for the reference char/double struct, not a fixed C offset. (c) Character access can inspect padding, but its contents need not be stable or meaningful; padding can be unspecified after stores. Do not infer field boundaries or logical equality from its value. (d) Conditional: converting to an incorrectly aligned int * is undefined, but char buf's starting address and alignment of int must be known before claiming that buf+1 is necessarily misaligned on every implementation. Even an aligned conversion does not justify accessing this declared char array as an int object. (e) Incorrect equality rule: equal fields may have different padding; representation equality and semantic member equality are different questions. memcmp is not automatically undefined merely because the objects contain padding, but its result is unsuitable as that semantic test.

### P02

| Object | Storage duration | Linkage | Initial content | Lifetime end |
| --- | --- | --- | --- | --- |
| file int global=7 | static | external | 7 | program termination |
| file int zero | static | external | 0 | program termination |
| block static int local | static | none | 0 | program termination |
| block int automatic=2 | automatic | none | 2 on each entry | leaving its block |
| successful malloc object, before store | allocated | no identifier/linkage | indeterminate bytes | deallocation; successful realloc ends the original object's lifetime |
| string literal "hi" | static | no identifier/linkage | h, i, NUL | program termination |
| block-scope (int){9} | automatic | no identifier/linkage | 9 | end of its enclosing block's lifetime |

The pointer variable receiving malloc's result might itself be automatic while the allocation outlives that variable's scope. The string literal is an array object with static storage duration, but modifying it is undefined even though its C array element type is char. A block-scope compound literal does not disappear at the end of its immediate expression; its enclosing-block lifetime matters. Those distinctions prevent the false equation “no visible name means no living object.”

### P03

Original fields A=char,B=double,C=short,D=int,E=char,F=short have offsets 0,8,16,20,24,26 under the supplied synthetic pairs. Ends are 1,16,18,24,25,28; largest alignment is eight, so size is 32. Member bytes total 1+8+2+4+1+2=18 and padding totals 14. Ordering B,D,C,F,A,E (double,int,short,short,char,char) gives offsets 0,8,12,14,16,17, ends at 18 and rounds to 24. Padding becomes six and savings eight bytes. Run E10 with those two exact type lists; on the reference ABI it agrees. If another platform has different pairs, the synthetic calculation remains correct for its stated inputs while the observed tool result answers a different set of inputs. Neither establishes a speed improvement.

### P04

The subtraction yields 3 with type ptrdiff_t: elements 1 and 4 are in the same array. &recs[5] is the allowed one-past pointer; &recs[6] would require going farther and is not permitted. One-past is not a sixth object to read. Equality comparisons between valid object pointers are defined; pointers to distinct live elements in different arrays compare unequal, while one-past/boundary cases require care and should not be generalized from integer addresses. Relational ordering across unrelated arrays has no general defined C meaning, and subtraction is likewise restricted. The byte spacing from element 1 to element 3 is `2*sizeof(struct Rec)`. To inspect positions, compare character pointers obtained from the representation of the whole array plus validated offsets; do not manufacture a subtraction between unrelated object representations.

### P05

Assuming 256>=sizeof(State) and State requires only fundamental alignment, malloc's returned region is suitable and has no declared type; a typed store can establish State access. The declared char array may additionally lack required alignment, and both declared character arrays retain their declared types. `_Alignas(max_align_t)` fixes only the alignment issue. It is not a C11 general-purpose escape from effective-type rules.

A repair is `struct State state = {0, 0.0};` and use &state. For moving bytes, create a valid State source, copy its representation into a byte buffer with memcpy, then copy it back into a declared State destination before accessing that destination's fields. The buffer remains character storage throughout. Arbitrary file bytes need validation and a specified encoding; copying invalid/trap representations does not make them valid. Another repair allocates sizeof(State), checks failure, assigns the State value, then frees once. HH014's platform block illustrates separating allocation from state organization, but the Windows/C++ API's alignment, initialization and lifetime assumptions must be translated explicitly for a C11 implementation rather than assumed from the video.

### P06

After successful realloc, old interior pointers cannot be reused; resolve from the returned base. Index links retain meaning only if the same row identities remain at the same slots. On failure, realloc leaves the original allocation intact; avoid overwriting its sole pointer before testing success. File saving/loading cannot persist process pointers usefully. Indices are address-independent but still need a format specifying byte order, widths, bounds, versions and reconstruction. Undo snapshots with preserved ordering can resolve identical indices against each selected snapshot; copied pointers require rebuilding if they are meant to refer to the snapshot rather than the original.

Deletion, compaction, reordering and reuse can invalidate index meaning even while every index is in bounds. A later design might use remapping or generation identifiers; this week's exercise states the limitation rather than implementing that system. Resolution costs include checks and base-plus-stride calculation; pointer links hold direct addresses but still need lifetime discipline. Reserving slot zero gives a simple absent-link sentinel at the cost of one usable row. The central benefit is controllable reference interpretation, not a claim that indices are always better or automatically safe.

### S01

[permutations.c](extras/permutations.c) enumerates field identities recursively, with a used-bit mask and depth five. Each identity is selected once, so it visits 5!=120 orders, including distinct A/E char positions. The first pass computes minimum/maximum; the second prints every minimum order. On the reference sizes the minimum is 16 and maximum 32; B,D,C,A,E is one minimum. The test runner compares the entire printed minimum set against an independent arithmetic enumeration, not just those two numbers.

Proof: in descending alignment order, every preceding member's alignment is a power-of-two multiple of the current alignment. Every preceding size is a multiple of its own alignment, hence of the current alignment. Starting at zero, the running end is therefore already aligned for each new member: no inter-member padding is needed. Every valid layout must contain at least the sum of sizes and have total size divisible by the largest alignment. The descending construction achieves that lower bound rounded up to the largest alignment, so it is optimal throughout this model, including aggregate members whose size exceeds alignment. This corrects the original plan's too-narrow scalar claim.

There can be several optimal orders, as the enumeration shows. Real constraints outside this model include fixed external field order, packed layouts, bit-fields and other ABI rules; optimal model ordering does not override those contracts. Smaller size alone also says nothing decisive about a particular program's speed. The stretch runs no timing experiment.

### S02

[symbol-observations.md](symbol-observations.md) records an actual reference build excerpt. Use `make PACKAGE=instructor symbols inspect` to obtain your own. shared_counter typically appears as D in .data, shared_zero as B in .bss, shared_limit as R in .rodata, each private initialized counter as d in its own .data, and the static local as b with a compiler-generated suffix. That suffix identifies an implementation symbol, not a new C linkage category.

readelf's section headers distinguish .bss as NOBITS: the zero-initialized region has a memory extent but no corresponding payload bytes in the file. Section headers and other metadata still occupy file space, so “.bss takes no file space” should mean no data payload, not no metadata. The loader/runtime arranges the required initialized process image. A relocation against shared_counter records where a reference must be fixed up, the target symbol, relocation type and often an addend; the linker combines it with the definition's location. On this x86-64 build a PC-relative relocation commonly appears. Exact offsets, generated local names and optimizer choices can differ. Relocation records describe address resolution, not the object's integer value or lifetime by themselves.
