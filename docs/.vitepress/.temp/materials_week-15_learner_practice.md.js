import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Practice and stretch","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-15/learner/practice.md","filePath":"materials/week-15/learner/practice.md"}');
const _sfc_main = { name: "materials/week-15/learner/practice.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="practice-and-stretch" tabindex="-1">Practice and stretch <a class="header-anchor" href="#practice-and-stretch" aria-label="Permalink to &quot;Practice and stretch&quot;">​</a></h1><h3 id="p01" tabindex="-1">P01 <a class="header-anchor" href="#p01" aria-label="Permalink to &quot;P01 {#p01}&quot;">​</a></h3><p>For five reverse-ordered distinct keys, calculate insertion comparisons and record writes under this contract. Contrast five equal keys.</p><h3 id="p02" tabindex="-1">P02 <a class="header-anchor" href="#p02" aria-label="Permalink to &quot;P02 {#p02}&quot;">​</a></h3><p>Explain why checking only that keys are nondecreasing can accept a sort that overwrites every record with zero.</p><h3 id="p03" tabindex="-1">P03 <a class="header-anchor" href="#p03" aria-label="Permalink to &quot;P03 {#p03}&quot;">​</a></h3><p>A merge chooses the right item on equal keys. Give the smallest tagged counterexample and repair the tie decision.</p><h3 id="p04" tabindex="-1">P04 <a class="header-anchor" href="#p04" aria-label="Permalink to &quot;P04 {#p04}&quot;">​</a></h3><p>An LSD radix pass fills each bucket in reverse input order. Give a two-byte counterexample showing lost earlier-digit ordering.</p><h3 id="p05" tabindex="-1">P05 <a class="header-anchor" href="#p05" aria-label="Permalink to &quot;P05 {#p05}&quot;">​</a></h3><p>Explain the difference between a uint32_t numeric byte extracted by a shift and a byte obtained from the object representation. What changes for signed keys?</p><h3 id="p06" tabindex="-1">P06 <a class="header-anchor" href="#p06" aria-label="Permalink to &quot;P06 {#p06}&quot;">​</a></h3><p>Two runs sort random then already-sorted data because the same buffer is reused. Explain how this biases the insertion comparison and repair the protocol.</p><h3 id="s01" tabindex="-1">S01 <a class="header-anchor" href="#s01" aria-label="Permalink to &quot;S01 {#s01}&quot;">​</a></h3><p>Design a controlled comparison of memory cost: caller-supplied scratch versus allocating scratch per operation. Give a complete experiment protocol and memory budget; correctness and no universal speed threshold are required.</p><h3 id="s02" tabindex="-1">S02 <a class="header-anchor" href="#s02" aria-label="Permalink to &quot;S02 {#s02}&quot;">​</a></h3><p>Design a stable hybrid using insertion sort on small runs before merging. Provide a complete threshold-selection protocol and invariant; justify how another machine may choose a different threshold.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-15/learner/practice.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const practice = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  practice as default
};
