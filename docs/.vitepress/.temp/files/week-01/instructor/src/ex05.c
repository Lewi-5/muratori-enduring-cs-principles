#include <stddef.h>
#include <stdio.h>

typedef struct { size_t count; int min; int max; } Stats;

int array_stats(const int *values, size_t length, Stats *out)
{
    *out = (Stats){length, 0, 0};
    if (length == 0) return 0; /* min/max placeholders are not extrema. */
    out->min = out->max = values[0];
    for (size_t i = 1; i < length; ++i) {
        if (values[i] < out->min) out->min = values[i];
        if (values[i] > out->max) out->max = values[i];
    }
    return 1;
}

int main(void)
{
    const int values[] = {4, -2, 7, 7};
    Stats stats;
    if (!array_stats(values, 4, &stats)) return 1;
    printf("count=%zu min=%d max=%d\n", stats.count, stats.min, stats.max);
    return 0;
}
