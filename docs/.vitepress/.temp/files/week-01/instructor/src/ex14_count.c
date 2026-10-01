#include "ex14_count.h"

size_t count_equal(const int *values, size_t length, int target)
{
    size_t count = 0;
    for (size_t i = 0; i < length; ++i) if (values[i] == target) ++count;
    return count;
}
