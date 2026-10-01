import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"empty.txt","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source/week-01/fixtures/empty.txt.md","filePath":"source/week-01/fixtures/empty.txt.md"}');
const _sfc_main = { name: "source/week-01/fixtures/empty.txt.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="empty-txt" tabindex="-1">empty.txt <a class="header-anchor" href="#empty-txt" aria-label="Permalink to &quot;empty.txt&quot;">​</a></h1><p><a href="/source-index/week-01/fixtures.html">Browse its folder</a></p><p><strong>Repository file:</strong> <code>week-01/fixtures/empty.txt</code> · <a href="/files/week-01/fixtures/empty.txt" download>Download original</a></p><div class="language-txt vp-adaptive-theme line-numbers-mode"><button title="Copy Code" class="copy"></button><span class="lang">txt</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span></span></span></code></pre><div class="line-numbers-wrapper" aria-hidden="true"><span class="line-number">1</span><br></div></div></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source/week-01/fixtures/empty.txt.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const empty_txt = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  empty_txt as default
};
