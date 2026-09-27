/* E01: reproducible random numbers. Reference solution. */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include "platform.h"

/* Constants of the generator (fixed by the week-4 specification; replaced in week 47). Hull-Dobell for the
   modulus 2^64, whose only prime factor is 2: the increment must be odd and (multiplier - 1) must be divisible
   by 2 and, because 4 divides the modulus, by 4. Both are checked at compile time. */
#define LCG_MULTIPLIER UINT64_C(6364136223846793005)
#define LCG_INCREMENT UINT64_C(1442695040888963407)
_Static_assert(LCG_INCREMENT % 2 == 1, "Hull-Dobell: the increment must be odd");
_Static_assert((LCG_MULTIPLIER - 1) % 4 == 0, "Hull-Dobell: multiplier - 1 must be divisible by 4");

/* Advance the state, then return its high 32 bits. Unsigned arithmetic wraps modulo 2^64 by definition
   (C11 6.2.5p9), so this is a pure function of *state on every conforming implementation. */
uint32_t lcg_next(uint64_t *state)
{
    *state = *state * LCG_MULTIPLIER + LCG_INCREMENT;
    return (uint32_t)(*state >> 32);
}

/* Unbiased value in [0, bound) by rejection sampling. Draws r until r >= threshold, where threshold =
   2^32 mod bound; the accepted range [threshold, 2^32) has 2^32 - threshold values, a multiple of bound,
   so every residue r % bound is equally likely. Rejects (returns 0, both objects unchanged) for a NULL
   pointer or bound == 0. Bound 1 always accepts the first draw and yields 0 (it still consumes a draw). */
int lcg_below(uint64_t *state, uint32_t bound, uint32_t *out)
{
    if (state == NULL || out == NULL || bound == 0) return 0;
    uint32_t threshold = (uint32_t)(UINT32_C(0) - bound) % bound; /* == 2^32 mod bound, computed in uint32_t */
    uint32_t r = lcg_next(state);
    while (r < threshold) r = lcg_next(state);
    *out = r % bound;
    return 1;
}

int main(void)
{
    uint64_t state = 0;
    uint32_t a = lcg_next(&state); /* every draw is its own statement: no argument-evaluation-order dependence */
    uint32_t b = lcg_next(&state);
    uint32_t c = lcg_next(&state);
    printf("seed=0 first=%08" PRIX32 ",%08" PRIX32 ",%08" PRIX32 "\n", a, b, c);
    state = 0;
    printf("bound7=");
    for (int i = 0; i < 10; ++i) {
        uint32_t v = 0;
        if (!lcg_below(&state, 7, &v)) return 1;
        printf(i == 0 ? "%" PRIu32 : ",%" PRIu32, v);
    }
    printf("\n");
    return 0;
}
