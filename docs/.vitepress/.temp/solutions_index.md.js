import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Reference solutions — spoilers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"solutions/index.md","filePath":"solutions/index.md"}');
const _sfc_main = { name: "solutions/index.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="reference-solutions-—-spoilers" tabindex="-1">Reference solutions — spoilers <a class="header-anchor" href="#reference-solutions-—-spoilers" aria-label="Permalink to &quot;Reference solutions — spoilers&quot;">​</a></h1><p>These pages contain full answers, source code, exemplar notebooks, and links to the original validation records. Try the exercises and their hints first. Reference code belongs to the instructor package; the default local build uses your learner files.</p><ul><li><a href="/solutions/week-01.html">Week 1 · C field notebook</a></li><li><a href="/solutions/week-02.html">Week 2 · Object-layout inspector</a></li><li><a href="/solutions/week-03.html">Week 3 · Geospatial mathematics</a></li><li><a href="/solutions/week-04.html">Week 4 · Deterministic data pipeline</a></li><li><a href="/solutions/week-05.html">Week 5 · Scalar geolab checkpoint</a></li><li><a href="/solutions/week-06.html">Week 6 · 8086 subset decoder</a></li><li><a href="/solutions/week-07.html">Week 7 · Memory operands and decoder API</a></li><li><a href="/solutions/week-08.html">Week 8 · Register state and arithmetic flags</a></li><li><a href="/solutions/week-09.html">Week 9 · Branches and bounded guest memory</a></li><li><a href="/solutions/week-10.html">Week 10 · Stack discipline, calls and lifetimes</a></li><li><a href="/solutions/week-11.html">Week 11 · From C to x64: calls and the ABI</a></li><li><a href="/solutions/week-12.html">Week 12 · Project 2: a specified simulator</a></li><li><a href="/solutions/week-13.html">Week 13 · Clocks and repeatable timing</a></li><li><a href="/solutions/week-14.html">Week 14 · Nested and recursive profiling</a></li><li><a href="/solutions/week-15.html">Week 15 · Sorting: complexity and measured cost</a></li><li><a href="/solutions/week-16.html">Week 16 · Object lifetimes and allocation ownership</a></li></ul><p>Historical timings and implementation observations retain their dates and toolchains. They are examples of evidence, not expected measurements for your computer. Search excludes these pages and the imported instructor materials to keep routine navigation free of accidental answers.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("solutions/index.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const index = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  index as default
};
