#include "lab.h"
int owned_copy(const int *src,size_t n,const Allocator *a,Owned *out) { (void)src;(void)n;(void)a;(void)out;return 0; }
int owned_resize(Owned *o,size_t n,const Allocator *a) { (void)o;(void)n;(void)a;return 0; }
int owned_release(Owned *o,const Allocator *a) { (void)o;(void)a;return 0; }
