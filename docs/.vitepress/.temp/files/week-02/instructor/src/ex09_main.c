#include <stdio.h>
#include "ex09_data.h"

static int hidden_counter = 3;

int main(void)
{
    int before = shared_counter;
    if (!bump_shared() || !bump_hidden()) return 1;
    int local1 = next_local(), local2 = next_local(); /* Explicit sequencing. */
    printf("shared_before=%d shared_after=%d zero=%d limit=%d hidden_data=%d hidden_main=%d shared_same=%d hidden_distinct=%d local=%d,%d\n",
           before, shared_counter, shared_zero, shared_limit, *hidden_address(), hidden_counter,
           shared_address() == &shared_counter, hidden_address() != &hidden_counter, local1, local2);
    return 0;
}
