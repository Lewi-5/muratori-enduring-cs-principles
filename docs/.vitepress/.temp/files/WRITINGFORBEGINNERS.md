# Writing for beginners

These are the principles used to rewrite the beginner companion of the *Packets Up* networking course, modelled on Charles Severance's *Introduction to Networking* ([net-intro.com](https://www.net-intro.com/)). They apply to any technical course where the reader is intelligent and motivated but new to the subject: networking, C, memory, compilers, operating systems.

The short version: **a beginner's chapter is not a summary for someone who already knows. It is an explanation for someone who doesn't, written so that they finish it able to reason, not just recite.**

---

## What went wrong before

Here is the paragraph that prompted the rewrite:

> Opening a pcap reads saved bytes and needs no capture privilege. Live Wireshark uses dumpcap plus an OS capture mechanism (Npcap on Windows, libpcap-based tooling on Linux). WSL is a separate Linux network view; its eth0 is not your laptop's Wi-Fi radio. Python's socket module asks the OS to perform networking; it does not inspect an adapter by itself.

Every sentence is true, and the paragraph is useless to a beginner. It is a list of conclusions with the reasoning removed. It uses six unexplained names in four sentences. It answers questions the reader has not yet asked. An expert nods along; a beginner learns nothing, because there is nothing to hold on to.

The rewrite of the same material starts like this:

> Picture your first evening with this course. You have installed Wireshark, you double-click its icon, and a window opens with a list of names: *Wi-Fi*, *Ethernet*, *Loopback*, perhaps a few *vEthernet* entries you have never heard of. Each has a small wiggling line beside it. Someone has also handed you a file called `sample.pcap`. It is natural to assume that Wireshark is somehow "plugged into" the network, and that opening the file and watching the wiggling lines are the same kind of activity.
>
> They are not, and untangling that is the first real networking lesson.

Then it builds the distinction with an analogy (a tape recorder versus a transcript), introduces each program only when the reader needs it, and keeps every fact from the original. The facts survived. What changed is that they now arrive as answers.

---

## The principles

### 1. Open with a situation, not a definition

Begin every section with a moment the reader is actually in, or will soon be in: a screen they are looking at, a command they just ran, a failure a colleague reported. The situation creates the question the section then answers.

- Networking: *"You type `ping 1.1.1.1`, press Enter, and a line comes back a few milliseconds later. It feels like one event."*
- Networking: *"You write a chat client that sends two messages. On the server, the first `recv()` returns just two bytes: `PU`."*
- C: *"You print a `float` that should be 0.3 and get 0.30000001192092896."*
- C: *"You declare a struct with a `char` and an `int`, call `sizeof`, and get 8, not 5."*

A good opening situation contains a small surprise or a hidden complexity. "It feels like one event. In fact..." is the most reliable shape there is.

### 2. Explain the problem before the solution

Every mechanism exists because someone hit a problem. Tell the reader the problem first, so the mechanism arrives as the obvious answer rather than an arbitrary rule.

- TTL isn't "an 8-bit field decremented per hop". It's the answer to *what stops a packet circling forever between confused routers?*
- DHCP's odd `0.0.0.0 → 255.255.255.255` addressing is the answer to *how do you ask a server for an address when you have no address and don't know the server's?*
- Struct padding is the answer to *what happens when the processor reads a 4-byte integer that starts at an odd address?*

Severance does this constantly: the transport layer exists *because* the IP layer loses packets, and he says so before describing TCP. If you can't state the problem a thing solves, you're not ready to explain the thing.

### 3. Define every term before you lean on it

Never assume the reader knows a word because it is common among practitioners. "Offset", "header", "payload", "port", "socket", "endianness", "stack frame" all need introducing the first time they carry weight.

Define it in plain words, give an example, and say *why it exists*. The offset rewrite went like this:

> Think of a paper form with boxes: surname in the first box, given name in the second, date of birth in the third. Once everyone has agreed on the layout, you do not need to write "SURNAME:" in front of the surname. The box's position says it. Protocol headers are forms of exactly this kind...

The reader now knows what an offset is, why protocols use them, and why a byte has no meaning without one.

Then keep the term exactly as defined. If an offset is "a distance from a stated starting position", every later offset must name its starting position ("file offset 54, frame offset 14, IP offset 0"). Consistency is how definitions become tools.

### 4. One idea per paragraph, in plain sentences

- Short paragraphs, each making one point.
- Mostly short sentences. Vary them, but don't nest clauses three deep.
- Plain words: *use* not *utilize*, *about* not *regarding*.
- Avoid slash-lists and compressed shorthand in prose ("inputs/state/outputs", "read/change/inspect"). They save the writer effort and cost the reader it.
- No hype, no exclamation marks, no "simply" or "just" in front of anything the reader might find hard.

Glossary tables can stay terse; the explanatory prose must not.

### 5. Use an everyday analogy, then say where it breaks

A good analogy lets the reader borrow intuition they already have: postcards for addresses, envelopes-inside-envelopes for encapsulation, telephone extensions for ports, a cloakroom ticket for a file handle, a festival wristband for a Kerberos ticket, a security camera overwriting old tape for a ring buffer.

Choose analogies that match the *mechanism*, not just the vibe. "A switch learns where people sit by watching which door their letters come through" matches how MAC learning works. "The router is like a brain" matches nothing.

Then mark the boundary. Every analogy fails somewhere, and a beginner can't tell where on their own. The TTL analogy of an expiry date is fine until you note that it counts hops, not seconds, despite its name.

### 6. Show the real thing, and check it

Whenever the subject has concrete artefacts, such as bytes, packets, output or assembly, show real ones and walk through them. Week 2's concepts section walks the entire 87-byte sample capture in a table: which bytes belong to the file header, which to Ethernet, IP, UDP and payload, and what each means.

Then **verify every concrete value against the real artefact**. During the rewrite, checking against the actual captures caught several invented details: a byte line that didn't match the file, a response interval measured from the wrong event (1.010 s from the ACK, 1.020 s from the request), a cookie header missing its `Path=/`, a Lua protocol name with the wrong capitalisation. A beginner will type what you wrote and compare. If it doesn't match, they will blame themselves.

For a C course: compile the example, run it, paste the actual output, and note the compiler and platform if the output depends on them.

### 7. Separate things that look alike

Most beginner confusion comes from merging two distinct ideas that share a word or a screen. Name both, and put them side by side:

- reading a capture versus recording one;
- a protocol (SMB) versus a program that implements it (Samba) versus a process (`smbd`);
- a capture filter versus a display filter;
- flow control versus congestion control;
- signing versus encryption;
- declaration versus definition; the value versus its representation; the pointer versus what it points at.

Comparison tables are the right tool here: one row per thing, columns for "what it is", "what it reads", "what it changes", "what it can't tell you".

### 8. Say what each tool or claim can and cannot establish

Beginners over-trust tools. Every tool introduction should say what its output proves and, just as importantly, what it doesn't:

- A reply to ping proves this ICMP exchange worked, not that a web server is running.
- A TLS certificate proves a key is bound to a name, not that the site is honest.
- A hash proves two files are identical, not where the bytes came from.
- A passing test proves the tested cases, not the program.

This is the habit that turns a learner into an analyst. Keep **observation** (what a field shows), **inference** (what that suggests) and **uncertainty** (what the evidence cannot show) visibly apart.

### 9. Build from what the reader already knows

Tie each new idea back to earlier ones by name: "This is Week 17's framing problem again", "the TLV encoding from Week 11", "Severance's offset, now per stream". Recurring ideas (offsets, framing, demultiplexing, matching replies to requests with identifiers) become familiar friends rather than new facts each time.

Callbacks also show the reader that the subject is small at its core. There are a handful of deep ideas, reappearing in new costumes.

### 10. Be honest about simplifications, including your source's

Introductory explanations simplify, and that's fine, as long as you say so when it matters. Where Severance's book smooths over something the course relies on, the page names it:

- TTL "starts at about 30" (real systems use 64 or 128);
- Wi-Fi described with collision *detection* (it actually uses collision *avoidance*);
- gateway discovery shown without ARP;
- TLS described as encrypting with the server's public key (modern TLS uses ephemeral key exchange).

The same applies to your own text. "This is the classic model; real stacks add..." costs one sentence and prevents a false belief that would otherwise need unlearning.

### 11. Keep every fact when you rewrite for style

A readability rewrite must not quietly drop content. Before replacing a section, list every fact, caution, link and instruction in the old version, and check each one appears in the new version. The networking rewrite kept every sentence's substance, often word for word, now embedded in explanation. Style is added; nothing is subtracted.

### 12. Give each section a shape

A reliable structure for a concept section:

1. **Situation**: the moment the reader is in, and the hidden question.
2. **Why it exists**: the problem.
3. **Build-up**: sub-headings, each one idea, each defining its terms.
4. **Concrete walk-through**: real bytes, output or a worked example.
5. **Comparison**: a table where similar things must be told apart.
6. **Cautions**: what the evidence or tool cannot show; common traps.
7. **Read alongside**: precise pointers to a gentler second explanation.

For a tool section: situation → what job each tool does → what it reads, what it changes, what privileges it needs → one comparison table → the first small check before touching anything live.

### 13. Draw the mechanism, simply

A small ASCII diagram often does more than a paragraph: a packet's journey with the capture point marked, nested headers, a sequence-number timeline, a request/response exchange.

- Draw the real mechanism, not a decoration.
- Prefer linear forms (`[Ethernet [IP [UDP payload]]]`) over nested boxes whose alignment breaks in different fonts.
- Label both ends of every arrow.

### 14. Point to a gentler companion, precisely

Pair each section with a specific reading in an approachable book, and cite it exactly: chapter, section title, printed page and PDF page. "Severance, §6.1 Packet Headers (book p. 63, PDF p. 71)" is usable; "see Severance chapter 6" is not.

Check the citations. In the networking course, a script verified all 171 against the book's table of contents.

For the C course, the same role can be played by whichever approachable text the syllabus adopts. Pick one gentle book and cite it consistently, rather than many books vaguely.

### 15. Quote sparingly and paraphrase honestly

Explain in your own words. Quote the source only when its exact phrasing is the point, keep quotations short, and attribute them. Never put your paraphrase inside quotation marks as if the author wrote it.

---

## Voice

- **Second person, present tense.** "You open the file." The reader is doing this, now.
- **Warm, not cute.** Friendly and calm, never jokey at the expense of clarity.
- **Confident about facts, humble about inference.** "Frame 8 is a 404" is stated flatly; "the link was probably outdated" is marked as a hypothesis with a test.
- **Respectful of intelligence.** Assume the reader is smart and new, not slow. Explain fully once, then trust them.

## Length

A beginner chapter is long because it contains the reasoning, not because it's padded. In the networking rewrite, each tools section grew from about 150 words to 550–1,300, and each concepts section from about 100 to 1,100–1,750. The test for every paragraph is whether a beginner would be worse off without it. If yes, it stays; if no, cut it.

---

## Checklist before publishing a section

- [ ] Does it open with a situation the reader is actually in?
- [ ] Is the problem stated before the mechanism?
- [ ] Is every technical term defined in plain words before it carries weight, and used consistently after?
- [ ] Does each analogy match the mechanism, and is its limit stated where it matters?
- [ ] Is every concrete value (byte, number, output line, name) checked against the real artefact?
- [ ] Are look-alike concepts explicitly separated, ideally in a table?
- [ ] Does each tool or claim say what it can *and cannot* establish?
- [ ] Are simplifications, yours and your source's, named where they matter?
- [ ] If this is a rewrite, is every fact, caution and link from the old version still present?
- [ ] Does it link back to earlier ideas by name?
- [ ] Does it end with a precise pointer to a gentler companion reading?
- [ ] Would a smart newcomer finish it able to *reason* about the topic, not just repeat it?
