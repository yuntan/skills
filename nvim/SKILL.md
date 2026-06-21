---
name: nvim
description: Use this skill to cooperate with Neovim. Connects Claude Code sessions to a running Neovim instance via --listen sockets, enabling automatic buffer sync, cursor tracking, and edit-location jumping. Use when the user mentions nvim, neovim, editor integration, or wants to see their edits reflected in their editor in real time.
license: MIT
compatibility: Designed for Claude Code (or similar products). Requires `jq` for JSON manipulation.
---

# Neovim連携

ターンごとのバッファ確認（UserPromptSubmit）と、編集後のファイル表示更新（PostToolUse on Write|Edit）は
`~/.claude/settings.json` のフックが自動で行う。**このスキルは接続の設定・切り替えのみを担当する。**

## セッションごとの接続状態

接続先ソケットは **セッション単位** の状態ファイルに保存する。

```
~/.claude/nvim-sockets/<session_id>
```

- スキル側（connect/disconnect）は自分の session_id を環境変数 `$CLAUDE_CODE_SESSION_ID` から得る。
- フック側は stdin で渡る `session_id` を使い、同じファイルを読む。
- ファイルが無ければフックは何もしない（＝そのセッションは切断状態）。

これにより、複数の neovim を立ち上げて別々の Claude Code セッションに接続しても衝突しない。

## サブコマンド

スキルの引数で動作を分岐する。

### setup

neovim 連携用のフックを `~/.claude/settings.json` の `hooks` に**マージ**する（既存フックは保持）。
対象は `UserPromptSubmit`（バッファ状態の注入）と `PostToolUse`（matcher `Write|Edit`、編集ファイルの表示更新）。
いずれのフックも stdin の `session_id` から `~/.claude/nvim-sockets/<session_id>` を読み、ファイルが無ければ no-op になる。

導入するフック定義は同梱の **`hooks.json`** にある（setup 実行時のみ読む）。
これを `~/.claude/settings.json` の `.hooks` にマージする。`update-config` スキルを使うのが安全。

### connect $socket

ユーザーが `nvim --listen $socket` で起動したソケットに、このセッションを接続する。

1. 到達確認:

   ```sh
   nvim --server $socket --remote-expr "1" >/dev/null 2>&1 && echo OK || echo NG
   ```

2. OK の場合のみ、このセッションの状態ファイルに保存する。以降フックがこのソケットを使う。

   ```sh
   mkdir -p ~/.claude/nvim-sockets
   printf '%s' "$socket" > ~/.claude/nvim-sockets/$CLAUDE_CODE_SESSION_ID
   ```

3. 接続できたことを Neovim 側にも知らせる。

   ```sh
   nvim --server $socket --remote-send ':echo "Connected to Claude Code!"<CR>'
   ```

   NG の場合は接続せず、その旨をユーザーに伝える。

### disconnect

このセッションの状態ファイルを削除する。以降フックは no-op になる（＝切断）。

```sh
rm -f ~/.claude/nvim-sockets/$CLAUDE_CODE_SESSION_ID
```

## 診断・デバッグ連携（任意）

ソケットはこのセッションの状態ファイルから取得する。

```sh
socket=$(cat ~/.claude/nvim-sockets/$CLAUDE_CODE_SESSION_ID)
```

### 診断情報の詳細取得

```sh
nvim --server "$socket" --remote-expr "luaeval('vim.inspect(vim.diagnostic.get(0))')"
```

### 特定行へジャンプ（診断箇所への移動）

```sh
nvim --server "$socket" --remote-send ':$line<CR>'
```

### コードをユーザーに表示（Read）

`--remote` 以降の引数はすべてファイル名として解釈されるため、`file:line` や `+line` を混ぜず、
ファイルを開いてから行ジャンプする。

```sh
nvim --server "$socket" --remote $filepath
nvim --server "$socket" --remote-send ':$line<CR>'
```
