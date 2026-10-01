/* Measurements recorded (not asserted) by the answer key, and the maxima that justify tolerances in
   tests/tolerances.h. Links against nothing: the reference sources are included with main renamed. */
#include <float.h>
#include <inttypes.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tolerances.h"

#define main ex01_main
#include "../src/ex01.c"
#undef main
#define main ex06_main
#include "../src/ex06.c"
#undef main
#define main ex07_main
#include "../src/ex07.c"
#undef main

static uint64_t cstate;
static uint32_t cnext(void)
{
    cstate = cstate * UINT64_C(6364136223846793005) + UINT64_C(1442695040888963407);
    return (uint32_t)(cstate >> 32);
}

static void rejection_run(uint32_t bound, uint64_t seed, long draws)
{
    uint32_t threshold = (uint32_t)(UINT32_C(0) - bound) % bound;
    cstate = seed;
    long rejected = 0, run = 0, longest = 0;
    for (long i = 0; i < draws; ++i) {
        uint32_t r = cnext();
        if (r < threshold) {
            ++rejected;
            if (++run > longest) longest = run;
        } else {
            run = 0;
        }
    }
    printf("rejection bound=%" PRIu32 " seed=%" PRIu64 " raw_draws=%ld threshold=%" PRIu32 " rejected_fraction=%.6f exact_fraction=%.6f longest_run=%ld\n",
           bound, seed, draws, threshold, (double)rejected / (double)draws, (double)threshold / 4294967296.0, longest);
}

static void processor_maxima(void)
{
    enum { N = 10000 };
    GeoPoint *pts = malloc(N * sizeof *pts);
    if (pts == NULL) exit(1);
    cstate = 4242;
    for (int i = 0; i < N; ++i) {
        uint32_t a = cnext();
        uint32_t b = cnext();
        pts[i].id = (uint64_t)i + 1;
        pts[i].lat_deg = (double)((int64_t)(a % 180000001u) - 90000000) / 1e6;
        pts[i].lon_deg = (double)((int64_t)(b % 360000001u) - 180000000) / 1e6;
    }
    static const double centers[][2] = {{37.75, -122.5}, {0.0, 0.0}, {90.0, 0.0}, {-45.5, 179.999999}};
    double worst_abs = 0, worst_rel = 0, worst_sum = 0, worst_min = 0, worst_max = 0, worst_bound_ratio = 0, smallest_sum = 1e300;
    for (size_t ci = 0; ci < 4; ++ci) {
        long double ref_sum = 0.0L;
        double ref_min = 0.0, ref_max = 0.0;
        for (int i = 0; i < N; ++i) {
            double mine = 0.0;
            if (!haversine_km(centers[ci][0], centers[ci][1], pts[i].lat_deg, pts[i].lon_deg, &mine)) exit(1);
            double ref = reference_distance_km(centers[ci][0], centers[ci][1], pts[i].lat_deg, pts[i].lon_deg);
            double d = fabs(mine - ref);
            if (d > worst_abs) worst_abs = d;
            if (ref > 0 && d / ref > worst_rel) worst_rel = d / ref;
            ref_sum += ref;
            if (i == 0 || ref < ref_min) ref_min = ref;
            if (i == 0 || ref > ref_max) ref_max = ref;
        }
        if ((double)ref_sum < smallest_sum) smallest_sum = (double)ref_sum;
        ProcessResult r;
        if (!process_points(pts, N, centers[ci][0], centers[ci][1], 8000.0, &r)) exit(1);
        double s = fabs(r.sum_km - (double)ref_sum) / (double)ref_sum;
        if (s > worst_sum) worst_sum = s;
        double mn = fabs(r.min_km - ref_min) / fmax(ref_min, 1.0), mx = fabs(r.max_km - ref_max) / ref_max;
        if (mn > worst_min) worst_min = mn;
        if (mx > worst_max) worst_max = mx;
        double bound = (double)(N - 1) * TOL_UNIT_ROUNDOFF; /* first-order (n-1)u accumulation bound */
        if (s / bound > worst_bound_ratio) worst_bound_ratio = s / bound;
    }
    printf("processor per_point_abs_km=%.3e per_point_rel=%.3e sum_rel=%.3e min_rel=%.3e max_rel=%.3e sum_rel_over_(n-1)u=%.3e smallest_reference_sum_km=%.4e\n",
           worst_abs, worst_rel, worst_sum, worst_min, worst_max, worst_bound_ratio, smallest_sum);
    free(pts);
}

static void grid_measure(void)
{
    enum { G = 1000001 };
    double *e = malloc(G * sizeof *e), *a = malloc(G * sizeof *a);
    if (e == NULL || a == NULL || !grid_explicit(0.0, 0.1, G, e) || !grid_accumulated(0.0, 0.1, G, a)) exit(1);
    long double we = 0, wa = 0;
    for (long i = 1; i < G; ++i) {
        long double x = fabsl(10.0L * e[i] - (long double)i) / (long double)i;
        long double y = fabsl(10.0L * a[i] - (long double)i) / (long double)i;
        if (x > we) we = x;
        if (y > wa) wa = y;
    }
    printf("grid vs_exact explicit_max_rel=%.6Le (in units of u: %.4Lf) accumulated_max_rel=%.6Le (in units of u: %.4Lf) derived_bound_explicit_u=1.5\n",
           we, we / TOL_UNIT_ROUNDOFF, wa, wa / TOL_UNIT_ROUNDOFF);
    free(e);
    free(a);
}

static void bias_demo(void)
{
    /* faulty r % bound versus rejection sampling, bound 3e9: how often is the result below 2^32 mod bound? */
    const uint32_t bound = 3000000000u, threshold = (uint32_t)(UINT32_C(0) - bound) % bound;
    const long n = 20000000L;
    cstate = 5;
    long faulty_low = 0, good_low = 0;
    for (long i = 0; i < n; ++i) faulty_low += (cnext() % bound) < threshold;
    uint64_t st = 5;
    for (long i = 0; i < n; ++i) {
        uint32_t v = 0;
        (void)lcg_below(&st, bound, &v);
        good_low += v < threshold;
    }
    printf("bias bound=3e9 P(result < %" PRIu32 "): faulty r%%bound measured=%.4f exact=%.4f ; rejection sampling measured=%.4f exact=%.4f\n",
           threshold, (double)faulty_low / (double)n, 2.0 * threshold / 4294967296.0, (double)good_low / (double)n, (double)threshold / 3e9);
}

static void strtod_accepts(void)
{
    static const char *const s[] = {"nan", "inf", "0x1p3", " 1.5", "1e2", "+1.5", "1.5", ".5", "5.", "-0.000000"};
    for (size_t i = 0; i < sizeof s / sizeof s[0]; ++i) {
        char *end = NULL;
        double v = strtod(s[i], &end);
        printf("strtod(\"%s\") = %g, consumed %td of %zu characters\n", s[i], v, end - s[i], strlen(s[i]));
    }
}

static void degrees_vs_area(void)
{
    const int n = 200000;
    cstate = 1;
    long polar = 0;
    for (int i = 0; i < n; ++i) {
        uint32_t lat_r = 0;
        (void)lcg_below(&cstate, 180000001u, &lat_r);
        uint32_t lon_r = 0;
        (void)lcg_below(&cstate, 360000001u, &lon_r);
        if (labs((long)lat_r - 90000000) > 60000000) ++polar;
    }
    printf("polar_fraction |lat|>60deg: measured=%.4f uniform_in_degrees=%.4f uniform_on_sphere=%.4f (1-sin 60)\n",
           (double)polar / n, 1.0 / 3.0, 1.0 - sin(GEO_PI / 3.0));
}

int main(void)
{
    printf("sizeof(GeoPoint)=%zu sizeof(ProcessResult)=%zu\n", sizeof(GeoPoint), sizeof(ProcessResult));
    rejection_run(3000000000u, 99, 100000000L);
    rejection_run(3000000000u, 1, 100000000L);
    rejection_run(2147483649u, 7, 100000000L); /* worst case for the accepted fraction: threshold = 2^31 - 1 */
    processor_maxima();
    grid_measure();
    bias_demo();
    strtod_accepts();
    degrees_vs_area();
    return 0;
}
