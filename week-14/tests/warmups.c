#include "profile.h"
#include <assert.h>
#include <stdio.h>
int main(void) { uint64_t v=99;double ratio;assert(!w01(1,2,&v) && v==99);assert(!w02(UINT64_MAX,&v));assert(w03(200,100,&ratio) && ratio==2);assert(!w03(1,0,&ratio));for(uint64_t a=0;a<256;++a)for(uint64_t b=0;b<=a;++b)assert(w01(a,b,&v) && v==a-b); puts("PASS warm-up boundaries and bounded exhaustive cases");return 0; }
