import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-13/instructor/evidence","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-13/instructor/evidence.md","filePath":"source-index/week-13/instructor/evidence.md"}');
const _sfc_main = { name: "source-index/week-13/instructor/evidence.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-13-instructor-evidence" tabindex="-1">Files: week-13/instructor/evidence <a class="header-anchor" href="#files-week-13-instructor-evidence" aria-label="Permalink to &quot;Files: week-13/instructor/evidence&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-13/instructor/evidence/clang-debug/manifest.json.html">clang-debug/manifest.json</a></li><li><a href="/source/week-13/instructor/evidence/clang-debug/raw.csv.html">clang-debug/raw.csv</a></li><li><a href="/source/week-13/instructor/evidence/clang-optimized/manifest.json.html">clang-optimized/manifest.json</a></li><li><a href="/source/week-13/instructor/evidence/clang-optimized/raw.csv.html">clang-optimized/raw.csv</a></li><li><a href="/source/week-13/instructor/evidence/gcc-debug/manifest.json.html">gcc-debug/manifest.json</a></li><li><a href="/source/week-13/instructor/evidence/gcc-debug/raw.csv.html">gcc-debug/raw.csv</a></li><li><a href="/source/week-13/instructor/evidence/gcc-optimized/manifest.json.html">gcc-optimized/manifest.json</a></li><li><a href="/source/week-13/instructor/evidence/gcc-optimized/raw.csv.html">gcc-optimized/raw.csv</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-13/instructor/evidence.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const evidence = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  evidence as default
};
