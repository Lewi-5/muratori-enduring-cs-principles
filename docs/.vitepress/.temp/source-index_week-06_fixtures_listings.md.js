import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Files: week-06/fixtures/listings","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source-index/week-06/fixtures/listings.md","filePath":"source-index/week-06/fixtures/listings.md"}');
const _sfc_main = { name: "source-index/week-06/fixtures/listings.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="files-week-06-fixtures-listings" tabindex="-1">Files: week-06/fixtures/listings <a class="header-anchor" href="#files-week-06-fixtures-listings" aria-label="Permalink to &quot;Files: week-06/fixtures/listings&quot;">​</a></h1><p>These files are read from the local course checkout when the site is built.</p><ul><li><a href="/source/week-06/fixtures/listings/arithmetic.bin.html">arithmetic.bin</a></li><li><a href="/source/week-06/fixtures/listings/arithmetic.txt.html">arithmetic.txt</a></li><li><a href="/source/week-06/fixtures/listings/group_or.bin.html">group_or.bin</a></li><li><a href="/source/week-06/fixtures/listings/group_or.txt.html">group_or.txt</a></li><li><a href="/source/week-06/fixtures/listings/immediates.bin.html">immediates.bin</a></li><li><a href="/source/week-06/fixtures/listings/immediates.txt.html">immediates.txt</a></li><li><a href="/source/week-06/fixtures/listings/jump.bin.html">jump.bin</a></li><li><a href="/source/week-06/fixtures/listings/jump.txt.html">jump.txt</a></li><li><a href="/source/week-06/fixtures/listings/memory_mode.bin.html">memory_mode.bin</a></li><li><a href="/source/week-06/fixtures/listings/memory_mode.txt.html">memory_mode.txt</a></li><li><a href="/source/week-06/fixtures/listings/program.bin.html">program.bin</a></li><li><a href="/source/week-06/fixtures/listings/program.txt.html">program.txt</a></li><li><a href="/source/week-06/fixtures/listings/registers.bin.html">registers.bin</a></li><li><a href="/source/week-06/fixtures/listings/registers.txt.html">registers.txt</a></li><li><a href="/source/week-06/fixtures/listings/resync.bin.html">resync.bin</a></li><li><a href="/source/week-06/fixtures/listings/resync.txt.html">resync.txt</a></li><li><a href="/source/week-06/fixtures/listings/truncated_end.bin.html">truncated_end.bin</a></li><li><a href="/source/week-06/fixtures/listings/truncated_end.txt.html">truncated_end.txt</a></li><li><a href="/source/week-06/fixtures/listings/unsupported_middle.bin.html">unsupported_middle.bin</a></li><li><a href="/source/week-06/fixtures/listings/unsupported_middle.txt.html">unsupported_middle.txt</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source-index/week-06/fixtures/listings.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const listings = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  listings as default
};
