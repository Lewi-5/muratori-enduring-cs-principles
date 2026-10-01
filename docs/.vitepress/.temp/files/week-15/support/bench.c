#define _POSIX_C_SOURCE 200809L
#include "lab.h"
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
static int argument(const char *text,size_t limit,size_t *out) {
    if (!*text) return 0;
    for (const char *p=text;*p;++p) if (*p<'0' || *p>'9') return 0;
    errno=0; char *end; unsigned long long n=strtoull(text,&end,10);
    if (errno || *end || !n || n>limit) return 0;
    *out=(size_t)n; return 1;
}
static int elapsed(struct timespec a,struct timespec b,uint64_t *out) {
    if (b.tv_sec<a.tv_sec || (b.tv_sec==a.tv_sec && b.tv_nsec<a.tv_nsec)) return 0;
    time_t secs=b.tv_sec-a.tv_sec; long nanos=b.tv_nsec-a.tv_nsec;
    if (nanos<0) { --secs; nanos+=1000000000L; }
    if ((uint64_t)secs>(UINT64_MAX-(uint64_t)nanos)/UINT64_C(1000000000)) return 0;
    *out=(uint64_t)secs*UINT64_C(1000000000)+(uint64_t)nanos; return 1;
}
int main(int argc,char **argv) {
    size_t n=1024,repeats=9;
    if (argc>3 || (argc>1 && !argument(argv[1],SORT_LIMIT,&n)) || (argc>2 && !argument(argv[2],SAMPLE_LIMIT,&repeats))) { fputs("usage: bench [count 1..65536] [repeat 1..64]\n",stderr);return 2; }
    Item *input=malloc(n*sizeof(Item)),*a=malloc(n*sizeof(Item)),*tmp=malloc(n*sizeof(Item));
    if (!input || !a || !tmp) { free(input);free(a);free(tmp);return 1; }
    const char *shapes[]={"sorted","reverse","random","duplicates"},*names[]={"insertion","merge","radix"};
    puts("shape,algorithm,n,repeat,min_ns,median_ns,mean_ns,max_ns,comparisons,writes,checksum");
    int success=1;
    for (unsigned shape=0;shape<4 && success;++shape) {
        uint32_t state=123;
        for (size_t i=0;i<n;++i) { state=state*1664525u+1013904223u; input[i]=(Item){shape==0 ? (uint32_t)i : shape==1 ? (uint32_t)(n-i) : shape==2 ? state : state%5,(uint32_t)i}; }
        for (unsigned which=0;which<3 && success;++which) {
            uint64_t samples[SAMPLE_LIMIT],checksum=0; SortStats stats={0};
            /* One untimed warm-up, then each timed trial resets original input. */
            for (size_t trial=0;trial<=repeats;++trial) {
                memcpy(a,input,n*sizeof(Item)); struct timespec begin,end;
                if (clock_gettime(CLOCK_MONOTONIC,&begin)) { success=0;break; }
                int ok=which==0 ? insertion_sort(a,n,&stats) : which==1 ? merge_sort(a,n,tmp,n,&stats) : radix_sort(a,n,tmp,n,&stats);
                if (clock_gettime(CLOCK_MONOTONIC,&end) || !ok) { success=0;break; }
                uint64_t delta; if (!elapsed(begin,end,&delta)) { success=0;break; }
                checksum=0;
                for (size_t i=0;i<n;++i) {
                    if (a[i].tag>=n || a[i].key!=input[a[i].tag].key || (i && (a[i-1].key>a[i].key || (a[i-1].key==a[i].key && a[i-1].tag>=a[i].tag)))) success=0;
                    checksum=checksum*UINT64_C(1099511628211)+a[i].key+a[i].tag;
                }
                if (trial) samples[trial-1]=delta;
            }
            SampleSummary s;
            if (!success || !summarize(samples,repeats,&s)) { success=0;break; }
            printf("%s,%s,%zu,%zu,%llu,%.1f,%.1f,%llu,%llu,%llu,%llu\n",shapes[shape],names[which],n,repeats,(unsigned long long)s.minimum,s.median,s.mean,(unsigned long long)s.maximum,(unsigned long long)stats.comparisons,(unsigned long long)stats.writes,(unsigned long long)checksum);
        }
    }
    free(input);free(a);free(tmp); return success && !ferror(stdout) ? 0 : 1;
}
