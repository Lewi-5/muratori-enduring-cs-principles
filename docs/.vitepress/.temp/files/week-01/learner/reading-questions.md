# Reading questions — the C field notebook

Questions to carry into the further readings. Each names the sections it draws on; the further-reading page gives page numbers and links. Answer in your notebook in a short paragraph; the worked answers are on the solutions page. They are ungraded and outside the core time budget.

### F01

**Simple steps, very fast** (*But How Do It Know?*, “Speed”; CE “Waste”). Scott argues that a computer does only a few very simple things, one at a time, and seems clever only because it does them quickly. Take the index loop of E06 and list the simple steps one iteration asks the machine to do. Then use Scott's framing to explain what Computer, Enhance! means by *waste*. Finally, name one way in which "one at a time" is a simplification for the processor you are using, which Week 2 will measure.

### F02

**A catalogue of C bugs, sorted** (CS 341 Coursebook §3.8 “Common Bugs”; Beej's Guide to C §6.4 “Out of Bounds!”). The coursebook lists common C mistakes: a string copy that forgets to copy, a write through a freed pointer followed by a second `free`, returning the address of an automatic variable, allocating `sizeof` a pointer instead of a struct, writing `array[N]`, forgetting the `+ 1` for the terminator, and assuming that memory starts at zero. Sort them into *undefined behaviour* and *defined behaviour that gives the wrong result*. Then comment on the coursebook's advice to set freed pointers to NULL "so the pointer cannot be used incorrectly without the program crashing": what does C actually promise about dereferencing a null pointer?

### F03

**From two files to one program** (CS:APP §1.2, §7.1 and §7.2; Beej's Guide to C §17.3–§17.4; *Dive Into Systems* §2.9.6; CS 341 Coursebook §17.3). Trace E14 through the stages CS:APP names: preprocessing, compilation, assembly and linking. For each of `ex14_main.c` and `ex14_count.c`, say what the object file contains for the name `count_equal`, and what `nm` shows for it. Then predict what goes wrong, and at which stage, if you delete the body of `count_equal` but keep the header. Why does the compiler accept `ex14_main.c` without ever seeing that body?

### F04

**The hardware wraps; C does not promise to** (*Dive Into Systems* §4.5; CS:APP §2.3.2; Handmade Chat 011). *Dive Into Systems* explains signed overflow with an odometer that rolls from the largest value round to the most negative, and CS:APP describes the same bit-level result for two's-complement addition. The C standard, however, makes signed overflow undefined. Explain how both can be true. Give one transformation an optimizing compiler may make because of the C rule, such as simplifying `x + 1 > x`, and explain why this course never runs a signed overflow to "see what happens". Contrast unsigned arithmetic.

### F05

**What the compiler may not remove** (CS:APP §5.1; *Dive Into Systems* §12.1). CS:APP's `twiddle1` and `twiddle2` look equivalent, yet a compiler may not turn one into the other. Explain *memory aliasing* with that example, and explain why a call to a function with a side effect cannot simply be moved out of a loop. Then connect this to E15: why does the timing loop read through a `volatile` array, and what does that choice mean for comparing an `-O0` build with an `-O2` build?

### F06

**How much can a faster loop help?** (CS:APP §1.9.1 “Amdahl's Law”; Hennessy and Patterson §1.9). Using Amdahl's law, compute the overall speedup when a part taking 90% of a program's time becomes four times faster, and the most any speedup of that part could ever achieve. Then say what E15's measurements can and cannot tell you about the fraction of a *real* program's time a summation loop would take.
