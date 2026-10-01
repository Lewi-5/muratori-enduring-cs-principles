import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 15 validation","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-15/instructor/validation.md","filePath":"materials/week-15/instructor/validation.md"}');
const _sfc_main = { name: "materials/week-15/instructor/validation.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-15-validation" tabindex="-1">Week 15 validation <a class="header-anchor" href="#week-15-validation" aria-label="Permalink to &quot;Week 15 validation&quot;">​</a></h1><p>Validated 2026-10-01 in x86-64 Linux/WSL, GCC 11.4.0, Clang 14.0.0 and Python 3.12.1. Workload estimates remain unpiloted.</p><p>make verify completed successfully in all six reference modes: GCC/Clang debug O0, optimized O2 and O1 with AddressSanitizer/UndefinedBehaviorSanitizer. Each mode passed 4313 independently expected input cases across all three stable sorts: exhaustive ternary arrays through length seven, four shapes at every length through 257 and full-width boundary keys. The qsort oracle compares keys then original-position tags; checking every resulting record establishes the exercised permutation and stable ordering. Additional checks cover the 65536-item boundary, exact insertion/merge/radix counters, invalid arguments with unchanged outputs, odd/even and maximum-valued summaries.</p><p>All six modes passed twelve benchmark rows at count 64 and three trials, identical result checksums across algorithms, valid summaries and malformed-argument errors. No speed threshold is asserted. Three warm-ups, deterministic playground, 29 matching prompts/answers and both warning-clean untouched starter failures passed. The standalone beginner source and exact displayed output passed GCC/Clang O0/O2.</p><p>tools/sample.py recorded actual optimized GCC/Clang CSV rows for sizes 16,64,256,1024 with nine trials and one warm-up. environment.json preserves flags, target, kernel and source hashes. In this GCC sample, sorted inputs favor insertion at all recorded sizes; reversed inputs favor insertion at 16 and merge at larger recorded sizes; random inputs move from insertion at 16 to merge at 64 and radix at 256/1024. These are median observations for this instrumented warmed experiment, not universal crossover points or an allocator/cache diagnosis. Fixed algorithm order remains an experimental limitation.</p><p>The reading checker passed 323 sections (211 checked against local PDFs), 173 Muratori entries and 220 cross-reference rows across 52 weeks. The integrated source check passed 14 lessons and 435 prompt/answer pairs. Primary URLs and assigned episode markers were checked against official sources. The production/visual evidence is added after the final site build; no learner pilot is claimed.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-15/instructor/validation.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const validation = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  validation as default
};
