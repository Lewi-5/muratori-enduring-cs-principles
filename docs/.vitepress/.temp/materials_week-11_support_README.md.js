import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Supplied observation subjects","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-11/support/README.md","filePath":"materials/week-11/support/README.md"}');
const _sfc_main = { name: "materials/week-11/support/README.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="supplied-observation-subjects" tabindex="-1">Supplied observation subjects <a class="header-anchor" href="#supplied-observation-subjects" aria-label="Permalink to &quot;Supplied observation subjects&quot;">​</a></h1><p>geolab/geo.c, query.c, geolab.h, geo_consts.h and geolab_types.h are byte-for-byte completed Week 5 prerequisites. Only geo/query are compiled; unrelated CSV/CLI declarations in the pinned header do not require those implementations to link. These functions are the real geolab comparison subjects, not replacement toy versions.</p><p>local.c is a supplied optimizer observation subject; playground.c supplies fixed inputs and consumes outputs. No Week 11 learner answer is compiled from instructor. The separate optional probe explicitly uses instructor/probe.S and is never part of the default learner build.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-11/support/README.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const README = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  README as default
};
