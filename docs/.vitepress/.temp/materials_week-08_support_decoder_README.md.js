import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Supplied prerequisite decoder","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-08/support/decoder/README.md","filePath":"materials/week-08/support/decoder/README.md"}');
const _sfc_main = { name: "materials/week-08/support/decoder/README.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="supplied-prerequisite-decoder" tabindex="-1">Supplied prerequisite decoder <a class="header-anchor" href="#supplied-prerequisite-decoder" aria-label="Permalink to &quot;Supplied prerequisite decoder&quot;">​</a></h1><p>Pinned, unchanged copies of Week 7&#39;s completed address.c, decode.c, format.c and headers. Both learner and instructor builds use this decoder. It is prerequisite infrastructure, not a solution to Week 8&#39;s register or arithmetic exercises. Revision remains 7; the simulator has a separate API. Week 7&#39;s complete stream/CLI/shared-library examples remain in that package.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-08/support/decoder/README.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const README = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  README as default
};
