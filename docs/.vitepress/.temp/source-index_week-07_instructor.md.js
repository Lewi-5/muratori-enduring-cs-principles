import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-07/instructor","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-07/instructor.md","filePath":"source-index/week-07/instructor.md"}');
const _sfc_main = { name: "source-index/week-07/instructor.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-07-instructor" tabindex="-1">Files: week-07/instructor <a class="header-anchor" href="#files-week-07-instructor" aria-label="Permalink to &quot;Files: week-07/instructor&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/materials/week-07/instructor/README.html">README.md</a></li><li><a href="/materials/week-07/instructor/answers.html">answers.md</a></li><li><a href="/source/week-07/instructor/cases.txt.html">cases.txt</a></li><li><a href="/materials/week-07/instructor/coverage.html">coverage.md</a></li><li><a href="/source/week-07/instructor/extras/load.c.html">extras/load.c</a></li><li><a href="/source/week-07/instructor/extras/roundtrip.c.html">extras/roundtrip.c</a></li><li><a href="/materials/week-07/instructor/observations.html">observations.md</a></li><li><a href="/materials/week-07/instructor/reading-answers.html">reading-answers.md</a></li><li><a href="/source/week-07/instructor/src/address.c.html">src/address.c</a></li><li><a href="/source/week-07/instructor/src/client.c.html">src/client.c</a></li><li><a href="/source/week-07/instructor/src/decode.c.html">src/decode.c</a></li><li><a href="/source/week-07/instructor/src/decode8086.c.html">src/decode8086.c</a></li><li><a href="/source/week-07/instructor/src/format.c.html">src/format.c</a></li><li><a href="/source/week-07/instructor/src/playground.c.html">src/playground.c</a></li><li><a href="/source/week-07/instructor/src/stream.c.html">src/stream.c</a></li><li><a href="/source/week-07/instructor/src/w01.c.html">src/w01.c</a></li><li><a href="/source/week-07/instructor/src/w02.c.html">src/w02.c</a></li><li><a href="/source/week-07/instructor/src/w03.c.html">src/w03.c</a></li><li><a href="/materials/week-07/instructor/validation.html">validation.md</a></li><li><a href="/materials/week-07/instructor/warmups.html">warmups.md</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-07/instructor.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const instructor = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  instructor as default
};
