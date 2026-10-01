	.file	"fold.c"
	.intel_syntax noprefix
# GNU C11 (Ubuntu 11.4.0-1ubuntu1~22.04.3) version 11.4.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O0 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
.Ltext0:
	.globl	fold_ids
	.type	fold_ids, @function
fold_ids:
.LFB1:
	.file 1 "instructor/src/fold.c"
	.loc 1 3 1
	.cfi_startproc
	endbr64	
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	mov	QWORD PTR -24[rbp], rdi	# points, points
	mov	QWORD PTR -32[rbp], rsi	# n, n
	mov	QWORD PTR -40[rbp], rdx	# out, out
# instructor/src/fold.c:4:     if (!out || (!points && n)) return 0;
	.loc 1 4 8
	cmp	QWORD PTR -40[rbp], 0	# out,
	je	.L2	#,
# instructor/src/fold.c:4:     if (!out || (!points && n)) return 0;
	.loc 1 4 14 discriminator 2
	cmp	QWORD PTR -24[rbp], 0	# points,
	jne	.L3	#,
# instructor/src/fold.c:4:     if (!out || (!points && n)) return 0;
	.loc 1 4 26 discriminator 3
	cmp	QWORD PTR -32[rbp], 0	# n,
	je	.L3	#,
.L2:
# instructor/src/fold.c:4:     if (!out || (!points && n)) return 0;
	.loc 1 4 40 discriminator 4
	mov	eax, 0	# _6,
	jmp	.L4	#
.L3:
# instructor/src/fold.c:5:     uint64_t sum=0;
	.loc 1 5 14
	mov	QWORD PTR -16[rbp], 0	# sum,
.LBB2:
# instructor/src/fold.c:6:     for (size_t k=0; k<n; ++k) sum+=points[k].id;
	.loc 1 6 17
	mov	QWORD PTR -8[rbp], 0	# k,
# instructor/src/fold.c:6:     for (size_t k=0; k<n; ++k) sum+=points[k].id;
	.loc 1 6 5
	jmp	.L5	#
.L6:
# instructor/src/fold.c:6:     for (size_t k=0; k<n; ++k) sum+=points[k].id;
	.loc 1 6 43 discriminator 3
	mov	rdx, QWORD PTR -8[rbp]	# tmp87, k
	mov	rax, rdx	# tmp88, tmp87
	add	rax, rax	# tmp88
	add	rax, rdx	# tmp88, tmp87
	sal	rax, 3	# tmp89,
	mov	rdx, rax	# _1, tmp88
	mov	rax, QWORD PTR -24[rbp]	# tmp90, points
	add	rax, rdx	# _2, _1
# instructor/src/fold.c:6:     for (size_t k=0; k<n; ++k) sum+=points[k].id;
	.loc 1 6 46 discriminator 3
	mov	rax, QWORD PTR [rax]	# _3, _2->id
# instructor/src/fold.c:6:     for (size_t k=0; k<n; ++k) sum+=points[k].id;
	.loc 1 6 35 discriminator 3
	add	QWORD PTR -16[rbp], rax	# sum, _3
# instructor/src/fold.c:6:     for (size_t k=0; k<n; ++k) sum+=points[k].id;
	.loc 1 6 27 discriminator 3
	add	QWORD PTR -8[rbp], 1	# k,
.L5:
# instructor/src/fold.c:6:     for (size_t k=0; k<n; ++k) sum+=points[k].id;
	.loc 1 6 23 discriminator 1
	mov	rax, QWORD PTR -8[rbp]	# tmp91, k
	cmp	rax, QWORD PTR -32[rbp]	# tmp91, n
	jb	.L6	#,
.LBE2:
# instructor/src/fold.c:7:     *out=sum;
	.loc 1 7 9
	mov	rax, QWORD PTR -40[rbp]	# tmp92, out
	mov	rdx, QWORD PTR -16[rbp]	# tmp93, sum
	mov	QWORD PTR [rax], rdx	# *out_8(D), tmp93
# instructor/src/fold.c:8:     return 1;
	.loc 1 8 12
	mov	eax, 1	# _6,
.L4:
# instructor/src/fold.c:9: }
	.loc 1 9 1
	pop	rbp	#
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE1:
	.size	fold_ids, .-fold_ids
.Letext0:
	.file 2 "/usr/lib/gcc/x86_64-linux-gnu/11/include/stddef.h"
	.file 3 "/usr/include/x86_64-linux-gnu/bits/types.h"
	.file 4 "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h"
	.file 5 "support/geolab/geolab_types.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x16b
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF18
	.byte	0xc
	.long	.LASF19
	.long	.LASF20
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF0
	.uleb128 0x3
	.long	.LASF9
	.byte	0x2
	.byte	0xd1
	.byte	0x17
	.long	0x40
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF1
	.uleb128 0x4
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
	.uleb128 0x3
	.long	.LASF10
	.byte	0x3
	.byte	0x2d
	.byte	0x1b
	.long	0x40
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF11
	.uleb128 0x3
	.long	.LASF12
	.byte	0x4
	.byte	0x1b
	.byte	0x14
	.long	0x7f
	.uleb128 0x5
	.byte	0x18
	.byte	0x5
	.byte	0x8
	.byte	0x9
	.long	0xce
	.uleb128 0x6
	.string	"id"
	.byte	0x5
	.byte	0x8
	.byte	0x1b
	.long	0x92
	.byte	0
	.uleb128 0x7
	.long	.LASF13
	.byte	0x5
	.byte	0x8
	.byte	0x26
	.long	0xce
	.byte	0x8
	.uleb128 0x7
	.long	.LASF14
	.byte	0x5
	.byte	0x8
	.byte	0x36
	.long	0xce
	.byte	0x10
	.byte	0
	.uleb128 0x2
	.byte	0x8
	.byte	0x4
	.long	.LASF15
	.uleb128 0x3
	.long	.LASF16
	.byte	0x5
	.byte	0x8
	.byte	0x41
	.long	0x9e
	.uleb128 0x8
	.long	0xd5
	.uleb128 0x9
	.long	.LASF21
	.byte	0x1
	.byte	0x2
	.byte	0x5
	.long	0x47
	.quad	.LFB1
	.quad	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.long	0x162
	.uleb128 0xa
	.long	.LASF17
	.byte	0x1
	.byte	0x2
	.byte	0x1e
	.long	0x162
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0xb
	.string	"n"
	.byte	0x1
	.byte	0x2
	.byte	0x2d
	.long	0x34
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0xb
	.string	"out"
	.byte	0x1
	.byte	0x2
	.byte	0x3a
	.long	0x168
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0xc
	.string	"sum"
	.byte	0x1
	.byte	0x5
	.byte	0xe
	.long	0x92
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0xd
	.quad	.LBB2
	.quad	.LBE2-.LBB2
	.uleb128 0xc
	.string	"k"
	.byte	0x1
	.byte	0x6
	.byte	0x11
	.long	0x34
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.uleb128 0xe
	.byte	0x8
	.long	0xe1
	.uleb128 0xe
	.byte	0x8
	.long	0x92
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
	.uleb128 0x4
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
	.uleb128 0x5
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xd
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
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0xd
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
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
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
	.uleb128 0xa
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
	.uleb128 0xb
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
	.uleb128 0xc
	.uleb128 0x34
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
	.uleb128 0xd
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.uleb128 0xe
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
.LASF9:
	.string	"size_t"
.LASF19:
	.string	"instructor/src/fold.c"
.LASF20:
	.string	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11"
.LASF17:
	.string	"points"
.LASF1:
	.string	"long unsigned int"
.LASF12:
	.string	"uint64_t"
.LASF14:
	.string	"lon_deg"
.LASF11:
	.string	"char"
.LASF18:
	.string	"GNU C11 11.4.0 -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O0 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection"
.LASF4:
	.string	"unsigned char"
.LASF16:
	.string	"GeoPoint"
.LASF0:
	.string	"long int"
.LASF15:
	.string	"double"
.LASF5:
	.string	"short unsigned int"
.LASF7:
	.string	"signed char"
.LASF3:
	.string	"long double"
.LASF13:
	.string	"lat_deg"
.LASF8:
	.string	"short int"
.LASF6:
	.string	"unsigned int"
.LASF10:
	.string	"__uint64_t"
.LASF21:
	.string	"fold_ids"
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
