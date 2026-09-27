/* E04: vectors and bases. Learner scaffold. */
#include <float.h>
#include <math.h>
#include <stdio.h>
#include "geo_consts.h"

/* ---- copy your E03 solutions here (non-static, so unused copies do not trip -Werror) ---- */
double deg_to_rad(double degrees)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)degrees;
    return 0.0;
}

double rad_to_deg(double radians)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)radians;
    return 0.0;
}

int wrap_lon_deg(double lon, double *out)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)lon;
    (void)out;
    return 0;
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

/* ---- end of E03 copies ---- */

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

int vec3_length(Vec3 v, double *out)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)v;
    (void)out;
    return 0;
}

int vec3_normalize(Vec3 v, Vec3 *out)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)v;
    (void)out;
    return 0;
}

int latlon_to_unit(double lat_deg, double lon_deg, Vec3 *out)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)lat_deg;
    (void)lon_deg;
    (void)out;
    return 0;
}

int unit_to_latlon(Vec3 v, double *lat_deg, double *lon_deg)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)v;
    (void)lat_deg;
    (void)lon_deg;
    return 0;
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
