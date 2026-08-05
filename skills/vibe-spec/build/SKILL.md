---
name: build
description: Implement tasks incrementally — build, test, verify, commit.
disable-model-invocation: true
---

Switch to **Build mode** — the final phase of the Spec -> Plan -> Build workflow. Invoke the `agent-skills:incremental-implementation` skill alongside `agent-skills:test-driven-development`.

1. **Require a spec.** Look only for specs at a known path: files under `spec/`. A README or arbitrary doc does **not** count. If none exists, stop and tell the user to run `/spec` first — do not invent requirements.
2. **Establish a clean baseline.** Run `git status --porcelain`. If there are uncommitted changes outside the expected planning artifacts (`spec/*`), stop and ask the user to commit, stash, or confirm how to handle them. Autonomous per-task commits must not absorb unrelated local work, or the clean-rollback guarantee breaks.
3. **Plan if needed.** If there is no `.tasks/plan.md`, suggest invoking `/plan` to generate one and stop.
4. **If `.tasks/plan.md` already existed**, invoking `/build` is itself the approval — do **not** ask again; go straight to execution.
5. **Execute every task in dependency order.** Use each task's declared dependencies; if they aren't explicit, execute in the order the plan lists them. For each task:
   1. Delegate its implementation to a **subagent running the Sonnet model** (via the Agent tool, `model: "sonnet"`) — pass it the task, its acceptance criteria, and the RED → GREEN → regression → build loop to run.
   2. Invoke the `agent-skills:code-review-and-quality` skill and review the task's changes across its five axes, categorizing findings as Critical, Important, or Suggestion. Delegate Critical and Important fixes to a Sonnet subagent; carry Suggestions to the final summary.
   3. Stage only the files that task touched — never `git add -A` blindly — and make one commit per task so any point is a clean rollback.
6. **Stop and ask the user** (do not push through) when:
   - a test can't be made to pass or the build breaks without an obvious fix → follow agent-skills:debugging-and-error-recovery
   - the spec is ambiguous, or a task needs a decision the spec doesn't cover
   - a task is high-risk or irreversible — auth/permission changes, destructive data migrations, payments, deletions, deploys, anything touching secrets, **or anything you can't undo with `git revert`** → follow agent-skills:doubt-driven-development and get explicit sign-off before continuing

   After the user resolves a blocker, they re-invoke `/build` — it resumes from the next pending task.

7. **Summarize at the end:** tasks completed, tests added, commits made, and anything skipped, flagged, or Suggestions left for the user.

If any step fails, follow the `agent-skills:debugging-and-error-recovery` skill.
