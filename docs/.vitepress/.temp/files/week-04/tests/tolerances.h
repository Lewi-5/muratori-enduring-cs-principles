#ifndef WEEK04_TOLERANCES_H
#define WEEK04_TOLERANCES_H
/* One source of truth for every tolerance the tests use. instructor/validation.md records, for each value, whether
   it is (A) an a-priori worst-case bound derived from rounding, which measurement then stays under, or
   (B) a measurement at least ten times the maximum recorded by instructor/extras/measure.c
   (GCC 11 and Clang 14, glibc 2.35, -O0 and -O2, -ffp-contract=off). A looser tolerance is a weaker test, so do
   not widen one to make a failing implementation pass. */
#define TOL_ANALYTIC_REL   1e-12  /* B: haversine distance of one point vs the analytic R * angle, relative */
#define TOL_DIST_ABS_KM    1e-9   /* B: absolute floor where the expected value is 0 (one micron) */
#define TOL_SUM_REL        2e-12  /* A+B: sum_km vs an independent sum. Accumulation bound (n-1)u = 1.11e-12 for n = 10^4 (derived), plus at most
                                     n * 3.3e-9 km / S <= 3.3e-13 from per-point disagreement (haversine near antipodes; measured), smallest measured S = 9.96e7 km */
#define TOL_MINMAX_REL     1e-11  /* B: min_km and max_km vs the independent reference, relative (max measured 8.1e-13, 12x margin) */
#define TOL_UNIT_ROUNDOFF  1.1102230246251565e-16 /* u = 2^-53, exact */
#endif
