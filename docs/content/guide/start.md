---
prev: false
next:
  text: Local setup
  link: /guide/setup
---

# Why this course

You can use a library successfully without knowing what work it asks the machine to perform. That is often a useful abstraction. When a result is wrong, storage grows unexpectedly, or a program becomes slow, you need a way to investigate below that abstraction.

This course uses small C programs to make that investigation manageable. C is the working language because its objects, compilation model, and operating-system interfaces give us relatively short paths to lower mechanisms. It is not a promise that each C line maps to one instruction, or that other languages cannot expose the same mechanisms.

## Who this companion is for

You can already follow variables, loops, and functions, but systems concepts may be new. The chapters explain terms before relying on them and connect each tool to a concrete question. The exercises still require substantial C work. Use the linked C readings when syntax or standard-library behavior is unfamiliar.

The original syllabus assumes experienced C programmers working roughly 8–10 hours per week. These expanded explanations make the entry path gentler, but do not establish a new completion-time guarantee. Take extra preparation time when needed; keep a record of where it was useful.

## The completed weeks

| Week | Question | What you build |
| --- | --- | --- |
| [1](/weeks/week-01) | What does source promise, and what did this run show? | A C field notebook with fifteen small programs |
| [2](/weeks/week-02) | Where do objects fit, and how long do they exist? | An object-layout inspector notebook |
| [3](/weeks/week-03) | What changes when numbers have finite representations? | A checked geospatial math library |
| [4](/weeks/week-04) | How do bytes and results become reproducible? | A generator, parser, loader, and reference processor |
| [5](/weeks/week-05) | What makes a timing comparison credible? | The first validated scalar `geolab` checkpoint |
| [6](/weeks/week-06) | How do bytes describe instructions? | An 8086 subset decoder |
| [7](/weeks/week-07) | How do instructions describe memory, and how can another program decode them? | Memory operands and a shared decoder library |
| [8](/weeks/week-08) | How do instructions change registers and arithmetic flags? | A checked register simulator and state traces |
| [9](/weeks/week-09) | How does a program repeat instructions and access addressed data? | Conditional branches and bounded guest memory |
| [10](/weeks/week-10) | How does a routine save its continuation and return? | A checked stack, nested calls and lifetime explanations |
| [11](/weeks/week-11) | How do compiled C functions agree on arguments and saved values? | A scalar ABI planner and actual x64 compiler comparisons |
| [12](/weeks/week-12) | What does a complete simulator and its evidence establish? | Project 2: specified state simulation, golden traces and an x64 comparison |
| [13](/weeks/week-13) | Which clock and units make a timing comparison meaningful? | A checked timing harness, raw samples and an optional counter experiment |
| [14](/weeks/week-14) | How do nested scopes share time, and how does observing change execution? | A bounded recursive profiler and paired overhead measurements |
| [15](/weeks/week-15) | How does algorithmic work relate to realized time? | Three stable integer-key sorts and a repeated comparison |
| [16](/weeks/week-16) | Who owns an object and when is access valid? | Lifetime repairs, checked allocation ownership and diagnostics |

`geolab` is a command-line geospatial engine that develops across the larger course. The [52-week syllabus](/materials/PLAN) describes the later allocators, memory experiments, SIMD, concurrency, indexes, and capstone. Weeks 17–52 are planned; this companion does not imply that their exercise packages exist. Weeks 15 and 16 supply the support needed to work independently.

## What counts as understanding

You should be able to explain a causal chain. For example: the layout model rounds a member's starting offset to its alignment; that introduces a gap; the inspector reports the predicted offset under the target ABI. That is stronger than remembering that a particular struct occupied 24 bytes on one machine.

Keep three things visible:

- **Prediction:** what you expect before observing the result, and why.
- **Observation:** what the program or tool actually reports, with the relevant environment.
- **Explanation and limit:** the mechanism consistent with the result and what the evidence does not establish.

The [qualified course rationale](/materials/solPlan) and [transcript analysis](/materials/analysis) preserve the origin and qualifications of the “extend downward” argument. They are background, while the weekly contracts define the work you submit.

## Where the work lives

Each chapter displays the current repository's exercise contracts and source files. You edit the files in the corresponding local learner directory. The site does not run C programs, store your notebook, or submit work.

Solutions have their own [clearly marked pages](/solutions/). Try the exercise and use its hints before opening the answer. A reference implementation is useful for comparison, but copying it cannot supply your original prediction or explain your own observation.

Continue with [local setup](/guide/setup), then [how to complete a week](/guide/how-to-study).
