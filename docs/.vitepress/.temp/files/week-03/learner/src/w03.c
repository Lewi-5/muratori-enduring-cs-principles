/* W03: wrapping a longitude by hand. Warm-up scaffold: fill in the TODO body. */
#include <math.h>
#include <stdio.h>

int wrap_small(double lon, double *out)
{
    /* TODO: implement the contract in learner/warmups.md. */
    (void)lon;
    (void)out;
    return 0;
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
