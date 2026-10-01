import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-11/learner/src","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-11/learner/src.md","filePath":"source-index/week-11/learner/src.md"}');
const _sfc_main = { name: "source-index/week-11/learner/src.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-11-learner-src" tabindex="-1">Files: week-11/learner/src <a class="header-anchor" href="#files-week-11-learner-src" aria-label="Permalink to &quot;Files: week-11/learner/src&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-11/learner/src/abi.c.html">abi.c</a></li><li><a href="/source/week-11/learner/src/calls.c.html">calls.c</a></li><li><a href="/source/week-11/learner/src/fold.c.html">fold.c</a></li><li><a href="/source/week-11/learner/src/w01.c.html">w01.c</a></li><li><a href="/source/week-11/learner/src/w02.c.html">w02.c</a></li><li><a href="/source/week-11/learner/src/w03.c.html">w03.c</a></li><li><a href="/source/week-11/learner/src/wrappers.c.html">wrappers.c</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-11/learner/src.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const src = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  src as default
};
