# Three ungraded warm-ups

### W01

Implement w01: interpret a 16-bit unsigned pattern as a signed mathematical value in int32_t. Test 0000, 7FFF, 8000 and FFFF; reject patterns above 65535 and NULL output without changes. Explain why subtracting 65536 is sufficient and why a cast to int16_t is avoidable.

### W02

Implement w02: compute complete word depth from high and SP as floor((high−SP)/2). Check high<=65535 and SP<=high. Explain why an odd distance is possible in this model and why this helper cannot prove the words are return addresses.

### W03

Implement w03: decode two low/high bytes as a uint16_t using shifts and OR, with NULL checks and unchanged output on failure. Explain why this works on either host byte order and why the API still requires two accessible input bytes.
