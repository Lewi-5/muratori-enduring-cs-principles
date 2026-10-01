import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Reading question answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-12/instructor/reading-answers.md","filePath":"materials/week-12/instructor/reading-answers.md"}');
const _sfc_main = { name: "materials/week-12/instructor/reading-answers.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="reading-question-answers" tabindex="-1">Reading question answers <a class="header-anchor" href="#reading-question-answers" aria-label="Permalink to &quot;Reading question answers&quot;">​</a></h1><h3 id="f01" tabindex="-1">F01 <a class="header-anchor" href="#f01" aria-label="Permalink to &quot;F01 {#f01}&quot;">​</a></h3><p>The CE review encourages auditing the composition of instruction effects. Scott&#39;s hardware/software account gives the role of encoded instructions and stored state; Dive Into Systems §5.9, CS:APP §5.7 and Hennessy/Patterson discuss modern implementation mechanisms. A correct state simulator establishes register/flag/memory transitions for its specified subset. Timing would additionally need an explicit model or measurements of fetching/decoding, prediction, caches, dependencies, scheduling and execution resources. Our prepared boundary map is validation metadata, not a return-address predictor. No text makes a 25-step guest count a modern cycle measurement.</p><h3 id="f02" tabindex="-1">F02 <a class="header-anchor" href="#f02" aria-label="Permalink to &quot;F02 {#f02}&quot;">​</a></h3><p>HH Chat 011 raises the difference between expected machine effects and the C language contract. Beej&#39;s signed/unsigned account and C11 §6.3.1.3 support defined conversion/masking rather than overflowing signed host arithmetic. For a byte ADD, sum in a wider unsigned type and retain eight bits; calculate flags separately. C11 lifetime/object-access rules and CS 341&#39;s bugs explain why a CodeImage borrowing a dead automatic byte array is invalid, even if its map still looks correct. Keep caller-owned or static code alive through execution. Undefined-behavior sanitizers support selected checks but their silence is not a proof of full C validity.</p><h3 id="f03" tabindex="-1">F03 <a class="header-anchor" href="#f03" aria-label="Permalink to &quot;F03 {#f03}&quot;">​</a></h3><p>Condition correctness concerns the ISA state transition: after CMP byte 80,01, CF is zero and SF differs from OF, so unsigned/signed predicates differ. ABI correctness concerns how generated x64 functions pass arguments/results and preserve state across calls. Microarchitecture affects how those instructions are scheduled, predicted and supplied with data, and requires another kind of evidence. CS:APP and Hennessy/Patterson connect these levels without specifying our immutable code, full predecode, checked targets, stack window, finite budget, halt convention or whole-run rollback. Those policies are in project.h and CHECKPOINT-2.md. A compiler listing is an observation of one build, not a required timing result.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-12/instructor/reading-answers.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const readingAnswers = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  readingAnswers as default
};
