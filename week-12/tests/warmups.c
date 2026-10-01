#include "project.h"
#include <assert.h>
#include <stdio.h>
int main(void)
{
    uint8_t result=77;int carry=77,present=77;
    for (unsigned a=0;a<256;++a) for (unsigned b=0;b<256;++b) {
        assert(w01(a,b,&result,&carry));assert(result==(a+b)%256u && carry==(a+b>=256));
    }
    result=77;carry=77;assert(!w01(256,0,&result,&carry) && result==77 && carry==77);
    assert(!w01(0,256,&result,&carry));assert(!w01(0,0,NULL,&carry));assert(!w01(0,0,&result,NULL));
    uint8_t map[65536]={0};map[0]=1;map[65535]=2;
    for (unsigned t=0;t<65536;++t) {assert(w02(map,t,&present));assert(present==(t==0 || t==65535));}
    present=77;assert(!w02(map,65536,&present) && present==77);assert(!w02(NULL,0,&present));assert(!w02(map,0,NULL));
    uint8_t bytes[2];
    for (unsigned word=0;word<65536;++word) {assert(w03((uint16_t)word,bytes));assert(bytes[0]==word%256u && bytes[1]==word/256u);}
    assert(!w03(0,NULL));puts("PASS exhaustive byte ADD, boundary membership and word encoding warm-ups");return 0;
}
