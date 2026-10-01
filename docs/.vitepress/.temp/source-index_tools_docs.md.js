import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: tools/docs","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/tools/docs.md","filePath":"source-index/tools/docs.md"}');
const _sfc_main = { name: "source-index/tools/docs.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-tools-docs" tabindex="-1">Files: tools/docs <a class="header-anchor" href="#files-tools-docs" aria-label="Permalink to &quot;Files: tools/docs&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/tools/docs/check_readings.py.html">check_readings.py</a></li><li><a href="/source/tools/docs/readings.json.html">readings.json</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/tools/docs.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const docs = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  docs as default
};
