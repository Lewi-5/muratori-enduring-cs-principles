# Coverage and limits

inventory.py checks 29 unique learner IDs against separate written answers: ten E contract/reasoning entries, six P, two S, five R, three W and three F.

contracts.c checks representative 3–6-byte instructions and every proper truncated prefix; unchanged instruction and text storage; exact-fit formatting; invalid operands and pointers; direct-address availability; group-operation precedence; empty-stream capacity; late stream failure; API revision. warmups.c covers all address-table pairs and every signed byte value.

oracle.py works in the encoding direction and covers all selected pair forms, widths, directions, modes, r/m and reg fields, representative displacement sign boundaries, group and MOV immediate forms and direct accumulator forms. It retains register-immediate and accumulator-immediate cases from Week 6. It does not enumerate every 16-bit immediate/displacement combination or every arbitrary stream. Test agreement is evidence for those cases; bounds and arithmetic arguments still need code review.

check.py compares streams against that oracle and hand-authored golden fixtures; probes unsupported/truncated CLI errors, input cap and absent files; runs a linked shared client; checks its ELF dependency, ORIGIN path and exactly four exports. It does not require another decoder to be installed. objdump is a separate manual/toolchain cross-check in R04 and validation. The course subset and formatting conventions differ from a full external decoder.

verify runs two compilers across three modes and compiles both learner packages. starters.py confirms unfinished correctness gates fail. The beginner snippet is checked by tools/docs/verify-examples.py against exact source and output. Documentation tests check prompt/answer coverage and links. No timing, simulation, segment execution or arbitrary ABI compatibility is established.
