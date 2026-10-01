#include "machine.h"
#include <assert.h>
#include <stdio.h>
int main(void)
{
    int32_t signed_value=123; unsigned depth=123; uint16_t word=123;
    for (unsigned pattern=0; pattern<65536; ++pattern) {
        assert(w01(pattern,&signed_value));
        assert(signed_value==(pattern<32768 ? (int32_t)pattern : (int32_t)pattern-65536));
        uint8_t bytes[]={(uint8_t)(pattern & 255u),(uint8_t)(pattern >> 8)};
        assert(w03(bytes,&word) && word==pattern);
    }
    assert(w02(256,250,&depth) && depth==3);
    assert(w02(9,7,&depth) && depth==1);
    assert(w02(9,8,&depth) && depth==0);
    depth=123; signed_value=123; word=123;
    assert(!w01(65536,&signed_value) && signed_value==123);
    assert(!w01(0,NULL)); assert(!w02(65536,0,&depth) && depth==123);
    assert(!w02(1,2,&depth) && depth==123); assert(!w02(1,1,NULL));
    assert(!w03(NULL,&word) && word==123); const uint8_t b[]={0,0}; assert(!w03(b,NULL));
    puts("PASS three warm-ups"); return 0;
}
