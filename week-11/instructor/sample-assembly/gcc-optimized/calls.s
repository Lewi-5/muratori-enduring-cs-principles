	.file	"calls.c"
	.intel_syntax noprefix
# GNU C11 (Ubuntu 11.4.0-1ubuntu1~22.04.3) version 11.4.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O2 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
.Ltext0:
	.p2align 4
	.globl	keep_across_call
	.type	keep_across_call, @function
keep_across_call:
.LVL0:
.LFB13:
	.file 1 "instructor/src/calls.c"
	.loc 1 3 1 view -0
	.cfi_startproc
	.loc 1 3 1 is_stmt 0 view .LVU1
	endbr64	
	.loc 1 4 5 is_stmt 1 view .LVU2
# instructor/src/calls.c:4:     if (!fn || !out) return 0;
	.loc 1 4 8 is_stmt 0 view .LVU3
	test	rsi, rsi	# fn
	je	.L5	#,
# instructor/src/calls.c:3: {
	.loc 1 3 1 view .LVU4
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rdx	# out, tmp101
	push	rbx	#
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	sub	rsp, 8	#,
	.cfi_def_cfa_offset 32
# instructor/src/calls.c:4:     if (!fn || !out) return 0;
	.loc 1 4 8 view .LVU5
	test	rdx, rdx	# out
	je	.L3	#,
	mov	rbx, rdi	# seed, tmp99
	.loc 1 7 5 is_stmt 1 view .LVU6
# instructor/src/calls.c:7:     uint64_t transformed=fn(seed+UINT64_C(1));
	.loc 1 7 26 is_stmt 0 view .LVU7
	lea	rdi, 1[rdi]	# tmp96,
.LVL1:
	.loc 1 7 26 view .LVU8
	call	rsi	# fn
.LVL2:
	.loc 1 8 5 is_stmt 1 view .LVU9
# instructor/src/calls.c:8:     *out=seed+transformed;
	.loc 1 8 14 is_stmt 0 view .LVU10
	add	rbx, rax	# tmp97, tmp102
.LVL3:
# instructor/src/calls.c:9:     return 1;
	.loc 1 9 12 view .LVU11
	mov	eax, 1	# <retval>,
.LVL4:
# instructor/src/calls.c:8:     *out=seed+transformed;
	.loc 1 8 14 view .LVU12
	mov	QWORD PTR 0[rbp], rbx	# *out_9(D), tmp97
	.loc 1 9 5 is_stmt 1 view .LVU13
# instructor/src/calls.c:10: }
	.loc 1 10 1 is_stmt 0 view .LVU14
	add	rsp, 8	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbx	#
	.cfi_def_cfa_offset 16
	pop	rbp	#
	.cfi_def_cfa_offset 8
.LVL5:
	.loc 1 10 1 view .LVU15
	ret	
.LVL6:
	.p2align 4,,10
	.p2align 3
.L3:
	.cfi_restore_state
	.loc 1 10 1 view .LVU16
	add	rsp, 8	#,
	.cfi_def_cfa_offset 24
# instructor/src/calls.c:4:     if (!fn || !out) return 0;
	.loc 1 4 29 view .LVU17
	xor	eax, eax	# <retval>
# instructor/src/calls.c:10: }
	.loc 1 10 1 view .LVU18
	pop	rbx	#
	.cfi_def_cfa_offset 16
	pop	rbp	#
	.cfi_def_cfa_offset 8
	ret	
	.p2align 4,,10
	.p2align 3
.L5:
	.cfi_restore 3
	.cfi_restore 6
# instructor/src/calls.c:4:     if (!fn || !out) return 0;
	.loc 1 4 29 view .LVU19
	xor	eax, eax	# <retval>
# instructor/src/calls.c:10: }
	.loc 1 10 1 view .LVU20
	ret	
	.cfi_endproc
.LFE13:
	.size	keep_across_call, .-keep_across_call
.Letext0:
	.file 2 "/usr/include/x86_64-linux-gnu/bits/types.h"
	.file 3 "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x137
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
	.quad	.LFB13
	.quad	.LFE13-.LFB13
	.uleb128 0x1
	.byte	0x9c
	.long	0x11f
	.uleb128 0x6
	.long	.LASF13
	.byte	0x1
	.byte	0x2
	.byte	0x1f
	.long	0x86
	.long	.LLST0
	.long	.LVUS0
	.uleb128 0x7
	.string	"fn"
	.byte	0x1
	.byte	0x2
	.byte	0x30
	.long	0x12e
	.long	.LLST1
	.long	.LVUS1
	.uleb128 0x7
	.string	"out"
	.byte	0x1
	.byte	0x2
	.byte	0x49
	.long	0x134
	.long	.LLST2
	.long	.LVUS2
	.uleb128 0x8
	.long	.LASF18
	.byte	0x1
	.byte	0x7
	.byte	0xe
	.long	0x86
	.long	.LLST3
	.long	.LVUS3
	.uleb128 0x9
	.quad	.LVL2
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x54
	.uleb128 0xa
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x2
	.byte	0x73
	.sleb128 1
	.byte	0
	.byte	0
	.uleb128 0xb
	.long	0x86
	.long	0x12e
	.uleb128 0xc
	.long	0x86
	.byte	0
	.uleb128 0xd
	.byte	0x8
	.long	0x11f
	.uleb128 0xd
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
	.uleb128 0x2117
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x2113
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x410a
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x2111
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xb
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
	.uleb128 0xc
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
.LVUS0:
	.uleb128 0
	.uleb128 .LVU8
	.uleb128 .LVU8
	.uleb128 .LVU11
	.uleb128 .LVU11
	.uleb128 .LVU16
	.uleb128 .LVU16
	.uleb128 0
.LLST0:
	.quad	.LVL0-.Ltext0
	.quad	.LVL1-.Ltext0
	.value	0x1
	.byte	0x55
	.quad	.LVL1-.Ltext0
	.quad	.LVL3-.Ltext0
	.value	0x1
	.byte	0x53
	.quad	.LVL3-.Ltext0
	.quad	.LVL6-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x55
	.byte	0x9f
	.quad	.LVL6-.Ltext0
	.quad	.LFE13-.Ltext0
	.value	0x1
	.byte	0x55
	.quad	0
	.quad	0
.LVUS1:
	.uleb128 0
	.uleb128 .LVU9
	.uleb128 .LVU9
	.uleb128 .LVU16
	.uleb128 .LVU16
	.uleb128 0
.LLST1:
	.quad	.LVL0-.Ltext0
	.quad	.LVL2-1-.Ltext0
	.value	0x1
	.byte	0x54
	.quad	.LVL2-1-.Ltext0
	.quad	.LVL6-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x54
	.byte	0x9f
	.quad	.LVL6-.Ltext0
	.quad	.LFE13-.Ltext0
	.value	0x1
	.byte	0x54
	.quad	0
	.quad	0
.LVUS2:
	.uleb128 0
	.uleb128 .LVU9
	.uleb128 .LVU9
	.uleb128 .LVU15
	.uleb128 .LVU15
	.uleb128 .LVU16
	.uleb128 .LVU16
	.uleb128 0
.LLST2:
	.quad	.LVL0-.Ltext0
	.quad	.LVL2-1-.Ltext0
	.value	0x1
	.byte	0x51
	.quad	.LVL2-1-.Ltext0
	.quad	.LVL5-.Ltext0
	.value	0x1
	.byte	0x56
	.quad	.LVL5-.Ltext0
	.quad	.LVL6-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.quad	.LVL6-.Ltext0
	.quad	.LFE13-.Ltext0
	.value	0x1
	.byte	0x51
	.quad	0
	.quad	0
.LVUS3:
	.uleb128 .LVU9
	.uleb128 .LVU12
.LLST3:
	.quad	.LVL2-.Ltext0
	.quad	.LVL4-.Ltext0
	.value	0x1
	.byte	0x50
	.quad	0
	.quad	0
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
.LASF14:
	.string	"GNU C11 11.4.0 -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O2 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection"
.LASF16:
	.string	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11"
.LASF17:
	.string	"keep_across_call"
.LASF1:
	.string	"long unsigned int"
.LASF11:
	.string	"uint64_t"
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
