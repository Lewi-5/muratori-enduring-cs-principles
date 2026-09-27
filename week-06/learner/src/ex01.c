/* E01: bit fields. Implement split_modrm and bit_at; the driver is supplied. */
#include <stdint.h>
#include <stdio.h>

typedef struct { unsigned mod, reg, rm; } ModRM;

ModRM split_modrm(uint8_t byte)
{
    /* TODO: mod = bits 7..6, reg = bits 5..3, rm = bits 2..0, with unsigned shifts and masks */
    (void)byte;
    ModRM m = {0, 0, 0};
    return m;
}

unsigned bit_at(uint8_t byte, unsigned index)
{
    /* TODO: bit index of byte (0 = least significant); return 0 for index > 7 */
    (void)byte;
    (void)index;
    return 0;
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
