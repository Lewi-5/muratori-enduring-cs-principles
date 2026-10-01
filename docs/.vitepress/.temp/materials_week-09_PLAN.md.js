import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 9 implementation contract","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-09/PLAN.md","filePath":"materials/week-09/PLAN.md"}');
const _sfc_main = { name: "materials/week-09/PLAN.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-9-implementation-contract" tabindex="-1">Week 9 implementation contract <a class="header-anchor" href="#week-9-implementation-contract" aria-label="Permalink to &quot;Week 9 implementation contract&quot;">​</a></h1><p>Follow the root PLAN and WRITINGFORBEGINNERS. Extend Week 8 state changes with memory and instruction fetch controlled by IP; reuse pinned Week 7 decoder and Week 8 aliases/ALU. Match Week 10&#39;s separate immutable code, flat 64KiB data, wrapping data words, boundary checks, full predecode, positive budget and whole-state transactions; exclude stack operations and their state fields.</p><p>Deliver four typed learner modules, supplied driver/playground, five graded prompts with C and written parts, six practice problems, two stretches, five notebook entries, three tested warm-ups and three reading questions, complete separate answers and original beginner/further-reading chapters. Gate on six GCC/Clang configurations, negative learner checks, independent flag/loop oracles, hand-derived traces, byte bounds, rollback and documentation checks. Record actual validation separately; workload estimates remain unpiloted.</p><p>No deployment, commits or changes to another team&#39;s authored week are necessary. Source registry additions preserve other weeks. Week 10 keeps its own pinned prerequisite implementations and separate header; the handoff is a shared mechanism and source contract, not a binary ABI promise.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-09/PLAN.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const PLAN = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  PLAN as default
};
