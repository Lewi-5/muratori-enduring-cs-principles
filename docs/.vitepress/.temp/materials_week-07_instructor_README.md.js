import { ssrRenderAttrs, ssrRenderStyle } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Instructor materials — spoilers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-07/instructor/README.md","filePath":"materials/week-07/instructor/README.md"}');
const _sfc_main = { name: "materials/week-07/instructor/README.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="instructor-materials-—-spoilers" tabindex="-1">Instructor materials — spoilers <a class="header-anchor" href="#instructor-materials-—-spoilers" aria-label="Permalink to &quot;Instructor materials — spoilers&quot;">​</a></h1><p>Reference C is in src; the learner build never uses these files. <a href="/materials/week-07/instructor/answers.html">Answers</a> cover all exercise, practice and stretch prompts. <a href="/materials/week-07/instructor/observations.html">Notebook</a>, <a href="/materials/week-07/instructor/warmups.html">warm-ups</a> and <a href="/materials/week-07/instructor/reading-answers.html">reading answers</a> complete the written coverage. <a href="/materials/week-07/instructor/validation.html">Validation</a> records actual checks and <a href="/materials/week-07/instructor/coverage.html">coverage</a> states their limits.</p><div class="language-sh vp-adaptive-theme line-numbers-mode"><button title="Copy Code" class="copy"></button><span class="lang">sh</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="${ssrRenderStyle({ "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" })}">make</span><span style="${ssrRenderStyle({ "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" })}"> verify</span></span>
<span class="line"><span style="${ssrRenderStyle({ "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" })}">make</span><span style="${ssrRenderStyle({ "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" })}"> PACKAGE=instructor</span><span style="${ssrRenderStyle({ "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" })}"> symbols</span></span></code></pre><div class="line-numbers-wrapper" aria-hidden="true"><span class="line-number">1</span><br><span class="line-number">2</span><br></div></div><p>tests/oracle.py creates bytes from independently chosen semantic fields. It is not a copy of the decoder. Golden text and the four-case playground make failures readable; contracts.c checks transactional failures. Learner stubs compile cleanly and intentionally fail correctness gates. Use the same public header across clients and library. This week changes the Operand layout from Week 6 and makes no binary compatibility promise with it.</p><p>Optional reference probes in extras demonstrate equivalent encodings and explicit POSIX loading. They are not required to build the learner solution; compile instructions are at the top of each file.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-07/instructor/README.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const README = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  README as default
};
