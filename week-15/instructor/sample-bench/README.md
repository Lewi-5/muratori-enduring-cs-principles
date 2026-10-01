# Actual repeated-sort observations

tools/sample.py records GCC and Clang optimized runs for four sizes and four input shapes, nine timed trials after one warm-up. environment.json records date, versions, target, kernel, exact flags and source hashes. CSV timings are actual observations, not expected outputs or universal crossover requirements. The benchmark counts operations inside its timed sort, resets outside it and consumes/checks afterward. Algorithms run in fixed order, so environmental drift and order effects remain limitations; alternating/randomized order is a useful controlled extension.

The tiny sample-summary numbers in the playground are deterministic arithmetic fixtures, not this measurement. Compare each shape and size independently, state which summary supports a claim, and permit another environment to differ. Regenerating these files deliberately replaces the sample with a new recorded experiment; update its date when doing so.
