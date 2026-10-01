/* E05: distance three ways. Learner scaffold. */
#include <math.h>
#include <stdio.h>
#include "geo_consts.h"

/* ---- copy your E03/E04 solutions here (non-static, so unused copies do not trip -Werror) ---- */
double deg_to_rad(double degrees)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)degrees;
    return 0.0;
}

int sin_deg(double degrees, double *out)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)degrees;
    (void)out;
    return 0;
}

int cos_deg(double degrees, double *out)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)degrees;
    (void)out;
    return 0;
}

double vec3_dot(Vec3 a, Vec3 b)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)a;
    (void)b;
    return 0.0;
}

Vec3 vec3_cross(Vec3 a, Vec3 b)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)a; (void)b;
    Vec3 r = {0.0, 0.0, 0.0};
    return r;
}

int latlon_to_unit(double lat_deg, double lon_deg, Vec3 *out)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)lat_deg;
    (void)lon_deg;
    (void)out;
    return 0;
}

/* ---- end of copies ---- */

int haversine_km(double lat1, double lon1, double lat2, double lon2, double *out)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)lat1;
    (void)lon1;
    (void)lat2;
    (void)lon2;
    (void)out;
    return 0;
}

int vector_distance_km(double lat1, double lon1, double lat2, double lon2, double *out)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)lat1;
    (void)lon1;
    (void)lat2;
    (void)lon2;
    (void)out;
    return 0;
}

int cosines_distance_km(double lat1, double lon1, double lat2, double lon2, double *out)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)lat1;
    (void)lon1;
    (void)lat2;
    (void)lon2;
    (void)out;
    return 0;
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
