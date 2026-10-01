/* W02: search backwards with an unsigned index. Reference solution. */
#include <stddef.h>
#include <stdio.h>

/* Stores the index of the last element equal to target and returns 1; returns 0 and leaves
   *out unchanged when there is none. values may be NULL only when length is 0.
   The loop counts i down from length to 1 and reads values[i - 1], so the unsigned index
   never has to go below zero. */
int last_index_of(const int *values, size_t length, int target, size_t *out)
{
    if (out == NULL) return 0;
    for (size_t i = length; i > 0; --i) {
        if (values[i - 1] == target) {
            *out = i - 1;
            return 1;
        }
    }
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
