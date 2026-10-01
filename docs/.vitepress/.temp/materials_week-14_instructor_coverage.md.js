import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 14 coverage","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-14/instructor/coverage.md","filePath":"materials/week-14/instructor/coverage.md"}');
const _sfc_main = { name: "materials/week-14/instructor/coverage.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-14-coverage" tabindex="-1">Week 14 coverage <a class="header-anchor" href="#week-14-coverage" aria-label="Permalink to &quot;Week 14 coverage&quot;">​</a></h1><p>All 29 learner IDs have separate answers:10 E contract/reasoning entries, 6 P,2 optional S, 5 R, 3 W and 3 F. E01–E04 have complete typed C references; E05 includes a runnable bench/capture tool and report. Warm-ups have independent bounded exhaustive/boundary tests. tests/inventory.py checks ID equality, tests/contracts.c covers deterministic state/error cases, fixtures/playground.txt checks exact output, tests/check.py checks real output structure and checksums without time thresholds. Six compiler/mode gates and forced unsupported-counter gates where relevant distinguish correctness from performance. See validation.md for executed evidence and limits.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-14/instructor/coverage.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const coverage = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  coverage as default
};
