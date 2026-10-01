#include "machine.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static Machine fresh(void)
{
    Machine m={0};
    m.stack_low=0x80; m.stack_high=0x100; m.cpu.regs[REG_SP]=0x100;
    return m;
}
static void unchanged(const Machine *a, const Machine *b)
{
    assert(memcmp(a,b,sizeof *a)==0);
}
static void stack_tests(void)
{
    Machine m=fresh(), old=m;
    uint16_t out=0x7777;
    assert(machine_push(NULL,1)==M_ARGUMENT);
    assert(machine_pop(NULL,&out)==M_ARGUMENT);
    assert(machine_pop(&m,NULL)==M_ARGUMENT); unchanged(&m,&old);
    assert(machine_pop(&m,&out)==M_STACK && out==0x7777); unchanged(&m,&old);
    for (unsigned value=0; value<65536; ++value) {
        m=fresh(); m.cpu.flags=0xabcd; m.cpu.ip=42;
        assert(machine_push(&m,(uint16_t)value)==M_OK);
        assert(m.cpu.regs[REG_SP]==0xfe && m.memory[0xfe]==value%256u && m.memory[0xff]==value/256u);
        assert(machine_pop(&m,&out)==M_OK && out==value);
        assert(m.cpu.regs[REG_SP]==0x100 && m.cpu.flags==0xabcd && m.cpu.ip==42);
        assert(m.memory[0xfe]==value%256u);
    }
    m=fresh();
    for (unsigned k=0; k<64; ++k) assert(machine_push(&m,(uint16_t)k)==M_OK);
    old=m; assert(machine_push(&m,0)==M_STACK); unchanged(&m,&old);
    for (unsigned k=64; k; --k) assert(machine_pop(&m,&out)==M_OK && out==k-1u);
    m=fresh(); m.stack_low=3; m.stack_high=9; m.cpu.regs[REG_SP]=9;
    assert(machine_push(&m,0x1234)==M_OK && m.memory[7]==0x34 && m.memory[8]==0x12);
    m.cpu.regs[REG_SP]=2; old=m; assert(machine_push(&m,0)==M_STACK); unchanged(&m,&old);
    m.stack_low=m.stack_high; old=m; assert(machine_pop(&m,&out)==M_STACK); unchanged(&m,&old);
}
static void decoder_tests(void)
{
    Decoded d={0}, old=d;
    uint8_t code[]={0xe8,0,0};
    assert(machine_decode(NULL,1,&d)==M_ARGUMENT);
    assert(machine_decode(NULL,0,&d)==M_DECODE);
    assert(machine_decode(code,3,NULL)==M_ARGUMENT);
    for (size_t n=0; n<3; ++n) { assert(machine_decode(code,n,&d)==M_DECODE); assert(memcmp(&old,&d,sizeof d)==0); }
    for (unsigned pattern=0; pattern<65536; ++pattern) {
        code[1]=(uint8_t)(pattern & 255u); code[2]=(uint8_t)(pattern >> 8);
        assert(machine_decode(code,3,&d)==M_OK && d.kind==X_CALL && d.length==3);
        assert(d.relative==(pattern<32768 ? (int32_t)pattern : (int32_t)pattern-65536));
    }
    for (unsigned k=0; k<8; ++k) {
        code[0]=(uint8_t)(0x50u+k); assert(machine_decode(code,1,&d)==M_OK && d.kind==X_PUSH && d.reg==k);
        code[0]=(uint8_t)(0x58u+k); assert(machine_decode(code,1,&d)==M_OK && d.kind==X_POP && d.reg==k);
    }
    const uint8_t unsupported[]={0x68,0xcb,0xc2,0xf4,0xff,0x26};
    for (size_t k=0; k<sizeof unsupported; ++k) {
        code[0]=unsupported[k]; old=d;
        assert(machine_decode(code,3,&d)==M_DECODE); assert(memcmp(&old,&d,sizeof d)==0);
    }
}
static void transfer_tests(void)
{
    const uint8_t code[]={0xb8,0x34,0x12,0xe8,2,0,0xeb,12,0x50,0xb8,0x78,0x56,
                          0xe8,3,0,0x5b,0xc3,0x90,0x40,0xc3};
    Machine m=fresh(), old=m;
    MachineResult r=machine_run(code,sizeof code,10,&m);
    assert(r.status==M_OK && r.steps==10 && r.offset==20);
    assert(m.cpu.regs[REG_AX]==0x5679 && m.cpu.regs[REG_BX]==0x1234 && m.cpu.regs[REG_SP]==0x100);
    assert(m.memory[0xfe]==6 && m.memory[0xff]==0 && m.memory[0xfa]==15 && m.memory[0xfb]==0);
    m=old; r=machine_run(code,sizeof code,9,&m); assert(r.status==M_LIMIT && r.steps==9); unchanged(&m,&old);
    const uint8_t bad_call[]={0xe8,0xfe,0xff,0x90};
    assert(machine_step(bad_call,sizeof bad_call,&m)==M_TARGET); unchanged(&m,&old);
    const uint8_t ret[]={0xc3};
    assert(machine_step(ret,1,&m)==M_STACK); unchanged(&m,&old);
    assert(machine_push(&m,2)==M_OK); old=m;
    assert(machine_step(ret,1,&m)==M_TARGET); unchanged(&m,&old);
    m=fresh(); assert(machine_push(&m,1)==M_OK);
    assert(machine_step(ret,1,&m)==M_OK && m.cpu.ip==1 && m.cpu.regs[REG_SP]==0x100);
    /* PUSH SP is explicitly original-8086 behavior; POP SP writes after pop. */
    const uint8_t ps[]={0x54}; m=fresh(); m.cpu.flags=0xffff;
    assert(machine_step(ps,1,&m)==M_OK && m.memory[0xfe]==0xfe && m.cpu.flags==0xffff);
    const uint8_t pops[]={0x5c}; m=fresh(); assert(machine_push(&m,0x80)==M_OK);
    assert(machine_step(pops,1,&m)==M_OK && m.cpu.regs[REG_SP]==0x80);
    m=fresh(); assert(machine_push(&m,0x7777)==M_OK); old=m;
    assert(machine_step(pops,1,&m)==M_STACK); unchanged(&m,&old);
    /* Reversed saves restore wrong words: a failing RET must roll back POP. */
    const uint8_t late[]={0x50,0xb8,1,0,0xc3}; m=fresh(); m.cpu.regs[REG_AX]=2; old=m;
    r=machine_run(late,sizeof late,10,&m); assert(r.status==M_TARGET && r.steps==2 && r.offset==4); unchanged(&m,&old);
    const uint8_t loop[]={0xeb,0xfe}; m=fresh(); old=m;
    r=machine_run(loop,2,3,&m); assert(r.status==M_LIMIT && r.steps==3 && r.offset==0); unchanged(&m,&old);
    const uint8_t truncated[]={0x50,0xe8};
    r=machine_run(truncated,2,3,&m); assert(r.status==M_DECODE && r.steps==0 && r.offset==1); unchanged(&m,&old);
    r=machine_run(NULL,0,1,&m); assert(r.status==M_OK && r.steps==0);
    assert(machine_run(NULL,1,1,&m).status==M_ARGUMENT);
    assert(machine_run(code,65536,1,&m).status==M_ARGUMENT);
    assert(machine_run(code,sizeof code,0,&m).status==M_ARGUMENT);
    assert(machine_run(code,sizeof code,1,NULL).status==M_ARGUMENT);
    m.cpu.ip=1; assert(machine_run(code,sizeof code,1,&m).status==M_TARGET);
    const uint8_t backward[]={0xeb,3,0x40,0xc3,0x90,0xe8,0xfa,0xff,0x90};
    m=fresh(); r=machine_run(backward,sizeof backward,5,&m);
    assert(r.status==M_OK && r.steps==5 && m.cpu.regs[REG_AX]==1 && m.cpu.regs[REG_SP]==0x100);
    const uint8_t recursive[]={0xe8,0xfd,0xff}; m=fresh(); old=m;
    r=machine_run(recursive,sizeof recursive,100,&m);
    assert(r.status==M_STACK && r.steps==64 && r.offset==0); unchanged(&m,&old);
    r=machine_run(recursive,sizeof recursive,64,&m);
    assert(r.status==M_LIMIT && r.steps==64 && r.offset==0); unchanged(&m,&old);
    /* A CALL with a valid target but a full stack cannot leak a return word. */
    m=fresh(); m.cpu.regs[REG_SP]=m.stack_low; old=m;
    assert(machine_step(recursive,sizeof recursive,&m)==M_STACK); unchanged(&m,&old);
    assert(machine_step(NULL,1,&m)==M_ARGUMENT);
    assert(machine_step(code,sizeof code,NULL)==M_ARGUMENT);
    /* All non-SP register stack forms read and restore the actual bank slot. */
    for (unsigned reg=0; reg<8; ++reg) {
        if (reg==REG_SP) continue;
        uint8_t pushpop[]={(uint8_t)(0x50u+reg),(uint8_t)(0x58u+reg)};
        m=fresh(); m.cpu.regs[reg]=(uint16_t)(0x1200u+reg); m.cpu.flags=0xa55a;
        assert(machine_step(pushpop,sizeof pushpop,&m)==M_OK);
        m.cpu.regs[reg]=0;
        assert(machine_step(pushpop,sizeof pushpop,&m)==M_OK);
        assert(m.cpu.regs[reg]==0x1200u+reg && m.cpu.flags==0xa55a && m.cpu.regs[REG_SP]==0x100);
    }
}
static void baseline_tests(void)
{
    /* Preserve CF with INC/DEC, including OF edges and unrelated bits. */
    const uint8_t inc[]={0x40}, dec[]={0x48};
    for (unsigned carry=0; carry<2; ++carry) {
        Machine m=fresh(); m.cpu.regs[REG_AX]=0x7fff; m.cpu.flags=(uint16_t)(0x200u+carry);
        assert(machine_step(inc,1,&m)==M_OK && m.cpu.regs[REG_AX]==0x8000);
        assert((m.cpu.flags & FLAG_OF)!=0 && (m.cpu.flags & FLAG_CF)==carry && (m.cpu.flags & 0x200)!=0);
        m.cpu.ip=0; assert(machine_step(dec,1,&m)==M_OK && m.cpu.regs[REG_AX]==0x7fff);
        assert((m.cpu.flags & FLAG_OF)!=0 && (m.cpu.flags & FLAG_CF)==carry);
    }
    const uint8_t mem[]={0xb8,0x34,0x12,0xa3,0xff,0xff,0x8b,0x1e,0xff,0xff};
    Machine m=fresh(); MachineResult r=machine_run(mem,sizeof mem,10,&m);
    assert(r.status==M_OK && m.memory[65535]==0x34 && m.memory[0]==0x12 && m.cpu.regs[REG_BX]==0x1234);
    /* All condition predicates independently specified as a truth table. */
    for (unsigned bits=0; bits<32; ++bits) {
        int c=(bits & 1u)!=0,z=(bits & 2u)!=0,s=(bits & 4u)!=0,o=(bits & 8u)!=0,p=(bits & 16u)!=0;
        int expected[16]={o,!o,c,!c,z,!z,c||z,!c&&!z,s,!s,p,!p,s!=o,s==o,z||s!=o,!z&&s==o};
        for (unsigned k=0; k<16; ++k) {
            uint8_t jcc[]={(uint8_t)(0x70u+k),1,0x90};
            m=fresh(); m.cpu.flags=(uint16_t)((c?FLAG_CF:0)|(z?FLAG_ZF:0)|(s?FLAG_SF:0)|(o?FLAG_OF:0)|(p?FLAG_PF:0));
            uint16_t flags=m.cpu.flags;
            assert(machine_step(jcc,sizeof jcc,&m)==M_OK && m.cpu.ip==(expected[k]?3:2) && m.cpu.flags==flags);
        }
    }
    const uint8_t count[]={0xb9,3,0,0x49,0x75,0xfd}; m=fresh();
    r=machine_run(count,sizeof count,10,&m); assert(r.status==M_OK && r.steps==7 && m.cpu.regs[REG_CX]==0);
}
int main(void)
{
    stack_tests(); decoder_tests(); transfer_tests(); baseline_tests();
    puts("PASS stack values, signed decode, nested calls, boundaries, rollback, flags and memory");
    return 0;
}
