import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Completed prerequisite code","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-09/support/README.md","filePath":"materials/week-09/support/README.md"}');
const _sfc_main = { name: "materials/week-09/support/README.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="completed-prerequisite-code" tabindex="-1">Completed prerequisite code <a class="header-anchor" href="#completed-prerequisite-code" aria-label="Permalink to &quot;Completed prerequisite code&quot;">​</a></h1><p>decoder contains Week 7 revision-7 decode/format/address implementation and headers; alu contains Week 8 register aliases and arithmetic flags. These are completed prerequisite snapshots, not Week 9 solutions. Week 9 builds independently of Week 10, with the same flat data-memory and immutable-code teaching policies. No binary compatibility with Week 10&#39;s extended Machine struct is promised.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-09/support/README.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const README = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  README as default
};
