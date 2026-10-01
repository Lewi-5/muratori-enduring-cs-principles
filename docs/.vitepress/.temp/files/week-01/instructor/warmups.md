# Warm-up answers — the C field notebook

The linked files are complete solutions. The warm-ups are ungraded; these answers explain the reasoning so a learner can check more than the test result. Behaviour marked *observed* was seen with GCC 11.4 and Clang 14 on x86-64 Linux (WSL2); everything else follows from C11 (N1570).

### W01

[w01.c](src/w01.c) tests `a > limit || b > limit - a` before adding. The order matters. Once `a <= limit` is known, `limit - a` cannot wrap below zero, and `b > limit - a` is exactly the mathematical condition `a + b > limit`, evaluated without ever forming a value larger than `limit`. Only after both checks pass does the function compute `a + b`, which is then known to fit. The output is written last, so every rejection leaves it untouched.

The driver prints `ok=1 out=5` for 2 + 3, `ok=1 out=10` for 7 + 3 (a sum equal to the limit is accepted), `ok=0 out=99` for 7 + 4, and `ok=0 out=99` for `ULLONG_MAX + 1`. In the last case the sentinel 99 survives, which proves the function did not write.

**Question.** `a + b > limit` fails when the sum wraps. Unsigned arithmetic in C is defined to wrap modulo 2^N (C11 §6.2.5 ¶9), so `ULLONG_MAX + 1` is exactly 0, and `0 > ULLONG_MAX` is false. The faulty test accepts the sum and stores 0. Because the wrap is *defined*, nothing traps, no sanitizer complains, and the program carries on with a wrong value. That is why the fault is silent. With signed integers the same mistake is worse: signed overflow is undefined behaviour (§6.5 ¶5), so the compiler may assume it never happens, and the check may even be removed. E03, E11 and E13 all use the check-before-operating pattern for this reason, and the supplied `decimal.h` does it for decimal digits: `value > (limit - digit) / 10`.

**Faulty approach:** checking after the fact, `if (a + b < a)`. It detects wraparound for unsigned types, but it cannot enforce a `limit` below `ULLONG_MAX`, and the same idea applied to signed integers relies on undefined behaviour.

### W02

[w02.c](src/w02.c) counts `i` down from `length` to 1 and reads `values[i - 1]`. When `length` is 0 the loop body never runs, so a NULL `values` is never dereferenced. Index 0 is reached when `i == 1`. Scanning from the end means the first match found is the last one in the array, so the function can return immediately. Driver output: `last 7 -> found=1 index=3`, `last 4 -> found=1 index=0`, `last 1 -> found=1 index=4`, `last 9 -> found=0 index=99`.

**Question.** `size_t` is unsigned, so `i >= 0` is always true. For an absent target, the loop reaches `i == 0`, decrements it, and `i` wraps to `SIZE_MAX` (defined unsigned wraparound). The next `values[i]` reads far outside the array, which is undefined behaviour. For `length == 0`, the very first value `length - 1` is already `SIZE_MAX`. *Observed:* GCC rejects this loop under the course flags (`-Wextra` enables `-Wtype-limits`: "comparison of unsigned expression in '>= 0' is always true", an error under `-Werror`), while Clang 14 with `-Wall -Wextra` accepts it silently. A warning is a courtesy, not a guarantee. The safe shapes are "count down from `length` and use `i - 1`", as here, or `for (size_t i = length; i-- > 0; )`, which tests before decrementing.

**Faulty approach:** switching the index to `int` to make `i >= 0` meaningful. It works for small arrays, but `length` is a `size_t` and may exceed `INT_MAX`, and converting such a value to `int` gives an implementation-defined result or raises an implementation-defined signal (§6.3.1.3 ¶3).

### W03

[w03.c](src/w03.c): `byte_at` shifts the wanted byte down to the bottom and masks it: `(value >> (8 * index)) & 0xFF`. `bit_count` repeatedly clears the lowest set bit with `value &= value - 1` and counts how many times it can do so; a loop over all 32 positions testing `value & (1u << k)` is also correct. For `0x01020304` the driver prints the bytes `04 03 02 01` (least significant first) and counts 5 set bits (1 in `0x01`, 1 in `0x02`, 2 in `0x03`, 1 in `0x04`), 32 in `0xFFFFFFFF` and 0 in 0.

**Question.** `byte_at` works on the *value*: shifting is defined arithmetically (§6.5.7 ¶5, dividing by a power of two for unsigned operands), so byte 0 is always `0x04`, on every machine. E09 looks at the *object representation*, the bytes as they sit at increasing addresses in memory, and their order is the implementation's choice. On x86-64, a little-endian machine, memory also holds `04 03 02 01`, so the two agree there. On a big-endian machine memory would hold `01 02 03 04` while `byte_at` still returns `0x04` for index 0. The machine-dependent one is E09's view. Note also that `index` must stay below 4: shifting a 32-bit value by 32 or more is undefined (§6.5.7 ¶3), which is why the contract states the range.

**Faulty approach:** `((unsigned char *)&value)[index]`. It is legal C, but it returns the memory-order byte, which is E09's question, not this one's.

### W04

[w04.c](src/w04.c) measures the string with `strlen`, allocates `length + 1` bytes, checks for NULL, and copies `length + 1` bytes so the terminating NUL comes along. The caller owns the result. The driver changes the first letter, prints `copy=Geolab length=6`, and frees the copy exactly once.

**Question.** A C string is its characters followed by a byte with value 0 that marks the end; `strlen` counts only the characters before it. A copy with `strlen(text)` bytes has no room for the terminator, and copying it writes one byte past the allocation. That is undefined behaviour, and the test's AddressSanitizer build reports it as a heap buffer overflow. The copy may be changed because it is an ordinary array that the program allocated. The literal `"geolab"` may not: attempting to modify a string literal is undefined behaviour (§6.4.5 ¶7). On Linux, string literals live in read-only memory, and writing to one typically crashes.

`malloc` may return a null pointer when it cannot allocate (§7.22.3 ¶1), so the result must be checked; the test forces that path. Freeing the copy twice is undefined behaviour (§7.22.3.3 ¶2), which is why the contract says "exactly once". E11 applies the same ownership rules to an array, and E12 to an open file.

**Faulty approach:** returning a pointer to a local array, `char buffer[64]; … return buffer;`. The array's lifetime ends when the function returns (§6.2.4 ¶2), so the caller receives a pointer to storage that no longer exists.
