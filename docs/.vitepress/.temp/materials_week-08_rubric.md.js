import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 8 rubric","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-08/rubric.md","filePath":"materials/week-08/rubric.md"}');
const _sfc_main = { name: "materials/week-08/rubric.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-8-rubric" tabindex="-1">Week 8 rubric <a class="header-anchor" href="#week-8-rubric" aria-label="Permalink to &quot;Week 8 rubric&quot;">​</a></h1><p>One graded assignment; correctness and explanation determine acceptance.</p><table tabindex="0"><thead><tr><th>Work</th><th>Points</th><th>Required evidence</th></tr></thead><tbody><tr><td>E01 register views</td><td>15</td><td>correct tables, preserving other byte, checked invalid input</td></tr><tr><td>E02 arithmetic</td><td>25</td><td>both widths, all six flags, defined host arithmetic</td></tr><tr><td>E03 execution</td><td>20</td><td>pre-state operands, MOV/CMP behavior, width/field checks, IP and failure preservation</td></tr><tr><td>E04 program</td><td>15</td><td>separate cursor, error distinctions, empty/capped input, whole-program rollback</td></tr><tr><td>E05 and R01–R05</td><td>25</td><td>hand predictions, complete traces, reproducible checks, mechanism and uncertainty</td></tr></tbody></table><p>Pass at 70 points with no unresolved bounds error, register-alias defect, flag-semantic error or transaction violation. Core explanation is required in addition to passing code. Beginner warm-ups, reading questions, practice and stretch are formative and have complete separate answers. No speedup, cycle count or modern-hardware timing requirement applies.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-08/rubric.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const rubric = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  rubric as default
};
