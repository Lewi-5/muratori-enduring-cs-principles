.text
.globl abi_probe_sum7
.type abi_probe_sum7, @function
abi_probe_sum7:
    mov %rdi, %rax
    add %rsi, %rax
    add %rdx, %rax
    add %rcx, %rax
    add %r8, %rax
    add %r9, %rax
    add 8(%rsp), %rax
    ret
.size abi_probe_sum7, .-abi_probe_sum7
.section .note.GNU-stack,"",@progbits
# Leaf probe: six GP arguments and one stack argument; caller-clobbered RAX.
# RSP and callee-saved registers are unchanged; arithmetic wraps at 64 bits.
