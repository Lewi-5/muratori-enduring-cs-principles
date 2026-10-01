---
prev:
  text: Week 7 · Memory operands and a decoder API
  link: /weeks/week-07
next: false
---

# Week 8 · Register state and arithmetic flags

You decode `mov al, 127`, then `add al, 1`. Their text describes operations, but it does not show the resulting AL or the evidence saved in flags. This week adds a C model of those architectural state changes. The [beginner section](/beginners/week-08) develops the shared register views and the two arithmetic range questions before the core work.

## A decoded operand finds a state value

You use byte register code four and expect a small SP. The decoder’s width-dependent table names AH instead: the high byte of AX. One word bank must support both views consistently. Masks and shifts read and replace the selected bits without depending on host byte order. Source values are captured before an overlapping destination changes.

## One operation saves several facts

You add one to 127 at byte width. The retained pattern is 80 hex. It fits the unsigned range but exceeds the signed positive limit, so carry and overflow differ. ADD and SUB compute both kinds of evidence along with parity, auxiliary carry, zero and sign. CMP performs the same subtraction flag calculation without writing its result. MOV preserves all flags.

The host C implementation widens operands and retains the guest width explicitly. It never needs an overflowing signed host operation. The [guided reading page](/further-reading/week-08) connects the C rules, instruction meanings and condition-code explanations.

## Decide the transaction boundary

You tentatively run a MOV, then encounter a valid memory operand the executor cannot support yet. Decoder acceptance and executor acceptance are different steps. The single-step API leaves state unchanged on rejection. The program API uses a local state and commits only if every instruction succeeds; its returned offset and step count describe the failed attempt.

The file cursor advances through immutable input using size_t. Guest IP advances at sixteen bits and can wrap. They are separate positions with separate jobs. Week 9 will introduce branch-controlled instruction fetching and memory; this week’s runner stays sequential.

## Read and watch

<!-- readings -->

## Tools and playground

```sh
cd week-08
make
make test
make warmups
```

After implementing the core modules, run `build/learner/gcc/debug/playground`. It isolates a signed-overflow addition, a comparison and a high-byte write that preserves flags. The [package guide](/materials/week-08/README) gives binary creation, CLI trace conventions, workload and exact execution scope. The [public header](/source/week-08/include/sim.h) supplies failure and ownership contracts; the [oracle](/source/week-08/tests/oracle.py) supplies an independent mathematical route to flag expectations.

## Guided exercises

<!-- contract-intro -->
<!-- exercise:E01 -->
<!-- exercise:E02 -->
<!-- exercise:E03 -->
<!-- exercise:E04 -->
<!-- exercise:E05 -->

## Practice and stretch

<!-- practice -->

## Notebook and handoff

Preserve your predictions before comparing with the traces. Explain which bits changed, which instruction rule caused them to change, and what the observation leaves unproved. Week 9 will turn flags into control-flow decisions and evaluate memory operand descriptions against bounded guest state.

<!-- report -->
