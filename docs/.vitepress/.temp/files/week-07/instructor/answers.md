# Week 7 worked answers — spoilers

The reference source modules are annotated working C. The following derivations explain their contracts and likely mistakes; a correct alternative need not use identical code.

### E01.C

address.c validates arguments first, initializes a normalized local Address, and obtains a byte count from mode and r/m. It checks availability before reading. Mode 01 interprets the raw byte by subtracting 256 when its sign bit is set. Mode 10 uses the analogous subtraction of 65536. These subtractions fit int32_t and avoid an implementation-defined conversion to int8_t or int16_t under C11. The direct exception copies an unsigned assembled word. Only the final assignments touch the caller's two outputs. Zero-tail forms may take NULL at zero length; direct form with no tail returns TRUNCATED. Unconditionally reading two bytes is a plausible fault that the zero-tail and proper-prefix tests catch.

### E01.Q

8B chooses MOV, word data, register destination. 46 is 01|000|110: one signed displacement byte, destination ax and address base bp. FE is 254 as raw bits, and 254-256=-2 as the specified signed field, so the length is three and text is `mov ax, [bp - 2]`. 06 changes only the mode to 00, selecting the rm=6 direct exception. FE FF assembles 65534, yielding `mov ax, [65534]` and length four. Data width determines how much data MOV would transfer; it does not shrink the address registers. This is an ISA rule, independent of host pointer width or byte order.

### E02.C

decode.c retains Week 6's opcode families and arithmetic operation selection. For ModR/M forms it establishes the group operation, then obtains either a register or a memory operand. The address helper starts at byte two; its used count advances the immediate position. The pair forms apply d to move the reg operand to the proper side. Group forms use /0, /5 or /7 as an operation, not a second operand register. C6/C7 admit only /0; A0–A3 have no ModR/M and always read a two-byte direct address. All instruction construction is local and commit happens once. Prefixes are rejected, and no code dereferences guest addresses. The largest form has opcode + ModR/M + two address bytes + two immediate bytes, six total. A faulty implementation that reads the immediate at fixed offset two passes register tests but fails displacement-plus-immediate cases.

### E02.Q

83 is a word arithmetic-group form with a sign-extended byte immediate. 80 is 10|000|000: mode two, /0 ADD, r/m zero selecting bx+si. 00 80 is unsigned 32768, interpreted as signed displacement -32768. FE is signed byte -2, preserved as the word operation's immediate value. Length is five; text is `add word [bx + si - 32768], -2`. The shorter 81 0E identifies /1, outside the selected arithmetic operations, as soon as ModR/M is present. It returns UNSUPPORTED_OPERATION before asking for direct-address bytes. This deliberate order is part of the API, not the CPU's instruction fault model.

### E03.C

format.c checks operation, width, operand kind, register index, immediate range, normalized address fields and the prohibition on two memory operands. It formats each validated operand into scratch storage, then the full instruction into a 64-byte local buffer. The final snprintf count must fit both scratch and caller capacity including NUL before memcpy commits. Each formula operand is at most 22 visible characters, a direct address seven, a register two and an immediate six. With no two memory operands, even adding a three-character mnemonic, separating spaces, two comma characters and a five-character width qualifier gives a conservative bound below 64. The longest displacement magnitude is computed in long, whose C11 range includes 32768; negating an int16_t at its minimum would be a poor approach. An exact-fit caller buffer succeeds and a one-byte-short buffer remains untouched. Instruction length is encoding metadata and does not control semantic formatting.

### E03.Q

`mov [bx], ax` already exposes word width through ax. `mov word [bx], -1` has no register from which an assembler can infer data width, so the memory qualifier states it. `mov byte [bx], -1` is a different operation width despite the same decimal value. 8B 40 00 and 8B 80 00 00 encode zero byte and zero word displacements for the same address expression; both print `mov ax, [bx + si]`. The normalized Address stores the numeric adjustment, not its encoding width, so printing omits zero and cannot reconstruct which original form was chosen. Preserving length alone would still not uniquely recover all equivalent encodings.

### E04.C

client.c includes the public header and owns its byte array, Instruction and text array. It checks the API revision before using the structured results, checks decode and formatting, and prints only a complete success. The supplied build produces PIC module objects, links them into libdecode.so, and links the separate client with -ldecode and a literal $ORIGIN loader path. The exports map exposes only decode_one, decode_stream, format_instruction and decoder_api_version. tests/check.py inspects those names and the dependency and executes the client. The optional loader example adds explicit runtime loading. Rebuilding with a mismatched header or linking instructor objects into the learner executable would defeat this assignment's boundary; neither is required or accepted.

### E04.Q

The header declaration lets the compiler check decode_one's use in client.c. decode.c supplies its definition. A compiled call can leave a relocation for the toolchain to resolve; the linked client records a shared-library dependency and the loader connects it at runtime according to the ABI. The helper decode_address is internal to the dynamic interface, although separate source modules can refer to it at library link time. API describes types and behavior; ABI describes layout and call conventions of compiled files. Revision 7 deliberately changes Operand's layout from Week 6. It is not a universal promise across different packing flags, machines or headers. A missing library can prevent the process from reaching main, so the version check cannot diagnose every loader failure.

### E05.C

Supplied stream.c validates and sizes all instructions before touching text. Its second pass reruns the pure decoder only after capacity is known; caller immutability and disjoint storage are explicit requirements. The CLI reads at most the stated cap and checks a byte beyond it, keeps file errors separate from byte errors, and writes only after successful stream decoding. The five sample entries in instructor/cases.txt target unsigned direct values, a signed lower boundary, address/immediate ordering, a late failure and group-operation precedence. These cases add explainable probes to the broad oracle. Expected output comes from manual field reasoning and an independent encoder, never by recording the program under test.

### E05.Q

89 D9 completes `mov cx, bx` at bytes zero and one. The instruction beginning at byte two is 8B 06, which requires a two-byte direct address. Only 34 remains, so failure is TRUNCATED at offset 2. text and text_len remain unchanged; only error_offset changes. No stdout is written by the CLI on this decode failure. Argument or output-capacity failure changes no outputs; successful stream decoding sets length and error_offset to the consumed input extent. Read or decode failure has a different rollback boundary from a failed stdout write, which can leave partial output. Overlapping text with bytes, concurrent modification of input or overlapping scalar outputs violate the caller contract and undermine the two-pass reasoning.

### P01

The formula table is bx+si, bx+di, bp+si, bp+di, si, di, bp, bx. Mode 00 takes those formulas without displacement except entry six, which takes a direct unsigned address. Mode 01 uses each formula plus a signed byte; mode 10 uses each plus a signed word. Bare bp therefore uses mode 01 or 10 with zero displacement. Looking up rm=6 before mode incorrectly turns direct input into bp.

### P02

8A 00 is `mov al, [bx + si]`, length 2: d=1, w=0, mod=00, reg=000, rm=000. 89 5E 00 is `mov [bp], bx`, length 3: d=0, w=1, reg=011, mod=01, rm=110, zero byte displacement. C6 06 00 80 FF is `mov byte [32768], -1`, length 5: /0, direct address 0x8000, immediate FF. A3 FF FF is `mov [65535], ax`, length 3: accumulator-to-memory word form. These are descriptions, with no claim that reading a word at offset 65535 is safe in a later simulator.

### P03

8B lacks ModR/M and is TRUNCATED. 8B 06 identifies a direct address but lacks both bytes: TRUNCATED. C7 0E has /1, outside MOV immediate /0: UNSUPPORTED_OPERATION before address availability. C7 06 34 12 00 has its direct address but only one of two immediate bytes: TRUNCATED. 26 8B 07 begins with a segment prefix outside the subset: UNSUPPORTED_OPCODE at offset zero. No case commits a partial instruction. A decoder that checks tail length before group operation changes the promised precedence.

### P04

Ordinary data addressing defaults to DS; formulas containing BP default to SS. These examples therefore use DS, SS and DS. A physical address requires segment state and evaluation of address registers, followed by the architectural segment calculation; an expression or direct offset alone supplies neither all state nor memory contents. Our API records the expression and rejects overrides. C pointer values are host addresses and must never be substituted for guest registers. Consult the Intel addressing description; this remains interpretation, not simulator execution.

### P05

The first pass reads original bytes, while the second writes text and can destroy bytes it has yet to reread. The documented disjoint-storage requirement forbids this request. Give input and text separate arrays and keep input unchanged through the call. Independent calls have no shared mutable library state, but two threads writing one buffer still conflict in caller-owned storage. Allocate separate result buffers or synchronize access. Thread safety is a property of both implementation and use; it is not a blanket permission for races.

### P06

nm -D shows exported dynamic names in that file; readelf -d shows dependency and loader metadata in the client. Neither executes a call. A successful client proves that this load and tested call work on this target. Adding a field changes structure layout and may change writes or argument conventions while symbol names stay the same. Rebuild both library and client with the matching header and compatible ABI; version checks help detect a deliberately changed API but are not a structural proof. Successful linking alone cannot detect every ABI mismatch.

### S01

Both inputs mean `mov ax, [bx + si]`; their lengths are three and four. Their explicit zero displacements disappear in text. The shortest canonical encoding, 8B 00, has length two and the same operands. The reference C program decodes all three and compares canonical text, not lengths. This finite experiment establishes these cases, not a general assembler inverse. In general an assembler can choose a direction, opcode family or displacement width. Forcing particular bytes requires retaining encoding metadata beyond the semantic operands. NASM is optional because the supplied C experiment already provides a complete reproducible case.

### S02

The reference opens the path with RTLD_NOW, clears dlerror before dlsym, checks the returned error and pointer, and invokes the version function while the handle remains open. It closes the handle on each acquired-handle path. A nonexistent file produces a loader diagnostic and nonzero status. POSIX supplies the ability to resolve a function through dlsym; ISO C alone does not promise that object and function pointers are interchangeable. The sample checks equal representation sizes and copies the returned representation into the function pointer on this target. It is explicitly a Linux/POSIX probe, not portable ISO C advice. A pointer into an unloaded library cannot be used after dlclose. Link-time dynamic dependencies and explicit loading differ in who decides when to request the library.
