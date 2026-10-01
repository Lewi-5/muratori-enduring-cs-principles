import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Query fixtures (E03.C)","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-05/learner/fixtures/README.md","filePath":"materials/week-05/learner/fixtures/README.md"}');
const _sfc_main = { name: "materials/week-05/learner/fixtures/README.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="query-fixtures-e03-c" tabindex="-1">Query fixtures (E03.C) <a class="header-anchor" href="#query-fixtures-e03-c" aria-label="Permalink to &quot;Query fixtures (E03.C)&quot;">​</a></h1><p>Add at least six hand-written CSV v1 files to this directory and one table row for each. <code>make test</code> runs every row as <code>geolab query --input learner/fixtures/FILE ARGUMENTS</code>. It fails if a listed file is missing, if a <code>.csv</code> file here is not listed, or if any of the six required purposes is absent: <code>pole</code>, <code>antimeridian</code>, <code>exact-tie</code>, <code>printed-tie</code>, <code>empty</code>, <code>malformed</code>. Extra rows may use other purpose words.</p><p>Keep the arguments to <code>--lat</code>, <code>--lon</code> and <code>--radius-km</code> with valid values. Put the file name and the arguments in backquotes, as in the example row format below. Then run <code>make expected</code>, which writes <code>expected/NAME.txt</code> from the <strong>supplied oracle</strong>, not from your program. Commit those files; the test fails if one no longer matches the oracle. Write the CSV files with a program or <code>printf</code>, not an editor that might add a byte-order mark or CRLF line endings.</p><p>Row format (replace the example with your own rows; a row that does not begin with a backquoted file name is ignored):</p><pre><code>| \`example.csv\` | pole | \`--lat 89.5 --lon 0 --radius-km 100\` | one sentence: what this fixture would catch |
</code></pre><table tabindex="0"><thead><tr><th>Fixture</th><th>Purpose</th><th>Arguments</th><th>Why it exists</th></tr></thead></table></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-05/learner/fixtures/README.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const README = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  README as default
};
