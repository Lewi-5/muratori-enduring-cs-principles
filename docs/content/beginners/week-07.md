# Week 7 beginner section · Describing an address

[Week 7 lesson](/weeks/week-07) · [Further reading](/further-reading/week-07)

## Purpose and prerequisites

You finished Week 6 and your decoder prints register moves. Now someone gives you `8B 46 FE`. It starts like a familiar `mov`, but the decoder rejects its mode. That rejection is the starting point for this week: the bytes describe a location in memory, and the location needs a different kind of operand.

This section takes about 2–4 hours including three ungraded warm-ups. The estimate is unpiloted and additional to the core lesson. Bring Week 6's masks, byte counts and signed immediate interpretation, and Week 2's distinction between a value and the object holding it. You should be able to compile a small C function and pass it an array with a length. Revisit those weeks if either step is unfamiliar.

By the end you can distinguish a register value, an address expression and the value stored at that address. You can count displacement bytes without reading beyond the input, explain the exceptional direct-address encoding, and tell the job of a header from the job of a shared library.

## Vocabulary

| Term | Plain meaning |
| --- | --- |
| Memory operand | An instruction operand that describes where a value is stored |
| Address expression | A recipe for a location, such as the contents of `bp` minus two |
| Displacement | A constant adjustment included in that recipe |
| Direct address | An unsigned location encoded without address registers |
| Effective address | The offset obtained by evaluating an address recipe with register values |
| Translation unit | One C source file after its includes have been processed |
| Declaration | The name and type the compiler needs to check a use |
| Definition | The function body or object storage that supplies the named thing |
| Shared library | Compiled code loaded into a process and callable by other compiled code |
| API | The documented types, functions and behavior offered to a caller |
| ABI | The machine conventions for passing values and arranging objects across compiled files |

## Concepts

### A location needs a recipe

You see `mov ax, [bp - 2]` and wonder whether the brackets mean that `bp - 2` is copied into `ax`. Brackets mark a memory operand: read the word stored at the location described by `bp - 2`. Without brackets, a register operand names the register itself. The constant `-2` adjusts the location; it is not the value to be copied.

Think of a shelf label saying “two spaces before the marker.” The marker's current position is needed before you can find the shelf. The analogy stops at physical shelves: an 8086 uses numeric offsets and segment rules, and the word at a location consists of bytes. This week only records the recipe. It does not read guest memory, evaluate register contents or calculate a physical address.

Week 6's `w` bit still chooses the size of the data. Even a byte memory operand uses the 16-bit address-register combinations. If `w` is zero, `r/m=000` means a byte at `[bx + si]`, not an address formed from `bl + al`. Data width and address selection answer different questions.

### The same field changes meaning with its mode

You split `46` into `01 | 000 | 110`. The mode is one, and `r/m` is six. In this mode, six chooses `bp`, followed by one signed displacement byte. `FE` has unsigned value 254; as an eight-bit signed pattern it means `254 - 256 = -2`. The resulting recipe is `[bp - 2]`.

Now change the ModR/M byte to `06`, or `00 | 000 | 110`. Mode zero usually means no displacement. This one field combination is the exception: two bytes contain a direct unsigned address. `FE FF` therefore describes `[65534]`. Calling it `-2` would confuse an address with a signed adjustment.

| Mode | Meaning of r/m=110 | Additional address bytes |
| --- | --- | --- |
| 00 | Direct unsigned address | Two |
| 01 | bp plus signed adjustment | One |
| 10 | bp plus signed adjustment | Two |
| 11 | Register selected by data width | None |

This is why you inspect mode before looking up an operand. A table entry has meaning in context, exactly as Week 6's register code four depended on width.

### Length is discovered in order

You decode a memory instruction followed by another instruction. If you skip the displacement, its first byte may look like an opcode. The next decode can look plausible while beginning in the wrong place. A length error is therefore also a stream-boundary error.

Follow the encoding in order: opcode, ModR/M when required, address bytes when required, then immediate bytes when required. The opcode identifies the form; the mode identifies the address-byte count. Check each available extent before reading it. Week 4's parser and Week 6's stream used the same idea: the format says what is required; the input extent says what exists.

A decoder reports `DEC_TRUNCATED` when required bytes are missing. It leaves the caller's instruction unchanged. Build a temporary instruction and assign it at the end. This gives the caller a useful promise even when several fields have already been inspected.

### A header lets two source files agree

You move the decoder into `decode.c` and call it from `client.c`. Including its header makes the compiler aware of the function's parameters and return type. The header does not provide the function body. Linking supplies the compiled definition and connects the call to it.

A menu and a kitchen offer a limited analogy: the declaration describes what can be requested; the compiled definition does the work. The analogy does not check C types. The compiler does that from the shared declaration, and both files must use compatible types and the same target ABI.

Week 2's external data declaration needed exactly one definition. Functions have a similar distinction. Put declarations and type definitions in the public header. Keep implementation helpers internal. A caller should not have to know which helper reads a displacement or how many passes formatting takes.

### A shared library has a lifetime too

You compile a client successfully, then the executable cannot find `libdecode.so`. Compilation checked the declarations and linking recorded the library dependency. The operating system's loader still needs the library when the program starts.

This package stores the library beside the client and records `$ORIGIN` as a search location meaning the client's directory on this Linux toolchain. No absolute path to an instructor checkout is needed. Inspecting the dependency establishes which library name was recorded. Running the client establishes that this particular load and call worked. Neither observation guarantees that a different header or architecture will be compatible.

## Walk-through

Save or open `docs/examples/week-07/address.c`, then compile it with the course flags. It uses arithmetic on explicit bytes, so its displayed values do not depend on host byte order. The automated example checker builds it with GCC and Clang at `-O0` and `-O2` and compares the following output.

<!-- snippet:address -->
```c
#include <stdint.h>
#include <stdio.h>
int main(void)
{
    const uint8_t b[] = {0x8b, 0x46, 0xfe};
    unsigned mod = b[1] >> 6, rm = b[1] & 7u;
    int32_t d = b[2] >= 128 ? (int32_t)b[2] - 256 : (int32_t)b[2];
    printf("mod=%u rm=%u displacement=%ld\n", mod, rm, (long)d);
    unsigned direct = 0xfeu + 256u * 0xffu;
    printf("direct=%u\n", direct);
    return 0;
}
```

<!-- output:address -->
```text
mod=1 rm=6 displacement=-2
direct=65534
```

The first line separates fields and interprets one signed byte. The second combines two bytes into an unsigned address. These lines demonstrate the integer interpretation. They do not demonstrate execution of an 8086 instruction. The core playground adds opcode recognition and operand formatting to the same reasoning.

## Warm-ups

Work in `week-07/learner/src/w01.c` through `w03.c`. Run `make` to compile the scaffolds and `make test` after your implementation; unfinished core exercises also fail that target. To check only the warm-ups, run `make warmups`.

<!-- warmup:W01 -->
<!-- warmup:W02 -->
<!-- warmup:W03 -->

## Check yourself

W01 asks you to explain why a byte operation can require a two-byte address. W02 asks which interpretation makes `FE FF` a direct address. W03 asks why a decoder must know the next offset before continuing. Write those explanations with your warm-up answers before comparing with the separate solutions.

## Ready for the lesson

You are ready when you can point to the bytes that select a form, the bytes that describe a location, and the bytes that provide an immediate. You do not need a processor state to describe an address. Move to E01 to make that description a typed result, then E02 to use it in the decoder.

## Read alongside

Beej's Guide to C, chapter 17, “Multifile Projects,” explains headers and separate compilation. Dive Into Systems §7.1 introduces x86 operands, but its modern x86 examples use different address combinations from the 8086. The [further-reading page](/further-reading/week-07) gives precise citations, a gentle-to-deep order and the explicit gap between those books and our encoding table.
