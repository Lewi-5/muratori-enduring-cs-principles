import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-12/support/geolab","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-12/support/geolab.md","filePath":"source-index/week-12/support/geolab.md"}');
const _sfc_main = { name: "source-index/week-12/support/geolab.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-12-support-geolab" tabindex="-1">Files: week-12/support/geolab <a class="header-anchor" href="#files-week-12-support-geolab" aria-label="Permalink to &quot;Files: week-12/support/geolab&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-12/support/geolab/geo.c.html">geo.c</a></li><li><a href="/source/week-12/support/geolab/geo_consts.h.html">geo_consts.h</a></li><li><a href="/source/week-12/support/geolab/geolab.h.html">geolab.h</a></li><li><a href="/source/week-12/support/geolab/geolab_types.h.html">geolab_types.h</a></li><li><a href="/source/week-12/support/geolab/query.c.html">query.c</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-12/support/geolab.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const geolab = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  geolab as default
};
