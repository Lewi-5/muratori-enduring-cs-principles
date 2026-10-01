# Practice and optional stretch

The six practice problems are ungraded preparation for the notebook. The stretch tasks are optional and additional to the core time estimate. Preserve IDs in your answers. Reason about invalid expressions as text; do not execute them.

### P01

Classify and justify: (a) `sizeof(struct S) % _Alignof(struct S) == 0` for an ordinary complete struct type; (b) the double member of `{char c; double d;}` is at offset 8; (c) reading struct padding through unsigned char determines a stable value; (d) converting `buf+1`, for declared char buf[8], to int * is always valid; (e) memcmp implements member-wise equality of two structs. Distinguish portable guarantees, ABI/implementation choices, unspecified contents, conditional undefined behavior, and incorrect conclusions. Do not assume that buf+1 is necessarily misaligned on every implementation.

### P02

Fill storage duration, linkage, initial value and lifetime end for: file-scope `int global=7`; file-scope `int zero`; block-scope `static int local`; block-scope `int automatic=2`; the object allocated by successful `malloc(sizeof(int))` before its first store; the string literal `"hi"`; and block-scope `(int){9}`. Distinguish the allocated object from the variable holding its pointer.

### P03

Using synthetic size/alignment pairs char=(1,1), double=(8,8), short=(2,2), int=(4,4), predict offsets, size and alignment of fields `char,double,short,int,char,short`. Reorder the named fields to minimize total size and calculate savings. Run the same two name lists through E10; explain any mismatch if your actual platform differs from these specified pairs.

### P04

For `struct Rec recs[5]`, give the value and type of `&recs[4]-&recs[1]`. Which of `&recs[5]` and `&recs[6]` may be formed? Explain == and < between pointers into different arrays. Give the byte distance between elements 3 and 1 without subtracting pointers outside a permitted common array/object representation.

### P05

For `struct State { int count; double weight; };`, compare 256 bytes from malloc with declared char buf[256] and declared `_Alignas(max_align_t) unsigned char buf[256]`. State the size/alignment assumptions needed, then decide which storage can hold a State accessed by a State lvalue. Explain effective type, and give repairs using a declared State and memcpy from its valid representation. Connect the result to HH014's platform-supplied memory block without claiming C++/Windows code automatically establishes a portable C11 rule.

### P06

Compare pointer links and index links during successful realloc growth, save/load and undo snapshots. State exactly which identities must be preserved. What happens on row reordering, deletion or slot reuse? Explain resolution cost, the reserved-zero convention, and the additional requirements for a portable serialized format.

### S01

Optional: write a C permutation enumerator for five distinct fields A=char, B=double, C=short, D=int, E=char, using E03's model. Enumerate all 120 identity orderings, report minimum/maximum size and every minimum ordering. Prove that descending alignment attains minimum total size for all valid model inputs, including aggregates. Discuss fixed-order/packing/bit-field constraints outside this model and why the smallest representation is not a measured speed result.

### S02

Optional: capture nm, readelf -S -s -r, objdump -dr, and size for E09's objects. Map the external initialized counter, zero counter, constant, private counter, and static local to symbols and sections. Explain local/global letters, the generated static-local name, .bss file versus memory extent, and a relocation referring to shared_counter. Accept other valid compiler/binutils output; do not grade exact names, addresses or relocation offsets.
