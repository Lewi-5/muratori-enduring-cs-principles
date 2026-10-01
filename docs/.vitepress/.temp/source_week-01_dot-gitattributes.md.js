import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":".gitattributes","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source/week-01/dot-gitattributes.md","filePath":"source/week-01/dot-gitattributes.md"}');
const _sfc_main = { name: "source/week-01/dot-gitattributes.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="gitattributes" tabindex="-1">.gitattributes <a class="header-anchor" href="#gitattributes" aria-label="Permalink to &quot;.gitattributes&quot;">​</a></h1><p><a href="/source-index/week-01.html">Browse its folder</a></p><p><strong>Repository file:</strong> <code>week-01/.gitattributes</code> · <a href="/files/week-01/.gitattributes" download>Download original</a></p><div class="language-text vp-adaptive-theme line-numbers-mode"><button title="Copy Code" class="copy"></button><span class="lang">text</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span># Preserve byte-count fixtures across Windows/Linux checkouts.</span></span>
<span class="line"><span>fixtures/*.txt -text</span></span>
<span class="line"><span>Makefile text eol=lf</span></span>
<span class="line"><span>*.c text eol=lf</span></span>
<span class="line"><span>*.h text eol=lf</span></span>
<span class="line"><span>*.py text eol=lf</span></span></code></pre><div class="line-numbers-wrapper" aria-hidden="true"><span class="line-number">1</span><br><span class="line-number">2</span><br><span class="line-number">3</span><br><span class="line-number">4</span><br><span class="line-number">5</span><br><span class="line-number">6</span><br></div></div></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source/week-01/dot-gitattributes.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const dotGitattributes = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  dotGitattributes as default
};
