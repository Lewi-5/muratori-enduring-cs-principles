# Warm-up solutions and check-yourself answers

### W01

src/w01.c validates both bytes and output pointers, adds in unsigned arithmetic, returns the low eight bits and carry when sum exceeds 255. 255+1 yields result zero/carry one; 127+1 yields 128/carry zero but would have signed byte overflow. Carry and overflow answer different range questions. Testing all 65536 pairs uses quotient/remainder reasoning and checks failure preserves both outputs.

### W02

src/w02.c checks pointers and target <= 65535, then tests the addressed map byte for nonzero. For starts 0 and 3 and end 5, target 1 is absent and target 3 present. That helper cannot prove the map matches current code bytes or their lifetime. The prepared-image ownership contract supplies that requirement. Test all positions plus a noncanonical nonzero map value and invalid inputs.

### W03

src/w03.c stores low byte first using a mask, then the high byte with an unsigned shift. Word 1234 hex becomes bytes 34,12; 80FF becomes FF,80. The helper requires two accessible output bytes and does not itself implement guest address wrap. The executor selects two valid guest-array indices separately when a word starts at FFFF. Test all 65536 word patterns without assuming host endian.

Check yourself: a trace delta records changed bytes, so same-value stores may be absent. A map with valid old offsets cannot keep dead code storage alive. At CALL the saved word is the following IP, not the opcode position. A capacity error commits neither trace nor guest state. ABI-correct optimized code may eliminate a source local, and neither an ISA trace nor a disassembly measures modern cycles.
