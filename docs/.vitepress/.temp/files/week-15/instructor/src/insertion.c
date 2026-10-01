#include "lab.h"
int insertion_sort(Item *a,size_t n,SortStats *out)
{
    if (!out || (!a && n) || n>SORT_LIMIT) return 0;
    SortStats s={0};
    for (size_t i=1;i<n;++i) {
        Item value=a[i]; size_t j=i;
        while (j>0) {
            ++s.comparisons;
            if (a[j-1].key<=value.key) break;
            a[j]=a[j-1]; ++s.writes; --j;
        }
        a[j]=value; ++s.writes;
    }
    *out=s; return 1;
}
