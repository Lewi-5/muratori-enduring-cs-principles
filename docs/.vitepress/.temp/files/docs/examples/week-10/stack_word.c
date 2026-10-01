#include <stdint.h>
#include <stdio.h>
int main(void)
{
    uint8_t memory[256]={0};
    unsigned sp=256;
    uint16_t saved=0x1234;
    sp-=2;
    memory[sp]=(uint8_t)(saved & 255u);
    memory[sp+1]=(uint8_t)((unsigned)saved >> 8);
    printf("push: sp=%04x bytes=%02x %02x\n",sp,(unsigned)memory[sp],(unsigned)memory[sp+1]);
    uint16_t restored=(uint16_t)((unsigned)memory[sp] | ((unsigned)memory[sp+1] << 8));
    sp+=2;
    printf("pop: sp=%04x value=%04x stale=%02x %02x\n",sp,(unsigned)restored,
           (unsigned)memory[254],(unsigned)memory[255]);
    return 0;
}
