# =============================================================================
# tests/helpers.sh — shared assertions for pomo CI tests
# =============================================================================
# Source from test scripts (POSIX /bin/sh). Does not modify product code.
# Parameterized ship unit: APP_NAME (default pomo), SCRIPT, APP_VERSION.
# Ported from countdown Type 0 harness; specialized for product B (pomo).
# =============================================================================

# shellcheck disable=SC2034
: "${TESTS_ROOT:=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}"
: "${REPO_ROOT:=$(CDPATH= cd -- "${TESTS_ROOT}/.." && pwd)}"
: "${APP_NAME:=pomo}"
: "${SCRIPT:=${REPO_ROOT}/${APP_NAME}}"
: "${PASS:=0}"
: "${FAIL:=0}"
: "${SKIP:=0}"

# Product version SSOT from ship unit (grep '^VERSION="')
if [ -z "${APP_VERSION:-}" ] && [ -f "${SCRIPT}" ]; then
    APP_VERSION=$(grep '^VERSION="' "${SCRIPT}" 2>/dev/null | head -n1 | cut -d'"' -f2)
fi
: "${APP_VERSION:=unknown}"

# --- output ---
t_info()  { printf '  · %s\n' "$*"; }
t_pass()  { PASS=$((PASS + 1)); printf '  PASS  %s\n' "$*"; }
t_fail()  { FAIL=$((FAIL + 1)); printf '  FAIL  %s\n' "$*" >&2; }
t_skip()  { SKIP=$((SKIP + 1)); printf '  SKIP  %s\n' "$*"; }
t_header() { printf '\n== %s ==\n' "$*"; }

# --- assertions ---
assert_eq() {
    _lab="$1"; _exp="$2"; _act="$3"
    if [ "$_exp" = "$_act" ]; then
        t_pass "$_lab"
    else
        t_fail "$_lab (expected='$(_trunc "$_exp")' actual='$(_trunc "$_act")')"
    fi
}

assert_contains() {
    _lab="$1"; _hay="$2"; _ndl="$3"
    case "$_hay" in
        *"$_ndl"*) t_pass "$_lab" ;;
        *) t_fail "$_lab (missing '$(_trunc "$_ndl")' in '$(_trunc "$_hay")')" ;;
    esac
}

assert_not_contains() {
    _lab="$1"; _hay="$2"; _ndl="$3"
    case "$_hay" in
        *"$_ndl"*) t_fail "$_lab (unexpected '$(_trunc "$_ndl")')" ;;
        *) t_pass "$_lab" ;;
    esac
}

assert_exit() {
    _lab="$1"; _exp="$2"; shift 2
    "$@" >/dev/null 2>&1
    _act=$?
    assert_eq "$_lab" "$_exp" "$_act"
}

assert_file_exists() {
    _lab="$1"; _path="$2"
    if [ -e "$_path" ]; then
        t_pass "$_lab"
    else
        t_fail "$_lab (missing $_path)"
    fi
}

assert_file_missing() {
    _lab="$1"; _path="$2"
    if [ -e "$_path" ]; then
        t_fail "$_lab (still exists: $_path)"
    else
        t_pass "$_lab"
    fi
}

assert_file_mode() {
    _lab="$1"; _path="$2"; _exp="$3"
    _act=$(python3 -c "import os,sys; print('%04o' % (os.stat(sys.argv[1]).st_mode & 0o777))" "$_path")
    assert_eq "$_lab" "$_exp" "$_act"
}

# Silent class: both stdout and stderr empty after a claimed one-liner = fail
assert_not_silent() {
    _lab="$1"; _out="$2"; _err="$3"
    if [ -n "$_out" ] || [ -n "$_err" ]; then
        t_pass "$_lab"
    else
        t_fail "$_lab (0-byte stdout and stderr — silent class fail)"
    fi
}

_trunc() {
    printf '%s' "$1" | tr '\n' ' ' | cut -c1-160
}

# --- isolation helpers ---
# Start a local HTTP channel serving SCRIPT as APP_NAME (+ derived .sha256).
# Sets: CI_HTTP_PID, CI_SCRIPT_URL, CI_CHANNEL_DIR, CI_PORT
ci_start_channel() {
    CI_CHANNEL_DIR=$(mktemp -d "${TMPDIR:-/tmp}/tm-channel.XXXXXX")
    cp "${SCRIPT}" "${CI_CHANNEL_DIR}/${APP_NAME}"
    sha256sum "${CI_CHANNEL_DIR}/${APP_NAME}" | awk '{print $1}' > "${CI_CHANNEL_DIR}/${APP_NAME}.sha256"

    CI_PORT=$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1]); s.close()')
    (
        cd "${CI_CHANNEL_DIR}" || exit 1
        exec python3 -m http.server "${CI_PORT}" --bind 127.0.0.1
    ) >/dev/null 2>&1 &
    CI_HTTP_PID=$!
    CI_SCRIPT_URL="http://127.0.0.1:${CI_PORT}/${APP_NAME}"

    _i=0
    while [ "$_i" -lt 50 ]; do
        if curl -fsS "${CI_SCRIPT_URL}" >/dev/null 2>&1; then
            return 0
        fi
        sleep 0.1
        _i=$((_i + 1))
    done
    t_fail "local channel failed to start on port ${CI_PORT}"
    return 1
}

ci_stop_channel() {
    if [ -n "${CI_HTTP_PID:-}" ]; then
        kill "${CI_HTTP_PID}" 2>/dev/null || true
        wait "${CI_HTTP_PID}" 2>/dev/null || true
        CI_HTTP_PID=
    fi
    if [ -n "${CI_CHANNEL_DIR:-}" ] && [ -d "${CI_CHANNEL_DIR}" ]; then
        rm -rf "${CI_CHANNEL_DIR}"
        CI_CHANNEL_DIR=
    fi
}

# Isolated HOME + USER_BIN. Sets CI_HOME, CI_USER_BIN.
ci_isolated_env() {
    CI_HOME=$(mktemp -d "${TMPDIR:-/tmp}/tm-home.XXXXXX")
    CI_USER_BIN="${CI_HOME}/.local/bin"
    mkdir -p "${CI_USER_BIN}"
    export HOME="${CI_HOME}"
    export USER_BIN="${CI_USER_BIN}"
    unset CHECKSUM 2>/dev/null || true
}

# Isolated GLOBAL_BIN plus a PATH stub so `id -u` prints 0 (no real root).
# Sets CI_GLOBAL_BIN, CI_STUB_BIN. Real uid is unchanged — only the `id` binary
# on PATH is stubbed so install/self-update take the GLOBAL_BIN branch.
ci_isolated_global_env() {
    : "${CI_HOME:=}"
    if [ -z "${CI_HOME}" ] || [ ! -d "${CI_HOME}" ]; then
        t_fail "ci_isolated_global_env requires ci_isolated_env first"
        return 1
    fi
    CI_GLOBAL_BIN="${CI_HOME}/global-bin"
    CI_STUB_BIN="${CI_HOME}/stub-bin"
    mkdir -p "${CI_GLOBAL_BIN}" "${CI_STUB_BIN}"
    _real_id=$(command -v id)
    _real_un=$(${_real_id} -un 2>/dev/null || echo unknown)
    cat > "${CI_STUB_BIN}/id" <<EOF
#!/bin/sh
if [ "\${1-}" = "-u" ]; then
    echo 0
    exit 0
fi
if [ "\${1-}" = "-un" ]; then
    echo ${_real_un}
    exit 0
fi
exec ${_real_id} "\$@"
EOF
    chmod 0755 "${CI_STUB_BIN}/id"
    unset _real_id _real_un
}

ci_cleanup_env() {
    if [ -n "${CI_HOME:-}" ] && [ -d "${CI_HOME}" ]; then
        rm -rf "${CI_HOME}"
        CI_HOME=
        CI_USER_BIN=
    fi
}

# Remove this user's volatile pomo state files (best-effort; domain suite).
# Live layout: ${/dev/shm|/dev/shm/cache|/tmp/cache|/tmp}/${APP_NAME}_${USER}_${name}
# Also clean nested private-dir variant and Git Bash AppData Local Temp/cache.
ci_cleanup_pomo_domain() {
    _u=$(id -un 2>/dev/null || echo "unknown")
    for _base in /dev/shm /dev/shm/cache /tmp/cache /tmp; do
        rm -f "${_base}/${APP_NAME}_${_u}"_* 2>/dev/null || true
        rm -rf "${_base}/${APP_NAME}-${_u}" 2>/dev/null || true
    done
    if [ -n "${HOME-}" ] && [ -d "${HOME}/AppData/Local/Temp/cache" ]; then
        rm -f "${HOME}/AppData/Local/Temp/cache/${APP_NAME}_${_u}"_* 2>/dev/null || true
        rm -rf "${HOME}/AppData/Local/Temp/cache/${APP_NAME}-${_u}" 2>/dev/null || true
    fi
    if [ -n "${TEMP-}" ] && [ -d "${TEMP}/cache" ]; then
        rm -f "${TEMP}/cache/${APP_NAME}_${_u}"_* 2>/dev/null || true
        rm -rf "${TEMP}/cache/${APP_NAME}-${_u}" 2>/dev/null || true
    fi
}

# Back-compat aliases if suites share countdown/timer names
ci_cleanup_countdown_domain() {
    ci_cleanup_pomo_domain
}

ci_cleanup_timer_domain() {
    ci_cleanup_pomo_domain
}

# Run SCRIPT under a PTY. Sends PTY_IN (default "99"). The two-character
# sequence \n in PTY_IN becomes a real newline (so PTY_IN="1\\n" is choice 1
# then Enter). A trailing newline is added when missing. Kills the child after
# PTY_TIMEOUT seconds (default 6). Prints child output.
ci_pty_capture() {
    python3 - "$@" <<'PY'
import os, pty, select, signal, sys, time
script = sys.argv[1]
cmd = sys.argv[2:]
raw = os.environ.get("PTY_IN", "99").replace("\\n", "\n")
payload = (raw + "\n").encode()
timeout = float(os.environ.get("PTY_TIMEOUT", "6"))
pid, fd = pty.fork()
if pid == 0:
    os.execv("/bin/sh", ["sh", script] + cmd)
time.sleep(0.2)
try:
    os.write(fd, payload)
except OSError:
    pass
out = bytearray()
end = time.time() + timeout
exited = False
while time.time() < end:
    r, _, _ = select.select([fd], [], [], 0.2)
    if fd in r:
        try:
            chunk = os.read(fd, 4096)
        except OSError:
            break
        if not chunk:
            break
        out += chunk
    wpid, _st = os.waitpid(pid, os.WNOHANG)
    if wpid:
        exited = True
        break
if not exited:
    try:
        os.kill(pid, signal.SIGTERM)
    except OSError:
        pass
try:
    os.waitpid(pid, 0)
except OSError:
    pass
try:
    os.close(fd)
except OSError:
    pass
sys.stdout.buffer.write(out)
PY
}

ci_run() {
    sh "${SCRIPT}" "$@"
}

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        t_fail "required command missing: $1"
        return 1
    fi
    return 0
}
