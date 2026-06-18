---
name: zettelkasten
description: "Injects zettelkasten reminder during agent bootstrap"
metadata: {"openclaw":{"emoji":"🗂️","events":["agent:bootstrap"]}}
---

# Zettelkasten Hook

Injects a reminder to capture useful knowledge in the Zettelkasten during agent bootstrap.

## What It Does

- Fires on `agent:bootstrap` (before workspace files are injected)
- Adds a reminder block to save research, ideas, and distilled learnings to the Zettelkasten
- Prompts the agent to create linked notes in `${ZK_DIR}/Literature/` or `${ZK_DIR}/Permanent/` when appropriate

## Configuration

No configuration needed. Enable with:

```bash
openclaw hooks enable zettelkasten
```
