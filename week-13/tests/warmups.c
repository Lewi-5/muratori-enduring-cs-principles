#include "timing.h"
#include <assert.h>
#include <stdio.h>
int main(void) { uint64_t v=99;assert(w01(1,2,&v) && v==1000000002);assert(!w01(UINT64_MAX,0,&v));assert(w02(9,9,&v) && v==0);assert(!w02(9,8,&v));assert(w03(UINT64_MAX,2,&v) && v==UINT64_MAX/2+1);for(uint64_t a=0;a<256;++a)for(uint64_t b=1;b<256;++b)assert(w03(a,b,&v) && v==a/b+(a%b!=0)); puts("PASS warm-up boundaries and bounded exhaustive cases");return 0; }
