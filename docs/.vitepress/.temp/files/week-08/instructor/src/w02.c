#include <stdint.h>
uint16_t replace_high(uint16_t word, uint8_t high)
{
    return (uint16_t)(((uint32_t)word & 255u) | ((uint32_t)high << 8));
}
