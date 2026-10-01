import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Warm-up and check-yourself answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-15/instructor/warmups.md","filePath":"materials/week-15/instructor/warmups.md"}');
const _sfc_main = { name: "materials/week-15/instructor/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="warm-up-and-check-yourself-answers" tabindex="-1">Warm-up and check-yourself answers <a class="header-anchor" href="#warm-up-and-check-yourself-answers" aria-label="Permalink to &quot;Warm-up and check-yourself answers&quot;">​</a></h1><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>Use one swap only when a.key&gt;b.key; equality makes no swap, preserving tag order. Reject NULL before touching either item. Aliased a==b is harmless, but caller objects must be accessible. Tags do not participate in the key comparison.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>Check pass&lt;4 before shifting by pass*8. Mask the unsigned shifted value with 255. Numeric digits are independent of object endian order. Invalid pass or NULL fails without writing; a shift by 32 would be undefined for this 32-bit value.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>Check out and count&lt;=SIZE_MAX/sizeof(Item) before multiplying. Zero is a valid zero-byte count. Preserve the old output on failure. A successful arithmetic check only establishes representable bytes; it does not establish allocation success or available physical memory.</p><p>Check yourself: Ordered output can lose records; compare records against the oracle. Equal keys must retain original input order. Four uint32_t passes sort all digits; signed and floating keys need different explicitly specified mappings. Representable workspace bytes do not guarantee allocation success.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-15/instructor/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
