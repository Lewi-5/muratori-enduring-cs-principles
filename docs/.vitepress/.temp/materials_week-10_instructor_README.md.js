import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 10 instructor materials","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-10/instructor/README.md","filePath":"materials/week-10/instructor/README.md"}');
const _sfc_main = { name: "materials/week-10/instructor/README.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-10-instructor-materials" tabindex="-1">Week 10 instructor materials <a class="header-anchor" href="#week-10-instructor-materials" aria-label="Permalink to &quot;Week 10 instructor materials&quot;">​</a></h1><p>Keep these files separate while learners attempt the assignment. <a href="/materials/week-10/instructor/answers.html">answers</a> covers every core, practice and stretch prompt; <a href="/materials/week-10/instructor/observations.html">observations</a> gives a complete notebook exemplar; <a href="/materials/week-10/instructor/warmups.html">warmups</a> and <a href="/materials/week-10/instructor/reading-answers.html">reading answers</a> complete the beginner layers.</p><p>The four files in src are annotated working reference implementations. The runner uses a local Machine; the step also uses a local Machine, so an invalid RET or exhausted run cannot leak popped SP or earlier data writes. This favors clear transaction boundaries over host throughput. The boundary scan is intentionally repeated by machine_step; S02 explains an optimization that retains the contract.</p><p>From week-10 run <code>make verify</code>. <a href="/materials/week-10/instructor/coverage.html">Coverage</a> maps requests to answers and <a href="/materials/week-10/instructor/validation.html">validation</a> records actual commands and outcomes. Passing checks establish these fixtures and domains, not all historical opcodes, real segmentation or modern CPU performance.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-10/instructor/README.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const README = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  README as default
};
