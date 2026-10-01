import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Completed prerequisites and supplied drivers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-10/support/README.md","filePath":"materials/week-10/support/README.md"}');
const _sfc_main = { name: "materials/week-10/support/README.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="completed-prerequisites-and-supplied-drivers" tabindex="-1">Completed prerequisites and supplied drivers <a class="header-anchor" href="#completed-prerequisites-and-supplied-drivers" aria-label="Permalink to &quot;Completed prerequisites and supplied drivers&quot;">​</a></h1><p><code>decoder/</code> is a byte-for-byte snapshot of Week 8&#39;s pinned revision-7 decoder (originally completed Week 7 code). <code>alu/registers.c</code>, <code>alu/alu.c</code> and <code>alu/sim.h</code> are byte-for-byte Week 8 reference prerequisites. Only their register and arithmetic functions are linked; obsolete Week 8 sim_step/sim_run declarations in that snapshot header are not this week&#39;s API. Use <a href="/source/week-10/include/machine.h.html">machine.h</a> for Week 10.</p><p>These are supplied completed prerequisites, not Week 10 solutions. <code>driver.c</code> and <code>playground.c</code> are shared harnesses. All new stack, extension decoding, execution and sequencing work comes from the selected package&#39;s four modules. The source pins let this package be built without another agent&#39;s unfinished Week 9 files.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-10/support/README.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const README = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  README as default
};
