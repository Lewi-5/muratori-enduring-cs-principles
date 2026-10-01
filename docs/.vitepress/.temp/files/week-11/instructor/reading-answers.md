# Reading answers

### F01

The x86 family retains related instruction/encoding ideas, but x64 has different widths/addressing and ordinary return words from the historical subset. The ABI assigns arguments, results, register ownership and stack agreement to separately compiled boundaries. CS:APP's examples show possible generated implementations of those requirements, including register or stack local storage. An observed RBP frame is not a universal C/ABI requirement; the actual signature and ABI rule must be distinguished from that compiler's choices.

### F02

Separate translation units can emit a symbolic call before its destination address is resolved. The object stores a relocation that lets the linker complete the reference; reading only placeholder bytes can misidentify the target. Compiler .s shows symbolic operands but not final runtime resolution. An optimized local calculation can be combined into LEA/ADD or other operations with no stack slot while retaining required C behavior. HH's particular compiler comparison is illustrative evidence, not a required mapping for our toolchain.

### F03

Architectural correctness describes resulting values/control flow; a historical cost model assigns costs under stated assumptions; a modern predictor speculates about likely flow before resolution. Pipelining, dependencies, resources and cache/call behavior prevent instruction count from being a cycle count. Intel's return account is processor-specific, not a universal depth guarantee or another source-language stack. Measure target-specific timing/prediction under a controlled workload rather than inferring it from the compiler listing or simulator steps.
