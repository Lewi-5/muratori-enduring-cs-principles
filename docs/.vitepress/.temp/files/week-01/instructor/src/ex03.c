#include <stdio.h>
#include "decimal.h"

int sum_to(size_t n, unsigned long long *out)
{
    if (n > 10000) return 0;
    unsigned long long sum = 0;
    /* Before iteration i, sum = 1 + ... + (i - 1). */
    for (size_t i = 1; i <= n; ++i) sum += i;
    *out = sum;
    return 1;
}

int main(int argc, char **argv)
{
    size_t n;
    unsigned long long sum;
    if (argc != 2 || !decimal_size(argv[1], 10000, &n) || !sum_to(n, &sum)) {
        fputs("error: expected N in 0..10000\n", stderr);
        return 1;
    }
    printf("sum=%llu\n", sum);
    return 0;
}
