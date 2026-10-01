# Maintaining the companion

The readable chapters live in `docs/content`. The exercise contracts and C files remain authoritative in their existing week directories. The site adapter reads them at build time; edit the originals when a contract or source changes.

## Content inputs

`tools/docs/catalogue.json` is the shared catalogue of six weeks, resources, source associations, and exercise-specific guidance. Its reading entries feed both the weekly blocks and consolidated index. Each exercise has a purpose, prerequisites, prediction, work sequence, hint, and interpretation of evidence. Practice, stretch, and report IDs have their own guidance.

`tools/docs/files.json` is an explicit allowlist of files exposed by the site. Do not replace it with an unrestricted repository glob. It deliberately excludes private environment files, unrelated PDFs, and build products. Add a source or fixture only when the course needs it.

## Chapter directives

The adapter expands exercise directives by stable ID, and inserts reading tables, practice, report prompts, and shared contract introductions. Imported relative links are resolved against their original file before becoming site routes. Source listings are read from the actual file; downloads preserve the original bytes.

The adapter also generates reference views of allowlisted Markdown, source-file pages, directory indexes, and six full solution pages. Imported materials are excluded from search to avoid duplicates and spoilers. Authored lesson prose remains searchable.

Generated pages and downloadable copies live in `docs/.generated`. Do not edit them. The VitePress cache and production output are also generated. Development watches authoring and package sources; restart the development command after changing the catalogue or allowlist.

## Beginner sections and further reading

Each week can have two more authored pages: `docs/content/beginners/week-NN.md` and `docs/content/further-reading/week-NN.md`. They are linked from the lesson and appear in the sidebar automatically once the file exists. Neither changes the lesson or its graded exercises.

**Beginner page.** Write it to [Writing for beginners](/materials/WRITINGFORBEGINNERS): every concept section opens with a situation the reader is in, states the problem before the mechanism, defines each term before leaning on it, and says what a tool or result cannot establish. The check requires these level-2 headings, in this order of intent: *Purpose and prerequisites*, *Vocabulary*, *Concepts*, *Walk-through*, *Warm-ups*, *Check yourself*, *Ready for the lesson*, *Read alongside*.

- Every program the page shows is a file in `docs/examples/week-NN/NAME.c`. Mark its code block with `<!-- snippet:NAME -->` and its output block with `<!-- output:NAME -->` on the line before each fence. `tools/docs/verify-examples.py` compiles each snippet with GCC and Clang at `-O0` and `-O2` using the course flags, fails if the shown code differs from the file, and fails if the shown output differs from what it prints. Never paste output you have not produced this way.
- Warm-ups are package prompts with IDs `W01…` in `week-NN/learner/warmups.md`, answered in `week-NN/instructor/warmups.md`, with typed stubs in `learner/src/wNN.c`, solutions in `instructor/src/wNN.c`, and tests run by `make warmups`. Insert each one on the page with `<!-- warmup:W01 -->`; the generator adds the contract, the starter listing and the answer link.

**Further-reading page.** Open with guided prose that introduces each of the seven companion texts for this week: why it matters, what to look for, where it gets hard, and in what order to read. Say plainly where no text covers a topic. Then place `<!-- crossref -->`, which renders the week's cross-reference from `tools/docs/readings.json`, and `<!-- reading-questions -->`, which renders the week's `F01…` prompts from `week-NN/learner/reading-questions.md` (answered in `week-NN/instructor/reading-answers.md`). Add the new prompt and answer files to the week's `promptFiles` and `answerFiles` in the catalogue, and to the allowlist.

**Reading data.** `tools/docs/readings.json` is the single source of truth for companion citations. It has four parts: `texts` (the seven books and guides), `sections` (one entry per cited section, with a gentle/bridge/core/deep/reference level), `muratori` (every Computer, Enhance! and Handmade Hero item in the course) and `weeks` (for each week, cross-reference rows from a Muratori item to sections, plus extra sections without a video counterpart). To cite a new book section, add its id (`csapp:2.4.2`, `cs341:3.3.2`, `hp:J.3`, `bhdik:the-clock`) with only a level, then run `python3 tools/docs/check_readings.py --fill` in WSL. The script reads the title and pages from the book itself and verifies them. Web sections (`bgc:`, `bgclr:`, `dis:`) need a title and URL, which `audit-links.py` checks online. `check_readings.py` also fails if a built week cites a Computer, Enhance! or Handmade Hero link that has no cross-reference row. Weeks not yet built are marked `draft` and are revised when the week is written.

**Rights.** The book PDFs are never committed or allowlisted. Paraphrase; quote at most one short, attributed line per page; do not copy figures or code. *Dive Into Systems* is CC BY-NC-ND: link to it, never adapt its text.

## Adding or revising material

Follow [Writing for beginners](/materials/WRITINGFORBEGINNERS). Preserve every existing fact, caution, link, and instruction when expanding a section. A readable explanation must not quietly change an assignment's domain or accepted result.

Run `npm run docs:check` for coverage, source, and internal-target checks, then `npm run docs:build`. Run `node tools/docs/check-built.mjs` after building to check actual HTML fragments and search exclusion. Review the site in a browser, including narrow screens and long code listings. The independent package inventory scripts remain part of verification.

If you change executable code, run the affected package's full verification. For prose examples, compile or derive the actual example and record how it was checked. Keep historical measurements labelled with their original dates; never relabel them as a fresh run.

`python3 tools/docs/verify-course.py` runs the documented compiler checks in a temporary Linux copy. `python3 tools/docs/verify-examples.py` compiles the exact layout, binary64, and CSV examples against unchanged reference code. `python3 tools/docs/audit-links.py` checks public reading URLs, Beej fragments, and assigned public index markers; it needs network access. Their JSON reports record what was actually checked.

The [source audit](/reference/source-audit) records external-link and citation checks. A successful HTTP response is not proof that a video timestamp or a technical claim is correct; inspect the relevant page or manual section too.
