import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"rawTranscript.txt","description":"","frontmatter":{"search":false,"prev":false,"next":false},"headers":[],"relativePath":"source/rawTranscript.txt.md","filePath":"source/rawTranscript.txt.md"}');
const _sfc_main = { name: "source/rawTranscript.txt.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="rawtranscript-txt" tabindex="-1">rawTranscript.txt <a class="header-anchor" href="#rawtranscript-txt" aria-label="Permalink to &quot;rawTranscript.txt&quot;">​</a></h1><p><a href="/source-index/root.html">Browse its folder</a></p><p><strong>Repository file:</strong> <code>rawTranscript.txt</code> · <a href="/files/rawTranscript.txt" download>Download original</a></p><pre class="line-source"><code><span id="L1">starting at 37min:25seconds
</span>
<span id="L2">
</span>
<span id="L3">Muratori:
</span>
<span id="L4">in this discussion that I&#39;m not sure like you could talk about any of them for quite some time. So I think the
</span>
<span id="L5">biggest thing I would point out is just that I think that when you&#39;re talking about
</span>
<span id="L6">what you should learn in a college setting or more specifically what you should learn in any kind of educational
</span>
<span id="L7">setting that is supposed to be uh more serious and less immediate. So,
</span>
<span id="L8">for example, if I just want to learn Python, I mean, I don&#39;t know about you guys, maybe this is atypical, but I
</span>
<span id="L9">don&#39;t think it is. Like, I&#39;d never programmed Python before and I wanted to do a little bit of that for uh some
</span>
<span id="L10">stuff I was doing on the Substack. It it it took like five minutes. Like, it like the amount of time it takes to learn for
</span>
<span id="L11">me to learn to program Python was zero time. Right. Right. So the idea that like we need to
</span>
<span id="L12">think very hard about what language you&#39;re learning uh to me seems just kind of ridiculous because if you&#39;re a if
</span>
<span id="L13">you&#39;re a decent programmer then if someone asks you to program in a new language it&#39;s like I have never found
</span>
<span id="L14">that to be a relevant question. It it just isn&#39;t. And maybe there are certain idiomatic things that I&#39;m going to have
</span>
<span id="L15">to like go read about because they wouldn&#39;t occur to me because I haven&#39;t been programming this language for 30 years or whatever it is. So like maybe I
</span>
<span id="L16">will want to go like uh to a good reference of some people who you know that I would respect and say okay so
</span>
<span id="L17">what are some idiomatic things that you tend to do in Python? Uh like all right I I see thank you and that&#39;s it. So to
</span>
<span id="L18">me when we&#39;re talking about what is what is supposed to be there for even a
</span>
<span id="L19">practical education not even the theoretical part it&#39;s what are the things that remain true
</span>
<span id="L20">meaning if I learned them 30 years ago I didn&#39;t relearn them today. There is a
</span>
<span id="L21">very big I think misconception promulgated by this C is not a low-level
</span>
<span id="L22">language statement which I think is false and not interesting but that&#39;s
</span>
<span id="L23">kind of irrelevant to the argument that somehow
</span>
<span id="L24">the things that you would learn in a course that was about low-level programming
</span>
<span id="L25">do not do not remain true because hardware has changed.
</span>
<span id="L26">And that is just completely false. Like it&#39;s literally completely false. The exact same things you had to consider in
</span>
<span id="L27">1968 and 1972 and 1977 and 1987 and 2012 and
</span>
<span id="L28">2026 are exactly the same. The only difference is the diagram you are
</span>
<span id="L29">reading about how these things are interconnected on the particular thing you have will be slightly different.
</span>
<span id="L30">That&#39;s the difference right but name a thing whatever you want sim caches loop
</span>
<span id="L31">caching virtual memory whatever it is it was there it was there since like at least 1970 but usually a little earlier
</span>
<span id="L32">than that. And so if you went and learned about how computers work,
</span>
<span id="L33">meaning you were like, &quot;Here is a survey of how they work, generally speaking, this is what the architectures look
</span>
<span id="L34">like. Here&#39;s the different kinds of components we have.&quot; That literally has changed almost not at all, you know, in
</span>
<span id="L35">like 50 or 60 years. The the thing that changed the most is really like that everyone has the best of everything now
</span>
<span id="L36">in their desktop chip. like all the things that you would have been like, &quot;Oh, I had to have a CDC 6000 or a system, you know, 36091
</span>
<span id="L37">to get those things like a loop cache, and now they&#39;re just on my PC by default
</span>
<span id="L38">that I have in my home or my smartphone or whatever, right? That&#39;s the big difference, but that&#39;s really it.
</span>
<span id="L39">They&#39;re all the same concepts.&quot; And so, uh, the reason that I think just
</span>
<span id="L40">Extending down
</span>
<span id="L41">to tie it back to Lori, uh, Lori Wyard&#39;s like original thing she said, the thing
</span>
<span id="L42">she said is the important thing. It&#39;s that if you teach a course in something like C, I would say Rust is probably
</span>
<span id="L43">equivalent here, although I&#39;m not really a Rust programmer, but you know, it&#39;s basic, you know, you pick a language
</span>
<span id="L44">like one of those languages. The important part is that it&#39;s very easy for someone to say, &quot;And here&#39;s how we
</span>
<span id="L45">would access this part of the CPU. Here&#39;s how we would do a thing that was cache aware. Here&#39;s how we would
</span>
<span id="L46">multi-thread this. Here&#39;s how we would do an atomic, right? Because you&#39;re not forced to use some highlevel [snorts]
</span>
<span id="L47">like co-outine implementation thing. That&#39;s the only way you do that in a
</span>
<span id="L48">language, right? In some higher level language, that&#39;s that&#39;s great. in C. Yeah, the vanilla language C doesn&#39;t
</span>
<span id="L49">have these things in it, but that&#39;s not the point. The point is that if you already kind of know roughly how to
</span>
<span id="L50">learn something like C or Rust, you can then just right there without teaching the student anything new go now we are
</span>
<span id="L51">going to go use this crazy instruction on your CPU by using an intrinsic to go
</span>
<span id="L52">do this thing that looks at a SIMD vector and takes the mask register and packs the ones that are zeros into like
</span>
<span id="L53">and you can understand it with knowing nothing more than just the C you already learned and the little bit that they&#39;re
</span>
<span id="L54">trying to teach you now. And so at least what I got out of her statement and I thought she said it pretty clearly, she
</span>
<span id="L55">even used the word like extending down to memory management or things like that. The thing about C is it&#39;s very
</span>
<span id="L56">easy to extend down to whatever I need to teach you. It&#39;s not that the language itself has baked in the concept of
</span>
<span id="L57">vector processing, but I don&#39;t want it to because if it did, I couldn&#39;t teach you it as easily, right? because you
</span>
<span id="L58">don&#39;t have to learn how it actually works if the language is autovectorizing. If I teach you how to
</span>
<span id="L59">write shaders, you will never know about how things like vectorzation work
</span>
<span id="L60">because it&#39;s already baked into the threading model. The we&#39;re the like simt uh model of programming, right? So to me
</span>
<span id="L61">like I think she was absolutely correct. I think the perspective that she placed it in was absolutely correct. And I
</span>
<span id="L62">think that&#39;s the critical piece that has to be understood, right? And if you do learn those things, I think they&#39;re
</span>
<span id="L63">useful for decades. Whereas, if you just learn how to program Python and the libraries that come with Python now, I I
</span>
<span id="L64">honestly don&#39;t think 30 years from now anyone&#39;s going to care what those things were.
</span>
<span id="L65">That was one thing I really like. So, I I technically have uh like more of a computer engineer. It&#39;s electrical and
</span>
<span id="L66">computer engineering degree is like I didn&#39;t go I have a CS minor. And it was fun because we just learned a bunch of
</span>
<span id="L67">stuff like about computers and like physically how they worked. And it was always very helpful to me because I I
</span>
<span id="L68">was like, &quot;Oh, you can look at the code and be like, well, that&#39;s going to be slow.&quot; Yeah. Cuz there&#39;s no way to make the computer
</span>
<span id="L69">do that in any way that&#39;s not slow. You can just look at it and be like, &quot;That&#39;s not going to be good.&quot; Which has served
</span>
<span id="L70">me well for a long time, which I I like. And it didn&#39;t matter what language we
</span>
<span id="L71">did it in. Mhm. Honestly, that was a loadbearing description you just gave right there. [laughter]
</span>
<span id="L72">Genuinely, that was wellformed. Yeah, it was wellformed. In my honest
</span>
<span id="L73">opinion, that was good. Yeah. And and so and it also means that you can do it in other languages, right? It doesn&#39;t have to be C. It just has to
</span>
<span id="L74">be a language with that easy downward extension, which is it&#39;s it&#39;s very cumbersome to do that in Python. Even in
</span>
<span id="L75">Java, it&#39;s cumbersome to do it. It doesn&#39;t mean can&#39;t, right? It&#39;s not trying to, you know, people get hung up
</span>
<span id="L76">on can you or can&#39;t you do this thing in a language. It&#39;s just, it&#39;s just how simple is it to just extend downwards
</span>
<span id="L77">into something I&#39;m trying to teach you, right? And we could just teach it all in assembly language,
</span>
<span id="L78">but I think at this point that just being able to read assembly languages enough. I don&#39;t know that we need to spend time to teach people to really
</span>
<span id="L79">write significantly sized programs in assembly language. So learning C and how to read the ASOM that comes out of it
</span>
<span id="L80">seems like a very or or like I said or Rust or something like that that&#39;s has this capability I think is a good idea
</span>
<span id="L81">and I think Lori was correct. Well that was my next topic was what
</span>
<span id="L82">makes C better and Casey I believe that you absolutely nailed that one. So that one&#39;s done. And so the real question is,
</span>
<span id="L83">is Python a mistake or should that be is is Python itself the mistake or is it
</span>
<span id="L84">the fact that there is not a heavy emphasis on C? And I think you&#39;ve kind of also answered that which is that it&#39;s
</span>
<span id="L85">the exact same thing as like a I mean it&#39;s kind of like a boot camp in some sense. You go to learn React. It&#39;s like
</span>
<span id="L86">it&#39;s not a very extensible skill unless if you go and you practice it a whole bunch. So you&#39;re not learning like how to make a great UI. you&#39;re learning how
</span>
<span id="L87">to use React to make a UI or cobalt might be a the historical analogy. It&#39;s like it&#39;s not a bad idea
</span>
<span id="L88">to learn it at the time. It&#39;s just probably not that relevant 30 years from now, right? But but it
</span>
<span id="L89">doesn&#39;t mean you shouldn&#39;t maybe start like like I think to T&#39;s point, start with it because it&#39;s like, hey, this is
</span>
<span id="L90">what people are using today. You&#39;ll see a lot of it. It&#39;s easy for you to get
</span>
<span id="L91">some stuff up on the screen that you&#39;ll be excited about, right? That all makes sense to me. So, I don&#39;t think Python is
</span>
<span id="L92">Is Python a mistake?
</span>
<span id="L93">a mistake. It&#39;s the lack of of some other thing that&#39;s the mistake if it&#39;s happening, which I don&#39;t know, by the
</span>
<span id="L94">way, because I&#39;m I don&#39;t know like like uh like Lori was talking about this move away from it. I don&#39;t know anything about that. So, I&#39;m not saying that&#39;s
</span>
<span id="L95">happening. I&#39;m just saying assuming that is happening. I agree with her that that&#39;s a problem. I will say about the Cobalt thing
</span>
<span id="L96">though, uh the use of cobalt cripples the mind. It&#39;s [laughter] teaching should therefore be uh regarded as a
</span>
<span id="L97">criminal offense. Okay. Edgar Dystra, QED. So, just in case you&#39;re wondering, you can&#39;t do that one.
</span>
<span id="L98">I think you could find that from Dystra about just about anything you wanted. [laughter] Everything is just actually crippling
</span>
<span id="L99">the mind. Yes. He also said APPL is for people who want to go play play around.
</span>
<span id="L100">APL is a mistake carried through to perfection. Yeah. Right. Yeah. I think so. He did like I mean
</span>
<span id="L101">like I said the first CS class I took was Python and that&#39;s like before I took
</span>
<span id="L102">that class I literally thought learning programming languages was like learning
</span>
<span id="L103">Spanish or like learning a foreign language like the way everybody talked about it like in my life right because I
</span>
<span id="L104">like nobody in my life is technical. My dad&#39;s an accountant and I always told him dad I like math but I&#39;m not going to
</span>
<span id="L105">do your math when I grow up. That&#39;s boring. Um right? And so, like, I
</span>
<span id="L106">literally thought programming languages were cool. I have to go memorize like a bunch of random grammar things and like
</span>
<span id="L107">there&#39;s like a million new vocab words and there&#39;s like 35,000 exceptions to everything and you can&#39;t do well on the
</span>
<span id="L108">test unless you study extensively vocab and I didn&#39;t want to do that. I hated that. Um, so when but I had to take a CS
</span>
<span id="L109">class as part of my like liberal arts thing because I was doing mechanical engineering. So, one of our like gen ed
</span>
<span id="L110">classes we had to take was CS1 and I took Python. I was like, &quot;Holy cow, programming is just like logic and like
</span>
<span id="L111">pattern recognition and like trying to communicate with the computer. This is so much fun.&quot; And then from that class,
</span>
<span id="L112">the next class we took was data structures and it was in C or C++. I think it was in like C++, but we pretty
</span>
<span id="L113">much only used C features, you know what I mean? Like that kind of thing. And that was for me, I thought that was a
</span>
<span id="L114">really effective way of getting people into a track for CS where you can see things like appear on the screen
</span>
<span id="L115">quickly. You can interact with stuff. You can like, you know, draw a turtle that moves around on the screen and like
</span>
<span id="L116">connects dots. You&#39;re like, I just told it to turn left and turn left. That&#39;s so cool. Like I think JavaScript is fine
</span>
<span id="L117">for some of this. Whoa, whoa, whoa. Tee, a lot of people are thinking you&#39;re talking about an actual turtle now. You&#39;re going to have to logo pill them.
</span>
<span id="L118">It&#39;s the Sorry. It&#39;s just literally a dot. It&#39;s a turtle&#39;s library in Python. So it&#39;s it&#39;s not as exciting as you
</span>
<span id="L119">might think. It&#39;s just it&#39;s it&#39;s it&#39;s just dots. Logo pilled. Yeah. Sorry.
</span>
<span id="L120">Went over my head. Yeah. Well, trash. That&#39;s because you&#39;re obviously not a real engineer. You don&#39;t know Python turtle library. So
</span>
<span id="L121">What about C++ ?
</span>
<span id="L122">[laughter] true. So, you know what? I did C++ in college and it almost made me quit coding. I hated it.
</span>
<span id="L123">Was it at the very beginning or in the middle? Trash. I think it was like a 300 course. I did
</span>
<span id="L124">VB before that. I did VB and then we went to dang C++ and I was like yo what are these
</span>
<span id="L125">till days doing here that [laughter] was weird I do think like like the the the part
</span>
<span id="L126">where maybe like I I wouldn&#39;t like I&#39;m not sure about what the in the original context of the discussion
</span>
<span id="L127">this the plus+ part of C++ is a problem and so like you know the the I think if
</span>
<span id="L128">you were teaching people C++ the like the actual C++ the way that it is now
</span>
<span id="L129">intended to be programmed. I do think that would be a similarly transient thing to teach people much like Python.
</span>
<span id="L130">Like not something anyone will care about in 30 years. I know everyone&#39;s going to hate me for saying that, but like so you know that I I don&#39;t know
</span>
<span id="L131">about that part. And maybe maybe Lori Wired was actually implying that teaching C++ the plus+ part was
</span>
<span id="L132">important. I don&#39;t know. I would part ways there, but you don&#39;t that doesn&#39;t seem like her her like her
</span>
<span id="L133">it wasn&#39;t the important part of what she the point she was making though I didn&#39;t think anyway. I think too to your point
</span>
<span id="L134">Casey like as much as especially like you know let&#39;s say before maybe senior
</span>
<span id="L135">year like my senior year we did a lot of like very pragmatic stuff where we like built projects together and like had to
</span>
<span id="L136">figure out how to collaborate like so we ended up using git and figuring this out and a bunch of other stuff which was very helpful before going into the
</span>
<span id="L137">workplace like let&#39;s say years one through three or something spending a bunch of time teaching you all about the
</span>
<span id="L138">tildies where they go in C++ ++ will make programming not fun. It will not be fun for people and I think it is
</span>
<span id="L139">actively like not helpful. You don&#39;t get [laughter] a reusable skill on the other side and you hate it. At least if you&#39;re
</span>
<span id="L140">going to teach them a not reusable skill, make them like excited about something in programming like cool here&#39;s how to make a website and it
</span>
<span id="L141">wasn&#39;t fun but at least you can like submit a form when you&#39;re done or something. I don&#39;t know.
</span>
<span id="L142">Perfect Student
</span>
<span id="L143">Um, so I I do have to admit something. Uh, which is that see at MSU, Montana
</span>
<span id="L144">State University, not Michigan. Okay. Yeah. Uh, well, I don&#39;t like Michigan State either, so that&#39;s fine.
</span>
<span id="L145">I know. I spit on that. I spitting I spit on that thing. You [laughter] know how many like CEOs of
</span>
<span id="L146">HTMX right now are hanging on every word you&#39;re about to say? Oh, yes, they will.
</span>
<span id="L147">Montana. I have been to his office. I actually know where it&#39;s at. I know I know all about the EPS representing the
</span>
<span id="L148">engineering physical science building in which also has the computer science
</span>
<span id="L149">laboratory in all right anyways I digressed a little bit but uh during my time when I started in 2005 Java was the
</span>
<span id="L150">thing they taught and I man I hate to admit this I was a stellar student uh
</span>
<span id="L151">the programming language concepts I had such a high grade they had to throw up mine and then curved to the next one I
</span>
<span id="L152">got like 170% multiple times on on many tests. Okay. I was very very good at it. Wait, wait, wait, wait. 170%. Oh, after
</span>
<span id="L153">the curve after the after being thrown off and the new curve shifting me up so far.
</span>
<span id="L154">So, I was I was very very good at these things. Uh computer uh engineering to actually going through and and doing
</span>
<span id="L155">like addition from a CPU&#39;s perspective [laughter] on integers by hand. I didn&#39;t hear what Trash said. Um
</span>
<span id="L156">I&#39;m just kidding. I said what happened. Oh, what happened? [laughter] I&#39;m about to tell you that&#39;s the that&#39;s what this
</span>
<span id="L157">is me getting to the shameful part trash. Okay, let me tell the story in a way that is you know because you have to
</span>
<span id="L158">tell a story where people like oh he&#39;s just humble bragging and then I turn it around back on that. Now here&#39;s the thing bragging. [laughter]
</span>
<span id="L159">Yes. I only had one class on C and it was kind of like a brief one where it&#39;s
</span>
<span id="L160">like hey here&#39;s how to do a linked list in C. Here&#39;s how to do a few things and it wasn&#39;t really like that good. It was more like on the language of C. It was a
</span>
<span id="L161">100 level class like just like how to dip your toes into C. And the thing is is that after I graduated college,
</span>
<span id="L162">I could talk about heap and stack memory and all these things, but it didn&#39;t dawn on me until like a couple years after
</span>
<span id="L163">college that when I was programming C that I was writing either to the stack or to the heap because I never actually
</span>
<span id="L164">learned those things. So even though I aced every single thing, could do addition of a register by hand, I could
</span>
<span id="L165">multiplication. I used to know all that stuff, all the barrel fun stuff, I could do all the things, but I actually had no
</span>
<span id="L166">tying it together to the point where I just I did not understand it because they never taught
</span>
<span id="L167">C. I only knew Java. And I do think that that was a great disservice that I wasn&#39;t pushed further into that category
</span>
<span id="L168">where you take the theoretics like actually drawing the squares and then doing these squares in language in a
</span>
<span id="L169">very practical kind of sense. And like I really do I really do feel like I I greatly missed out on that because all
</span>
<span id="L170">practical assignments like doing AVL trees and everything were all done in Java. All my stuff was done in Java
</span>
<span id="L171">except for networking which was done in C. But again, you&#39;re just playing with like you know net.h H you&#39;re not
</span>
<span id="L172">actually you&#39;re not actually doing anything other than crafting UDP packets. So it&#39;s it&#39;s not quite the same thing. And so I do feel like I was
</span>
<span id="L173">certainly robbed and it it uh I actually still look back at that as like what a waste that was. I was learning so many
</span>
<span id="L174">things that I didn&#39;t understand how good they were, but I could pass exams. Like I could 100% all of them, but I
</span>
<span id="L175">literally learned nothing because I didn&#39;t have that like the t the real tie into everything. And so I look back at
</span>
<span id="L176">that as like a huge failure. And so I I do actually agree that I wish more things were in a sense reaching down as
</span>
<span id="L177">you say like that makes perfect sense replaying it against my past. I could leak code. Yeah. Yeah. I could leak code like a
</span>
<span id="L178">boss. Like I was that classic person that could come out and balance a tree but have no idea about anything else.
</span>
<span id="L179">Well and I think that gets to like Lor&#39;s like extending downward thing which is the crucial part, right? It&#39;s like you
</span>
<span id="L180">What should you be learning?
</span>
<span id="L181">did learn some C but you can&#39;t like it they can&#39;t just say oh here&#39;s the C language. Okay now you know everything.
</span>
<span id="L182">Like no, it&#39;s like the C language is just what what really we&#39;re saying is it&#39;s a way it&#39;s a framework that makes
</span>
<span id="L183">it easier to teach these concepts that you actually need to know. And again, it&#39;s not you can&#39;t teach
</span>
<span id="L184">another languages. Like one of the things I did on my Substack, right, is I&#39;m like, hey, here&#39;s this Python program. It&#39;s extremely slow to add the
</span>
<span id="L185">add numbers together and we can show why. Well, okay, we could we could use S Python to compile that Python into C.
</span>
<span id="L186">You could go reach for Pi Pi or something, but you like those are all these steps that now you have to do
</span>
<span id="L187">instead of just no, we can literally just write in this language without changing anything we&#39;re doing. We can
</span>
<span id="L188">just show exactly how to do the thing from here. It&#39;s a very short step, right? And so it&#39;s really just about
</span>
<span id="L189">it&#39;s a very it&#39;s just very convenient. It happens to hit a nice sweet spot. It&#39;s why it&#39;s been such an enduring language. there&#39;s so many things written
</span>
<span id="L190">in it. So it&#39;s easy to go look at the examples of people doing things like operating systems in it because that&#39;s what they write operating systems in
</span>
<span id="L191">blah blah blah blah right and so you know those languages and the C lineage languages like now successor
</span>
<span id="L192">languages like Rust that are trying to be you know C and then some new things without breaking the cess of them right
</span>
<span id="L193">um those are they&#39;re just easier to do this education I think I think that&#39;s
</span>
<span id="L194">just the bottom line and when you if you made me teach the same thing in Java it&#39;s just going to be
</span>
<span id="L195">harder for me to do that, right? Uh it&#39;s not that I couldn&#39;t, it&#39;s that it becomes just a lot harder to to uh
</span>
<span id="L196">uh to do it because it&#39;s the wrong base. It&#39;s the wrong base layer. And you know, that&#39;s I don&#39;t know how to how else to
</span>
<span id="L197">underscore that point. And I think that&#39;s what it might be really hard to do it at all. Like I&#39;m not I you know, at least when I was in my 1.6 days, I don&#39;t know if you
</span>
<span id="L198">can really disamiguate the stack in the heap. Yeah. Like in you knew up an object. I&#39;m not sure if you really understand what&#39;s going on
</span>
<span id="L199">there. Yeah. in like Java, I don&#39;t know how hard it would be to try to teach someone about like let&#39;s let&#39;s change the memory
</span>
<span id="L200">layout of these things, right? Uh you know, and you know, can I disable the garbage collector in some Javas, you
</span>
<span id="L201">know, can I go in there and and monkey with that stuff? I don&#39;t know. Uh but, you know, that would be the kinds of
</span>
<span id="L202">things that I start to have to think about if I&#39;m going to go, you know, use something like Python or Java, like how am I going to teach those things?
</span>
<span id="L203">whereas in C it&#39;s just like it it&#39;s just made um you know the people say like it doesn&#39;t matter anymore because we&#39;re not
</span>
<span id="L204">programming a PDP11 you know a obviously don&#39;t know anything about a PDP11 like they&#39;ve probably never even read the
</span>
<span id="L205">manual um it it had virtual memory so I don&#39;t know what they&#39;re say they like a
</span>
<span id="L206">linear address space like no it wasn&#39;t right like it has a it has an address it it has a a t page table uh a address
</span>
<span id="L207">translation table anyway so like there&#39;s weird weird stuff like that that people think But it&#39;s like, no, it really is.
</span>
<span id="L208">And even if I want to teach you down to the micro op level, it&#39;s very easy to do that in C. And and it&#39;s not that easy to
</span>
<span id="L209">do it another language for a variety of reasons. Uh and so languages like C um
</span>
<span id="L210">help. It also just kind of seems like what you know, if our goal, even if the
</span>
<span id="L211">goal isn&#39;t to get people a job from college or whatever, right? It&#39;s just like we want to teach them. Why would we make it harder than it needs to be? Like
</span>
<span id="L212">if it&#39;s like cool our goal at the end of this semester is that you understand the
</span>
<span id="L213">difference between stack and the heap and how it is managed in real programs like how it gets used. Cool. That&#39;s one
</span>
<span id="L214">of our syllabus goals. Then why are we picking a way that makes that harder to show than it has? Like it just seems
</span>
<span id="L215">that doesn&#39;t even make sense. You should just pick the one that&#39;s the best and like with the least number of hops and
</span>
<span id="L216">the least extra things that you need to do so you can focus on them actually learning like the primary task, right?
</span>
<span id="L217">Like if we&#39;re like, &quot;Cool, this this semester is about memory management.&quot; Then let&#39;s like teach them that. Let&#39;s
</span>
<span id="L218">not spend a bunch of time showing them like here&#39;s sealed classes in Java and why your homework didn&#39;t compile because
</span>
<span id="L219">we put this extra keyword here to make sure you couldn&#39;t do this and cheat and get the wrong, you know, like awesome.
</span>
<span id="L220">We didn&#39;t have to do we didn&#39;t have to do that, right? That&#39;s just like wasted time and effort. Well, and I I I guess I
</span>
<span id="L221">Heap or Stack
</span>
<span id="L222">mean just to uh to try to address people&#39;s concerns who complain about this. I I mean like one of the things
</span>
<span id="L223">that I saw mentioned while people were complaining about the Lori Wired uh uh
</span>
<span id="L224">inter interview I don&#39;t know what that thing was the pres presentation um was
</span>
<span id="L225">like oh but there&#39;s no difference between the stack and the heap right which is which is true in the sense of
</span>
<span id="L226">like they are stored in RAM right and so so I I agree with the statement that if
</span>
<span id="L227">you&#39;re if you&#39;re asking me about like does some is something taking up more
</span>
<span id="L228">space on the heap or the stack or something like that? Like I mean, you know, it there there&#39;s there&#39;s ways in
</span>
<span id="L229">which that makes sense to say and I might say it sometimes if someone asked me a question about like that where that
</span>
<span id="L230">was the correct answer. But it to say that there&#39;s no difference between the
</span>
<span id="L231">stack and the heap in terms of educating you about what&#39;s going on is ridiculous because literally there are a number of
</span>
<span id="L232">things in hardware that are about the stack. And it&#39;s not that they&#39;re storing
</span>
<span id="L233">it in some magic thing that&#39;s not RAM, right? Or something like this. Uh it&#39;s
</span>
<span id="L234">not that we&#39;re saying that. it&#39;s that there really are a bunch of things that are processor specific that have to do
</span>
<span id="L235">with dealing with the stack. And so you do need to understand that difference. So you need to be able to understand
</span>
<span id="L236">like what a push and a pop are like that&#39;s a thing that is specific to like what what is the stack pointer? That&#39;s a
</span>
<span id="L237">thing that&#39;s like in hardware. What is the return address stack that&#39;s in hardware not stored in RAM by the way?
</span>
<span id="L238">It&#39;s in a special thing inside the core, right? And so there&#39;s a number of things like that. And if you just fundamentally
</span>
<span id="L239">have no way of understanding what those two things are, that would be really bad. And furthermore, it would be really
</span>
<span id="L240">nice if when you write something in your language, whatever the teaching language is, that it&#39;s very direct. So if I have
</span>
<span id="L241">int x and I know that the int is four bytes, and that&#39;s going to translate into a push for or something like this,
</span>
<span id="L242">right? That&#39;s helpful, right? these these are help these are helpful things because there&#39;s a very short uh uh path
</span>
<span id="L243">to me showing you what happens versus a very complicated like very high level language where the it&#39;s like I got to
</span>
<span id="L244">trace you through 30 steps to show you how it got to the thing right and so again I just I think people are using
</span>
<span id="L245">they&#39;re using irrelevant differences to argue that there&#39;s no value but there
</span>
<span id="L246">but there is value like the fact that it&#39;s stored in RAM it&#39;s Uh,
</span>
<span id="L247">it&#39;s not easy. Uh, by the way, the stack is stored in the balls. Okay. It&#39;s not stored in RAM. That&#39;s ridiculous. Yeah. Yeah. It&#39;s in the It&#39;s a secundi
</span>
<span id="L248">stack. [clears throat] Classic stack. Yeah. TJ&#39;s not happy.
</span>
<span id="L249">I was really trying to find a way to make a joke about how nobody goes to Stack Overflow anymore. And I was more
</span>
<span id="L250">disappointed in myself in the inability to connect those two things together. Like, what? We don&#39;t need this stack
</span>
<span id="L251">anymore. We have chat GPT. but it just didn&#39;t connect. So, I was more
</span>
<span id="L252">disappointed with myself than than you two. Yeah. [laughter] Okay.
</span>
<span id="L253">Yeah. Well, I feel like we&#39;ve kind of touched all things, but Trash, I I kind of want to get your last last thoughts here as
</span>
<span id="L254">Outro
</span>
<span id="L255">we close this bad boy down. Can you uh give us your last thoughts, and I want you to close down the episode? [clears throat] My last thoughts is,
</span>
<span id="L256">[sighs] how should I say this? I think these arguments are very tiring
</span>
<span id="L257">and meaningless in most cases. Um I very much don&#39;t enjoy reading them at all. Uh
</span>
<span id="L258">I do think it&#39;s helpful that we are bringing it to light. I do think there is some importance of you know telling
</span>
<span id="L259">people what they what they should and shouldn&#39;t learn. I think ultimately it&#39;s going to depend on the person. So even
</span>
<span id="L260">if you were to teach someone C, it&#39;s going to be up to them if they want to take it even deeper. I don&#39;t think it&#39;s going to be up to the school to kind of
</span>
<span id="L261">push them to want to learn these things. Um, but in my humble opinion, I think if you
</span>
<span id="L262">want to make it in this day and age of AI, you should really try a lot harder than you&#39;re trying now because it&#39;s
</span>
<span id="L263">going to be even harder to uh stand out amongst the rest. Um, so for those that
</span>
<span id="L264">are unemployed watching this, I think uh yeah, keep up the good fight and try
</span>
<span id="L265">super duper hard because I I can&#39;t imagine what it&#39;s like to be in your
</span>
<span id="L266">shoes right now. And with the age of AI, I know it&#39;s pretty terrifying. And I know myself what I&#39;m doing is I&#39;m making
</span>
<span id="L267">sure that I&#39;m still studying because, you know, one day I won&#39;t have the job I have now. And Lord knows what I need to
</span>
<span id="L268">know when I have to go back in interviewing pool. I think it&#39;s going to be a completely different ballgame. So, I&#39;m actually going down the hole of just
</span>
<span id="L269">like understanding everything at a low level because I think that&#39;s the only way I&#39;m going to stand out to be honest. Um, if you want me to code something, I
</span>
<span id="L270">mean, I just literally type into a text box and it will pop out. So, yeah, those
</span>
<span id="L271">are my those are my thoughts. Kind of depressing, but that&#39;s kind of just how I&#39;ve been feeling lately. Um, I think AI
</span>
<span id="L272">is honestly kind of depressing me if I&#39;m being quite honest. And I think the only way I can uh take those emotions back is
</span>
<span id="L273">to actually challenge myself outside of like the workspace and using AI and just
</span>
<span id="L274">trying to build things for me. Um so
</span>
<span id="L275">that was kind of sad, huh? Yeah. No, dude. That was good. [laughter] This was an emotional ending. That was an emotional ending to the the thing.
</span>
<span id="L276">Trash, I think we should unpack this a little bit more later, too, cuz I&#39;m interested to hear more of what you&#39;re thinking.
</span>
<span id="L277">Yeah. Yeah. Yeah, for sure. Mhm. We can. We can. I know many other people feel the same
</span>
<span id="L278">way. So Mhm. Yep. Well, let&#39;s [laughter] Would you like to
</span>
<span id="L279">also close it out though? Trash. Thank you for watching the standup with the prime gym. I am Trash featuring
</span>
<span id="L280">legendary programmer case and Tee. Right back [applause] at you, baby.
</span>
<span id="L281">Thanks. Hey, well, I put Doom inside of a Neoim guy today. Okay, trash. [laughter] I saw
</span>
<span id="L282">Can we stop? Can we Can we get the G out of Neo Vim Gooey? It just looks like text still. It just looks like
</span>
<span id="L283">Casey, did you see? I don&#39;t think I don&#39;t think you realize. Did you see me put a circle? I put a
</span>
<span id="L284">circle in, but it&#39;s just like you&#39;re just putting some a somebody else drawing graphics on
</span>
<span id="L285">top of your text. It&#39;s just wait,
</span>
<span id="L286">man. delusions of grandeur with the Neoim people. What can I do to convince you it&#39;s a
</span>
<span id="L287">real GU? I don&#39;t know. Have like a lot of images in the the graphs happening like next to
</span>
<span id="L288">the code or something like give me something I can sink my teeth into. T TJ the thing that I told you to put into
</span>
<span id="L289">Neo. Yeah, that&#39;s what he wants to see. Yeah. The thing that you told me to put in Neoim. I wasn&#39;t listening probably. What
</span>
<span id="L290">did you tell me to put? Yes, you were. We laughed about it this morning. I&#39;m very offended that you&#39;ve already forgot. If you&#39;re not spending a
</span>
<span id="L291">million dollars in tokens, I don&#39;t think you&#39;re get Well, to impress me, Casey, I will. We&#39;re going to spend a million dollars in tokens and
</span>
<span id="L292">get me a Neovim guy that actually looks G instead of T in the front of UI. Got it.
</span>
<span id="L293">That&#39;s my That&#39;s my assignment. This I&#39;ll come back with something next week and I&#39;ll present it. All right.
</span>
<span id="L294">Thank you everybody. Bye. Bye. Bye. Boot [singing] up today.
</span>
<span id="L295">Five [music] errors [singing] on my screen. Terminal coffee
</span>
<span id="L296">and living the dream.</span></code></pre></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("source/rawTranscript.txt.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const rawTranscript_txt = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  rawTranscript_txt as default
};
