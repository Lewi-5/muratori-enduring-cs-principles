# Ungraded warm-ups

Typed stubs and contracts are in project.h; run make warmups.

### W01

Implement w01, a byte ADD result and carry. Predict 255+1 and 127+1; distinguish carry from signed overflow. Test every byte pair and unchanged outputs on invalid arguments.

### W02

Implement w02, checked boundary membership for a 65536-byte map. Predict targets 1 and 3 in a map containing starts 0 and 3 and end 5. A numeric target is not automatically an instruction boundary.

### W03

Implement w03, little-endian word encoding into two bytes. Predict 1234 and 80FF. Use numeric operations, then explain why this helper alone does not implement wrapping memory access.
