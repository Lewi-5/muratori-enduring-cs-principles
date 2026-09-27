/* E01: binary64 anatomy. Reference solution. */
#include <float.h>
#include <inttypes.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "platform.h"

typedef enum { FP_CLASS_ZERO, FP_CLASS_SUBNORMAL, FP_CLASS_NORMAL, FP_CLASS_INFINITE, FP_CLASS_NAN } DoubleClass;
typedef struct { unsigned sign; unsigned exponent; uint64_t fraction; DoubleClass kind; } DoubleParts;

#define FRACTION_BITS 52
#define FRACTION_MASK ((UINT64_C(1) << FRACTION_BITS) - 1)

int decompose_double(double value, DoubleParts *out)
{
    if (!GEO_IEC559 || out == NULL) return 0;
    uint64_t bits;
    memcpy(&bits, &value, sizeof bits); /* legal object-byte copy; a pointer cast would not be */
    DoubleParts parts;
    parts.sign = (unsigned)(bits >> 63);
    parts.exponent = (unsigned)((bits >> FRACTION_BITS) & 0x7FF);
    parts.fraction = bits & FRACTION_MASK;
    if (parts.exponent == 0) parts.kind = parts.fraction == 0 ? FP_CLASS_ZERO : FP_CLASS_SUBNORMAL;
    else if (parts.exponent == 0x7FF) parts.kind = parts.fraction == 0 ? FP_CLASS_INFINITE : FP_CLASS_NAN;
    else parts.kind = FP_CLASS_NORMAL;
    *out = parts; /* commit only after every step has succeeded */
    return 1;
}

int compose_double(unsigned sign, unsigned exponent, uint64_t fraction, double *out)
{
    if (!GEO_IEC559 || out == NULL || sign > 1 || exponent > 0x7FF || fraction > FRACTION_MASK) return 0;
    uint64_t bits = ((uint64_t)sign << 63) | ((uint64_t)exponent << FRACTION_BITS) | fraction;
    double value;
    memcpy(&value, &bits, sizeof value);
    *out = value;
    return 1;
}

static const char *class_name(DoubleClass kind)
{
    static const char *const names[] = {"zero", "subnormal", "normal", "infinite", "nan"};
    return names[kind];
}

int main(void)
{
    struct { const char *name; double value; } const samples[] = {
        {"1.0", 1.0}, {"0.5", 0.5}, {"-2.0", -2.0}, {"0.1", 0.1}, {"0.0", 0.0}, {"-0.0", -0.0},
        {"DBL_MIN", DBL_MIN}, {"DBL_TRUE_MIN", DBL_TRUE_MIN}, {"DBL_MAX", DBL_MAX},
        {"infinity", INFINITY}, {"nan", NAN}
    };
    puts(GEO_IEC559 ? "ieee754_binary64=checked" : "ieee754_binary64=skipped");
    if (!GEO_IEC559) return 0;
    for (size_t i = 0; i < sizeof samples / sizeof samples[0]; ++i) {
        DoubleParts parts;
        if (!decompose_double(samples[i].value, &parts)) return 1;
        printf("value=%s sign=%u exp=%u frac=0x%013" PRIX64 " class=%s\n", samples[i].name,
               parts.sign, parts.exponent, parts.fraction, class_name(parts.kind));
    }
    return 0;
}
