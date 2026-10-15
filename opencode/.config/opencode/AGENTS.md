# Global Development Standards

## Core Principle

Write code that a competent human developer would be comfortable
maintaining six months from now.

Prefer simple, explicit, readable solutions over clever, abstract,
or unnecessarily generalized ones.

## Before Coding

Do not immediately start implementing a request.

First inspect the relevant parts of the codebase and determine:

- where the behavior belongs
- how similar functionality is implemented
- which existing utilities/components/services can be reused
- what conventions the surrounding code follows
- what tests already exist

Only then implement the change.

Do not ask the user questions that can be answered by inspecting
the repository.

## Code Quality

- Follow the existing architecture and conventions before introducing new patterns.
- Prefer the simplest implementation that correctly solves the problem.
- Do not over-engineer for hypothetical future requirements.
- Avoid unnecessary abstractions, wrappers, helpers, or indirection.
- Keep functions and modules focused.
- Use descriptive names rather than comments to explain obvious behavior.
- Reuse existing utilities and patterns when they are appropriate.
- Do not duplicate logic unnecessarily.
- Preserve existing behavior unless the task explicitly requires changing it.

## Comments

Comments should explain WHY, not WHAT.

Do not add comments that merely restate the code.

Avoid:

- comments on self-explanatory code
- large explanatory blocks
- comments for every function or variable
- generated-looking documentation

Use comments when they explain:

- a non-obvious decision
- a workaround
- an important constraint
- unusual business logic
- behavior that would otherwise be surprising

Keep comments concise.

## Changes

Before modifying code:

1. Understand the relevant existing code.
2. Identify the established patterns.
3. Make the smallest coherent change that solves the problem.

Do not modify unrelated files or refactor unrelated code unless necessary.

## Verification

Never assume code works simply because it looks correct.

After making changes:

1. Run the most relevant formatter/linter/type checker.
2. Run relevant tests.
3. For behavior changes, perform an appropriate runtime or integration check.
4. Inspect the final diff.
5. Remove accidental changes, dead code, debug code, and unnecessary complexity.

If verification cannot be performed, explicitly state what could not be verified.

## Self-review

Before declaring a task complete, ask:

- Is this simpler than it needs to be?
- Is every changed line necessary?
- Does this follow the existing project patterns?
- Would another developer understand this without asking the author?
- Did I introduce unnecessary abstraction?
- Did I add unnecessary comments?
- Did I handle important error cases?
- Did I actually verify the behavior?

Do not declare completion merely because the implementation compiles.

## Communication

Keep responses concise, direct, and easy to scan.

- Lead with the answer or action taken.
- Do not repeat the user's request.
- Do not restate information that has already been established.
- Avoid unnecessary introductions, conclusions, and summaries.
- Prefer short paragraphs and bullets when they improve readability.
- Explain reasoning only when it materially helps the user understand a decision.
- Do not narrate every action being performed.
- Do not provide information that was not requested unless it is important
  to correctness, safety, or the user's next action.
- When reporting completed work, summarize only:
  - what changed
  - important decisions
  - verification performed
  - anything that remains unresolved
- Do not repeat the same conclusion in different words.
- Avoid filler such as "Sure", "Absolutely", "Of course", or "Here's what I did"
  unless it adds useful context.
- Prefer precise technical language over verbose explanations.

### Response Length

Use the minimum amount of text necessary to communicate the answer clearly.

For simple tasks:

- 1–5 sentences is usually enough.

For implementation tasks:

- briefly state what was changed
- list important details only
- state verification results

For complex tasks:

- use headings and bullets
- explain only the decisions that require explanation

Do not make a response longer merely to appear thorough.
