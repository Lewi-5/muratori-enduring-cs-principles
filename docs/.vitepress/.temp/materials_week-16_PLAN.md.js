import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 16 specification","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-16/PLAN.md","filePath":"materials/week-16/PLAN.md"}');
const _sfc_main = { name: "materials/week-16/PLAN.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-16-specification" tabindex="-1">Week 16 specification <a class="header-anchor" href="#week-16-specification" aria-label="Permalink to &quot;Week 16 specification&quot;">​</a></h1><p>Parent: <a href="/materials/PLAN.html">course specification</a>. Status: implemented; compiler and correctness validation passed.</p><p>Trace automatic, static and allocated objects, repair returned-local and ownership mistakes, implement failure-atomic allocation operations and interpret isolated diagnostics.</p><p>Deliver learner stubs, full separate reference code and reasoning, 29 matched prompts, three tested warm-ups, checked beginner output, seven-text cross-reference, deterministic tests and six GCC/Clang configurations. No universal speed or compiler listing threshold. Core budget 600 minutes, unpiloted; beginner preparation adds 2–4 hours.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-16/PLAN.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const PLAN = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  PLAN as default
};
