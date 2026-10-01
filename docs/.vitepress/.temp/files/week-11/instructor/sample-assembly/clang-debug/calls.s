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
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset rbp, -16
	mov	rbp, rsp
	.cfi_def_cfa_register rbp
	sub	rsp, 48
	mov	qword ptr [rbp - 16], rdi
	mov	qword ptr [rbp - 24], rsi
	mov	qword ptr [rbp - 32], rdx
.Ltmp0:
	.loc	1 4 10 prologue_end             # instructor/src/calls.c:4:10
	cmp	qword ptr [rbp - 24], 0
	.loc	1 4 13 is_stmt 0                # instructor/src/calls.c:4:13
	je	.LBB0_2
# %bb.1:
	.loc	1 4 17                          # instructor/src/calls.c:4:17
	cmp	qword ptr [rbp - 32], 0
.Ltmp1:
	.loc	1 4 9                           # instructor/src/calls.c:4:9
	jne	.LBB0_3
.LBB0_2:
.Ltmp2:
	.loc	1 4 22                          # instructor/src/calls.c:4:22
	mov	dword ptr [rbp - 4], 0
	jmp	.LBB0_4
.Ltmp3:
.LBB0_3:
	.loc	1 7 26 is_stmt 1                # instructor/src/calls.c:7:26
	mov	rax, qword ptr [rbp - 24]
	.loc	1 7 29 is_stmt 0                # instructor/src/calls.c:7:29
	mov	rdi, qword ptr [rbp - 16]
	.loc	1 7 33                          # instructor/src/calls.c:7:33
	add	rdi, 1
	.loc	1 7 26                          # instructor/src/calls.c:7:26
	call	rax
	.loc	1 7 14                          # instructor/src/calls.c:7:14
	mov	qword ptr [rbp - 40], rax
	.loc	1 8 10 is_stmt 1                # instructor/src/calls.c:8:10
	mov	rcx, qword ptr [rbp - 16]
	.loc	1 8 14 is_stmt 0                # instructor/src/calls.c:8:14
	add	rcx, qword ptr [rbp - 40]
	.loc	1 8 6                           # instructor/src/calls.c:8:6
	mov	rax, qword ptr [rbp - 32]
	.loc	1 8 9                           # instructor/src/calls.c:8:9
	mov	qword ptr [rax], rcx
	.loc	1 9 5 is_stmt 1                 # instructor/src/calls.c:9:5
	mov	dword ptr [rbp - 4], 1
.LBB0_4:
	.loc	1 10 1                          # instructor/src/calls.c:10:1
	mov	eax, dword ptr [rbp - 4]
	add	rsp, 48
	pop	rbp
	.cfi_def_cfa rsp, 8
	ret
.Ltmp4:
.Lfunc_end0:
	.size	keep_across_call, .Lfunc_end0-keep_across_call
	.cfi_endproc
                                        # -- End function
	.file	2 "/usr/include/x86_64-linux-gnu/bits" "types.h"
	.file	3 "/usr/include/x86_64-linux-gnu/bits" "stdint-uintn.h"
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
	.byte	7                               # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	8                               # Abbreviation Code
	.byte	21                              # DW_TAG_subroutine_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	9                               # Abbreviation Code
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
	.byte	1                               # Abbrev [1] 0xb:0xab DW_TAG_compile_unit
	.long	.Linfo_string0                  # DW_AT_producer
	.short	12                              # DW_AT_language
	.long	.Linfo_string1                  # DW_AT_name
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.long	.Linfo_string2                  # DW_AT_comp_dir
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	2                               # Abbrev [2] 0x2a:0x52 DW_TAG_subprogram
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	86
	.long	.Linfo_string3                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	124                             # DW_AT_type
                                        # DW_AT_external
	.byte	3                               # Abbrev [3] 0x43:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	112
	.long	.Linfo_string5                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
	.long	131                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x51:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	104
	.long	.Linfo_string9                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
	.long	160                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x5f:0xe DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	96
	.long	.Linfo_string10                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
	.long	176                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x6d:0xe DW_TAG_variable
	.byte	2                               # DW_AT_location
	.byte	145
	.byte	88
	.long	.Linfo_string11                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	7                               # DW_AT_decl_line
	.long	131                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	5                               # Abbrev [5] 0x7c:0x7 DW_TAG_base_type
	.long	.Linfo_string4                  # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	6                               # Abbrev [6] 0x83:0xb DW_TAG_typedef
	.long	142                             # DW_AT_type
	.long	.Linfo_string8                  # DW_AT_name
	.byte	3                               # DW_AT_decl_file
	.byte	27                              # DW_AT_decl_line
	.byte	6                               # Abbrev [6] 0x8e:0xb DW_TAG_typedef
	.long	153                             # DW_AT_type
	.long	.Linfo_string7                  # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	45                              # DW_AT_decl_line
	.byte	5                               # Abbrev [5] 0x99:0x7 DW_TAG_base_type
	.long	.Linfo_string6                  # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	7                               # Abbrev [7] 0xa0:0x5 DW_TAG_pointer_type
	.long	165                             # DW_AT_type
	.byte	8                               # Abbrev [8] 0xa5:0xb DW_TAG_subroutine_type
	.long	131                             # DW_AT_type
                                        # DW_AT_prototyped
	.byte	9                               # Abbrev [9] 0xaa:0x5 DW_TAG_formal_parameter
	.long	131                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	7                               # Abbrev [7] 0xb0:0x5 DW_TAG_pointer_type
	.long	131                             # DW_AT_type
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
