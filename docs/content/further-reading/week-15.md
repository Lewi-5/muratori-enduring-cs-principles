# Week 15 further reading · Sorting: complexity and measured cost

[Lesson](/weeks/week-15) · [Beginner section](/beginners/week-15)

You have two programs that return the same sorted records. One does fewer comparisons, yet on a small input it may take longer. Begin with Scott’s “Speed”: instruction work is a useful first question, but does not settle the whole elapsed-time question. Its teaching computer is not the CPU used by this benchmark.

Next read Beej’s function-pointer discussion to understand comparator callbacks, then the C Library Reference qsort contract. The difficult boundary is that a library function can promise ordering without promising the stable algorithm this lesson requires. Our tagged oracle adds an original-position tie breaker to obtain an independent expected record sequence; it does not claim qsort itself is stable.

Dive Into Systems’ locality section asks which storage is reused and which accesses are nearby. Keep the three sorting loops beside the reading and mark scratch traffic. CS 341’s pointer arithmetic explanation helps with the array bounds that must remain valid during moves; use it before optimizing indices. These texts support the access reasoning but do not specify the lesson’s counter policy.

CS:APP’s locality and memory-performance sections deepen that question: extra buffers, cache residency and dependencies can affect a realized cost. They are harder because several effects interact. Read after obtaining correct data, and state a hypothesis before treating a timing as evidence for one particular effect. Finally read Hennessy and Patterson’s measurement/reporting section for how to communicate conditions and variation. Big O and a repeated minimum answer different questions; neither replaces an independent permutation/stability test.

Watch the HH sorting portions for scale, storage and stable-digit reasoning. CE repetition testing provides a favorable-observation protocol amid hidden state; it does not mandate one fastest sort. All seven companion texts have roles below, with explicit gaps. Optional deeper reading adds time beyond the unpiloted core budget.

## Cross-reference

<!-- crossref -->

## Reading questions

<!-- reading-questions -->
