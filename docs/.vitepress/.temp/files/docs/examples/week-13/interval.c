#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
int main(void)
{
    uint64_t seconds=2, nanos=300, begin=2000000100;
    uint64_t end=seconds*UINT64_C(1000000000)+nanos;
    if(end<begin)return 1;
    printf("end=%" PRIu64 " elapsed=%" PRIu64 " ns\n",end,end-begin);
    return 0;
}
