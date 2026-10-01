#include "timing.h"
TimeStatus timing_collect(const ClockSource *clock,const Work *work,size_t n,TimeSample *out)
{
    if (!clock || !work || !out || !clock->read || !work->call || !n || n>TIME_MAX_SAMPLES) return T_ARGUMENT;
    TimeSample samples[TIME_MAX_SAMPLES];
    for (size_t k=0;k<n;++k) {TimeStatus s=timing_measure(clock,work,&samples[k]);if (s!=T_OK) return s;}
    for (size_t k=0;k<n;++k) out[k]=samples[k];
    return T_OK;
}
TimeStatus timing_summary(const TimeSample *samples,size_t n,TimeSummary *out)
{
    if (!samples || !out || !n || n>TIME_MAX_SAMPLES) return T_ARGUMENT;
    uint64_t sorted[TIME_MAX_SAMPLES];TimeSummary summary={0};
    for (size_t k=0;k<n;++k) {
        sorted[k]=samples[k].elapsed;
        summary.zeros+=samples[k].elapsed==0;summary.aux_changes+=samples[k].aux_changed!=0;
        size_t pos=k;
        while (pos && sorted[pos]<sorted[pos-1]) {
            uint64_t temp=sorted[pos];sorted[pos]=sorted[pos-1];sorted[pos-1]=temp;--pos;
        }
    }
    summary.minimum=sorted[0];summary.median=sorted[(n-1)/2];summary.maximum=sorted[n-1];
    *out=summary;return T_OK;
}
