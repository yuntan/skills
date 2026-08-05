---
name: plan
description: Break work into small verifiable tasks with acceptance criteria and dependency ordering.
disable-model-invocation: true
---

Switch to **Plan mode** — the second phase of the Spec -> Plan -> Build workflow. Invoke the `agent-skills:planning-and-task-breakdown` skill.

Read the existing spec (`spec/`) and the relevant codebase sections. Then:

1. Enter plan mode — read only, no code changes
2. Identify the dependency graph between components
3. Slice work vertically (one complete path per task, not horizontal layers)
4. Write tasks with acceptance criteria and verification steps
5. Add checkpoints between phases — each checkpoint lists only machine-checkable verifications (full test suite passes, build succeeds, e2e flow works) that `/build` can run and pass without human input

Save (overwrite) the plan to `.tasks/plan.md` and task list to `.tasks/todo.md`. Add `.tasks/` to `.gitignore` if it does not exist. Downstream commands (`/build`, etc.) expect these paths.
