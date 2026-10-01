import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Timing protocol (E05.C) — write this BEFORE running make bench-data","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-05/learner/PROTOCOL.md","filePath":"materials/week-05/learner/PROTOCOL.md"}');
const _sfc_main = { name: "materials/week-05/learner/PROTOCOL.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="timing-protocol-e05-c-—-write-this-before-running-make-bench-data" tabindex="-1">Timing protocol (E05.C) — write this BEFORE running <code>make bench-data</code> <a class="header-anchor" href="#timing-protocol-e05-c-—-write-this-before-running-make-bench-data" aria-label="Permalink to &quot;Timing protocol (E05.C) — write this BEFORE running \`make bench-data\`&quot;">​</a></h1><p>Date written: Author:</p><h2 id="question" tabindex="-1">Question <a class="header-anchor" href="#question" aria-label="Permalink to &quot;Question&quot;">​</a></h2><p>What is the scalar baseline cost per point of <code>distance</code>, <code>query</code> and <code>parse</code> on this machine, and does it change with dataset size or between the <code>VEC=off</code> and <code>VEC=default</code> builds?</p><h2 id="fixed-before-collecting-data" tabindex="-1">Fixed before collecting data <a class="header-anchor" href="#fixed-before-collecting-data" aria-label="Permalink to &quot;Fixed before collecting data&quot;">​</a></h2><ul><li><strong>Datasets</strong> (seed, count, SHA-256 checked by the runner):</li><li><strong>Builds</strong> (compiler, the complete compile command for each variant, where each executable lives):</li><li><strong>Variants and parameters</strong> (center, radius, repeat, warm-up):</li><li><strong>Process runs</strong> (how many, at least 5):</li><li><strong>Order</strong> (how variants and builds are interleaved):</li><li><strong>Held constant</strong> (power source, background load, other programs, virtual machine, CPU pinning or not):</li><li><strong>Recorded</strong> (environment block, command, raw output files, faults file):</li><li><strong>Stopping rule</strong> (when you stop, and what, if anything, justifies a rerun):</li><li><strong>Comparison rule</strong> (how you will decide whether two conditions differ, and what that does and does not establish):</li></ul><h2 id="deviations" tabindex="-1">Deviations <a class="header-anchor" href="#deviations" aria-label="Permalink to &quot;Deviations&quot;">​</a></h2><p>Write down anything that happened differently from the plan above, when it happened and why. Do not edit the sections above after collecting data.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-05/learner/PROTOCOL.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const PROTOCOL = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  PROTOCOL as default
};
