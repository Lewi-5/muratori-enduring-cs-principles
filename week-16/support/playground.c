#include "lab.h"
#include "allocator.h"
#include <stdio.h>
static int inner(int *out) { int local=40; return local_value(local,out); }
int main(void) {
    int value=0; uint64_t first,second; Owned o={NULL,0}; Allocator a=default_allocator(); int src[]={4,7};
    if (!inner(&value) || !static_next(&first) || !static_next(&second) || !owned_copy(src,2,&a,&o)) return 1;
    printf("after helper: caller=%d static=%llu,%llu owned=%d,%d\n",value,(unsigned long long)first,(unsigned long long)second,o.data[0],o.data[1]);
    if (!owned_resize(&o,3,&a)) { owned_release(&o,&a);return 1; }
    printf("after resize: count=%zu tail=%d\n",o.count,o.data[2]);
    if (!owned_release(&o,&a)) return 1;
    printf("after release: empty=%d count=%zu\n",o.data==NULL,o.count); return ferror(stdout) ? 1:0;
}
