import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Reading questions","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-16/learner/reading-questions.md","filePath":"materials/week-16/learner/reading-questions.md"}');
const _sfc_main = { name: "materials/week-16/learner/reading-questions.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="reading-questions" tabindex="-1">Reading questions <a class="header-anchor" href="#reading-questions" aria-label="Permalink to &quot;Reading questions&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>Explain how CE’s architectural stack relates to C storage duration and why neither gives a universal physical location for each C local.</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>Compare HH’s platform memory policy with C malloc/free contracts. Explain one video-specific assumption that must not become a portable C claim.</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>Use the lifetime and allocator readings to explain failed versus successful resizing and stale aliases. Identify what the companion sources do not specify about our API.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-16/learner/reading-questions.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingQuestions = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingQuestions as default
};
