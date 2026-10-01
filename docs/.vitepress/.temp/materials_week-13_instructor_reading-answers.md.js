import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Reading questions answers (spoilers)","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-13/instructor/reading-answers.md","filePath":"materials/week-13/instructor/reading-answers.md"}');
const _sfc_main = { name: "materials/week-13/instructor/reading-answers.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="reading-questions-answers-spoilers" tabindex="-1">Reading questions answers (spoilers) <a class="header-anchor" href="#reading-questions-answers-spoilers" aria-label="Permalink to &quot;Reading questions answers (spoilers)&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>Scott introduces coordination of hardware operations. The OS exposes an elapsed-time abstraction with its own units, adjustments and failure rules; the Linux manual defines this assignment’s clock.</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>clock() reports processor time in clock_t units; timespec_get(TIME_UTC) supplies calendar-based time. Neither is the specified monotonic elapsed provider. Their representation/conversion lessons still help.</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>Performance comparisons require a specified workload and metric. An empirical ticks/sec conversion ties one counter to a measured interval; it does not establish core cycles, stability across systems or performance for another workload.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-13/instructor/reading-answers.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingAnswers = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingAnswers as default
};
