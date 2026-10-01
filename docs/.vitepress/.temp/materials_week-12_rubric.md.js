import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Project 2 rubric","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-12/rubric.md","filePath":"materials/week-12/rubric.md"}');
const _sfc_main = { name: "materials/week-12/rubric.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="project-2-rubric" tabindex="-1">Project 2 rubric <a class="header-anchor" href="#project-2-rubric" aria-label="Permalink to &quot;Project 2 rubric&quot;">​</a></h1><p>100 points: E01 preparation/ownership 15; E02 complete execution and C validity 25; E03 bounded transaction 15; E04 trace/capacity/failure contracts 20; E05 and R01–R05 fixture independence, actual x64 comparison and model defense 25. Warm-ups/practice are ungraded, stretch optional.</p><p>Full credit requires correct code and a reasoned explanation. Host undefined behavior, incorrect original PUSH SP, partial state/trace leaks and forged expected output block credit for the affected correctness criterion until repaired. A warning-clean build alone is insufficient. Accept equivalent correct algorithms and different real compiler listings. No speedup or universal cycle threshold is imposed. A retained mistaken prediction plus a documented correction is valid evidence; silently rewriting the prediction loses report credit.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-12/rubric.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const rubric = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  rubric as default
};
