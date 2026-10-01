import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"My C field notebook","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-01/learner/observations.md","filePath":"materials/week-01/learner/observations.md"}');
const _sfc_main = { name: "materials/week-01/learner/observations.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="my-c-field-notebook" tabindex="-1">My C field notebook <a class="header-anchor" href="#my-c-field-notebook" aria-label="Permalink to &quot;My C field notebook&quot;">​</a></h1><h3 id="r01" tabindex="-1">R01 <a class="header-anchor" href="#r01" aria-label="Permalink to &quot;R01 {#r01}&quot;">​</a></h3><p>Record date, CPU/architecture, OS/kernel, GCC and Clang versions, build commands and flags, and test results. Note if WSL is used and what else was running during timing.</p><h3 id="r02" tabindex="-1">R02 <a class="header-anchor" href="#r02" aria-label="Permalink to &quot;R02 {#r02}&quot;">​</a></h3><p>For each E01–E15, record a <strong>prediction before running</strong>, an <strong>observed output or test result</strong>, and an <strong>explanation</strong> connecting source → mechanism → observation. Answer each E01.Q–E15.Q explicitly, retaining those IDs. Include the E08 layout diagram and E14 symbol observations. Explain any failed prediction. Reference source filenames for E01.C–E15.C.</p><table tabindex="0"><thead><tr><th>Exercise</th><th>Prediction</th><th>Observation</th><th>Explanation / boundary</th></tr></thead><tbody><tr><td>E01–E15 (expand to fifteen rows)</td><td></td><td></td><td></td></tr></tbody></table><h3 id="r03" tabindex="-1">R03 <a class="header-anchor" href="#r03" aria-label="Permalink to &quot;R03 {#r03}&quot;">​</a></h3><p>Identify two concrete observations that depend on this implementation. For each, contrast with a portable relationship that your tests use. Distinguish formally implementation-defined choices from merely unspecified or observed details when relevant.</p><h3 id="r04" tabindex="-1">R04 <a class="header-anchor" href="#r04" aria-label="Permalink to &quot;R04 {#r04}&quot;">​</a></h3><p>Record E15 size, initialization, iterations, warm-up, checksum, all five raw times per build, median, min, max and range. Show one median calculation and elapsed-time unit conversion. Compare <code>-O0</code>/<code>-O2</code> with a cautiously worded conclusion, describe overhead and volatile-read limits, and state how another valid result would change your conclusion.</p><h3 id="r05" tabindex="-1">R05 <a class="header-anchor" href="#r05" aria-label="Permalink to &quot;R05 {#r05}&quot;">​</a></h3><p>Submit source, the build recipe, test output and this report. Give a short defense of one source → mechanism → observation connection that would remain useful in another language, and name one unresolved question for later weeks. Include your six practice responses, and any optional stretch responses, under their stable IDs.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-01/learner/observations.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const observations = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  observations as default
};
