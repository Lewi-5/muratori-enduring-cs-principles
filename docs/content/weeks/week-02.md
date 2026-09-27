---
prev:
  text: Week 1 · C as an inspectable starting point
  link: /weeks/week-01
next:
  text: Week 3 · Numbers in a box
  link: /weeks/week-03
---

# Week 2 · Objects, bytes, and storage

You put a `char`, a `double`, and an `int` into a struct. Their individual sizes seem easy to add. Then `sizeof` reports more than the total. Reordering the fields may change the answer even though the same three values are present.

The extra bytes are not arbitrary waste you can remove by wishful thinking. An implementation arranges objects to meet alignment requirements and to support arrays of those objects. This week you build an inspector that predicts and displays that arrangement. You also investigate a second surprise: the same numeric address can be reused for different objects at different times.

## What carries forward

Week 1 distinguished a value from its representation and introduced checked arithmetic. Now you use those ideas to reason about layouts and lifetimes. The resulting model will help you understand the storage cost of the point arrays in Weeks 3–5. It also prepares you for later allocators and relocatable data structures.

After this week, you should be able to draw a layout with justified offsets, explain when a pointer remains usable, and distinguish a C guarantee from a System V ABI convention. An **ABI**, or application binary interface, is an agreement about how compiled components represent data and communicate on a target. It is more specific than C itself.

Read the concepts first, then work through E01–E05 as the inspector's numeric foundation. E06–E09 investigate identity and visibility; E10 composes the inspector. The ten-hour estimate assumes C experience and remains unpiloted.

## A layout is a set of constraints

### Starting at an acceptable boundary

You want to put another object after the bytes already used. Its **alignment** is a requirement on where it may start. With an alignment of eight in the exercise's numeric model, acceptable offsets are 0, 8, 16, and so on. Offset 9 must advance to 16.

Imagine marked starting positions along a ruler. An object must begin at one of the marks appropriate to it. Unlike an everyday ruler, `size_t` has a maximum value: advancing to the next mark may be unrepresentable. E02 therefore checks both the alignment rule and the arithmetic.

Do not reduce alignment to “the processor cannot read unaligned data.” Hardware capabilities vary, and C's typed-access requirements are a separate constraint. A successful accidental machine access cannot make an invalid C access legal.

### Internal and tail padding

Use the synthetic member specifications `(size 1, alignment 1)`, `(8,8)`, and `(4,4)`. Under the model in E03, their offsets are 0, 8, and 16. The last member ends at offset 20; rounding the total to alignment eight gives size 24.

```text
offset 0: A
offsets 1–7: internal padding
offsets 8–15: B
offsets 16–19: C
offsets 20–23: tail padding
map: A.......BBBBBBBBCCCC....
```

This is an exact worked result for those stated model inputs. The compiler measurements are a separate comparison. Tail padding matters because the next element of an array begins one whole struct size later. Without the appropriate stride, later elements could start at unacceptable boundaries.

Nested structs add another level. A nested member occupies one top-level span, including any padding inside that member. A map of outer fields does not automatically expose the inner layout.

### Offsets always need a starting point

You ask for the position of a field in the fourth record. The calculation combines the record index times the record stride with the field's offset within one record. State both units and origins. A byte offset from the beginning of the array is different from a member offset within one struct.

Typed pointer arithmetic already uses the pointed-to type's size. Byte arithmetic uses single-byte steps. Confusing them can multiply a displacement twice. The E05 comparisons start from the whole array's representation so that the object being traversed is explicit.

## Objects also occupy time

### Scope, linkage, and lifetime answer different questions

You call a function twice and see the same local address. That observation alone does not mean the first object survived the return. Storage can be reused after a lifetime ends.

| Concept | Question it answers | Example |
| --- | --- | --- |
| Scope | Where may this name be used? | A block-local name |
| Linkage | Can declarations identify the same entity across scopes or files? | An external function declaration |
| Storage duration | What determines how long storage lasts? | Automatic, static, or allocated storage |
| Lifetime | When does this particular object exist? | From successful allocation until release |

A local variable holding a pointer and the allocated object it identifies are two objects. Returning the pointer value can be useful when the allocation remains alive. Returning a pointer to a dead automatic object is a different case. Draw both lifetime intervals before deciding whether access is legal.

### Copying references versus copying their targets

You copy a table of linked records. A stored pointer value still identifies its original target; copying its bytes does not retarget it to the corresponding row of the new table. An index can be resolved against whichever table you choose.

The index scheme resembles a seat number used with a particular seating chart. The number remains useful after moving the chart, but not after silently assigning that seat to someone else. Reordering, deletion, and slot reuse still require identity rules. Nor does copying raw structs to disk create a portable format: padding, byte order, and type representation remain concerns.

## Read and watch with a question

Use HH014 to ask what makes a large block suitable for typed objects. Use HH064 to ask which references survive copying. Both are design prompts, not substitutes for checking the C11 validity conditions of your implementation.

<!-- readings -->

## Tools and the first comparison

```sh
cd week-02
make
make test
make CC=clang test
```

Run these from the repository root and then the package directory shown. Until your implementations are complete, the tests are expected to fail behaviorally. After E09, use `make symbols` and `make inspect` to examine compiled objects. `nm` lists symbols; `readelf` exposes object-file metadata; neither determines a variable's language lifetime by itself.

The [platform support](/source/week-02/support/platform.h) documents reference-target assumptions. The [build recipe](/source/week-02/Makefile) separates compiler, package, and mode. Prefer the provided fixture-driven checks to experiments that dereference expired or misaligned pointers.

## Guided exercises

The supplied drivers show how results will be consumed. Keep their interfaces, implement the requested helpers, and validate entire requests before publishing outputs when the contract requires unchanged outputs on failure.

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

## Practice and stretch

<!-- practice -->

## Your notebook and the next question

Keep the model inputs, predicted layout, observed compiler layout, and explanation together. Do not erase a mismatch: it may reveal a bad calculation, an unstated ABI assumption, or a different target.

Knowing a struct's size does not tell you how fast a loop will be. You now have the vocabulary to count storage; later weeks supply the mechanisms and experiments needed for performance. Week 3 first asks what the numbers stored in those objects can represent accurately.

<!-- report -->
