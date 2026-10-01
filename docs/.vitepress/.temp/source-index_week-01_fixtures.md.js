import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-01/fixtures","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-01/fixtures.md","filePath":"source-index/week-01/fixtures.md"}');
const _sfc_main = { name: "source-index/week-01/fixtures.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-01-fixtures" tabindex="-1">Files: week-01/fixtures <a class="header-anchor" href="#files-week-01-fixtures" aria-label="Permalink to &quot;Files: week-01/fixtures&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-01/fixtures/empty.txt.html">empty.txt</a></li><li><a href="/source/week-01/fixtures/no-final-newline.txt.html">no-final-newline.txt</a></li><li><a href="/source/week-01/fixtures/two-lines.txt.html">two-lines.txt</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-01/fixtures.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const fixtures = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  fixtures as default
};
