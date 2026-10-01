import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 15 rubric","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-15/rubric.md","filePath":"materials/week-15/rubric.md"}');
const _sfc_main = { name: "materials/week-15/rubric.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-15-rubric" tabindex="-1">Week 15 rubric <a class="header-anchor" href="#week-15-rubric" aria-label="Permalink to &quot;Week 15 rubric&quot;">​</a></h1><p>One graded submission includes E01–E05 and R01–R05. Warm-ups and reading questions prepare the learner; practice and stretch have complete answers. Other correct implementations and interpretations receive credit. No universal timing/diagnostic address is expected.</p><table tabindex="0"><thead><tr><th>Criterion</th><th>Points</th><th>Evidence</th></tr></thead><tbody><tr><td>C contract correctness</td><td>35</td><td>All specified outputs, errors, bounds and ownership/order rules</td></tr><tr><td>Mechanism reasoning</td><td>25</td><td>Invariants, worked predictions and language/platform distinctions</td></tr><tr><td>Independent validation</td><td>20</td><td>Complete record/ownership checks and actual compiler modes</td></tr><tr><td>Evidence notebook</td><td>15</td><td>Actual outputs, commands, workload and justified limits</td></tr><tr><td>Reproducibility</td><td>5</td><td>Toolchain, input and policy recorded</td></tr></tbody></table><p>Fabricated observations or a missing ownership/permutation argument require correction. Optional work may deepen the explanation but cannot replace the core contracts.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-15/rubric.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const rubric = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  rubric as default
};
