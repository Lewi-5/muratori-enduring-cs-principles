import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 10 implementation specification","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-10/PLAN.md","filePath":"materials/week-10/PLAN.md"}');
const _sfc_main = { name: "materials/week-10/PLAN.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-10-implementation-specification" tabindex="-1">Week 10 implementation specification <a class="header-anchor" href="#week-10-implementation-specification" aria-label="Permalink to &quot;Week 10 implementation specification&quot;">​</a></h1><p>Parent: <a href="/materials/PLAN.html">course plan</a>. Status: implemented; see <a href="/materials/week-10/instructor/validation.html">validation</a>. Workload estimates are unpiloted.</p><p>Implement register PUSH/POP, near relative CALL and plain RET in C, using explicit guest bytes rather than host recursion or a second hidden return stack. Include INC/DEC, NOP and bounded branches to support original real-program fixtures. Preserve completed decoder/register/ALU prerequisites in an independent snapshot while Weeks 9–11 are authored concurrently.</p><p>Require defined unsigned guest-width arithmetic; signed displacement decoding without implementation-defined narrowing; original 8086 PUSH SP behavior; POP SP final-write behavior; odd addresses; boundary validation; budgeted execution; atomic step and whole-program rollback including data memory. Explain every course restriction separately from the historical ISA and C language rules.</p><p>Deliver five core exercises, six practice prompts, two stretch prompts, five notebook prompts, three typed beginner warm-ups and three reading questions, with matching complete written solutions and working C reference code. Include a beginner page, checked output snippet, seven-text reading cross-reference, deterministic nested trace, invalid transfer/stack tests, independent arithmetic expectations, six GCC/Clang configurations and meaningful starter failures. No universal timing or speed requirement applies.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-10/PLAN.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const PLAN = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  PLAN as default
};
