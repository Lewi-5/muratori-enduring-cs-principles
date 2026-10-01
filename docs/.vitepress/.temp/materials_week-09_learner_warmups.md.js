import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Ungraded warm-ups","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-09/learner/warmups.md","filePath":"materials/week-09/learner/warmups.md"}');
const _sfc_main = { name: "materials/week-09/learner/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="ungraded-warm-ups" tabindex="-1">Ungraded warm-ups <a class="header-anchor" href="#ungraded-warm-ups" aria-label="Permalink to &quot;Ungraded warm-ups&quot;">​</a></h1><p>Compile with make warmups. Headers and typed stubs specify valid inputs and unchanged failure outputs.</p><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>Implement w01: interpret an unsigned byte pattern as signed int32_t without an out-of-range signed-byte cast. Predict F8 and 80.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>Implement w02: add displacement to following IP modulo 65536. Predict following=0011, displacement=-8 and following=0000, displacement=-1.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>Implement w03: read a little-endian word from two accessible bytes using shifts and OR. Predict bytes 34,12 and FF,80. Keep output unchanged for bad arguments.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-09/learner/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
