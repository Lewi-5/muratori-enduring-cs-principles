import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 14 implementation plan","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-14/PLAN.md","filePath":"materials/week-14/PLAN.md"}');
const _sfc_main = { name: "materials/week-14/PLAN.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-14-implementation-plan" tabindex="-1">Week 14 implementation plan <a class="header-anchor" href="#week-14-implementation-plan" aria-label="Permalink to &quot;Week 14 implementation plan&quot;">​</a></h1><p>Inclusive time, exclusive time and measurement overhead. Implement the bounded original APIs in E01–E04, then E05 integrates deterministic evidence and actual timing. Read README for the 600-minute unpiloted core allocation and use the website’s explicit viewing portions. Preserve raw observations, claims and limits separately. The predecessor contract is pinned in support; build artifacts are regenerated locally, not hand-authored expected assembly.</p><p>Acceptance: six compiler/mode reference gates, four inspect manifests, intentional learner failures, exact snippets,29 matched prompts, raw timing captures and complete separate answers. No performance threshold or universal host-clock assertion is an acceptance condition.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-14/PLAN.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const PLAN = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  PLAN as default
};
