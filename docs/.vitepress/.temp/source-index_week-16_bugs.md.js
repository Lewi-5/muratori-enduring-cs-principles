import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-16/bugs","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-16/bugs.md","filePath":"source-index/week-16/bugs.md"}');
const _sfc_main = { name: "source-index/week-16/bugs.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-16-bugs" tabindex="-1">Files: week-16/bugs <a class="header-anchor" href="#files-week-16-bugs" aria-label="Permalink to &quot;Files: week-16/bugs&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-16/bugs/double_free.c.html">double_free.c</a></li><li><a href="/source/week-16/bugs/return_local.c.html">return_local.c</a></li><li><a href="/source/week-16/bugs/use_after_free.c.html">use_after_free.c</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-16/bugs.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const bugs = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  bugs as default
};
