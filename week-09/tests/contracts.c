#include "machine.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>

static void same(const Machine *a, const Machine *b) { assert(memcmp(a,b,sizeof *a)==0); }
static void conditions(void)
{
    for (unsigned flags=0;flags<65536;++flags) {
        int c=(flags & FLAG_CF)!=0,z=(flags & FLAG_ZF)!=0;
        int s=(flags & FLAG_SF)!=0,o=(flags & FLAG_OF)!=0,p=(flags & FLAG_PF)!=0;
        const int expected[16]={o,!o,c,!c,z,!z,c||z,!(c||z),s,!s,p,!p,s!=o,s==o,z||(s!=o),!(z||(s!=o))};
        for (unsigned k=0;k<16;++k) assert(machine_condition(k,(uint16_t)flags)==expected[k]);
    }
    assert(machine_condition(16,0)==-1);
    for (unsigned bits=0;bits<32;++bits) for (unsigned k=0;k<16;++k) {
        uint16_t flags=(uint16_t)(0x200u | ((bits & 1u) ? FLAG_CF : 0u)
            | ((bits & 2u) ? FLAG_PF : 0u) | ((bits & 4u) ? FLAG_ZF : 0u)
            | ((bits & 8u) ? FLAG_SF : 0u) | ((bits & 16u) ? FLAG_OF : 0u));
        Machine m={0}; m.cpu.flags=flags;
        uint8_t code[2]={(uint8_t)(0x70u+k),0xfe};
        int taken=machine_condition(k,flags);
        assert(machine_step(code,2,&m)==M_OK);
        assert(m.cpu.ip==(taken ? 0 : 2) && m.cpu.flags==flags);
    }
    /* Independent signed/unsigned comparison oracle for every byte pair. */
    for (unsigned a=0;a<256;++a) for (unsigned b=0;b<256;++b) {
        AluResult r; assert(sim_alu(OP_CMP,0,(uint16_t)a,(uint16_t)b,&r));
        int sa=a<128 ? (int)a : (int)a-256, sb=b<128 ? (int)b : (int)b-256;
        assert(machine_condition(2,r.flags)==(a<b));
        assert(machine_condition(6,r.flags)==(a<=b));
        assert(machine_condition(12,r.flags)==(sa<sb));
        assert(machine_condition(14,r.flags)==(sa<=sb));
    }
}
static void addresses(void)
{
    CpuState c={{11,22,33,0xfff0,55,0x120,0x30,0x41},0,0};
    const uint32_t base[8]={0x10020,0x10031,0x150,0x161,0x30,0x41,0x120,0xfff0};
    uint16_t out=77;
    for (unsigned rm=0;rm<8;++rm) for (int32_t disp=-32768;disp<=32767;++disp) {
        Address a={0,rm,disp,0};
        assert(machine_address(&a,&c,&out));
        int64_t expected=(int64_t)base[rm]+disp;
        if (expected<0) expected+=65536;
        assert(out==(uint16_t)((uint64_t)expected % 65536u));
    }
    Address a={1,999,999999,0xffff}; assert(machine_address(&a,&c,&out) && out==65535);
    out=77; a.direct=2; assert(!machine_address(&a,&c,&out) && out==77);
    a.direct=0;a.rm=8;a.displacement=0;assert(!machine_address(&a,&c,&out) && out==77);
    a.rm=0;a.displacement=-32769;assert(!machine_address(&a,&c,&out));
    a.displacement=32768;assert(!machine_address(&a,&c,&out));
    assert(!machine_address(NULL,&c,&out));assert(!machine_address(&a,NULL,&out));assert(!machine_address(&a,&c,NULL));
}
static void decoding(void)
{
    Decoded out={0},old=out;
    assert(machine_decode(NULL,0,&out)==M_DECODE);assert(memcmp(&out,&old,sizeof out)==0);
    assert(machine_decode(NULL,1,&out)==M_ARGUMENT);assert(machine_decode((uint8_t[]){0xeb},1,&out)==M_DECODE);
    assert(machine_decode((uint8_t[]){0xe9,0},2,&out)==M_DECODE);
    assert(machine_decode((uint8_t[]){0x90},1,&out)==M_DECODE);
    assert(machine_decode((uint8_t[]){0xeb,0},2,NULL)==M_ARGUMENT);
    for (unsigned k=0;k<16;++k) for (unsigned b=0;b<256;++b) {
        uint8_t code[2]={(uint8_t)(0x70u+k),(uint8_t)b};
        assert(machine_decode(code,2,&out)==M_OK && out.length==2 && out.kind==X_JCC && out.condition==k);
        assert(out.relative==(b<128 ? (int32_t)b : (int32_t)b-256));
    }
    for (unsigned p=0;p<65536;++p) {
        uint8_t code[3]={0xe9,(uint8_t)(p & 255u),(uint8_t)(p >> 8)};
        assert(machine_decode(code,3,&out)==M_OK && out.kind==X_JMP && out.length==3);
        assert(out.relative==(p<32768 ? (int32_t)p : (int32_t)p-65536));
    }
}
static void memory(void)
{
    Machine m={0}; m.cpu.flags=0x200;
    /* Each expression, displacement width, data width and encoding direction.
       Values are independently prepared in data memory; register indexing is
       derived from the ISA table, not machine_address. */
    const unsigned a_reg[8]={3,3,5,5,6,7,5,3}, b_reg[4]={6,7,6,7};
    const int disps[3]={0,-7,0x1234};
    for (unsigned rm=0;rm<8;++rm) for (unsigned mode=0;mode<3;++mode)
    for (unsigned wide=0;wide<2;++wide) for (unsigned direction=0;direction<2;++direction) {
        memset(&m,0,sizeof m); m.cpu.flags=0x200;
        m.cpu.regs[3]=0xfff0;m.cpu.regs[5]=0x100;m.cpu.regs[6]=0x21;m.cpu.regs[7]=0x31;
        m.cpu.regs[0]=wide ? 0x7654 : 0x54;
        unsigned base=m.cpu.regs[a_reg[rm]];
        if (rm<4) base+=m.cpu.regs[b_reg[rm]];
        int delta=disps[mode];
        unsigned addr=(unsigned)((int64_t)base+delta+65536) & 65535u;
        uint8_t code[4]={(uint8_t)(0x88u+wide+2u*direction),(uint8_t)((mode<<6)|rm),0,0};
        size_t n=2;
        if (mode==0 && rm==6) { addr=0xfffe;code[2]=0xfe;code[3]=0xff;n=4; }
        else if (mode==1) { code[2]=0xf9;n=3; }
        else if (mode==2) { code[2]=0x34;code[3]=0x12;n=4; }
        if (direction) { m.memory[addr]=0x98;m.memory[(addr+1u)&65535u]=0xba; }
        assert(machine_step(code,n,&m)==M_OK && m.cpu.ip==n && m.cpu.flags==0x200);
        if (direction) assert(m.cpu.regs[0]==(wide ? 0xba98 : 0x98));
        else { assert(m.memory[addr]==0x54);assert(m.memory[(addr+1u)&65535u]==(wide ? 0x76 : 0)); }
    }
    memset(&m,0,sizeof m);m.cpu.regs[0]=0x1234;
    assert(machine_step((uint8_t[]){0xa3,0xff,0xff},3,&m)==M_OK);
    assert(m.memory[65535]==0x34 && m.memory[0]==0x12);
    m.cpu.ip=0;m.cpu.regs[0]=0;
    assert(machine_step((uint8_t[]){0xa1,0xff,0xff},3,&m)==M_OK && m.cpu.regs[0]==0x1234);
    /* Memory-source address must use old BX, not the loaded destination BX. */
    memset(&m,0,sizeof m);m.cpu.regs[3]=100;m.memory[100]=200;
    assert(machine_step((uint8_t[]){0x8b,0x1f},2,&m)==M_OK && m.cpu.regs[3]==200);
    /* C7 little-endian immediate; sign-extended group83 memory ADD; CMP no write. */
    memset(&m,0,sizeof m);m.cpu.regs[3]=100;m.cpu.flags=0x200;
    assert(machine_step((uint8_t[]){0xc7,0x07,1,0},4,&m)==M_OK);
    m.cpu.ip=0;assert(machine_step((uint8_t[]){0x83,0x07,0xfe},3,&m)==M_OK);
    assert(m.memory[100]==255 && m.memory[101]==255 && (m.cpu.flags & 0x200));
    m.cpu.ip=0;assert(machine_step((uint8_t[]){0x83,0x3f,0xff},3,&m)==M_OK);
    assert(m.memory[100]==255 && m.memory[101]==255 && (m.cpu.flags & FLAG_ZF));
}
static void runs(void)
{
    Machine m={0},old=m;
    uint8_t program[]={0xc6,0x06,0,1,7,0xeb,0xfa}; /* store then jump into immediate at 1 */
    MachineResult r=machine_run(program,sizeof program,10,&m);
    assert(r.status==M_TARGET && r.offset==5 && r.steps==1);same(&m,&old);
    r=machine_run((uint8_t[]){0xeb,0xfe},2,3,&m);
    assert(r.status==M_LIMIT && r.steps==3 && r.offset==0);same(&m,&old);
    r=machine_run((uint8_t[]){0xb0,1},2,1,&m);
    assert(r.status==M_OK && r.steps==1 && r.offset==2 && m.cpu.regs[0]==1);
    memset(&m,0,sizeof m);old=m;
    r=machine_run((uint8_t[]){0xeb,1,0xff},3,3,&m); /* invalid unreachable suffix */
    assert(r.status==M_DECODE && r.offset==2 && r.steps==0);same(&m,&old);
    r=machine_run((uint8_t[]){0xeb,0xfb},2,2,&m);assert(r.status==M_TARGET);same(&m,&old);
    r=machine_run((uint8_t[]){0x74,0x7f},2,1,&m); /* untaken invalid target */
    assert(r.status==M_OK && r.steps==1 && m.cpu.ip==2);
    memset(&m,0,sizeof m);old=m;m.cpu.flags=FLAG_ZF;old=m;
    assert(machine_step((uint8_t[]){0x74,0x7f},2,&m)==M_TARGET);same(&m,&old);
    m.cpu.ip=1;old=m;r=machine_run((uint8_t[]){0xb8,1,0},3,2,&m);
    assert(r.status==M_TARGET && r.offset==1);same(&m,&old);
    memset(&m,0,sizeof m);old=m;
    assert(machine_run(NULL,0,1,&m).status==M_OK);same(&m,&old);
    assert(machine_step(NULL,0,&m)==M_TARGET);
    assert(machine_run(NULL,0,0,&m).status==M_ARGUMENT);
    assert(machine_run(NULL,1,1,&m).status==M_ARGUMENT);
    assert(machine_run((uint8_t[]){0},65536,1,&m).status==M_ARGUMENT);
    assert(machine_run(NULL,0,1,NULL).status==M_ARGUMENT);
    assert(machine_step(NULL,0,NULL)==M_ARGUMENT);
    /* Maximum allowed code length, target wraps to boundary 0. */
    static uint8_t large[65535];
    for (unsigned i=0;i<65532;i+=2) {large[i]=0xb0;large[i+1]=0;}
    large[65532]=0xe9;large[65533]=1;large[65534]=0;
    m.cpu.ip=65532;assert(machine_step(large,sizeof large,&m)==M_OK && m.cpu.ip==0);
}
int main(void)
{
    conditions();addresses();decoding();memory();runs();
    puts("PASS 1048576 branch predicates, 65536 byte comparisons, 524288 address/displacement cases, rel8/rel16, memory and rollback contracts");
    return 0;
}
