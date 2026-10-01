import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Evidence notebook","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-16/learner/observations.md","filePath":"materials/week-16/learner/observations.md"}');
const _sfc_main = { name: "materials/week-16/learner/observations.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="evidence-notebook" tabindex="-1">Evidence notebook <a class="header-anchor" href="#evidence-notebook" aria-label="Permalink to &quot;Evidence notebook&quot;">​</a></h1><h3 id="r01" tabindex="-1">R01 <a class="header-anchor" href="#r01" aria-label="Permalink to &quot;R01 {#r01}&quot;">​</a></h3><p>Draw creation, helper return, successful resize and release for automatic pointer/result, static counter and allocated elements. Label valid access windows without assuming physical stack placement.</p><h3 id="r02" tabindex="-1">R02 <a class="header-anchor" href="#r02" aria-label="Permalink to &quot;R02 {#r02}&quot;">​</a></h3><p>Record actual compiler diagnostics for return_local.c and sanitizer reports for use_after_free/double_free. Explain each defect and the corresponding repair.</p><h3 id="r03" tabindex="-1">R03 <a class="header-anchor" href="#r03" aria-label="Permalink to &quot;R03 {#r03}&quot;">​</a></h3><p>Describe allocator ownership/provenance and failure injection. Record attempts, successful allocations and releases, proving the failed grow leaves the original data intact.</p><h3 id="r04" tabindex="-1">R04 <a class="header-anchor" href="#r04" aria-label="Permalink to &quot;R04 {#r04}&quot;">​</a></h3><p>Record six-mode repaired correctness results and expected broken-program failures separately. State what remains a caller precondition and what tests cannot prove.</p><h3 id="r05" tabindex="-1">R05 <a class="header-anchor" href="#r05" aria-label="Permalink to &quot;R05 {#r05}&quot;">​</a></h3><p>Record actual workload, peak resize memory and a handoff to later arena/allocator weeks. Give one API design that would make a lifetime obligation easier to follow.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-16/learner/observations.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const observations = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  observations as default
};
