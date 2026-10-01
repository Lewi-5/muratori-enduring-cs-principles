import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Coverage","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-11/instructor/coverage.md","filePath":"materials/week-11/instructor/coverage.md"}');
const _sfc_main = { name: "materials/week-11/instructor/coverage.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="coverage" tabindex="-1">Coverage <a class="header-anchor" href="#coverage" aria-label="Permalink to &quot;Coverage&quot;">​</a></h1><p>tests/inventory.py checks 29 unique learner prompts against matching separate answers: E01.C–E05.Q, P01–P06, S01–S02, R01–R05, W01–W03 and F01–F03. Four reference C modules implement the checked assignment APIs. The local-example and actual geolab subjects are supplied prerequisites. One optional 16-line probe has an independent C harness.</p><p>answers.md contains all core/practice/stretch reasoning, a full scalar mapping table, an inlining experiment protocol and a worked mixed-class aggregate example outside the planner. observations.md includes the stack diagram, concrete artifact interpretations and complete report structure. warmups.md answers the beginner check-yourself prompts as well as each typed warm-up. reading-answers.md covers all cross-reference questions. Dated sample artifacts and tests complement written solutions; no universal listing or speed is imposed.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-11/instructor/coverage.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const coverage = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  coverage as default
};
