#include "lab.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static int order(const void *pa,const void *pb) {
    const Item *a=pa,*b=pb;
    if (a->key!=b->key) return (a->key>b->key)-(a->key<b->key);
    return (a->tag>b->tag)-(a->tag<b->tag);
}
static void check(const Item *input,size_t n) {
    Item a[257],tmp[257],expected[257]; SortStats s;
    assert(n<=257); memcpy(expected,input,n*sizeof(Item)); qsort(expected,n,sizeof(Item),order);
    for (unsigned which=0;which<3;++which) {
        memcpy(a,input,n*sizeof(Item));
        int ok=which==0 ? insertion_sort(a,n,&s) : which==1 ? merge_sort(a,n,tmp,n,&s) : radix_sort(a,n,tmp,n,&s);
        assert(ok);
        for (size_t k=0;k<n;++k) assert(a[k].key==expected[k].key && a[k].tag==expected[k].tag);
        if (which==2) assert(s.comparisons==0 && s.passes==(n<2 ? 0u:4u) && s.writes==(n<2 ? 0u:4u*n));
    }
}
int main(void) {
    Item a[257]; size_t cases=0;
    for (size_t n=0;n<=7;++n) {
        size_t combinations=1; for (size_t i=0;i<n;++i) combinations*=3;
        for (size_t v=0;v<combinations;++v) { size_t x=v; for (size_t i=0;i<n;++i) { a[i].key=(uint32_t)(x%3);a[i].tag=(uint32_t)i;x/=3; } check(a,n); ++cases; }
    }
    uint32_t state=123;
    for (size_t n=0;n<=257;++n) {
        for (unsigned shape=0;shape<4;++shape) {
            for (size_t i=0;i<n;++i) { state=state*1664525u+1013904223u; a[i].key=shape==0 ? (uint32_t)i : shape==1 ? (uint32_t)(n-i) : shape==2 ? state : state%5; a[i].tag=(uint32_t)i; }
            check(a,n); ++cases;
        }
    }
    Item edge[]={{UINT32_MAX,0},{0,1},{0x80000000u,2},{255,3},{256,4},{UINT32_MAX,5}}; check(edge,6);
    SortStats s={11,22,33},old=s; Item tmp[2]={{9,9},{8,8}},before[2]; memcpy(before,tmp,sizeof tmp);
    Item one={7,4};
    assert(!insertion_sort(NULL,1,&s) && memcmp(&s,&old,sizeof s)==0);
    assert(!insertion_sort(&one,SORT_LIMIT+1u,&s)); assert(!insertion_sort(&one,1,NULL));
    assert(!merge_sort(&one,2,tmp,1,&s) && one.key==7 && memcmp(tmp,before,sizeof tmp)==0 && memcmp(&s,&old,sizeof s)==0);
    assert(!radix_sort(&one,2,NULL,2,&s) && one.key==7 && memcmp(&s,&old,sizeof s)==0);
    assert(merge_sort(NULL,0,NULL,0,&s) && s.writes==0); assert(radix_sort(&one,1,NULL,0,&s) && s.passes==0);
    Item sorted[]={{1,0},{2,1},{3,2},{4,3}}; assert(insertion_sort(sorted,4,&s) && s.comparisons==3 && s.writes==3);
    Item reversed[]={{4,0},{3,1},{2,2},{1,3}}; assert(insertion_sort(reversed,4,&s) && s.comparisons==6 && s.writes==9);
    assert(merge_sort(sorted,4,a,257,&s) && s.passes==2 && s.writes==16);
    Item *large=malloc(SORT_LIMIT*sizeof(Item)),*scratch=malloc(SORT_LIMIT*sizeof(Item)); assert(large && scratch);
    for (size_t i=0;i<SORT_LIMIT;++i) { large[i].key=UINT32_MAX-(uint32_t)i; large[i].tag=(uint32_t)i; }
    assert(radix_sort(large,SORT_LIMIT,scratch,SORT_LIMIT,&s));
    for (size_t i=1;i<SORT_LIMIT;++i) assert(large[i-1].key<large[i].key);
    assert(merge_sort(large,SORT_LIMIT,scratch,SORT_LIMIT,&s)); assert(insertion_sort(large,SORT_LIMIT,&s)); free(large);free(scratch);
    uint64_t samples[]={9,1,5,3}; SampleSummary result;
    assert(summarize(samples,4,&result) && result.minimum==1 && result.maximum==9 && result.median==4 && result.mean==4.5 && samples[0]==9);
    assert(summarize(samples,3,&result) && result.median==5 && result.mean==5);
    SampleSummary saved=result; assert(!summarize(samples,0,&result) && memcmp(&saved,&result,sizeof result)==0);
    assert(!summarize(NULL,1,&result)); assert(!summarize(samples,65,&result)); assert(!summarize(samples,1,NULL));
    uint64_t maximum[]={UINT64_MAX,UINT64_MAX}; assert(summarize(maximum,2,&result) && result.minimum==UINT64_MAX && result.median>0 && result.mean>0);
    printf("PASS %zu sort inputs across three algorithms, stable permutation, edges, bounds and sample summaries\n",cases+1);
    return 0;
}
