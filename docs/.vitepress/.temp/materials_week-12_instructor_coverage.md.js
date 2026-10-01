import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Prompt and artifact coverage","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-12/instructor/coverage.md","filePath":"materials/week-12/instructor/coverage.md"}');
const _sfc_main = { name: "materials/week-12/instructor/coverage.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="prompt-and-artifact-coverage" tabindex="-1">Prompt and artifact coverage <a class="header-anchor" href="#prompt-and-artifact-coverage" aria-label="Permalink to &quot;Prompt and artifact coverage&quot;">​</a></h1><p>tests/inventory.py checks all 29 prompt IDs and matching answers. E01.C–E05.Q, P01–P06 and S01–S02 are in answers.md; R01–R05 in observations.md; W01–W03 in warmups.md with typed learner/reference C and exhaustive tests; F01–F03 in reading-answers.md. Beginner check-yourself answers are in warmups.md.</p><p>E01–E04 reference modules are prepare/execute/run/trace.c. E05 has CHECKPOINT-2.md, supplied drivers, three original hand-derived fixtures, independent Python combined traces, real inspection tooling and instructor/report.md. Both written stretches have complete designs/protocols; neither asks for an unprovided C implementation or fabricated timing. Every displayed beginner output is generated from docs/examples/week-12/evidence.c and checked by tests/snippets.py.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-12/instructor/coverage.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const coverage = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  coverage as default
};
