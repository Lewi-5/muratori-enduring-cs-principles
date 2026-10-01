/* E02: comparing values. Reference solution. */
#include <float.h>
#include <inttypes.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "platform.h"

/* Contract: returns 0 and leaves *equal unchanged for a NULL output or a tolerance that is
   NaN, infinite or negative. Otherwise *equal is set and 1 is returned. */
int approx_equal(double a, double b, double rel_tol, double abs_tol, int *equal)
{
    if (equal == NULL || !isfinite(rel_tol) || !isfinite(abs_tol) || rel_tol < 0.0 || abs_tol < 0.0) return 0;
    if (isnan(a) || isnan(b)) { *equal = 0; return 1; }
    if (a == b) { *equal = 1; return 1; }          /* equal infinities and +0/-0 */
    if (isinf(a) || isinf(b)) { *equal = 0; return 1; }
    double diff = fabs(a - b);
    if (isinf(diff)) { *equal = 0; return 1; }     /* difference overflowed: by contract, not equal */
    double scale = fmax(fabs(a), fabs(b));
    double limit = fmax(abs_tol, rel_tol * scale);
    *equal = diff <= limit;
    return 1;
}

/* Monotone key: adjacent doubles have keys that differ by one; -0.0 and +0.0 share a key. */
static uint64_t ordered_key(double value)
{
    uint64_t bits;
    memcpy(&bits, &value, sizeof bits);
    uint64_t magnitude = bits & UINT64_C(0x7FFFFFFFFFFFFFFF);
    const uint64_t zero_key = UINT64_C(0x8000000000000000);
    return (bits >> 63) ? zero_key - magnitude : zero_key + magnitude;
}

int ulp_distance(double a, double b, uint64_t *out)
{
    if (!GEO_IEC559 || out == NULL || !isfinite(a) || !isfinite(b)) return 0;
    uint64_t ka = ordered_key(a), kb = ordered_key(b);
    *out = ka > kb ? ka - kb : kb - ka;             /* unsigned subtraction of the larger key */
    return 1;
}

double add3_left(double a, double b, double c) { return (a + b) + c; }
double add3_right(double a, double b, double c) { return a + (b + c); }

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
