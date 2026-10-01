# Beginner warm-ups

Ungraded typed stubs; attempt before comparing with solutions.

### W01

Implement address_bytes(mod,rm): modes 0–2 and rm 0–7 return the address-tail byte count; invalid arguments return 99. Explain why a byte data operation may need two address bytes.

### W02

Implement signed_byte(raw) returning -128..127 using int32_t arithmetic and no signed narrowing cast. Explain how FE differs from the direct-address bytes FE FF.

### W03

Implement next_offset(offset,length,total,out). Require nonzero length, a real output pointer and an extent inside total. Return 1 with offset+length or 0 preserving out. Explain why the next instruction depends on length and why checking offset+length first is risky.
