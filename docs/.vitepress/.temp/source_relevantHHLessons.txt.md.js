import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"relevantHHLessons.txt","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source/relevantHHLessons.txt.md","filePath":"source/relevantHHLessons.txt.md"}');
const _sfc_main = { name: "source/relevantHHLessons.txt.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="relevanthhlessons-txt" tabindex="-1">relevantHHLessons.txt <a class="header-anchor" href="#relevanthhlessons-txt" aria-label="Permalink to &quot;relevantHHLessons.txt&quot;">​</a></h1><p><a href="/source-index/root.html">Browse its folder</a></p><p><strong>Repository file:</strong> <code>relevantHHLessons.txt</code> · <a href="/files/relevantHHLessons.txt" download>Download original</a></p><div class="language-txt vp-adaptive-theme line-numbers-mode"><button title="Copy Code" class="copy"></button><span class="lang">txt</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>Day 010: QueryPerformanceCounter and RDTSC</span></span>
<span class="line"><span>Day 014: Platform-independent Game Memory</span></span>
<span class="line"><span>Day 045: Geometric vs. Temporal Movement Search</span></span>
<span class="line"><span>Day 047: Vector Lengths</span></span>
<span class="line"><span>Day 048: Line Segment Intersection Collisions</span></span>
<span class="line"><span>Day 055: Hash-based World Storage</span></span>
<span class="line"><span>Day 057: Spatially Partitioning Entities</span></span>
<span class="line"><span>Day 064: Mapping Entity Indexes to Pointers</span></span>
<span class="line"><span>Day 079: Defining the Ground</span></span>
<span class="line"><span>Day 090: Bases Part I</span></span>
<span class="line"><span>Day 091: Bases Part II</span></span>
<span class="line"><span>Day 112: A Mental Model of CPU Performance</span></span>
<span class="line"><span>Day 113: Simple Performance Counters</span></span>
<span class="line"><span>Day 115: SIMD Basics</span></span>
<span class="line"><span>Day 116: Converting Math Operations to SIMD</span></span>
<span class="line"><span>Day 119: Counting Intrinsics</span></span>
<span class="line"><span>Day 122: Introduction to Multithreading</span></span>
<span class="line"><span>Day 123: Interlocked Operations</span></span>
<span class="line"><span>Day 124: Memory Barriers and Semaphores</span></span>
<span class="line"><span>Day 125: Abstracting the Work Queue</span></span>
<span class="line"><span>Day 126: Circular FIFO Work Queue</span></span>
<span class="line"><span>Day 146: Accumulation vs. Explicit Calculation</span></span>
<span class="line"><span>Day 157: Introduction to General Purpose Allocation</span></span>
<span class="line"><span>Day 160: Basic General Purpose Allocation</span></span>
<span class="line"><span>Day 161: Finishing the General Purpose Allocator</span></span>
<span class="line"><span>Day 166: Adding Locks to the Asset Operations</span></span>
<span class="line"><span>Day 177: Automatic Performance Counters</span></span>
<span class="line"><span>Day 178: Thread-safe Performance Counters</span></span>
<span class="line"><span>Day 216: On-demand Deallocation</span></span>
<span class="line"><span>Day 218: Hashing Debug Elements</span></span>
<span class="line"><span>Day 231: Order Notation</span></span>
<span class="line"><span>Day 232: Examples of Sorting Algorithms</span></span>
<span class="line"><span>Day 233: Can We Merge Sort In Place?</span></span>
<span class="line"><span>Day 234: Implementing Radix Sort</span></span>
<span class="line"><span>Day 286: Starting to Decouple Entity Behavior</span></span>
<span class="line"><span>Day 298: Improving Sort Keys Part 1</span></span>
<span class="line"><span>Day 299: Improving Sort Keys Part 2</span></span>
<span class="line"><span>Day 302: Confirming No Total Ordering</span></span>
<span class="line"><span>Day 303: Trying Separate Y and Z Sorts</span></span>
<span class="line"><span>Day 304: Building and Traversing Graphs</span></span>
<span class="line"><span>Day 305: Using Memory Arenas in the Platform Layer</span></span>
<span class="line"><span>Day 306: Debugging Graph-based Sort</span></span>
<span class="line"><span>Day 307: Visualizing Sort Groups</span></span>
<span class="line"><span>Day 308: Debugging the Cycle Check</span></span>
<span class="line"><span>Day 309: Grid Partitioning for Overlap Testing</span></span>
<span class="line"><span>Day 310: Finishing Sort Acceleration via Gridding</span></span>
<span class="line"><span>Day 311: Allowing Manual Sorting</span></span>
<span class="line"><span>Day 315: Un-reversing Sort Key Order</span></span>
<span class="line"><span>Day 325: Ticket Mutexes</span></span>
<span class="line"><span>Day 342: Supporting Temporary Memory in Dynamic Arenas</span></span>
<span class="line"><span>Day 343: Saving and Restoring Dynamically Allocated Memory Pages</span></span>
<span class="line"><span>Day 344: Selective Memory Restoration</span></span>
<span class="line"><span>Day 345: Protecting Memory Pages for Underflow Detection</span></span>
<span class="line"><span>Day 346: Consolidating Memory Block Headers</span></span>
<span class="line"><span>Day 350: Multithreaded World Simulation</span></span>
<span class="line"><span>Day 351: Optimizing Multithreaded Simulation Regions</span></span>
<span class="line"><span>Day 353: Simple RLE Compression</span></span>
<span class="line"><span>Day 354: Simple LZ Compression</span></span>
<span class="line"><span>Day 434: Replacing the Pseudo-random Number Generator</span></span>
<span class="line"><span>Day 439: Testing Better Entropy</span></span>
<span class="line"><span>Day 440: Introduction to Function Approximation with Andrew Bromage</span></span>
<span class="line"><span>Day 449: Preventing Overlapping Rooms</span></span>
<span class="line"><span>Day 454: Parsing ZLIB Headers</span></span>
<span class="line"><span>Day 455: Decoding PNG Huffman Tables</span></span>
<span class="line"><span>Day 474: Removing the Transient State Concept</span></span>
<span class="line"><span>Day 489: Implementing Undo and Redo</span></span>
<span class="line"><span>Day 510: Making a Parser for HHTs</span></span>
<span class="line"><span>Day 521: Debugging Missing Parent Pointers</span></span>
<span class="line"><span>Day 522: Solving for Sorting Displacement</span></span>
<span class="line"><span>Day 539: Capturing Source Information for Memory Allocations</span></span>
<span class="line"><span>Day 542: Drawing Memory Occupancy Accurately</span></span>
<span class="line"><span>Day 575: Generalizing Code Reloading</span></span>
<span class="line"><span>Day 595: Sketching Out A K-d Tree Loop</span></span>
<span class="line"><span>Day 596: Fleshing Out Kd-Tree Traversal</span></span>
<span class="line"><span>Day 597: Basic Kd-tree Construction</span></span>
<span class="line"><span>Day 615: Optimized Grid Step Selection</span></span>
<span class="line"><span>Day 633: Narrowing in on a Collision Scheme</span></span>
<span class="line"><span>Day 663: Simplifying Entity Storage, Part I</span></span>
<span class="line"><span>Day 666: Entity Packing and Unpacking</span></span>
<span class="line"><span>Chat 011: Undefined Behavior</span></span>
<span class="line"><span>Chat 013: Translation Units, Function Pointers, Compilation, Linking, and Execution</span></span>
<span class="line"><span>Chat 017: Modern x64 Architectures and the Cache</span></span>
<span class="line"><span>Chat 020: Assembly Analysis and Front-end Register Clears</span></span>
<span class="line"><span>Day 1001: Multithreading</span></span>
<span class="line"><span>Day 1002: Replacing rand() and Preparing for SIMD</span></span>
<span class="line"><span>Day 1003: Optimizing with SSE2 and AVX2</span></span>
<span class="line"><span>Day 1006: The Thirty-Million Line Problem</span></span>
<span class="line"><span>Day 1007: Compression</span></span>
<span class="line"><span>Day 1008: Compression Followup</span></span></code></pre><div class="line-numbers-wrapper" aria-hidden="true"><span class="line-number">1</span><br><span class="line-number">2</span><br><span class="line-number">3</span><br><span class="line-number">4</span><br><span class="line-number">5</span><br><span class="line-number">6</span><br><span class="line-number">7</span><br><span class="line-number">8</span><br><span class="line-number">9</span><br><span class="line-number">10</span><br><span class="line-number">11</span><br><span class="line-number">12</span><br><span class="line-number">13</span><br><span class="line-number">14</span><br><span class="line-number">15</span><br><span class="line-number">16</span><br><span class="line-number">17</span><br><span class="line-number">18</span><br><span class="line-number">19</span><br><span class="line-number">20</span><br><span class="line-number">21</span><br><span class="line-number">22</span><br><span class="line-number">23</span><br><span class="line-number">24</span><br><span class="line-number">25</span><br><span class="line-number">26</span><br><span class="line-number">27</span><br><span class="line-number">28</span><br><span class="line-number">29</span><br><span class="line-number">30</span><br><span class="line-number">31</span><br><span class="line-number">32</span><br><span class="line-number">33</span><br><span class="line-number">34</span><br><span class="line-number">35</span><br><span class="line-number">36</span><br><span class="line-number">37</span><br><span class="line-number">38</span><br><span class="line-number">39</span><br><span class="line-number">40</span><br><span class="line-number">41</span><br><span class="line-number">42</span><br><span class="line-number">43</span><br><span class="line-number">44</span><br><span class="line-number">45</span><br><span class="line-number">46</span><br><span class="line-number">47</span><br><span class="line-number">48</span><br><span class="line-number">49</span><br><span class="line-number">50</span><br><span class="line-number">51</span><br><span class="line-number">52</span><br><span class="line-number">53</span><br><span class="line-number">54</span><br><span class="line-number">55</span><br><span class="line-number">56</span><br><span class="line-number">57</span><br><span class="line-number">58</span><br><span class="line-number">59</span><br><span class="line-number">60</span><br><span class="line-number">61</span><br><span class="line-number">62</span><br><span class="line-number">63</span><br><span class="line-number">64</span><br><span class="line-number">65</span><br><span class="line-number">66</span><br><span class="line-number">67</span><br><span class="line-number">68</span><br><span class="line-number">69</span><br><span class="line-number">70</span><br><span class="line-number">71</span><br><span class="line-number">72</span><br><span class="line-number">73</span><br><span class="line-number">74</span><br><span class="line-number">75</span><br><span class="line-number">76</span><br><span class="line-number">77</span><br><span class="line-number">78</span><br><span class="line-number">79</span><br><span class="line-number">80</span><br><span class="line-number">81</span><br><span class="line-number">82</span><br><span class="line-number">83</span><br><span class="line-number">84</span><br><span class="line-number">85</span><br><span class="line-number">86</span><br><span class="line-number">87</span><br><span class="line-number">88</span><br><span class="line-number">89</span><br></div></div></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source/relevantHHLessons.txt.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const relevantHHLessons_txt = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  relevantHHLessons_txt as default
};
