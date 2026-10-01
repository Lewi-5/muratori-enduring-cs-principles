import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Warmups — spoilers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-08/instructor/warmups.md","filePath":"materials/week-08/instructor/warmups.md"}');
const _sfc_main = { name: "materials/week-08/instructor/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="warmups-—-spoilers" tabindex="-1">Warmups — spoilers <a class="header-anchor" href="#warmups-—-spoilers" aria-label="Permalink to &quot;Warmups — spoilers&quot;">​</a></h1><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>A numeric AND with 255 preserves bits zero through seven and clears higher bits. It does not inspect the object’s storage bytes. Every word has exactly the remainder modulo 256 in those low bits, so the exhaustive test checks the whole domain. A byte pointer into a uint16_t would instead depend on which byte the host stores first.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>Clear the old high bits by word &amp; 255, shift the new uint8_t value left by eight after widening, then OR the pieces. The result from 1234 and FF is FF34. Widening makes the arithmetic bounds explicit; the shift count is below the chosen width. Tests vary every new high and preserved low byte. Assignment of high alone would erase the low byte.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>The largest sum is 510, which fits the unsigned calculation type on the course target. A carry occurs when the full sum exceeds 255. Thus 127+1 has no carry and 255+1 has carry. Signed overflow asks whether the sum of signed interpretations lies outside -128..127, so it is a different predicate; the first case overflows signed range and the second does not. The warm-up function is intentionally limited to carry. All 65,536 byte pairs are checked.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-08/instructor/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
