import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Warm-up and check-yourself answers","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-16/instructor/warmups.md","filePath":"materials/week-16/instructor/warmups.md"}');
const _sfc_main = { name: "materials/week-16/instructor/warmups.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="warm-up-and-check-yourself-answers" tabindex="-1">Warm-up and check-yourself answers <a class="header-anchor" href="#warm-up-and-check-yourself-answers" aria-label="Permalink to &quot;Warm-up and check-yourself answers&quot;">​</a></h1><h3 id="w01" tabindex="-1">W01 <a class="header-anchor" href="#w01" aria-label="Permalink to &quot;W01 {#w01}&quot;">​</a></h3><p>Creation marks every modeled kind live. Block exit ends the modeled automatic object while static/allocated remain. Explicit release ends the modeled allocated object; the static object remains. Real scopes, multiple blocks and process termination require more context, and this function never inspects a pointer. Reject unsupported kinds/events without committing output.</p><h3 id="w02" tabindex="-1">W02 <a class="header-anchor" href="#w02" aria-label="Permalink to &quot;W02 {#w02}&quot;">​</a></h3><p>Guard n&gt;SIZE_MAX/sizeof(int) before multiplying; zero succeeds. Arithmetic representability is different from available memory, successful malloc or a live owner. Preserve the old output on failure, including NULL-output rejection before writing.</p><h3 id="w03" tabindex="-1">W03 <a class="header-anchor" href="#w03" aria-label="Permalink to &quot;W03 {#w03}&quot;">​</a></h3><p>Check out and seed!=INT_MAX before signed addition. An automatic value can be copied into the caller’s live object before the helper ends; no pointer to the helper’s local escapes. INT_MIN+1 is representable. Returning by value would also repair the lifetime issue under another API.</p><p>Check yourself: A pointer object and its pointee have separate lifetimes. Scope is name visibility, not duration. A failed allocation preserves old ownership; successful resize invalidates previous borrows. Static mutable state is shared and this API is single-threaded. Diagnostics are evidence for exercised bugs, not a proof of every valid access.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-16/instructor/warmups.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const warmups = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  warmups as default
};
