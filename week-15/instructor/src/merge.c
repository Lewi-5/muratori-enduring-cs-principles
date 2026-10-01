#include "lab.h"
int merge_sort(Item *a,size_t n,Item *tmp,size_t cap,SortStats *out)
{
    if (!out || (!a && n) || n>SORT_LIMIT || (n>=2 && (!tmp || cap<n))) return 0;
    SortStats s={0};
    for (size_t width=1;width<n;width*=2) {
        for (size_t lo=0;lo<n;lo+=2*width) {
            size_t mid=lo+width<n ? lo+width : n;
            size_t hi=mid+width<n ? mid+width : n;
            size_t i=lo,j=mid,k=lo;
            while (i<mid && j<hi) {
                ++s.comparisons;
                tmp[k++]=a[i].key<=a[j].key ? a[i++] : a[j++]; ++s.writes;
            }
            while (i<mid) { tmp[k++]=a[i++]; ++s.writes; }
            while (j<hi) { tmp[k++]=a[j++]; ++s.writes; }
        }
        for (size_t k=0;k<n;++k) { a[k]=tmp[k]; ++s.writes; }
        ++s.passes;
    }
    *out=s; return 1;
}
