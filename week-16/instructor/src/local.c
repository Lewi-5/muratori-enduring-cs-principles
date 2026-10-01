#include "lab.h"
#include <limits.h>
int local_value(int seed,int *out) { if (!out || seed==INT_MAX) return 0; int value=seed+1; *out=value; return 1; }
