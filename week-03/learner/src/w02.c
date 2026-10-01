/* W02: neighbouring doubles. Warm-up scaffold: fill in the TODO bodies. */
#include <math.h>
#include <stdio.h>
#include "platform.h"

double gap_above(double x)
{
    /* TODO: implement the contract in learner/warmups.md. */
    (void)x;
    return 0.0;
}

int absorbs_one(double x)
{
    /* TODO: implement the contract in learner/warmups.md. */
    (void)x;
    return -1;
}

int main(void)
{
    const double at[] = {1.0, 2.0, 1024.0, 0x1p52, 0x1p53, -1.0};
    const char *const names[] = {"1", "2", "1024", "2^52", "2^53", "-1"};
    puts(GEO_IEC559 ? "ieee754_binary64=checked" : "ieee754_binary64=skipped");
    if (!GEO_IEC559) return 0;
    for (int i = 0; i < 6; ++i) {
        printf("x=%s gap=%a absorbs_one=%d\n", names[i], gap_above(at[i]), absorbs_one(at[i]));
    }
    return 0;
}
