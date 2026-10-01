import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Project notebook","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-12/learner/observations.md","filePath":"materials/week-12/learner/observations.md"}');
const _sfc_main = { name: "materials/week-12/learner/observations.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="project-notebook" tabindex="-1">Project notebook <a class="header-anchor" href="#project-notebook" aria-label="Permalink to &quot;Project notebook&quot;">​</a></h1><h3 id="r01" tabindex="-1">R01 <a class="header-anchor" href="#r01" aria-label="Permalink to &quot;R01 {#r01}&quot;">​</a></h3><p>Preserve the main fixture&#39;s 25-step prediction, record actual complete output and explain final state and memory deltas.</p><h3 id="r02" tabindex="-1">R02 <a class="header-anchor" href="#r02" aria-label="Permalink to &quot;R02 {#r02}&quot;">​</a></h3><p>Record three failures with statuses/offsets/tentative counts and complete unchanged-output checks, including capacity and late guest memory mutation.</p><h3 id="r03" tabindex="-1">R03 <a class="header-anchor" href="#r03" aria-label="Permalink to &quot;R03 {#r03}&quot;">​</a></h3><p>Record independent expected-value methods for wrapping words, flags and stack words. Compare against the uncached predecessor and name shared assumptions.</p><h3 id="r04" tabindex="-1">R04 <a class="header-anchor" href="#r04" aria-label="Permalink to &quot;R04 {#r04}&quot;">​</a></h3><p>Attach actual debug/optimized x64 excerpts, manifests and ABI/relocation annotations for two subjects. Explain differing valid compiler choices and an eliminated local.</p><h3 id="r05" tabindex="-1">R05 <a class="header-anchor" href="#r05" aria-label="Permalink to &quot;R05 {#r05}&quot;">​</a></h3><p>Write the Project 2 model defense and Week 13 handoff. List exact tools/commands, actual time, observations, inferences and limitations; do not invent timings or learner pilot results.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-12/learner/observations.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const observations = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  observations as default
};
