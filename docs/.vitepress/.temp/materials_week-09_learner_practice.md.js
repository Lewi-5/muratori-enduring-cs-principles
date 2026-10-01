import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Practice and optional stretch","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-09/learner/practice.md","filePath":"materials/week-09/learner/practice.md"}');
const _sfc_main = { name: "materials/week-09/learner/practice.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="practice-and-optional-stretch" tabindex="-1">Practice and optional stretch <a class="header-anchor" href="#practice-and-optional-stretch" aria-label="Permalink to &quot;Practice and optional stretch&quot;">​</a></h1><h3 id="p01" tabindex="-1">P01 <a class="header-anchor" href="#p01" aria-label="Permalink to &quot;P01 {#p01}&quot;">​</a></h3><p>Calculate [BP+DI-16] for BP=0010 and DI=FFFF. Explain the flat model&#39;s BP segment limitation.</p><h3 id="p02" tabindex="-1">P02 <a class="header-anchor" href="#p02" aria-label="Permalink to &quot;P02 {#p02}&quot;">​</a></h3><p>After CMP AL,1 with AL=80, derive result, CF,ZF,SF,OF and all four unsigned/signed strict and inclusive comparisons. Do not use SF alone.</p><h3 id="p03" tabindex="-1">P03 <a class="header-anchor" href="#p03" aria-label="Permalink to &quot;P03 {#p03}&quot;">​</a></h3><p>For code B8 34 12 EB FC, list boundaries, calculate the jump target and distinguish numeric range from a legal target.</p><h3 id="p04" tabindex="-1">P04 <a class="header-anchor" href="#p04" aria-label="Permalink to &quot;P04 {#p04}&quot;">​</a></h3><p>Draw byte data after storing ABCD at FFFF, then changing byte 0000 to 12. Predict a word read at FFFF and explain why host uint16_t pointer casts are unsuitable.</p><h3 id="p05" tabindex="-1">P05 <a class="header-anchor" href="#p05" aria-label="Permalink to &quot;P05 {#p05}&quot;">​</a></h3><p>MOV BL,[BX] reads data 20 from guest address 0100 while BX=0100. Predict final BX and show why address calculation must precede the destination write.</p><h3 id="p06" tabindex="-1">P06 <a class="header-anchor" href="#p06" aria-label="Permalink to &quot;P06 {#p06}&quot;">​</a></h3><p>A run stores 7 at 0100 then jumps into an immediate. Predict committed memory, returned step count and stdout. Explain how to design a regression that catches partial writes.</p><h3 id="s01" tabindex="-1">S01 <a class="header-anchor" href="#s01" aria-label="Permalink to &quot;S01 {#s01}&quot;">​</a></h3><p>Run a repeated CMP AL,1 with AL=80 using JB versus JL. Predict which version halts and which exhausts a budget of six. Implement the two original byte streams in C, check status/steps and rollback, and explain why this does not mean signed loops generally never terminate.</p><h3 id="s02" tabindex="-1">S02 <a class="header-anchor" href="#s02" aria-label="Permalink to &quot;S02 {#s02}&quot;">​</a></h3><p>Design a reusable immutable-code boundary map to avoid reparsing on every step. Specify ownership, invalidation, error offsets, preparation versus execution and an equivalence test plan. A written complete design is enough; no speedup claim is required.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-09/learner/practice.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const practice = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  practice as default
};
