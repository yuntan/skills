---
name: git-commit
description: Commit message format (emoji, type, scope) and rules for splitting changes into commits. Use before running git commit, when writing a commit message, or when splitting changes into multiple commits.
---

# Git Commit

## Context

Check the recent commit history and split the changes into appropriately-sized commits. Write commit messages following the style of recent ones (Japanese or English).

## Default Commit Message Format

```
<emoji> <type>(<scope>): <description>

<body>
```

Emoji and Type:

| Emoji | Type     |
| ----- | -------- |
| ✨    | feat     |
| 🐛    | fix      |
| ♻️    | refactor |
| 📝    | docs     |
| ✅    | test     |
| 🔧    | chore    |
| ⚡️    | perf     |
| 👷    | ci       |

Scope: the affected module or top-level directory (e.g. `auth`, `api`, `build`). Keep it consistent across the project; omit it when a change spans many areas.

## Guidelines

- **Subject**: imperative mood, no trailing period, ~50 chars max.
- **Body**: explain _why_, not _what_ (the diff shows what). Wrap at 72 chars.
- **Atomic**: one logical change per commit. Don't mix formatting with logic changes.
