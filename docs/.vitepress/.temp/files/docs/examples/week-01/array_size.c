#include <stdio.h>

/* Written as the pointer it really is. Declaring the parameter as double values[4] changes
   nothing: C adjusts an array parameter to a pointer (and GCC warns about sizeof on it). */
static size_t size_inside(const double *values)
{
    return sizeof values;
}

int main(void)
{
    double values[4] = {1.0, 2.0, 3.0, 4.0};
    printf("sizeof values in main:     %zu\n", sizeof values);
    printf("sizeof values[0]:          %zu\n", sizeof values[0]);
    printf("number of elements:        %zu\n", sizeof values / sizeof values[0]);
    printf("sizeof values in function: %zu\n", size_inside(values));
    return 0;
}
