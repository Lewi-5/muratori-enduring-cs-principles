# Ungraded warm-ups

### W01

Implement w01 mapping zero-based scalar integer argument position to GP index for the first six or callee-entry stack offset thereafter. Accept 0..31 and preserve output on invalid arguments. Explain why the return word occupies offset zero.

### W02

Implement w02 for the register-code table in lab.h: preserved RBX/RBP/R12–R15, special restored RSP, and caller-clobbered others. Explain why a function using a preserved register may still modify it internally.

### W03

Implement w03 rounding 0..32 eight-byte stack words up to sixteen-byte caller reservation. Explain why one spilled word needs sixteen reserved bytes under the initially aligned caller assumption, and why this arithmetic alone is not a general ABI argument classifier.
