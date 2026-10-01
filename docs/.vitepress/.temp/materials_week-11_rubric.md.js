import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 11 rubric","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-11/rubric.md","filePath":"materials/week-11/rubric.md"}');
const _sfc_main = { name: "materials/week-11/rubric.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-11-rubric" tabindex="-1">Week 11 rubric <a class="header-anchor" href="#week-11-rubric" aria-label="Permalink to &quot;Week 11 rubric&quot;">​</a></h1><p>One graded submission includes E01–E05 and R01–R05; warm-ups/reading questions are ungraded preparation. Six practice prompts and optional stretches have full answers. Other correct implementations and compiler listings receive full credit when contracts and explanation hold. No speed threshold applies.</p><table tabindex="0"><thead><tr><th>Criterion</th><th>Points</th><th>Evidence</th></tr></thead><tbody><tr><td>Restricted scalar planner</td><td>20</td><td>Independent pools, source-order spills, entry offsets, alignment, unchanged error output</td></tr><tr><td>C behavior</td><td>20</td><td>Geolab validation/order, unsigned fold, callback exactly once and preserved pre-call values</td></tr><tr><td>ABI interpretation</td><td>25</td><td>Argument/result locations, preserved registers, stack before/after prologue, pointer output</td></tr><tr><td>Actual artifact comparison</td><td>20</td><td>Both compilers, O0/O2, manifests, relocations, optimized-local explanation</td></tr><tr><td>Limits and report</td><td>15</td><td>ISA/ABI/compiler/prediction separated, complete notebook, actual commands/workload</td></tr></tbody></table><p>A fabricated exact assembly listing, unsupported ABI-generalization or inferred cycle count requires correction. Fewer instructions alone is not proof of faster execution. The optional probe must use defined full-width unsigned behavior, restore RSP and avoid modifying preserved registers. Omitting the optional handwritten probe does not prevent a complete C-only core submission.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-11/rubric.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const rubric = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  rubric as default
};
