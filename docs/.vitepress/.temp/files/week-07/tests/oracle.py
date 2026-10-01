"""Independent encoding-direction oracle: choose fields, then emit bytes.
No decoder is used to create expected strings. Each case records its reason.
"""
REGS=[['al','cl','dl','bl','ah','ch','dh','bh'],['ax','cx','dx','bx','sp','bp','si','di']]
BASES=['bx + si','bx + di','bp + si','bp + di','si','di','bp','bx']
def address(mod,rm,value=0):
    if mod==3: return [],None
    if mod==0 and rm==6: return list(value.to_bytes(2,'little')),f'[{value}]'
    data=[] if mod==0 else list(value.to_bytes(1 if mod==1 else 2,'little',signed=True))
    sign=' - ' if value<0 else ' + '
    text=BASES[rm]+(sign+str(abs(value)) if value else '')
    return data,f'[{text}]'
def cases():
    for op,code in [('mov',0x88),('add',0),('sub',0x28),('cmp',0x38)]:
        for wide in range(2):
            for direction in range(2):
                for mod in range(4):
                    for rm in range(8):
                        values=([0,65535] if rm==6 else [0]) if mod==0 else ([-128,-1,0,127] if mod==1 else ([-32768,-1,0,32767] if mod==2 else [0]))
                        for value in values:
                            for reg in range(8):
                                tail,mem=address(mod,rm,value)
                                target=REGS[wide][rm] if mod==3 else mem
                                operands=[target,REGS[wide][reg]]
                                if direction: operands.reverse()
                                yield bytes([code|direction<<1|wide,mod<<6|reg<<3|rm]+tail),op+' '+', '.join(operands)
    for opcode,wide,count in [(0x80,0,1),(0x81,1,2),(0x83,1,1),(0xc6,0,1),(0xc7,1,2)]:
        ops=[('mov',0)] if opcode in (0xc6,0xc7) else [('add',0),('sub',5),('cmp',7)]
        for op,reg in ops:
            for mod in range(4):
                for rm in range(8):
                    disp=65535 if mod==0 and rm==6 else (-128 if mod==1 else (-32768 if mod==2 else 0))
                    tail,mem=address(mod,rm,disp)
                    for value in ([-128,-1,0,127] if count==1 else [-32768,-1,0,32767]):
                        target=REGS[wide][rm] if mod==3 else ('word ' if wide else 'byte ')+mem
                        yield bytes([opcode,mod<<6|reg<<3|rm]+tail+list(value.to_bytes(count,'little',signed=True))),f'{op} {target}, {value}'
    for opcode in range(0xa0,0xa4):
        for value in [0,32768,65535]:
            acc=REGS[opcode&1][0]; mem=f'[{value}]'
            operands=[acc,mem] if not opcode&2 else [mem,acc]
            yield bytes([opcode]+list(value.to_bytes(2,'little'))),'mov '+', '.join(operands)
    # Every old-week family remains present, including all 256 byte values.
    for wide in range(2):
        for reg in range(8):
            for value in (range(-128,128) if not wide else [-32768,-1,0,32767]):
                yield bytes([0xb0|wide<<3|reg])+value.to_bytes(1+wide,'little',signed=True),f'mov {REGS[wide][reg]}, {value}'
        for op,base in [('add',4),('sub',0x2c),('cmp',0x3c)]:
            for value in [-128,-1,0,127] if not wide else [-32768,-1,0,32767]:
                yield bytes([base|wide])+value.to_bytes(1+wide,'little',signed=True),f'{op} {REGS[wide][0]}, {value}'
