import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 16 validation","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-16/instructor/validation.md","filePath":"materials/week-16/instructor/validation.md"}');
const _sfc_main = { name: "materials/week-16/instructor/validation.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-16-validation" tabindex="-1">Week 16 validation <a class="header-anchor" href="#week-16-validation" aria-label="Permalink to &quot;Week 16 validation&quot;">​</a></h1><p>Validated 2026-10-01 in x86-64 Linux/WSL, GCC 11.4.0, Clang 14.0.0 and Python 3.12.1. Workload estimates remain unpiloted.</p><p>make verify completed successfully in all six reference modes: GCC/Clang debug O0, optimized O2 and O1 with AddressSanitizer/UndefinedBehaviorSanitizer. Each mode passed caller-owned value boundary checks, the first hundred static-counter calls, NULL no-effect behavior, deep-copy independence, failed allocation and failed grow rollback, overflow/invalid metadata rejection, equal-size no-allocation, successful grow/zero-tail/shrink/zero release, repeated empty cleanup and growing counts through 128. The tracking allocator checks live allocations and exact once-only release, ending with allocations equal releases and no live slots.</p><p>Three warm-ups, deterministic lifetime playground, 29 matching prompts/answers and both warning-clean untouched starter failures passed. The standalone beginner source and exact displayed successful-allocation output passed GCC/Clang O0/O2. Tests do not access or compare old pointers after successful replacement/release.</p><p>make diagnose separately passed two compiler expected failures for returned automatic-local addresses and four isolated ASan expected failures: heap-use-after-free and double-free under both compilers. Actual warning/error-category excerpts are in diagnostic-examples.md; full variable-address/frame reports regenerate in build/diagnostics. These intentionally invalid fixtures are never linked into normal lab binaries. Diagnostics establish exercised violations, not arbitrary-pointer validity or proof of every lifetime path.</p><p>The reading checker passed 323 sections (211 checked against local PDFs), 173 Muratori entries and 220 cross-reference rows across 52 weeks. The integrated source check passed 14 lessons and 435 prompt/answer pairs. Primary URLs and assigned episode markers were checked against official sources. The production/visual evidence is added after the final site build; no concurrency, allocator-internals implementation or learner pilot is claimed.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-16/instructor/validation.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const validation = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  validation as default
};
