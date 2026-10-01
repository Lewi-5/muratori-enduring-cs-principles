	.file	"geo.c"
	.intel_syntax noprefix
# GNU C11 (Ubuntu 11.4.0-1ubuntu1~22.04.3) version 11.4.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O2 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
.Ltext0:
	.p2align 4
	.globl	geo_valid_position
	.type	geo_valid_position, @function
geo_valid_position:
.LVL0:
.LFB15:
	.file 1 "support/geolab/geo.c"
	.loc 1 12 1 view -0
	.cfi_startproc
	.loc 1 12 1 is_stmt 0 view .LVU1
	endbr64	
	.loc 1 13 5 is_stmt 1 view .LVU2
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 12 is_stmt 0 view .LVU3
	movq	xmm2, QWORD PTR .LC0[rip]	# tmp89,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 111 view .LVU4
	movsd	xmm3, QWORD PTR .LC1[rip]	# tmp90,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 12 view .LVU5
	movapd	xmm4, xmm0	# tmp88, lat_deg
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 111 view .LVU6
	xor	eax, eax	# <retval>
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 12 view .LVU7
	andpd	xmm4, xmm2	# tmp88, tmp89
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 111 view .LVU8
	ucomisd	xmm3, xmm4	# tmp90, tmp88
	jb	.L1	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 33 discriminator 1 view .LVU9
	andpd	xmm2, xmm1	# tmp91, lon_deg
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 30 discriminator 1 view .LVU10
	ucomisd	xmm3, xmm2	# tmp90, tmp91
	jb	.L1	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 51 discriminator 3 view .LVU11
	comisd	xmm0, QWORD PTR .LC2[rip]	# lat_deg,
	jb	.L1	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 71 discriminator 5 view .LVU12
	movsd	xmm2, QWORD PTR .LC3[rip]	# tmp95,
	comisd	xmm2, xmm0	# tmp95, lat_deg
	jb	.L1	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 90 discriminator 7 view .LVU13
	comisd	xmm1, QWORD PTR .LC4[rip]	# lon_deg,
	jb	.L1	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 111 discriminator 9 view .LVU14
	movsd	xmm0, QWORD PTR .LC5[rip]	# tmp100,
.LVL1:
	.loc 1 13 111 discriminator 9 view .LVU15
	xor	eax, eax	# <retval>
	comisd	xmm0, xmm1	# tmp100, lon_deg
	setnb	al	#, <retval>
.L1:
# support/geolab/geo.c:15: }
	.loc 1 15 1 view .LVU16
	ret	
	.cfi_endproc
.LFE15:
	.size	geo_valid_position, .-geo_valid_position
	.p2align 4
	.globl	geo_distance_km
	.type	geo_distance_km, @function
geo_distance_km:
.LVL2:
.LFB16:
	.loc 1 20 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 20 1 is_stmt 0 view .LVU18
	endbr64	
	.loc 1 21 5 is_stmt 1 view .LVU19
# support/geolab/geo.c:21:     if (out == NULL || !geo_valid_position(lat1, lon1) || !geo_valid_position(lat2, lon2)) return 0;
	.loc 1 21 8 is_stmt 0 view .LVU20
	test	rdi, rdi	# out
	je	.L30	#,
.LBB26:
.LBB27:
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 12 view .LVU21
	movq	xmm4, QWORD PTR .LC0[rip]	# tmp114,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 111 view .LVU22
	movsd	xmm5, QWORD PTR .LC1[rip]	# tmp115,
	movapd	xmm6, xmm0	# lat1, tmp161
.LVL3:
	.loc 1 13 111 view .LVU23
.LBE27:
.LBI26:
	.loc 1 11 5 is_stmt 1 view .LVU24
.LBB28:
	.loc 1 13 5 view .LVU25
.LBE28:
.LBE26:
# support/geolab/geo.c:21:     if (out == NULL || !geo_valid_position(lat1, lon1) || !geo_valid_position(lat2, lon2)) return 0;
	.loc 1 21 99 is_stmt 0 view .LVU26
	xor	eax, eax	# <retval>
.LBB32:
.LBB29:
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 12 view .LVU27
	andpd	xmm0, xmm4	# tmp113, tmp114
.LVL4:
	.loc 1 13 12 view .LVU28
.LBE29:
.LBE32:
# support/geolab/geo.c:21:     if (out == NULL || !geo_valid_position(lat1, lon1) || !geo_valid_position(lat2, lon2)) return 0;
	.loc 1 21 99 view .LVU29
	ucomisd	xmm5, xmm0	# tmp115, tmp113
.LBB33:
.LBB30:
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 111 view .LVU30
	jb	.L59	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 33 view .LVU31
	movapd	xmm0, xmm1	# tmp116, lon1
	andpd	xmm0, xmm4	# tmp116, tmp114
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 30 view .LVU32
	ucomisd	xmm5, xmm0	# tmp115, tmp116
	jb	.L59	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 51 view .LVU33
	movsd	xmm7, QWORD PTR .LC2[rip]	# tmp119,
	comisd	xmm6, xmm7	# lat1, tmp119
	jb	.L59	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 71 view .LVU34
	movsd	xmm8, QWORD PTR .LC3[rip]	# tmp158,
	comisd	xmm8, xmm6	# tmp158, lat1
	jb	.L59	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 90 view .LVU35
	movsd	xmm9, QWORD PTR .LC4[rip]	# tmp159,
	comisd	xmm1, xmm9	# lon1, tmp159
	jb	.L59	#,
.LBE30:
.LBE33:
# support/geolab/geo.c:20: {
	.loc 1 20 1 view .LVU36
	push	rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	sub	rsp, 48	#,
	.cfi_def_cfa_offset 64
.LBB34:
.LBB31:
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 111 view .LVU37
	movsd	xmm10, QWORD PTR .LC5[rip]	# tmp160,
	movsd	QWORD PTR 16[rsp], xmm1	# %sfp, lon1
	comisd	xmm10, xmm1	# tmp160, lon1
	jb	.L15	#,
.LVL5:
	.loc 1 13 111 view .LVU38
.LBE31:
.LBE34:
.LBB35:
.LBI35:
	.loc 1 11 5 is_stmt 1 view .LVU39
.LBB36:
	.loc 1 13 5 view .LVU40
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 12 is_stmt 0 view .LVU41
	movapd	xmm0, xmm2	# tmp123, lat2
	andpd	xmm0, xmm4	# tmp123, tmp114
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 111 view .LVU42
	ucomisd	xmm5, xmm0	# tmp115, tmp123
	jb	.L15	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 33 view .LVU43
	andpd	xmm4, xmm3	# tmp126, lon2
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 30 view .LVU44
	ucomisd	xmm5, xmm4	# tmp115, tmp126
	jb	.L15	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 51 view .LVU45
	comisd	xmm2, xmm7	# lat2, tmp119
	jb	.L56	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 71 view .LVU46
	comisd	xmm8, xmm2	# tmp158, lat2
	jb	.L56	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 90 view .LVU47
	comisd	xmm3, xmm9	# lon2, tmp159
	jb	.L56	#,
# support/geolab/geo.c:13:     return isfinite(lat_deg) && isfinite(lon_deg) && lat_deg >= -90.0 && lat_deg <= 90.0 && lon_deg >= -180.0 &&
	.loc 1 13 111 view .LVU48
	comisd	xmm10, xmm3	# tmp160, lon2
	movsd	QWORD PTR 40[rsp], xmm3	# %sfp, lon2
	jb	.L56	#,
.LBE36:
.LBE35:
# support/geolab/geo.c:22:     double sd_lat = sin(deg_to_rad(lat2 - lat1) / 2.0);
	.loc 1 22 25 view .LVU49
	movapd	xmm4, xmm2	# tmp133, lat2
	mov	rbx, rdi	# out, tmp165
.LVL6:
	.loc 1 22 5 is_stmt 1 view .LVU50
.LBB37:
.LBI37:
	.loc 1 7 15 view .LVU51
.LBB38:
	.loc 1 7 44 view .LVU52
	.loc 1 7 44 is_stmt 0 view .LVU53
.LBE38:
.LBE37:
# support/geolab/geo.c:22:     double sd_lat = sin(deg_to_rad(lat2 - lat1) / 2.0);
	.loc 1 22 21 view .LVU54
	movsd	xmm0, QWORD PTR .LC9[rip]	# tmp136,
# support/geolab/geo.c:22:     double sd_lat = sin(deg_to_rad(lat2 - lat1) / 2.0);
	.loc 1 22 25 view .LVU55
	movsd	QWORD PTR 32[rsp], xmm2	# %sfp, lat2
	subsd	xmm4, xmm6	# tmp133, lat1
.LBB40:
.LBB39:
# support/geolab/geo.c:7: static double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }
	.loc 1 7 59 view .LVU56
	mulsd	xmm4, QWORD PTR .LC8[rip]	# tmp134,
.LBE39:
.LBE40:
# support/geolab/geo.c:22:     double sd_lat = sin(deg_to_rad(lat2 - lat1) / 2.0);
	.loc 1 22 25 view .LVU57
	movsd	QWORD PTR 8[rsp], xmm6	# %sfp, lat1
# support/geolab/geo.c:22:     double sd_lat = sin(deg_to_rad(lat2 - lat1) / 2.0);
	.loc 1 22 21 view .LVU58
	mulsd	xmm0, xmm4	# tmp136, tmp134
	call	sin@PLT	#
.LVL7:
# support/geolab/geo.c:23:     double sd_lon = sin(deg_to_rad(lon2 - lon1) / 2.0);
	.loc 1 23 25 view .LVU59
	movsd	xmm1, QWORD PTR 16[rsp]	# lon1, %sfp
	movsd	xmm3, QWORD PTR 40[rsp]	# lon2, %sfp
# support/geolab/geo.c:22:     double sd_lat = sin(deg_to_rad(lat2 - lat1) / 2.0);
	.loc 1 22 21 view .LVU60
	movsd	QWORD PTR 24[rsp], xmm0	# %sfp, sd_lat
.LVL8:
	.loc 1 23 5 is_stmt 1 view .LVU61
.LBB41:
.LBI41:
	.loc 1 7 15 view .LVU62
.LBB42:
	.loc 1 7 44 view .LVU63
# support/geolab/geo.c:7: static double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }
	.loc 1 7 59 is_stmt 0 view .LVU64
	movsd	xmm0, QWORD PTR .LC8[rip]	# tmp138,
.LVL9:
	.loc 1 7 59 view .LVU65
.LBE42:
.LBE41:
# support/geolab/geo.c:23:     double sd_lon = sin(deg_to_rad(lon2 - lon1) / 2.0);
	.loc 1 23 25 view .LVU66
	subsd	xmm3, xmm1	# lon2, lon1
.LBB44:
.LBB43:
# support/geolab/geo.c:7: static double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }
	.loc 1 7 59 view .LVU67
	mulsd	xmm0, xmm3	# tmp138, lon2
.LBE43:
.LBE44:
# support/geolab/geo.c:23:     double sd_lon = sin(deg_to_rad(lon2 - lon1) / 2.0);
	.loc 1 23 21 view .LVU68
	mulsd	xmm0, QWORD PTR .LC9[rip]	# tmp141,
	call	sin@PLT	#
.LVL10:
.LBB45:
.LBB46:
# support/geolab/geo.c:7: static double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }
	.loc 1 7 59 view .LVU69
	movsd	xmm6, QWORD PTR 8[rsp]	# lat1, %sfp
.LBE46:
.LBE45:
# support/geolab/geo.c:23:     double sd_lon = sin(deg_to_rad(lon2 - lon1) / 2.0);
	.loc 1 23 21 view .LVU70
	movsd	QWORD PTR 16[rsp], xmm0	# %sfp, sd_lon
.LVL11:
	.loc 1 24 5 is_stmt 1 view .LVU71
.LBB48:
.LBI45:
	.loc 1 7 15 view .LVU72
.LBB47:
	.loc 1 7 44 view .LVU73
# support/geolab/geo.c:7: static double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }
	.loc 1 7 59 is_stmt 0 view .LVU74
	movsd	xmm0, QWORD PTR .LC8[rip]	# tmp143,
.LVL12:
	.loc 1 7 59 view .LVU75
	mulsd	xmm0, xmm6	# tmp143, lat1
.LBE47:
.LBE48:
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 34 view .LVU76
	call	cos@PLT	#
.LVL13:
.LBB49:
.LBI49:
	.loc 1 7 15 is_stmt 1 view .LVU77
.LBB50:
	.loc 1 7 44 view .LVU78
# support/geolab/geo.c:7: static double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }
	.loc 1 7 59 is_stmt 0 view .LVU79
	movsd	xmm2, QWORD PTR 32[rsp]	# lat2, %sfp
	movsd	xmm7, QWORD PTR .LC8[rip]	# tmp145,
.LBE50:
.LBE49:
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 34 view .LVU80
	movsd	QWORD PTR 8[rsp], xmm0	# %sfp, tmp168
.LVL14:
.LBB52:
.LBB51:
# support/geolab/geo.c:7: static double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }
	.loc 1 7 59 view .LVU81
	mulsd	xmm7, xmm2	# tmp145, lat2
	movapd	xmm0, xmm7	# tmp145, tmp145
.LBE51:
.LBE52:
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 58 view .LVU82
	call	cos@PLT	#
.LVL15:
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 56 view .LVU83
	mulsd	xmm0, QWORD PTR 8[rsp]	# tmp147, %sfp
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 80 view .LVU84
	movsd	xmm1, QWORD PTR 16[rsp]	# sd_lon, %sfp
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 23 view .LVU85
	movsd	xmm4, QWORD PTR 24[rsp]	# sd_lat, %sfp
	mulsd	xmm4, xmm4	# tmp150, sd_lat
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 80 view .LVU86
	mulsd	xmm0, xmm1	# tmp148, sd_lon
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 89 view .LVU87
	mulsd	xmm0, xmm1	# tmp149, sd_lon
.LBB53:
.LBB54:
# support/geolab/geo.c:9: static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }
	.loc 1 9 74 view .LVU88
	pxor	xmm1, xmm1	# tmp151
.LBE54:
.LBE53:
# support/geolab/geo.c:24:     double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
	.loc 1 24 12 view .LVU89
	addsd	xmm0, xmm4	# a, tmp150
.LVL16:
	.loc 1 25 5 is_stmt 1 view .LVU90
.LBB57:
.LBI53:
	.loc 1 9 15 view .LVU91
.LBB55:
	.loc 1 9 55 view .LVU92
# support/geolab/geo.c:9: static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }
	.loc 1 9 74 is_stmt 0 view .LVU93
	comisd	xmm1, xmm0	# tmp151, a
	ja	.L43	#,
# support/geolab/geo.c:9: static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }
	.loc 1 9 89 view .LVU94
	comisd	xmm0, QWORD PTR .LC6[rip]	# a,
	ja	.L44	#,
.LVL17:
	.loc 1 9 89 view .LVU95
	ucomisd	xmm1, xmm0	# tmp151, a
	ja	.L57	#,
.LVL18:
.L29:
	.loc 1 9 89 view .LVU96
.LBE55:
.LBE57:
# support/geolab/geo.c:25:     *out = 2.0 * asin(sqrt(clamp(a, 0.0, 1.0))) * GEO_EARTH_RADIUS_KM;
	.loc 1 25 18 view .LVU97
	sqrtsd	xmm0, xmm0	# _1, a
.L28:
	call	asin@PLT	#
.LVL19:
# support/geolab/geo.c:26:     return 1;
	.loc 1 26 12 view .LVU98
	mov	eax, 1	# <retval>,
# support/geolab/geo.c:25:     *out = 2.0 * asin(sqrt(clamp(a, 0.0, 1.0))) * GEO_EARTH_RADIUS_KM;
	.loc 1 25 16 view .LVU99
	addsd	xmm0, xmm0	# tmp154, tmp171
# support/geolab/geo.c:25:     *out = 2.0 * asin(sqrt(clamp(a, 0.0, 1.0))) * GEO_EARTH_RADIUS_KM;
	.loc 1 25 49 view .LVU100
	mulsd	xmm0, QWORD PTR .LC10[rip]	# tmp155,
# support/geolab/geo.c:25:     *out = 2.0 * asin(sqrt(clamp(a, 0.0, 1.0))) * GEO_EARTH_RADIUS_KM;
	.loc 1 25 10 view .LVU101
	movsd	QWORD PTR [rbx], xmm0	# *out_19(D), tmp155
	.loc 1 26 5 is_stmt 1 view .LVU102
.LVL20:
.L15:
# support/geolab/geo.c:27: }
	.loc 1 27 1 is_stmt 0 view .LVU103
	add	rsp, 48	#,
	.cfi_def_cfa_offset 16
	pop	rbx	#
	.cfi_def_cfa_offset 8
	ret	
.LVL21:
	.p2align 4,,10
	.p2align 3
.L59:
	.cfi_restore 3
	.loc 1 27 1 view .LVU104
	ret	
.LVL22:
	.p2align 4,,10
	.p2align 3
.L30:
# support/geolab/geo.c:21:     if (out == NULL || !geo_valid_position(lat1, lon1) || !geo_valid_position(lat2, lon2)) return 0;
	.loc 1 21 99 view .LVU105
	xor	eax, eax	# <retval>
	ret	
.LVL23:
	.p2align 4,,10
	.p2align 3
.L56:
	.cfi_def_cfa_offset 64
	.cfi_offset 3, -16
# support/geolab/geo.c:27: }
	.loc 1 27 1 view .LVU106
	add	rsp, 48	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 16
# support/geolab/geo.c:21:     if (out == NULL || !geo_valid_position(lat1, lon1) || !geo_valid_position(lat2, lon2)) return 0;
	.loc 1 21 99 view .LVU107
	xor	eax, eax	# <retval>
.LVL24:
# support/geolab/geo.c:27: }
	.loc 1 27 1 view .LVU108
	pop	rbx	#
	.cfi_def_cfa_offset 8
	ret	
.LVL25:
	.p2align 4,,10
	.p2align 3
.L43:
	.cfi_restore_state
.LBB58:
.LBB56:
# support/geolab/geo.c:9: static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }
	.loc 1 9 74 view .LVU109
	movapd	xmm0, xmm1	# a, tmp151
.LVL26:
	.loc 1 9 74 view .LVU110
	jmp	.L29	#
.LVL27:
	.p2align 4,,10
	.p2align 3
.L44:
# support/geolab/geo.c:9: static double clamp(double x, double lo, double hi) { return x < lo ? lo : (x > hi ? hi : x); }
	.loc 1 9 89 view .LVU111
	mov	rax, QWORD PTR .LC6[rip]	# tmp182,
	movq	xmm0, rax	# a, tmp182
.LVL28:
	.loc 1 9 89 view .LVU112
	jmp	.L29	#
.LVL29:
.L57:
	.loc 1 9 89 view .LVU113
.LBE56:
.LBE58:
# support/geolab/geo.c:25:     *out = 2.0 * asin(sqrt(clamp(a, 0.0, 1.0))) * GEO_EARTH_RADIUS_KM;
	.loc 1 25 18 view .LVU114
	call	sqrt@PLT	#
.LVL30:
	.loc 1 25 18 view .LVU115
	jmp	.L28	#
	.cfi_endproc
.LFE16:
	.size	geo_distance_km, .-geo_distance_km
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC0:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	-1
	.long	2146435071
	.align 8
.LC2:
	.long	0
	.long	-1068072960
	.align 8
.LC3:
	.long	0
	.long	1079410688
	.align 8
.LC4:
	.long	0
	.long	-1067024384
	.align 8
.LC5:
	.long	0
	.long	1080459264
	.align 8
.LC6:
	.long	0
	.long	1072693248
	.align 8
.LC8:
	.long	-1571644103
	.long	1066524486
	.align 8
.LC9:
	.long	0
	.long	1071644672
	.align 8
.LC10:
	.long	1085767732
	.long	1085858562
	.text
.Letext0:
	.file 2 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x475
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF26
	.byte	0xc
	.long	.LASF27
	.long	.LASF28
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x2
	.byte	0x8
	.byte	0x4
	.long	.LASF0
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.long	.LASF1
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.long	.LASF2
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF3
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF4
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF5
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.long	.LASF6
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF7
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF8
	.uleb128 0x2
	.byte	0x4
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
	.long	0x2d
	.long	0x9e
	.uleb128 0x5
	.long	0x2d
	.byte	0
	.uleb128 0x4
	.long	.LASF13
	.byte	0x2
	.byte	0x8f
	.byte	0x1
	.long	0x2d
	.long	0xb4
	.uleb128 0x5
	.long	0x2d
	.byte	0
	.uleb128 0x6
	.string	"cos"
	.byte	0x2
	.byte	0x3e
	.byte	0x1
	.long	0x2d
	.long	0xca
	.uleb128 0x5
	.long	0x2d
	.byte	0
	.uleb128 0x6
	.string	"sin"
	.byte	0x2
	.byte	0x40
	.byte	0x1
	.long	0x2d
	.long	0xe0
	.uleb128 0x5
	.long	0x2d
	.byte	0
	.uleb128 0x7
	.long	.LASF29
	.byte	0x1
	.byte	0x13
	.byte	0x5
	.long	0x5e
	.quad	.LFB16
	.quad	.LFE16-.LFB16
	.uleb128 0x1
	.byte	0x9c
	.long	0x3cc
	.uleb128 0x8
	.long	.LASF14
	.byte	0x1
	.byte	0x13
	.byte	0x1c
	.long	0x2d
	.long	.LLST1
	.long	.LVUS1
	.uleb128 0x8
	.long	.LASF15
	.byte	0x1
	.byte	0x13
	.byte	0x29
	.long	0x2d
	.long	.LLST2
	.long	.LVUS2
	.uleb128 0x8
	.long	.LASF16
	.byte	0x1
	.byte	0x13
	.byte	0x36
	.long	0x2d
	.long	.LLST3
	.long	.LVUS3
	.uleb128 0x8
	.long	.LASF17
	.byte	0x1
	.byte	0x13
	.byte	0x43
	.long	0x2d
	.long	.LLST4
	.long	.LVUS4
	.uleb128 0x9
	.string	"out"
	.byte	0x1
	.byte	0x13
	.byte	0x51
	.long	0x3cc
	.long	.LLST5
	.long	.LVUS5
	.uleb128 0xa
	.long	.LASF18
	.byte	0x1
	.byte	0x16
	.byte	0xc
	.long	0x2d
	.long	.LLST6
	.long	.LVUS6
	.uleb128 0xa
	.long	.LASF19
	.byte	0x1
	.byte	0x17
	.byte	0xc
	.long	0x2d
	.long	.LLST7
	.long	.LVUS7
	.uleb128 0xb
	.string	"a"
	.byte	0x1
	.byte	0x18
	.byte	0xc
	.long	0x2d
	.long	.LLST8
	.long	.LVUS8
	.uleb128 0xc
	.long	0x3d2
	.quad	.LBI26
	.byte	.LVU24
	.long	.Ldebug_ranges0+0
	.byte	0x1
	.byte	0x15
	.byte	0x19
	.long	0x1d4
	.uleb128 0xd
	.long	0x3ef
	.long	.LLST9
	.long	.LVUS9
	.uleb128 0xd
	.long	0x3e3
	.long	.LLST10
	.long	.LVUS10
	.byte	0
	.uleb128 0xe
	.long	0x3d2
	.quad	.LBI35
	.byte	.LVU39
	.quad	.LBB35
	.quad	.LBE35-.LBB35
	.byte	0x1
	.byte	0x15
	.byte	0x3c
	.long	0x214
	.uleb128 0xd
	.long	0x3ef
	.long	.LLST11
	.long	.LVUS11
	.uleb128 0xd
	.long	0x3e3
	.long	.LLST12
	.long	.LVUS12
	.byte	0
	.uleb128 0xc
	.long	0x42e
	.quad	.LBI37
	.byte	.LVU51
	.long	.Ldebug_ranges0+0x50
	.byte	0x1
	.byte	0x16
	.byte	0x19
	.long	0x23b
	.uleb128 0xd
	.long	0x43f
	.long	.LLST13
	.long	.LVUS13
	.byte	0
	.uleb128 0xc
	.long	0x42e
	.quad	.LBI41
	.byte	.LVU62
	.long	.Ldebug_ranges0+0x80
	.byte	0x1
	.byte	0x17
	.byte	0x19
	.long	0x262
	.uleb128 0xd
	.long	0x43f
	.long	.LLST14
	.long	.LVUS14
	.byte	0
	.uleb128 0xc
	.long	0x42e
	.quad	.LBI45
	.byte	.LVU72
	.long	.Ldebug_ranges0+0xb0
	.byte	0x1
	.byte	0x18
	.byte	0x22
	.long	0x289
	.uleb128 0xd
	.long	0x43f
	.long	.LLST15
	.long	.LVUS15
	.byte	0
	.uleb128 0xc
	.long	0x42e
	.quad	.LBI49
	.byte	.LVU77
	.long	.Ldebug_ranges0+0xe0
	.byte	0x1
	.byte	0x18
	.byte	0x3a
	.long	0x2b0
	.uleb128 0xd
	.long	0x43f
	.long	.LLST16
	.long	.LVUS16
	.byte	0
	.uleb128 0xc
	.long	0x3fc
	.quad	.LBI53
	.byte	.LVU91
	.long	.Ldebug_ranges0+0x110
	.byte	0x1
	.byte	0x19
	.byte	0x12
	.long	0x2f1
	.uleb128 0xd
	.long	0x422
	.long	.LLST17
	.long	.LVUS17
	.uleb128 0xd
	.long	0x417
	.long	.LLST18
	.long	.LVUS18
	.uleb128 0xd
	.long	0x40d
	.long	.LLST19
	.long	.LVUS19
	.byte	0
	.uleb128 0xf
	.quad	.LVL7
	.long	0xca
	.long	0x32a
	.uleb128 0x10
	.uleb128 0x1
	.byte	0x61
	.uleb128 0x23
	.byte	0x91
	.sleb128 -32
	.byte	0xf6
	.byte	0x8
	.uleb128 0x2d
	.byte	0x91
	.sleb128 -56
	.byte	0xf6
	.byte	0x8
	.uleb128 0x2d
	.byte	0x1c
	.byte	0xf4
	.uleb128 0x2d
	.byte	0x8
	.long	0xa2529d39
	.long	0x3f91df46
	.byte	0x1e
	.byte	0xf4
	.uleb128 0x2d
	.byte	0x8
	.long	0
	.long	0x3fe00000
	.byte	0x1e
	.byte	0
	.uleb128 0xf
	.quad	.LVL10
	.long	0xca
	.long	0x363
	.uleb128 0x10
	.uleb128 0x1
	.byte	0x61
	.uleb128 0x23
	.byte	0x91
	.sleb128 -24
	.byte	0xf6
	.byte	0x8
	.uleb128 0x2d
	.byte	0x91
	.sleb128 -48
	.byte	0xf6
	.byte	0x8
	.uleb128 0x2d
	.byte	0x1c
	.byte	0xf4
	.uleb128 0x2d
	.byte	0x8
	.long	0xa2529d39
	.long	0x3f91df46
	.byte	0x1e
	.byte	0xf4
	.uleb128 0x2d
	.byte	0x8
	.long	0
	.long	0x3fe00000
	.byte	0x1e
	.byte	0
	.uleb128 0xf
	.quad	.LVL13
	.long	0xb4
	.long	0x38a
	.uleb128 0x10
	.uleb128 0x1
	.byte	0x61
	.uleb128 0x11
	.byte	0x91
	.sleb128 -56
	.byte	0xf6
	.byte	0x8
	.uleb128 0x2d
	.byte	0xf4
	.uleb128 0x2d
	.byte	0x8
	.long	0xa2529d39
	.long	0x3f91df46
	.byte	0x1e
	.byte	0
	.uleb128 0xf
	.quad	.LVL15
	.long	0xb4
	.long	0x3b1
	.uleb128 0x10
	.uleb128 0x1
	.byte	0x61
	.uleb128 0x11
	.byte	0x91
	.sleb128 -32
	.byte	0xf6
	.byte	0x8
	.uleb128 0x2d
	.byte	0xf4
	.uleb128 0x2d
	.byte	0x8
	.long	0xa2529d39
	.long	0x3f91df46
	.byte	0x1e
	.byte	0
	.uleb128 0x11
	.quad	.LVL19
	.long	0x88
	.uleb128 0x11
	.quad	.LVL30
	.long	0x9e
	.byte	0
	.uleb128 0x12
	.byte	0x8
	.long	0x2d
	.uleb128 0x13
	.long	.LASF20
	.byte	0x1
	.byte	0xb
	.byte	0x5
	.long	0x5e
	.byte	0x1
	.long	0x3fc
	.uleb128 0x14
	.long	.LASF21
	.byte	0x1
	.byte	0xb
	.byte	0x1f
	.long	0x2d
	.uleb128 0x14
	.long	.LASF22
	.byte	0x1
	.byte	0xb
	.byte	0x2f
	.long	0x2d
	.byte	0
	.uleb128 0x15
	.long	.LASF23
	.byte	0x1
	.byte	0x9
	.byte	0xf
	.long	0x2d
	.byte	0x1
	.long	0x42e
	.uleb128 0x16
	.string	"x"
	.byte	0x1
	.byte	0x9
	.byte	0x1c
	.long	0x2d
	.uleb128 0x16
	.string	"lo"
	.byte	0x1
	.byte	0x9
	.byte	0x26
	.long	0x2d
	.uleb128 0x16
	.string	"hi"
	.byte	0x1
	.byte	0x9
	.byte	0x31
	.long	0x2d
	.byte	0
	.uleb128 0x15
	.long	.LASF24
	.byte	0x1
	.byte	0x7
	.byte	0xf
	.long	0x2d
	.byte	0x1
	.long	0x44c
	.uleb128 0x14
	.long	.LASF25
	.byte	0x1
	.byte	0x7
	.byte	0x21
	.long	0x2d
	.byte	0
	.uleb128 0x17
	.long	0x3d2
	.quad	.LFB15
	.quad	.LFE15-.LFB15
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0xd
	.long	0x3e3
	.long	.LLST0
	.long	.LVUS0
	.uleb128 0x18
	.long	0x3ef
	.uleb128 0x1
	.byte	0x62
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
	.uleb128 0x2117
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
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
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x2138
	.uleb128 0xb
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x57
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x2138
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x58
	.uleb128 0xb
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x57
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
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
	.uleb128 0x10
	.uleb128 0x410a
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x2111
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x4109
	.byte	0
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
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
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
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
	.byte	0
	.byte	0
	.uleb128 0x15
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
	.uleb128 0x20
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
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
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x31
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
	.uleb128 0x18
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
.LVUS1:
	.uleb128 0
	.uleb128 .LVU28
	.uleb128 .LVU28
	.uleb128 .LVU59
	.uleb128 .LVU59
	.uleb128 .LVU81
	.uleb128 .LVU81
	.uleb128 .LVU104
	.uleb128 .LVU104
	.uleb128 .LVU105
	.uleb128 .LVU105
	.uleb128 .LVU106
	.uleb128 .LVU106
	.uleb128 .LVU109
	.uleb128 .LVU109
	.uleb128 0
.LLST1:
	.quad	.LVL2-.Ltext0
	.quad	.LVL4-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL4-.Ltext0
	.quad	.LVL7-1-.Ltext0
	.value	0x1
	.byte	0x67
	.quad	.LVL7-1-.Ltext0
	.quad	.LVL14-.Ltext0
	.value	0x2
	.byte	0x91
	.sleb128 -56
	.quad	.LVL14-.Ltext0
	.quad	.LVL21-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x11
	.uleb128 0x2d
	.byte	0x9f
	.quad	.LVL21-.Ltext0
	.quad	.LVL22-.Ltext0
	.value	0x1
	.byte	0x67
	.quad	.LVL22-.Ltext0
	.quad	.LVL23-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL23-.Ltext0
	.quad	.LVL25-.Ltext0
	.value	0x1
	.byte	0x67
	.quad	.LVL25-.Ltext0
	.quad	.LFE16-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x11
	.uleb128 0x2d
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS2:
	.uleb128 0
	.uleb128 .LVU59
	.uleb128 .LVU59
	.uleb128 .LVU71
	.uleb128 .LVU71
	.uleb128 .LVU104
	.uleb128 .LVU104
	.uleb128 .LVU109
	.uleb128 .LVU109
	.uleb128 0
.LLST2:
	.quad	.LVL2-.Ltext0
	.quad	.LVL7-1-.Ltext0
	.value	0x1
	.byte	0x62
	.quad	.LVL7-1-.Ltext0
	.quad	.LVL11-.Ltext0
	.value	0x2
	.byte	0x91
	.sleb128 -48
	.quad	.LVL11-.Ltext0
	.quad	.LVL21-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x12
	.uleb128 0x2d
	.byte	0x9f
	.quad	.LVL21-.Ltext0
	.quad	.LVL25-.Ltext0
	.value	0x1
	.byte	0x62
	.quad	.LVL25-.Ltext0
	.quad	.LFE16-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x12
	.uleb128 0x2d
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS3:
	.uleb128 0
	.uleb128 .LVU59
	.uleb128 .LVU59
	.uleb128 .LVU103
	.uleb128 .LVU103
	.uleb128 .LVU104
	.uleb128 .LVU104
	.uleb128 .LVU109
	.uleb128 .LVU109
	.uleb128 0
.LLST3:
	.quad	.LVL2-.Ltext0
	.quad	.LVL7-1-.Ltext0
	.value	0x1
	.byte	0x63
	.quad	.LVL7-1-.Ltext0
	.quad	.LVL20-.Ltext0
	.value	0x2
	.byte	0x91
	.sleb128 -32
	.quad	.LVL20-.Ltext0
	.quad	.LVL21-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x13
	.uleb128 0x2d
	.byte	0x9f
	.quad	.LVL21-.Ltext0
	.quad	.LVL25-.Ltext0
	.value	0x1
	.byte	0x63
	.quad	.LVL25-.Ltext0
	.quad	.LFE16-.Ltext0
	.value	0x2
	.byte	0x91
	.sleb128 -32
	.quad	0
	.quad	0
.LVUS4:
	.uleb128 0
	.uleb128 .LVU59
	.uleb128 .LVU59
	.uleb128 .LVU103
	.uleb128 .LVU103
	.uleb128 .LVU104
	.uleb128 .LVU104
	.uleb128 .LVU109
	.uleb128 .LVU109
	.uleb128 0
.LLST4:
	.quad	.LVL2-.Ltext0
	.quad	.LVL7-1-.Ltext0
	.value	0x1
	.byte	0x64
	.quad	.LVL7-1-.Ltext0
	.quad	.LVL20-.Ltext0
	.value	0x2
	.byte	0x91
	.sleb128 -24
	.quad	.LVL20-.Ltext0
	.quad	.LVL21-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x14
	.uleb128 0x2d
	.byte	0x9f
	.quad	.LVL21-.Ltext0
	.quad	.LVL25-.Ltext0
	.value	0x1
	.byte	0x64
	.quad	.LVL25-.Ltext0
	.quad	.LFE16-.Ltext0
	.value	0x2
	.byte	0x91
	.sleb128 -24
	.quad	0
	.quad	0
.LVUS5:
	.uleb128 0
	.uleb128 .LVU59
	.uleb128 .LVU59
	.uleb128 .LVU103
	.uleb128 .LVU103
	.uleb128 .LVU104
	.uleb128 .LVU104
	.uleb128 .LVU109
	.uleb128 .LVU109
	.uleb128 0
.LLST5:
	.quad	.LVL2-.Ltext0
	.quad	.LVL7-1-.Ltext0
	.value	0x1
	.byte	0x55
	.quad	.LVL7-1-.Ltext0
	.quad	.LVL20-.Ltext0
	.value	0x1
	.byte	0x53
	.quad	.LVL20-.Ltext0
	.quad	.LVL21-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x55
	.byte	0x9f
	.quad	.LVL21-.Ltext0
	.quad	.LVL25-.Ltext0
	.value	0x1
	.byte	0x55
	.quad	.LVL25-.Ltext0
	.quad	.LFE16-.Ltext0
	.value	0x1
	.byte	0x53
	.quad	0
	.quad	0
.LVUS6:
	.uleb128 .LVU61
	.uleb128 .LVU65
	.uleb128 .LVU65
	.uleb128 .LVU103
	.uleb128 .LVU109
	.uleb128 0
.LLST6:
	.quad	.LVL8-.Ltext0
	.quad	.LVL9-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL9-.Ltext0
	.quad	.LVL20-.Ltext0
	.value	0x2
	.byte	0x91
	.sleb128 -40
	.quad	.LVL25-.Ltext0
	.quad	.LFE16-.Ltext0
	.value	0x2
	.byte	0x91
	.sleb128 -40
	.quad	0
	.quad	0
.LVUS7:
	.uleb128 .LVU71
	.uleb128 .LVU75
	.uleb128 .LVU75
	.uleb128 .LVU103
	.uleb128 .LVU109
	.uleb128 0
.LLST7:
	.quad	.LVL11-.Ltext0
	.quad	.LVL12-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL12-.Ltext0
	.quad	.LVL20-.Ltext0
	.value	0x2
	.byte	0x91
	.sleb128 -48
	.quad	.LVL25-.Ltext0
	.quad	.LFE16-.Ltext0
	.value	0x2
	.byte	0x91
	.sleb128 -48
	.quad	0
	.quad	0
.LVUS8:
	.uleb128 .LVU90
	.uleb128 .LVU96
	.uleb128 .LVU109
	.uleb128 .LVU110
	.uleb128 .LVU111
	.uleb128 .LVU112
	.uleb128 .LVU113
	.uleb128 .LVU115
.LLST8:
	.quad	.LVL16-.Ltext0
	.quad	.LVL18-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL25-.Ltext0
	.quad	.LVL26-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL27-.Ltext0
	.quad	.LVL28-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL29-.Ltext0
	.quad	.LVL30-1-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	0
	.quad	0
.LVUS9:
	.uleb128 .LVU23
	.uleb128 .LVU38
	.uleb128 .LVU104
	.uleb128 .LVU105
.LLST9:
	.quad	.LVL3-.Ltext0
	.quad	.LVL5-.Ltext0
	.value	0x1
	.byte	0x62
	.quad	.LVL21-.Ltext0
	.quad	.LVL22-.Ltext0
	.value	0x1
	.byte	0x62
	.quad	0
	.quad	0
.LVUS10:
	.uleb128 .LVU23
	.uleb128 .LVU28
	.uleb128 .LVU28
	.uleb128 .LVU38
	.uleb128 .LVU104
	.uleb128 .LVU105
.LLST10:
	.quad	.LVL3-.Ltext0
	.quad	.LVL4-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL4-.Ltext0
	.quad	.LVL5-.Ltext0
	.value	0x1
	.byte	0x67
	.quad	.LVL21-.Ltext0
	.quad	.LVL22-.Ltext0
	.value	0x1
	.byte	0x67
	.quad	0
	.quad	0
.LVUS11:
	.uleb128 .LVU38
	.uleb128 .LVU50
	.uleb128 .LVU106
	.uleb128 .LVU108
.LLST11:
	.quad	.LVL5-.Ltext0
	.quad	.LVL6-.Ltext0
	.value	0x1
	.byte	0x64
	.quad	.LVL23-.Ltext0
	.quad	.LVL24-.Ltext0
	.value	0x1
	.byte	0x64
	.quad	0
	.quad	0
.LVUS12:
	.uleb128 .LVU38
	.uleb128 .LVU50
	.uleb128 .LVU106
	.uleb128 .LVU108
.LLST12:
	.quad	.LVL5-.Ltext0
	.quad	.LVL6-.Ltext0
	.value	0x1
	.byte	0x63
	.quad	.LVL23-.Ltext0
	.quad	.LVL24-.Ltext0
	.value	0x1
	.byte	0x63
	.quad	0
	.quad	0
.LVUS13:
	.uleb128 .LVU51
	.uleb128 .LVU53
.LLST13:
	.quad	.LVL6-.Ltext0
	.quad	.LVL6-.Ltext0
	.value	0x8
	.byte	0xf5
	.uleb128 0x13
	.uleb128 0x2d
	.byte	0xf5
	.uleb128 0x17
	.uleb128 0x2d
	.byte	0x1c
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS14:
	.uleb128 .LVU62
	.uleb128 .LVU64
.LLST14:
	.quad	.LVL8-.Ltext0
	.quad	.LVL8-.Ltext0
	.value	0xc
	.byte	0x91
	.sleb128 -24
	.byte	0xf6
	.byte	0x8
	.uleb128 0x2d
	.byte	0x91
	.sleb128 -48
	.byte	0xf6
	.byte	0x8
	.uleb128 0x2d
	.byte	0x1c
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS15:
	.uleb128 .LVU72
	.uleb128 .LVU74
.LLST15:
	.quad	.LVL11-.Ltext0
	.quad	.LVL11-.Ltext0
	.value	0x2
	.byte	0x91
	.sleb128 -56
	.quad	0
	.quad	0
.LVUS16:
	.uleb128 .LVU77
	.uleb128 .LVU79
.LLST16:
	.quad	.LVL13-.Ltext0
	.quad	.LVL13-.Ltext0
	.value	0x2
	.byte	0x91
	.sleb128 -32
	.quad	0
	.quad	0
.LVUS17:
	.uleb128 .LVU91
	.uleb128 .LVU95
	.uleb128 .LVU109
	.uleb128 .LVU112
.LLST17:
	.quad	.LVL16-.Ltext0
	.quad	.LVL17-.Ltext0
	.value	0xa
	.byte	0x9e
	.uleb128 0x8
	.long	0
	.long	0x3ff00000
	.quad	.LVL25-.Ltext0
	.quad	.LVL28-.Ltext0
	.value	0xa
	.byte	0x9e
	.uleb128 0x8
	.long	0
	.long	0x3ff00000
	.quad	0
	.quad	0
.LVUS18:
	.uleb128 .LVU91
	.uleb128 .LVU95
	.uleb128 .LVU109
	.uleb128 .LVU112
.LLST18:
	.quad	.LVL16-.Ltext0
	.quad	.LVL17-.Ltext0
	.value	0xa
	.byte	0x9e
	.uleb128 0x8
	.long	0
	.long	0
	.quad	.LVL25-.Ltext0
	.quad	.LVL28-.Ltext0
	.value	0xa
	.byte	0x9e
	.uleb128 0x8
	.long	0
	.long	0
	.quad	0
	.quad	0
.LVUS19:
	.uleb128 .LVU91
	.uleb128 .LVU95
	.uleb128 .LVU109
	.uleb128 .LVU110
	.uleb128 .LVU111
	.uleb128 .LVU112
.LLST19:
	.quad	.LVL16-.Ltext0
	.quad	.LVL17-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL25-.Ltext0
	.quad	.LVL26-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL27-.Ltext0
	.quad	.LVL28-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	0
	.quad	0
.LVUS0:
	.uleb128 0
	.uleb128 .LVU15
	.uleb128 .LVU15
	.uleb128 0
.LLST0:
	.quad	.LVL0-.Ltext0
	.quad	.LVL1-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL1-.Ltext0
	.quad	.LFE15-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x11
	.uleb128 0x2d
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
	.quad	.LBB26-.Ltext0
	.quad	.LBE26-.Ltext0
	.quad	.LBB32-.Ltext0
	.quad	.LBE32-.Ltext0
	.quad	.LBB33-.Ltext0
	.quad	.LBE33-.Ltext0
	.quad	.LBB34-.Ltext0
	.quad	.LBE34-.Ltext0
	.quad	0
	.quad	0
	.quad	.LBB37-.Ltext0
	.quad	.LBE37-.Ltext0
	.quad	.LBB40-.Ltext0
	.quad	.LBE40-.Ltext0
	.quad	0
	.quad	0
	.quad	.LBB41-.Ltext0
	.quad	.LBE41-.Ltext0
	.quad	.LBB44-.Ltext0
	.quad	.LBE44-.Ltext0
	.quad	0
	.quad	0
	.quad	.LBB45-.Ltext0
	.quad	.LBE45-.Ltext0
	.quad	.LBB48-.Ltext0
	.quad	.LBE48-.Ltext0
	.quad	0
	.quad	0
	.quad	.LBB49-.Ltext0
	.quad	.LBE49-.Ltext0
	.quad	.LBB52-.Ltext0
	.quad	.LBE52-.Ltext0
	.quad	0
	.quad	0
	.quad	.LBB53-.Ltext0
	.quad	.LBE53-.Ltext0
	.quad	.LBB57-.Ltext0
	.quad	.LBE57-.Ltext0
	.quad	.LBB58-.Ltext0
	.quad	.LBE58-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF24:
	.string	"deg_to_rad"
.LASF12:
	.string	"asin"
.LASF9:
	.string	"float"
.LASF15:
	.string	"lon1"
.LASF17:
	.string	"lon2"
.LASF1:
	.string	"unsigned char"
.LASF20:
	.string	"geo_valid_position"
.LASF4:
	.string	"long unsigned int"
.LASF2:
	.string	"short unsigned int"
.LASF25:
	.string	"degrees"
.LASF0:
	.string	"double"
.LASF26:
	.string	"GNU C11 11.4.0 -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O2 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection"
.LASF6:
	.string	"short int"
.LASF19:
	.string	"sd_lon"
.LASF28:
	.string	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11"
.LASF18:
	.string	"sd_lat"
.LASF3:
	.string	"unsigned int"
.LASF14:
	.string	"lat1"
.LASF21:
	.string	"lat_deg"
.LASF10:
	.string	"long long int"
.LASF8:
	.string	"char"
.LASF29:
	.string	"geo_distance_km"
.LASF22:
	.string	"lon_deg"
.LASF7:
	.string	"long int"
.LASF11:
	.string	"long double"
.LASF5:
	.string	"signed char"
.LASF27:
	.string	"support/geolab/geo.c"
.LASF16:
	.string	"lat2"
.LASF13:
	.string	"sqrt"
.LASF23:
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
