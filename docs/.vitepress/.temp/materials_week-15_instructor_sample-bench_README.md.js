import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Actual repeated-sort observations","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-15/instructor/sample-bench/README.md","filePath":"materials/week-15/instructor/sample-bench/README.md"}');
const _sfc_main = { name: "materials/week-15/instructor/sample-bench/README.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="actual-repeated-sort-observations" tabindex="-1">Actual repeated-sort observations <a class="header-anchor" href="#actual-repeated-sort-observations" aria-label="Permalink to &quot;Actual repeated-sort observations&quot;">​</a></h1><p>tools/sample.py records GCC and Clang optimized runs for four sizes and four input shapes, nine timed trials after one warm-up. environment.json records date, versions, target, kernel, exact flags and source hashes. CSV timings are actual observations, not expected outputs or universal crossover requirements. The benchmark counts operations inside its timed sort, resets outside it and consumes/checks afterward. Algorithms run in fixed order, so environmental drift and order effects remain limitations; alternating/randomized order is a useful controlled extension.</p><p>The tiny sample-summary numbers in the playground are deterministic arithmetic fixtures, not this measurement. Compare each shape and size independently, state which summary supports a claim, and permit another environment to differ. Regenerating these files deliberately replaces the sample with a new recorded experiment; update its date when doing so.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-15/instructor/sample-bench/README.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const README = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  README as default
};
