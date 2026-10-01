import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Warm-ups answers (spoilers)","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-13/instructor/warmups.md","filePath":"materials/week-13/instructor/warmups.md"}');
const _sfc_main = { name: "materials/week-13/instructor/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="warm-ups-answers-spoilers" tabindex="-1">Warm-ups answers (spoilers) <a class="header-anchor" href="#warm-ups-answers-spoilers" aria-label="Permalink to &quot;Warm-ups answers (spoilers)&quot;">​</a></h1><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>Check seconds against (UINT64_MAX-nanos)/1e9, then publish seconds*1e9+nanos. 1s+2ns yields1000000002.</p><p>Code: <a href="/source/week-13/instructor/src/w01.c.html">w01.c</a>. Check with <code>make warmups</code> using PACKAGE=instructor.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>Reject end&lt;begin before subtraction. 9→9 gives0; 9→8 fails and leaves the sentinel.</p><p>Code: <a href="/source/week-13/instructor/src/w02.c.html">w02.c</a>. Check with <code>make warmups</code> using PACKAGE=instructor.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>Use total/batch plus one when total%batch is nonzero. UINT64_MAX with batch2 yields UINT64_MAX/2+1.</p><p>Code: <a href="/source/week-13/instructor/src/w03.c.html">w03.c</a>. Check with <code>make warmups</code> using PACKAGE=instructor.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-13/instructor/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
