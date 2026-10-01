#include "timing.h"
TimeStatus timing_rate(uint64_t ticks,uint64_t ns,double *hz)
{
    if (!hz || !ticks || !ns) return T_ARGUMENT;
    *hz=(double)ticks*1e9/(double)ns;return T_OK;
}
