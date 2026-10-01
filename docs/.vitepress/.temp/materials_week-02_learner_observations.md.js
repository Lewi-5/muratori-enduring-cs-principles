import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"My object-layout inspector notebook","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-02/learner/observations.md","filePath":"materials/week-02/learner/observations.md"}');
const _sfc_main = { name: "materials/week-02/learner/observations.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="my-object-layout-inspector-notebook" tabindex="-1">My object-layout inspector notebook <a class="header-anchor" href="#my-object-layout-inspector-notebook" aria-label="Permalink to &quot;My object-layout inspector notebook&quot;">​</a></h1><h3 id="r01" tabindex="-1">R01 <a class="header-anchor" href="#r01" aria-label="Permalink to &quot;R01 {#r01}&quot;">​</a></h3><p>Record date, CPU, OS/kernel, WSL if applicable, GCC/Clang versions, binutils versions and exact build/test commands. Attach test output for both optimization levels and compilers. Identify the source of each recorded fact.</p><h3 id="r02" tabindex="-1">R02 <a class="header-anchor" href="#r02" aria-label="Permalink to &quot;R02 {#r02}&quot;">​</a></h3><p>Before running, write predictions for E01–E10 and draw E03/E04/E10 layouts. After running, preserve those predictions and add observations and explanations. Answer E01.Q–E10.Q under their IDs, referencing corresponding source for E01.C–E10.C. Include the E06/P02 storage-duration table, and nested versus top-level padding. Do not silently replace a failed prediction.</p><table tabindex="0"><thead><tr><th>Exercise (expand to ten rows)</th><th>Prediction before run</th><th>Observed output/test</th><th>Explanation and boundary</th></tr></thead><tbody><tr><td>E01–E10</td><td></td><td></td><td></td></tr></tbody></table><h3 id="r03" tabindex="-1">R03 <a class="header-anchor" href="#r03" aria-label="Permalink to &quot;R03 {#r03}&quot;">​</a></h3><p>Give at least two implementation-dependent observations contrasted with portable test relationships. Create a claim ledger with at least six statements labelled C11, POSIX/Linux, System V ABI, compiler, toolchain or this-machine observation. Explain why those categories are not interchangeable.</p><h3 id="r04" tabindex="-1">R04 <a class="header-anchor" href="#r04" aria-label="Permalink to &quot;R04 {#r04}&quot;">​</a></h3><p>Explain the HH014 block design and its C11 validity conditions, the HH064 index/reference design with evidence from E08, and why sizes/offsets alone do not predict loop speed. Identify the later course weeks that supply missing performance mechanisms. State the limits of copying indices and raw object bytes.</p><h3 id="r05" tabindex="-1">R05 <a class="header-anchor" href="#r05" aria-label="Permalink to &quot;R05 {#r05}&quot;">​</a></h3><p>List submitted sources, helper/header files, build recipe, test logs and this notebook. Defend one durable source → mechanism → observation connection. State an unresolved question appropriate to week three, and record actual time spent versus the unpiloted ten-hour core estimate. Include P01–P06 responses and any optional S01/S02 work.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-02/learner/observations.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const observations = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  observations as default
};
