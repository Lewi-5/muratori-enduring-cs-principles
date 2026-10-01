import { ssrRenderAttrs, ssrRenderStyle } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Rubric — one notebook, 100 points","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-02/rubric.md","filePath":"materials/week-02/rubric.md"}');
const _sfc_main = { name: "materials/week-02/rubric.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="rubric-—-one-notebook-100-points" tabindex="-1">Rubric — one notebook, 100 points <a class="header-anchor" href="#rubric-—-one-notebook-100-points" aria-label="Permalink to &quot;Rubric — one notebook, 100 points&quot;">​</a></h1><table tabindex="0"><thead><tr><th>Area</th><th style="${ssrRenderStyle({ "text-align": "right" })}">Points</th><th>Full-credit evidence</th></tr></thead><tbody><tr><td>Functional correctness</td><td style="${ssrRenderStyle({ "text-align": "right" })}">40</td><td>Four per exercise: correct normal result, boundary/error handling, defined C operations and strict builds. E03/E04/E07 reject atomically without partial outputs.</td></tr><tr><td>Layout/storage reasoning</td><td style="${ssrRenderStyle({ "text-align": "right" })}">25</td><td>Five each: alignment/padding; arrays/pointers; duration/lifetime; linkage/translation; two qualified implementation observations. Worked examples matter more than terminology alone.</td></tr><tr><td>Prediction/observation method</td><td style="${ssrRenderStyle({ "text-align": "right" })}">20</td><td>Five each: recorded environment/flags; prior diagrams; honest reconciliation of predictions; correct C/ABI/compiler/toolchain/observation labels.</td></tr><tr><td>Clarity</td><td style="${ssrRenderStyle({ "text-align": "right" })}">15</td><td>Five each: readable source/diagnostics; explicit contracts and navigable IDs; coherent notebook understandable without videos.</td></tr></tbody></table><p>Award roughly half of an item for mostly correct work with a missing explanation or recoverable edge error; zero for missing work or explanations dependent on undefined behavior. Explain deductions concretely. Public tests are evidence, not proof of every precondition. Alternative correct implementations and observations receive credit. ABI-specific sample numbers are not portable grading constants, and a correct skipped target observation is not an error on another platform.</p><p>Practice is ungraded and stretch optional; both have complete answers. No points depend on speed or fitting an unvalidated time estimate. Learners should record overruns so the workload can be adjusted after a real pilot. Submission includes source, build recipe, test output and notebook.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-02/rubric.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const rubric = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  rubric as default
};
