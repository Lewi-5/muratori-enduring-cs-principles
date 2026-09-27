#include <stdio.h>

int clamp_int(int value, int low, int high, int *out)
{
    if (low > high) return 0; /* No invented answer; out is unchanged. */
    *out = value < low ? low : value > high ? high : value;
    return 1;
}

int main(void)
{
    int result;
    if (!clamp_int(12, -3, 8, &result)) return 1;
    printf("clamped=%d\n", result);
    return 0;
}
