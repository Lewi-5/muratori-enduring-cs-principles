#include "lab.h"
#include <limits.h>
int w03(int seed,int *out) { if (!out || seed==INT_MAX) return 0; *out=seed+1; return 1; }
