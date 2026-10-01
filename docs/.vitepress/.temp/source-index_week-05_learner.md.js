import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-05/learner","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-05/learner.md","filePath":"source-index/week-05/learner.md"}');
const _sfc_main = { name: "source-index/week-05/learner.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-05-learner" tabindex="-1">Files: week-05/learner <a class="header-anchor" href="#files-week-05-learner" aria-label="Permalink to &quot;Files: week-05/learner&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/materials/week-05/learner/PROTOCOL.html">PROTOCOL.md</a></li><li><a href="/materials/week-05/learner/exercises.html">exercises.md</a></li><li><a href="/materials/week-05/learner/fixtures/README.html">fixtures/README.md</a></li><li><a href="/source/week-05/learner/geolab/include/bench.h.html">geolab/include/bench.h</a></li><li><a href="/source/week-05/learner/geolab/include/cli.h.html">geolab/include/cli.h</a></li><li><a href="/source/week-05/learner/geolab/include/geolab.h.html">geolab/include/geolab.h</a></li><li><a href="/source/week-05/learner/geolab/src/bench.c.html">geolab/src/bench.c</a></li><li><a href="/source/week-05/learner/geolab/src/cli.c.html">geolab/src/cli.c</a></li><li><a href="/source/week-05/learner/geolab/src/csv.c.html">geolab/src/csv.c</a></li><li><a href="/source/week-05/learner/geolab/src/geo.c.html">geolab/src/geo.c</a></li><li><a href="/source/week-05/learner/geolab/src/main.c.html">geolab/src/main.c</a></li><li><a href="/source/week-05/learner/geolab/src/query.c.html">geolab/src/query.c</a></li><li><a href="/materials/week-05/learner/practice.html">practice.md</a></li><li><a href="/materials/week-05/learner/report.html">report.md</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-05/learner.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const learner = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  learner as default
};
