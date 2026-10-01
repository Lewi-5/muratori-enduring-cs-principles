import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 16 instructor materials","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-16/instructor/README.md","filePath":"materials/week-16/instructor/README.md"}');
const _sfc_main = { name: "materials/week-16/instructor/README.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-16-instructor-materials" tabindex="-1">Week 16 instructor materials <a class="header-anchor" href="#week-16-instructor-materials" aria-label="Permalink to &quot;Week 16 instructor materials&quot;">​</a></h1><p>Attempt the learner package before using these files. <a href="/materials/week-16/instructor/answers.html">Answers</a>, <a href="/materials/week-16/instructor/observations.html">notebook exemplars</a>, <a href="/materials/week-16/instructor/warmups.html">warm-ups</a> and <a href="/materials/week-16/instructor/reading-answers.html">reading answers</a> cover every numbered prompt. Reference C lives in src; the default build uses separate learner stubs. <a href="/materials/week-16/instructor/validation.html">Validation</a> records actual evidence and limits.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-16/instructor/README.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const README = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  README as default
};
