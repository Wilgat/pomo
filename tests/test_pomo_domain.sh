# =============================================================================
# tests/test_pomo_domain.sh — pomo product domain commands
# =============================================================================
# Covers: start (work/break minutes) / status / list / stop / kill / skip,
# stats, theme, --json, --persist, invalid name, already-running, no_pomodoro.
# Uses isolated HOME for persistent storage; cleans volatile files after suite.
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_pomo_domain() {
    t_header "Pomo domain"

    require_cmd date
    require_cmd sh

    ci_isolated_env
    ci_cleanup_pomo_domain

    _run() {
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        XDG_CACHE_HOME="${CI_HOME}/.cache" \
        sh "${SCRIPT}" "$@"
    }

    # --- start / status / list / stop (human, volatile) ---
    # Work duration is plain minutes (1.7.0 / 2.0.0 contract)
    _out=$(_run start ci-smoke 1 --break 1 2>/dev/null)
    _ec=$?
    assert_eq "domain start exit 0" 0 "$_ec"
    assert_contains "domain start success text" "$_out" "started"

    _out=$(_run status ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "domain status exit 0" 0 "$_ec"
    assert_contains "domain status remaining text" "$_out" "remaining"

    _out=$(_run list 2>/dev/null)
    _ec=$?
    assert_eq "domain list exit 0" 0 "$_ec"
    assert_contains "domain list includes pomodoro" "$_out" "ci-smoke"

    # already running fails
    _out=$(_run start ci-smoke 1 2>/dev/null)
    _ec=$?
    assert_eq "domain start already-running exit 1" 1 "$_ec"

    _out=$(_run stop ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "domain stop exit 0" 0 "$_ec"
    assert_contains "domain stop completed text" "$_out" "completed"

    _out=$(_run list 2>/dev/null)
    _ec=$?
    assert_eq "domain list after stop exit 0" 0 "$_ec"
    case "$_out" in
        *ci-smoke*) t_fail "domain list after stop still shows ci-smoke" ;;
        *) t_pass "domain list after stop has no ci-smoke" ;;
    esac

    # --- default name with minutes only ---
    _out=$(_run start 1 2>/dev/null)
    _ec=$?
    assert_eq "domain start default name exit 0" 0 "$_ec"
    _out=$(_run stop 2>/dev/null)
    _ec=$?
    assert_eq "domain stop default exit 0" 0 "$_ec"

    # --- JSON start / status / list / stop ---
    _out=$(_run --json start json-t 1 --break 1 2>/dev/null)
    _ec=$?
    assert_eq "domain json start exit 0" 0 "$_ec"
    assert_contains "domain json start type success" "$_out" '"type":"success"'
    assert_contains "domain json start name" "$_out" '"name":"json-t"'
    assert_contains "domain json start phase work" "$_out" '"phase":"work"'
    assert_contains "domain json start remaining" "$_out" '"remaining":'
    assert_contains "domain json start work_minutes" "$_out" '"work_minutes":"1"'
    assert_contains "domain json start break_minutes" "$_out" '"break_minutes":"1"'

    _out=$(_run --json status json-t 2>/dev/null)
    _ec=$?
    assert_eq "domain json status exit 0" 0 "$_ec"
    assert_contains "domain json status type" "$_out" '"type":"status"'
    assert_contains "domain json status phase" "$_out" '"phase":"work"'
    assert_contains "domain json status remaining" "$_out" '"remaining":'
    assert_contains "domain json status percent" "$_out" '"percent":'

    _out=$(_run --json list 2>/dev/null)
    _ec=$?
    assert_eq "domain json list exit 0" 0 "$_ec"
    assert_contains "domain json list type" "$_out" '"type":"list"'
    assert_contains "domain json list has name" "$_out" "json-t"

    _out=$(_run --json stop json-t 2>/dev/null)
    _ec=$?
    assert_eq "domain json stop exit 0" 0 "$_ec"
    assert_contains "domain json stop counted" "$_out" '"counted":"true"'

    # --- no_pomodoro errors ---
    _err=$(_run --json status gone 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain status missing exit 1" 1 "$_ec"
    assert_contains "domain status no_pomodoro code" "$_err" "no_pomodoro"

    # --- kill (discard without counting; human warn is on stderr) ---
    _run start kill-me 1 >/dev/null 2>&1
    _out=$(_run kill kill-me 2>&1)
    _ec=$?
    assert_eq "domain kill exit 0" 0 "$_ec"
    assert_contains "domain kill discarded text" "$_out" "discarded"

    # --- skip work → break ---
    _run start skip-me 1 --break 1 >/dev/null 2>&1
    _out=$(_run skip skip-me 2>/dev/null)
    _ec=$?
    assert_eq "domain skip exit 0" 0 "$_ec"
    assert_contains "domain skip switched text" "$_out" "break"

    _out=$(_run --json status skip-me 2>/dev/null)
    _ec=$?
    assert_eq "domain status after skip exit 0" 0 "$_ec"
    assert_contains "domain status after skip is break" "$_out" '"phase":"break"'

    _out=$(_run --json skip skip-me 2>/dev/null)
    _ec=$?
    assert_eq "domain skip break→work exit 0" 0 "$_ec"
    assert_contains "domain skip to work phase" "$_out" '"new_phase":"work"'

    _run kill skip-me >/dev/null 2>&1 || true

    # --- stats ---
    _out=$(_run --json stats 2>/dev/null)
    _ec=$?
    assert_eq "domain stats json exit 0" 0 "$_ec"
    assert_contains "domain stats type" "$_out" '"type":"stats"'
    assert_contains "domain stats completed key" "$_out" '"completed":'
    assert_contains "domain stats total_minutes key" "$_out" '"total_minutes":'

    _out=$(_run stats 2>/dev/null)
    _ec=$?
    assert_eq "domain stats human exit 0" 0 "$_ec"

    # --- theme list / set / next / prev ---
    _out=$(_run theme list 2>/dev/null)
    _ec=$?
    assert_eq "domain theme list exit 0" 0 "$_ec"
    assert_contains "domain theme list default" "$_out" "default"
    assert_contains "domain theme list energetic" "$_out" "energetic"
    assert_contains "domain theme list minimal" "$_out" "minimal"

    _out=$(_run --json theme list 2>/dev/null)
    _ec=$?
    assert_eq "domain theme list json exit 0" 0 "$_ec"
    assert_contains "domain theme list json kind" "$_out" '"kind":"themes"'
    assert_contains "domain theme list json type list" "$_out" '"type":"list"'

    _out=$(_run theme set energetic 2>/dev/null)
    _ec=$?
    assert_eq "domain theme set exit 0" 0 "$_ec"
    assert_contains "domain theme set text" "$_out" "energetic"

    _out=$(_run --json theme set minimal 2>/dev/null)
    _ec=$?
    assert_eq "domain theme set json exit 0" 0 "$_ec"
    assert_contains "domain theme set json theme" "$_out" '"theme":"minimal"'

    _out=$(_run --json theme next 2>/dev/null)
    _ec=$?
    assert_eq "domain theme next json exit 0" 0 "$_ec"
    assert_contains "domain theme next json theme key" "$_out" '"theme":'

    _out=$(_run --json theme prev 2>/dev/null)
    _ec=$?
    assert_eq "domain theme prev json exit 0" 0 "$_ec"

    _err=$(_run --json theme set not-a-theme 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain invalid theme exit 1" 1 "$_ec"
    assert_contains "domain invalid_theme code" "$_err" "invalid_theme"

    # --- watch refuses --json ---
    _err=$(_run --json watch 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain watch --json exits non-zero" 1 "$_ec"

    # --- invalid name (path-safe) ---
    _err=$(_run start 'bad/name' 1 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain invalid name exit 1" 1 "$_ec"

    _err=$(_run --json start 'bad/name' 1 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain invalid name json exit 1" 1 "$_ec"
    assert_contains "domain invalid_name code" "$_err" "invalid_name"

    _err=$(_run --json start '..' 1 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain invalid name dots exit 1" 1 "$_ec"
    assert_contains "domain invalid_name dots code" "$_err" "invalid_name"

    # --- zero / invalid work duration ---
    _err=$(_run --json start zd 0 2>&1 >/dev/null)
    _ec=$?
    assert_eq "domain zero work duration exit 1" 1 "$_ec"
    assert_contains "domain invalid_duration code" "$_err" "invalid_duration"

    # --- --break requires number ---
    _err=$(_run --json start 1 --break 2>&1 >/dev/null)
    _ec=$?
    if [ "$_ec" -ne 0 ]; then
        t_pass "domain --break without value fails"
    else
        t_fail "domain --break without value expected non-zero"
    fi

    # --- persistent mode ---
    _out=$(_run start --persist persist-t 1 --break 1 2>/dev/null)
    _ec=$?
    assert_eq "domain persist start exit 0" 0 "$_ec"
    assert_contains "domain persist start success" "$_out" "started"

    _out=$(_run status --persist persist-t 2>/dev/null)
    _ec=$?
    assert_eq "domain persist status exit 0" 0 "$_ec"

    _out=$(_run list --persist 2>/dev/null)
    _ec=$?
    assert_eq "domain persist list exit 0" 0 "$_ec"
    assert_contains "domain persist list name" "$_out" "persist-t"

    _out=$(_run stop --persist persist-t 2>/dev/null)
    _ec=$?
    assert_eq "domain persist stop exit 0" 0 "$_ec"

    # --- stop --force discards without counting (via kill path) ---
    _run start force-me 1 >/dev/null 2>&1
    _out=$(_run --json --force stop force-me 2>/dev/null)
    _ec=$?
    assert_eq "domain stop --force exit 0" 0 "$_ec"
    assert_contains "domain stop --force not counted" "$_out" '"counted":"false"'

    # cleanup domain artifacts for this user
    ci_cleanup_pomo_domain
    rm -rf "${CI_HOME}/.cache/${APP_NAME}" 2>/dev/null || true

    ci_cleanup_env
}
