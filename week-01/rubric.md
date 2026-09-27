# Grading the C field notebook

| Criterion | Points | Full-credit evidence |
| --- | ---: | --- |
| Functional correctness | 40 | Fifteen exercises compile with strict GCC and Clang, specified outputs and function contracts hold, numeric/file failures are explicit, no invalid accesses or arithmetic. E01–E10: 2 each; E11–E15: 4 each. |
| C reasoning | 25 | Five points each for arrays/pointers, representations/layout, allocation/lifetime, translation/linking, and two qualified implementation observations. Work through examples rather than only naming vocabulary. |
| Experimental method | 20 | Five points each for environment/flags, validated repeated trials, correct median/variation, and interpretation with limitations. No required speedup. |
| Clarity | 15 | Five points each for readable source/diagnostics, predictions separated from observations/explanations, and navigable report with stable prompt IDs. |

Partial credit: award roughly half of a category for a mostly correct result with missing reasoning or one recoverable boundary error; zero for missing work or reasoning built on undefined behavior. Give concrete correction feedback. An instructor may accept another correct implementation, diagram or machine observation even when it differs from the exemplar. Machine-specific sample sizes and timings are never grading targets. Tests do not prove every contract and do not replace review.

Practice and stretch work have complete answer keys but carry no additional points or penalty for omitting optional work. A complete submission includes source, build recipe, test log and observations. Do not penalize a sound report because a supposedly faster build loses on the learner's machine.
