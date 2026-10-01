/* W02: search backwards with an unsigned index. Warm-up scaffold: fill in the TODO body. */
#include <stddef.h>
#include <stdio.h>

int last_index_of(const int *values, size_t length, int target, size_t *out)
{
    /* TODO: implement the contract in learner/warmups.md. */
    (void)values;
    (void)length;
    (void)target;
    (void)out;
    return 0;
}

int main(void)
{
    const int values[] = {4, -2, 7, 7, 1};
    const int targets[] = {7, 4, 1, 9};
    for (int t = 0; t < 4; ++t) {
        size_t at = 99;
        int found = last_index_of(values, 5, targets[t], &at);
        printf("last %d -> found=%d index=%zu\n", targets[t], found, at);
    }
    return 0;
}
