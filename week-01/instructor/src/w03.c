/* W03: bytes and bits of a value. Reference solution. */
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>

/* Byte number index (0 = least significant) of the *value*, found with shifts and a mask.
   This does not depend on how the machine orders the bytes in memory. index must be 0..3. */
unsigned byte_at(uint32_t value, unsigned index)
{
    return (unsigned)((value >> (8u * index)) & 0xFFu);
}

/* Number of 1 bits in value. value &= value - 1 clears the lowest set bit each time. */
unsigned bit_count(uint32_t value)
{
    unsigned count = 0;
    while (value != 0) {
        value &= value - 1u;
        ++count;
    }
    return count;
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
