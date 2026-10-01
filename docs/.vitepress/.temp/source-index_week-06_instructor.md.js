import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-06/instructor","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-06/instructor.md","filePath":"source-index/week-06/instructor.md"}');
const _sfc_main = { name: "source-index/week-06/instructor.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-06-instructor" tabindex="-1">Files: week-06/instructor <a class="header-anchor" href="#files-week-06-instructor" aria-label="Permalink to &quot;Files: week-06/instructor&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/materials/week-06/instructor/README.html">README.md</a></li><li><a href="/materials/week-06/instructor/answers.html">answers.md</a></li><li><a href="/source/week-06/instructor/cases.txt.html">cases.txt</a></li><li><a href="/materials/week-06/instructor/coverage.html">coverage.md</a></li><li><a href="/source/week-06/instructor/extras/mutate.py.html">extras/mutate.py</a></li><li><a href="/source/week-06/instructor/extras/s01_jumps.c.html">extras/s01_jumps.c</a></li><li><a href="/source/week-06/instructor/extras/s02_table.c.html">extras/s02_table.c</a></li><li><a href="/materials/week-06/instructor/observations.html">observations.md</a></li><li><a href="/source/week-06/instructor/src/decode.c.html">src/decode.c</a></li><li><a href="/source/week-06/instructor/src/decode.h.html">src/decode.h</a></li><li><a href="/source/week-06/instructor/src/decode8086.c.html">src/decode8086.c</a></li><li><a href="/source/week-06/instructor/src/ex01.c.html">src/ex01.c</a></li><li><a href="/source/week-06/instructor/src/ex02.c.html">src/ex02.c</a></li><li><a href="/source/week-06/instructor/src/ex03.c.html">src/ex03.c</a></li><li><a href="/source/week-06/instructor/src/ex04.c.html">src/ex04.c</a></li><li><a href="/source/week-06/instructor/src/ex05.c.html">src/ex05.c</a></li><li><a href="/materials/week-06/instructor/validation.html">validation.md</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-06/instructor.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const instructor = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  instructor as default
};
