#include "lab.h"
int summarize(const uint64_t *samples,size_t n,SampleSummary *out)
{
    if (!samples || !out || !n || n>SAMPLE_LIMIT) return 0;
    uint64_t sorted[SAMPLE_LIMIT]; long double sum=0;
    for (size_t i=0;i<n;++i) { sorted[i]=samples[i]; sum+=(long double)samples[i]; }
    for (size_t i=1;i<n;++i) { uint64_t x=sorted[i]; size_t j=i; while (j && sorted[j-1]>x) { sorted[j]=sorted[j-1]; --j; } sorted[j]=x; }
    SampleSummary s={sorted[0],sorted[n-1],0,0};
    s.median=n%2 ? (double)sorted[n/2] : (double)sorted[n/2-1]/2.0+(double)sorted[n/2]/2.0;
    s.mean=(double)(sum/(long double)n); *out=s; return 1;
}
