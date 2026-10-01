import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Practice and stretch","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-08/learner/practice.md","filePath":"materials/week-08/learner/practice.md"}');
const _sfc_main = { name: "materials/week-08/learner/practice.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="practice-and-stretch" tabindex="-1">Practice and stretch <a class="header-anchor" href="#practice-and-stretch" aria-label="Permalink to &quot;Practice and stretch&quot;">​</a></h1><h3 id="p01" tabindex="-1">P01 <a class="header-anchor" href="#p01" aria-label="Permalink to &quot;P01 {#p01}&quot;">​</a></h3><p>Draw the guest register bank and label all eight byte views. From AX=ABCD and BX=1234 hex, execute mov ah,bl then mov bl,al. Give both words and identify every preserved byte.</p><h3 id="p02" tabindex="-1">P02 <a class="header-anchor" href="#p02" aria-label="Permalink to &quot;P02 {#p02}&quot;">​</a></h3><p>Compute every modeled flag for byte 80 hex minus 01 hex and 00 hex minus 01 hex. Interpret each operand/result as both unsigned and signed.</p><h3 id="p03" tabindex="-1">P03 <a class="header-anchor" href="#p03" aria-label="Permalink to &quot;P03 {#p03}&quot;">​</a></h3><p>Compare CMP AL,BL when AL=80 and BL=01 hex. What unsigned-less and signed-less predicates would Week 9 use? Does CMP itself select an interpretation?</p><h3 id="p04" tabindex="-1">P04 <a class="header-anchor" href="#p04" aria-label="Permalink to &quot;P04 {#p04}&quot;">​</a></h3><p>Why do result 0001 hex and 0101 hex have the same parity flag at word width? What about 0000 and 0100?</p><h3 id="p05" tabindex="-1">P05 <a class="header-anchor" href="#p05" aria-label="Permalink to &quot;P05 {#p05}&quot;">​</a></h3><p>Start IP at FFFE hex and execute two two-byte instructions from a four-byte file. Give each guest IP and each next file cursor. Describe the effect of a third truncated instruction.</p><h3 id="p06" tabindex="-1">P06 <a class="header-anchor" href="#p06" aria-label="Permalink to &quot;P06 {#p06}&quot;">​</a></h3><p>Decode 83 C0 FE and show its effect from AX=0001 hex. Explain immediate sign extension versus host signed arithmetic and MOV’s flag behavior.</p><h3 id="s01" tabindex="-1">S01 <a class="header-anchor" href="#s01" aria-label="Permalink to &quot;S01 {#s01}&quot;">​</a></h3><p>Implement unsigned-less and signed-less predicates on CMP flags in C, without adding guest jump execution. Compare 80 hex with 01 hex, then compare equal operands. Verify with instructor/extras/predicates.c and explain why the two predicates can differ.</p><h3 id="s02" tabindex="-1">S02 <a class="header-anchor" href="#s02" aria-label="Permalink to &quot;S02 {#s02}&quot;">​</a></h3><p>Differentially compare the instructions in fixtures/program.hex against a trusted decoder, such as objdump with i8086 selected. Record its instruction boundaries and reconcile text conventions. Explain exactly which simulator claims this comparison leaves untested.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-08/learner/practice.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const practice = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  practice as default
};
