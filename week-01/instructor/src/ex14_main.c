#include <stdio.h>
#include "ex14_count.h"

int main(void)
{
    const int values[] = {2, 4, 2, 2, 7};
    printf("matches=%zu\n", count_equal(values, 5, 2));
    return 0;
}
