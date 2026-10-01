import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Warm-up answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-11/instructor/warmups.md","filePath":"materials/week-11/instructor/warmups.md"}');
const _sfc_main = { name: "materials/week-11/instructor/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="warm-up-answers" tabindex="-1">Warm-up answers <a class="header-anchor" href="#warm-up-answers" aria-label="Permalink to &quot;Warm-up answers&quot;">​</a></h1><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>src/w01.c maps positions zero through five to GP indices in RDI,RSI,RDX,RCX,R8,R9 order. For position k&gt;=6, the stack offset is 8+8(k−6). The return word occupies entry offset zero, so the first spill begins at eight. Invalid position/NULL output leaves the output unchanged. This is a scalar-integer-only exercise; a double elsewhere in a full signature does not increment this position.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>src/w02.c marks codes 3(RBX),5(RBP),12–15 as preserved, and 4(RSP) as specially restored. Other listed GP registers are caller-clobbered. A callee may save the incoming RBX, modify it as working storage, then restore it before return. The obligation is at the boundary, not every intermediate instruction. Tests cover all sixteen codes and unchanged output on invalid code/NULL.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>src/w03.c computes ceil(8*words/16)*16 with bounded unsigned arithmetic. Zero→zero, one→sixteen, two→sixteen, three→thirty-two. With an initially aligned caller, even-sized reservation keeps pre-CALL alignment; padding belongs above the scalar argument area. This does not decide type classes or handle stronger alignment/aggregate cases. Test all permitted counts and sentinel preservation.</p><h2 id="beginner-check-yourself-answers" tabindex="-1">Beginner check-yourself answers <a class="header-anchor" href="#beginner-check-yourself-answers" aria-label="Permalink to &quot;Beginner check-yourself answers&quot;">​</a></h2><p>Double parameters use a separate pool, so parameter five can be GP argument one. A preserved register can change internally after saving its incoming value; restoration at return fulfills the agreement. A push moves RSP and therefore changes a fixed memory location&#39;s relative offset. The C result can be correct with an optimized expression and no doubled slot. Architectural RET determines the actual continuation; the listing does not measure early speculative predictions or CPU cycles.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-11/instructor/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
