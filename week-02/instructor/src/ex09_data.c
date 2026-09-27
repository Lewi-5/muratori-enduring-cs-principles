#include <limits.h>
#include "ex09_data.h"

int shared_counter = 7;
int shared_zero;
const int shared_limit = 100;
static int hidden_counter = 3;

int bump_shared(void)
{
    if (shared_counter == INT_MAX) return 0;
    ++shared_counter;
    return 1;
}
int bump_hidden(void)
{
    if (hidden_counter == INT_MAX) return 0;
    ++hidden_counter;
    return 1;
}
int next_local(void)
{
    static int local;
    if (local == INT_MAX) return 0;
    return ++local;
}
int *shared_address(void) { return &shared_counter; }
const int *hidden_address(void) { return &hidden_counter; }
