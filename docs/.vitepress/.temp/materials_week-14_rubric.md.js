import { ssrRenderAttrs, ssrRenderStyle } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 14 rubric","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-14/rubric.md","filePath":"materials/week-14/rubric.md"}');
const _sfc_main = { name: "materials/week-14/rubric.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-14-rubric" tabindex="-1">Week 14 rubric <a class="header-anchor" href="#week-14-rubric" aria-label="Permalink to &quot;Week 14 rubric&quot;">​</a></h1><table tabindex="0"><thead><tr><th>Evidence</th><th style="${ssrRenderStyle({ "text-align": "right" })}">Points</th><th>Full-credit condition</th></tr></thead><tbody><tr><td>E01</td><td style="${ssrRenderStyle({ "text-align": "right" })}">15</td><td>Valid ranges, ordered events/endpoints, complete failure preservation</td></tr><tr><td>E02</td><td style="${ssrRenderStyle({ "text-align": "right" })}">15</td><td>Checked state publication, callback/hit semantics and boundary cases</td></tr><tr><td>E03</td><td style="${ssrRenderStyle({ "text-align": "right" })}">15</td><td>Correct aggregation and overlap/median interpretation; raw inputs retained</td></tr><tr><td>E04</td><td style="${ssrRenderStyle({ "text-align": "right" })}">15</td><td>Defined numeric conversion, unsupported/zero cases and qualified units</td></tr><tr><td>E05</td><td style="${ssrRenderStyle({ "text-align": "right" })}">15</td><td>Reproducible captures, checksum and actual compiler artifacts</td></tr><tr><td>Written E questions</td><td style="${ssrRenderStyle({ "text-align": "right" })}">10</td><td>Specific mechanism and correct limitations</td></tr><tr><td>Practice/notebook</td><td style="${ssrRenderStyle({ "text-align": "right" })}">10</td><td>Predictions and recorded observations for P/R; S optional</td></tr><tr><td>W/F</td><td style="${ssrRenderStyle({ "text-align": "right" })}">5</td><td>Warm-up gates and source-based reading explanations</td></tr></tbody></table><p>100 points total. Invalid C, silently corrupted outputs, invented timing results or a counter/core-cycle equivalence prevents full credit in the affected item. Variable timing alone never causes failure. Reading access and elapsed learner time are not graded. Submit sources, exact commands/manifests, raw data and completed notebook; exclude generated binaries from review commits.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-14/rubric.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const rubric = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  rubric as default
};
