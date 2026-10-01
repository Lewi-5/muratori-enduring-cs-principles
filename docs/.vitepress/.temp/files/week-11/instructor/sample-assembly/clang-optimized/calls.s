	.text
	.intel_syntax noprefix
	.file	"calls.c"
	.globl	keep_across_call                # -- Begin function keep_across_call
	.p2align	4, 0x90
	.type	keep_across_call,@function
keep_across_call:                       # @keep_across_call
.Lfunc_begin0:
	.file	1 "/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" "instructor/src/calls.c"
	.loc	1 3 0                           # instructor/src/calls.c:3:0
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: keep_across_call:seed <- $rdi
	#DEBUG_VALUE: keep_across_call:fn <- $rsi
	#DEBUG_VALUE: keep_across_call:out <- $rdx
	push	r14
	.cfi_def_cfa_offset 16
	push	rbx
	.cfi_def_cfa_offset 24
	push	rax
	.cfi_def_cfa_offset 32
	.cfi_offset rbx, -24
	.cfi_offset r14, -16
	xor	eax, eax
.Ltmp0:
	.loc	1 4 10 prologue_end             # instructor/src/calls.c:4:10
	test	rsi, rsi
	.loc	1 4 13 is_stmt 0                # instructor/src/calls.c:4:13
	je	.LBB0_3
.Ltmp1:
# %bb.1:
	#DEBUG_VALUE: keep_across_call:seed <- $rdi
	#DEBUG_VALUE: keep_across_call:fn <- $rsi
	#DEBUG_VALUE: keep_across_call:out <- $rdx
	.loc	1 0 13                          # instructor/src/calls.c:0:13
	mov	rbx, rdx
	.loc	1 4 13                          # instructor/src/calls.c:4:13
	test	rdx, rdx
	je	.LBB0_3
.Ltmp2:
# %bb.2:
	#DEBUG_VALUE: keep_across_call:seed <- $rdi
	#DEBUG_VALUE: keep_across_call:fn <- $rsi
	#DEBUG_VALUE: keep_across_call:out <- $rbx
	.loc	1 0 13                          # instructor/src/calls.c:0:13
	mov	r14, rdi
	.loc	1 7 33 is_stmt 1                # instructor/src/calls.c:7:33
	add	rdi, 1
.Ltmp3:
	#DEBUG_VALUE: keep_across_call:seed <- $r14
	.loc	1 7 26 is_stmt 0                # instructor/src/calls.c:7:26
	call	rsi
.Ltmp4:
	#DEBUG_VALUE: keep_across_call:fn <- [DW_OP_LLVM_entry_value 1] $rsi
	#DEBUG_VALUE: keep_across_call:transformed <- $rax
	.loc	1 8 14 is_stmt 1                # instructor/src/calls.c:8:14
	add	rax, r14
.Ltmp5:
	.loc	1 8 9 is_stmt 0                 # instructor/src/calls.c:8:9
	mov	qword ptr [rbx], rax
	mov	eax, 1
.Ltmp6:
.LBB0_3:
	#DEBUG_VALUE: keep_across_call:seed <- [DW_OP_LLVM_entry_value 1] $rdi
	#DEBUG_VALUE: keep_across_call:fn <- [DW_OP_LLVM_entry_value 1] $rsi
	#DEBUG_VALUE: keep_across_call:out <- [DW_OP_LLVM_entry_value 1] $rdx
	.loc	1 10 1 is_stmt 1                # instructor/src/calls.c:10:1
	add	rsp, 8
	.cfi_def_cfa_offset 24
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	r14
	.cfi_def_cfa_offset 8
	ret
.Ltmp7:
.Lfunc_end0:
	.size	keep_across_call, .Lfunc_end0-keep_across_call
	.cfi_endproc
                                        # -- End function
	.file	2 "/usr/include/x86_64-linux-gnu/bits" "types.h"
	.file	3 "/usr/include/x86_64-linux-gnu/bits" "stdint-uintn.h"
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp3-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	85                              # DW_OP_reg5
	.quad	.Ltmp3-.Lfunc_begin0
	.quad	.Ltmp6-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	94                              # DW_OP_reg14
	.quad	.Ltmp6-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	85                              # DW_OP_reg5
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc1:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp4-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	84                              # DW_OP_reg4
	.quad	.Ltmp4-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	84                              # DW_OP_reg4
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp2-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	81                              # DW_OP_reg1
	.quad	.Ltmp2-.Lfunc_begin0
	.quad	.Ltmp6-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	83                              # DW_OP_reg3
	.quad	.Ltmp6-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	81                              # DW_OP_reg1
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc3:
	.quad	.Ltmp4-.Lfunc_begin0
	.quad	.Ltmp5-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	80                              # DW_OP_reg0
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
	.byte	5                               # Abbreviation Code
	.ascii	"\211\202\001"                  # DW_TAG_GNU_call_site
	.byte	0                               # DW_CHILDREN_no
	.ascii	"\223B"                         # DW_AT_GNU_call_site_target
	.byte	24                              # DW_FORM_exprloc
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
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
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	9                               # Abbreviation Code
	.byte	21                              # DW_TAG_subroutine_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	10                              # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
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
	.byte	1                               # Abbrev [1] 0xb:0xba DW_TAG_compile_unit
	.long	.Linfo_string0                  # DW_AT_producer
	.short	12                              # DW_AT_language
	.long	.Linfo_string1                  # DW_AT_name
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.long	.Linfo_string2                  # DW_AT_comp_dir
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	2                               # Abbrev [2] 0x2a:0x61 DW_TAG_subprogram
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	.Linfo_string3                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	139                             # DW_AT_type
                                        # DW_AT_external
	.byte	3                               # Abbrev [3] 0x43:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc0                    # DW_AT_location
	.long	.Linfo_string5                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
	.long	146                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x52:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc1                    # DW_AT_location
	.long	.Linfo_string9                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
	.long	175                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x61:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc2                    # DW_AT_location
	.long	.Linfo_string10                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
	.long	191                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x70:0xf DW_TAG_variable
	.long	.Ldebug_loc3                    # DW_AT_location
	.long	.Linfo_string11                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	146                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x7f:0xb DW_TAG_GNU_call_site
	.byte	1                               # DW_AT_GNU_call_site_target
	.byte	84
	.quad	.Ltmp4                          # DW_AT_low_pc
	.byte	0                               # End Of Children Mark
	.byte	6                               # Abbrev [6] 0x8b:0x7 DW_TAG_base_type
	.long	.Linfo_string4                  # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	7                               # Abbrev [7] 0x92:0xb DW_TAG_typedef
	.long	157                             # DW_AT_type
	.long	.Linfo_string8                  # DW_AT_name
	.byte	3                               # DW_AT_decl_file
	.byte	27                              # DW_AT_decl_line
	.byte	7                               # Abbrev [7] 0x9d:0xb DW_TAG_typedef
	.long	168                             # DW_AT_type
	.long	.Linfo_string7                  # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	45                              # DW_AT_decl_line
	.byte	6                               # Abbrev [6] 0xa8:0x7 DW_TAG_base_type
	.long	.Linfo_string6                  # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	8                               # Abbrev [8] 0xaf:0x5 DW_TAG_pointer_type
	.long	180                             # DW_AT_type
	.byte	9                               # Abbrev [9] 0xb4:0xb DW_TAG_subroutine_type
	.long	146                             # DW_AT_type
                                        # DW_AT_prototyped
	.byte	10                              # Abbrev [10] 0xb9:0x5 DW_TAG_formal_parameter
	.long	146                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	8                               # Abbrev [8] 0xbf:0x5 DW_TAG_pointer_type
	.long	146                             # DW_AT_type
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"Ubuntu clang version 14.0.0-1ubuntu1.1" # string offset=0
.Linfo_string1:
	.asciz	"instructor/src/calls.c"        # string offset=39
.Linfo_string2:
	.asciz	"/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" # string offset=62
.Linfo_string3:
	.asciz	"keep_across_call"              # string offset=155
.Linfo_string4:
	.asciz	"int"                           # string offset=172
.Linfo_string5:
	.asciz	"seed"                          # string offset=176
.Linfo_string6:
	.asciz	"unsigned long"                 # string offset=181
.Linfo_string7:
	.asciz	"__uint64_t"                    # string offset=195
.Linfo_string8:
	.asciz	"uint64_t"                      # string offset=206
.Linfo_string9:
	.asciz	"fn"                            # string offset=215
.Linfo_string10:
	.asciz	"out"                           # string offset=218
.Linfo_string11:
	.asciz	"transformed"                   # string offset=222
	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.section	.debug_line,"",@progbits
.Lline_table_start0:
