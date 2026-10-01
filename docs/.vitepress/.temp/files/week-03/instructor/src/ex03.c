/* E03: angles and longitude. Reference solution. */
#include <math.h>
#include <stdio.h>
#include "geo_consts.h"

double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }
double rad_to_deg(double radians) { return radians * (180.0 / GEO_PI); }

/* Maps any finite longitude to [-180, 180). fmod is exact (C11 7.12.10.1: the result is
   x - n*y for an integer n), so the only rounding-capable step is the one correction, and that
   subtraction is exact by Sterbenz: both operands lie within a factor of two of each other. */
int wrap_lon_deg(double lon, double *out)
{
    if (out == NULL || !isfinite(lon)) return 0;
    double r = fmod(lon, 360.0);        /* |r| < 360, same sign as lon */
    if (r >= 180.0) r -= 360.0;         /* r in [180,360): 360 - r is within [0,180], exact */
    else if (r < -180.0) r += 360.0;    /* r in (-360,-180): exact for the same reason */
    *out = r;
    return 1;
}

/* Both longitudes must lie in [-180, 180]. The subtraction to - from may round; the wrap is exact. */
int lon_delta_deg(double from, double to, double *out)
{
    if (out == NULL || !isfinite(from) || !isfinite(to)
        || from < -180.0 || from > 180.0 || to < -180.0 || to > 180.0) return 0;
    return wrap_lon_deg(to - from, out);
}

/* Shared exact quadrant reduction: x = 90*q + r with q in {0,1,2,3} and r in [0, 90).
   |x| is reduced by fmod(., 360) (exact) and then by subtracting 90, 180 or 270. Each subtraction
   is exact by Sterbenz: r - k with k/2 <= ... i.e. k <= 2r and r <= 2k holds on each branch
   (r in [90,180) with k=90, [180,270) with k=180, [270,360) with k=270). See answers.md E03.Q. */
static void reduce_quadrant(double magnitude, int *quadrant, double *residue)
{
    double r = fmod(magnitude, 360.0);
    int q = 0;
    if (r >= 270.0) { r -= 270.0; q = 3; }
    else if (r >= 180.0) { r -= 180.0; q = 2; }
    else if (r >= 90.0) { r -= 90.0; q = 1; }
    *quadrant = q;
    *residue = r;
}

static double plus_zero(double v) { return v == 0.0 ? 0.0 : v; } /* never returns -0.0 */

int sin_deg(double degrees, double *out)
{
    if (out == NULL || !isfinite(degrees)) return 0;
    int q; double r;
    reduce_quadrant(fabs(degrees), &q, &r);
    double rad = deg_to_rad(r);
    static const int use_cos[4] = {0, 1, 0, 1};
    static const int negative[4] = {0, 0, 1, 1};
    double v = use_cos[q] ? cos(rad) : sin(rad);
    if (negative[q]) v = -v;
    if (degrees < 0.0) v = -v;          /* odd symmetry is applied, not computed */
    *out = plus_zero(v);
    return 1;
}

int cos_deg(double degrees, double *out)
{
    if (out == NULL || !isfinite(degrees)) return 0;
    int q; double r;
    reduce_quadrant(fabs(degrees), &q, &r);  /* even symmetry: only |x| matters */
    double rad = deg_to_rad(r);
    static const int use_sin[4] = {0, 1, 0, 1};
    static const int negative[4] = {0, 1, 1, 0};
    double v = use_sin[q] ? sin(rad) : cos(rad);
    if (negative[q]) v = -v;
    *out = plus_zero(v);
    return 1;
}

int main(void)
{
    double wrapped, delta, s180;
    if (!wrap_lon_deg(180.0, &wrapped) || !lon_delta_deg(179.0, -179.0, &delta) || !sin_deg(180.0, &s180)) return 1;
    printf("wrap(180)=%g delta(179,-179)=%g sin_deg(180)=%g sin(pi)=%.17g\n", wrapped, delta, s180, sin(GEO_PI));
    return 0;
}
