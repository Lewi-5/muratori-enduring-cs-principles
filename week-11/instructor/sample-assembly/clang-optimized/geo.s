	.text
	.intel_syntax noprefix
	.file	"geo.c"
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4                               # -- Begin function geo_valid_position
.LCPI0_0:
	.quad	0x7fffffffffffffff              # double NaN
	.quad	0x7fffffffffffffff              # double NaN
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI0_1:
	.quad	0x7ff0000000000000              # double +Inf
.LCPI0_2:
	.quad	0xc066800000000000              # double -180
.LCPI0_3:
	.quad	0x4056800000000000              # double 90
.LCPI0_4:
	.quad	0xc056800000000000              # double -90
.LCPI0_5:
	.quad	0x4066800000000000              # double 180
	.text
	.globl	geo_valid_position
	.p2align	4, 0x90
	.type	geo_valid_position,@function
geo_valid_position:                     # @geo_valid_position
.Lfunc_begin0:
	.file	1 "/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" "support/geolab/geo.c"
	.loc	1 12 0                          # support/geolab/geo.c:12:0
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm0
	#DEBUG_VALUE: geo_valid_position:lon_deg <- $xmm1
	movapd	xmm2, xmmword ptr [rip + .LCPI0_0] # xmm2 = [NaN,NaN]
.Ltmp0:
	.loc	1 13 12 prologue_end            # support/geolab/geo.c:13:12
	andpd	xmm2, xmm0
	xor	eax, eax
	ucomisd	xmm2, qword ptr [rip + .LCPI0_1]
	.loc	1 13 30 is_stmt 0               # support/geolab/geo.c:13:30
	je	.LBB0_6
.Ltmp1:
# %bb.1:
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm0
	#DEBUG_VALUE: geo_valid_position:lon_deg <- $xmm1
	.loc	1 0 30                          # support/geolab/geo.c:0:30
	ucomisd	xmm1, qword ptr [rip + .LCPI0_2]
	.loc	1 13 51                         # support/geolab/geo.c:13:51
	jb	.LBB0_6
.Ltmp2:
# %bb.2:
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm0
	#DEBUG_VALUE: geo_valid_position:lon_deg <- $xmm1
	.loc	1 0 51                          # support/geolab/geo.c:0:51
	movsd	xmm2, qword ptr [rip + .LCPI0_3] # xmm2 = mem[0],zero
	.loc	1 13 51                         # support/geolab/geo.c:13:51
	ucomisd	xmm2, xmm0
	jb	.LBB0_6
.Ltmp3:
# %bb.3:
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm0
	#DEBUG_VALUE: geo_valid_position:lon_deg <- $xmm1
	ucomisd	xmm0, qword ptr [rip + .LCPI0_4]
	jb	.LBB0_6
.Ltmp4:
# %bb.4:
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm0
	#DEBUG_VALUE: geo_valid_position:lon_deg <- $xmm1
	.loc	1 0 51                          # support/geolab/geo.c:0:51
	movapd	xmm0, xmmword ptr [rip + .LCPI0_0] # xmm0 = [NaN,NaN]
.Ltmp5:
	#DEBUG_VALUE: geo_valid_position:lat_deg <- [DW_OP_LLVM_entry_value 1] $xmm0
	andpd	xmm0, xmm1
	.loc	1 13 51                         # support/geolab/geo.c:13:51
	ucomisd	xmm0, qword ptr [rip + .LCPI0_1]
	je	.LBB0_6
.Ltmp6:
# %bb.5:
	#DEBUG_VALUE: geo_valid_position:lat_deg <- [DW_OP_LLVM_entry_value 1] $xmm0
	#DEBUG_VALUE: geo_valid_position:lon_deg <- $xmm1
	.loc	1 0 51                          # support/geolab/geo.c:0:51
	movsd	xmm0, qword ptr [rip + .LCPI0_5] # xmm0 = mem[0],zero
	.loc	1 14 20 is_stmt 1               # support/geolab/geo.c:14:20
	xor	eax, eax
	ucomisd	xmm0, xmm1
	setae	al
.Ltmp7:
.LBB0_6:
	#DEBUG_VALUE: geo_valid_position:lat_deg <- [DW_OP_LLVM_entry_value 1] $xmm0
	#DEBUG_VALUE: geo_valid_position:lon_deg <- $xmm1
	.loc	1 13 5                          # support/geolab/geo.c:13:5
	ret
.Ltmp8:
.Lfunc_end0:
	.size	geo_valid_position, .Lfunc_end0-geo_valid_position
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4                               # -- Begin function geo_distance_km
.LCPI1_0:
	.quad	0x7fffffffffffffff              # double NaN
	.quad	0x7fffffffffffffff              # double NaN
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI1_1:
	.quad	0x7ff0000000000000              # double +Inf
.LCPI1_2:
	.quad	0xc066800000000000              # double -180
.LCPI1_3:
	.quad	0x4056800000000000              # double 90
.LCPI1_4:
	.quad	0xc056800000000000              # double -90
.LCPI1_5:
	.quad	0x4066800000000000              # double 180
.LCPI1_6:
	.quad	0x3f91df46a2529d39              # double 0.017453292519943295
.LCPI1_7:
	.quad	0x3fe0000000000000              # double 0.5
.LCPI1_8:
	.quad	0x3ff0000000000000              # double 1
.LCPI1_9:
	.quad	0x40b8e30240b78034              # double 6371.0087999999996
	.text
	.globl	geo_distance_km
	.p2align	4, 0x90
	.type	geo_distance_km,@function
geo_distance_km:                        # @geo_distance_km
.Lfunc_begin1:
	.loc	1 20 0                          # support/geolab/geo.c:20:0
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm0
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	push	rbx
	.cfi_def_cfa_offset 16
	sub	rsp, 80
	.cfi_def_cfa_offset 96
	.cfi_offset rbx, -16
	xor	eax, eax
.Ltmp9:
	.loc	1 21 13 prologue_end            # support/geolab/geo.c:21:13
	test	rdi, rdi
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm0
	#DEBUG_VALUE: geo_valid_position:lon_deg <- undef
	.loc	1 21 21 is_stmt 0               # support/geolab/geo.c:21:21
	je	.LBB1_17
.Ltmp10:
# %bb.1:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm0
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	.loc	1 0 21                          # support/geolab/geo.c:0:21
	movapd	xmm4, xmm0
	movapd	xmm0, xmmword ptr [rip + .LCPI1_0] # xmm0 = [NaN,NaN]
.Ltmp11:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm4
	andpd	xmm0, xmm4
	.loc	1 21 21                         # support/geolab/geo.c:21:21
	ucomisd	xmm0, qword ptr [rip + .LCPI1_1]
	je	.LBB1_17
.Ltmp12:
# %bb.2:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm4
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm4
	.loc	1 0 21                          # support/geolab/geo.c:0:21
	ucomisd	xmm1, qword ptr [rip + .LCPI1_2]
.Ltmp13:
	.loc	1 13 51 is_stmt 1               # support/geolab/geo.c:13:51
	jb	.LBB1_17
.Ltmp14:
# %bb.3:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm4
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm4
	.loc	1 0 51 is_stmt 0                # support/geolab/geo.c:0:51
	movsd	xmm0, qword ptr [rip + .LCPI1_3] # xmm0 = mem[0],zero
	.loc	1 13 51                         # support/geolab/geo.c:13:51
	ucomisd	xmm0, xmm4
	jb	.LBB1_17
.Ltmp15:
# %bb.4:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm4
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm4
	ucomisd	xmm4, qword ptr [rip + .LCPI1_4]
	jb	.LBB1_17
.Ltmp16:
# %bb.5:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm4
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm4
	.loc	1 0 51                          # support/geolab/geo.c:0:51
	movapd	xmm5, xmmword ptr [rip + .LCPI1_0] # xmm5 = [NaN,NaN]
	andpd	xmm5, xmm1
	.loc	1 13 51                         # support/geolab/geo.c:13:51
	ucomisd	xmm5, qword ptr [rip + .LCPI1_1]
	je	.LBB1_17
.Ltmp17:
# %bb.6:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm4
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm4
	.loc	1 0 51                          # support/geolab/geo.c:0:51
	movsd	xmm6, qword ptr [rip + .LCPI1_5] # xmm6 = mem[0],zero
	.loc	1 14 20 is_stmt 1               # support/geolab/geo.c:14:20
	ucomisd	xmm6, xmm1
.Ltmp18:
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm2
	#DEBUG_VALUE: geo_valid_position:lon_deg <- $xmm3
	.loc	1 21 56                         # support/geolab/geo.c:21:56
	jb	.LBB1_17
.Ltmp19:
# %bb.7:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm4
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	.loc	1 0 56 is_stmt 0                # support/geolab/geo.c:0:56
	movapd	xmm5, xmmword ptr [rip + .LCPI1_0] # xmm5 = [NaN,NaN]
	andpd	xmm5, xmm2
	.loc	1 21 56                         # support/geolab/geo.c:21:56
	ucomisd	xmm5, qword ptr [rip + .LCPI1_1]
	je	.LBB1_17
.Ltmp20:
# %bb.8:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm4
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm2
	#DEBUG_VALUE: geo_valid_position:lon_deg <- $xmm3
	.loc	1 0 56                          # support/geolab/geo.c:0:56
	ucomisd	xmm3, qword ptr [rip + .LCPI1_2]
.Ltmp21:
	.loc	1 13 51 is_stmt 1               # support/geolab/geo.c:13:51
	jb	.LBB1_17
.Ltmp22:
# %bb.9:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm4
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm2
	#DEBUG_VALUE: geo_valid_position:lon_deg <- $xmm3
	ucomisd	xmm0, xmm2
	jb	.LBB1_17
.Ltmp23:
# %bb.10:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm4
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm2
	#DEBUG_VALUE: geo_valid_position:lon_deg <- $xmm3
	ucomisd	xmm2, qword ptr [rip + .LCPI1_4]
	jb	.LBB1_17
.Ltmp24:
# %bb.11:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm4
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm2
	#DEBUG_VALUE: geo_valid_position:lon_deg <- $xmm3
	.loc	1 0 51 is_stmt 0                # support/geolab/geo.c:0:51
	movapd	xmm0, xmmword ptr [rip + .LCPI1_0] # xmm0 = [NaN,NaN]
	andpd	xmm0, xmm3
	.loc	1 13 51                         # support/geolab/geo.c:13:51
	ucomisd	xmm0, qword ptr [rip + .LCPI1_1]
	je	.LBB1_17
.Ltmp25:
# %bb.12:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm4
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	#DEBUG_VALUE: geo_valid_position:lat_deg <- $xmm2
	#DEBUG_VALUE: geo_valid_position:lon_deg <- $xmm3
	ucomisd	xmm6, xmm3
	jb	.LBB1_17
.Ltmp26:
# %bb.13:
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm4
	#DEBUG_VALUE: geo_distance_km:lon1 <- $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- $rdi
	.loc	1 0 51                          # support/geolab/geo.c:0:51
	mov	rbx, rdi
	.loc	1 22 41 is_stmt 1               # support/geolab/geo.c:22:41
	movapd	xmm0, xmm2
	subsd	xmm0, xmm4
.Ltmp27:
	#DEBUG_VALUE: deg_to_rad:degrees <- $xmm0
	.loc	1 7 59                          # support/geolab/geo.c:7:59
	mulsd	xmm0, qword ptr [rip + .LCPI1_6]
.Ltmp28:
	.loc	1 22 49                         # support/geolab/geo.c:22:49
	mulsd	xmm0, qword ptr [rip + .LCPI1_7]
	movapd	xmmword ptr [rsp + 64], xmm2    # 16-byte Spill
.Ltmp29:
	#DEBUG_VALUE: geo_distance_km:lat2 <- [DW_OP_plus_uconst 64] [$rsp+0]
	.loc	1 0 49 is_stmt 0                # support/geolab/geo.c:0:49
	movapd	xmmword ptr [rsp + 16], xmm4    # 16-byte Spill
.Ltmp30:
	#DEBUG_VALUE: geo_distance_km:lat1 <- [DW_OP_plus_uconst 16] [$rsp+0]
	movapd	xmmword ptr [rsp + 48], xmm3    # 16-byte Spill
.Ltmp31:
	#DEBUG_VALUE: geo_distance_km:lon2 <- [DW_OP_plus_uconst 48] [$rsp+0]
	movapd	xmmword ptr [rsp + 32], xmm1    # 16-byte Spill
.Ltmp32:
	#DEBUG_VALUE: geo_distance_km:lon1 <- [DW_OP_plus_uconst 32] [$rsp+0]
	.loc	1 22 21                         # support/geolab/geo.c:22:21
	call	sin@PLT
.Ltmp33:
	#DEBUG_VALUE: geo_distance_km:out <- $rbx
	.loc	1 0 21                          # support/geolab/geo.c:0:21
	movsd	qword ptr [rsp + 8], xmm0       # 8-byte Spill
.Ltmp34:
	#DEBUG_VALUE: geo_distance_km:sd_lat <- [DW_OP_plus_uconst 8] [$rsp+0]
	movapd	xmm0, xmmword ptr [rsp + 48]    # 16-byte Reload
.Ltmp35:
	#DEBUG_VALUE: geo_distance_km:lon2 <- $xmm0
	.loc	1 23 41 is_stmt 1               # support/geolab/geo.c:23:41
	subsd	xmm0, qword ptr [rsp + 32]      # 16-byte Folded Reload
.Ltmp36:
	#DEBUG_VALUE: geo_distance_km:lon2 <- [DW_OP_plus_uconst 48] [$rsp+0]
	#DEBUG_VALUE: deg_to_rad:degrees <- $xmm0
	.loc	1 7 59                          # support/geolab/geo.c:7:59
	mulsd	xmm0, qword ptr [rip + .LCPI1_6]
.Ltmp37:
	.loc	1 23 49                         # support/geolab/geo.c:23:49
	mulsd	xmm0, qword ptr [rip + .LCPI1_7]
	.loc	1 23 21 is_stmt 0               # support/geolab/geo.c:23:21
	call	sin@PLT
.Ltmp38:
	.loc	1 0 21                          # support/geolab/geo.c:0:21
	movsd	qword ptr [rsp + 32], xmm0      # 8-byte Spill
.Ltmp39:
	#DEBUG_VALUE: geo_distance_km:lon1 <- undef
	#DEBUG_VALUE: geo_distance_km:sd_lon <- [DW_OP_plus_uconst 32] [$rsp+0]
	movsd	xmm0, qword ptr [rsp + 8]       # 8-byte Reload
                                        # xmm0 = mem[0],zero
.Ltmp40:
	#DEBUG_VALUE: geo_distance_km:sd_lat <- $xmm0
	.loc	1 24 23 is_stmt 1               # support/geolab/geo.c:24:23
	mulsd	xmm0, xmm0
.Ltmp41:
	#DEBUG_VALUE: geo_distance_km:sd_lat <- [DW_OP_plus_uconst 8] [$rsp+0]
	#DEBUG_VALUE: deg_to_rad:degrees <- [DW_OP_plus_uconst 16] [$rsp+0]
	.loc	1 0 23 is_stmt 0                # support/geolab/geo.c:0:23
	movsd	qword ptr [rsp + 8], xmm0       # 8-byte Spill
.Ltmp42:
	#DEBUG_VALUE: geo_distance_km:sd_lat <- undef
	movapd	xmm0, xmmword ptr [rsp + 16]    # 16-byte Reload
.Ltmp43:
	#DEBUG_VALUE: deg_to_rad:degrees <- $xmm0
	#DEBUG_VALUE: geo_distance_km:lat1 <- $xmm0
	.loc	1 7 59 is_stmt 1                # support/geolab/geo.c:7:59
	mulsd	xmm0, qword ptr [rip + .LCPI1_6]
.Ltmp44:
	#DEBUG_VALUE: deg_to_rad:degrees <- [DW_OP_plus_uconst 16] [$rsp+0]
	#DEBUG_VALUE: geo_distance_km:lat1 <- [DW_OP_plus_uconst 16] [$rsp+0]
	.loc	1 24 34                         # support/geolab/geo.c:24:34
	call	cos@PLT
.Ltmp45:
	.loc	1 0 34 is_stmt 0                # support/geolab/geo.c:0:34
	movsd	qword ptr [rsp + 16], xmm0      # 8-byte Spill
	#DEBUG_VALUE: deg_to_rad:degrees <- undef
.Ltmp46:
	#DEBUG_VALUE: geo_distance_km:lat1 <- undef
	#DEBUG_VALUE: deg_to_rad:degrees <- [DW_OP_plus_uconst 64] [$rsp+0]
	movapd	xmm0, xmmword ptr [rsp + 64]    # 16-byte Reload
.Ltmp47:
	#DEBUG_VALUE: deg_to_rad:degrees <- $xmm0
	#DEBUG_VALUE: geo_distance_km:lat2 <- $xmm0
	.loc	1 7 59 is_stmt 1                # support/geolab/geo.c:7:59
	mulsd	xmm0, qword ptr [rip + .LCPI1_6]
.Ltmp48:
	#DEBUG_VALUE: deg_to_rad:degrees <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: geo_distance_km:lat2 <- [DW_OP_plus_uconst 64] [$rsp+0]
	.loc	1 24 58                         # support/geolab/geo.c:24:58
	call	cos@PLT
.Ltmp49:
	.loc	1 24 56 is_stmt 0               # support/geolab/geo.c:24:56
	mulsd	xmm0, qword ptr [rsp + 16]      # 8-byte Folded Reload
	movsd	xmm1, qword ptr [rsp + 32]      # 8-byte Reload
                                        # xmm1 = mem[0],zero
.Ltmp50:
	#DEBUG_VALUE: geo_distance_km:sd_lon <- $xmm1
	.loc	1 24 80                         # support/geolab/geo.c:24:80
	mulsd	xmm0, xmm1
	.loc	1 24 89                         # support/geolab/geo.c:24:89
	mulsd	xmm0, xmm1
	.loc	1 24 32                         # support/geolab/geo.c:24:32
	addsd	xmm0, qword ptr [rsp + 8]       # 8-byte Folded Reload
.Ltmp51:
	#DEBUG_VALUE: geo_distance_km:a <- $xmm0
	#DEBUG_VALUE: clamp:x <- $xmm0
	.loc	1 0 32                          # support/geolab/geo.c:0:32
	movsd	xmm1, qword ptr [rip + .LCPI1_8] # xmm1 = mem[0],zero
.Ltmp52:
	#DEBUG_VALUE: geo_distance_km:sd_lon <- [DW_OP_plus_uconst 32] [$rsp+0]
	#DEBUG_VALUE: clamp:lo <- 0.000000e+00
	#DEBUG_VALUE: clamp:hi <- 1.000000e+00
	.loc	1 9 62 is_stmt 1                # support/geolab/geo.c:9:62
	minsd	xmm1, xmm0
	xorpd	xmm2, xmm2
	cmpltsd	xmm0, xmm2
.Ltmp53:
	andnpd	xmm0, xmm1
.Ltmp54:
	.loc	1 25 18                         # support/geolab/geo.c:25:18
	ucomisd	xmm0, xmm2
	jb	.LBB1_15
.Ltmp55:
# %bb.14:
	#DEBUG_VALUE: geo_distance_km:lat1 <- [DW_OP_LLVM_entry_value 1] $xmm0
	#DEBUG_VALUE: geo_distance_km:lon1 <- [DW_OP_LLVM_entry_value 1] $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: geo_distance_km:lon2 <- [DW_OP_plus_uconst 48] [$rsp+0]
	#DEBUG_VALUE: geo_distance_km:out <- $rbx
	#DEBUG_VALUE: geo_distance_km:sd_lon <- [DW_OP_plus_uconst 32] [$rsp+0]
	#DEBUG_VALUE: deg_to_rad:degrees <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: clamp:lo <- 0.000000e+00
	#DEBUG_VALUE: clamp:hi <- 1.000000e+00
	.loc	1 0 18 is_stmt 0                # support/geolab/geo.c:0:18
	sqrtsd	xmm0, xmm0
	jmp	.LBB1_16
.Ltmp56:
.LBB1_15:
	#DEBUG_VALUE: geo_distance_km:lat1 <- [DW_OP_LLVM_entry_value 1] $xmm0
	#DEBUG_VALUE: geo_distance_km:lon1 <- [DW_OP_LLVM_entry_value 1] $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: geo_distance_km:lon2 <- [DW_OP_plus_uconst 48] [$rsp+0]
	#DEBUG_VALUE: geo_distance_km:out <- $rbx
	#DEBUG_VALUE: geo_distance_km:sd_lon <- [DW_OP_plus_uconst 32] [$rsp+0]
	.loc	1 25 18                         # support/geolab/geo.c:25:18
	call	sqrt@PLT
.Ltmp57:
.LBB1_16:
	#DEBUG_VALUE: geo_distance_km:lat1 <- [DW_OP_LLVM_entry_value 1] $xmm0
	#DEBUG_VALUE: geo_distance_km:lon1 <- [DW_OP_LLVM_entry_value 1] $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- [DW_OP_plus_uconst 64] [$rsp+0]
	#DEBUG_VALUE: geo_distance_km:lon2 <- [DW_OP_plus_uconst 48] [$rsp+0]
	#DEBUG_VALUE: geo_distance_km:out <- $rbx
	#DEBUG_VALUE: geo_distance_km:sd_lon <- [DW_OP_plus_uconst 32] [$rsp+0]
	call	asin@PLT
.Ltmp58:
	.loc	1 25 16                         # support/geolab/geo.c:25:16
	addsd	xmm0, xmm0
	.loc	1 25 49                         # support/geolab/geo.c:25:49
	mulsd	xmm0, qword ptr [rip + .LCPI1_9]
	.loc	1 25 10                         # support/geolab/geo.c:25:10
	movsd	qword ptr [rbx], xmm0
	mov	eax, 1
.Ltmp59:
.LBB1_17:
	#DEBUG_VALUE: geo_distance_km:lat1 <- [DW_OP_LLVM_entry_value 1] $xmm0
	#DEBUG_VALUE: geo_distance_km:lon1 <- [DW_OP_LLVM_entry_value 1] $xmm1
	#DEBUG_VALUE: geo_distance_km:lat2 <- [DW_OP_LLVM_entry_value 1] $xmm2
	#DEBUG_VALUE: geo_distance_km:lon2 <- [DW_OP_LLVM_entry_value 1] $xmm3
	#DEBUG_VALUE: geo_distance_km:out <- [DW_OP_LLVM_entry_value 1] $rdi
	.loc	1 27 1 is_stmt 1                # support/geolab/geo.c:27:1
	add	rsp, 80
	.cfi_def_cfa_offset 16
	pop	rbx
	.cfi_def_cfa_offset 8
	ret
.Ltmp60:
.Lfunc_end1:
	.size	geo_distance_km, .Lfunc_end1-geo_distance_km
	.cfi_endproc
                                        # -- End function
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp5-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	97                              # DW_OP_reg17
	.quad	.Ltmp5-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	97                              # DW_OP_reg17
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc1:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp11-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	97                              # DW_OP_reg17
	.quad	.Ltmp11-.Lfunc_begin0
	.quad	.Ltmp30-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	101                             # DW_OP_reg21
	.quad	.Ltmp30-.Lfunc_begin0
	.quad	.Ltmp43-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	16                              # 16
	.quad	.Ltmp43-.Lfunc_begin0
	.quad	.Ltmp44-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	97                              # DW_OP_reg17
	.quad	.Ltmp44-.Lfunc_begin0
	.quad	.Ltmp46-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	16                              # 16
	.quad	.Ltmp55-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	97                              # DW_OP_reg17
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp32-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	98                              # DW_OP_reg18
	.quad	.Ltmp32-.Lfunc_begin0
	.quad	.Ltmp39-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	32                              # 32
	.quad	.Ltmp55-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	98                              # DW_OP_reg18
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc3:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp29-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	99                              # DW_OP_reg19
	.quad	.Ltmp29-.Lfunc_begin0
	.quad	.Ltmp47-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	192                             # 64
	.byte	0                               # 
	.quad	.Ltmp47-.Lfunc_begin0
	.quad	.Ltmp48-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	97                              # DW_OP_reg17
	.quad	.Ltmp48-.Lfunc_begin0
	.quad	.Ltmp59-.Lfunc_begin0
	.short	3                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	192                             # 64
	.byte	0                               # 
	.quad	.Ltmp59-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	99                              # DW_OP_reg19
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc4:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp31-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	100                             # DW_OP_reg20
	.quad	.Ltmp31-.Lfunc_begin0
	.quad	.Ltmp35-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	48                              # 48
	.quad	.Ltmp35-.Lfunc_begin0
	.quad	.Ltmp36-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	97                              # DW_OP_reg17
	.quad	.Ltmp36-.Lfunc_begin0
	.quad	.Ltmp59-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	48                              # 48
	.quad	.Ltmp59-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	100                             # DW_OP_reg20
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc5:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp33-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	85                              # DW_OP_reg5
	.quad	.Ltmp33-.Lfunc_begin0
	.quad	.Ltmp59-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	83                              # DW_OP_reg3
	.quad	.Ltmp59-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	85                              # DW_OP_reg5
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc6:
	.quad	.Ltmp34-.Lfunc_begin0
	.quad	.Ltmp40-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	8                               # 8
	.quad	.Ltmp40-.Lfunc_begin0
	.quad	.Ltmp41-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	97                              # DW_OP_reg17
	.quad	.Ltmp41-.Lfunc_begin0
	.quad	.Ltmp42-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	8                               # 8
	.quad	0
	.quad	0
.Ldebug_loc7:
	.quad	.Ltmp39-.Lfunc_begin0
	.quad	.Ltmp50-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	32                              # 32
	.quad	.Ltmp50-.Lfunc_begin0
	.quad	.Ltmp52-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	98                              # DW_OP_reg18
	.quad	.Ltmp52-.Lfunc_begin0
	.quad	.Ltmp59-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	119                             # DW_OP_breg7
	.byte	32                              # 32
	.quad	0
	.quad	0
.Ldebug_loc8:
	.quad	.Ltmp51-.Lfunc_begin0
	.quad	.Ltmp53-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	97                              # DW_OP_reg17
	.quad	0
	.quad	0
.Ldebug_loc9:
	.quad	.Ltmp51-.Lfunc_begin0
	.quad	.Ltmp53-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	97                              # DW_OP_reg17
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
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	4                               # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	23                              # DW_FORM_sec_offset
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	5                               # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	6                               # Abbreviation Code
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
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	32                              # DW_AT_inline
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	7                               # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
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
	.byte	9                               # Abbreviation Code
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
	.byte	32                              # DW_AT_inline
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	10                              # Abbreviation Code
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
	.byte	11                              # Abbreviation Code
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
	.byte	12                              # Abbreviation Code
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
	.byte	13                              # Abbreviation Code
	.byte	29                              # DW_TAG_inlined_subroutine
	.byte	1                               # DW_CHILDREN_yes
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	88                              # DW_AT_call_file
	.byte	11                              # DW_FORM_data1
	.byte	89                              # DW_AT_call_line
	.byte	11                              # DW_FORM_data1
	.byte	87                              # DW_AT_call_column
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	14                              # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	28                              # DW_AT_const_value
	.byte	15                              # DW_FORM_udata
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	15                              # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
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
	.byte	1                               # Abbrev [1] 0xb:0x234 DW_TAG_compile_unit
	.long	.Linfo_string0                  # DW_AT_producer
	.short	12                              # DW_AT_language
	.long	.Linfo_string1                  # DW_AT_name
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.long	.Linfo_string2                  # DW_AT_comp_dir
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin0       # DW_AT_high_pc
	.byte	2                               # Abbrev [2] 0x2a:0x1 DW_TAG_pointer_type
	.byte	3                               # Abbrev [3] 0x2b:0x24 DW_TAG_subprogram
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	79                              # DW_AT_abstract_origin
	.byte	4                               # Abbrev [4] 0x3e:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc0                    # DW_AT_location
	.long	91                              # DW_AT_abstract_origin
	.byte	5                               # Abbrev [5] 0x47:0x7 DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	98
	.long	102                             # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	6                               # Abbrev [6] 0x4f:0x23 DW_TAG_subprogram
	.long	.Linfo_string3                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	114                             # DW_AT_type
                                        # DW_AT_external
	.byte	1                               # DW_AT_inline
	.byte	7                               # Abbrev [7] 0x5b:0xb DW_TAG_formal_parameter
	.long	.Linfo_string5                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.long	121                             # DW_AT_type
	.byte	7                               # Abbrev [7] 0x66:0xb DW_TAG_formal_parameter
	.long	.Linfo_string7                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.long	121                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	8                               # Abbrev [8] 0x72:0x7 DW_TAG_base_type
	.long	.Linfo_string4                  # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	8                               # Abbrev [8] 0x79:0x7 DW_TAG_base_type
	.long	.Linfo_string6                  # DW_AT_name
	.byte	4                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	9                               # Abbrev [9] 0x80:0x18 DW_TAG_subprogram
	.long	.Linfo_string8                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	121                             # DW_AT_type
	.byte	1                               # DW_AT_inline
	.byte	7                               # Abbrev [7] 0x8c:0xb DW_TAG_formal_parameter
	.long	.Linfo_string9                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	121                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	9                               # Abbrev [9] 0x98:0x2e DW_TAG_subprogram
	.long	.Linfo_string10                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	9                               # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	121                             # DW_AT_type
	.byte	1                               # DW_AT_inline
	.byte	7                               # Abbrev [7] 0xa4:0xb DW_TAG_formal_parameter
	.long	.Linfo_string11                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	9                               # DW_AT_decl_line
	.long	121                             # DW_AT_type
	.byte	7                               # Abbrev [7] 0xaf:0xb DW_TAG_formal_parameter
	.long	.Linfo_string12                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	9                               # DW_AT_decl_line
	.long	121                             # DW_AT_type
	.byte	7                               # Abbrev [7] 0xba:0xb DW_TAG_formal_parameter
	.long	.Linfo_string13                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	9                               # DW_AT_decl_line
	.long	121                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	10                              # Abbrev [10] 0xc6:0x173 DW_TAG_subprogram
	.quad	.Lfunc_begin1                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin1       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	.Linfo_string14                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	19                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	114                             # DW_AT_type
                                        # DW_AT_external
	.byte	11                              # Abbrev [11] 0xdf:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc1                    # DW_AT_location
	.long	.Linfo_string15                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	19                              # DW_AT_decl_line
	.long	121                             # DW_AT_type
	.byte	11                              # Abbrev [11] 0xee:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc2                    # DW_AT_location
	.long	.Linfo_string16                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	19                              # DW_AT_decl_line
	.long	121                             # DW_AT_type
	.byte	11                              # Abbrev [11] 0xfd:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc3                    # DW_AT_location
	.long	.Linfo_string17                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	19                              # DW_AT_decl_line
	.long	121                             # DW_AT_type
	.byte	11                              # Abbrev [11] 0x10c:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc4                    # DW_AT_location
	.long	.Linfo_string18                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	19                              # DW_AT_decl_line
	.long	121                             # DW_AT_type
	.byte	11                              # Abbrev [11] 0x11b:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc5                    # DW_AT_location
	.long	.Linfo_string19                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	19                              # DW_AT_decl_line
	.long	569                             # DW_AT_type
	.byte	12                              # Abbrev [12] 0x12a:0xf DW_TAG_variable
	.long	.Ldebug_loc6                    # DW_AT_location
	.long	.Linfo_string20                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	22                              # DW_AT_decl_line
	.long	121                             # DW_AT_type
	.byte	12                              # Abbrev [12] 0x139:0xf DW_TAG_variable
	.long	.Ldebug_loc7                    # DW_AT_location
	.long	.Linfo_string21                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	23                              # DW_AT_decl_line
	.long	121                             # DW_AT_type
	.byte	12                              # Abbrev [12] 0x148:0xf DW_TAG_variable
	.long	.Ldebug_loc8                    # DW_AT_location
	.long	.Linfo_string22                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	24                              # DW_AT_decl_line
	.long	121                             # DW_AT_type
	.byte	13                              # Abbrev [13] 0x157:0x1c DW_TAG_inlined_subroutine
	.long	79                              # DW_AT_abstract_origin
	.quad	.Ltmp13                         # DW_AT_low_pc
	.long	.Ltmp18-.Ltmp13                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	21                              # DW_AT_call_line
	.byte	25                              # DW_AT_call_column
	.byte	5                               # Abbrev [5] 0x16b:0x7 DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	101
	.long	91                              # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	13                              # Abbrev [13] 0x173:0x23 DW_TAG_inlined_subroutine
	.long	79                              # DW_AT_abstract_origin
	.quad	.Ltmp21                         # DW_AT_low_pc
	.long	.Ltmp26-.Ltmp21                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	21                              # DW_AT_call_line
	.byte	60                              # DW_AT_call_column
	.byte	5                               # Abbrev [5] 0x187:0x7 DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	99
	.long	91                              # DW_AT_abstract_origin
	.byte	5                               # Abbrev [5] 0x18e:0x7 DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	100
	.long	102                             # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	13                              # Abbrev [13] 0x196:0x1c DW_TAG_inlined_subroutine
	.long	128                             # DW_AT_abstract_origin
	.quad	.Ltmp27                         # DW_AT_low_pc
	.long	.Ltmp28-.Ltmp27                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	22                              # DW_AT_call_line
	.byte	25                              # DW_AT_call_column
	.byte	5                               # Abbrev [5] 0x1aa:0x7 DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	97
	.long	140                             # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	13                              # Abbrev [13] 0x1b2:0x1c DW_TAG_inlined_subroutine
	.long	128                             # DW_AT_abstract_origin
	.quad	.Ltmp36                         # DW_AT_low_pc
	.long	.Ltmp37-.Ltmp36                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	23                              # DW_AT_call_line
	.byte	25                              # DW_AT_call_column
	.byte	5                               # Abbrev [5] 0x1c6:0x7 DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	97
	.long	140                             # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	13                              # Abbrev [13] 0x1ce:0x1c DW_TAG_inlined_subroutine
	.long	128                             # DW_AT_abstract_origin
	.quad	.Ltmp43                         # DW_AT_low_pc
	.long	.Ltmp44-.Ltmp43                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	24                              # DW_AT_call_line
	.byte	38                              # DW_AT_call_column
	.byte	5                               # Abbrev [5] 0x1e2:0x7 DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	97
	.long	140                             # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	13                              # Abbrev [13] 0x1ea:0x1c DW_TAG_inlined_subroutine
	.long	128                             # DW_AT_abstract_origin
	.quad	.Ltmp47                         # DW_AT_low_pc
	.long	.Ltmp48-.Ltmp47                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	24                              # DW_AT_call_line
	.byte	62                              # DW_AT_call_column
	.byte	5                               # Abbrev [5] 0x1fe:0x7 DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	97
	.long	140                             # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	13                              # Abbrev [13] 0x206:0x32 DW_TAG_inlined_subroutine
	.long	152                             # DW_AT_abstract_origin
	.quad	.Ltmp52                         # DW_AT_low_pc
	.long	.Ltmp54-.Ltmp52                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	25                              # DW_AT_call_line
	.byte	28                              # DW_AT_call_column
	.byte	4                               # Abbrev [4] 0x21a:0x9 DW_TAG_formal_parameter
	.long	.Ldebug_loc9                    # DW_AT_location
	.long	164                             # DW_AT_abstract_origin
	.byte	14                              # Abbrev [14] 0x223:0x6 DW_TAG_formal_parameter
	.byte	0                               # DW_AT_const_value
	.long	175                             # DW_AT_abstract_origin
	.byte	14                              # Abbrev [14] 0x229:0xe DW_TAG_formal_parameter
	.ascii	"\200\200\200\200\200\200\200\370?" # DW_AT_const_value
	.long	186                             # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	15                              # Abbrev [15] 0x239:0x5 DW_TAG_pointer_type
	.long	121                             # DW_AT_type
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"Ubuntu clang version 14.0.0-1ubuntu1.1" # string offset=0
.Linfo_string1:
	.asciz	"support/geolab/geo.c"          # string offset=39
.Linfo_string2:
	.asciz	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" # string offset=60
.Linfo_string3:
	.asciz	"geo_valid_position"            # string offset=153
.Linfo_string4:
	.asciz	"int"                           # string offset=172
.Linfo_string5:
	.asciz	"lat_deg"                       # string offset=176
.Linfo_string6:
	.asciz	"double"                        # string offset=184
.Linfo_string7:
	.asciz	"lon_deg"                       # string offset=191
.Linfo_string8:
	.asciz	"deg_to_rad"                    # string offset=199
.Linfo_string9:
	.asciz	"degrees"                       # string offset=210
.Linfo_string10:
	.asciz	"clamp"                         # string offset=218
.Linfo_string11:
	.asciz	"x"                             # string offset=224
.Linfo_string12:
	.asciz	"lo"                            # string offset=226
.Linfo_string13:
	.asciz	"hi"                            # string offset=229
.Linfo_string14:
	.asciz	"geo_distance_km"               # string offset=232
.Linfo_string15:
	.asciz	"lat1"                          # string offset=248
.Linfo_string16:
	.asciz	"lon1"                          # string offset=253
.Linfo_string17:
	.asciz	"lat2"                          # string offset=258
.Linfo_string18:
	.asciz	"lon2"                          # string offset=263
.Linfo_string19:
	.asciz	"out"                           # string offset=268
.Linfo_string20:
	.asciz	"sd_lat"                        # string offset=272
.Linfo_string21:
	.asciz	"sd_lon"                        # string offset=279
.Linfo_string22:
	.asciz	"a"                             # string offset=286
	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.section	.debug_line,"",@progbits
.Lline_table_start0:
