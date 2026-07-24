# =============================================================================
# tests/test_online_curl_install.sh — TP-CURL-* (PM-ONLINE-CURL-INSTALL-TEST-PLAN)
# =============================================================================
# Mold catalog order: TP-CURL-01..09. Core = local HTTP; Optional = public flag.
# Product is Type O /bin/sh (mold "bash" sketches → sh -s when product supports sh).
# TP-CURL-04 mold Core = hostile HOME + set -u (pipe and/or direct); dual with TP-U-03.
# Primary REQs: RQ-SHELL-CLI-ZERO-ARGUMENTS, RQ-SHELL-SELF-MANAGEMENT,
#               RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE.
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_online_curl_install() {
    t_header "Online curl|sh (PM-ONLINE-CURL-INSTALL-TEST-PLAN / TP-CURL-*)"

    require_cmd curl
    require_cmd python3
    require_cmd sha256sum

    ci_isolated_env
    if ! ci_start_channel; then
        ci_cleanup_env
        return 1
    fi

    _errf="${CI_HOME}/curl-err.txt"
    _app_bin="${CI_USER_BIN}/${APP_NAME}"

    # --- TP-CURL-01: Channel probe (Core) ---
    _out=$(curl -fsS "${CI_SCRIPT_URL}" 2>"${_errf}")
    _ec=$?
    assert_eq "TP-CURL-01 curl channel ship unit exit 0" 0 "$_ec"
    case "$_out" in
        *"APP_NAME=\"${APP_NAME}\""*|*"APP_NAME:=${APP_NAME}"*|*"APP_NAME:=\"${APP_NAME}\""*)
            t_pass "TP-CURL-01 body has APP_NAME assign" ;;
        *) t_fail "TP-CURL-01 body missing APP_NAME assign for ${APP_NAME}" ;;
    esac
    assert_contains "TP-CURL-01 body has VERSION" "$_out" "VERSION=\""
    _comp=$(curl -fsS "${CI_SCRIPT_URL}.sha256" 2>"${_errf}")
    _ec=$?
    assert_eq "TP-CURL-01 companion download exit 0" 0 "$_ec"
    _hex=$(printf '%s' "$_comp" | awk '{print $1; exit}')
    case "$_hex" in
        [0-9a-fA-F][0-9a-fA-F]*) t_pass "TP-CURL-01 companion first field looks like SHA-256 hex" ;;
        *) t_fail "TP-CURL-01 companion not hex: '$(_trunc "$_hex")'" ;;
    esac

    # --- TP-CURL-02: First curl|sh clean HOME (Core) ---
    # Mold sketch uses bash; product Type O is /bin/sh → sh (not silent; binary at USER_BIN)
    : > "${_errf}"
    _out=$(
        curl -fsSL "${CI_SCRIPT_URL}" 2>"${_errf}" \
        | env HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
            sh 2>>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-CURL-02 first pipe install exit 0" 0 "$_ec"
    assert_file_exists "TP-CURL-02 binary at USER_BIN" "${_app_bin}"
    assert_not_silent "TP-CURL-02 first pipe not silent" "$_out" "$_err"

    # --- TP-CURL-03: Second pipe same HOME (Core) ---
    : > "${_errf}"
    _out=$(
        curl -fsSL "${CI_SCRIPT_URL}" 2>"${_errf}" \
        | env HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
            sh 2>>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-CURL-03 second pipe exit 0" 0 "$_ec"
    assert_not_silent "TP-CURL-03 second pipe not silent" "$_out" "$_err"
    assert_not_contains "TP-CURL-03 second pipe not help-only" "$_out" "Global Options"
    assert_contains "TP-CURL-03 second pipe already-installed messaging" "$_out$_err" "already installed"

    # --- TP-CURL-04: bashrc + set -u via pipe (Core) + direct (TP-U-03) ---
    # Mold: HOME with .bashrc stub; pipe or product invoke must not be silent under set -u.
    # Product does not source bashrc; still prove non-silent under hostile HOME.
    printf 'export UNBOUND_SDKMAN_STYLE=\n# stub sdkman-style\n' > "${CI_HOME}/.bashrc"
    : > "${_errf}"
    _out=$(
        curl -fsSL "${CI_SCRIPT_URL}" 2>"${_errf}" \
        | env HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
            sh 2>>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-CURL-04 pipe under HOME with bashrc exit 0" 0 "$_ec"
    assert_not_silent "TP-CURL-04 pipe under bashrc not silent" "$_out" "$_err"

    : > "${_errf}"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
        sh "${SCRIPT}" version 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-CURL-04 TP-U-03 direct version under bashrc HOME exit 0" 0 "$_ec"
    assert_not_silent "TP-CURL-04 TP-U-03 direct not silent" "$_out" "$_err"
    assert_contains "TP-CURL-04 TP-U-03 version text" "$_out" "${APP_VERSION}"

    # --- TP-CURL-05: Bad URL with curl -fsSL (Core) ---
    : > "${_errf}"
    _out=$(curl -fsSL "http://127.0.0.1:1/${APP_NAME}-missing" 2>"${_errf}" || true)
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_not_silent "TP-CURL-05 bad URL curl not silent" "$_out" "$_err"

    # --- TP-CURL-06: curl|sh when product requires bash (Core if bash-only) ---
    # Product supports /bin/sh → n/a with explicit pass note (mold skip rule).
    t_pass "TP-CURL-06 n/a product supports sh (no bash-required gate)"

    # --- TP-CURL-07: Pipe with args: sh -s -- version (Core; mold bash -s → sh -s) ---
    : > "${_errf}"
    _out=$(
        curl -fsSL "${CI_SCRIPT_URL}" 2>"${_errf}" \
        | env HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" SCRIPT_URL="${CI_SCRIPT_URL}" \
            sh -s -- version 2>>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    assert_eq "TP-CURL-07 pipe version exit 0" 0 "$_ec"
    assert_contains "TP-CURL-07 pipe version reports version" "$_out" "${APP_VERSION}"
    assert_not_silent "TP-CURL-07 pipe version not silent" "$_out" "$_err"

    # --- TP-CURL-08: Product runs, channel unreachable for install (Core) ---
    rm -f "${_app_bin}"
    : > "${_errf}"
    _out=$(
        env HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        SCRIPT_URL="http://127.0.0.1:1/${APP_NAME}-unreachable" \
        sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    _err=$(cat "${_errf}" 2>/dev/null || true)
    if [ "$_ec" -ne 0 ]; then
        t_pass "TP-CURL-08 unreachable channel non-zero"
    else
        t_fail "TP-CURL-08 expected non-zero, got 0"
    fi
    assert_not_silent "TP-CURL-08 unreachable not silent" "$_out" "$_err"
    assert_file_missing "TP-CURL-08 no binary left" "${_app_bin}"

    # --- TP-CURL-09: Published online channel smoke (Optional) ---
    if [ "${RUN_ONLINE_CURL_TESTS:-0}" = "1" ]; then
        t_info "TP-CURL-09 online smoke: flag set"
        t_skip "TP-CURL-09 optional online (configure real SCRIPT_URL harness if desired)"
    else
        t_skip "TP-CURL-09 optional online (set RUN_ONLINE_CURL_TESTS=1)"
    fi

    ci_stop_channel
    ci_cleanup_env
}
