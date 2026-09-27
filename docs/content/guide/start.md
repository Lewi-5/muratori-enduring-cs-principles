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

## The six completed weeks

| Week | Question | What you build |
| --- | --- | --- |
| [1](/weeks/week-01) | What does source promise, and what did this run show? | A C field notebook with fifteen small programs |
| [2](/weeks/week-02) | Where do objects fit, and how long do they exist? | An object-layout inspector notebook |
| [3](/weeks/week-03) | What changes when numbers have finite representations? | A checked geospatial math library |
| [4](/weeks/week-04) | How do bytes and results become reproducible? | A generator, parser, loader, and reference processor |
| [5](/weeks/week-05) | What makes a timing comparison credible? | The first validated scalar `geolab` checkpoint |
| [6](/weeks/week-06) | How do bytes describe instructions? | An 8086 subset decoder |

`geolab` is a command-line geospatial engine that develops across the larger course. The [52-week syllabus](/materials/PLAN) describes the later allocators, memory experiments, SIMD, concurrency, indexes, and capstone. Weeks 7–52 are planned; this companion does not imply that their exercise packages exist.

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
