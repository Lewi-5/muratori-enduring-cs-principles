/* E05: distance three ways. Reference solution (E03/E04 helpers copied in). */
#include <math.h>
#include <stdio.h>
#include "geo_consts.h"

/* ---- copied from E03 ---- */
static double deg_to_rad(double degrees) { return degrees * (GEO_PI / 180.0); }

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

/* ---- copied from E04 ---- */
static double vec3_dot(Vec3 a, Vec3 b) { return a.x * b.x + a.y * b.y + a.z * b.z; }

static Vec3 vec3_cross(Vec3 a, Vec3 b)
{
    Vec3 r = {a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x};
    return r;
}

static int latlon_to_unit(double lat_deg, double lon_deg, Vec3 *out)
{
    double clat, slat, clon, slon;
    if (!cos_deg(lat_deg, &clat) || !sin_deg(lat_deg, &slat)
        || !cos_deg(lon_deg, &clon) || !sin_deg(lon_deg, &slon)) return 0;
    Vec3 v = {plus_zero(clat * clon), plus_zero(clat * slon), slat};
    *out = v;
    return 1;
}
/* ---- end of copies ---- */

static int valid_point(double lat, double lon)
{
    return isfinite(lat) && isfinite(lon) && lat >= -90.0 && lat <= 90.0 && lon >= -180.0 && lon <= 180.0;
}

static double clamp(double v, double lo, double hi) { return v < lo ? lo : (v > hi ? hi : v); }

/* hav(c) = hav(dlat) + cos(lat1) cos(lat2) hav(dlon), with hav(t) = sin^2(t/2). Rounding can
   push the sum slightly outside [0, 1]; the clamp guarantees sqrt/asin never see NaN inputs. */
int haversine_km(double lat1, double lon1, double lat2, double lon2, double *out)
{
    if (out == NULL || !valid_point(lat1, lon1) || !valid_point(lat2, lon2)) return 0;
    double sd_lat = sin(deg_to_rad(lat2 - lat1) / 2.0);
    double sd_lon = sin(deg_to_rad(lon2 - lon1) / 2.0);
    double a = sd_lat * sd_lat + cos(deg_to_rad(lat1)) * cos(deg_to_rad(lat2)) * sd_lon * sd_lon;
    a = clamp(a, 0.0, 1.0);
    *out = 2.0 * asin(sqrt(a)) * GEO_EARTH_RADIUS_KM;
    return 1;
}

/* central angle = atan2(|u x v|, u . v): well conditioned for all angles because atan2 is. */
int vector_distance_km(double lat1, double lon1, double lat2, double lon2, double *out)
{
    Vec3 u, v;
    if (out == NULL || !valid_point(lat1, lon1) || !valid_point(lat2, lon2)) return 0;
    if (!latlon_to_unit(lat1, lon1, &u) || !latlon_to_unit(lat2, lon2, &v)) return 0;
    Vec3 c = vec3_cross(u, v);
    double cross_len = sqrt(vec3_dot(c, c));
    *out = atan2(cross_len, vec3_dot(u, v)) * GEO_EARTH_RADIUS_KM;
    return 1;
}

/* Spherical law of cosines. Algebraically correct; badly conditioned for small angles. */
int cosines_distance_km(double lat1, double lon1, double lat2, double lon2, double *out)
{
    if (out == NULL || !valid_point(lat1, lon1) || !valid_point(lat2, lon2)) return 0;
    double p1 = deg_to_rad(lat1), p2 = deg_to_rad(lat2);
    double c = sin(p1) * sin(p2) + cos(p1) * cos(p2) * cos(deg_to_rad(lon2 - lon1));
    *out = acos(clamp(c, -1.0, 1.0)) * GEO_EARTH_RADIUS_KM;
    return 1;
}

typedef struct { const char *name; double lat1, lon1, lat2, lon2, expected_km; } Case;

int main(void)
{
    const double R = GEO_EARTH_RADIUS_KM;
    const double km_per_deg = R * (GEO_PI / 180.0);
    const double one_km_deg = 180.0 / (GEO_PI * R); /* the latitude difference whose arc is 1 km */
    const Case cases[] = {
        {"identical", 40.0, 33.25, 40.0, 33.25, 0.0},
        {"one_metre_equator", 0.0, 0.0, 0.0, 1e-5, 1e-5 * km_per_deg},
        {"one_km_meridian", 0.0, 0.0, one_km_deg, 0.0, 1.0},
        {"quarter_meridian", 0.0, 0.0, 90.0, 0.0, R * (GEO_PI / 2.0)},
        {"half_circle", 0.0, 0.0, 0.0, 180.0, R * GEO_PI},
        {"antimeridian_pair", 0.0, 179.5, 0.0, -179.5, 1.0 * km_per_deg},
    };
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        double h, v, c;
        if (!haversine_km(cases[i].lat1, cases[i].lon1, cases[i].lat2, cases[i].lon2, &h)
            || !vector_distance_km(cases[i].lat1, cases[i].lon1, cases[i].lat2, cases[i].lon2, &v)
            || !cosines_distance_km(cases[i].lat1, cases[i].lon1, cases[i].lat2, cases[i].lon2, &c)) return 1;
        printf("case=%s expected_km=%.9f haversine_km=%.9f vector_km=%.9f cosines_km=%.9f\n",
               cases[i].name, cases[i].expected_km, h, v, c);
    }
    return 0;
}
