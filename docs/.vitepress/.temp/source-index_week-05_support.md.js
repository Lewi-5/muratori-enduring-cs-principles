import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-05/support","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-05/support.md","filePath":"source-index/week-05/support.md"}');
const _sfc_main = { name: "source-index/week-05/support.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-05-support" tabindex="-1">Files: week-05/support <a class="header-anchor" href="#files-week-05-support" aria-label="Permalink to &quot;Files: week-05/support&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-05/support/envinfo.c.html">envinfo.c</a></li><li><a href="/source/week-05/support/envinfo.h.html">envinfo.h</a></li><li><a href="/source/week-05/support/geo_consts.h.html">geo_consts.h</a></li><li><a href="/source/week-05/support/geolab_types.h.html">geolab_types.h</a></li><li><a href="/source/week-05/support/monotonic.h.html">monotonic.h</a></li><li><a href="/source/week-05/support/platform.h.html">platform.h</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-05/support.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const support = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  support as default
};
