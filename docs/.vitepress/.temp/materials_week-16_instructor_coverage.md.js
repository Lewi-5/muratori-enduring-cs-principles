import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Coverage","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-16/instructor/coverage.md","filePath":"materials/week-16/instructor/coverage.md"}');
const _sfc_main = { name: "materials/week-16/instructor/coverage.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="coverage" tabindex="-1">Coverage <a class="header-anchor" href="#coverage" aria-label="Permalink to &quot;Coverage&quot;">​</a></h1><p>The inventory checks 29 unique prompt/answer pairs: five C/Q exercise pairs, six practice, two stretch, five notebook, three warm-up and three reading prompts. Full typed C reference implementations, conceptual reasoning, worked predictions, complete stretch designs and notebook exemplars are separate from learner files. tests/contracts.c, warm-ups, deterministic playground and checked beginner snippet complement these answers. Workload estimates remain unpiloted.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-16/instructor/coverage.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const coverage = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  coverage as default
};
