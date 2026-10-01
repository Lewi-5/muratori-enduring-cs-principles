/* E02: comparing values. Learner scaffold: fill in the TODO bodies. */
#include <float.h>
#include <inttypes.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "platform.h"

/* Contracts: see learner/exercises.md (E02.C). */
int approx_equal(double a, double b, double rel_tol, double abs_tol, int *equal)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)a;
    (void)b;
    (void)rel_tol;
    (void)abs_tol;
    (void)equal;
    return 0;
}

int ulp_distance(double a, double b, uint64_t *out)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)a;
    (void)b;
    (void)out;
    return 0;
}

double add3_left(double a, double b, double c)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)a;
    (void)b;
    (void)c;
    return 0.0;
}

double add3_right(double a, double b, double c)
{
    /* TODO: implement the contract in learner/exercises.md. */
    (void)a;
    (void)b;
    (void)c;
    return 0.0;
}

int main(void)
{
    puts(GEO_IEC559 ? "ieee754_binary64=checked" : "ieee754_binary64=skipped");
    double left = add3_left(0.1, 0.2, 0.3);
    double right = add3_right(0.1, 0.2, 0.3);
    double sum = 0.1 + 0.2;
    double target = 0.3;
    uint64_t lr = 0, st = 0;
    if (!ulp_distance(left, right, &lr) || !ulp_distance(sum, target, &st)) return !GEO_IEC559 ? 0 : 1;
    printf("left=%.17g right=%.17g ulps=%" PRIu64 "\n", left, right, lr);
    printf("sum=%.17g target=%.17g ulps=%" PRIu64 "\n", sum, target, st);
    return 0;
}
