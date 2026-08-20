---
description: Connect this session to Neovim instance.
argument-hint: tell what you want agent to see
disable-model-invoke: true
---

## Connect to Neovim

`nvim-remote.sh`, next to this file, drives Neovim instances started with
`nvim --listen SOCKET`. Run it with no argument for the full usage.

1. `nvim-remote.sh list` — instances whose cwd is this session's cwd or below,
   as TSV: socket, cwd, focused buffer.

   - No line: tell the user to start Neovim with `nvim --listen SOCKET`, then
     stop.
   - Two or more: ask which one (`AskUserQuestion`, labelled with the focused
     buffer), then `export NVIM_SOCK=<socket>` for the commands below. Every
     command refuses to guess while more than one instance is listening.

2. `nvim-remote.sh state` — cwd, focused buffer, cursor, `mode()`, `&modified`,
   the visual selection, and the buffer list. The selection is `live` while the
   user is in visual mode and `last` once they have left it.

3. `nvim-remote.sh text [FILE]` — buffer text. Read it from here rather than
   from disk while `&modified` is 1.

4. `nvim-remote.sh reload FILE` — `:checktime`, so the instance picks up a file
   you just edited. Run it after every edit to a file the instance has open. It
   refuses when the buffer carries unsaved changes; ask the user to save or
   discard rather than forcing it.

5. `nvim-remote.sh expr EXPR` and `nvim-remote.sh send KEYS` — anything the
   commands above do not cover. Confirm with the user before sending keys that
   change a buffer.
