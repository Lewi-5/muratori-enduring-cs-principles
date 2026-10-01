#include "project.h"
int w02(const uint8_t *map,unsigned target,int *present)
{ if (!map || !present || target>65535) return 0; *present=map[target]!=0; return 1; }
