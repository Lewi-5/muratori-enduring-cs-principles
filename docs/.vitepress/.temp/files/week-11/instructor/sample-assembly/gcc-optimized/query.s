	.file	"query.c"
	.intel_syntax noprefix
# GNU C11 (Ubuntu 11.4.0-1ubuntu1~22.04.3) version 11.4.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O2 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
.Ltext0:
	.p2align 4
	.globl	query_hit_compare
	.type	query_hit_compare, @function
query_hit_compare:
.LVL0:
.LFB23:
	.file 1 "support/geolab/query.c"
	.loc 1 12 1 view -0
	.cfi_startproc
	.loc 1 12 1 is_stmt 0 view .LVU1
	endbr64	
	.loc 1 13 5 is_stmt 1 view .LVU2
.LVL1:
	.loc 1 14 5 view .LVU3
# support/geolab/query.c:14:     if (x->distance_km < y->distance_km) return -1;
	.loc 1 14 10 is_stmt 0 view .LVU4
	movsd	xmm1, QWORD PTR 8[rdi]	# _1, MEM[(const struct QueryHit *)a_5(D)].distance_km
# support/geolab/query.c:14:     if (x->distance_km < y->distance_km) return -1;
	.loc 1 14 27 view .LVU5
	movsd	xmm0, QWORD PTR 8[rsi]	# _2, MEM[(const struct QueryHit *)b_6(D)].distance_km
# support/geolab/query.c:14:     if (x->distance_km < y->distance_km) return -1;
	.loc 1 14 49 view .LVU6
	mov	eax, -1	# <retval>,
# support/geolab/query.c:14:     if (x->distance_km < y->distance_km) return -1;
	.loc 1 14 8 view .LVU7
	comisd	xmm0, xmm1	# _2, _1
	ja	.L1	#,
	.loc 1 15 5 is_stmt 1 view .LVU8
# support/geolab/query.c:15:     if (x->distance_km > y->distance_km) return 1;
	.loc 1 15 8 is_stmt 0 view .LVU9
	comisd	xmm1, xmm0	# _1, _2
# support/geolab/query.c:15:     if (x->distance_km > y->distance_km) return 1;
	.loc 1 15 49 view .LVU10
	mov	eax, 1	# <retval>,
# support/geolab/query.c:15:     if (x->distance_km > y->distance_km) return 1;
	.loc 1 15 8 view .LVU11
	ja	.L1	#,
.LVL2:
.LBB4:
.LBI4:
	.loc 1 11 5 is_stmt 1 view .LVU12
.LBB5:
	.loc 1 16 5 view .LVU13
# support/geolab/query.c:16:     if (x->id < y->id) return -1;
	.loc 1 16 8 is_stmt 0 view .LVU14
	mov	rax, QWORD PTR [rsi]	# tmp98, MEM[(const struct QueryHit *)b_6(D)].id
	cmp	QWORD PTR [rdi], rax	# MEM[(const struct QueryHit *)a_5(D)].id, tmp98
# support/geolab/query.c:17:     if (x->id > y->id) return 1;
	.loc 1 17 8 view .LVU15
	mov	edx, -1	# tmp93,
	seta	al	#, tmp94
	movzx	eax, al	# tmp94, tmp94
	cmovb	eax, edx	# tmp94,, <retval>, tmp93
.LVL3:
.L1:
	.loc 1 17 8 view .LVU16
.LBE5:
.LBE4:
# support/geolab/query.c:19: }
	.loc 1 19 1 view .LVU17
	ret	
	.cfi_endproc
.LFE23:
	.size	query_hit_compare, .-query_hit_compare
	.p2align 4
	.globl	query_points
	.type	query_points, @function
query_points:
.LVL4:
.LFB24:
	.loc 1 23 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 23 1 is_stmt 0 view .LVU19
	endbr64	
	push	r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	push	r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 88	#,
	.cfi_def_cfa_offset 144
# support/geolab/query.c:23: {
	.loc 1 23 1 view .LVU20
	movsd	QWORD PTR 8[rsp], xmm0	# %sfp, tmp157
	movsd	QWORD PTR 16[rsp], xmm1	# %sfp, tmp158
	movsd	QWORD PTR 24[rsp], xmm2	# %sfp, tmp159
	mov	rax, QWORD PTR fs:40	# tmp167, MEM[(<address-space-1> long unsigned int *)40B]
	mov	QWORD PTR 72[rsp], rax	# D.3517, tmp167
	xor	eax, eax	# tmp167
	.loc 1 25 5 is_stmt 1 view .LVU21
# support/geolab/query.c:25:     if (hits == NULL || nhits == NULL || (points == NULL && count > 0)) return 0;
	.loc 1 25 8 is_stmt 0 view .LVU22
	test	rdx, rdx	# hits
	je	.L50	#,
	mov	rbp, rcx	# nhits, tmp161
	test	rcx, rcx	# nhits
	je	.L50	#,
	mov	r12, rdi	# points, tmp155
	mov	r14, rsi	# count, tmp156
	mov	rbx, rdx	# hits, tmp160
# support/geolab/query.c:25:     if (hits == NULL || nhits == NULL || (points == NULL && count > 0)) return 0;
	.loc 1 25 39 discriminator 2 view .LVU23
	test	rdi, rdi	# points
	jne	.L29	#,
	test	rsi, rsi	# count
	je	.L29	#,
.LVL5:
.L50:
.LBB6:
	.loc 1 61 13 is_stmt 1 view .LVU24
# support/geolab/query.c:61:             return 0;
	.loc 1 61 20 is_stmt 0 view .LVU25
	xor	eax, eax	# <retval>
.LVL6:
.L7:
	.loc 1 61 20 view .LVU26
.LBE6:
# support/geolab/query.c:79: }
	.loc 1 79 1 view .LVU27
	mov	rdx, QWORD PTR 72[rsp]	# tmp169, D.3517
	sub	rdx, QWORD PTR fs:40	# tmp169, MEM[(<address-space-1> long unsigned int *)40B]
	jne	.L52	#,
	add	rsp, 88	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	pop	rbx	#
	.cfi_def_cfa_offset 48
	pop	rbp	#
	.cfi_def_cfa_offset 40
	pop	r12	#
	.cfi_def_cfa_offset 32
	pop	r13	#
	.cfi_def_cfa_offset 24
	pop	r14	#
	.cfi_def_cfa_offset 16
	pop	r15	#
	.cfi_def_cfa_offset 8
	ret	
.LVL7:
	.p2align 4,,10
	.p2align 3
.L29:
	.cfi_restore_state
	.loc 1 26 5 is_stmt 1 view .LVU28
# support/geolab/query.c:26:     if (!geo_valid_position(lat, lon)) return 0;
	.loc 1 26 10 is_stmt 0 view .LVU29
	movsd	xmm1, QWORD PTR 16[rsp]	#, %sfp
.LVL8:
	.loc 1 26 10 view .LVU30
	movsd	xmm0, QWORD PTR 8[rsp]	#, %sfp
.LVL9:
	.loc 1 26 10 view .LVU31
	call	geo_valid_position@PLT	#
.LVL10:
# support/geolab/query.c:26:     if (!geo_valid_position(lat, lon)) return 0;
	.loc 1 26 8 view .LVU32
	test	eax, eax	# tmp162
	je	.L50	#,
	.loc 1 27 5 is_stmt 1 view .LVU33
# support/geolab/query.c:27:     if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > GEOLAB_MAX_RADIUS_KM) return 0;
	.loc 1 27 10 is_stmt 0 view .LVU34
	movsd	xmm4, QWORD PTR 24[rsp]	# radius_km, %sfp
# support/geolab/query.c:27:     if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > GEOLAB_MAX_RADIUS_KM) return 0;
	.loc 1 27 8 view .LVU35
	movsd	xmm1, QWORD PTR .LC1[rip]	# tmp138,
# support/geolab/query.c:27:     if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > GEOLAB_MAX_RADIUS_KM) return 0;
	.loc 1 27 10 view .LVU36
	movapd	xmm0, xmm4	# tmp136, radius_km
	andpd	xmm0, XMMWORD PTR .LC0[rip]	# tmp136,
# support/geolab/query.c:27:     if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > GEOLAB_MAX_RADIUS_KM) return 0;
	.loc 1 27 8 view .LVU37
	ucomisd	xmm1, xmm0	# tmp138, tmp136
	jb	.L50	#,
# support/geolab/query.c:27:     if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > GEOLAB_MAX_RADIUS_KM) return 0;
	.loc 1 27 30 discriminator 2 view .LVU38
	pxor	xmm0, xmm0	# tmp139
	comisd	xmm0, xmm4	# tmp139, radius_km
	ja	.L50	#,
# support/geolab/query.c:27:     if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > GEOLAB_MAX_RADIUS_KM) return 0;
	.loc 1 27 49 discriminator 4 view .LVU39
	comisd	xmm4, QWORD PTR .LC3[rip]	# radius_km,
	ja	.L50	#,
.LVL11:
.LBB9:
	.loc 1 28 26 is_stmt 1 view .LVU40
	test	r14, r14	# count
	je	.L13	#,
	lea	r15, 8[r12]	# ivtmp.29,
# support/geolab/query.c:28:     for (size_t i = 0; i < count; ++i) {
	.loc 1 28 17 is_stmt 0 view .LVU41
	xor	r13d, r13d	# i
	jmp	.L14	#
.LVL12:
	.p2align 4,,10
	.p2align 3
.L54:
	.loc 1 28 35 is_stmt 1 discriminator 2 view .LVU42
	add	r13, 1	# i,
.LVL13:
	.loc 1 28 26 discriminator 2 view .LVU43
	add	r15, 24	# ivtmp.29,
	cmp	r14, r13	# count, i
	je	.L53	#,
.LVL14:
.L14:
	.loc 1 29 9 view .LVU44
# support/geolab/query.c:29:         if (!geo_valid_position(points[i].lat_deg, points[i].lon_deg)) return 0;
	.loc 1 29 14 is_stmt 0 view .LVU45
	movsd	xmm1, QWORD PTR 8[r15]	#, MEM[(double *)_106 + 8B]
	movsd	xmm0, QWORD PTR [r15]	#, MEM[(double *)_106]
	call	geo_valid_position@PLT	#
.LVL15:
# support/geolab/query.c:29:         if (!geo_valid_position(points[i].lat_deg, points[i].lon_deg)) return 0;
	.loc 1 29 12 view .LVU46
	test	eax, eax	# tmp163
	jne	.L54	#,
	jmp	.L50	#
.LVL16:
.L13:
	.loc 1 29 12 view .LVU47
.LBE9:
	.loc 1 31 5 is_stmt 1 view .LVU48
	.loc 1 32 9 view .LVU49
# support/geolab/query.c:32:         *hits = NULL;
	.loc 1 32 15 is_stmt 0 view .LVU50
	mov	QWORD PTR [rbx], 0	# *hits_48(D),
	.loc 1 33 9 is_stmt 1 view .LVU51
# support/geolab/query.c:34:         return 1;
	.loc 1 34 16 is_stmt 0 view .LVU52
	mov	eax, 1	# <retval>,
# support/geolab/query.c:33:         *nhits = 0;
	.loc 1 33 16 view .LVU53
	mov	QWORD PTR 0[rbp], 0	# *nhits_49(D),
	.loc 1 34 9 is_stmt 1 view .LVU54
# support/geolab/query.c:34:         return 1;
	.loc 1 34 16 is_stmt 0 view .LVU55
	jmp	.L7	#
.LVL17:
	.p2align 4,,10
	.p2align 3
.L53:
	.loc 1 31 5 is_stmt 1 view .LVU56
	.loc 1 38 5 view .LVU57
	.loc 1 39 5 view .LVU58
# support/geolab/query.c:39:     double *dist = malloc(count * sizeof(double));
	.loc 1 39 20 is_stmt 0 view .LVU59
	lea	r14, 0[0+r13*8]	# _14,
.LVL18:
	.loc 1 39 20 view .LVU60
	mov	rdi, r14	#, _14
	call	malloc@PLT	#
.LVL19:
	mov	QWORD PTR 56[rsp], rax	# %sfp, dist
.LVL20:
	.loc 1 40 5 is_stmt 1 view .LVU61
# support/geolab/query.c:40:     if (dist == NULL) return 0;
	.loc 1 40 8 is_stmt 0 view .LVU62
	test	rax, rax	# dist
	je	.L50	#,
	mov	rax, QWORD PTR 56[rsp]	# dist, %sfp
	.loc 1 40 8 view .LVU63
	lea	r15, 16[r12]	# ivtmp.24,
	add	r14, rax	# _14, dist
	mov	rcx, rax	# ivtmp.23, dist
	lea	rax, 64[rsp]	# tmp190,
.LVL21:
	.loc 1 40 8 view .LVU64
	mov	QWORD PTR 48[rsp], r14	# %sfp, _14
# support/geolab/query.c:41:     size_t selected = 0;
	.loc 1 41 12 view .LVU65
	xor	r14d, r14d	# selected
	mov	QWORD PTR 40[rsp], rax	# %sfp, tmp190
	jmp	.L19	#
.LVL22:
	.p2align 4,,10
	.p2align 3
.L16:
.LBB10:
.LBB11:
	.loc 1 48 9 is_stmt 1 view .LVU66
# support/geolab/query.c:48:         dist[i] = d;
	.loc 1 48 17 is_stmt 0 view .LVU67
	movsd	xmm0, QWORD PTR 64[rsp]	# d.0_22, d
# support/geolab/query.c:49:         if (d <= radius_km) ++selected; /* inclusive: the unrounded distance against the parsed radius */
	.loc 1 49 29 view .LVU68
	movsd	xmm5, QWORD PTR 24[rsp]	# radius_km, %sfp
	comisd	xmm5, xmm0	# radius_km, d.0_22
# support/geolab/query.c:48:         dist[i] = d;
	.loc 1 48 17 view .LVU69
	movsd	QWORD PTR [rcx], xmm0	# MEM[(double *)_87], d.0_22
	.loc 1 49 9 is_stmt 1 view .LVU70
# support/geolab/query.c:49:         if (d <= radius_km) ++selected; /* inclusive: the unrounded distance against the parsed radius */
	.loc 1 49 29 is_stmt 0 view .LVU71
	sbb	r14, -1	# selected,
.LVL23:
	.loc 1 49 29 view .LVU72
.LBE11:
	.loc 1 42 35 is_stmt 1 view .LVU73
	.loc 1 42 26 view .LVU74
	add	rcx, 8	# ivtmp.23,
	add	r15, 24	# ivtmp.24,
	cmp	QWORD PTR 48[rsp], rcx	# %sfp, ivtmp.23
	je	.L55	#,
.LVL24:
.L19:
.LBB12:
# support/geolab/query.c:44:         if (!geo_distance_km(lat, lon, points[i].lat_deg, points[i].lon_deg, &d)) { /* unreachable after validation */
	.loc 1 44 14 is_stmt 0 view .LVU75
	mov	rdi, QWORD PTR 40[rsp]	#, %sfp
	movsd	xmm3, QWORD PTR [r15]	#, MEM[(double *)_32]
	mov	QWORD PTR 32[rsp], rcx	# %sfp, ivtmp.23
.LVL25:
	.loc 1 43 9 is_stmt 1 view .LVU76
# support/geolab/query.c:44:         if (!geo_distance_km(lat, lon, points[i].lat_deg, points[i].lon_deg, &d)) { /* unreachable after validation */
	.loc 1 44 14 is_stmt 0 view .LVU77
	movsd	xmm2, QWORD PTR -8[r15]	#, MEM[(double *)_32 + -8B]
	movsd	xmm1, QWORD PTR 16[rsp]	#, %sfp
# support/geolab/query.c:43:         double d = 0.0;
	.loc 1 43 16 view .LVU78
	mov	QWORD PTR 64[rsp], 0x000000000	# d,
	.loc 1 44 9 is_stmt 1 view .LVU79
# support/geolab/query.c:44:         if (!geo_distance_km(lat, lon, points[i].lat_deg, points[i].lon_deg, &d)) { /* unreachable after validation */
	.loc 1 44 14 is_stmt 0 view .LVU80
	movsd	xmm0, QWORD PTR 8[rsp]	#, %sfp
	call	geo_distance_km@PLT	#
.LVL26:
# support/geolab/query.c:44:         if (!geo_distance_km(lat, lon, points[i].lat_deg, points[i].lon_deg, &d)) { /* unreachable after validation */
	.loc 1 44 12 view .LVU81
	mov	rcx, QWORD PTR 32[rsp]	# ivtmp.23, %sfp
	test	eax, eax	# <retval>
	jne	.L16	#,
# support/geolab/query.c:45:             free(dist);
	.loc 1 45 13 view .LVU82
	mov	rdi, QWORD PTR 56[rsp]	#, %sfp
	mov	DWORD PTR 8[rsp], eax	# %sfp, <retval>
.LVL27:
	.loc 1 45 13 is_stmt 1 view .LVU83
	call	free@PLT	#
.LVL28:
	.loc 1 46 13 view .LVU84
	mov	eax, DWORD PTR 8[rsp]	# <retval>, %sfp
	jmp	.L7	#
.LVL29:
.L55:
	.loc 1 46 13 is_stmt 0 view .LVU85
.LBE12:
.LBE10:
	.loc 1 52 5 is_stmt 1 view .LVU86
	.loc 1 53 5 view .LVU87
# support/geolab/query.c:53:     if (selected > 0) {
	.loc 1 53 8 is_stmt 0 view .LVU88
	test	r14, r14	# selected
	je	.L28	#,
.LBB13:
	.loc 1 54 9 is_stmt 1 view .LVU89
# support/geolab/query.c:54:         if (selected > SIZE_MAX / sizeof(QueryHit)) {
	.loc 1 54 12 is_stmt 0 view .LVU90
	mov	rax, r14	# tmp168, selected
	shr	rax, 60	# tmp168,
	jne	.L51	#,
	.loc 1 58 9 is_stmt 1 view .LVU91
# support/geolab/query.c:58:         out = malloc(selected * sizeof(QueryHit));
	.loc 1 58 15 is_stmt 0 view .LVU92
	mov	rdi, r14	# tmp146, selected
	sal	rdi, 4	# tmp146,
	call	malloc@PLT	#
.LVL30:
	mov	r15, rax	# out, tmp165
.LVL31:
	.loc 1 59 9 is_stmt 1 view .LVU93
# support/geolab/query.c:59:         if (out == NULL) {
	.loc 1 59 12 is_stmt 0 view .LVU94
	test	rax, rax	# out
	je	.L51	#,
.LBB7:
# support/geolab/query.c:64:         for (size_t i = 0; i < count; ++i) {
	.loc 1 64 21 view .LVU95
	xor	eax, eax	# i
.LVL32:
	.loc 1 64 21 view .LVU96
.LBE7:
# support/geolab/query.c:63:         size_t k = 0;
	.loc 1 63 16 view .LVU97
	xor	ecx, ecx	# k
.LVL33:
	.p2align 4,,10
	.p2align 3
.L25:
.LBB8:
	.loc 1 65 13 is_stmt 1 view .LVU98
# support/geolab/query.c:65:             if (dist[i] <= radius_km) {
	.loc 1 65 21 is_stmt 0 view .LVU99
	mov	rsi, QWORD PTR 56[rsp]	# dist, %sfp
# support/geolab/query.c:65:             if (dist[i] <= radius_km) {
	.loc 1 65 16 view .LVU100
	movsd	xmm6, QWORD PTR 24[rsp]	# radius_km, %sfp
# support/geolab/query.c:65:             if (dist[i] <= radius_km) {
	.loc 1 65 21 view .LVU101
	movsd	xmm0, QWORD PTR [rsi+rax*8]	# _26, MEM[(double *)dist_58 + i_83 * 8]
# support/geolab/query.c:65:             if (dist[i] <= radius_km) {
	.loc 1 65 16 view .LVU102
	comisd	xmm6, xmm0	# radius_km, _26
	jb	.L23	#,
	.loc 1 66 17 is_stmt 1 view .LVU103
# support/geolab/query.c:66:                 out[k].id = points[i].id;
	.loc 1 66 20 is_stmt 0 view .LVU104
	mov	rdx, rcx	# tmp148, k
# support/geolab/query.c:66:                 out[k].id = points[i].id;
	.loc 1 66 27 view .LVU105
	mov	rsi, QWORD PTR [r12]	# MEM[(long unsigned int *)_39], MEM[(long unsigned int *)_39]
# support/geolab/query.c:68:                 ++k;
	.loc 1 68 17 view .LVU106
	add	rcx, 1	# k,
.LVL34:
# support/geolab/query.c:66:                 out[k].id = points[i].id;
	.loc 1 66 20 view .LVU107
	sal	rdx, 4	# tmp148,
.LVL35:
	.loc 1 66 20 view .LVU108
	add	rdx, r15	# _30, out
# support/geolab/query.c:66:                 out[k].id = points[i].id;
	.loc 1 66 27 view .LVU109
	mov	QWORD PTR [rdx], rsi	# _30->id, MEM[(long unsigned int *)_39]
	.loc 1 67 17 is_stmt 1 view .LVU110
# support/geolab/query.c:67:                 out[k].distance_km = dist[i];
	.loc 1 67 36 is_stmt 0 view .LVU111
	movsd	QWORD PTR 8[rdx], xmm0	# _30->distance_km, _26
	.loc 1 68 17 is_stmt 1 view .LVU112
.LVL36:
.L23:
	.loc 1 64 39 discriminator 2 view .LVU113
	add	rax, 1	# i,
.LVL37:
	.loc 1 64 30 discriminator 2 view .LVU114
	add	r12, 24	# ivtmp.16,
	cmp	rax, r13	# i, i
	jb	.L25	#,
	.loc 1 64 30 is_stmt 0 discriminator 2 view .LVU115
.LBE8:
	.loc 1 72 9 is_stmt 1 view .LVU116
	lea	rcx, query_hit_compare[rip]	# tmp150,
.LVL38:
	.loc 1 72 9 is_stmt 0 view .LVU117
	mov	edx, 16	#,
	mov	rsi, r14	#, selected
	mov	rdi, r15	#, out
	call	qsort@PLT	#
.LVL39:
.L20:
	.loc 1 72 9 view .LVU118
.LBE13:
	.loc 1 74 5 is_stmt 1 view .LVU119
	mov	rdi, QWORD PTR 56[rsp]	#, %sfp
	call	free@PLT	#
.LVL40:
	.loc 1 76 5 view .LVU120
# support/geolab/query.c:76:     *hits = out;
	.loc 1 76 11 is_stmt 0 view .LVU121
	mov	QWORD PTR [rbx], r15	# *hits_48(D), out
	.loc 1 77 5 is_stmt 1 view .LVU122
# support/geolab/query.c:78:     return 1;
	.loc 1 78 12 is_stmt 0 view .LVU123
	mov	eax, 1	# <retval>,
# support/geolab/query.c:77:     *nhits = selected;
	.loc 1 77 12 view .LVU124
	mov	QWORD PTR 0[rbp], r14	# *nhits_49(D), selected
	.loc 1 78 5 is_stmt 1 view .LVU125
# support/geolab/query.c:78:     return 1;
	.loc 1 78 12 is_stmt 0 view .LVU126
	jmp	.L7	#
.LVL41:
.L51:
.LBB14:
	.loc 1 60 13 is_stmt 1 view .LVU127
	mov	rdi, QWORD PTR 56[rsp]	#, %sfp
	call	free@PLT	#
.LVL42:
	jmp	.L50	#
.LVL43:
.L28:
	.loc 1 60 13 is_stmt 0 view .LVU128
.LBE14:
# support/geolab/query.c:52:     QueryHit *out = NULL;
	.loc 1 52 15 view .LVU129
	xor	r15d, r15d	# out
	jmp	.L20	#
.LVL44:
.L52:
# support/geolab/query.c:79: }
	.loc 1 79 1 view .LVU130
	call	__stack_chk_fail@PLT	#
.LVL45:
	.cfi_endproc
.LFE24:
	.size	query_points, .-query_points
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
.LC3:
	.long	0
	.long	1090021888
	.text
.Letext0:
	.file 2 "/usr/include/x86_64-linux-gnu/bits/types.h"
	.file 3 "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h"
	.file 4 "/usr/lib/gcc/x86_64-linux-gnu/11/include/stddef.h"
	.file 5 "/usr/include/stdlib.h"
	.file 6 "support/geolab/geolab_types.h"
	.file 7 "support/geolab/geolab.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x565
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF34
	.byte	0xc
	.long	.LASF35
	.long	.LASF36
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
	.uleb128 0x4
	.long	.LASF10
	.byte	0x2
	.byte	0x2d
	.byte	0x1b
	.long	0x49
	.uleb128 0x5
	.byte	0x8
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF8
	.uleb128 0x2
	.byte	0x4
	.byte	0x4
	.long	.LASF9
	.uleb128 0x4
	.long	.LASF11
	.byte	0x3
	.byte	0x1b
	.byte	0x14
	.long	0x6c
	.uleb128 0x4
	.long	.LASF12
	.byte	0x4
	.byte	0xd1
	.byte	0x17
	.long	0x49
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF13
	.uleb128 0x6
	.long	.LASF14
	.byte	0x5
	.value	0x330
	.byte	0xf
	.long	0xb4
	.uleb128 0x7
	.byte	0x8
	.long	0xba
	.uleb128 0x8
	.long	0x5e
	.long	0xce
	.uleb128 0x9
	.long	0xce
	.uleb128 0x9
	.long	0xce
	.byte	0
	.uleb128 0x7
	.byte	0x8
	.long	0xd4
	.uleb128 0xa
	.uleb128 0x2
	.byte	0x10
	.byte	0x4
	.long	.LASF15
	.uleb128 0xb
	.byte	0x18
	.byte	0x6
	.byte	0x8
	.byte	0x9
	.long	0x10c
	.uleb128 0xc
	.string	"id"
	.byte	0x6
	.byte	0x8
	.byte	0x1b
	.long	0x88
	.byte	0
	.uleb128 0xd
	.long	.LASF16
	.byte	0x6
	.byte	0x8
	.byte	0x26
	.long	0x2d
	.byte	0x8
	.uleb128 0xd
	.long	.LASF17
	.byte	0x6
	.byte	0x8
	.byte	0x36
	.long	0x2d
	.byte	0x10
	.byte	0
	.uleb128 0x4
	.long	.LASF18
	.byte	0x6
	.byte	0x8
	.byte	0x41
	.long	0xdc
	.uleb128 0xe
	.long	0x10c
	.uleb128 0xb
	.byte	0x10
	.byte	0x7
	.byte	0x2a
	.byte	0x9
	.long	0x140
	.uleb128 0xc
	.string	"id"
	.byte	0x7
	.byte	0x2a
	.byte	0x1b
	.long	0x88
	.byte	0
	.uleb128 0xd
	.long	.LASF19
	.byte	0x7
	.byte	0x2a
	.byte	0x26
	.long	0x2d
	.byte	0x8
	.byte	0
	.uleb128 0x4
	.long	.LASF20
	.byte	0x7
	.byte	0x2a
	.byte	0x35
	.long	0x11d
	.uleb128 0xe
	.long	0x140
	.uleb128 0xf
	.long	.LASF21
	.byte	0x5
	.value	0x346
	.byte	0xd
	.long	0x173
	.uleb128 0x9
	.long	0x78
	.uleb128 0x9
	.long	0x94
	.uleb128 0x9
	.long	0x94
	.uleb128 0x9
	.long	0xa7
	.byte	0
	.uleb128 0xf
	.long	.LASF22
	.byte	0x5
	.value	0x22b
	.byte	0xd
	.long	0x186
	.uleb128 0x9
	.long	0x78
	.byte	0
	.uleb128 0x10
	.long	.LASF23
	.byte	0x7
	.byte	0x26
	.byte	0x5
	.long	0x5e
	.long	0x1b0
	.uleb128 0x9
	.long	0x2d
	.uleb128 0x9
	.long	0x2d
	.uleb128 0x9
	.long	0x2d
	.uleb128 0x9
	.long	0x2d
	.uleb128 0x9
	.long	0x1b0
	.byte	0
	.uleb128 0x7
	.byte	0x8
	.long	0x2d
	.uleb128 0x11
	.long	.LASF24
	.byte	0x5
	.value	0x21c
	.byte	0xe
	.long	0x78
	.long	0x1cd
	.uleb128 0x9
	.long	0x94
	.byte	0
	.uleb128 0x10
	.long	.LASF25
	.byte	0x7
	.byte	0x22
	.byte	0x5
	.long	0x5e
	.long	0x1e8
	.uleb128 0x9
	.long	0x2d
	.uleb128 0x9
	.long	0x2d
	.byte	0
	.uleb128 0x12
	.long	.LASF37
	.byte	0x1
	.byte	0x15
	.byte	0x5
	.long	0x5e
	.quad	.LFB24
	.quad	.LFE24-.LFB24
	.uleb128 0x1
	.byte	0x9c
	.long	0x47d
	.uleb128 0x13
	.long	.LASF26
	.byte	0x1
	.byte	0x15
	.byte	0x22
	.long	0x47d
	.long	.LLST4
	.long	.LVUS4
	.uleb128 0x13
	.long	.LASF27
	.byte	0x1
	.byte	0x15
	.byte	0x31
	.long	0x94
	.long	.LLST5
	.long	.LVUS5
	.uleb128 0x14
	.string	"lat"
	.byte	0x1
	.byte	0x15
	.byte	0x3f
	.long	0x2d
	.long	.LLST6
	.long	.LVUS6
	.uleb128 0x14
	.string	"lon"
	.byte	0x1
	.byte	0x15
	.byte	0x4b
	.long	0x2d
	.long	.LLST7
	.long	.LVUS7
	.uleb128 0x13
	.long	.LASF28
	.byte	0x1
	.byte	0x15
	.byte	0x57
	.long	0x2d
	.long	.LLST8
	.long	.LVUS8
	.uleb128 0x13
	.long	.LASF29
	.byte	0x1
	.byte	0x15
	.byte	0x6d
	.long	0x483
	.long	.LLST9
	.long	.LVUS9
	.uleb128 0x13
	.long	.LASF30
	.byte	0x1
	.byte	0x16
	.byte	0x1a
	.long	0x48f
	.long	.LLST10
	.long	.LVUS10
	.uleb128 0x15
	.long	.LASF31
	.byte	0x1
	.byte	0x27
	.byte	0xd
	.long	0x1b0
	.long	.LLST11
	.long	.LVUS11
	.uleb128 0x15
	.long	.LASF32
	.byte	0x1
	.byte	0x29
	.byte	0xc
	.long	0x94
	.long	.LLST12
	.long	.LVUS12
	.uleb128 0x16
	.string	"out"
	.byte	0x1
	.byte	0x34
	.byte	0xf
	.long	0x489
	.long	.LLST13
	.long	.LVUS13
	.uleb128 0x17
	.quad	.LBB9
	.quad	.LBE9-.LBB9
	.long	0x307
	.uleb128 0x16
	.string	"i"
	.byte	0x1
	.byte	0x1c
	.byte	0x11
	.long	0x94
	.long	.LLST16
	.long	.LVUS16
	.uleb128 0x18
	.quad	.LVL15
	.long	0x1cd
	.byte	0
	.uleb128 0x17
	.quad	.LBB10
	.quad	.LBE10-.LBB10
	.long	0x37f
	.uleb128 0x19
	.string	"i"
	.byte	0x1
	.byte	0x2a
	.byte	0x11
	.long	0x94
	.uleb128 0x1a
	.long	.Ldebug_ranges0+0x70
	.uleb128 0x1b
	.string	"d"
	.byte	0x1
	.byte	0x2b
	.byte	0x10
	.long	0x2d
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.uleb128 0x1c
	.quad	.LVL26
	.long	0x186
	.long	0x367
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x61
	.uleb128 0x6
	.byte	0x91
	.sleb128 -136
	.byte	0xf6
	.byte	0x8
	.uleb128 0x2d
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x62
	.uleb128 0x6
	.byte	0x91
	.sleb128 -128
	.byte	0xf6
	.byte	0x8
	.uleb128 0x2d
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x4
	.byte	0x91
	.sleb128 -104
	.byte	0x6
	.byte	0
	.uleb128 0x1e
	.quad	.LVL28
	.long	0x173
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x4
	.byte	0x91
	.sleb128 -88
	.byte	0x6
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x1f
	.long	.Ldebug_ranges0+0
	.long	0x417
	.uleb128 0x16
	.string	"k"
	.byte	0x1
	.byte	0x3f
	.byte	0x10
	.long	0x94
	.long	.LLST14
	.long	.LVUS14
	.uleb128 0x1f
	.long	.Ldebug_ranges0+0x40
	.long	0x3b6
	.uleb128 0x16
	.string	"i"
	.byte	0x1
	.byte	0x40
	.byte	0x15
	.long	0x94
	.long	.LLST15
	.long	.LVUS15
	.byte	0
	.uleb128 0x1c
	.quad	.LVL30
	.long	0x1b6
	.long	0x3d0
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x4
	.byte	0x7e
	.sleb128 0
	.byte	0x34
	.byte	0x24
	.byte	0
	.uleb128 0x1c
	.quad	.LVL39
	.long	0x151
	.long	0x400
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x2
	.byte	0x7f
	.sleb128 0
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x2
	.byte	0x7e
	.sleb128 0
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x40
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	query_hit_compare
	.byte	0
	.uleb128 0x1e
	.quad	.LVL42
	.long	0x173
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x4
	.byte	0x91
	.sleb128 -88
	.byte	0x6
	.byte	0
	.byte	0
	.uleb128 0x1c
	.quad	.LVL10
	.long	0x1cd
	.long	0x43d
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x61
	.uleb128 0x6
	.byte	0x91
	.sleb128 -136
	.byte	0xf6
	.byte	0x8
	.uleb128 0x2d
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x62
	.uleb128 0x6
	.byte	0x91
	.sleb128 -128
	.byte	0xf6
	.byte	0x8
	.uleb128 0x2d
	.byte	0
	.uleb128 0x1c
	.quad	.LVL19
	.long	0x1b6
	.long	0x455
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x2
	.byte	0x7e
	.sleb128 0
	.byte	0
	.uleb128 0x1c
	.quad	.LVL40
	.long	0x173
	.long	0x46f
	.uleb128 0x1d
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x4
	.byte	0x91
	.sleb128 -88
	.byte	0x6
	.byte	0
	.uleb128 0x18
	.quad	.LVL45
	.long	0x55f
	.byte	0
	.uleb128 0x7
	.byte	0x8
	.long	0x118
	.uleb128 0x7
	.byte	0x8
	.long	0x489
	.uleb128 0x7
	.byte	0x8
	.long	0x140
	.uleb128 0x7
	.byte	0x8
	.long	0x94
	.uleb128 0x20
	.long	.LASF33
	.byte	0x1
	.byte	0xb
	.byte	0x5
	.long	0x5e
	.byte	0x1
	.long	0x4cf
	.uleb128 0x21
	.string	"a"
	.byte	0x1
	.byte	0xb
	.byte	0x23
	.long	0xce
	.uleb128 0x21
	.string	"b"
	.byte	0x1
	.byte	0xb
	.byte	0x32
	.long	0xce
	.uleb128 0x19
	.string	"x"
	.byte	0x1
	.byte	0xd
	.byte	0x15
	.long	0x4cf
	.uleb128 0x19
	.string	"y"
	.byte	0x1
	.byte	0xd
	.byte	0x1d
	.long	0x4cf
	.byte	0
	.uleb128 0x7
	.byte	0x8
	.long	0x14c
	.uleb128 0x22
	.long	0x495
	.quad	.LFB23
	.quad	.LFE23-.LFB23
	.uleb128 0x1
	.byte	0x9c
	.long	0x55f
	.uleb128 0x23
	.long	0x4a6
	.uleb128 0x1
	.byte	0x55
	.uleb128 0x23
	.long	0x4b0
	.uleb128 0x1
	.byte	0x54
	.uleb128 0x24
	.long	0x4ba
	.long	.LLST0
	.long	.LVUS0
	.uleb128 0x24
	.long	0x4c4
	.long	.LLST1
	.long	.LVUS1
	.uleb128 0x25
	.long	0x495
	.quad	.LBI4
	.byte	.LVU12
	.quad	.LBB4
	.quad	.LBE4-.LBB4
	.byte	0x1
	.byte	0xb
	.byte	0x5
	.uleb128 0x26
	.long	0x4b0
	.long	.LLST2
	.long	.LVUS2
	.uleb128 0x26
	.long	0x4a6
	.long	.LLST3
	.long	.LVUS3
	.uleb128 0x27
	.long	0x4ba
	.uleb128 0x27
	.long	0x4c4
	.byte	0
	.byte	0
	.uleb128 0x28
	.long	.LASF38
	.long	.LASF38
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
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
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
	.uleb128 0x9
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x26
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0xb
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
	.uleb128 0xc
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
	.uleb128 0xd
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
	.uleb128 0xe
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
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
	.uleb128 0x5
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
	.uleb128 0x12
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
	.uleb128 0x13
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
	.uleb128 0x14
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
	.uleb128 0x15
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
	.uleb128 0x16
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
	.uleb128 0x17
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x4109
	.byte	0
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x19
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
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x1b
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
	.uleb128 0x1c
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
	.uleb128 0x1d
	.uleb128 0x410a
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x2111
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x20
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
	.uleb128 0x21
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
	.uleb128 0x22
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
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x23
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x24
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x25
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
	.byte	0
	.byte	0
	.uleb128 0x26
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
	.uleb128 0x27
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x28
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
.LVUS4:
	.uleb128 0
	.uleb128 .LVU24
	.uleb128 .LVU24
	.uleb128 .LVU28
	.uleb128 .LVU28
	.uleb128 .LVU32
	.uleb128 .LVU32
	.uleb128 .LVU98
	.uleb128 .LVU98
	.uleb128 .LVU127
	.uleb128 .LVU127
	.uleb128 .LVU130
	.uleb128 .LVU130
	.uleb128 0
.LLST4:
	.quad	.LVL4-.Ltext0
	.quad	.LVL5-.Ltext0
	.value	0x1
	.byte	0x55
	.quad	.LVL5-.Ltext0
	.quad	.LVL7-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x55
	.byte	0x9f
	.quad	.LVL7-.Ltext0
	.quad	.LVL10-1-.Ltext0
	.value	0x1
	.byte	0x55
	.quad	.LVL10-1-.Ltext0
	.quad	.LVL33-.Ltext0
	.value	0x1
	.byte	0x5c
	.quad	.LVL33-.Ltext0
	.quad	.LVL41-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x55
	.byte	0x9f
	.quad	.LVL41-.Ltext0
	.quad	.LVL44-.Ltext0
	.value	0x1
	.byte	0x5c
	.quad	.LVL44-.Ltext0
	.quad	.LFE24-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x55
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS5:
	.uleb128 0
	.uleb128 .LVU24
	.uleb128 .LVU24
	.uleb128 .LVU28
	.uleb128 .LVU28
	.uleb128 .LVU32
	.uleb128 .LVU32
	.uleb128 .LVU60
	.uleb128 .LVU60
	.uleb128 0
.LLST5:
	.quad	.LVL4-.Ltext0
	.quad	.LVL5-.Ltext0
	.value	0x1
	.byte	0x54
	.quad	.LVL5-.Ltext0
	.quad	.LVL7-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x54
	.byte	0x9f
	.quad	.LVL7-.Ltext0
	.quad	.LVL10-1-.Ltext0
	.value	0x1
	.byte	0x54
	.quad	.LVL10-1-.Ltext0
	.quad	.LVL18-.Ltext0
	.value	0x1
	.byte	0x5e
	.quad	.LVL18-.Ltext0
	.quad	.LFE24-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x54
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS6:
	.uleb128 0
	.uleb128 .LVU24
	.uleb128 .LVU24
	.uleb128 .LVU26
	.uleb128 .LVU26
	.uleb128 .LVU28
	.uleb128 .LVU28
	.uleb128 .LVU31
	.uleb128 .LVU31
	.uleb128 .LVU83
	.uleb128 .LVU83
	.uleb128 .LVU85
	.uleb128 .LVU85
	.uleb128 .LVU130
	.uleb128 .LVU130
	.uleb128 0
.LLST6:
	.quad	.LVL4-.Ltext0
	.quad	.LVL5-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL5-.Ltext0
	.quad	.LVL6-.Ltext0
	.value	0x3
	.byte	0x91
	.sleb128 -136
	.quad	.LVL6-.Ltext0
	.quad	.LVL7-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x11
	.uleb128 0x2d
	.byte	0x9f
	.quad	.LVL7-.Ltext0
	.quad	.LVL9-.Ltext0
	.value	0x1
	.byte	0x61
	.quad	.LVL9-.Ltext0
	.quad	.LVL27-.Ltext0
	.value	0x3
	.byte	0x91
	.sleb128 -136
	.quad	.LVL27-.Ltext0
	.quad	.LVL29-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x11
	.uleb128 0x2d
	.byte	0x9f
	.quad	.LVL29-.Ltext0
	.quad	.LVL44-.Ltext0
	.value	0x3
	.byte	0x91
	.sleb128 -136
	.quad	.LVL44-.Ltext0
	.quad	.LFE24-.Ltext0
	.value	0x6
	.byte	0xf3
	.uleb128 0x3
	.byte	0xf5
	.uleb128 0x11
	.uleb128 0x2d
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS7:
	.uleb128 0
	.uleb128 .LVU24
	.uleb128 .LVU24
	.uleb128 .LVU28
	.uleb128 .LVU28
	.uleb128 .LVU30
	.uleb128 .LVU30
	.uleb128 0
.LLST7:
	.quad	.LVL4-.Ltext0
	.quad	.LVL5-.Ltext0
	.value	0x1
	.byte	0x62
	.quad	.LVL5-.Ltext0
	.quad	.LVL7-.Ltext0
	.value	0x3
	.byte	0x91
	.sleb128 -128
	.quad	.LVL7-.Ltext0
	.quad	.LVL8-.Ltext0
	.value	0x1
	.byte	0x62
	.quad	.LVL8-.Ltext0
	.quad	.LFE24-.Ltext0
	.value	0x3
	.byte	0x91
	.sleb128 -128
	.quad	0
	.quad	0
.LVUS8:
	.uleb128 0
	.uleb128 .LVU24
	.uleb128 .LVU24
	.uleb128 .LVU28
	.uleb128 .LVU28
	.uleb128 .LVU32
	.uleb128 .LVU32
	.uleb128 0
.LLST8:
	.quad	.LVL4-.Ltext0
	.quad	.LVL5-.Ltext0
	.value	0x1
	.byte	0x63
	.quad	.LVL5-.Ltext0
	.quad	.LVL7-.Ltext0
	.value	0x3
	.byte	0x91
	.sleb128 -120
	.quad	.LVL7-.Ltext0
	.quad	.LVL10-1-.Ltext0
	.value	0x1
	.byte	0x63
	.quad	.LVL10-1-.Ltext0
	.quad	.LFE24-.Ltext0
	.value	0x3
	.byte	0x91
	.sleb128 -120
	.quad	0
	.quad	0
.LVUS9:
	.uleb128 0
	.uleb128 .LVU24
	.uleb128 .LVU24
	.uleb128 .LVU28
	.uleb128 .LVU28
	.uleb128 .LVU32
	.uleb128 .LVU32
	.uleb128 .LVU130
	.uleb128 .LVU130
	.uleb128 0
.LLST9:
	.quad	.LVL4-.Ltext0
	.quad	.LVL5-.Ltext0
	.value	0x1
	.byte	0x51
	.quad	.LVL5-.Ltext0
	.quad	.LVL7-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.quad	.LVL7-.Ltext0
	.quad	.LVL10-1-.Ltext0
	.value	0x1
	.byte	0x51
	.quad	.LVL10-1-.Ltext0
	.quad	.LVL44-.Ltext0
	.value	0x1
	.byte	0x53
	.quad	.LVL44-.Ltext0
	.quad	.LFE24-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS10:
	.uleb128 0
	.uleb128 .LVU24
	.uleb128 .LVU24
	.uleb128 .LVU28
	.uleb128 .LVU28
	.uleb128 .LVU32
	.uleb128 .LVU32
	.uleb128 .LVU130
	.uleb128 .LVU130
	.uleb128 0
.LLST10:
	.quad	.LVL4-.Ltext0
	.quad	.LVL5-.Ltext0
	.value	0x1
	.byte	0x52
	.quad	.LVL5-.Ltext0
	.quad	.LVL7-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.quad	.LVL7-.Ltext0
	.quad	.LVL10-1-.Ltext0
	.value	0x1
	.byte	0x52
	.quad	.LVL10-1-.Ltext0
	.quad	.LVL44-.Ltext0
	.value	0x1
	.byte	0x56
	.quad	.LVL44-.Ltext0
	.quad	.LFE24-.Ltext0
	.value	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS11:
	.uleb128 .LVU61
	.uleb128 .LVU64
	.uleb128 .LVU64
	.uleb128 .LVU66
	.uleb128 .LVU66
	.uleb128 .LVU130
.LLST11:
	.quad	.LVL20-.Ltext0
	.quad	.LVL21-.Ltext0
	.value	0x1
	.byte	0x50
	.quad	.LVL21-.Ltext0
	.quad	.LVL22-.Ltext0
	.value	0x1
	.byte	0x52
	.quad	.LVL22-.Ltext0
	.quad	.LVL44-.Ltext0
	.value	0x3
	.byte	0x91
	.sleb128 -88
	.quad	0
	.quad	0
.LVUS12:
	.uleb128 .LVU66
	.uleb128 .LVU75
	.uleb128 .LVU76
	.uleb128 .LVU130
.LLST12:
	.quad	.LVL22-.Ltext0
	.quad	.LVL24-.Ltext0
	.value	0x1
	.byte	0x5e
	.quad	.LVL25-.Ltext0
	.quad	.LVL44-.Ltext0
	.value	0x1
	.byte	0x5e
	.quad	0
	.quad	0
.LVUS13:
	.uleb128 .LVU87
	.uleb128 .LVU93
	.uleb128 .LVU93
	.uleb128 .LVU96
	.uleb128 .LVU96
	.uleb128 .LVU127
	.uleb128 .LVU128
	.uleb128 .LVU130
.LLST13:
	.quad	.LVL29-.Ltext0
	.quad	.LVL31-.Ltext0
	.value	0x2
	.byte	0x30
	.byte	0x9f
	.quad	.LVL31-.Ltext0
	.quad	.LVL32-.Ltext0
	.value	0x1
	.byte	0x50
	.quad	.LVL32-.Ltext0
	.quad	.LVL41-.Ltext0
	.value	0x1
	.byte	0x5f
	.quad	.LVL43-.Ltext0
	.quad	.LVL44-.Ltext0
	.value	0x2
	.byte	0x30
	.byte	0x9f
	.quad	0
	.quad	0
.LVUS16:
	.uleb128 .LVU40
	.uleb128 .LVU42
	.uleb128 .LVU42
	.uleb128 .LVU47
	.uleb128 .LVU47
	.uleb128 .LVU56
	.uleb128 .LVU56
	.uleb128 .LVU130
.LLST16:
	.quad	.LVL11-.Ltext0
	.quad	.LVL12-.Ltext0
	.value	0x2
	.byte	0x30
	.byte	0x9f
	.quad	.LVL12-.Ltext0
	.quad	.LVL16-.Ltext0
	.value	0x1
	.byte	0x5d
	.quad	.LVL16-.Ltext0
	.quad	.LVL17-.Ltext0
	.value	0x2
	.byte	0x30
	.byte	0x9f
	.quad	.LVL17-.Ltext0
	.quad	.LVL44-.Ltext0
	.value	0x1
	.byte	0x5d
	.quad	0
	.quad	0
.LVUS14:
	.uleb128 .LVU98
	.uleb128 .LVU107
	.uleb128 .LVU107
	.uleb128 .LVU108
	.uleb128 .LVU108
	.uleb128 .LVU113
	.uleb128 .LVU113
	.uleb128 .LVU117
.LLST14:
	.quad	.LVL33-.Ltext0
	.quad	.LVL34-.Ltext0
	.value	0x1
	.byte	0x52
	.quad	.LVL34-.Ltext0
	.quad	.LVL35-.Ltext0
	.value	0x1
	.byte	0x51
	.quad	.LVL35-.Ltext0
	.quad	.LVL36-.Ltext0
	.value	0x3
	.byte	0x72
	.sleb128 -1
	.byte	0x9f
	.quad	.LVL36-.Ltext0
	.quad	.LVL38-.Ltext0
	.value	0x1
	.byte	0x52
	.quad	0
	.quad	0
.LVUS15:
	.uleb128 .LVU98
	.uleb128 .LVU118
.LLST15:
	.quad	.LVL33-.Ltext0
	.quad	.LVL39-1-.Ltext0
	.value	0x1
	.byte	0x50
	.quad	0
	.quad	0
.LVUS0:
	.uleb128 .LVU3
	.uleb128 0
.LLST0:
	.quad	.LVL1-.Ltext0
	.quad	.LFE23-.Ltext0
	.value	0x1
	.byte	0x55
	.quad	0
	.quad	0
.LVUS1:
	.uleb128 .LVU3
	.uleb128 0
.LLST1:
	.quad	.LVL1-.Ltext0
	.quad	.LFE23-.Ltext0
	.value	0x1
	.byte	0x54
	.quad	0
	.quad	0
.LVUS2:
	.uleb128 .LVU12
	.uleb128 .LVU16
.LLST2:
	.quad	.LVL2-.Ltext0
	.quad	.LVL3-.Ltext0
	.value	0x1
	.byte	0x54
	.quad	0
	.quad	0
.LVUS3:
	.uleb128 .LVU12
	.uleb128 .LVU16
.LLST3:
	.quad	.LVL2-.Ltext0
	.quad	.LVL3-.Ltext0
	.value	0x1
	.byte	0x55
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
	.quad	.LBB6-.Ltext0
	.quad	.LBE6-.Ltext0
	.quad	.LBB13-.Ltext0
	.quad	.LBE13-.Ltext0
	.quad	.LBB14-.Ltext0
	.quad	.LBE14-.Ltext0
	.quad	0
	.quad	0
	.quad	.LBB7-.Ltext0
	.quad	.LBE7-.Ltext0
	.quad	.LBB8-.Ltext0
	.quad	.LBE8-.Ltext0
	.quad	0
	.quad	0
	.quad	.LBB11-.Ltext0
	.quad	.LBE11-.Ltext0
	.quad	.LBB12-.Ltext0
	.quad	.LBE12-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF12:
	.string	"size_t"
.LASF37:
	.string	"query_points"
.LASF27:
	.string	"count"
.LASF26:
	.string	"points"
.LASF30:
	.string	"nhits"
.LASF11:
	.string	"uint64_t"
.LASF20:
	.string	"QueryHit"
.LASF33:
	.string	"query_hit_compare"
.LASF9:
	.string	"float"
.LASF21:
	.string	"qsort"
.LASF1:
	.string	"unsigned char"
.LASF25:
	.string	"geo_valid_position"
.LASF4:
	.string	"long unsigned int"
.LASF2:
	.string	"short unsigned int"
.LASF38:
	.string	"__stack_chk_fail"
.LASF0:
	.string	"double"
.LASF34:
	.string	"GNU C11 11.4.0 -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O2 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection"
.LASF17:
	.string	"lon_deg"
.LASF6:
	.string	"short int"
.LASF18:
	.string	"GeoPoint"
.LASF36:
	.string	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11"
.LASF3:
	.string	"unsigned int"
.LASF19:
	.string	"distance_km"
.LASF8:
	.string	"char"
.LASF16:
	.string	"lat_deg"
.LASF31:
	.string	"dist"
.LASF15:
	.string	"long double"
.LASF22:
	.string	"free"
.LASF13:
	.string	"long long int"
.LASF14:
	.string	"__compar_fn_t"
.LASF29:
	.string	"hits"
.LASF23:
	.string	"geo_distance_km"
.LASF28:
	.string	"radius_km"
.LASF32:
	.string	"selected"
.LASF7:
	.string	"long int"
.LASF10:
	.string	"__uint64_t"
.LASF35:
	.string	"support/geolab/query.c"
.LASF5:
	.string	"signed char"
.LASF24:
	.string	"malloc"
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
