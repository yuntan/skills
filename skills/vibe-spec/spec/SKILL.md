---
name: spec
description: Start spec-driven development — write a structured specification before writing code. Use when starting a new project, feature, or significant change, or when requirements are unclear, ambiguous, or only exist as a vague idea, or when the change touches multiple files or modules, or when an architectural decision is involved. Skip for single-line fixes, typo corrections, or changes where requirements are unambiguous and self-contained.
---

Switch to **Spec mode** — the first phase of the Spec -> Plan -> Build workflow. Invoke the `agent-skills:spec-driven-development` skill.

## Locate the Target Spec First (default: update, don't create)

**Before writing anything, find where this change belongs.** Most projects already keep specs. The default action is to **update the existing spec file(s) the change touches, in place** — not to create a new monolithic `spec/spec.md`.

1. Read `CLAUDE.md` to learn the repo's spec layout and conventions.
2. Identify which existing document(s) the requirement belongs to (a feature change edits its domain/contract/platform spec; a cross-cutting change like a rename edits every doc it touches).
3. **Only create a new file when no existing spec covers the topic** — and then name and place it to match the repo's convention (e.g. `spec/<domain>.md`, `spec/platforms/<x>.md`), never a generic `spec/spec.md` unless the repo has no `spec/` structure at all.

Ask clarifying questions where the requirement is ambiguous:

1. The objective and target users
2. Core features and acceptance criteria
3. Tech stack preferences and constraints
4. Known boundaries (what to always do, ask first about, and never do)

## Update the Existing Spec

Read the target document(s), then update them based on the new requirements. Cover the relevant core areas (objective, commands, project structure, code style, testing strategy, boundaries) **within the existing document's structure** — extend and revise its sections rather than bolting on a parallel spec. Check for inconsistencies with sibling specs and keep them coherent.

## New Spec (only when nothing fits)

When the change genuinely has no home in the existing specs, generate a structured spec covering all six core areas, and save it under `spec/` following the repo's naming convention.

## Implementation

Investigate the implementation to keep the spec accurate (find inconsistencies, verify feasibility), but do not propose implementation changes. Implementation happens separately: the user runs `/plan` to break the spec into tasks, then `/build` to implement them.
