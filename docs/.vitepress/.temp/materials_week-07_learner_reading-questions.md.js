import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Further-reading questions","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-07/learner/reading-questions.md","filePath":"materials/week-07/learner/reading-questions.md"}');
const _sfc_main = { name: "materials/week-07/learner/reading-questions.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="further-reading-questions" tabindex="-1">Further-reading questions <a class="header-anchor" href="#further-reading-questions" aria-label="Permalink to &quot;Further-reading questions&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>Compare Scott’s load/store description, CS:APP’s operand formula and the Intel 8086 ModR/M table. Which explains the idea, which expresses an address calculation and which determines our bytes?</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>Use Beej chapter 17 and the CS 341 compiling/linking section to trace a client’s include, compile, link and load. What is missing if you distribute only decode.h?</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>Read CS:APP §§7.10–7.12 after the shared-library episode. Explain PIC, explicit dlopen versus a recorded dependency, and why these do not make mismatched structures compatible.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-07/learner/reading-questions.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingQuestions = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingQuestions as default
};
