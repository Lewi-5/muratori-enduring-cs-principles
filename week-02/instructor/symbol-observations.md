# Actual symbol and relocation excerpt

Captured 2026-09-20 under Ubuntu/WSL2 x86-64, GCC 11.4.0, GNU binutils 2.38, strict C11 -O0 with -fno-common. Command from week-02: `make PACKAGE=instructor symbols inspect`. This is one actual build, not a golden test fixture. The full local capture remains in ignored `build/symbols.log`.

Relevant `nm` entries:

```text
ex09_main.o:
0000000000000000 d hidden_counter
                 U shared_counter
                 U shared_limit
                 U shared_zero

ex09_data.o:
0000000000000004 d hidden_counter
0000000000000004 b local.0
0000000000000000 D shared_counter
0000000000000000 R shared_limit
0000000000000000 B shared_zero
```

readelf reported .bss as NOBITS and, in main.o, these representative symbol entries:

```text
4: 0000000000000000 4 OBJECT LOCAL  DEFAULT 3   hidden_counter
7: 0000000000000000 0 NOTYPE GLOBAL DEFAULT UND shared_counter
```

The data unit reports shared_counter in .data, shared_limit in .rodata, shared_zero and local.0 in .bss, and its own hidden_counter in .data. The two hidden objects have the same source spelling but separate internal linkage. local.0 is this compiler's chosen name for next_local's static local.

A relocation in the caller object:

```text
000000000013 000700000002 R_X86_64_PC32 0000000000000000 shared_counter - 4
```

This names a PC-relative reference requiring resolution against shared_counter, including an addend of -4 in this encoding. It is not the integer value of shared_counter. Link-time addresses in the executable differ from object-relative positions. Other compilation modes may change relocation locations and names while preserving C behavior. See the complete S02 explanation in [answers.md](answers.md#s02).
