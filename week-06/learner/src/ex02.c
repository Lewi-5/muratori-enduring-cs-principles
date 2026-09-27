/* E02: register names. Implement reg_name; the driver is supplied. */
#include <stddef.h>
#include <stdio.h>

const char *reg_name(unsigned wide, unsigned reg)
{
    /* TODO: the canonical name ("al" ... "bh" for w = 0, "ax" ... "di" for w = 1), or NULL when wide > 1 or reg > 7 */
    (void)wide;
    (void)reg;
    return NULL;
}

int main(void)
{
    for (unsigned w = 0; w < 2; ++w) {
        printf("w=%u", w);
        for (unsigned r = 0; r < 8; ++r) printf(" %u=%s", r, reg_name(w, r) ? reg_name(w, r) : "?");
        printf("\n");
    }
    return 0;
}
