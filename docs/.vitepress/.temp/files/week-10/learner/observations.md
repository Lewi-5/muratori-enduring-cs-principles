# Notebook

### R01

Before running the fixture, draw all live stack words at the deepest call and annotate each with its role, source IP and byte order. Then record the actual ten transition lines and explain any discrepancy.

### R02

Record a deliberately invalid return and a budgeted infinite loop. For each give initial state, status, offset, tentative steps and caller CPU/data-state effect. Explain why a nonzero tentative count does not imply committed effects.

### R03

Draw a timeline for a C automatic local, a static local and an allocated object across two calls. Repair the invalid-return example from E05. Explain why a compiler may eliminate the automatic local or keep it in a register.

### R04

Record compiler versions, commands and actual outcomes for debug, optimized and sanitizer checks. Explain what each establishes and at least one remaining uncertainty. Do not invent timings or assembly output.

### R05

Report actual time, difficult concepts and untested boundaries. Explain what Week 11 must add to compare this near-call model with System V x64 functions: argument passing, register ownership, alignment and code generation.
