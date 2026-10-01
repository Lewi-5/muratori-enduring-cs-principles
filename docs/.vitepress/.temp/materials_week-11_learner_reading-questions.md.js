import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Reading questions","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-11/learner/reading-questions.md","filePath":"materials/week-11/learner/reading-questions.md"}');
const _sfc_main = { name: "materials/week-11/learner/reading-questions.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="reading-questions" tabindex="-1">Reading questions <a class="header-anchor" href="#reading-questions" aria-label="Permalink to &quot;Reading questions&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>Compare CE From 8086 to x64 with CS:APP §§3.7.3–3.7.5 and the System V ABI. Which parts are instruction-family continuity, which are software conventions, and which are compiler observations?</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>Use HH Chat 020&#39;s assigned assembly comparison, Beej&#39;s multifile material and Dive Into Systems §2.9.7 to explain why an unresolved object CALL needs relocation information. State how an optimized local can lack a stack slot.</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>Relate CE Estimating Cycles to Hennessy/Patterson&#39;s pipeline and x86 discussions, and Intel&#39;s return prediction account. Distinguish architectural correctness, an explicit historical cost model and a modern predictor. What must be measured rather than inferred?</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-11/learner/reading-questions.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingQuestions = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingQuestions as default
};
