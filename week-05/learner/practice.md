# Practice (ungraded) and stretch work (optional)

Answers are in the instructor package. Work each problem before you look.

### P01

Classify each statement as an ISO C guarantee, a POSIX/Linux guarantee, compiler or hardware behavior, or false in general. Justify each with a clause, a man-page statement or a counterexample.

1. `clock()` measures elapsed wall-clock time.
2. `CLOCK_MONOTONIC` never goes backwards.
3. `CLOCK_MONOTONIC` counts processor cycles.
4. `qsort` keeps equal elements in their original order.
5. A program that never calls `setlocale` prints `.` as the decimal point of `%.6f`.
6. A faster `-O2` time shows that the compiler vectorized the loop.

### P02

Eleven timed repetitions of one `bench` run gave these samples, in nanoseconds, in the order they were taken:

`812, 790, 805, 798, 5210, 801, 795, 808, 799, 803, 797`

By hand, compute the minimum, median, maximum, mean and spread `(max − min) / median`. Recompute the mean and median without the 5,210 sample. Show how that one sample moves the mean and not the median, suggest what might have caused it, and state what each statistic estimates.

### P03

In the style of Handmade Hero 010's dimensional analysis: a `distance` run over 1,000,000 points had a median of 44,660,000 ns.

1. Convert that to nanoseconds per point and to points per second.
2. Convert it to gigabytes per second of `GeoPoint` data read. Use 24 bytes per point for the whole structure, then 16 bytes per point for the two fields actually used.
3. Convert it to cycles per point at a **stated** nominal frequency of 3.0 GHz.
4. List three reasons the cycle figure is only an estimate.

### P04

A query found these eight hits. The distances are given exactly, in `%a`, and in decimal:

| id | distance (`%a`) | distance (decimal) |
| ---: | --- | --- |
| 9 | `0x1.9000001ad7f2ap+6` | 100.0000004 |
| 40 | `0x1.9p+3` | 12.5 |
| 2 | `0x1.f480000000001p+7` | 250.25000000000003 |
| 21 | `0x1.90000006b5fcap+6` | 100.0000001 |
| 5 | `0x0p+0` | 0 |
| 12 | `0x1.f48p+7` | 250.25 |
| 30 | `0x1.387fffffbce42p+14` | 19999.999999 |
| 7 | `0x1.9p+3` | 12.5 |

Write the exact output lines `geolab query` must print, in order. Identify the exact tie and the two printed ties, and say which identifiers come out in reverse numerical order and why.

### P05

For each command, give the exit code, whether anything is printed on standard output, and the first line of the diagnostic (if any). `d.csv` is a valid 1,000-row file, `header.csv` is valid but header-only, and `missing.csv` does not exist.

1. `geolab query --input d.csv --lat 45 --lon -73.5 --radius-km 10`
2. `geolab query --input d.csv --lat 45 --lon -73.5`
3. `geolab query --input d.csv --lat 95 --lon 0 --radius-km 1`
4. `geolab query --input d.csv --lat 45 --lon 0 --radius-km 1 --threads 8`
5. `geolab query --input d.csv --lat 45 --lon 0 --radius-km 1 --backend gpu`
6. `geolab query --input missing.csv --lat 0 --lon 0 --radius-km 1`
7. `geolab bench --input header.csv --variant query --repeat 5`
8. `geolab bench --input d.csv --variant query --repeat 5 --repeat 6`
9. `geolab generate --count 10 --seed -1 --out x.csv`
10. `geolab query --input d.csv --lat -0.0 --lon 1.5 --radius-km 0`

### S01

**Bytes per point** (the syllabus extension). For each `bench` variant, estimate the bytes read and written per point:

- **CSV bytes per row.** *Derive* them from the generator's distribution of formatted field lengths (week 4). Latitude and longitude microdegrees are uniform over their integer ranges; count how many values need a sign and how many integer digits. Then check the result against the actual size of the 1,000,000-row file.
- **`GeoPoint` data.** 24-byte `GeoPoint`s are read (gated on the reference ABI), but the distance uses only 16 of those bytes.
- **Output.** 16-byte hits are written.

Combine these with your measured medians into bytes per nanosecond. State what this does **not** show: whether memory bandwidth is a limit is week 21's question.

### S02

**What did the compiler decide?** Build `bench.c` and `query.c` at `-O2` with `VEC=default` and ask the compiler why:

- GCC: `-fopt-info-vec-all`;
- Clang: `-Rpass=loop-vectorize -Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize`.

Also find out whether your GCC enables the vectorizer at `-O2` at all (`gcc -Q --help=optimizers -O2`), and compare the `VEC=off` and `VEC=default` object files with `cmp`. Do not change flags to force a result. Record whether the distance loop was vectorized and the reason the compiler gives, and explain it in terms of the loop body's calls to scalar `libm` functions and its early return. This is the first entry in the vectorization path's evidence trail; week 31 starts from it.
