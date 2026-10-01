import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Reading answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-15/instructor/reading-answers.md","filePath":"materials/week-15/instructor/reading-answers.md"}');
const _sfc_main = { name: "materials/week-15/instructor/reading-answers.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="reading-answers" tabindex="-1">Reading answers <a class="header-anchor" href="#reading-answers" aria-label="Permalink to &quot;Reading answers&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>Big O gives an asymptotic upper bound on a specified cost function, which can describe worst, best or average cases. Here the deterministic counter contract defines one cost; CE repetition testing observes favorable realized time amid hidden state. Neither promises a fixed crossover. Read the HH scale discussion for intuition while retaining the precise definition.</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>A later stable digit grouping preserves prior lower-digit ordering within equal current digits. Repeat this invariant across all four bytes. HH explains a sorting mechanism, while Beej’s qsort contract provides neither stability nor our algorithm. The course’s uint32_t-only domain and scratch/error/count rules remain defined in lab.h.</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>Locality describes reuse and nearby accesses; more scratch can change traffic but does not prove a cache miss. Timings alone cannot identify the cause. A later controlled counter/cache experiment with a named CPU and fixed workload can support that claim. Use CS:APP memory/locality and HP measurement sections for the distinction, not an invented universal penalty.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-15/instructor/reading-answers.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingAnswers = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingAnswers as default
};
