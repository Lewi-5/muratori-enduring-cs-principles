#include <stddef.h>
#include <stdio.h>

static void show(int *a)
{
    printf("parameter=%zu first=%d\n", sizeof a, a[0]);
}

int main(void)
{
    int a[3] = {2, 4, 6};
    printf("array=%zu element=%zu length=%zu\n", sizeof a, sizeof a[0], sizeof a / sizeof a[0]);
    show(a);
    int sum = 0;
    for (size_t i = 0; i < 3; ++i) sum += a[i];
    printf("sum=%d\n", sum);
    return 0;
}
