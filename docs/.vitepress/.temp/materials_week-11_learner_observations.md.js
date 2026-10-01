import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Notebook","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-11/learner/observations.md","filePath":"materials/week-11/learner/observations.md"}');
const _sfc_main = { name: "materials/week-11/learner/observations.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="notebook" tabindex="-1">Notebook <a class="header-anchor" href="#notebook" aria-label="Permalink to &quot;Notebook&quot;">​</a></h1><h3 id="r01" tabindex="-1">R01 <a class="header-anchor" href="#r01" aria-label="Permalink to &quot;R01 {#r01}&quot;">​</a></h3><p>Record predicted argument/result locations for the three geolab signatures from E01. Attach actual assembly annotations linking each observed boundary use to the ABI or a compiler choice.</p><h3 id="r02" tabindex="-1">R02 <a class="header-anchor" href="#r02" aria-label="Permalink to &quot;R02 {#r02}&quot;">​</a></h3><p>For GCC and Clang at O0/O2, record version, target, flags and source hashes from manifests. Compare local_example and one real geolab routine without inventing a universal sequence. Include at least one relocation interpretation.</p><h3 id="r03" tabindex="-1">R03 <a class="header-anchor" href="#r03" aria-label="Permalink to &quot;R03 {#r03}&quot;">​</a></h3><p>Draw stack positions before a call, at entry and after one prologue push. Explain register ownership and show how keep_across_call retains its live values. State the red-zone limitation.</p><h3 id="r04" tabindex="-1">R04 <a class="header-anchor" href="#r04" aria-label="Permalink to &quot;R04 {#r04}&quot;">​</a></h3><p>Record actual correctness/sanitizer/probe results, including whether you chose to write the optional probe. Separate tested behavior from unmeasured performance and prediction. Identify unsupported ABI cases.</p><h3 id="r05" tabindex="-1">R05 <a class="header-anchor" href="#r05" aria-label="Permalink to &quot;R05 {#r05}&quot;">​</a></h3><p>Record actual workload and difficulties. Write a handoff for Week 12 explaining what simulator state, x64 ABI comparison and machine-specific timing assumptions can each establish.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-11/learner/observations.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const observations = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  observations as default
};
