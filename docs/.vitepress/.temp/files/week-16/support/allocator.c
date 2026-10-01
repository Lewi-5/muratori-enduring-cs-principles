#include "allocator.h"
#include <stdlib.h>
static void *allocate(void *ctx,size_t n) { (void)ctx;return malloc(n); }
static void release(void *ctx,void *p) { (void)ctx;free(p); }
Allocator default_allocator(void) { return (Allocator){NULL,allocate,release}; }
