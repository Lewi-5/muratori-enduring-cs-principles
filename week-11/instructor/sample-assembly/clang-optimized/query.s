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
	#DEBUG_VALUE: query_hit_compare:a <- $rdi
	#DEBUG_VALUE: query_hit_compare:b <- $rsi
	#DEBUG_VALUE: query_hit_compare:x <- $rdi
	#DEBUG_VALUE: query_hit_compare:y <- $rsi
	.loc	1 14 12 prologue_end            # support/geolab/query.c:14:12
	movsd	xmm0, qword ptr [rdi + 8]       # xmm0 = mem[0],zero
	.loc	1 14 29 is_stmt 0               # support/geolab/query.c:14:29
	movsd	xmm1, qword ptr [rsi + 8]       # xmm1 = mem[0],zero
	mov	eax, -1
	.loc	1 14 24                         # support/geolab/query.c:14:24
	ucomisd	xmm1, xmm0
.Ltmp0:
	.loc	1 14 9                          # support/geolab/query.c:14:9
	ja	.LBB0_4
.Ltmp1:
# %bb.1:
	#DEBUG_VALUE: query_hit_compare:a <- $rdi
	#DEBUG_VALUE: query_hit_compare:b <- $rsi
	#DEBUG_VALUE: query_hit_compare:x <- $rdi
	#DEBUG_VALUE: query_hit_compare:y <- $rsi
	.loc	1 0 9                           # support/geolab/query.c:0:9
	mov	eax, 1
.Ltmp2:
	.loc	1 15 24 is_stmt 1               # support/geolab/query.c:15:24
	ucomisd	xmm0, xmm1
.Ltmp3:
	.loc	1 15 9 is_stmt 0                # support/geolab/query.c:15:9
	ja	.LBB0_4
.Ltmp4:
# %bb.2:
	#DEBUG_VALUE: query_hit_compare:a <- $rdi
	#DEBUG_VALUE: query_hit_compare:b <- $rsi
	#DEBUG_VALUE: query_hit_compare:x <- $rdi
	#DEBUG_VALUE: query_hit_compare:y <- $rsi
	.loc	1 16 20 is_stmt 1               # support/geolab/query.c:16:20
	mov	rcx, qword ptr [rsi]
	mov	eax, -1
	.loc	1 16 15 is_stmt 0               # support/geolab/query.c:16:15
	cmp	qword ptr [rdi], rcx
.Ltmp5:
	.loc	1 16 9                          # support/geolab/query.c:16:9
	jb	.LBB0_4
.Ltmp6:
# %bb.3:
	#DEBUG_VALUE: query_hit_compare:a <- $rdi
	#DEBUG_VALUE: query_hit_compare:b <- $rsi
	#DEBUG_VALUE: query_hit_compare:x <- $rdi
	#DEBUG_VALUE: query_hit_compare:y <- $rsi
	.loc	1 17 15 is_stmt 1               # support/geolab/query.c:17:15
	seta	al
.Ltmp7:
	.loc	1 0 0 is_stmt 0                 # support/geolab/query.c:0:0
	movzx	eax, al
.Ltmp8:
.LBB0_4:
	#DEBUG_VALUE: query_hit_compare:a <- $rdi
	#DEBUG_VALUE: query_hit_compare:b <- $rsi
	#DEBUG_VALUE: query_hit_compare:x <- $rdi
	#DEBUG_VALUE: query_hit_compare:y <- $rsi
	.loc	1 19 1 is_stmt 1                # support/geolab/query.c:19:1
	ret
.Ltmp9:
.Lfunc_end0:
	.size	query_hit_compare, .Lfunc_end0-query_hit_compare
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4                               # -- Begin function query_points
.LCPI1_0:
	.quad	0x7fffffffffffffff              # double NaN
	.quad	0x7fffffffffffffff              # double NaN
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI1_1:
	.quad	0x40f86a0000000000              # double 1.0E+5
.LCPI1_2:
	.quad	0x7ff0000000000000              # double +Inf
	.text
	.globl	query_points
	.p2align	4, 0x90
	.type	query_points,@function
query_points:                           # @query_points
.Lfunc_begin1:
	.loc	1 23 0                          # support/geolab/query.c:23:0
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: query_points:points <- $rdi
	#DEBUG_VALUE: query_points:count <- $rsi
	#DEBUG_VALUE: query_points:lat <- $xmm0
	#DEBUG_VALUE: query_points:lon <- $xmm1
	#DEBUG_VALUE: query_points:radius_km <- $xmm2
	#DEBUG_VALUE: query_points:hits <- $rdx
	#DEBUG_VALUE: query_points:nhits <- $rcx
	push	rbp
	.cfi_def_cfa_offset 16
	push	r15
	.cfi_def_cfa_offset 24
	push	r14
	.cfi_def_cfa_offset 32
	push	r13
	.cfi_def_cfa_offset 40
	push	r12
	.cfi_def_cfa_offset 48
	push	rbx
	.cfi_def_cfa_offset 56
	sub	rsp, 72
	.cfi_def_cfa_offset 128
	.cfi_offset rbx, -56
	.cfi_offset r12, -48
	.cfi_offset r13, -40
	.cfi_offset r14, -32
	.cfi_offset r15, -24
	.cfi_offset rbp, -16
	xor	r13d, r13d
.Ltmp10:
	.loc	1 25 14 prologue_end            # support/geolab/query.c:25:14
	test	rdx, rdx
	.loc	1 25 22 is_stmt 0               # support/geolab/query.c:25:22
	je	.LBB1_31
.Ltmp11:
# %bb.1:
	#DEBUG_VALUE: query_points:points <- $rdi
	#DEBUG_VALUE: query_points:count <- $rsi
	#DEBUG_VALUE: query_points:lat <- $xmm0
	#DEBUG_VALUE: query_points:lon <- $xmm1
	#DEBUG_VALUE: query_points:radius_km <- $xmm2
	#DEBUG_VALUE: query_points:hits <- $rdx
	#DEBUG_VALUE: query_points:nhits <- $rcx
	.loc	1 0 22                          # support/geolab/query.c:0:22
	mov	rbx, rcx
	.loc	1 25 22                         # support/geolab/query.c:25:22
	test	rcx, rcx
	je	.LBB1_31
.Ltmp12:
# %bb.2:
	#DEBUG_VALUE: query_points:points <- $rdi
	#DEBUG_VALUE: query_points:count <- $rsi
	#DEBUG_VALUE: query_points:lat <- $xmm0
	#DEBUG_VALUE: query_points:lon <- $xmm1
	#DEBUG_VALUE: query_points:radius_km <- $xmm2
	#DEBUG_VALUE: query_points:hits <- $rdx
	#DEBUG_VALUE: query_points:nhits <- $rbx
	.loc	1 0 22                          # support/geolab/query.c:0:22
	mov	r12, rdx
	mov	r14, rsi
	mov	r15, rdi
	.loc	1 25 50                         # support/geolab/query.c:25:50
	test	rdi, rdi
	.loc	1 25 58                         # support/geolab/query.c:25:58
	jne	.LBB1_4
.Ltmp13:
# %bb.3:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- $xmm0
	#DEBUG_VALUE: query_points:lon <- $xmm1
	#DEBUG_VALUE: query_points:radius_km <- $xmm2
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	test	r14, r14
	jne	.LBB1_31
.Ltmp14:
.LBB1_4:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- $xmm0
	#DEBUG_VALUE: query_points:lon <- $xmm1
	#DEBUG_VALUE: query_points:radius_km <- $xmm2
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	.loc	1 0 58                          # support/geolab/query.c:0:58
	movaps	xmmword ptr [rsp + 16], xmm2    # 16-byte Spill
.Ltmp15:
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	movsd	qword ptr [rsp + 56], xmm0      # 8-byte Spill
.Ltmp16:
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	movsd	qword ptr [rsp + 64], xmm1      # 8-byte Spill
.Ltmp17:
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	.loc	1 26 10 is_stmt 1               # support/geolab/query.c:26:10
	call	geo_valid_position@PLT
.Ltmp18:
	test	eax, eax
.Ltmp19:
	.loc	1 26 9 is_stmt 0                # support/geolab/query.c:26:9
	je	.LBB1_31
.Ltmp20:
# %bb.5:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	.loc	1 0 9                           # support/geolab/query.c:0:9
	movapd	xmm1, xmmword ptr [rsp + 16]    # 16-byte Reload
.Ltmp21:
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	ucomisd	xmm1, qword ptr [rip + .LCPI1_1]
.Ltmp22:
	.loc	1 27 30 is_stmt 1               # support/geolab/query.c:27:30
	ja	.LBB1_31
.Ltmp23:
# %bb.6:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	.loc	1 0 30 is_stmt 0                # support/geolab/query.c:0:30
	xorpd	xmm0, xmm0
	.loc	1 27 30                         # support/geolab/query.c:27:30
	ucomisd	xmm0, xmm1
	ja	.LBB1_31
.Ltmp24:
# %bb.7:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	.loc	1 0 30                          # support/geolab/query.c:0:30
	movapd	xmm0, xmmword ptr [rip + .LCPI1_0] # xmm0 = [NaN,NaN]
	andpd	xmm0, xmm1
	.loc	1 27 30                         # support/geolab/query.c:27:30
	ucomisd	xmm0, qword ptr [rip + .LCPI1_2]
	je	.LBB1_31
.Ltmp25:
# %bb.8:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: i <- 0
	.loc	1 28 26 is_stmt 1               # support/geolab/query.c:28:26
	test	r14, r14
.Ltmp26:
	.loc	1 28 5 is_stmt 0                # support/geolab/query.c:28:5
	je	.LBB1_13
.Ltmp27:
# %bb.9:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: i <- 0
	.loc	1 0 5                           # support/geolab/query.c:0:5
	mov	qword ptr [rsp + 40], rbx       # 8-byte Spill
.Ltmp28:
	#DEBUG_VALUE: query_points:nhits <- [DW_OP_plus_uconst 40] [$rsp+0]
	.loc	1 28 5                          # support/geolab/query.c:28:5
	lea	rbx, [r15 + 16]
	mov	rbp, r14
.Ltmp29:
	.p2align	4, 0x90
.LBB1_11:                               # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: i <- [DW_OP_LLVM_arg 0, DW_OP_LLVM_arg 1, DW_OP_minus, DW_OP_consts 18446744073709551615, DW_OP_div, DW_OP_stack_value] $rbp, $r14
	.loc	1 29 43 is_stmt 1               # support/geolab/query.c:29:43
	movsd	xmm0, qword ptr [rbx - 8]       # xmm0 = mem[0],zero
	.loc	1 29 62 is_stmt 0               # support/geolab/query.c:29:62
	movsd	xmm1, qword ptr [rbx]           # xmm1 = mem[0],zero
	.loc	1 29 14                         # support/geolab/query.c:29:14
	call	geo_valid_position@PLT
.Ltmp30:
	test	eax, eax
.Ltmp31:
	#DEBUG_VALUE: i <- [DW_OP_LLVM_arg 0, DW_OP_LLVM_arg 1, DW_OP_minus, DW_OP_consts 18446744073709551615, DW_OP_div, DW_OP_consts 1, DW_OP_plus, DW_OP_stack_value] $rbp, $r14
	.loc	1 29 13                         # support/geolab/query.c:29:13
	je	.LBB1_31
.Ltmp32:
# %bb.10:                               #   in Loop: Header=BB1_11 Depth=1
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- [DW_OP_plus_uconst 40] [$rsp+0]
	#DEBUG_VALUE: i <- [DW_OP_LLVM_arg 0, DW_OP_LLVM_arg 1, DW_OP_minus, DW_OP_consts 18446744073709551615, DW_OP_div, DW_OP_consts 1, DW_OP_plus, DW_OP_stack_value] $rbp, $r14
	.loc	1 28 26 is_stmt 1               # support/geolab/query.c:28:26
	add	rbx, 24
	add	rbp, -1
.Ltmp33:
	.loc	1 28 5 is_stmt 0                # support/geolab/query.c:28:5
	jne	.LBB1_11
.Ltmp34:
# %bb.12:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- [DW_OP_plus_uconst 40] [$rsp+0]
	.loc	1 28 26                         # support/geolab/query.c:28:26
	test	r14, r14
	mov	rbx, qword ptr [rsp + 40]       # 8-byte Reload
.Ltmp35:
	#DEBUG_VALUE: query_points:nhits <- $rbx
	.loc	1 31 9 is_stmt 1                # support/geolab/query.c:31:9
	je	.LBB1_13
.Ltmp36:
# %bb.14:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	.loc	1 38 15                         # support/geolab/query.c:38:15
	mov	rax, r14
	shr	rax, 61
.Ltmp37:
	.loc	1 38 9 is_stmt 0                # support/geolab/query.c:38:9
	jne	.LBB1_31
.Ltmp38:
# %bb.15:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	.loc	1 39 33 is_stmt 1               # support/geolab/query.c:39:33
	lea	rdi, [8*r14]
	.loc	1 39 20 is_stmt 0               # support/geolab/query.c:39:20
	call	malloc@PLT
.Ltmp39:
	#DEBUG_VALUE: query_points:dist <- $rax
	.loc	1 0 20                          # support/geolab/query.c:0:20
	mov	qword ptr [rsp], rax            # 8-byte Spill
.Ltmp40:
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	.loc	1 40 14 is_stmt 1               # support/geolab/query.c:40:14
	test	rax, rax
.Ltmp41:
	.loc	1 40 9 is_stmt 0                # support/geolab/query.c:40:9
	je	.LBB1_31
.Ltmp42:
# %bb.16:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- $rax
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: query_points:selected <- 0
	.loc	1 42 5 is_stmt 1                # support/geolab/query.c:42:5
	lea	r13, [r15 + 16]
	xor	ebp, ebp
	xor	edi, edi
.Ltmp43:
.LBB1_17:                               # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- $rax
	#DEBUG_VALUE: i <- $rbp
	#DEBUG_VALUE: query_points:selected <- $rdi
	#DEBUG_VALUE: d <- 0.000000e+00
	.loc	1 0 5 is_stmt 0                 # support/geolab/query.c:0:5
	mov	qword ptr [rsp + 48], rdi       # 8-byte Spill
.Ltmp44:
	#DEBUG_VALUE: query_points:selected <- [DW_OP_plus_uconst 48] [$rsp+0]
	.loc	1 43 16 is_stmt 1               # support/geolab/query.c:43:16
	mov	qword ptr [rsp + 8], 0
.Ltmp45:
	.loc	1 44 50                         # support/geolab/query.c:44:50
	movsd	xmm2, qword ptr [r13 - 8]       # xmm2 = mem[0],zero
	.loc	1 44 69 is_stmt 0               # support/geolab/query.c:44:69
	movsd	xmm3, qword ptr [r13]           # xmm3 = mem[0],zero
.Ltmp46:
	#DEBUG_VALUE: d <- [DW_OP_plus_uconst 8, DW_OP_deref] $rsp
	.loc	1 0 69                          # support/geolab/query.c:0:69
	movsd	xmm0, qword ptr [rsp + 56]      # 8-byte Reload
                                        # xmm0 = mem[0],zero
.Ltmp47:
	#DEBUG_VALUE: query_points:lat <- $xmm0
	movsd	xmm1, qword ptr [rsp + 64]      # 8-byte Reload
                                        # xmm1 = mem[0],zero
.Ltmp48:
	#DEBUG_VALUE: query_points:lon <- $xmm1
	.loc	1 44 14                         # support/geolab/query.c:44:14
	lea	rdi, [rsp + 8]
	call	geo_distance_km@PLT
.Ltmp49:
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	test	eax, eax
.Ltmp50:
	.loc	1 44 13                         # support/geolab/query.c:44:13
	je	.LBB1_18
.Ltmp51:
# %bb.19:                               #   in Loop: Header=BB1_17 Depth=1
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	#DEBUG_VALUE: i <- $rbp
	#DEBUG_VALUE: query_points:selected <- [DW_OP_plus_uconst 48] [$rsp+0]
	#DEBUG_VALUE: d <- [DW_OP_plus_uconst 8, DW_OP_deref] $rsp
	.loc	1 48 19 is_stmt 1               # support/geolab/query.c:48:19
	movsd	xmm0, qword ptr [rsp + 8]       # xmm0 = mem[0],zero
.Ltmp52:
	#DEBUG_VALUE: d <- $xmm0
	.loc	1 0 19 is_stmt 0                # support/geolab/query.c:0:19
	movapd	xmm1, xmmword ptr [rsp + 16]    # 16-byte Reload
.Ltmp53:
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	.loc	1 49 15 is_stmt 1               # support/geolab/query.c:49:15
	ucomisd	xmm1, xmm0
	mov	rdi, qword ptr [rsp + 48]       # 8-byte Reload
.Ltmp54:
	#DEBUG_VALUE: query_points:selected <- $rdi
	.loc	1 49 13 is_stmt 0               # support/geolab/query.c:49:13
	sbb	rdi, -1
.Ltmp55:
	#DEBUG_VALUE: query_points:selected <- [DW_OP_plus_uconst 48] [$rsp+0]
	#DEBUG_VALUE: query_points:selected <- $rdi
	#DEBUG_VALUE: query_points:selected <- $rdi
	.loc	1 0 13                          # support/geolab/query.c:0:13
	mov	rax, qword ptr [rsp]            # 8-byte Reload
.Ltmp56:
	#DEBUG_VALUE: query_points:dist <- $rax
	.loc	1 48 17 is_stmt 1               # support/geolab/query.c:48:17
	movsd	qword ptr [rax + 8*rbp], xmm0
.Ltmp57:
	.loc	1 42 35                         # support/geolab/query.c:42:35
	add	rbp, 1
.Ltmp58:
	#DEBUG_VALUE: i <- $rbp
	.loc	1 42 26 is_stmt 0               # support/geolab/query.c:42:26
	add	r13, 24
	cmp	r14, rbp
.Ltmp59:
	.loc	1 42 5                          # support/geolab/query.c:42:5
	jne	.LBB1_17
.Ltmp60:
# %bb.20:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- $rax
	#DEBUG_VALUE: query_points:selected <- $rdi
	#DEBUG_VALUE: query_points:selected <- $rdi
	#DEBUG_VALUE: query_points:out <- 0
	.loc	1 53 18 is_stmt 1               # support/geolab/query.c:53:18
	test	rdi, rdi
.Ltmp61:
	.loc	1 53 9 is_stmt 0                # support/geolab/query.c:53:9
	je	.LBB1_21
.Ltmp62:
# %bb.22:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- $rax
	#DEBUG_VALUE: query_points:selected <- $rdi
	#DEBUG_VALUE: query_points:out <- 0
	.loc	1 54 22 is_stmt 1               # support/geolab/query.c:54:22
	mov	rax, rdi
.Ltmp63:
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	shr	rax, 60
.Ltmp64:
	.loc	1 54 13 is_stmt 0               # support/geolab/query.c:54:13
	jne	.LBB1_18
.Ltmp65:
# %bb.23:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	#DEBUG_VALUE: query_points:selected <- $rdi
	#DEBUG_VALUE: query_points:out <- 0
	.loc	1 0 13                          # support/geolab/query.c:0:13
	mov	r13, rdi
	.loc	1 58 31 is_stmt 1               # support/geolab/query.c:58:31
	shl	rdi, 4
.Ltmp66:
	#DEBUG_VALUE: query_points:selected <- $r13
	.loc	1 58 15 is_stmt 0               # support/geolab/query.c:58:15
	call	malloc@PLT
.Ltmp67:
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:out <- $rax
	.loc	1 59 17 is_stmt 1               # support/geolab/query.c:59:17
	test	rax, rax
.Ltmp68:
	.loc	1 59 13 is_stmt 0               # support/geolab/query.c:59:13
	je	.LBB1_18
.Ltmp69:
# %bb.24:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	#DEBUG_VALUE: query_points:selected <- $r13
	#DEBUG_VALUE: query_points:out <- $rax
	.loc	1 0 0                           # support/geolab/query.c:0:0
	mov	rbp, rax
.Ltmp70:
	#DEBUG_VALUE: i <- 0
	#DEBUG_VALUE: k <- 0
	.loc	1 64 9 is_stmt 1                # support/geolab/query.c:64:9
	cmp	r14, 2
	mov	eax, 1
.Ltmp71:
	#DEBUG_VALUE: query_points:out <- $rbp
	cmovae	rax, r14
	xor	ecx, ecx
	xor	edx, edx
	movapd	xmm1, xmmword ptr [rsp + 16]    # 16-byte Reload
.Ltmp72:
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	.loc	1 0 9 is_stmt 0                 # support/geolab/query.c:0:9
	jmp	.LBB1_25
.Ltmp73:
.LBB1_13:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	.loc	1 32 15 is_stmt 1               # support/geolab/query.c:32:15
	mov	qword ptr [r12], 0
	.loc	1 33 16                         # support/geolab/query.c:33:16
	mov	qword ptr [rbx], 0
.Ltmp74:
.LBB1_30:
	#DEBUG_VALUE: query_points:points <- [DW_OP_LLVM_entry_value 1] $rdi
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	.loc	1 0 16 is_stmt 0                # support/geolab/query.c:0:16
	mov	r13d, 1
.Ltmp75:
.LBB1_31:
	#DEBUG_VALUE: query_points:points <- [DW_OP_LLVM_entry_value 1] $rdi
	#DEBUG_VALUE: query_points:count <- [DW_OP_LLVM_entry_value 1] $rsi
	#DEBUG_VALUE: query_points:lat <- [DW_OP_LLVM_entry_value 1] $xmm0
	#DEBUG_VALUE: query_points:lon <- [DW_OP_LLVM_entry_value 1] $xmm1
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_LLVM_entry_value 1] $xmm2
	#DEBUG_VALUE: query_points:hits <- [DW_OP_LLVM_entry_value 1] $rdx
	#DEBUG_VALUE: query_points:nhits <- [DW_OP_LLVM_entry_value 1] $rcx
	.loc	1 79 1 is_stmt 1                # support/geolab/query.c:79:1
	mov	eax, r13d
	add	rsp, 72
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	r12
	.cfi_def_cfa_offset 40
	pop	r13
	.cfi_def_cfa_offset 32
	pop	r14
	.cfi_def_cfa_offset 24
	pop	r15
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
.Ltmp76:
.LBB1_27:                               #   in Loop: Header=BB1_25 Depth=1
	.cfi_def_cfa_offset 128
	#DEBUG_VALUE: query_points:points <- [DW_OP_LLVM_entry_value 1] $rdi
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	#DEBUG_VALUE: query_points:selected <- $r13
	#DEBUG_VALUE: query_points:out <- $rbp
	#DEBUG_VALUE: i <- $rcx
	#DEBUG_VALUE: k <- $rdx
	#DEBUG_VALUE: k <- $rdx
	.loc	1 64 39                         # support/geolab/query.c:64:39
	add	rcx, 1
.Ltmp77:
	#DEBUG_VALUE: i <- $rcx
	.loc	1 64 30 is_stmt 0               # support/geolab/query.c:64:30
	add	r15, 24
	cmp	rax, rcx
.Ltmp78:
	.loc	1 64 9                          # support/geolab/query.c:64:9
	je	.LBB1_28
.Ltmp79:
.LBB1_25:                               # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: query_points:points <- [DW_OP_LLVM_entry_value 1] $rdi
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	#DEBUG_VALUE: query_points:selected <- $r13
	#DEBUG_VALUE: query_points:out <- $rbp
	#DEBUG_VALUE: i <- $rcx
	#DEBUG_VALUE: k <- $rdx
	.loc	1 0 9                           # support/geolab/query.c:0:9
	mov	rsi, qword ptr [rsp]            # 8-byte Reload
.Ltmp80:
	#DEBUG_VALUE: query_points:dist <- $rsi
	.loc	1 65 17 is_stmt 1               # support/geolab/query.c:65:17
	movsd	xmm0, qword ptr [rsi + 8*rcx]   # xmm0 = mem[0],zero
	.loc	1 65 25 is_stmt 0               # support/geolab/query.c:65:25
	ucomisd	xmm1, xmm0
.Ltmp81:
	.loc	1 65 17                         # support/geolab/query.c:65:17
	jb	.LBB1_27
.Ltmp82:
# %bb.26:                               #   in Loop: Header=BB1_25 Depth=1
	#DEBUG_VALUE: query_points:points <- [DW_OP_LLVM_entry_value 1] $rdi
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- $rsi
	#DEBUG_VALUE: query_points:selected <- $r13
	#DEBUG_VALUE: query_points:out <- $rbp
	#DEBUG_VALUE: i <- $rcx
	#DEBUG_VALUE: k <- $rdx
	.loc	1 66 39 is_stmt 1               # support/geolab/query.c:66:39
	mov	rsi, qword ptr [r15]
.Ltmp83:
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	.loc	1 66 24 is_stmt 0               # support/geolab/query.c:66:24
	mov	rdi, rdx
	shl	rdi, 4
	.loc	1 66 27                         # support/geolab/query.c:66:27
	mov	qword ptr [rbp + rdi], rsi
	.loc	1 67 36 is_stmt 1               # support/geolab/query.c:67:36
	movsd	qword ptr [rbp + rdi + 8], xmm0
	.loc	1 68 17                         # support/geolab/query.c:68:17
	add	rdx, 1
.Ltmp84:
	#DEBUG_VALUE: k <- $rdx
	.loc	1 0 17 is_stmt 0                # support/geolab/query.c:0:17
	jmp	.LBB1_27
.Ltmp85:
.LBB1_18:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	mov	rdi, qword ptr [rsp]            # 8-byte Reload
.Ltmp86:
	#DEBUG_VALUE: query_points:dist <- $rdi
	call	free@PLT
.Ltmp87:
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	xor	r13d, r13d
.Ltmp88:
	#DEBUG_VALUE: query_points:selected <- undef
	jmp	.LBB1_31
.Ltmp89:
.LBB1_21:
	#DEBUG_VALUE: query_points:points <- $r15
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- $rax
	#DEBUG_VALUE: query_points:selected <- $rdi
	#DEBUG_VALUE: query_points:out <- 0
	mov	r13, rdi
.Ltmp90:
	#DEBUG_VALUE: query_points:selected <- $r13
	#DEBUG_VALUE: query_points:selected <- $r13
	xor	ebp, ebp
	jmp	.LBB1_29
.Ltmp91:
.LBB1_28:
	#DEBUG_VALUE: query_points:points <- [DW_OP_LLVM_entry_value 1] $rdi
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- $xmm1
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	#DEBUG_VALUE: query_points:selected <- $r13
	#DEBUG_VALUE: query_points:out <- $rbp
	#DEBUG_VALUE: k <- $rdx
	.loc	1 72 9 is_stmt 1                # support/geolab/query.c:72:9
	lea	rcx, [rip + query_hit_compare]
	mov	edx, 16
.Ltmp92:
	mov	rdi, rbp
	mov	rsi, r13
	call	qsort@PLT
.Ltmp93:
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
.LBB1_29:
	#DEBUG_VALUE: query_points:points <- [DW_OP_LLVM_entry_value 1] $rdi
	#DEBUG_VALUE: query_points:count <- $r14
	#DEBUG_VALUE: query_points:lat <- [DW_OP_plus_uconst 56] [$rsp+0]
	#DEBUG_VALUE: query_points:lon <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: query_points:radius_km <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: query_points:hits <- $r12
	#DEBUG_VALUE: query_points:nhits <- $rbx
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	#DEBUG_VALUE: query_points:selected <- $r13
	#DEBUG_VALUE: query_points:out <- $rbp
	.loc	1 0 9 is_stmt 0                 # support/geolab/query.c:0:9
	mov	rdi, qword ptr [rsp]            # 8-byte Reload
.Ltmp94:
	#DEBUG_VALUE: query_points:dist <- $rdi
	.loc	1 74 5 is_stmt 1                # support/geolab/query.c:74:5
	call	free@PLT
.Ltmp95:
	#DEBUG_VALUE: query_points:dist <- [$rsp+0]
	.loc	1 76 11                         # support/geolab/query.c:76:11
	mov	qword ptr [r12], rbp
	.loc	1 77 12                         # support/geolab/query.c:77:12
	mov	qword ptr [rbx], r13
	jmp	.LBB1_30
.Ltmp96:
.Lfunc_end1:
	.size	query_points, .Lfunc_end1-query_points
	.cfi_endproc
	.file	2 "/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" "support/geolab/geolab.h"
	.file	3 "/usr/include" "stdlib.h"
	.file	4 "/usr/lib/llvm-14/lib/clang/14.0.0/include" "stddef.h"
                                        # -- End function
	.file	5 "/usr/include/x86_64-linux-gnu/bits" "types.h"
	.file	6 "/usr/include/x86_64-linux-gnu/bits" "stdint-uintn.h"
	.file	7 "/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" "support/geolab/geolab_types.h"
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp13-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	85                              # DW_OP_reg5
	.quad	.Ltmp13-.Lfunc_begin0
	.quad	.Ltmp74-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	95                              # DW_OP_reg15
	.quad	.Ltmp74-.Lfunc_begin0
	.quad	.Ltmp85-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	85                              # DW_OP_reg5
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp85-.Lfunc_begin0
	.quad	.Ltmp91-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	95                              # DW_OP_reg15
	.quad	.Ltmp91-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	85                              # DW_OP_reg5
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc1:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp13-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	84                              # DW_OP_reg4
	.quad	.Ltmp13-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	94                              # DW_OP_reg14
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	84                              # DW_OP_reg4
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	94                              # DW_OP_reg14
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp16-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	97                              # DW_OP_reg17
	.quad	.Ltmp16-.Lfunc_begin0
	.quad	.Ltmp47-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	56                              # 56
	.quad	.Ltmp47-.Lfunc_begin0
	.quad	.Ltmp49-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	97                              # DW_OP_reg17
	.quad	.Ltmp49-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	56                              # 56
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	97                              # DW_OP_reg17
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	56                              # 56
	.quad	0
	.quad	0
.Ldebug_loc3:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp17-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	98                              # DW_OP_reg18
	.quad	.Ltmp17-.Lfunc_begin0
	.quad	.Ltmp48-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	192                             # 64
	.byte	0                               # 
	.quad	.Ltmp48-.Lfunc_begin0
	.quad	.Ltmp49-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	98                              # DW_OP_reg18
	.quad	.Ltmp49-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	192                             # 64
	.byte	0                               # 
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	98                              # DW_OP_reg18
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	192                             # 64
	.byte	0                               # 
	.quad	0
	.quad	0
.Ldebug_loc4:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp15-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	99                              # DW_OP_reg19
	.quad	.Ltmp15-.Lfunc_begin0
	.quad	.Ltmp21-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	16                              # 16
	.quad	.Ltmp21-.Lfunc_begin0
	.quad	.Ltmp29-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	98                              # DW_OP_reg18
	.quad	.Ltmp29-.Lfunc_begin0
	.quad	.Ltmp53-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	16                              # 16
	.quad	.Ltmp53-.Lfunc_begin0
	.quad	.Ltmp67-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	98                              # DW_OP_reg18
	.quad	.Ltmp67-.Lfunc_begin0
	.quad	.Ltmp72-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	16                              # 16
	.quad	.Ltmp72-.Lfunc_begin0
	.quad	.Ltmp73-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	98                              # DW_OP_reg18
	.quad	.Ltmp73-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	16                              # 16
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	99                              # DW_OP_reg19
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Ltmp85-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	98                              # DW_OP_reg18
	.quad	.Ltmp85-.Lfunc_begin0
	.quad	.Ltmp89-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	16                              # 16
	.quad	.Ltmp89-.Lfunc_begin0
	.quad	.Ltmp93-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	98                              # DW_OP_reg18
	.quad	.Ltmp93-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	16                              # 16
	.quad	0
	.quad	0
.Ldebug_loc5:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp13-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	81                              # DW_OP_reg1
	.quad	.Ltmp13-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	92                              # DW_OP_reg12
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	81                              # DW_OP_reg1
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	92                              # DW_OP_reg12
	.quad	0
	.quad	0
.Ldebug_loc6:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp12-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	82                              # DW_OP_reg2
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Ltmp28-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	83                              # DW_OP_reg3
	.quad	.Ltmp28-.Lfunc_begin0
	.quad	.Ltmp35-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	40                              # 40
	.quad	.Ltmp35-.Lfunc_begin0
	.quad	.Ltmp75-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	83                              # DW_OP_reg3
	.quad	.Ltmp75-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	82                              # DW_OP_reg2
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	83                              # DW_OP_reg3
	.quad	0
	.quad	0
.Ldebug_loc7:
	.quad	.Ltmp25-.Lfunc_begin0
	.quad	.Ltmp29-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp29-.Lfunc_begin0
	.quad	.Ltmp31-.Lfunc_begin0
	.short	9                               # Loc expr size
	.byte	118                             # DW_OP_breg6
	.byte	0                               # 0
	.byte	126                             # DW_OP_breg14
	.byte	0                               # 0
	.byte	28                              # DW_OP_minus
	.byte	17                              # DW_OP_consts
	.byte	127                             # -1
	.byte	27                              # DW_OP_div
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp31-.Lfunc_begin0
	.quad	.Ltmp33-.Lfunc_begin0
	.short	12                              # Loc expr size
	.byte	118                             # DW_OP_breg6
	.byte	0                               # 0
	.byte	126                             # DW_OP_breg14
	.byte	0                               # 0
	.byte	28                              # DW_OP_minus
	.byte	17                              # DW_OP_consts
	.byte	127                             # -1
	.byte	27                              # DW_OP_div
	.byte	17                              # DW_OP_consts
	.byte	1                               # 1
	.byte	34                              # DW_OP_plus
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc8:
	.quad	.Ltmp39-.Lfunc_begin0
	.quad	.Ltmp40-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	80                              # DW_OP_reg0
	.quad	.Ltmp40-.Lfunc_begin0
	.quad	.Ltmp42-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	0                               # 0
	.quad	.Ltmp42-.Lfunc_begin0
	.quad	.Ltmp49-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	80                              # DW_OP_reg0
	.quad	.Ltmp49-.Lfunc_begin0
	.quad	.Ltmp56-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	0                               # 0
	.quad	.Ltmp56-.Lfunc_begin0
	.quad	.Ltmp63-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	80                              # DW_OP_reg0
	.quad	.Ltmp63-.Lfunc_begin0
	.quad	.Ltmp73-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	0                               # 0
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Ltmp80-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	0                               # 0
	.quad	.Ltmp80-.Lfunc_begin0
	.quad	.Ltmp83-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	84                              # DW_OP_reg4
	.quad	.Ltmp83-.Lfunc_begin0
	.quad	.Ltmp86-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	0                               # 0
	.quad	.Ltmp86-.Lfunc_begin0
	.quad	.Ltmp87-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	85                              # DW_OP_reg5
	.quad	.Ltmp87-.Lfunc_begin0
	.quad	.Ltmp89-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	0                               # 0
	.quad	.Ltmp89-.Lfunc_begin0
	.quad	.Ltmp91-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	80                              # DW_OP_reg0
	.quad	.Ltmp91-.Lfunc_begin0
	.quad	.Ltmp94-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	0                               # 0
	.quad	.Ltmp94-.Lfunc_begin0
	.quad	.Ltmp95-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	85                              # DW_OP_reg5
	.quad	.Ltmp95-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	0                               # 0
	.quad	0
	.quad	0
.Ldebug_loc9:
	.quad	.Ltmp42-.Lfunc_begin0
	.quad	.Ltmp43-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp43-.Lfunc_begin0
	.quad	.Ltmp60-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	86                              # DW_OP_reg6
	.quad	0
	.quad	0
.Ldebug_loc10:
	.quad	.Ltmp42-.Lfunc_begin0
	.quad	.Ltmp43-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp43-.Lfunc_begin0
	.quad	.Ltmp44-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	85                              # DW_OP_reg5
	.quad	.Ltmp44-.Lfunc_begin0
	.quad	.Ltmp54-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	48                              # 48
	.quad	.Ltmp54-.Lfunc_begin0
	.quad	.Ltmp66-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	85                              # DW_OP_reg5
	.quad	.Ltmp66-.Lfunc_begin0
	.quad	.Ltmp73-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	93                              # DW_OP_reg13
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Ltmp85-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	93                              # DW_OP_reg13
	.quad	.Ltmp89-.Lfunc_begin0
	.quad	.Ltmp90-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	85                              # DW_OP_reg5
	.quad	.Ltmp90-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	93                              # DW_OP_reg13
	.quad	0
	.quad	0
.Ldebug_loc11:
	.quad	.Ltmp43-.Lfunc_begin0
	.quad	.Ltmp46-.Lfunc_begin0
	.short	10                              # Loc expr size
	.byte	158                             # DW_OP_implicit_value
	.byte	8                               # 8
	.byte	0                               #  
	.byte	0                               #  
	.byte	0                               #  
	.byte	0                               #  
	.byte	0                               #  
	.byte	0                               #  
	.byte	0                               #  
	.byte	0                               #  
	.quad	.Ltmp46-.Lfunc_begin0
	.quad	.Ltmp52-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	8                               # 8
	.quad	.Ltmp52-.Lfunc_begin0
	.quad	.Ltmp60-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	97                              # DW_OP_reg17
	.quad	0
	.quad	0
.Ldebug_loc12:
	.quad	.Ltmp60-.Lfunc_begin0
	.quad	.Ltmp67-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp67-.Lfunc_begin0
	.quad	.Ltmp71-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	80                              # DW_OP_reg0
	.quad	.Ltmp71-.Lfunc_begin0
	.quad	.Ltmp73-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	86                              # DW_OP_reg6
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Ltmp85-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	86                              # DW_OP_reg6
	.quad	.Ltmp89-.Lfunc_begin0
	.quad	.Ltmp91-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp91-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	86                              # DW_OP_reg6
	.quad	0
	.quad	0
.Ldebug_loc13:
	.quad	.Ltmp70-.Lfunc_begin0
	.quad	.Ltmp73-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Ltmp85-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	82                              # DW_OP_reg2
	.quad	0
	.quad	0
.Ldebug_loc14:
	.quad	.Ltmp70-.Lfunc_begin0
	.quad	.Ltmp73-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Ltmp85-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	81                              # DW_OP_reg1
	.quad	.Ltmp91-.Lfunc_begin0
	.quad	.Ltmp92-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	81                              # DW_OP_reg1
	.quad	0
	.quad	0
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
	.ascii	"\227B"                         # DW_AT_GNU_all_call_sites
	.byte	25                              # DW_FORM_flag_present
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
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	23                              # DW_FORM_sec_offset
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
	.byte	7                               # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	23                              # DW_FORM_sec_offset
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
	.byte	8                               # Abbreviation Code
	.byte	11                              # DW_TAG_lexical_block
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	9                               # Abbreviation Code
	.byte	11                              # DW_TAG_lexical_block
	.byte	1                               # DW_CHILDREN_yes
	.byte	85                              # DW_AT_ranges
	.byte	23                              # DW_FORM_sec_offset
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	10                              # Abbreviation Code
	.ascii	"\211\202\001"                  # DW_TAG_GNU_call_site
	.byte	0                               # DW_CHILDREN_no
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	11                              # Abbreviation Code
	.ascii	"\211\202\001"                  # DW_TAG_GNU_call_site
	.byte	1                               # DW_CHILDREN_yes
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	12                              # Abbreviation Code
	.ascii	"\212\202\001"                  # DW_TAG_GNU_call_site_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.ascii	"\221B"                         # DW_AT_GNU_call_site_value
	.byte	24                              # DW_FORM_exprloc
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	13                              # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
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
	.byte	60                              # DW_AT_declaration
	.byte	25                              # DW_FORM_flag_present
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	14                              # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	15                              # Abbreviation Code
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
	.byte	16                              # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	17                              # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	5                               # DW_FORM_data2
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	60                              # DW_AT_declaration
	.byte	25                              # DW_FORM_flag_present
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	18                              # Abbreviation Code
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
	.byte	19                              # Abbreviation Code
	.byte	22                              # DW_TAG_typedef
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	3                               # DW_AT_name
	.byte	14                              # DW_FORM_strp
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	5                               # DW_FORM_data2
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	20                              # Abbreviation Code
	.byte	21                              # DW_TAG_subroutine_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	21                              # Abbreviation Code
	.byte	38                              # DW_TAG_const_type
	.byte	0                               # DW_CHILDREN_no
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	22                              # Abbreviation Code
	.byte	38                              # DW_TAG_const_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	23                              # Abbreviation Code
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
	.byte	24                              # Abbreviation Code
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
	.byte	1                               # Abbrev [1] 0xb:0x337 DW_TAG_compile_unit
	.long	.Linfo_string0                  # DW_AT_producer
	.short	12                              # DW_AT_language
	.long	.Linfo_string1                  # DW_AT_name
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.long	.Linfo_string2                  # DW_AT_comp_dir
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin0       # DW_AT_high_pc
	.byte	2                               # Abbrev [2] 0x2a:0x1 DW_TAG_pointer_type
	.byte	3                               # Abbrev [3] 0x2b:0x4e DW_TAG_subprogram
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	.Linfo_string11                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	542                             # DW_AT_type
                                        # DW_AT_external
	.byte	4                               # Abbrev [4] 0x44:0xd DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	85
	.long	.Linfo_string13                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.long	678                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x51:0xd DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	84
	.long	.Linfo_string14                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.long	678                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x5e:0xd DW_TAG_variable
	.byte	1                               # DW_AT_location
	.byte	85
	.long	.Linfo_string15                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	13                              # DW_AT_decl_line
	.long	684                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x6b:0xd DW_TAG_variable
	.byte	1                               # DW_AT_location
	.byte	84
	.long	.Linfo_string21                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	13                              # DW_AT_decl_line
	.long	684                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	3                               # Abbrev [3] 0x79:0x18f DW_TAG_subprogram
	.quad	.Lfunc_begin1                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin1       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	.Linfo_string12                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	542                             # DW_AT_type
                                        # DW_AT_external
	.byte	6                               # Abbrev [6] 0x92:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc0                    # DW_AT_location
	.long	.Linfo_string22                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
	.long	756                             # DW_AT_type
	.byte	6                               # Abbrev [6] 0xa1:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc1                    # DW_AT_location
	.long	.Linfo_string26                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
	.long	627                             # DW_AT_type
	.byte	6                               # Abbrev [6] 0xb0:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc2                    # DW_AT_location
	.long	.Linfo_string27                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
	.long	549                             # DW_AT_type
	.byte	6                               # Abbrev [6] 0xbf:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc3                    # DW_AT_location
	.long	.Linfo_string28                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
	.long	549                             # DW_AT_type
	.byte	6                               # Abbrev [6] 0xce:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc4                    # DW_AT_location
	.long	.Linfo_string29                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
	.long	549                             # DW_AT_type
	.byte	6                               # Abbrev [6] 0xdd:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc5                    # DW_AT_location
	.long	.Linfo_string30                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
	.long	818                             # DW_AT_type
	.byte	6                               # Abbrev [6] 0xec:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc6                    # DW_AT_location
	.long	.Linfo_string31                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	22                              # DW_AT_decl_line
	.long	828                             # DW_AT_type
	.byte	7                               # Abbrev [7] 0xfb:0xf DW_TAG_variable
	.long	.Ldebug_loc8                    # DW_AT_location
	.long	.Linfo_string33                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	39                              # DW_AT_decl_line
	.long	593                             # DW_AT_type
	.byte	7                               # Abbrev [7] 0x10a:0xf DW_TAG_variable
	.long	.Ldebug_loc10                   # DW_AT_location
	.long	.Linfo_string34                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	41                              # DW_AT_decl_line
	.long	627                             # DW_AT_type
	.byte	7                               # Abbrev [7] 0x119:0xf DW_TAG_variable
	.long	.Ldebug_loc12                   # DW_AT_location
	.long	.Linfo_string36                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	52                              # DW_AT_decl_line
	.long	823                             # DW_AT_type
	.byte	8                               # Abbrev [8] 0x128:0x1d DW_TAG_lexical_block
	.quad	.Ltmp25                         # DW_AT_low_pc
	.long	.Ltmp35-.Ltmp25                 # DW_AT_high_pc
	.byte	7                               # Abbrev [7] 0x135:0xf DW_TAG_variable
	.long	.Ldebug_loc7                    # DW_AT_location
	.long	.Linfo_string32                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	28                              # DW_AT_decl_line
	.long	627                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	8                               # Abbrev [8] 0x145:0x3a DW_TAG_lexical_block
	.quad	.Ltmp42                         # DW_AT_low_pc
	.long	.Ltmp60-.Ltmp42                 # DW_AT_high_pc
	.byte	7                               # Abbrev [7] 0x152:0xf DW_TAG_variable
	.long	.Ldebug_loc9                    # DW_AT_location
	.long	.Linfo_string32                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.long	627                             # DW_AT_type
	.byte	8                               # Abbrev [8] 0x161:0x1d DW_TAG_lexical_block
	.quad	.Ltmp44                         # DW_AT_low_pc
	.long	.Ltmp57-.Ltmp44                 # DW_AT_high_pc
	.byte	7                               # Abbrev [7] 0x16e:0xf DW_TAG_variable
	.long	.Ldebug_loc11                   # DW_AT_location
	.long	.Linfo_string35                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	43                              # DW_AT_decl_line
	.long	549                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	9                               # Abbrev [9] 0x17f:0x2a DW_TAG_lexical_block
	.long	.Ldebug_ranges0                 # DW_AT_ranges
	.byte	7                               # Abbrev [7] 0x184:0xf DW_TAG_variable
	.long	.Ldebug_loc14                   # DW_AT_location
	.long	.Linfo_string37                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	63                              # DW_AT_decl_line
	.long	627                             # DW_AT_type
	.byte	9                               # Abbrev [9] 0x193:0x15 DW_TAG_lexical_block
	.long	.Ldebug_ranges1                 # DW_AT_ranges
	.byte	7                               # Abbrev [7] 0x198:0xf DW_TAG_variable
	.long	.Ldebug_loc13                   # DW_AT_location
	.long	.Linfo_string32                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	64                              # DW_AT_decl_line
	.long	627                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	10                              # Abbrev [10] 0x1a9:0xd DW_TAG_GNU_call_site
	.long	520                             # DW_AT_abstract_origin
	.quad	.Ltmp18                         # DW_AT_low_pc
	.byte	10                              # Abbrev [10] 0x1b6:0xd DW_TAG_GNU_call_site
	.long	520                             # DW_AT_abstract_origin
	.quad	.Ltmp30                         # DW_AT_low_pc
	.byte	11                              # Abbrev [11] 0x1c3:0x25 DW_TAG_GNU_call_site
	.long	556                             # DW_AT_abstract_origin
	.quad	.Ltmp49                         # DW_AT_low_pc
	.byte	12                              # Abbrev [12] 0x1d0:0x6 DW_TAG_GNU_call_site_parameter
	.byte	1                               # DW_AT_location
	.byte	85
	.byte	2                               # DW_AT_GNU_call_site_value
	.byte	145
	.byte	8
	.byte	12                              # Abbrev [12] 0x1d6:0x9 DW_TAG_GNU_call_site_parameter
	.byte	1                               # DW_AT_location
	.byte	98
	.byte	5                               # DW_AT_GNU_call_site_value
	.byte	145
	.asciz	"\300"
	.byte	148
	.byte	8
	.byte	12                              # Abbrev [12] 0x1df:0x8 DW_TAG_GNU_call_site_parameter
	.byte	1                               # DW_AT_location
	.byte	97
	.byte	4                               # DW_AT_GNU_call_site_value
	.byte	145
	.byte	56
	.byte	148
	.byte	8
	.byte	0                               # End Of Children Mark
	.byte	11                              # Abbrev [11] 0x1e8:0x1f DW_TAG_GNU_call_site
	.long	598                             # DW_AT_abstract_origin
	.quad	.Ltmp93                         # DW_AT_low_pc
	.byte	12                              # Abbrev [12] 0x1f5:0x6 DW_TAG_GNU_call_site_parameter
	.byte	1                               # DW_AT_location
	.byte	84
	.byte	2                               # DW_AT_GNU_call_site_value
	.byte	125
	.byte	0
	.byte	12                              # Abbrev [12] 0x1fb:0x6 DW_TAG_GNU_call_site_parameter
	.byte	1                               # DW_AT_location
	.byte	85
	.byte	2                               # DW_AT_GNU_call_site_value
	.byte	118
	.byte	0
	.byte	12                              # Abbrev [12] 0x201:0x5 DW_TAG_GNU_call_site_parameter
	.byte	1                               # DW_AT_location
	.byte	81
	.byte	1                               # DW_AT_GNU_call_site_value
	.byte	64
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	13                              # Abbrev [13] 0x208:0x16 DW_TAG_subprogram
	.long	.Linfo_string3                  # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	34                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	542                             # DW_AT_type
                                        # DW_AT_declaration
                                        # DW_AT_external
	.byte	14                              # Abbrev [14] 0x213:0x5 DW_TAG_formal_parameter
	.long	549                             # DW_AT_type
	.byte	14                              # Abbrev [14] 0x218:0x5 DW_TAG_formal_parameter
	.long	549                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	15                              # Abbrev [15] 0x21e:0x7 DW_TAG_base_type
	.long	.Linfo_string4                  # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	15                              # Abbrev [15] 0x225:0x7 DW_TAG_base_type
	.long	.Linfo_string5                  # DW_AT_name
	.byte	4                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	13                              # Abbrev [13] 0x22c:0x25 DW_TAG_subprogram
	.long	.Linfo_string6                  # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	38                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	542                             # DW_AT_type
                                        # DW_AT_declaration
                                        # DW_AT_external
	.byte	14                              # Abbrev [14] 0x237:0x5 DW_TAG_formal_parameter
	.long	549                             # DW_AT_type
	.byte	14                              # Abbrev [14] 0x23c:0x5 DW_TAG_formal_parameter
	.long	549                             # DW_AT_type
	.byte	14                              # Abbrev [14] 0x241:0x5 DW_TAG_formal_parameter
	.long	549                             # DW_AT_type
	.byte	14                              # Abbrev [14] 0x246:0x5 DW_TAG_formal_parameter
	.long	549                             # DW_AT_type
	.byte	14                              # Abbrev [14] 0x24b:0x5 DW_TAG_formal_parameter
	.long	593                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	16                              # Abbrev [16] 0x251:0x5 DW_TAG_pointer_type
	.long	549                             # DW_AT_type
	.byte	17                              # Abbrev [17] 0x256:0x1d DW_TAG_subprogram
	.long	.Linfo_string7                  # DW_AT_name
	.byte	3                               # DW_AT_decl_file
	.short	838                             # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_declaration
                                        # DW_AT_external
	.byte	14                              # Abbrev [14] 0x25e:0x5 DW_TAG_formal_parameter
	.long	42                              # DW_AT_type
	.byte	14                              # Abbrev [14] 0x263:0x5 DW_TAG_formal_parameter
	.long	627                             # DW_AT_type
	.byte	14                              # Abbrev [14] 0x268:0x5 DW_TAG_formal_parameter
	.long	627                             # DW_AT_type
	.byte	14                              # Abbrev [14] 0x26d:0x5 DW_TAG_formal_parameter
	.long	645                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	18                              # Abbrev [18] 0x273:0xb DW_TAG_typedef
	.long	638                             # DW_AT_type
	.long	.Linfo_string9                  # DW_AT_name
	.byte	4                               # DW_AT_decl_file
	.byte	46                              # DW_AT_decl_line
	.byte	15                              # Abbrev [15] 0x27e:0x7 DW_TAG_base_type
	.long	.Linfo_string8                  # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	19                              # Abbrev [19] 0x285:0xc DW_TAG_typedef
	.long	657                             # DW_AT_type
	.long	.Linfo_string10                 # DW_AT_name
	.byte	3                               # DW_AT_decl_file
	.short	816                             # DW_AT_decl_line
	.byte	16                              # Abbrev [16] 0x291:0x5 DW_TAG_pointer_type
	.long	662                             # DW_AT_type
	.byte	20                              # Abbrev [20] 0x296:0x10 DW_TAG_subroutine_type
	.long	542                             # DW_AT_type
                                        # DW_AT_prototyped
	.byte	14                              # Abbrev [14] 0x29b:0x5 DW_TAG_formal_parameter
	.long	678                             # DW_AT_type
	.byte	14                              # Abbrev [14] 0x2a0:0x5 DW_TAG_formal_parameter
	.long	678                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	16                              # Abbrev [16] 0x2a6:0x5 DW_TAG_pointer_type
	.long	683                             # DW_AT_type
	.byte	21                              # Abbrev [21] 0x2ab:0x1 DW_TAG_const_type
	.byte	16                              # Abbrev [16] 0x2ac:0x5 DW_TAG_pointer_type
	.long	689                             # DW_AT_type
	.byte	22                              # Abbrev [22] 0x2b1:0x5 DW_TAG_const_type
	.long	694                             # DW_AT_type
	.byte	18                              # Abbrev [18] 0x2b6:0xb DW_TAG_typedef
	.long	705                             # DW_AT_type
	.long	.Linfo_string20                 # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	23                              # Abbrev [23] 0x2c1:0x1d DW_TAG_structure_type
	.byte	16                              # DW_AT_byte_size
	.byte	2                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	24                              # Abbrev [24] 0x2c5:0xc DW_TAG_member
	.long	.Linfo_string16                 # DW_AT_name
	.long	734                             # DW_AT_type
	.byte	2                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	0                               # DW_AT_data_member_location
	.byte	24                              # Abbrev [24] 0x2d1:0xc DW_TAG_member
	.long	.Linfo_string19                 # DW_AT_name
	.long	549                             # DW_AT_type
	.byte	2                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	8                               # DW_AT_data_member_location
	.byte	0                               # End Of Children Mark
	.byte	18                              # Abbrev [18] 0x2de:0xb DW_TAG_typedef
	.long	745                             # DW_AT_type
	.long	.Linfo_string18                 # DW_AT_name
	.byte	6                               # DW_AT_decl_file
	.byte	27                              # DW_AT_decl_line
	.byte	18                              # Abbrev [18] 0x2e9:0xb DW_TAG_typedef
	.long	638                             # DW_AT_type
	.long	.Linfo_string17                 # DW_AT_name
	.byte	5                               # DW_AT_decl_file
	.byte	45                              # DW_AT_decl_line
	.byte	16                              # Abbrev [16] 0x2f4:0x5 DW_TAG_pointer_type
	.long	761                             # DW_AT_type
	.byte	22                              # Abbrev [22] 0x2f9:0x5 DW_TAG_const_type
	.long	766                             # DW_AT_type
	.byte	18                              # Abbrev [18] 0x2fe:0xb DW_TAG_typedef
	.long	777                             # DW_AT_type
	.long	.Linfo_string25                 # DW_AT_name
	.byte	7                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	23                              # Abbrev [23] 0x309:0x29 DW_TAG_structure_type
	.byte	24                              # DW_AT_byte_size
	.byte	7                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	24                              # Abbrev [24] 0x30d:0xc DW_TAG_member
	.long	.Linfo_string16                 # DW_AT_name
	.long	734                             # DW_AT_type
	.byte	7                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	0                               # DW_AT_data_member_location
	.byte	24                              # Abbrev [24] 0x319:0xc DW_TAG_member
	.long	.Linfo_string23                 # DW_AT_name
	.long	549                             # DW_AT_type
	.byte	7                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	8                               # DW_AT_data_member_location
	.byte	24                              # Abbrev [24] 0x325:0xc DW_TAG_member
	.long	.Linfo_string24                 # DW_AT_name
	.long	549                             # DW_AT_type
	.byte	7                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	16                              # DW_AT_data_member_location
	.byte	0                               # End Of Children Mark
	.byte	16                              # Abbrev [16] 0x332:0x5 DW_TAG_pointer_type
	.long	823                             # DW_AT_type
	.byte	16                              # Abbrev [16] 0x337:0x5 DW_TAG_pointer_type
	.long	694                             # DW_AT_type
	.byte	16                              # Abbrev [16] 0x33c:0x5 DW_TAG_pointer_type
	.long	627                             # DW_AT_type
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.quad	.Ltmp62-.Lfunc_begin0
	.quad	.Ltmp73-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Ltmp85-.Lfunc_begin0
	.quad	.Ltmp91-.Lfunc_begin0
	.quad	.Ltmp93-.Lfunc_begin0
	.quad	0
	.quad	0
.Ldebug_ranges1:
	.quad	.Ltmp70-.Lfunc_begin0
	.quad	.Ltmp73-.Lfunc_begin0
	.quad	.Ltmp76-.Lfunc_begin0
	.quad	.Ltmp85-.Lfunc_begin0
	.quad	0
	.quad	0
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"Ubuntu clang version 14.0.0-1ubuntu1.1" # string offset=0
.Linfo_string1:
	.asciz	"support/geolab/query.c"        # string offset=39
.Linfo_string2:
	.asciz	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" # string offset=62
.Linfo_string3:
	.asciz	"geo_valid_position"            # string offset=155
.Linfo_string4:
	.asciz	"int"                           # string offset=174
.Linfo_string5:
	.asciz	"double"                        # string offset=178
.Linfo_string6:
	.asciz	"geo_distance_km"               # string offset=185
.Linfo_string7:
	.asciz	"qsort"                         # string offset=201
.Linfo_string8:
	.asciz	"unsigned long"                 # string offset=207
.Linfo_string9:
	.asciz	"size_t"                        # string offset=221
.Linfo_string10:
	.asciz	"__compar_fn_t"                 # string offset=228
.Linfo_string11:
	.asciz	"query_hit_compare"             # string offset=242
.Linfo_string12:
	.asciz	"query_points"                  # string offset=260
.Linfo_string13:
	.asciz	"a"                             # string offset=273
.Linfo_string14:
	.asciz	"b"                             # string offset=275
.Linfo_string15:
	.asciz	"x"                             # string offset=277
.Linfo_string16:
	.asciz	"id"                            # string offset=279
.Linfo_string17:
	.asciz	"__uint64_t"                    # string offset=282
.Linfo_string18:
	.asciz	"uint64_t"                      # string offset=293
.Linfo_string19:
	.asciz	"distance_km"                   # string offset=302
.Linfo_string20:
	.asciz	"QueryHit"                      # string offset=314
.Linfo_string21:
	.asciz	"y"                             # string offset=323
.Linfo_string22:
	.asciz	"points"                        # string offset=325
.Linfo_string23:
	.asciz	"lat_deg"                       # string offset=332
.Linfo_string24:
	.asciz	"lon_deg"                       # string offset=340
.Linfo_string25:
	.asciz	"GeoPoint"                      # string offset=348
.Linfo_string26:
	.asciz	"count"                         # string offset=357
.Linfo_string27:
	.asciz	"lat"                           # string offset=363
.Linfo_string28:
	.asciz	"lon"                           # string offset=367
.Linfo_string29:
	.asciz	"radius_km"                     # string offset=371
.Linfo_string30:
	.asciz	"hits"                          # string offset=381
.Linfo_string31:
	.asciz	"nhits"                         # string offset=386
.Linfo_string32:
	.asciz	"i"                             # string offset=392
.Linfo_string33:
	.asciz	"dist"                          # string offset=394
.Linfo_string34:
	.asciz	"selected"                      # string offset=399
.Linfo_string35:
	.asciz	"d"                             # string offset=408
.Linfo_string36:
	.asciz	"out"                           # string offset=410
.Linfo_string37:
	.asciz	"k"                             # string offset=414
	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym query_hit_compare
	.section	.debug_line,"",@progbits
.Lline_table_start0:
