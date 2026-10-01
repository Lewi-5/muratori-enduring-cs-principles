#include "project.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static Machine initial(void)
{
    Machine m={0};m.stack_low=0x80;m.stack_high=0x100;m.cpu.regs[REG_SP]=0x100;return m;
}
static void equal(const Machine *a,const Machine *b)
{
    assert(memcmp(a,b,sizeof *a)==0);
}
static CodeImage image(const uint8_t *code,size_t n)
{
    CodeImage out;MachineResult r=project_prepare(code,n,&out);
    assert(r.status==M_OK && r.offset==n && r.steps==0);return out;
}
static void preparation(void)
{
    const uint8_t code[]={0xb8,0x34,0x12,0xeb,0xfb};
    CodeImage out=image(code,sizeof code),old=out;
    assert(out.bytes==code && out.length==5);
    for (unsigned k=0;k<65536;++k) assert(out.boundary[k]==(k==0 || k==3 || k==5));
    MachineResult r=project_prepare((uint8_t[]){0x90,0xe8,0},3,&out);
    assert(r.status==M_DECODE && r.offset==1 && r.steps==0 && memcmp(&out,&old,sizeof out)==0);
    r=project_prepare((uint8_t[]){0xeb,1,0xff},3,&out);
    assert(r.status==M_DECODE && r.offset==2 && memcmp(&out,&old,sizeof out)==0);
    assert(project_prepare(NULL,1,&out).status==M_ARGUMENT);
    assert(project_prepare(code,65536,&out).status==M_ARGUMENT);
    assert(project_prepare(code,5,NULL).status==M_ARGUMENT);
    assert(memcmp(&out,&old,sizeof out)==0);
    out=image(NULL,0);assert(out.boundary[0]==1 && out.boundary[1]==0);
    static uint8_t large[65535];memset(large,0x90,sizeof large);
    out=image(large,sizeof large);assert(out.boundary[65535] && out.boundary[65534]);
}
static void arithmetic(void)
{
    /* Mathematical oracle for every byte ADD/SUB/CMP pair, not C bit formulas. */
    for (unsigned a=0;a<256;++a) for (unsigned b=0;b<256;++b) for (unsigned op=0;op<3;++op) {
        int subtract=op!=0;
        int full=subtract ? (int)a-(int)b : (int)a+(int)b;
        unsigned value=(unsigned)(full+256) % 256u;
        int sa=a<128 ? (int)a : (int)a-256,sb=b<128 ? (int)b : (int)b-256;
        int signed_full=subtract ? sa-sb : sa+sb;
        unsigned bits=0;for (unsigned k=0;k<8;++k) bits+=(value >> k) & 1u;
        unsigned flags=(subtract ? a<b : a+b>255) ? FLAG_CF : 0u;
        if (!(bits % 2u)) flags|=FLAG_PF;
        if (subtract ? a%16u<b%16u : a%16u+b%16u>15u) flags|=FLAG_AF;
        if (!value) flags|=FLAG_ZF;
        if (value>=128) flags|=FLAG_SF;
        if (signed_full < -128 || signed_full>127) flags|=FLAG_OF;
        AluResult out;assert(sim_alu(op==0 ? OP_ADD : op==1 ? OP_SUB : OP_CMP,0,(uint16_t)a,(uint16_t)b,&out));
        assert(out.value==value && out.flags==flags);
    }
}
static void predicates(void)
{
    for (unsigned bits=0;bits<32;++bits) {
        int c=(bits & 1u)!=0,p=(bits & 2u)!=0,z=(bits & 4u)!=0;
        int s=(bits & 8u)!=0,o=(bits & 16u)!=0;
        const int expected[16]={o,!o,c,!c,z,!z,c||z,!(c||z),s,!s,p,!p,s!=o,s==o,z||(s!=o),!(z||(s!=o))};
        uint16_t flags=(uint16_t)(0x200u+(c ? FLAG_CF : 0u)+(p ? FLAG_PF : 0u)
            +(z ? FLAG_ZF : 0u)+(s ? FLAG_SF : 0u)+(o ? FLAG_OF : 0u));
        for (unsigned k=0;k<16;++k) {
            uint8_t code[2]={(uint8_t)(0x70u+k),0xfe};CodeImage prepared=image(code,2);
            Machine m=initial();m.cpu.flags=flags;
            assert(project_step(&prepared,&m)==M_OK);
            assert(m.cpu.ip==(expected[k] ? 0 : 2) && m.cpu.flags==flags);
        }
    }
}
static void memory(void)
{
    const unsigned first[8]={3,3,5,5,6,7,5,3},second[4]={6,7,6,7};
    for (unsigned rm=0;rm<8;++rm) for (unsigned mode=0;mode<3;++mode)
    for (unsigned wide=0;wide<2;++wide) for (unsigned direction=0;direction<2;++direction) {
        Machine m=initial();m.cpu.regs[3]=0xfff0;m.cpu.regs[5]=0x100;m.cpu.regs[6]=0x21;m.cpu.regs[7]=0x31;
        m.cpu.regs[0]=0x7654;m.cpu.flags=0x200;
        int32_t sum=m.cpu.regs[first[rm]];
        if (rm<4) sum+=m.cpu.regs[second[rm]];
        if (mode==1) sum-=7;else if (mode==2) sum+=0x1234;
        unsigned addr=(unsigned)(sum+65536) % 65536u;
        uint8_t code[4]={(uint8_t)(0x88u+wide+2u*direction),(uint8_t)((mode << 6)|rm),0,0};size_t n=2;
        if (!mode && rm==6) {addr=65535;code[2]=255;code[3]=255;n=4;}
        else if (mode==1) {code[2]=0xf9;n=3;}
        else if (mode==2) {code[2]=0x34;code[3]=0x12;n=4;}
        if (direction) {m.memory[addr]=0x98;m.memory[(addr+1u)%65536u]=0xba;}
        CodeImage prepared=image(code,n);assert(project_step(&prepared,&m)==M_OK);
        assert(m.cpu.flags==0x200 && m.cpu.ip==n);
        if (direction) assert(m.cpu.regs[0]==(wide ? 0xba98 : 0x7698));
        else {assert(m.memory[addr]==0x54);assert(m.memory[(addr+1u)%65536u]==(wide ? 0x76 : 0));}
    }
    Machine m=initial();m.cpu.regs[3]=0x100;m.memory[0x100]=0x20;m.memory[0x101]=2;
    CodeImage prepared=image((uint8_t[]){0x8b,0x1f},2);
    assert(project_step(&prepared,&m)==M_OK && m.cpu.regs[3]==0x220);
    /* Memory arithmetic, signed immediate and CMP no data change. */
    m=initial();m.cpu.regs[3]=0x100;
    prepared=image((uint8_t[]){0xc7,7,1,0,0x83,7,0xfe,0x83,0x3f,0xff},10);
    assert(project_run(&prepared,3,&m).status==M_OK && m.memory[0x100]==255 && m.memory[0x101]==255);
    assert(m.cpu.flags & FLAG_ZF);
}
static void stack_and_failures(void)
{
    Machine m=initial(),old=m;
    CodeImage prepared=image((uint8_t[]){0x50,0x5b},2);m.cpu.regs[0]=0x1234;
    assert(project_run(&prepared,2,&m).status==M_OK && m.cpu.regs[3]==0x1234 && m.cpu.regs[4]==0x100);
    assert(m.memory[0xfe]==0x34 && m.memory[0xff]==0x12);
    m=initial();prepared=image((uint8_t[]){0x54},1);
    assert(project_step(&prepared,&m)==M_OK && m.memory[0xfe]==0xfe && m.cpu.regs[4]==0xfe);
    m=initial();m.cpu.regs[4]=0xfe;m.memory[0xfe]=0x82;
    prepared=image((uint8_t[]){0x5c},1);
    assert(project_step(&prepared,&m)==M_OK && m.cpu.regs[4]==0x82);
    m=initial();m.cpu.regs[4]=0xfe;m.memory[0xfe]=0x7f;old=m;
    assert(project_step(&prepared,&m)==M_STACK);equal(&m,&old);
    m=initial();prepared=image((uint8_t[]){0x90,0xe8,0xfc,0xff},4);old=m;
    MachineResult r=project_run(&prepared,300,&m);assert(r.status==M_STACK && r.steps==129);equal(&m,&old);
    /* Ret target corruption cannot leak the tentative POP. */
    m=initial();m.cpu.regs[4]=0xfe;m.memory[0xfe]=1;old=m;
    prepared=image((uint8_t[]){0xc3,0xb8,0,0},4);
    /* Target 1 is legal here; change it to immediate position 2. */
    m.memory[0xfe]=2;old=m;assert(project_step(&prepared,&m)==M_TARGET);equal(&m,&old);
    prepared=image((uint8_t[]){0xc6,6,0,1,7,0xeb,0xfa},7);m=initial();old=m;
    r=project_run(&prepared,10,&m);assert(r.status==M_TARGET && r.offset==5 && r.steps==1);equal(&m,&old);
    prepared=image((uint8_t[]){0xeb,0xfe},2);r=project_run(&prepared,3,&m);
    assert(r.status==M_LIMIT && r.steps==3 && r.offset==0);equal(&m,&old);
    prepared=image((uint8_t[]){0x74,0x7f},2);r=project_run(&prepared,1,&m);assert(r.status==M_OK);
    m=initial();m.cpu.flags=FLAG_ZF;old=m;assert(project_step(&prepared,&m)==M_TARGET);equal(&m,&old);
    prepared=image((uint8_t[]){0xb8,0,0},3);m=initial();m.cpu.ip=1;old=m;
    r=project_run(&prepared,2,&m);assert(r.status==M_TARGET && r.offset==1);equal(&m,&old);
    prepared=image(NULL,0);m=initial();old=m;
    r=project_run(&prepared,1,&m);assert(r.status==M_OK && r.steps==0);equal(&m,&old);
    assert(project_step(&prepared,&m)==M_TARGET);
    assert(project_run(NULL,1,&m).status==M_ARGUMENT);
    assert(project_run(&prepared,0,&m).status==M_ARGUMENT);
    assert(project_run(&prepared,1,NULL).status==M_ARGUMENT);
    assert(project_step(NULL,&m)==M_ARGUMENT);
    assert(project_step(&prepared,NULL)==M_ARGUMENT);
    static uint8_t large[65535];memset(large,0x90,sizeof large);
    large[65532]=0xe9;large[65533]=1;large[65534]=0;
    prepared=image(large,sizeof large);m=initial();m.cpu.ip=65532;
    assert(project_step(&prepared,&m)==M_OK && m.cpu.ip==0);
    for (unsigned kind=0;kind<2;++kind) {
        uint8_t code[1]={(uint8_t)(kind ? 0x48 : 0x40)};prepared=image(code,1);m=initial();
        m.cpu.flags=0x201;m.cpu.regs[0]=kind ? 0x8000 : 0x7fff;
        assert(project_step(&prepared,&m)==M_OK && (m.cpu.flags & FLAG_CF) && (m.cpu.flags & FLAG_OF) && (m.cpu.flags & 0x200));
    }
}
static void traces(void)
{
    const uint8_t code[]={0xb8,0x34,0x12,0xa3,0xff,0xff};CodeImage prepared=image(code,6);
    Machine m=initial(),old=m;TraceRecord records[3],saved[3];memset(records,0xa5,sizeof records);memcpy(saved,records,sizeof saved);
    size_t count=77;MachineResult r=project_trace(&prepared,2,&m,records,1,&count);
    assert(r.status==M_CAPACITY && r.offset==6 && r.steps==2 && count==77);equal(&m,&old);assert(memcmp(records,saved,sizeof records)==0);
    r=project_trace(&prepared,2,&m,records,3,&count);assert(r.status==M_OK && count==2);
    assert(records[0].before_ip==0 && records[0].after.ip==3 && records[0].changed_count==0);
    assert(records[0].addresses[0]==0 && records[0].values[1]==0);
    assert(records[1].changed_count==2 && records[1].addresses[0]==0 && records[1].values[0]==0x12);
    assert(records[1].addresses[1]==0xffff && records[1].values[1]==0x34);
    assert(memcmp(&records[2],&saved[2],sizeof records[2])==0);
    /* Same-value writes are not observable deltas. */
    m.cpu.ip=3;r=project_trace(&prepared,1,&m,records,3,&count);assert(r.status==M_OK && count==1 && !records[0].changed_count);
    m=initial();old=m;memcpy(records,saved,sizeof records);count=77;
    prepared=image((uint8_t[]){0x50,0xc3},2);m.memory[0]=99;old=m;
    r=project_trace(&prepared,3,&m,records,0,&count);
    assert(r.status==M_LIMIT && count==77);equal(&m,&old);assert(memcmp(records,saved,sizeof records)==0);
    prepared=image(NULL,0);m=initial();r=project_trace(&prepared,1,&m,NULL,0,&count);assert(r.status==M_OK && count==0);
    count=77;assert(project_trace(&prepared,1,&m,NULL,1,&count).status==M_ARGUMENT && count==77);
    assert(project_trace(&prepared,1,&m,records,3,NULL).status==M_ARGUMENT);
    assert(project_trace(&prepared,1,NULL,records,3,&count).status==M_ARGUMENT);
}
static void comparison(void)
{
    /* Deterministic comparison to uncached predecessor. Shared helpers mean
       this is regression equivalence, supplemented by independent domains. */
    const uint8_t nested[]={0xb8,0x34,0x12,0xe8,2,0,0xeb,0x0c,0x50,0xb8,0x78,0x56,0xe8,3,0,0x5b,0xc3,0x90,0x40,0xc3};
    CodeImage nested_image=image(nested,sizeof nested);Machine nested_a=initial(),nested_b=nested_a;
    MachineResult nx=project_run(&nested_image,100,&nested_a),ny=machine_run(nested,sizeof nested,100,&nested_b);
    assert(nx.status==M_OK && nx.steps==10 && nx.steps==ny.steps);
    assert(nested_a.cpu.regs[0]==0x5679 && nested_a.cpu.regs[3]==0x1234 && nested_a.cpu.regs[4]==0x100);
    equal(&nested_a,&nested_b);
    for (unsigned pattern=0;pattern<256;++pattern) {
        uint8_t code[]={0xb8,(uint8_t)pattern,0xff,0x50,0x5b,0x40,0x48,0x39,0xd8,0x75,0,0xa3,0xff,0xff};
        CodeImage prepared=image(code,sizeof code);Machine a=initial(),b=a;
        MachineResult x=project_run(&prepared,20,&a),y=machine_run(code,sizeof code,20,&b);
        assert(x.status==y.status && x.offset==y.offset && x.steps==y.steps);equal(&a,&b);
    }
    for (unsigned opcode=0;opcode<256;++opcode) {
        uint8_t code[8]={(uint8_t)opcode,0,0,0,0,0,0,0};
        Decoded d;MachineStatus s=machine_decode(code,sizeof code,&d);
        if (s!=M_OK) continue;
        CodeImage prepared=image(code,d.length);Machine a=initial(),b=a;
        MachineResult x=project_run(&prepared,3,&a),y=machine_run(code,d.length,3,&b);
        assert(x.status==y.status && x.offset==y.offset && x.steps==y.steps);equal(&a,&b);
    }
}
int main(void)
{
    preparation();arithmetic();predicates();memory();stack_and_failures();traces();comparison();
    puts("PASS 196608 independent arithmetic cases, 512 conditional steps, prepared-map/trace/stack/memory/rollback and predecessor comparisons");
    return 0;
}
