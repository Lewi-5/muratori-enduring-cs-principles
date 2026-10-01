import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 8 notebook","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-08/learner/observations.md","filePath":"materials/week-08/learner/observations.md"}');
const _sfc_main = { name: "materials/week-08/learner/observations.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-8-notebook" tabindex="-1">Week 8 notebook <a class="header-anchor" href="#week-8-notebook" aria-label="Permalink to &quot;Week 8 notebook&quot;">​</a></h1><p>Keep prediction, observation, explanation and uncertainty distinct.</p><h3 id="r01" tabindex="-1">R01 <a class="header-anchor" href="#r01" aria-label="Permalink to &quot;R01 {#r01}&quot;">​</a></h3><p>Record the platform, compiler versions and complete flags, supplied decoder revision, study time and the exact commands you ran.</p><p>Prediction:</p><p>Observation:</p><p>Explanation and limits:</p><h3 id="r02" tabindex="-1">R02 <a class="header-anchor" href="#r02" aria-label="Permalink to &quot;R02 {#r02}&quot;">​</a></h3><p>Draw the complete seven-instruction fixture’s byte partitions and predict every register/IP/flag state before running. Reconcile predictions with the observed trace.</p><p>Prediction:</p><p>Observation:</p><p>Explanation and limits:</p><h3 id="r03" tabindex="-1">R03 <a class="header-anchor" href="#r03" aria-label="Permalink to &quot;R03 {#r03}&quot;">​</a></h3><p>Explain one carry-without-overflow case, one overflow-without-carry case, one low-byte parity case and one CMP non-write case with saved test evidence.</p><p>Prediction:</p><p>Observation:</p><p>Explanation and limits:</p><h3 id="r04" tabindex="-1">R04 <a class="header-anchor" href="#r04" aria-label="Permalink to &quot;R04 {#r04}&quot;">​</a></h3><p>Demonstrate one late decode failure and one unsupported memory execution. Record status, offset, tentative steps, stdout and caller-state preservation. Distinguish sim_step, sim_run and CLI transaction boundaries.</p><p>Prediction:</p><p>Observation:</p><p>Explanation and limits:</p><h3 id="r05" tabindex="-1">R05 <a class="header-anchor" href="#r05" aria-label="Permalink to &quot;R05 {#r05}&quot;">​</a></h3><p>Connect one C operation to a guest mechanism and trace observation. State test limits and Week 9’s missing state/control-flow mechanisms.</p><p>Prediction:</p><p>Observation:</p><p>Explanation and limits:</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-08/learner/observations.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const observations = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  observations as default
};
