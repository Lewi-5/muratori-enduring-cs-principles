#include <limits.h>
#include "ex09_data.h"

int shared_counter = 7;
int shared_zero;
const int shared_limit = 100;
static int hidden_counter = 3;

int bump_shared(void)
{
    /* TODO: implement the corresponding learner contract. */
    return 0;
}
int bump_hidden(void)
{
    (void)hidden_counter;
    /* TODO: implement the corresponding learner contract. */
    return 0;
}
int next_local(void)
{
    /* TODO: implement the corresponding learner contract. */
    return 0;
}
int *shared_address(void) {
    /* TODO: implement the corresponding learner contract. */
    return 0;
}
const int *hidden_address(void) {
    /* TODO: implement the corresponding learner contract. */
    return 0;
}
