import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Evidence notebook","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-15/learner/observations.md","filePath":"materials/week-15/learner/observations.md"}');
const _sfc_main = { name: "materials/week-15/learner/observations.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="evidence-notebook" tabindex="-1">Evidence notebook <a class="header-anchor" href="#evidence-notebook" aria-label="Permalink to &quot;Evidence notebook&quot;">​</a></h1><h3 id="r01" tabindex="-1">R01 <a class="header-anchor" href="#r01" aria-label="Permalink to &quot;R01 {#r01}&quot;">​</a></h3><p>Record predictions of counts and crossover by size/input shape before execution. Explain the expected mechanism rather than inventing a universal winning algorithm.</p><h3 id="r02" tabindex="-1">R02 <a class="header-anchor" href="#r02" aria-label="Permalink to &quot;R02 {#r02}&quot;">​</a></h3><p>Record oracle, stability/permutation evidence, boundary/error cases and compiler/sanitizer results. Include one counterexample to an inadequate ordering-only check.</p><h3 id="r03" tabindex="-1">R03 <a class="header-anchor" href="#r03" aria-label="Permalink to &quot;R03 {#r03}&quot;">​</a></h3><p>Attach actual benchmark CSV, compiler/version/target/flags, timer, reset/warm-up policy and timed scope. Separate deterministic example samples from measured observations.</p><h3 id="r04" tabindex="-1">R04 <a class="header-anchor" href="#r04" aria-label="Permalink to &quot;R04 {#r04}&quot;">​</a></h3><p>Compare min/median/mean/max by algorithm and shape. Explain variability, counter instrumentation and limitations; state whether crossover was observed rather than forcing one.</p><h3 id="r05" tabindex="-1">R05 <a class="header-anchor" href="#r05" aria-label="Permalink to &quot;R05 {#r05}&quot;">​</a></h3><p>Compute extra memory from sizeof(Item), scratch and bucket metadata. Record actual workload and a handoff to Week 16 ownership/lifetime reasoning.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-15/learner/observations.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const observations = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  observations as default
};
