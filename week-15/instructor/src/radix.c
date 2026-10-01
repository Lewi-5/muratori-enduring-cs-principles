#include "lab.h"
int radix_sort(Item *a,size_t n,Item *tmp,size_t cap,SortStats *out)
{
    if (!out || (!a && n) || n>SORT_LIMIT || (n>=2 && (!tmp || cap<n))) return 0;
    SortStats s={0};
    if (n>=2) {
        Item *src=a,*dst=tmp;
        for (unsigned pass=0;pass<4;++pass) {
            size_t count[256]={0},next[256];
            unsigned shift=pass*8;
            for (size_t i=0;i<n;++i) ++count[(src[i].key>>shift)&255u];
            size_t offset=0;
            for (unsigned d=0;d<256;++d) { next[d]=offset; offset+=count[d]; }
            for (size_t i=0;i<n;++i) { unsigned d=(src[i].key>>shift)&255u; dst[next[d]++]=src[i]; ++s.writes; }
            Item *swap=src; src=dst; dst=swap; ++s.passes;
        }
        /* An even number of passes leaves the result in the original array. */
    }
    *out=s; return 1;
}
