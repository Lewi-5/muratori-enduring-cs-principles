#include <limits.h>
#include <stdio.h>

int main(void)
{
    /* Each conversion matches the promoted argument's type. */
    printf("signed=%d unsigned=%u long=%ld ull=%llu\n", -7, 7u, -42L, 42ULL);
    printf("int_min=%d int_max=%d uint_max=%u\n", INT_MIN, INT_MAX, UINT_MAX);
    return 0;
}
