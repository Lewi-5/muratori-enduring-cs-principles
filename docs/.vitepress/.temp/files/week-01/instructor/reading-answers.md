# Reading-question answers — the C field notebook

Worked answers to the further-reading questions. Book citations match the further-reading page. Behaviour marked *observed* was seen with GCC 11.4 and Clang 14 on x86-64 Linux (WSL2). C11 clauses were checked against the N1570 draft.

### F01

In E06's index loop, `for (size_t i = 0; i < length; ++i) sum += values[i];`, one iteration asks for roughly these simple steps:

1. Compute the address of `values[i]`: the start of the array plus `i` times the size of an `int`.
2. Load the element from memory.
3. Add it to the running sum.
4. Add one to `i`.
5. Compare `i` with `length`.
6. Jump back to the top if the comparison says to continue.

At `-O0` there are more steps, because `sum` and `i` are also loaded from and stored back to memory each time. Scott's point is that none of these steps is clever; the machine's power is in doing them quickly. It follows that the cost of a program is dominated by *how many* such steps it performs. Computer, Enhance!'s *waste* is steps that the problem never needed: re-checking types, looking up names, boxing numbers, or copying data that is already where it needs to be. The Python version of the same loop performs many of those for every useful addition. Removing waste means removing steps, not making steps faster.

"One at a time" is Scott's deliberate simplification. A modern x86-64 core overlaps the steps of several instructions (pipelining), issues several independent instructions per clock, and executes out of order. *Dive Into Systems* §5.7 introduces pipelining, and Week 2's CE episode "Instructions Per Clock" measures the effect. Scott's model stays useful as a way to count work; it is not a timing model.

### F02

| Coursebook example | Category | Why |
| --- | --- | --- |
| `mystrcpy` that assigns `dest = src` in the loop and never copies | Defined, wrong result | Only local pointer variables change; no invalid access occurs. The destination is simply never written |
| Writing through `p` after `free(p)`, then `free(p)` again | Undefined | Using an object after its lifetime ends (C11 §6.2.4 ¶2) and freeing space already deallocated (§7.22.3.3 ¶2) |
| Returning `&result` for an automatic `result` | Undefined once used | The pointer becomes indeterminate when the function returns (§6.2.4 ¶2); dereferencing it is undefined |
| `malloc(sizeof(user))` where `user` is a pointer | Undefined once the struct is written | The allocation is too small, and writing the struct overruns it |
| Loop starting at `i = N` writing `array[i]` | Undefined | `array[N]` is one past the end; forming that address is allowed, accessing it is not (§6.5.6 ¶8) |
| `strlen(s)` bytes for a copy of `s` | Undefined when the NUL is written | One byte past the allocation |
| Using an uninitialized automatic variable | Indeterminate value; undefined in some cases | Its value is indeterminate (§6.7.9 ¶10), and reading it can be undefined (§6.3.2.1 ¶2) |
| Assuming `malloc` returns zeroed memory | Indeterminate values | `malloc`'s bytes are indeterminate (§7.22.3.4 ¶2); `calloc` is the zeroing allocator |

Beej's §6.4 makes the same point about array bounds: C does not check them, and going out of bounds is undefined, not an error the language reports.

On setting freed pointers to NULL: it is a good habit because it turns a later *use-after-free* into a *null dereference*, which is easier to recognise. But dereferencing a null pointer is also undefined behaviour in C (§6.5.3.2 ¶4). On Linux the lowest page of the address space is normally unmapped, so the dereference usually crashes with a segmentation fault, which is the behaviour the coursebook means. That is an operating-system observation, not a language promise, and an optimizer may assume a pointer it has seen dereferenced is not null. The advice also does not protect other copies of the same pointer.

### F03

CS:APP §1.2 describes four stages: the **preprocessor** pastes in `#include`d files and expands macros; the **compiler** translates C into assembly; the **assembler** turns assembly into a relocatable object file; and the **linker** combines object files into an executable. `gcc -c` stops after the assembler and writes a `.o` file (§7.1, and Beej §17.4).

- `ex14_count.o` *defines* `count_equal`: its symbol table records a function symbol with an address in the text (code) section. `nm` shows it with `T`.
- `ex14_main.o` only *refers* to `count_equal`: it contains a call whose target address is left for the linker to fill in, recorded as a relocation. `nm` shows it with `U`, meaning undefined here.
- The **linker** matches the reference to the definition (symbol resolution, §7.2) and writes in the real address (relocation). In the final executable, `nm` shows one `T count_equal`.

If the body is deleted but the header is kept, both files still *compile*. `ex14_main.c` sees the declaration in `ex14_count.h`, and that is all a compiler needs to check a call: the name, the parameter types and the return type. The failure comes at **link** time: an "undefined reference to `count_equal`" error, because no object file supplies the definition. This is Handmade Chat 013's point about translation units: each `.c` file is compiled alone, knowing only what its headers declare. *Dive Into Systems* §2.9.6 shows the same split for a small library. Beej §17.3 explains how `static` hides a name from other translation units, and `extern` announces one.

### F04

Both describe different layers. *Dive Into Systems* and CS:APP describe what the **hardware's** add instruction produces: on a two's-complement machine, adding 1 to the largest `int` bit pattern gives the most negative one. The **C language** does not promise that result. C11 §6.5 ¶5 says that if the result of an expression is not mathematically defined or not representable in its type, the behaviour is undefined. The compiler is therefore allowed to assume that signed overflow never happens, and to generate code that is correct only under that assumption.

For example, `x + 1 > x` for an `int x` may be compiled to the constant 1, since it is true whenever no overflow occurs. Similarly, a loop `for (int i = 0; i <= n; ++i)` may be assumed to terminate, and its counter may be widened to a 64-bit register without wraparound checks. At `-O2` GCC and Clang commonly do both; at `-O0` they may not. A program that "tests" signed overflow by running it can therefore print different answers at different optimization levels, and any answer it prints proves nothing about C. That is why the course reasons about such code instead of executing it, and why Handmade Chat 011 insists on separating what the language says from what one build did. UBSan (CS 341 §2.4.3) reports signed overflow at run time when it does occur.

Unsigned arithmetic is different: C11 §6.2.5 ¶9 defines it to wrap modulo 2^N, so `UINT_MAX + 1u` is exactly 0 on every conforming implementation. The beginner section's `wrap` example prints exactly that.

### F05

`twiddle1` performs `*xp += *yp;` twice, and `twiddle2` performs `*xp += 2 * *yp;` once. If `xp` and `yp` point to different objects, the results agree. If they point to the *same* object, `twiddle1` doubles it twice (multiplying by 4), while `twiddle2` triples it. The case where two pointers may designate the same memory location is **memory aliasing**. A compiler that cannot prove the pointers differ must keep `twiddle1`'s extra loads and stores. Likewise, a call to a function with a side effect, such as CS:APP's `f()` that increments a global counter, cannot be hoisted out of a loop or merged, because calling it a different number of times changes the program's behaviour. Unless the compiler can see the body and prove there is no side effect (for example after inlining), it must keep every call. *Dive Into Systems* §12.1 shows the complementary case: moving a loop-invariant computation out of a loop by hand when the compiler could not prove it safe.

E15 faces the opposite problem. A summation whose result is known, or unused, may be removed or folded entirely at `-O2`, and the timing then measures nothing. Reading the array through `volatile` forces every element to be loaded on every pass (C11 §5.1.2.3 ¶6 treats volatile accesses as observable). The cost is that the `-O2` build is no longer free to vectorize or combine those loads, so an `-O0` versus `-O2` comparison in E15 measures *this deliberately constrained loop*, not what `-O2` would do to an ordinary summation. The exercise asks you to state that limitation, and Week 30 returns to building benchmarks the compiler cannot defeat without such a blunt tool.

### F06

Amdahl's law (CS:APP equation 1.1): if a fraction α of the time is sped up by a factor k, the overall speedup is S = 1 / ((1 − α) + α / k). With α = 0.9 and k = 4: S = 1 / (0.1 + 0.225) = 1 / 0.325 ≈ 3.08. However large k becomes, the remaining 10% still takes its full time, so S can never exceed 1 / 0.1 = 10. CS:APP's own example (α = 0.6, k = 3, giving 1.67×) makes the same point. Hennessy and Patterson §1.9 present the law as a principle of design: improve the common case, and know how common it is.

E15 measures one loop in isolation, under a fixed size and a `volatile` constraint. It tells you how long that loop took on that machine and how much the trials varied. It cannot tell you α for a real program, because α depends on everything else the program does: input, parsing, allocation and output. To know whether speeding up a summation matters, you must measure the whole program and find the fraction first. Week 5's timing protocol and Week 14's profiler do exactly that.
