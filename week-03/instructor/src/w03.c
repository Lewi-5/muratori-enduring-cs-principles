/* W03: wrapping a longitude by hand. Reference solution. */
#include <math.h>
#include <stdio.h>

/* Wraps a longitude in [-540, 540) into the half-open interval [-180, 180) with at most one
   correction of 360, and no fmod. Rejects (output unchanged) anything outside that domain. */
int wrap_small(double lon, double *out)
{
    if (out == NULL || !isfinite(lon) || lon < -540.0 || lon >= 540.0) return 0;
    double r = lon;
    if (r >= 180.0) r -= 360.0;
    else if (r < -180.0) r += 360.0;
    *out = r;
    return 1;
}

int main(void)
{
    const double in[] = {0.0, 179.0, 180.0, 190.0, -180.0, -190.0, 539.0, -540.0};
    for (int i = 0; i < 8; ++i) {
        double out;
        if (!wrap_small(in[i], &out)) return 1;
        printf("wrap(%g)=%g\n", in[i], out);
    }
    return 0;
}
