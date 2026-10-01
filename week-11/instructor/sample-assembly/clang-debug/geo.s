	.text
	.intel_syntax noprefix
	.file	"geo.c"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3                               # -- Begin function geo_valid_position
.LCPI0_0:
	.quad	0x7ff0000000000000              # double +Inf
.LCPI0_2:
	.quad	0xc056800000000000              # double -90
.LCPI0_3:
	.quad	0x4056800000000000              # double 90
.LCPI0_4:
	.quad	0xc066800000000000              # double -180
.LCPI0_5:
	.quad	0x4066800000000000              # double 180
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.LCPI0_1:
	.quad	0x7fffffffffffffff              # double NaN
	.quad	0x7fffffffffffffff              # double NaN
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
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	movsd	qword ptr [rbp - 8], xmm0
	movsd	qword ptr [rbp - 16], xmm1
.Ltmp0:
	.loc	1 13 12 prologue_end            # support/geolab/geo.c:13:12
	movsd	xmm0, qword ptr [rbp - 8]       # xmm0 = mem[0],zero
	movaps	xmm1, xmmword ptr [rip + .LCPI0_1] # xmm1 = [NaN,NaN]
	pand	xmm0, xmm1
	xor	eax, eax
                                        # kill: def $al killed $al killed $eax
	.loc	1 13 30 is_stmt 0               # support/geolab/geo.c:13:30
	movsd	xmm1, qword ptr [rip + .LCPI0_0] # xmm1 = mem[0],zero
	.loc	1 13 12                         # support/geolab/geo.c:13:12
	ucomisd	xmm0, xmm1
	mov	byte ptr [rbp - 17], al         # 1-byte Spill
	.loc	1 13 30                         # support/geolab/geo.c:13:30
	je	.LBB0_6
# %bb.1:
	.loc	1 13 33                         # support/geolab/geo.c:13:33
	movsd	xmm0, qword ptr [rbp - 16]      # xmm0 = mem[0],zero
	movaps	xmm1, xmmword ptr [rip + .LCPI0_1] # xmm1 = [NaN,NaN]
	pand	xmm0, xmm1
	xor	eax, eax
                                        # kill: def $al killed $al killed $eax
	.loc	1 13 51                         # support/geolab/geo.c:13:51
	movsd	xmm1, qword ptr [rip + .LCPI0_0] # xmm1 = mem[0],zero
	.loc	1 13 33                         # support/geolab/geo.c:13:33
	ucomisd	xmm0, xmm1
	mov	byte ptr [rbp - 17], al         # 1-byte Spill
	.loc	1 13 51                         # support/geolab/geo.c:13:51
	je	.LBB0_6
# %bb.2:
	.loc	1 13 54                         # support/geolab/geo.c:13:54
	movsd	xmm0, qword ptr [rbp - 8]       # xmm0 = mem[0],zero
	.loc	1 13 62                         # support/geolab/geo.c:13:62
	xor	eax, eax
                                        # kill: def $al killed $al killed $eax
	.loc	1 13 71                         # support/geolab/geo.c:13:71
	movsd	xmm1, qword ptr [rip + .LCPI0_2] # xmm1 = mem[0],zero
	.loc	1 13 62                         # support/geolab/geo.c:13:62
	ucomisd	xmm0, xmm1
	mov	byte ptr [rbp - 17], al         # 1-byte Spill
	.loc	1 13 71                         # support/geolab/geo.c:13:71
	jb	.LBB0_6
# %bb.3:
	.loc	1 13 82                         # support/geolab/geo.c:13:82
	xor	eax, eax
                                        # kill: def $al killed $al killed $eax
	.loc	1 13 90                         # support/geolab/geo.c:13:90
	movsd	xmm0, qword ptr [rip + .LCPI0_3] # xmm0 = mem[0],zero
	.loc	1 13 82                         # support/geolab/geo.c:13:82
	ucomisd	xmm0, qword ptr [rbp - 8]
	mov	byte ptr [rbp - 17], al         # 1-byte Spill
	.loc	1 13 90                         # support/geolab/geo.c:13:90
	jb	.LBB0_6
# %bb.4:
	.loc	1 13 93                         # support/geolab/geo.c:13:93
	movsd	xmm0, qword ptr [rbp - 16]      # xmm0 = mem[0],zero
	.loc	1 13 101                        # support/geolab/geo.c:13:101
	xor	eax, eax
                                        # kill: def $al killed $al killed $eax
	.loc	1 13 111                        # support/geolab/geo.c:13:111
	movsd	xmm1, qword ptr [rip + .LCPI0_4] # xmm1 = mem[0],zero
	.loc	1 13 101                        # support/geolab/geo.c:13:101
	ucomisd	xmm0, xmm1
	mov	byte ptr [rbp - 17], al         # 1-byte Spill
	.loc	1 13 111                        # support/geolab/geo.c:13:111
	jb	.LBB0_6
# %bb.5:
	.loc	1 14 20 is_stmt 1               # support/geolab/geo.c:14:20
	movsd	xmm0, qword ptr [rip + .LCPI0_5] # xmm0 = mem[0],zero
	ucomisd	xmm0, qword ptr [rbp - 16]
	setae	al
	mov	byte ptr [rbp - 17], al         # 1-byte Spill
.LBB0_6:
	.loc	1 0 20 is_stmt 0                # support/geolab/geo.c:0:20
	mov	al, byte ptr [rbp - 17]         # 1-byte Reload
	.loc	1 13 111 is_stmt 1              # support/geolab/geo.c:13:111
	and	al, 1
	movzx	eax, al
	.loc	1 13 5 is_stmt 0                # support/geolab/geo.c:13:5
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Ltmp1:
.Lfunc_end0:
	.size	geo_valid_position, .Lfunc_end0-geo_valid_position
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3                               # -- Begin function geo_distance_km
.LCPI1_0:
	.quad	0x40b8e30240b78034              # double 6371.0087999999996
.LCPI1_1:
	.quad	0x4000000000000000              # double 2
.LCPI1_2:
	.quad	0x3ff0000000000000              # double 1
	.text
	.globl	geo_distance_km
	.p2align	4, 0x90
	.type	geo_distance_km,@function
geo_distance_km:                        # @geo_distance_km
.Lfunc_begin1:
	.loc	1 20 0 is_stmt 1                # support/geolab/geo.c:20:0
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	sub	rsp, 96
	movsd	qword ptr [rbp - 16], xmm0
	movsd	qword ptr [rbp - 24], xmm1
	movsd	qword ptr [rbp - 32], xmm2
	movsd	qword ptr [rbp - 40], xmm3
	mov	qword ptr [rbp - 48], rdi
.Ltmp2:
	.loc	1 21 13 prologue_end            # support/geolab/geo.c:21:13
	cmp	qword ptr [rbp - 48], 0
	.loc	1 21 21 is_stmt 0               # support/geolab/geo.c:21:21
	je	.LBB1_3
# %bb.1:
	.loc	1 21 44                         # support/geolab/geo.c:21:44
	movsd	xmm0, qword ptr [rbp - 16]      # xmm0 = mem[0],zero
	.loc	1 21 50                         # support/geolab/geo.c:21:50
	movsd	xmm1, qword ptr [rbp - 24]      # xmm1 = mem[0],zero
	.loc	1 21 25                         # support/geolab/geo.c:21:25
	call	geo_valid_position
	cmp	eax, 0
	.loc	1 21 56                         # support/geolab/geo.c:21:56
	je	.LBB1_3
# %bb.2:
	.loc	1 21 79                         # support/geolab/geo.c:21:79
	movsd	xmm0, qword ptr [rbp - 32]      # xmm0 = mem[0],zero
	.loc	1 21 85                         # support/geolab/geo.c:21:85
	movsd	xmm1, qword ptr [rbp - 40]      # xmm1 = mem[0],zero
	.loc	1 21 60                         # support/geolab/geo.c:21:60
	call	geo_valid_position
	cmp	eax, 0
.Ltmp3:
	.loc	1 21 9                          # support/geolab/geo.c:21:9
	jne	.LBB1_4
.LBB1_3:
.Ltmp4:
	.loc	1 21 92                         # support/geolab/geo.c:21:92
	mov	dword ptr [rbp - 4], 0
	jmp	.LBB1_5
.Ltmp5:
.LBB1_4:
	.loc	1 22 36 is_stmt 1               # support/geolab/geo.c:22:36
	movsd	xmm0, qword ptr [rbp - 32]      # xmm0 = mem[0],zero
	.loc	1 22 41 is_stmt 0               # support/geolab/geo.c:22:41
	subsd	xmm0, qword ptr [rbp - 16]
	.loc	1 22 25                         # support/geolab/geo.c:22:25
	call	deg_to_rad
	.loc	1 22 49                         # support/geolab/geo.c:22:49
	movsd	xmm1, qword ptr [rip + .LCPI1_1] # xmm1 = mem[0],zero
	divsd	xmm0, xmm1
	.loc	1 22 21                         # support/geolab/geo.c:22:21
	call	sin@PLT
	.loc	1 22 12                         # support/geolab/geo.c:22:12
	movsd	qword ptr [rbp - 56], xmm0
	.loc	1 23 36 is_stmt 1               # support/geolab/geo.c:23:36
	movsd	xmm0, qword ptr [rbp - 40]      # xmm0 = mem[0],zero
	.loc	1 23 41 is_stmt 0               # support/geolab/geo.c:23:41
	subsd	xmm0, qword ptr [rbp - 24]
	.loc	1 23 25                         # support/geolab/geo.c:23:25
	call	deg_to_rad
	.loc	1 23 49                         # support/geolab/geo.c:23:49
	movsd	xmm1, qword ptr [rip + .LCPI1_1] # xmm1 = mem[0],zero
	divsd	xmm0, xmm1
	.loc	1 23 21                         # support/geolab/geo.c:23:21
	call	sin@PLT
	.loc	1 23 12                         # support/geolab/geo.c:23:12
	movsd	qword ptr [rbp - 64], xmm0
	.loc	1 24 16 is_stmt 1               # support/geolab/geo.c:24:16
	movsd	xmm0, qword ptr [rbp - 56]      # xmm0 = mem[0],zero
	.loc	1 24 23 is_stmt 0               # support/geolab/geo.c:24:23
	mulsd	xmm0, qword ptr [rbp - 56]
	movsd	qword ptr [rbp - 80], xmm0      # 8-byte Spill
	.loc	1 24 49                         # support/geolab/geo.c:24:49
	movsd	xmm0, qword ptr [rbp - 16]      # xmm0 = mem[0],zero
	.loc	1 24 38                         # support/geolab/geo.c:24:38
	call	deg_to_rad
	.loc	1 24 34                         # support/geolab/geo.c:24:34
	call	cos@PLT
	movsd	qword ptr [rbp - 88], xmm0      # 8-byte Spill
	.loc	1 24 73                         # support/geolab/geo.c:24:73
	movsd	xmm0, qword ptr [rbp - 32]      # xmm0 = mem[0],zero
	.loc	1 24 62                         # support/geolab/geo.c:24:62
	call	deg_to_rad
	.loc	1 24 58                         # support/geolab/geo.c:24:58
	call	cos@PLT
	movsd	xmm1, qword ptr [rbp - 88]      # 8-byte Reload
                                        # xmm1 = mem[0],zero
	movaps	xmm2, xmm0
	movsd	xmm0, qword ptr [rbp - 80]      # 8-byte Reload
                                        # xmm0 = mem[0],zero
	.loc	1 24 56                         # support/geolab/geo.c:24:56
	mulsd	xmm1, xmm2
	.loc	1 24 80                         # support/geolab/geo.c:24:80
	mulsd	xmm1, qword ptr [rbp - 64]
	.loc	1 24 89                         # support/geolab/geo.c:24:89
	mulsd	xmm1, qword ptr [rbp - 64]
	.loc	1 24 32                         # support/geolab/geo.c:24:32
	addsd	xmm0, xmm1
	.loc	1 24 12                         # support/geolab/geo.c:24:12
	movsd	qword ptr [rbp - 72], xmm0
	.loc	1 25 34 is_stmt 1               # support/geolab/geo.c:25:34
	movsd	xmm0, qword ptr [rbp - 72]      # xmm0 = mem[0],zero
	.loc	1 25 28 is_stmt 0               # support/geolab/geo.c:25:28
	xorps	xmm1, xmm1
	movsd	xmm2, qword ptr [rip + .LCPI1_2] # xmm2 = mem[0],zero
	call	clamp
	.loc	1 25 23                         # support/geolab/geo.c:25:23
	call	sqrt@PLT
	.loc	1 25 18                         # support/geolab/geo.c:25:18
	call	asin@PLT
	movaps	xmm1, xmm0
	.loc	1 25 16                         # support/geolab/geo.c:25:16
	movsd	xmm0, qword ptr [rip + .LCPI1_1] # xmm0 = mem[0],zero
	mulsd	xmm0, xmm1
	.loc	1 25 49                         # support/geolab/geo.c:25:49
	movsd	xmm1, qword ptr [rip + .LCPI1_0] # xmm1 = mem[0],zero
	mulsd	xmm0, xmm1
	.loc	1 25 6                          # support/geolab/geo.c:25:6
	mov	rax, qword ptr [rbp - 48]
	.loc	1 25 10                         # support/geolab/geo.c:25:10
	movsd	qword ptr [rax], xmm0
	.loc	1 26 5 is_stmt 1                # support/geolab/geo.c:26:5
	mov	dword ptr [rbp - 4], 1
.LBB1_5:
	.loc	1 27 1                          # support/geolab/geo.c:27:1
	mov	eax, dword ptr [rbp - 4]
	add	rsp, 96
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Ltmp6:
.Lfunc_end1:
	.size	geo_distance_km, .Lfunc_end1-geo_distance_km
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3                               # -- Begin function deg_to_rad
.LCPI2_0:
	.quad	0x3f91df46a2529d39              # double 0.017453292519943295
	.text
	.p2align	4, 0x90
	.type	deg_to_rad,@function
deg_to_rad:                             # @deg_to_rad
.Lfunc_begin2:
	.loc	1 7 0                           # support/geolab/geo.c:7:0
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	movsd	qword ptr [rbp - 8], xmm0
.Ltmp7:
	.loc	1 7 59 prologue_end             # support/geolab/geo.c:7:59
	movsd	xmm0, qword ptr [rip + .LCPI2_0] # xmm0 = mem[0],zero
	mulsd	xmm0, qword ptr [rbp - 8]
	.loc	1 7 44 is_stmt 0                # support/geolab/geo.c:7:44
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Ltmp8:
.Lfunc_end2:
	.size	deg_to_rad, .Lfunc_end2-deg_to_rad
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90                         # -- Begin function clamp
	.type	clamp,@function
clamp:                                  # @clamp
.Lfunc_begin3:
	.loc	1 9 0 is_stmt 1                 # support/geolab/geo.c:9:0
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	movsd	qword ptr [rbp - 8], xmm0
	movsd	qword ptr [rbp - 16], xmm1
	movsd	qword ptr [rbp - 24], xmm2
.Ltmp9:
	.loc	1 9 62 prologue_end             # support/geolab/geo.c:9:62
	movsd	xmm1, qword ptr [rbp - 8]       # xmm1 = mem[0],zero
	.loc	1 9 66 is_stmt 0                # support/geolab/geo.c:9:66
	movsd	xmm0, qword ptr [rbp - 16]      # xmm0 = mem[0],zero
	.loc	1 9 64                          # support/geolab/geo.c:9:64
	ucomisd	xmm0, xmm1
	.loc	1 9 62                          # support/geolab/geo.c:9:62
	jbe	.LBB3_2
# %bb.1:
	.loc	1 9 71                          # support/geolab/geo.c:9:71
	movsd	xmm0, qword ptr [rbp - 16]      # xmm0 = mem[0],zero
	movsd	qword ptr [rbp - 32], xmm0      # 8-byte Spill
	.loc	1 9 62                          # support/geolab/geo.c:9:62
	jmp	.LBB3_6
.LBB3_2:
	.loc	1 9 77                          # support/geolab/geo.c:9:77
	movsd	xmm0, qword ptr [rbp - 8]       # xmm0 = mem[0],zero
	.loc	1 9 79                          # support/geolab/geo.c:9:79
	ucomisd	xmm0, qword ptr [rbp - 24]
	.loc	1 9 77                          # support/geolab/geo.c:9:77
	jbe	.LBB3_4
# %bb.3:
	.loc	1 9 86                          # support/geolab/geo.c:9:86
	movsd	xmm0, qword ptr [rbp - 24]      # xmm0 = mem[0],zero
	movsd	qword ptr [rbp - 40], xmm0      # 8-byte Spill
	.loc	1 9 77                          # support/geolab/geo.c:9:77
	jmp	.LBB3_5
.LBB3_4:
	.loc	1 9 91                          # support/geolab/geo.c:9:91
	movsd	xmm0, qword ptr [rbp - 8]       # xmm0 = mem[0],zero
	movsd	qword ptr [rbp - 40], xmm0      # 8-byte Spill
.LBB3_5:
	.loc	1 0 91                          # support/geolab/geo.c:0:91
	movsd	xmm0, qword ptr [rbp - 40]      # 8-byte Reload
                                        # xmm0 = mem[0],zero
	movsd	qword ptr [rbp - 32], xmm0      # 8-byte Spill
.LBB3_6:
	movsd	xmm0, qword ptr [rbp - 32]      # 8-byte Reload
                                        # xmm0 = mem[0],zero
	.loc	1 9 55                          # support/geolab/geo.c:9:55
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Ltmp10:
.Lfunc_end3:
	.size	clamp, .Lfunc_end3-clamp
	.cfi_endproc
                                        # -- End function
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
	.byte	0                               # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.long	.Ldebug_info_end0-.Ldebug_info_start0 # Length of Unit
.Ldebug_info_start0:
	.short	4                               # DWARF version number
	.long	.debug_abbrev                   # Offset Into Abbrev. Section
	.byte	8                               # Address Size (in bytes)
	.byte	1                               # Abbrev [1] 0xb:0x161 DW_TAG_compile_unit
	.long	.Linfo_string0                  # DW_AT_producer
	.short	12                              # DW_AT_language
	.long	.Linfo_string1                  # DW_AT_name
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.long	.Linfo_string2                  # DW_AT_comp_dir
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end3-.Lfunc_begin0       # DW_AT_high_pc
	.byte	2                               # Abbrev [2] 0x2a:0x1 DW_TAG_pointer_type
	.byte	3                               # Abbrev [3] 0x2b:0x36 DW_TAG_subprogram
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	86
	.long	.Linfo_string3                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	344                             # DW_AT_type
                                        # DW_AT_external
	.byte	4                               # Abbrev [4] 0x44:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	120
	.long	.Linfo_string9                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.long	351                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x52:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	112
	.long	.Linfo_string10                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.long	351                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	3                               # Abbrev [3] 0x61:0x8b DW_TAG_subprogram
	.quad	.Lfunc_begin1                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin1       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	86
	.long	.Linfo_string5                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	19                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	344                             # DW_AT_type
                                        # DW_AT_external
	.byte	4                               # Abbrev [4] 0x7a:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	112
	.long	.Linfo_string11                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	19                              # DW_AT_decl_line
	.long	351                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x88:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	104
	.long	.Linfo_string12                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	19                              # DW_AT_decl_line
	.long	351                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x96:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	96
	.long	.Linfo_string13                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	19                              # DW_AT_decl_line
	.long	351                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0xa4:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	88
	.long	.Linfo_string14                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	19                              # DW_AT_decl_line
	.long	351                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0xb2:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	80
	.long	.Linfo_string15                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	19                              # DW_AT_decl_line
	.long	358                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0xc0:0xe DW_TAG_variable
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	72
	.long	.Linfo_string16                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	22                              # DW_AT_decl_line
	.long	351                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0xce:0xe DW_TAG_variable
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	64
	.long	.Linfo_string17                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	23                              # DW_AT_decl_line
	.long	351                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0xdc:0xf DW_TAG_variable
	.byte	3                               # DW_AT_location
	.byte	145
	.ascii	"\270\177"
	.long	.Linfo_string18                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	24                              # DW_AT_decl_line
	.long	351                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	6                               # Abbrev [6] 0xec:0x28 DW_TAG_subprogram
	.quad	.Lfunc_begin2                   # DW_AT_low_pc
	.long	.Lfunc_end2-.Lfunc_begin2       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	86
	.long	.Linfo_string6                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	351                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x105:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	120
	.long	.Linfo_string19                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	351                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	6                               # Abbrev [6] 0x114:0x44 DW_TAG_subprogram
	.quad	.Lfunc_begin3                   # DW_AT_low_pc
	.long	.Lfunc_end3-.Lfunc_begin3       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	86
	.long	.Linfo_string8                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	9                               # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	351                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x12d:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	120
	.long	.Linfo_string20                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	9                               # DW_AT_decl_line
	.long	351                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x13b:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	112
	.long	.Linfo_string21                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	9                               # DW_AT_decl_line
	.long	351                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x149:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	104
	.long	.Linfo_string22                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	9                               # DW_AT_decl_line
	.long	351                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	7                               # Abbrev [7] 0x158:0x7 DW_TAG_base_type
	.long	.Linfo_string4                  # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	7                               # Abbrev [7] 0x15f:0x7 DW_TAG_base_type
	.long	.Linfo_string7                  # DW_AT_name
	.byte	4                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	8                               # Abbrev [8] 0x166:0x5 DW_TAG_pointer_type
	.long	351                             # DW_AT_type
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
	.asciz	"geo_distance_km"               # string offset=176
.Linfo_string6:
	.asciz	"deg_to_rad"                    # string offset=192
.Linfo_string7:
	.asciz	"double"                        # string offset=203
.Linfo_string8:
	.asciz	"clamp"                         # string offset=210
.Linfo_string9:
	.asciz	"lat_deg"                       # string offset=216
.Linfo_string10:
	.asciz	"lon_deg"                       # string offset=224
.Linfo_string11:
	.asciz	"lat1"                          # string offset=232
.Linfo_string12:
	.asciz	"lon1"                          # string offset=237
.Linfo_string13:
	.asciz	"lat2"                          # string offset=242
.Linfo_string14:
	.asciz	"lon2"                          # string offset=247
.Linfo_string15:
	.asciz	"out"                           # string offset=252
.Linfo_string16:
	.asciz	"sd_lat"                        # string offset=256
.Linfo_string17:
	.asciz	"sd_lon"                        # string offset=263
.Linfo_string18:
	.asciz	"a"                             # string offset=270
.Linfo_string19:
	.asciz	"degrees"                       # string offset=272
.Linfo_string20:
	.asciz	"x"                             # string offset=280
.Linfo_string21:
	.asciz	"lo"                            # string offset=282
.Linfo_string22:
	.asciz	"hi"                            # string offset=285
	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym geo_valid_position
	.addrsig_sym sin
	.addrsig_sym deg_to_rad
	.addrsig_sym cos
	.addrsig_sym asin
	.addrsig_sym sqrt
	.addrsig_sym clamp
	.section	.debug_line,"",@progbits
.Lline_table_start0:
