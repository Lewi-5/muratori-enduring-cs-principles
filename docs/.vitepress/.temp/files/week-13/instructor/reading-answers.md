# Reading questions answers (spoilers)

### F01

Scott introduces coordination of hardware operations. The OS exposes an elapsed-time abstraction with its own units, adjustments and failure rules; the Linux manual defines this assignment’s clock.

### F02

clock() reports processor time in clock_t units; timespec_get(TIME_UTC) supplies calendar-based time. Neither is the specified monotonic elapsed provider. Their representation/conversion lessons still help.

### F03

Performance comparisons require a specified workload and metric. An empirical ticks/sec conversion ties one counter to a measured interval; it does not establish core cycles, stability across systems or performance for another workload.
