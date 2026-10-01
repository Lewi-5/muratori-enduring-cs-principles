#include <stdint.h>
int carry8(uint8_t a, uint8_t b)
{
    return (unsigned)a+(unsigned)b>255u;
}
