import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Course background files","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/root.md","filePath":"source-index/root.md"}');
const _sfc_main = { name: "source-index/root.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="course-background-files" tabindex="-1">Course background files <a class="header-anchor" href="#course-background-files" aria-label="Permalink to &quot;Course background files&quot;">​</a></h1><ul><li><a href="/materials/PLAN.html">PLAN.md</a></li><li><a href="/materials/WRITINGFORBEGINNERS.html">WRITINGFORBEGINNERS.md</a></li><li><a href="/materials/analysis.html">analysis.md</a></li><li><a href="/source/computerEnhanceTOC.txt.html">computerEnhanceTOC.txt</a></li><li><a href="/source/handmadeHeroLessonList.txt.html">handmadeHeroLessonList.txt</a></li><li><a href="/source/rawTranscript.txt.html">rawTranscript.txt</a></li><li><a href="/source/relevantHHLessons.txt.html">relevantHHLessons.txt</a></li><li><a href="/materials/solPlan.html">solPlan.md</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/root.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const root = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  root as default
};
