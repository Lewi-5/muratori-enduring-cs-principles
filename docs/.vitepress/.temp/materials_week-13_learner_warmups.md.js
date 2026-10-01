import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Warm-ups","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-13/learner/warmups.md","filePath":"materials/week-13/learner/warmups.md"}');
const _sfc_main = { name: "materials/week-13/learner/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="warm-ups" tabindex="-1">Warm-ups <a class="header-anchor" href="#warm-ups" aria-label="Permalink to &quot;Warm-ups&quot;">​</a></h1><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>w01: convert unsigned seconds plus nanos to nanoseconds; reject nanos&gt;=1e9, overflow and NULL without changing output.</p><p>Code: <a href="/source/week-13/learner/src/w01.c.html">w01.c</a>. Check with <code>make warmups</code>.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>w02: compute an ordered delta, allowing equality and preserving output on reversal or NULL.</p><p>Code: <a href="/source/week-13/learner/src/w02.c.html">w02.c</a>. Check with <code>make warmups</code>.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>w03: compute ceil(total/batch) for batch&gt;0 without adding batch-1 to total.</p><p>Code: <a href="/source/week-13/learner/src/w03.c.html">w03.c</a>. Check with <code>make warmups</code>.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-13/learner/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
