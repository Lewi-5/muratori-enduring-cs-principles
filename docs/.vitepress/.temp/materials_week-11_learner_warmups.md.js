import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Ungraded warm-ups","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-11/learner/warmups.md","filePath":"materials/week-11/learner/warmups.md"}');
const _sfc_main = { name: "materials/week-11/learner/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="ungraded-warm-ups" tabindex="-1">Ungraded warm-ups <a class="header-anchor" href="#ungraded-warm-ups" aria-label="Permalink to &quot;Ungraded warm-ups&quot;">​</a></h1><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>Implement w01 mapping zero-based scalar integer argument position to GP index for the first six or callee-entry stack offset thereafter. Accept 0..31 and preserve output on invalid arguments. Explain why the return word occupies offset zero.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>Implement w02 for the register-code table in lab.h: preserved RBX/RBP/R12–R15, special restored RSP, and caller-clobbered others. Explain why a function using a preserved register may still modify it internally.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>Implement w03 rounding 0..32 eight-byte stack words up to sixteen-byte caller reservation. Explain why one spilled word needs sixteen reserved bytes under the initially aligned caller assumption, and why this arithmetic alone is not a general ABI argument classifier.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-11/learner/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
