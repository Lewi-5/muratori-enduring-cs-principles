# Practice and stretch

### P01

Draw the guest register bank and label all eight byte views. From AX=ABCD and BX=1234 hex, execute mov ah,bl then mov bl,al. Give both words and identify every preserved byte.

### P02

Compute every modeled flag for byte 80 hex minus 01 hex and 00 hex minus 01 hex. Interpret each operand/result as both unsigned and signed.

### P03

Compare CMP AL,BL when AL=80 and BL=01 hex. What unsigned-less and signed-less predicates would Week 9 use? Does CMP itself select an interpretation?

### P04

Why do result 0001 hex and 0101 hex have the same parity flag at word width? What about 0000 and 0100?

### P05

Start IP at FFFE hex and execute two two-byte instructions from a four-byte file. Give each guest IP and each next file cursor. Describe the effect of a third truncated instruction.

### P06

Decode 83 C0 FE and show its effect from AX=0001 hex. Explain immediate sign extension versus host signed arithmetic and MOV’s flag behavior.

### S01

Implement unsigned-less and signed-less predicates on CMP flags in C, without adding guest jump execution. Compare 80 hex with 01 hex, then compare equal operands. Verify with instructor/extras/predicates.c and explain why the two predicates can differ.

### S02

Differentially compare the instructions in fixtures/program.hex against a trusted decoder, such as objdump with i8086 selected. Record its instruction boundaries and reconcile text conventions. Explain exactly which simulator claims this comparison leaves untested.
