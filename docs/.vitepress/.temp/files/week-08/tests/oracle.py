"""Mathematical oracle: signed ranges and nibble arithmetic, not bitwise OF/AF
formulas copied from the C implementation. Python integers do not overflow.
"""
def arithmetic(op,wide,a,b):
    modulus=65536 if wide else 256
    sign=modulus//2
    exact=a+b if op==1 else a-b
    result=exact%modulus
    signed=lambda value: value if value<sign else value-modulus
    signed_exact=signed(a)+signed(b) if op==1 else signed(a)-signed(b)
    carry=exact>=modulus if op==1 else a<b
    auxiliary=(a%16+b%16>=16) if op==1 else (a%16<b%16)
    parity=(result%256).bit_count()%2==0
    overflow=not -sign<=signed_exact<sign
    flags=int(carry)+4*int(parity)+16*int(auxiliary)+64*int(result==0)+128*int(result>=sign)+2048*int(overflow)
    return result,flags
def cases():
    for op in [1,2,3]:
        for a in range(256):
            for b in range(256):
                r,f=arithmetic(op,0,a,b)
                yield op,0,a,b,r,f
    boundaries=[0,1,15,16,127,128,255,256,32767,32768,65534,65535]
    for op in [1,2,3]:
        for a in boundaries:
            for b in boundaries:
                r,f=arithmetic(op,1,a,b); yield op,1,a,b,r,f
        seed=0x12345678
        for _ in range(4096):
            seed=(1664525*seed+1013904223)%2**32; a=seed%65536
            seed=(1664525*seed+1013904223)%2**32; b=seed%65536
            r,f=arithmetic(op,1,a,b); yield op,1,a,b,r,f
def state_line(regs,ip,flags):
    return ''.join(f' {name}={v:04x}' for name,v in zip(['ax','cx','dx','bx','sp','bp','si','di'],regs))+f' ip={ip:04x} flags={flags:04x}\n'
def trace_program(commands):
    """Encoding-direction straight-line program builder with independent state.
    commands contain op, width, destination register, signed immediate.
    """
    regs=[0]*8; flags=0; ip=0; offset=0; data=bytearray(); lines=[]
    for op,wide,reg,imm in commands:
        size=1+wide; value=imm%(256**size)
        if op==0:
            encoded=bytes([0xb0|wide<<3|reg])+value.to_bytes(size,'little')
            name='mov'
        else:
            group={1:0,2:5,3:7}[op]
            encoded=bytes([0x80|wide,0xc0|group<<3|reg])+value.to_bytes(size,'little')
            name={1:'add',2:'sub',3:'cmp'}[op]
        slot=reg if wide else reg%4
        old=regs[slot] if wide else ((regs[slot]//256 if reg>=4 else regs[slot])%256)
        if op: result,flags=arithmetic(op,wide,old,value)
        else: result=value
        if op!=3:
            if wide: regs[slot]=result
            elif reg<4: regs[slot]=regs[slot]//256*256+result
            else: regs[slot]=regs[slot]%256+result*256
        ip=(ip+len(encoded))%65536
        register=(['al','cl','dl','bl','ah','ch','dh','bh'],['ax','cx','dx','bx','sp','bp','si','di'])[wide][reg]
        lines.append(f'offset={offset} {name} {register}, {imm} |'+state_line(regs,ip,flags))
        offset+=len(encoded); data.extend(encoded)
    lines.append(f'final steps={len(commands)} |'+state_line(regs,ip,flags))
    return bytes(data),''.join(lines)
