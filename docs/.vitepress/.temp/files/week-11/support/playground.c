#include "lab.h"
#include <inttypes.h>
#include <stdio.h>
static uint64_t triple(uint64_t value) { return value*3; }
int main(void)
{
    AbiType types[]={ABI_DOUBLE,ABI_DOUBLE,ABI_DOUBLE,ABI_DOUBLE,ABI_POINTER};
    AbiPlan plan;
    double distance=123;
    uint64_t folded=0, kept=0;
    GeoPoint points[]={{2,0,0},{5,0,0},{9,0,0}};
    int order=99;
    if (!abi_plan(types,5,&plan) || !distance_to_origin(0,0,&distance) ||
        !compare_hit_values(9,1,2,1,&order) || !fold_ids(points,3,&folded) ||
        !keep_across_call(7,triple,&kept)) return 1;
    printf("geo_distance: xmm0,xmm1,xmm2,xmm3; pointer=gp%u reserve=%u\n",plan.args[4].index,plan.reserve_bytes);
    printf("distance=%.0f order=%d folded=%" PRIu64 " kept=%" PRIu64 " local=%" PRIu64 "\n",
           distance,order,folded,kept,local_example(7));
    return 0;
}
