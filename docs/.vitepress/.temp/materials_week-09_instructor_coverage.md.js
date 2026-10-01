import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Prompt and artifact coverage","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-09/instructor/coverage.md","filePath":"materials/week-09/instructor/coverage.md"}');
const _sfc_main = { name: "materials/week-09/instructor/coverage.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="prompt-and-artifact-coverage" tabindex="-1">Prompt and artifact coverage <a class="header-anchor" href="#prompt-and-artifact-coverage" aria-label="Permalink to &quot;Prompt and artifact coverage&quot;">​</a></h1><p>tests/inventory.py checks all29 stable prompt IDs and matching separate answers: E01.C–E05.Q, P01–P06 and S01–S02 in answers.md; R01–R05 in observations.md; W01–W03 in warmups.md with typed learner/reference C and exhaustive tests; F01–F03 in reading-answers.md. Beginner check-yourself answers are in warmups.md.</p><p>E01–E04 reference code is src/address.c,decode.c,execute.c,run.c; E05 has supplied driver/playground and hand-derived fixture plus independent Python trace oracle. S01 has extras/predicates.c; S02 asks a written design and receives a complete ownership, invalidation, preparation, execution and equivalence-testing design. Every output on the beginner page comes from checked-in docs/examples/week-09/flow.c. No exercise requires unfinished Week10 code.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-09/instructor/coverage.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const coverage = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  coverage as default
};
