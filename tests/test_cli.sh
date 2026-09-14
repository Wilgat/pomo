# =============================================================================
# tests/test_cli.sh — Type 0 CLI surface (PM-SHELL-CLI-TEST-PLAN / TP-CLI-*)
# =============================================================================
# Mold catalog TP-CLI-01..11 (Core). Product: sh -n not bash -n; TP-CLI-05/10 n/a;
# TP-CLI-12 product extension (out_json string-key). Cross: TP-CSUM-01/05, TP-U-01/02,
# TP-POMO-01 (help domain verbs); TP-CLI-13 Git Bash/target; TP-CLI-16/17/29/30
# TTY menu; TP-TX-01..05 + TP-TX-08 Termux this-login dest + $PREFIX/tmp;
# TP-TX-09/10 Git Bash AppData Local Temp/cache + mkdir cache fail-soft.
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_cli() {
    t_header "CLI surface (TP-CLI / TP-CSUM / TP-U / TP-TX)"

    require_cmd sh
    require_cmd sha256sum
    require_cmd grep

    # --- TP-CLI-01: syntax + companion Shape A ---
    sh -n "${SCRIPT}"
    _syn=$?
    assert_eq "TP-CLI-01 sh -n ${APP_NAME} (syntax)" 0 "$_syn"

    if [ -f "${REPO_ROOT}/${APP_NAME}.sha256" ]; then
        _expected=$(awk '{print $1; exit}' "${REPO_ROOT}/${APP_NAME}.sha256")
        _actual=$(sha256sum "${SCRIPT}" | awk '{print $1}')
        assert_eq "TP-CLI-01 TP-CSUM-01 ${APP_NAME}.sha256 matches ./${APP_NAME}" "$_expected" "$_actual"
    else
        t_fail "TP-CLI-01 TP-CSUM-01 ${APP_NAME}.sha256 missing at repo root"
    fi

    # --- TP-CLI-02: version human + JSON ---
    _out=$(sh "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-02 version exit 0" 0 "$_ec"
    assert_contains "TP-CLI-02 version human mentions version" "$_out" "${APP_VERSION}"
    assert_contains "TP-CLI-02 version human mentions app" "$_out" "${APP_NAME}"

    _out=$(sh "${SCRIPT}" --json version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-02 version --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-02 version --json type" "$_out" '"type":"version"'
    assert_contains "TP-CLI-02 version --json app" "$_out" "\"app\":\"${APP_NAME}\""
    assert_contains "TP-CLI-02 version --json version field" "$_out" "\"version\":\"${APP_VERSION}\""

    # --- TP-CLI-03 / TP-POMO-01 / TP-CSUM-05: help Type 0 + domain; CHECKSUM absent ---
    _out=$(sh "${SCRIPT}" help 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-03 help exit 0" 0 "$_ec"
    assert_contains "TP-CLI-03 help lists install" "$_out" "install"
    assert_contains "TP-CLI-03 help lists version-check" "$_out" "version-check"
    assert_contains "TP-CLI-03 help lists self-update" "$_out" "self-update"
    assert_contains "TP-CLI-03 help lists self-uninstall" "$_out" "self-uninstall"
    assert_contains "TP-CLI-03 help lists about" "$_out" "about"
    assert_contains "TP-CLI-03 TP-POMO-01 help lists start (domain)" "$_out" "start"
    assert_contains "TP-CLI-03 TP-POMO-01 help lists status (domain)" "$_out" "status"
    assert_contains "TP-CLI-03 TP-POMO-01 help lists watch (domain)" "$_out" "watch"
    assert_contains "TP-CLI-03 TP-POMO-01 help lists skip (domain)" "$_out" "skip"
    assert_contains "TP-CLI-03 TP-POMO-01 help lists stop (domain)" "$_out" "stop"
    assert_contains "TP-CLI-03 TP-POMO-01 help lists kill (domain)" "$_out" "kill"
    assert_contains "TP-CLI-03 TP-POMO-01 help lists list (domain)" "$_out" "list"
    assert_contains "TP-CLI-03 TP-POMO-01 help lists stats (domain)" "$_out" "stats"
    assert_contains "TP-CLI-03 TP-POMO-01 help lists theme (domain)" "$_out" "theme"
    assert_contains "TP-CLI-03 TP-POMO-01 help lists --persist" "$_out" "--persist"
    assert_contains "TP-CLI-03 TP-POMO-01 help lists --break" "$_out" "--break"
    assert_contains "TP-CLI-03 help lists --json" "$_out" "--json"
    assert_contains "TP-CLI-03 help lists --force" "$_out" "--force"
    assert_contains "TP-CLI-03 help lists REPO_USER" "$_out" "REPO_USER"
    assert_contains "TP-CLI-03 help lists REPO_NAME" "$_out" "REPO_NAME"
    assert_contains "TP-CLI-03 help lists SCRIPT_URL" "$_out" "SCRIPT_URL"
    assert_not_contains "TP-CLI-03 TP-CSUM-05 help must not list CHECKSUM" "$_out" "CHECKSUM"

    # --- TP-CLI-04: help/about JSON purity ---
    _out=$(sh "${SCRIPT}" --json help 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-04 help --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-04 help --json type success" "$_out" '"type":"success"'
    assert_contains "TP-CLI-04 help --json command help" "$_out" '"command":"help"'

    _out=$(sh "${SCRIPT}" --json about 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-04 about --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-04 about --json type" "$_out" '"type":"about"'
    assert_contains "TP-CLI-04 about --json app" "$_out" "\"app\":\"${APP_NAME}\""
    assert_contains "TP-CLI-04 about --json target field" "$_out" '"target":'
    assert_not_contains "TP-CLI-04 TP-CSUM-05 about --json must not include CHECKSUM" "$_out" "CHECKSUM"

    # --- TP-CLI-05: shell storage fields n/a (domain owns storage) ---
    _out=$(sh "${SCRIPT}" --json about 2>/dev/null)
    assert_contains "TP-CLI-05 about --json type present (shell storage n/a)" "$_out" '"type":"about"'
    t_pass "TP-CLI-05 shell storage resolve n/a for pomo (see TP-STORAGE-*)"

    # --- TP-CLI-06: unknown command ---
    _err=$(sh "${SCRIPT}" no-such-command 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-CLI-06 unknown command exit 1" 1 "$_ec"
    assert_contains "TP-CLI-06 unknown command error text" "$_err" "Unknown command"

    _err=$(sh "${SCRIPT}" --json no-such-command 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-CLI-06 unknown command --json exit 1" 1 "$_ec"
    assert_contains "TP-CLI-06 unknown command --json type error" "$_err" '"type":"out_error"'

    # --- TP-CLI-07: quiet mode (--quiet and -q) ---
    _out=$(sh "${SCRIPT}" --quiet version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-07 version --quiet exit 0" 0 "$_ec"
    if [ -z "$_out" ]; then
        t_pass "TP-CLI-07 version --quiet suppresses human info"
    else
        _trim=$(printf '%s' "$_out" | tr -d ' \t\n\r')
        if [ -z "$_trim" ]; then
            t_pass "TP-CLI-07 version --quiet suppresses human info"
        else
            t_fail "TP-CLI-07 version --quiet expected empty stdout, got '$(_trunc "$_out")'"
        fi
    fi
    _out=$(sh "${SCRIPT}" -q version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-07 version -q exit 0" 0 "$_ec"
    _trim=$(printf '%s' "$_out" | tr -d ' \t\n\r')
    if [ -z "$_trim" ]; then
        t_pass "TP-CLI-07 version -q suppresses human info"
    else
        t_fail "TP-CLI-07 version -q expected empty stdout, got '$(_trunc "$_out")'"
    fi

    # --- TP-CLI-08 / TP-U-01: HOME unset under set -u ---
    _out=$(env -u HOME sh "${SCRIPT}" version 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-08 TP-U-01 env -u HOME version exit 0" 0 "$_ec"
    assert_contains "TP-CLI-08 TP-U-01 env -u HOME version still reports version" "$_out" "${APP_VERSION}"

    # --- TP-CLI-09 / TP-LC-09 / TP-U-02: zero-arg bad channel ---
    ci_isolated_env
    _errf="${CI_HOME}/zero-arg-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        SCRIPT_URL="http://127.0.0.1:1/${APP_NAME}-unreachable" \
        sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ "$_ec" -ne 0 ]; then
        t_pass "TP-CLI-09 TP-LC-09 TP-U-02 zero-arg failed install exits non-zero"
    else
        t_fail "TP-CLI-09 zero-arg failed install expected non-zero exit, got 0 (stdout='$(_trunc "$_out")' err='$(_trunc "$_err")')"
    fi
    assert_file_missing "TP-CLI-09 zero-arg failed install left no binary" "${CI_USER_BIN}/${APP_NAME}"
    if [ -n "$_err" ] || [ -n "$_out" ]; then
        t_pass "TP-CLI-09 zero-arg fail is not silent"
    else
        t_fail "TP-CLI-09 zero-arg fail was silent (0-byte out+err)"
    fi
    ci_cleanup_env

    # --- TP-CLI-11: self-uninstall --json without force ---
    ci_isolated_env
    mkdir -p "${CI_USER_BIN}"
    cp "${SCRIPT}" "${CI_USER_BIN}/${APP_NAME}"
    chmod +x "${CI_USER_BIN}/${APP_NAME}"
    _errf="${CI_HOME}/un-err.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        sh "${SCRIPT}" --json self-uninstall 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-CLI-11 self-uninstall --json without --force exit 1" 1 "$_ec"
    assert_contains "TP-CLI-11 self-uninstall --json confirm_required code" "$_err" '"code":"confirm_required"'
    assert_contains "TP-CLI-11 self-uninstall --json out_error type" "$_err" '"type":"out_error"'
    assert_not_contains "TP-CLI-11 self-uninstall --json must not fake success cancel" "$_out$_err" "cancelled by user"
    assert_file_exists "TP-CLI-11 binary remains without --force" "${CI_USER_BIN}/${APP_NAME}"
    ci_cleanup_env

    # --- TP-CLI-12: out_json string-key contract ---
    # Pomo out_json string-escapes all k/v pairs (no @raw nested extension yet).
    # Lock escape + string embedding; @key raw nested is n/a until product gains it.
    _harness=$(mktemp "${TMPDIR:-/tmp}/pomo-outjson.XXXXXX")
    {
        printf '%s\n' 'JSON=1'
        sed -n '/^util_json_escape()/,/^}/p' "${SCRIPT}"
        sed -n '/^out_json()/,/^}/p' "${SCRIPT}"
        printf '%s\n' 'out_json "t" "m" "plain" "v" "name" "ci-smoke"'
    } > "${_harness}"
    _out=$(sh "${_harness}" 2>/dev/null)
    _ec=$?
    rm -f "${_harness}"
    assert_eq "TP-CLI-12 out_json string-key harness exit 0" 0 "$_ec"
    assert_contains "TP-CLI-12 out_json type" "$_out" '"type":"t"'
    assert_contains "TP-CLI-12 out_json plain string key" "$_out" '"plain":"v"'
    assert_contains "TP-CLI-12 out_json name field" "$_out" '"name":"ci-smoke"'
    t_pass "TP-CLI-12 @key raw nested n/a (pomo out_json string-escapes all pairs)"

    # --- TP-CLI-13: Termux / Git Bash as command line for normal user only ---
    _out=$(sh "${SCRIPT}" --json about 2>/dev/null)
    assert_contains "TP-CLI-13 default about --json target posix (this host)" "$_out" '"target":"posix"'
    assert_contains "TP-CLI-13 default about --json normal_user_only false" "$_out" '"normal_user_only":"false"'

    _out=$(TERMUX_VERSION=test sh "${SCRIPT}" --json about 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-13 Termux about --json exit 0" 0 "$_ec"
    assert_contains "TP-CLI-13 Termux about --json target termux" "$_out" '"target":"termux"'
    assert_contains "TP-CLI-13 Termux about --json normal_user_only true" "$_out" '"normal_user_only":"true"'

    _out=$(TERMUX_VERSION=test sh "${SCRIPT}" help 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-13 Termux help exit 0" 0 "$_ec"
    assert_contains "TP-CLI-13 Termux help names Termux" "$_out" "Termux"
    assert_contains "TP-CLI-13 Termux help this login" "$_out" "this login"
    assert_not_contains "TP-CLI-13 Termux help must not recommend sudo curl" "$_out" "sudo curl"

    _out=$(PREFIX="/data/data/com.termux/files/usr" sh "${SCRIPT}" help 2>/dev/null)
    assert_contains "TP-CLI-13 PREFIX com.termux help names Termux" "$_out" "Termux"
    assert_not_contains "TP-CLI-13 PREFIX com.termux help must not recommend sudo curl" "$_out" "sudo curl"

    _out=$(MSYSTEM=MINGW64 sh "${SCRIPT}" --json about 2>/dev/null)
    assert_contains "TP-CLI-13 Git Bash about --json target git-bash" "$_out" '"target":"git-bash"'
    assert_contains "TP-CLI-13 Git Bash about --json normal_user_only true" "$_out" '"normal_user_only":"true"'

    _out=$(MSYSTEM=MINGW64 sh "${SCRIPT}" help 2>/dev/null)
    assert_contains "TP-CLI-13 Git Bash help names Git Bash" "$_out" "Git Bash"
    assert_not_contains "TP-CLI-13 Git Bash help must not recommend sudo curl" "$_out" "sudo curl"

    # --- TP-CLI-16: do-not-capture-read (no $() of prompt_* in live code) ---
    _hits=$(grep -nE '\$\(prompt_|`prompt_' "${SCRIPT}" | grep -v '^[^:]*:[[:space:]]*#' || true)
    if [ -z "${_hits}" ]; then
        t_pass "TP-CLI-16 no live \$(prompt_ / backtick prompt_ capture"
    else
        t_fail "TP-CLI-16 live prompt capture: ${_hits}"
    fi

    # --- TP-CLI-29 / TP-CLI-17: empty argv overlay; --json is JSON help ---
    _out=$(sh "${SCRIPT}" --json 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-29 --json no command exit 0" 0 "$_ec"
    assert_contains "TP-CLI-29 --json no command is JSON help" "$_out" '"type":"success"'
    assert_contains "TP-CLI-29 --json no command help command field" "$_out" '"command":"help"'
    assert_not_contains "TP-CLI-29 --json no command not numbered list" "$_out" "99. Exit"
    assert_not_contains "TP-CLI-29 --json no command not top menu" "$_out" "1. timer:"

    ci_isolated_env
    HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" sh "${SCRIPT}" install >/dev/null 2>&1 || true
    _errf="${CI_HOME}/dbg-empty.err"
    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" sh "${SCRIPT}" --debug </dev/null 2>"${_errf}")
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-CLI-29 --debug no command off-TTY exit 0" 0 "$_ec"
    assert_contains "TP-CLI-29 --debug no command off-TTY ensure" "$_out" "already installed"
    assert_not_contains "TP-CLI-29 --debug no command off-TTY not help dump" "$_out" "Usage:"
    assert_not_contains "TP-CLI-29 --debug no command off-TTY not numbered list" "$_out" "99. Exit"
    assert_not_contains "TP-CLI-29 --debug no command off-TTY not top menu" "$_out" "1. timer:"
    assert_contains "TP-CLI-29 --debug no command off-TTY debug tag" "$_err" "[DEBUG]"
    assert_contains "TP-CLI-29 --debug no command off-TTY dispatch ensure" "$_err" "command=ensure"

    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" sh "${SCRIPT}" --quiet </dev/null 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-29 --quiet no command off-TTY exit 0" 0 "$_ec"
    assert_not_contains "TP-CLI-29 --quiet no command off-TTY not help dump" "$_out" "Usage:"
    assert_not_contains "TP-CLI-29 --quiet no command off-TTY not numbered list" "$_out" "99. Exit"

    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" sh "${SCRIPT}" --json --debug 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-29 --json --debug no command exit 0" 0 "$_ec"
    assert_contains "TP-CLI-29 --json --debug no command is JSON help" "$_out" '"type":"success"'
    assert_not_contains "TP-CLI-29 --json --debug no command not numbered list" "$_out" "99. Exit"

    _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" sh "${SCRIPT}" menu </dev/null 2>/dev/null)
    _ec=$?
    assert_eq "TP-CLI-17 off-TTY menu is help exit 0" 0 "$_ec"
    assert_contains "TP-CLI-17 off-TTY menu is help" "$_out" "Usage:"
    assert_not_contains "TP-CLI-17 off-TTY menu not CSI" "$_out" "$(printf '\033')"

    if command -v python3 >/dev/null 2>&1; then
        _bold=$(printf '\033[1m')
        _italic=$(printf '\033[3m')
        _gray_italic=$(printf '\033[3;37m')
        _ident="${APP_NAME}(${APP_VERSION})"
        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" PTY_IN="9" ci_pty_capture "${SCRIPT}")
        _stripped=$(printf '%s' "$_out" | awk 'BEGIN{ORS=""} {gsub(/\033\[[0-9;]*m/,""); print}')
        assert_contains "TP-CLI-17 TTY empty argv is top menu" "$_out" "9. Exit"
        assert_contains "TP-CLI-17 TTY empty argv timer first" "$_stripped" "1. timer:"
        assert_contains "TP-CLI-17 TTY empty argv self-management is 8" "$_stripped" "8. self-management:"
        assert_not_contains "TP-CLI-17 TTY empty argv no start row" "$_stripped" "11. start:"
        assert_not_contains "TP-CLI-17 TTY empty argv no install row" "$_stripped" "81. install:"
        assert_not_contains "TP-CLI-17 TTY empty argv not help dump" "$_out" "Usage:"
        assert_contains "TP-CLI-17 TTY header bold APP_NAME" "$_out" "${_bold}"
        assert_contains "TP-CLI-17 TTY header italic VERSION" "$_out" "${_italic}"
        assert_contains "TP-CLI-17 TTY header nametag APP_NAME(VERSION)" "$_stripped" "${_ident}"
        assert_contains "TP-CLI-17 TTY short-descript is bold (SGR 1)" "$_out" "$(printf '\033[1mtimer\033[0m')"
        assert_contains "TP-CLI-17 TTY desc is italic + light gray (SGR 3+37)" "$_out" "${_gray_italic}"
        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" PTY_IN="1\\n0\\n9" ci_pty_capture "${SCRIPT}")
        _stripped=$(printf '%s' "$_out" | awk 'BEGIN{ORS=""} {gsub(/\033\[[0-9;]*m/,""); print}')
        assert_contains "TP-CLI-17 TTY timer board start is 11" "$_stripped" "11. start:"
        assert_contains "TP-CLI-17 TTY timer board Back 0" "$_out" "0. Back"
        assert_not_contains "TP-CLI-17 TTY timer board no Exit 99" "$_out" "99. Exit"
        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" PTY_IN="8\\n0\\n9" ci_pty_capture "${SCRIPT}")
        _stripped=$(printf '%s' "$_out" | awk 'BEGIN{ORS=""} {gsub(/\033\[[0-9;]*m/,""); print}')
        assert_contains "TP-CLI-17 TTY self-management install is 81" "$_stripped" "81. install:"
        assert_contains "TP-CLI-17 TTY self-management has self-update 83" "$_stripped" "83. self-update:"
        assert_not_contains "TP-CLI-17 TTY self-management no start row" "$_stripped" "11. start:"
        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" PTY_IN="2\\n9" ci_pty_capture "${SCRIPT}")
        assert_contains "TP-CLI-19 unused 2 is ERROR retry" "$_out" "[ERROR]"
        assert_contains "TP-CLI-19 unused 2 reprints top timer row" "$_out" "timer"
        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" PTY_IN="9" ci_pty_capture "${SCRIPT}" --debug)
        assert_contains "TP-CLI-29 TTY --debug no command is top menu" "$_out" "9. Exit"
        assert_contains "TP-CLI-29 TTY --debug no command timer first" "$_out" "timer"
        assert_contains "TP-CLI-29 TTY --debug no command dispatch menu" "$_out" "command=menu"
        assert_not_contains "TP-CLI-29 TTY --debug no command not help dump" "$_out" "Usage:"
        _jout=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" PTY_IN="9" ci_pty_capture "${SCRIPT}" --json)
        assert_contains "TP-CLI-29 TTY --json no command is JSON help" "$_jout" '"type":"success"'
        assert_not_contains "TP-CLI-29 TTY --json no command not numbered list" "$_jout" "99. Exit"
        assert_not_contains "TP-CLI-29 TTY --json no command not top menu" "$_jout" "1. timer:"
        unset _jout _bold _italic _gray_italic _ident _stripped

        mkdir -p "${CI_HOME}/vol"
        _vol="${CI_HOME}/vol"
        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" VOLATILE_DIR="${_vol}" \
            PTY_IN="1\\n17" ci_pty_capture "${SCRIPT}")
        _stripped=$(printf '%s' "$_out" | awk 'BEGIN{ORS=""} {gsub(/\033\[[0-9;]*m/,""); print}')
        assert_contains "TP-CLI-30 TTY menu list still lists" "$_stripped" "17. list:"
        assert_not_contains "TP-CLI-30 TTY menu list does not prompt for name" "$_out" "Pomodoro name"
        assert_contains "TP-CLI-30 TTY menu list runs without name" "$_out" "No running pomodoros found."

        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" VOLATILE_DIR="${_vol}" \
            PTY_IN="1\\n15\\n9" ci_pty_capture "${SCRIPT}")
        assert_contains "TP-CLI-30 TTY menu stop with none is empty list" "$_out" "No running pomodoros found."
        assert_not_contains "TP-CLI-30 TTY menu stop with none does not prompt for name" "$_out" "Pomodoro name"
        assert_not_contains "TP-CLI-30 TTY menu stop with none has no cancel row" "$_out" "0. Exit"

        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" VOLATILE_DIR="${_vol}" \
            PTY_IN="1\\n11\\n" ci_pty_capture "${SCRIPT}")
        assert_contains "TP-CLI-30 TTY menu start prompts for name" "$_out" "Pomodoro name"
        assert_contains "TP-CLI-30 TTY menu start shows default" "$_out" "Default: default"
        assert_contains "TP-CLI-30 TTY menu start Enter uses default name" "$_out" "Work phase started"

        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" VOLATILE_DIR="${_vol}" \
            PTY_IN="1\\n11\\nwork" ci_pty_capture "${SCRIPT}")
        assert_contains "TP-CLI-30 TTY menu start typed name" "$_out" "Work phase started"
        _u=$(id -un 2>/dev/null || echo "unknown")
        assert_file_exists "TP-CLI-30 TTY menu start typed name file" "${_vol}/${APP_NAME}_${_u}_work"

        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" VOLATILE_DIR="${_vol}" \
            PTY_IN="1\\n15\\n1" ci_pty_capture "${SCRIPT}")
        _stripped=$(printf '%s' "$_out" | awk 'BEGIN{ORS=""} {gsub(/\033\[[0-9;]*m/,""); print}')
        assert_contains "TP-CLI-30 TTY menu stop numbered running row" "$_stripped" "1. default:"
        assert_contains "TP-CLI-30 TTY menu stop cancel is 0" "$_out" "0. Exit"
        assert_not_contains "TP-CLI-30 TTY menu stop does not prompt for name" "$_out" "Pomodoro name"
        assert_contains "TP-CLI-30 TTY menu stop pick 1 stops listed timer" "$_out" "Work session completed"
        assert_file_missing "TP-CLI-30 TTY menu stop pick 1 removed default" "${_vol}/${APP_NAME}_${_u}_default"
        assert_file_exists "TP-CLI-30 TTY menu stop pick 1 does not stop other" "${_vol}/${APP_NAME}_${_u}_work"

        _out=$(HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" VOLATILE_DIR="${_vol}" \
            PTY_IN="1\\n12\\nwork" ci_pty_capture "${SCRIPT}")
        _stripped=$(printf '%s' "$_out" | awk 'BEGIN{ORS=""} {gsub(/\033\[[0-9;]*m/,""); print}')
        assert_contains "TP-CLI-30 TTY menu status listed name" "$_stripped" "1. work:"
        assert_contains "TP-CLI-30 TTY menu status uses listed name" "$_out" "Work"
        unset _vol _u _stripped
    else
        t_skip "TP-CLI-17 TTY header (no python3 for PTY)"
        t_skip "TP-CLI-29 TTY --debug no command (no python3 for PTY)"
        t_skip "TP-CLI-29 TTY --json no command (no python3 for PTY)"
        t_skip "TP-CLI-30 TTY menu start name / running-pomo pick (no python3 for PTY)"
    fi
    ci_cleanup_env

    # --- TP-TX-*: Termux target (command line for this login only) ---
    _stub=$(mktemp -d "${TMPDIR:-/tmp}/tm-pkgstub.XXXXXX")
    printf '#!/bin/sh\necho pkg-called >> "%s/pkg.log"\nexit 0\n' "${_stub}" > "${_stub}/pkg"
    chmod +x "${_stub}/pkg"
    _out=$(env -u PREFIX -u TERMUX_VERSION PATH="${_stub}:${PATH}" \
        sh "${SCRIPT}" --json about 2>/dev/null)
    assert_contains "TP-TX-01 about termux false off detect" "$_out" '"termux":"false"'
    assert_file_missing "TP-TX-01 TP-LC-15 pkg stub not invoked off Termux" "${_stub}/pkg.log"

    ci_isolated_env
    _tx_prefix="${CI_HOME}/data/com.termux/files/usr"
    mkdir -p "${_tx_prefix}/bin" "${_tx_prefix}/tmp"
    _out=$(
        HOME="${CI_HOME}" PREFIX="${_tx_prefix}" TERMUX_VERSION="0.118.0" \
        PATH="${_stub}:${PATH}" \
        env -u USER_BIN sh "${SCRIPT}" --json about 2>/dev/null
    )
    assert_contains "TP-TX-02 about termux true on PREFIX detect" "$_out" '"termux":"true"'
    assert_contains "TP-TX-02 about prefix field" "$_out" "com.termux"
    assert_contains "TP-TX-04 user_bin is PREFIX/bin" "$_out" "${_tx_prefix}/bin"
    assert_file_missing "TP-TX-05 pkg stub not invoked on Termux (no pkg companion)" "${_stub}/pkg.log"
    _help=$(
        HOME="${CI_HOME}" PREFIX="${_tx_prefix}" TERMUX_VERSION="0.118.0" \
        env -u USER_BIN sh "${SCRIPT}" help 2>/dev/null
    )
    assert_not_contains "TP-TX-03 help must not recommend sudo on Termux" "$_help" "sudo curl"
    assert_contains "TP-TX-03 help install names this login" "$_help" "this login"

    # --- TP-TX-08: Termux volatile records use $PREFIX/tmp when /dev/shm is unusable ---
    # Real Termux: /dev/shm missing, Android /tmp often read-only. Simulate by
    # pointing VOLATILE_DIR at a missing path; apply_target_paths retargets to PREFIX/tmp.
    _tx_name="tx-pref-tmp"
    _u=$(id -un 2>/dev/null || echo "unknown")
    _tx_file="${_tx_prefix}/tmp/${APP_NAME}_${_u}_${_tx_name}"
    _errf="${CI_HOME}/tx-stor.err"
    rm -f "${_tx_file}"
    _out=$(
        HOME="${CI_HOME}" PREFIX="${_tx_prefix}" TERMUX_VERSION="0.118.0" \
        VOLATILE_DIR="${CI_HOME}/no-such-shm" \
        env -u USER_BIN sh "${SCRIPT}" start "${_tx_name}" 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    _all="${_out}${_err}"
    assert_eq "TP-TX-08 termux start with unusable VOLATILE_DIR exit 0" 0 "$_ec"
    assert_not_contains "TP-TX-08 must not die on missing /dev/shm /tmp" "$_all" "No writable temporary storage"
    assert_not_contains "TP-TX-08 must not write pomo file at filesystem root" "$_all" "cannot create /${APP_NAME}_"
    assert_file_exists "TP-TX-08 volatile file under PREFIX/tmp" "${_tx_file}"
    _stop=$(
        HOME="${CI_HOME}" PREFIX="${_tx_prefix}" TERMUX_VERSION="0.118.0" \
        VOLATILE_DIR="${CI_HOME}/no-such-shm" \
        env -u USER_BIN sh "${SCRIPT}" stop "${_tx_name}" 2>/dev/null
    )
    _sec=$?
    assert_eq "TP-TX-08 termux stop of PREFIX/tmp pomo exit 0" 0 "$_sec"
    rm -f "${_tx_file}"

    # --- TP-TX-09: Git Bash volatile records use $HOME/AppData/Local/Temp/cache ---
    # Real Git Bash: /dev/shm missing. Prefer Windows user temp cache, not
    # $HOME/.cache and not a mid-chain mkdir die.
    mkdir -p "${CI_HOME}/AppData/Local/Temp"
    _gb_name="gb-cache"
    _u=$(id -un 2>/dev/null || echo "unknown")
    _gb_file="${CI_HOME}/AppData/Local/Temp/cache/${APP_NAME}_${_u}_${_gb_name}"
    _errf="${CI_HOME}/gb-stor.err"
    rm -f "${_gb_file}"
    _out=$(
        HOME="${CI_HOME}" MSYSTEM=MINGW64 \
        VOLATILE_DIR="${CI_HOME}/no-such-shm" \
        env -u PREFIX -u TEMP -u TMPDIR -u USER_BIN \
        sh "${SCRIPT}" start "${_gb_name}" 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    _all="${_out}${_err}"
    assert_eq "TP-TX-09 Git Bash start with unusable VOLATILE_DIR exit 0" 0 "$_ec"
    assert_not_contains "TP-TX-09 must not die on mkdir cache" "$_all" "No writable temporary storage"
    assert_not_contains "TP-TX-09 must not write pomo file at filesystem root" "$_all" "cannot create /${APP_NAME}_"
    assert_file_exists "TP-TX-09 volatile file under HOME/AppData/Local/Temp/cache" "${_gb_file}"
    _stop=$(
        HOME="${CI_HOME}" MSYSTEM=MINGW64 \
        VOLATILE_DIR="${CI_HOME}/no-such-shm" \
        env -u PREFIX -u TEMP -u TMPDIR -u USER_BIN \
        sh "${SCRIPT}" stop "${_gb_name}" 2>/dev/null
    )
    _sec=$?
    assert_eq "TP-TX-09 Git Bash stop of AppData cache pomo exit 0" 0 "$_sec"
    rm -f "${_gb_file}"

    # --- TP-TX-10: mkdir of cache as a file must not abort; fall through to $TEMP/cache ---
    mkdir -p "${CI_HOME}/AppData/Local/Temp"
    rm -rf "${CI_HOME}/AppData/Local/Temp/cache"
    touch "${CI_HOME}/AppData/Local/Temp/cache"
    _gb_temp="${CI_HOME}/win-temp"
    mkdir -p "${_gb_temp}"
    _gb_name="gb-cache-fail"
    _gb_file="${_gb_temp}/cache/${APP_NAME}_${_u}_${_gb_name}"
    _errf="${CI_HOME}/gb-mkdir.err"
    rm -f "${_gb_file}"
    _out=$(
        HOME="${CI_HOME}" MSYSTEM=MINGW64 \
        VOLATILE_DIR="${CI_HOME}/no-such-shm" \
        TEMP="${_gb_temp}" \
        env -u PREFIX -u TMPDIR -u USER_BIN \
        sh "${SCRIPT}" start "${_gb_name}" 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    _all="${_out}${_err}"
    assert_eq "TP-TX-10 Git Bash start when AppData cache mkdir fails exit 0" 0 "$_ec"
    assert_not_contains "TP-TX-10 mkdir cache must not break execution" "$_all" "No writable temporary storage"
    assert_file_exists "TP-TX-10 volatile file under \$TEMP/cache after mkdir fail" "${_gb_file}"
    _stop=$(
        HOME="${CI_HOME}" MSYSTEM=MINGW64 \
        VOLATILE_DIR="${CI_HOME}/no-such-shm" \
        TEMP="${_gb_temp}" \
        env -u PREFIX -u TMPDIR -u USER_BIN \
        sh "${SCRIPT}" stop "${_gb_name}" 2>/dev/null
    )
    _sec=$?
    assert_eq "TP-TX-10 Git Bash stop of TEMP/cache pomo exit 0" 0 "$_sec"
    rm -f "${_gb_file}" "${CI_HOME}/AppData/Local/Temp/cache"
    rm -rf "${_gb_temp}/cache"

    # --- TP-TX-11: Git Bash detect by folder /c/ (default Windows C: drive) ---
    _gb_src=$(sed -n '/^pomo_is_git_bash()/,/^}/p' "${SCRIPT}")
    assert_contains "TP-TX-11 detect source probes /c/" "${_gb_src}" '[ -d /c/ ]'
    assert_contains "TP-TX-11 detect source probes /c" "${_gb_src}" '[ -d /c ]'
    if [ -d /c/ ] || [ -d /c ]; then
        _out=$(env -u MSYSTEM -u WSL_DISTRO_NAME sh "${SCRIPT}" --json about 2>/dev/null)
        assert_contains "TP-TX-11 live /c/ about target git-bash" "$_out" '"target":"git-bash"'
        assert_contains "TP-TX-11 live /c/ about normal_user_only true" "$_out" '"normal_user_only":"true"'
    else
        t_skip "TP-TX-11 live /c/ not present on this host (source probe have)"
    fi

    # --- TP-TX-12: default-drive Temp ${GIT_BASH_DRIVE}/Users/<user>/AppData/Local/Temp/cache ---
    _u=$(id -un 2>/dev/null || echo "unknown")
    _gb_drive="${CI_HOME}/c"
    _gb_home="${CI_HOME}/gb-home-no-appdata"
    mkdir -p "${_gb_drive}/Users/${_u}/AppData/Local/Temp"
    mkdir -p "${_gb_home}"
    _gb_name="gb-drive-temp"
    _gb_file="${_gb_drive}/Users/${_u}/AppData/Local/Temp/cache/${APP_NAME}_${_u}_${_gb_name}"
    _errf="${CI_HOME}/gb-drive.err"
    rm -f "${_gb_file}"
    _out=$(
        HOME="${_gb_home}" MSYSTEM=MINGW64 \
        GIT_BASH_DRIVE="${_gb_drive}" \
        VOLATILE_DIR="${CI_HOME}/no-such-shm" \
        env -u PREFIX -u TEMP -u TMPDIR -u USER_BIN \
        sh "${SCRIPT}" start "${_gb_name}" 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    _all="${_out}${_err}"
    assert_eq "TP-TX-12 Git Bash start via GIT_BASH_DRIVE Users Temp exit 0" 0 "$_ec"
    assert_not_contains "TP-TX-12 must not die when HOME has no AppData" "$_all" "No writable temporary storage"
    assert_file_exists "TP-TX-12 volatile file under GIT_BASH_DRIVE/Users/.../Temp/cache" "${_gb_file}"
    _stop=$(
        HOME="${_gb_home}" MSYSTEM=MINGW64 \
        GIT_BASH_DRIVE="${_gb_drive}" \
        VOLATILE_DIR="${CI_HOME}/no-such-shm" \
        env -u PREFIX -u TEMP -u TMPDIR -u USER_BIN \
        sh "${SCRIPT}" stop "${_gb_name}" 2>/dev/null
    )
    _sec=$?
    assert_eq "TP-TX-12 Git Bash stop of drive Temp cache pomo exit 0" 0 "$_sec"
    rm -f "${_gb_file}"
    rm -rf "${_gb_drive}" "${_gb_home}"

    _errf="${CI_HOME}/tx-zero-arg.err"
    _out=$(
        HOME="${CI_HOME}" PREFIX="${_tx_prefix}" TERMUX_VERSION="0.118.0" \
        SCRIPT_URL="http://127.0.0.1:1/pomo-unreachable" \
        env -u USER_BIN sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _err=$(cat "${_errf}" 2>/dev/null || true)
    _all="${_out}${_err}"
    assert_not_contains "TP-TX-03 empty-argv recommend has no sudo curl" "$_all" "sudo curl"
    assert_contains "TP-TX-03 empty-argv still shows curl | sh" "$_all" "curl -fsSL"
    ci_cleanup_env
    rm -rf "${_stub}"
}
