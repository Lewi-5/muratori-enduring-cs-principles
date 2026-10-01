import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-10/support","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-10/support.md","filePath":"source-index/week-10/support.md"}');
const _sfc_main = { name: "source-index/week-10/support.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-10-support" tabindex="-1">Files: week-10/support <a class="header-anchor" href="#files-week-10-support" aria-label="Permalink to &quot;Files: week-10/support&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/materials/week-10/support/README.html">README.md</a></li><li><a href="/source/week-10/support/alu/alu.c.html">alu/alu.c</a></li><li><a href="/source/week-10/support/alu/registers.c.html">alu/registers.c</a></li><li><a href="/source/week-10/support/alu/sim.h.html">alu/sim.h</a></li><li><a href="/source/week-10/support/decoder/address.c.html">decoder/address.c</a></li><li><a href="/source/week-10/support/decoder/address.h.html">decoder/address.h</a></li><li><a href="/source/week-10/support/decoder/decode.c.html">decoder/decode.c</a></li><li><a href="/source/week-10/support/decoder/decode.h.html">decoder/decode.h</a></li><li><a href="/source/week-10/support/decoder/format.c.html">decoder/format.c</a></li><li><a href="/source/week-10/support/driver.c.html">driver.c</a></li><li><a href="/source/week-10/support/playground.c.html">playground.c</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-10/support.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const support = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  support as default
};
