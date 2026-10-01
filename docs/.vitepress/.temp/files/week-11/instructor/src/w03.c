#include "lab.h"
int w03(unsigned words, unsigned *out)
{
    if (!out || words>32) return 0;
    *out=((words*8u+15u)/16u)*16u;
    return 1;
}
