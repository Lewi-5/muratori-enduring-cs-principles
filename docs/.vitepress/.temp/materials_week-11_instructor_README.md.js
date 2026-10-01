import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 11 instructor materials","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-11/instructor/README.md","filePath":"materials/week-11/instructor/README.md"}');
const _sfc_main = { name: "materials/week-11/instructor/README.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-11-instructor-materials" tabindex="-1">Week 11 instructor materials <a class="header-anchor" href="#week-11-instructor-materials" aria-label="Permalink to &quot;Week 11 instructor materials&quot;">​</a></h1><p>Learners attempt their modules and annotations before opening this package. <a href="/materials/week-11/instructor/answers.html">Answers</a> covers E01.C–E05.Q, six practice and two stretch prompts. <a href="/materials/week-11/instructor/observations.html">Notebook</a>, <a href="/materials/week-11/instructor/warmups.html">warm-ups</a> and <a href="/materials/week-11/instructor/reading-answers.html">reading answers</a> complete every other request. <a href="/materials/week-11/instructor/coverage.html">Coverage</a> records stable IDs; <a href="/materials/week-11/instructor/validation.html">validation</a> records actual checks.</p><p>Reference C lives in src. Completed support/geolab is unchanged Week 5 code. The separate 16-line probe.S is the package&#39;s only handwritten assembly, not part of default learner compilation. Instructor sample-assembly contains actual recorded object listings and manifests; only the leading object path is normalized for portability. Treat those samples as dated evidence, not normative compiler output. Run <code>make verify</code> and regenerate your own <code>make inspect</code> observations.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-11/instructor/README.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const README = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  README as default
};
