import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-09/fixtures","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-09/fixtures.md","filePath":"source-index/week-09/fixtures.md"}');
const _sfc_main = { name: "source-index/week-09/fixtures.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-09-fixtures" tabindex="-1">Files: week-09/fixtures <a class="header-anchor" href="#files-week-09-fixtures" aria-label="Permalink to &quot;Files: week-09/fixtures&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-09/fixtures/playground.txt.html">playground.txt</a></li><li><a href="/source/week-09/fixtures/program.hex.html">program.hex</a></li><li><a href="/source/week-09/fixtures/program.txt.html">program.txt</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-09/fixtures.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const fixtures = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  fixtures as default
};
