import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: docs/examples/week-08","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/docs/examples/week-08.md","filePath":"source-index/docs/examples/week-08.md"}');
const _sfc_main = { name: "source-index/docs/examples/week-08.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-docs-examples-week-08" tabindex="-1">Files: docs/examples/week-08 <a class="header-anchor" href="#files-docs-examples-week-08" aria-label="Permalink to &quot;Files: docs/examples/week-08&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/docs/examples/week-08/state.c.html">state.c</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/docs/examples/week-08.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const week08 = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  week08 as default
};
