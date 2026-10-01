import { ssrRenderAttrs, ssrRenderStyle } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Instructor materials — spoilers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-08/instructor/README.md","filePath":"materials/week-08/instructor/README.md"}');
const _sfc_main = { name: "materials/week-08/instructor/README.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="instructor-materials-—-spoilers" tabindex="-1">Instructor materials — spoilers <a class="header-anchor" href="#instructor-materials-—-spoilers" aria-label="Permalink to &quot;Instructor materials — spoilers&quot;">​</a></h1><p><a href="/materials/week-08/instructor/answers.html">Worked answers</a>, <a href="/materials/week-08/instructor/observations.html">notebook</a>, <a href="/materials/week-08/instructor/warmups.html">warm-ups</a> and <a href="/materials/week-08/instructor/reading-answers.html">reading answers</a> cover all 29 learner IDs. Reference C is in src; the learner build shares only the completed prerequisite decoder and supplied drivers. <a href="/materials/week-08/instructor/coverage.html">Coverage</a> describes the test domains and <a href="/materials/week-08/instructor/validation.html">validation</a> records actual execution.</p><div class="language-sh vp-adaptive-theme line-numbers-mode"><button title="Copy Code" class="copy"></button><span class="lang">sh</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="${ssrRenderStyle({ "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" })}">make</span><span style="${ssrRenderStyle({ "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" })}"> verify</span></span>
<span class="line"><span style="${ssrRenderStyle({ "--shiki-light": "#6F42C1", "--shiki-dark": "#B392F0" })}">make</span><span style="${ssrRenderStyle({ "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" })}"> PACKAGE=instructor</span><span style="${ssrRenderStyle({ "--shiki-light": "#032F62", "--shiki-dark": "#9ECBFF" })}"> extras</span></span></code></pre><div class="line-numbers-wrapper" aria-hidden="true"><span class="line-number">1</span><br><span class="line-number">2</span><br></div></div><p>The mathematical oracle checks all byte operand pairs for ADD/SUB/CMP and selected word inputs. It obtains overflow from signed range tests and auxiliary carry/borrow from nibble arithmetic. The C implementation uses sign-bit and carry-bit identities, giving independent routes to the same expectation. Trace tests independently construct encoded immediate/register programs and compare every printed state. A passing decoder alone is not evidence of simulated flags.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-08/instructor/README.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const README = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  README as default
};
