import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Practice and stretch","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-13/learner/practice.md","filePath":"materials/week-13/learner/practice.md"}');
const _sfc_main = { name: "materials/week-13/learner/practice.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="practice-and-stretch" tabindex="-1">Practice and stretch <a class="header-anchor" href="#practice-and-stretch" aria-label="Permalink to &quot;Practice and stretch&quot;">​</a></h1><p>Predict before running; these are additional explanations and experiments, not changes to the core API.</p><h3 id="p01" tabindex="-1">P01 <a class="header-anchor" href="#p01" aria-label="Permalink to &quot;P01 {#p01}&quot;">​</a></h3><p>Predict the two seconds fields 18,446,744,073 and 18,446,744,074 with nanos zero. Explain the accepted boundary.</p><h3 id="p02" tabindex="-1">P02 <a class="header-anchor" href="#p02" aria-label="Permalink to &quot;P02 {#p02}&quot;">​</a></h3><p>Hand-sort [10,40,30,20] and compare the playground output. Explain lower versus arithmetic median.</p><h3 id="p03" tabindex="-1">P03 <a class="header-anchor" href="#p03" aria-label="Permalink to &quot;P03 {#p03}&quot;">​</a></h3><p>Inject T_CLOCK on the sixth read of a four-sample collection. Predict callback counts and output.</p><h3 id="p04" tabindex="-1">P04 <a class="header-anchor" href="#p04" aria-label="Permalink to &quot;P04 {#p04}&quot;">​</a></h3><p>Inspect CLOCK_REALTIME, CLOCK_MONOTONIC and process CPU time in the Linux manual. Choose a clock for an elapsed batch that may be preempted.</p><h3 id="p05" tabindex="-1">P05 <a class="header-anchor" href="#p05" aria-label="Permalink to &quot;P05 {#p05}&quot;">​</a></h3><p>Compare work and empty raw intervals. Explain why subtracting their minima is not a proof of exact work cost.</p><h3 id="p06" tabindex="-1">P06 <a class="header-anchor" href="#p06" aria-label="Permalink to &quot;P06 {#p06}&quot;">​</a></h3><p>Find RDTSCP and LFENCE in one optimized object listing. Record source and compiler manifest.</p><h3 id="s01" tabindex="-1">S01 <a class="header-anchor" href="#s01" aria-label="Permalink to &quot;S01 {#s01}&quot;">​</a></h3><p>Design a longer calibration window without busy-waiting on counter ticks. State units, bounds and failure behavior before coding.</p><h3 id="s02" tabindex="-1">S02 <a class="header-anchor" href="#s02" aria-label="Permalink to &quot;S02 {#s02}&quot;">​</a></h3><p>Compare elapsed wall duration with process CPU duration on a workload that sometimes sleeps. Predict and then observe.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-13/learner/practice.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const practice = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  practice as default
};
