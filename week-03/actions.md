# Week 03 review actions and implementation handoff

Status: implemented 2026-09-22; a human workload pilot remains pending. The checklist and fresh verification evidence below record completion. The review findings remain as historical context.

Review date: 2026-09-22. This handoff follows a review of the course specification, the weeks 1–2 teaching and implementation pattern, and the week-three learner materials, instructor solutions, tests, and explanations.

## Outcome sought

Keep the existing seven-exercise geospatial math notebook and its substantial verification suite. Fix the confirmed vector-conversion bug, repair the mathematical explanations, teach coordinate bases accurately, and make the required workload more credible. Synchronize the specification, prompts, reference code, answer key, and validation evidence.

The package substantially meets the course plan. These are targeted corrections, not a rewrite. Preserve the learner/instructor separation, prediction-before-observation workflow, explicit failure contracts, independent oracles, and distinction between language guarantees and measured results. Keep the public library API and later-week scope unchanged. Do not add parsing, performance experiments, SIMD, or general robust geometric predicates.

## Evidence and starting conditions

- The reviewer ran `make verify` successfully in WSL on 2026-09-22. Both GCC and Clang passed the reference debug, optimized, and sanitizer configurations; the learner build targets and 27-ID inventory passed. Passing this suite does not establish the absence of the bug below.
- Inventory scripts for weeks 1, 2, and 3 passed with 43, 33, and 27 prompt IDs respectively. Weeks 1–2 were comparison material, not the subject of a complete new correctness audit.
- A temporary C probe linked to the current instructor `geomath.c` reproduced `unit_to_latlon({1e-200, 1e-200, 1e200})` returning success, latitude 90, and longitude 0. The longitude calculated from the original horizontal components is 45 degrees.
- The same probe confirmed `fmod(0x1p60, 360.0) == 136.0`, contradicting a step of the current exactness proof.
- No course source was changed during the review. The temporary probe source was removed; reconstruct the regression from this document rather than expecting that file to exist.
- Inspect the working tree before editing and preserve unrelated work. Existing `instructor/validation.md` evidence predates this review; distinguish historical results from new runs.

## A1 — Preserve longitude when normalization underflows horizontal components

Priority: required correctness fix.

### Defect

`unit_to_latlon` normalizes the input and uses the normalized `x` and `y` for both `atan2` and the exact-pole test. For finite vectors with a very large vertical-to-horizontal ratio, both horizontal components underflow to zero. This incorrectly applies the longitude-zero convention to an input whose original horizontal components are nonzero.

Reproducer:

```c
Vec3 v = {1e-200, 1e-200, 1e200};
double lat = 42.0, lon = 42.0;
int ok = unit_to_latlon(v, &lat, &lon);
/* Current: ok == 1, lat == 90, lon == 0.
   Required: success, finite latitude near 90, longitude near 45. */
```

Latitude rounding to 90 does not justify discarding a longitude that remains recoverable from the original input. The contract accepts any finite nonzero vector; it does not restrict callers to unit vectors produced by `latlon_to_unit`.

### Changes

- Fix both `instructor/src/ex04.c` and `instructor/src/geomath.c`.
- Preserve finite/nonzero validation and a scaled computation of latitude to avoid overflowing `hypot` on large components.
- Determine an exact pole from the original `v.x == 0.0 && v.y == 0.0`. Otherwise compute longitude using `atan2(v.y, v.x)`, convert to degrees, and apply the existing wrapping policy. Do not divide the original horizontal components before computing longitude.
- Continue validating before committing either output. Preserve NULL-output rejection and unchanged outputs on failure.
- Clarify the original-component pole convention in `learner/exercises.md`, `PLAN.md`, both `geomath.h` copies, and `instructor/answers.md` E04.C/E04.Q. Keep learner mechanism bodies as TODOs.
- Audit copied helpers for another occurrence of this function; update every actual implementation, not just the assembled library.

### Regression checks

Add cases to `check_vectors` in `tests/contracts.c`, which exercises both E04 and E07:

- The reproducer above, with expected longitude 45 degrees.
- Sign variants with expected longitudes -45 and 135 degrees, and a negative vertical component to exercise the southern hemisphere.
- At least one case with original subnormal horizontal components, such as `{DBL_TRUE_MIN, DBL_TRUE_MIN, DBL_MAX}`, on the reference platform.
- Retain exact poles, ordinary round trips, `{DBL_MAX, DBL_MAX, 0}`, zero/non-finite rejection, and output-sentinel checks.

Use the existing justified angular tolerance for nonzero longitude comparisons. Do not require bit-identical `atan2` results. Verify that at least the first new regression fails against the old code and passes against both corrected implementations. The fix must not be a tolerance increase or a reduced input domain.

## A2 — Replace the invalid proof of `fmod` exactness

Priority: required mathematical-content fix.

### Defect

E03.Q in `instructor/answers.md` claims that if `x = m * 2^e`, the remainder modulo 360 is an integer multiple of `2^e`. For the normalized binary64 representation `2^60 = 2^52 * 2^8`, the remainder is 136, which is not a multiple of 256. The guarantee is correct under the stated conditions; this proof step is not.

### Changes

- Replace the proof, keeping the authoritative citation to C11 N1570 Annex F.10.7.1 paragraph 2 and its subnormal-support condition.
- One valid proof route for finite binary64 input and divisor 360: handle `abs(x) < 360` directly; otherwise use integer significand `m` and split on `e <= 3` versus `e > 3`. In the first case, 360 is an integer multiple of `2^e`, and the remainder's coefficient fits because its magnitude is below `abs(x)`. In the second case, both operands are multiples of 8 and the remainder's magnitude is below 360, so its representation is exact. Check the details and negative-input argument before publishing.
- Keep the separate Sterbenz argument for the single longitude correction and quadrant subtractions; those are different claims and do not need replacing merely because the remainder proof was wrong.
- Check E03.C, P01(e), report claims, and the validation text for references to the faulty reasoning. State the Annex F/platform boundary consistently.
- Add `0x1p60` and its negative to the existing huge-input oracle cases, without adding a separate test framework. The independent integer oracle should establish the expected wrapped result; explain that tests illustrate the proof rather than prove it for all inputs.

Acceptance: the revised argument covers all finite reference-platform inputs, including large exponents, and does not claim the remainder is always a multiple of the dividend's spacing.

## A3 — Separate mathematical exactness from correct rounding

Priority: required mathematical-content fix.

### Defects

- E02.Q and introductory policy text list `sqrt` among operations whose results are exact by specification. Under Annex F it is correctly rounded; an irrational result such as sqrt(2) is not exactly representable.
- E05.Q calls `sqrt(1 + 2^-52)` an exact halfway case equal to `1 + 2^-53`. The mathematical square root is strictly below that midpoint. The observed rounded result is correct; the explanation is not.

### Changes

- Audit `README.md`, `PLAN.md`, `learner/exercises.md`, `instructor/answers.md`, `instructor/observations.md`, `instructor/validation.md`, and introductory comments in `tests/contracts.c` for these claims.
- Teach three distinct cases: an exactly representable mathematical result; a correctly rounded result; and a transcendental result assessed using a justified error tolerance. Scope each claim to its specified platform and inputs.
- Give a small contrast such as sqrt(4), which is exact, versus sqrt(2), which is correctly rounded but inexact. Do not imply that correct rounding universally licenses exact equality between different computational paths.
- Replace the false halfway explanation with an inequality: `(1 + 2^-53)^2 = 1 + 2^-52 + 2^-106 > 1 + 2^-52`, so `1 < sqrt(1 + 2^-52) < 1 + 2^-53`. In round-to-nearest binary64, the result is therefore 1, without a tie.
- Retain valid exact special-value checks and bounded integer-predicate checks. Do not weaken tests solely because their underlying operation sometimes rounds on other inputs.
- Keep the haversine clamp. Explain the observed one-ulp overshoot separately from any universal claim: failure to reproduce a NaN for one formula on one sample set does not prove that clamping is redundant for every permitted input, rounding environment, or libm implementation. Avoid describing a surviving clamp mutation as universally equivalent based only on observed samples.
- Record whether changed wording affects a tolerance derivation or measured table; refresh affected evidence where necessary.

Acceptance: no active instruction equates correct rounding with zero mathematical error, and the midpoint explanation is valid algebraically as well as consistent with a run.

## A4 — Teach an actual basis change alongside spherical coordinates

Priority: required conceptual correction; keep the addition small.

### Defect

The plan and E04 explanation call latitude/longitude-to-Cartesian conversion a change of basis. It is a nonlinear coordinate conversion. Latitude and longitude are angles, not coefficients of a vector in a linear basis. The current exercise does not concretely demonstrate expressing the same vector in two bases.

### Changes

- Correct this distinction in `PLAN.md` objectives and E04 requirements, `learner/exercises.md` E04.Q, and `instructor/answers.md` E04.Q and P04. Search the rest of the week for the same imprecision.
- Retain the latitude/longitude map and its role in the haversine derivation. Explain that the resulting Cartesian components are coefficients in the chosen fixed orthonormal basis.
- Add one compact worked basis-change subquestion under the existing E04.Q ID. For example, use `b1 = (3/5, 4/5, 0)`, `b2 = (-4/5, 3/5, 0)`, `b3 = (0, 0, 1)` and `v = (1, 2, 3)`. Ask learners to verify orthonormality, compute the coordinates with dot products, and reconstruct the original vector.
- Supply the full answer: coordinates `(11/5, 2/5, 3)` and reconstruction `v = (11/5)b1 + (2/5)b2 + 3b3`. Distinguish exact rational calculations on paper from rounded C calculations. Explain why taking dot products with the basis vectors works here specifically because the basis is orthonormal.
- Connect this example explicitly to the assigned HH090–091 segments. No new public API or general matrix library is needed; existing `vec3_dot` is enough for an optional check.
- Update the coverage description and rubric wording as needed. Preserve the 27 top-level prompt IDs by placing the new work within E04.Q, and ensure its subquestions are all answered.

Acceptance: a learner can distinguish spherical coordinate conversion from linear basis change and can carry out a concrete basis change without merely repeating terminology.

## A5 — Reduce avoidable workload and document the remaining uncertainty

Priority: required teaching-design revision; human pilot remains follow-up work.

### Concern

The ten-hour estimate is unpiloted. E06 alone budgets 50 minutes for segment classification, degenerate cases, explanations, and an independently authored exhaustive integer oracle. Adding the basis example without adjusting scope would increase an already dense workload.

### Changes

- Make the existing independent oracle in `tests/contracts.c` supplied verification infrastructure. Replace the requirement to write another complete oracle with a requirement to explain the supplied oracle's independence, trace a representative case, and add a small number of purposeful boundary tests. Keep the exhaustive 6,561-pair oracle running in the suite.
- Keep implementing the actual segment-intersection algorithm as core learner work. Preserve the numerical reasoning and required degenerate cases.
- Update E06.C/E06.Q, their instructor answers, `PLAN.md`, and any coverage/report references so they agree about who supplies the oracle and what the learner must contribute.
- Recalculate the activity budget, explicitly accounting for explanations, the E04 basis example, tests, and debugging. Keep the course's 8–10-hour target, but do not assert that changing a table proves it achievable. If the revised scope still appears too large, state the unresolved estimate honestly and identify a concrete further reduction for review.
- Retain optional stretch work as additional time. Do not move essential correctness or reasoning out of the core simply to make the estimate look smaller.
- Provide a short pilot procedure: an experienced C programmer attempts the learner package without the answer key, logs reading/implementation/test/explanation time by exercise, and records points requiring help. Use those results to revise the budget later.
- Do not fabricate pilot results or present agent execution time as learner completion time. A coding agent can complete these edits and record the pilot as pending; obtaining a human pilot is not a prerequisite for delivering the fixes.

Acceptance: instructions no longer require duplicate exhaustive-oracle construction, workload descriptions agree, and the unpiloted status remains explicit.

## Implementation order and verification

1. Inspect the current files and establish a passing baseline before changes. Use the supported Linux/WSL environment; do not substitute a Windows C runtime for reference numerical evidence.
2. Add and demonstrate the A1 regression, then fix both reference implementations.
3. Correct A2 and A3 proofs and exactness policies. Cross-check mathematical claims against primary sources, not only against existing answer text.
4. Apply A4 and A5 together so the added basis example is accounted for in learner scope and time estimates.
5. Synchronize the week plan, learner prompts, instructor answers, header contracts, coverage table, rubric, and report exemplar. Clearly distinguish historical corrections from the current normative requirements.
6. Run the normal verification matrix after code and test changes. Avoid unnecessary reruns after prose-only edits; rerun inventory/link checks for document changes.

From `week-03`, the final checks are:

```sh
make verify
make PACKAGE=instructor symbols
make inventory
```

Also confirm the unfinished learner package still fails `make test` for the expected unimplemented behavior, rather than a build or harness error. Demonstrate that restoring the old A1 implementation makes the new regression fail. Preserve the existing forced-skip, symbol, stretch, and property checks.

Update `instructor/validation.md` with the date, environment actually used, commands, results, regression reproduction, and limits of the evidence. Retain historical measurements with their dates; do not silently relabel them as fresh results. When numerical output changes, reconcile the affected answer and report tables. Ordinary last-digit variation is not a reason to invent a new universal expected value.

Primary references to consult:

- [C11 draft N1570](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf): section 3.9, Annex F.3, and F.10.7.1.
- [HH090: Bases Part I](https://guide.handmadehero.org/code/day090/) and [HH091: Bases Part II](https://guide.handmadehero.org/code/day091/): use the already assigned indexed segments.

## Completion checklist and handoff report

- [x] A1: original-component longitude and pole handling fixed in E04 and E07; new regression failed before and passed after.
- [x] A2: valid remainder proof replaces the false spacing claim; huge-input example covered by the independent oracle.
- [x] A3: exactness/correct-rounding distinction and square-root midpoint explanation corrected throughout the week.
- [x] A4: spherical conversion and basis change distinguished; a fully worked basis example added under E04.Q.
- [x] A5: supplied oracle workflow and revised workload documentation synchronized; human pilot explicitly pending.
- [x] Existing API, platform gates, failure contracts, learner TODO separation, and 27 prompt IDs preserved.
- [x] Required compiler/sanitizer matrix, symbol inspection, inventory, and learner-negative check completed.
- [x] Validation record updated with fresh evidence and remaining limitations.

The implementing agent's final report should summarize each action, affected files, verification results, and unresolved workload evidence. Mark completed items here as work finishes. Do not mark the human pilot complete without actual participant data.
