import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-01/instructor","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-01/instructor.md","filePath":"source-index/week-01/instructor.md"}');
const _sfc_main = { name: "source-index/week-01/instructor.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-01-instructor" tabindex="-1">Files: week-01/instructor <a class="header-anchor" href="#files-week-01-instructor" aria-label="Permalink to &quot;Files: week-01/instructor&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/materials/week-01/instructor/README.html">README.md</a></li><li><a href="/materials/week-01/instructor/answers.html">answers.md</a></li><li><a href="/materials/week-01/instructor/coverage.html">coverage.md</a></li><li><a href="/source/week-01/instructor/extras/practice_sizeof.c.html">extras/practice_sizeof.c</a></li><li><a href="/source/week-01/instructor/extras/stretch_lines.c.html">extras/stretch_lines.c</a></li><li><a href="/materials/week-01/instructor/observations.html">observations.md</a></li><li><a href="/materials/week-01/instructor/reading-answers.html">reading-answers.md</a></li><li><a href="/source/week-01/instructor/src/ex01.c.html">src/ex01.c</a></li><li><a href="/source/week-01/instructor/src/ex02.c.html">src/ex02.c</a></li><li><a href="/source/week-01/instructor/src/ex03.c.html">src/ex03.c</a></li><li><a href="/source/week-01/instructor/src/ex04.c.html">src/ex04.c</a></li><li><a href="/source/week-01/instructor/src/ex05.c.html">src/ex05.c</a></li><li><a href="/source/week-01/instructor/src/ex06.c.html">src/ex06.c</a></li><li><a href="/source/week-01/instructor/src/ex07.c.html">src/ex07.c</a></li><li><a href="/source/week-01/instructor/src/ex08.c.html">src/ex08.c</a></li><li><a href="/source/week-01/instructor/src/ex09.c.html">src/ex09.c</a></li><li><a href="/source/week-01/instructor/src/ex10.c.html">src/ex10.c</a></li><li><a href="/source/week-01/instructor/src/ex11.c.html">src/ex11.c</a></li><li><a href="/source/week-01/instructor/src/ex12.c.html">src/ex12.c</a></li><li><a href="/source/week-01/instructor/src/ex13.c.html">src/ex13.c</a></li><li><a href="/source/week-01/instructor/src/ex14_count.c.html">src/ex14_count.c</a></li><li><a href="/source/week-01/instructor/src/ex14_count.h.html">src/ex14_count.h</a></li><li><a href="/source/week-01/instructor/src/ex14_main.c.html">src/ex14_main.c</a></li><li><a href="/source/week-01/instructor/src/ex15.c.html">src/ex15.c</a></li><li><a href="/source/week-01/instructor/src/w01.c.html">src/w01.c</a></li><li><a href="/source/week-01/instructor/src/w02.c.html">src/w02.c</a></li><li><a href="/source/week-01/instructor/src/w03.c.html">src/w03.c</a></li><li><a href="/source/week-01/instructor/src/w04.c.html">src/w04.c</a></li><li><a href="/materials/week-01/instructor/validation.html">validation.md</a></li><li><a href="/materials/week-01/instructor/warmups.html">warmups.md</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-01/instructor.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const instructor = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  instructor as default
};
