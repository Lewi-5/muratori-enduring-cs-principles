/* E03: angles and longitude. Learner scaffold: fill in the TODO bodies. */
#include <math.h>
#include <stdio.h>
#include "geo_consts.h"

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

int lon_delta_deg(double from, double to, double *out)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)from;
    (void)to;
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

int main(void)
{
    double wrapped, delta, s180;
    if (!wrap_lon_deg(180.0, &wrapped) || !lon_delta_deg(179.0, -179.0, &delta) || !sin_deg(180.0, &s180)) return 1;
    printf("wrap(180)=%g delta(179,-179)=%g sin_deg(180)=%g sin(pi)=%.17g\n", wrapped, delta, s180, sin(GEO_PI));
    return 0;
}
