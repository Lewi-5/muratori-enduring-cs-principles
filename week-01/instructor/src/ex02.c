#include <stdio.h>
#include <stddef.h>

/* Array parameter syntax would also be adjusted to int *. */
static size_t parameter_size(int *values)
{
    return sizeof values;
}

int main(void)
{
    int values[5] = {0};
    printf("char=%zu short=%zu int=%zu long=%zu pointer=%zu\n",
           sizeof(char), sizeof(short), sizeof(int), sizeof(long), sizeof(int *));
    printf("array=%zu element=%zu length=%zu parameter=%zu\n",
           sizeof values, sizeof values[0], sizeof values / sizeof values[0],
           parameter_size(values));
    return 0;
}
