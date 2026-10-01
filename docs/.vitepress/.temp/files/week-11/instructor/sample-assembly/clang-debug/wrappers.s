	.text
	.intel_syntax noprefix
	.file	"wrappers.c"
	.globl	distance_to_origin              # -- Begin function distance_to_origin
	.p2align	4, 0x90
	.type	distance_to_origin,@function
distance_to_origin:                     # @distance_to_origin
.Lfunc_begin0:
	.file	1 "/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" "instructor/src/wrappers.c"
	.loc	1 4 0                           # instructor/src/wrappers.c:4:0
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	sub	rsp, 32
	movsd	qword ptr [rbp - 8], xmm0
	movsd	qword ptr [rbp - 16], xmm1
	mov	qword ptr [rbp - 24], rdi
.Ltmp0:
	.loc	1 5 36 prologue_end             # instructor/src/wrappers.c:5:36
	movsd	xmm2, qword ptr [rbp - 8]       # xmm2 = mem[0],zero
	.loc	1 5 40 is_stmt 0                # instructor/src/wrappers.c:5:40
	movsd	xmm3, qword ptr [rbp - 16]      # xmm3 = mem[0],zero
	.loc	1 5 44                          # instructor/src/wrappers.c:5:44
	mov	rdi, qword ptr [rbp - 24]
	.loc	1 5 12                          # instructor/src/wrappers.c:5:12
	xorps	xmm1, xmm1
	movaps	xmm0, xmm1
	call	geo_distance_km@PLT
	.loc	1 5 5                           # instructor/src/wrappers.c:5:5
	add	rsp, 32
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Ltmp1:
.Lfunc_end0:
	.size	distance_to_origin, .Lfunc_end0-distance_to_origin
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3                               # -- Begin function compare_hit_values
.LCPI1_0:
	.quad	0x7ff0000000000000              # double +Inf
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4
.LCPI1_1:
	.quad	0x7fffffffffffffff              # double NaN
	.quad	0x7fffffffffffffff              # double NaN
	.text
	.globl	compare_hit_values
	.p2align	4, 0x90
	.type	compare_hit_values,@function
compare_hit_values:                     # @compare_hit_values
.Lfunc_begin1:
	.loc	1 8 0 is_stmt 1                 # instructor/src/wrappers.c:8:0
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	sub	rsp, 96
	mov	qword ptr [rbp - 16], rdi
	movsd	qword ptr [rbp - 24], xmm0
	mov	qword ptr [rbp - 32], rsi
	movsd	qword ptr [rbp - 40], xmm1
	mov	qword ptr [rbp - 48], rdx
.Ltmp2:
	.loc	1 9 10 prologue_end             # instructor/src/wrappers.c:9:10
	cmp	qword ptr [rbp - 48], 0
	.loc	1 9 14 is_stmt 0                # instructor/src/wrappers.c:9:14
	je	.LBB1_5
# %bb.1:
	.loc	1 9 18                          # instructor/src/wrappers.c:9:18
	movsd	xmm0, qword ptr [rbp - 24]      # xmm0 = mem[0],zero
	movaps	xmm1, xmmword ptr [rip + .LCPI1_1] # xmm1 = [NaN,NaN]
	pand	xmm0, xmm1
	.loc	1 9 31                          # instructor/src/wrappers.c:9:31
	movsd	xmm1, qword ptr [rip + .LCPI1_0] # xmm1 = mem[0],zero
	.loc	1 9 18                          # instructor/src/wrappers.c:9:18
	ucomisd	xmm0, xmm1
	.loc	1 9 31                          # instructor/src/wrappers.c:9:31
	je	.LBB1_5
# %bb.2:
	.loc	1 9 35                          # instructor/src/wrappers.c:9:35
	movsd	xmm0, qword ptr [rbp - 40]      # xmm0 = mem[0],zero
	movaps	xmm1, xmmword ptr [rip + .LCPI1_1] # xmm1 = [NaN,NaN]
	pand	xmm0, xmm1
	.loc	1 9 48                          # instructor/src/wrappers.c:9:48
	movsd	xmm1, qword ptr [rip + .LCPI1_0] # xmm1 = mem[0],zero
	.loc	1 9 35                          # instructor/src/wrappers.c:9:35
	ucomisd	xmm0, xmm1
	.loc	1 9 48                          # instructor/src/wrappers.c:9:48
	je	.LBB1_5
# %bb.3:
	.loc	1 9 56                          # instructor/src/wrappers.c:9:56
	xorps	xmm0, xmm0
	.loc	1 9 53                          # instructor/src/wrappers.c:9:53
	ucomisd	xmm0, qword ptr [rbp - 24]
	.loc	1 9 56                          # instructor/src/wrappers.c:9:56
	ja	.LBB1_5
.Ltmp3:
# %bb.4:
	.loc	1 9 9                           # instructor/src/wrappers.c:9:9
	xorps	xmm0, xmm0
.Ltmp4:
	.loc	1 9 61                          # instructor/src/wrappers.c:9:61
	ucomisd	xmm0, qword ptr [rbp - 40]
.Ltmp5:
	.loc	1 9 9                           # instructor/src/wrappers.c:9:9
	jbe	.LBB1_6
.LBB1_5:
.Ltmp6:
	.loc	1 9 65                          # instructor/src/wrappers.c:9:65
	mov	dword ptr [rbp - 4], 0
	jmp	.LBB1_7
.Ltmp7:
.LBB1_6:
	.loc	1 10 17 is_stmt 1               # instructor/src/wrappers.c:10:17
	mov	rax, qword ptr [rbp - 16]
	.loc	1 10 16 is_stmt 0               # instructor/src/wrappers.c:10:16
	mov	qword ptr [rbp - 64], rax
	.loc	1 10 22                         # instructor/src/wrappers.c:10:22
	movsd	xmm0, qword ptr [rbp - 24]      # xmm0 = mem[0],zero
	.loc	1 10 16                         # instructor/src/wrappers.c:10:16
	movsd	qword ptr [rbp - 56], xmm0
	.loc	1 10 30                         # instructor/src/wrappers.c:10:30
	mov	rax, qword ptr [rbp - 32]
	.loc	1 10 29                         # instructor/src/wrappers.c:10:29
	mov	qword ptr [rbp - 80], rax
	.loc	1 10 35                         # instructor/src/wrappers.c:10:35
	movsd	xmm0, qword ptr [rbp - 40]      # xmm0 = mem[0],zero
	.loc	1 10 29                         # instructor/src/wrappers.c:10:29
	movsd	qword ptr [rbp - 72], xmm0
	.loc	1 11 33 is_stmt 1               # instructor/src/wrappers.c:11:33
	lea	rdi, [rbp - 64]
	.loc	1 11 36 is_stmt 0               # instructor/src/wrappers.c:11:36
	lea	rsi, [rbp - 80]
	.loc	1 11 15                         # instructor/src/wrappers.c:11:15
	call	query_hit_compare@PLT
	.loc	1 11 9                          # instructor/src/wrappers.c:11:9
	mov	dword ptr [rbp - 84], eax
	.loc	1 12 10 is_stmt 1               # instructor/src/wrappers.c:12:10
	mov	ecx, dword ptr [rbp - 84]
	.loc	1 12 6 is_stmt 0                # instructor/src/wrappers.c:12:6
	mov	rax, qword ptr [rbp - 48]
	.loc	1 12 9                          # instructor/src/wrappers.c:12:9
	mov	dword ptr [rax], ecx
	.loc	1 13 5 is_stmt 1                # instructor/src/wrappers.c:13:5
	mov	dword ptr [rbp - 4], 1
.LBB1_7:
	.loc	1 14 1                          # instructor/src/wrappers.c:14:1
	mov	eax, dword ptr [rbp - 4]
	add	rsp, 96
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Ltmp8:
.Lfunc_end1:
	.size	compare_hit_values, .Lfunc_end1-compare_hit_values
	.cfi_endproc
                                        # -- End function
	.file	2 "/usr/include/x86_64-linux-gnu/bits" "types.h"
	.file	3 "/usr/include/x86_64-linux-gnu/bits" "stdint-uintn.h"
	.file	4 "/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" "support/geolab/geolab.h"
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
	.byte	3                               # Abbreviation Code
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
	.byte	4                               # Abbreviation Code
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
	.byte	5                               # Abbreviation Code
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
	.byte	6                               # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	7                               # Abbreviation Code
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
	.byte	8                               # Abbreviation Code
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
	.byte	9                               # Abbreviation Code
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
	.byte	1                               # Abbrev [1] 0xb:0x14d DW_TAG_compile_unit
	.long	.Linfo_string0                  # DW_AT_producer
	.short	12                              # DW_AT_language
	.long	.Linfo_string1                  # DW_AT_name
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.long	.Linfo_string2                  # DW_AT_comp_dir
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin0       # DW_AT_high_pc
	.byte	2                               # Abbrev [2] 0x2a:0x44 DW_TAG_subprogram
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	86
	.long	.Linfo_string3                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	3                               # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	250                             # DW_AT_type
                                        # DW_AT_external
	.byte	3                               # Abbrev [3] 0x43:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	120
	.long	.Linfo_string6                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	3                               # DW_AT_decl_line
	.long	257                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x51:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	112
	.long	.Linfo_string8                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	3                               # DW_AT_decl_line
	.long	257                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x5f:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	104
	.long	.Linfo_string9                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	3                               # DW_AT_decl_line
	.long	264                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	2                               # Abbrev [2] 0x6e:0x8c DW_TAG_subprogram
	.quad	.Lfunc_begin1                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin1       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	86
	.long	.Linfo_string5                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	250                             # DW_AT_type
                                        # DW_AT_external
	.byte	3                               # Abbrev [3] 0x87:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	112
	.long	.Linfo_string10                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	269                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x95:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	104
	.long	.Linfo_string14                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	257                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0xa3:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	96
	.long	.Linfo_string15                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	269                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0xb1:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	88
	.long	.Linfo_string16                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	257                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0xbf:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	80
	.long	.Linfo_string9                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	298                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0xcd:0xe DW_TAG_variable
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	64
	.long	.Linfo_string17                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	10                              # DW_AT_decl_line
	.long	303                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0xdb:0xf DW_TAG_variable
	.byte	3                               # DW_AT_location
	.byte	145
	.ascii	"\260\177"
	.long	.Linfo_string21                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	10                              # DW_AT_decl_line
	.long	303                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0xea:0xf DW_TAG_variable
	.byte	3                               # DW_AT_location
	.byte	145
	.ascii	"\254\177"
	.long	.Linfo_string22                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.long	250                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	5                               # Abbrev [5] 0xfa:0x7 DW_TAG_base_type
	.long	.Linfo_string4                  # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	5                               # Abbrev [5] 0x101:0x7 DW_TAG_base_type
	.long	.Linfo_string7                  # DW_AT_name
	.byte	4                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	6                               # Abbrev [6] 0x108:0x5 DW_TAG_pointer_type
	.long	257                             # DW_AT_type
	.byte	7                               # Abbrev [7] 0x10d:0xb DW_TAG_typedef
	.long	280                             # DW_AT_type
	.long	.Linfo_string13                 # DW_AT_name
	.byte	3                               # DW_AT_decl_file
	.byte	27                              # DW_AT_decl_line
	.byte	7                               # Abbrev [7] 0x118:0xb DW_TAG_typedef
	.long	291                             # DW_AT_type
	.long	.Linfo_string12                 # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	45                              # DW_AT_decl_line
	.byte	5                               # Abbrev [5] 0x123:0x7 DW_TAG_base_type
	.long	.Linfo_string11                 # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	6                               # Abbrev [6] 0x12a:0x5 DW_TAG_pointer_type
	.long	250                             # DW_AT_type
	.byte	7                               # Abbrev [7] 0x12f:0xb DW_TAG_typedef
	.long	314                             # DW_AT_type
	.long	.Linfo_string20                 # DW_AT_name
	.byte	4                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	8                               # Abbrev [8] 0x13a:0x1d DW_TAG_structure_type
	.byte	16                              # DW_AT_byte_size
	.byte	4                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	9                               # Abbrev [9] 0x13e:0xc DW_TAG_member
	.long	.Linfo_string18                 # DW_AT_name
	.long	269                             # DW_AT_type
	.byte	4                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	0                               # DW_AT_data_member_location
	.byte	9                               # Abbrev [9] 0x14a:0xc DW_TAG_member
	.long	.Linfo_string19                 # DW_AT_name
	.long	257                             # DW_AT_type
	.byte	4                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	8                               # DW_AT_data_member_location
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"Ubuntu clang version 14.0.0-1ubuntu1.1" # string offset=0
.Linfo_string1:
	.asciz	"instructor/src/wrappers.c"     # string offset=39
.Linfo_string2:
	.asciz	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" # string offset=65
.Linfo_string3:
	.asciz	"distance_to_origin"            # string offset=158
.Linfo_string4:
	.asciz	"int"                           # string offset=177
.Linfo_string5:
	.asciz	"compare_hit_values"            # string offset=181
.Linfo_string6:
	.asciz	"lat"                           # string offset=200
.Linfo_string7:
	.asciz	"double"                        # string offset=204
.Linfo_string8:
	.asciz	"lon"                           # string offset=211
.Linfo_string9:
	.asciz	"out"                           # string offset=215
.Linfo_string10:
	.asciz	"id_a"                          # string offset=219
.Linfo_string11:
	.asciz	"unsigned long"                 # string offset=224
.Linfo_string12:
	.asciz	"__uint64_t"                    # string offset=238
.Linfo_string13:
	.asciz	"uint64_t"                      # string offset=249
.Linfo_string14:
	.asciz	"da"                            # string offset=258
.Linfo_string15:
	.asciz	"id_b"                          # string offset=261
.Linfo_string16:
	.asciz	"db"                            # string offset=266
.Linfo_string17:
	.asciz	"a"                             # string offset=269
.Linfo_string18:
	.asciz	"id"                            # string offset=271
.Linfo_string19:
	.asciz	"distance_km"                   # string offset=274
.Linfo_string20:
	.asciz	"QueryHit"                      # string offset=286
.Linfo_string21:
	.asciz	"b"                             # string offset=295
.Linfo_string22:
	.asciz	"order"                         # string offset=297
	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym geo_distance_km
	.addrsig_sym query_hit_compare
	.section	.debug_line,"",@progbits
.Lline_table_start0:
