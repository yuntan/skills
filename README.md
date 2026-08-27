# Skills

[![skills.sh](https://skills.sh/b/yuntan/skills)](https://skills.sh/yuntan/skills)

My agent skills that I use every day.

## Installation

```sh
npx skills add yuntan/skills --global
```

Drop `--global` to install into the current project instead.

## Skills

These split on one axis: who can invoke them. **User-invoked** skills are reachable only when you type them (e.g. `/handoff`). **Model-invoked** skills can be invoked by you *or* reached for automatically by the agent when the task fits.

### User-invoked

- **[handoff](skills/handoff/SKILL.md)**: Create a `HANDOFF.md` document for a new session or another coding agent.
- **[nvim](skills/nvim/SKILL.md)**: Connect the session to a Neovim instance started with `nvim --listen SOCKET`, and read or edit what you have open there. Add this function to your shell:

  ```bash
  nvim() {
    command nvim --listen "$(mktemp)" "$@"
  }
  ```

### Model-invoked

- **[git-commit](skills/git-commit/SKILL.md)**: ✨ Sparkle commit messages.
- **[rewrite](skills/rewrite/SKILL.md)**: Rewrite AI slop into short, concise English.
- **[rewrite-copy](skills/rewrite-copy/SKILL.md)**: Rewrite landing page copy.
- **[show-me](skills/show-me/SKILL.md)**: Explain the topic like I'm 5 years old, with big pictures and few words, saved as an HTML file.

## License

[MIT](LICENSE)
