import { ssrRenderAttrs, ssrRenderStyle } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Grading the C field notebook","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-01/rubric.md","filePath":"materials/week-01/rubric.md"}');
const _sfc_main = { name: "materials/week-01/rubric.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="grading-the-c-field-notebook" tabindex="-1">Grading the C field notebook <a class="header-anchor" href="#grading-the-c-field-notebook" aria-label="Permalink to &quot;Grading the C field notebook&quot;">​</a></h1><p>The beginner section&#39;s warm-ups (W01–W04) and the further-reading questions (F01–F06) are ungraded. They have worked answers in the instructor package and are not part of the 100 points.</p><table tabindex="0"><thead><tr><th>Criterion</th><th style="${ssrRenderStyle({ "text-align": "right" })}">Points</th><th>Full-credit evidence</th></tr></thead><tbody><tr><td>Functional correctness</td><td style="${ssrRenderStyle({ "text-align": "right" })}">40</td><td>Fifteen exercises compile with strict GCC and Clang, specified outputs and function contracts hold, numeric/file failures are explicit, no invalid accesses or arithmetic. E01–E10: 2 each; E11–E15: 4 each.</td></tr><tr><td>C reasoning</td><td style="${ssrRenderStyle({ "text-align": "right" })}">25</td><td>Five points each for arrays/pointers, representations/layout, allocation/lifetime, translation/linking, and two qualified implementation observations. Work through examples rather than only naming vocabulary.</td></tr><tr><td>Experimental method</td><td style="${ssrRenderStyle({ "text-align": "right" })}">20</td><td>Five points each for environment/flags, validated repeated trials, correct median/variation, and interpretation with limitations. No required speedup.</td></tr><tr><td>Clarity</td><td style="${ssrRenderStyle({ "text-align": "right" })}">15</td><td>Five points each for readable source/diagnostics, predictions separated from observations/explanations, and navigable report with stable prompt IDs.</td></tr></tbody></table><p>Partial credit: award roughly half of a category for a mostly correct result with missing reasoning or one recoverable boundary error; zero for missing work or reasoning built on undefined behavior. Give concrete correction feedback. An instructor may accept another correct implementation, diagram or machine observation even when it differs from the exemplar. Machine-specific sample sizes and timings are never grading targets. Tests do not prove every contract and do not replace review.</p><p>Practice and stretch work have complete answer keys but carry no additional points or penalty for omitting optional work. A complete submission includes source, build recipe, test log and observations. Do not penalize a sound report because a supposedly faster build loses on the learner&#39;s machine.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-01/rubric.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const rubric = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  rubric as default
};
