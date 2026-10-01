	.file	"wrappers.c"
	.intel_syntax noprefix
# GNU C11 (Ubuntu 11.4.0-1ubuntu1~22.04.3) version 11.4.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O0 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
.Ltext0:
	.globl	distance_to_origin
	.type	distance_to_origin, @function
distance_to_origin:
.LFB1:
	.file 1 "instructor/src/wrappers.c"
	.loc 1 4 1
	.cfi_startproc
	endbr64	
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	sub	rsp, 32	#,
	movsd	QWORD PTR -8[rbp], xmm0	# lat, lat
	movsd	QWORD PTR -16[rbp], xmm1	# lon, lon
	mov	QWORD PTR -24[rbp], rdi	# out, out
# instructor/src/wrappers.c:5:     return geo_distance_km(0.0,0.0,lat,lon,out);
	.loc 1 5 12
	mov	rax, QWORD PTR -24[rbp]	# tmp84, out
	movsd	xmm1, QWORD PTR -16[rbp]	# tmp85, lon
	movsd	xmm0, QWORD PTR -8[rbp]	# tmp86, lat
	mov	rdi, rax	#, tmp84
	movapd	xmm3, xmm1	#, tmp85
	movapd	xmm2, xmm0	#, tmp86
	pxor	xmm1, xmm1	#
	mov	rax, QWORD PTR .LC0[rip]	# tmp87,
	movq	xmm0, rax	#, tmp87
	call	geo_distance_km@PLT	#
# instructor/src/wrappers.c:6: }
	.loc 1 6 1
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE1:
	.size	distance_to_origin, .-distance_to_origin
	.globl	compare_hit_values
	.type	compare_hit_values, @function
compare_hit_values:
.LFB2:
	.loc 1 8 1
	.cfi_startproc
	endbr64	
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	sub	rsp, 112	#,
	mov	QWORD PTR -72[rbp], rdi	# id_a, id_a
	movsd	QWORD PTR -80[rbp], xmm0	# da, da
	mov	QWORD PTR -88[rbp], rsi	# id_b, id_b
	movsd	QWORD PTR -96[rbp], xmm1	# db, db
	mov	QWORD PTR -104[rbp], rdx	# out, out
# instructor/src/wrappers.c:8: {
	.loc 1 8 1
	mov	rax, QWORD PTR fs:40	# tmp104, MEM[(<address-space-1> long unsigned int *)40B]
	mov	QWORD PTR -8[rbp], rax	# D.3106, tmp104
	xor	eax, eax	# tmp104
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 8
	cmp	QWORD PTR -104[rbp], 0	# out,
	je	.L4	#,
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 18 discriminator 2
	movsd	xmm0, QWORD PTR -80[rbp]	# tmp86, da
	movq	xmm1, QWORD PTR .LC1[rip]	# tmp87,
	andpd	xmm1, xmm0	# _1, tmp86
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 14 discriminator 2
	movsd	xmm0, QWORD PTR .LC2[rip]	# tmp88,
	ucomisd	xmm0, xmm1	# tmp88, _1
	jb	.L4	#,
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 35 discriminator 4
	movsd	xmm0, QWORD PTR -96[rbp]	# tmp89, db
	movq	xmm1, QWORD PTR .LC1[rip]	# tmp90,
	andpd	xmm1, xmm0	# _2, tmp89
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 31 discriminator 4
	movsd	xmm0, QWORD PTR .LC2[rip]	# tmp91,
	ucomisd	xmm0, xmm1	# tmp91, _2
	jb	.L4	#,
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 48 discriminator 6
	pxor	xmm0, xmm0	# tmp92
	comisd	xmm0, QWORD PTR -80[rbp]	# tmp92, da
	ja	.L4	#,
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 56 discriminator 8
	pxor	xmm0, xmm0	# tmp93
	comisd	xmm0, QWORD PTR -96[rbp]	# tmp93, db
	jbe	.L10	#,
.L4:
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 72 discriminator 9
	mov	eax, 0	# _3,
	jmp	.L8	#
.L10:
# instructor/src/wrappers.c:10:     QueryHit a={id_a,da}, b={id_b,db};
	.loc 1 10 14
	mov	rax, QWORD PTR -72[rbp]	# tmp94, id_a
	mov	QWORD PTR -48[rbp], rax	# a.id, tmp94
	movsd	xmm0, QWORD PTR -80[rbp]	# tmp95, da
	movsd	QWORD PTR -40[rbp], xmm0	# a.distance_km, tmp95
# instructor/src/wrappers.c:10:     QueryHit a={id_a,da}, b={id_b,db};
	.loc 1 10 27
	mov	rax, QWORD PTR -88[rbp]	# tmp96, id_b
	mov	QWORD PTR -32[rbp], rax	# b.id, tmp96
	movsd	xmm0, QWORD PTR -96[rbp]	# tmp97, db
	movsd	QWORD PTR -24[rbp], xmm0	# b.distance_km, tmp97
# instructor/src/wrappers.c:11:     int order=query_hit_compare(&a,&b);
	.loc 1 11 15
	lea	rdx, -32[rbp]	# tmp98,
	lea	rax, -48[rbp]	# tmp99,
	mov	rsi, rdx	#, tmp98
	mov	rdi, rax	#, tmp99
	call	query_hit_compare@PLT	#
	mov	DWORD PTR -52[rbp], eax	# order, tmp100
# instructor/src/wrappers.c:12:     *out=order;
	.loc 1 12 9
	mov	rax, QWORD PTR -104[rbp]	# tmp101, out
	mov	edx, DWORD PTR -52[rbp]	# tmp102, order
	mov	DWORD PTR [rax], edx	# *out_5(D), tmp102
# instructor/src/wrappers.c:13:     return 1;
	.loc 1 13 12
	mov	eax, 1	# _3,
.L8:
# instructor/src/wrappers.c:14: }
	.loc 1 14 1 discriminator 1
	mov	rdx, QWORD PTR -8[rbp]	# tmp105, D.3106
	sub	rdx, QWORD PTR fs:40	# tmp105, MEM[(<address-space-1> long unsigned int *)40B]
	je	.L9	#,
# instructor/src/wrappers.c:14: }
	.loc 1 14 1 is_stmt 0
	call	__stack_chk_fail@PLT	#
.L9:
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE2:
	.size	compare_hit_values, .-compare_hit_values
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	0
	.align 16
.LC1:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
	.align 8
.LC2:
	.long	-1
	.long	2146435071
	.text
.Letext0:
	.file 2 "/usr/include/x86_64-linux-gnu/bits/types.h"
	.file 3 "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h"
	.file 4 "support/geolab/geolab.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x20b
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF21
	.byte	0xc
	.long	.LASF22
	.long	.LASF23
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
	.byte	0x10
	.byte	0x4
	.byte	0x2a
	.byte	0x9
	.long	0xbc
	.uleb128 0x6
	.string	"id"
	.byte	0x4
	.byte	0x2a
	.byte	0x1b
	.long	0x86
	.byte	0
	.uleb128 0x7
	.long	.LASF13
	.byte	0x4
	.byte	0x2a
	.byte	0x26
	.long	0x92
	.byte	0x8
	.byte	0
	.uleb128 0x4
	.long	.LASF14
	.byte	0x4
	.byte	0x2a
	.byte	0x35
	.long	0x99
	.uleb128 0x2
	.byte	0x4
	.byte	0x4
	.long	.LASF15
	.uleb128 0x8
	.long	.LASF16
	.byte	0x4
	.byte	0x39
	.byte	0x5
	.long	0x3b
	.long	0xea
	.uleb128 0x9
	.long	0xea
	.uleb128 0x9
	.long	0xea
	.byte	0
	.uleb128 0xa
	.byte	0x8
	.long	0xf0
	.uleb128 0xb
	.uleb128 0x8
	.long	.LASF17
	.byte	0x4
	.byte	0x26
	.byte	0x5
	.long	0x3b
	.long	0x11b
	.uleb128 0x9
	.long	0x92
	.uleb128 0x9
	.long	0x92
	.uleb128 0x9
	.long	0x92
	.uleb128 0x9
	.long	0x92
	.uleb128 0x9
	.long	0x11b
	.byte	0
	.uleb128 0xa
	.byte	0x8
	.long	0x92
	.uleb128 0xc
	.long	.LASF24
	.byte	0x1
	.byte	0x7
	.byte	0x5
	.long	0x3b
	.quad	.LFB2
	.quad	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.long	0x1bc
	.uleb128 0xd
	.long	.LASF18
	.byte	0x1
	.byte	0x7
	.byte	0x21
	.long	0x86
	.uleb128 0x3
	.byte	0x91
	.sleb128 -88
	.uleb128 0xe
	.string	"da"
	.byte	0x1
	.byte	0x7
	.byte	0x2e
	.long	0x92
	.uleb128 0x3
	.byte	0x91
	.sleb128 -96
	.uleb128 0xd
	.long	.LASF19
	.byte	0x1
	.byte	0x7
	.byte	0x3b
	.long	0x86
	.uleb128 0x3
	.byte	0x91
	.sleb128 -104
	.uleb128 0xe
	.string	"db"
	.byte	0x1
	.byte	0x7
	.byte	0x48
	.long	0x92
	.uleb128 0x3
	.byte	0x91
	.sleb128 -112
	.uleb128 0xe
	.string	"out"
	.byte	0x1
	.byte	0x7
	.byte	0x51
	.long	0x1bc
	.uleb128 0x3
	.byte	0x91
	.sleb128 -120
	.uleb128 0xf
	.string	"a"
	.byte	0x1
	.byte	0xa
	.byte	0xe
	.long	0xbc
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0xf
	.string	"b"
	.byte	0x1
	.byte	0xa
	.byte	0x1b
	.long	0xbc
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x10
	.long	.LASF20
	.byte	0x1
	.byte	0xb
	.byte	0x9
	.long	0x3b
	.uleb128 0x3
	.byte	0x91
	.sleb128 -68
	.byte	0
	.uleb128 0xa
	.byte	0x8
	.long	0x3b
	.uleb128 0x11
	.long	.LASF25
	.byte	0x1
	.byte	0x3
	.byte	0x5
	.long	0x3b
	.quad	.LFB1
	.quad	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0xe
	.string	"lat"
	.byte	0x1
	.byte	0x3
	.byte	0x1f
	.long	0x92
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0xe
	.string	"lon"
	.byte	0x1
	.byte	0x3
	.byte	0x2b
	.long	0x92
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0xe
	.string	"out"
	.byte	0x1
	.byte	0x3
	.byte	0x38
	.long	0x11b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.byte	0
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
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x26
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xc
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
	.uleb128 0xd
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
	.uleb128 0xe
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
	.uleb128 0xf
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
	.uleb128 0x10
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
	.uleb128 0x11
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
.LASF20:
	.string	"order"
.LASF22:
	.string	"instructor/src/wrappers.c"
.LASF25:
	.string	"distance_to_origin"
.LASF11:
	.string	"uint64_t"
.LASF14:
	.string	"QueryHit"
.LASF16:
	.string	"query_hit_compare"
.LASF15:
	.string	"float"
.LASF18:
	.string	"id_a"
.LASF19:
	.string	"id_b"
.LASF1:
	.string	"long unsigned int"
.LASF5:
	.string	"short unsigned int"
.LASF21:
	.string	"GNU C11 11.4.0 -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O0 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection"
.LASF12:
	.string	"double"
.LASF8:
	.string	"short int"
.LASF23:
	.string	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11"
.LASF4:
	.string	"unsigned char"
.LASF6:
	.string	"unsigned int"
.LASF13:
	.string	"distance_km"
.LASF9:
	.string	"char"
.LASF2:
	.string	"long long int"
.LASF24:
	.string	"compare_hit_values"
.LASF17:
	.string	"geo_distance_km"
.LASF10:
	.string	"__uint64_t"
.LASF0:
	.string	"long int"
.LASF3:
	.string	"long double"
.LASF7:
	.string	"signed char"
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
