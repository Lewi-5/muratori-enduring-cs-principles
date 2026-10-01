import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Warm-up solutions and check-yourself answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-12/instructor/warmups.md","filePath":"materials/week-12/instructor/warmups.md"}');
const _sfc_main = { name: "materials/week-12/instructor/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="warm-up-solutions-and-check-yourself-answers" tabindex="-1">Warm-up solutions and check-yourself answers <a class="header-anchor" href="#warm-up-solutions-and-check-yourself-answers" aria-label="Permalink to &quot;Warm-up solutions and check-yourself answers&quot;">​</a></h1><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>src/w01.c validates both bytes and output pointers, adds in unsigned arithmetic, returns the low eight bits and carry when sum exceeds 255. 255+1 yields result zero/carry one; 127+1 yields 128/carry zero but would have signed byte overflow. Carry and overflow answer different range questions. Testing all 65536 pairs uses quotient/remainder reasoning and checks failure preserves both outputs.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>src/w02.c checks pointers and target &lt;= 65535, then tests the addressed map byte for nonzero. For starts 0 and 3 and end 5, target 1 is absent and target 3 present. That helper cannot prove the map matches current code bytes or their lifetime. The prepared-image ownership contract supplies that requirement. Test all positions plus a noncanonical nonzero map value and invalid inputs.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>src/w03.c stores low byte first using a mask, then the high byte with an unsigned shift. Word 1234 hex becomes bytes 34,12; 80FF becomes FF,80. The helper requires two accessible output bytes and does not itself implement guest address wrap. The executor selects two valid guest-array indices separately when a word starts at FFFF. Test all 65536 word patterns without assuming host endian.</p><p>Check yourself: a trace delta records changed bytes, so same-value stores may be absent. A map with valid old offsets cannot keep dead code storage alive. At CALL the saved word is the following IP, not the opcode position. A capacity error commits neither trace nor guest state. ABI-correct optimized code may eliminate a source local, and neither an ISA trace nor a disassembly measures modern cycles.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-12/instructor/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
