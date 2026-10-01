#include "project.h"
int w01(unsigned a,unsigned b,uint8_t *result,int *carry)
{ if (!result || !carry || a>255 || b>255) return 0; unsigned sum=a+b; *result=(uint8_t)(sum & 255u); *carry=sum>255; return 1; }
