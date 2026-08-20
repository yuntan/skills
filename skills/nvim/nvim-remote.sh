#!/usr/bin/env bash
# Talk to Neovim instances started with `nvim --listen SOCKET`.
#
# Usage: nvim-remote.sh COMMAND [ARG]
#   list [DIR]     instances whose cwd is DIR or below (default: $PWD), as TSV:
#                  socket, cwd, focused buffer
#   state          cwd, focused buffer, cursor, mode, visual selection, buffers
#   text [FILE]    buffer text (default: the focused buffer)
#   expr EXPR      evaluate a Vim expression
#   send KEYS      feed keys as typed
#   reload [FILE]  :checktime, refused while the buffer has unsaved changes
#
# The socket comes from $NVIM_SOCK, otherwise from the one instance `list` finds.
set -uo pipefail

usage() { awk 'NR > 1 && /^#/ { sub(/^# ?/, ""); print; next } NR > 1 { exit }' "$0"; }

sockets() {
  local dir cwd sock
  dir=$(cd "${1:-$PWD}" && pwd -P) || return 1
  pgrep -fl '^nvim' | grep -o -- '--listen [^ ]*' | awk '{print $2}' | sort -u |
    while read -r sock; do
      cwd=$(nvim --server "$sock" --remote-expr 'resolve(getcwd())' 2>/dev/null) || continue
      [ -n "$cwd" ] || continue
      case "$cwd" in
        "$dir" | "$dir"/*) printf '%s\t%s\n' "$sock" "$cwd" ;;
      esac
    done
}

resolve_sock() {
  local found n
  if [ -n "${NVIM_SOCK:-}" ]; then printf '%s\n' "$NVIM_SOCK"; return 0; fi
  found=$(sockets "$PWD") || return 1
  n=$(printf '%s' "$found" | grep -c .)
  if [ "$n" -eq 0 ]; then
    echo "no Neovim instance listening under $PWD" >&2
    return 1
  elif [ "$n" -gt 1 ]; then
    echo "several instances; ask the user, then set NVIM_SOCK to one of:" >&2
    printf '%s\n' "$found" >&2
    return 1
  fi
  printf '%s\n' "$found" | cut -f1
}

vexpr() { nvim --server "$SOCK" --remote-expr "$1"; }
vline() { vexpr "$1"; echo; }

buf_of() {
  local f buf
  f=$(cd "$(dirname "$1")" 2>/dev/null && pwd)/$(basename "$1")
  buf=$(vexpr "bufnr(\"$f\")")
  case "$buf" in
    ''|-1|0) echo "not open in Neovim: $f" >&2; return 1 ;;
  esac
  printf '%s\n' "$buf"
}

cmd_list() {
  local sock cwd
  sockets "${1:-$PWD}" | while IFS=$'\t' read -r sock cwd; do
    printf '%s\t%s\t%s\n' "$sock" "$cwd" \
      "$(nvim --server "$sock" --remote-expr 'expand("%:p")' 2>/dev/null)"
  done
}

cmd_state() {
  local mode vm
  mode=$(vexpr 'mode()')
  printf 'socket:\t%s\n' "$SOCK"
  printf 'cwd:\t%s\n' "$(vexpr 'getcwd()')"
  printf 'file:\t%s\n' "$(vexpr 'expand("%:p")')"
  printf 'modified:\t%s\n' "$(vexpr '&modified')"
  printf 'mode:\t%s\n' "$mode"
  printf 'cursor:\t%s\n' "$(vexpr 'line(".") . ":" . col(".")')"
  case "$mode" in
    v | V | $'\026')
      printf 'selection:\tlive %s\n' \
        "$(vexpr 'string([getpos("v")[1:2], getpos(".")[1:2]])')"
      vexpr 'join(getregion(getpos("v"), getpos("."), {"type": mode()}), "\n")' |
        sed 's/^/  /'
      echo
      ;;
    *)
      vm=$(vexpr 'visualmode()')
      if [ -n "$vm" ]; then
        printf 'selection:\tlast %s\n' \
          "$(vexpr "string([getpos(\"'<\")[1:2], getpos(\"'>\")[1:2]])")"
        vexpr "join(getregion(getpos(\"'<\"), getpos(\"'>\"), {'type': visualmode()}), \"\n\")" |
          sed 's/^/  /'
        echo
      else
        printf 'selection:\t-\n'
      fi
      ;;
  esac
  printf 'buffers:\n'
  vexpr 'execute("ls")' | sed 's/^/  /'
  echo
}

cmd_text() {
  local buf
  if [ -n "${1:-}" ]; then
    buf=$(buf_of "$1") || return 1
    vline "join(getbufline($buf, 1, '\$'), \"\n\")"
  else
    vline 'join(getline(1, "$"), "\n")'
  fi
}

cmd_reload() {
  local buf dirty
  if [ -n "${1:-}" ]; then
    buf=$(buf_of "$1") || return 1
    if [ "$(vexpr "getbufvar($buf, '&modified')")" != 0 ]; then
      echo "unsaved changes in $1: ask the user to save or discard" >&2
      return 1
    fi
    vexpr "execute('checktime $buf')" >/dev/null
  else
    dirty=$(vexpr 'join(map(getbufinfo({"bufmodified": 1}), "v:val.name"), "\n")')
    if [ -n "$dirty" ]; then
      echo "unsaved changes; name a FILE to reload, or ask the user to save:" >&2
      printf '%s\n' "$dirty" >&2
      return 1
    fi
    vexpr 'execute("checktime")' >/dev/null
  fi
}

cmd=${1:-}
[ $# -gt 0 ] && shift
case "$cmd" in
  list) cmd_list "${1:-}" ;;
  state | text | expr | send | reload)
    SOCK=$(resolve_sock) || exit 1
    case "$cmd" in
      state) cmd_state ;;
      text) cmd_text "${1:-}" ;;
      expr) vline "${1:?expr: EXPR required}" ;;
      send) nvim --server "$SOCK" --remote-send "${1:?send: KEYS required}" ;;
      reload) cmd_reload "${1:-}" ;;
    esac
    ;;
  '' | -h | --help | help) usage ;;
  *) usage >&2; exit 1 ;;
esac
