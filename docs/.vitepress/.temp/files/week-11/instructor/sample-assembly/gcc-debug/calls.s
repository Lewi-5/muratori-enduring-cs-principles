	.file	"calls.c"
	.intel_syntax noprefix
# GNU C11 (Ubuntu 11.4.0-1ubuntu1~22.04.3) version 11.4.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O0 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
.Ltext0:
	.globl	keep_across_call
	.type	keep_across_call, @function
keep_across_call:
.LFB1:
	.file 1 "instructor/src/calls.c"
	.loc 1 3 1
	.cfi_startproc
	endbr64	
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	sub	rsp, 48	#,
	mov	QWORD PTR -24[rbp], rdi	# seed, seed
	mov	QWORD PTR -32[rbp], rsi	# fn, fn
	mov	QWORD PTR -40[rbp], rdx	# out, out
# instructor/src/calls.c:4:     if (!fn || !out) return 0;
	.loc 1 4 8
	cmp	QWORD PTR -32[rbp], 0	# fn,
	je	.L2	#,
# instructor/src/calls.c:4:     if (!fn || !out) return 0;
	.loc 1 4 13 discriminator 2
	cmp	QWORD PTR -40[rbp], 0	# out,
	jne	.L3	#,
.L2:
# instructor/src/calls.c:4:     if (!fn || !out) return 0;
	.loc 1 4 29 discriminator 3
	mov	eax, 0	# _3,
	jmp	.L4	#
.L3:
# instructor/src/calls.c:7:     uint64_t transformed=fn(seed+UINT64_C(1));
	.loc 1 7 26
	mov	rax, QWORD PTR -24[rbp]	# tmp86, seed
	lea	rdx, 1[rax]	# _1,
	mov	rax, QWORD PTR -32[rbp]	# tmp87, fn
	mov	rdi, rdx	#, _1
	call	rax	# tmp87
.LVL0:
	mov	QWORD PTR -8[rbp], rax	# transformed, tmp88
# instructor/src/calls.c:8:     *out=seed+transformed;
	.loc 1 8 14
	mov	rdx, QWORD PTR -24[rbp]	# tmp89, seed
	mov	rax, QWORD PTR -8[rbp]	# tmp90, transformed
	add	rdx, rax	# _2, tmp90
# instructor/src/calls.c:8:     *out=seed+transformed;
	.loc 1 8 9
	mov	rax, QWORD PTR -40[rbp]	# tmp91, out
	mov	QWORD PTR [rax], rdx	# *out_6(D), _2
# instructor/src/calls.c:9:     return 1;
	.loc 1 9 12
	mov	eax, 1	# _3,
.L4:
# instructor/src/calls.c:10: }
	.loc 1 10 1
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE1:
	.size	keep_across_call, .-keep_across_call
.Letext0:
	.file 2 "/usr/include/x86_64-linux-gnu/bits/types.h"
	.file 3 "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x10f
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF14
	.byte	0xc
	.long	.LASF15
	.long	.LASF16
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF0
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF1
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF2
	.uleb128 0x2
	.byte	0x10
	.byte	0x4
	.long	.LASF3
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.long	.LASF4
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.long	.LASF5
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF6
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF7
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.long	.LASF8
	.uleb128 0x4
	.long	.LASF10
	.byte	0x2
	.byte	0x2d
	.byte	0x1b
	.long	0x34
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF9
	.uleb128 0x4
	.long	.LASF11
	.byte	0x3
	.byte	0x1b
	.byte	0x14
	.long	0x73
	.uleb128 0x2
	.byte	0x8
	.byte	0x4
	.long	.LASF12
	.uleb128 0x5
	.long	.LASF17
	.byte	0x1
	.byte	0x2
	.byte	0x5
	.long	0x3b
	.quad	.LFB1
	.quad	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.long	0xf7
	.uleb128 0x6
	.long	.LASF13
	.byte	0x1
	.byte	0x2
	.byte	0x1f
	.long	0x86
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x7
	.string	"fn"
	.byte	0x1
	.byte	0x2
	.byte	0x30
	.long	0x106
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x7
	.string	"out"
	.byte	0x1
	.byte	0x2
	.byte	0x49
	.long	0x10c
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x8
	.long	.LASF18
	.byte	0x1
	.byte	0x7
	.byte	0xe
	.long	0x86
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x9
	.long	0x86
	.long	0x106
	.uleb128 0xa
	.long	0x86
	.byte	0
	.uleb128 0xb
	.byte	0x8
	.long	0xf7
	.uleb128 0xb
	.byte	0x8
	.long	0x86
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x2116
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x2c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x8
	.byte	0
	.value	0
	.value	0
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF2:
	.string	"long long int"
.LASF6:
	.string	"unsigned int"
.LASF16:
	.string	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11"
.LASF17:
	.string	"keep_across_call"
.LASF1:
	.string	"long unsigned int"
.LASF11:
	.string	"uint64_t"
.LASF14:
	.string	"GNU C11 11.4.0 -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O0 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection"
.LASF4:
	.string	"unsigned char"
.LASF9:
	.string	"char"
.LASF0:
	.string	"long int"
.LASF18:
	.string	"transformed"
.LASF13:
	.string	"seed"
.LASF12:
	.string	"double"
.LASF15:
	.string	"instructor/src/calls.c"
.LASF5:
	.string	"short unsigned int"
.LASF7:
	.string	"signed char"
.LASF3:
	.string	"long double"
.LASF8:
	.string	"short int"
.LASF10:
	.string	"__uint64_t"
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
