import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Reading answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-11/instructor/reading-answers.md","filePath":"materials/week-11/instructor/reading-answers.md"}');
const _sfc_main = { name: "materials/week-11/instructor/reading-answers.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="reading-answers" tabindex="-1">Reading answers <a class="header-anchor" href="#reading-answers" aria-label="Permalink to &quot;Reading answers&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>The x86 family retains related instruction/encoding ideas, but x64 has different widths/addressing and ordinary return words from the historical subset. The ABI assigns arguments, results, register ownership and stack agreement to separately compiled boundaries. CS:APP&#39;s examples show possible generated implementations of those requirements, including register or stack local storage. An observed RBP frame is not a universal C/ABI requirement; the actual signature and ABI rule must be distinguished from that compiler&#39;s choices.</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>Separate translation units can emit a symbolic call before its destination address is resolved. The object stores a relocation that lets the linker complete the reference; reading only placeholder bytes can misidentify the target. Compiler .s shows symbolic operands but not final runtime resolution. An optimized local calculation can be combined into LEA/ADD or other operations with no stack slot while retaining required C behavior. HH&#39;s particular compiler comparison is illustrative evidence, not a required mapping for our toolchain.</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>Architectural correctness describes resulting values/control flow; a historical cost model assigns costs under stated assumptions; a modern predictor speculates about likely flow before resolution. Pipelining, dependencies, resources and cache/call behavior prevent instruction count from being a cycle count. Intel&#39;s return account is processor-specific, not a universal depth guarantee or another source-language stack. Measure target-specific timing/prediction under a controlled workload rather than inferring it from the compiler listing or simulator steps.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-11/instructor/reading-answers.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingAnswers = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingAnswers as default
};
