import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"","description":"","frontmatter":{"layout":"home","hero":{"name":"Enduring CS Principles","text":"From C source to evidence.","tagline":"Guided weeks connecting programs, representations, numerical reasoning, machine instructions, and stack discipline.","actions":[{"theme":"brand","text":"Start the course","link":"/guide/start"},{"theme":"alt","text":"Open Week 1","link":"/weeks/week-01"}]},"features":[{"title":"Understand the reason","details":"Begin with a concrete question, build the mechanism, and explain why the exercise is worth doing."},{"title":"Work locally","details":"Read source here; implement and test the C exercises in your Linux or WSL checkout."},{"title":"Make a defensible claim","details":"Keep predictions, observations, and uncertainty visible. Correctness and explanation come before speed."}]},"headers":[],"relativePath":"index.md","filePath":"index.md"}');
const _sfc_main = { name: "index.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("index.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const index = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  index as default
};
