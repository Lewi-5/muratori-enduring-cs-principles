#include <stdint.h>
uint16_t low_byte(uint16_t word)
{
    return (uint16_t)(word & 255u);
}
