import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Guided reading answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-09/instructor/reading-answers.md","filePath":"materials/week-09/instructor/reading-answers.md"}');
const _sfc_main = { name: "materials/week-09/instructor/reading-answers.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="guided-reading-answers" tabindex="-1">Guided reading answers <a class="header-anchor" href="#guided-reading-answers" aria-label="Permalink to &quot;Guided reading answers&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>Scott&#39;s simple machine introduces selecting a next instruction from a comparison. CS:APP §3.6.3 gives actual x86 jump predicates: after CMP, signed less uses SF != OF, whereas unsigned less uses CF. For byte patterns 80 minus 01 hex, the stored result 7F looks positive even though signed -128 is less than 1. OF = 1 corrects that misleading sign in the signed predicate. Scott&#39;s teaching ISA and CS:APP&#39;s x64 encodings do not specify our precise 8086 byte subset or checked targets. Intel supplies shared predicate semantics; machine.h defines accepted forms and course restrictions.</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>Beej&#39;s array bounds and CS 341&#39;s pointer arithmetic apply to host C storage. Guest offset FFFF is 65535, within the 65536-byte data array, but a contiguous two-byte host operation starting there would need byte 65536 outside the object. This model maps the second guest byte to offset 0000 before a separate valid host array access. Guest wrap is numeric address arithmetic modulo 65536; host bounds concern actual accessible C elements. A valid guest address does not authorize dereferencing a numeric host pointer. Explicitly indexing the two bytes satisfies both rules.</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>Dive Into Systems §7.4.3 explains repeated comparisons and transfers as loops. Hennessy and Patterson Appendix A.6 compares control-flow choices in instruction sets. Neither dictates our separate code and data, full predecode, checked boundaries, halt at code length, finite budget or whole-run rollback; those are course policies in machine.h. In our fixture, JNE repeats while SUB CX,1 produces a nonzero value, then falls through when ZF is set. This architectural mechanism does not explain branch predictor behavior or require a particular host instruction sequence. A loop whose unchanged comparison stays true demonstrates budget failure, not a processor timing result.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-09/instructor/reading-answers.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingAnswers = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingAnswers as default
};
