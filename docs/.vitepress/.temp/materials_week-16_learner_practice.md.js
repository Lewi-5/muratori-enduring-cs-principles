import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Practice and stretch","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-16/learner/practice.md","filePath":"materials/week-16/learner/practice.md"}');
const _sfc_main = { name: "materials/week-16/learner/practice.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="practice-and-stretch" tabindex="-1">Practice and stretch <a class="header-anchor" href="#practice-and-stretch" aria-label="Permalink to &quot;Practice and stretch&quot;">​</a></h1><h3 id="p01" tabindex="-1">P01 <a class="header-anchor" href="#p01" aria-label="Permalink to &quot;P01 {#p01}&quot;">​</a></h3><p>A pointer to an allocated object is stored in an automatic local. What ends when the function returns, and what remains allocated?</p><h3 id="p02" tabindex="-1">P02 <a class="header-anchor" href="#p02" aria-label="Permalink to &quot;P02 {#p02}&quot;">​</a></h3><p>An Owned struct is assigned to another Owned struct, then both are released. Explain the fault and propose an explicit transfer protocol.</p><h3 id="p03" tabindex="-1">P03 <a class="header-anchor" href="#p03" aria-label="Permalink to &quot;P03 {#p03}&quot;">​</a></h3><p>Why can assigning realloc’s return directly into the only owning pointer leak memory on failure? Explain our allocate-copy-commit repair.</p><h3 id="p04" tabindex="-1">P04 <a class="header-anchor" href="#p04" aria-label="Permalink to &quot;P04 {#p04}&quot;">​</a></h3><p>The owner’s data pointer equals NULL but count equals four. Is that an empty valid owner? Explain what metadata validation can and cannot establish.</p><h3 id="p05" tabindex="-1">P05 <a class="header-anchor" href="#p05" aria-label="Permalink to &quot;P05 {#p05}&quot;">​</a></h3><p>After successful resize, an old alias has the same numeric address as the new buffer. May the program keep using the old alias?</p><h3 id="p06" tabindex="-1">P06 <a class="header-anchor" href="#p06" aria-label="Permalink to &quot;P06 {#p06}&quot;">​</a></h3><p>A static counter works in sequential tests. Explain why that says nothing about concurrent safety or independent caller state.</p><h3 id="s01" tabindex="-1">S01 <a class="header-anchor" href="#s01" aria-label="Permalink to &quot;S01 {#s01}&quot;">​</a></h3><p>Design an explicit Owned move operation with complete preconditions, success/error behavior, tests and ownership diagram. Keep allocator provenance requirements explicit.</p><h3 id="s02" tabindex="-1">S02 <a class="header-anchor" href="#s02" aria-label="Permalink to &quot;S02 {#s02}&quot;">​</a></h3><p>Design a scoped borrow interface that detects stale handles after resize/release without dereferencing freed storage. Give a complete exemplar and limits.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-16/learner/practice.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const practice = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  practice as default
};
