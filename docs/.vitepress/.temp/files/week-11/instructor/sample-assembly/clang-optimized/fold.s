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
	#DEBUG_VALUE: fold_ids:points <- $rdi
	#DEBUG_VALUE: fold_ids:n <- $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	xor	eax, eax
.Ltmp0:
	.loc	1 4 10 prologue_end             # instructor/src/fold.c:4:10
	test	rdx, rdx
	.loc	1 4 14 is_stmt 0                # instructor/src/fold.c:4:14
	je	.LBB0_11
.Ltmp1:
# %bb.1:
	#DEBUG_VALUE: fold_ids:points <- $rdi
	#DEBUG_VALUE: fold_ids:n <- $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	.loc	1 4 19                          # instructor/src/fold.c:4:19
	test	rdi, rdi
	.loc	1 4 26                          # instructor/src/fold.c:4:26
	jne	.LBB0_3
.Ltmp2:
# %bb.2:
	#DEBUG_VALUE: fold_ids:points <- $rdi
	#DEBUG_VALUE: fold_ids:n <- $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	test	rsi, rsi
	je	.LBB0_3
.Ltmp3:
.LBB0_11:
	#DEBUG_VALUE: fold_ids:points <- $rdi
	#DEBUG_VALUE: fold_ids:n <- $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	.loc	1 9 1 is_stmt 1                 # instructor/src/fold.c:9:1
	ret
.Ltmp4:
.LBB0_3:
	#DEBUG_VALUE: fold_ids:points <- $rdi
	#DEBUG_VALUE: fold_ids:n <- $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	#DEBUG_VALUE: k <- 0
	#DEBUG_VALUE: fold_ids:sum <- 0
	.loc	1 6 23                          # instructor/src/fold.c:6:23
	test	rsi, rsi
.Ltmp5:
	.loc	1 6 5 is_stmt 0                 # instructor/src/fold.c:6:5
	je	.LBB0_4
.Ltmp6:
# %bb.5:
	#DEBUG_VALUE: fold_ids:points <- $rdi
	#DEBUG_VALUE: fold_ids:n <- $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	#DEBUG_VALUE: k <- 0
	#DEBUG_VALUE: fold_ids:sum <- 0
	lea	rax, [rsi - 1]
	mov	r8d, esi
	and	r8d, 3
	cmp	rax, 3
	jae	.LBB0_12
.Ltmp7:
# %bb.6:
	#DEBUG_VALUE: fold_ids:points <- $rdi
	#DEBUG_VALUE: fold_ids:n <- $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	#DEBUG_VALUE: k <- 0
	#DEBUG_VALUE: fold_ids:sum <- 0
	.loc	1 0 5                           # instructor/src/fold.c:0:5
	xor	r9d, r9d
	xor	eax, eax
	jmp	.LBB0_7
.Ltmp8:
.LBB0_4:
	#DEBUG_VALUE: fold_ids:points <- $rdi
	#DEBUG_VALUE: fold_ids:n <- $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	#DEBUG_VALUE: k <- 0
	#DEBUG_VALUE: fold_ids:sum <- 0
	xor	eax, eax
	jmp	.LBB0_10
.Ltmp9:
.LBB0_12:
	#DEBUG_VALUE: fold_ids:points <- $rdi
	#DEBUG_VALUE: fold_ids:n <- $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	#DEBUG_VALUE: k <- 0
	#DEBUG_VALUE: fold_ids:sum <- 0
	.loc	1 6 5                           # instructor/src/fold.c:6:5
	and	rsi, -4
.Ltmp10:
	#DEBUG_VALUE: fold_ids:n <- [DW_OP_LLVM_entry_value 1] $rsi
	.loc	1 0 5                           # instructor/src/fold.c:0:5
	xor	r9d, r9d
	mov	rcx, rdi
	xor	eax, eax
.Ltmp11:
	.p2align	4, 0x90
.LBB0_13:                               # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: fold_ids:points <- $rdi
	#DEBUG_VALUE: fold_ids:n <- [DW_OP_LLVM_entry_value 1] $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	#DEBUG_VALUE: k <- $r9
	#DEBUG_VALUE: fold_ids:sum <- $rax
	.loc	1 6 35                          # instructor/src/fold.c:6:35
	add	rax, qword ptr [rcx]
.Ltmp12:
	#DEBUG_VALUE: fold_ids:sum <- $rax
	#DEBUG_VALUE: fold_ids:sum <- $rax
	#DEBUG_VALUE: k <- [DW_OP_constu 1, DW_OP_or, DW_OP_stack_value] $r9
	#DEBUG_VALUE: k <- [DW_OP_constu 1, DW_OP_or, DW_OP_stack_value] $r9
	add	rax, qword ptr [rcx + 24]
.Ltmp13:
	#DEBUG_VALUE: fold_ids:sum <- $rax
	#DEBUG_VALUE: fold_ids:sum <- $rax
	#DEBUG_VALUE: k <- [DW_OP_constu 2, DW_OP_or, DW_OP_stack_value] $r9
	#DEBUG_VALUE: k <- [DW_OP_constu 2, DW_OP_or, DW_OP_stack_value] $r9
	add	rax, qword ptr [rcx + 48]
.Ltmp14:
	#DEBUG_VALUE: fold_ids:sum <- $rax
	#DEBUG_VALUE: fold_ids:sum <- $rax
	#DEBUG_VALUE: k <- [DW_OP_constu 3, DW_OP_or, DW_OP_stack_value] $r9
	#DEBUG_VALUE: k <- [DW_OP_constu 3, DW_OP_or, DW_OP_stack_value] $r9
	add	rax, qword ptr [rcx + 72]
.Ltmp15:
	#DEBUG_VALUE: fold_ids:sum <- $rax
	.loc	1 6 27                          # instructor/src/fold.c:6:27
	add	r9, 4
.Ltmp16:
	#DEBUG_VALUE: k <- $r9
	.loc	1 6 5                           # instructor/src/fold.c:6:5
	add	rcx, 96
	cmp	rsi, r9
	jne	.LBB0_13
.Ltmp17:
.LBB0_7:
	#DEBUG_VALUE: fold_ids:points <- $rdi
	#DEBUG_VALUE: fold_ids:n <- [DW_OP_LLVM_entry_value 1] $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	test	r8, r8
	je	.LBB0_10
.Ltmp18:
# %bb.8:
	#DEBUG_VALUE: fold_ids:points <- $rdi
	#DEBUG_VALUE: fold_ids:n <- [DW_OP_LLVM_entry_value 1] $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	lea	rcx, [r9 + 2*r9]
	lea	rcx, [rdi + 8*rcx]
	shl	r8, 3
	lea	rsi, [r8 + 2*r8]
	xor	edi, edi
.Ltmp19:
	#DEBUG_VALUE: fold_ids:points <- [DW_OP_LLVM_entry_value 1] $rdi
	.p2align	4, 0x90
.LBB0_9:                                # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: fold_ids:points <- [DW_OP_LLVM_entry_value 1] $rdi
	#DEBUG_VALUE: fold_ids:n <- [DW_OP_LLVM_entry_value 1] $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	#DEBUG_VALUE: k <- [DW_OP_LLVM_arg 0, DW_OP_consts 24, DW_OP_div, DW_OP_LLVM_arg 0, DW_OP_plus, DW_OP_stack_value] undef
	#DEBUG_VALUE: fold_ids:sum <- $rax
	.loc	1 6 35                          # instructor/src/fold.c:6:35
	add	rax, qword ptr [rcx + rdi]
.Ltmp20:
	#DEBUG_VALUE: k <- [DW_OP_LLVM_arg 0, DW_OP_consts 24, DW_OP_div, DW_OP_consts 1, DW_OP_LLVM_arg 0, DW_OP_plus, DW_OP_plus, DW_OP_stack_value] undef
	#DEBUG_VALUE: fold_ids:sum <- $rax
	.loc	1 6 5                           # instructor/src/fold.c:6:5
	add	rdi, 24
	cmp	rsi, rdi
	jne	.LBB0_9
.Ltmp21:
.LBB0_10:
	#DEBUG_VALUE: fold_ids:points <- [DW_OP_LLVM_entry_value 1] $rdi
	#DEBUG_VALUE: fold_ids:n <- [DW_OP_LLVM_entry_value 1] $rsi
	#DEBUG_VALUE: fold_ids:out <- $rdx
	.loc	1 7 9 is_stmt 1                 # instructor/src/fold.c:7:9
	mov	qword ptr [rdx], rax
	mov	eax, 1
	.loc	1 9 1                           # instructor/src/fold.c:9:1
	ret
.Ltmp22:
.Lfunc_end0:
	.size	fold_ids, .Lfunc_end0-fold_ids
	.cfi_endproc
                                        # -- End function
	.file	2 "/usr/include/x86_64-linux-gnu/bits" "types.h"
	.file	3 "/usr/include/x86_64-linux-gnu/bits" "stdint-uintn.h"
	.file	4 "/mnt/c/Users/Lewis/OneDrive - LATYS/Documents/Github/muratori-enduring-cs-principles/week-11" "support/geolab/geolab_types.h"
	.file	5 "/usr/lib/llvm-14/lib/clang/14.0.0/include" "stddef.h"
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
	.quad	.Lfunc_begin0-.Lfunc_begin0
	.quad	.Ltmp19-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	85                              # DW_OP_reg5
	.quad	.Ltmp19-.Lfunc_begin0
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
	.quad	.Ltmp10-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	84                              # DW_OP_reg4
	.quad	.Ltmp10-.Lfunc_begin0
	.quad	.Lfunc_end0-.Lfunc_begin0
	.short	4                               # Loc expr size
	.byte	243                             # DW_OP_GNU_entry_value
	.byte	1                               # 1
	.byte	84                              # DW_OP_reg4
	.byte	159                             # DW_OP_stack_value
	.quad	0
	.quad	0
.Ldebug_loc2:
	.quad	.Ltmp4-.Lfunc_begin0
	.quad	.Ltmp11-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp11-.Lfunc_begin0
	.quad	.Ltmp12-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	89                              # DW_OP_reg9
	.quad	.Ltmp12-.Lfunc_begin0
	.quad	.Ltmp13-.Lfunc_begin0
	.short	5                               # Loc expr size
	.byte	121                             # DW_OP_breg9
	.byte	0                               # 0
	.byte	49                              # DW_OP_lit1
	.byte	33                              # DW_OP_or
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp13-.Lfunc_begin0
	.quad	.Ltmp14-.Lfunc_begin0
	.short	5                               # Loc expr size
	.byte	121                             # DW_OP_breg9
	.byte	0                               # 0
	.byte	50                              # DW_OP_lit2
	.byte	33                              # DW_OP_or
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp14-.Lfunc_begin0
	.quad	.Ltmp16-.Lfunc_begin0
	.short	5                               # Loc expr size
	.byte	121                             # DW_OP_breg9
	.byte	0                               # 0
	.byte	51                              # DW_OP_lit3
	.byte	33                              # DW_OP_or
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp16-.Lfunc_begin0
	.quad	.Ltmp17-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	89                              # DW_OP_reg9
	.quad	0
	.quad	0
.Ldebug_loc3:
	.quad	.Ltmp4-.Lfunc_begin0
	.quad	.Ltmp11-.Lfunc_begin0
	.short	2                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	159                             # DW_OP_stack_value
	.quad	.Ltmp11-.Lfunc_begin0
	.quad	.Ltmp17-.Lfunc_begin0
	.short	1                               # Loc expr size
	.byte	80                              # DW_OP_reg0
	.quad	.Ltmp19-.Lfunc_begin0
	.quad	.Ltmp21-.Lfunc_begin0
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
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	10                              # Abbreviation Code
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
	.byte	11                              # Abbreviation Code
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
	.byte	12                              # Abbreviation Code
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
	.byte	1                               # Abbrev [1] 0xb:0x10a DW_TAG_compile_unit
	.long	.Linfo_string0                  # DW_AT_producer
	.short	12                              # DW_AT_language
	.long	.Linfo_string1                  # DW_AT_name
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.long	.Linfo_string2                  # DW_AT_comp_dir
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	2                               # Abbrev [2] 0x2a:0x71 DW_TAG_subprogram
	.quad	.Lfunc_begin0                   # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	87
                                        # DW_AT_GNU_all_call_sites
	.long	.Linfo_string3                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	155                             # DW_AT_type
                                        # DW_AT_external
	.byte	3                               # Abbrev [3] 0x43:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc0                    # DW_AT_location
	.long	.Linfo_string5                  # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
	.long	162                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x52:0xf DW_TAG_formal_parameter
	.long	.Ldebug_loc1                    # DW_AT_location
	.long	.Linfo_string14                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
	.long	260                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x61:0xd DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	81
	.long	.Linfo_string16                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
	.long	271                             # DW_AT_type
	.byte	5                               # Abbrev [5] 0x6e:0xf DW_TAG_variable
	.long	.Ldebug_loc3                    # DW_AT_location
	.long	.Linfo_string18                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	5                               # DW_AT_decl_line
	.long	224                             # DW_AT_type
	.byte	6                               # Abbrev [6] 0x7d:0x1d DW_TAG_lexical_block
	.quad	.Ltmp4                          # DW_AT_low_pc
	.long	.Ltmp21-.Ltmp4                  # DW_AT_high_pc
	.byte	5                               # Abbrev [5] 0x8a:0xf DW_TAG_variable
	.long	.Ldebug_loc2                    # DW_AT_location
	.long	.Linfo_string17                 # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	6                               # DW_AT_decl_line
	.long	260                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	7                               # Abbrev [7] 0x9b:0x7 DW_TAG_base_type
	.long	.Linfo_string4                  # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	8                               # Abbrev [8] 0xa2:0x5 DW_TAG_pointer_type
	.long	167                             # DW_AT_type
	.byte	9                               # Abbrev [9] 0xa7:0x5 DW_TAG_const_type
	.long	172                             # DW_AT_type
	.byte	10                              # Abbrev [10] 0xac:0xb DW_TAG_typedef
	.long	183                             # DW_AT_type
	.long	.Linfo_string13                 # DW_AT_name
	.byte	4                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	11                              # Abbrev [11] 0xb7:0x29 DW_TAG_structure_type
	.byte	24                              # DW_AT_byte_size
	.byte	4                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	12                              # Abbrev [12] 0xbb:0xc DW_TAG_member
	.long	.Linfo_string6                  # DW_AT_name
	.long	224                             # DW_AT_type
	.byte	4                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	0                               # DW_AT_data_member_location
	.byte	12                              # Abbrev [12] 0xc7:0xc DW_TAG_member
	.long	.Linfo_string10                 # DW_AT_name
	.long	253                             # DW_AT_type
	.byte	4                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	8                               # DW_AT_data_member_location
	.byte	12                              # Abbrev [12] 0xd3:0xc DW_TAG_member
	.long	.Linfo_string12                 # DW_AT_name
	.long	253                             # DW_AT_type
	.byte	4                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	16                              # DW_AT_data_member_location
	.byte	0                               # End Of Children Mark
	.byte	10                              # Abbrev [10] 0xe0:0xb DW_TAG_typedef
	.long	235                             # DW_AT_type
	.long	.Linfo_string9                  # DW_AT_name
	.byte	3                               # DW_AT_decl_file
	.byte	27                              # DW_AT_decl_line
	.byte	10                              # Abbrev [10] 0xeb:0xb DW_TAG_typedef
	.long	246                             # DW_AT_type
	.long	.Linfo_string8                  # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	45                              # DW_AT_decl_line
	.byte	7                               # Abbrev [7] 0xf6:0x7 DW_TAG_base_type
	.long	.Linfo_string7                  # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	7                               # Abbrev [7] 0xfd:0x7 DW_TAG_base_type
	.long	.Linfo_string11                 # DW_AT_name
	.byte	4                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	10                              # Abbrev [10] 0x104:0xb DW_TAG_typedef
	.long	246                             # DW_AT_type
	.long	.Linfo_string15                 # DW_AT_name
	.byte	5                               # DW_AT_decl_file
	.byte	46                              # DW_AT_decl_line
	.byte	8                               # Abbrev [8] 0x10f:0x5 DW_TAG_pointer_type
	.long	224                             # DW_AT_type
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
	.asciz	"k"                             # string offset=256
.Linfo_string18:
	.asciz	"sum"                           # string offset=258
	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.section	.debug_line,"",@progbits
.Lline_table_start0:
