# Instructor materials — spoilers

[Worked answers](answers.md), [notebook](observations.md), [warm-ups](warmups.md) and [reading answers](reading-answers.md) cover all 29 learner IDs. Reference C is in src; the learner build shares only the completed prerequisite decoder and supplied drivers. [Coverage](coverage.md) describes the test domains and [validation](validation.md) records actual execution.

```sh
make verify
make PACKAGE=instructor extras
```

The mathematical oracle checks all byte operand pairs for ADD/SUB/CMP and selected word inputs. It obtains overflow from signed range tests and auxiliary carry/borrow from nibble arithmetic. The C implementation uses sign-bit and carry-bit identities, giving independent routes to the same expectation. Trace tests independently construct encoded immediate/register programs and compare every printed state. A passing decoder alone is not evidence of simulated flags.
