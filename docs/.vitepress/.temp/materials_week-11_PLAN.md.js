import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 11 implementation specification","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-11/PLAN.md","filePath":"materials/week-11/PLAN.md"}');
const _sfc_main = { name: "materials/week-11/PLAN.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-11-implementation-specification" tabindex="-1">Week 11 implementation specification <a class="header-anchor" href="#week-11-implementation-specification" aria-label="Permalink to &quot;Week 11 implementation specification&quot;">​</a></h1><p>Parent: <a href="/materials/PLAN.html">course plan</a>. Status: implemented; <a href="/materials/week-11/instructor/validation.html">validation</a> records evidence. Workload remains unpiloted.</p><p>Compare completed geolab functions at O0/O2 under System V AMD64 LP64, preserving C behavior and independent compiler artifacts. Teach GP/SSE scalar argument classes, pointer outputs versus return registers, register ownership, entry versus post-prologue offsets, alignment, indirect calls, optimized-away locals, object relocations and return prediction versus architectural data.</p><p>Deliver four typed learner C modules, five paired core exercises, six practice, two stretch, five report prompts, three warm-ups and three reading questions with full separate code/written solutions. Supply at most one 10–20-line handwritten assembly probe (this package has one 16-line probe), all other substantial code in C, deterministic behavioral tests, exact checked beginner output, seven-text cross-reference and six reference configurations. Do not test a universal compiler listing, predictor size or speedup. The planner is deliberately restricted and must not claim aggregate/variadic ABI support.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-11/PLAN.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const PLAN = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  PLAN as default
};
