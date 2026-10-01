import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Warm-up answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-07/instructor/warmups.md","filePath":"materials/week-07/instructor/warmups.md"}');
const _sfc_main = { name: "materials/week-07/instructor/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="warm-up-answers" tabindex="-1">Warm-up answers <a class="header-anchor" href="#warm-up-answers" aria-label="Permalink to &quot;Warm-up answers&quot;">​</a></h1><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>Check mode and rm first. Mode one always consumes one byte; mode two always consumes two. Mode zero consumes two only for rm six and otherwise consumes zero. w is absent because data width does not determine address width. The decoder describes an offset in the 8086 address space even for byte-sized data. w01.c implements the table; the warm-up harness covers all accepted pairs and invalid boundaries.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>Unsigned raw 0..127 already represents its signed value. Values 128..255 subtract 256, so 128 becomes -128 and 255 becomes -1. FE becomes -2. The two-byte direct address FE FF is instead unsigned 254+256×255=65534. The encoding field determines which interpretation to use. w02.c implements the conversion and all 256 values are checked.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>Reject offset above total, then compare length with total-offset. Only after that proof can offset+length be formed without exceeding total or overflowing size_t. Reject zero length to guarantee progress. The next instruction begins after the previous encoding, including displacement and immediate tails; a bad length can reinterpret a tail byte as a new opcode. w03.c commits once, and tests include exact end, one past end, SIZE_MAX and zero-length failures.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-07/instructor/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
