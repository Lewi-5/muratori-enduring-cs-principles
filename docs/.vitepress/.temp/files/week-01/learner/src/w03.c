/* W03: bytes and bits of a value. Warm-up scaffold: fill in the TODO bodies. */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>

unsigned byte_at(uint32_t value, unsigned index)
{
    /* TODO: implement the contract in learner/warmups.md. */
    (void)value;
    (void)index;
    return 0;
}

unsigned bit_count(uint32_t value)
{
    /* TODO: implement the contract in learner/warmups.md. */
    (void)value;
    return 0;
}

int main(void)
{
    const uint32_t value = UINT32_C(0x01020304);
    printf("value=0x%08" PRIX32 " bytes (least significant first):", value);
    for (unsigned i = 0; i < 4; ++i) printf(" %02x", byte_at(value, i));
    printf("\nbits set: %u in 0x%08" PRIX32 ", %u in 0xFFFFFFFF, %u in 0\n", bit_count(value), value,
           bit_count(UINT32_C(0xFFFFFFFF)), bit_count(0));
    return 0;
}
