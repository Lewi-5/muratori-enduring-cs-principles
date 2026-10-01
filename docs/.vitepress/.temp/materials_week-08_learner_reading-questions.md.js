import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Reading Questions","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-08/learner/reading-questions.md","filePath":"materials/week-08/learner/reading-questions.md"}');
const _sfc_main = { name: "materials/week-08/learner/reading-questions.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="reading-questions" tabindex="-1">Reading Questions <a class="header-anchor" href="#reading-questions" aria-label="Permalink to &quot;Reading Questions&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>Use Beej’s signed/unsigned section and CS:APP’s two’s-complement addition section to explain the same 80 hex result as both 128 and -128. Which flag identifies each kind of arithmetic range failure?</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>Compare Scott’s comparator/zero explanation and the CS:APP condition-code sections with CMP in this simulator. What is shared, and what must not be imported from Scott’s teaching machine?</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>Read Dive Into Systems arithmetic and Hennessy/Patterson’s operations section after the two CE episodes. Explain why a correct ISA state trace cannot establish a modern CPU’s timing or internal execution strategy.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-08/learner/reading-questions.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingQuestions = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingQuestions as default
};
