#!/bin/sh
# S02: what did the compiler decide about the distance loop? Run from week-05. Nothing here changes flags to force a
# result; the output is a toolchain observation for this compiler version.
set -u
COMMON="-std=c11 -O2 -ffp-contract=off -D_POSIX_C_SOURCE=200809L -Iinstructor/geolab/include -Isupport"
echo "== gcc $(gcc -dumpfullversion): is the vectorizer on at -O2?"
gcc -Q --help=optimizers -O2 | grep -E -- '-ftree-(loop|slp)-vectorize'
echo "== gcc -O2 -fopt-info-vec-all (bench.c distance loop and query.c loops)"
gcc $COMMON -c instructor/geolab/src/bench.c -o /dev/null -fopt-info-vec-all 2>&1 | grep -E 'bench.c:(9[0-9]|10[0-9]):' | sort -u
gcc $COMMON -c instructor/geolab/src/query.c -o /dev/null -fopt-info-vec-all 2>&1 | grep -E 'missed|optimized' | sort -u | head -12
echo "== gcc -O2 -ftree-vectorize (what -O2 would try if the vectorizer were enabled; GCC 12+ enables a cheap form)"
gcc $COMMON -ftree-vectorize -c instructor/geolab/src/bench.c -o /dev/null -fopt-info-vec-missed 2>&1 | grep -E 'bench.c:(9[0-9]|10[0-9]):' | sort -u
echo "== clang $(clang -dumpversion) -O2 remarks"
clang $COMMON -c instructor/geolab/src/bench.c -o /dev/null -Rpass=loop-vectorize -Rpass-missed=loop-vectorize \
    -Rpass-analysis=loop-vectorize 2>&1 | grep -E 'bench.c:(9[0-9]|10[0-9]):' | sort -u
echo "== are the VEC=off and VEC=default objects different? (needs make bench-bins for both compilers)"
for cc in gcc clang; do
    for u in csv geo query cli bench main; do
        a=build/instructor/$cc/bench-vec-off/obj/$u.o
        b=build/instructor/$cc/bench-vec-default/obj/$u.o
        if [ -f "$a" ] && [ -f "$b" ]; then
            if cmp -s "$a" "$b"; then echo "$cc $u.o identical"; else echo "$cc $u.o differs"; fi
        fi
    done
done
