# Warm-ups answers (spoilers)

### W01

Check seconds against (UINT64_MAX-nanos)/1e9, then publish seconds*1e9+nanos. 1s+2ns yields1000000002.

Code: [w01.c](src/w01.c). Check with `make warmups` using PACKAGE=instructor.

### W02

Reject end<begin before subtraction. 9→9 gives0; 9→8 fails and leaves the sentinel.

Code: [w02.c](src/w02.c). Check with `make warmups` using PACKAGE=instructor.

### W03

Use total/batch plus one when total%batch is nonzero. UINT64_MAX with batch2 yields UINT64_MAX/2+1.

Code: [w03.c](src/w03.c). Check with `make warmups` using PACKAGE=instructor.
