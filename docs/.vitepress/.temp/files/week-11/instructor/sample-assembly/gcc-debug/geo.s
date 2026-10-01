	.file	"geo.c"
	.intel_syntax noprefix
# GNU C11 (Ubuntu 11.4.0-1ubuntu1~22.04.3) version 11.4.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O0 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
.Ltext0:
	.type	deg_to_rad, @function
deg_to_rad:
.LFB1:
	.file 1 "support/geolab/geo.c"
	.loc 1 7 42
	.cfi_startproc
	endbr64	
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	movsd	QWORD PTR -8[rbp], xmm0	# degrees, degrees
# support/geolab/geo.c:7: static double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }
	.loc 1 7 59
	movsd	xmm1, QWORD PTR -8[rbp]	# tmp84, degrees
	movsd	xmm0, QWORD PTR .LC0[rip]	# tmp85,
	mulsd	xmm0, xmm1	# _2, tmp84
	movq	rax, xmm0	# <retval>, _2
# support/geolab/geo.c:7: static double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }
	.loc 1 7 79
	movq	xmm0, rax	#, <retval>
	pop	rbp	#
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE1:
	.size	deg_to_rad, .-deg_to_rad
	.type	clamp, @function
clamp:
.LFB2:
	.loc 1 9 53
	.cfi_startproc
	endbr64	
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	movsd	QWORD PTR -8[rbp], xmm0	# x, x
	movsd	QWORD PTR -16[rbp], xmm1	# lo, lo
	movsd	QWORD PTR -24[rbp], xmm2	# hi, hi
# support/geolab/geo.c:9: static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }
	.loc 1 9 74
	movsd	xmm0, QWORD PTR -16[rbp]	# tmp84, lo
	comisd	xmm0, QWORD PTR -8[rbp]	# tmp84, x
	jbe	.L13	#,
# support/geolab/geo.c:9: static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }
	.loc 1 9 74 is_stmt 0 discriminator 1
	movsd	xmm0, QWORD PTR -16[rbp]	# iftmp.1_2, lo
	jmp	.L10	#
.L13:
# support/geolab/geo.c:9: static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }
	.loc 1 9 89 is_stmt 1 discriminator 2
	movsd	xmm0, QWORD PTR -8[rbp]	# tmp85, x
	comisd	xmm0, QWORD PTR -24[rbp]	# tmp85, hi
	jbe	.L14	#,
# support/geolab/geo.c:9: static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }
	.loc 1 9 89 is_stmt 0 discriminator 4
	movsd	xmm0, QWORD PTR -24[rbp]	# iftmp.1_2, hi
# support/geolab/geo.c:9: static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }
	.loc 1 9 74 is_stmt 1 discriminator 4
	jmp	.L10	#
.L14:
# support/geolab/geo.c:9: static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }
	.loc 1 9 89 discriminator 5
	movsd	xmm0, QWORD PTR -8[rbp]	# iftmp.1_2, x
.L10:
# support/geolab/geo.c:9: static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }
	.loc 1 9 74 discriminator 9
	movq	rax, xmm0	# <retval>, iftmp.1_2
# support/geolab/geo.c:9: static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }
	.loc 1 9 95 discriminator 9
	movq	xmm0, rax	#, <retval>
	pop	rbp	#
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE2:
	.size	clamp, .-clamp
	.globl	geo_valid_position
	.type	geo_valid_position, @function
geo_valid_position:
.LFB3:
	.loc 1 12 1
	.cfi_startproc
	endbr64	
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	movsd	QWORD PTR -8[rbp], xmm0	# lat_deg, lat_deg
	movsd	QWORD PTR -16[rbp], xmm1	# lon_deg, lon_deg
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 12
	movsd	xmm0, QWORD PTR -8[rbp]	# tmp90, lat_deg
	movq	xmm1, QWORD PTR .LC1[rip]	# tmp91,
	andpd	xmm1, xmm0	# _1, tmp90
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 111
	movsd	xmm0, QWORD PTR .LC2[rip]	# tmp92,
	ucomisd	xmm0, xmm1	# tmp92, _1
	setb	al	#, _2
	xor	eax, 1	# _3,
	test	al, al	# _3
	je	.L16	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 33 discriminator 1
	movsd	xmm0, QWORD PTR -16[rbp]	# tmp93, lon_deg
	movq	xmm1, QWORD PTR .LC1[rip]	# tmp94,
	andpd	xmm1, xmm0	# _4, tmp93
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 30 discriminator 1
	movsd	xmm0, QWORD PTR .LC2[rip]	# tmp95,
	ucomisd	xmm0, xmm1	# tmp95, _4
	setb	al	#, _5
	xor	eax, 1	# _6,
	test	al, al	# _6
	je	.L16	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 51 discriminator 3
	movsd	xmm0, QWORD PTR -8[rbp]	# tmp96, lat_deg
	comisd	xmm0, QWORD PTR .LC3[rip]	# tmp96,
	jb	.L16	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 71 discriminator 5
	movsd	xmm0, QWORD PTR .LC4[rip]	# tmp97,
	comisd	xmm0, QWORD PTR -8[rbp]	# tmp97, lat_deg
	jb	.L16	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 90 discriminator 7
	movsd	xmm0, QWORD PTR -16[rbp]	# tmp98, lon_deg
	comisd	xmm0, QWORD PTR .LC5[rip]	# tmp98,
	jb	.L16	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 111 discriminator 9
	movsd	xmm0, QWORD PTR .LC6[rip]	# tmp99,
	comisd	xmm0, QWORD PTR -16[rbp]	# tmp99, lon_deg
	jb	.L16	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 111 is_stmt 0 discriminator 11
	mov	eax, 1	# iftmp.2_7,
	jmp	.L22	#
.L16:
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 111 discriminator 12
	mov	eax, 0	# iftmp.2_7,
.L22:
# support/geolab/geo.c:15: }
	.loc 1 15 1 is_stmt 1 discriminator 15
	pop	rbp	#
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE3:
	.size	geo_valid_position, .-geo_valid_position
	.globl	geo_distance_km
	.type	geo_distance_km, @function
geo_distance_km:
.LFB4:
	.loc 1 20 1
	.cfi_startproc
	endbr64	
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	sub	rsp, 96	#,
	movsd	QWORD PTR -40[rbp], xmm0	# lat1, lat1
	movsd	QWORD PTR -48[rbp], xmm1	# lon1, lon1
	movsd	QWORD PTR -56[rbp], xmm2	# lat2, lat2
	movsd	QWORD PTR -64[rbp], xmm3	# lon2, lon2
	mov	QWORD PTR -72[rbp], rdi	# out, out
# support/geolab/geo.c:21:     if (out == NULL || !geo_valid_position(lat1, lon1) || !geo_valid_position(lat2, lon2)) return 0;
	.loc 1 21 8
	cmp	QWORD PTR -72[rbp], 0	# out,
	je	.L28	#,
# support/geolab/geo.c:21:     if (out == NULL || !geo_valid_position(lat1, lon1) || !geo_valid_position(lat2, lon2)) return 0;
	.loc 1 21 25 discriminator 2
	movsd	xmm0, QWORD PTR -48[rbp]	# tmp105, lon1
	mov	rax, QWORD PTR -40[rbp]	# tmp106, lat1
	movapd	xmm1, xmm0	#, tmp105
	movq	xmm0, rax	#, tmp106
	call	geo_valid_position	#
# support/geolab/geo.c:21:     if (out == NULL || !geo_valid_position(lat1, lon1) || !geo_valid_position(lat2, lon2)) return 0;
	.loc 1 21 21 discriminator 2
	test	eax, eax	# _1
	je	.L28	#,
# support/geolab/geo.c:21:     if (out == NULL || !geo_valid_position(lat1, lon1) || !geo_valid_position(lat2, lon2)) return 0;
	.loc 1 21 60 discriminator 4
	movsd	xmm0, QWORD PTR -64[rbp]	# tmp107, lon2
	mov	rax, QWORD PTR -56[rbp]	# tmp108, lat2
	movapd	xmm1, xmm0	#, tmp107
	movq	xmm0, rax	#, tmp108
	call	geo_valid_position	#
# support/geolab/geo.c:21:     if (out == NULL || !geo_valid_position(lat1, lon1) || !geo_valid_position(lat2, lon2)) return 0;
	.loc 1 21 56 discriminator 4
	test	eax, eax	# _2
	jne	.L29	#,
.L28:
# support/geolab/geo.c:21:     if (out == NULL || !geo_valid_position(lat1, lon1) || !geo_valid_position(lat2, lon2)) return 0;
	.loc 1 21 99 discriminator 5
	mov	eax, 0	# _22,
	jmp	.L30	#
.L29:
# support/geolab/geo.c:22:     double sd_lat = sin(deg_to_rad(lat2 - lat1) / 2.0);
	.loc 1 22 25
	movsd	xmm0, QWORD PTR -56[rbp]	# tmp109, lat2
	subsd	xmm0, QWORD PTR -40[rbp]	# tmp109, lat1
	movq	rax, xmm0	# _3, tmp109
	movq	xmm0, rax	#, _3
	call	deg_to_rad	#
	movq	rax, xmm0	# _4,
# support/geolab/geo.c:22:     double sd_lat = sin(deg_to_rad(lat2 - lat1) / 2.0);
	.loc 1 22 21
	movsd	xmm0, QWORD PTR .LC7[rip]	# tmp110,
	movq	xmm4, rax	# _4, _4
	divsd	xmm4, xmm0	# _4, tmp110
	movq	rax, xmm4	# _5, _4
	movq	xmm0, rax	#, _5
	call	sin@PLT	#
	movq	rax, xmm0	# tmp111,
	mov	QWORD PTR -24[rbp], rax	# sd_lat, tmp111
# support/geolab/geo.c:23:     double sd_lon = sin(deg_to_rad(lon2 - lon1) / 2.0);
	.loc 1 23 25
	movsd	xmm0, QWORD PTR -64[rbp]	# tmp112, lon2
	subsd	xmm0, QWORD PTR -48[rbp]	# tmp112, lon1
	movq	rax, xmm0	# _6, tmp112
	movq	xmm0, rax	#, _6
	call	deg_to_rad	#
	movq	rax, xmm0	# _7,
# support/geolab/geo.c:23:     double sd_lon = sin(deg_to_rad(lon2 - lon1) / 2.0);
	.loc 1 23 21
	movsd	xmm0, QWORD PTR .LC7[rip]	# tmp113,
	movq	xmm5, rax	# _7, _7
	divsd	xmm5, xmm0	# _7, tmp113
	movq	rax, xmm5	# _8, _7
	movq	xmm0, rax	#, _8
	call	sin@PLT	#
	movq	rax, xmm0	# tmp114,
	mov	QWORD PTR -16[rbp], rax	# sd_lon, tmp114
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 23
	movsd	xmm0, QWORD PTR -24[rbp]	# tmp115, sd_lat
	mulsd	xmm0, xmm0	# tmp115, tmp115
	movsd	QWORD PTR -80[rbp], xmm0	# %sfp, tmp115
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 34
	mov	rax, QWORD PTR -40[rbp]	# tmp116, lat1
	movq	xmm0, rax	#, tmp116
	call	deg_to_rad	#
	movq	rax, xmm0	# _10,
	movq	xmm0, rax	#, _10
	call	cos@PLT	#
	movsd	QWORD PTR -88[rbp], xmm0	# %sfp,
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 58
	mov	rax, QWORD PTR -56[rbp]	# tmp117, lat2
	movq	xmm0, rax	#, tmp117
	call	deg_to_rad	#
	movq	rax, xmm0	# _12,
	movq	xmm0, rax	#, _12
	call	cos@PLT	#
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 56
	mulsd	xmm0, QWORD PTR -88[rbp]	# _14, %sfp
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 80
	mulsd	xmm0, QWORD PTR -16[rbp]	# _15, sd_lon
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 89
	mulsd	xmm0, QWORD PTR -16[rbp]	# _16, sd_lon
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 12
	addsd	xmm0, QWORD PTR -80[rbp]	# tmp118, %sfp
	movsd	QWORD PTR -8[rbp], xmm0	# a, tmp118
# support/geolab/geo.c:25:     *out = 2.0 * asin(sqrt(clamp(a, 0.0, 1.0))) * GEO_EARTH_RADIUS_KM;
	.loc 1 25 18
	movsd	xmm0, QWORD PTR .LC8[rip]	# tmp119,
	mov	rax, QWORD PTR -8[rbp]	# tmp120, a
	movapd	xmm2, xmm0	#, tmp119
	pxor	xmm1, xmm1	#
	movq	xmm0, rax	#, tmp120
	call	clamp	#
	movq	rax, xmm0	# _17,
	movq	xmm0, rax	#, _17
	call	sqrt@PLT	#
	movq	rax, xmm0	# _18,
	movq	xmm0, rax	#, _18
	call	asin@PLT	#
# support/geolab/geo.c:25:     *out = 2.0 * asin(sqrt(clamp(a, 0.0, 1.0))) * GEO_EARTH_RADIUS_KM;
	.loc 1 25 16
	movapd	xmm1, xmm0	# _19, _19
	addsd	xmm1, xmm0	# _19, _19
# support/geolab/geo.c:25:     *out = 2.0 * asin(sqrt(clamp(a, 0.0, 1.0))) * GEO_EARTH_RADIUS_KM;
	.loc 1 25 49
	movsd	xmm0, QWORD PTR .LC10[rip]	# tmp121,
	mulsd	xmm0, xmm1	# _21, _20
# support/geolab/geo.c:25:     *out = 2.0 * asin(sqrt(clamp(a, 0.0, 1.0))) * GEO_EARTH_RADIUS_KM;
	.loc 1 25 10
	mov	rax, QWORD PTR -72[rbp]	# tmp122, out
	movsd	QWORD PTR [rax], xmm0	# *out_25(D), _21
# support/geolab/geo.c:26:     return 1;
	.loc 1 26 12
	mov	eax, 1	# _22,
.L30:
# support/geolab/geo.c:27: }
	.loc 1 27 1
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE4:
	.size	geo_distance_km, .-geo_distance_km
	.section	.rodata
	.align 8
.LC0:
	.long	-1571644103
	.long	1066524486
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
	.align 8
.LC3:
	.long	0
	.long	-1068072960
	.align 8
.LC4:
	.long	0
	.long	1079410688
	.align 8
.LC5:
	.long	0
	.long	-1067024384
	.align 8
.LC6:
	.long	0
	.long	1080459264
	.align 8
.LC7:
	.long	0
	.long	1073741824
	.align 8
.LC8:
	.long	0
	.long	1072693248
	.align 8
.LC10:
	.long	1085767732
	.long	1085858562
	.text
.Letext0:
	.file 2 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x23a
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF25
	.byte	0xc
	.long	.LASF26
	.long	.LASF27
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.long	.LASF0
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.long	.LASF1
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF2
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF3
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF4
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.long	.LASF5
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF6
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF7
	.uleb128 0x2
	.byte	0x4
	.byte	0x4
	.long	.LASF8
	.uleb128 0x2
	.byte	0x8
	.byte	0x4
	.long	.LASF9
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF10
	.uleb128 0x2
	.byte	0x10
	.byte	0x4
	.long	.LASF11
	.uleb128 0x4
	.long	.LASF12
	.byte	0x2
	.byte	0x37
	.byte	0x1
	.long	0x73
	.long	0x9e
	.uleb128 0x5
	.long	0x73
	.byte	0
	.uleb128 0x4
	.long	.LASF13
	.byte	0x2
	.byte	0x8f
	.byte	0x1
	.long	0x73
	.long	0xb4
	.uleb128 0x5
	.long	0x73
	.byte	0
	.uleb128 0x6
	.string	"cos"
	.byte	0x2
	.byte	0x3e
	.byte	0x1
	.long	0x73
	.long	0xca
	.uleb128 0x5
	.long	0x73
	.byte	0
	.uleb128 0x6
	.string	"sin"
	.byte	0x2
	.byte	0x40
	.byte	0x1
	.long	0x73
	.long	0xe0
	.uleb128 0x5
	.long	0x73
	.byte	0
	.uleb128 0x7
	.long	.LASF20
	.byte	0x1
	.byte	0x13
	.byte	0x5
	.long	0x57
	.quad	.LFB4
	.quad	.LFE4-.LFB4
	.uleb128 0x1
	.byte	0x9c
	.long	0x17c
	.uleb128 0x8
	.long	.LASF14
	.byte	0x1
	.byte	0x13
	.byte	0x1c
	.long	0x73
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x8
	.long	.LASF15
	.byte	0x1
	.byte	0x13
	.byte	0x29
	.long	0x73
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x8
	.long	.LASF16
	.byte	0x1
	.byte	0x13
	.byte	0x36
	.long	0x73
	.uleb128 0x3
	.byte	0x91
	.sleb128 -72
	.uleb128 0x8
	.long	.LASF17
	.byte	0x1
	.byte	0x13
	.byte	0x43
	.long	0x73
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.uleb128 0x9
	.string	"out"
	.byte	0x1
	.byte	0x13
	.byte	0x51
	.long	0x17c
	.uleb128 0x3
	.byte	0x91
	.sleb128 -88
	.uleb128 0xa
	.long	.LASF18
	.byte	0x1
	.byte	0x16
	.byte	0xc
	.long	0x73
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0xa
	.long	.LASF19
	.byte	0x1
	.byte	0x17
	.byte	0xc
	.long	0x73
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0xb
	.string	"a"
	.byte	0x1
	.byte	0x18
	.byte	0xc
	.long	0x73
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0xc
	.byte	0x8
	.long	0x73
	.uleb128 0xd
	.long	.LASF21
	.byte	0x1
	.byte	0xb
	.byte	0x5
	.long	0x57
	.quad	.LFB3
	.quad	.LFE3-.LFB3
	.uleb128 0x1
	.byte	0x9c
	.long	0x1c3
	.uleb128 0x8
	.long	.LASF22
	.byte	0x1
	.byte	0xb
	.byte	0x1f
	.long	0x73
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x8
	.long	.LASF23
	.byte	0x1
	.byte	0xb
	.byte	0x2f
	.long	0x73
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.byte	0
	.uleb128 0xe
	.long	.LASF28
	.byte	0x1
	.byte	0x9
	.byte	0xf
	.long	0x73
	.quad	.LFB2
	.quad	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.long	0x20f
	.uleb128 0x9
	.string	"x"
	.byte	0x1
	.byte	0x9
	.byte	0x1c
	.long	0x73
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0x9
	.string	"lo"
	.byte	0x1
	.byte	0x9
	.byte	0x26
	.long	0x73
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x9
	.string	"hi"
	.byte	0x1
	.byte	0x9
	.byte	0x31
	.long	0x73
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.byte	0
	.uleb128 0xf
	.long	.LASF29
	.byte	0x1
	.byte	0x7
	.byte	0xf
	.long	0x73
	.quad	.LFB1
	.quad	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x8
	.long	.LASF24
	.byte	0x1
	.byte	0x7
	.byte	0x21
	.long	0x73
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
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
	.uleb128 0x5
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
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
	.uleb128 0x7
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
	.uleb128 0x8
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
	.uleb128 0x9
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
	.uleb128 0xa
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
	.uleb128 0xb
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
	.uleb128 0xc
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
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
	.uleb128 0xe
	.uleb128 0x2e
	.byte	0x1
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
	.uleb128 0xf
	.uleb128 0x2e
	.byte	0x1
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
.LASF29:
	.string	"deg_to_rad"
.LASF12:
	.string	"asin"
.LASF8:
	.string	"float"
.LASF15:
	.string	"lon1"
.LASF17:
	.string	"lon2"
.LASF0:
	.string	"unsigned char"
.LASF21:
	.string	"geo_valid_position"
.LASF3:
	.string	"long unsigned int"
.LASF1:
	.string	"short unsigned int"
.LASF25:
	.string	"GNU C11 11.4.0 -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O0 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection"
.LASF24:
	.string	"degrees"
.LASF9:
	.string	"double"
.LASF5:
	.string	"short int"
.LASF19:
	.string	"sd_lon"
.LASF27:
	.string	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11"
.LASF18:
	.string	"sd_lat"
.LASF2:
	.string	"unsigned int"
.LASF14:
	.string	"lat1"
.LASF22:
	.string	"lat_deg"
.LASF10:
	.string	"long long int"
.LASF7:
	.string	"char"
.LASF20:
	.string	"geo_distance_km"
.LASF23:
	.string	"lon_deg"
.LASF6:
	.string	"long int"
.LASF11:
	.string	"long double"
.LASF4:
	.string	"signed char"
.LASF26:
	.string	"support/geolab/geo.c"
.LASF16:
	.string	"lat2"
.LASF13:
	.string	"sqrt"
.LASF28:
	.string	"clamp"
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
