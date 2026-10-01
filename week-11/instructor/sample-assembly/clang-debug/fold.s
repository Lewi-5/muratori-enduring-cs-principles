	.text
	.intel_syntax noprefix
	.file	"fold.c"
	.globl	fold_ids                        # -- Begin function fold_ids
	.p2align	4, 0x90
	.type	fold_ids,@function
fold_ids:                               # @fold_ids
.Lfunc_begin0:
	.file	1 "/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" "instructor/src/fold.c"
	.loc	1 3 0                           # instructor/src/fold.c:3:0
	.cfi_startproc
# %bb.0:
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	mov	qword ptr [rbp - 16], rdi
	mov	qword ptr [rbp - 24], rsi
	mov	qword ptr [rbp - 32], rdx
.Ltmp0:
	.loc	1 4 10 prologue_end             # instructor/src/fold.c:4:10
	cmp	qword ptr [rbp - 32], 0
	.loc	1 4 14 is_stmt 0                # instructor/src/fold.c:4:14
	je	.LBB0_3
# %bb.1:
	.loc	1 4 19                          # instructor/src/fold.c:4:19
	cmp	qword ptr [rbp - 16], 0
	.loc	1 4 26                          # instructor/src/fold.c:4:26
	jne	.LBB0_4
# %bb.2:
	.loc	1 4 29                          # instructor/src/fold.c:4:29
	cmp	qword ptr [rbp - 24], 0
.Ltmp1:
	.loc	1 4 9                           # instructor/src/fold.c:4:9
	je	.LBB0_4
.LBB0_3:
.Ltmp2:
	.loc	1 4 33                          # instructor/src/fold.c:4:33
	mov	dword ptr [rbp - 4], 0
	jmp	.LBB0_9
.Ltmp3:
.LBB0_4:
	.loc	1 5 14 is_stmt 1                # instructor/src/fold.c:5:14
	mov	qword ptr [rbp - 40], 0
.Ltmp4:
	.loc	1 6 17                          # instructor/src/fold.c:6:17
	mov	qword ptr [rbp - 48], 0
.LBB0_5:                                # =>This Inner Loop Header: Depth=1
.Ltmp5:
	.loc	1 6 22 is_stmt 0                # instructor/src/fold.c:6:22
	mov	rax, qword ptr [rbp - 48]
	.loc	1 6 23                          # instructor/src/fold.c:6:23
	cmp	rax, qword ptr [rbp - 24]
.Ltmp6:
	.loc	1 6 5                           # instructor/src/fold.c:6:5
	jae	.LBB0_8
# %bb.6:                                #   in Loop: Header=BB0_5 Depth=1
.Ltmp7:
	.loc	1 6 37                          # instructor/src/fold.c:6:37
	mov	rax, qword ptr [rbp - 16]
	imul	rcx, qword ptr [rbp - 48], 24
	add	rax, rcx
	.loc	1 6 47                          # instructor/src/fold.c:6:47
	mov	rax, qword ptr [rax]
	.loc	1 6 35                          # instructor/src/fold.c:6:35
	add	rax, qword ptr [rbp - 40]
	mov	qword ptr [rbp - 40], rax
# %bb.7:                                #   in Loop: Header=BB0_5 Depth=1
	.loc	1 6 27                          # instructor/src/fold.c:6:27
	mov	rax, qword ptr [rbp - 48]
	add	rax, 1
	mov	qword ptr [rbp - 48], rax
	.loc	1 6 5                           # instructor/src/fold.c:6:5
	jmp	.LBB0_5
.Ltmp8:
.LBB0_8:
	.loc	1 7 10 is_stmt 1                # instructor/src/fold.c:7:10
	mov	rcx, qword ptr [rbp - 40]
	.loc	1 7 6 is_stmt 0                 # instructor/src/fold.c:7:6
	mov	rax, qword ptr [rbp - 32]
	.loc	1 7 9                           # instructor/src/fold.c:7:9
	mov	qword ptr [rax], rcx
	.loc	1 8 5 is_stmt 1                 # instructor/src/fold.c:8:5
	mov	dword ptr [rbp - 4], 1
.LBB0_9:
	.loc	1 9 1                           # instructor/src/fold.c:9:1
	mov	eax, dword ptr [rbp - 4]
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Ltmp9:
.Lfunc_end0:
	.size	fold_ids, .Lfunc_end0-fold_ids
	.cfi_endproc
                                        # -- End function
	.file	2 "/usr/include/x86_64-linux-gnu/bits" "types.h"
	.file	3 "/usr/include/x86_64-linux-gnu/bits" "stdint-uintn.h"
	.file	4 "/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" "support/geolab/geolab_types.h"
	.file	5 "/usr/lib/llvm-14/lib/clang/14.0.0/include" "stddef.h"
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
	.byte	11                              # DW_TAG_lexical_block
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	6                               # Abbreviation Code
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
	.byte	7                               # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	8                               # Abbreviation Code
	.byte	38                              # DW_TAG_const_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	9                               # Abbreviation Code
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
	.byte	10                              # Abbreviation Code
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
	.byte	11                              # Abbreviation Code
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
	.byte	1                               # Abbrev [1] 0xb:0x107 DW_TAG_compile_unit
	.long	.Linfo_string0                  # DW_AT_producer
	.short	12                              # DW_AT_language
	.long	.Linfo_string1                  # DW_AT_name
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.long	.Linfo_string2                  # DW_AT_comp_dir
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	2                               # Abbrev [2] 0x2a:0x6e DW_TAG_subprogram
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	86
	.long	.Linfo_string3                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	152                             # DW_AT_type
                                        # DW_AT_external
	.byte	3                               # Abbrev [3] 0x43:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	112
	.long	.Linfo_string5                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
	.long	159                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x51:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	104
	.long	.Linfo_string14                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
	.long	257                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x5f:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	96
	.long	.Linfo_string16                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
	.long	268                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x6d:0xe DW_TAG_variable
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	88
	.long	.Linfo_string17                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	5                               # DW_AT_decl_line
	.long	221                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x7b:0x1c DW_TAG_lexical_block
	.quad	.Ltmp4                          # DW_AT_low_pc
	.long	.Ltmp8-.Ltmp4                   # DW_AT_high_pc
	.byte	4                               # Abbrev [4] 0x88:0xe DW_TAG_variable
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	80
	.long	.Linfo_string18                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	6                               # DW_AT_decl_line
	.long	257                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	6                               # Abbrev [6] 0x98:0x7 DW_TAG_base_type
	.long	.Linfo_string4                  # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	7                               # Abbrev [7] 0x9f:0x5 DW_TAG_pointer_type
	.long	164                             # DW_AT_type
	.byte	8                               # Abbrev [8] 0xa4:0x5 DW_TAG_const_type
	.long	169                             # DW_AT_type
	.byte	9                               # Abbrev [9] 0xa9:0xb DW_TAG_typedef
	.long	180                             # DW_AT_type
	.long	.Linfo_string13                 # DW_AT_name
	.byte	4                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	10                              # Abbrev [10] 0xb4:0x29 DW_TAG_structure_type
	.byte	24                              # DW_AT_byte_size
	.byte	4                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	11                              # Abbrev [11] 0xb8:0xc DW_TAG_member
	.long	.Linfo_string6                  # DW_AT_name
	.long	221                             # DW_AT_type
	.byte	4                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	0                               # DW_AT_data_member_location
	.byte	11                              # Abbrev [11] 0xc4:0xc DW_TAG_member
	.long	.Linfo_string10                 # DW_AT_name
	.long	250                             # DW_AT_type
	.byte	4                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	8                               # DW_AT_data_member_location
	.byte	11                              # Abbrev [11] 0xd0:0xc DW_TAG_member
	.long	.Linfo_string12                 # DW_AT_name
	.long	250                             # DW_AT_type
	.byte	4                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	16                              # DW_AT_data_member_location
	.byte	0                               # End Of Children Mark
	.byte	9                               # Abbrev [9] 0xdd:0xb DW_TAG_typedef
	.long	232                             # DW_AT_type
	.long	.Linfo_string9                  # DW_AT_name
	.byte	3                               # DW_AT_decl_file
	.byte	27                              # DW_AT_decl_line
	.byte	9                               # Abbrev [9] 0xe8:0xb DW_TAG_typedef
	.long	243                             # DW_AT_type
	.long	.Linfo_string8                  # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	45                              # DW_AT_decl_line
	.byte	6                               # Abbrev [6] 0xf3:0x7 DW_TAG_base_type
	.long	.Linfo_string7                  # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	6                               # Abbrev [6] 0xfa:0x7 DW_TAG_base_type
	.long	.Linfo_string11                 # DW_AT_name
	.byte	4                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	9                               # Abbrev [9] 0x101:0xb DW_TAG_typedef
	.long	243                             # DW_AT_type
	.long	.Linfo_string15                 # DW_AT_name
	.byte	5                               # DW_AT_decl_file
	.byte	46                              # DW_AT_decl_line
	.byte	7                               # Abbrev [7] 0x10c:0x5 DW_TAG_pointer_type
	.long	221                             # DW_AT_type
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"Ubuntu clang version 14.0.0-1ubuntu1.1" # string offset=0
.Linfo_string1:
	.asciz	"instructor/src/fold.c"         # string offset=39
.Linfo_string2:
	.asciz	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" # string offset=61
.Linfo_string3:
	.asciz	"fold_ids"                      # string offset=154
.Linfo_string4:
	.asciz	"int"                           # string offset=163
.Linfo_string5:
	.asciz	"points"                        # string offset=167
.Linfo_string6:
	.asciz	"id"                            # string offset=174
.Linfo_string7:
	.asciz	"unsigned long"                 # string offset=177
.Linfo_string8:
	.asciz	"__uint64_t"                    # string offset=191
.Linfo_string9:
	.asciz	"uint64_t"                      # string offset=202
.Linfo_string10:
	.asciz	"lat_deg"                       # string offset=211
.Linfo_string11:
	.asciz	"double"                        # string offset=219
.Linfo_string12:
	.asciz	"lon_deg"                       # string offset=226
.Linfo_string13:
	.asciz	"GeoPoint"                      # string offset=234
.Linfo_string14:
	.asciz	"n"                             # string offset=243
.Linfo_string15:
	.asciz	"size_t"                        # string offset=245
.Linfo_string16:
	.asciz	"out"                           # string offset=252
.Linfo_string17:
	.asciz	"sum"                           # string offset=256
.Linfo_string18:
	.asciz	"k"                             # string offset=260
	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.section	.debug_line,"",@progbits
.Lline_table_start0:
