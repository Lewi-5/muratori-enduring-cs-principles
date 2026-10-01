# Worked answers

Each coding answer links annotated, complete C and explains correctness, edges and a plausible mistake. Each question answer gives the reasoning separately. ISO C is the authority for object and expression semantics; POSIX supplies the timer, and the compiler/ABI determines observed code and layout. Consult the primary references linked in the weekly README for the distinction.

### E01.C

[ex01.c](src/ex01.c) passes `-7`, `7u`, `-42L` and `42ULL` to `%d`, `%u`, `%ld` and `%llu`. The suffixes select the intended types; the conversion and argument must agree in this variadic function. `INT_MIN`, `INT_MAX` and `UINT_MAX` print representable boundaries rather than computing beyond them. The test checks the representative output and C's minimum required ranges, not a 32-bit assumption. Passing a `long` to `%d` is a faulty approach: it is not made valid merely because a particular ABI happens to print the desired low bits. Match the format to the type instead.

### E01.Q

A range is a set of mathematical values: for a typical 32-bit int it is -2147483648 through 2147483647. Representation is how bits encode a member of that set. `int x = -7;` specifies a value; it does not universally specify the bytes you would see in storage. C11 requires at least -32767..32767 for int and permits more than one signed representation, including sign-and-magnitude, ones' complement and two's complement. The target's limits are obtained from `<limits.h>`; its documented representation is an implementation choice. Unsigned arithmetic reduces modulo one more than its maximum value. Signed addition whose mathematical result is unrepresentable has undefined behavior: seeing a wrap in one executable does not license predicting the next optimized build. Print limits without evaluating `INT_MAX + 1`. A common error is treating range, byte count and representation as interchangeable facts.

### E02.C

[ex02.c](src/ex02.c) measures the actual array where it is declared and separately measures the helper's pointer parameter. `%zu` matches `size_t`, the unsigned result type of `sizeof`. For five ints the relationships are `array == 5 * element`, `element == sizeof(int)` and `parameter == sizeof(int *)`. Changing the declaration to three elements changes only the array extent and quotient in this experiment; pointer size does not follow the array length. An empty C array is not a portable substitute for this boundary test. A faulty test asserts `array == 20`: use the size relationship instead.

### E02.Q

At the definition, `sizeof values` is the storage size of all five elements, and `sizeof values[0]` is one int. Their quotient is exactly five; `sizeof` normally suppresses array-to-pointer conversion here. In a function parameter declaration, `int values[5]` is adjusted to `int *values`. The callee receives a pointer, not a copy of the array or a stored length. Its `sizeof values` is pointer size, so dividing by element size might coincidentally produce two on one machine, but does not discover the caller's length. On a typical 4-byte-int, 8-byte-pointer build the playground changes 20 to 12 bytes and five to three elements while the helper still reports eight. Those numbers are observations; the relationships are the guarantee. Pass length explicitly when needed.

### E03.C

[ex03.c](src/ex03.c) rejects counts above 10000 before starting the loop, adds each integer once, and stores output only on success. The CLI uses the supplied checked digit parser rather than `atoi`, which would not distinguish zero from malformed text. Boundary totals are 0, 1, 55 and 50005000 for N=0,1,10,10000. The next value is rejected with output unchanged. A loop beginning at zero can still be correct, but stopping at `i < n` while starting at one would omit N; the tests expose that mistake.

### E03.Q

Invariant: before iteration i, sum equals 1+...+(i-1). Initially i=1 and sum=0, the empty prefix. Adding i yields the prefix through i; incrementing i reestablishes the invariant. For N=3, the successive sums are 0,1,3,6; termination at i=4 leaves the complete sum. For N=0, the first condition is false and output is the empty sum zero. The largest result is `10000*10001/2 = 50005000`; unsigned long long can represent this on every conforming C11 implementation. On the reference platform the size_t loop index easily represents 10001 (indeed even C's minimum SIZE_MAX suffices here). A mathematical invariant alone is insufficient if its intermediate arithmetic can overflow; the input bound supplies that missing proof.

### E04.C

[ex04.c](src/ex04.c) checks interval validity before writing output. For a valid interval, comparisons choose the nearest endpoint only when outside the interval; otherwise the input is retained. Thus INT_MIN and INT_MAX require no risky subtraction. Tests cover [-3,3] exhaustively for values -5..5, equal bounds and integer extremes. Implementing clamp by subtracting endpoints can overflow on extremes; direct comparisons avoid that unnecessary failure mode.

### E04.Q

For [-3,8], -4 becomes -3, -3 stays -3, 4 stays 4, 8 stays 8 and 12 becomes 8. The endpoints belong to the interval. An interval [9,1] contains no values under this API and returns failure without touching output; even [2,2] is valid and always clamps to 2. A sentinel such as -1 is ambiguous because -1 can be a correct result in another interval. Swapping endpoints silently conceals an input mistake and changes the requested contract. A separate success flag leaves the full int range available for valid results and forces the caller to decide what to do with invalid input.

### E05.C

[ex05.c](src/ex05.c) initializes count and empty placeholders, then handles zero length before ever reading an element. On nonempty input it seeds both extrema from values[0] and scans the rest. For `{4,-2,7,7}`, (min,max) progresses (4,4), (-2,4), (-2,7), (-2,7). Comparisons, without arithmetic on values, accept integer extremes. A faulty implementation reads values[0] before checking length; the NULL/zero test detects that. Zero placeholders are a contract detail, not a claim that an empty set has extrema zero.

### E05.Q

After processing each prefix, min and max describe that prefix; the next value can only extend an endpoint or leave it alone. Starting from zero fails on `{4,7}` by reporting a minimum never present, and similarly fails for the maximum of an all-negative array. A singleton has the same min and max. An empty collection has no element to choose, so no ordinary integer result describes its minimum. Returning 0 plus count zero lets the caller distinguish no data from a genuine `{0}` result, which returns success and extrema zero. This distinction is semantic and portable; it does not depend on physical layout of Stats.

### E06.C

[ex06.c](src/ex06.c) visits exactly length elements in each version. The pointer version counts remaining elements, so zero length performs neither dereference nor pointer arithmetic; it can safely accept NULL in that case. For the fixture, 4-2+7+7=16; changing the first element to five gives 17 in both versions. The maximum absolute total is 10000000, which fits even C's minimum range for long. A faulty pointer loop dereferences its end pointer or forms `NULL + length` for an empty array; avoid both by guarding operations with remaining count.

### E06.Q

`p + 1` points to the next int element, not the next byte. Its address spacing in an actual array is `sizeof(int)` C bytes. C allows a pointer one past an array as a stopping value, but not reading through it. In the reference, the final increment forms one-past only for a real nonempty array and is never dereferenced. NULL is not an array address; even adding zero is not a sound general substitute for an explicit empty case. `values[i]` is defined using pointer arithmetic and dereference, so both traversals compute the same result under their contract. A compiler may nevertheless emit different instructions, or optimize both into the same loop. Increasing one element explains the incremented sum at the source level; it says nothing by itself about instruction count or speed.

### E07.C

[ex07.c](src/ex07.c) checks both coordinates for finiteness and then applies inclusive ranges. Logical `&&` combines all required conditions; a NaN cannot pass. The test includes both poles, both antimeridian endpoints, limits exceeded in either direction, NaN, and signed infinities. `PRIu64` handles the exact-width identifier's format without guessing whether it is unsigned long or unsigned long long. A faulty implementation checks `lat > 90` alone and ignores negative/out-of-range longitude; the symmetric boundary cases prevent that omission.

### E07.Q

id identifies a record; it is not a coordinate or a distance. lat_deg is signed latitude in degrees and lon_deg signed longitude in degrees. (45.5,-73.5) and the endpoint (90,180) are valid, while (91,0) exceeds latitude and (0,infinity) is not a finite location. NaN is unordered: both `lat < -90` and `lat > 90` are false for NaN, so a rejection condition containing only those comparisons can accidentally accept it. Explicit isfinite makes the finite-coordinate requirement visible. This week does not resolve whether +180 and -180 name the same meridian or calculate geodesic distance. Exact-width uint64_t is available on our target but is an optional typedef on more exotic C implementations.

### E08.C

[ex08.c](src/ex08.c) uses offsetof instead of guessing member addresses or deriving padding from uninitialized byte contents. Tests check that the first member begins at zero, later member extents do not overlap, and the total size accommodates the last member. They never assert a fixed total or an improvement from reordering. A faulty test uses `sizeof A == sum of member sizes`; C permits intervening and trailing padding, so use extents and bounds instead.

### E08.Q

A typical x86-64 Linux observation with char/int/double sizes 1/4/8 and double alignment 8 is:

```text
A: [0 tag][1..7 padding][8..15 value][16..19 count][20..23 tail padding]
   sizeof A = 24; offsets tag=0, value=8, count=16
B: [0..7 value][8..11 count][12 tag][13..15 tail padding]
   sizeof B = 16; offsets value=0, count=8, tag=12
```

Padding lets members and successive struct array elements satisfy the implementation's alignment requirements. Reordering packs the smaller fields into space following the double and needs less tail space in this example. C guarantees member order and no padding before the first ordinary member, but not these numeric offsets, sizes or strict improvement. Draw your observed layout by subtracting adjacent member extents; do not assume padding bytes have meaningful or reproducible contents. A common mistake is to serialize the raw struct as if every byte were a portable file format; the logical fields and storage representation are distinct.

### E09.C

[ex09.c](src/ex09.c) aliases the uint32_t object only through unsigned char, prints all `sizeof value` bytes, and classifies recognized sequences conditionally. For 8-bit bytes the common outputs are `04 03 02 01`/little and `01 02 03 04`/big. An unrecognized arrangement remains other. Tests verify the byte multiset and agreement with classification, not a preferred order. A faulty implementation reads through a `float *` and prints its value; that is not a valid object-representation inspection. Character access or copying into character storage is the repair.

### E09.Q

C specifically permits a character lvalue to access an object's representation. The uint32_t holds mathematical value 0x01020304 regardless of which end appears first in increasing memory addresses. A little-endian observation means the least significant octet 04 is at the lowest address for this object; it is not a universal C property. A C byte has CHAR_BIT bits, not necessarily eight. Exact-width uint32_t, where provided, has exactly 32 bits and no padding; implementations that cannot supply it need not define it. The required x86-64 target supplies it. Other non-character pointer reinterpretations can violate effective-type/alignment rules, even if two types happen to have equal size. One unsigned integer experiment also does not establish the layout of every floating-point or aggregate type.

### E10.C

[ex10.c](src/ex10.c) factors the four operations into tiny functions. OR sets requested bits, AND tests all requested bits, XOR toggles, and AND with complement clears while preserving other bits. Repeated setting is idempotent; toggling twice restores the original. Combined-mask tests distinguish the specified all-bits test from a faulty any-bit implementation `(flags & mask) != 0`. For a zero mask, the all-bits test is true, setting/toggling/clearing change nothing; it requests no bits.

### E10.Q

Using the two low bits, start `00`. OR READ `01` gives `01`; AND READ gives `01`, equal to the mask. XOR WRITE `10` gives `11`. Clearing READ computes `11 & ...1110`, giving `10`. Unsigned operands make bit arithmetic and complement easier to reason about with defined modular value behavior; `1u` also avoids accidental signed left-shift overflow. It does not make every shift valid: a negative count or a count at least the width of the promoted left operand is undefined for unsigned too. Here counts zero and one are valid on every target. A common error `flags & !mask` uses logical negation and normally clears everything; `~mask` is the bitwise complement required.

### E11.C

[ex11.c](src/ex11.c) rejects counts before multiplication, handles zero separately, allocates once, initializes every element before reading, and frees exactly once. N=5 produces 0,1,2,3,4 and sum 10. A block of 100 values totals 4950, so one million values total 49500000. Those values fit int and the aggregate fits unsigned long long. The C tests cover SIZE_MAX and the cap; the fault fixture also forces malloc failure and checks no free follows a failed allocation. A faulty `malloc(n * sizeof(int))` before validating n can wrap into too small a buffer. Bound n first, then multiply.

### E11.Q

The division check `n <= SIZE_MAX / sizeof(int)` is equivalent to requiring the multiplication's mathematical result to fit size_t, without performing the risky product. The one-million cap is an independent teaching-resource limit and also bounds work/sum; it is not a machine allocation guarantee. Zero deliberately allocates nothing and succeeds with zero sum, avoiding implementation differences in malloc(0). Nonzero malloc can fail even below the cap; return failure while leaving the output unchanged. The function owns the returned pointer until free, exposes no alias, and never reads after freeing. Freeing twice or losing the pointer before free breaks that ownership discipline. Fix the allocate-before-check mistake by validating, allocating, checking NULL, initializing, consuming and releasing in that order.

### E12.C

[ex12.c](src/ex12.c) opens in binary mode to count actual file bytes, uses int for fgetc's result, counts safely, checks ferror and unconditionally attempts fclose once. Outputs commit only after all operations succeed. For `one\ntwo\n`, bytes=8 and newlines=2; for `one\ntwo`, bytes=7 and newlines=1. Missing paths fail; empty files succeed with both counts zero. Tests add 0xff so an implementation that stores fgetc into signed char cannot mistake that byte for EOF. A faulty `if (ferror(file) || fclose(file))` skips the close on read error; separate checks preserve cleanup.

### E12.Q

Byte count measures storage units consumed; newline count measures occurrences of one character. A nonempty final line need not end in newline, so the two are not line-count synonyms. fopen failure is distinct from a successful open that immediately yields EOF. fgetc returns either an unsigned-char value converted to int or EOF, hence storing it in char loses information. EOF can mean normal end-of-file or read failure; ferror distinguishes them after the loop. Closing releases resources even after an earlier failure, and a nonzero fclose return is an error that must reach the caller. The code closes exactly once and does not retry using a closed stream. Count-overflow rejection leaves output unchanged too. On Linux the directory-path test exercises a real read error; deterministic mocks test close errors without relying on a filesystem accident.

### E13.C

[ex13.c](src/ex13.c) first enforces the digits-only grammar, clears errno, calls strtoull with base 10, then checks range, end pointer and the application limit before committing output. It accepts `00042` as 42 and `0` with limit zero. A huge decimal string exercises conversion overflow; 1000001 fits the conversion but violates the CLI limit. Testing with ULLONG_MAX as the function limit verifies that the largest conversion value is not inherently an error. A faulty parser treats any returned zero as failure; use conversion status and end-pointer information instead.

### E13.Q

Empty input has no digits. `1x`, `1.0` and `0x10` violate the chosen decimal grammar; `+1`, `-1` and whitespace are also deliberately rejected even though strtoull accepts some of them. A lexical pass makes that policy explicit. Setting errno to zero prevents a stale ERANGE from a previous call contaminating success. The end pointer must advance and finish at the terminator; otherwise conversion was absent or partial. ERANGE signals representational overflow, whereas `value > limit` signals a valid conversion rejected by course policy. Return 0 for either and leave output unchanged; main prints a diagnostic and returns a failing process status. Without sign rejection, strtoull can interpret a leading minus by unsigned negation, which is not the requested nonnegative decimal syntax.

### E14.C

[ex14_count.h](src/ex14_count.h), [ex14_count.c](src/ex14_count.c) and [ex14_main.c](src/ex14_main.c) separate interface, loop and caller. The loop counts exact equality without reordering input; zero iterations gives zero for an empty array. Tests include no matches, one match and repeated matches. Build commands from week-01, equivalent to the Makefile's rules, are:

```sh
gcc -std=c11 -Wall -Wextra -Wpedantic -Werror -O0 -c instructor/src/ex14_main.c -o build/main.o
gcc -std=c11 -Wall -Wextra -Wpedantic -Werror -O0 -c instructor/src/ex14_count.c -o build/count.o
gcc -std=c11 -Wall -Wextra -Wpedantic -Werror -O0 build/main.o build/count.o -o build/count-demo
nm build/main.o build/count.o build/count-demo
```

`make` creates build directories automatically; for these manual commands first run `mkdir -p build`. A faulty shortcut includes `ex14_count.c` in main: that defeats separate compilation and can produce duplicate definitions when also linked. Include the header instead.

### E14.Q

A declaration states the function's name and type so calls can be checked. A definition supplies its body. Preprocessing each `.c` file with its included headers produces a separate translation unit. Compilation produces an object containing code plus symbol/relocation information. Typically `nm ex14_main.o` shows `U count_equal`, an unresolved reference, while `nm ex14_count.o` shows `T count_equal`, a definition in the code section. The final executable has the resolved definition. Exact addresses are build-dependent; dynamic library symbols such as printf can remain to be resolved later. Omitting count.o causes a link error, not a mysterious runtime call. Defining an ordinary external function in a shared header produces a definition in each including translation unit; include guards prevent repeated inclusion within one unit, not multiple definitions across units. Keep one definition in a `.c` file.

### E15.C

[ex15.c](src/ex15.c) initializes before timing, validates a warm-up pass, then measures five batches of 1000 passes. Each pass sums ten full blocks 0..99 and one partial block 0..23: `10*4950 + 276 = 49776`. Each batch must total 49776000. A small double comparator sorts durations without lossy integer subtraction, so the third of five values is the median. Output and sorting occur after timing; the checksum check is also outside the interval. Clock failures return nonzero. A faulty design leaves the pure sum unused and lets the optimizer erase it. Volatile element reads require observable accesses here, at the deliberate cost of studying that constrained loop instead of unrestricted optimized array processing.

### E15.Q

timespec expresses seconds plus nanoseconds. Subtract both fields and calculate `seconds_difference + nanoseconds_difference/1e9`; a negative nanosecond difference is fine when the second field crosses a boundary. From (10,900000000) to (11,100000000), elapsed is `1 - 0.8 = 0.2 s`. Check clock calls before consuming their outputs. A monotonic clock avoids wall-clock corrections, but not scheduling interruptions or overhead. Warm-up reduces first-use effects and does not remove all noise.

For sample seconds [0.0024,0.0021,0.0023,0.0022,0.0025], sorting gives [0.0021,0.0022,0.0023,0.0024,0.0025]; median=0.0023, min=0.0021, max=0.0025, range=0.0004. The range is a simple descriptive variation measure, not a confidence interval. The timed region includes loop control, accumulation, calls if uninlined, and volatile reads; initialization and printing are excluded. Two clock calls and surrounding bookkeeping also affect short measurements. `-O2` may reduce control overhead but cannot simply erase the required volatile reads. Checking one final nonvolatile checksum alone would prevent total dead-code elimination but would not necessarily prevent hoisting the repeated sum outside the repetition loop.

Compare builds using the same data and workload, include all raw trials, and avoid a universal ranking. CPU state, compiler decisions, background work, virtualization and timer resolution can change outcomes. If -O2 loses or trial ranges overlap, report that result and gather more evidence before attributing a cause. Volatile is neither thread synchronization nor a general-purpose benchmarking prescription.

### P01

(a) Portable: a char occupies one C byte by definition; the byte's bit width can vary. (b) Implementation-defined: the implementation documents whether plain char behaves as signed or unsigned char; it does not follow solely from the CPU. (c) Portable: UINT_MAX is unsigned int and unsigned addition wraps modulo UINT_MAX+1. (d) Undefined when evaluated: both operands are int, the mathematical result is outside int's range, and the assignment destination cannot retroactively widen the addition. (e) Undefined dereference: `a+3` may be formed as one-past but does not point to an int object to read. “Implementation-dependent” is useful informal language for differing observations, but does not mean every difference is formally implementation-defined; padding byte values, for example, can be unspecified.

### P02

[practice_sizeof.c](extras/practice_sizeof.c) is the runnable answer. In the caller, sizes are `3*sizeof(int)`, `sizeof(int)` and quotient 3; it prints first element 2. In a function declared with `int a[3]`, a is adjusted to int *, so its size is `sizeof(int *)`, not the array's total. The runnable helper uses the explicit pointer spelling to avoid the diagnostic that warns about sizeof on adjusted array parameters while teaching the same type. A common 4-byte-int/8-byte-pointer build prints 12,4,3,8,2; only the symbolic relationships and first element are portable. Array parameter syntax does not check that three elements were passed. Supply length separately when using the array.

### P03

The loop visits indices 0,1,2,3, but only 0,1,2 designate elements. Replace `i<=3` with `i<3`; the resulting sum is 2+4+6=12. Forming the address a+3 is useful as an exclusive endpoint for comparison, but evaluating `a[3]` reads through that endpoint and is undefined. This diagnosis follows from the contract, not from whether one run crashes. The safe loop appears in [practice_sizeof.c](extras/practice_sizeof.c); the flawed text is never compiled or executed as a demonstration.

### P04

The E08 diagram is a worked plausible layout: A=24 bytes and B=16 when char/int/double alignment and sizes are 1/4/8 with aggregate alignment 8. A spends seven bytes before the double and four at the tail; B spends three at the tail. Thus reordering may save eight bytes per object. A compiler/ABI with other alignment rules may save nothing or produce different totals. A portable test can assert member order and non-overlap, but cannot require these constants or B<A. Smaller layout by itself also does not prove a faster program; this week measures layout only.

### P05

```text
main.c + count.h  -> preprocessing/compilation -> main.o [uses count_equal]
count.c + count.h -> preprocessing/compilation -> count.o [defines count_equal]
main.o + count.o + runtime/libraries -> linker -> executable
executable -> OS loader/process setup -> C runtime startup -> main -> return/exit
```

The compiler checks calls against the declaration in each unit. The linker finds a matching external definition and arranges references; if count.o is omitted, the unresolved count_equal is a link-time failure. Loading and running are later operations: the executable file itself is not a process, and the CPU usually enters runtime startup before the C main function. Shared library binding can be deferred further. The conceptual stages are durable even when a compiler driver hides the individual tool invocations.

### P06

Timing initialization plus summation measures two tasks, including stores absent from the intended steady-state loop. Move setup before the start clock and record it separately if setup cost is itself a question. Discarding a pure sum allows deletion because the program has no observable dependency on it. Consume and validate results; then inspect whether the compiler hoisted identical work. The week-one solution additionally uses volatile reads to require each pass, which inhibits some optimizations and changes the workload. It makes the limited experiment defensible, not a representative benchmark of every array sum. Neither fix removes scheduler noise or establishes a speed rule from one observation.

### S01

The commands in `make assembly` generate real listings for the learner's compiler. Below are illustrative AT&T-style x86-64 loop fragments for a function accumulating int elements into a long. They are explanations of possible output, not required byte sequences. Operand order is source,destination.

```asm
# Possible -O0 shape: index and sum reside in stack slots.
movq -8(%rbp), %rax          # reload index i
leaq 0(,%rax,4), %rdx       # offset for an implementation with 4-byte int
movq -24(%rbp), %rax        # array base
movl (%rax,%rdx), %eax      # load values[i]
cltq                       # sign-extend int to this ABI's 64-bit long
addq %rax, -16(%rbp)        # update sum in its stack slot
addq $1, -8(%rbp)           # advance i; comparison/branch surrounds this body

# Possible -O2 scalar shape: pointer/end/sum stay in registers.
.Lloop:
movslq (%rdi), %rdx         # load and sign-extend the current int
addq $4, %rdi              # advance by sizeof(int) on this machine
addq %rdx, %rax            # accumulate in register
cmpq %rsi, %rdi            # compare to exclusive end
jne .Lloop                 # continue if elements remain
```

The optimized fragment needs an empty-length check before entry, an initialized accumulator, a correctly formed end pointer for nonempty input, and a return after exit; these are excerpts, not standalone replacements. Less stack traffic is one plausible difference. Other compilers may unroll, use an index, or select vector instructions; none is required by C. Both implementations must preserve the valid-input result. Assembly alone does not determine elapsed time, prove faster execution, or justify assuming every automatic object lives on the stack. Annotate the actual listing rather than forcing it to fit this example.

### S02

[stretch_lines.c](extras/stretch_lines.c) is the complete annotated solution. It retains byte/newline counts plus a `last` value initialized to EOF. At normal EOF, logical lines = newlines + (nonempty and last character is not newline). Empty data has zero lines, `\n` has one, `one\ntwo\n` has two and `one\ntwo` also has two. A final newline closes a line; it does not create another empty logical line after the end under this contract. For `a\n\n`, there are two lines, including the empty second line. The extra line cannot overflow because when the file does not end in newline, newlines is strictly less than bytes. Open/read/close errors reject without committing output. The shared test runner compiles this file and verifies all these fixtures. The faulty formula `newlines+1` incorrectly reports one for an empty file and three for a two-line terminated file; track the final character to repair it.
