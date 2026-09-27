#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "decimal.h"

int allocated_sum(size_t n, unsigned long long *out)
{
    /* Check before n * sizeof(int) is evaluated. */
    if (n > SIZE_MAX / sizeof(int) || n > 1000000) return 0;
    if (n == 0) { *out = 0; return 1; }
    int *values = malloc(n * sizeof *values);
    if (values == NULL) return 0;
    for (size_t i = 0; i < n; ++i) values[i] = (int)(i % 100);
    unsigned long long sum = 0;
    for (size_t i = 0; i < n; ++i) sum += (unsigned)values[i];
    free(values); /* This function owns the allocation; no aliases escape. */
    *out = sum;
    return 1;
}

int main(int argc, char **argv)
{
    size_t n;
    unsigned long long sum;
    if (argc != 2 || !decimal_size(argv[1], SIZE_MAX, &n) || !allocated_sum(n, &sum)) {
        fputs("error: invalid count (cap 1000000) or allocation failed\n", stderr);
        return 1;
    }
    printf("count=%zu sum=%llu\n", n, sum);
    return 0;
}
