#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

static void show(const char *name, double value)
{
    uint64_t bits;
    memcpy(&bits, &value, sizeof bits); /* copy the bytes; never cast the pointer */
    unsigned sign = (unsigned)(bits >> 63);
    unsigned exponent = (unsigned)((bits >> 52) & 0x7FF);
    uint64_t fraction = bits & ((UINT64_C(1) << 52) - 1);
    printf("%-5s bits=0x%016" PRIX64 " sign=%u exponent=%4u (2^%-5d) fraction=0x%013" PRIX64 "\n",
           name, bits, sign, exponent, (int)exponent - 1023, fraction);
}

int main(void)
{
    show("1.0", 1.0);
    show("0.5", 0.5);
    show("-2.0", -2.0);
    show("3.0", 3.0);
    show("0.1", 0.1);
    return 0;
}
