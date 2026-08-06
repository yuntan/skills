---
name: git-commit
description: Commit message format and rules for splitting changes into commits. Use when writing a commit message or when splitting changes into multiple commits.
---

# Git Commit

## Steps

1. Check the recent commit history (`git log -5`) and match the language of recent commits (Japanese or English).
2. Assign every changed hunk to exactly one commit, so that each commit is one logical change. Formatting-only changes get their own commit.
3. Write each message in the format below.

## Commit Message Format

Based on Conventional Commits 1.0.0. The type table below is authoritative.

```
<emoji> <type>[(<scope>)][!]: <description>

<body>

[<footer>]
```

| Emoji | Type |
| --- | --- |
| ✨ | feat |
| 🐛 | fix |
| ⚡️ | perf |
| ♻️ | refactor |
| 🎨 | style |
| 📝 | docs |
| ✅ | test |
| 🌐 | i18n |
| 🔧 | chore |
| 👷 | ci |
| 📦️ | package |
| 🔖 | version |
| ⏪️ | revert |
| 🔀 | merge |

- **Scope**: the affected module or top-level directory (e.g. `auth`, `api`, `build`). Keep it consistent across the project; omit it when a change spans many areas.
- **Breaking change**: append `!` after `<type>` and add a `BREAKING CHANGE:` footer. Any `<type>` can carry one.
- **Description**: imperative mood, no trailing period, ~50 chars max.
- **Body**: explain _why_, not _what_ (the diff shows what). Wrap at 72 chars.
