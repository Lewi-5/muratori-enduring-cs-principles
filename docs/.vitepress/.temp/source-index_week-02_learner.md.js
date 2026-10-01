import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-02/learner","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-02/learner.md","filePath":"source-index/week-02/learner.md"}');
const _sfc_main = { name: "source-index/week-02/learner.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-02-learner" tabindex="-1">Files: week-02/learner <a class="header-anchor" href="#files-week-02-learner" aria-label="Permalink to &quot;Files: week-02/learner&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/materials/week-02/learner/exercises.html">exercises.md</a></li><li><a href="/materials/week-02/learner/observations.html">observations.md</a></li><li><a href="/materials/week-02/learner/practice.html">practice.md</a></li><li><a href="/source/week-02/learner/src/ex01.c.html">src/ex01.c</a></li><li><a href="/source/week-02/learner/src/ex02.c.html">src/ex02.c</a></li><li><a href="/source/week-02/learner/src/ex03.c.html">src/ex03.c</a></li><li><a href="/source/week-02/learner/src/ex04.c.html">src/ex04.c</a></li><li><a href="/source/week-02/learner/src/ex05.c.html">src/ex05.c</a></li><li><a href="/source/week-02/learner/src/ex06.c.html">src/ex06.c</a></li><li><a href="/source/week-02/learner/src/ex07.c.html">src/ex07.c</a></li><li><a href="/source/week-02/learner/src/ex08.c.html">src/ex08.c</a></li><li><a href="/source/week-02/learner/src/ex09_data.c.html">src/ex09_data.c</a></li><li><a href="/source/week-02/learner/src/ex09_data.h.html">src/ex09_data.h</a></li><li><a href="/source/week-02/learner/src/ex09_main.c.html">src/ex09_main.c</a></li><li><a href="/source/week-02/learner/src/ex10.c.html">src/ex10.c</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-02/learner.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const learner = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  learner as default
};
