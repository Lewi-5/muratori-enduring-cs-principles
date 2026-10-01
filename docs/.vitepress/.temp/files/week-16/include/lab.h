#ifndef WEEK16_LAB_H
#define WEEK16_LAB_H
#include <stddef.h>
#include <stdint.h>
typedef struct { int *data; size_t count; } Owned;
typedef struct { void *context; void *(*allocate)(void *,size_t); void (*release)(void *,void *); } Allocator;
/* Caller-provided allocators return NULL or suitably aligned fresh storage;
   release accepts their own allocations once, cannot fail. Both callbacks
   required. Owner is zero-initialized empty or has data!=NULL,count>0 and an
   accessible allocation of that many ints from this same allocator. Ownership
   must never be shallow-copied. All output/source/owner objects are disjoint.
   Metadata shape is checked, not arbitrary-pointer validity or allocator origin.
   On failure output/owner unchanged; failed allocations may have allocator effects.
   Aliases are borrows valid only until successful resize/release. */
int local_value(int seed,int *out); /* seed+1; reject INT_MAX/NULL atomically. */
int static_next(uint64_t *out); /* process-static counter, first 1, unsigned wrap;
                                 NULL has no effect; single-threaded only. */
int owned_copy(const int *source,size_t n,const Allocator *allocator,Owned *out);
/* copy requires empty out; NULL source only n=0; check byte-product overflow. */
int owned_resize(Owned *owner,size_t n,const Allocator *allocator);
/* Allocate/copy/zero-new-tail/free/commit; equal count no allocation. Zero count
   explicitly releases, avoiding malloc/realloc(0) portability questions. */
int owned_release(Owned *owner,const Allocator *allocator);
/* Release and reset to empty; repeat empty release succeeds without callback. */
int w01(unsigned kind,unsigned event,int *live);
/* Teaching model: kind 0 automatic,1 static,2 allocated; event 0 creation,
   1 block exit,2 explicit release. Expected liveness: creation all live;
   block exit static/allocated live; explicit release only static live.
   This table is a simplified event model, not a pointer-validity oracle. */
int w02(size_t n,size_t *bytes); /* checked int-array byte product. */
int w03(int seed,int *out); /* caller-owned result repair, same as local_value. */
#endif
