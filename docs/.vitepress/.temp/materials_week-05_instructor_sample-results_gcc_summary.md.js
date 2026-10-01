import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-05/instructor/sample-results/gcc/summary.md","filePath":"materials/week-05/instructor/sample-results/gcc/summary.md"}');
const _sfc_main = { name: "materials/week-05/instructor/sample-results/gcc/summary.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><table tabindex="0"><thead><tr><th>variant</th><th>size</th><th>build</th><th>run medians (ns/point)</th><th>median of runs</th><th>range of runs</th><th>max within-run spread</th><th>short samples</th></tr></thead><tbody><tr><td>distance</td><td>d1k</td><td>vec-off</td><td>31.32, 35.08, 31.93, 33.69, 34.27</td><td>33.69</td><td>31.32–35.08</td><td>0.381</td><td>0</td></tr><tr><td>distance</td><td>d1k</td><td>vec-default</td><td>32.85, 34.19, 36.10, 32.61, 32.19</td><td>32.85</td><td>32.19–36.10</td><td>3.906</td><td>0</td></tr><tr><td>distance</td><td>d100k</td><td>vec-off</td><td>44.14, 43.73, 44.43, 44.12, 44.19</td><td>44.14</td><td>43.73–44.43</td><td>0.280</td><td>0</td></tr><tr><td>distance</td><td>d100k</td><td>vec-default</td><td>44.44, 44.48, 45.08, 43.78, 44.99</td><td>44.48</td><td>43.78–45.08</td><td>0.214</td><td>0</td></tr><tr><td>distance</td><td>d1m</td><td>vec-off</td><td>44.69, 44.32, 45.65, 44.35, 44.79</td><td>44.69</td><td>44.32–45.65</td><td>0.116</td><td>0</td></tr><tr><td>distance</td><td>d1m</td><td>vec-default</td><td>44.69, 44.10, 44.66, 44.58, 44.77</td><td>44.66</td><td>44.10–44.77</td><td>0.179</td><td>0</td></tr><tr><td>query</td><td>d1k</td><td>vec-off</td><td>37.56, 34.56, 35.15, 33.88, 33.61</td><td>34.56</td><td>33.61–37.56</td><td>1.830</td><td>0</td></tr><tr><td>query</td><td>d1k</td><td>vec-default</td><td>35.03, 37.18, 33.74, 35.16, 33.35</td><td>35.03</td><td>33.35–37.18</td><td>1.582</td><td>0</td></tr><tr><td>query</td><td>d100k</td><td>vec-off</td><td>49.80, 47.16, 48.41, 47.36, 47.25</td><td>47.36</td><td>47.16–49.80</td><td>0.478</td><td>0</td></tr><tr><td>query</td><td>d100k</td><td>vec-default</td><td>49.01, 47.80, 48.59, 48.16, 47.72</td><td>48.16</td><td>47.72–49.01</td><td>0.368</td><td>0</td></tr><tr><td>query</td><td>d1m</td><td>vec-off</td><td>50.45, 49.76, 49.83, 49.90, 49.93</td><td>49.90</td><td>49.76–50.45</td><td>0.157</td><td>0</td></tr><tr><td>query</td><td>d1m</td><td>vec-default</td><td>49.97, 49.19, 50.49, 49.55, 49.00</td><td>49.55</td><td>49.00–50.49</td><td>0.132</td><td>0</td></tr><tr><td>parse</td><td>d100k</td><td>vec-off</td><td>92.13, 90.72, 92.69, 91.06, 90.43</td><td>91.06</td><td>90.43–92.69</td><td>0.101</td><td>0</td></tr><tr><td>parse</td><td>d100k</td><td>vec-default</td><td>91.02, 90.82, 90.74, 91.46, 91.18</td><td>91.02</td><td>90.74–91.46</td><td>0.108</td><td>0</td></tr></tbody></table></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-05/instructor/sample-results/gcc/summary.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const summary = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  summary as default
};
