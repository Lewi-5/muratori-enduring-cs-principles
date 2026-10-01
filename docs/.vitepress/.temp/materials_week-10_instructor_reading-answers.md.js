import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Further-reading answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-10/instructor/reading-answers.md","filePath":"materials/week-10/instructor/reading-answers.md"}');
const _sfc_main = { name: "materials/week-10/instructor/reading-answers.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="further-reading-answers" tabindex="-1">Further-reading answers <a class="header-anchor" href="#further-reading-answers" aria-label="Permalink to &quot;Further-reading answers&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>All three explain a saved continuation and last-in, first-out restoration for nested calls. CS:APP and Dive Into Systems discuss x64: their eight-byte return words, RSP naming, register argument passing and frame conventions must not be substituted for our two-byte near return and SP. The shared idea is control transfer with retained continuation; its size and convention are ISA/ABI-specific. CS:APP&#39;s frame diagrams are useful reasoning tools, not a C requirement that every local have an addressable stack slot.</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>Scope tells you where a name is visible, while lifetime tells you when the object exists. An automatic local ceases to be a valid object at block exit regardless of whether its bytes still look unchanged. Dereferencing a returned &amp;local is therefore invalid; a successful stale read would not make it portable. <code>int good(int *out) { if (!out) return 0; *out=7; return 1; }</code> lets the caller provide storage whose lifetime extends through use. Static storage changes lifetime but introduces a shared object; allocation requires an explicit free/ownership contract.</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>Intel settles the operations, encodings and affected flags, including original 8086 PUSH SP. An ABI settles agreements between compiled callers and callees: registers to preserve, argument locations, result locations and alignment. Hennessy/Patterson places calls among broader control-flow designs but does not define our exact decoder subset or guest transaction policy. HH&#39;s observed RIP/RSP discussion connects a running program to those architectural locations; its Windows/x64 example does not settle System V behavior. One compiled trace proves a concrete observed result under its configuration and leaves other compiler choices, timing and unsupported instructions unresolved.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-10/instructor/reading-answers.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingAnswers = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingAnswers as default
};
