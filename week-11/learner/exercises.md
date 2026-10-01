# Graded assignment — Explain a compiled call

Implement the four C modules under [lab.h](../include/lab.h), then inspect actual generated artifacts and complete R01–R05. Completed geolab support and the local-example subject are supplied. Preserve predictions before compiling.

### E01.C

Implement abi_plan for only the header's scalar fixed-signature subset. GP and XMM counters are independent. Give source-order stack spills entry-RSP offsets starting at eight, and round caller reservation to sixteen. Validate all kinds/counts/pointers before committing; initialize unused fields on success. Test both pools and invalid interior kinds.

### E01.Q

Map geo_distance_km's four doubles plus pointer, query_hit_compare's two pointers, and query_points's points/count/lat/lon/radius/hits/nhits. Name integer return locations and distinguish the pointer-written distance. Predict seven integer arguments and nine double arguments, including alignment and first spill.

### E02.C

Implement distance_to_origin and compare_hit_values in wrappers.c through the supplied geolab functions. Delegate coordinate validation; reject nonfinite/negative distances and NULL comparison output without changing output. Preserve full uint64_t ID ordering. Compare real geo/query function assembly with wrapper assembly at both optimization levels.

### E02.Q

Explain argument moves at the wrapper-to-distance call and why source argument number five can still arrive in RDI. Explain the difference between compiler text, object relocations and final linked addresses. Explain what a tail jump does to an ordinary call/return sequence.

### E03.C

Implement fold_ids over GeoPoint IDs using defined unsigned wrap, accepting NULL only with zero count and preserving out on bad arguments. Use supplied local_example as an unchanged comparison subject. Generate real debug/optimized inspection artifacts for both compilers; annotate one loop and the local example.

### E03.Q

Explain why doubled in local_example can disappear while the result stays correct. Show a stack-slot observation in debug and an optimized expression observation if present; accept different valid compiler choices. Explain why lea can compute arithmetic without reading memory and why fewer instructions do not establish cycles.

### E04.C

Implement keep_across_call: validate callback/out, call exactly once with seed+1, then store pre-call seed plus callback result modulo 2^64. Annotate the indirect call and how seed/output pointer survive it. Test zero/max values, callback argument/count and unchanged output on bad arguments.

### E04.Q

Explain caller-clobbered versus callee-preserved registers, RSP alignment before CALL versus at entry, and why a caller cannot keep live state in its red zone across a nested call. Separate the architectural return word from a modern return predictor; state what your listings cannot prove about prediction.

### E05.C

Run the supplied playground, tests and inspection tools for your learner implementation. Submit the fixed output plus actual compiler/version/target/flag manifests and annotated O0/O2 GCC/Clang comparisons for geo_distance_km and query_hit_compare. Complete R01–R05. Optionally write at most one 10–20-line assembly probe that sums seven uint64_t arguments without changing preserved registers/RSP; compare with the separate reference probe after attempting it. The core may remain entirely C.

### E05.Q

Compare Week 10's two-byte near return with ordinary x64 eight-byte return and the System V data agreements. Explain why CE's 8086 cycle table cannot time your x64 geolab and why a correct ABI trace is not a prediction-success measurement. State the handoff to Week 12.
