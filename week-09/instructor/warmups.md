# Warm-up reasoning and check-yourself answers

### W01

The reference in src/w01.c validates the range 0..255 and subtracts 256 only for patterns 128..255. F8 hex is 248, so its signed interpretation is -8; 80 hex is 128, so its interpretation is -128. All intermediate values are representable in int32_t. An out-of-range int8_t cast would depend on the C implementation. The test checks all 256 patterns and invalid inputs. Validation comes before assignment, so failure preserves the caller's output.

### W02

The reference in src/w02.c converts the displacement to uint32_t, adds the following IP and retains the low sixteen bits with a mask of 65535. The result is 0009 hex for 0011 minus 8, and FFFF for zero minus 1. Both input ranges are checked before mutation. Testing every following IP with displacements +1 and -1 catches errors at zero and the upper boundary. This helper produces a numeric guest offset; validating whether it selects an instruction boundary is a later operation. It never produces a negative host array index.

### W03

The reference in src/w03.c widens each byte, shifts the high byte by eight bits and combines the values with OR. Bytes 34 and 12 hex yield word 1234; bytes FF and 80 yield 80FF. Widening before shifting makes the arithmetic explicit, and the result fits uint16_t. The test checks all 65536 word patterns. Copying the bytes into a host uint16_t with memcpy would use the host's byte order and would not define the guest encoding.

Check yourself: a relative displacement is measured from the position following the complete instruction. Signed JL uses SF != OF because overflow can make the stored subtraction sign misleading. A word at FFFF uses host array indices 65535 and 0. An untaken jump preserves flags and does not validate its unused destination. Budget failure discards the entire tentative Machine while still returning the attempted step count. Real 8086 segment addressing and instruction decoding are broader than this teaching model.
