#include "lab.h"
int w01(unsigned kind,unsigned event,int *out) { if (!out || kind>2 || event>2) return 0; *out=event==0 || kind==1 || (kind==2 && event==1); return 1; }
