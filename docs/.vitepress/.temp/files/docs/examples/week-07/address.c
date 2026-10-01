#include <stdint.h>
#include <stdio.h>
int main(void)
{
    const uint8_t b[] = {0x8b, 0x46, 0xfe};
    unsigned mod = b[1] >> 6, rm = b[1] & 7u;
    int32_t d = b[2] >= 128 ? (int32_t)b[2] - 256 : (int32_t)b[2];
    printf("mod=%u rm=%u displacement=%ld\n", mod, rm, (long)d);
    unsigned direct = 0xfeu + 256u * 0xffu;
    printf("direct=%u\n", direct);
    return 0;
}
