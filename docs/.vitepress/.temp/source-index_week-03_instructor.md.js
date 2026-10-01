import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-03/instructor","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-03/instructor.md","filePath":"source-index/week-03/instructor.md"}');
const _sfc_main = { name: "source-index/week-03/instructor.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-03-instructor" tabindex="-1">Files: week-03/instructor <a class="header-anchor" href="#files-week-03-instructor" aria-label="Permalink to &quot;Files: week-03/instructor&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/materials/week-03/instructor/README.html">README.md</a></li><li><a href="/materials/week-03/instructor/answers.html">answers.md</a></li><li><a href="/materials/week-03/instructor/coverage.html">coverage.md</a></li><li><a href="/source/week-03/instructor/extras/measure.c.html">extras/measure.c</a></li><li><a href="/source/week-03/instructor/extras/stretch_antipodal.c.html">extras/stretch_antipodal.c</a></li><li><a href="/source/week-03/instructor/extras/stretch_edges.c.html">extras/stretch_edges.c</a></li><li><a href="/materials/week-03/instructor/observations.html">observations.md</a></li><li><a href="/materials/week-03/instructor/reading-answers.html">reading-answers.md</a></li><li><a href="/source/week-03/instructor/src/ex01.c.html">src/ex01.c</a></li><li><a href="/source/week-03/instructor/src/ex02.c.html">src/ex02.c</a></li><li><a href="/source/week-03/instructor/src/ex03.c.html">src/ex03.c</a></li><li><a href="/source/week-03/instructor/src/ex04.c.html">src/ex04.c</a></li><li><a href="/source/week-03/instructor/src/ex05.c.html">src/ex05.c</a></li><li><a href="/source/week-03/instructor/src/ex06.c.html">src/ex06.c</a></li><li><a href="/source/week-03/instructor/src/geomath.c.html">src/geomath.c</a></li><li><a href="/source/week-03/instructor/src/geomath.h.html">src/geomath.h</a></li><li><a href="/source/week-03/instructor/src/geomath_demo.c.html">src/geomath_demo.c</a></li><li><a href="/source/week-03/instructor/src/w01.c.html">src/w01.c</a></li><li><a href="/source/week-03/instructor/src/w02.c.html">src/w02.c</a></li><li><a href="/source/week-03/instructor/src/w03.c.html">src/w03.c</a></li><li><a href="/source/week-03/instructor/src/w04.c.html">src/w04.c</a></li><li><a href="/materials/week-03/instructor/validation.html">validation.md</a></li><li><a href="/materials/week-03/instructor/warmups.html">warmups.md</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-03/instructor.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const instructor = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  instructor as default
};
