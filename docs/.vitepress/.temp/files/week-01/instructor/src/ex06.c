#include <stddef.h>
#include <stdio.h>

/* Contract: <= 10000 elements, each in [-1000,1000]. */
long sum_index(const int *values, size_t length)
{
    long sum = 0;
    for (size_t i = 0; i < length; ++i) sum += values[i];
    return sum;
}

long sum_pointer(const int *values, size_t length)
{
    long sum = 0;
    const int *p = values;
    /* Avoid even forming NULL + 0 in the empty case. */
    for (size_t remaining = length; remaining != 0; --remaining, ++p) sum += *p;
    return sum;
}

int main(void)
{
    const int values[] = {4, -2, 7, 7};
    printf("index=%ld pointer=%ld\n", sum_index(values, 4), sum_pointer(values, 4));
    return 0;
}
