# Reading-question answers — numbers in a box

Worked answers to the further-reading questions. Book citations match the further-reading page. Values marked *measured* were observed with GCC 11.4 and Clang 14, glibc 2.35, x86-64 Linux (WSL2), `-ffp-contract=off`, identical at `-O0` and `-O2`. C11 clauses were checked against the N1570 draft.

### F01

Past the binary point, the positions are worth 1/2, 1/4, 1/8, 1/16, and so on. To find the bits of a fraction, double it: the whole-number part of the result is the next bit, and the fractional part carries on. For 0.1: 0.2 → 0, 0.4 → 0, 0.8 → 0, 1.6 → 1 (keep 0.6), 1.2 → 1 (keep 0.2), 0.4 → 0, 0.8 → 0, 1.6 → 1, 1.2 → 1, 0.4 → 0. The first ten bits are `0001100110`, and from the second bit on the block `0011` repeats forever: 0.1 = 0.0(0011)(0011)… in binary.

It never ends because the remainder returns to 0.2 after four doublings and the cycle restarts. The deeper reason is the denominator: 1/10 = 1/(2 · 5), and no finite sum of powers of 1/2 can have a factor of 5 in its denominator. A decimal fraction has a finite binary expansion exactly when, in lowest terms, its denominator is a power of two: 0.5, 0.25, 0.75, 0.125, 0.375 and so on. That is why `0.5` and `-2.0` have short patterns in W01 while `0.1` ends in the rounded `…999A`. Scott's book stops at whole numbers; *Dive Into Systems* §4.8 makes the same extension to fractions.

### F02

For binary64 (11 exponent bits, bias 1023, 52 fraction bits), following CS:APP's three cases:

| Case | Exponent field `e` | Actual exponent E | Significand |
| --- | --- | --- | --- |
| Normalized | 1 to 2046 | `e − 1023` (−1022 to 1023) | `1.f` (implicit leading 1) |
| Denormalized | 0 | `1 − 1023 = −1022` | `0.f` (no implicit 1) |
| Special | 2047 | none | fraction 0: ±infinity; fraction nonzero: NaN |

`1.0` is normalized with `e = 1023`, E = 0. `0.1` is normalized with `e = 1019`, E = −4, fraction `0x999999999999A`. `DBL_MIN` is the smallest normalized value, `e = 1`, fraction 0, value 2^−1022. `DBL_TRUE_MIN` is the smallest denormalized value, `e = 0`, fraction 1, value 2^−1074. `DBL_MAX` is `e = 2046` with every fraction bit set, value (2 − 2^−52) · 2^1023. Infinity is `e = 2047`, fraction 0. These are exactly the fields E01's driver prints.

CS:APP's aside explains why denormals use `1 − Bias` rather than `−Bias`: it makes the step from the largest denormal to the smallest normal the same size as the steps on either side, a smooth join. What that buys is **gradual underflow**. One property that follows (Goldberg's article, which the lesson assigns, states it) is that for finite `x` and `y`, `x − y == 0` exactly when `x == y`. Take `x = 1.5 · 2^−1022` and `y = 2^−1022`. Their difference is `2^−1023`, a denormal. On hardware that flushed such results to zero, `x − y` would be 0 even though `x != y`, and a guard such as `if (x != y) z = 1 / (x − y);` would divide by zero.

### F03

If every halfway value were rounded up, each tie would add a small positive error, and over many roundings the errors would not cancel. The average of a set of rounded values would drift above the average of the original values. CS:APP makes this argument about computing averages. Rounding ties to the even neighbour sends about half of them up and half down, so the tie errors cancel on average. It is the default rounding mode in IEC 60559 and the one every result in this course assumes.

Losing associativity, using W02's absorption: `a = 1e16`, `b = 1`, `c = 1`. Predicted: `(a + b) + c` absorbs each 1 separately (each sum is a tie that rounds to the even neighbour `1e16`), giving `10000000000000000`. `a + (b + c)` first computes the exact 2, and `1e16 + 2` is representable because the spacing there is 2, giving `10000000000000002`. Measured: exactly those two values. E02 shows the same effect at a smaller scale: `(0.1 + 0.2) + 0.3` and `0.1 + (0.2 + 0.3)` differ by one ulp because each association rounds at a different point. Neither order is "wrong"; they are two different sequences of rounded operations. Next week, HH146's accumulation example applies this to long sums.

### F04

`t*t - (t*t)` is exactly 0: both operands are the same rounded product, so their difference is zero. `fma(t, t, -(t*t))` computes the exact mathematical product `t · t` (where `t` is the double nearest 0.1), subtracts the rounded product, and rounds only that final result. What remains is the rounding error that the ordinary multiplication committed. *Measured:* `-0x1.eb851eb851eb8p-61`, about −8.3 × 10^−19. The value is not an accident of this library: C11 §7.12.13.1 specifies `fma` as `(x × y) + z` "rounded as one ternary operation", and Annex F §F.10.10.1 as "correctly rounded once", so any conforming binary64 implementation gives the same bits. H&P use exactly this effect, computing a remainder with one rounding, to correct a division result.

C11 also lets a compiler *contract* an ordinary expression such as `a*b + c` into a fused operation (§6.5 ¶8, controlled by the `FP_CONTRACT` pragma of §7.12.2). Whether that happens depends on the compiler, the flags and the target: Clang's default permits it, GCC's ISO mode does not, and it only matters where the hardware has an FMA instruction. The same source could then print different digits under different builds. This course builds everything with `-ffp-contract=off` so that tests, tolerances and reports mean the same thing under GCC and Clang. That is a reproducibility decision. A fused operation is usually *more* accurate, and weeks 33–34 use `fma` deliberately, as an explicit call where the rounding behaviour is part of the design.

### F05

| Statement | Beej's page | C11 main text | Annex F needed? |
| --- | --- | --- | --- |
| (a) `fmod` has the sign of `x` | Yes ("the same sign as x") | Yes, §7.12.10.1 ¶3 | No |
| (b) `fmod` has no rounding error | No | Specifies the value `x − ny` but does not state exactness | Yes: §F.10.7.1 ¶2, "the returned value is exact" (with subnormal support) |
| (c) `hypot` avoids overflow of `x*x` | No (describes √(x² + y²) only) | Yes: §7.12.7.3 ¶2, "without undue overflow or underflow" | No |
| (d) `nextafter(x, x)` returns `y` | Yes | Yes: §7.12.11.3 ¶2 | No |

Beej's formula for `fmod` describes the mathematics, not a way to compute it. Evaluated literally in doubles for `x = 2^60`, `y = 360`, `x / y` rounds, `trunc` of it is then multiplied by 360 and rounds again, and the subtraction yields **128**. The true remainder, which `fmod` returns, is **136** (*measured*: `fmod=136 literal=128`). The week-3 answer key's proof of E03.Q explains why 136 is exact. For (c), *measured*: `sqrt(1e300*1e300)` is `inf` because the square overflows, while `hypot(1e300, 1e300)` is about `1.41421e+300`. "Undue" matters here: if the true result exceeds `DBL_MAX`, `hypot` still overflows and a range error may occur. For (d), returning `y` rather than `x` matters for signed zeros: `nextafter(0.0, -0.0)` returns `-0.0`.

The general lesson is to use friendly reference pages to learn what a function is for, and to consult the standard (and, for floating-point exactness, Annex F) before relying on a precise guarantee.

### F06

C11 itself guarantees very little about sizes, and nothing about formats or alignments of these types:

| Coursebook statement | Category |
| --- | --- |
| `char` is exactly one byte | C11: `sizeof(char)` is 1 by definition (§6.5.3.4 ¶4); a byte is `CHAR_BIT` bits, at least 8 (§5.2.4.2.1) |
| `int` is at least two bytes; `long long` at least eight | C11 guarantees ranges, not bytes: `int` holds at least −32767..32767 (16 bits), `long long` at least 64 bits (§5.2.4.2.1). "Two bytes" and "eight bytes" follow only when `CHAR_BIT` is 8, as the coursebook explicitly assumes |
| `int` is 4 bytes "on most machines" | Common-platform fact (x86-64 Linux: 4) |
| types are aligned to 2-, 4- or 8-byte boundaries | Common-platform fact; C11 leaves alignment to the implementation (§6.2.8). The 32-bit x86 System V ABI, for example, aligns `double` struct members to 4 bytes |
| `float` is IEEE-754 single, `double` IEEE-754 double | Annex F only: §F.2 ¶1 applies when `__STDC_IEC_559__` is defined. The main text requires only minimum range and precision (§5.2.4.2.2, e.g. `DBL_DIG` ≥ 10) |

The coursebook's descriptions are accurate for the machines its readers use, and it states the 8-bit-byte assumption. They are platform facts, and a portable program should not silently depend on them. This week's `GEO_IEC559` gate (`support/platform.h`) turns the second group into a checked condition. It requires `__STDC_IEC_559__`, a 53-bit significand, the binary64 exponent range and 8-bit bytes, and asserts that `double` and `uint64_t` have the same size. Code that relies on the binary64 layout runs only when the gate is true and reports "skipped" otherwise, so the claim becomes something the program checks.
