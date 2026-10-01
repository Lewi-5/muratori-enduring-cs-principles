#ifndef WEEK15_LAB_H
#define WEEK15_LAB_H
#include <stddef.h>
#include <stdint.h>
enum { SORT_LIMIT=65536, SAMPLE_LIMIT=64 };
typedef struct { uint32_t key, tag; } Item;
typedef struct { uint64_t comparisons, writes, passes; } SortStats;
typedef struct { uint64_t minimum, maximum; double median, mean; } SampleSummary;
/* All sorts are stable ascending uint32_t key only; tag is carried unchanged.
   n<=SORT_LIMIT. NULL data only at n=0; stats required and disjoint from data.
   Caller provides accessible objects; merge/radix require disjoint scratch of
   at least n Items only when n>=2. Invalid args leave data/scratch/stats unchanged.
   On success initialize stats: comparisons counts key comparisons; writes counts
   Item assignments to data or scratch, not local temporaries. For n<2 all zero.
   Insertion writes each final placement, even unchanged. Merge copies back each
   width pass, counting 2*n writes per pass. Radix does exactly four stable byte
   passes for n>=2, counting 4*n writes and zero key comparisons. No allocation.
   Overlap is a caller precondition, not guessed by relational pointer tests. */
int insertion_sort(Item *data,size_t n,SortStats *stats);
int merge_sort(Item *data,size_t n,Item *scratch,size_t capacity,SortStats *stats);
int radix_sort(Item *data,size_t n,Item *scratch,size_t capacity,SortStats *stats);
/* Nonempty 1..64 integer nanosecond samples; immutable and disjoint from out.
   Sort a local copy. Median is middle or average of two middle values; mean is
   arithmetic mean, both represented as double. Zero-resolution samples allowed.
   Invalid arguments leave out unchanged. Integer samples need not be ordered. */
int summarize(const uint64_t *samples,size_t n,SampleSummary *out);
/* Warm-ups: ordered pair preserves equal-key order; digit is numeric shift,
   not object-byte endian order; workspace byte count checks SIZE_MAX overflow.
   All return 0 without changing outputs on invalid args. */
int w01(Item *a,Item *b);
int w02(uint32_t key,unsigned pass,unsigned *digit);
int w03(size_t count,size_t *bytes);
#endif
