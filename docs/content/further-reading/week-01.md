---
prev:
  text: Week 1 lesson
  link: /weeks/week-01
next: false
---

# Week 1 further reading · C as an inspectable starting point

[Week 1 beginner section](/beginners/week-01) · [Week 1 lesson](/weeks/week-01) · [Reading map](/reference/reading-map)

## Where to go after the videos

You have finished the first week. You have a notebook of fifteen small programs, and you can say which of your claims come from the C standard, which from your compiler and which from one run. The four assigned videos set up the course's argument: *Welcome* and *Waste* explain why a programmer should care what the machine does, and the two Handmade Chat segments explain undefined behaviour and how separate files become one program. Each was short, and each opened more questions than it closed. Why does the hardware wrap on overflow when C refuses to promise it? What exactly is in an object file? How much can a faster loop ever help?

This page is where those questions are answered at more length. It is the first further-reading page of the course, so it also introduces the idea behind all of them. The course pairs its videos with seven written texts, arranged like the rungs of a ladder, from a book that assumes nothing to one written for processor designers. Every week's further-reading page follows the same pattern: a guide to what each text offers that week, then a table that starts from each video and lists the sections that explain the same mechanism, from the gentlest to the deepest, then a few reading questions with worked answers.

None of this reading is required, and none of it is counted in the lesson's time budget. The point is to have somewhere to go when a question will not leave you alone. Pick the rung that matches the question you have now, read that section with the question in mind, and come back.

### How to use a ladder

A reading ladder solves a common problem. A textbook section that answers your question often assumes three chapters you have not read, while a friendly introduction explains the idea but stops before your question. The ladder puts the texts in order, so that each rung prepares you for the next.

1. **Gentle.** J. Clark Scott's *But How Do It Know?* and Beej's Guide to C. They assume little and explain everything.
2. **Bridge.** *Dive Into Systems* and the CS 341 Coursebook. They connect the C you write to what the machine and the operating system do with it.
3. **Core.** Bryant and O'Hallaron's *Computer Systems: A Programmer's Perspective* (CS:APP). It is the standard account of how systems look from a programmer's side, and much of this course leans on it.
4. **Deep.** Hennessy and Patterson's *Computer Architecture: A Quantitative Approach*. It is written for people who design processors, and explains why the machine is built the way it is.
5. **Reference.** Beej's Guide to the C Library Reference, one readable page per standard function.

Start one rung below where you think you are. If a section feels easy, skim it and climb; if it feels impenetrable, drop a rung. Page numbers on this site give the printed page first and the PDF page second, because the two rarely agree.

### The seven texts, this week

**J. Clark Scott, *But How Do It Know?*** This short book builds a working computer from a single switch, one idea per chapter, with no C and no assumed background. Its opening chapters are worth reading in Week 1 even if you have programmed for years. “Just the Facts Ma'am” (PDF p. 5) sets out the promise that every part of a computer is simple. “Speed” (PDF p. 7) makes the claim that underlies Computer, Enhance!'s *Waste*: the machine can do only a few very simple things, one after another, and its power is entirely in how fast it does them. Keep that picture in mind while you count the steps in E06's loop (reading question F01). Later, keep in mind that Scott's "one at a time" is a deliberate simplification, which Week 2 starts to take apart. The book has no printed page numbers, so this course cites it by chapter title and PDF page.

**Beej's Guide to C Programming** and **Beej's Guide to the C Library Reference.** Brian Hall's free guides are the gentlest way to refresh any part of C that this week's notebook touches. The chapters line up closely with the exercises: §5 on pointers and §6 on arrays (especially §6.4, “Out of Bounds!”, and §6.6 on arrays and pointers) for E02 and E06; §9 on file input and output for E12; §12 on manual memory allocation for E11; §17 on multifile projects for E14; §20.5 on padding bytes for E08; and §24 on bitwise operations for E10. The library reference has a page for every function the notebook calls, such as `fopen`, `malloc`, `free`, `strlen` and `strtoull`. It is ideal for learning what a function is for. For a precise guarantee, such as whether `malloc` may return NULL for a size of zero, check the C standard as well.

***Dive Into Systems*** by Matthews, Newhall and Webb. This free online book is the bridge between knowing C and knowing the machine underneath it. This week its most useful sections are §4.5 on integer overflow, which explains with an odometer why adding one to the largest value wraps round; §2.9.6 on writing your own C libraries, which is E14 in miniature; §2.8 on input and output; and §12.1 on first steps in code optimization, which pairs with *Waste*. One caution: §4.5 describes what the *hardware* does on signed overflow. The C language does not promise that behaviour, and reading question F04 asks you to reconcile the two. The book is licensed for reading and linking, not adapting, so the course links to it and never copies from it.

**The CS 341 Coursebook** from the University of Illinois. This is the textbook of a systems-programming course, blunt and practical. It will be one of the most frequently cited texts in this course, because it covers exactly the places where C programs meet the operating system: processes, allocators, threads, virtual memory, files and signals. This week, four of its sections matter:

- §3.8 “Common Bugs” (p. 67, PDF p. 81): a catalogue of real C mistakes, most of them undefined behaviour. Reading question F02 asks you to sort them.
- §3.5.1 “Handling Errors” (p. 52, PDF p. 66): on checking what library calls return.
- §2.4.3 “Undefined Behavior Sanitizer” (p. 21, PDF p. 35): the tool the course's sanitize builds use.
- §17.3 “Compiling and Linking” (p. 341, PDF p. 355): on E14's pipeline.

Its §3.3.2 on C data types states sizes that are true on common platforms; Week 3 asks you to read it critically.

**Bryant and O'Hallaron, *Computer Systems: A Programmer's Perspective*, 3rd edition.** CS:APP is the core text of the course. Its first chapter, “A Tour of Computer Systems”, is the best single overview of what this course is about. §1.2 follows a program from source text through preprocessor, compiler, assembler and linker. §1.3 gives three reasons it pays to understand that pipeline. §1.4 describes the hardware the result runs on. §1.9.1 introduces Amdahl's law. Chapter 7 returns to linking in depth: §7.1 on compiler drivers and §7.2 on static linking explain the `U` and `T` you see in E14's `nm` output. §2.3 covers integer arithmetic at the bit level, and §5.1 explains what optimizing compilers can and cannot do, with its well-known `twiddle` example of memory aliasing (reading question F05). The page numbers cited here are those of the 3rd global edition PDF; the section numbers match the North American printing.

**Hennessy and Patterson, *Computer Architecture: A Quantitative Approach*, 6th edition.** This is the top rung, and in Week 1 you need only a taste of it. §1.1 (p. 2, PDF p. 34) tells the story of performance growth from the architect's side. §1.9 (p. 48, PDF p. 80), “Quantitative Principles of Computer Design”, presents locality, parallelism and Amdahl's law as design rules. It is the natural companion to reading question F06. The book says almost nothing about C, translation units or undefined behaviour, and the cross-reference below says so rather than stretching a citation.

### Where the texts stop

- **Undefined behaviour as a language rule** is explained well by the C-facing texts (Beej, CS 341) and described at the bit level by *Dive Into Systems* and CS:APP. None of them states the rule with the standard's precision. For that, the lesson's assigned clauses of the C11 draft are the source, and the reading answers cite them.
- **Measurement method** (trials, medians, what to report) is only lightly covered by these texts in Week 1. The lesson's E15 contract and Week 5's timing protocol carry it, and Hennessy and Patterson §1.8, cited in Week 5, gives the architect's view of reporting performance.

## Cross-reference: from each video to the texts

<!-- crossref -->

## Reading questions

Answer these in your notebook after the matching reading. Each has a worked answer on the solutions page.

<!-- reading-questions -->
