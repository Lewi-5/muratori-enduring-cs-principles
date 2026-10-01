import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 12 implementation contract","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-12/PLAN.md","filePath":"materials/week-12/PLAN.md"}');
const _sfc_main = { name: "materials/week-12/PLAN.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-12-implementation-contract" tabindex="-1">Week 12 implementation contract <a class="header-anchor" href="#week-12-implementation-contract" aria-label="Permalink to &quot;Week 12 implementation contract&quot;">​</a></h1><p>Project 2 integrates Weeks 6–11: a specified C decoder/simulator, golden byte-stream tests, complete state traces and actual x64 comparison. Apply the root PLAN and WRITINGFORBEGINNERS. Keep the Week 10 subset and policies; optimize ownership by preparing a reusable immutable boundary map without claiming a speedup.</p><p>Learner modules own prepare, execute, run and trace. Completed decoding, arithmetic and stack helpers are pinned prerequisites. The uncached predecessor is test-only, supplemented by independent mathematical predicates/flags and hand-derived fixtures. Every failure preserves caller state and required outputs; capacity failure follows successful execution validation.</p><p>Deliver five paired graded prompts, six practice problems, two stretches, five notebook entries, three typed/tested warm-ups, three reading questions, complete separate code/written answers, checkpoint manifest, report exemplar, beginner chapter and guided readings mapped to seven texts. Six compiler configurations, four inspection sets, negative scaffolds, snippets, citations and site checks are gates. Estimates remain unpiloted.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-12/PLAN.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const PLAN = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  PLAN as default
};
