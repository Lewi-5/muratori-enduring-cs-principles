import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Ungraded warm-ups","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-12/learner/warmups.md","filePath":"materials/week-12/learner/warmups.md"}');
const _sfc_main = { name: "materials/week-12/learner/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="ungraded-warm-ups" tabindex="-1">Ungraded warm-ups <a class="header-anchor" href="#ungraded-warm-ups" aria-label="Permalink to &quot;Ungraded warm-ups&quot;">​</a></h1><p>Typed stubs and contracts are in project.h; run make warmups.</p><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>Implement w01, a byte ADD result and carry. Predict 255+1 and 127+1; distinguish carry from signed overflow. Test every byte pair and unchanged outputs on invalid arguments.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>Implement w02, checked boundary membership for a 65536-byte map. Predict targets 1 and 3 in a map containing starts 0 and 3 and end 5. A numeric target is not automatically an instruction boundary.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>Implement w03, little-endian word encoding into two bytes. Predict 1234 and 80FF. Use numeric operations, then explain why this helper alone does not implement wrapping memory access.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-12/learner/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
