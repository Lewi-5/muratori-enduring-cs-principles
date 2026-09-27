#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int counter_bump(int *counter)
{
    if (counter == NULL || *counter == INT_MAX) return 0;
    ++*counter;
    return 1;
}

int next_static(void)
{
    static int counter;
    return counter_bump(&counter) ? counter : 0; /* 0 signals exhaustion. */
}

int next_automatic(void) { int counter = 0; return ++counter; }

static int frame(unsigned depth, const int *parent)
{
    int local = 0;
    if (parent != NULL && &local == parent) return 0;
    return depth == 0 || frame(depth - 1, &local);
}

int frames_distinct(unsigned depth) { return depth <= 1000 && frame(depth, NULL); }

int *counter_create(int start)
{
    int *counter = malloc(sizeof *counter);
    if (counter != NULL) *counter = start;
    return counter;
}
void counter_destroy(int *counter) { free(counter); }

static void automatic_snapshot(uintptr_t *out)
{
    int local = 0;
    *out = (uintptr_t)&local; /* Capture the integer before lifetime ends. */
}

int main(void)
{
    int s1 = next_static(), s2 = next_static(), s3 = next_static();
    int a1 = next_automatic(), a2 = next_automatic(), a3 = next_automatic();
    int *one = counter_create(7), *two = counter_create(7);
    if (one == NULL || two == NULL) { counter_destroy(one); counter_destroy(two); return 1; }
    int independent = one != two && counter_bump(one) && *one == 8 && *two == 7;
    counter_destroy(one);
    counter_destroy(two);
    uintptr_t first, second;
    automatic_snapshot(&first);
    automatic_snapshot(&second);
    printf("static=%d,%d,%d automatic=%d,%d,%d frames_distinct=%d alloc_independent=%d\n",
           s1, s2, s3, a1, a2, a3, frames_distinct(5), independent);
    printf("auto_reuse=%s\n", first == second ? "yes" : "no");
    return !independent;
}
