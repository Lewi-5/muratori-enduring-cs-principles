# Graded assignment

### E01.C

Implement insertion_sort with checked arguments and exact comparison/write counts. Preserve ties by moving only strictly larger keys. Test empty, singleton, already sorted and reversed input.

### E01.Q

Predict the sorted four-element example versus reversed input: count three versus six comparisons. Explain best-case linear and worst-case quadratic work, and why Big O is an asymptotic upper bound rather than a measured time or a synonym for worst-case input.

### E02.C

Implement iterative merge_sort using caller scratch, merging equal keys from the left first. Copy back after every width pass; count every data/scratch write. Check the full argument contract before touching memory.

### E02.Q

Draw two adjacent sorted runs with equal keys. Explain the invariant, ceil(log2(n)) passes, odd tail handling, O(n log n) work and O(n) extra record storage. Explain why an in-place merge is a separate algorithm.

### E03.C

Implement radix_sort as four stable least-significant-byte passes for uint32_t keys. Use numeric shifts, 256 counters and exclusive offsets. Scatter forward, swapping source/destination after each pass.

### E03.Q

Trace keys 256,1,0,257 after the first byte and after the next. Explain why stability is required, why four passes leave the result in data, and why comparison-sort lower bounds do not apply to fixed-width radix sorting.

### E04.C

Implement summarize over a local copy of 1–64 uint64_t nanosecond samples. Compute min/max, arithmetic mean and the even/odd median without integer-sum overflow. Leave input and output unchanged on error as specified.

### E04.Q

For samples 9,1,5,3 calculate min=1, median=4, mean=4.5 and max=9. Explain what a minimum suggests about favorable state and why it does not describe a typical application invocation.

### E05.C

Run the supplied benchmark for at least four sizes and all four input shapes. Predict crossover before running, validate results, preserve raw rows and environment/flags, and complete R01–R05.

### E05.Q

Explain why resetting input, consuming output and labeling timed boundaries matter. Distinguish algorithmic counts, instrumented timings, allocation cost, scratch capacity and unmeasured cache behavior. State how a different valid crossover is interpreted.
