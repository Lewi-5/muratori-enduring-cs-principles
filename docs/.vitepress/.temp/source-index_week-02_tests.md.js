import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-02/tests","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-02/tests.md","filePath":"source-index/week-02/tests.md"}');
const _sfc_main = { name: "source-index/week-02/tests.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-02-tests" tabindex="-1">Files: week-02/tests <a class="header-anchor" href="#files-week-02-tests" aria-label="Permalink to &quot;Files: week-02/tests&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-02/tests/check.py.html">check.py</a></li><li><a href="/source/week-02/tests/contracts.c.html">contracts.c</a></li><li><a href="/source/week-02/tests/faults.c.html">faults.c</a></li><li><a href="/source/week-02/tests/inventory.py.html">inventory.py</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-02/tests.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const tests = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  tests as default
};
