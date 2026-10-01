#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

enum { LENGTH = 1024, ITERATIONS = 1000, TRIALS = 5 };

/* Volatile reads make each pass observable to the C abstract machine.
   This deliberately measures a volatile-read loop, not unrestricted array code. */
static unsigned long long sum_array(const volatile unsigned *values)
{
    unsigned long long sum = 0;
    for (size_t i = 0; i < LENGTH; ++i) sum += values[i];
    return sum;
}

static int compare_double(const void *a, const void *b)
{
    double x = *(const double *)a, y = *(const double *)b;
    return (x > y) - (x < y);
}

int main(void)
{
    volatile unsigned values[LENGTH];
    for (size_t i = 0; i < LENGTH; ++i) values[i] = (unsigned)(i % 100);
    const unsigned long long expected = 49776ULL;
    if (sum_array(values) != expected) return 1; /* Validate and warm up. */
    double times[TRIALS];
    printf("size=%d iterations=%d trials=%d expected=%llu\n", LENGTH, ITERATIONS, TRIALS, expected);
    for (size_t trial = 0; trial < TRIALS; ++trial) {
        struct timespec start, stop;
        unsigned long long total = 0;
        if (clock_gettime(CLOCK_MONOTONIC, &start) != 0) { perror("clock_gettime"); return 1; }
        for (size_t i = 0; i < ITERATIONS; ++i) total += sum_array(values);
        if (clock_gettime(CLOCK_MONOTONIC, &stop) != 0) { perror("clock_gettime"); return 1; }
        if (total != expected * ITERATIONS) { fputs("error: checksum\n", stderr); return 1; }
        times[trial] = (double)(stop.tv_sec - start.tv_sec)
                     + (double)(stop.tv_nsec - start.tv_nsec) / 1000000000.0;
        if (times[trial] < 0) return 1;
        printf("trial=%zu seconds=%.9f checksum=%llu\n", trial + 1, times[trial], total);
    }
    qsort(times, TRIALS, sizeof times[0], compare_double);
    printf("median=%.9f min=%.9f max=%.9f range=%.9f\n", times[TRIALS / 2], times[0], times[TRIALS - 1], times[TRIALS - 1] - times[0]);
    return 0;
}
