#include <assert.h>
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
unsigned address_bytes(unsigned, unsigned);
int32_t signed_byte(uint8_t);
int next_offset(size_t, size_t, size_t, size_t *);
int main(void)
{
    for (unsigned m=0; m<3; ++m) for (unsigned r=0; r<8; ++r)
        assert(address_bytes(m,r)==(m==1 ? 1u : (m==2 || r==6 ? 2u : 0u)));
    assert(address_bytes(3,0)==99 && address_bytes(0,8)==99);
    for (unsigned b=0; b<256; ++b)
        assert(signed_byte((uint8_t)b)==(b<128 ? (int32_t)b : (int32_t)b-256));
    size_t out=99;
    assert(next_offset(2,3,5,&out) && out==5);
    out=99;
    assert(!next_offset(2,4,5,&out) && out==99);
    assert(!next_offset(SIZE_MAX,1,SIZE_MAX,&out) && out==99);
    assert(!next_offset(0,0,3,&out) && !next_offset(0,1,3,NULL));
    puts("PASS W01-W03"); return 0;
}
