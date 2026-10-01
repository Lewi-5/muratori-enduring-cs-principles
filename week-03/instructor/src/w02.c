/* W02: neighbouring doubles. Reference solution. */
#include <math.h>
#include <stdio.h>
#include "platform.h"

/* Distance from x to the next representable double above it. For finite x this subtraction
   is exact: the two neighbours differ by one unit in the last place of the larger magnitude. */
double gap_above(double x)
{
    return nextafter(x, INFINITY) - x;
}

/* 1 when adding one to x gives back x itself (the one is rounded away), 0 otherwise. */
int absorbs_one(double x)
{
    double y = x + 1.0;
    return y == x;
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
