# Notebook exemplar

### R01

E01.Q supplies a complete three-signature mapping. Annotate the actual geo_distance_km boundary: XMM0–3 receive lat1/lon1/lat2/lon2, RDI is output pointer, EAX is status. In query_hit_compare, RDI/RSI reference QueryHit objects and EAX is ordering. In query_points, GP and FP pools are independent as shown in the table. Reloads/moves within a function are compiler choices; the public boundary locations are ABI obligations. Do not label a pointer store as a double return in XMM0.

### R02

The recorded environment is GCC 11.4 and Clang 14 under x86-64 Linux/WSL; sample manifests preserve exact version/target/flags and hashes. GCC O0 local_example uses a doubled slot at RBP−8; GCC O2 uses LEA with +1; Clang O2 uses LEA and ADD one. These differ yet preserve the same modular C function. In GCC O2 distance_to_origin, the tail JMP carries a relocation naming geo_distance_km; its placeholder relative value is not a final target. Sample object listings are dated observations, not required golden instruction tests. Source .s, object relocations and final executable are different stages.

### R03

```text
caller just before CALL: RSP=P, P mod 16=0
callee entry:           RSP=P-8 -> eight-byte return word; arg7 at P
after PUSH RBX:         RSP=P-16 -> saved RBX; return at P-8; arg7 at P
```

Thus arg7 changes from entry offset +8 to post-push offset +16. The recorded callback routine saves incoming RBP/RBX, retains output pointer in RBP and seed in RBX, adjusts alignment, calls RSI with seed+1 in RDI, then restores the saved registers. A different compiler may use stack slots. Caller-live red-zone storage would overlap nested callee usage; allocate a frame or use preserved storage instead.

### R04

Record the command matrix and actual exit statuses from validation.md, plus any learner-specific changes and outcomes. C tests cover scalar plans, geolab edge/order cases, modular folds, callback argument/count and unchanged error outputs. The optional probe's sum tests validate six register arguments and one stack argument; the C sanitizer cannot instrument assembly instructions. Unsupported cases include struct/vector/varargs classification, Windows ABI and predictor modeling. Functional checks and artifacts do not supply timings or prediction-hit rates.

### R05

Use actual recorded workload fields: viewing/reference __; planner __; wrappers __; loop/local __; callback __; artifacts/report/practice __; total __. These are learner measurements, not filled with an invented pilot. A useful difficulty entry is confusing pointer-written distance with function return. Week 12 receives the tested simulator subset/traces, actual geolab O0/O2 annotations and labeled model limitations. Historical costs are assumptions about a particular processor; modern timing requires a separate experiment.
