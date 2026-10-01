# Week 10 beginner section · Save a place to return

[Lesson](/weeks/week-10) · [Further reading](/further-reading/week-10)

## Purpose and prerequisites

You call a small routine from two different places. The routine's instructions are the same each time, but it must continue at a different caller position afterward. A jump gets you into the routine; it does not by itself remember where to come back. This week adds that missing memory and shows why nested calls need an ordering rule.

Bring Week 8's registers and flags, Week 9's branch targets and guest memory, and Week 1's C arrays and functions. You need to recognize an unsigned integer, a byte array and a checked function result. You do not need to write assembly to begin. Allow 2–4 hours for this page and three warm-ups; the ten-hour core assignment is separate. Both estimates are unpiloted.

You finish able to draw two saved words, explain the direction of SP movement, identify the position a CALL saves, and distinguish an architectural stack from C's object-lifetime rules. The [package guide](/materials/week-10/README) gives exact encodings and restrictions when you are ready.

## Vocabulary

| Term | Plain meaning |
| --- | --- |
| Stack | An ordered region where the newest saved item is retrieved first |
| Push | Reserve room and save an item at the current top |
| Pop | Read the newest item and move the top past it |
| SP | Guest stack pointer: the numeric data address of the current top |
| Word | A two-byte, sixteen-bit value in this model |
| Return address | The code position at which the caller should continue |
| Near call | A call within the same conceptual code segment |
| Callee / caller | The routine being entered / the code that enters it |
| Displacement | A signed distance from a defined reference position |
| Little-endian | A multi-byte value stored with the least significant byte first |
| ABI | Agreement about how separately compiled callers and callees cooperate |
| Scope | The part of source code where an identifier can be used |
| Lifetime | The interval when an object exists and can be used under C's rules |
| Storage duration | C's classification of how an object's lifetime is determined |

## Concepts

### A routine needs a continuation

You jump to a helper and reach its last instruction. Which instruction should follow? A fixed jump back works only if every caller uses the same continuation. CALL instead saves the position immediately after its own encoding and transfers to the helper. RET retrieves a saved position and resumes there. The saved continuation is a number in guest memory, not a host C function pointer.

A bookmark is a useful first analogy: you leave the main text, read an appendix, then resume at the bookmark. Nested calls need several bookmarks in reverse order. The analogy stops at the exact representation: our continuation is a sixteen-bit code position stored as two data bytes, and RET checks whether it is an accepted instruction boundary. A real processor need not reject every corrupt continuation in this way.

The displacement of a relative CALL is measured from the following instruction, after all CALL bytes. First calculate that following IP, then add the signed displacement. This is Week 9's relative-branch rule with an additional saved continuation. Knowing the target lies inside the code's numeric range is insufficient: the target might be the middle of an immediate. The assignment checks a map of decoded boundaries.

### Reserve before you store, read before you release

You have a bounded byte array and need a place to save a word. This model starts the empty SP just beyond its stack window and grows toward lower numeric addresses. PUSH subtracts two, then stores the low byte followed by the high byte. Another PUSH subtracts two again, placing the newer word below the older one. POP reads at the current SP, then adds two.

The current top is therefore the lowest address among live stack words. “Top” means the next word to retrieve, not the largest address. Last-in, first-out is the ordering rule: the newest saved item leaves first. It makes nested calls work because the inner routine must return before its outer routine can return.

You can save ordinary data too. If you save a register after CALL has saved its continuation, that data word lies above the continuation in retrieval order. Restore the data before RET, or RET will interpret it as a code position. A balanced SP is necessary for many calling conventions but insufficient to show correct values: popping words into the wrong registers can balance SP while swapping their contents.

The stack window is an assignment bound. It makes exhaustion and empty POP explicit errors and keeps stack accesses inside supplied storage. The historical 8086 does not enforce our window as a protected container. Likewise, odd SP values are accepted: two adjacent bytes make a word even when the address is odd. C pointer casts are unnecessary and may add host alignment problems that the numerical guest model avoids.

### Saved bits are not a living C object

You POP a word and inspect its old bytes. They still look right, so it is tempting to call them a usable variable. POP did not erase those bits; it only removed the word from the live stack interval. A separate set of rules governs whether a C object still exists.

A C automatic local has a lifetime that ends when execution leaves its block. A static local has a lifetime throughout program execution. An allocated object remains until its storage is released according to its allocation contract. Scope answers where the local's *name* is visible; lifetime answers when the *object* exists. Neither question is answered by whether a memory viewer still shows old bits.

Returning the address of an automatic local does not let the caller extend its lifetime. Do not dereference that invalid returned address to see what happens. Instead let the caller provide a live output object, or choose another explicit storage/ownership contract. The reference answers work through that repair.

| Thing | What it controls | What it does not establish |
| --- | --- | --- |
| Guest SP | Which guest bytes are the next modeled stack word | Whether any host C local exists |
| C storage duration | How an object's lifetime begins and ends | A mandatory physical stack location |
| Identifier scope | Where a source name is visible | Ownership or validity of every pointer using its storage |
| ABI convention | How machine-code routines exchange data | The lifetime of an automatic object after return |

Our Machine byte array is itself a host C object; guest PUSH changes elements inside it. It does not push a host C variable or create a host function call. Compilers may keep a host local in a register or eliminate it, so “automatic” and “stored on the processor stack” are not interchangeable terms.

### Instruction rules and software agreements are different

You expect a helper to preserve AX because it is convenient for the caller. The CALL instruction promises a saved return position, not automatic preservation of all registers. Software establishes which registers must be saved and which may change. That agreement is part of a calling convention or ABI. Week 11 studies one concrete modern ABI.

Likewise, do not infer flag effects from an instruction's familiar appearance. PUSH, POP, CALL and RET preserve flags here. INC and ADD both add one in the simple case, but INC preserves the previous carry flag while ADD replaces it. Original 8086 PUSH SP also differs from modern x86: the historical instruction stores the already decremented SP. The [Intel manual](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html) documents that difference. Read the particular operation rather than silently using a newer rule.

## Walk-through

You save a word in a tiny data array, then restore it. This checked-in C snippet isolates the byte order and SP movement; it does not implement instruction decoding, target checking or a full stack API. The word fits the fixed example array, so this specific demonstration does not need a runtime capacity check. Your assignment functions do.

<!-- snippet:stack_word -->
```c
#include <stdint.h>
#include <stdio.h>
int main(void)
{
    uint8_t memory[256]={0};
    unsigned sp=256;
    uint16_t saved=0x1234;
    sp-=2;
    memory[sp]=(uint8_t)(saved & 255u);
    memory[sp+1]=(uint8_t)((unsigned)saved >> 8);
    printf("push: sp=%04x bytes=%02x %02x\n",sp,(unsigned)memory[sp],(unsigned)memory[sp+1]);
    uint16_t restored=(uint16_t)((unsigned)memory[sp] | ((unsigned)memory[sp+1] << 8));
    sp+=2;
    printf("pop: sp=%04x value=%04x stale=%02x %02x\n",sp,(unsigned)restored,
           (unsigned)memory[254],(unsigned)memory[255]);
    return 0;
}
```

<!-- output:stack_word -->
```text
push: sp=00fe bytes=34 12
pop: sp=0100 value=1234 stale=34 12
```

The first line shows SP moved down two bytes before storing. The bytes reconstruct the original numerical word: the high byte contributes its value multiplied by 256. The second line shows SP returned to the empty boundary and the saved bits remain. This observation establishes those updates in the demonstration. It does not establish a valid lifetime for an unrelated C local, complete simulator correctness, or hardware timing.

## Warm-ups

Work on these small numeric helpers before implementing the machine. Their tests are exhaustive over sixteen-bit patterns where practical and preserve sentinel outputs on bad arguments.

<!-- warmup:W01 -->
<!-- warmup:W02 -->
<!-- warmup:W03 -->

## Check yourself

Explain why PUSH reserves before storing, why CALL saves the following position, why POP leaves old bytes, why an expired C local cannot be revived by unchanged contents, and why INC cannot simply copy every flag from ADD. Compare with the beginner check-yourself answers on the [instructor warm-up page](/materials/week-10/instructor/warmups) after attempting them.

## Ready for the lesson

You are ready when you can draw two live words and their retrieval order without running code. Begin E01 with checked byte operations, then E02 with signed displacements, and combine them in E03. Keep each predicted transition before inspecting the trace. A failing step leaves caller state unchanged; a failing whole run also rolls back earlier tentative memory writes. Those different transaction boundaries are part of the assignment, not a hardware claim.

## Read alongside

Start with Beej [§13 Scope](https://beej.us/guide/bgc/html/split/scope.html#scope), then Dive Into Systems [§2.1 Parts of Program Memory and Scope](https://diveintosystems.org/book/C2-C_depth/scope_memory.html). For calls, read [§7.5 Functions in Assembly](https://diveintosystems.org/book/C7-x86_64/functions.html) while remembering that its examples are x64. CS 341 §3.8.3 “Returning pointers to automatic variables” (printed p. 68, PDF p. 82) directly addresses the lifetime mistake. The [guided further reading](/further-reading/week-10) places these beside the gentle register-machine account and deeper architecture texts with exact registry citations.
