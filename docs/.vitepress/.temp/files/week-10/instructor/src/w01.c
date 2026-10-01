#include "machine.h"
int w01(unsigned p, int32_t *out)
{
    if (!out || p>65535) return 0;
    *out=p<32768 ? (int32_t)p : (int32_t)p-65536;
    return 1;
}
