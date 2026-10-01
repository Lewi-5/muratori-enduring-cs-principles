import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 9 rubric","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-09/rubric.md","filePath":"materials/week-09/rubric.md"}');
const _sfc_main = { name: "materials/week-09/rubric.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-9-rubric" tabindex="-1">Week 9 rubric <a class="header-anchor" href="#week-9-rubric" aria-label="Permalink to &quot;Week 9 rubric&quot;">​</a></h1><p>One graded assignment, 100 points. E01 addresses 15; E02 decoding and sixteen predicates 20; E03 registers/memory/flags and atomic steps 25; E04 boundary/budget/whole-run transaction 20; E05 independent predicted trace and R01–R05 evidence 20. Warm-ups and practice are ungraded; stretch earns feedback, not a requirement.</p><p>Full credit explains the mechanism and portability boundary, validates failures without leaked state, and uses independent expected values. Incorrect signed predicates, a host out-of-bounds word access or partial mutation on a failed run blocks correctness credit for the affected criterion until fixed. A compiler-clean build alone is insufficient. Equivalent correct implementations earn credit; no speedup threshold or required host instruction sequence is imposed. Reports retain a mistaken prediction and explain the correction instead of rewriting history. Actual workload may differ from unpiloted estimates.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-09/rubric.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const rubric = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  rubric as default
};
