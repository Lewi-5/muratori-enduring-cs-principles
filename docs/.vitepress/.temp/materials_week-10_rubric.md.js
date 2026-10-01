import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 10 rubric","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-10/rubric.md","filePath":"materials/week-10/rubric.md"}');
const _sfc_main = { name: "materials/week-10/rubric.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-10-rubric" tabindex="-1">Week 10 rubric <a class="header-anchor" href="#week-10-rubric" aria-label="Permalink to &quot;Week 10 rubric&quot;">​</a></h1><p>One graded assignment combines E01–E05 and R01–R05. Correctness and explanation determine the grade; there is no speed threshold. Beginner warm-ups and further-reading questions are ungraded; practice and stretch provide preparation.</p><table tabindex="0"><thead><tr><th>Criterion</th><th>Points</th><th>Evidence</th></tr></thead><tbody><tr><td>Stack word order and bounds</td><td>20</td><td>Little-endian bytes, reserve/read order, odd SP, exhaustion, untouched outputs</td></tr><tr><td>Decode and transfer rules</td><td>20</td><td>Signed rel16/rel8, correct next IP, CALL/RET targets, original PUSH SP and POP SP</td></tr><tr><td>State integrity</td><td>20</td><td>Flag preservation, INC/DEC CF, memory effects, atomic step and run failures</td></tr><tr><td>Program validation and CLI</td><td>15</td><td>Boundary map, instruction budget, empty input, golden trace, empty stdout on model failure</td></tr><tr><td>Written reasoning and evidence</td><td>25</td><td>Hand stack diagrams, lifetime repair, tool limitations, tests and actual workload</td></tr></tbody></table><p>Award alternative implementations full credit when they meet the public contract and explain their tradeoffs. A host pointer cast used as a guest address, undefined signed overflow, or an escaped tentative memory write requires correction before a correctness pass. An ordinary tested timing difference is neither required nor a failure. A trace without a prediction earns less explanatory credit than a complete hand derivation.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-10/rubric.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const rubric = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  rubric as default
};
