# `geolab` contract version 1 (checkpoint 1)

This is the versioned contract that week 5 delivers and later checkpoints build on. A later checkpoint may add commands and accept more option values; it must keep `generate` byte-identical and `query` output compatible, or bump the version and say why.

## Commands

| Command | Options | Standard output on success |
| --- | --- | --- |
| `geolab generate` | `--count N` (0–1,000,000), `--seed S` (0–18446744073709551615), `--out FILE` | nothing; FILE holds the CSV v1 bytes of week 4 |
| `geolab query` | `--input FILE`, `--lat X`, `--lon Y`, `--radius-km R`; optional `--threads 1`, `--backend scalar`, `--index none` | `id,distance_km`, then `ID,D` per hit, `D` printed with `%.6f` |
| `geolab bench` | `--input FILE`, `--variant parse\|distance\|query`, `--repeat N` (1–1,000); optional `--warmup W` (0–100, default 3), `--lat X` (default 0), `--lon Y` (default 0), `--radius-km R` (default 1000) | the `env` block, then one `bench …` line |

- Options may appear in any order; each at most once; every value is one argument. Unknown, duplicate, missing or stray arguments are usage errors.
- **Numbers.** `--lat`, `--lon` and `--radius-km` accept `-?(0|[1-9][0-9]*)(\.[0-9]{1,6})?`, with no sign for the radius. Latitude is limited to ±90, longitude to ±180 and the radius to [0, 100000]. The value is the correctly rounded double of the decimal (Annex F), and `-0`-style input gives +0.0. `--count`, `--seed`, `--repeat` and `--warmup` are unsigned decimal integers without sign, whitespace or leading `+`.
- **`query` semantics.** Every point whose haversine distance from the center is `<=` the radius is selected (inclusive), ordered by the unrounded distance and then by identifier, both ascending. A header-only file gives the header line alone.
- **Future options.** `--threads 2…256`, `--backend simd`, `--index grid` and `--index kd` are well-formed values that checkpoint 1 does not support (exit 3). Any other value is a usage error (exit 2).
- **`bench` line:** `bench variant=V points=P warmup=W repeat=N resolution_ns=R min_ns=… median_ns=… max_ns=… median_ns_per_point=… short_samples=K checksum=COUNT:VALUE`. VALUE is the identifier sum modulo 2^64 for `parse`, the `%a` double sum for `distance`, and a 16-hex-digit order-sensitive hash for `query`. A zero-point input is an error (`geolab: empty benchmark input`).

## Exit codes and diagnostics

| Exit | Meaning |
| --- | --- |
| 0 | success |
| 1 | input, data, allocation, clock or output error; a file error names week 4's status and line: `geolab: PARSE_BAD_LAT at line 3 in FILE` |
| 2 | usage error (unknown, duplicate or missing option; malformed or out-of-range value) |
| 3 | a well-formed option value that checkpoint 1 does not support |

Every diagnostic goes to standard error and begins with `geolab:`. Validation and computation finish before the first byte is printed, so standard output is empty on those failures. A write error on standard output can happen after output has begun. It is reported (`geolab: output error`, exit 1), but no rollback is promised. `generate` removes its partial output after a failure only if the path is a regular file.

## Build variants

| Variant | Flags (added to `-std=c11 -Wall -Wextra -Wpedantic -Werror -ffp-contract=off -D_POSIX_C_SOURCE=200809L`) | Directory |
| --- | --- | --- |
| debug | `-O0` | `build/PACKAGE/CC/debug` |
| optimized | `-O2` | `build/PACKAGE/CC/optimized` |
| sanitize | `-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer` | `build/PACKAGE/CC/sanitize` |
| bench, `VEC=off` (the scalar baseline for week 31) | `-O2` plus GCC `-fno-tree-vectorize` or Clang `-fno-vectorize -fno-slp-vectorize` | `build/PACKAGE/CC/bench-vec-off` |
| bench, `VEC=default` | `-O2` | `build/PACKAGE/CC/bench-vec-default` |

Forbidden in every variant: `-ffast-math`, `-Ofast`, `-funsafe-math-optimizations`, `-march=native`, and any flag permitting reassociation or contraction. The exact compile command is recorded in each build directory (`compile-command.txt`, `buildinfo.h`) and printed by `bench`.

## Data

CSV v1 (week 4), unchanged: header `id,lat_deg,lon_deg`, LF only, six-decimal fixed-point coordinates, at most 1,000,000 rows and 127 characters per line. The reference datasets are the oracle's `d1k` (seed 1, 1,000 rows), `d100k` (seed 11400714819323198485, 100,000 rows) and `d1m` (seed 5, 1,000,000 rows, SHA-256 `513c4440…0a42`).
