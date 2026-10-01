import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Actual symbol and relocation excerpt","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-02/instructor/symbol-observations.md","filePath":"materials/week-02/instructor/symbol-observations.md"}');
const _sfc_main = { name: "materials/week-02/instructor/symbol-observations.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="actual-symbol-and-relocation-excerpt" tabindex="-1">Actual symbol and relocation excerpt <a class="header-anchor" href="#actual-symbol-and-relocation-excerpt" aria-label="Permalink to &quot;Actual symbol and relocation excerpt&quot;">​</a></h1><p>Captured 2026-09-20 under Ubuntu/WSL2 x86-64, GCC 11.4.0, GNU binutils 2.38, strict C11 -O0 with -fno-common. Command from week-02: <code>make PACKAGE=instructor symbols inspect</code>. This is one actual build, not a golden test fixture. The full local capture remains in ignored <code>build/symbols.log</code>.</p><p>Relevant <code>nm</code> entries:</p><div class="language-text vp-adaptive-theme line-numbers-mode"><button title="Copy Code" class="copy"></button><span class="lang">text</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>ex09_main.o:</span></span>
<span class="line"><span>0000000000000000 d hidden_counter</span></span>
<span class="line"><span>                 U shared_counter</span></span>
<span class="line"><span>                 U shared_limit</span></span>
<span class="line"><span>                 U shared_zero</span></span>
<span class="line"><span></span></span>
<span class="line"><span>ex09_data.o:</span></span>
<span class="line"><span>0000000000000004 d hidden_counter</span></span>
<span class="line"><span>0000000000000004 b local.0</span></span>
<span class="line"><span>0000000000000000 D shared_counter</span></span>
<span class="line"><span>0000000000000000 R shared_limit</span></span>
<span class="line"><span>0000000000000000 B shared_zero</span></span></code></pre><div class="line-numbers-wrapper" aria-hidden="true"><span class="line-number">1</span><br><span class="line-number">2</span><br><span class="line-number">3</span><br><span class="line-number">4</span><br><span class="line-number">5</span><br><span class="line-number">6</span><br><span class="line-number">7</span><br><span class="line-number">8</span><br><span class="line-number">9</span><br><span class="line-number">10</span><br><span class="line-number">11</span><br><span class="line-number">12</span><br></div></div><p>readelf reported .bss as NOBITS and, in main.o, these representative symbol entries:</p><div class="language-text vp-adaptive-theme line-numbers-mode"><button title="Copy Code" class="copy"></button><span class="lang">text</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>4: 0000000000000000 4 OBJECT LOCAL  DEFAULT 3   hidden_counter</span></span>
<span class="line"><span>7: 0000000000000000 0 NOTYPE GLOBAL DEFAULT UND shared_counter</span></span></code></pre><div class="line-numbers-wrapper" aria-hidden="true"><span class="line-number">1</span><br><span class="line-number">2</span><br></div></div><p>The data unit reports shared_counter in .data, shared_limit in .rodata, shared_zero and local.0 in .bss, and its own hidden_counter in .data. The two hidden objects have the same source spelling but separate internal linkage. local.0 is this compiler&#39;s chosen name for next_local&#39;s static local.</p><p>A relocation in the caller object:</p><div class="language-text vp-adaptive-theme line-numbers-mode"><button title="Copy Code" class="copy"></button><span class="lang">text</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>000000000013 000700000002 R_X86_64_PC32 0000000000000000 shared_counter - 4</span></span></code></pre><div class="line-numbers-wrapper" aria-hidden="true"><span class="line-number">1</span><br></div></div><p>This names a PC-relative reference requiring resolution against shared_counter, including an addend of -4 in this encoding. It is not the integer value of shared_counter. Link-time addresses in the executable differ from object-relative positions. Other compilation modes may change relocation locations and names while preserving C behavior. See the complete S02 explanation in <a href="/materials/week-02/instructor/answers.html#s02">answers.md</a>.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-02/instructor/symbol-observations.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const symbolObservations = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  symbolObservations as default
};
