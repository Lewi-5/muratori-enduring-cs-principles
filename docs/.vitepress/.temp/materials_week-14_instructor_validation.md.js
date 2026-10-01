import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 14 validation — 2026-10-01","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-14/instructor/validation.md","filePath":"materials/week-14/instructor/validation.md"}');
const _sfc_main = { name: "materials/week-14/instructor/validation.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-14-validation-—-2026-10-01" tabindex="-1">Week 14 validation — 2026-10-01 <a class="header-anchor" href="#week-14-validation-—-2026-10-01" aria-label="Permalink to &quot;Week 14 validation — 2026-10-01&quot;">​</a></h1><p>Executed in x86-64 WSL Linux with GCC 11.4.0, Clang 14.0.0 and Python 3.10.12.</p><ul><li><code>make verify</code> passed GCC and Clang debug (-O0), optimized (-O2) and ASan/UBSan (-O1): six complete reference configurations.</li><li>Each ran deterministic contracts, 10,000 calculated cases, warm-up boundary/bounded exhaustive gates, 29 prompt/answer inventory, exact playground and real measurement structure/checksum checks. <code>/dev/full</code> output failure is reported.</li><li>Four actual source assembly/object-disassembly manifests were generated. Inspection results are observations, not instruction-count performance claims.</li><li>Both learner packages compile warning clean and intentionally fail contract, warm-up and playground correctness checks.</li><li>The standalone beginner snippet matched exact source and output with GCC/Clang at O0/O2.</li><li>Four debug/optimized timing captures preserve raw CSV and source/build/host manifests in instructor/evidence. Four additional outer-only captures compare one hit with 33 nested hits on unchanged work. Negative differences are retained; zero-baseline ratios report NA.</li></ul><p>Corrections during validation: The pinned timing header excludes Week 13 warm-up declarations to avoid conflicting independent Week 14 warm-up names.</p><p>Course citation, snippet and documentation checks are recorded in docs/VALIDATION.md. No learner pilot, universal duration/frequency/slowdown, cross-core synchronization, shared-instance thread safety or interactive browser review is claimed. Compiler/runtime checks cover executed domains and do not prove all-input correctness.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-14/instructor/validation.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const validation = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  validation as default
};
