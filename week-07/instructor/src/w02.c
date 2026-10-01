#include <stddef.h>
#include <stdint.h>
int32_t signed_byte(uint8_t raw)
{
    return raw >= 128 ? (int32_t)raw - 256 : (int32_t)raw;
}
