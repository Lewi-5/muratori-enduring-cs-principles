# Practice and stretch

### P01

A window [0080,0100) starts empty. How many word PUSHes fit? What happens on the next PUSH and on the next POP after complete draining? Give statuses and unchanged-state expectations.

### P02

AX=7FFF and CF=1. Compare INC AX with ADD AX,1: result, CF, OF, and all other arithmetic flags. Explain a valid reason software may depend on the difference.

### P03

A three-byte CALL starts at 0010 and uses rel16 pattern FFF0. Calculate next IP and target. Explain whether the numbers alone prove the target is accepted.

### P04

PUSH AX then PUSH BX. Which POP order restores both? Explain what POP AX then POP BX actually does when AX=1234 and BX=ABCD.

### P05

Does reading the same old guest bytes after POP prove a returned pointer to a C automatic local is safe? Explain using object lifetime, identifier scope, and architectural stack contents as three distinct concepts.

### P06

The CLI uses separate code and data arrays. Can MOV to the numeric data address of a CALL change that CALL? State the model's behavior and the corresponding limitation compared with real 8086 memory.

### S01

Construct a recursive near-CALL fixture that reaches M_STACK before its instruction budget expires. Supply bytes, a recurrence for SP, the failing IP, successful step count, and a rollback check. Explain why the simulator need not recurse in host C.

### S02

Design a boundary-map cache to avoid rescanning all code on each step. Give a C API and a working reference prototype or pseudocode sufficient to implement it; explain ownership, immutable code, cache invalidation and how you would verify it against the original runner. No speedup is required.
