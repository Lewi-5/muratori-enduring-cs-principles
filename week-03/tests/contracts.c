/* C contract suites. Each exercise source is included with its main renamed; E07 links geomath.o and
   includes only geomath.h. Nothing here asserts a libm result bit-for-bit or a fixed digit string:
   exact expectations are limited to exactly representable results (including selected fmod and sqrt cases), integer arithmetic,
   byte decomposition, orientation predicates on the stated domain). Every tolerance is in tolerances.h. */
#include <assert.h>
#include <float.h>
#include <inttypes.h>
#include <limits.h>
#include <math.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "platform.h"
#include "tolerances.h"
#if EXERCISE == 7
#include "geomath.h"
#else
#define main exercise_main
#include SOURCE
#undef main
#endif

#define SENTINEL 42.0
static inline int same_bits(double a, double b) { return memcmp(&a, &b, sizeof a) == 0; }
static inline int within_rel(double got, double want, double rel, double abs_floor)
{
    return fabs(got - want) <= fmax(abs_floor, rel * fabs(want));
}

#if EXERCISE == 2 || EXERCISE == 7
static void check_approx_equal(void)
{
    int eq = 99;
    static const double vals[] = {0.0, -0.0, 1.0, -1.0, 1e-300, 1e300, 0.1, 0.3, DBL_MAX, -DBL_MAX, DBL_MIN, DBL_TRUE_MIN, INFINITY, -INFINITY, NAN};
    for (size_t i = 0; i < sizeof vals / sizeof vals[0]; ++i) for (size_t j = 0; j < sizeof vals / sizeof vals[0]; ++j) {
        int e1 = 5, e2 = 6;
        assert(approx_equal(vals[i], vals[j], 1e-9, 1e-12, &e1) && approx_equal(vals[j], vals[i], 1e-9, 1e-12, &e2) && e1 == e2);
    }
    assert(approx_equal(NAN, NAN, 1.0, 1.0, &eq) && eq == 0);
    assert(approx_equal(NAN, 1.0, 1.0, 1.0, &eq) && eq == 0);
    assert(approx_equal(INFINITY, INFINITY, 0, 0, &eq) && eq == 1);
    assert(approx_equal(INFINITY, -INFINITY, 1, 1, &eq) && eq == 0);
    assert(approx_equal(INFINITY, DBL_MAX, 1, 1, &eq) && eq == 0);
    assert(approx_equal(0.0, -0.0, 0, 0, &eq) && eq == 1);
    assert(approx_equal(DBL_MAX, -DBL_MAX, 1.0, 0.0, &eq) && eq == 0); /* difference overflows: contract says not equal */
    assert(approx_equal(1e-20, 2e-20, 0.0, 1e-19, &eq) && eq == 1);    /* absolute floor near zero */
    assert(approx_equal(1e-20, 2e-20, 1e-9, 0.0, &eq) && eq == 0);     /* relative tolerance does not help near zero mismatch */
    assert(approx_equal(1e300, 1e300 * (1.0 + 1e-15), 1e-14, 0.0, &eq) && eq == 1);
    assert(approx_equal(1.0, 1.0 + 1e-6, 1e-9, 1e-9, &eq) && eq == 0);
    assert(approx_equal(1.0, 1.0 + 1e-6, 1e-5, 0.0, &eq) && eq == 1);
    eq = 99;
    assert(!approx_equal(1, 1, NAN, 0, &eq) && !approx_equal(1, 1, 0, NAN, &eq) && !approx_equal(1, 1, INFINITY, 0, &eq)
           && !approx_equal(1, 1, 0, INFINITY, &eq) && !approx_equal(1, 1, -1e-9, 0, &eq) && !approx_equal(1, 1, 0, -1e-9, &eq)
           && !approx_equal(1, 1, 0, 0, NULL) && eq == 99);
    assert(approx_equal(1, 1, -0.0, -0.0, &eq) && eq == 1); /* -0.0 is not negative */
}
#endif

/* ---- E03/E07 oracle: (m * 2^k) mod 360 by modular exponentiation, independent of fmod ---- */
#if EXERCISE == 3 || EXERCISE == 7
static int mod360_of_integer(double magnitude)
{
    if (magnitude < 9007199254740992.0) return (int)((uint64_t)magnitude % 360u);
    int e; double f = frexp(magnitude, &e);
    uint64_t m = (uint64_t)ldexp(f, 53), p = 1, b = 2; int n = e - 53;
    while (n > 0) { if (n & 1) p = p * b % 360u; b = b * b % 360u; n >>= 1; }
    return (int)((m % 360u) * p % 360u);
}
static double expected_wrap(double v)
{
    int r = mod360_of_integer(fabs(v));
    if (v < 0) r = (360 - r) % 360;
    return r < 180 ? r : r - 360;
}
static void check_angles(void)
{
    double out = SENTINEL;
    assert(!wrap_lon_deg(NAN, &out) && out == SENTINEL);
    assert(!wrap_lon_deg(INFINITY, &out) && !wrap_lon_deg(-INFINITY, &out) && out == SENTINEL);
    assert(!wrap_lon_deg(1.0, NULL));
    static const struct { double in, want; } fixed[] = {
        {180, -180}, {-180, -180}, {540, -180}, {360, 0}, {-360, 0}, {0, 0}, {179.999999, 179.999999}, {-179.999999, -179.999999},
        {181, -179}, {-181, 179}, {720, 0}, {90, 90}, {-90, -90}};
    for (size_t i = 0; i < sizeof fixed / sizeof fixed[0]; ++i) assert(wrap_lon_deg(fixed[i].in, &out) && out == fixed[i].want);
    assert(wrap_lon_deg(-0.0, &out) && out == 0.0);
    assert(wrap_lon_deg(1e300, &out) && out >= -180.0 && out < 180.0);
    /* Annex F fmod is exact with subnormal support; these samples illustrate it with an independent integer oracle. */
    static const double huge[] = {1e300, -1e300, 1e22, -1e22, 0x1p60, -0x1p60, 9007199254740993.0, 123456789012345678.0, 1.7976931348623157e308,
                                  4503599627370496.5 * 2.0, 1e16, 3.0e15, -3.0e15 + 7.0};
    for (size_t i = 0; i < sizeof huge / sizeof huge[0]; ++i) assert(wrap_lon_deg(huge[i], &out) && out == expected_wrap(huge[i]));
    /* integer-valued inputs up to 2^50: lon - result is an exact multiple of 360. */
    for (int64_t k = -(INT64_C(1) << 50); k <= (INT64_C(1) << 50); k += (INT64_C(1) << 50) / 997 + 1) {
        double lon = (double)k; assert(wrap_lon_deg(lon, &out) && out >= -180.0 && out < 180.0);
        assert(fmod(lon - out, 360.0) == 0.0);
    }
    for (int k = -3000; k <= 3000; ++k) { double x = k * 0.37; assert(wrap_lon_deg(x, &out) && out >= -180.0 && out < 180.0); }
    out = SENTINEL;
    assert(lon_delta_deg(179, -179, &out) && out == 2.0);
    assert(lon_delta_deg(-179, 179, &out) && out == -2.0);
    assert(lon_delta_deg(0, 180, &out) && out == -180.0);
    assert(lon_delta_deg(180, -180, &out) && out == 0.0);
    assert(lon_delta_deg(10, 10, &out) && out == 0.0);
    out = SENTINEL;
    assert(!lon_delta_deg(-180.5, 0, &out) && !lon_delta_deg(0, 180.5, &out) && !lon_delta_deg(NAN, 0, &out) && !lon_delta_deg(0, INFINITY, &out));
    assert(out == SENTINEL);
    for (int k = -486; k <= 486; ++k) {
        double x = k * 0.37; if (x == 0.0) continue;
        assert(within_rel(rad_to_deg(deg_to_rad(x)), x, TOL_DEG_RAD_REL, 0.0));
    }
    assert(deg_to_rad(0.0) == 0.0 && rad_to_deg(0.0) == 0.0);
    assert(within_rel(deg_to_rad(180.0), GEO_PI, 4e-16, 0.0));
    /* exact quadrants, exact symmetry */
    static const double axes[] = {0, 90, 180, 270, 360, 450, 9.0e15, 1e14 * 90.0};
    static const double sines[] = {0, 1, 0, -1, 0, 1, 0, 0};
    static const double cosines[] = {1, 0, -1, 0, 1, 0, 1, 1};
    for (size_t i = 0; i < sizeof axes / sizeof axes[0]; ++i) {
        double s = SENTINEL, c = SENTINEL, sn = SENTINEL, cn = SENTINEL;
        assert(sin_deg(axes[i], &s) && cos_deg(axes[i], &c) && sin_deg(-axes[i], &sn) && cos_deg(-axes[i], &cn));
        assert(s == sines[i] && c == cosines[i] && sn == -sines[i] && cn == cosines[i]);
        assert(!signbit(s) || s != 0.0); /* zero results are +0.0 so that printing shows "0" */
    }
    assert(sin_deg(-0.0, &out) && out == 0.0 && !signbit(out));
    for (int k = -1948; k <= 1948; ++k) {
        double x = k * 0.37, a, b, c, d;
        assert(sin_deg(x, &a) && sin_deg(-x, &b) && cos_deg(x, &c) && cos_deg(-x, &d));
        assert(a == -b && c == d && fabs(a) <= 1.0 && fabs(c) <= 1.0);
    }
    { double s, c;
      assert(sin_deg(30, &s) && fabs(s - 0.5) <= TOL_SIN_REF_ABS);
      assert(sin_deg(45, &s) && fabs(s - sqrt(0.5)) <= TOL_SIN_REF_ABS);
      assert(sin_deg(60, &s) && fabs(s - sqrt(0.75)) <= TOL_SIN_REF_ABS);
      assert(cos_deg(60, &c) && fabs(c - 0.5) <= TOL_SIN_REF_ABS);
      assert(cos_deg(30, &c) && fabs(c - sqrt(0.75)) <= TOL_SIN_REF_ABS); }
    for (int k = -1948; k <= 1948; ++k) { /* against a long double reference */
        double x = k * 0.37, s, c; long double ref = (long double)x * 3.14159265358979323846264338327950288L / 180.0L;
        assert(sin_deg(x, &s) && cos_deg(x, &c));
        assert(fabsl((long double)s - sinl(ref)) <= TOL_SIN_LATTICE_ABS && fabsl((long double)c - cosl(ref)) <= TOL_SIN_LATTICE_ABS);
    }
    out = SENTINEL;
    assert(!sin_deg(NAN, &out) && !cos_deg(INFINITY, &out) && !sin_deg(-INFINITY, &out) && !cos_deg(0, NULL) && out == SENTINEL);
#if GEO_IEC559
    { double s = sin(GEO_PI); assert(s > 0.0 && s < 1e-15); } /* GEO_PI is below pi: an observation, not a digit string */
#endif
}
#endif

#if EXERCISE == 4 || EXERCISE == 7
static void check_vectors(void)
{
    for (int ax = -2; ax <= 2; ++ax) for (int ay = -2; ay <= 2; ++ay) for (int az = -2; az <= 2; ++az)
    for (int bx = -2; bx <= 2; ++bx) for (int by = -2; by <= 2; ++by) for (int bz = -2; bz <= 2; ++bz) {
        Vec3 a = {ax, ay, az}, b = {bx, by, bz}, c = vec3_cross(a, b);
        assert(vec3_dot(a, c) == 0.0 && vec3_dot(b, c) == 0.0);
        assert(vec3_dot(a, b) == vec3_dot(b, a));
    }
    { Vec3 x = {1, 0, 0}, y = {0, 1, 0}, z = vec3_cross(x, y); assert(z.x == 0 && z.y == 0 && z.z == 1); }
    double len = SENTINEL; Vec3 n = {SENTINEL, SENTINEL, SENTINEL};
    Vec3 zero = {0, 0, 0};
    assert(vec3_length(zero, &len) && len == 0.0);
    { Vec3 v = {3, 4, 12}; assert(vec3_length(v, &len) && within_rel(len, 13.0, TOL_UNIT_LENGTH * 4, 0.0)); }
    { Vec3 v = {1e200, 1e200, 0}; assert(vec3_length(v, &len) && isfinite(len) && within_rel(len, 1e200 * sqrt(2.0), 1e-15, 0.0)); }
    { Vec3 v = {DBL_MAX, 0, 0}; assert(vec3_length(v, &len) && len == DBL_MAX); }
    { Vec3 v = {1e-200, 0, 0}; assert(vec3_length(v, &len) && len == 1e-200); }
    len = SENTINEL;
    { Vec3 v = {DBL_MAX, DBL_MAX, 0}; assert(!vec3_length(v, &len) && len == SENTINEL); }
    { Vec3 v = {NAN, 0, 0}, w = {0, INFINITY, 0}; assert(!vec3_length(v, &len) && !vec3_length(w, &len) && len == SENTINEL); }
    assert(!vec3_length(zero, NULL));
    static const Vec3 extreme[] = {{1e200, 1e200, 0}, {1e-200, 0, 0}, {1e-320, 1e-320, 0}, {DBL_MAX, DBL_MAX, 0},
                                   {DBL_MAX, -DBL_MAX, DBL_MAX}, {3, 4, 12}, {0, 0, -5}, {DBL_TRUE_MIN, 0, 0}};
    for (size_t i = 0; i < sizeof extreme / sizeof extreme[0]; ++i) {
        assert(vec3_normalize(extreme[i], &n));
        double l = SENTINEL; assert(vec3_length(n, &l) && fabs(l - 1.0) <= TOL_UNIT_LENGTH);
    }
    { Vec3 v = {1e-320, 1e-320, 0}; assert(vec3_normalize(v, &n) && fabs(n.x - sqrt(0.5)) < 1e-15 && n.x == n.y && n.z == 0.0); }
    { Vec3 v = {0, 0, -5}; assert(vec3_normalize(v, &n) && n.x == 0.0 && n.y == 0.0 && n.z == -1.0); }
    n.x = n.y = n.z = SENTINEL;
    { Vec3 z0 = {0, 0, 0}, nan = {0, NAN, 1}, inf = {INFINITY, 0, 0}; assert(!vec3_normalize(z0, &n) && !vec3_normalize(nan, &n) && !vec3_normalize(inf, &n)); }
    { Vec3 v = {1, 0, 0}; assert(!vec3_normalize(v, NULL)); }
    assert(n.x == SENTINEL && n.y == SENTINEL && n.z == SENTINEL);
    /* poles and axes are exact */
    static const double lons[] = {-180, -120, -45, 0, 45, 90, 180};
    for (size_t i = 0; i < sizeof lons / sizeof lons[0]; ++i) {
        assert(latlon_to_unit(90, lons[i], &n) && n.x == 0.0 && n.y == 0.0 && n.z == 1.0);
        assert(latlon_to_unit(-90, lons[i], &n) && n.x == 0.0 && n.y == 0.0 && n.z == -1.0);
    }
    assert(latlon_to_unit(0, 0, &n) && n.x == 1.0 && n.y == 0.0 && n.z == 0.0);
    assert(latlon_to_unit(0, 90, &n) && n.x == 0.0 && n.y == 1.0 && n.z == 0.0);
    assert(latlon_to_unit(0, -90, &n) && n.x == 0.0 && n.y == -1.0 && n.z == 0.0);
    assert(latlon_to_unit(0, 180, &n) && n.x == -1.0 && n.y == 0.0 && n.z == 0.0);
    n.x = n.y = n.z = SENTINEL;
    assert(!latlon_to_unit(90.0000001, 0, &n) && !latlon_to_unit(-91, 0, &n) && !latlon_to_unit(0, 180.5, &n) && !latlon_to_unit(0, -181, &n)
           && !latlon_to_unit(NAN, 0, &n) && !latlon_to_unit(0, INFINITY, &n) && !latlon_to_unit(0, 0, NULL));
    assert(n.x == SENTINEL && n.y == SENTINEL && n.z == SENTINEL);
    for (int la = -85; la <= 85; la += 5) for (int lo = -175; lo <= 175; lo += 5) {
        double lat, lon, d;
        assert(latlon_to_unit(la, lo, &n) && fabs(vec3_dot(n, n) - 1.0) <= TOL_UNIT_LENGTH);
        assert(unit_to_latlon(n, &lat, &lon) && fabs(lat - la) <= TOL_ROUNDTRIP_DEG);
        d = lon - lo; if (d > 180.0) d -= 360.0; if (d < -180.0) d += 360.0; /* wrapped difference, local to this test */
        assert(fabs(d) <= TOL_ROUNDTRIP_DEG);
    }
    { double lat = SENTINEL, lon = SENTINEL; Vec3 up = {0, 0, 1}, down = {0, 0, -5}, e1 = {1, 0, 0}, wx = {-1, 0, 0}, e2 = {0, 2, 0};
      assert(unit_to_latlon(up, &lat, &lon) && lat == 90.0 && lon == 0.0);
      assert(unit_to_latlon(down, &lat, &lon) && lat == -90.0 && lon == 0.0);
      assert(unit_to_latlon(e1, &lat, &lon) && lat == 0.0 && lon == 0.0);
      assert(unit_to_latlon(wx, &lat, &lon) && lat == 0.0 && lon == -180.0); /* half-open longitude policy */
      assert(unit_to_latlon(e2, &lat, &lon) && lat == 0.0 && fabs(lon - 90.0) <= TOL_ROUNDTRIP_DEG);
      Vec3 big = {DBL_MAX, DBL_MAX, 0};
      assert(unit_to_latlon(big, &lat, &lon) && fabs(lat) <= TOL_ROUNDTRIP_DEG && fabs(lon - 45.0) <= TOL_ROUNDTRIP_DEG);
      /* Scaling can round both horizontal components to zero; original nonzero x/y still determine longitude. */
      static const struct { Vec3 v; double want_lon; } near_poles[] = {
          {{1e-200, 1e-200, 1e200}, 45.0},
          {{1e-200, -1e-200, 1e200}, -45.0},
          {{-1e-200, 1e-200, 1e200}, 135.0},
          {{1e-200, 1e-200, -1e200}, 45.0},
          {{DBL_TRUE_MIN, DBL_TRUE_MIN, DBL_MAX}, 45.0}
      };
      for (size_t i = 0; i < sizeof near_poles / sizeof near_poles[0]; ++i) {
          assert(unit_to_latlon(near_poles[i].v, &lat, &lon));
          assert(isfinite(lat) && fabs(lat) <= 90.0 && fabs(lon - near_poles[i].want_lon) <= TOL_ROUNDTRIP_DEG);
          assert(near_poles[i].v.z > 0.0 ? lat > 0.0 : lat < 0.0);
      }
      lat = lon = SENTINEL;
      Vec3 z0 = {0, 0, 0}, bad = {NAN, 0, 1};
      assert(!unit_to_latlon(z0, &lat, &lon) && !unit_to_latlon(bad, &lat, &lon) && !unit_to_latlon(up, NULL, &lon) && !unit_to_latlon(up, &lat, NULL));
      assert(lat == SENTINEL && lon == SENTINEL); }
}
#endif

#if EXERCISE == 5 || EXERCISE == 7
#if EXERCISE == 7
#define HAV geo_distance_km
#define VEC geo_distance_km_vector
#else
#define HAV haversine_km
#define VEC vector_distance_km
#endif
static void check_distance(void)
{
    const double R = GEO_EARTH_RADIUS_KM, kpd = R * (GEO_PI / 180.0), one_km_deg = 180.0 / (GEO_PI * R);
    const struct { double a, b, c, d, expected; } cs[] = {
        {40.0, 33.25, 40.0, 33.25, 0.0}, {0, 0, 0, 1e-5, 1e-5 * kpd}, {0, 0, one_km_deg, 0, 1.0},
        {0, 0, 90, 0, R * (GEO_PI / 2.0)}, {0, 0, 0, 180, R * GEO_PI}, {0, 179.5, 0, -179.5, kpd}};
    for (size_t i = 0; i < sizeof cs / sizeof cs[0]; ++i) {
        double h = SENTINEL, v = SENTINEL;
        assert(HAV(cs[i].a, cs[i].b, cs[i].c, cs[i].d, &h) && VEC(cs[i].a, cs[i].b, cs[i].c, cs[i].d, &v));
        assert(within_rel(h, cs[i].expected, TOL_DIST_REL, TOL_DIST_ABS_KM) && within_rel(v, cs[i].expected, TOL_DIST_REL, TOL_DIST_ABS_KM));
    }
    { double h, v; assert(HAV(40.0, 33.25, 40.0, 33.25, &h) && VEC(40.0, 33.25, 40.0, 33.25, &v) && h == 0.0 && v == 0.0); }
    enum { N = 13, M = N * N };
    static double lat[M], lon[M], h[M][M], v[M][M];
    for (int i = 0; i < N; ++i) for (int j = 0; j < N; ++j) { lat[i * N + j] = -90.0 + 15.0 * i; lon[i * N + j] = -180.0 + 30.0 * j; }
    const double max_km = GEO_PI * R * (1.0 + 1e-15);
    for (int a = 0; a < M; ++a) for (int b = 0; b < M; ++b) {
        assert(HAV(lat[a], lon[a], lat[b], lon[b], &h[a][b]) && VEC(lat[a], lon[a], lat[b], lon[b], &v[a][b]));
        assert(!isnan(h[a][b]) && !isnan(v[a][b]) && h[a][b] >= 0.0 && v[a][b] >= 0.0 && h[a][b] <= max_km && v[a][b] <= max_km);
    }
    for (int a = 0; a < M; ++a) for (int b = 0; b < M; ++b) {
        assert(fabs(h[a][b] - h[b][a]) <= TOL_SYMMETRY_KM && fabs(v[a][b] - v[b][a]) <= TOL_SYMMETRY_KM);
        for (int c = 0; c < M; ++c) assert(h[a][c] <= h[a][b] + h[b][c] + TOL_TRIANGLE_KM && v[a][c] <= v[a][b] + v[b][c] + TOL_TRIANGLE_KM);
    }
    for (int a = 0; a < M; ++a) for (int i = 0; i < N; ++i) {
        double p, q, la = -90.0 + 15.0 * i;
        assert(HAV(la, 180, lat[a], lon[a], &p) && HAV(la, -180, lat[a], lon[a], &q) && fabs(p - q) <= TOL_ANTIMERIDIAN_KM);
        assert(VEC(la, 180, lat[a], lon[a], &p) && VEC(la, -180, lat[a], lon[a], &q) && fabs(p - q) <= TOL_ANTIMERIDIAN_KM);
    }
    /* Exact antipodes (L,0)-(-L,180) for integer L: the haversine sum a = sin^2 + cos^2 rounds above 1 for some L (8, 12, 82 on the
       reference platform), which is NaN without the clamp. The haversine result is finite but only accurate to about 1e-8 relative here
       (a rounds below 1 for other L); the vector formulation stays accurate. Both bounds are measured, not derived from a general theorem. */
    for (int L = 0; L <= 90; ++L) {
        double hh = SENTINEL, vv = SENTINEL;
        assert(HAV(L, 0, -L, 180, &hh) && VEC(L, 0, -L, 180, &vv) && !isnan(hh) && !isnan(vv));
        assert(within_rel(hh, GEO_PI * R, 2e-8, 0.0) && within_rel(vv, GEO_PI * R, 1e-12, 0.0));
    }
    double out = SENTINEL;
    static const double bad[][4] = {{90.5, 0, 0, 0}, {0, 0, -90.5, 0}, {0, 180.5, 0, 0}, {0, 0, 0, -180.5}, {NAN, 0, 0, 0}, {0, 0, 0, INFINITY}, {0, -INFINITY, 0, 0}};
    for (size_t i = 0; i < sizeof bad / sizeof bad[0]; ++i) {
        assert(!HAV(bad[i][0], bad[i][1], bad[i][2], bad[i][3], &out) && !VEC(bad[i][0], bad[i][1], bad[i][2], bad[i][3], &out));
#if EXERCISE == 5
        assert(!cosines_distance_km(bad[i][0], bad[i][1], bad[i][2], bad[i][3], &out));
#endif
    }
    assert(out == SENTINEL && !HAV(0, 0, 0, 0, NULL) && !VEC(0, 0, 0, 0, NULL));
#if EXERCISE == 5
    /* The law of cosines is asserted only to be finite and nonnegative; its error is recorded, not bounded. */
    for (int a = 0; a < M; ++a) for (int b = 0; b < M; ++b) {
        double c = SENTINEL; assert(cosines_distance_km(lat[a], lon[a], lat[b], lon[b], &c) && isfinite(c) && c >= 0.0);
    }
    { double c; assert(!cosines_distance_km(0, 0, 0, 0, NULL) && cosines_distance_km(0, 0, 0, 180, &c) && within_rel(c, GEO_PI * R, 1e-9, 0.0)); }
#endif
}
#endif

#if EXERCISE == 6 || EXERCISE == 7
/* ---- independent integer oracle (CLRS orientation tests + rational intersection), lattice {0,1,2}^2 ---- */
typedef struct { long x, y; } IPt;
static long icross(IPt a, IPt b, IPt c) { return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x); }
static int isign(long v) { return (v > 0) - (v < 0); }
static int on_seg(IPt a, IPt b, IPt p)
{
    return icross(a, b, p) == 0 && p.x >= (a.x < b.x ? a.x : b.x) && p.x <= (a.x > b.x ? a.x : b.x)
        && p.y >= (a.y < b.y ? a.y : b.y) && p.y <= (a.y > b.y ? a.y : b.y);
}
static int ilex(IPt a, IPt b) { return a.x < b.x || (a.x == b.x && a.y < b.y); }
static int ieq(IPt a, IPt b) { return a.x == b.x && a.y == b.y; }
static int clrs_intersects(IPt p0, IPt p1, IPt q0, IPt q1)
{
    int d1 = isign(icross(q0, q1, p0)), d2 = isign(icross(q0, q1, p1)), d3 = isign(icross(p0, p1, q0)), d4 = isign(icross(p0, p1, q1));
    if (d1 * d2 < 0 && d3 * d4 < 0) return 1;
    return on_seg(q0, q1, p0) || on_seg(q0, q1, p1) || on_seg(p0, p1, q0) || on_seg(p0, p1, q1);
}
static void check_segments_against_oracle(void)
{
    long kinds[3] = {0, 0, 0};
    for (int s1 = 0; s1 < 81; ++s1) for (int s2 = 0; s2 < 81; ++s2) {
        IPt P0 = {s1 % 3, (s1 / 3) % 3}, P1 = {(s1 / 9) % 3, s1 / 27}, Q0 = {s2 % 3, (s2 / 3) % 3}, Q1 = {(s2 / 9) % 3, s2 / 27};
        Vec2 p0 = {(double)P0.x, (double)P0.y}, p1 = {(double)P1.x, (double)P1.y}, q0 = {(double)Q0.x, (double)Q0.y}, q1 = {(double)Q1.x, (double)Q1.y};
        SegResult r; assert(segment_intersect(p0, p1, q0, q1, &r));
        long den = (P1.x - P0.x) * (Q1.y - Q0.y) - (P1.y - P0.y) * (Q1.x - Q0.x);
        if (!clrs_intersects(P0, P1, Q0, Q1)) { assert(r.kind == SEG_NONE); ++kinds[0]; continue; }
        if (den != 0) {
            long tn = (Q0.x - P0.x) * (Q1.y - Q0.y) - (Q0.y - P0.y) * (Q1.x - Q0.x);
            double ex = (double)(P0.x * den + tn * (P1.x - P0.x)) / (double)den, ey = (double)(P0.y * den + tn * (P1.y - P0.y)) / (double)den;
            assert(r.kind == SEG_POINT && r.a.x == r.b.x && r.a.y == r.b.y);
            assert(fabs(r.a.x - ex) <= TOL_CROSSING_ABS && fabs(r.a.y - ey) <= TOL_CROSSING_ABS);
            /* integer and half-integer intersections are representable, so they must be exact */
            if (fmod(2.0 * ex, 1.0) == 0.0 && fmod(2.0 * ey, 1.0) == 0.0) assert(r.a.x == ex && r.a.y == ey);
            ++kinds[1]; continue;
        }
        IPt lo = {9, 9}, hi = {-9, -9}; int have = 0;
        IPt pts[4] = {P0, P1, Q0, Q1};
        for (int i = 0; i < 4; ++i) if (on_seg(P0, P1, pts[i]) && on_seg(Q0, Q1, pts[i])) {
            if (!have || ilex(pts[i], lo)) lo = pts[i];
            if (!have || ilex(hi, pts[i])) hi = pts[i];
            have = 1;
        }
        assert(have);
        if (ieq(lo, hi)) { assert(r.kind == SEG_POINT && r.a.x == lo.x && r.a.y == lo.y && r.b.x == lo.x && r.b.y == lo.y); ++kinds[1]; }
        else { assert(r.kind == SEG_OVERLAP && r.a.x == lo.x && r.a.y == lo.y && r.b.x == hi.x && r.b.y == hi.y); ++kinds[2]; }
    }
    /* the oracle must actually have exercised every branch */
    assert(kinds[0] > 0 && kinds[1] > 0 && kinds[2] > 0 && kinds[0] + kinds[1] + kinds[2] == 6561);
}
static void check_segments(void)
{
    check_segments_against_oracle();
    SegResult r = {SEG_OVERLAP, {SENTINEL, SENTINEL}, {SENTINEL, SENTINEL}};
    /* Small boundary examples: one point lies on a segment; two distinct point segments do not meet. */
    { Vec2 point = {1, 1}, a = {0, 0}, b = {2, 2}, other = {2, 1};
      assert(segment_intersect(point, point, a, b, &r) && r.kind == SEG_POINT
             && r.a.x == 1.0 && r.a.y == 1.0 && r.b.x == 1.0 && r.b.y == 1.0);
      assert(segment_intersect(point, point, other, other, &r) && r.kind == SEG_NONE
             && r.a.x == 0.0 && r.a.y == 0.0 && r.b.x == 0.0 && r.b.y == 0.0); }
    const double L = 33554432.0;
    { Vec2 a = {-L, -L}, b = {L, L}, c = {-L, L}, d = {L, -L};
      assert(segment_intersect(a, b, c, d, &r) && r.kind == SEG_POINT && r.a.x == 0.0 && r.a.y == 0.0); }
    r.kind = SEG_OVERLAP; r.a.x = r.a.y = r.b.x = r.b.y = SENTINEL;
    { Vec2 ok = {0, 0}, over = {L + 1.0, 0}, nan = {NAN, 0}, inf = {0, INFINITY}, neg = {-L - 1.0, 0};
      assert(!segment_intersect(ok, over, ok, ok, &r) && !segment_intersect(ok, ok, nan, ok, &r) && !segment_intersect(ok, ok, ok, inf, &r)
             && !segment_intersect(neg, ok, ok, ok, &r) && !segment_intersect(ok, ok, ok, ok, NULL));
      assert(r.kind == SEG_OVERLAP && r.a.x == SENTINEL && r.b.y == SENTINEL); }
    /* endpoints are returned exactly, and argument order does not change the classification */
    { Vec2 a = {0.1, 0.3}, b = {0.7, 0.9}, c = {0.7, 0.9}, d = {5.5, -2.25};
      assert(segment_intersect(a, b, c, d, &r) && r.kind == SEG_POINT && r.a.x == 0.7 && r.a.y == 0.9);
      assert(segment_intersect(b, a, d, c, &r) && r.kind == SEG_POINT && r.a.x == 0.7 && r.a.y == 0.9); }
    /* T-junction with non-integer coordinates: p0 lies on q, the numerator test is exactly zero, and *recomputing* the point
       from the parametric formula would give (0.2, 2.3000000000000003). The endpoint must be returned as given. */
    { Vec2 a = {0.2, 2.3}, b = {1.4, -1.3}, c = {-0.8, 2.3}, d = {1.2, 2.3};
      assert(segment_intersect(a, b, c, d, &r) && r.kind == SEG_POINT && r.a.x == 0.2 && r.a.y == 2.3 && r.b.x == 0.2 && r.b.y == 2.3); }
    /* non-integer crossing: swapping roles gives the same point within the documented tolerance */
    { Vec2 a = {0, 0}, b = {3, 1}, c = {0, 1}, d = {3, 0}; SegResult s, t;
      assert(segment_intersect(a, b, c, d, &s) && segment_intersect(c, d, a, b, &t) && s.kind == SEG_POINT && t.kind == SEG_POINT);
      assert(fabs(s.a.x - t.a.x) <= TOL_CROSSING_ABS && fabs(s.a.y - t.a.y) <= TOL_CROSSING_ABS && fabs(s.a.x - 1.5) <= TOL_CROSSING_ABS); }
    /* no NaN can escape from the parallel branch */
    { Vec2 a = {0, 0}, b = {1, 1}, c = {2, 2}, d = {3, 3}; assert(segment_intersect(a, b, c, d, &r) && r.kind == SEG_NONE && !isnan(r.a.x)); }
}
#endif

int main(void)
{
    (void)same_bits; (void)within_rel; /* helpers are not used by every exercise build */
#if EXERCISE == 1
    DoubleParts p = {7, 7, 7, FP_CLASS_NAN}; double d = SENTINEL;
#if GEO_IEC559
    static const struct { double v; unsigned s, e; uint64_t f; DoubleClass k; } t[] = {
        {1.0, 0, 1023, 0, FP_CLASS_NORMAL}, {0.5, 0, 1022, 0, FP_CLASS_NORMAL}, {-2.0, 1, 1024, 0, FP_CLASS_NORMAL},
        {0.1, 0, 1019, UINT64_C(0x999999999999A), FP_CLASS_NORMAL}, {0.0, 0, 0, 0, FP_CLASS_ZERO}, {-0.0, 1, 0, 0, FP_CLASS_ZERO},
        {DBL_MIN, 0, 1, 0, FP_CLASS_NORMAL}, {DBL_TRUE_MIN, 0, 0, 1, FP_CLASS_SUBNORMAL},
        {DBL_MAX, 0, 2046, (UINT64_C(1) << 52) - 1, FP_CLASS_NORMAL}, {INFINITY, 0, 2047, 0, FP_CLASS_INFINITE},
        {-INFINITY, 1, 2047, 0, FP_CLASS_INFINITE}, {0.75, 0, 1022, UINT64_C(1) << 51, FP_CLASS_NORMAL},
        {-6.5, 1, 1025, UINT64_C(0xA000000000000), FP_CLASS_NORMAL}};
    for (size_t i = 0; i < sizeof t / sizeof t[0]; ++i) {
        assert(decompose_double(t[i].v, &p) && p.sign == t[i].s && p.exponent == t[i].e && p.fraction == t[i].f && p.kind == t[i].k);
        assert(compose_double(p.sign, p.exponent, p.fraction, &d) && same_bits(d, t[i].v));
    }
    assert(decompose_double(NAN, &p) && p.kind == FP_CLASS_NAN && p.exponent == 2047 && p.fraction != 0); /* payload and sign not asserted */
    assert(compose_double(p.sign, p.exponent, p.fraction, &d) && same_bits(d, NAN));
    assert(decompose_double(-0.0, &p) && p.sign == 1 && -0.0 == 0.0);
    { double sub; assert(compose_double(0, 0, (UINT64_C(1) << 52) - 1, &sub) && sub < DBL_MIN && nextafter(sub, INFINITY) == DBL_MIN); }
    p.sign = p.exponent = 7; p.fraction = 7; p.kind = FP_CLASS_NAN; d = SENTINEL;
    assert(!compose_double(2, 0, 0, &d) && !compose_double(0, 0x800, 0, &d) && !compose_double(0, 0, UINT64_C(1) << 52, &d)
           && !compose_double(0, 1, 0, NULL) && d == SENTINEL);
    assert(!decompose_double(1.0, NULL));
    assert(p.sign == 7 && p.exponent == 7 && p.fraction == 7 && p.kind == FP_CLASS_NAN);
    puts("binary64 checks passed");
#else
    assert(!decompose_double(1.0, &p) && p.sign == 7 && p.fraction == 7);
    assert(!compose_double(0, 1023, 0, &d) && d == SENTINEL);
    puts("binary64 checks skipped");
#endif
#elif EXERCISE == 2
    check_approx_equal();
#if GEO_IEC559
    uint64_t u = 77;
    static const double vals[] = {0.0, -0.0, 1.0, -1.0, 1e-300, 1e300, 0.1, 0.3, DBL_MAX, -DBL_MAX, DBL_MIN, DBL_TRUE_MIN, INFINITY, -INFINITY, NAN};
    for (size_t i = 0; i < sizeof vals / sizeof vals[0]; ++i) for (size_t j = 0; j < sizeof vals / sizeof vals[0]; ++j) {
        uint64_t a = 1, b = 2;
        int ok1 = ulp_distance(vals[i], vals[j], &a), ok2 = ulp_distance(vals[j], vals[i], &b);
        assert(ok1 == ok2 && ok1 == (isfinite(vals[i]) && isfinite(vals[j])) && (!ok1 || a == b));
    }
    static const double xs[] = {1.0, -1.0, 1e-300, 1e300, 0.1, -0.1, DBL_MIN, -DBL_MIN, 12345.6789};
    for (size_t i = 0; i < sizeof xs / sizeof xs[0]; ++i) {
        assert(ulp_distance(xs[i], nextafter(xs[i], INFINITY), &u) && u == 1);
        assert(ulp_distance(xs[i], nextafter(xs[i], -INFINITY), &u) && u == 1);
        assert(ulp_distance(xs[i], xs[i], &u) && u == 0);
    }
    assert(ulp_distance(0.0, DBL_TRUE_MIN, &u) && u == 1 && ulp_distance(-0.0, DBL_TRUE_MIN, &u) && u == 1 && ulp_distance(-DBL_TRUE_MIN, 0.0, &u) && u == 1);
    assert(ulp_distance(-DBL_TRUE_MIN, DBL_TRUE_MIN, &u) && u == 2);
    assert(ulp_distance(-0.0, 0.0, &u) && u == 0);
    assert(ulp_distance(-1.0, 1.0, &u) && u == UINT64_C(0x7FE0000000000000));
    assert(ulp_distance(-DBL_MAX, DBL_MAX, &u) && u == UINT64_C(0xFFDFFFFFFFFFFFFE));
    u = 77;
    assert(!ulp_distance(NAN, 1, &u) && !ulp_distance(1, INFINITY, &u) && !ulp_distance(-INFINITY, 1, &u) && !ulp_distance(1, 1, NULL) && u == 77);
    assert(ulp_distance(add3_left(0.1, 0.2, 0.3), add3_right(0.1, 0.2, 0.3), &u) && u == 1);
    { double sum = 0.1 + 0.2, target = 0.3; assert(ulp_distance(sum, target, &u) && u == 1 && sum != target); }
    assert(add3_left(1e16, -1e16, 1.0) == 1.0 && add3_right(1e16, -1e16, 1.0) != 1.0); /* not associative */
    puts("ieee754 checks passed");
#else
    uint64_t u = 77;
    assert(!ulp_distance(1.0, 2.0, &u) && u == 77);
    puts("ieee754 checks skipped");
#endif
    assert(add3_left(1, 2, 3) == 6.0 && add3_right(1, 2, 3) == 6.0);
#elif EXERCISE == 3
    check_angles();
#elif EXERCISE == 4
    check_vectors();
#elif EXERCISE == 5
    check_distance();
#elif EXERCISE == 6
    check_segments();
#elif EXERCISE == 7
    check_angles();
    check_vectors();
    check_distance();
    check_segments();
    check_approx_equal();
#endif
    puts("contract passed");
    return 0;
}
