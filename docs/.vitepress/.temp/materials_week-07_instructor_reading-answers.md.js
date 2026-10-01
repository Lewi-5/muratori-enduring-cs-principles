import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Reading answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-07/instructor/reading-answers.md","filePath":"materials/week-07/instructor/reading-answers.md"}');
const _sfc_main = { name: "materials/week-07/instructor/reading-answers.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="reading-answers" tabindex="-1">Reading answers <a class="header-anchor" href="#reading-answers" aria-label="Permalink to &quot;Reading answers&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>Scott introduces separating memory location from stored data. CS:APP gives effective-address arithmetic for modern machine-code operands. Intel provides the exact historical encoding table needed to interpret mode and r/m. All support the idea of a memory operand, but only the selected ISA reference determines the accepted byte patterns. Modern scaling factors and extra registers from CS:APP must not enter the 8086 table.</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>The include contributes declarations and type definitions to the client translation unit. Compilation checks its uses and emits code with unresolved external calls or linker information. Linking connects those calls to definitions or records shared dependencies; loading makes the needed code available in the process. A header alone lacks implementation code, so the library definition is still needed. Conversely a library with no matching header leaves the client without reliable compile-time type information. CS 341 extends the build view; CS:APP covers shared loading in more depth.</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>Position-independent code supports loading code at different addresses using the toolchain’s addressing and relocation machinery. A recorded shared dependency is processed by the loader at startup; dlopen requests a library while the application is running. Both still call machine code under an ABI. A changed Operand layout can shift offsets and sizes while symbol names stay identical. Rebuild both sides against compatible headers and conventions. Dynamic loading controls when code is available; it does not infer type compatibility. The deeper reading explains these Linux/ELF mechanisms beyond ISO C.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-07/instructor/reading-answers.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingAnswers = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingAnswers as default
};
