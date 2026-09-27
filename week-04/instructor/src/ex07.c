/* E07: accumulation versus explicit calculation. Reference solution. */
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "platform.h"

#define PAIRWISE_BLOCK 8
#define GRID_MAX 16777216u /* 2^24 */

/* All sums: reject (return 0, *out unchanged) if out is NULL, or v is NULL with n > 0. n == 0 succeeds with 0.
   Non-finite inputs and overflow follow IEEE arithmetic (the result may be +-infinity or NaN) and return 1.
   Nothing here relies on integer overflow; the loops are bounded by n. Partial sums start from +0.0. */

/* Left to right. Error bound (Higham, Accuracy and Stability of Numerical Algorithms, 2nd ed., section 4.2):
   |error| <= gamma_(n-1) * sum(|v_i|), with gamma_k = k u / (1 - k u) and u = 2^-53. */
int sum_naive(const double *v, size_t n, double *out)
{
    if (out == NULL || (v == NULL && n > 0)) return 0;
    double s = 0.0;
    for (size_t i = 0; i < n; ++i) s += v[i];
    *out = s;
    return 1;
}

static double pairwise_rec(const double *v, size_t n)
{
    if (n <= PAIRWISE_BLOCK) {
        double s = 0.0;
        for (size_t i = 0; i < n; ++i) s += v[i];
        return s;
    }
    size_t half = n / 2;
    return pairwise_rec(v, half) + pairwise_rec(v + half, n - half);
}

/* Split at n / 2 until a block has at most 8 elements, sum blocks naively, add the halves. Each value takes part
   in at most 7 additions inside its block plus one per level of the tree, so the bound is
   gamma_(7 + ceil(log2(n / 8))) * sum(|v_i|). The recursion depth is ceil(log2(n / 8)) (17 for n = 10^6). */
int sum_pairwise(const double *v, size_t n, double *out)
{
    if (out == NULL || (v == NULL && n > 0)) return 0;
    *out = pairwise_rec(v, n);
    return 1;
}

/* Kahan-Babuska (Neumaier) compensated summation: c collects the rounding error of each addition, computed
   exactly by the branch that subtracts the smaller operand from the larger first. Bound (Ogita, Rump, Oishi,
   "Accurate Sum and Dot Product", SIAM J. Sci. Comput. 26, 2005, Sum2): |result - s| <= u |s| +
   gamma_(n-1)^2 sum(|v_i|). The correction is only valid if the compiler evaluates the expressions as written:
   with reassociation (-ffast-math) (sum - t) + x simplifies to 0 and the compensation vanishes.
   A non-finite input makes the correction inf - inf = NaN, so the result is NaN even where the naive sum is
   infinite; this is IEEE arithmetic being followed, not an error return. */
int sum_neumaier(const double *v, size_t n, double *out)
{
    if (out == NULL || (v == NULL && n > 0)) return 0;
    double sum = 0.0, c = 0.0;
    for (size_t i = 0; i < n; ++i) {
        double x = v[i];
        double t = sum + x;
        if (fabs(sum) >= fabs(x)) c += (sum - t) + x; /* sum is the larger operand: its low bits were lost */
        else c += (x - t) + sum;                      /* x is the larger operand */
        sum = t;
    }
    *out = sum + c;
    return 1;
}

/* Grid of n values by repeated addition: x_0 = start, x_(i+1) = x_i + step. Rejects n > 2^24, non-finite start or
   step, a NULL out with n > 0, and a non-finite final element. Validation is a first pass with no writes:
   for a monotone grid every element is finite when the last one is, and rounding cannot make it non-monotone. */
int grid_accumulated(double start, double step, size_t n, double *out)
{
    if (n > GRID_MAX || !isfinite(start) || !isfinite(step) || (out == NULL && n > 0)) return 0;
    if (n == 0) return 1;
    double x = start;
    for (size_t i = 1; i < n; ++i) x += step;
    if (!isfinite(x)) return 0;
    x = start;
    for (size_t i = 0; i < n; ++i) {
        out[i] = x;
        if (i + 1 < n) x += step; /* do not calculate a value beyond the requested grid */
    }
    return 1;
}

/* Grid by explicit calculation: x_i = start + i * step with i converted to double (exact, i <= 2^24). Same
   rejections. Each element has at most two roundings whatever i is; nothing accumulates. */
int grid_explicit(double start, double step, size_t n, double *out)
{
    if (n > GRID_MAX || !isfinite(start) || !isfinite(step) || (out == NULL && n > 0)) return 0;
    if (n == 0) return 1;
    double last = start + (double)(n - 1) * step;
    if (!isfinite(last)) return 0;
    for (size_t i = 0; i < n; ++i) out[i] = start + (double)i * step;
    return 1;
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
    if (acc == NULL || expl == NULL) { free(acc); free(expl); return 1; }
    if (!grid_accumulated(0.0, 0.1, G, acc) || !grid_explicit(0.0, 0.1, G, expl)) {
        free(acc);
        free(expl);
        return 1;
    }
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
