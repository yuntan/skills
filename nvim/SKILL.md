---
name: nvim
description: Use this skill to cooperate with neovim
license: MIT
---

# Neovim連携

## 引数

- $socket: ユーザーが `nvim --listen $socket` で指定したソケット

## 挙動

### スキル読み込み時

以下のコマンドを実行し、接続確認を行う。

```sh
nvim --server $socket --remote-send ':echo "Connected to Claude Code!"<CR>' 2>/dev/null && echo "NVIM_CONNECTED" || echo "NVIM_DISCONNECTED"
```

- NVIM_CONNECTED: neovim 連携ワークフロー有効
- NVIM_DISCONNECTED: 通常ワークフローで継続（neovim 操作をスキップ）

その後、nvim 関連のコマンドが失敗するまで、NVIM_CONNECTED を維持する。

## ユーザーとのやり取り

現在開いているファイルを暗黙的に取得する。

```sh
nvim --server $socket --remote-expr "expand('%:p')"
nvim --server $socket --remote-expr "line('.')"
```

現在選択されている行を暗黙的に取得する。まず visual mode 中かどうかを確認する。

```sh
nvim --server $socket --remote-expr "mode()"
```

`v` / `V` / `\x16`(Ctrl-V) で始まる場合: visual mode 中。

```sh
nvim --server $socket --remote-expr "line('.')"
nvim --server $socket --remote-expr "line('v')"
```

## コーディングワークフロー

### Read

ユーザーにコードの内容を示す場合、以下のコマンドを実行する

```sh
nvim --server $socket --remote $filepath:$line
```

### Write, Edit, MultiEdit

Edit, MultiEdit の場合は、ファイルの変更前に、必ず以下のコマンドを実行してファイルを開く

```sh
nvim --server $socket --remote +$line $filepath
```

Edit, MultiEdit が完了したら、必ず以下のコマンドで vim の表示を更新する

```sh
nvim --server $socket --remote-send ':checktime<CR>'
```

Write の場合は、ファイルの作成後に必ず以下のコマンドを実行し、ファイルを開く

```sh
nvim --server $socket --remote +$line $filepath
```

## 診断・デバッグ連携

### 診断情報の詳細取得

```sh
nvim --server $socket --remote-expr "luaeval('vim.inspect(vim.diagnostic.get(0))')"
```

### 特定行へジャンプ（診断箇所への移動）

```sh
nvim --server $socket --remote-send ':$line<CR>'
```
