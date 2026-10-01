# Evidence notebook

### R01

Draw creation, helper return, successful resize and release for automatic pointer/result, static counter and allocated elements. Label valid access windows without assuming physical stack placement.

### R02

Record actual compiler diagnostics for return_local.c and sanitizer reports for use_after_free/double_free. Explain each defect and the corresponding repair.

### R03

Describe allocator ownership/provenance and failure injection. Record attempts, successful allocations and releases, proving the failed grow leaves the original data intact.

### R04

Record six-mode repaired correctness results and expected broken-program failures separately. State what remains a caller precondition and what tests cannot prove.

### R05

Record actual workload, peak resize memory and a handoff to later arena/allocator weeks. Give one API design that would make a lifetime obligation easier to follow.
