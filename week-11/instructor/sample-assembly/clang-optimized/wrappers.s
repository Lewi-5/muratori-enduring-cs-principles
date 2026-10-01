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
	#DEBUG_VALUE: distance_to_origin:lat <- $xmm0
	#DEBUG_VALUE: distance_to_origin:lon <- $xmm1
	#DEBUG_VALUE: distance_to_origin:out <- $rdi
	movaps	xmm3, xmm1
	movaps	xmm2, xmm0
.Ltmp0:
	.loc	1 5 12 prologue_end             # instructor/src/wrappers.c:5:12
	xorps	xmm0, xmm0
.Ltmp1:
	#DEBUG_VALUE: distance_to_origin:lat <- $xmm2
	xorps	xmm1, xmm1
.Ltmp2:
	#DEBUG_VALUE: distance_to_origin:lon <- $xmm3
	jmp	geo_distance_km@PLT             # TAILCALL
.Ltmp3:
.Lfunc_end0:
	.size	distance_to_origin, .Lfunc_end0-distance_to_origin
	.cfi_endproc
	.file	2 "/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" "support/geolab/geolab.h"
                                        # -- End function
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4                               # -- Begin function compare_hit_values
.LCPI1_0:
	.quad	0x7fffffffffffffff              # double NaN
	.quad	0x7fffffffffffffff              # double NaN
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI1_1:
	.quad	0x7ff0000000000000              # double +Inf
	.text
	.globl	compare_hit_values
	.p2align	4, 0x90
	.type	compare_hit_values,@function
compare_hit_values:                     # @compare_hit_values
.Lfunc_begin1:
	.loc	1 8 0                           # instructor/src/wrappers.c:8:0
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: compare_hit_values:id_a <- $rdi
	#DEBUG_VALUE: compare_hit_values:da <- $xmm0
	#DEBUG_VALUE: compare_hit_values:id_b <- $rsi
	#DEBUG_VALUE: compare_hit_values:db <- $xmm1
	#DEBUG_VALUE: compare_hit_values:out <- $rdx
	push	rbx
	.cfi_def_cfa_offset 16
	sub	rsp, 32
	.cfi_def_cfa_offset 48
	.cfi_offset rbx, -16
	xor	eax, eax
.Ltmp4:
	.loc	1 9 10 prologue_end             # instructor/src/wrappers.c:9:10
	test	rdx, rdx
	.loc	1 9 14 is_stmt 0                # instructor/src/wrappers.c:9:14
	je	.LBB1_6
.Ltmp5:
# %bb.1:
	#DEBUG_VALUE: compare_hit_values:id_a <- $rdi
	#DEBUG_VALUE: compare_hit_values:da <- $xmm0
	#DEBUG_VALUE: compare_hit_values:id_b <- $rsi
	#DEBUG_VALUE: compare_hit_values:db <- $xmm1
	#DEBUG_VALUE: compare_hit_values:out <- $rdx
	.loc	1 0 14                          # instructor/src/wrappers.c:0:14
	movapd	xmm2, xmmword ptr [rip + .LCPI1_0] # xmm2 = [NaN,NaN]
	andpd	xmm2, xmm0
	.loc	1 9 14                          # instructor/src/wrappers.c:9:14
	ucomisd	xmm2, qword ptr [rip + .LCPI1_1]
	je	.LBB1_6
.Ltmp6:
# %bb.2:
	#DEBUG_VALUE: compare_hit_values:id_a <- $rdi
	#DEBUG_VALUE: compare_hit_values:da <- $xmm0
	#DEBUG_VALUE: compare_hit_values:id_b <- $rsi
	#DEBUG_VALUE: compare_hit_values:db <- $xmm1
	#DEBUG_VALUE: compare_hit_values:out <- $rdx
	.loc	1 0 14                          # instructor/src/wrappers.c:0:14
	xorpd	xmm2, xmm2
	ucomisd	xmm2, xmm1
	.loc	1 9 48                          # instructor/src/wrappers.c:9:48
	ja	.LBB1_6
.Ltmp7:
# %bb.3:
	#DEBUG_VALUE: compare_hit_values:id_a <- $rdi
	#DEBUG_VALUE: compare_hit_values:da <- $xmm0
	#DEBUG_VALUE: compare_hit_values:id_b <- $rsi
	#DEBUG_VALUE: compare_hit_values:db <- $xmm1
	#DEBUG_VALUE: compare_hit_values:out <- $rdx
	ucomisd	xmm2, xmm0
	ja	.LBB1_6
.Ltmp8:
# %bb.4:
	#DEBUG_VALUE: compare_hit_values:id_a <- $rdi
	#DEBUG_VALUE: compare_hit_values:da <- $xmm0
	#DEBUG_VALUE: compare_hit_values:id_b <- $rsi
	#DEBUG_VALUE: compare_hit_values:db <- $xmm1
	#DEBUG_VALUE: compare_hit_values:out <- $rdx
	.loc	1 0 48                          # instructor/src/wrappers.c:0:48
	movapd	xmm2, xmmword ptr [rip + .LCPI1_0] # xmm2 = [NaN,NaN]
	andpd	xmm2, xmm1
	.loc	1 9 48                          # instructor/src/wrappers.c:9:48
	ucomisd	xmm2, qword ptr [rip + .LCPI1_1]
	je	.LBB1_6
.Ltmp9:
# %bb.5:
	#DEBUG_VALUE: compare_hit_values:id_a <- $rdi
	#DEBUG_VALUE: compare_hit_values:da <- $xmm0
	#DEBUG_VALUE: compare_hit_values:id_b <- $rsi
	#DEBUG_VALUE: compare_hit_values:db <- $xmm1
	#DEBUG_VALUE: compare_hit_values:out <- $rdx
	.loc	1 0 48                          # instructor/src/wrappers.c:0:48
	mov	rbx, rdx
	.loc	1 10 16 is_stmt 1               # instructor/src/wrappers.c:10:16
	mov	qword ptr [rsp + 16], rdi
	movsd	qword ptr [rsp + 24], xmm0
	.loc	1 10 29 is_stmt 0               # instructor/src/wrappers.c:10:29
	mov	qword ptr [rsp], rsi
	movsd	qword ptr [rsp + 8], xmm1
	lea	rdi, [rsp + 16]
.Ltmp10:
	#DEBUG_VALUE: compare_hit_values:id_a <- [DW_OP_LLVM_entry_value 1] $rdi
	.loc	1 0 29                          # instructor/src/wrappers.c:0:29
	mov	rsi, rsp
.Ltmp11:
	#DEBUG_VALUE: compare_hit_values:id_b <- [DW_OP_LLVM_entry_value 1] $rsi
	.loc	1 11 15 is_stmt 1               # instructor/src/wrappers.c:11:15
	call	query_hit_compare@PLT
.Ltmp12:
	#DEBUG_VALUE: compare_hit_values:out <- $rbx
	#DEBUG_VALUE: compare_hit_values:db <- [DW_OP_LLVM_entry_value 1] $xmm1
	#DEBUG_VALUE: compare_hit_values:da <- [DW_OP_LLVM_entry_value 1] $xmm0
	#DEBUG_VALUE: compare_hit_values:order <- $eax
	.loc	1 12 9                          # instructor/src/wrappers.c:12:9
	mov	dword ptr [rbx], eax
	mov	eax, 1
.Ltmp13:
.LBB1_6:
	#DEBUG_VALUE: compare_hit_values:id_a <- [DW_OP_LLVM_entry_value 1] $rdi
	#DEBUG_VALUE: compare_hit_values:da <- [DW_OP_LLVM_entry_value 1] $xmm0
	#DEBUG_VALUE: compare_hit_values:id_b <- [DW_OP_LLVM_entry_value 1] $rsi
	#DEBUG_VALUE: compare_hit_values:db <- [DW_OP_LLVM_entry_value 1] $xmm1
	#DEBUG_VALUE: compare_hit_values:out <- [DW_OP_LLVM_entry_value 1] $rdx
	.loc	1 14 1                          # instructor/src/wrappers.c:14:1
	add	rsp, 32
	.cfi_def_cfa_offset 16
	pop	rbx
	.cfi_def_cfa_offset 8
	ret
.Ltmp14:
.Lfunc_end1:
	.size	compare_hit_values, .Lfunc_end1-compare_hit_values
	.cfi_endproc
                                        # -- End function
	.file	3 "/usr/include/x86_64-linux-gnu/bits" "types.h"
	.file	4 "/usr/include/x86_64-linux-gnu/bits" "stdint-uintn.h"
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp1-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	97                              # DW_OP_reg17
	.quad	.Ltmp1-.Lfunc_begin0
	.quad	.Ltmp3-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	99                              # DW_OP_reg19
	.quad	0
	.quad	0
.Ldebug_loc1:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp2-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	98                              # DW_OP_reg18
	.quad	.Ltmp2-.Lfunc_begin0
	.quad	.Ltmp3-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	100                             # DW_OP_reg20
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp10-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	85                              # DW_OP_reg5
	.quad	.Ltmp10-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	85                              # DW_OP_reg5
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc3:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp12-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	97                              # DW_OP_reg17
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	97                              # DW_OP_reg17
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc4:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp11-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	84                              # DW_OP_reg4
	.quad	.Ltmp11-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	84                              # DW_OP_reg4
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc5:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp12-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	98                              # DW_OP_reg18
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	98                              # DW_OP_reg18
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc6:
	.quad	.Lfunc_begin1-.Lfunc_begin0
	.quad	.Ltmp12-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	81                              # DW_OP_reg1
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Ltmp13-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	83                              # DW_OP_reg3
	.quad	.Ltmp13-.Lfunc_begin0
	.quad	.Lfunc_end1-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	81                              # DW_OP_reg1
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc7:
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Ltmp13-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	80                              # super-register DW_OP_reg0
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
	.byte	3                               # Abbreviation Code
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
	.ascii	"\211\202\001"                  # DW_TAG_GNU_call_site
	.byte	1                               # DW_CHILDREN_yes
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.ascii	"\225B"                         # DW_AT_GNU_tail_call
	.byte	25                              # DW_FORM_flag_present
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	6                               # Abbreviation Code
	.ascii	"\212\202\001"                  # DW_TAG_GNU_call_site_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.ascii	"\221B"                         # DW_AT_GNU_call_site_value
	.byte	24                              # DW_FORM_exprloc
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	7                               # Abbreviation Code
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
	.byte	8                               # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	9                               # Abbreviation Code
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
	.byte	10                              # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	11                              # Abbreviation Code
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
	.ascii	"\211\202\001"                  # DW_TAG_GNU_call_site
	.byte	1                               # DW_CHILDREN_yes
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	14                              # Abbreviation Code
	.byte	38                              # DW_TAG_const_type
	.byte	0                               # DW_CHILDREN_no
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	15                              # Abbreviation Code
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
	.byte	16                              # Abbreviation Code
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
	.byte	17                              # Abbreviation Code
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
	.byte	1                               # Abbrev [1] 0xb:0x1d0 DW_TAG_compile_unit
	.long	.Linfo_string0                  # DW_AT_producer
	.short	12                              # DW_AT_language
	.long	.Linfo_string1                  # DW_AT_name
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.long	.Linfo_string2                  # DW_AT_comp_dir
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin0       # DW_AT_high_pc
	.byte	2                               # Abbrev [2] 0x2a:0x68 DW_TAG_subprogram
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	.Linfo_string7                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	3                               # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	183                             # DW_AT_type
                                        # DW_AT_external
	.byte	3                               # Abbrev [3] 0x43:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc0                    # DW_AT_location
	.long	.Linfo_string9                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	3                               # DW_AT_decl_line
	.long	190                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x52:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc1                    # DW_AT_location
	.long	.Linfo_string10                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	3                               # DW_AT_decl_line
	.long	190                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x61:0xd DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	85
	.long	.Linfo_string11                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	3                               # DW_AT_decl_line
	.long	197                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x6e:0x23 DW_TAG_GNU_call_site
	.long	146                             # DW_AT_abstract_origin
                                        # DW_AT_GNU_tail_call
	.quad	.Ltmp3                          # DW_AT_low_pc
	.byte	6                               # Abbrev [6] 0x7b:0x7 DW_TAG_GNU_call_site_parameter
	.byte	1                               # DW_AT_location
	.byte	85
	.byte	3                               # DW_AT_GNU_call_site_value
	.byte	243
	.byte	1
	.byte	85
	.byte	6                               # Abbrev [6] 0x82:0x7 DW_TAG_GNU_call_site_parameter
	.byte	1                               # DW_AT_location
	.byte	99
	.byte	3                               # DW_AT_GNU_call_site_value
	.byte	243
	.byte	1
	.byte	97
	.byte	6                               # Abbrev [6] 0x89:0x7 DW_TAG_GNU_call_site_parameter
	.byte	1                               # DW_AT_location
	.byte	100
	.byte	3                               # DW_AT_GNU_call_site_value
	.byte	243
	.byte	1
	.byte	98
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	7                               # Abbrev [7] 0x92:0x25 DW_TAG_subprogram
	.long	.Linfo_string3                  # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	38                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	183                             # DW_AT_type
                                        # DW_AT_declaration
                                        # DW_AT_external
	.byte	8                               # Abbrev [8] 0x9d:0x5 DW_TAG_formal_parameter
	.long	190                             # DW_AT_type
	.byte	8                               # Abbrev [8] 0xa2:0x5 DW_TAG_formal_parameter
	.long	190                             # DW_AT_type
	.byte	8                               # Abbrev [8] 0xa7:0x5 DW_TAG_formal_parameter
	.long	190                             # DW_AT_type
	.byte	8                               # Abbrev [8] 0xac:0x5 DW_TAG_formal_parameter
	.long	190                             # DW_AT_type
	.byte	8                               # Abbrev [8] 0xb1:0x5 DW_TAG_formal_parameter
	.long	197                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	9                               # Abbrev [9] 0xb7:0x7 DW_TAG_base_type
	.long	.Linfo_string4                  # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	9                               # Abbrev [9] 0xbe:0x7 DW_TAG_base_type
	.long	.Linfo_string5                  # DW_AT_name
	.byte	4                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	10                              # Abbrev [10] 0xc5:0x5 DW_TAG_pointer_type
	.long	190                             # DW_AT_type
	.byte	2                               # Abbrev [2] 0xca:0xaa DW_TAG_subprogram
	.quad	.Lfunc_begin1                   # DW_AT_low_pc
	.long	.Lfunc_end1-.Lfunc_begin1       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	.Linfo_string8                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	183                             # DW_AT_type
                                        # DW_AT_external
	.byte	3                               # Abbrev [3] 0xe3:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc2                    # DW_AT_location
	.long	.Linfo_string20                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	440                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0xf2:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc3                    # DW_AT_location
	.long	.Linfo_string21                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	190                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x101:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc4                    # DW_AT_location
	.long	.Linfo_string22                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	440                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x110:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc5                    # DW_AT_location
	.long	.Linfo_string23                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	190                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x11f:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc6                    # DW_AT_location
	.long	.Linfo_string11                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	469                             # DW_AT_type
	.byte	11                              # Abbrev [11] 0x12e:0xe DW_TAG_variable
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	16
	.long	.Linfo_string12                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	10                              # DW_AT_decl_line
	.long	400                             # DW_AT_type
	.byte	11                              # Abbrev [11] 0x13c:0xe DW_TAG_variable
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	0
	.long	.Linfo_string19                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	10                              # DW_AT_decl_line
	.long	400                             # DW_AT_type
	.byte	12                              # Abbrev [12] 0x14a:0xf DW_TAG_variable
	.long	.Ldebug_loc7                    # DW_AT_location
	.long	.Linfo_string24                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.long	183                             # DW_AT_type
	.byte	13                              # Abbrev [13] 0x159:0x1a DW_TAG_GNU_call_site
	.long	372                             # DW_AT_abstract_origin
	.quad	.Ltmp12                         # DW_AT_low_pc
	.byte	6                               # Abbrev [6] 0x166:0x6 DW_TAG_GNU_call_site_parameter
	.byte	1                               # DW_AT_location
	.byte	84
	.byte	2                               # DW_AT_GNU_call_site_value
	.byte	145
	.byte	0
	.byte	6                               # Abbrev [6] 0x16c:0x6 DW_TAG_GNU_call_site_parameter
	.byte	1                               # DW_AT_location
	.byte	85
	.byte	2                               # DW_AT_GNU_call_site_value
	.byte	145
	.byte	16
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	7                               # Abbrev [7] 0x174:0x16 DW_TAG_subprogram
	.long	.Linfo_string6                  # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	57                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	183                             # DW_AT_type
                                        # DW_AT_declaration
                                        # DW_AT_external
	.byte	8                               # Abbrev [8] 0x17f:0x5 DW_TAG_formal_parameter
	.long	394                             # DW_AT_type
	.byte	8                               # Abbrev [8] 0x184:0x5 DW_TAG_formal_parameter
	.long	394                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	10                              # Abbrev [10] 0x18a:0x5 DW_TAG_pointer_type
	.long	399                             # DW_AT_type
	.byte	14                              # Abbrev [14] 0x18f:0x1 DW_TAG_const_type
	.byte	15                              # Abbrev [15] 0x190:0xb DW_TAG_typedef
	.long	411                             # DW_AT_type
	.long	.Linfo_string18                 # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	16                              # Abbrev [16] 0x19b:0x1d DW_TAG_structure_type
	.byte	16                              # DW_AT_byte_size
	.byte	2                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	17                              # Abbrev [17] 0x19f:0xc DW_TAG_member
	.long	.Linfo_string13                 # DW_AT_name
	.long	440                             # DW_AT_type
	.byte	2                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	0                               # DW_AT_data_member_location
	.byte	17                              # Abbrev [17] 0x1ab:0xc DW_TAG_member
	.long	.Linfo_string17                 # DW_AT_name
	.long	190                             # DW_AT_type
	.byte	2                               # DW_AT_decl_file
	.byte	42                              # DW_AT_decl_line
	.byte	8                               # DW_AT_data_member_location
	.byte	0                               # End Of Children Mark
	.byte	15                              # Abbrev [15] 0x1b8:0xb DW_TAG_typedef
	.long	451                             # DW_AT_type
	.long	.Linfo_string16                 # DW_AT_name
	.byte	4                               # DW_AT_decl_file
	.byte	27                              # DW_AT_decl_line
	.byte	15                              # Abbrev [15] 0x1c3:0xb DW_TAG_typedef
	.long	462                             # DW_AT_type
	.long	.Linfo_string15                 # DW_AT_name
	.byte	3                               # DW_AT_decl_file
	.byte	45                              # DW_AT_decl_line
	.byte	9                               # Abbrev [9] 0x1ce:0x7 DW_TAG_base_type
	.long	.Linfo_string14                 # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	10                              # Abbrev [10] 0x1d5:0x5 DW_TAG_pointer_type
	.long	183                             # DW_AT_type
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
	.asciz	"geo_distance_km"               # string offset=158
.Linfo_string4:
	.asciz	"int"                           # string offset=174
.Linfo_string5:
	.asciz	"double"                        # string offset=178
.Linfo_string6:
	.asciz	"query_hit_compare"             # string offset=185
.Linfo_string7:
	.asciz	"distance_to_origin"            # string offset=203
.Linfo_string8:
	.asciz	"compare_hit_values"            # string offset=222
.Linfo_string9:
	.asciz	"lat"                           # string offset=241
.Linfo_string10:
	.asciz	"lon"                           # string offset=245
.Linfo_string11:
	.asciz	"out"                           # string offset=249
.Linfo_string12:
	.asciz	"a"                             # string offset=253
.Linfo_string13:
	.asciz	"id"                            # string offset=255
.Linfo_string14:
	.asciz	"unsigned long"                 # string offset=258
.Linfo_string15:
	.asciz	"__uint64_t"                    # string offset=272
.Linfo_string16:
	.asciz	"uint64_t"                      # string offset=283
.Linfo_string17:
	.asciz	"distance_km"                   # string offset=292
.Linfo_string18:
	.asciz	"QueryHit"                      # string offset=304
.Linfo_string19:
	.asciz	"b"                             # string offset=313
.Linfo_string20:
	.asciz	"id_a"                          # string offset=315
.Linfo_string21:
	.asciz	"da"                            # string offset=320
.Linfo_string22:
	.asciz	"id_b"                          # string offset=323
.Linfo_string23:
	.asciz	"db"                            # string offset=328
.Linfo_string24:
	.asciz	"order"                         # string offset=331
	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.section	.debug_line,"",@progbits
.Lline_table_start0:
