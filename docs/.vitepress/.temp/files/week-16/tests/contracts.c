#include "lab.h"
#include <assert.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct { unsigned attempts,allocations,frees; int fail; void *live[8]; } Tracking;
static void *allocate(void *ctx,size_t n) {
    Tracking *t=ctx; ++t->attempts; if (t->fail) return NULL;
    assert(n>0); void *p=malloc(n); assert(p);
    for (unsigned i=0;i<8;++i) if (!t->live[i]) { t->live[i]=p; ++t->allocations; return p; }
    assert(0); return NULL;
}
static void release(void *ctx,void *p) {
    Tracking *t=ctx; assert(p);
    for (unsigned i=0;i<8;++i) if (t->live[i]==p) { t->live[i]=NULL; ++t->frees; free(p);return; }
    assert(0);
}
int main(void) {
    int v=99;assert(local_value(40,&v) && v==41);assert(local_value(INT_MIN,&v) && v==INT_MIN+1);
    v=99;assert(!local_value(INT_MAX,&v) && v==99);assert(!local_value(0,NULL));
    uint64_t counter;assert(!static_next(NULL)); for (uint64_t i=1;i<=100;++i) assert(static_next(&counter) && counter==i);
    Tracking t={0};Allocator a={&t,allocate,release};Owned o={NULL,0};int src[]={4,7,9};
    t.fail=1;assert(!owned_copy(src,3,&a,&o) && !o.data && !o.count && t.attempts==1);
    t.fail=0;assert(owned_copy(src,3,&a,&o) && o.count==3 && o.data!=src && o.data[1]==7);src[1]=55;assert(o.data[1]==7);
    unsigned before=t.attempts;assert(!owned_copy(src,3,&a,&o) && t.attempts==before);
    int *original=o.data;size_t original_count=o.count;t.fail=1;
    assert(!owned_resize(&o,5,&a) && o.data==original && o.count==original_count && o.data[1]==7 && t.frees==0);
    assert(!owned_resize(&o,SIZE_MAX,&a) && o.data==original);assert(!owned_resize(&o,5,NULL));
    t.fail=0;before=t.attempts;assert(owned_resize(&o,3,&a) && t.attempts==before);
    assert(owned_resize(&o,5,&a) && o.count==5 && o.data[0]==4 && o.data[1]==7 && o.data[3]==0 && o.data[4]==0 && t.frees==1);
    /* Do not inspect the old pointer after successful resize: its lifetime ended. */
    assert(owned_resize(&o,1,&a) && o.count==1 && o.data[0]==4 && t.frees==2);
    assert(owned_resize(&o,0,&a) && !o.data && !o.count && t.frees==3);
    assert(owned_release(&o,&a) && t.frees==3); assert(owned_release(&o,&a) && t.frees==3);
    before=t.attempts;assert(owned_copy(NULL,0,&a,&o) && t.attempts==before);
    assert(!owned_copy(NULL,1,&a,&o));assert(!owned_copy(src,SIZE_MAX,&a,&o));assert(!owned_copy(src,1,&a,NULL));
    Owned malformed={NULL,1}; assert(!owned_resize(&malformed,2,&a) && malformed.count==1);assert(!owned_release(&malformed,&a));
    Allocator invalid={&t,allocate,NULL};assert(!owned_copy(src,1,&invalid,&o));
    for (size_t n=1;n<=128;++n) { assert(owned_resize(&o,n,&a)); for (size_t i=0;i<n;++i) assert(o.data[i]==0); }
    assert(owned_release(&o,&a) && t.allocations==t.frees);
    for (unsigned i=0;i<8;++i) assert(!t.live[i]);
    puts("PASS caller/static lifetime, deep copy, failure rollback, resize and exact ownership release");
}
