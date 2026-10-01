---
prev:
  text: Week 3 lesson
  link: /weeks/week-03
next:
  text: Week 3 further reading
  link: /further-reading/week-03
---

# Week 3 beginner section · Numbers in a box

[All beginner sections](/beginners/) · [Week 3 lesson](/weeks/week-03) · [Week 3 further reading](/further-reading/week-03)

## Purpose and prerequisites

This section is a way into Week 3 for everyone, including readers who have written C for years without ever looking inside a `double`. It goes slower than the lesson, starts further back, and shows real output for every claim. It does not replace the lesson or change any of its exercises.

**By the end you should be able to:** read the sign, exponent and fraction of a `double` from its 16 hex digits; say how far apart neighbouring doubles are at a given size; choose between absolute, relative and step-count error for a comparison; explain why longitude needs a stated wrapping rule; explain why two correct distance formulas can disagree; and say when a "which side?" test is exact.

**Time:** about 2–4 hours, in short sessions: roughly 90 minutes of reading and running the examples, and 60–90 minutes for the four warm-ups. This is in addition to the lesson's own budget, and like every estimate in the course it has not yet been checked by a learner pilot.

**You need from earlier weeks:** Week 1's habit of returning a status and leaving outputs unchanged on failure, and Week 2's legal way to look at an object's bytes with `memcpy`. If either feels shaky, reread [Week 2's first exercise](/weeks/week-02) before starting.

Every program on this page is a file in `docs/examples/week-03/`. Each was compiled with both GCC 11.4 and Clang 14 using the course flags (`-std=c11 -Wall -Wextra -Wpedantic -Werror -ffp-contract=off`) on x86-64 Linux under WSL2, and the printed output below is what they produced. A site check recompiles them and fails if the output changes.

## Vocabulary

| Term | Plain meaning | Where you meet it |
| --- | --- | --- |
| **binary fraction** | A number written in base two with digits after the point, each worth half the one before: 1/2, 1/4, 1/8… | Why 0.1 cannot be stored exactly |
| **binary64** | The 64-bit floating-point format that `double` uses on the course's reference platform. C does not require it; it is an optional part of the standard (Annex F). | E01, the `GEO_IEC559` gate |
| **sign, exponent, fraction** | The three fields of a binary64 value: 1 bit, 11 bits and 52 bits | W01, E01 |
| **bias** | The constant 1023 added to the true exponent so the exponent field can be stored as an unsigned number | Reading the exponent field |
| **normal / subnormal** | A normal value has an implied leading 1 before its fraction; a subnormal (the tiniest values) does not | E01's classes |
| **rounding** | Replacing an exact result that cannot be stored with a nearby value that can | Every arithmetic operation |
| **round-to-nearest-even** | The default rule: pick the nearest storable value; on an exact tie, pick the one whose last bit is 0 | W02, F03 |
| **ulp** | "Unit in the last place": the gap between a double and its neighbour. Its size depends on the magnitude | W02, E02 |
| **absolute / relative error** | How far off a result is, in units; and that distance divided by the size of the true value | E02, E05 |
| **NaN, infinity, finite** | NaN is "not a number", the result of operations such as 0/0; infinity is an overflowed or unbounded value; a finite value is neither | Input validation in every exercise |
| **half-open interval** | An interval that includes one end and excludes the other, written `[-180, 180)` | W03, E03 |
| **great-circle distance** | The shortest distance between two points along the surface of a sphere | E05 |
| **orientation** | Whether three points turn left, turn right or lie on one line; the sign of a cross product | W04, E06 |
| **exact / correctly rounded** | An exact result has no error at all; a correctly rounded result is the storable value nearest the exact one | The comparison table below |

## Concepts

### A `double` is a ruler with uneven marks

You add 0.1 and 0.2 and print the result with enough digits to see everything.

<!-- snippet:point_three -->
```c
#include <stdio.h>

int main(void)
{
    double sum = 0.1 + 0.2;
    double target = 0.3;
    printf("0.1 + 0.2 = %.17g\n", sum);
    printf("0.3       = %.17g\n", target);
    printf("equal?      %s\n", sum == target ? "yes" : "no");
    return 0;
}
```

<!-- output:point_three -->
```text
0.1 + 0.2 = 0.30000000000000004
0.3       = 0.29999999999999999
equal?      no
```

Nothing is broken. The surprise comes from a picture most programmers carry without noticing: that a `double` holds "a real number". It does not. It holds one of a fixed, finite collection of values, and every number you write in source code, and every result of arithmetic, is replaced by one of those values.

Why would a computer be built this way? Because it has a fixed number of bits for each number: 64 for a `double`. Sixty-four bits can form about 1.8 × 10^19 different patterns. That is a lot, but the real numbers between 0 and 1 alone are infinitely many. Most real numbers simply have no pattern of their own, so each one must borrow the pattern of a nearby number that does.

Think of a ruler. You can only read a length off a ruler at its marks; a length between two marks gets reported as the nearer mark. A `double` is a ruler with marks at every storable value. Here the analogy needs a correction straight away: this ruler's marks are **not evenly spaced**. Near 1 they are extremely close together; near a billion they are much further apart. The section after next measures exactly how far.

So `0.1` in your source code becomes the mark nearest 0.1. So do `0.2` and `0.3`. The sum of the first two marks is not itself a mark, so it too is rounded to the nearest one, and that turns out to be the mark just above the one chosen for `0.3`. Two roundings led to one mark, one rounding to its neighbour, and `==` compares marks, not intentions.

**Read alongside:** *But How Do It Know?*, “Numbers” (PDF p. 46) for binary place value from scratch; *Dive Into Systems* [§4.8](https://diveintosystems.org/book/C4-Binary/floating_point.html) for fractions in binary.

### Where the 64 bits go

You want to know which mark `0.1` actually became. The way to find out is to look at its bits, using the same legal `memcpy` technique as Week 2.

A binary64 value is split into three fields:

```text
bit 63      bits 62..52           bits 51..0
[ sign ] [ exponent: 11 bits ] [ fraction: 52 bits ]
```

The value they encode (for ordinary, "normal" numbers) is

```text
(-1)^sign  ×  1.fraction (in binary)  ×  2^(exponent - 1023)
```

Each field solves one problem:

- The **sign** bit says positive or negative, so the other fields only ever describe a magnitude.
- The **exponent** says which power of two the number sits near: whether the ruler is being read between 1 and 2, between 1024 and 2048, or between 1/16 and 1/8. It is stored with 1023 added (the **bias**) so that the field is never negative; subtract 1023 to get the true power.
- The **fraction** says where between that power of two and the next one the number sits. Every normal number starts with a binary `1.` before its fraction, so that 1 is not stored at all. Leaving it implied buys one extra bit of precision.

Here is a program that pulls the three fields out of five values:

<!-- snippet:fields -->
```c
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

static void show(const char *name, double value)
{
    uint64_t bits;
    memcpy(&bits, &value, sizeof bits); /* copy the bytes; never cast the pointer */
    unsigned sign = (unsigned)(bits >> 63);
    unsigned exponent = (unsigned)((bits >> 52) & 0x7FF);
    uint64_t fraction = bits & ((UINT64_C(1) << 52) - 1);
    printf("%-5s bits=0x%016" PRIX64 " sign=%u exponent=%4u (2^%-5d) fraction=0x%013" PRIX64 "\n",
           name, bits, sign, exponent, (int)exponent - 1023, fraction);
}

int main(void)
{
    show("1.0", 1.0);
    show("0.5", 0.5);
    show("-2.0", -2.0);
    show("3.0", 3.0);
    show("0.1", 0.1);
    return 0;
}
```

<!-- output:fields -->
```text
1.0   bits=0x3FF0000000000000 sign=0 exponent=1023 (2^0    ) fraction=0x0000000000000
0.5   bits=0x3FE0000000000000 sign=0 exponent=1022 (2^-1   ) fraction=0x0000000000000
-2.0  bits=0xC000000000000000 sign=1 exponent=1024 (2^1    ) fraction=0x0000000000000
3.0   bits=0x4008000000000000 sign=0 exponent=1024 (2^1    ) fraction=0x8000000000000
0.1   bits=0x3FB999999999999A sign=0 exponent=1019 (2^-4   ) fraction=0x999999999999A
```

Read the lines one at a time.

- `1.0` is `1.0 × 2^0`: the implied 1, a fraction of zero, and a true exponent of 0, stored as 1023.
- `0.5` is `1.0 × 2^-1`. Only the exponent changes.
- `-2.0` is `1.0 × 2^1` with the sign bit set.
- `3.0` is `1.5 × 2^1`. In binary, 1.5 is `1.1`: the first fraction bit is worth one half. That single bit is the top bit of the 52-bit fraction, which prints as `0x8000000000000`.
- `0.1` is `1.6 × 2^-4`, since 1.6 / 16 = 0.1. In binary, 0.6 is `0.1001 1001 1001…`, repeating forever. In hex, four bits at a time, that is `0x999…`. The format keeps 52 bits and must round the rest. The discarded tail starts with a 1, so it rounds up, and the last hex digit becomes `A` instead of `9`.

That rounding is where the error of `0.1` enters, and it is the first thing Exercise E01 asks you to explain.

A few patterns are reserved and do not follow the formula. An exponent field of all zeros means zero (with either sign) or a **subnormal**, a tiny value with no implied leading 1 that fills the gap between the smallest normal number and zero. An exponent field of all ones means infinity (fraction zero) or NaN (fraction nonzero). E01 has you classify all five cases.

**Read alongside:** CS:APP §2.4.2 IEEE Floating-Point Representation (p. 148, PDF p. 141) and §2.4.3 Example Numbers (p. 151, PDF p. 144); Beej's Guide to C [§14.4](https://beej.us/guide/bgc/html/split/types-ii-way-more-types.html#more-float-double-and-long-double) for what `double` promises from the C side.

### How far apart are the marks?

You store the number of centimetres in a light-year in a `double`, add one, and the value does not change. Is that a bug?

The previous section explains why it happens. The fraction has 52 bits after the implied 1, so between any power of two and the next there are exactly 2^52 marks, evenly spaced. The next stretch, twice as long, has the same number of marks, so they are twice as far apart. The gap between neighbouring doubles therefore doubles every time the numbers double.

<!-- snippet:spacing -->
```c
#include <math.h>
#include <stdio.h>

int main(void)
{
    const double at[] = {1.0, 2.0, 1000.0, 1e16};
    for (int i = 0; i < 4; ++i) {
        double x = at[i];
        double step = nextafter(x, INFINITY) - x;
        printf("next double after %-6g is %.17g larger\n", x, step);
    }
    double big = 1e16;
    printf("1e16 + 1 == 1e16 ? %s\n", big + 1.0 == big ? "yes" : "no");
    return 0;
}
```

<!-- output:spacing -->
```text
next double after 1      is 2.2204460492503131e-16 larger
next double after 2      is 4.4408920985006262e-16 larger
next double after 1000   is 1.1368683772161603e-13 larger
next double after 1e+16  is 2 larger
1e16 + 1 == 1e16 ? yes
```

`nextafter(x, INFINITY)` returns the next mark above `x`. Near 1 the gap is 2^-52, about 2.2 × 10^-16; this is the constant `DBL_EPSILON`. Near 2 it is twice that. Near 1000 (which lies between 512 and 1024) it is 2^-43. Beyond 2^53, about 9 × 10^15, the gap is 2 or more, so odd integers can no longer be stored at all. That is why adding 1 to `1e16` does nothing: the exact sum lies halfway between two marks, and round-to-nearest-even picks the one you started with.

The gap at a value is called one **ulp** there, a *unit in the last place*. It is the natural unit for rounding error, because a correctly rounded result is never more than half an ulp from the exact answer. It is also a unit whose size depends on where you are, which is why "the answer is within 3 ulps" and "the answer is within 1e-9" are different kinds of promise. Warm-up W02 has you measure the gaps yourself, including a surprise at -1.

**Read alongside:** CS:APP §2.4.4 Rounding (p. 156, PDF p. 149) for round-to-even with a money example; Beej's reference for [`nextafter`](https://beej.us/guide/bgclr/html/split/math.html#man-nextafter).

### Three ways to say "how wrong"

Your distance function returns 1,000.001 km for a pair of points whose true distance is 1,000 km. Is that good? It depends on what you are asking, and there are three common questions:

| Measure | Question it answers | Example | Where it misleads |
| --- | --- | --- | --- |
| Absolute error | How many units off? | 1 metre off | 1 metre is terrible between two chairs and superb between two continents |
| Relative error | How far off, compared with the size of the answer? | 1 m in 1,000 km = 10^-6 | Undefined or meaningless when the true value is 0 or very near it |
| Ulp distance | How many storable values lie between the result and the reference? | 3 ulps | Says nothing about units; 3 ulps near 1e16 is 6, near 1 it is about 7 × 10^-16 |

No single number works everywhere, which is why the lesson's `approx_equal` in E02 combines an absolute floor near zero with a relative tolerance elsewhere, and why the course writes every tolerance in one header with a reason attached. A tolerance is a statement of how much error you can justify, not a number you raise until the tests pass.

There is one more distinction that looks like a detail and is not. Three different things can be true of a computed result:

| Kind of result | Meaning | Example |
| --- | --- | --- |
| Exact | The mathematical answer is itself a mark, and the operation hits it | `sqrt(4.0)` is exactly 2 |
| Correctly rounded | The answer is not a mark; the operation returns the nearest mark | `sqrt(2.0)`: the true value is irrational, the result is the nearest double |
| Approximated | The library aims to be close, with an error that you bound by analysis or measurement | `sin`, `cos`, `atan2` in glibc: close, but not guaranteed to be the nearest mark |

Under the optional Annex F of the C standard, `+ - * /` and `sqrt` are correctly rounded, and a few functions such as `fmod` are exact. The trigonometric functions carry no such guarantee, so the course never compares their results bit for bit.

**Read alongside:** Goldberg's article, assigned in the lesson, for ulps versus relative error; CS:APP §2.4.5 Floating-Point Operations (p. 158, PDF p. 151).

### Degrees, radians and the line where longitude jumps

You fly from longitude 179° east to 179° west. Subtracting the labels gives −358°. The plane actually travelled 2° east.

Longitude is an angle, and angles repeat every 360°. The labels 181°, −179° and 541° all name the same meridian. A program needs one agreed spelling for each meridian, or two equal places will compare as different. This course uses the **half-open interval** `[-180, 180)`: −180 is allowed, 180 is not, and 180 is rewritten as −180. Choosing which end to include is a policy, not a fact about the Earth. What matters is that it is stated and applied everywhere.

Wrapping means adding or subtracting multiples of 360 until the value lands in the interval. For a value near the interval, one step is enough, and that is warm-up W03. For an arbitrary finite value, such as 10^300, you cannot loop: subtracting 360 from 10^300 gives 10^300 back, the same absorption you saw with `1e16 + 1`. E03 uses `fmod`, which computes the remainder in one exact step.

The C trigonometric functions take **radians**, where a full turn is 2π instead of 360. Converting degrees to radians multiplies by an approximation of π/180, since π itself is not a mark on the ruler. So a clean angle such as 180° becomes a radian value that is not exactly π, and `sin` of it is not exactly zero. E03 has you predict how far from zero it lands, and then build `sin_deg`, which handles the multiples of 90° exactly before any conversion happens.

**Read alongside:** Beej's reference for [`fmod`](https://beej.us/guide/bgclr/html/split/math.html#man-fmod), then reading question F05, which compares it with what the C standard actually guarantees.

### From two angles to three numbers

You want to know whether two cities are close. Comparing their latitudes and longitudes directly is awkward: near the poles, a large difference in longitude can be a short walk, and across the antimeridian the numbers jump. It would be easier to have each position as an arrow from the centre of the Earth and compare the arrows.

That is what a **unit vector** is: an arrow of length 1, written as three numbers `(x, y, z)`. Each number is how far the arrow reaches along one of three fixed, perpendicular directions: toward latitude 0 longitude 0, toward latitude 0 longitude 90° east, and toward the North Pole. Latitude φ and longitude λ turn into those three numbers like this:

```text
x = cos φ · cos λ      y = cos φ · sin λ      z = sin φ
```

Two ideas in this deserve to be kept apart, because the lesson's E04 depends on the difference:

| | Latitude and longitude | x, y, z components |
| --- | --- | --- |
| What they are | Two angles | Three lengths along fixed directions |
| How they combine | Through sines and cosines: a curved, nonlinear conversion | By adding scaled direction arrows: linear |
| Changing to another set | Needs trigonometry again | Needs only dot products, if the new directions are perpendicular and of length 1 |

The fixed perpendicular directions are called a **basis**, and the three numbers are the arrow's **coordinates** in that basis. Latitude and longitude are not coordinates in a basis; they are a recipe for producing them. The lesson's HH090 and HH091 segments and E04's worked example show what a real change of basis looks like.

Two practical traps appear as soon as you compute with arrows. Finding an arrow's length means squaring components, and squaring a large number can overflow even when the length itself is representable; E04 scales first to avoid it. And the arrow `(0, 0, 0)` has no direction at all, so "make it length 1" must be refused rather than divided by zero. HH047 discusses exactly this case.

### Two correct formulas, two different answers

You compute the distance between two points 6 cm apart on the equator using the spherical law of cosines, a formula straight from a geometry textbook. It says the distance is zero.

<!-- snippet:tiny_angle -->
```c
#include <math.h>
#include <stdio.h>

int main(void)
{
    const double radius_km = 6371.0;
    double angle = 1e-8; /* radians: two points about 6 cm apart on the equator */
    double c = cos(angle);
    double via_cosine = acos(c) * radius_km * 1e5;          /* centimetres */
    double s = sin(angle / 2);
    double via_haversine = 2 * asin(s) * radius_km * 1e5;   /* centimetres */
    printf("cos(1e-8) == 1.0 ? %s\n", c == 1.0 ? "yes" : "no");
    printf("law of cosines: %.3f cm\n", via_cosine);
    printf("haversine:      %.3f cm\n", via_haversine);
    return 0;
}
```

<!-- output:tiny_angle -->
```text
cos(1e-8) == 1.0 ? yes
law of cosines: 0.000 cm
haversine:      6.371 cm
```

Both formulas are mathematically correct; they are algebraically the same function. The difference is what happens to a *tiny angle on the ruler*. The cosine of 10^-8 is about 1 − 5 × 10^-17. The marks just below 1 are 2^-53 apart, about 1.1 × 10^-16, so the exact cosine is closer to 1 than to the next mark down, and it rounds to exactly 1. Every trace of the angle has been lost before `acos` even runs, and `acos(1)` is 0.

The haversine formula never forms that "1 minus something tiny". It works with `sin(angle/2)`, which for a small angle is a small number, stored with full relative precision. The information survives.

This is what **conditioning** means. A computation is ill-conditioned where a tiny change in its input causes a large change in its output: `acos` near 1 is extremely steep, so the rounding of its input to the nearest mark is magnified enormously. A formula whose steps stay well-conditioned on your inputs is the one to trust there. E05 has you compute the same distances three ways and measure which one fails where. The lesson also asks you to keep this separate from two other error sources: treating the Earth as a sphere, and storing coordinates with six decimal places.

**Read alongside:** CS:APP §2.4.5 (p. 158, PDF p. 151) on why algebraically equal expressions can compute differently.

### Asking "which side?" exactly

You have a road from point A to point B and a house at C, and you need to know which side of the road the house is on. Collision code, map code and the segment intersection in E06 all ask this question constantly.

The answer is the sign of one number, the **cross product**:

```text
cross = (bx - ax) * (cy - ay) - (by - ay) * (cx - ax)
```

Positive means C is to the left of the direction A → B (a counter-clockwise turn), negative means right, and zero means the three points are on one line. It is two multiplications and a subtraction, but it is only useful if its sign is right, and near zero a rounding error can flip the sign.

Integers are exact until they overflow. Doubles hold integers exactly only up to 2^53. Above that, products round too:

<!-- snippet:big_product -->
```c
#include <stdio.h>

int main(void)
{
    long long a = 100000001, b = 99999999;
    double da = 100000001.0, db = 99999999.0;
    printf("integer product: %lld\n", a * b);
    printf("double product:  %.17g\n", da * db);
    return 0;
}
```

<!-- output:big_product -->
```text
integer product: 9999999999999999
double product:  10000000000000000
```

The true product, 10^16 − 1, is odd and above 2^53, so it is not a mark; it rounds to 10^16. In a cross product, that kind of rounding can turn a small nonzero result into zero, or into the wrong sign. The fix is not a tolerance. It is a **stated domain**: E06 limits coordinates to magnitudes up to 2^25 on integer-valued inputs, so every product and difference is an integer below 2^53 and exact. Warm-up W04 does the same with `long long` and a larger bound, and asks you to show the bound is enough.

**Read alongside:** *Dive Into Systems* [§4.5 Overflow](https://diveintosystems.org/book/C4-Binary/overflow.html); CS:APP §2.3.5 Two's-Complement Multiplication (p. 133, PDF p. 126).

## Walk-through: taking 0.1 apart by hand

The ideas above come together in one short calculation. Do it on paper first, then check each step with the programs.

**Step 1: write 0.1 in binary.** Double it repeatedly; each whole part is the next bit. 0.1 → 0.2 (0), 0.4 (0), 0.8 (0), 1.6 (1, keep 0.6), 1.2 (1, keep 0.2), and the cycle repeats: `0.000110011001100…`

**Step 2: normalize.** Slide the point until there is a single 1 before it: `1.100110011001… × 2^-4`. The true exponent is −4, so the stored exponent is −4 + 1023 = 1019. The sign is 0.

**Step 3: keep 52 fraction bits and round.** The fraction bits are `1001 1001 1001 …`, in hex `9 9 9 … 9` for thirteen hex digits, and the next bit after them is a 1 followed by more nonzero bits. That is more than halfway to the next mark, so it rounds up: the last hex digit becomes `A`.

**Step 4: assemble.** Sign 0, exponent 1019 = `0x3FB`, fraction `0x999999999999A`: the pattern `0x3FB999999999999A`. That is exactly what the `fields` program printed.

**Step 5: see the exact value you stored.** Every double is a finite binary fraction, so it has a finite decimal expansion too. Printing enough digits shows the mark itself:

<!-- snippet:exact_tenth -->
```c
#include <stdio.h>

int main(void)
{
    double tenth = 0.1;
    printf("%%a:    %a\n", tenth);
    printf("%%.55f: %.55f\n", tenth);
    printf("%%.17g: %.17g\n", tenth);
    printf("%%g:    %g\n", tenth);
    return 0;
}
```

<!-- output:exact_tenth -->
```text
%a:    0x1.999999999999ap-4
%.55f: 0.1000000000000000055511151231257827021181583404541015625
%.17g: 0.10000000000000001
%g:    0.1
```

The `%a` format prints the value in hexadecimal floating point, which is the fraction and exponent from Step 4 written directly. The 55-digit line is the exact stored value, slightly *above* 0.1 because Step 3 rounded up. `%.17g` gives enough significant digits to identify the double uniquely. `%g`, with its default six digits, rounds the display back to `0.1` and hides everything. **What you print is itself a rounding of what you stored.** When a result surprises you, print it with `%a` or `%.17g` before drawing conclusions.

## Warm-ups

Four short programs, each leading into one exercise of the lesson. The scaffolds are in `week-03/learner/src/w01.c` to `w04.c`, each with a supplied `main`. From `week-03`, run `make warmups` to build and check only the warm-ups. It names each one that is not yet passing. They are ungraded, but the lesson's exercises assume you can do them.

<!-- warmup:W01 -->

<!-- warmup:W02 -->

<!-- warmup:W03 -->

<!-- warmup:W04 -->

## Check yourself

Try each question before opening its answer.

1. Why does `0.5` have an exact binary representation and `0.1` not?

   ::: details Answer
   0.5 is 1/2, a single binary place. 0.1 is 1/10; its denominator has a factor of 5, and no finite sum of halves, quarters, eighths and so on can produce that. Its binary expansion repeats forever and must be rounded.
   :::

2. The exponent field of a double is 1026. Between which two powers of two does the value lie, and how far apart are neighbouring doubles there?

   ::: details Answer
   The true exponent is 1026 − 1023 = 3, so the value lies in [8, 16). The 2^52 marks in that stretch are 8 / 2^52 = 2^-49 apart.
   :::

3. `x + 1.0 == x` is true for some finite `x`. What is the smallest positive power of two for which that happens, and why?

   ::: details Answer
   2^53. Up to 2^53 the spacing is at most 1, so adding 1 lands on a mark. At 2^53 the spacing is 2, `2^53 + 1` is exactly halfway between two marks, and round-to-nearest-even returns `2^53`.
   :::

4. A test says `fabs(computed - expected) < 1e-9`. Give an input where this is too strict and one where it is too loose.

   ::: details Answer
   Too strict: `expected` around 10^9, where one ulp is about 1.2 × 10^-7, so even a correctly rounded result can fail. Too loose: `expected` around 10^-12, where an answer of 0 or 2 × 10^-12 would pass despite being entirely wrong. E02 asks you to build a comparison that handles both.
   :::

5. Which of these results are guaranteed exact under Annex F: `1.0 + 2.0`, `sqrt(2.0)`, `fmod(1e300, 360.0)`, `sin(M_PI)`?

   ::: details Answer
   `1.0 + 2.0` (the exact sum 3 is a mark, and addition is correctly rounded) and `fmod(1e300, 360.0)` (Annex F §F.10.7.1 states `fmod` is exact). `sqrt(2.0)` is correctly rounded but not exact, because √2 is irrational. `sin(M_PI)` has no exactness or correct-rounding guarantee, and its argument is not π anyway.
   :::

6. Why does the law of cosines report zero distance for points 6 cm apart, while the haversine formula does not?

   ::: details Answer
   The law of cosines needs `cos` of a tiny angle, which is within half an ulp of 1 and rounds to exactly 1, erasing the angle before `acos` runs. The haversine formula works with `sin(angle/2)`, a small number that keeps its full relative precision.
   :::

7. Why is `[-180, 180)` a better longitude range than `[-180, 180]`?

   ::: details Answer
   With both ends included, the antimeridian has two spellings, and two equal positions can compare as different. A half-open interval gives every meridian exactly one representation.
   :::

## Ready for the lesson

You are ready for the [Week 3 lesson](/weeks/week-03) when you can do each of these without looking back:

- Read `0x3FB999999999999A` as sign, exponent and fraction, and say which of its bits were rounded (prepares **E01**).
- Say how big one ulp is near 1, near 1000 and near 10^16, and pick an error measure for a given comparison (prepares **E02**).
- Wrap a longitude by hand and explain why the interval is half-open (prepares **E03**).
- Convert a latitude and longitude into a unit vector, and say why that conversion is not a change of basis (prepares **E04**).
- Explain, with the 6 cm example, why the formula you choose matters as much as the arithmetic (prepares **E05**).
- State a domain in which a cross-product sign is exact (prepares **E06**).

All four warm-ups should pass `make warmups`. If one resists, its written answer on the [solutions page](/solutions/week-03#w01) explains the reasoning, not just the code.

## Read alongside

The [further-reading page](/further-reading/week-03) introduces each companion text and gives a full cross-reference from every video in this week to the sections that explain the same mechanism. If you only have time for three readings this week, take them in this order:

1. *But How Do It Know?*, “Numbers” (PDF p. 46): binary place value from nothing, the gentlest possible start.
2. *Dive Into Systems*, [§4.8 Real Numbers in Binary](https://diveintosystems.org/book/C4-Binary/floating_point.html): the same format this page described, with more pictures.
3. CS:APP §2.4 Floating Point (p. 144, PDF p. 137), especially §2.4.2 to §2.4.5: the full treatment, with the encodings, rounding modes and operations you will lean on all year.
