/* E04: vectors and bases. Reference solution (E03 helpers copied in, as a learner would). */
#include <float.h>
#include <math.h>
#include <stdio.h>
#include "geo_consts.h"

/* ---- copied from E03 ---- */
static double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }
static double rad_to_deg(double radians) { return radians * (180.0 / GEO_PI); }

static int wrap_lon_deg(double lon, double *out)
{
    if (out == NULL || !isfinite(lon)) return 0;
    double r = fmod(lon, 360.0);
    if (r >= 180.0) r -= 360.0;
    else if (r < -180.0) r += 360.0;
    *out = r;
    return 1;
}

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

static double plus_zero(double v) { return v == 0.0 ? 0.0 : v; }

static int sin_deg(double degrees, double *out)
{
    if (out == NULL || !isfinite(degrees)) return 0;
    int q; double r;
    reduce_quadrant(fabs(degrees), &q, &r);
    double rad = deg_to_rad(r);
    static const int use_cos[4] = {0, 1, 0, 1}, negative[4] = {0, 0, 1, 1};
    double v = use_cos[q] ? cos(rad) : sin(rad);
    if (negative[q]) v = -v;
    if (degrees < 0.0) v = -v;
    *out = plus_zero(v);
    return 1;
}

static int cos_deg(double degrees, double *out)
{
    if (out == NULL || !isfinite(degrees)) return 0;
    int q; double r;
    reduce_quadrant(fabs(degrees), &q, &r);
    double rad = deg_to_rad(r);
    static const int use_sin[4] = {0, 1, 0, 1}, negative[4] = {0, 1, 1, 0};
    double v = use_sin[q] ? sin(rad) : cos(rad);
    if (negative[q]) v = -v;
    *out = plus_zero(v);
    return 1;
}
/* ---- end of E03 copies ---- */

double vec3_dot(Vec3 a, Vec3 b) { return a.x * b.x + a.y * b.y + a.z * b.z; }

Vec3 vec3_cross(Vec3 a, Vec3 b)
{
    Vec3 r = {a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x};
    return r;
}

static int finite3(Vec3 v) { return isfinite(v.x) && isfinite(v.y) && isfinite(v.z); }
static double largest_magnitude(Vec3 v) { return fmax(fabs(v.x), fmax(fabs(v.y), fabs(v.z))); }

/* Length by scaling: with m = max |component|, every scaled component has magnitude <= 1, so
   the sum of squares lies in [1, 3] and neither overflows nor underflows away. The result is
   rejected only if m * sqrt(sum) is itself not finite. */
int vec3_length(Vec3 v, double *out)
{
    if (out == NULL || !finite3(v)) return 0;
    double m = largest_magnitude(v);
    if (m == 0.0) { *out = 0.0; return 1; }
    double x = v.x / m, y = v.y / m, z = v.z / m;
    double length = m * sqrt(x * x + y * y + z * z);
    if (!isfinite(length)) return 0;
    *out = length;
    return 1;
}

/* Normalization never needs the length to be representable: divide by m first, then by the
   scaled length (in [1, sqrt 3]). */
int vec3_normalize(Vec3 v, Vec3 *out)
{
    if (out == NULL || !finite3(v)) return 0;
    double m = largest_magnitude(v);
    if (m == 0.0) return 0;
    Vec3 s = {v.x / m, v.y / m, v.z / m};
    double n = sqrt(s.x * s.x + s.y * s.y + s.z * s.z);
    Vec3 r = {s.x / n, s.y / n, s.z / n};
    *out = r;
    return 1;
}

int latlon_to_unit(double lat_deg, double lon_deg, Vec3 *out)
{
    if (out == NULL || !isfinite(lat_deg) || !isfinite(lon_deg)
        || lat_deg < -90.0 || lat_deg > 90.0 || lon_deg < -180.0 || lon_deg > 180.0) return 0;
    double clat, slat, clon, slon;
    if (!cos_deg(lat_deg, &clat) || !sin_deg(lat_deg, &slat)
        || !cos_deg(lon_deg, &clon) || !sin_deg(lon_deg, &slon)) return 0;
    Vec3 v = {plus_zero(clat * clon), plus_zero(clat * slon), slat};
    *out = v;
    return 1;
}

int unit_to_latlon(Vec3 v, double *lat_deg, double *lon_deg)
{
    Vec3 u;
    if (lat_deg == NULL || lon_deg == NULL || !vec3_normalize(v, &u)) return 0;
    double lat = rad_to_deg(atan2(u.z, hypot(u.x, u.y)));
    if (lat > 90.0) lat = 90.0;          /* rounding in rad_to_deg can overshoot the range */
    if (lat < -90.0) lat = -90.0;
    double lon = 0.0;
    if (v.x != 0.0 || v.y != 0.0) {      /* only an original exact pole has conventional longitude 0 */
        if (!wrap_lon_deg(rad_to_deg(atan2(v.y, v.x)), &lon)) return 0;
    }
    *lat_deg = lat;
    *lon_deg = lon;
    return 1;
}

int main(void)
{
    static const double cases[][2] = {{0, 0}, {0, 90}, {90, 45}, {-90, -120}, {45, 45}};
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        Vec3 v;
        if (!latlon_to_unit(cases[i][0], cases[i][1], &v)) return 1;
        printf("lat=%g lon=%g x=%.9f y=%.9f z=%.9f\n", cases[i][0], cases[i][1], v.x, v.y, v.z);
    }
    return 0;
}
