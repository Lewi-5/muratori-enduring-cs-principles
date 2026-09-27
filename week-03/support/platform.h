#ifndef WEEK03_PLATFORM_H
#define WEEK03_PLATFORM_H
#include <float.h>
#include <limits.h>
#include <stdint.h>
/* Reference-platform gate: IEC 60559 (Annex F) binary64 doubles and 8-bit bytes.
   -DGEO_FORCE_NO_IEC exercises the skip path; it does not emulate another ABI. */
#if defined(__STDC_IEC_559__) && !defined(GEO_FORCE_NO_IEC) \
    && DBL_MANT_DIG == 53 && DBL_MAX_EXP == 1024 && CHAR_BIT == 8
#define GEO_IEC559 1
_Static_assert(sizeof(double) == sizeof(uint64_t), "binary64 gate requires a 64-bit double");
#else
#define GEO_IEC559 0
#endif
#endif
