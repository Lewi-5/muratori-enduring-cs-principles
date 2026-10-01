	.text
	.intel_syntax noprefix
	.file	"query.c"
	.globl	query_hit_compare               # -- Begin function query_hit_compare
	.p2align	4, 0x90
	.type	query_hit_compare,@function
query_hit_compare:                      # @query_hit_compare
.Lfunc_begin0:
	.file	1 "/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" "support/geolab/query.c"
	.loc	1 12 0                          # support/geolab/query.c:12:0
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	mov	qword ptr [rbp - 16], rdi
	mov	qword ptr [rbp - 24], rsi
.Ltmp0:
	.loc	1 13 25 prologue_end            # support/geolab/query.c:13:25
	mov	rax, qword ptr [rbp - 16]
	.loc	1 13 21 is_stmt 0               # support/geolab/query.c:13:21
	mov	qword ptr [rbp - 32], rax
	.loc	1 13 33                         # support/geolab/query.c:13:33
	mov	rax, qword ptr [rbp - 24]
	.loc	1 13 29                         # support/geolab/query.c:13:29
	mov	qword ptr [rbp - 40], rax
.Ltmp1:
	.loc	1 14 9 is_stmt 1                # support/geolab/query.c:14:9
	mov	rax, qword ptr [rbp - 32]
	.loc	1 14 12 is_stmt 0               # support/geolab/query.c:14:12
	movsd	xmm1, qword ptr [rax + 8]       # xmm1 = mem[0],zero
	.loc	1 14 26                         # support/geolab/query.c:14:26
	mov	rax, qword ptr [rbp - 40]
	.loc	1 14 29                         # support/geolab/query.c:14:29
	movsd	xmm0, qword ptr [rax + 8]       # xmm0 = mem[0],zero
	.loc	1 14 24                         # support/geolab/query.c:14:24
	ucomisd	xmm0, xmm1
.Ltmp2:
	.loc	1 14 9                          # support/geolab/query.c:14:9
	jbe	.LBB0_2
# %bb.1:
.Ltmp3:
	.loc	1 14 42                         # support/geolab/query.c:14:42
	mov	dword ptr [rbp - 4], -1
	jmp	.LBB0_9
.Ltmp4:
.LBB0_2:
	.loc	1 15 9 is_stmt 1                # support/geolab/query.c:15:9
	mov	rax, qword ptr [rbp - 32]
	.loc	1 15 12 is_stmt 0               # support/geolab/query.c:15:12
	movsd	xmm0, qword ptr [rax + 8]       # xmm0 = mem[0],zero
	.loc	1 15 26                         # support/geolab/query.c:15:26
	mov	rax, qword ptr [rbp - 40]
	.loc	1 15 24                         # support/geolab/query.c:15:24
	ucomisd	xmm0, qword ptr [rax + 8]
.Ltmp5:
	.loc	1 15 9                          # support/geolab/query.c:15:9
	jbe	.LBB0_4
# %bb.3:
.Ltmp6:
	.loc	1 15 42                         # support/geolab/query.c:15:42
	mov	dword ptr [rbp - 4], 1
	jmp	.LBB0_9
.Ltmp7:
.LBB0_4:
	.loc	1 16 9 is_stmt 1                # support/geolab/query.c:16:9
	mov	rax, qword ptr [rbp - 32]
	.loc	1 16 12 is_stmt 0               # support/geolab/query.c:16:12
	mov	rax, qword ptr [rax]
	.loc	1 16 17                         # support/geolab/query.c:16:17
	mov	rcx, qword ptr [rbp - 40]
	.loc	1 16 15                         # support/geolab/query.c:16:15
	cmp	rax, qword ptr [rcx]
.Ltmp8:
	.loc	1 16 9                          # support/geolab/query.c:16:9
	jae	.LBB0_6
# %bb.5:
.Ltmp9:
	.loc	1 16 24                         # support/geolab/query.c:16:24
	mov	dword ptr [rbp - 4], -1
	jmp	.LBB0_9
.Ltmp10:
.LBB0_6:
	.loc	1 17 9 is_stmt 1                # support/geolab/query.c:17:9
	mov	rax, qword ptr [rbp - 32]
	.loc	1 17 12 is_stmt 0               # support/geolab/query.c:17:12
	mov	rax, qword ptr [rax]
	.loc	1 17 17                         # support/geolab/query.c:17:17
	mov	rcx, qword ptr [rbp - 40]
	.loc	1 17 15                         # support/geolab/query.c:17:15
	cmp	rax, qword ptr [rcx]
.Ltmp11:
	.loc	1 17 9                          # support/geolab/query.c:17:9
	jbe	.LBB0_8
# %bb.7:
.Ltmp12:
	.loc	1 17 24                         # support/geolab/query.c:17:24
	mov	dword ptr [rbp - 4], 1
	jmp	.LBB0_9
.Ltmp13:
.LBB0_8:
	.loc	1 18 5 is_stmt 1                # support/geolab/query.c:18:5
	mov	dword ptr [rbp - 4], 0
.LBB0_9:
	.loc	1 19 1                          # support/geolab/query.c:19:1
	mov	eax, dword ptr [rbp - 4]
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Ltmp14:
.Lfunc_end0:
	.size	query_hit_compare, .Lfunc_end0-query_hit_compare
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3                               # -- Begin function query_points
.LCPI1_0:
	.quad	0x7ff0000000000000              # double +Inf
.LCPI1_2:
	.quad	0x40f86a0000000000              # double 1.0E+5
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.LCPI1_1:
	.quad	0x7fffffffffffffff              # double NaN
	.quad	0x7fffffffffffffff              # double NaN
	.text
	.globl	query_points
	.p2align	4, 0x90
	.type	query_points,@function
query_points:                           # @query_points
.Lfunc_begin1:
	.loc	1 23 0                          # support/geolab/query.c:23:0
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	sub	rsp, 128
	mov	qword ptr [rbp - 16], rdi
	mov	qword ptr [rbp - 24], rsi
	movsd	qword ptr [rbp - 32], xmm0
	movsd	qword ptr [rbp - 40], xmm1
	movsd	qword ptr [rbp - 48], xmm2
	mov	qword ptr [rbp - 56], rdx
	mov	qword ptr [rbp - 64], rcx
.Ltmp15:
	.loc	1 25 14 prologue_end            # support/geolab/query.c:25:14
	cmp	qword ptr [rbp - 56], 0
	.loc	1 25 22 is_stmt 0               # support/geolab/query.c:25:22
	je	.LBB1_4
# %bb.1:
	.loc	1 25 31                         # support/geolab/query.c:25:31
	cmp	qword ptr [rbp - 64], 0
	.loc	1 25 39                         # support/geolab/query.c:25:39
	je	.LBB1_4
# %bb.2:
	.loc	1 25 50                         # support/geolab/query.c:25:50
	cmp	qword ptr [rbp - 16], 0
	.loc	1 25 58                         # support/geolab/query.c:25:58
	jne	.LBB1_5
# %bb.3:
	.loc	1 25 67                         # support/geolab/query.c:25:67
	cmp	qword ptr [rbp - 24], 0
.Ltmp16:
	.loc	1 25 9                          # support/geolab/query.c:25:9
	jbe	.LBB1_5
.LBB1_4:
.Ltmp17:
	.loc	1 25 73                         # support/geolab/query.c:25:73
	mov	dword ptr [rbp - 4], 0
	jmp	.LBB1_44
.Ltmp18:
.LBB1_5:
	.loc	1 26 29 is_stmt 1               # support/geolab/query.c:26:29
	movsd	xmm0, qword ptr [rbp - 32]      # xmm0 = mem[0],zero
	.loc	1 26 34 is_stmt 0               # support/geolab/query.c:26:34
	movsd	xmm1, qword ptr [rbp - 40]      # xmm1 = mem[0],zero
	.loc	1 26 10                         # support/geolab/query.c:26:10
	call	geo_valid_position@PLT
	cmp	eax, 0
.Ltmp19:
	.loc	1 26 9                          # support/geolab/query.c:26:9
	jne	.LBB1_7
# %bb.6:
.Ltmp20:
	.loc	1 26 40                         # support/geolab/query.c:26:40
	mov	dword ptr [rbp - 4], 0
	jmp	.LBB1_44
.Ltmp21:
.LBB1_7:
	.loc	1 27 10 is_stmt 1               # support/geolab/query.c:27:10
	movsd	xmm0, qword ptr [rbp - 48]      # xmm0 = mem[0],zero
	movaps	xmm1, xmmword ptr [rip + .LCPI1_1] # xmm1 = [NaN,NaN]
	pand	xmm0, xmm1
	.loc	1 27 30 is_stmt 0               # support/geolab/query.c:27:30
	movsd	xmm1, qword ptr [rip + .LCPI1_0] # xmm1 = mem[0],zero
	.loc	1 27 10                         # support/geolab/query.c:27:10
	ucomisd	xmm0, xmm1
	.loc	1 27 30                         # support/geolab/query.c:27:30
	je	.LBB1_10
# %bb.8:
	.loc	1 27 49                         # support/geolab/query.c:27:49
	xorps	xmm0, xmm0
	.loc	1 27 43                         # support/geolab/query.c:27:43
	ucomisd	xmm0, qword ptr [rbp - 48]
	.loc	1 27 49                         # support/geolab/query.c:27:49
	ja	.LBB1_10
# %bb.9:
	.loc	1 27 52                         # support/geolab/query.c:27:52
	movsd	xmm0, qword ptr [rbp - 48]      # xmm0 = mem[0],zero
.Ltmp22:
	.loc	1 27 9                          # support/geolab/query.c:27:9
	movsd	xmm1, qword ptr [rip + .LCPI1_2] # xmm1 = mem[0],zero
.Ltmp23:
	.loc	1 27 62                         # support/geolab/query.c:27:62
	ucomisd	xmm0, xmm1
.Ltmp24:
	.loc	1 27 9                          # support/geolab/query.c:27:9
	jbe	.LBB1_11
.LBB1_10:
.Ltmp25:
	.loc	1 27 86                         # support/geolab/query.c:27:86
	mov	dword ptr [rbp - 4], 0
	jmp	.LBB1_44
.Ltmp26:
.LBB1_11:
	.loc	1 28 17 is_stmt 1               # support/geolab/query.c:28:17
	mov	qword ptr [rbp - 72], 0
.LBB1_12:                               # =>This Inner Loop Header: Depth=1
.Ltmp27:
	.loc	1 28 24 is_stmt 0               # support/geolab/query.c:28:24
	mov	rax, qword ptr [rbp - 72]
	.loc	1 28 26                         # support/geolab/query.c:28:26
	cmp	rax, qword ptr [rbp - 24]
.Ltmp28:
	.loc	1 28 5                          # support/geolab/query.c:28:5
	jae	.LBB1_17
# %bb.13:                               #   in Loop: Header=BB1_12 Depth=1
.Ltmp29:
	.loc	1 29 33 is_stmt 1               # support/geolab/query.c:29:33
	mov	rax, qword ptr [rbp - 16]
	imul	rcx, qword ptr [rbp - 72], 24
	add	rax, rcx
	.loc	1 29 43 is_stmt 0               # support/geolab/query.c:29:43
	movsd	xmm0, qword ptr [rax + 8]       # xmm0 = mem[0],zero
	.loc	1 29 52                         # support/geolab/query.c:29:52
	mov	rax, qword ptr [rbp - 16]
	imul	rcx, qword ptr [rbp - 72], 24
	add	rax, rcx
	.loc	1 29 62                         # support/geolab/query.c:29:62
	movsd	xmm1, qword ptr [rax + 16]      # xmm1 = mem[0],zero
	.loc	1 29 14                         # support/geolab/query.c:29:14
	call	geo_valid_position@PLT
	cmp	eax, 0
.Ltmp30:
	.loc	1 29 13                         # support/geolab/query.c:29:13
	jne	.LBB1_15
# %bb.14:
.Ltmp31:
	.loc	1 29 72                         # support/geolab/query.c:29:72
	mov	dword ptr [rbp - 4], 0
	jmp	.LBB1_44
.Ltmp32:
.LBB1_15:                               #   in Loop: Header=BB1_12 Depth=1
	.loc	1 30 5 is_stmt 1                # support/geolab/query.c:30:5
	jmp	.LBB1_16
.Ltmp33:
.LBB1_16:                               #   in Loop: Header=BB1_12 Depth=1
	.loc	1 28 35                         # support/geolab/query.c:28:35
	mov	rax, qword ptr [rbp - 72]
	add	rax, 1
	mov	qword ptr [rbp - 72], rax
	.loc	1 28 5 is_stmt 0                # support/geolab/query.c:28:5
	jmp	.LBB1_12
.Ltmp34:
.LBB1_17:
	.loc	1 31 15 is_stmt 1               # support/geolab/query.c:31:15
	cmp	qword ptr [rbp - 24], 0
.Ltmp35:
	.loc	1 31 9 is_stmt 0                # support/geolab/query.c:31:9
	jne	.LBB1_19
# %bb.18:
.Ltmp36:
	.loc	1 32 10 is_stmt 1               # support/geolab/query.c:32:10
	mov	rax, qword ptr [rbp - 56]
	.loc	1 32 15 is_stmt 0               # support/geolab/query.c:32:15
	mov	qword ptr [rax], 0
	.loc	1 33 10 is_stmt 1               # support/geolab/query.c:33:10
	mov	rax, qword ptr [rbp - 64]
	.loc	1 33 16 is_stmt 0               # support/geolab/query.c:33:16
	mov	qword ptr [rax], 0
	.loc	1 34 9 is_stmt 1                # support/geolab/query.c:34:9
	mov	dword ptr [rbp - 4], 1
	jmp	.LBB1_44
.Ltmp37:
.LBB1_19:
	.loc	1 38 9                          # support/geolab/query.c:38:9
	movabs	rax, 2305843009213693951
.Ltmp38:
	.loc	1 38 15 is_stmt 0               # support/geolab/query.c:38:15
	cmp	qword ptr [rbp - 24], rax
.Ltmp39:
	.loc	1 38 9                          # support/geolab/query.c:38:9
	jbe	.LBB1_21
# %bb.20:
.Ltmp40:
	.loc	1 38 44                         # support/geolab/query.c:38:44
	mov	dword ptr [rbp - 4], 0
	jmp	.LBB1_44
.Ltmp41:
.LBB1_21:
	.loc	1 39 27 is_stmt 1               # support/geolab/query.c:39:27
	mov	rdi, qword ptr [rbp - 24]
	.loc	1 39 33 is_stmt 0               # support/geolab/query.c:39:33
	shl	rdi, 3
	.loc	1 39 20                         # support/geolab/query.c:39:20
	call	malloc@PLT
	.loc	1 39 13                         # support/geolab/query.c:39:13
	mov	qword ptr [rbp - 80], rax
.Ltmp42:
	.loc	1 40 14 is_stmt 1               # support/geolab/query.c:40:14
	cmp	qword ptr [rbp - 80], 0
.Ltmp43:
	.loc	1 40 9 is_stmt 0                # support/geolab/query.c:40:9
	jne	.LBB1_23
# %bb.22:
.Ltmp44:
	.loc	1 40 23                         # support/geolab/query.c:40:23
	mov	dword ptr [rbp - 4], 0
	jmp	.LBB1_44
.Ltmp45:
.LBB1_23:
	.loc	1 41 12 is_stmt 1               # support/geolab/query.c:41:12
	mov	qword ptr [rbp - 88], 0
.Ltmp46:
	.loc	1 42 17                         # support/geolab/query.c:42:17
	mov	qword ptr [rbp - 96], 0
.LBB1_24:                               # =>This Inner Loop Header: Depth=1
.Ltmp47:
	.loc	1 42 24 is_stmt 0               # support/geolab/query.c:42:24
	mov	rax, qword ptr [rbp - 96]
	.loc	1 42 26                         # support/geolab/query.c:42:26
	cmp	rax, qword ptr [rbp - 24]
.Ltmp48:
	.loc	1 42 5                          # support/geolab/query.c:42:5
	jae	.LBB1_31
# %bb.25:                               #   in Loop: Header=BB1_24 Depth=1
.Ltmp49:
	.loc	1 43 16 is_stmt 1               # support/geolab/query.c:43:16
	xorps	xmm0, xmm0
	movsd	qword ptr [rbp - 104], xmm0
.Ltmp50:
	.loc	1 44 30                         # support/geolab/query.c:44:30
	movsd	xmm0, qword ptr [rbp - 32]      # xmm0 = mem[0],zero
	.loc	1 44 35 is_stmt 0               # support/geolab/query.c:44:35
	movsd	xmm1, qword ptr [rbp - 40]      # xmm1 = mem[0],zero
	.loc	1 44 40                         # support/geolab/query.c:44:40
	mov	rax, qword ptr [rbp - 16]
	imul	rcx, qword ptr [rbp - 96], 24
	add	rax, rcx
	.loc	1 44 50                         # support/geolab/query.c:44:50
	movsd	xmm2, qword ptr [rax + 8]       # xmm2 = mem[0],zero
	.loc	1 44 59                         # support/geolab/query.c:44:59
	mov	rax, qword ptr [rbp - 16]
	imul	rcx, qword ptr [rbp - 96], 24
	add	rax, rcx
	.loc	1 44 69                         # support/geolab/query.c:44:69
	movsd	xmm3, qword ptr [rax + 16]      # xmm3 = mem[0],zero
	.loc	1 44 14                         # support/geolab/query.c:44:14
	lea	rdi, [rbp - 104]
	call	geo_distance_km@PLT
	cmp	eax, 0
.Ltmp51:
	.loc	1 44 13                         # support/geolab/query.c:44:13
	jne	.LBB1_27
# %bb.26:
.Ltmp52:
	.loc	1 45 18 is_stmt 1               # support/geolab/query.c:45:18
	mov	rdi, qword ptr [rbp - 80]
	.loc	1 45 13 is_stmt 0               # support/geolab/query.c:45:13
	call	free@PLT
	.loc	1 46 13 is_stmt 1               # support/geolab/query.c:46:13
	mov	dword ptr [rbp - 4], 0
	jmp	.LBB1_44
.Ltmp53:
.LBB1_27:                               #   in Loop: Header=BB1_24 Depth=1
	.loc	1 48 19                         # support/geolab/query.c:48:19
	movsd	xmm0, qword ptr [rbp - 104]     # xmm0 = mem[0],zero
	.loc	1 48 9 is_stmt 0                # support/geolab/query.c:48:9
	mov	rax, qword ptr [rbp - 80]
	.loc	1 48 14                         # support/geolab/query.c:48:14
	mov	rcx, qword ptr [rbp - 96]
	.loc	1 48 17                         # support/geolab/query.c:48:17
	movsd	qword ptr [rax + 8*rcx], xmm0
.Ltmp54:
	.loc	1 49 13 is_stmt 1               # support/geolab/query.c:49:13
	movsd	xmm1, qword ptr [rbp - 104]     # xmm1 = mem[0],zero
	.loc	1 49 18 is_stmt 0               # support/geolab/query.c:49:18
	movsd	xmm0, qword ptr [rbp - 48]      # xmm0 = mem[0],zero
	.loc	1 49 15                         # support/geolab/query.c:49:15
	ucomisd	xmm0, xmm1
.Ltmp55:
	.loc	1 49 13                         # support/geolab/query.c:49:13
	jb	.LBB1_29
# %bb.28:                               #   in Loop: Header=BB1_24 Depth=1
.Ltmp56:
	.loc	1 49 29                         # support/geolab/query.c:49:29
	mov	rax, qword ptr [rbp - 88]
	add	rax, 1
	mov	qword ptr [rbp - 88], rax
.Ltmp57:
.LBB1_29:                               #   in Loop: Header=BB1_24 Depth=1
	.loc	1 50 5 is_stmt 1                # support/geolab/query.c:50:5
	jmp	.LBB1_30
.Ltmp58:
.LBB1_30:                               #   in Loop: Header=BB1_24 Depth=1
	.loc	1 42 35                         # support/geolab/query.c:42:35
	mov	rax, qword ptr [rbp - 96]
	add	rax, 1
	mov	qword ptr [rbp - 96], rax
	.loc	1 42 5 is_stmt 0                # support/geolab/query.c:42:5
	jmp	.LBB1_24
.Ltmp59:
.LBB1_31:
	.loc	1 52 15 is_stmt 1               # support/geolab/query.c:52:15
	mov	qword ptr [rbp - 112], 0
.Ltmp60:
	.loc	1 53 18                         # support/geolab/query.c:53:18
	cmp	qword ptr [rbp - 88], 0
.Ltmp61:
	.loc	1 53 9 is_stmt 0                # support/geolab/query.c:53:9
	jbe	.LBB1_43
# %bb.32:
.Ltmp62:
	.loc	1 54 13 is_stmt 1               # support/geolab/query.c:54:13
	movabs	rax, 1152921504606846975
.Ltmp63:
	.loc	1 54 22 is_stmt 0               # support/geolab/query.c:54:22
	cmp	qword ptr [rbp - 88], rax
.Ltmp64:
	.loc	1 54 13                         # support/geolab/query.c:54:13
	jbe	.LBB1_34
# %bb.33:
.Ltmp65:
	.loc	1 55 18 is_stmt 1               # support/geolab/query.c:55:18
	mov	rdi, qword ptr [rbp - 80]
	.loc	1 55 13 is_stmt 0               # support/geolab/query.c:55:13
	call	free@PLT
	.loc	1 56 13 is_stmt 1               # support/geolab/query.c:56:13
	mov	dword ptr [rbp - 4], 0
	jmp	.LBB1_44
.Ltmp66:
.LBB1_34:
	.loc	1 58 22                         # support/geolab/query.c:58:22
	mov	rdi, qword ptr [rbp - 88]
	.loc	1 58 31 is_stmt 0               # support/geolab/query.c:58:31
	shl	rdi, 4
	.loc	1 58 15                         # support/geolab/query.c:58:15
	call	malloc@PLT
	.loc	1 58 13                         # support/geolab/query.c:58:13
	mov	qword ptr [rbp - 112], rax
.Ltmp67:
	.loc	1 59 17 is_stmt 1               # support/geolab/query.c:59:17
	cmp	qword ptr [rbp - 112], 0
.Ltmp68:
	.loc	1 59 13 is_stmt 0               # support/geolab/query.c:59:13
	jne	.LBB1_36
# %bb.35:
.Ltmp69:
	.loc	1 60 18 is_stmt 1               # support/geolab/query.c:60:18
	mov	rdi, qword ptr [rbp - 80]
	.loc	1 60 13 is_stmt 0               # support/geolab/query.c:60:13
	call	free@PLT
	.loc	1 61 13 is_stmt 1               # support/geolab/query.c:61:13
	mov	dword ptr [rbp - 4], 0
	jmp	.LBB1_44
.Ltmp70:
.LBB1_36:
	.loc	1 63 16                         # support/geolab/query.c:63:16
	mov	qword ptr [rbp - 120], 0
.Ltmp71:
	.loc	1 64 21                         # support/geolab/query.c:64:21
	mov	qword ptr [rbp - 128], 0
.LBB1_37:                               # =>This Inner Loop Header: Depth=1
.Ltmp72:
	.loc	1 64 28 is_stmt 0               # support/geolab/query.c:64:28
	mov	rax, qword ptr [rbp - 128]
	.loc	1 64 30                         # support/geolab/query.c:64:30
	cmp	rax, qword ptr [rbp - 24]
.Ltmp73:
	.loc	1 64 9                          # support/geolab/query.c:64:9
	jae	.LBB1_42
# %bb.38:                               #   in Loop: Header=BB1_37 Depth=1
.Ltmp74:
	.loc	1 65 17 is_stmt 1               # support/geolab/query.c:65:17
	mov	rax, qword ptr [rbp - 80]
	.loc	1 65 22 is_stmt 0               # support/geolab/query.c:65:22
	mov	rcx, qword ptr [rbp - 128]
	.loc	1 65 17                         # support/geolab/query.c:65:17
	movsd	xmm1, qword ptr [rax + 8*rcx]   # xmm1 = mem[0],zero
	.loc	1 65 28                         # support/geolab/query.c:65:28
	movsd	xmm0, qword ptr [rbp - 48]      # xmm0 = mem[0],zero
	.loc	1 65 25                         # support/geolab/query.c:65:25
	ucomisd	xmm0, xmm1
.Ltmp75:
	.loc	1 65 17                         # support/geolab/query.c:65:17
	jb	.LBB1_40
# %bb.39:                               #   in Loop: Header=BB1_37 Depth=1
.Ltmp76:
	.loc	1 66 29 is_stmt 1               # support/geolab/query.c:66:29
	mov	rax, qword ptr [rbp - 16]
	imul	rcx, qword ptr [rbp - 128], 24
	add	rax, rcx
	.loc	1 66 39 is_stmt 0               # support/geolab/query.c:66:39
	mov	rcx, qword ptr [rax]
	.loc	1 66 17                         # support/geolab/query.c:66:17
	mov	rax, qword ptr [rbp - 112]
	.loc	1 66 21                         # support/geolab/query.c:66:21
	mov	rdx, qword ptr [rbp - 120]
	.loc	1 66 17                         # support/geolab/query.c:66:17
	shl	rdx, 4
	add	rax, rdx
	.loc	1 66 27                         # support/geolab/query.c:66:27
	mov	qword ptr [rax], rcx
	.loc	1 67 38 is_stmt 1               # support/geolab/query.c:67:38
	mov	rax, qword ptr [rbp - 80]
	.loc	1 67 43 is_stmt 0               # support/geolab/query.c:67:43
	mov	rcx, qword ptr [rbp - 128]
	.loc	1 67 38                         # support/geolab/query.c:67:38
	movsd	xmm0, qword ptr [rax + 8*rcx]   # xmm0 = mem[0],zero
	.loc	1 67 17                         # support/geolab/query.c:67:17
	mov	rax, qword ptr [rbp - 112]
	.loc	1 67 21                         # support/geolab/query.c:67:21
	mov	rcx, qword ptr [rbp - 120]
	.loc	1 67 17                         # support/geolab/query.c:67:17
	shl	rcx, 4
	add	rax, rcx
	.loc	1 67 36                         # support/geolab/query.c:67:36
	movsd	qword ptr [rax + 8], xmm0
	.loc	1 68 17 is_stmt 1               # support/geolab/query.c:68:17
	mov	rax, qword ptr [rbp - 120]
	add	rax, 1
	mov	qword ptr [rbp - 120], rax
.Ltmp77:
.LBB1_40:                               #   in Loop: Header=BB1_37 Depth=1
	.loc	1 70 9                          # support/geolab/query.c:70:9
	jmp	.LBB1_41
.Ltmp78:
.LBB1_41:                               #   in Loop: Header=BB1_37 Depth=1
	.loc	1 64 39                         # support/geolab/query.c:64:39
	mov	rax, qword ptr [rbp - 128]
	add	rax, 1
	mov	qword ptr [rbp - 128], rax
	.loc	1 64 9 is_stmt 0                # support/geolab/query.c:64:9
	jmp	.LBB1_37
.Ltmp79:
.LBB1_42:
	.loc	1 72 15 is_stmt 1               # support/geolab/query.c:72:15
	mov	rdi, qword ptr [rbp - 112]
	.loc	1 72 20 is_stmt 0               # support/geolab/query.c:72:20
	mov	rsi, qword ptr [rbp - 88]
	.loc	1 72 9                          # support/geolab/query.c:72:9
	mov	edx, 16
	lea	rcx, [rip + query_hit_compare]
	call	qsort@PLT
.Ltmp80:
.LBB1_43:
	.loc	1 74 10 is_stmt 1               # support/geolab/query.c:74:10
	mov	rdi, qword ptr [rbp - 80]
	.loc	1 74 5 is_stmt 0                # support/geolab/query.c:74:5
	call	free@PLT
	.loc	1 76 13 is_stmt 1               # support/geolab/query.c:76:13
	mov	rcx, qword ptr [rbp - 112]
	.loc	1 76 6 is_stmt 0                # support/geolab/query.c:76:6
	mov	rax, qword ptr [rbp - 56]
	.loc	1 76 11                         # support/geolab/query.c:76:11
	mov	qword ptr [rax], rcx
	.loc	1 77 14 is_stmt 1               # support/geolab/query.c:77:14
	mov	rcx, qword ptr [rbp - 88]
	.loc	1 77 6 is_stmt 0                # support/geolab/query.c:77:6
	mov	rax, qword ptr [rbp - 64]
	.loc	1 77 12                         # support/geolab/query.c:77:12
	mov	qword ptr [rax], rcx
	.loc	1 78 5 is_stmt 1                # support/geolab/query.c:78:5
	mov	dword ptr [rbp - 4], 1
.LBB1_44:
	.loc	1 79 1                          # support/geolab/query.c:79:1
	mov	eax, dword ptr [rbp - 4]
	add	rsp, 128
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Ltmp81:
.Lfunc_end1:
	.size	query_points, .Lfunc_end1-query_points
	.cfi_endproc
                                        # -- End function
	.file	2 "/usr/include/x86_64-linux-gnu/bits" "types.h"
	.file	3 "/usr/include/x86_64-linux-gnu/bits" "stdint-uintn.h"
	.file	4 "/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" "support/geolab/geolab.h"
	.file	5 "/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" "support/geolab/geolab_types.h"
	.file	6 "/usr/lib/llvm-14/lib/clang/14.0.0/include" "stddef.h"
	.section	.debug_abbrev,"",@progbits
	.byte	1                               # Abbreviation Code
	.byte	17                              # DW_TAG_compile_unit
	.byte	1                               # DW_CHILDREN_yes
	.byte	37                              # DW_AT_producer
	.byte	14                              # DW_FORM_strp
	.byte	19                              # DW_AT_language
	.byte	5                               # DW_FORM_data2
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	16                              # DW_AT_stmt_list
	.byte	23                              # DW_FORM_sec_offset
	.byte	27                              # DW_AT_comp_dir
	.byte	14                              # DW_FORM_strp
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	2                               # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	3                               # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	64                              # DW_AT_frame_base
	.byte	24                              # DW_FORM_exprloc
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	4                               # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	5                               # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	6                               # Abbreviation Code
	.byte	11                              # DW_TAG_lexical_block
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	7                               # Abbreviation Code
	.byte	36                              # DW_TAG_base_type
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	62                              # DW_AT_encoding
	.byte	11                              # DW_FORM_data1
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	8                               # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	9                               # Abbreviation Code
	.byte	38                              # DW_TAG_const_type
	.byte	0                               # DW_CHILDREN_no
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	10                              # Abbreviation Code
	.byte	38                              # DW_TAG_const_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	11                              # Abbreviation Code
	.byte	22                              # DW_TAG_typedef
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	12                              # Abbreviation Code
	.byte	19                              # DW_TAG_structure_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	13                              # Abbreviation Code
	.byte	13                              # DW_TAG_member
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	56                              # DW_AT_data_member_location
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	0                               # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.long	.Ldebug_info_end0-.Ldebug_info_start0 # Length of Unit
.Ldebug_info_start0:
	.short	4                               # DWARF version number
	.long	.debug_abbrev                   # Offset Into Abbrev. Section
	.byte	8                               # Address Size (in bytes)
	.byte	1                               # Abbrev [1] 0xb:0x26d DW_TAG_compile_unit
	.long	.Linfo_string0                  # DW_AT_producer
	.short	12                              # DW_AT_language
	.long	.Linfo_string1                  # DW_AT_name
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.long	.Linfo_string2                  # DW_AT_comp_dir
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin0       # DW_AT_high_pc
	.byte	2                               # Abbrev [2] 0x2a:0x1 DW_TAG_pointer_type
	.byte	3                               # Abbrev [3] 0x2b:0x52 DW_TAG_subprogram
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	86
	.long	.Linfo_string3                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	439                             # DW_AT_type
                                        # DW_AT_external
	.byte	4                               # Abbrev [4] 0x44:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	112
	.long	.Linfo_string6                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.long	446                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x52:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	104
	.long	.Linfo_string7                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.long	446                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x60:0xe DW_TAG_variable
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	96
	.long	.Linfo_string8                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	13                              # DW_AT_decl_line
	.long	452                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x6e:0xe DW_TAG_variable
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	88
	.long	.Linfo_string16                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	13                              # DW_AT_decl_line
	.long	452                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	3                               # Abbrev [3] 0x7d:0x13a DW_TAG_subprogram
	.quad	.Lfunc_begin1                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin1       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	86
	.long	.Linfo_string5                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	439                             # DW_AT_type
                                        # DW_AT_external
	.byte	4                               # Abbrev [4] 0x96:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	112
	.long	.Linfo_string17                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
	.long	538                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0xa4:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	104
	.long	.Linfo_string21                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
	.long	600                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0xb2:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	96
	.long	.Linfo_string23                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
	.long	531                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0xc0:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	88
	.long	.Linfo_string24                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
	.long	531                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0xce:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	80
	.long	.Linfo_string25                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
	.long	531                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0xdc:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	72
	.long	.Linfo_string26                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
	.long	611                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0xea:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	64
	.long	.Linfo_string27                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	22                              # DW_AT_decl_line
	.long	621                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0xf8:0xf DW_TAG_variable
	.byte	3                               # DW_AT_location
	.byte	145
	.ascii	"\260\177"
	.long	.Linfo_string29                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	39                              # DW_AT_decl_line
	.long	626                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x107:0xf DW_TAG_variable
	.byte	3                               # DW_AT_location
	.byte	145
	.ascii	"\250\177"
	.long	.Linfo_string30                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	41                              # DW_AT_decl_line
	.long	600                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x116:0xf DW_TAG_variable
	.byte	3                               # DW_AT_location
	.byte	145
	.ascii	"\220\177"
	.long	.Linfo_string32                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	52                              # DW_AT_decl_line
	.long	616                             # DW_AT_type
	.byte	6                               # Abbrev [6] 0x125:0x1d DW_TAG_lexical_block
	.quad	.Ltmp26                         # DW_AT_low_pc
	.long	.Ltmp34-.Ltmp26                 # DW_AT_high_pc
	.byte	5                               # Abbrev [5] 0x132:0xf DW_TAG_variable
	.byte	3                               # DW_AT_location
	.byte	145
	.ascii	"\270\177"
	.long	.Linfo_string28                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	28                              # DW_AT_decl_line
	.long	600                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	6                               # Abbrev [6] 0x142:0x3a DW_TAG_lexical_block
	.quad	.Ltmp46                         # DW_AT_low_pc
	.long	.Ltmp59-.Ltmp46                 # DW_AT_high_pc
	.byte	5                               # Abbrev [5] 0x14f:0xf DW_TAG_variable
	.byte	3                               # DW_AT_location
	.byte	145
	.ascii	"\240\177"
	.long	.Linfo_string28                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.long	600                             # DW_AT_type
	.byte	6                               # Abbrev [6] 0x15e:0x1d DW_TAG_lexical_block
	.quad	.Ltmp49                         # DW_AT_low_pc
	.long	.Ltmp58-.Ltmp49                 # DW_AT_high_pc
	.byte	5                               # Abbrev [5] 0x16b:0xf DW_TAG_variable
	.byte	3                               # DW_AT_location
	.byte	145
	.ascii	"\230\177"
	.long	.Linfo_string31                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	43                              # DW_AT_decl_line
	.long	531                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	6                               # Abbrev [6] 0x17c:0x3a DW_TAG_lexical_block
	.quad	.Ltmp62                         # DW_AT_low_pc
	.long	.Ltmp80-.Ltmp62                 # DW_AT_high_pc
	.byte	5                               # Abbrev [5] 0x189:0xf DW_TAG_variable
	.byte	3                               # DW_AT_location
	.byte	145
	.ascii	"\210\177"
	.long	.Linfo_string33                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	63                              # DW_AT_decl_line
	.long	600                             # DW_AT_type
	.byte	6                               # Abbrev [6] 0x198:0x1d DW_TAG_lexical_block
	.quad	.Ltmp71                         # DW_AT_low_pc
	.long	.Ltmp79-.Ltmp71                 # DW_AT_high_pc
	.byte	5                               # Abbrev [5] 0x1a5:0xf DW_TAG_variable
	.byte	3                               # DW_AT_location
	.byte	145
	.ascii	"\200\177"
	.long	.Linfo_string28                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	64                              # DW_AT_decl_line
	.long	600                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	7                               # Abbrev [7] 0x1b7:0x7 DW_TAG_base_type
	.long	.Linfo_string4                  # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	8                               # Abbrev [8] 0x1be:0x5 DW_TAG_pointer_type
	.long	451                             # DW_AT_type
	.byte	9                               # Abbrev [9] 0x1c3:0x1 DW_TAG_const_type
	.byte	8                               # Abbrev [8] 0x1c4:0x5 DW_TAG_pointer_type
	.long	457                             # DW_AT_type
	.byte	10                              # Abbrev [10] 0x1c9:0x5 DW_TAG_const_type
	.long	462                             # DW_AT_type
	.byte	11                              # Abbrev [11] 0x1ce:0xb DW_TAG_typedef
	.long	473                             # DW_AT_type
	.long	.Linfo_string15                 # DW_AT_name
	.byte	4                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	12                              # Abbrev [12] 0x1d9:0x1d DW_TAG_structure_type
	.byte	16                              # DW_AT_byte_size
	.byte	4                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	13                              # Abbrev [13] 0x1dd:0xc DW_TAG_member
	.long	.Linfo_string9                  # DW_AT_name
	.long	502                             # DW_AT_type
	.byte	4                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	0                               # DW_AT_data_member_location
	.byte	13                              # Abbrev [13] 0x1e9:0xc DW_TAG_member
	.long	.Linfo_string13                 # DW_AT_name
	.long	531                             # DW_AT_type
	.byte	4                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	8                               # DW_AT_data_member_location
	.byte	0                               # End Of Children Mark
	.byte	11                              # Abbrev [11] 0x1f6:0xb DW_TAG_typedef
	.long	513                             # DW_AT_type
	.long	.Linfo_string12                 # DW_AT_name
	.byte	3                               # DW_AT_decl_file
	.byte	27                              # DW_AT_decl_line
	.byte	11                              # Abbrev [11] 0x201:0xb DW_TAG_typedef
	.long	524                             # DW_AT_type
	.long	.Linfo_string11                 # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	45                              # DW_AT_decl_line
	.byte	7                               # Abbrev [7] 0x20c:0x7 DW_TAG_base_type
	.long	.Linfo_string10                 # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	7                               # Abbrev [7] 0x213:0x7 DW_TAG_base_type
	.long	.Linfo_string14                 # DW_AT_name
	.byte	4                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	8                               # Abbrev [8] 0x21a:0x5 DW_TAG_pointer_type
	.long	543                             # DW_AT_type
	.byte	10                              # Abbrev [10] 0x21f:0x5 DW_TAG_const_type
	.long	548                             # DW_AT_type
	.byte	11                              # Abbrev [11] 0x224:0xb DW_TAG_typedef
	.long	559                             # DW_AT_type
	.long	.Linfo_string20                 # DW_AT_name
	.byte	5                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	12                              # Abbrev [12] 0x22f:0x29 DW_TAG_structure_type
	.byte	24                              # DW_AT_byte_size
	.byte	5                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	13                              # Abbrev [13] 0x233:0xc DW_TAG_member
	.long	.Linfo_string9                  # DW_AT_name
	.long	502                             # DW_AT_type
	.byte	5                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	0                               # DW_AT_data_member_location
	.byte	13                              # Abbrev [13] 0x23f:0xc DW_TAG_member
	.long	.Linfo_string18                 # DW_AT_name
	.long	531                             # DW_AT_type
	.byte	5                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	8                               # DW_AT_data_member_location
	.byte	13                              # Abbrev [13] 0x24b:0xc DW_TAG_member
	.long	.Linfo_string19                 # DW_AT_name
	.long	531                             # DW_AT_type
	.byte	5                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	16                              # DW_AT_data_member_location
	.byte	0                               # End Of Children Mark
	.byte	11                              # Abbrev [11] 0x258:0xb DW_TAG_typedef
	.long	524                             # DW_AT_type
	.long	.Linfo_string22                 # DW_AT_name
	.byte	6                               # DW_AT_decl_file
	.byte	46                              # DW_AT_decl_line
	.byte	8                               # Abbrev [8] 0x263:0x5 DW_TAG_pointer_type
	.long	616                             # DW_AT_type
	.byte	8                               # Abbrev [8] 0x268:0x5 DW_TAG_pointer_type
	.long	462                             # DW_AT_type
	.byte	8                               # Abbrev [8] 0x26d:0x5 DW_TAG_pointer_type
	.long	600                             # DW_AT_type
	.byte	8                               # Abbrev [8] 0x272:0x5 DW_TAG_pointer_type
	.long	531                             # DW_AT_type
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"Ubuntu clang version 14.0.0-1ubuntu1.1" # string offset=0
.Linfo_string1:
	.asciz	"support/geolab/query.c"        # string offset=39
.Linfo_string2:
	.asciz	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" # string offset=62
.Linfo_string3:
	.asciz	"query_hit_compare"             # string offset=155
.Linfo_string4:
	.asciz	"int"                           # string offset=173
.Linfo_string5:
	.asciz	"query_points"                  # string offset=177
.Linfo_string6:
	.asciz	"a"                             # string offset=190
.Linfo_string7:
	.asciz	"b"                             # string offset=192
.Linfo_string8:
	.asciz	"x"                             # string offset=194
.Linfo_string9:
	.asciz	"id"                            # string offset=196
.Linfo_string10:
	.asciz	"unsigned long"                 # string offset=199
.Linfo_string11:
	.asciz	"__uint64_t"                    # string offset=213
.Linfo_string12:
	.asciz	"uint64_t"                      # string offset=224
.Linfo_string13:
	.asciz	"distance_km"                   # string offset=233
.Linfo_string14:
	.asciz	"double"                        # string offset=245
.Linfo_string15:
	.asciz	"QueryHit"                      # string offset=252
.Linfo_string16:
	.asciz	"y"                             # string offset=261
.Linfo_string17:
	.asciz	"points"                        # string offset=263
.Linfo_string18:
	.asciz	"lat_deg"                       # string offset=270
.Linfo_string19:
	.asciz	"lon_deg"                       # string offset=278
.Linfo_string20:
	.asciz	"GeoPoint"                      # string offset=286
.Linfo_string21:
	.asciz	"count"                         # string offset=295
.Linfo_string22:
	.asciz	"size_t"                        # string offset=301
.Linfo_string23:
	.asciz	"lat"                           # string offset=308
.Linfo_string24:
	.asciz	"lon"                           # string offset=312
.Linfo_string25:
	.asciz	"radius_km"                     # string offset=316
.Linfo_string26:
	.asciz	"hits"                          # string offset=326
.Linfo_string27:
	.asciz	"nhits"                         # string offset=331
.Linfo_string28:
	.asciz	"i"                             # string offset=337
.Linfo_string29:
	.asciz	"dist"                          # string offset=339
.Linfo_string30:
	.asciz	"selected"                      # string offset=344
.Linfo_string31:
	.asciz	"d"                             # string offset=353
.Linfo_string32:
	.asciz	"out"                           # string offset=355
.Linfo_string33:
	.asciz	"k"                             # string offset=359
	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym query_hit_compare
	.addrsig_sym geo_valid_position
	.addrsig_sym malloc
	.addrsig_sym geo_distance_km
	.addrsig_sym free
	.addrsig_sym qsort
	.section	.debug_line,"",@progbits
.Lline_table_start0:
