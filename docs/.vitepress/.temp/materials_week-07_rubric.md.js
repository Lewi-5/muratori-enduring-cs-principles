import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Week 7 rubric","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-07/rubric.md","filePath":"materials/week-07/rubric.md"}');
const _sfc_main = { name: "materials/week-07/rubric.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="week-7-rubric" tabindex="-1">Week 7 rubric <a class="header-anchor" href="#week-7-rubric" aria-label="Permalink to &quot;Week 7 rubric&quot;">​</a></h1><p>Correctness and explanation determine acceptance; no performance requirement.</p><table tabindex="0"><thead><tr><th>Work</th><th>Points</th><th>Evidence</th></tr></thead><tbody><tr><td>E01 address description</td><td>15</td><td>all modes, direct exception, sign boundaries, unchanged outputs</td></tr><tr><td>E02 instruction integration</td><td>25</td><td>exact forms, direction, widths, length, status order, bounded reads</td></tr><tr><td>E03 canonical formatting</td><td>15</td><td>validated operands, qualifiers, signed/unsigned distinction, transactional output</td></tr><tr><td>E04 API and shared client</td><td>15</td><td>matching header, four exports, dependency, actual independent client execution</td></tr><tr><td>E05 integration and cases</td><td>10</td><td>golden streams, five independently reasoned cases, CLI failures</td></tr><tr><td>R01–R05 explanations</td><td>20</td><td>predictions, observations, mechanisms, ABI and test limits, next-week handoff</td></tr></tbody></table><p>To pass: at least 70 points and no unresolved out-of-bounds read, output contract violation, unsupported accepted instruction or incompatible library/client build. Practice, warm-ups, reading questions and stretch are formative; complete answers are supplied. Different valid architectures within the documented course contract and different tool spellings are accepted. A test transcript alone does not replace written reasoning.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-07/rubric.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const rubric = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  rubric as default
};
