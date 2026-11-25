#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROFILE_FILE=/etc/profile.d/wslrpc.sh

if ! command -v node >/dev/null 2>&1; then
    echo "wslrpc: WSL node is required (node was not found)" >&2
    exit 1
fi
if ! command -v node.exe >/dev/null 2>&1; then
    echo "wslrpc: Windows node.exe is required and is not visible from WSL" >&2
    exit 1
fi
if [ ! -f "$ROOT_DIR/config.json" ] || [ ! -f "$ROOT_DIR/index.js" ]; then
    echo "wslrpc: installation source is incomplete: $ROOT_DIR" >&2
    exit 1
fi

tmp_file=$(mktemp)
trap 'rm -f "$tmp_file"' EXIT HUP INT TERM
cat >"$tmp_file" <<EOF
# Managed by wslrpc.  This file is idempotent and never starts a second copy.
_wslrpc_start() {
    [ "\${WSLRPC_DISABLE:-0}" = 1 ] && return 0
    command -v node >/dev/null 2>&1 || return 0
    command -v node.exe >/dev/null 2>&1 || return 0

    _wslrpc_runtime=\${XDG_RUNTIME_DIR:-/tmp}/wslrpc-\${UID:-\$(id -u)}
    _wslrpc_lock="\${_wslrpc_runtime}.lock"
    _wslrpc_log="\${XDG_STATE_HOME:-\$HOME/.local/state}/wslrpc/wslrpc.log"
    mkdir -p "\$(dirname -- "\$_wslrpc_log")" || return 0
    if ! mkdir "\$_wslrpc_lock" 2>/dev/null; then
        return 0
    fi
    if ! ps -u "\$(id -u)" -o args= | awk -v target="$ROOT_DIR/index.js" 'index(\$0, target) { found=1 } END { exit(found ? 0 : 1) }'; then
        nohup node "$ROOT_DIR/index.js" >>"\$_wslrpc_log" 2>&1 </dev/null &
    fi
    rmdir "\$_wslrpc_lock" 2>/dev/null || true
    unset _wslrpc_runtime _wslrpc_lock _wslrpc_log
}
_wslrpc_start
unset -f _wslrpc_start 2>/dev/null || true
EOF
install -m 0644 "$tmp_file" "$PROFILE_FILE"
echo "installed $PROFILE_FILE for $ROOT_DIR"
