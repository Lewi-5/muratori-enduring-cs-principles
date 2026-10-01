import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-14/instructor/evidence/clang-debug","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-14/instructor/evidence/clang-debug.md","filePath":"source-index/week-14/instructor/evidence/clang-debug.md"}');
const _sfc_main = { name: "source-index/week-14/instructor/evidence/clang-debug.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-14-instructor-evidence-clang-debug" tabindex="-1">Files: week-14/instructor/evidence/clang-debug <a class="header-anchor" href="#files-week-14-instructor-evidence-clang-debug" aria-label="Permalink to &quot;Files: week-14/instructor/evidence/clang-debug&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-14/instructor/evidence/clang-debug/manifest.json.html">manifest.json</a></li><li><a href="/source/week-14/instructor/evidence/clang-debug/outer/manifest.json.html">outer/manifest.json</a></li><li><a href="/source/week-14/instructor/evidence/clang-debug/outer/raw.csv.html">outer/raw.csv</a></li><li><a href="/source/week-14/instructor/evidence/clang-debug/raw.csv.html">raw.csv</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-14/instructor/evidence/clang-debug.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const clangDebug = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  clangDebug as default
};
