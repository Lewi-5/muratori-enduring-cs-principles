# Practice and optional stretch

### P01

Calculate [BP+DI-16] for BP=0010 and DI=FFFF. Explain the flat model's BP segment limitation.

### P02

After CMP AL,1 with AL=80, derive result, CF,ZF,SF,OF and all four unsigned/signed strict and inclusive comparisons. Do not use SF alone.

### P03

For code B8 34 12 EB FC, list boundaries, calculate the jump target and distinguish numeric range from a legal target.

### P04

Draw byte data after storing ABCD at FFFF, then changing byte 0000 to 12. Predict a word read at FFFF and explain why host uint16_t pointer casts are unsuitable.

### P05

MOV BL,[BX] reads data 20 from guest address 0100 while BX=0100. Predict final BX and show why address calculation must precede the destination write.

### P06

A run stores 7 at 0100 then jumps into an immediate. Predict committed memory, returned step count and stdout. Explain how to design a regression that catches partial writes.

### S01

Run a repeated CMP AL,1 with AL=80 using JB versus JL. Predict which version halts and which exhausts a budget of six. Implement the two original byte streams in C, check status/steps and rollback, and explain why this does not mean signed loops generally never terminate.

### S02

Design a reusable immutable-code boundary map to avoid reparsing on every step. Specify ownership, invalidation, error offsets, preparation versus execution and an equivalence test plan. A written complete design is enough; no speedup claim is required.
