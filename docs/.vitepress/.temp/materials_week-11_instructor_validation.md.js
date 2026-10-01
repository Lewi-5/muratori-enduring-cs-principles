import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 11 validation","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-11/instructor/validation.md","filePath":"materials/week-11/instructor/validation.md"}');
const _sfc_main = { name: "materials/week-11/instructor/validation.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-11-validation" tabindex="-1">Week 11 validation <a class="header-anchor" href="#week-11-validation" aria-label="Permalink to &quot;Week 11 validation&quot;">​</a></h1><p>Validated on 2026-10-01 on x86-64 Ubuntu/WSL with GCC 11.4.0, Clang 14.0.0, Python 3.12.1 and GNU make/binutils. Workload estimates remain unpiloted; sample compiler artifacts are observations, not universal instruction listings.</p><p><code>make verify</code> passed all six reference configurations: each compiler at debug O0, optimized O2 and O1 with AddressSanitizer/UndefinedBehaviorSanitizer. All passed scalar argument planning, independent register exhaustion and interleaved spills, alignment/padding, invalid-kind and unchanged-output contracts; real geolab wrapper edge cases and query ordering; unsigned fold wrap; callback argument/count, preservation and modular arithmetic; three warm-ups; and exact playground output. The 16-line optional probe passed seven-argument, wrap and repeated-value checks in all six configurations. The sanitizers instrument its C harness, not handwritten assembly.</p><p>Both untouched learner packages compile warning-clean and fail the correctness gates meaningfully. All 29 learner prompts have separate matching answers. The standalone beginner snippet passed exact-output comparisons under GCC and Clang at O0/O2. Four actual inspection sets were regenerated with recorded flags, target and source hashes and saved in sample-assembly. DWARF 4 avoids unsupported debug-form warnings from the installed older binutils; ordinary inspection artifacts contain no sanitizer instrumentation.</p><p>The reading checker passed all 323 registered sections, including 211 local-PDF checks, 173 Muratori items and 220 cross-reference rows across 52 weeks. Documentation source/target checks passed for 11 lessons and 348 prompt/answer pairs. The production build passed with 1037 rendered pages and 72497 internal links/fragments/assets checked; solution routes were absent from search. The existing bundle-size warning remains. Assembly source extensions are rendered as plain text to avoid unsupported syntax-highlighter warnings.</p><p>The lesson and beginner page were visually inspected in the in-app browser. A temporary 390-pixel viewport override showed readable wrapped text; the document&#39;s client and scroll widths both measured 375 pixels after the scrollbar, with no horizontal page overflow. The override was reset and temporary preview closed. Five pinned geolab files were separately checked byte-for-byte against their completed Week 5 originals. No learner pilot or modern timing/prediction measurement is claimed.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-11/instructor/validation.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const validation = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  validation as default
};
