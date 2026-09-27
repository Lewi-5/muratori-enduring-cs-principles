# Enduring CS Principles

A C-based course about the mechanisms beneath everyday programming: object representation, numerical limits, compilation, data movement, and machine instructions. Based on standup pod #71 and Muratori's “extend downward” argument, with the qualifications preserved in the source analysis.

See [analysis.md](analysis.md) for the extracted thesis (Muratori's "extend downward" argument) and a seed outline for a C-based course teaching enduring CS principles.

The [52-week syllabus](PLAN.md) is the course specification; [solPlan.md](solPlan.md) supplies the qualified teaching rationale. **Weeks 1–6 are implemented. Weeks 7–52 remain planned.**

## Read the course companion

The VitePress companion explains why each lesson matters, develops the concepts from first principles, and guides every existing exercise, practice problem, stretch task, and report requirement. It is written for programmers who are new to systems concepts. The assignments retain their existing C requirements; the original 8–10-hour estimates assume experienced C programmers, and background preparation may take longer.

With Node.js 20 or later, run from this repository root:

```sh
npm ci
npm run docs:dev
```

Open the local address printed in the terminal. On Windows, use `npm.cmd` if PowerShell blocks `npm.ps1`. For a production check and preview:

```sh
npm run docs:build
npm run docs:preview
```

The site runs locally; C exercises run in your Linux/WSL terminal. It does not execute code in the browser. Start with [course orientation](docs/content/guide/start.md), [setup](docs/content/guide/setup.md), and [how to complete a week](docs/content/guide/how-to-study.md).

## The completed sequence

| Week | What you investigate | Companion | Local package |
| --- | --- | --- | --- |
| 1 | Source semantics, values, arrays, resources, linking, and evidence | [C as an inspectable starting point](docs/content/weeks/week-01.md) | [Week 01](week-01/README.md) |
| 2 | Object layout, alignment, lifetime, and references | [Objects, bytes, and storage](docs/content/weeks/week-02.md) | [Week 02](week-02/README.md) |
| 3 | Floating-point representation, error, and geometry | [Numbers in a box](docs/content/weeks/week-03.md) | [Week 03](week-03/README.md) |
| 4 | Reproducible generation, parsing, loading, and accumulation | [Deterministic data](docs/content/weeks/week-04.md) | [Week 04](week-04/README.md) |
| 5 | Correctness, timing protocols, and uncertainty | [Scalar geolab baseline](docs/content/weeks/week-05.md) | [Week 05](week-05/README.md) |
| 6 | Instruction fields, bounded decoding, and independent checks | [Bytes to instructions](docs/content/weeks/week-06.md) | [Week 06](week-06/README.md) |

Each week includes learner work, separate full instructor solutions, public tests, a rubric, and a notebook or report. Predict before running. Explain the mechanism behind the output and what the evidence cannot establish. Correctness and explanation take precedence over speed.

## Work on the exercises

Use x86-64 Linux or Ubuntu under WSL, with GCC, Clang, make, Python 3, and binutils. From the repository root:

```sh
cd week-01
make
make test
```

The supplied learner scaffolds compile but intentionally fail behavioral tests until implemented. Follow the named functions and contracts in the package. Run the other compiler and required modes as each week directs. Python handles test orchestration; the learner programs are C.

Readings and videos appear beside the questions they help answer, with a consolidated site index. Computer, Enhance! is a required subscription resource; this repository contains original exercises rather than copies of its paid assignments. Handmade Hero segments and primary technical references retain their assigned portions. Beej's Guide to C provides a gentler companion for unfamiliar language details.

## Maintain and verify the site

Authored chapters live in `docs/content`; the build imports contracts and source from the week packages. `tools/docs/catalogue.json` holds shared readings and exercise guidance. `tools/docs/files.json` explicitly lists the course files exposed in the site. Generated pages are not committed or edited by hand.

`npm run docs:check` verifies all 183 prompt/answer pairs, imported sources, and internal targets. `npm run docs:build` also checks rendered links and search exclusions. See [authoring guidance](docs/content/guide/authoring.md), [writing principles](WRITINGFORBEGINNERS.md), and [validation results](docs/VALIDATION.md).
