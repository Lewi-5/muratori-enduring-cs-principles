---
prev:
  text: Week 2 · Objects, bytes, and storage
  link: /weeks/week-02
next:
  text: Week 4 · Deterministic data
  link: /weeks/week-04
---

# Week 3 · Numbers in a box

You calculate the distance between two nearby points using two formulas learned in mathematics. They are algebraically equivalent, yet the final digits disagree. On a very short distance, one may lose much more information than the other.

The computer has not abandoned mathematics. It is performing a sequence of operations on a finite set of representable numbers. Each operation can round, and different formulas take different routes through that set. This week makes that route visible, then turns the understanding into a geospatial math library.

## Why the sequence matters

Week 2 gave you a legal way to inspect representation and a habit of naming platform assumptions. E01 applies that discipline to floating point. Error comparisons and angle conventions come next, followed by vectors, distance formulas, segment intersection, and a reusable interface.

You are not expected to know numerical analysis already. You should be comfortable with Week 1's checked functions and Week 2's byte inspection. Read the geometry slowly with drawings; the aim is to explain a failure mechanism, not memorize a formula. The original ten-hour budget assumes experienced C programmers and does not include unlimited background review.

By the end, you should be able to decompose a supported floating-point value, choose and justify an error measure, explain a coordinate convention, and demonstrate your geometry functions on both ordinary and difficult boundary cases.

## Finite representations change arithmetic

### Why a decimal fraction can need infinitely many bits

You divide one by ten and expect to store the result. In decimal, `0.1` ends after one digit. In binary, a finite fraction has a denominator that is a power of two after reduction. Ten contains a factor of five, so one tenth has no finite binary expansion.

On the reference binary64 platform, a normal value has a sign, an exponent, and a significand. The exponent changes scale; the significand selects a position within that scale. One leading bit is implicit for normal values, so it is not stored in the fraction field. Subnormal values use a different leading-bit rule to extend the range toward zero with decreasing precision.

Here **binary64** names the 64-bit floating-point format used by the reference target's `double`; C11 does not require every `double` to have this format. A normal nonzero value follows the pattern `sign × significand × 2^exponent`. The stored exponent has a bias added so its bit field is unsigned. The example below removes that bias explicitly. Zero, subnormal values, infinities, and NaNs have special field interpretations rather than all following the normal-value rule.

An everyday ruler provides a useful analogy: a measurement between marks must be represented by a nearby mark. Floating-point spacing, however, grows with scale; it is not one uniformly spaced ruler covering the whole number line. E02's representable-step measurements expose that distinction.

### Three error measures, three questions

You compare 100.01 with a reference of 100. The absolute error is 0.01; the relative error is 0.0001, or 0.01%. Near a zero reference, division by the reference is no longer a useful measure. A count of **ulps**, steps between neighboring representable values under the exercise's definition, asks another question again.

| Measure | Useful question | Important limit |
| --- | --- | --- |
| Absolute error | How many metres or units are wrong? | One threshold may be unsuitable across scales |
| Relative error | How large is the error compared with the result? | Zero and near-zero references need care |
| Representable-step distance | How far apart are these stored values? | The physical size of a step varies |

A tolerance is an explicit acceptance rule. It should follow from the intended question and numerical error analysis, rather than being enlarged until tests pass. Exact equality is appropriate for selected exact outcomes; it is not a universal mistake or a universal solution.

### Exceptional values are part of the input domain

You compare a NaN with both interval endpoints and neither comparison reports outside. A NaN is not an ordinary number waiting beyond the upper bound. Validate finiteness explicitly wherever the contract requires finite inputs.

**NaN** means “not a number”: it represents a numerical result that is not an ordinary real value. An infinity represents an unbounded magnitude in the supported arithmetic. A **finite** input excludes both. Testing only `x < low || x > high` does not reject NaN, because these ordered comparisons with NaN are false.

The exercises gate binary64-specific experiments on the documented platform properties. A skip is a statement that a prerequisite is absent. It does not mean the experiment passed, and forcing the skip path does not emulate a different floating-point machine.

## Geometry needs conventions as well as formulas

### Crossing the longitude boundary

You travel from 179° longitude to −179°. Subtracting the labels suggests −358°, while the short signed change is +2°. Longitude wrapping chooses a representative of equivalent angles. The half-open interval `[-180,180)` gives the boundary a single canonical spelling.

Degrees and radians are different units. Converting an exact degree boundary through an approximate stored pi can lose an exact trigonometric special case. The degree functions therefore handle quadrants explicitly. That is a deliberate interface guarantee, not a property inferred from a fortunate library result.

### Position on a sphere versus coordinates in a basis

Latitude and longitude describe a point nonlinearly on a sphere. Converting to Cartesian components gives a vector in a fixed basis. Changing the basis of an existing vector is another operation: dot products recover coordinates in an orthonormal basis. Keep these two transformations distinct when reading the assigned geometry videos.

A **basis** is a set of reference directions used to express a vector. **Orthonormal** means those directions are perpendicular and each has length one. The **dot product** multiplies corresponding components and adds them; with a unit reference direction, it measures the vector's component along that direction. The exercise contracts give the exact formulas and domains so a drawing does not silently choose a different convention.

When finding a vector's length, squaring a large component may overflow even when the desired direction is easy to represent. Scaling components first avoids that intermediate problem. A vector can have a representable unit direction even when its original length cannot be returned as a finite `double`.

### Choosing a reference you can defend

You compare three formulas and two agree. Agreement alone does not select the truth; both could share a weakness. Start with analytic cases: identical points, a quarter-circle, or an arc on the equator with a known angle. Add properties such as symmetry, then use a different formulation as another witness.

The sphere itself is a simplification of Earth. Keep that modeling choice separate from six-decimal input quantization and rounding during arithmetic. Improving one source of error does not eliminate the others.

## Read and watch with a question

The Haversine introduction provides the application. The Handmade Hero segments supply reasons to care about zero vectors, collision boundaries, and coordinate systems. Read the primary clauses when you need to distinguish the C contract from Annex F or a particular `libm` result.

<!-- readings -->

## Tools and a first exact example

On the stated binary64 model, `0.75 = 1.5 × 2^-1`. Its sign is zero, its stored exponent is `1023 - 1 = 1022`, and its fraction represents the one-half after the implicit leading one. That fraction is `0x8000000000000`. This is a model calculation to check with E01, not an invented transcript from your computer.

```sh
cd week-03
make
make test
make CC=clang MODE=optimized test
```

The [constants](/source/week-03/support/geo_consts.h), [platform gate](/source/week-03/support/platform.h), and [test tolerances](/source/week-03/tests/tolerances.h) are supplied support. Explain what each establishes before borrowing it. The build disables floating-point contraction because a changed rounding path would change the experiment. Keep the required flags; a faster result from a different arithmetic policy answers a different question.

## Guided exercises

The drivers supply inputs and presentation. You implement the mathematical mechanisms and their validation. Preserve numerical predictions before running, especially for E02, E03, and E05.

<!-- contract-intro -->
<!-- exercise:E01 -->
<!-- exercise:E02 -->
<!-- exercise:E03 -->
<!-- exercise:E04 -->
<!-- exercise:E05 -->
<!-- exercise:E06 -->
<!-- exercise:E07 -->

## Practice and stretch

<!-- practice -->

## Your notebook and the next question

A useful error table names the input, reference, observed value, error measure, tolerance, and reason for that tolerance. “Accurate” without a domain or unit is incomplete. In particular, do not generalize the short-distance observations into a claim that one formula wins everywhere; the optional antipodal sweep investigates another difficult region.

Week 4 adds text input and many-term accumulation. You should leave this week able to ask how rounding coordinates to six decimal places differs from rounding a floating-point operation, and why summing many distances introduces another error path.

<!-- report -->
