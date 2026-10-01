/* geomath.c: the assembled E03-E06 functions plus approx_equal. Helpers are static (internal linkage);
   only names declared in geomath.h are visible to the linker. No printing, no exit, no writable globals. */
#include <math.h>
#include <stddef.h>
#include "geomath.h"

/* ---------- comparison (E02) ---------- */
int approx_equal(double a, double b, double rel_tol, double abs_tol, int *equal)
{
    if (equal == NULL || !isfinite(rel_tol) || !isfinite(abs_tol) || rel_tol < 0.0 || abs_tol < 0.0) return 0;
    if (isnan(a) || isnan(b)) { *equal = 0; return 1; }
    if (a == b) { *equal = 1; return 1; }
    if (isinf(a) || isinf(b)) { *equal = 0; return 1; }
    double diff = fabs(a - b);
    if (isinf(diff)) { *equal = 0; return 1; }
    *equal = diff <= fmax(abs_tol, rel_tol * fmax(fabs(a), fabs(b)));
    return 1;
}

/* ---------- angles (E03) ---------- */
double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }
double rad_to_deg(double radians) { return radians * (180.0 / GEO_PI); }

int wrap_lon_deg(double lon, double *out)
{
    if (out == NULL || !isfinite(lon)) return 0;
    double r = fmod(lon, 360.0);
    if (r >= 180.0) r -= 360.0;
    else if (r < -180.0) r += 360.0;
    *out = r;
    return 1;
}

int lon_delta_deg(double from, double to, double *out)
{
    if (out == NULL || !isfinite(from) || !isfinite(to)
        || from < -180.0 || from > 180.0 || to < -180.0 || to > 180.0) return 0;
    return wrap_lon_deg(to - from, out);
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

int sin_deg(double degrees, double *out)
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

int cos_deg(double degrees, double *out)
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

/* ---------- vectors (E04) ---------- */
double vec3_dot(Vec3 a, Vec3 b) { return a.x * b.x + a.y * b.y + a.z * b.z; }

Vec3 vec3_cross(Vec3 a, Vec3 b)
{
    Vec3 r = {a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x};
    return r;
}

static int finite3(Vec3 v) { return isfinite(v.x) && isfinite(v.y) && isfinite(v.z); }
static double largest_magnitude(Vec3 v) { return fmax(fabs(v.x), fmax(fabs(v.y), fabs(v.z))); }

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

static int valid_point(double lat, double lon)
{
    return isfinite(lat) && isfinite(lon) && lat >= -90.0 && lat <= 90.0 && lon >= -180.0 && lon <= 180.0;
}

int latlon_to_unit(double lat_deg, double lon_deg, Vec3 *out)
{
    if (out == NULL || !valid_point(lat_deg, lon_deg)) return 0;
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
    if (lat > 90.0) lat = 90.0;
    if (lat < -90.0) lat = -90.0;
    double lon = 0.0;
    if (v.x != 0.0 || v.y != 0.0) {
        if (!wrap_lon_deg(rad_to_deg(atan2(v.y, v.x)), &lon)) return 0;
    }
    *lat_deg = lat;
    *lon_deg = lon;
    return 1;
}

/* ---------- distance (E05) ---------- */
static double clamp(double v, double lo, double hi) { return v < lo ? lo : (v > hi ? hi : v); }

int geo_distance_km(double lat1, double lon1, double lat2, double lon2, double *out)
{
    if (out == NULL || !valid_point(lat1, lon1) || !valid_point(lat2, lon2)) return 0;
    double sd_lat = sin(deg_to_rad(lat2 - lat1) / 2.0);
    double sd_lon = sin(deg_to_rad(lon2 - lon1) / 2.0);
    double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
    *out = 2.0 * asin(sqrt(clamp(a, 0.0, 1.0))) * GEO_EARTH_RADIUS_KM;
    return 1;
}

int geo_distance_km_vector(double lat1, double lon1, double lat2, double lon2, double *out)
{
    Vec3 u, v;
    if (out == NULL || !valid_point(lat1, lon1) || !valid_point(lat2, lon2)) return 0;
    if (!latlon_to_unit(lat1, lon1, &u) || !latlon_to_unit(lat2, lon2, &v)) return 0;
    Vec3 c = vec3_cross(u, v);
    *out = atan2(sqrt(vec3_dot(c, c)), vec3_dot(u, v)) * GEO_EARTH_RADIUS_KM;
    return 1;
}

/* ---------- segments (E06) ---------- */
#define SEG_LIMIT 33554432.0 /* 2^25 */

static int in_domain(Vec2 p) { return fabs(p.x) <= SEG_LIMIT && fabs(p.y) <= SEG_LIMIT; }
static Vec2 sub(Vec2 a, Vec2 b) { Vec2 r = {a.x - b.x, a.y - b.y}; return r; }
static double cross2(Vec2 a, Vec2 b) { return a.x * b.y - a.y * b.x; }
static int same(Vec2 a, Vec2 b) { return a.x == b.x && a.y == b.y; }
static int lex_less(Vec2 a, Vec2 b) { return a.x < b.x || (a.x == b.x && a.y < b.y); }
static SegResult none(void) { SegResult r = {SEG_NONE, {0, 0}, {0, 0}}; return r; }
static SegResult point(Vec2 p) { SegResult r = {SEG_POINT, p, p}; return r; }

static int on_segment(Vec2 s0, Vec2 s1, Vec2 p)
{
    if (cross2(sub(s1, s0), sub(p, s0)) != 0.0) return 0;
    Vec2 lo = lex_less(s0, s1) ? s0 : s1, hi = lex_less(s0, s1) ? s1 : s0;
    return !lex_less(p, lo) && !lex_less(hi, p);
}

int segment_intersect(Vec2 p0, Vec2 p1, Vec2 q0, Vec2 q1, SegResult *out)
{
    if (out == NULL || !in_domain(p0) || !in_domain(p1) || !in_domain(q0) || !in_domain(q1)) return 0;
    int p_point = same(p0, p1), q_point = same(q0, q1);
    SegResult r;
    if (p_point && q_point) r = same(p0, q0) ? point(p0) : none();
    else if (p_point) r = on_segment(q0, q1, p0) ? point(p0) : none();
    else if (q_point) r = on_segment(p0, p1, q0) ? point(q0) : none();
    else {
        Vec2 d1 = sub(p1, p0), d2 = sub(q1, q0), w = sub(q0, p0);
        double denom = cross2(d1, d2);
        if (denom != 0.0) {
            double tn = cross2(w, d2), un = cross2(w, d1);
            if (denom < 0.0) { denom = -denom; tn = -tn; un = -un; }
            if (tn < 0.0 || tn > denom || un < 0.0 || un > denom) r = none();
            else if (tn == 0.0) r = point(p0);
            else if (tn == denom) r = point(p1);
            else if (un == 0.0) r = point(q0);
            else if (un == denom) r = point(q1);
            else {
                Vec2 x = {(p0.x * denom + tn * d1.x) / denom, (p0.y * denom + tn * d1.y) / denom};
                r = point(x);
            }
        } else if (cross2(w, d1) != 0.0) {
            r = none();
        } else {
            Vec2 a1 = lex_less(p0, p1) ? p0 : p1, b1 = lex_less(p0, p1) ? p1 : p0;
            Vec2 a2 = lex_less(q0, q1) ? q0 : q1, b2 = lex_less(q0, q1) ? q1 : q0;
            Vec2 lo = lex_less(a1, a2) ? a2 : a1, hi = lex_less(b1, b2) ? b1 : b2;
            if (lex_less(hi, lo)) r = none();
            else if (same(lo, hi)) r = point(lo);
            else { r.kind = SEG_OVERLAP; r.a = lo; r.b = hi; }
        }
    }
    *out = r;
    return 1;
}
