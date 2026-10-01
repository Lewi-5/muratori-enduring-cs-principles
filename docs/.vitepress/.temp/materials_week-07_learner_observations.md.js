import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 7 notebook","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-07/learner/observations.md","filePath":"materials/week-07/learner/observations.md"}');
const _sfc_main = { name: "materials/week-07/learner/observations.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-7-notebook" tabindex="-1">Week 7 notebook <a class="header-anchor" href="#week-7-notebook" aria-label="Permalink to &quot;Week 7 notebook&quot;">​</a></h1><p>Keep prediction, observation, explanation and remaining uncertainty in separate paragraphs.</p><h3 id="r01" tabindex="-1">R01 <a class="header-anchor" href="#r01" aria-label="Permalink to &quot;R01 {#r01}&quot;">​</a></h3><p>Record platform, GCC/Clang and binutils versions, complete flags, the API revision and your actual study time.</p><p>Prediction:</p><p>Observation:</p><p>Explanation and limits:</p><h3 id="r02" tabindex="-1">R02 <a class="header-anchor" href="#r02" aria-label="Permalink to &quot;R02 {#r02}&quot;">​</a></h3><p>Before running, draw the byte partitions for 8B 46 FE, 8B 06 FE FF and C7 86 00 80 00 80. Record predictions, then observations and explanations.</p><p>Prediction:</p><p>Observation:</p><p>Explanation and limits:</p><h3 id="r03" tabindex="-1">R03 <a class="header-anchor" href="#r03" aria-label="Permalink to &quot;R03 {#r03}&quot;">​</a></h3><p>Show one truncation, one unsupported operation and one too-small text result. Explain output preservation and status precedence, with assertions or saved test evidence.</p><p>Prediction:</p><p>Observation:</p><p>Explanation and limits:</p><h3 id="r04" tabindex="-1">R04 <a class="header-anchor" href="#r04" aria-label="Permalink to &quot;R04 {#r04}&quot;">​</a></h3><p>Record library exports, client dependency, successful load/call and one independent disassembly comparison. Explain convention differences and evidence limits.</p><p>Prediction:</p><p>Observation:</p><p>Explanation and limits:</p><h3 id="r05" tabindex="-1">R05 <a class="header-anchor" href="#r05" aria-label="Permalink to &quot;R05 {#r05}&quot;">​</a></h3><p>Explain source → mechanism → observation for one memory operand, and identify the additional state Week 8/9 would need. Submit five purposeful cases and explain what the broad tests leave unproved.</p><p>Prediction:</p><p>Observation:</p><p>Explanation and limits:</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-07/learner/observations.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const observations = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  observations as default
};
