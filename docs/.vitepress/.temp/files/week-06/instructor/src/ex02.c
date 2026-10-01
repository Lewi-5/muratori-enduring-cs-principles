/* E02: register names. Reference solution. */
#include <stddef.h>
#include <stdio.h>

/* The 3-bit register field with the w bit. w = 0 selects an 8-bit register: the low (al, cl, dl, bl) or high
   (ah, ch, dh, bh) half of ax, cx, dx, bx. w = 1 selects a 16-bit register. sp, bp, si and di have no 8-bit halves
   on the 8086, which is why field value 4 means ah (w = 0) but sp (w = 1). */
const char *reg_name(unsigned wide, unsigned reg)
{
    static const char *const names[2][8] = {{"al", "cl", "dl", "bl", "ah", "ch", "dh", "bh"},
                                            {"ax", "cx", "dx", "bx", "sp", "bp", "si", "di"}};
    if (wide > 1 || reg > 7) return NULL;
    return names[wide][reg];
}

int main(void)
{
    for (unsigned w = 0; w < 2; ++w) {
        printf("w=%u", w);
        for (unsigned r = 0; r < 8; ++r) printf(" %u=%s", r, reg_name(w, r));
        printf("\n");
    }
    return 0;
}
