# Glossary

Use these short definitions as reminders after reading the explanations in the weeks. Each term names a specific distinction; the examples in the chapters show how to use it.

| Term | Meaning in this course |
| --- | --- |
| Object | A region of storage that represents a value under the C model |
| Representation | The stored bits or bytes used to express a value |
| Byte | C's addressable object-size unit; `CHAR_BIT` gives its bit count |
| Extent | The size of the region available to an object or operation |
| Offset | A distance from a named starting position, with stated units |
| Alignment | A restriction on the positions where an object may begin |
| Padding | Space in a representation not occupied by the named top-level members |
| Stride | The distance from one array element's start to the next |
| Pointer | A value used to identify an object, function, or permitted boundary position |
| Lifetime | The interval during which a particular object exists |
| Scope | The part of source where a name can be used |
| Linkage | Whether declarations can identify the same entity across scopes or files |
| Ownership | The program's rule for who is responsible for a resource and its release |
| Translation unit | The source compiled after preprocessing and inclusion |
| ABI | The target agreement used by compiled components for representation and calling conventions |
| ISA | The architecture's defined instructions and their behavior or encodings |
| Invariant | A statement maintained across a repeated operation or state transition |
| Undefined behavior | An operation for which the C standard imposes no requirements |
| Implementation-defined | A choice the implementation must document where the standard permits alternatives |
| Unspecified | A permitted choice for which the standard does not require the implementation to document the selection |
| Binary64 | The floating-point format with 1 sign, 11 exponent, and 52 stored fraction bits used by the gated experiments |
| NaN | A floating-point not-a-number value, with special comparison behavior |
| Subnormal | A floating-point value using the smallest exponent scale without the normal implicit leading one |
| Tolerance | An explicitly justified numerical acceptance threshold |
| ULP | A unit associated with spacing between representable floating-point values; the exercise defines its step-distance convention |
| Microdegree | One millionth of a degree, represented by an integer in CSV generation |
| Grammar | The accepted forms of an input language |
| Canonical | The one chosen spelling or representation among possible alternatives |
| Oracle | An independent source of expected results with its own assumptions and limits |
| Fixture | A saved input or expected artifact chosen to test a specific behavior |
| Baseline | The recorded correct implementation and experiment against which later changes are compared |
| Median | The middle order statistic, or the defined midpoint of the two central values |
| Opcode | Instruction bits that select an operation or encoding form |
| Immediate | A value carried directly in the instruction encoding |
| ModR/M | An x86 encoding byte containing mode, register, and register/memory fields |
| Disassembly | Interpreting machine-code bytes as instruction text for a selected architecture |
| Sign extension | Widening a signed bit pattern while preserving its interpreted value |
| Validate-then-commit | Checking a complete request before publishing a result to the caller |
