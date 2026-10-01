# Week 10 instructor materials

Keep these files separate while learners attempt the assignment. [answers](answers.md) covers every core, practice and stretch prompt; [observations](observations.md) gives a complete notebook exemplar; [warmups](warmups.md) and [reading answers](reading-answers.md) complete the beginner layers.

The four files in src are annotated working reference implementations. The runner uses a local Machine; the step also uses a local Machine, so an invalid RET or exhausted run cannot leak popped SP or earlier data writes. This favors clear transaction boundaries over host throughput. The boundary scan is intentionally repeated by machine_step; S02 explains an optimization that retains the contract.

From week-10 run `make verify`. [Coverage](coverage.md) maps requests to answers and [validation](validation.md) records actual commands and outcomes. Passing checks establish these fixtures and domains, not all historical opcodes, real segmentation or modern CPU performance.
