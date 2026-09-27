# Tools and commands

You see a compiler, linker, Python script, and disassembler mentioned in one lesson. They are not interchangeable witnesses. Each consumes a different artifact and answers a different question.

| Tool | Reads | Produces or changes | Cannot establish alone |
| --- | --- | --- | --- |
| GCC or Clang | C source, headers, options | Objects, assembly, or executables | Correctness for all inputs |
| `make` | Build recipe, dependencies, timestamps | Runs the selected build/test actions | Whether the recipe asks the right scientific question |
| Linker | Objects and libraries | A linked executable | That the program's runtime logic is correct |
| `nm` | Object or executable | A symbol listing | The time a function takes |
| `readelf` | ELF object or executable | Sections, symbols, relocations | The C lifetime of every object |
| `objdump` | Binary bytes and architecture choice | Disassembly or other object details | Whether the decoded bytes were actually executed |
| Python test harness | Fixtures and program results | Comparisons and diagnostics; sometimes generated fixtures | All behavior beyond its checks |
| Sanitizers | An instrumented execution | Diagnostics for supported faults on executed paths | Absence of all undefined behavior |
| VitePress | Authored Markdown and imported course files | The local documentation site | A working C exercise environment |

## Compiler flags have jobs

`-std=c11` selects the language version. `-Wall -Wextra -Wpedantic` request diagnostic groups, and `-Werror` makes warnings fail the build. These flags are useful checks, not a proof that the source is valid in every respect.

`-O0` and `-O2` select optimization policies. They are not promises of a fixed instruction sequence or a particular speed ratio. The numerical packages use `-ffp-contract=off` to keep the studied rounding paths from changing through contraction. Preserve each package's required flags.

`-g` adds debugging information. AddressSanitizer and UndefinedBehaviorSanitizer instrument a build to detect particular classes of faults during execution. The package recipes record their exact supported configurations; do not infer that a clean sanitizer run covers paths you never exercised.

## Read a command in context

In `make CC=clang MODE=optimized test`, `CC` chooses the compiler, `MODE` chooses the recipe's build mode, and `test` is the target. Run it from the named week directory. The same-looking target can include different additional checks in different weeks.

The default package is the learner package. `make PACKAGE=instructor test` deliberately selects the reference answers. This is useful for instructor verification but does not validate your unfinished learner implementation.

`make symbols` inspects names after compilation. An undefined symbol in an object file can be a normal reference for the linker to resolve; it is not automatically a failed program. Follow it into the executable before interpreting it.

## Evidence categories

| Category | Example question |
| --- | --- |
| C11 | Is this access or arithmetic operation defined by the language? |
| Annex F / IEC 60559 | Which floating-point properties does the gated target promise? |
| POSIX/Linux | What does this clock or file operation promise? |
| ABI or ISA | How are objects arranged, or instructions encoded, for this target? |
| Compiler/toolchain | What did these flags and tools generate or display? |
| Observation | What occurred in this recorded run? |

Begin with a small check whose result you can derive. If a tool disagrees, confirm its input file, mode, and architecture before revising your mental model.
