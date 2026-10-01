import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Generated fixture expectations","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-05/instructor/fixtures/expected.md","filePath":"source-index/week-05/instructor/fixtures/expected.md"}');
const _sfc_main = { name: "source-index/week-05/instructor/fixtures/expected.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="generated-fixture-expectations" tabindex="-1">Generated fixture expectations <a class="header-anchor" href="#generated-fixture-expectations" aria-label="Permalink to &quot;Generated fixture expectations&quot;">​</a></h1><p>This directory is generated locally by the supplied oracle. From <code>week-05</code>, run <code>make PACKAGE=instructor expected</code> to recreate the reference outputs, or <code>make expected</code> for your learner fixtures. The website does not generate or substitute answers into your checkout. See the <a href="/materials/week-05/instructor/fixtures/README.html">fixture contract</a>.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-05/instructor/fixtures/expected.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const expected = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  expected as default
};
