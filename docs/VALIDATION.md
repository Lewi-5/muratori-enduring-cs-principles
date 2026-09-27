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
