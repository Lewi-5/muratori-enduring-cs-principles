import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Warm-up answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-10/instructor/warmups.md","filePath":"materials/week-10/instructor/warmups.md"}');
const _sfc_main = { name: "materials/week-10/instructor/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="warm-up-answers" tabindex="-1">Warm-up answers <a class="header-anchor" href="#warm-up-answers" aria-label="Permalink to &quot;Warm-up answers&quot;">​</a></h1><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>Reference src/w01.c. For p&lt;32768, p is its signed value. Otherwise subtract 65536 in int32_t: 0000→0, 7FFF→32767, 8000→−32768, FFFF→−1. This interprets a width-specific pattern without narrowing an out-of-range value to int16_t. Validate p and output before assigning; tests compare all patterns and sentinel preservation. A faulty approach casts first and relies on host conversion behavior.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>Reference src/w02.c. Validate high&lt;=65535 and SP&lt;=high, then compute unsigned (high−SP)/2. High=256 and SP=250 gives three complete words; an odd difference rounds down because two bytes make a word. The stack accepts odd addresses, but an odd byte distance need not describe a fully balanced sequence of word pushes from that high. This helper counts capacity-derived words and cannot classify their contents as return addresses. A subtraction before validation would wrap and manufacture a huge depth.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>Reference src/w03.c. Widen bytes[1] before shifting by eight and OR it with bytes[0]; assign the uint16_t result after NULL checks. Bytes 34,12 yield word 1234. Numeric operations express guest little-endian format independently of host byte order or alignment. NULL checks do not establish that two bytes are accessible; that extent is part of the caller contract. Exhaustive patterns verify reconstruction; no pointer cast is needed.</p><h2 id="beginner-check-yourself-answers" tabindex="-1">Beginner check-yourself answers <a class="header-anchor" href="#beginner-check-yourself-answers" aria-label="Permalink to &quot;Beginner check-yourself answers&quot;">​</a></h2><p>PUSH reserves first because the current SP of an empty stack points just beyond its bytes; writing there would cross high. CALL stores the following IP so RET continues after the completed call. POP removes a word from the live interval without deleting bytes. Guest memory contents and host C object lifetime are separate rules; only a live object may be dereferenced through a valid pointer. INC preserves an existing CF by definition, so reusing all ADD flags would be wrong. These are instruction and language contracts, not timing measurements.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-10/instructor/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
