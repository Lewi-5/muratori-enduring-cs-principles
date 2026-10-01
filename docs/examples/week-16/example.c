#include <stdio.h>
#include <stdlib.h>
static int next(void) { static int count;return ++count; }
static void helper(int *out) { int local=40;*out=local+1; }
int main(void)
{
    int caller=0;helper(&caller);
    int *owner=malloc(sizeof *owner);if (!owner) return 1;
    *owner=7;
    int first=next(),second=next();
    printf("caller=%d static=%d,%d allocated=%d\n",caller,first,second,*owner);
    free(owner);owner=NULL;
    printf("owner cleared=%d\n",owner==NULL);
    return 0;
}
