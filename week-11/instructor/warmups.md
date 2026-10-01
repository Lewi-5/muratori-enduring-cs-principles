# Warm-up answers

### W01

src/w01.c maps positions zero through five to GP indices in RDI,RSI,RDX,RCX,R8,R9 order. For position k>=6, the stack offset is 8+8(k−6). The return word occupies entry offset zero, so the first spill begins at eight. Invalid position/NULL output leaves the output unchanged. This is a scalar-integer-only exercise; a double elsewhere in a full signature does not increment this position.

### W02

src/w02.c marks codes 3(RBX),5(RBP),12–15 as preserved, and 4(RSP) as specially restored. Other listed GP registers are caller-clobbered. A callee may save the incoming RBX, modify it as working storage, then restore it before return. The obligation is at the boundary, not every intermediate instruction. Tests cover all sixteen codes and unchanged output on invalid code/NULL.

### W03

src/w03.c computes ceil(8*words/16)*16 with bounded unsigned arithmetic. Zero→zero, one→sixteen, two→sixteen, three→thirty-two. With an initially aligned caller, even-sized reservation keeps pre-CALL alignment; padding belongs above the scalar argument area. This does not decide type classes or handle stronger alignment/aggregate cases. Test all permitted counts and sentinel preservation.

## Beginner check-yourself answers

Double parameters use a separate pool, so parameter five can be GP argument one. A preserved register can change internally after saving its incoming value; restoration at return fulfills the agreement. A push moves RSP and therefore changes a fixed memory location's relative offset. The C result can be correct with an optimized expression and no doubled slot. Architectural RET determines the actual continuation; the listing does not measure early speculative predictions or CPU cycles.
