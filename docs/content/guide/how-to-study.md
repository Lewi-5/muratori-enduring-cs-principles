# How to complete a week

You open an exercise and recognize enough syntax to start typing. Pause long enough to say what the exercise is investigating. A program that passes tests without a model behind it leaves you poorly prepared when the next input behaves differently.

## Read, predict, implement, inspect, explain

First read the chapter's opening situation and conceptual sections. Use the readings to answer the questions stated beside them. You do not need to memorize the standard or watch every minute of an unrelated long episode.

Next read the contract. Identify inputs, outputs, accepted limits, and failure behavior. Find the supplied driver and the function you must implement. Write one small successful example and one boundary example on paper. Record your prediction before running anything that would reveal the answer.

Implement in small steps. Run the relevant checks and distinguish compiler diagnostics from behavioral failures. When a test fails, identify the violated contract before changing code. If your prediction fails, preserve it and add the explanation you now have.

Finally, connect source to mechanism and observation. “It works” omits the most transferable part of the exercise. Say why a bound prevents overflow, how a layout creates an offset, or why two instructions can have the same text.

## Understand the stable IDs

| ID | What it asks for |
| --- | --- |
| `E01.C` and other `.C` entries | The concrete implementation or experiment and its checks |
| `E01.Q` and other `.Q` entries | The written reasoning that accompanies it |
| `P01` and other P entries | Ungraded practice that prepares that reasoning |
| `S01` and other S entries | Optional stretch work beyond the core time budget |
| `R01` and other R entries | Required notebook or report sections |

Retain these IDs in your work. The site imports their contracts from the original package, and every one links to its corresponding answer. An exercise can require a protocol or a prediction rather than a new C function; read the `.C` label as the concrete task, not permission to skip written artifacts.

## Use hints and answers deliberately

Hints are expandable within the lesson. Open one when you can name the point at which your reasoning stops. The separate solution pages contain full implementations and explanations, and are excluded from search so ordinary searches do not unexpectedly reveal answers.

After an honest attempt, compare approaches. If a reference uses a different method, ask which invariant or contract both preserve. Re-run your own tests after changes and explain what you learned. A reference report's historical measurements are examples of reporting, not values for your machine to reproduce.

## Keep a claim ledger

A **claim ledger** records both a statement and its authority. “The C standard defines unsigned wraparound” and “this GCC build uses these instructions” belong to different categories. Add a source or command for each statement and name any assumptions.

A useful notebook paragraph has this shape:

> I expected X because of rule Y. The recorded run showed Z under these flags. The difference is explained by mechanism M. This does not establish N; checking N would require another observation.

This is a writing aid, not text to repeat mechanically. Use concrete expressions, numbers, and files from the exercise.

## Pace and finishing

Treat required correctness work, explanations, and report sections as the core. Stretch tasks add time. The existing budgets assume experienced C programmers and remain unpiloted; record actual time and points where more preparation was needed.

Before moving on, review the rubric, your unanswered questions, and the week's handoff. You are ready when you can explain the important mechanism and its limits, not only when the test runner returns zero.
