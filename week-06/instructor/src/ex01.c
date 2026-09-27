/* E01: bit fields. Reference solution. */
#include <stdint.h>
#include <stdio.h>

typedef struct { unsigned mod, reg, rm; } ModRM;

/* A uint8_t operand is promoted to int before the shift (C11 6.3.1.1); every value is at most 255, so each shift
   and mask here is exact and nonnegative. The masks matter: byte >> 3 alone would keep the mod bits too. */
ModRM split_modrm(uint8_t byte)
{
    ModRM m;
    m.mod = (unsigned)(byte >> 6) & 3u;
    m.reg = (unsigned)(byte >> 3) & 7u;
    m.rm = (unsigned)byte & 7u;
    return m;
}

/* Bit index (0 = least significant) of byte; an index above 7 is rejected by returning 0, as documented. */
unsigned bit_at(uint8_t byte, unsigned index)
{
    if (index > 7) return 0;
    return ((unsigned)byte >> index) & 1u;
}

static void print_bits(unsigned value, unsigned width)
{
    for (unsigned i = width; i > 0; --i) putchar(bit_at((uint8_t)value, i - 1) ? '1' : '0');
}

int main(void)
{
    static const uint8_t samples[] = {0xD9, 0xCB, 0xC6, 0x00};
    for (size_t i = 0; i < sizeof samples; ++i) {
        ModRM m = split_modrm(samples[i]);
        printf("byte=0x%02X mod=", samples[i]);
        print_bits(m.mod, 2);
        printf(" reg=");
        print_bits(m.reg, 3);
        printf(" rm=");
        print_bits(m.rm, 3);
        printf("\n");
    }
    return 0;
}
