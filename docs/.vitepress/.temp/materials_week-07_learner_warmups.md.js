import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Beginner warm-ups","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-07/learner/warmups.md","filePath":"materials/week-07/learner/warmups.md"}');
const _sfc_main = { name: "materials/week-07/learner/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="beginner-warm-ups" tabindex="-1">Beginner warm-ups <a class="header-anchor" href="#beginner-warm-ups" aria-label="Permalink to &quot;Beginner warm-ups&quot;">​</a></h1><p>Ungraded typed stubs; attempt before comparing with solutions.</p><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>Implement address_bytes(mod,rm): modes 0–2 and rm 0–7 return the address-tail byte count; invalid arguments return 99. Explain why a byte data operation may need two address bytes.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>Implement signed_byte(raw) returning -128..127 using int32_t arithmetic and no signed narrowing cast. Explain how FE differs from the direct-address bytes FE FF.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>Implement next_offset(offset,length,total,out). Require nonzero length, a real output pointer and an extent inside total. Return 1 with offset+length or 0 preserving out. Explain why the next instruction depends on length and why checking offset+length first is risky.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-07/learner/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
