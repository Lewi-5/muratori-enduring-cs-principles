/* Warm-up contract checks (ungraded). Each warm-up source is included with its main renamed.
   Exact expectations are limited to results that binary64 represents exactly, and are gated on GEO_IEC559. */
#include <assert.h>
#include <float.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "platform.h"
#define main warmup_main
#include SOURCE
#undef main

#if WARMUP == 1
static void check(void)
{
    unsigned char bytes[sizeof(double)], sentinel[sizeof(double)];
    memset(sentinel, 0xAB, sizeof sentinel);
    memcpy(bytes, sentinel, sizeof bytes);
    assert(!double_bytes(1.0, NULL));
    const double values[] = {1.0, -2.0, 0.5, 0.1, -0.0, DBL_MAX, DBL_TRUE_MIN};
    for (size_t i = 0; i < sizeof values / sizeof values[0]; ++i) {
        assert(double_bytes(values[i], bytes));
        assert(memcmp(bytes, &values[i], sizeof bytes) == 0); /* the object's own bytes, in memory order */
    }
    uint64_t bits = 7;
    assert(!double_bits(1.0, NULL));
    if (!GEO_IEC559) { assert(!double_bits(1.0, &bits) && bits == 7); puts("checks skipped"); return; }
    assert(double_bits(1.0, &bits) && bits == UINT64_C(0x3FF0000000000000));
    assert(double_bits(-2.0, &bits) && bits == UINT64_C(0xC000000000000000));
    assert(double_bits(0.5, &bits) && bits == UINT64_C(0x3FE0000000000000));
    assert(double_bits(0.1, &bits) && bits == UINT64_C(0x3FB999999999999A));
    assert(double_bits(-0.0, &bits) && bits == UINT64_C(0x8000000000000000));
    /* bits and bytes agree: the integer's representation is the double's representation */
    assert(double_bits(0.1, &bits) && double_bytes(0.1, bytes) && memcmp(bytes, &bits, sizeof bits) == 0);
}
#elif WARMUP == 2
static void check(void)
{
    if (!GEO_IEC559) { puts("checks skipped"); return; }
    assert(gap_above(1.0) == 0x1p-52);
    assert(gap_above(2.0) == 0x1p-51);
    assert(gap_above(1.5) == 0x1p-52);             /* same binade as 1: same spacing */
    assert(gap_above(1024.0) == 0x1p-42);
    assert(gap_above(0x1p52) == 1.0);
    assert(gap_above(0x1p53) == 2.0);
    assert(gap_above(-1.0) == 0x1p-53);            /* above -1 lies the binade [0.5, 1) in magnitude */
    assert(gap_above(0.0) == DBL_TRUE_MIN);
    assert(absorbs_one(0x1p52) == 0 && absorbs_one(0x1p53) == 1 && absorbs_one(1e16) == 1);
    assert(absorbs_one(1.0) == 0 && absorbs_one(-0x1p53) == 0);  /* -2^53 + 1 is representable */
}
#elif WARMUP == 3
static void check(void)
{
    const double cases[][2] = {{0, 0}, {179, 179}, {180, -180}, {190, -170}, {-180, -180}, {-190, 170},
                               {539, 179}, {-540, -180}, {359.5, -0.5}, {-0.0, 0}};
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        double out = 42.0;
        assert(wrap_small(cases[i][0], &out) && out == cases[i][1]);
        assert(out >= -180.0 && out < 180.0);
    }
    const double rejected[] = {540.0, -540.5, 1e300, INFINITY, -INFINITY, NAN};
    for (size_t i = 0; i < sizeof rejected / sizeof rejected[0]; ++i) {
        double out = 42.0;
        assert(!wrap_small(rejected[i], &out) && out == 42.0);
    }
    assert(!wrap_small(0.0, NULL));
}
#elif WARMUP == 4
static void check(void)
{
    assert(orientation(0, 0, 4, 0, 1, 3) == 1);
    assert(orientation(0, 0, 4, 0, 1, -3) == -1);
    assert(orientation(0, 0, 4, 0, 8, 0) == 0);
    assert(orientation(0, 0, 4, 0, -2, 0) == 0);
    assert(orientation(1, 1, 1, 1, 5, 7) == 0);    /* a == b: degenerate, every point is "collinear" */
    assert(orientation(0, 0, 1, 1, 2, 2) == 0);
    /* swapping a and b reverses the turn */
    assert(orientation(4, 0, 0, 0, 1, 3) == -1);
    /* large coordinates at the edge of the stated domain stay exact */
    const long long m = 1LL << 30;
    assert(orientation(-m, -m, m, m, m - 1, m) == 1);
    assert(orientation(-m, -m, m, m, m, m - 1) == -1);
    assert(orientation(-m, -m, m, m, 0, 0) == 0);
}
#else
#error WARMUP must be 1, 2, 3 or 4
#endif

int main(void)
{
    check();
    puts("warm-up passed");
    return 0;
}
