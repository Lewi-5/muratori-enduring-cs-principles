#include "timing.h"
TimeStatus timing_measure(const ClockSource *clock,const Work *work,TimeSample *out)
{
    if (!clock || !work || !out || !clock->read || !work->call) return T_ARGUMENT;
    ClockStamp begin,end;uint64_t checksum;
    TimeStatus s=clock->read(clock->context,&begin);if (s!=T_OK) return s;
    if (!work->call(work->context,&checksum)) return T_WORK;
    s=clock->read(clock->context,&end);if (s!=T_OK) return s;
    TimeSample result={0};s=timing_elapsed(begin.value,end.value,&result.elapsed);
    if (s!=T_OK) return s;
    result.checksum=checksum;result.begin_aux=begin.aux;result.end_aux=end.aux;
    result.aux_changed=begin.aux!=end.aux;*out=result;return T_OK;
}
