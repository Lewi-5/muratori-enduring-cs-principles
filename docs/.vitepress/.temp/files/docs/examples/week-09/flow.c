#include <stdint.h>
#include <stdio.h>
int main(void)
{
    unsigned next=17, pattern=248;
    int32_t displacement=(int32_t)pattern-256;
    unsigned target=(next+(uint32_t)displacement) & 65535u;
    uint8_t memory[65536]={0};
    unsigned address=65535;
    memory[address]=0x34;
    memory[(address+1u) & 65535u]=0x12;
    unsigned word=(unsigned)memory[address]
        | ((unsigned)memory[(address+1u) & 65535u] << 8);
    printf("following=%u displacement=%d target=%u\n",next,(int)displacement,target);
    printf("data[ffff]=%02x data[0000]=%02x word=%04x\n",
           (unsigned)memory[65535],(unsigned)memory[0],word);
    unsigned value=128;
    int signed_value=(int)value-256;
    printf("unsigned 128 < 1: %d; signed -128 < 1: %d\n",value<1,signed_value<1);
    return 0;
}
