#include "lab.h"
int w02(unsigned code, int *out)
{
    if (!out || code>=16) return 0;
    *out=code==3 || code==4 || code==5 || code>=12;
    return 1;
}
