#ifndef WEEK11_LAB_H
#define WEEK11_LAB_H
#include "geolab.h"
enum { ABI_MAX_ARGS=32 };
typedef enum { ABI_INTEGER, ABI_POINTER, ABI_DOUBLE } AbiType;
typedef enum { ABI_GP, ABI_XMM, ABI_STACK } AbiPlace;
typedef struct { AbiPlace place; unsigned index, offset; } AbiLocation;
typedef struct {
    AbiLocation args[ABI_MAX_ARGS];
    unsigned count, stack_words, reserve_bytes;
} AbiPlan;
/* E01: teaching subset of System V AMD64 LP64: fixed, nonvariadic signatures,
   only full-width scalar integers, pointers and double. INTEGER and POINTER
   share RDI,RSI,RDX,RCX,R8,R9; DOUBLE independently uses XMM0..7. Overflow
   arguments occupy eight-byte stack slots in source order: offset 8+8*k
   from callee ENTRY RSP, before any prologue. index=0 on STACK; offset=0 on
   registers. reserve_bytes rounds stack_words*8 up to 16 assuming initially
   aligned caller RSP, with padding above the highest-address argument.
   n<=32; NULL types allowed only n=0. Failure returns 0, leaves out unchanged.
   All output fields, including unused args, are initialized on success.
   Caller storage is accessible, immutable during calls and disjoint. This is
   not the ABI's aggregate, vector, long-double, varargs or return classifier. */
int abi_plan(const AbiType *types, size_t n, AbiPlan *out);
/* E02: call completed geolab functions through ordinary C boundaries.
   distance_to_origin delegates all coordinate/out validation to geolab.
   compare_hit_values requires finite nonnegative distances and non-NULL out,
   returns 1 and -1/0/1 distance-then-ID order, or 0 leaving out unchanged.
   IDs cover the complete uint64_t range; no subtract-and-narrow comparator. */
int distance_to_origin(double lat, double lon, double *out);
int compare_hit_values(uint64_t id_a, double distance_a, uint64_t id_b, double distance_b, int *out);
/* E03: sum point IDs with unsigned modulo-2^64 arithmetic. NULL points only
   at n=0. No position validation or retained pointers. On bad args output is
   unchanged. Array elements and output must not overlap; no allocation/I/O. */
int fold_ids(const GeoPoint *points, size_t n, uint64_t *out);
/* Supplied comparison subject: local may have no stack slot under optimization. */
uint64_t local_example(uint64_t value);
/* E04: callback must be non-NULL and valid with matching signature. Call it
   exactly once with seed+1 modulo 2^64, then add pre-call seed to its result.
   NULL callback/out returns 0 without calling or writing. Otherwise return 1.
   Callback can have ordinary effects; this API does not roll them back. */
int keep_across_call(uint64_t seed, uint64_t (*transform)(uint64_t), uint64_t *out);
/* W01: scalar integer argument position 0..31 -> GP index or stack offset. */
int w01(unsigned position, AbiLocation *out);
/* W02: codes RAX,RCX,RDX,RBX,RSP,RBP,RSI,RDI,R8..R15 -> preservation bit.
   RSP is restored specially, not a free general-purpose preserved register. */
int w02(unsigned code, int *preserved);
/* W03: 0..32 spilled words -> caller reservation rounded up to 16 bytes. */
int w03(unsigned words, unsigned *reserve);
#endif
