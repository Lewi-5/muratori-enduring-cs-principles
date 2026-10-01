import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-13/instructor","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-13/instructor.md","filePath":"source-index/week-13/instructor.md"}');
const _sfc_main = { name: "source-index/week-13/instructor.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-13-instructor" tabindex="-1">Files: week-13/instructor <a class="header-anchor" href="#files-week-13-instructor" aria-label="Permalink to &quot;Files: week-13/instructor&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/materials/week-13/instructor/answers.html">answers.md</a></li><li><a href="/materials/week-13/instructor/coverage.html">coverage.md</a></li><li><a href="/source/week-13/instructor/evidence/clang-debug/manifest.json.html">evidence/clang-debug/manifest.json</a></li><li><a href="/source/week-13/instructor/evidence/clang-debug/raw.csv.html">evidence/clang-debug/raw.csv</a></li><li><a href="/source/week-13/instructor/evidence/clang-optimized/manifest.json.html">evidence/clang-optimized/manifest.json</a></li><li><a href="/source/week-13/instructor/evidence/clang-optimized/raw.csv.html">evidence/clang-optimized/raw.csv</a></li><li><a href="/source/week-13/instructor/evidence/gcc-debug/manifest.json.html">evidence/gcc-debug/manifest.json</a></li><li><a href="/source/week-13/instructor/evidence/gcc-debug/raw.csv.html">evidence/gcc-debug/raw.csv</a></li><li><a href="/source/week-13/instructor/evidence/gcc-optimized/manifest.json.html">evidence/gcc-optimized/manifest.json</a></li><li><a href="/source/week-13/instructor/evidence/gcc-optimized/raw.csv.html">evidence/gcc-optimized/raw.csv</a></li><li><a href="/materials/week-13/instructor/observations.html">observations.md</a></li><li><a href="/materials/week-13/instructor/reading-answers.html">reading-answers.md</a></li><li><a href="/materials/week-13/instructor/report.html">report.md</a></li><li><a href="/source/week-13/instructor/src/clock.c.html">src/clock.c</a></li><li><a href="/source/week-13/instructor/src/rate.c.html">src/rate.c</a></li><li><a href="/source/week-13/instructor/src/sample.c.html">src/sample.c</a></li><li><a href="/source/week-13/instructor/src/summary.c.html">src/summary.c</a></li><li><a href="/source/week-13/instructor/src/w01.c.html">src/w01.c</a></li><li><a href="/source/week-13/instructor/src/w02.c.html">src/w02.c</a></li><li><a href="/source/week-13/instructor/src/w03.c.html">src/w03.c</a></li><li><a href="/materials/week-13/instructor/validation.html">validation.md</a></li><li><a href="/materials/week-13/instructor/warmups.html">warmups.md</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-13/instructor.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const instructor = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  instructor as default
};
