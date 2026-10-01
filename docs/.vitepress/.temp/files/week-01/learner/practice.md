# Practice and optional stretch

These six practice problems are ungraded preparation for the notebook explanations. The two stretch tasks are optional; neither changes the base exercise contracts.

### P01

Classify and justify each as a portable C11 guarantee, implementation-defined choice/observation, or invalid/undefined operation: (a) `sizeof(char)==1`; (b) plain `char` is signed; (c) `UINT_MAX + 1u == 0`; (d) `INT_MAX + 1` is evaluated in type int; (e) dereferencing `a + 3` where `int a[3]` exists. Refine the label where “implementation-dependent” is broader than the standard's term “implementation-defined.”

### P02

For `int a[3]={2,4,6}`, predict `sizeof a`, `sizeof a[0]`, and their quotient. In `void show(int a[3])`, what type does `a` actually have and what does `sizeof a` mean? Write and run a warning-clean example using an explicit pointer parameter for the actual measurement and print the first element too. Explain why the warning-clean spelling has the same parameter type.

### P03

Inspect without executing: `int a[3]={2,4,6}; int sum=0; for(size_t i=0;i<=3;++i) sum+=a[i];`. Locate the error, repair the bound, give the expected sum and explain the legal role of a one-past pointer.

### P04

For the two field orders in E08, predict which may use fewer bytes on x86-64 Linux, draw a plausible layout, and explain why neither that byte count nor a strict size improvement belongs in a portable test.

### P05

Sketch the E14 path from source and included header through compiler, object files, linker, executable and running process. Explain where a missing definition is diagnosed and where the program actually begins executing.

### P06

Identify two faulty benchmark designs: initialization inside the timed interval, and a pure repeated sum whose results are discarded. Explain the bias or optimization each allows and give a repair, including the limitation of the chosen anti-optimization technique.

### S01

Optional: use `make assembly` for E06. Annotate a short loop excerpt at `-O0` and `-O2` to relate loads, increments, additions and branches to source semantics. Explain one difference and one conclusion you cannot infer from assembly alone. Different valid compiler output is accepted.

### S02

Optional: in a separate `stretch_lines.c`, extend E12 to count logical lines, including a final nonempty unterminated line. Define empty-file behavior, preserve error handling and provide code plus tests for empty, newline-only, terminated and unterminated multi-line inputs. Explain the state needed beyond newline count.
