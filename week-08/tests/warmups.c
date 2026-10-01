#include <assert.h>
#include <stdint.h>
#include <stdio.h>
uint16_t low_byte(uint16_t);
uint16_t replace_high(uint16_t,uint8_t);
int carry8(uint8_t,uint8_t);
int main(void)
{
    for (unsigned word=0; word<65536; ++word) assert(low_byte((uint16_t)word)==word%256);
    for (unsigned high=0; high<256; ++high) for (unsigned low=0; low<256; ++low)
        assert(replace_high((uint16_t)(0xab00u+low),(uint8_t)high)==256u*high+low);
    for (unsigned a=0; a<256; ++a) for (unsigned b=0; b<256; ++b)
        assert(carry8((uint8_t)a,(uint8_t)b)==(a+b>=256));
    puts("PASS W01-W03 exhaustive byte and alias warm-ups"); return 0;
}
