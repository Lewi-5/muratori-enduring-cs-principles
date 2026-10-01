# Worked notebook structure

Concrete execution results are recorded in validation.md. The answers below give a complete reasoning exemplar and accept different valid tool output.

### R01

Use `uname -a`, compiler --version and objdump --version, and save the make command lines. State x86-64 Linux/WSL, revision 7, separate source/header versions, debug/optimized/sanitizer flags and observed study time. A hostname alone does not identify the build. This exemplar specifies the evidence format; validation.md records the actual execution environment. Unpiloted course estimates are not measured learner completion times.

### R02

The first partition is opcode | ModR/M | signed byte, yielding length 3 and bp-2. The second is opcode | ModR/M | unsigned address low | high, length 4, address 65534. The third is opcode | ModR/M | signed displacement low | high | immediate low | high, length 6, bp-32768 and word immediate -32768. Save predictions before execution, then reconcile them with the playground. A correct mnemonic with a wrong length is still a decode defect. See the golden fixture for the exact canonical lines.

### R03

Use 8B 06 34, 81 0E and a caller text buffer shorter than the complete formatted text. The first is TRUNCATED; the second UNSUPPORTED_OPERATION before displacement checks; the third is an output-capacity failure. Fill destinations with a sentinel and compare the original object representation after failure; never read uninitialized padding to create your evidence. tests/contracts.c initializes its snapshots first. decode_one preserves Instruction; format preserves text; stream byte failure changes only error_offset, while capacity failure preserves every output.

### R04

Expected dynamic exports are the four public functions. The client records libdecode.so plus an ORIGIN search path and prints the API revision and decoded memory move. Run it from /tmp using the absolute executable path to rule out accidental reliance on current working directory. For an objdump comparison, create a binary from fixtures/memory.hex and select -b binary -m i8086 -M intel. Hexadecimal addresses, PTR qualifiers and displacement style can differ. Compare operands, width and instruction boundaries, not spelling alone. This tool observes an interpretation under a selected ISA; it does not prove the input was intended to execute. Record a missing tool as a limitation rather than fabricating output.

### R05

The source shifts and masks 46 into mode one and rm six, dispatches one displacement byte and builds bp-2. The formatter prints brackets; the playground reports length three and the corresponding MOV text. The observation checks a description, not an actual memory transfer. Week 8 needs registers and arithmetic flags for register operations; Week 9 adds segment/address interpretation and bounded guest memory for memory operands. The oracle enumerates forms, register fields, width, direction and selected sign boundaries, not every possible word value or arbitrary stream. The five additional cases isolate defects; passing checks still requires review of bounds, normalization and ABI assumptions.
