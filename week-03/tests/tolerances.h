#ifndef WEEK03_TOLERANCES_H
#define WEEK03_TOLERANCES_H
/* One source of truth for every tolerance the tests use. Two kinds of justification are used, and
   instructor/validation.md records which applies to each value:
   (a) an a-priori worst-case bound derived from rounding (the ulp-level constants: degree/radian conversion,
       sin_deg/cos_deg, normalization length, segment crossing), which a measurement then stays under; and
   (b) a measurement at least ten times the maximum error recorded by instructor/extras/measure.c
       (GCC 11 and Clang 14, glibc 2.35, -O0 and -O2, -ffp-contract=off) for lattice-level quantities.
   A looser tolerance is a weaker test, so do not widen one to make a failing implementation pass. */
#define TOL_DEG_RAD_REL        1e-15   /* rad_to_deg(deg_to_rad(x)) relative error */
#define TOL_SIN_REF_ABS        1e-15   /* sin_deg/cos_deg vs exact 30/45/60 references */
#define TOL_SIN_LATTICE_ABS    1e-15   /* sin_deg/cos_deg vs a long double reference */
#define TOL_UNIT_LENGTH        1e-15   /* | |normalize(v)| - 1 | */
#define TOL_ROUNDTRIP_DEG      1e-12   /* latlon -> unit -> latlon, degrees (lat and wrapped lon delta) */
#define TOL_DIST_REL           1e-12   /* haversine/vector vs analytic expected, relative */
#define TOL_DIST_ABS_KM        1e-9    /* absolute floor, used where the expected value is 0 */
#define TOL_SYMMETRY_KM        1e-9    /* |d(a,b) - d(b,a)| */
#define TOL_TRIANGLE_KM        1e-8    /* d(a,c) <= d(a,b) + d(b,c) + tol */
#define TOL_ANTIMERIDIAN_KM    1e-8    /* distance to (lat,180) vs (lat,-180) for the haversine path */
#define TOL_CROSSING_ABS       4e-16   /* segment crossing point vs exact rational, absolute per unit of magnitude */
#endif
