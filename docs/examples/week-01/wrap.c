#include <limits.h>
#include <stdio.h>

int main(void)
{
    unsigned int top = UINT_MAX;
    unsigned int next = top + 1u;        /* defined: unsigned arithmetic wraps modulo UINT_MAX + 1 */
    printf("UINT_MAX = %u, UINT_MAX + 1u = %u\n", top, next);
    printf("INT_MAX  = %d\n", INT_MAX);  /* INT_MAX + 1 would be undefined: this program never computes it */
    return 0;
}
