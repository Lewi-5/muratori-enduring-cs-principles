import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Completed prerequisites and comparison subjects","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-12/support/README.md","filePath":"materials/week-12/support/README.md"}');
const _sfc_main = { name: "materials/week-12/support/README.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="completed-prerequisites-and-comparison-subjects" tabindex="-1">Completed prerequisites and comparison subjects <a class="header-anchor" href="#completed-prerequisites-and-comparison-subjects" aria-label="Permalink to &quot;Completed prerequisites and comparison subjects&quot;">​</a></h1><p>decoder and alu are completed Week 7/8 snapshots. machine/decode.c and stack.c are the Week 10 completed decoder and stack helpers. Their source is unchanged; include/machine.h extends the common status list with M_CAPACITY and directs new execution through project.h.</p><p>oracle/execute.c and run.c are pinned Week 10 comparison implementations. They are linked only into the contract harness, never learner or production executables. A comparison against these shares helpers and reasoning, so it is supplemented by mathematical cases and hand-derived traces rather than claimed as an independent hardware oracle.</p><p>geolab supplies the Week 5 geo/query implementation already pinned in Week 11. compare.c is an original defined-C comparison subject, not a simulator solution. All simulator and substantial assignment software remains C; no new handwritten assembly is introduced.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-12/support/README.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const README = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  README as default
};
