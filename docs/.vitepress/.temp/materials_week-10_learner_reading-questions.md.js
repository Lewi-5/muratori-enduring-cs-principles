import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Read, then reason","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-10/learner/reading-questions.md","filePath":"materials/week-10/learner/reading-questions.md"}');
const _sfc_main = { name: "materials/week-10/learner/reading-questions.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="read-then-reason" tabindex="-1">Read, then reason <a class="header-anchor" href="#read-then-reason" aria-label="Permalink to &quot;Read, then reason&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>Connect CE The Stack to CS:APP §§3.7.1–3.7.2 and Dive Into Systems §7.5. Which mechanism is shared, and which word sizes/conventions must you avoid importing into the 8086 model?</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>Use Beej §13 and CS 341 §3.8.3 to distinguish scope from lifetime. Why does observing stale memory fail to make returning &amp;local valid? Give a correct caller-owned-output alternative.</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>Relate CE Other Common Instructions and HH Chat 013 to Intel&#39;s instruction reference and Hennessy/Patterson Appendix A.6. What does an instruction manual settle, what does an ABI settle, and what does an observed compiled trace leave uncertain?</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-10/learner/reading-questions.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingQuestions = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingQuestions as default
};
