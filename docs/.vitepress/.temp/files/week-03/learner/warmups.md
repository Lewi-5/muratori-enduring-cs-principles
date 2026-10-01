# Warm-ups — easing into numbers in a box

Four small, ungraded programs. Each one prepares a single exercise in the main assignment, so do them before the lesson or alongside it. Every warm-up has a typed scaffold in `src/wNN.c` with a supplied `main`; you fill in the `TODO` bodies. From `week-03`, `make warmups` builds and checks only the warm-ups and reports which ones still need work. `make test` checks them first, then the graded exercises.

Each warm-up ends with a short question. Answer it in a sentence or two in your notebook; the worked answers are on the solutions page.

### W01

**The bytes of a double (prepares E01).** Implement `int double_bits(double value, uint64_t *out)`, which stores the 64-bit pattern of `value` in `*out`, and `int double_bytes(double value, unsigned char out[8])`, which stores the same eight bytes in the order they sit in memory. Copy with `memcpy`; do not cast a `double *` to another pointer type. `double_bits` returns 0 and writes nothing when `out` is NULL or the binary64 gate `GEO_IEC559` is false; `double_bytes` returns 0 when `out` is NULL. Both return 1 on success. Before you run the driver, predict the 16 hex digits of `1.0`, `-2.0` and `0.5` from the layout described in the beginner section, then compare.

**Question:** the driver prints `bits=0x3FF0000000000000` but `memory=00 00 00 00 00 00 F0 3F` for `1.0`. Why are the same eight bytes shown in two different orders, and which of the two orders does C promise?

### W02

**Neighbouring doubles (prepares E02).** Implement `double gap_above(double x)`, the distance from a finite `x` to the next representable `double` above it (use `nextafter` from `<math.h>`), and `int absorbs_one(double x)`, which returns 1 when `x + 1.0` gives back exactly `x` and 0 otherwise. Store `x + 1.0` in a variable before comparing it. Before you run the driver, predict the gap at 1, 2 and 1024, and the smallest power of two at which adding one is absorbed.

**Question:** why is the gap above `-1.0` half the gap above `1.0`, and what does that tell you about measuring error in "steps between doubles" rather than in plain units?

### W03

**Wrapping a longitude by hand (prepares E03).** Implement `int wrap_small(double lon, double *out)` without `fmod`. It accepts a finite `lon` with `-540 <= lon < 540` and stores the equivalent longitude in the half-open interval `[-180, 180)`, using at most one addition or subtraction of 360. It returns 0 and leaves `*out` unchanged for a NULL `out`, a non-finite input or an input outside that domain. Work out the eight driver lines on paper first: `0, 179, 180, 190, -180, -190, 539, -540`.

**Question:** 180 and -180 name the same meridian. Why does the interval include -180 but not 180, and what would go wrong for a program that compares two wrapped longitudes if both spellings were allowed?

### W04

**Which side? (prepares E06).** Implement `int orientation(ax, ay, bx, by, cx, cy)` for `long long` integer coordinates, each within `[-2^30, 2^30]`. Return +1 when `c` lies to the left of the directed line from `a` to `b` (a counter-clockwise turn), -1 when it lies to the right, and 0 when the three points are collinear. Compute the cross product `(b - a) x (c - a)` and return only its sign. Draw the driver's three cases before running it.

**Question:** why does the coordinate bound make this test exact, and what could go wrong if you computed the same cross product in `double` with coordinates near `10^8`? (The `big_product` example in the beginner section is a hint.)
