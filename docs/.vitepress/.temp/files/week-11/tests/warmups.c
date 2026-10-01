#include "lab.h"
#include <assert.h>
#include <stdio.h>
int main(void)
{
    AbiLocation a;
    for (unsigned k=0; k<32; ++k) {
        assert(w01(k,&a));
        assert(k<6 ? a.place==ABI_GP && a.index==k && a.offset==0 : a.place==ABI_STACK && a.offset==8+8*(k-6));
    }
    a.offset=123; assert(!w01(32,&a) && a.offset==123); assert(!w01(0,NULL));
    const int expected[16]={0,0,0,1,1,1,0,0,0,0,0,0,1,1,1,1};
    int preserved=99;
    for (unsigned k=0; k<16; ++k) assert(w02(k,&preserved) && preserved==expected[k]);
    preserved=99; assert(!w02(16,&preserved) && preserved==99); assert(!w02(0,NULL));
    unsigned reserve=123;
    for (unsigned words=0; words<=32; ++words) {
        assert(w03(words,&reserve)); assert(reserve%16==0 && reserve>=words*8 && reserve-words*8<16);
    }
    reserve=123; assert(!w03(33,&reserve) && reserve==123); assert(!w03(0,NULL));
    puts("PASS three ABI warm-ups"); return 0;
}
