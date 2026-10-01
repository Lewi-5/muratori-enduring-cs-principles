/* S01 reference: an edge-case and property suite for geomath. Prints one `case=NAME result=pass|fail`
   line per named case; exits nonzero if any fail. Links against geomath.o and includes only geomath.h. */
#include <float.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include "geomath.h"

static int failures;
#define CASE(name, condition) do { int ok_ = (condition); printf("case=%s result=%s\n", name, ok_ ? "pass" : "fail"); failures += !ok_; } while (0)

static double dist(double a, double b, double c, double d) { double r = -1.0; return geo_distance_km(a, b, c, d, &r) ? r : -1.0; }
static double distv(double a, double b, double c, double d) { double r = -1.0; return geo_distance_km_vector(a, b, c, d, &r) ? r : -1.0; }
static int close_km(double a, double b, double tol) { return a >= 0.0 && b >= 0.0 && fabs(a - b) <= tol; }

static uint32_t rng_state = 12345u;
static uint32_t next_random(void) { rng_state ^= rng_state << 13; rng_state ^= rng_state >> 17; rng_state ^= rng_state << 5; return rng_state; }
static double unit_interval(void) { return next_random() / 4294967296.0; }

int main(void)
{
    const double R = GEO_EARTH_RADIUS_KM, half = GEO_PI * R;

    /* Would catch: treating longitude as meaningful at a pole (a cos(lat)=0 term forgotten or approximated). */
    int poles = 1;
    for (double lon = -180.0; lon <= 180.0; lon += 45.0) poles = poles && close_km(dist(90, 0, 90, lon), 0.0, 1e-9) && close_km(distv(90, 0, 90, lon), 0.0, 1e-9)
        && close_km(dist(90, lon, 0, 0), half / 2.0, 1e-8) && close_km(distv(-90, lon, 0, 30), half / 2.0, 1e-8);
    CASE("poles_any_longitude", poles);

    /* Would catch: subtracting longitudes without wrapping, or rejecting +-180. */
    CASE("antimeridian_equivalence", close_km(dist(10, 180, 20, 10), dist(10, -180, 20, 10), 1e-8) && close_km(distv(10, 180, 20, 10), distv(10, -180, 20, 10), 1e-8));
    CASE("antimeridian_short_way", close_km(dist(0, 179.5, 0, -179.5), R * (GEO_PI / 180.0), 1e-8) && close_km(dist(0, -179.5, 0, 179.5), R * (GEO_PI / 180.0), 1e-8));

    /* Would catch: an acos-based formula that returns a nonzero distance (or NaN) for a coincident point. */
    CASE("identical_points_exact_zero", dist(40, 33.25, 40, 33.25) == 0.0 && distv(40, 33.25, 40, 33.25) == 0.0 && dist(-90, 0, -90, 0) == 0.0);

    /* Would catch: an asymmetric formula or an argument-order bug. */
    int reversed = 1;
    for (int i = 0; i < 200; ++i) {
        double a = -90 + 180 * unit_interval(), b = -180 + 360 * unit_interval(), c = -90 + 180 * unit_interval(), d = -180 + 360 * unit_interval();
        reversed = reversed && close_km(dist(a, b, c, d), dist(c, d, a, b), 1e-9) && close_km(distv(a, b, c, d), distv(c, d, a, b), 1e-9);
    }
    CASE("both_directions_random_pairs", reversed);

    /* Would catch: a clamp missing on the sqrt/asin argument (NaN near antipodes) and a wrong upper bound. */
    CASE("exact_antipode_finite", close_km(dist(0, 0, 0, 180), half, 1e-8) && close_km(distv(0, 0, 0, 180), half, 1e-8) && close_km(dist(90, 0, -90, 0), half, 1e-8)
         && close_km(dist(0, -180, 0, 0), half, 1e-8) && close_km(dist(45, 10, -45, -170), half, 1e-6));
    CASE("latitude_extremes_and_longitude_limits_valid", dist(-90, 180, 90, -180) >= 0.0 && dist(-90, -180, -90, 180) >= 0.0);

    /* Would catch: mistaking floating-point closeness for exact ordering. One ulp of longitude is a valid, tiny, nonnegative distance.
       The haversine path is accurate here (the longitude difference is exact); the vector path is recorded elsewhere, not asserted. */
    double lon2 = nextafter(10.0, 20.0), h = dist(0, 10, 0, lon2), expected = R * ((lon2 - 10.0) * (GEO_PI / 180.0));
    CASE("points_one_ulp_apart", h > 0.0 && h < 1e-9 && fabs(h - expected) <= 1e-12 * expected && dist(0, 10, 0, 10) == 0.0);

    /* Would catch: missing validation (silently accepting NaN, infinities or out-of-range coordinates). */
    double sink = 7.0;
    CASE("invalid_inputs_rejected_unchanged", !geo_distance_km(90.5, 0, 0, 0, &sink) && !geo_distance_km(0, NAN, 0, 0, &sink) && !geo_distance_km(0, 0, 0, 180.0000001, &sink)
         && !geo_distance_km_vector(0, 0, -91, 0, &sink) && !geo_distance_km(0, 0, 0, INFINITY, &sink) && sink == 7.0);

    /* Would catch: wrap_lon_deg that is not idempotent, or +360 that changes the answer when the addition is exact. */
    int wraps = 1;
    for (int k = -1440; k <= 1440; ++k) {
        double lon = k / 8.0, a, b, c; /* binary fractions: adding 360 is exact */
        wraps = wraps && wrap_lon_deg(lon, &a) && wrap_lon_deg(lon + 360.0, &b) && wrap_lon_deg(lon - 360.0, &c) && a == b && a == c;
        double again; wraps = wraps && wrap_lon_deg(a, &again) && again == a;
    }
    CASE("wrap_invariant_under_360_and_idempotent", wraps);

    /* Would catch: a triangle-inequality violation beyond rounding, e.g. from a wrong central angle. */
    int triangle = 1;
    for (int i = 0; i < 2000; ++i) {
        double p[3][2];
        for (int j = 0; j < 3; ++j) { p[j][0] = -90 + 180 * unit_interval(); p[j][1] = -180 + 360 * unit_interval(); }
        double ab = dist(p[0][0], p[0][1], p[1][0], p[1][1]), bc = dist(p[1][0], p[1][1], p[2][0], p[2][1]), ac = dist(p[0][0], p[0][1], p[2][0], p[2][1]);
        triangle = triangle && ac <= ab + bc + 1e-8 && ab <= ac + bc + 1e-8 && bc <= ab + ac + 1e-8;
    }
    CASE("triangle_inequality_random_triples", triangle);

    /* Would catch: NaN escaping from a division in the parallel branch, endpoint drift, or lexicographic-order mistakes. */
    Vec2 a = {0, 0}, b = {4, 4}, c = {1, 1}, d = {3, 3}; SegResult r;
    CASE("segment_collinear_contained", segment_intersect(a, b, c, d, &r) && r.kind == SEG_OVERLAP && r.a.x == 1 && r.b.x == 3);
    CASE("segment_reversed_argument_order", segment_intersect(b, a, d, c, &r) && r.kind == SEG_OVERLAP && r.a.x == 1 && r.a.y == 1 && r.b.x == 3);
    Vec2 e = {-33554432.0, 0}, f = {33554432.0, 0}, g = {0, -33554432.0}, k = {0, 33554432.0};
    CASE("segment_domain_extremes_cross_at_origin", segment_intersect(e, f, g, k, &r) && r.kind == SEG_POINT && r.a.x == 0.0 && r.a.y == 0.0);
    return failures != 0;
}
