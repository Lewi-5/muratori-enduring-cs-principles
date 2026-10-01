# Guided reading answers

### F01

Scott's simple machine introduces selecting a next instruction from a comparison. CS:APP §3.6.3 gives actual x86 jump predicates: after CMP, signed less uses SF != OF, whereas unsigned less uses CF. For byte patterns 80 minus 01 hex, the stored result 7F looks positive even though signed -128 is less than 1. OF = 1 corrects that misleading sign in the signed predicate. Scott's teaching ISA and CS:APP's x64 encodings do not specify our precise 8086 byte subset or checked targets. Intel supplies shared predicate semantics; machine.h defines accepted forms and course restrictions.

### F02

Beej's array bounds and CS 341's pointer arithmetic apply to host C storage. Guest offset FFFF is 65535, within the 65536-byte data array, but a contiguous two-byte host operation starting there would need byte 65536 outside the object. This model maps the second guest byte to offset 0000 before a separate valid host array access. Guest wrap is numeric address arithmetic modulo 65536; host bounds concern actual accessible C elements. A valid guest address does not authorize dereferencing a numeric host pointer. Explicitly indexing the two bytes satisfies both rules.

### F03

Dive Into Systems §7.4.3 explains repeated comparisons and transfers as loops. Hennessy and Patterson Appendix A.6 compares control-flow choices in instruction sets. Neither dictates our separate code and data, full predecode, checked boundaries, halt at code length, finite budget or whole-run rollback; those are course policies in machine.h. In our fixture, JNE repeats while SUB CX,1 produces a nonzero value, then falls through when ZF is set. This architectural mechanism does not explain branch predictor behavior or require a particular host instruction sequence. A loop whose unchanged comparison stays true demonstrates budget failure, not a processor timing result.
