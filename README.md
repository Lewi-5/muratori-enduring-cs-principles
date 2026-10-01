# muratori-enduring-cs-principles
based on standup pod #71

See [analysis.md](analysis.md) for the extracted thesis (Muratori's "extend downward" argument) and a seed outline for a C-based course teaching enduring CS principles.

The [52-week syllabus](PLAN.md) is the course specification; [solPlan.md](solPlan.md) supplies the qualified teaching rationale. The implemented packages below contain learner exercises, separate instructor solutions, and Linux/WSL build and test instructions:

- [Week 01: C as an inspectable starting point](week-01/README.md)
- [Week 02: Objects, bytes, and storage](week-02/README.md)
- [Week 03: Numbers in a box](week-03/README.md)
- [Week 04: Deterministic data and a reference processor](week-04/README.md)
- [Week 05: A validated scalar geolab baseline](week-05/README.md) (Checkpoint 1)
- [Week 06: Bytes to instructions](week-06/README.md)
- [Week 07: Memory operands and a decoder API](week-07/README.md)
- [Week 08: Register state and arithmetic flags](week-08/README.md)
- [Week 09: Branches and bounded guest memory](week-09/README.md)
- [Week 10: Stack discipline, calls and lifetimes](week-10/README.md)
- [Week 11: From C to x64: calls and the ABI](week-11/README.md)
- [Week 12: Project 2: a specified simulator](week-12/README.md) (Checkpoint 2)
- [Week 13: Clocks and repeatable timing](week-13/README.md)
- [Week 14: Nested and recursive profiling](week-14/README.md)
- [Week 15: Sorting: complexity and measured cost](week-15/README.md)
- [Week 16: Object lifetimes and allocation ownership](week-16/README.md)

Weeks 17–52 remain planned. Weeks 15 and 16 are independently buildable with supplied timing and allocation support.

## Beginner sections and further reading

Every week is getting a **beginner section**, a slower way into the lesson with checked examples and ungraded warm-ups, written to [WRITINGFORBEGINNERS.md](WRITINGFORBEGINNERS.md), and a **further-reading** page that guides learners into seven companion texts and cross-references them with the week's Computer, Enhance! and Handmade Hero material. Week 3 is the first week with both. [tools/docs/readings.json](tools/docs/readings.json) holds the verified citations and a first-pass reading map for all 52 weeks.

## Reading the course as a site

The course is also a local VitePress site that reads the week packages directly:

```sh
npm ci
npm run docs:dev      # http://localhost:5176/
npm run docs:build    # checks, builds, and verifies rendered links
```

See the site's authoring guide (`docs/content/guide/authoring.md`) for how the pages, checks and reading data fit together.
