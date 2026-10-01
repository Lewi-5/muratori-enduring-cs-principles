import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-13/support","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-13/support.md","filePath":"source-index/week-13/support.md"}');
const _sfc_main = { name: "source-index/week-13/support.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-13-support" tabindex="-1">Files: week-13/support <a class="header-anchor" href="#files-week-13-support" aria-label="Permalink to &quot;Files: week-13/support&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-13/support/bench.c.html">bench.c</a></li><li><a href="/source/week-13/support/counter.c.html">counter.c</a></li><li><a href="/source/week-13/support/geolab_types.h.html">geolab_types.h</a></li><li><a href="/source/week-13/support/kernel.c.html">kernel.c</a></li><li><a href="/source/week-13/support/kernel.h.html">kernel.h</a></li><li><a href="/source/week-13/support/playground.c.html">playground.c</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-13/support.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const support = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  support as default
};
