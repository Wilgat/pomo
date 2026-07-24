# Test plan — pomo

Maps **portable proof molds (`PM-*`)** to product-root `tests/` with status.  
**Suite entry:** `./tests/run.sh` (`PM-SHELL-CLI-SUITE-TEST-PLAN` order: CLI → LC → CURL → domain)  
**Last update:** 2026-07-24 (mold alignment: CURL order + TP-POMO/STORAGE worked catalog)

**Proof molds (cite by PM-ID):**

| Family | Proof mold-ID | Suite file | Specialize note |
|--------|---------------|------------|-----------------|
| **TP-CLI** | `PM-SHELL-CLI-TEST-PLAN` | `tests/test_cli.sh` | Core 01–11; product **12** beyond mold |
| **TP-LC** | `PM-INSTALL-LIFECYCLE-TEST-PLAN` | `tests/test_install_lifecycle.sh` | Core 01–09; product **05b/10–12** beyond mold |
| **TP-CSUM** | `PM-CHECKSUM-TEST-PLAN` | CLI + lifecycle | Full 01–05 |
| **TP-U** | `PM-SET-U-TEST-PLAN` | CLI + curl | 01–03 have; 04–05 n/a |
| **TP-CURL** | `PM-ONLINE-CURL-INSTALL-TEST-PLAN` | `tests/test_online_curl_install.sh` | Full 01–09; sh not bash |
| **TP-POMO** | `PM-DOMAIN-TEST-PLAN` §4.2.3 | `tests/test_pomo_domain.sh` | Subject `pomo` ops |
| **TP-STORAGE** | `PM-DOMAIN-TEST-PLAN` §4.2.3 storage | same | Maps mold storage intents 08–10 pattern |
| Umbrella | `PM-SHELL-CLI-SUITE-TEST-PLAN` | `tests/run.sh` | |

Status: **have** = automated · **todo** = needed · **n/a** = not applicable · **optional** = gated  

**Policy:** `policy-harness-id-notation` §5 — stack families portable; domain-subject **`TP-POMO-*`** + storage **`TP-STORAGE-*`** product-local (not `TP-DOM-*`).

---

## Baseline result

| Date | Result | Notes |
|------|--------|-------|
| 2026-07-16 | PASS=181 FAIL=0 SKIP=0 | Pre–family-ID suite |
| 2026-07-24 | **PASS=236 FAIL=0 SKIP=1** | CURL + domain storage; SKIP=TP-CURL-09 optional |
| 2026-07-24 | *(mold align)* | CURL catalog order + mold-faithful TP-CURL-04 pipe; domain mold §4.2.3 |

---

## TP-CLI — `PM-SHELL-CLI-TEST-PLAN`

| TP-ID | Mold intent | Status | Evidence / specialize |
|-------|-------------|--------|------------------------|
| **TP-CLI-01** | Syntax + companion Shape A | **have** | `sh -n` (mold `bash -n` → product `/bin/sh`); `pomo.sha256` |
| **TP-CLI-02** | Version human + JSON | **have** | version exit/app/version |
| **TP-CLI-03** | Help Type 0 + domain surface | **have** | install/self-*; domain verbs; no CHECKSUM |
| **TP-CLI-04** | Help/about JSON purity | **have** | help/about JSON; about no CHECKSUM |
| **TP-CLI-05** | About storage resolve | **n/a** | No shell `storage_dir` about; domain **TP-STORAGE-*** |
| **TP-CLI-06** | Unknown command | **have** | human + JSON `out_error` |
| **TP-CLI-07** | Quiet mode | **have** | `--quiet` and `-q` |
| **TP-CLI-08** | `env -u HOME` under set -u | **have** | = **TP-U-01** |
| **TP-CLI-09** | Zero-arg bad channel | **have** | non-zero; not silent; no binary (= **TP-LC-09** / **TP-U-02**) |
| **TP-CLI-10** | bashrc+sdkman under set -u | **n/a** | No product sdkman source path |
| **TP-CLI-11** | self-uninstall refuse without force | **have** | `confirm_required`; binary remains |
| **TP-CLI-12** | *(product extension)* out_json string-key | **have** | beyond mold; string-escape contract (`@key` raw n/a) |

---

## TP-LC — `PM-INSTALL-LIFECYCLE-TEST-PLAN`

| TP-ID | Mold intent | Status | Evidence / specialize |
|-------|-------------|--------|------------------------|
| **TP-LC-01** | First empty-argv ensure (+ already local/global) | **have** | lifecycle suite |
| **TP-LC-02** | Payload `install` | **n/a** | Type O CLI — no Type O-P payload |
| **TP-LC-03** | Payload uninstall | **n/a** | No payload surface |
| **TP-LC-04** | About installed + version-check JSON | **have** | local/remote/is_latest |
| **TP-LC-05** | self-update already-latest | **have** | success message (alias n/a if not claimed) |
| **TP-LC-05b** | *(product)* self-update when remote newer | **have** | beyond mold core table |
| **TP-LC-06** | Force reinstall companion transparency | **have** | = **TP-CSUM-02**; mold wording “self-update --force” → product force install path |
| **TP-LC-07** | self-uninstall refuse / force | **have** | + PATH cleanup when bin empty |
| **TP-LC-08** | Downgrade refuse / force | **have** | `downgrade_blocked` + force allow |
| **TP-LC-09** | Bad channel empty argv | **have** | CLI suite class |
| **TP-LC-10** | *(product)* Idempotent re-install | **have** | beyond mold; “already installed” |
| **TP-LC-11** | *(product)* version-check network failure | **have** | beyond mold |
| **TP-LC-12** | *(product)* Explicit `install --json` | **have** | beyond mold |

---

## TP-CSUM — `PM-CHECKSUM-TEST-PLAN`

| TP-ID | Mold intent | Status | Evidence |
|-------|-------------|--------|----------|
| **TP-CSUM-01** | Publisher companion matches ship unit | **have** | CLI |
| **TP-CSUM-02** | Human force reinstall transparency | **have** | lifecycle (= **TP-LC-06**) |
| **TP-CSUM-03** | Shape B pin mismatch abort | **have** | lifecycle |
| **TP-CSUM-04** | Shape B pin match install | **have** | lifecycle |
| **TP-CSUM-05** | Help/about hide CHECKSUM | **have** | CLI |

---

## TP-U — `PM-SET-U-TEST-PLAN`

| TP-ID | Mold intent | Status | Evidence |
|-------|-------------|--------|----------|
| **TP-U-01** | `env -u HOME` safe command | **have** | TP-CLI-08 |
| **TP-U-02** | Defaults on zero-arg fail path | **have** | TP-CLI-09 |
| **TP-U-03** | bashrc stub under set -u (direct) | **have** | TP-CURL-04 direct |
| **TP-U-04** | bashrc via **pipe** (product sources bashrc) | **n/a** | product does not source bashrc on pipe; pipe still covered under **TP-CURL-04** non-silent |
| **TP-U-05** | Safe external source helper | **n/a** | no bare product sdkman source path |

---

## TP-CURL — `PM-ONLINE-CURL-INSTALL-TEST-PLAN`

Mold catalog order and Core/Opt flags. Product uses **`sh`** where mold sketches **`bash`** (Type O `/bin/sh` product).

| TP-ID | Mold intent | Core/Opt | Status | Evidence |
|-------|-------------|----------|--------|----------|
| **TP-CURL-01** | Channel probe | Core | **have** | local HTTP ship + companion hex |
| **TP-CURL-02** | First `curl \| sh` clean HOME | Core | **have** | binary at USER_BIN; not silent |
| **TP-CURL-03** | Second pipe same HOME | Core | **have** | already-installed; not help-only |
| **TP-CURL-04** | Hostile HOME / bashrc under set -u | Core | **have** | **pipe** + direct version (**TP-U-03**) |
| **TP-CURL-05** | Bad URL `curl -fsSL` | Core | **have** | not silent |
| **TP-CURL-06** | `curl \| sh` when product requires bash | Core if bash-only | **n/a** | product supports `/bin/sh` |
| **TP-CURL-07** | Pipe args: `sh -s -- version` | Core | **have** | version text; not silent |
| **TP-CURL-08** | Unreachable SCRIPT_URL install | Core | **have** | non-zero; no binary; not silent |
| **TP-CURL-09** | Public online channel | Optional | **optional** | `RUN_ONLINE_CURL_TESTS=1` |

---

## TP-POMO — `PM-DOMAIN-TEST-PLAN` §4.2.3 (ops)

Subject = `pomo`. **Not** portable **TP-DOM-***. Law: domain SSOT for pomodoro.

| TP-ID | Mold §4.2.3 intent | Status | Evidence |
|-------|--------------------|--------|----------|
| **TP-POMO-01** | Help domain verbs/flags | **have** | start/status/watch/skip/stop/kill/list/stats/theme/--persist/--break |
| **TP-POMO-02** | start/status/list/stop human (+ minutes) | **have** | domain suite |
| **TP-POMO-03** | already-running | **have** | domain suite |
| **TP-POMO-04** | JSON start/status/list/stop | **have** | domain suite |
| **TP-POMO-05** | Missing resource (`no_pomodoro`) | **have** | domain suite |
| **TP-POMO-06** | kill / skip phases | **have** | domain suite |
| **TP-POMO-07** | invalid_name / invalid_duration | **have** | domain suite |
| **TP-POMO-09** | stats + theme | **have** | domain suite |
| **TP-POMO-10** | watch rejects `--json` | **have** | domain suite |
| **TP-POMO-11** | stop `--force` not counted | **have** | domain suite |
| **TP-PAYLOAD-*** | Type O-P scaffold (§4.1) | **n/a** | not Type O-P payload product |

---

## TP-STORAGE — `PM-DOMAIN-TEST-PLAN` §4.2.3 (storage)

Product-local storage family (mold dual-storage pattern). Maps countdown/timer storage intents without claiming those subject IDs.

| TP-ID | Mold intent | Parallel mold row | Status | Evidence |
|-------|-------------|-------------------|--------|----------|
| **TP-STORAGE-01** | Volatile storage path resolve | ~ COUNTDOWN-09 / TIMER-09 | **have** | `/dev/shm\|tmp/${APP}_${USER}_${name}` |
| **TP-STORAGE-02** | `--persist` start/list/status/stop | ~ COUNTDOWN-08 / TIMER-08 | **have** | isolated HOME |
| **TP-STORAGE-03** | Corrupted state → `corrupted_data` | ~ COUNTDOWN-10 | **have** | empty state file |

Legacy: TP-POMO-08→**TP-STORAGE-02**, TP-POMO-12→**01**, TP-POMO-13→**03**.

---

## Static proof (finding lock-in)

| TP-ID | Intent | Status | Notes |
|-------|--------|--------|-------|
| **TP-CITE-01** | Ship unit ALIGNMENT cites live REQs | **have** | header comments |
| **TP-ID-01** | `APP_NAME` hard-assign / Config SSOT | **have** | ship unit pomo |
| **TP-DOC-01** | README pin not frozen stale hash | **have** | closed 2026-07-16 |
| **TP-DOC-02** | README bootstrap claim disk-honest | **have** | closed 2026-07-16 |
| **TP-HYG-01** | Ship unit header APP_NAME default | **have** | closed 2026-07-16 |

---

## Legacy map (retired → family)

| Legacy | Now |
|--------|-----|
| TP-01…23 bare | family IDs (see prior map) |
| TP-POMO-08 | **TP-STORAGE-02** |
| TP-POMO-12 | **TP-STORAGE-01** |
| TP-POMO-13 | **TP-STORAGE-03** |

---

## Rules

1. Closing a bug updates matching TP to **have** (or supersedes with a new test).  
2. Do not mark **have** without suite assertion (or documented static fix).  
3. Domain ops = **TP-POMO-***; storage = **TP-STORAGE-***; stack families portable.  
4. Primary citation uses **TP-IDs** / **`RQ-*`**; suite path secondary.  
5. Versioned requirements list TP + `tests/*` + `reviews/*` only — never `docs/templates/**`.  
6. Mold Core rows: implement or honest **n/a**; Optional may **skip** with message.  
