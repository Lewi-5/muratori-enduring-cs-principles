	.file	"query.c"
	.intel_syntax noprefix
# GNU C11 (Ubuntu 11.4.0-1ubuntu1~22.04.3) version 11.4.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O0 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
.Ltext0:
	.globl	query_hit_compare
	.type	query_hit_compare, @function
query_hit_compare:
.LFB1:
	.file 1 "support/geolab/query.c"
	.loc 1 12 1
	.cfi_startproc
	endbr64	
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	mov	QWORD PTR -24[rbp], rdi	# a, a
	mov	QWORD PTR -32[rbp], rsi	# b, b
# support/geolab/query.c:13:     const QueryHit *x = a, *y = b;
	.loc 1 13 21
	mov	rax, QWORD PTR -24[rbp]	# tmp92, a
	mov	QWORD PTR -16[rbp], rax	# x, tmp92
# support/geolab/query.c:13:     const QueryHit *x = a, *y = b;
	.loc 1 13 29
	mov	rax, QWORD PTR -32[rbp]	# tmp93, b
	mov	QWORD PTR -8[rbp], rax	# y, tmp93
# support/geolab/query.c:14:     if (x->distance_km < y->distance_km) return -1;
	.loc 1 14 10
	mov	rax, QWORD PTR -16[rbp]	# tmp94, x
	movsd	xmm1, QWORD PTR 8[rax]	# _1, x_11->distance_km
# support/geolab/query.c:14:     if (x->distance_km < y->distance_km) return -1;
	.loc 1 14 27
	mov	rax, QWORD PTR -8[rbp]	# tmp95, y
	movsd	xmm0, QWORD PTR 8[rax]	# _2, y_13->distance_km
# support/geolab/query.c:14:     if (x->distance_km < y->distance_km) return -1;
	.loc 1 14 8
	comisd	xmm0, xmm1	# _2, _1
	jbe	.L11	#,
# support/geolab/query.c:14:     if (x->distance_km < y->distance_km) return -1;
	.loc 1 14 49 discriminator 1
	mov	eax, -1	# _9,
	jmp	.L4	#
.L11:
# support/geolab/query.c:15:     if (x->distance_km > y->distance_km) return 1;
	.loc 1 15 10
	mov	rax, QWORD PTR -16[rbp]	# tmp96, x
	movsd	xmm0, QWORD PTR 8[rax]	# _3, x_11->distance_km
# support/geolab/query.c:15:     if (x->distance_km > y->distance_km) return 1;
	.loc 1 15 27
	mov	rax, QWORD PTR -8[rbp]	# tmp97, y
	movsd	xmm1, QWORD PTR 8[rax]	# _4, y_13->distance_km
# support/geolab/query.c:15:     if (x->distance_km > y->distance_km) return 1;
	.loc 1 15 8
	comisd	xmm0, xmm1	# _3, _4
	jbe	.L12	#,
# support/geolab/query.c:15:     if (x->distance_km > y->distance_km) return 1;
	.loc 1 15 49 discriminator 1
	mov	eax, 1	# _9,
	jmp	.L4	#
.L12:
# support/geolab/query.c:16:     if (x->id < y->id) return -1;
	.loc 1 16 10
	mov	rax, QWORD PTR -16[rbp]	# tmp98, x
	mov	rdx, QWORD PTR [rax]	# _5, x_11->id
# support/geolab/query.c:16:     if (x->id < y->id) return -1;
	.loc 1 16 18
	mov	rax, QWORD PTR -8[rbp]	# tmp99, y
	mov	rax, QWORD PTR [rax]	# _6, y_13->id
# support/geolab/query.c:16:     if (x->id < y->id) return -1;
	.loc 1 16 8
	cmp	rdx, rax	# _5, _6
	jnb	.L7	#,
# support/geolab/query.c:16:     if (x->id < y->id) return -1;
	.loc 1 16 31 discriminator 1
	mov	eax, -1	# _9,
	jmp	.L4	#
.L7:
# support/geolab/query.c:17:     if (x->id > y->id) return 1;
	.loc 1 17 10
	mov	rax, QWORD PTR -16[rbp]	# tmp100, x
	mov	rdx, QWORD PTR [rax]	# _7, x_11->id
# support/geolab/query.c:17:     if (x->id > y->id) return 1;
	.loc 1 17 18
	mov	rax, QWORD PTR -8[rbp]	# tmp101, y
	mov	rax, QWORD PTR [rax]	# _8, y_13->id
# support/geolab/query.c:17:     if (x->id > y->id) return 1;
	.loc 1 17 8
	cmp	rdx, rax	# _7, _8
	jbe	.L8	#,
# support/geolab/query.c:17:     if (x->id > y->id) return 1;
	.loc 1 17 31 discriminator 1
	mov	eax, 1	# _9,
	jmp	.L4	#
.L8:
# support/geolab/query.c:18:     return 0;
	.loc 1 18 12
	mov	eax, 0	# _9,
.L4:
# support/geolab/query.c:19: }
	.loc 1 19 1
	pop	rbp	#
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE1:
	.size	query_hit_compare, .-query_hit_compare
	.globl	query_points
	.type	query_points, @function
query_points:
.LFB2:
	.loc 1 23 1
	.cfi_startproc
	endbr64	
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	sub	rsp, 144	#,
	mov	QWORD PTR -88[rbp], rdi	# points, points
	mov	QWORD PTR -96[rbp], rsi	# count, count
	movsd	QWORD PTR -104[rbp], xmm0	# lat, lat
	movsd	QWORD PTR -112[rbp], xmm1	# lon, lon
	movsd	QWORD PTR -120[rbp], xmm2	# radius_km, radius_km
	mov	QWORD PTR -128[rbp], rdx	# hits, hits
	mov	QWORD PTR -136[rbp], rcx	# nhits, nhits
# support/geolab/query.c:23: {
	.loc 1 23 1
	mov	rax, QWORD PTR fs:40	# tmp185, MEM[(<address-space-1> long unsigned int *)40B]
	mov	QWORD PTR -8[rbp], rax	# D.3232, tmp185
	xor	eax, eax	# tmp185
# support/geolab/query.c:25:     if (hits == NULL || nhits == NULL || (points == NULL && count > 0)) return 0;
	.loc 1 25 8
	cmp	QWORD PTR -128[rbp], 0	# hits,
	je	.L14	#,
# support/geolab/query.c:25:     if (hits == NULL || nhits == NULL || (points == NULL && count > 0)) return 0;
	.loc 1 25 22 discriminator 2
	cmp	QWORD PTR -136[rbp], 0	# nhits,
	je	.L14	#,
# support/geolab/query.c:25:     if (hits == NULL || nhits == NULL || (points == NULL && count > 0)) return 0;
	.loc 1 25 39 discriminator 4
	cmp	QWORD PTR -88[rbp], 0	# points,
	jne	.L15	#,
# support/geolab/query.c:25:     if (hits == NULL || nhits == NULL || (points == NULL && count > 0)) return 0;
	.loc 1 25 58 discriminator 5
	cmp	QWORD PTR -96[rbp], 0	# count,
	je	.L15	#,
.L14:
# support/geolab/query.c:25:     if (hits == NULL || nhits == NULL || (points == NULL && count > 0)) return 0;
	.loc 1 25 80 discriminator 6
	mov	eax, 0	# _44,
	jmp	.L16	#
.L15:
# support/geolab/query.c:26:     if (!geo_valid_position(lat, lon)) return 0;
	.loc 1 26 10
	movsd	xmm0, QWORD PTR -112[rbp]	# tmp119, lon
	mov	rax, QWORD PTR -104[rbp]	# tmp120, lat
	movapd	xmm1, xmm0	#, tmp119
	movq	xmm0, rax	#, tmp120
	call	geo_valid_position@PLT	#
# support/geolab/query.c:26:     if (!geo_valid_position(lat, lon)) return 0;
	.loc 1 26 8
	test	eax, eax	# _1
	jne	.L17	#,
# support/geolab/query.c:26:     if (!geo_valid_position(lat, lon)) return 0;
	.loc 1 26 47 discriminator 1
	mov	eax, 0	# _44,
	jmp	.L16	#
.L17:
# support/geolab/query.c:27:     if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > GEOLAB_MAX_RADIUS_KM) return 0;
	.loc 1 27 10
	movsd	xmm0, QWORD PTR -120[rbp]	# tmp121, radius_km
	movq	xmm1, QWORD PTR .LC0[rip]	# tmp122,
	andpd	xmm1, xmm0	# _2, tmp121
# support/geolab/query.c:27:     if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > GEOLAB_MAX_RADIUS_KM) return 0;
	.loc 1 27 8
	movsd	xmm0, QWORD PTR .LC1[rip]	# tmp123,
	ucomisd	xmm0, xmm1	# tmp123, _2
	jb	.L18	#,
# support/geolab/query.c:27:     if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > GEOLAB_MAX_RADIUS_KM) return 0;
	.loc 1 27 30 discriminator 2
	pxor	xmm0, xmm0	# tmp124
	comisd	xmm0, QWORD PTR -120[rbp]	# tmp124, radius_km
	ja	.L18	#,
# support/geolab/query.c:27:     if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > GEOLAB_MAX_RADIUS_KM) return 0;
	.loc 1 27 49 discriminator 4
	movsd	xmm0, QWORD PTR -120[rbp]	# tmp125, radius_km
	comisd	xmm0, QWORD PTR .LC3[rip]	# tmp125,
	jbe	.L42	#,
.L18:
# support/geolab/query.c:27:     if (!isfinite(radius_km) || radius_km < 0.0 || radius_km > GEOLAB_MAX_RADIUS_KM) return 0;
	.loc 1 27 93 discriminator 5
	mov	eax, 0	# _44,
	jmp	.L16	#
.L42:
.LBB2:
# support/geolab/query.c:28:     for (size_t i = 0; i < count; ++i) {
	.loc 1 28 17
	mov	QWORD PTR -64[rbp], 0	# i,
# support/geolab/query.c:28:     for (size_t i = 0; i < count; ++i) {
	.loc 1 28 5
	jmp	.L21	#
.L23:
# support/geolab/query.c:29:         if (!geo_valid_position(points[i].lat_deg, points[i].lon_deg)) return 0;
	.loc 1 29 58
	mov	rdx, QWORD PTR -64[rbp]	# tmp126, i
	mov	rax, rdx	# tmp127, tmp126
	add	rax, rax	# tmp127
	add	rax, rdx	# tmp127, tmp126
	sal	rax, 3	# tmp128,
	mov	rdx, rax	# _3, tmp127
	mov	rax, QWORD PTR -88[rbp]	# tmp129, points
	add	rax, rdx	# _4, _3
# support/geolab/query.c:29:         if (!geo_valid_position(points[i].lat_deg, points[i].lon_deg)) return 0;
	.loc 1 29 61
	movsd	xmm0, QWORD PTR 16[rax]	# _5, _4->lon_deg
# support/geolab/query.c:29:         if (!geo_valid_position(points[i].lat_deg, points[i].lon_deg)) return 0;
	.loc 1 29 39
	mov	rdx, QWORD PTR -64[rbp]	# tmp130, i
	mov	rax, rdx	# tmp131, tmp130
	add	rax, rax	# tmp131
	add	rax, rdx	# tmp131, tmp130
	sal	rax, 3	# tmp132,
	mov	rdx, rax	# _6, tmp131
	mov	rax, QWORD PTR -88[rbp]	# tmp133, points
	add	rax, rdx	# _7, _6
# support/geolab/query.c:29:         if (!geo_valid_position(points[i].lat_deg, points[i].lon_deg)) return 0;
	.loc 1 29 42
	mov	rax, QWORD PTR 8[rax]	# _8, _7->lat_deg
# support/geolab/query.c:29:         if (!geo_valid_position(points[i].lat_deg, points[i].lon_deg)) return 0;
	.loc 1 29 14
	movapd	xmm1, xmm0	#, _5
	movq	xmm0, rax	#, _8
	call	geo_valid_position@PLT	#
# support/geolab/query.c:29:         if (!geo_valid_position(points[i].lat_deg, points[i].lon_deg)) return 0;
	.loc 1 29 12
	test	eax, eax	# _9
	jne	.L22	#,
# support/geolab/query.c:29:         if (!geo_valid_position(points[i].lat_deg, points[i].lon_deg)) return 0;
	.loc 1 29 79 discriminator 1
	mov	eax, 0	# _44,
	jmp	.L16	#
.L22:
# support/geolab/query.c:28:     for (size_t i = 0; i < count; ++i) {
	.loc 1 28 35 discriminator 2
	add	QWORD PTR -64[rbp], 1	# i,
.L21:
# support/geolab/query.c:28:     for (size_t i = 0; i < count; ++i) {
	.loc 1 28 26 discriminator 1
	mov	rax, QWORD PTR -64[rbp]	# tmp134, i
	cmp	rax, QWORD PTR -96[rbp]	# tmp134, count
	jb	.L23	#,
.LBE2:
# support/geolab/query.c:31:     if (count == 0) {
	.loc 1 31 8
	cmp	QWORD PTR -96[rbp], 0	# count,
	jne	.L24	#,
# support/geolab/query.c:32:         *hits = NULL;
	.loc 1 32 15
	mov	rax, QWORD PTR -128[rbp]	# tmp135, hits
	mov	QWORD PTR [rax], 0	# *hits_51(D),
# support/geolab/query.c:33:         *nhits = 0;
	.loc 1 33 16
	mov	rax, QWORD PTR -136[rbp]	# tmp136, nhits
	mov	QWORD PTR [rax], 0	# *nhits_52(D),
# support/geolab/query.c:34:         return 1;
	.loc 1 34 16
	mov	eax, 1	# _44,
	jmp	.L16	#
.L24:
# support/geolab/query.c:38:     if (count > SIZE_MAX / sizeof(double)) return 0;
	.loc 1 38 8
	movabs	rax, 2305843009213693951	# tmp137,
	cmp	QWORD PTR -96[rbp], rax	# count, tmp137
	jbe	.L25	#,
# support/geolab/query.c:38:     if (count > SIZE_MAX / sizeof(double)) return 0;
	.loc 1 38 51 discriminator 1
	mov	eax, 0	# _44,
	jmp	.L16	#
.L25:
# support/geolab/query.c:39:     double *dist = malloc(count * sizeof(double));
	.loc 1 39 20
	mov	rax, QWORD PTR -96[rbp]	# tmp138, count
	sal	rax, 3	# _10,
	mov	rdi, rax	#, _10
	call	malloc@PLT	#
	mov	QWORD PTR -16[rbp], rax	# dist, tmp139
# support/geolab/query.c:40:     if (dist == NULL) return 0;
	.loc 1 40 8
	cmp	QWORD PTR -16[rbp], 0	# dist,
	jne	.L26	#,
# support/geolab/query.c:40:     if (dist == NULL) return 0;
	.loc 1 40 30 discriminator 1
	mov	eax, 0	# _44,
	jmp	.L16	#
.L26:
# support/geolab/query.c:41:     size_t selected = 0;
	.loc 1 41 12
	mov	QWORD PTR -56[rbp], 0	# selected,
.LBB3:
# support/geolab/query.c:42:     for (size_t i = 0; i < count; ++i) {
	.loc 1 42 17
	mov	QWORD PTR -48[rbp], 0	# i,
# support/geolab/query.c:42:     for (size_t i = 0; i < count; ++i) {
	.loc 1 42 5
	jmp	.L27	#
.L31:
.LBB4:
# support/geolab/query.c:43:         double d = 0.0;
	.loc 1 43 16
	pxor	xmm0, xmm0	# tmp140
	movsd	QWORD PTR -72[rbp], xmm0	# d, tmp140
# support/geolab/query.c:44:         if (!geo_distance_km(lat, lon, points[i].lat_deg, points[i].lon_deg, &d)) { /* unreachable after validation */
	.loc 1 44 65
	mov	rdx, QWORD PTR -48[rbp]	# tmp141, i
	mov	rax, rdx	# tmp142, tmp141
	add	rax, rax	# tmp142
	add	rax, rdx	# tmp142, tmp141
	sal	rax, 3	# tmp143,
	mov	rdx, rax	# _11, tmp142
	mov	rax, QWORD PTR -88[rbp]	# tmp144, points
	add	rax, rdx	# _12, _11
# support/geolab/query.c:44:         if (!geo_distance_km(lat, lon, points[i].lat_deg, points[i].lon_deg, &d)) { /* unreachable after validation */
	.loc 1 44 68
	movsd	xmm2, QWORD PTR 16[rax]	# _13, _12->lon_deg
# support/geolab/query.c:44:         if (!geo_distance_km(lat, lon, points[i].lat_deg, points[i].lon_deg, &d)) { /* unreachable after validation */
	.loc 1 44 46
	mov	rdx, QWORD PTR -48[rbp]	# tmp145, i
	mov	rax, rdx	# tmp146, tmp145
	add	rax, rax	# tmp146
	add	rax, rdx	# tmp146, tmp145
	sal	rax, 3	# tmp147,
	mov	rdx, rax	# _14, tmp146
	mov	rax, QWORD PTR -88[rbp]	# tmp148, points
	add	rax, rdx	# _15, _14
# support/geolab/query.c:44:         if (!geo_distance_km(lat, lon, points[i].lat_deg, points[i].lon_deg, &d)) { /* unreachable after validation */
	.loc 1 44 49
	movsd	xmm1, QWORD PTR 8[rax]	# _16, _15->lat_deg
# support/geolab/query.c:44:         if (!geo_distance_km(lat, lon, points[i].lat_deg, points[i].lon_deg, &d)) { /* unreachable after validation */
	.loc 1 44 14
	lea	rdx, -72[rbp]	# tmp149,
	movsd	xmm0, QWORD PTR -112[rbp]	# tmp150, lon
	mov	rax, QWORD PTR -104[rbp]	# tmp151, lat
	mov	rdi, rdx	#, tmp149
	movapd	xmm3, xmm2	#, _13
	movapd	xmm2, xmm1	#, _16
	movapd	xmm1, xmm0	#, tmp150
	movq	xmm0, rax	#, tmp151
	call	geo_distance_km@PLT	#
# support/geolab/query.c:44:         if (!geo_distance_km(lat, lon, points[i].lat_deg, points[i].lon_deg, &d)) { /* unreachable after validation */
	.loc 1 44 12
	test	eax, eax	# _17
	jne	.L28	#,
# support/geolab/query.c:45:             free(dist);
	.loc 1 45 13
	mov	rax, QWORD PTR -16[rbp]	# tmp152, dist
	mov	rdi, rax	#, tmp152
	call	free@PLT	#
# support/geolab/query.c:46:             return 0;
	.loc 1 46 20
	mov	eax, 0	# _44,
	jmp	.L16	#
.L28:
# support/geolab/query.c:48:         dist[i] = d;
	.loc 1 48 13
	mov	rax, QWORD PTR -48[rbp]	# tmp153, i
	lea	rdx, 0[0+rax*8]	# _18,
	mov	rax, QWORD PTR -16[rbp]	# tmp154, dist
	add	rax, rdx	# _19, _18
# support/geolab/query.c:48:         dist[i] = d;
	.loc 1 48 17
	movsd	xmm0, QWORD PTR -72[rbp]	# d.0_20, d
	movsd	QWORD PTR [rax], xmm0	# *_19, d.0_20
# support/geolab/query.c:49:         if (d <= radius_km) ++selected; /* inclusive: the unrounded distance against the parsed radius */
	.loc 1 49 15
	movsd	xmm1, QWORD PTR -72[rbp]	# d.1_21, d
# support/geolab/query.c:49:         if (d <= radius_km) ++selected; /* inclusive: the unrounded distance against the parsed radius */
	.loc 1 49 12
	movsd	xmm0, QWORD PTR -120[rbp]	# tmp155, radius_km
	comisd	xmm0, xmm1	# tmp155, d.1_21
	jb	.L29	#,
# support/geolab/query.c:49:         if (d <= radius_km) ++selected; /* inclusive: the unrounded distance against the parsed radius */
	.loc 1 49 29 discriminator 1
	add	QWORD PTR -56[rbp], 1	# selected,
.L29:
.LBE4:
# support/geolab/query.c:42:     for (size_t i = 0; i < count; ++i) {
	.loc 1 42 35
	add	QWORD PTR -48[rbp], 1	# i,
.L27:
# support/geolab/query.c:42:     for (size_t i = 0; i < count; ++i) {
	.loc 1 42 26 discriminator 1
	mov	rax, QWORD PTR -48[rbp]	# tmp156, i
	cmp	rax, QWORD PTR -96[rbp]	# tmp156, count
	jb	.L31	#,
.LBE3:
# support/geolab/query.c:52:     QueryHit *out = NULL;
	.loc 1 52 15
	mov	QWORD PTR -40[rbp], 0	# out,
# support/geolab/query.c:53:     if (selected > 0) {
	.loc 1 53 8
	cmp	QWORD PTR -56[rbp], 0	# selected,
	je	.L32	#,
.LBB5:
# support/geolab/query.c:54:         if (selected > SIZE_MAX / sizeof(QueryHit)) {
	.loc 1 54 12
	movabs	rax, 1152921504606846975	# tmp157,
	cmp	QWORD PTR -56[rbp], rax	# selected, tmp157
	jbe	.L33	#,
# support/geolab/query.c:55:             free(dist);
	.loc 1 55 13
	mov	rax, QWORD PTR -16[rbp]	# tmp158, dist
	mov	rdi, rax	#, tmp158
	call	free@PLT	#
# support/geolab/query.c:56:             return 0;
	.loc 1 56 20
	mov	eax, 0	# _44,
	jmp	.L16	#
.L33:
# support/geolab/query.c:58:         out = malloc(selected * sizeof(QueryHit));
	.loc 1 58 15
	mov	rax, QWORD PTR -56[rbp]	# tmp159, selected
	sal	rax, 4	# _22,
	mov	rdi, rax	#, _22
	call	malloc@PLT	#
	mov	QWORD PTR -40[rbp], rax	# out, tmp160
# support/geolab/query.c:59:         if (out == NULL) {
	.loc 1 59 12
	cmp	QWORD PTR -40[rbp], 0	# out,
	jne	.L34	#,
# support/geolab/query.c:60:             free(dist);
	.loc 1 60 13
	mov	rax, QWORD PTR -16[rbp]	# tmp161, dist
	mov	rdi, rax	#, tmp161
	call	free@PLT	#
# support/geolab/query.c:61:             return 0;
	.loc 1 61 20
	mov	eax, 0	# _44,
	jmp	.L16	#
.L34:
# support/geolab/query.c:63:         size_t k = 0;
	.loc 1 63 16
	mov	QWORD PTR -32[rbp], 0	# k,
.LBB6:
# support/geolab/query.c:64:         for (size_t i = 0; i < count; ++i) {
	.loc 1 64 21
	mov	QWORD PTR -24[rbp], 0	# i,
# support/geolab/query.c:64:         for (size_t i = 0; i < count; ++i) {
	.loc 1 64 9
	jmp	.L35	#
.L38:
# support/geolab/query.c:65:             if (dist[i] <= radius_km) {
	.loc 1 65 21
	mov	rax, QWORD PTR -24[rbp]	# tmp162, i
	lea	rdx, 0[0+rax*8]	# _23,
	mov	rax, QWORD PTR -16[rbp]	# tmp163, dist
	add	rax, rdx	# _24, _23
	movsd	xmm1, QWORD PTR [rax]	# _25, *_24
# support/geolab/query.c:65:             if (dist[i] <= radius_km) {
	.loc 1 65 16
	movsd	xmm0, QWORD PTR -120[rbp]	# tmp164, radius_km
	comisd	xmm0, xmm1	# tmp164, _25
	jb	.L36	#,
# support/geolab/query.c:66:                 out[k].id = points[i].id;
	.loc 1 66 35
	mov	rdx, QWORD PTR -24[rbp]	# tmp165, i
	mov	rax, rdx	# tmp166, tmp165
	add	rax, rax	# tmp166
	add	rax, rdx	# tmp166, tmp165
	sal	rax, 3	# tmp167,
	mov	rdx, rax	# _26, tmp166
	mov	rax, QWORD PTR -88[rbp]	# tmp168, points
	add	rax, rdx	# _27, _26
# support/geolab/query.c:66:                 out[k].id = points[i].id;
	.loc 1 66 20
	mov	rdx, QWORD PTR -32[rbp]	# tmp169, k
	mov	rcx, rdx	# tmp169, tmp169
	sal	rcx, 4	# tmp169,
	mov	rdx, QWORD PTR -40[rbp]	# tmp170, out
	add	rdx, rcx	# _29, _28
# support/geolab/query.c:66:                 out[k].id = points[i].id;
	.loc 1 66 38
	mov	rax, QWORD PTR [rax]	# _30, _27->id
# support/geolab/query.c:66:                 out[k].id = points[i].id;
	.loc 1 66 27
	mov	QWORD PTR [rdx], rax	# _29->id, _30
# support/geolab/query.c:67:                 out[k].distance_km = dist[i];
	.loc 1 67 42
	mov	rax, QWORD PTR -24[rbp]	# tmp171, i
	lea	rdx, 0[0+rax*8]	# _31,
	mov	rax, QWORD PTR -16[rbp]	# tmp172, dist
	add	rdx, rax	# _32, tmp172
# support/geolab/query.c:67:                 out[k].distance_km = dist[i];
	.loc 1 67 20
	mov	rax, QWORD PTR -32[rbp]	# tmp173, k
	sal	rax, 4	# tmp173,
	mov	rcx, rax	# _33, tmp173
	mov	rax, QWORD PTR -40[rbp]	# tmp174, out
	add	rax, rcx	# _34, _33
# support/geolab/query.c:67:                 out[k].distance_km = dist[i];
	.loc 1 67 42
	movsd	xmm0, QWORD PTR [rdx]	# _35, *_32
# support/geolab/query.c:67:                 out[k].distance_km = dist[i];
	.loc 1 67 36
	movsd	QWORD PTR 8[rax], xmm0	# _34->distance_km, _35
# support/geolab/query.c:68:                 ++k;
	.loc 1 68 17
	add	QWORD PTR -32[rbp], 1	# k,
.L36:
# support/geolab/query.c:64:         for (size_t i = 0; i < count; ++i) {
	.loc 1 64 39 discriminator 2
	add	QWORD PTR -24[rbp], 1	# i,
.L35:
# support/geolab/query.c:64:         for (size_t i = 0; i < count; ++i) {
	.loc 1 64 30 discriminator 1
	mov	rax, QWORD PTR -24[rbp]	# tmp175, i
	cmp	rax, QWORD PTR -96[rbp]	# tmp175, count
	jb	.L38	#,
.LBE6:
# support/geolab/query.c:72:         qsort(out, selected, sizeof *out, query_hit_compare);
	.loc 1 72 9
	mov	rsi, QWORD PTR -56[rbp]	# tmp176, selected
	mov	rax, QWORD PTR -40[rbp]	# tmp177, out
	lea	rdx, query_hit_compare[rip]	# tmp178,
	mov	rcx, rdx	#, tmp178
	mov	edx, 16	#,
	mov	rdi, rax	#, tmp177
	call	qsort@PLT	#
.L32:
.LBE5:
# support/geolab/query.c:74:     free(dist);
	.loc 1 74 5
	mov	rax, QWORD PTR -16[rbp]	# tmp179, dist
	mov	rdi, rax	#, tmp179
	call	free@PLT	#
# support/geolab/query.c:76:     *hits = out;
	.loc 1 76 11
	mov	rax, QWORD PTR -128[rbp]	# tmp180, hits
	mov	rdx, QWORD PTR -40[rbp]	# tmp181, out
	mov	QWORD PTR [rax], rdx	# *hits_51(D), tmp181
# support/geolab/query.c:77:     *nhits = selected;
	.loc 1 77 12
	mov	rax, QWORD PTR -136[rbp]	# tmp182, nhits
	mov	rdx, QWORD PTR -56[rbp]	# tmp183, selected
	mov	QWORD PTR [rax], rdx	# *nhits_52(D), tmp183
# support/geolab/query.c:78:     return 1;
	.loc 1 78 12
	mov	eax, 1	# _44,
.L16:
# support/geolab/query.c:79: }
	.loc 1 79 1
	mov	rdx, QWORD PTR -8[rbp]	# tmp186, D.3232
	sub	rdx, QWORD PTR fs:40	# tmp186, MEM[(<address-space-1> long unsigned int *)40B]
	je	.L39	#,
	call	__stack_chk_fail@PLT	#
.L39:
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE2:
	.size	query_points, .-query_points
	.section	.rodata
	.align 16
.LC0:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
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
	.long	0x3c0
	.value	0x4
	.long	.Ldebug_abbrev0
	.byte	0x8
	.uleb128 0x1
	.long	.LASF35
	.byte	0xc
	.long	.LASF36
	.long	.LASF37
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
	.uleb128 0x4
	.long	.LASF10
	.byte	0x2
	.byte	0x2d
	.byte	0x1b
	.long	0x42
	.uleb128 0x5
	.byte	0x8
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
	.uleb128 0x4
	.long	.LASF11
	.byte	0x3
	.byte	0x1b
	.byte	0x14
	.long	0x65
	.uleb128 0x4
	.long	.LASF12
	.byte	0x4
	.byte	0xd1
	.byte	0x17
	.long	0x42
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
	.long	0x57
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
	.long	0x81
	.byte	0x8
	.uleb128 0xd
	.long	.LASF17
	.byte	0x6
	.byte	0x8
	.byte	0x36
	.long	0x81
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
	.long	0x81
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
	.long	0x71
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
	.long	0x71
	.byte	0
	.uleb128 0x10
	.long	.LASF23
	.byte	0x7
	.byte	0x26
	.byte	0x5
	.long	0x57
	.long	0x1b0
	.uleb128 0x9
	.long	0x81
	.uleb128 0x9
	.long	0x81
	.uleb128 0x9
	.long	0x81
	.uleb128 0x9
	.long	0x81
	.uleb128 0x9
	.long	0x1b0
	.byte	0
	.uleb128 0x7
	.byte	0x8
	.long	0x81
	.uleb128 0x11
	.long	.LASF24
	.byte	0x5
	.value	0x21c
	.byte	0xe
	.long	0x71
	.long	0x1cd
	.uleb128 0x9
	.long	0x94
	.byte	0
	.uleb128 0x10
	.long	.LASF25
	.byte	0x7
	.byte	0x22
	.byte	0x5
	.long	0x57
	.long	0x1e8
	.uleb128 0x9
	.long	0x81
	.uleb128 0x9
	.long	0x81
	.byte	0
	.uleb128 0x12
	.long	.LASF33
	.byte	0x1
	.byte	0x15
	.byte	0x5
	.long	0x57
	.quad	.LFB2
	.quad	.LFE2-.LFB2
	.uleb128 0x1
	.byte	0x9c
	.long	0x34e
	.uleb128 0x13
	.long	.LASF26
	.byte	0x1
	.byte	0x15
	.byte	0x22
	.long	0x34e
	.uleb128 0x3
	.byte	0x91
	.sleb128 -104
	.uleb128 0x13
	.long	.LASF27
	.byte	0x1
	.byte	0x15
	.byte	0x31
	.long	0x94
	.uleb128 0x3
	.byte	0x91
	.sleb128 -112
	.uleb128 0x14
	.string	"lat"
	.byte	0x1
	.byte	0x15
	.byte	0x3f
	.long	0x81
	.uleb128 0x3
	.byte	0x91
	.sleb128 -120
	.uleb128 0x14
	.string	"lon"
	.byte	0x1
	.byte	0x15
	.byte	0x4b
	.long	0x81
	.uleb128 0x3
	.byte	0x91
	.sleb128 -128
	.uleb128 0x13
	.long	.LASF28
	.byte	0x1
	.byte	0x15
	.byte	0x57
	.long	0x81
	.uleb128 0x3
	.byte	0x91
	.sleb128 -136
	.uleb128 0x13
	.long	.LASF29
	.byte	0x1
	.byte	0x15
	.byte	0x6d
	.long	0x354
	.uleb128 0x3
	.byte	0x91
	.sleb128 -144
	.uleb128 0x13
	.long	.LASF30
	.byte	0x1
	.byte	0x16
	.byte	0x1a
	.long	0x360
	.uleb128 0x3
	.byte	0x91
	.sleb128 -152
	.uleb128 0x15
	.long	.LASF31
	.byte	0x1
	.byte	0x27
	.byte	0xd
	.long	0x1b0
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x15
	.long	.LASF32
	.byte	0x1
	.byte	0x29
	.byte	0xc
	.long	0x94
	.uleb128 0x3
	.byte	0x91
	.sleb128 -72
	.uleb128 0x16
	.string	"out"
	.byte	0x1
	.byte	0x34
	.byte	0xf
	.long	0x35a
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x17
	.quad	.LBB2
	.quad	.LBE2-.LBB2
	.long	0x2cc
	.uleb128 0x16
	.string	"i"
	.byte	0x1
	.byte	0x1c
	.byte	0x11
	.long	0x94
	.uleb128 0x3
	.byte	0x91
	.sleb128 -80
	.byte	0
	.uleb128 0x17
	.quad	.LBB3
	.quad	.LBE3-.LBB3
	.long	0x30f
	.uleb128 0x16
	.string	"i"
	.byte	0x1
	.byte	0x2a
	.byte	0x11
	.long	0x94
	.uleb128 0x2
	.byte	0x91
	.sleb128 -64
	.uleb128 0x18
	.quad	.LBB4
	.quad	.LBE4-.LBB4
	.uleb128 0x16
	.string	"d"
	.byte	0x1
	.byte	0x2b
	.byte	0x10
	.long	0x81
	.uleb128 0x3
	.byte	0x91
	.sleb128 -88
	.byte	0
	.byte	0
	.uleb128 0x18
	.quad	.LBB5
	.quad	.LBE5-.LBB5
	.uleb128 0x16
	.string	"k"
	.byte	0x1
	.byte	0x3f
	.byte	0x10
	.long	0x94
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x18
	.quad	.LBB6
	.quad	.LBE6-.LBB6
	.uleb128 0x16
	.string	"i"
	.byte	0x1
	.byte	0x40
	.byte	0x15
	.long	0x94
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x7
	.byte	0x8
	.long	0x118
	.uleb128 0x7
	.byte	0x8
	.long	0x35a
	.uleb128 0x7
	.byte	0x8
	.long	0x140
	.uleb128 0x7
	.byte	0x8
	.long	0x94
	.uleb128 0x19
	.long	.LASF34
	.byte	0x1
	.byte	0xb
	.byte	0x5
	.long	0x57
	.quad	.LFB1
	.quad	.LFE1-.LFB1
	.uleb128 0x1
	.byte	0x9c
	.long	0x3bd
	.uleb128 0x14
	.string	"a"
	.byte	0x1
	.byte	0xb
	.byte	0x23
	.long	0xce
	.uleb128 0x2
	.byte	0x91
	.sleb128 -40
	.uleb128 0x14
	.string	"b"
	.byte	0x1
	.byte	0xb
	.byte	0x32
	.long	0xce
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x16
	.string	"x"
	.byte	0x1
	.byte	0xd
	.byte	0x15
	.long	0x3bd
	.uleb128 0x2
	.byte	0x91
	.sleb128 -32
	.uleb128 0x16
	.string	"y"
	.byte	0x1
	.byte	0xd
	.byte	0x1d
	.long	0x3bd
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.uleb128 0x7
	.byte	0x8
	.long	0x14c
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
	.uleb128 0x2116
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
	.uleb128 0x18
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
	.uleb128 0x18
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
	.uleb128 0x18
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
	.uleb128 0x18
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
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.byte	0
	.byte	0
	.uleb128 0x19
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
.LASF12:
	.string	"size_t"
.LASF33:
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
.LASF34:
	.string	"query_hit_compare"
.LASF8:
	.string	"float"
.LASF21:
	.string	"qsort"
.LASF0:
	.string	"unsigned char"
.LASF25:
	.string	"geo_valid_position"
.LASF3:
	.string	"long unsigned int"
.LASF1:
	.string	"short unsigned int"
.LASF35:
	.string	"GNU C11 11.4.0 -masm=intel -mtune=generic -march=x86-64 -g -gdwarf-4 -O0 -std=c11 -ffp-contract=off -fno-lto -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection"
.LASF9:
	.string	"double"
.LASF17:
	.string	"lon_deg"
.LASF5:
	.string	"short int"
.LASF18:
	.string	"GeoPoint"
.LASF37:
	.string	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11"
.LASF2:
	.string	"unsigned int"
.LASF19:
	.string	"distance_km"
.LASF7:
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
.LASF6:
	.string	"long int"
.LASF10:
	.string	"__uint64_t"
.LASF36:
	.string	"support/geolab/query.c"
.LASF4:
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
