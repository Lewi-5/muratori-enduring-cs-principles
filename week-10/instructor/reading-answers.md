# Further-reading answers

### F01

All three explain a saved continuation and last-in, first-out restoration for nested calls. CS:APP and Dive Into Systems discuss x64: their eight-byte return words, RSP naming, register argument passing and frame conventions must not be substituted for our two-byte near return and SP. The shared idea is control transfer with retained continuation; its size and convention are ISA/ABI-specific. CS:APP's frame diagrams are useful reasoning tools, not a C requirement that every local have an addressable stack slot.

### F02

Scope tells you where a name is visible, while lifetime tells you when the object exists. An automatic local ceases to be a valid object at block exit regardless of whether its bytes still look unchanged. Dereferencing a returned &local is therefore invalid; a successful stale read would not make it portable. `int good(int *out) { if (!out) return 0; *out=7; return 1; }` lets the caller provide storage whose lifetime extends through use. Static storage changes lifetime but introduces a shared object; allocation requires an explicit free/ownership contract.

### F03

Intel settles the operations, encodings and affected flags, including original 8086 PUSH SP. An ABI settles agreements between compiled callers and callees: registers to preserve, argument locations, result locations and alignment. Hennessy/Patterson places calls among broader control-flow designs but does not define our exact decoder subset or guest transaction policy. HH's observed RIP/RSP discussion connects a running program to those architectural locations; its Windows/x64 example does not settle System V behavior. One compiled trace proves a concrete observed result under its configuration and leaves other compiler choices, timing and unsupported instructions unresolved.
