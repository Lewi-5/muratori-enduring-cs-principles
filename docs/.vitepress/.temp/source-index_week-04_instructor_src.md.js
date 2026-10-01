import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-04/instructor/src","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-04/instructor/src.md","filePath":"source-index/week-04/instructor/src.md"}');
const _sfc_main = { name: "source-index/week-04/instructor/src.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-04-instructor-src" tabindex="-1">Files: week-04/instructor/src <a class="header-anchor" href="#files-week-04-instructor-src" aria-label="Permalink to &quot;Files: week-04/instructor/src&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-04/instructor/src/ex01.c.html">ex01.c</a></li><li><a href="/source/week-04/instructor/src/ex02.c.html">ex02.c</a></li><li><a href="/source/week-04/instructor/src/ex03.c.html">ex03.c</a></li><li><a href="/source/week-04/instructor/src/ex04.c.html">ex04.c</a></li><li><a href="/source/week-04/instructor/src/ex05.c.html">ex05.c</a></li><li><a href="/source/week-04/instructor/src/ex06.c.html">ex06.c</a></li><li><a href="/source/week-04/instructor/src/ex07.c.html">ex07.c</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-04/instructor/src.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const src = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  src as default
};
