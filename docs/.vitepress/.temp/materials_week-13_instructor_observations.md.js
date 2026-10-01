import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Measurement notebook exemplar","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-13/instructor/observations.md","filePath":"materials/week-13/instructor/observations.md"}');
const _sfc_main = { name: "materials/week-13/instructor/observations.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="measurement-notebook-exemplar" tabindex="-1">Measurement notebook exemplar <a class="header-anchor" href="#measurement-notebook-exemplar" aria-label="Permalink to &quot;Measurement notebook exemplar&quot;">​</a></h1><p>Keep prediction, observation, inference and limitation distinct.</p><h3 id="r01" tabindex="-1">R01 <a class="header-anchor" href="#r01" aria-label="Permalink to &quot;R01 {#r01}&quot;">​</a></h3><p>The header defines the bounds and output transaction; the deterministic playground supplies a hand-derivable prediction. Real durations remain unknown until observed.</p><h3 id="r02" tabindex="-1">R02 <a class="header-anchor" href="#r02" aria-label="Permalink to &quot;R02 {#r02}&quot;">​</a></h3><p>Week 13 late clock failure preserves samples but retains completed work. Week 14 rejected end preserves the stack, totals and last timestamp. Record the actual gate and sentinels, not just an error label.</p><h3 id="r03" tabindex="-1">R03 <a class="header-anchor" href="#r03" aria-label="Permalink to &quot;R03 {#r03}&quot;">​</a></h3><p>Preserve source hashes and exact flags. Week 13 counter listing shows fenced RDTSCP; Week 14 event listing shows state-copy/accumulation paths. A listing proves emission under that build; no latency follows from line count.</p><h3 id="r04" tabindex="-1">R04 <a class="header-anchor" href="#r04" aria-label="Permalink to &quot;R04 {#r04}&quot;">​</a></h3><p>Use tools/measure.py for four captures. Lower median is declared for13; paired relative differences for14 include negative samples. WSL/virtualization and load constrain transfer to other systems.</p><h3 id="r05" tabindex="-1">R05 <a class="header-anchor" href="#r05" aria-label="Permalink to &quot;R05 {#r05}&quot;">​</a></h3><p>Supported: the fixed event/timing contracts pass the checked domains and raw host runs have the recorded values. Unsupported: counterticks equalcorecycles or instrumentation has a universal fixed cost. Next: repeat on specified hardware with a workload and sampling protocol designed for the new claim.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-13/instructor/observations.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const observations = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  observations as default
};
