#include "lab.h"
#include <assert.h>
#include <limits.h>
#include <stdio.h>
int main(void) {
    int live,expected[3][3]={{1,0,0},{1,1,1},{1,1,0}};
    for (unsigned k=0;k<3;++k) for (unsigned e=0;e<3;++e) assert(w01(k,e,&live) && live==expected[k][e]);
    live=99;assert(!w01(3,0,&live) && live==99);assert(!w01(0,3,&live));assert(!w01(0,0,NULL));
    size_t bytes;assert(w02(0,&bytes) && bytes==0);assert(w02(4,&bytes) && bytes==4*sizeof(int));bytes=99;assert(!w02(SIZE_MAX,&bytes) && bytes==99);assert(!w02(0,NULL));
    int out;assert(w03(7,&out) && out==8);out=99;assert(!w03(INT_MAX,&out) && out==99);assert(!w03(0,NULL));puts("PASS three lifetime warm-ups");
}
