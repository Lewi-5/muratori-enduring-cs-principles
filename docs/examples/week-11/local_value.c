#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
static uint64_t local_value(uint64_t value)
{
    uint64_t doubled=value*UINT64_C(2);
    return doubled+UINT64_C(1);
}
int main(void)
{
    printf("value=7 result=%" PRIu64 "\n",local_value(7));
    printf("value=max result=%" PRIu64 "\n",local_value(UINT64_MAX));
    return 0;
}
