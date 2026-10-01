# Beginner sections

Every week of the course starts with a lesson written for experienced C programmers. The beginner section is a way into that lesson for anyone, including readers who have written C for years without ever looking at the mechanism the week is about. It moves more slowly, starts further back, and shows real output for each claim. It never changes the lesson or its graded exercises.

## How a beginner section is shaped

Each one has the same parts, in the same order:

| Part | What it gives you |
| --- | --- |
| **Purpose and prerequisites** | What you will be able to do afterwards, roughly how long it takes, and what to refresh from earlier weeks |
| **Vocabulary** | Every term the week leans on, in plain words, before it carries any weight |
| **Concepts** | Short sections that each open with a situation you are actually in, then explain the problem before the mechanism |
| **Walk-through** | One concrete example worked by hand and checked with real output |
| **Warm-ups** | Three to five small, ungraded programs (`W01…`), each leading into one exercise of the lesson, with tests and written answers |
| **Check yourself** | Questions with answers you can reveal after trying |
| **Ready for the lesson** | A checklist tied to the lesson's exercises |
| **Read alongside** | The gentlest readings for this week, with the full list on the further-reading page |

Every program shown on a beginner page is a real file in `docs/examples/`, compiled with GCC and Clang, and its printed output is checked automatically. If a page says a program prints something, it does.

## How to use them

Read the beginner section before the lesson, or keep it open beside the lesson and go back to it when an exercise assumes something you have not met. Do the warm-ups: from the week's directory, `make warmups` checks only them. After the lesson, the week's further-reading page guides you into seven companion texts, from the gentlest to the deepest, and ties each to the videos you watched.

Time spent here is additional to the lesson's budget. The beginner section is the part of each week that everyone can start and finish.

## Available sections

- [Week 1 · C as an inspectable starting point](/beginners/week-01)
- [Week 3 · Numbers in a box](/beginners/week-03)
- [Week 7 · Describing an address](/beginners/week-07)
- [Week 8 · An instruction changes state](/beginners/week-08)
- [Week 9 · Choose the next instruction](/beginners/week-09)
- [Week 10 · Save a place to return](/beginners/week-10)
- [Week 11 · A call has an agreement](/beginners/week-11)
- [Week 12 · What does a passing trace prove?](/beginners/week-12)
- [Week 13 · Wall time versus timestamp counters](/beginners/week-13)
- [Week 14 · Inclusive time, exclusive time and measurement overhead](/beginners/week-14)

Beginner sections for the other built weeks are being written to the same pattern; the [reading map](/reference/reading-map) already covers all 52 weeks.
