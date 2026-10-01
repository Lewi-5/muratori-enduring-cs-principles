import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: docs/examples","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/docs/examples.md","filePath":"source-index/docs/examples.md"}');
const _sfc_main = { name: "source-index/docs/examples.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-docs-examples" tabindex="-1">Files: docs/examples <a class="header-anchor" href="#files-docs-examples" aria-label="Permalink to &quot;Files: docs/examples&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/docs/examples/week-01/array_size.c.html">week-01/array_size.c</a></li><li><a href="/source/docs/examples/week-01/clock_res.c.html">week-01/clock_res.c</a></li><li><a href="/source/docs/examples/week-01/display.c.html">week-01/display.c</a></li><li><a href="/source/docs/examples/week-01/layout.c.html">week-01/layout.c</a></li><li><a href="/source/docs/examples/week-01/safe_divide.c.html">week-01/safe_divide.c</a></li><li><a href="/source/docs/examples/week-01/trace.c.html">week-01/trace.c</a></li><li><a href="/source/docs/examples/week-01/wrap.c.html">week-01/wrap.c</a></li><li><a href="/source/docs/examples/week-03/big_product.c.html">week-03/big_product.c</a></li><li><a href="/source/docs/examples/week-03/exact_tenth.c.html">week-03/exact_tenth.c</a></li><li><a href="/source/docs/examples/week-03/fields.c.html">week-03/fields.c</a></li><li><a href="/source/docs/examples/week-03/point_three.c.html">week-03/point_three.c</a></li><li><a href="/source/docs/examples/week-03/spacing.c.html">week-03/spacing.c</a></li><li><a href="/source/docs/examples/week-03/tiny_angle.c.html">week-03/tiny_angle.c</a></li><li><a href="/source/docs/examples/week-07/address.c.html">week-07/address.c</a></li><li><a href="/source/docs/examples/week-08/state.c.html">week-08/state.c</a></li><li><a href="/source/docs/examples/week-09/flow.c.html">week-09/flow.c</a></li><li><a href="/source/docs/examples/week-10/stack_word.c.html">week-10/stack_word.c</a></li><li><a href="/source/docs/examples/week-11/local_value.c.html">week-11/local_value.c</a></li><li><a href="/source/docs/examples/week-12/evidence.c.html">week-12/evidence.c</a></li><li><a href="/source/docs/examples/week-13/interval.c.html">week-13/interval.c</a></li><li><a href="/source/docs/examples/week-14/nested.c.html">week-14/nested.c</a></li><li><a href="/source/docs/examples/week-15/example.c.html">week-15/example.c</a></li><li><a href="/source/docs/examples/week-16/example.c.html">week-16/example.c</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/docs/examples.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const examples = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  examples as default
};
