import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Warm-up reasoning and check-yourself answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-09/instructor/warmups.md","filePath":"materials/week-09/instructor/warmups.md"}');
const _sfc_main = { name: "materials/week-09/instructor/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="warm-up-reasoning-and-check-yourself-answers" tabindex="-1">Warm-up reasoning and check-yourself answers <a class="header-anchor" href="#warm-up-reasoning-and-check-yourself-answers" aria-label="Permalink to &quot;Warm-up reasoning and check-yourself answers&quot;">​</a></h1><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>The reference in src/w01.c validates the range 0..255 and subtracts 256 only for patterns 128..255. F8 hex is 248, so its signed interpretation is -8; 80 hex is 128, so its interpretation is -128. All intermediate values are representable in int32_t. An out-of-range int8_t cast would depend on the C implementation. The test checks all 256 patterns and invalid inputs. Validation comes before assignment, so failure preserves the caller&#39;s output.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>The reference in src/w02.c converts the displacement to uint32_t, adds the following IP and retains the low sixteen bits with a mask of 65535. The result is 0009 hex for 0011 minus 8, and FFFF for zero minus 1. Both input ranges are checked before mutation. Testing every following IP with displacements +1 and -1 catches errors at zero and the upper boundary. This helper produces a numeric guest offset; validating whether it selects an instruction boundary is a later operation. It never produces a negative host array index.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>The reference in src/w03.c widens each byte, shifts the high byte by eight bits and combines the values with OR. Bytes 34 and 12 hex yield word 1234; bytes FF and 80 yield 80FF. Widening before shifting makes the arithmetic explicit, and the result fits uint16_t. The test checks all 65536 word patterns. Copying the bytes into a host uint16_t with memcpy would use the host&#39;s byte order and would not define the guest encoding.</p><p>Check yourself: a relative displacement is measured from the position following the complete instruction. Signed JL uses SF != OF because overflow can make the stored subtraction sign misleading. A word at FFFF uses host array indices 65535 and 0. An untaken jump preserves flags and does not validate its unused destination. Budget failure discards the entire tentative Machine while still returning the attempted step count. Real 8086 segment addressing and instruction decoding are broader than this teaching model.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-09/instructor/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
