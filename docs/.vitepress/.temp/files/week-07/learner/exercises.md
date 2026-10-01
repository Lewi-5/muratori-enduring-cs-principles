# Week 7 exercise contracts

One graded assignment combines E01–E05 and R01–R05. Functions are declared in the public or internal header. Use the guide for the exact subset.

### E01.C

**An address tail.** Implement `decode_address` in `address.c` using the supplied internal declaration. Input begins immediately after ModR/M. Validate NULL and mode/index arguments before byte availability. Modes 0–2 only. Return used=0, 1 or 2 and an Address; preserve both outputs on any failure. Direct addresses set direct=1, rm=0, displacement=0; formula addresses set direct=0, address=0. Decode all address-table entries, signed boundaries and the direct exception.

### E01.Q

Derive 8B 46 FE and 8B 06 FE FF. Explain why the former uses signed -2 and the latter unsigned 65534. Explain why byte data still uses word address registers.

### E02.C

**One complete memory instruction.** Extend the supplied register decoder in `decode.c` to the exact subset in README, using E01 for every memory ModR/M operand. Add C6/C7 /0 and A0–A3. Preserve unchanged-output behavior and error order. Instruction length includes address and immediate tails and is 2–6. Decode only the first instruction even when later bytes exist. Never evaluate a memory operand or access guest state.

### E02.Q

Hand-decode 83 80 00 80 FE, giving mode, group operation, address formula, displacement, immediate width, value and total length. Explain the status of 81 0E with no further bytes and why it is decided before address truncation.

### E03.C

**Canonical memory text.** Implement `format_instruction` in `format.c` under the public header and README conventions. Validate operands, operation and matching widths before formatting. Immediate may only be a source; memory-memory is invalid. Validate normalized memory fields. Output buffer is unchanged on failure, including one-byte-short capacity. A 64-byte buffer is sufficient; demonstrate a conservative length bound. Zero displacements are omitted.

### E03.Q

Explain when byte/word is necessary. Give two accepted encodings with the same printed address expression but different lengths. Explain why format does not recover encoded displacement width.

### E04.C

**A separately compiled caller.** Complete `client.c` using only include/decode.h. Check decoder_api_version against DEC_API_VERSION, decode 8B 46 FE, format and print `api=7 mov ax, [bp - 2]` plus newline. Fail nonzero on any rejected step. Build the shared library from your four modules using the supplied Makefile. Record nm dynamic exports and readelf dependency/search path. Run client from a different working directory by absolute executable path.

### E04.Q

Explain declaration, definition, relocation, link and load for this call. Identify the four exported names, the private address helper and the API versus ABI promise. Explain what happens if the library is missing when the client starts.

### E05.C

**Stream integration and evidence.** Use the supplied stream and CLI with your modules. Run the four-case playground, golden fixtures and all tests. Add five entries to learner/cases.txt with hex bytes, expected canonical text or status and failure offset, and the defect each targets. Include a direct address, a signed displacement boundary, displacement followed by immediate, late truncation and an unsupported group operation. Derive expectations before running. Complete R01–R05.

### E05.Q

Explain why 89 D9 8B 06 34 fails at byte offset 2 with no stdout. Give the caller outputs changed by each failure class, and state the immutability/aliasing assumptions that make the two-pass stream contract valid.
