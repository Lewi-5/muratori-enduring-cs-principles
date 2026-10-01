# Reading questions answers (spoilers)

### F01

C call frames support arguments, locals and return control. Profiler frames record ID, start and direct-child elapsed for measurement. Same-ID recursion needs distinct profiler frames even if output later groups by ID.

### F02

Profiling locates expensive regions but adds work and can change code behavior. Coarse scopes reduce hook count and lose attribution detail; fine scopes add attribution and perturbation. State which tradeoff the measured workload supports.

### F03

The API must report inability to represent a valid overlapping total without publishing a partial report. Measurement definitions must clarify that overlapping inclusive time is not a disjoint wall-time partition; saturation would silently change the quantity.
