# Reading answers

### F01

Scott introduces separating memory location from stored data. CS:APP gives effective-address arithmetic for modern machine-code operands. Intel provides the exact historical encoding table needed to interpret mode and r/m. All support the idea of a memory operand, but only the selected ISA reference determines the accepted byte patterns. Modern scaling factors and extra registers from CS:APP must not enter the 8086 table.

### F02

The include contributes declarations and type definitions to the client translation unit. Compilation checks its uses and emits code with unresolved external calls or linker information. Linking connects those calls to definitions or records shared dependencies; loading makes the needed code available in the process. A header alone lacks implementation code, so the library definition is still needed. Conversely a library with no matching header leaves the client without reliable compile-time type information. CS 341 extends the build view; CS:APP covers shared loading in more depth.

### F03

Position-independent code supports loading code at different addresses using the toolchain’s addressing and relocation machinery. A recorded shared dependency is processed by the loader at startup; dlopen requests a library while the application is running. Both still call machine code under an ABI. A changed Operand layout can shift offsets and sizes while symbol names stay identical. Rebuild both sides against compatible headers and conventions. Dynamic loading controls when code is available; it does not infer type compatibility. The deeper reading explains these Linux/ELF mechanisms beyond ISO C.
