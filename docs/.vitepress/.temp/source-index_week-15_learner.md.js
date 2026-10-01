import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-15/learner","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-15/learner.md","filePath":"source-index/week-15/learner.md"}');
const _sfc_main = { name: "source-index/week-15/learner.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-15-learner" tabindex="-1">Files: week-15/learner <a class="header-anchor" href="#files-week-15-learner" aria-label="Permalink to &quot;Files: week-15/learner&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/materials/week-15/learner/exercises.html">exercises.md</a></li><li><a href="/materials/week-15/learner/observations.html">observations.md</a></li><li><a href="/materials/week-15/learner/practice.html">practice.md</a></li><li><a href="/materials/week-15/learner/reading-questions.html">reading-questions.md</a></li><li><a href="/source/week-15/learner/src/insertion.c.html">src/insertion.c</a></li><li><a href="/source/week-15/learner/src/merge.c.html">src/merge.c</a></li><li><a href="/source/week-15/learner/src/radix.c.html">src/radix.c</a></li><li><a href="/source/week-15/learner/src/summary.c.html">src/summary.c</a></li><li><a href="/source/week-15/learner/src/w01.c.html">src/w01.c</a></li><li><a href="/source/week-15/learner/src/w02.c.html">src/w02.c</a></li><li><a href="/source/week-15/learner/src/w03.c.html">src/w03.c</a></li><li><a href="/materials/week-15/learner/warmups.html">warmups.md</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-15/learner.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const learner = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  learner as default
};
