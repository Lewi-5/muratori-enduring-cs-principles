# Companion validation — 2026-09-27

This record covers the new local VitePress companion. Existing C implementations, contracts, fixtures, rubrics, and historical reports were not rewritten. Verification used isolated Linux copies for builds, generated datasets, and examples. The networking repository was read as a reference and left untouched.

## Site and inventory

- VitePress is pinned to 1.6.4 with `package-lock.json`. A clean `npm.cmd ci --ignore-scripts` completed with Node 24.19.0 and npm 11.17.0 on Windows. The production build runs the installed bundler successfully.
- `npm run docs:check` maps all 183 original prompt IDs to lesson explanations and corresponding answer anchors: 43, 33, 27, 27, 26, and 27 for Weeks 1–6. All six original `tests/inventory.py` scripts also passed in the actual checkout.
- The explicit download allowlist contains 490 course files. The generator checks their existence, preserves original download bytes, rebases imported Markdown links, and removes retired generated files. Missing prompt IDs, guidance, source files, or answers fail validation.
- `npm run docs:build` builds 579 HTML pages, including six authored chapters, six solution pages, and source/reference views. The rendered checker validates 24,596 internal links, anchors, and assets, including old transcript line references.
- The built local-search index contains no solution, imported-material, or source-page routes. Authored lessons and shared guides are searchable. Solutions have no previous/next lesson controls.
- Development uses `http://localhost:5176/`; production preview uses `http://localhost:4176/`. Both commands were started and their pages inspected. Neither command publishes the course.
- An authored homepage edit refreshed automatically in the browser; the temporary test wording was restored. The watcher uses absolute paths on Windows and ignores generated output, avoiding self-triggered rebuilds.

The pinned dependency tree reports three npm audit findings (two moderate, one high). This pass retains the specifically requested VitePress version; both servers bind to local loopback. VitePress also reports large chunks for some full source/solution pages. The build succeeds; long source listings are initially collapsed. Dependency upgrades and public deployment were outside this pass.

## C execution and exact examples

The environment was x86-64 Ubuntu under WSL2, Linux 6.18.33.2, glibc 2.35, GCC 11.4.0, Clang 14.0.0, GNU Make 4.3, Python 3.10.12, and binutils 2.38. These observations do not establish behavior on other targets.

`tools/docs/course-validation.json` records 29 command checks in a temporary copy. For every week, reference tests passed with GCC debug and Clang optimized builds. Learner starter builds succeeded; their unfinished behavioral tests failed as expected. Week 5's oracle expectations were generated in the temporary copy before testing. Initial inventory failures in Weeks 3–4 came from missing background documents in that copy; the copy was completed and those checks rerun successfully, as recorded in the report.

The Week 1 E06 example printed `index=16 pointer=16`. The Week 6 binary containing `89 d9 83 c6 fe` decoded to `mov cx, bx` and `add si, -2`; GNU `objdump` independently agreed in meaning, printing the second immediate as `0xfffe`.

`tools/docs/example-validation.json` records eight additional GCC/Clang checks of the exact chapter inputs against unchanged reference functions:

- Week 2: offsets 0, 8, and 16; size 24; alignment 8; map `A.......BBBBBBBBCCCC....` for the stated synthetic specifications.
- Week 3: binary64 `0.75` has sign 0, stored exponent 1022, and fraction `0x8000000000000` on the gated target.
- Week 4: `7,-0.000005,0.000010` has 20 visible characters, plus LF; its C buffer needs 22 bytes including NUL.

Week 5's five-sample median/mean example is labelled illustrative arithmetic, not measured course performance. Historical timing tables and environment records keep their original provenance. This pass did not rerun full timing campaigns or claim new performance results. Commands requiring completed learner implementations are labelled accordingly; operating-system package installation instructions were reviewed, not used to change the machine.

## External references

`tools/docs/link-audit.json` records 51 distinct public URLs returning HTTP 200, verified Beej chapter headings and the assigned section fragment, and all timestamp boundaries in the 12 assigned public Handmade Hero index entries. The shared catalogue supplies both weekly reading blocks and the consolidated index. Required viewing, optional extensions, consultation references, and the subscription requirement are distinguished.

This verifies public locators and index markers, not a fresh viewing of every video. Subscription-only video contents and historically qualified duration estimates were not invented or relabelled as newly verified. Original primary-reference clauses and cautions remain in the package material. Beej supplies introductory explanation; it does not replace the specification.

## Browser review

All six chapters and six solution pages were opened in the Codex browser at desktop width (1280 px) and mobile width (390 px). No page-level horizontal overflow was observed. The long decoder source panel expanded correctly and scrolled inside its code block at mobile width. A hint expanded correctly. The mobile sidebar navigated between weeks. Search for `alignment` returned lesson sections and navigated to the selected anchor; no solution results appeared. The built-index check establishes exclusion across the index, beyond this sample query. Browser error logs were empty during the search check.

The lesson sequence runs from Week 1 through Week 6, stopping there. Later weeks are represented by the existing syllabus. Solution pages display spoiler notices, answer IDs, reference code, exemplar reports, and links to dated validation records.

## Editorial review against WRITINGFORBEGINNERS.md

| Principle | Review evidence |
| --- | --- |
| 1. Situation first | Each chapter opens with a concrete surprise; concept subsections begin with a task or observation. |
| 2. Problem before mechanism | Padding follows a layout question; statuses follow ambiguous failure; parsing follows a reproducibility problem. |
| 3. Define terms | Added explicit explanations of objects, pointer syntax, ABI, binary64, NaN, basis, comparator, ISA, register, and immediate. Exercise prerequisites name the concepts to revisit. |
| 4. Plain paragraphs | Authored prose develops one idea at a time; exact original contracts remain intact rather than being compressed or silently simplified. |
| 5. Bounded analogies | Checklist, ruler, seating-chart, form, and wording analogies identify their limits. |
| 6. Real checked artifacts | Compiled examples, decoder bytes, exact CSV length, and platform-qualified observations are recorded above. |
| 7. Separate look-alikes | Tables and prose distinguish value/display/representation, scope/linkage/lifetime, error measures, clock boundaries, and decoding/execution/reassembly. |
| 8. Limits of evidence | Tools, tests, checksums, measurements, and independent references each have explicit limits. |
| 9. Connect earlier ideas | Each week names earlier contracts and explains how its results prepare the next week. |
| 10. Name simplifications | The spherical Earth model, synthetic layout model, binary64 gate, scalar source, and restricted 8086 subset are explicit. |
| 11. Preserve facts | Prompts, rubrics, original reading tables, caution text, and reference reports are imported or linked from their authoritative files; all inventory checks pass. |
| 12. Section shape | Motivation, progression, preparation, concepts, resources, worked examples, guided work, and interpretation appear in every chapter. |
| 13. Mechanism diagrams | Small text diagrams show translation stages, object spans, parsing stages, and instruction fields. |
| 14. Precise gentle companion | Beej chapter and section URLs are verified and listed consistently beside primary sources. |
| 15. Honest paraphrase | New explanations use original wording; no paid course transcript or assignment is reproduced. |

This is an editorial and technical review, not a learner pilot. Original workload estimates remain explicitly unpiloted estimates for experienced C programmers. Preparation for readers new to systems may require additional time.

## Beginner section and further-reading pilot — 2026-09-27

Week 3 received the first beginner page (`docs/content/beginners/week-03.md`) and further-reading page (`docs/content/further-reading/week-03.md`), plus the shared infrastructure for later weeks. The Week 3 lesson and its graded exercises are unchanged apart from two links.

- **Reading data.** `tools/docs/readings.json` lists seven companion texts, 314 cited sections, 173 Computer, Enhance! and Handmade Hero items, and cross-reference rows for all 52 weeks (weeks 1–6 complete, week 7 planned, weeks 8–52 a draft map). `python3 tools/docs/check_readings.py` in WSL checked all 207 citations of the four local PDFs (CS:APP 3rd global edition, the CS 341 Coursebook, Hennessy & Patterson 6th edition, *But How Do It Know?*) against each book's own contents and page text. It also confirmed that every CE and HH reading of weeks 1–6 has a cross-reference row. A deliberately wrong PDF page, a wrong printed label and a removed row each made it fail.
- **Generator.** `prepare.mjs` now recognizes `W` and `F` prompt IDs and expands the `<!-- warmup:Wnn -->`, `<!-- crossref -->` and `<!-- reading-questions -->` directives. It generates `/reference/reading-map` and links the beginner and further-reading pages from each lesson's reading block. `check.mjs` requires the beginner page's eight fixed sections and places W and F anchors on their own pages.
- **Checks run.** `node tools/docs/check.mjs`: 6 lessons, 193 prompt/answer pairs (183 earlier plus W01–W04 and F01–F06), 609 pages. `npm run docs:build`: 610 rendered pages and 29,558 internal links, fragments and assets resolved; solution routes absent from the search index. `python3 tools/docs/verify-examples.py`: the six beginner snippets match their shown code and printed output under GCC 11.4 and Clang 14 at `-O0` and `-O2`, alongside the earlier chapter examples. `python tools/docs/audit-links.py`: 226 public URLs reachable, and all 61 fragments found.
- **Package.** Week 3 `make verify` passed in all six reference configurations with the warm-ups included. Details, the learner-negative check and a 16-mutant check of the warm-up tests are in `week-03/instructor/validation.md`.

Browser review (2026-09-27, `npm run docs:dev`): the Week 3 beginner and further-reading pages render with every required section, no directive text leaks into the page, and there is no page-level horizontal scroll at 375 px (the wide tables scroll within themselves). The reading map shows all 52 weeks. Two fixes came out of the review: cross-reference headings no longer contain links, which had given their permalinks a raw-Markdown label, and page numbers no longer break across lines. The added learner time (about 2–4 hours) is unpiloted.

## Week 1 beginner section and further reading — 2026-09-28

Week 1 received a beginner page and a further-reading page built to the Week 3 pattern; the lesson and its 43 graded prompts are unchanged apart from two links. Results:

- `node tools/docs/check.mjs`: 6 lessons, 203 prompt/answer pairs, 633 pages.
- `npm run docs:build`: 634 rendered pages, with 32,051 internal links, fragments and assets resolved.
- `python3 tools/docs/verify-examples.py`: the seven Week 1 and six Week 3 beginner snippets match their shown code and output under GCC and Clang at `-O0` and `-O2`.
- `python3 tools/docs/check_readings.py`: 323 sections, 211 of them checked against the local PDFs.
- `python tools/docs/audit-links.py`: all 231 public URLs reachable, and all 66 fragments found.
- Week 1 `make verify` passed with the warm-ups; details are in `week-01/instructor/validation.md`.

The built Week 1 pages were checked for their required sections and W and F anchors. An interactive browser pass was not possible in this session.

## Week 7 package and companion — 2026-09-30

Added the memory-operand decoder lesson, its beginner section, guided further reading and separate solutions. Navigation now covers seven implemented weeks, with Week 6 linking to Week 7. The public API, typed learner scaffolds, independent shared client, warm-ups and complete answer keys are included in the source catalogue.

- Week 7 `make verify` passed all six GCC/Clang reference configurations plus both learner builds and their expected correctness failures. Each reference configuration checked 13,892 independently encoded cases and the library/CLI contracts.
- The beginner snippet matched checked-in source and real output under both compilers at `-O0` and `-O2` through `tools/docs/verify-examples.py`.
- The reading checker passed 323 section records (211 checked against local PDFs) and verified Week 7's complete CE/HH cross-reference. Its additional snprintf reference uses the existing citation registry.
- The documentation check passed seven lessons, 232 prompt/answer pairs and 700 generated Markdown pages. The production build passed rendered link, fragment and asset checks and excluded solution routes from search.

Full execution details and test limits are in `week-07/instructor/validation.md`. This is implementation validation, not a learner pilot or an interactive browser review.

## Week 8 register simulator and companion — 2026-09-30

Added the register-state/flags lesson, beginner on-ramp, guided further reading and separate solutions. The simulator consumes a pinned copy of the completed Week 7 decoder and has independent learner and instructor simulation sources. Navigation now covers eight implemented weeks.

- Week 8 `make verify` passed six GCC/Clang reference configurations, each with 209328 mathematical arithmetic cases, 512 register-combination checks, independent state traces, golden programs and transactional/API failures. Both learner builds compile warning-clean and fail unfinished correctness gates.
- The standalone beginner snippet matched its shown source and output under both compilers at `-O0` and `-O2`.
- The reading checker passed the verified registry and both assigned CE cross-reference rows. The ADD/SUB/CMP episode URL was resolved from the official TOC rather than derived from its title.
- Documentation coverage passed eight lessons, 261 prompt/answer pairs and 771 generated Markdown pages. The production build checks rendered routes, fragments and assets and keeps solution routes out of search.

The optional C predicate example and objdump fixture comparison supplied additional evidence for their respective mechanisms. Full results and limits are in `week-08/instructor/validation.md`; workload estimates remain unpiloted.

## Week 9 branches and bounded guest memory — 2026-09-30

Week 9 follows Week 10's flat data array, separate immutable code, checked targets, finite budget and complete-state rollback. The implementation includes all sixteen short Jcc predicates, short/near JMP and actual memory effects for the revision-7 MOV/ADD/SUB/CMP subset, with separate typed learner sources and complete solutions.

- Six GCC/Clang reference configurations passed, each checking 1048576 predicates, 65536 signed/unsigned byte comparisons, 512 conditional-step outcomes, 524288 address/displacement cases, displacement decoding, wrapping words, aliasing, rollback and 255 independent complete loop traces.
- Three warm-ups, 29 matched prompt/answer IDs, negative learner gates and the optional signed/unsigned C loop passed. The checked beginner source and output matched both compilers at -O0 and -O2.
- Citation checks passed the existing 323-section registry and both complete Week 9 CE mappings. Source routes and the production build passed, including rendered links and solution-search exclusion.

See `week-09/instructor/validation.md` for commands, exact build results and limits. No Week 9 browser review or learner pilot is claimed.

## Weeks 10 and 11 integration — 2026-10-01

Week 10's checked stack, near calls/returns and lifetime explanations are complete. Week 11 adds a restricted System V AMD64 scalar ABI planner, checked geolab wrappers, unsigned ID fold and callback-preservation exercise, with actual GCC/Clang O0/O2 assembly and object-relocation samples. Each week has 29 matched learner/answer prompts, beginner preparation and a complete seven-text reading map.

Both packages passed their six GCC/Clang reference modes, warm-ups, deterministic output, meaningful untouched-starter failures and exact beginner snippet checks. Week 11's one optional 16-line assembly probe passed its independent harness; sanitizer instrumentation covers that C harness, not handwritten assembly. Five pinned geolab support files match Week 5 byte-for-byte.

The integrated source check passed 11 lessons and 348 prompt/answer pairs. The production build passed 1037 rendered pages and 72497 internal links/fragments/assets and excluded solution routes from search. Reading checks passed 323 sections (211 local-PDF checks), 173 Muratori items and 220 cross-reference rows. Lesson and beginner layouts were visually inspected, including narrow beginner pages with no horizontal page overflow. Detailed dated evidence and scope limits are in each package's instructor/validation.md. Workload estimates remain unpiloted.

## Week 12 Project 2 checkpoint — 2026-10-01

The checkpoint integrates the specified simulator subset through prepared immutable code, atomic execution/runs and complete CPU/changed-byte traces. It includes three independent golden byte streams, a checkpoint manifest, original beginner/further-reading chapters and a complete report with actual x64 compiler observations.

- Six GCC/Clang reference modes passed, each with 196608 mathematical byte arithmetic cases, 512 conditional transitions, memory/stack/target/rollback/capacity contracts, golden output and 128 independent complete combined-program traces.
- Three exhaustive warm-ups, all 29 prompt/answer pairs, negative learner gates, four real inspection sets and exact beginner source/output passed.
- Reading checks passed the verified registry and both complete Week 12 CE/HH mappings. The source check covered 12 lessons, 377 prompt/answer pairs and 1125 generated pages.
- The production build passed 1126 rendered pages and 83103 links/fragments/assets, excluding solutions from search. All 68 authored package files and the standalone snippet are registered.

Full commands, correction history and limits are in `week-12/instructor/validation.md`. No Week 12 browser review, timing result or learner pilot is claimed.

## Weeks 15 and 16 — 2026-10-01

Week 15 implements stable insertion, buffered merge and four-pass uint32_t radix sorting, explicit operation counts and repeated-sort summaries. Week 16 implements caller/static lifetime subjects, deep-copy ownership, failure-atomic replacement and once-only cleanup, with isolated intentionally invalid fixtures. Each has 29 matched prompts/answers, three typed/tested warm-ups, checked beginner output and a complete seven-text CE/HH reading cross-reference.

Both packages passed GCC/Clang debug, optimized and ASan/UBSan modes, deterministic output, warm-ups, negative starter gates and exact beginner snippets. Each sorting mode checks 4313 independent inputs across all three algorithms, stable record preservation, full-width/boundary cases and benchmark behavior without a speed threshold. Ownership checks include allocation-failure injection, unchanged original storage, deep-copy independence and complete allocation/release balance. Two expected compiler failures and four expected ASan child failures identify the supplied lifetime bugs. Actual optimized timing CSVs and diagnostic excerpts are labeled as observations.

Reading checks passed 323 sections, including 211 local-PDF checks, 173 Muratori entries and 220 cross-reference rows. The final fixed registered-source snapshot passed 16 lessons and 493 pairs, then produced 1374 rendered pages with 123311 internal links/fragments/assets checked and solution routes excluded from search. The snapshot under week-15/build/site-validation prevents concurrent course builds from rewriting its generated pages; unregistered weekly drafts are now omitted until their catalogue entry exists. The existing bundle-size warning remains.

Both lesson pages and beginner layouts were inspected in the in-app browser, with narrow beginner pages showing readable wrapping and no horizontal page overflow. Detailed commands, actual evidence and limits are in each instructor/validation.md. Workload estimates remain unpiloted; only validation-record prose changed after the production snapshot.
