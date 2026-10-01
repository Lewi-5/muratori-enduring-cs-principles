# Warm-ups answers (spoilers)

### W01

Check child<=inclusive before unsigned subtraction. Inclusive100,child30 yields70.

Code: [w01.c](src/w01.c). Check with `make warmups` using PACKAGE=instructor.

### W02

Reject UINT64_MAX; otherwise publish old+1. Zero-duration events still use this increment.

Code: [w02.c](src/w02.c). Check with `make warmups` using PACKAGE=instructor.

### W03

Convert before dividing. Part200,whole 100 yields2 because inclusive regions can overlap; do not clamp to1.

Code: [w03.c](src/w03.c). Check with `make warmups` using PACKAGE=instructor.
