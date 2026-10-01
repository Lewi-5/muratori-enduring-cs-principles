# Reading questions — numbers in a box

Questions to carry into the further readings. Each names the sections it draws on; the further-reading page gives page numbers and links. Answer in your notebook in a short paragraph; the worked answers are on the solutions page. They are ungraded and outside the core time budget.

### F01

**Place value, past the point** (*But How Do It Know?*, “Numbers”; *Dive Into Systems* §4.8). Scott builds binary whole numbers from place values: each position is worth twice the one to its right. Extend the same idea to the right of the point, where positions are worth 1/2, 1/4, 1/8 and so on. Write the first ten bits of 0.1 after the binary point by repeated doubling, name the repeating pattern, and explain why it never ends. Then say which decimal fractions do have a finite binary expansion.

### F02

**Three kinds of encoding** (CS:APP §2.4.2 and §2.4.3). CS:APP sorts the bit patterns of a floating-point format into normalized values, denormalized values and special values. For binary64, give the exponent field range of each case, how the actual exponent E is computed from it, and whether the significand has an implicit leading 1. Place `1.0`, `0.1`, `DBL_MIN`, `DBL_TRUE_MIN`, `DBL_MAX` and infinity in the scheme. Finally, explain what the denormalized values buy: give a property of subtraction that holds with them and fails without them.

### F03

**Rounding to even, and losing associativity** (CS:APP §2.4.4 and §2.4.5). CS:APP explains round-to-even with money: a value exactly halfway between two whole dollars goes to the even one. Explain why a rounding rule that always rounded halves up would be a poor default for a long computation. Then use the absorption you saw in W02 to construct three doubles `a`, `b`, `c` for which `(a + b) + c` and `a + (b + c)` differ, predict both results, and check them. Connect this to the two association orders in E02.

### F04

**Rounding once** (Hennessy & Patterson, Appendix J §J.7, “Fused Multiply-Add”). H&P describe an instruction that computes `a*b + c` exactly and rounds only at the end. For `t = 0.1`, predict whether `t*t - (t*t)` and `fma(t, t, -(t*t))` give the same result, check both, and explain the difference. Then explain why this course builds every package with `-ffp-contract=off`, and why that is a decision about reproducibility rather than a claim that fused operations are worse.

### F05

**What a reference page promises** (Beej's C Library Reference, `fmod`, `hypot` and `nextafter`; C11 §7.12 and Annex F). Reference pages summarize; the standard specifies. For each statement, say whether Beej's page supports it, whether C11's main text does, and whether it needs Annex F: (a) `fmod(x, y)` has the sign of `x`; (b) `fmod(x, y)` is computed without rounding error; (c) `hypot` avoids overflow when `x*x` would overflow; (d) `nextafter(x, y)` returns `y` when `x == y`. Beej describes `fmod` as `x - trunc(x / y) * y`: evaluate that expression literally in C for `x = 0x1p60`, `y = 360` and compare it with `fmod`.

### F06

**Sizes and formats in a systems textbook** (CS 341 Coursebook §3.3.2, “C data types”). The coursebook describes `float` and `double` as IEEE-754 single and double precision, and gives sizes and alignments for the integer types. Sort its statements about `char`, `int`, `long long`, `float` and `double` into three groups: guaranteed by C11 itself, guaranteed only when Annex F applies, and true of common platforms such as x86-64 Linux. Say how this week's `GEO_IEC559` gate turns the second group into something a program can check.
