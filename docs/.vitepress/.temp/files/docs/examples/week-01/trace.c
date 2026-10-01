#include <stdio.h>

int main(void)
{
    const int values[] = {3, 5, -1};
    const size_t length = sizeof values / sizeof values[0];
    long sum = 0;
    printf("before the loop: sum=%ld (the empty prefix)\n", sum);
    for (size_t i = 0; i < length; ++i) {
        sum += values[i];
        printf("after i=%zu: sum=%ld covers values[0..%zu]\n", i, sum, i);
    }
    return 0;
}
