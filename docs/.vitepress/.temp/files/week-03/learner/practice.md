# Practice and optional stretch

The six practice problems are ungraded preparation for the notebook. The stretch tasks are optional and additional to the core time estimate. Preserve the IDs in your answers. Reason about undefined or invalid operations as text; do not execute them.

### P01

Classify each statement as a portable C11 guarantee, an IEC 60559 / Annex F fact, an observation about one implementation, or false in general, and justify each with the clause or manual statement that supports it: (a) `0.1 + 0.2 == 0.3`; (b) `x != x` is true when `x` is NaN; (c) `(a + b) + c == a + (b + c)` for all finite doubles; (d) `sqrt(x * x) == fabs(x)` for all finite `x`; (e) `fmod(x, 360.0)` is computed without rounding error. Where a statement is false, give a counterexample you have checked. For (e), say which document actually states the guarantee: check whether the `fmod(3)` manual page does.

### P02

Decompose by hand `0.75`, `-6.5` and the largest subnormal (`0x000FFFFFFFFFFFFF`) into sign, biased exponent and fraction; reconstruct `0.75` from its fields; then check all three with E01. For `0.1` (biased exponent 1019), use the fraction printed by E01 to explain the repeating binary pattern and the direction of the rounding.

### P03

Predict the sign and approximate magnitude of `sin(GEO_PI)` from the relationship between `GEO_PI` and π, then measure it with a run and reconcile the two. Explain how `sin_deg(180)` avoids the problem.

### P04

Prove, from the dot product of two unit vectors, that the haversine of the central angle equals `hav(Δφ) + cos φ1 cos φ2 hav(Δλ)`, where `hav(θ) = sin²(θ/2)`. Then show that it also equals `|u − v|² / 4`. Say which step justifies each form, and where clamping becomes necessary in floating point.

### P05

Classify six segment pairs with small integer coordinates by hand using orientation signs and the parametric values `t` and `u`: one properly crossing pair, one parallel pair, one collinear overlapping pair, one touching pair, one degenerate (zero-length) pair, and one pair that is collinear and disjoint. Show the division-by-zero test for the parallel case.

### P06

Coordinates in a file are rounded to six decimal places. Compute the largest positional error this introduces per axis in metres, its effect on a computed distance of 1 m, 100 m and 10 km, and the spacing between adjacent doubles near 180 degrees. State what the comparison implies for the choice of tolerance in week 4. Use `GEO_EARTH_RADIUS_KM` and say whether your bound is worst-case or typical.

### S01

Optional: write `stretch_edges.c`, your own edge-case and property suite for `geomath`, linked against your `geomath.o` and including only `geomath.h`. Include at least ten named edge cases (poles with different longitudes, antimeridian equivalence, identical points, both directions of every pair, points one ulp apart, and others you choose) plus deterministic property checks (symmetry, the triangle inequality, invariance under adding 360° in cases where the addition is exact). For each test, write one sentence explaining what defect it would catch, and try to break your own library to confirm that it does.

### S02

Optional: a nearly-antipodal sweep. For `δ = 10^-k` degrees, `k = 1…12`, compare `haversine_km` and `vector_distance_km` for the pair `(0, 0)` and `(0, 180 − δ)` against the analytic central angle, and report the absolute error in radians for each formulation and each `k`. Note that `180 − δ` is not exactly representable, so take the reference from the actual double value of the longitude. Derive the amplification factor of each formula from the derivative of its final inverse function with respect to its argument, then confirm or refute it with your measurements. State which formulation loses accuracy, at what `δ`, and by how much on this machine. Do not assert a digit count that your sweep did not show. Different valid measurements are accepted.
