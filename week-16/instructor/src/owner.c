#include "lab.h"
#include <string.h>
static int valid_allocator(const Allocator *a) { return a && a->allocate && a->release; }
static int valid_owner(const Owned *o) { return o && ((o->data==NULL && o->count==0) || (o->data!=NULL && o->count>0 && o->count<=SIZE_MAX/sizeof(int))); }
int owned_copy(const int *src,size_t n,const Allocator *a,Owned *out) {
    if (!valid_allocator(a) || !out || out->data || out->count || (!src && n) || n>SIZE_MAX/sizeof(int)) return 0;
    Owned next={NULL,0};
    if (n) { next.data=a->allocate(a->context,n*sizeof(int)); if (!next.data) return 0; memcpy(next.data,src,n*sizeof(int)); next.count=n; }
    *out=next; return 1;
}
int owned_resize(Owned *o,size_t n,const Allocator *a) {
    if (!valid_allocator(a) || !valid_owner(o) || n>SIZE_MAX/sizeof(int)) return 0;
    if (n==o->count) return 1;
    if (!n) { a->release(a->context,o->data); *o=(Owned){NULL,0}; return 1; }
    int *next=a->allocate(a->context,n*sizeof(int)); if (!next) return 0;
    size_t keep=n<o->count ? n:o->count;
    if (keep) memcpy(next,o->data,keep*sizeof(int));
    for (size_t i=keep;i<n;++i) next[i]=0;
    if (o->data) a->release(a->context,o->data);
    *o=(Owned){next,n}; return 1;
}
int owned_release(Owned *o,const Allocator *a) {
    if (!valid_allocator(a) || !valid_owner(o)) return 0;
    if (o->data) a->release(a->context,o->data);
    *o=(Owned){NULL,0}; return 1;
}
