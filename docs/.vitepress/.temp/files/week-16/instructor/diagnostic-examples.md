# Actual diagnostic excerpts — 2026-10-01

Observed under GCC 11.4 and Clang 14 on x86-64 WSL. Full reports are regenerated in build/diagnostics. Sanitizer excerpts stop after the error category; variable addresses, symbols and frames are omitted. Compiler excerpts retain the actual warning and source location. These are expected child-process failures, separate from clean repaired runs.

## clang-double_free

```text

SUMMARY: AddressSanitizer: double-free

```

## clang-local

```text

bugs/return_local.c:2:43: error: address of stack memory associated with local variable 'local' returned [-Werror,-Wreturn-stack-address]

```

## clang-use_after_free

```text

SUMMARY: AddressSanitizer: heap-use-after-free

```

## gcc-double_free

```text

SUMMARY: AddressSanitizer: double-free

```

## gcc-local

```text

bugs/return_local.c:2:42: error: function returns address of local variable [-Werror=return-local-addr]

```

## gcc-use_after_free

```text

SUMMARY: AddressSanitizer: heap-use-after-free

```
