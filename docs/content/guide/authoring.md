# Maintaining the companion

The readable chapters live in `docs/content`. The exercise contracts and C files remain authoritative in their existing week directories. The site adapter reads them at build time; edit the originals when a contract or source changes.

## Content inputs

`tools/docs/catalogue.json` is the shared catalogue of six weeks, resources, source associations, and exercise-specific guidance. Its reading entries feed both the weekly blocks and consolidated index. Each exercise has a purpose, prerequisites, prediction, work sequence, hint, and interpretation of evidence. Practice, stretch, and report IDs have their own guidance.

`tools/docs/files.json` is an explicit allowlist of files exposed by the site. Do not replace it with an unrestricted repository glob. It deliberately excludes private environment files, unrelated PDFs, and build products. Add a source or fixture only when the course needs it.

## Chapter directives

The adapter expands exercise directives by stable ID, and inserts reading tables, practice, report prompts, and shared contract introductions. Imported relative links are resolved against their original file before becoming site routes. Source listings are read from the actual file; downloads preserve the original bytes.

The adapter also generates reference views of allowlisted Markdown, source-file pages, directory indexes, and six full solution pages. Imported materials are excluded from search to avoid duplicates and spoilers. Authored lesson prose remains searchable.

Generated pages and downloadable copies live in `docs/.generated`. Do not edit them. The VitePress cache and production output are also generated. Development watches authoring and package sources; restart the development command after changing the catalogue or allowlist.

## Adding or revising material

Follow [Writing for beginners](/materials/WRITINGFORBEGINNERS). Preserve every existing fact, caution, link, and instruction when expanding a section. A readable explanation must not quietly change an assignment's domain or accepted result.

Run `npm run docs:check` for coverage, source, and internal-target checks, then `npm run docs:build`. Run `node tools/docs/check-built.mjs` after building to check actual HTML fragments and search exclusion. Review the site in a browser, including narrow screens and long code listings. The independent package inventory scripts remain part of verification.

If you change executable code, run the affected package's full verification. For prose examples, compile or derive the actual example and record how it was checked. Keep historical measurements labelled with their original dates; never relabel them as a fresh run.

`python3 tools/docs/verify-course.py` runs the documented compiler checks in a temporary Linux copy. `python3 tools/docs/verify-examples.py` compiles the exact layout, binary64, and CSV examples against unchanged reference code. `python3 tools/docs/audit-links.py` checks public reading URLs, Beej fragments, and assigned public index markers; it needs network access. Their JSON reports record what was actually checked.

The [source audit](/reference/source-audit) records external-link and citation checks. A successful HTTP response is not proof that a video timestamp or a technical claim is correct; inspect the relevant page or manual section too.
