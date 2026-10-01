import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"materials/week-05/instructor/sample-results/clang/summary.md","filePath":"materials/week-05/instructor/sample-results/clang/summary.md"}');
const _sfc_main = { name: "materials/week-05/instructor/sample-results/clang/summary.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><table tabindex="0"><thead><tr><th>variant</th><th>size</th><th>build</th><th>run medians (ns/point)</th><th>median of runs</th><th>range of runs</th><th>max within-run spread</th><th>short samples</th></tr></thead><tbody><tr><td>distance</td><td>d1k</td><td>vec-off</td><td>32.56, 37.76, 32.01, 34.93, 45.74</td><td>34.93</td><td>32.01–45.74</td><td>1.963</td><td>0</td></tr><tr><td>distance</td><td>d1k</td><td>vec-default</td><td>34.33, 35.21, 33.81, 33.05, 32.40</td><td>33.81</td><td>32.40–35.21</td><td>0.620</td><td>0</td></tr><tr><td>distance</td><td>d100k</td><td>vec-off</td><td>44.49, 44.42, 44.99, 44.10, 47.38</td><td>44.49</td><td>44.10–47.38</td><td>0.124</td><td>0</td></tr><tr><td>distance</td><td>d100k</td><td>vec-default</td><td>44.38, 44.56, 44.45, 44.72, 47.96</td><td>44.56</td><td>44.38–47.96</td><td>0.159</td><td>0</td></tr><tr><td>distance</td><td>d1m</td><td>vec-off</td><td>44.87, 46.11, 45.06, 45.05, 44.96</td><td>45.05</td><td>44.87–46.11</td><td>0.065</td><td>0</td></tr><tr><td>distance</td><td>d1m</td><td>vec-default</td><td>46.28, 45.25, 45.29, 45.22, 44.95</td><td>45.25</td><td>44.95–46.28</td><td>0.085</td><td>0</td></tr><tr><td>query</td><td>d1k</td><td>vec-off</td><td>38.88, 39.32, 37.03, 35.04, 37.31</td><td>37.31</td><td>35.04–39.32</td><td>5.815</td><td>0</td></tr><tr><td>query</td><td>d1k</td><td>vec-default</td><td>35.24, 41.07, 38.12, 34.43, 36.02</td><td>36.02</td><td>34.43–41.07</td><td>1.027</td><td>0</td></tr><tr><td>query</td><td>d100k</td><td>vec-off</td><td>49.40, 48.85, 49.15, 47.69, 50.16</td><td>49.15</td><td>47.69–50.16</td><td>0.141</td><td>0</td></tr><tr><td>query</td><td>d100k</td><td>vec-default</td><td>50.99, 49.31, 48.45, 48.19, 49.74</td><td>49.31</td><td>48.19–50.99</td><td>0.186</td><td>0</td></tr><tr><td>query</td><td>d1m</td><td>vec-off</td><td>51.07, 50.80, 49.55, 50.23, 50.95</td><td>50.80</td><td>49.55–51.07</td><td>0.158</td><td>0</td></tr><tr><td>query</td><td>d1m</td><td>vec-default</td><td>50.53, 50.12, 50.39, 50.33, 50.87</td><td>50.39</td><td>50.12–50.87</td><td>0.066</td><td>0</td></tr><tr><td>parse</td><td>d100k</td><td>vec-off</td><td>93.88, 94.28, 92.58, 94.67, 94.98</td><td>94.28</td><td>92.58–94.98</td><td>0.148</td><td>0</td></tr><tr><td>parse</td><td>d100k</td><td>vec-default</td><td>91.80, 93.26, 91.09, 91.17, 91.64</td><td>91.64</td><td>91.09–93.26</td><td>0.103</td><td>0</td></tr></tbody></table></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("materials/week-05/instructor/sample-results/clang/summary.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const summary = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  summary as default
};
