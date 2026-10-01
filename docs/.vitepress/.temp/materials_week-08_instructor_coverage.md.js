import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Coverage and boundaries","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-08/instructor/coverage.md","filePath":"materials/week-08/instructor/coverage.md"}');
const _sfc_main = { name: "materials/week-08/instructor/coverage.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="coverage-and-boundaries" tabindex="-1">Coverage and boundaries <a class="header-anchor" href="#coverage-and-boundaries" aria-label="Permalink to &quot;Coverage and boundaries&quot;">​</a></h1><p>inventory.py enforces 29 unique learner IDs and complete separate answers: ten E contract/reasoning entries, six P, two S, five R, three W and three F. The beginner warm-ups have typed stubs and reference C in both packages; warmups.c checks the finite low-byte, replacement and byte-carry domains exhaustively.</p><p>The Python arithmetic oracle and C probe compare 196608 byte cases (all 256×256 pairs across ADD/SUB/CMP), 432 word boundary cases and 12288 deterministic word samples: 209328 total per configuration. OF is derived with mathematical signed ranges, AF with modulo-16 carry/borrow, and PF with low-byte bit counts. This oracle does not copy the C bitwise OF/AF formulas.</p><p>The C contracts cover all register reads, byte-write preservation, invalid register arguments, invalid ALU requests, overlapping aliases, MOV flag preservation, CMP non-write and preservation of unmodeled flag bits, malformed instruction fields, unsupported memory operands, late decode/execution rollback, NULL/empty/oversized input and IP wrap with independent file progress. They exercise all 512 operation/width/destination/source register combinations and a separate 83 sign-extension case. The Python trace oracle checks both widths and all eight register codes through sequences of immediate operations. Hand-derived golden traces additionally include a register/register subtraction and alias writes.</p><p>CLI checks include full traces, a four-instruction playground, late decode/unsupported memory failures, invalid opcode and group, input cap, empty files, absent files and argument errors. Output-write failure is reported by supplied plumbing but is not rolled back. Six compiler/mode configurations and unfinished learner-negative checks supply build evidence. The beginner snippet, reading registry and rendered site have independent checks.</p><p>Word tests sample a large domain; they do not enumerate every word pair or arbitrary program. No memory, jump, interrupt, timing or modern microarchitecture behavior is implemented. Optional trusted-decoder comparison checks the decoded fixture’s lengths/operands, not flags or execution. Review of validation, bounds and transactional logic remains necessary.</p></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-08/instructor/coverage.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const coverage = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  coverage as default
};
