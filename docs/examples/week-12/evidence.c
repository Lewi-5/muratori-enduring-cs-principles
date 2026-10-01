#include <stdint.h>
#include <stdio.h>
int main(void)
{
    unsigned sum=255u+1u;
    uint8_t result=(uint8_t)(sum & 255u);
    const uint8_t starts[6]={1,0,0,1,0,1};
    uint16_t word=0x1234;
    uint8_t bytes[2]={(uint8_t)(word & 255u),(uint8_t)((unsigned)word >> 8)};
    uint64_t value=UINT64_MAX;
    uint64_t doubled=value*UINT64_C(2);
    printf("byte result=%u carry=%u\n",(unsigned)result,sum/256u);
    printf("target 1 boundary=%u; target 3 boundary=%u\n",
           (unsigned)starts[1],(unsigned)starts[3]);
    printf("word 1234 bytes=%02x %02x\n",(unsigned)bytes[0],(unsigned)bytes[1]);
    printf("defined unsigned result=%llu\n",(unsigned long long)(doubled+UINT64_C(1)));
    return 0;
}
