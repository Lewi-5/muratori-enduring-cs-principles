/* E01: reproducible random numbers. Learner scaffold: fill in the TODO bodies. */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include "platform.h"

/* Constants fixed by the week-4 specification. TODO (E01.Q): add _Static_assert checks of the Hull-Dobell
   conditions for a modulus of 2^64 and explain them in your notebook. */
#define LCG_MULTIPLIER UINT64_C(6364136223846793005)
#define LCG_INCREMENT UINT64_C(1442695040888963407)

/* Contract: see learner/exercises.md (E01.C). */
uint32_t lcg_next(uint64_t *state)
{
    /* TODO: advance *state first, then return its high 32 bits. */
    (void)state;
    return 0;
}

int lcg_below(uint64_t *state, uint32_t bound, uint32_t *out)
{
    /* TODO: reject bound == 0 (and NULL pointers) without touching anything; otherwise rejection-sample. */
    (void)state;
    (void)bound;
    (void)out;
    return 0;
}

/* ---- supplied driver ---- */
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
