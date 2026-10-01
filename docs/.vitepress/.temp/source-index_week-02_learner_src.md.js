import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-02/learner/src","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-02/learner/src.md","filePath":"source-index/week-02/learner/src.md"}');
const _sfc_main = { name: "source-index/week-02/learner/src.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-02-learner-src" tabindex="-1">Files: week-02/learner/src <a class="header-anchor" href="#files-week-02-learner-src" aria-label="Permalink to &quot;Files: week-02/learner/src&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-02/learner/src/ex01.c.html">ex01.c</a></li><li><a href="/source/week-02/learner/src/ex02.c.html">ex02.c</a></li><li><a href="/source/week-02/learner/src/ex03.c.html">ex03.c</a></li><li><a href="/source/week-02/learner/src/ex04.c.html">ex04.c</a></li><li><a href="/source/week-02/learner/src/ex05.c.html">ex05.c</a></li><li><a href="/source/week-02/learner/src/ex06.c.html">ex06.c</a></li><li><a href="/source/week-02/learner/src/ex07.c.html">ex07.c</a></li><li><a href="/source/week-02/learner/src/ex08.c.html">ex08.c</a></li><li><a href="/source/week-02/learner/src/ex09_data.c.html">ex09_data.c</a></li><li><a href="/source/week-02/learner/src/ex09_data.h.html">ex09_data.h</a></li><li><a href="/source/week-02/learner/src/ex09_main.c.html">ex09_main.c</a></li><li><a href="/source/week-02/learner/src/ex10.c.html">ex10.c</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-02/learner/src.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const src = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  src as default
};
