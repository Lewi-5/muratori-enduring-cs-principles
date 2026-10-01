import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-07/learner","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-07/learner.md","filePath":"source-index/week-07/learner.md"}');
const _sfc_main = { name: "source-index/week-07/learner.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-07-learner" tabindex="-1">Files: week-07/learner <a class="header-anchor" href="#files-week-07-learner" aria-label="Permalink to &quot;Files: week-07/learner&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-07/learner/cases.txt.html">cases.txt</a></li><li><a href="/materials/week-07/learner/exercises.html">exercises.md</a></li><li><a href="/materials/week-07/learner/observations.html">observations.md</a></li><li><a href="/materials/week-07/learner/practice.html">practice.md</a></li><li><a href="/materials/week-07/learner/reading-questions.html">reading-questions.md</a></li><li><a href="/source/week-07/learner/src/address.c.html">src/address.c</a></li><li><a href="/source/week-07/learner/src/client.c.html">src/client.c</a></li><li><a href="/source/week-07/learner/src/decode.c.html">src/decode.c</a></li><li><a href="/source/week-07/learner/src/decode8086.c.html">src/decode8086.c</a></li><li><a href="/source/week-07/learner/src/format.c.html">src/format.c</a></li><li><a href="/source/week-07/learner/src/playground.c.html">src/playground.c</a></li><li><a href="/source/week-07/learner/src/stream.c.html">src/stream.c</a></li><li><a href="/source/week-07/learner/src/w01.c.html">src/w01.c</a></li><li><a href="/source/week-07/learner/src/w02.c.html">src/w02.c</a></li><li><a href="/source/week-07/learner/src/w03.c.html">src/w03.c</a></li><li><a href="/materials/week-07/learner/warmups.html">warmups.md</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-07/learner.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const learner = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  learner as default
};
