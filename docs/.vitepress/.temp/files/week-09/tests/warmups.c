#include "machine.h"
#include <assert.h>
#include <stdio.h>
int main(void)
{
    int32_t s=77; uint16_t out=77;
    for (unsigned p=0;p<256;++p) { assert(w01(p,&s)); assert(s==(p<128 ? (int32_t)p : (int32_t)p-256)); }
    s=77; assert(!w01(256,&s) && s==77); assert(!w01(0,NULL));
    for (unsigned p=0;p<65536;++p) {
        uint8_t b[2]={(uint8_t)(p & 255u),(uint8_t)(p >> 8)};
        assert(w03(b,&out) && out==p);
        assert(w02(p,-1,&out) && out==((p+65535u) & 65535u));
        assert(w02(p,1,&out) && out==((p+1u) & 65535u));
    }
    out=77; assert(!w02(65536,0,&out) && out==77);
    assert(!w02(0,32768,&out) && out==77); assert(!w02(0,-32769,&out));
    assert(!w02(0,0,NULL)); assert(!w03(NULL,&out) && out==77); assert(!w03((uint8_t[]){0,0},NULL));
    puts("PASS warm-up signed bytes, all words and wrapping targets");
    return 0;
}
