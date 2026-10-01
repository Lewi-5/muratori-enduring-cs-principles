---
prev:
  text: Week 3 lesson
  link: /weeks/week-03
next: false
---

# Week 3 further reading · Numbers in a box

[Week 3 beginner section](/beginners/week-03) · [Week 3 lesson](/weeks/week-03) · [Reading map](/reference/reading-map)

## Where to go after the videos

You have finished the week. Your library passes its tests, and you can explain why `0.1 + 0.2` prints a 4 at the end. Something probably still feels unexplained, though. Perhaps it is why the designers put the exponent before the fraction, or why subnormal numbers exist at all, or what a processor actually does when it adds two doubles. The Computer, Enhance! episode and the Handmade Hero segments showed you the problem and one way through it. They were never meant to be the whole story.

This page is a guide to where the rest of the story lives. It covers seven texts, arranged like the rungs of a ladder. The bottom rungs assume almost nothing; the top ones assume you have read the lower ones. You do not need to climb every ladder every week. Pick the rung that matches the question you have now, read that section with the question in mind, and come back.

The reading here is optional and outside the lesson's time budget. The six reading questions at the end of the page turn the most useful sections into short, answerable tasks, and each has a worked answer.

### The seven texts and what each is for

**J. Clark Scott, *But How Do It Know?*** This is the gentlest book on the list. It builds a working computer from a single switch upward, with no C at all and no assumption that you know what a bit is. That sounds too basic for an experienced programmer. It is worth an evening anyway, because it shows how simple each part of a computer is, and it gives you a picture to hang every later idea on. This week its chapter “Numbers” is the relevant one: place value in base two, built from nothing. Scott stops at whole numbers; the rest of the ladder picks up fractions. The book has no printed page numbers, so this course cites its chapters by title and PDF page.

**Beej's Guide to C Programming** and **Beej's Guide to the C Library Reference.** Brian Hall's guides are friendly, accurate and free. The first explains the C language; §14.4 on `double` and `long double` is this week's section. The second has a readable page for every standard library function this week uses: `fmod`, `nextafter`, `hypot`, `atan2`, `asin`, `sqrt`, and the limits in `<float.h>`. Use the library pages to learn what a function is *for*. When you need a precise guarantee, such as whether `fmod` is exact, go to the C standard. Reading question F05 shows why.

***Dive Into Systems*** by Matthews, Newhall and Webb. This free online book is the bridge between knowing C and knowing the machine. Its chapter 4 covers binary representation, and §4.8 introduces real numbers in binary, first as fixed point and then in the IEEE format, and ends with the consequences of rounding. If CS:APP's notation feels dense, read *Dive Into Systems* first. It is licensed for reading and linking, not for adapting, so this course links to it and never copies from it.

**The CS 341 Coursebook** from the University of Illinois. This is a systems-programming course's own textbook, practical and direct. It matters more in the weeks on processes, allocators and threads. This week its §3.3.2 “C data types” (p. 48, PDF p. 62) is worth reading critically: it describes `float` and `double` as IEEE-754 formats and gives sizes and alignments. That is true on the machines you use, but it is not what C itself guarantees. Reading question F06 asks you to sort its statements into what C promises, what Annex F promises and what your platform happens to do.

**Bryant and O'Hallaron, *Computer Systems: A Programmer's Perspective* (CS:APP), 3rd edition.** This is the core text for much of the course. Section 2.4 (p. 144, PDF p. 137) is the most complete treatment of floating point you are likely to need as a programmer. It builds from fractional binary numbers (§2.4.1) to the IEEE encoding (§2.4.2), works through example numbers for a tiny format (§2.4.3), then covers rounding (§2.4.4), the algebraic properties of the operations (§2.4.5) and what C does with them (§2.4.6). The page numbers cited here are those of the 3rd global edition PDF; the section numbers match the North American printing. Of all the readings, §2.4.3 does the most for your intuition. CS:APP plots every value of a tiny 6-bit format on a number line and tabulates examples of an 8-bit one, so you can see the uneven marks of the ruler with your own eyes.

**Hennessy and Patterson, *Computer Architecture: A Quantitative Approach*, 6th edition.** This is the top rung, written for people who design processors. Appendix J, “Computer Arithmetic”, shows floating point from the hardware's side. §J.3 (p. J-13, PDF p. 1208) covers the formats and special values, §J.5 shows how an adder aligns and rounds, and §J.7 (p. J-32, PDF p. 1227) covers fused multiply-add. It explains why the course passes `-ffp-contract=off`, and reading question F04 is built on it. Read H&P when you want to know *why* the format is shaped the way it is, not just how to use it.

**Going up the ladder.** Suppose, for example, you want to understand subnormal numbers. You could read Scott's “Numbers” to be sure of place value; then *Dive Into Systems* §4.8 for a diagram of the format; then CS:APP §2.4.2 and §2.4.3, where the 8-bit example makes gradual underflow visible; and finally H&P §J.3 and its discussion of denormals, where you learn what they cost in hardware. Each rung answers the question the rung below it raised.

### Where the texts stop

Two of this week's topics are not covered by any of the seven texts, and it is better to say so than to point at a section that only nearly fits.

- **Coordinate bases** (HH090 and HH091) are linear algebra, and none of these systems books teaches them. The lesson's worked 3-4-5 basis and the assigned video segments are the sources.
- **Exact geometric predicates** (HH048) belong to computational geometry. The systems texts explain why integer and floating-point arithmetic can or cannot be exact, and that is the half of the argument E06 needs. The geometry itself comes from the lesson.

## Cross-reference: from each video to the texts

<!-- crossref -->

## Reading questions

Answer these in your notebook after the matching reading. Each has a worked answer on the solutions page.

<!-- reading-questions -->
