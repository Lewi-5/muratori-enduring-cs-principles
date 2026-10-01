import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Reading answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-16/instructor/reading-answers.md","filePath":"materials/week-16/instructor/reading-answers.md"}');
const _sfc_main = { name: "materials/week-16/instructor/reading-answers.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="reading-answers" tabindex="-1">Reading answers <a class="header-anchor" href="#reading-answers" aria-label="Permalink to &quot;Reading answers&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>Architectural PUSH/CALL/RET manipulate machine storage and saved continuations; C specifies object lifetimes independently. An automatic local may occupy registers or vanish under optimization, while static and allocated storage have different duration rules. Read CS:APP frames for a compiler example and CS 341’s returned-local bug for the language error; do not infer legality from old stack contents.</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>HH demonstrates a game/platform allocation policy and later general allocator reasoning. C malloc provides uninitialized suitably aligned allocated storage for an appropriate request, with NULL failure; it does not promise the platform’s pages always start zero. Our resize zeros newly added ints explicitly. free releases an owned allocation; caller metadata reset is our API policy, not something free performs automatically.</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>Failed nonzero replacement leaves the old live allocation and its borrows valid under our contract. Successful replacement frees it and commits a new object, invalidating old borrows. Use Beej’s allocation pages and C11 §7.22.3 for language/library rules, CS 341 and CS:APP for bugs. The companion accounts do not define our callback allocator, empty-owner invariant or generation-handle extension.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-16/instructor/reading-answers.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingAnswers = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingAnswers as default
};
