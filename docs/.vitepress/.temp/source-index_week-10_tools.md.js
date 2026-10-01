import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-10/tools","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-10/tools.md","filePath":"source-index/week-10/tools.md"}');
const _sfc_main = { name: "source-index/week-10/tools.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-10-tools" tabindex="-1">Files: week-10/tools <a class="header-anchor" href="#files-week-10-tools" aria-label="Permalink to &quot;Files: week-10/tools&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-10/tools/bootstrap.py.html">bootstrap.py</a></li><li><a href="/source/week-10/tools/register_docs.py.html">register_docs.py</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-10/tools.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const tools = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  tools as default
};
