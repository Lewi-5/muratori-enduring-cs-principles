/* E07: accumulation versus explicit calculation. Learner scaffold: fill in the TODO bodies. */
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "platform.h"

#define GRID_MAX 16777216u /* 2^24 */

/* Contracts: see learner/exercises.md (E07.C). Sums: reject NULL out, or NULL v with n > 0; n == 0 succeeds with
   0; non-finite input and overflow follow IEEE arithmetic and still return 1. */
int sum_naive(const double *v, size_t n, double *out)
{
    /* TODO: left to right. */
    (void)v;
    (void)n;
    (void)out;
    return 0;
}

int sum_pairwise(const double *v, size_t n, double *out)
{
    /* TODO: split at n / 2; blocks of at most 8 elements are summed naively. */
    (void)v;
    (void)n;
    (void)out;
    return 0;
}

int sum_neumaier(const double *v, size_t n, double *out)
{
    /* TODO: Kahan-Babuska compensation whose correction term is valid whichever operand is larger. */
    (void)v;
    (void)n;
    (void)out;
    return 0;
}

int grid_accumulated(double start, double step, size_t n, double *out)
{
    /* TODO: x += step. Reject n > GRID_MAX, non-finite start/step, and a non-finite final element, before writing. */
    (void)start;
    (void)step;
    (void)n;
    (void)out;
    return 0;
}

int grid_explicit(double start, double step, size_t n, double *out)
{
    /* TODO: start + i * step with i converted to double. Same rejections. */
    (void)start;
    (void)step;
    (void)n;
    (void)out;
    return 0;
}

/* ---- supplied driver ---- */
static void report(const char *name, const double *v, size_t n)
{
    double a = 0.0, b = 0.0, c = 0.0;
    if (!sum_naive(v, n, &a) || !sum_pairwise(v, n, &b) || !sum_neumaier(v, n, &c)) exit(1);
    printf("case=%s naive=%.17g pairwise=%.17g neumaier=%.17g\n", name, a, b, c);
}

int main(void)
{
    enum { N = 1000000 };
    double *v = malloc(N * sizeof *v);
    if (v == NULL) return 1;
    static const double cancel[4] = {1e16, 1.0, -1e16, 1.0};
    report("cancel", cancel, 4);
    for (size_t i = 0; i < N; ++i) v[i] = 0.1;
    report("tenths", v, N);
    for (size_t i = 0; i < N; ++i) v[i] = (double)(i + 1);
    report("ramp", v, N);
    for (size_t i = 0; i < N; ++i) v[i] = (double)((uint64_t)(i + 1) * 2654435761u % 1000003u) / 7.0;
    report("hashed", v, N);
    free(v);
    enum { G = 1000001 };
    double *acc = malloc(G * sizeof *acc), *expl = malloc(G * sizeof *expl);
    if (acc == NULL || expl == NULL) return 1;
    if (!grid_accumulated(0.0, 0.1, G, acc) || !grid_explicit(0.0, 0.1, G, expl)) return 1;
    double worst_acc = 0.0, worst_exp = 0.0;
    for (size_t i = 1; i < G; ++i) {
        double ref = (double)i / 10.0;
        double e1 = fabs(acc[i] - ref) / ref, e2 = fabs(expl[i] - ref) / ref;
        if (e1 > worst_acc) worst_acc = e1;
        if (e2 > worst_exp) worst_exp = e2;
    }
    printf("grid n=%d accumulated_max_rel_err=%.6e explicit_max_rel_err=%.6e\n", G, worst_acc, worst_exp);
    free(acc);
    free(expl);
    return 0;
}
