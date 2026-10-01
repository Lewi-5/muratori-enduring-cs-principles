# Warm-up answers — numbers in a box

The linked files are complete solutions. The warm-ups are ungraded; these answers explain the reasoning so a learner can check more than the test result. Values marked *measured* were observed with GCC 11.4 and Clang 14 on x86-64 Linux (WSL2), glibc 2.35, `-ffp-contract=off`; everything else follows from the binary64 format or C11.

### W01

[w01.c](src/w01.c) copies the eight bytes of the `double` with `memcpy`, into a `uint64_t` for `double_bits` and into the caller's array for `double_bytes`. `double_bits` checks `out` and the `GEO_IEC559` gate before writing, because "the 64-bit pattern of a binary64 value" means nothing on a platform whose `double` is some other format. `double_bytes` needs no gate: copying an object's bytes is always legal in C (C11 §6.2.6.1 ¶4 calls them its object representation).

Predictions from the layout: `1.0` is sign 0, biased exponent 1023 (`0x3FF`), fraction 0, so `0x3FF0000000000000`. `-2.0` is sign 1, exponent 1024 (`0x400`), fraction 0; the top twelve bits are `1100 0000 0000` = `0xC00`, giving `0xC000000000000000`. `0.5` is exponent 1022 (`0x3FE`), giving `0x3FE0000000000000`. The tests also check `0.1` = `0x3FB999999999999A` and `-0.0` = `0x8000000000000000`.

**Question.** The `bits=` field prints the value of a 64-bit *integer*, most significant digit first, as humans write numbers. The `memory=` field prints the bytes at increasing addresses. On x86-64 the least significant byte of a multi-byte integer is stored at the lowest address (little-endian), so the byte `3F`, which holds the sign and the top of the exponent, comes last. C promises neither order: C11 leaves the representation of `uint64_t` bytes to the implementation beyond requiring no padding bits (§7.20.1.1), and it says nothing about byte order. The test checks the relationship that is portable, namely that `double_bytes` returns the double's own bytes and that they equal the integer's bytes, and it checks the hex pattern only under the binary64 gate.

**Faulty approach:** `*out = *(uint64_t *)&value;`. It usually "works", but it reads a `double` object through an lvalue of an incompatible type, which violates the effective-type rule (C11 §6.5 ¶7), so the compiler may assume the two do not alias. `memcpy` has defined behaviour, and GCC and Clang typically turn it into a single register move at `-O2` (a compiler observation, not a language guarantee).

### W02

[w02.c](src/w02.c): `gap_above(x)` is `nextafter(x, INFINITY) - x`. The subtraction is exact: the two neighbours differ by exactly one unit in the last place, and that difference is representable. `absorbs_one` stores `x + 1.0` in a variable and compares it with `x`.

Predictions: a normal double has 53 significant bits, so between 1 and 2 the spacing is 2^-52; between 2 and 4 it doubles to 2^-51; between 1024 and 2048 it is 2^-42. At 2^52 the spacing reaches 1, so `2^52 + 1` is still representable and nothing is absorbed. At 2^53 the spacing is 2, and `2^53 + 1` lies exactly halfway between `2^53` and `2^53 + 2`. Round-to-nearest-even picks the neighbour whose last significand bit is even, which is `2^53` itself, so the one is absorbed. The tests also confirm that `1e16 + 1 == 1e16`, as the beginner section's `spacing` example printed.

**Question.** The double just above `-1.0` lies between -1 and -0.5, where doubles are twice as dense as they are between 1 and 2 (the binade [0.5, 1) in magnitude has spacing 2^-53). Moving "up" from -1 moves toward zero, into the denser binade. The lesson for E02 is that an ulp is not a fixed size: one step near 1e16 is 2, one step near 1 is about 2.2e-16. Counting steps between two doubles measures how many representable values separate them, which is the natural unit of rounding error. It says nothing directly about the size of the error in metres; you need the magnitude for that.

**Faulty approach:** `return x + 1.0 == x;` works on this platform, but a compiler that evaluates in extended precision (C11 §5.2.4.2.2, `FLT_EVAL_METHOD` other than 0) may keep `x + 1.0` in a wider register, where the one is not absorbed. Storing the sum in a `double` variable first forces the rounding the question is about. On x86-64 with SSE2, `FLT_EVAL_METHOD` is 0 and both forms agree.

### W03

[w03.c](src/w03.c) validates first (NULL, non-finite, outside `[-540, 540)`), then applies one conditional correction: subtract 360 when `lon >= 180`, add 360 when `lon < -180`. Every input in the domain lands in `[-180, 180)` after at most one step, because the domain is exactly one full turn wider on each side of the target interval. The correction never rounds. Sterbenz's lemma says that `x - y` is exact when `y/2 <= x <= 2y`; with `y = 360` that covers every `x` in `[180, 720]`, which includes `[180, 540)`. For negative inputs, `lon + 360` is `360 - |lon|` with `|lon|` in `(180, 540]`, the same situation. E03 makes the same argument for the general `fmod` version.

The driver lines: `wrap(0)=0`, `wrap(179)=179`, `wrap(180)=-180`, `wrap(190)=-170`, `wrap(-180)=-180`, `wrap(-190)=170`, `wrap(539)=179`, `wrap(-540)=-180`.

**Question.** A half-open interval gives each meridian exactly one spelling. If both 180 and -180 were allowed, two points on the antimeridian could compare as different longitudes even though they are the same place, and any code that sorts, hashes or tests equality on longitudes would need special cases. Choosing `[-180, 180)` rather than `(-180, 180]` is a convention, not a fact about the globe; E03 states it as policy.

**Faulty approach:** `while (lon >= 180) lon -= 360;` without a domain check. It is correct for small inputs, but for `1e300` it never terminates, because subtracting 360 from `1e300` gives back `1e300` (the same absorption as W02). E03 uses `fmod` precisely so that huge inputs take one exact step.

### W04

[w04.c](src/w04.c) computes `cross = (bx - ax) * (cy - ay) - (by - ay) * (cx - ax)` in `long long` and returns its sign with `(cross > 0) - (cross < 0)`. The driver's cases are a point above the x-axis segment from (0,0) to (4,0) (left, +1), a point below it (right, -1) and a point on its extension (collinear, 0).

**Question.** With every coordinate in `[-2^30, 2^30]`, each difference lies in `[-2^31, 2^31]` and each product in `[-2^62, 2^62]`, well inside `long long` (at least 64 bits, C11 §5.2.4.2.1). The final subtraction also cannot overflow, for a geometric reason: the cross product is twice the signed area of the triangle `abc`, and a triangle whose corners lie in a square of side 2^31 has at most half the square's area. So `|cross| <= 2^62`, and every intermediate is an exact integer. E06 uses a much smaller domain (magnitudes up to 2^25, doubles holding integers) so that every intermediate is an integer below 2^53 and therefore exact in `double`. In `double` with coordinates near 10^8, the products are near 10^16, above 2^53, so they round to even integers: the beginner section's `big_product` example shows `100000001 * 99999999` coming out as `10000000000000000` instead of `9999999999999999`. A cross product that should be 1 or -1 can round to 0, and a nearly collinear point is then misclassified.

**Faulty approach:** returning `cross` itself instead of its sign. The caller only needs the sign, and a large `cross` returned through an `int` would be truncated or change sign on conversion.
