import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Reading Answers — spoilers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-08/instructor/reading-answers.md","filePath":"materials/week-08/instructor/reading-answers.md"}');
const _sfc_main = { name: "materials/week-08/instructor/reading-answers.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="reading-answers-—-spoilers" tabindex="-1">Reading Answers — spoilers <a class="header-anchor" href="#reading-answers-—-spoilers" aria-label="Permalink to &quot;Reading Answers — spoilers&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>The bits 10000000 encode unsigned 128 and signed -128 depending on interpretation; the register bank stores the pattern, not a C signedness tag. CF reports an unsigned carry or subtraction borrow. OF reports an out-of-range mathematical result under signed interpretation. The C host must not invoke signed overflow to model either result. Beej separates representation and type; CS:APP derives the signed range and wrap behavior. The ISA specifies which flags these instructions actually set.</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>The shared idea is arithmetic leaving small state bits that later control a decision. CMP here computes subtraction flags and discards the result. ZF alone reports equality; unsigned and signed ordering need CF or SF/OF respectively. Scott builds a different teaching CPU, so its clear-flags instruction and register organization are conceptual preparation, not an 8086 opcode or reset-state specification. CS:APP’s modern condition-code discussion is closer, but Intel remains the authority for our selected instructions and flag effects.</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>An ISA describes architectural outcomes: destination patterns, flags and next instruction position. Different implementations can realize those outcomes with different pipelines, internal operations, dependencies and timings. Our simulator has no caches, scheduling, branch predictor or timing model. The architecture text places operations in a design context; Dive Into Systems introduces machine instructions through compiler examples. Neither turns our step count into a cycle count, and observed host runtime is the cost of the C simulator, not elapsed guest hardware cycles.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-08/instructor/reading-answers.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingAnswers = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingAnswers as default
};
