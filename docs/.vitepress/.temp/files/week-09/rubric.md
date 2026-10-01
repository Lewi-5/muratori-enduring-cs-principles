# Week 9 rubric

One graded assignment, 100 points. E01 addresses 15; E02 decoding and sixteen predicates 20; E03 registers/memory/flags and atomic steps 25; E04 boundary/budget/whole-run transaction 20; E05 independent predicted trace and R01–R05 evidence 20. Warm-ups and practice are ungraded; stretch earns feedback, not a requirement.

Full credit explains the mechanism and portability boundary, validates failures without leaked state, and uses independent expected values. Incorrect signed predicates, a host out-of-bounds word access or partial mutation on a failed run blocks correctness credit for the affected criterion until fixed. A compiler-clean build alone is insufficient. Equivalent correct implementations earn credit; no speedup threshold or required host instruction sequence is imposed. Reports retain a mistaken prediction and explain the correction instead of rewriting history. Actual workload may differ from unpiloted estimates.
