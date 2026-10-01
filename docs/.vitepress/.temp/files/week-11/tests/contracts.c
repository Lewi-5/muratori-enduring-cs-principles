#include "lab.h"
#include "geo_consts.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static unsigned calls;
static uint64_t received;
static uint64_t transform(uint64_t x) { ++calls; received=x; return x*3; }
static void plans(void)
{
    AbiPlan p, old;
    memset(&p,0x5a,sizeof p); old=p;
    AbiType invalid[]={ABI_INTEGER,(AbiType)99};
    assert(!abi_plan(invalid,2,&p) && memcmp(&p,&old,sizeof p)==0);
    assert(!abi_plan(NULL,1,&p) && memcmp(&p,&old,sizeof p)==0);
    assert(!abi_plan(NULL,0,NULL)); assert(!abi_plan(invalid,33,&p));
    assert(abi_plan(NULL,0,&p) && p.count==0 && p.reserve_bytes==0);
    for (unsigned integers=0; integers<=12; ++integers) {
        for (unsigned doubles=0; doubles<=12; ++doubles) {
            AbiType types[32]; unsigned count=integers+doubles;
            for (unsigned k=0; k<count; ++k) types[k]=k<integers ? ABI_INTEGER : ABI_DOUBLE;
            assert(abi_plan(types,count,&p));
            unsigned spilled=0;
            for (unsigned k=0; k<count; ++k) {
                int in_gp=k<integers && k<6;
                int in_fp=k>=integers && k-integers<8;
                if (in_gp) assert(p.args[k].place==ABI_GP && p.args[k].index==k && p.args[k].offset==0);
                else if (in_fp) assert(p.args[k].place==ABI_XMM && p.args[k].index==k-integers && p.args[k].offset==0);
                else { assert(p.args[k].place==ABI_STACK && p.args[k].index==0 && p.args[k].offset==8+8*spilled); ++spilled; }
            }
            assert(p.stack_words==spilled && p.reserve_bytes>=spilled*8 && p.reserve_bytes%16==0);
            assert(p.reserve_bytes-spilled*8<16);
            for (unsigned k=count; k<32; ++k) assert(p.args[k].index==0 && p.args[k].offset==0);
        }
    }
    /* Interleave independent pools: a GP spill does not consume XMM slots. */
    AbiType mixed[18];
    for (unsigned k=0; k<18; ++k) mixed[k]=(k%2) ? ABI_DOUBLE : ABI_POINTER;
    assert(abi_plan(mixed,18,&p) && p.stack_words==4 && p.reserve_bytes==32);
    assert(p.args[12].place==ABI_STACK && p.args[12].offset==8);
    assert(p.args[13].place==ABI_XMM && p.args[13].index==6);
    assert(p.args[14].offset==16 && p.args[15].index==7 && p.args[16].offset==24 && p.args[17].offset==32);
}
static void kernels(void)
{
    double distance=123;
    assert(distance_to_origin(0,0,&distance) && distance==0);
    assert(distance_to_origin(0,90,&distance));
    assert(fabs(distance-(GEO_EARTH_RADIUS_KM*GEO_PI/2))<1e-8);
    distance=123;
    assert(!distance_to_origin(91,0,&distance) && distance==123);
    assert(!distance_to_origin(NAN,0,&distance) && distance==123);
    assert(!distance_to_origin(0,0,NULL));
    int order=99;
    assert(compare_hit_values(UINT64_MAX,1,0,1,&order) && order==1);
    assert(compare_hit_values(8,0,0,1,&order) && order==-1);
    assert(compare_hit_values(5,2,5,2,&order) && order==0);
    order=99; assert(!compare_hit_values(0,NAN,1,0,&order) && order==99);
    assert(!compare_hit_values(0,-1,1,0,&order) && order==99);
    assert(!compare_hit_values(0,0,1,INFINITY,&order) && order==99);
    assert(!compare_hit_values(0,0,1,0,NULL));
    GeoPoint points[]={{UINT64_MAX,0,0},{1,0,0},{9,0,0}};
    uint64_t out=123;
    assert(fold_ids(points,3,&out) && out==9);
    assert(fold_ids(NULL,0,&out) && out==0);
    out=123; assert(!fold_ids(NULL,1,&out) && out==123);
    assert(!fold_ids(points,3,NULL));
    for (uint64_t k=0; k<1000; ++k) {
        calls=0; assert(keep_across_call(k,transform,&out));
        assert(calls==1 && received==k+1 && out==k+(k+1)*3);
        assert(local_example(k)==k*2+1);
    }
    calls=0; assert(keep_across_call(UINT64_MAX,transform,&out) && received==0 && out==UINT64_MAX && calls==1);
    out=123; calls=0;
    assert(!keep_across_call(0,NULL,&out) && out==123 && calls==0);
    assert(!keep_across_call(0,transform,NULL) && calls==0);
    /* The original query remains a real separately compiled comparison subject. */
    QueryHit *hits=NULL; size_t n=0;
    GeoPoint ties[]={{9,0,0},{2,0,0},{5,0,1}};
    assert(query_points(ties,3,0,0,0,&hits,&n) && n==2 && hits[0].id==2 && hits[1].id==9);
    free(hits);
}
int main(void)
{
    plans(); kernels(); puts("PASS scalar ABI plans, geolab wrappers, modular IDs and callback preservation"); return 0;
}
