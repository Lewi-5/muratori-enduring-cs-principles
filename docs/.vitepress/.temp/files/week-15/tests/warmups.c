#include "lab.h"
#include <assert.h>
#include <stdio.h>
int main(void) {
    Item a={2,0},b={1,1}; assert(w01(&a,&b) && a.key==1 && b.key==2);
    a=(Item){1,7};b=(Item){1,8};assert(w01(&a,&b) && a.tag==7 && b.tag==8);assert(!w01(NULL,&b));
    unsigned d=99; for (unsigned p=0;p<4;++p) assert(w02(0x12345678u,p,&d) && d==((0x12345678u>>(p*8))&255u));
    d=99;assert(!w02(0,4,&d) && d==99); assert(!w02(0,0,NULL));
    size_t bytes=99;assert(w03(0,&bytes) && bytes==0); assert(w03(8,&bytes) && bytes==8*sizeof(Item));
    bytes=99;assert(!w03(SIZE_MAX,&bytes) && bytes==99);assert(!w03(1,NULL)); puts("PASS three sorting warm-ups");
}
