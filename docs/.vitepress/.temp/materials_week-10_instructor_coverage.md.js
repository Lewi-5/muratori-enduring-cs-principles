import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Coverage","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-10/instructor/coverage.md","filePath":"materials/week-10/instructor/coverage.md"}');
const _sfc_main = { name: "materials/week-10/instructor/coverage.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="coverage" tabindex="-1">Coverage <a class="header-anchor" href="#coverage" aria-label="Permalink to &quot;Coverage&quot;">​</a></h1><p>Stable prompt IDs are checked by tests/inventory.py. E01–E04 have working reference C in src/stack.c, decode.c, execute.c and run.c; E05 uses the supplied driver/playground and golden fixture. E01.C–E05.Q, P01–P06 and S01–S02 are answered in answers.md. R01–R05 are answered in observations.md; W01–W03 in warmups.md with separate typed C reference files and tests; F01–F03 in reading-answers.md.</p><p>The beginner&#39;s check-yourself prompts are answered in warmups.md. Hand-derived stack diagrams and flag values appear in answers.md and observations.md. Open-ended cache design has a complete preparation algorithm and equivalence-validation method. Workload recording accepts actual measured experience rather than supplying fictional pilot hours.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-10/instructor/coverage.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const coverage = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  coverage as default
};
