# Reading question answers

### F01

The CE review encourages auditing the composition of instruction effects. Scott's hardware/software account gives the role of encoded instructions and stored state; Dive Into Systems §5.9, CS:APP §5.7 and Hennessy/Patterson discuss modern implementation mechanisms. A correct state simulator establishes register/flag/memory transitions for its specified subset. Timing would additionally need an explicit model or measurements of fetching/decoding, prediction, caches, dependencies, scheduling and execution resources. Our prepared boundary map is validation metadata, not a return-address predictor. No text makes a 25-step guest count a modern cycle measurement.

### F02

HH Chat 011 raises the difference between expected machine effects and the C language contract. Beej's signed/unsigned account and C11 §6.3.1.3 support defined conversion/masking rather than overflowing signed host arithmetic. For a byte ADD, sum in a wider unsigned type and retain eight bits; calculate flags separately. C11 lifetime/object-access rules and CS 341's bugs explain why a CodeImage borrowing a dead automatic byte array is invalid, even if its map still looks correct. Keep caller-owned or static code alive through execution. Undefined-behavior sanitizers support selected checks but their silence is not a proof of full C validity.

### F03

Condition correctness concerns the ISA state transition: after CMP byte 80,01, CF is zero and SF differs from OF, so unsigned/signed predicates differ. ABI correctness concerns how generated x64 functions pass arguments/results and preserve state across calls. Microarchitecture affects how those instructions are scheduled, predicted and supplied with data, and requires another kind of evidence. CS:APP and Hennessy/Patterson connect these levels without specifying our immutable code, full predecode, checked targets, stack window, finite budget, halt convention or whole-run rollback. Those policies are in project.h and CHECKPOINT-2.md. A compiler listing is an observation of one build, not a required timing result.
