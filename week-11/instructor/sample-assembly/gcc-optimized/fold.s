	.file	"fold.c"
	.intel_syntax noprefix
# GNU C11 (Ubuntu 11.4.0-1ubuntu1~22.04.3) version 11.4.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O2 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
.Ltext0:
	.p2align 4
	.globl	fold_ids
	.type	fold_ids, @function
fold_ids:
.LVL0:
.LFB13:
	.file 1 "instructor/src/fold.c"
	.loc 1 3 1 view -0
	.cfi_startproc
	.loc 1 3 1 is_stmt 0 view .LVU1
	endbr64	
	.loc 1 4 5 is_stmt 1 view .LVU2
# instructor/src/fold.c:4:     if (!out || (!points && n)) return 0;
	.loc 1 4 8 is_stmt 0 view .LVU3
	test	rdx, rdx	# out
	je	.L6	#,
# instructor/src/fold.c:4:     if (!out || (!points && n)) return 0;
	.loc 1 4 14 discriminator 2 view .LVU4
	test	rdi, rdi	# points
	jne	.L8	#,
# instructor/src/fold.c:4:     if (!out || (!points && n)) return 0;
	.loc 1 4 40 discriminator 2 view .LVU5
	xor	eax, eax	# <retval>
# instructor/src/fold.c:4:     if (!out || (!points && n)) return 0;
	.loc 1 4 14 discriminator 2 view .LVU6
	test	rsi, rsi	# n
	je	.L4	#,
# instructor/src/fold.c:9: }
	.loc 1 9 1 view .LVU7
	ret	
	.p2align 4,,10
	.p2align 3
.L8:
.LVL1:
.LBB2:
	.loc 1 6 23 is_stmt 1 view .LVU8
	test	rsi, rsi	# n
	je	.L4	#,
	lea	rax, [rsi+rsi*2]	# tmp100,
.LBE2:
# instructor/src/fold.c:5:     uint64_t sum=0;
	.loc 1 5 14 is_stmt 0 view .LVU9
	xor	esi, esi	# n
.LVL2:
	.loc 1 5 14 view .LVU10
	lea	rax, [rdi+rax*8]	# _26,
.LVL3:
	.p2align 4,,10
	.p2align 3
.L5:
.LBB3:
	.loc 1 6 32 is_stmt 1 discriminator 3 view .LVU11
# instructor/src/fold.c:6:     for (size_t k=0; k<n; ++k) sum+=points[k].id;
	.loc 1 6 35 is_stmt 0 discriminator 3 view .LVU12
	add	rsi, QWORD PTR [rdi]	# n, MEM[(long unsigned int *)_23]
.LVL4:
	.loc 1 6 27 is_stmt 1 discriminator 3 view .LVU13
	.loc 1 6 23 discriminator 3 view .LVU14
	add	rdi, 24	# ivtmp.7,
	cmp	rdi, rax	# ivtmp.7, _26
	jne	.L5	#,
.LVL5:
.L4:
	.loc 1 6 23 is_stmt 0 discriminator 3 view .LVU15
.LBE3:
	.loc 1 7 5 is_stmt 1 view .LVU16
# instructor/src/fold.c:7:     *out=sum;
	.loc 1 7 9 is_stmt 0 view .LVU17
	mov	QWORD PTR [rdx], rsi	# *out_11(D), n
	.loc 1 8 5 is_stmt 1 view .LVU18
# instructor/src/fold.c:8:     return 1;
	.loc 1 8 12 is_stmt 0 view .LVU19
	mov	eax, 1	# <retval>,
	ret	
.LVL6:
	.p2align 4,,10
	.p2align 3
.L6:
# instructor/src/fold.c:4:     if (!out || (!points && n)) return 0;
	.loc 1 4 40 view .LVU20
	xor	eax, eax	# <retval>
# instructor/src/fold.c:9: }
	.loc 1 9 1 view .LVU21
	ret	
	.cfi_endproc
.LFE13:
	.size	fold_ids, .-fold_ids
.Letext0:
	.file 2 "/usr/lib/gcc/x86_64-linux-gnu/11/include/stddef.h"
	.file 3 "/usr/include/x86_64-linux-gnu/bits/types.h"
	.file 4 "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h"
	.file 5 "support/geolab/geolab_types.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x172
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
	.quad	.LFB13
	.quad	.LFE13-.LFB13
	.uleb128 0x1
	.byte	0x9c
	.long	0x169
	.uleb128 0xa
	.long	.LASF17
	.byte	0x1
	.byte	0x2
	.byte	0x1e
	.long	0x169
	.long	.LLST0
	.long	.LVUS0
	.uleb128 0xb
	.string	"n"
	.byte	0x1
	.byte	0x2
	.byte	0x2d
	.long	0x34
	.long	.LLST1
	.long	.LVUS1
	.uleb128 0xc
	.string	"out"
	.byte	0x1
	.byte	0x2
	.byte	0x3a
	.long	0x16f
	.uleb128 0x1
	.byte	0x51
	.uleb128 0xd
	.string	"sum"
	.byte	0x1
	.byte	0x5
	.byte	0xe
	.long	0x92
	.long	.LLST2
	.long	.LVUS2
	.uleb128 0xe
	.long	.Ldebug_ranges0+0
	.uleb128 0xd
	.string	"k"
	.byte	0x1
	.byte	0x6
	.byte	0x11
	.long	0x34
	.long	.LLST3
	.long	.LVUS3
	.byte	0
	.byte	0
	.uleb128 0xf
	.byte	0x8
	.long	0xe1
	.uleb128 0xf
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xc
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
	.uleb128 0xd
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xf
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
	.uleb128 .LVU11
	.uleb128 .LVU11
	.uleb128 .LVU20
	.uleb128 .LVU20
	.uleb128 0
.LLST0:
	.quad	.LVL0-.Ltext0
	.quad	.LVL3-.Ltext0
	.value	0x1
	.byte	0x55
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
	.uleb128 .LVU10
	.uleb128 .LVU10
	.uleb128 .LVU20
	.uleb128 .LVU20
	.uleb128 0
.LLST1:
	.quad	.LVL0-.Ltext0
	.quad	.LVL2-.Ltext0
	.value	0x1
	.byte	0x54
	.quad	.LVL2-.Ltext0
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
	.uleb128 .LVU8
	.uleb128 .LVU11
	.uleb128 .LVU11
	.uleb128 .LVU15
.LLST2:
	.quad	.LVL1-.Ltext0
	.quad	.LVL3-.Ltext0
	.value	0x2
	.byte	0x30
	.byte	0x9f
	.quad	.LVL3-.Ltext0
	.quad	.LVL5-.Ltext0
	.value	0x1
	.byte	0x54
	.quad	0
	.quad	0
.LVUS3:
	.uleb128 .LVU8
	.uleb128 .LVU11
.LLST3:
	.quad	.LVL1-.Ltext0
	.quad	.LVL3-.Ltext0
	.value	0x2
	.byte	0x30
	.byte	0x9f
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
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.quad	.LBB2-.Ltext0
	.quad	.LBE2-.Ltext0
	.quad	.LBB3-.Ltext0
	.quad	.LBE3-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF2:
	.string	"long long int"
.LASF9:
	.string	"size_t"
.LASF18:
	.string	"GNU C11 11.4.0 -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O2 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection"
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
