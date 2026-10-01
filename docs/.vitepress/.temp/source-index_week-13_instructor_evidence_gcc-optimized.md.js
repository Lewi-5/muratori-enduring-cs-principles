import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-13/instructor/evidence/gcc-optimized","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-13/instructor/evidence/gcc-optimized.md","filePath":"source-index/week-13/instructor/evidence/gcc-optimized.md"}');
const _sfc_main = { name: "source-index/week-13/instructor/evidence/gcc-optimized.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-13-instructor-evidence-gcc-optimized" tabindex="-1">Files: week-13/instructor/evidence/gcc-optimized <a class="header-anchor" href="#files-week-13-instructor-evidence-gcc-optimized" aria-label="Permalink to &quot;Files: week-13/instructor/evidence/gcc-optimized&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-13/instructor/evidence/gcc-optimized/manifest.json.html">manifest.json</a></li><li><a href="/source/week-13/instructor/evidence/gcc-optimized/raw.csv.html">raw.csv</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-13/instructor/evidence/gcc-optimized.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const gccOptimized = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  gccOptimized as default
};
