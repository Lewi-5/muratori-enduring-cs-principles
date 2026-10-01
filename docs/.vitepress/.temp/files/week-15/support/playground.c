#include "lab.h"
#include <stdio.h>
int main(void) {
    Item a[]={{3,0},{1,1},{3,2},{0,3}},tmp[4]; SortStats s;
    if (!radix_sort(a,4,tmp,4,&s)) return 1;
    for (size_t i=0;i<4;++i) printf("%u:%u%s",a[i].key,a[i].tag,i==3 ? "\n" : " ");
    printf("passes=%llu writes=%llu\n",(unsigned long long)s.passes,(unsigned long long)s.writes);
    uint64_t times[]={9,1,5,3}; SampleSummary summary;
    if (!summarize(times,4,&summary)) return 1;
    printf("sample min=%llu median=%.0f mean=%.1f\n",(unsigned long long)summary.minimum,summary.median,summary.mean);
    return ferror(stdout) ? 1 : 0;
}
