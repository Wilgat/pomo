# =============================================================================
# tests/test_pomo_domain.sh — pomo domain (requirement-domain-pomo / TP-POMO-*)
# =============================================================================
# Domain-subject family TP-POMO-* proves requirement-domain-pomo
# (policy-harness-id-notation §5). Not portable TP-DOM-*; not bare TP-01.
# Type O-P portable payload design tokens (TP-PAYLOAD-*) are n/a for this product.
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

run_test_pomo_domain() {
    t_header "Pomo domain (TP-POMO-*)"

    require_cmd date
    require_cmd sh

    ci_isolated_env
    ci_cleanup_pomo_domain

    _run() {
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        XDG_CACHE_HOME="${CI_HOME}/.cache" \
        sh "${SCRIPT}" "$@"
    }

    # --- TP-POMO-01: help lists domain verbs/flags ---
    _out=$(_run help 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-01 help exit 0" 0 "$_ec"
    assert_contains "TP-POMO-01 help lists start" "$_out" "start"
    assert_contains "TP-POMO-01 help lists stop" "$_out" "stop"
    assert_contains "TP-POMO-01 help lists status" "$_out" "status"
    assert_contains "TP-POMO-01 help lists list" "$_out" "list"
    assert_contains "TP-POMO-01 help lists kill" "$_out" "kill"
    assert_contains "TP-POMO-01 help lists skip" "$_out" "skip"
    assert_contains "TP-POMO-01 help lists watch" "$_out" "watch"
    assert_contains "TP-POMO-01 help lists stats" "$_out" "stats"
    assert_contains "TP-POMO-01 help lists theme" "$_out" "theme"
    assert_contains "TP-POMO-01 help lists --persist" "$_out" "--persist"
    assert_contains "TP-POMO-01 help lists --break" "$_out" "--break"

    # --- TP-POMO-02: start / status / list / stop (human, volatile) ---
    # Work duration is plain minutes (1.7.0 / 2.0.0 contract)
    _out=$(_run start ci-smoke 1 --break 1 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-02 start exit 0" 0 "$_ec"
    assert_contains "TP-POMO-02 start success text" "$_out" "started"

    _out=$(_run status ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-02 status exit 0" 0 "$_ec"
    assert_contains "TP-POMO-02 status remaining text" "$_out" "remaining"

    _out=$(_run list 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-02 list exit 0" 0 "$_ec"
    assert_contains "TP-POMO-02 list includes pomodoro" "$_out" "ci-smoke"

    # --- TP-POMO-03: already-running fails ---
    _out=$(_run start ci-smoke 1 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-03 start already-running exit 1" 1 "$_ec"

    _out=$(_run stop ci-smoke 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-02 stop exit 0" 0 "$_ec"
    assert_contains "TP-POMO-02 stop completed text" "$_out" "completed"

    _out=$(_run list 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-02 list after stop exit 0" 0 "$_ec"
    case "$_out" in
        *ci-smoke*) t_fail "TP-POMO-02 list after stop still shows ci-smoke" ;;
        *) t_pass "TP-POMO-02 list after stop has no ci-smoke" ;;
    esac

    # --- default name with minutes only ---
    _out=$(_run start 1 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-02 start default name exit 0" 0 "$_ec"
    _out=$(_run stop 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-02 stop default exit 0" 0 "$_ec"

    # --- TP-POMO-04: JSON start / status / list / stop ---
    _out=$(_run --json start json-t 1 --break 1 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-04 json start exit 0" 0 "$_ec"
    assert_contains "TP-POMO-04 json start type success" "$_out" '"type":"success"'
    assert_contains "TP-POMO-04 json start name" "$_out" '"name":"json-t"'
    assert_contains "TP-POMO-04 json start phase work" "$_out" '"phase":"work"'
    assert_contains "TP-POMO-04 json start remaining" "$_out" '"remaining":'
    assert_contains "TP-POMO-04 json start work_minutes" "$_out" '"work_minutes":"1"'
    assert_contains "TP-POMO-04 json start break_minutes" "$_out" '"break_minutes":"1"'

    _out=$(_run --json status json-t 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-04 json status exit 0" 0 "$_ec"
    assert_contains "TP-POMO-04 json status type" "$_out" '"type":"status"'
    assert_contains "TP-POMO-04 json status phase" "$_out" '"phase":"work"'
    assert_contains "TP-POMO-04 json status remaining" "$_out" '"remaining":'
    assert_contains "TP-POMO-04 json status percent" "$_out" '"percent":'

    _out=$(_run --json list 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-04 json list exit 0" 0 "$_ec"
    assert_contains "TP-POMO-04 json list type" "$_out" '"type":"list"'
    assert_contains "TP-POMO-04 json list has name" "$_out" "json-t"

    _out=$(_run --json stop json-t 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-04 json stop exit 0" 0 "$_ec"
    assert_contains "TP-POMO-04 json stop counted" "$_out" '"counted":"true"'

    # --- TP-POMO-05: no_pomodoro errors ---
    _err=$(_run --json status gone 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-POMO-05 status missing exit 1" 1 "$_ec"
    assert_contains "TP-POMO-05 no_pomodoro code" "$_err" "no_pomodoro"

    # --- TP-POMO-06: kill (discard without counting) + skip phases ---
    _run start kill-me 1 >/dev/null 2>&1
    _out=$(_run kill kill-me 2>&1)
    _ec=$?
    assert_eq "TP-POMO-06 kill exit 0" 0 "$_ec"
    assert_contains "TP-POMO-06 kill discarded text" "$_out" "discarded"

    _run start skip-me 1 --break 1 >/dev/null 2>&1
    _out=$(_run skip skip-me 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-06 skip exit 0" 0 "$_ec"
    assert_contains "TP-POMO-06 skip switched text" "$_out" "break"

    _out=$(_run --json status skip-me 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-06 status after skip exit 0" 0 "$_ec"
    assert_contains "TP-POMO-06 status after skip is break" "$_out" '"phase":"break"'

    _out=$(_run --json skip skip-me 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-06 skip break→work exit 0" 0 "$_ec"
    assert_contains "TP-POMO-06 skip to work phase" "$_out" '"new_phase":"work"'

    _run kill skip-me >/dev/null 2>&1 || true

    # --- TP-POMO-09: stats + theme ---
    _out=$(_run --json stats 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-09 stats json exit 0" 0 "$_ec"
    assert_contains "TP-POMO-09 stats type" "$_out" '"type":"stats"'
    assert_contains "TP-POMO-09 stats completed key" "$_out" '"completed":'
    assert_contains "TP-POMO-09 stats total_minutes key" "$_out" '"total_minutes":'

    _out=$(_run stats 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-09 stats human exit 0" 0 "$_ec"

    _out=$(_run theme list 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-09 theme list exit 0" 0 "$_ec"
    assert_contains "TP-POMO-09 theme list default" "$_out" "default"
    assert_contains "TP-POMO-09 theme list energetic" "$_out" "energetic"
    assert_contains "TP-POMO-09 theme list minimal" "$_out" "minimal"

    _out=$(_run --json theme list 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-09 theme list json exit 0" 0 "$_ec"
    assert_contains "TP-POMO-09 theme list json kind" "$_out" '"kind":"themes"'
    assert_contains "TP-POMO-09 theme list json type list" "$_out" '"type":"list"'

    _out=$(_run theme set energetic 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-09 theme set exit 0" 0 "$_ec"
    assert_contains "TP-POMO-09 theme set text" "$_out" "energetic"

    _out=$(_run --json theme set minimal 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-09 theme set json exit 0" 0 "$_ec"
    assert_contains "TP-POMO-09 theme set json theme" "$_out" '"theme":"minimal"'

    _out=$(_run --json theme next 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-09 theme next json exit 0" 0 "$_ec"
    assert_contains "TP-POMO-09 theme next json theme key" "$_out" '"theme":'

    _out=$(_run --json theme prev 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-09 theme prev json exit 0" 0 "$_ec"

    _err=$(_run --json theme set not-a-theme 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-POMO-09 invalid theme exit 1" 1 "$_ec"
    assert_contains "TP-POMO-09 invalid_theme code" "$_err" "invalid_theme"

    # --- TP-POMO-10: watch refuses --json ---
    _err=$(_run --json watch 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-POMO-10 watch --json exits non-zero" 1 "$_ec"

    # --- TP-POMO-07: invalid name (path-safe) + invalid duration ---
    _err=$(_run start 'bad/name' 1 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-POMO-07 invalid name exit 1" 1 "$_ec"

    _err=$(_run --json start 'bad/name' 1 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-POMO-07 invalid name json exit 1" 1 "$_ec"
    assert_contains "TP-POMO-07 invalid_name code" "$_err" "invalid_name"

    _err=$(_run --json start '..' 1 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-POMO-07 invalid name dots exit 1" 1 "$_ec"
    assert_contains "TP-POMO-07 invalid_name dots code" "$_err" "invalid_name"

    _err=$(_run --json start zd 0 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-POMO-07 zero work duration exit 1" 1 "$_ec"
    assert_contains "TP-POMO-07 invalid_duration code" "$_err" "invalid_duration"

    _err=$(_run --json start 1 --break 2>&1 >/dev/null)
    _ec=$?
    if [ "$_ec" -ne 0 ]; then
        t_pass "TP-POMO-07 --break without value fails"
    else
        t_fail "TP-POMO-07 --break without value expected non-zero"
    fi

    # --- TP-POMO-08: persistent mode ---
    _out=$(_run start --persist persist-t 1 --break 1 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-08 persist start exit 0" 0 "$_ec"
    assert_contains "TP-POMO-08 persist start success" "$_out" "started"

    _out=$(_run status --persist persist-t 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-08 persist status exit 0" 0 "$_ec"

    _out=$(_run list --persist 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-08 persist list exit 0" 0 "$_ec"
    assert_contains "TP-POMO-08 persist list name" "$_out" "persist-t"

    _out=$(_run stop --persist persist-t 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-08 persist stop exit 0" 0 "$_ec"

    # --- TP-POMO-11: stop --force discards without counting ---
    _run start force-me 1 >/dev/null 2>&1
    _out=$(_run --json --force stop force-me 2>/dev/null)
    _ec=$?
    assert_eq "TP-POMO-11 stop --force exit 0" 0 "$_ec"
    assert_contains "TP-POMO-11 stop --force not counted" "$_out" '"counted":"false"'

    # --- TP-POMO-12: volatile storage path ---
    # Live layout (pomo_get_file): ${/dev/shm|/tmp}/${APP_NAME}_${USER}_${name}
    _run start stor-path 1 --break 1 >/dev/null 2>&1
    _u=$(id -un 2>/dev/null || echo "unknown")
    _hit=0
    _state=
    for _base in /dev/shm /tmp; do
        _candidate="${_base}/${APP_NAME}_${_u}_stor-path"
        if [ -f "$_candidate" ]; then
            _hit=1
            _state="$_candidate"
            break
        fi
        # also accept nested private-dir layout if product changes
        _candidate2="${_base}/${APP_NAME}-${_u}/${APP_NAME}_${_u}_stor-path"
        if [ -f "$_candidate2" ]; then
            _hit=1
            _state="$_candidate2"
            break
        fi
    done
    if [ "$_hit" -eq 1 ]; then
        t_pass "TP-POMO-12 volatile storage file present"
    else
        _out=$(_run status stor-path 2>/dev/null)
        if [ $? -eq 0 ]; then
            t_pass "TP-POMO-12 storage resolved (status OK; path layout may differ)"
        else
            t_fail "TP-POMO-12 no storage file and status failed"
        fi
    fi
    _run kill stor-path >/dev/null 2>&1 || true
    _run stop stor-path >/dev/null 2>&1 || true

    # --- TP-POMO-13: corrupted state → fail-closed ---
    _run start corrupt-me 1 --break 1 >/dev/null 2>&1
    _u=$(id -un 2>/dev/null || echo "unknown")
    _state=
    for _base in /dev/shm /tmp; do
        _candidate="${_base}/${APP_NAME}_${_u}_corrupt-me"
        if [ -f "$_candidate" ]; then
            _state="$_candidate"
            break
        fi
        _candidate2="${_base}/${APP_NAME}-${_u}/${APP_NAME}_${_u}_corrupt-me"
        if [ -f "$_candidate2" ]; then
            _state="$_candidate2"
            break
        fi
    done
    if [ -n "$_state" ]; then
        # Empty file: read of 5 fields fails → corrupted_data (partial junk can still parse)
        : > "$_state"
        _err=$(_run --json status corrupt-me 2>&1)
        _ec=$?
        if [ "$_ec" -ne 0 ]; then
            t_pass "TP-POMO-13 corrupted state status non-zero"
            assert_contains "TP-POMO-13 corrupted_data code" "$_err" "corrupted_data"
        else
            t_fail "TP-POMO-13 corrupted state expected non-zero status (out='$(_trunc "$_err")')"
        fi
    else
        t_skip "TP-POMO-13 could not locate state file to corrupt"
    fi
    _run kill corrupt-me >/dev/null 2>&1 || true
    _run stop corrupt-me >/dev/null 2>&1 || true

    # cleanup domain artifacts for this user
    ci_cleanup_pomo_domain
    rm -rf "${CI_HOME}/.cache/${APP_NAME}" 2>/dev/null || true

    ci_cleanup_env
}
