#include <stdint.h>
#include <stdio.h>
int main(void)
{
    uint16_t ax=0x1234;
    ax=(uint16_t)(((uint32_t)ax & 255u) | (255u << 8));
    printf("ax=%04x ah=%u al=%u\n",(unsigned)ax,(unsigned)(ax >> 8),(unsigned)(ax & 255u));
    unsigned a=127, b=1, full=a+b, result=full & 255u;
    int carry=full>255, overflow=(a<128 && b<128 && result>=128);
    printf("127+1 result=%u carry=%d overflow=%d\n",result,carry,overflow);
    a=255; full=a+b; result=full & 255u;
    carry=full>255; overflow=(a<128 && b<128 && result>=128);
    printf("255+1 result=%u carry=%d overflow=%d\n",result,carry,overflow);
    return 0;
}
