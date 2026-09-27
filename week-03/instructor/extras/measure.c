/* Records the maximum observed errors that justify the tolerances in tests/tolerances.h.
   Prints `metric=NAME max=VALUE tolerance=VALUE ratio=TOLERANCE/MAX` and fails if any maximum exceeds
   its tolerance. Values are measurements on one machine, never universal constants. */
#include <float.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "geomath.h"
#include "tolerances.h"

static int failed;
static void report(const char *name, double max, double tol)
{
    printf("metric=%s max=%.3e tolerance=%.1e ratio=%.3g\n", name, max, tol, max > 0 ? tol / max : INFINITY);
    if (!(max <= tol)) { failed = 1; }
}
static double dmax(double a, double b) { return a > b ? a : b; }

/* The law of cosines, copied from E05 so the recorded (not asserted) error can be printed here. */
static double cosines_km(double lat1, double lon1, double lat2, double lon2)
{
    double p1 = deg_to_rad(lat1), p2 = deg_to_rad(lat2);
    double c = sin(p1) * sin(p2) + cos(p1) * cos(p2) * cos(deg_to_rad(lon2 - lon1));
    return acos(c < -1.0 ? -1.0 : (c > 1.0 ? 1.0 : c)) * GEO_EARTH_RADIUS_KM;
}

int main(void)
{
    const long double LPI = 3.14159265358979323846264338327950288L;
    double worst = 0, worst2 = 0;

    /* M1: degree/radian round trip. */
    for (int k = -486; k <= 486; ++k) {
        double x = k * 0.37, back = rad_to_deg(deg_to_rad(x));
        if (x != 0.0) worst = dmax(worst, fabs(back - x) / fabs(x));
    }
    report("deg_rad_roundtrip_rel", worst, TOL_DEG_RAD_REL);

    /* M2: sin_deg/cos_deg vs exact references and a long double reference on a lattice. */
    worst = 0;
    { double s, c;
      sin_deg(30.0, &s); worst = dmax(worst, fabs(s - 0.5));
      sin_deg(45.0, &s); worst = dmax(worst, fabs(s - sqrt(0.5)));
      sin_deg(60.0, &s); worst = dmax(worst, fabs(s - sqrt(0.75)));
      cos_deg(60.0, &c); worst = dmax(worst, fabs(c - 0.5));
      cos_deg(45.0, &c); worst = dmax(worst, fabs(c - sqrt(0.5)));
      cos_deg(30.0, &c); worst = dmax(worst, fabs(c - sqrt(0.75))); }
    report("sin_cos_deg_known_abs", worst, TOL_SIN_REF_ABS);
    worst = 0;
    for (int k = -1948; k <= 1948; ++k) {
        double x = k * 0.37, s, c;
        sin_deg(x, &s); cos_deg(x, &c);
        long double ref = (long double)x * LPI / 180.0L;
        worst = dmax(worst, fabs((double)((long double)s - sinl(ref))));
        worst = dmax(worst, fabs((double)((long double)c - cosl(ref))));
    }
    report("sin_cos_deg_lattice_abs", worst, TOL_SIN_LATTICE_ABS);

    /* M3: normalization length. */
    worst = 0;
    { Vec3 vs[] = {{1e200, 1e200, 0}, {1e-200, 0, 0}, {1e-320, 1e-320, 0}, {DBL_MAX, DBL_MAX, 0}, {3, 4, 12}, {1, 2, 3}, {-7, 0.5, 1e-3}};
      for (size_t i = 0; i < sizeof vs / sizeof vs[0]; ++i) {
          Vec3 n; double len;
          if (!vec3_normalize(vs[i], &n) || !vec3_length(n, &len)) { puts("normalize failed"); return 1; }
          worst = dmax(worst, fabs(len - 1.0));
      } }
    report("normalize_length_error", worst, TOL_UNIT_LENGTH);

    /* M4: lat/lon -> unit -> lat/lon. */
    worst = 0; worst2 = 0;
    for (int la = -85; la <= 85; la += 5) for (int lo = -175; lo <= 175; lo += 5) {
        Vec3 v; double lat, lon, d;
        latlon_to_unit(la, lo, &v); unit_to_latlon(v, &lat, &lon);
        worst = dmax(worst, fabs(lat - la));
        lon_delta_deg(lo, lon, &d); worst2 = dmax(worst2, fabs(d));
    }
    report("roundtrip_lat_deg", worst, TOL_ROUNDTRIP_DEG);
    report("roundtrip_lon_deg", worst2, TOL_ROUNDTRIP_DEG);

    /* M5: lattice properties of both formulations. */
    enum { N = 13 };
    static double hv[N * N][N * N], vc[N * N][N * N], lat[N * N], lon[N * N];
    for (int i = 0; i < N; ++i) for (int j = 0; j < N; ++j) { lat[i * N + j] = -90.0 + 15.0 * i; lon[i * N + j] = -180.0 + 30.0 * j; }
    double sym_h = 0, sym_v = 0, tri_h = 0, tri_v = 0, cross_formulas = 0;
    for (int a = 0; a < N * N; ++a) for (int b = 0; b < N * N; ++b) {
        geo_distance_km(lat[a], lon[a], lat[b], lon[b], &hv[a][b]);
        geo_distance_km_vector(lat[a], lon[a], lat[b], lon[b], &vc[a][b]);
    }
    for (int a = 0; a < N * N; ++a) for (int b = 0; b < N * N; ++b) {
        sym_h = dmax(sym_h, fabs(hv[a][b] - hv[b][a]));
        sym_v = dmax(sym_v, fabs(vc[a][b] - vc[b][a]));
        cross_formulas = dmax(cross_formulas, fabs(hv[a][b] - vc[a][b]));
        for (int c = 0; c < N * N; ++c) {
            tri_h = dmax(tri_h, hv[a][c] - hv[a][b] - hv[b][c]);
            tri_v = dmax(tri_v, vc[a][c] - vc[a][b] - vc[b][c]);
        }
    }
    report("symmetry_haversine_km", sym_h, TOL_SYMMETRY_KM);
    report("symmetry_vector_km", sym_v, TOL_SYMMETRY_KM);
    report("triangle_haversine_km", tri_h, TOL_TRIANGLE_KM);
    report("triangle_vector_km", tri_v, TOL_TRIANGLE_KM);
    report("haversine_vs_vector_km", cross_formulas, 1e-6);

    /* M6: antimeridian: distance from (lat,180) and (lat,-180) to every lattice point. */
    double anti_h = 0, anti_v = 0;
    for (int a = 0; a < N * N; ++a) for (int i = 0; i < N; ++i) {
        double p, q;
        geo_distance_km(-90.0 + 15.0 * i, 180.0, lat[a], lon[a], &p); geo_distance_km(-90.0 + 15.0 * i, -180.0, lat[a], lon[a], &q);
        anti_h = dmax(anti_h, fabs(p - q));
        geo_distance_km_vector(-90.0 + 15.0 * i, 180.0, lat[a], lon[a], &p); geo_distance_km_vector(-90.0 + 15.0 * i, -180.0, lat[a], lon[a], &q);
        anti_v = dmax(anti_v, fabs(p - q));
    }
    report("antimeridian_haversine_km", anti_h, TOL_ANTIMERIDIAN_KM);
    report("antimeridian_vector_km", anti_v, TOL_ANTIMERIDIAN_KM);

    /* M7: segment crossing points on the 3x3 lattice vs exact rational. */
    double seg = 0;
    for (int s1 = 0; s1 < 81; ++s1) for (int s2 = 0; s2 < 81; ++s2) {
        Vec2 p0 = {s1 % 3, (s1 / 3) % 3}, p1 = {(s1 / 9) % 3, s1 / 27}, q0 = {s2 % 3, (s2 / 3) % 3}, q1 = {(s2 / 9) % 3, s2 / 27};
        SegResult r; segment_intersect(p0, p1, q0, q1, &r);
        if (r.kind != SEG_POINT) continue;
        double d1x = p1.x - p0.x, d1y = p1.y - p0.y, d2x = q1.x - q0.x, d2y = q1.y - q0.y;
        double den = d1x * d2y - d1y * d2x;
        if (den == 0) continue;
        double tn = (q0.x - p0.x) * d2y - (q0.y - p0.y) * d2x;
        long double ex = p0.x + (long double)tn * d1x / den, ey = p0.y + (long double)tn * d1y / den;
        seg = dmax(seg, (double)fabsl((long double)r.a.x - ex));
        seg = dmax(seg, (double)fabsl((long double)r.a.y - ey));
    }
    report("segment_crossing_abs", seg, TOL_CROSSING_ABS);

    /* M8: the E05 driver cases against their analytic references (cosines is recorded, not asserted). */
    { const double R = GEO_EARTH_RADIUS_KM, kpd = R * (GEO_PI / 180.0), one_km_deg = 180.0 / (GEO_PI * R);
      const struct { const char *name; double a, b, c, d, expected; } cs[] = {
        {"identical", 40.0, 33.25, 40.0, 33.25, 0.0}, {"one_metre_equator", 0, 0, 0, 1e-5, 1e-5 * kpd},
        {"one_km_meridian", 0, 0, one_km_deg, 0, 1.0}, {"quarter_meridian", 0, 0, 90, 0, R * (GEO_PI / 2.0)},
        {"half_circle", 0, 0, 0, 180, R * GEO_PI}, {"antimeridian_pair", 0, 179.5, 0, -179.5, kpd}};
      double worst_h = 0, worst_v = 0;
      for (size_t i = 0; i < sizeof cs / sizeof cs[0]; ++i) {
          double h, v, c = cosines_km(cs[i].a, cs[i].b, cs[i].c, cs[i].d);
          geo_distance_km(cs[i].a, cs[i].b, cs[i].c, cs[i].d, &h);
          geo_distance_km_vector(cs[i].a, cs[i].b, cs[i].c, cs[i].d, &v);
          double e = cs[i].expected, den = e != 0.0 ? fabs(e) : 1.0;
          printf("recorded case=%s abs_err_km haversine=%.3e vector=%.3e cosines=%.3e rel_err haversine=%.3e vector=%.3e cosines=%.3e\n",
                 cs[i].name, fabs(h - e), fabs(v - e), fabs(c - e), fabs(h - e) / den, fabs(v - e) / den, fabs(c - e) / den);
          worst_h = dmax(worst_h, fabs(h - e) / den); worst_v = dmax(worst_v, fabs(v - e) / den);
      }
      report("e05_haversine_rel_or_abs", worst_h, TOL_DIST_REL);
      report("e05_vector_rel_or_abs", worst_v, TOL_DIST_REL); }

    /* M9 (recorded, not asserted): does the haversine intermediate `a` exceed 1, and what does each final form do with it?
       (8, 0) and (-8, 180) are exact antipodes. Count how many integer latitudes L in 1..89 give a > 1 for (L,0)-(-L,180). */
    { int over = 0, nan_asin = 0, nan_atan2 = 0; double first_excess = 0; int first_L = 0;
      for (int L = 1; L <= 89; ++L) {
          double sl = sin(deg_to_rad(-2.0 * L) / 2.0), so = sin(deg_to_rad(180.0) / 2.0);
          double a = sl * sl + cos(deg_to_rad(L)) * cos(deg_to_rad(-L)) * so * so;
          if (a > 1.0) { if (!over) { first_L = L; first_excess = a - 1.0; } ++over; }
          if (isnan(asin(sqrt(a)))) ++nan_asin;
          if (isnan(2.0 * atan2(sqrt(a), sqrt(1.0 - a)))) ++nan_atan2;
      }
      printf("recorded haversine_intermediate_above_one: latitudes_with_a_gt_1=%d of 89 first_L=%d a_minus_1=%.3e nan_from_asin_sqrt=%d nan_from_atan2_form=%d\n",
             over, first_L, first_excess, nan_asin, nan_atan2); }

    /* M10 (recorded, not asserted): accuracy of each formulation at exact antipodes (L,0)-(-L,180), L = 0..90. */
    { double wh = 0, wv = 0; int lh = 0, lv = 0;
      for (int L = 0; L <= 90; ++L) {
          double h, v; geo_distance_km(L, 0, -L, 180, &h); geo_distance_km_vector(L, 0, -L, 180, &v);
          double eh = fabs(h - GEO_PI * GEO_EARTH_RADIUS_KM), ev = fabs(v - GEO_PI * GEO_EARTH_RADIUS_KM);
          if (eh > wh) { wh = eh; lh = L; }
          if (ev > wv) { wv = ev; lv = L; }
      }
      printf("recorded exact_antipodes: worst_haversine_abs_km=%.3e at_L=%d relative=%.3e worst_vector_abs_km=%.3e at_L=%d\n",
             wh, lh, wh / (GEO_PI * GEO_EARTH_RADIUS_KM), wv, lv); }

    /* M11 (recorded, not asserted): two faulty techniques from the answer key. */
    { double lon = nextafter(180.0, 0.0), r_faulty = lon - 360.0 * floor((lon + 180.0) / 360.0), r_good;
      wrap_lon_deg(lon, &r_good);
      printf("recorded faulty_floor_wrap: lon=%.17g faulty=%.17g correct=%.17g in_range=%d\n", lon, r_faulty, r_good, r_faulty >= -180.0 && r_faulty < 180.0);
      double lon2 = 1e22, faulty2 = lon2 - 360.0 * floor((lon2 + 180.0) / 360.0), good2; wrap_lon_deg(lon2, &good2);
      printf("recorded faulty_floor_wrap_large: lon=1e22 faulty=%.17g correct=%.17g\n", faulty2, good2);
      Vec2 a = {0.0, 0.0}, b = {0.3, 0.9}, c = {0.1, 0.3};
      double orient = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
      printf("recorded decimal_collinear_orientation: cross=%.17g (zero in exact decimal arithmetic)\n", orient); }
    return failed;
}
