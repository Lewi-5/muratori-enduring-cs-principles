	.file	"wrappers.c"
	.intel_syntax noprefix
# GNU C11 (Ubuntu 11.4.0-1ubuntu1~22.04.3) version 11.4.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O2 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
.Ltext0:
	.p2align 4
	.globl	distance_to_origin
	.type	distance_to_origin, @function
distance_to_origin:
.LVL0:
.LFB13:
	.file 1 "instructor/src/wrappers.c"
	.loc 1 4 1 view -0
	.cfi_startproc
	.loc 1 4 1 is_stmt 0 view .LVU1
	endbr64	
	.loc 1 5 5 is_stmt 1 view .LVU2
# instructor/src/wrappers.c:5:     return geo_distance_km(0.0,0.0,lat,lon,out);
	.loc 1 5 12 is_stmt 0 view .LVU3
	movapd	xmm3, xmm1	#, tmp88
	pxor	xmm1, xmm1	#
.LVL1:
# instructor/src/wrappers.c:4: {
	.loc 1 4 1 view .LVU4
	movapd	xmm2, xmm0	# tmp87, lat
# instructor/src/wrappers.c:5:     return geo_distance_km(0.0,0.0,lat,lon,out);
	.loc 1 5 12 view .LVU5
	movapd	xmm0, xmm1	#,
.LVL2:
	.loc 1 5 12 view .LVU6
	jmp	geo_distance_km@PLT	#
.LVL3:
	.loc 1 5 12 view .LVU7
	.cfi_endproc
.LFE13:
	.size	distance_to_origin, .-distance_to_origin
	.p2align 4
	.globl	compare_hit_values
	.type	compare_hit_values, @function
compare_hit_values:
.LVL4:
.LFB14:
	.loc 1 8 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 8 1 is_stmt 0 view .LVU9
	endbr64	
	sub	rsp, 72	#,
	.cfi_def_cfa_offset 80
# instructor/src/wrappers.c:8: {
	.loc 1 8 1 view .LVU10
	mov	rax, QWORD PTR fs:40	# tmp110, MEM[(<address-space-1> long unsigned int *)40B]
	mov	QWORD PTR 56[rsp], rax	# D.3240, tmp110
	xor	eax, eax	# tmp110
	.loc 1 9 5 is_stmt 1 view .LVU11
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 8 is_stmt 0 view .LVU12
	test	rdx, rdx	# out
	mov	QWORD PTR 8[rsp], rdx	# %sfp, out
	je	.L6	#,
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 18 discriminator 2 view .LVU13
	movq	xmm2, QWORD PTR .LC1[rip]	# tmp93,
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 14 discriminator 2 view .LVU14
	movsd	xmm3, QWORD PTR .LC2[rip]	# tmp94,
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 18 discriminator 2 view .LVU15
	movapd	xmm4, xmm0	# tmp92, da
	andpd	xmm4, xmm2	# tmp92, tmp93
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 14 discriminator 2 view .LVU16
	ucomisd	xmm3, xmm4	# tmp94, tmp92
	jb	.L3	#,
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 35 discriminator 4 view .LVU17
	andpd	xmm2, xmm1	# tmp95, db
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 31 discriminator 4 view .LVU18
	ucomisd	xmm3, xmm2	# tmp94, tmp95
	jb	.L3	#,
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 48 discriminator 6 view .LVU19
	pxor	xmm2, xmm2	# tmp98
	comisd	xmm2, xmm0	# tmp98, da
	ja	.L3	#,
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 56 discriminator 8 view .LVU20
	comisd	xmm2, xmm1	# tmp98, db
	ja	.L3	#,
	.loc 1 10 5 is_stmt 1 view .LVU21
# instructor/src/wrappers.c:10:     QueryHit a={id_a,da}, b={id_b,db};
	.loc 1 10 14 is_stmt 0 view .LVU22
	mov	QWORD PTR 16[rsp], rdi	# a.id, id_a
# instructor/src/wrappers.c:11:     int order=query_hit_compare(&a,&b);
	.loc 1 11 15 view .LVU23
	lea	rdi, 16[rsp]	# tmp101,
.LVL5:
# instructor/src/wrappers.c:10:     QueryHit a={id_a,da}, b={id_b,db};
	.loc 1 10 27 view .LVU24
	mov	QWORD PTR 32[rsp], rsi	# b.id, id_b
# instructor/src/wrappers.c:11:     int order=query_hit_compare(&a,&b);
	.loc 1 11 15 view .LVU25
	lea	rsi, 32[rsp]	# tmp100,
.LVL6:
# instructor/src/wrappers.c:10:     QueryHit a={id_a,da}, b={id_b,db};
	.loc 1 10 14 view .LVU26
	movsd	QWORD PTR 24[rsp], xmm0	# a.distance_km, da
# instructor/src/wrappers.c:10:     QueryHit a={id_a,da}, b={id_b,db};
	.loc 1 10 27 view .LVU27
	movsd	QWORD PTR 40[rsp], xmm1	# b.distance_km, db
	.loc 1 11 5 is_stmt 1 view .LVU28
# instructor/src/wrappers.c:11:     int order=query_hit_compare(&a,&b);
	.loc 1 11 15 is_stmt 0 view .LVU29
	call	query_hit_compare@PLT	#
.LVL7:
	.loc 1 12 5 is_stmt 1 view .LVU30
# instructor/src/wrappers.c:12:     *out=order;
	.loc 1 12 9 is_stmt 0 view .LVU31
	mov	rdx, QWORD PTR 8[rsp]	# out, %sfp
	mov	DWORD PTR [rdx], eax	# *out_5(D), tmp109
	.loc 1 13 5 is_stmt 1 view .LVU32
# instructor/src/wrappers.c:13:     return 1;
	.loc 1 13 12 is_stmt 0 view .LVU33
	mov	eax, 1	# <retval>,
.LVL8:
	.p2align 4,,10
	.p2align 3
.L3:
# instructor/src/wrappers.c:14: }
	.loc 1 14 1 view .LVU34
	mov	rdx, QWORD PTR 56[rsp]	# tmp111, D.3240
	sub	rdx, QWORD PTR fs:40	# tmp111, MEM[(<address-space-1> long unsigned int *)40B]
	jne	.L12	#,
	add	rsp, 72	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret	
.LVL9:
	.p2align 4,,10
	.p2align 3
.L6:
	.cfi_restore_state
# instructor/src/wrappers.c:9:     if (!out || !isfinite(da) || !isfinite(db) || da<0 || db<0) return 0;
	.loc 1 9 72 view .LVU35
	xor	eax, eax	# <retval>
	jmp	.L3	#
.LVL10:
.L12:
# instructor/src/wrappers.c:14: }
	.loc 1 14 1 view .LVU36
	call	__stack_chk_fail@PLT	#
.LVL11:
	.cfi_endproc
.LFE14:
	.size	compare_hit_values, .-compare_hit_values
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC1:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
	.section	.rodata.cst8,"aM",@progbits,8
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
	.long	0x2af
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF22
	.byte	0xc
	.long	.LASF23
	.long	.LASF24
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.byte	0x8
	.byte	0x4
	.long	.LASF0
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF1
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF2
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF3
	.uleb128 0x2
	.byte	0x10
	.byte	0x4
	.long	.LASF4
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.long	.LASF5
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.long	.LASF6
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF7
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF8
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.long	.LASF9
	.uleb128 0x4
	.long	.LASF11
	.byte	0x2
	.byte	0x2d
	.byte	0x1b
	.long	0x3b
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF10
	.uleb128 0x4
	.long	.LASF12
	.byte	0x3
	.byte	0x1b
	.byte	0x14
	.long	0x7a
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
	.long	0x8d
	.byte	0
	.uleb128 0x7
	.long	.LASF13
	.byte	0x4
	.byte	0x2a
	.byte	0x26
	.long	0x2d
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
	.long	0x42
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
	.long	0x42
	.long	0x11b
	.uleb128 0x9
	.long	0x2d
	.uleb128 0x9
	.long	0x2d
	.uleb128 0x9
	.long	0x2d
	.uleb128 0x9
	.long	0x2d
	.uleb128 0x9
	.long	0x11b
	.byte	0
	.uleb128 0xa
	.byte	0x8
	.long	0x2d
	.uleb128 0xc
	.long	.LASF20
	.byte	0x1
	.byte	0x7
	.byte	0x5
	.long	0x42
	.quad	.LFB14
	.quad	.LFE14-.LFB14
	.uleb128 0x1
	.byte	0x9c
	.long	0x1ff
	.uleb128 0xd
	.long	.LASF18
	.byte	0x1
	.byte	0x7
	.byte	0x21
	.long	0x8d
	.long	.LLST3
	.long	.LVUS3
	.uleb128 0xe
	.string	"da"
	.byte	0x1
	.byte	0x7
	.byte	0x2e
	.long	0x2d
	.long	.LLST4
	.long	.LVUS4
	.uleb128 0xd
	.long	.LASF19
	.byte	0x1
	.byte	0x7
	.byte	0x3b
	.long	0x8d
	.long	.LLST5
	.long	.LVUS5
	.uleb128 0xe
	.string	"db"
	.byte	0x1
	.byte	0x7
	.byte	0x48
	.long	0x2d
	.long	.LLST6
	.long	.LVUS6
	.uleb128 0xe
	.string	"out"
	.byte	0x1
	.byte	0x7
	.byte	0x51
	.long	0x1ff
	.long	.LLST7
	.long	.LVUS7
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
	.long	.LASF25
	.byte	0x1
	.byte	0xb
	.byte	0x9
	.long	0x42
	.long	.LLST8
	.long	.LVUS8
	.uleb128 0x11
	.quad	.LVL7
	.long	0xcf
	.long	0x1f1
	.uleb128 0x12
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x12
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.byte	0
	.uleb128 0x13
	.quad	.LVL11
	.long	0x2a9
	.byte	0
	.uleb128 0xa
	.byte	0x8
	.long	0x42
	.uleb128 0xc
	.long	.LASF21
	.byte	0x1
	.byte	0x3
	.byte	0x5
	.long	0x42
	.quad	.LFB13
	.quad	.LFE13-.LFB13
	.uleb128 0x1
	.byte	0x9c
	.long	0x2a9
	.uleb128 0xe
	.string	"lat"
	.byte	0x1
	.byte	0x3
	.byte	0x1f
	.long	0x2d
	.long	.LLST0
	.long	.LVUS0
	.uleb128 0xe
	.string	"lon"
	.byte	0x1
	.byte	0x3
	.byte	0x2b
	.long	0x2d
	.long	.LLST1
	.long	.LVUS1
	.uleb128 0xe
	.string	"out"
	.byte	0x1
	.byte	0x3
	.byte	0x38
	.long	0x11b
	.long	.LLST2
	.long	.LVUS2
	.uleb128 0x14
	.quad	.LVL3
	.long	0xf1
	.uleb128 0x12
	.uleb128 0x1
	.byte	0x61
	.uleb128 0xb
	.byte	0xf4
	.uleb128 0x2d
	.byte	0x8
	.long	0
	.long	0
	.uleb128 0x12
	.uleb128 0x1
	.byte	0x62
	.uleb128 0xb
	.byte	0xf4
	.uleb128 0x2d
	.byte	0x8
	.long	0
	.long	0
	.uleb128 0x12
	.uleb128 0x1
	.byte	0x63
	.uleb128 0x5
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x11
	.uleb128 0x2d
	.uleb128 0x12
	.uleb128 0x1
	.byte	0x64
	.uleb128 0x5
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x12
	.uleb128 0x2d
	.uleb128 0x12
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x55
	.byte	0
	.byte	0
	.uleb128 0x15
	.long	.LASF26
	.long	.LASF26
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
	.uleb128 0x2117
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x410a
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x2111
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x4109
	.byte	0
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x2115
	.uleb128 0x19
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x6e
	.uleb128 0xe
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
.LVUS3:
	.uleb128 0
	.uleb128 .LVU24
	.uleb128 .LVU24
	.uleb128 .LVU30
	.uleb128 .LVU30
	.uleb128 .LVU35
	.uleb128 .LVU35
	.uleb128 .LVU36
	.uleb128 .LVU36
	.uleb128 0
.LLST3:
	.quad	.LVL4-.Ltext0
	.quad	.LVL5-.Ltext0
	.value	0x1
	.byte	0x55
	.quad	.LVL5-.Ltext0
	.quad	.LVL7-1-.Ltext0
	.value	0x2
	.byte	0x75
	.sleb128 0
	.quad	.LVL7-1-.Ltext0
	.quad	.LVL9-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x55
	.byte	0x9f
	.quad	.LVL9-.Ltext0
	.quad	.LVL10-.Ltext0
	.value	0x1
	.byte	0x55
	.quad	.LVL10-.Ltext0
	.quad	.LFE14-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x55
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS4:
	.uleb128 0
	.uleb128 .LVU30
	.uleb128 .LVU30
	.uleb128 .LVU35
	.uleb128 .LVU35
	.uleb128 .LVU36
	.uleb128 .LVU36
	.uleb128 0
.LLST4:
	.quad	.LVL4-.Ltext0
	.quad	.LVL7-1-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL7-1-.Ltext0
	.quad	.LVL9-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x11
	.uleb128 0x2d
	.byte	0x9f
	.quad	.LVL9-.Ltext0
	.quad	.LVL10-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL10-.Ltext0
	.quad	.LFE14-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x11
	.uleb128 0x2d
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS5:
	.uleb128 0
	.uleb128 .LVU26
	.uleb128 .LVU26
	.uleb128 .LVU30
	.uleb128 .LVU30
	.uleb128 .LVU35
	.uleb128 .LVU35
	.uleb128 .LVU36
	.uleb128 .LVU36
	.uleb128 0
.LLST5:
	.quad	.LVL4-.Ltext0
	.quad	.LVL6-.Ltext0
	.value	0x1
	.byte	0x54
	.quad	.LVL6-.Ltext0
	.quad	.LVL7-1-.Ltext0
	.value	0x2
	.byte	0x74
	.sleb128 0
	.quad	.LVL7-1-.Ltext0
	.quad	.LVL9-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x54
	.byte	0x9f
	.quad	.LVL9-.Ltext0
	.quad	.LVL10-.Ltext0
	.value	0x1
	.byte	0x54
	.quad	.LVL10-.Ltext0
	.quad	.LFE14-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x54
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS6:
	.uleb128 0
	.uleb128 .LVU30
	.uleb128 .LVU30
	.uleb128 .LVU35
	.uleb128 .LVU35
	.uleb128 .LVU36
	.uleb128 .LVU36
	.uleb128 0
.LLST6:
	.quad	.LVL4-.Ltext0
	.quad	.LVL7-1-.Ltext0
	.value	0x1
	.byte	0x62
	.quad	.LVL7-1-.Ltext0
	.quad	.LVL9-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x12
	.uleb128 0x2d
	.byte	0x9f
	.quad	.LVL9-.Ltext0
	.quad	.LVL10-.Ltext0
	.value	0x1
	.byte	0x62
	.quad	.LVL10-.Ltext0
	.quad	.LFE14-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x12
	.uleb128 0x2d
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS7:
	.uleb128 0
	.uleb128 .LVU30
	.uleb128 .LVU30
	.uleb128 .LVU35
	.uleb128 .LVU35
	.uleb128 .LVU36
	.uleb128 .LVU36
	.uleb128 0
.LLST7:
	.quad	.LVL4-.Ltext0
	.quad	.LVL7-1-.Ltext0
	.value	0x1
	.byte	0x51
	.quad	.LVL7-1-.Ltext0
	.quad	.LVL9-.Ltext0
	.value	0x3
	.byte	0x91
	.sleb128 -72
	.quad	.LVL9-.Ltext0
	.quad	.LVL10-.Ltext0
	.value	0x1
	.byte	0x51
	.quad	.LVL10-.Ltext0
	.quad	.LFE14-.Ltext0
	.value	0x3
	.byte	0x91
	.sleb128 -72
	.quad	0
	.quad	0
.LVUS8:
	.uleb128 .LVU30
	.uleb128 .LVU34
.LLST8:
	.quad	.LVL7-.Ltext0
	.quad	.LVL8-.Ltext0
	.value	0x1
	.byte	0x50
	.quad	0
	.quad	0
.LVUS0:
	.uleb128 0
	.uleb128 .LVU6
	.uleb128 .LVU6
	.uleb128 .LVU7
	.uleb128 .LVU7
	.uleb128 0
.LLST0:
	.quad	.LVL0-.Ltext0
	.quad	.LVL2-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL2-.Ltext0
	.quad	.LVL3-1-.Ltext0
	.value	0x1
	.byte	0x63
	.quad	.LVL3-1-.Ltext0
	.quad	.LFE13-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x11
	.uleb128 0x2d
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS1:
	.uleb128 0
	.uleb128 .LVU4
	.uleb128 .LVU4
	.uleb128 .LVU7
	.uleb128 .LVU7
	.uleb128 0
.LLST1:
	.quad	.LVL0-.Ltext0
	.quad	.LVL1-.Ltext0
	.value	0x1
	.byte	0x62
	.quad	.LVL1-.Ltext0
	.quad	.LVL3-1-.Ltext0
	.value	0x1
	.byte	0x64
	.quad	.LVL3-1-.Ltext0
	.quad	.LFE13-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x12
	.uleb128 0x2d
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS2:
	.uleb128 0
	.uleb128 .LVU7
	.uleb128 .LVU7
	.uleb128 0
.LLST2:
	.quad	.LVL0-.Ltext0
	.quad	.LVL3-1-.Ltext0
	.value	0x1
	.byte	0x55
	.quad	.LVL3-1-.Ltext0
	.quad	.LFE13-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x55
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
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF25:
	.string	"order"
.LASF23:
	.string	"instructor/src/wrappers.c"
.LASF21:
	.string	"distance_to_origin"
.LASF12:
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
.LASF2:
	.string	"long unsigned int"
.LASF6:
	.string	"short unsigned int"
.LASF26:
	.string	"__stack_chk_fail"
.LASF5:
	.string	"unsigned char"
.LASF0:
	.string	"double"
.LASF22:
	.string	"GNU C11 11.4.0 -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O2 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection"
.LASF9:
	.string	"short int"
.LASF24:
	.string	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11"
.LASF7:
	.string	"unsigned int"
.LASF13:
	.string	"distance_km"
.LASF10:
	.string	"char"
.LASF3:
	.string	"long long int"
.LASF20:
	.string	"compare_hit_values"
.LASF17:
	.string	"geo_distance_km"
.LASF11:
	.string	"__uint64_t"
.LASF1:
	.string	"long int"
.LASF4:
	.string	"long double"
.LASF8:
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
