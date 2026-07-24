# Test plan — pomo

Maps **portable TP families** (proof molds) to product-root `tests/`.  
**Suite entry:** `./tests/run.sh`  
**Last update:** 2026-07-24 (H2 harness sync, ID notation, **TP-POMO-*** domain family)

**Proof molds (cite by PM-ID):**

| Family | Proof mold-ID | Suite file |
|--------|---------------|------------|
| **TP-CLI** | `PM-SHELL-CLI-TEST-PLAN` | `tests/test_cli.sh` |
| **TP-LC** | `PM-INSTALL-LIFECYCLE-TEST-PLAN` | `tests/test_install_lifecycle.sh` |
| **TP-CSUM** | `PM-CHECKSUM-TEST-PLAN` | CLI + lifecycle |
| **TP-U** | `PM-SET-U-TEST-PLAN` | CLI (partial) |
| **TP-CURL** | `PM-ONLINE-CURL-INSTALL-TEST-PLAN` | `tests/test_online_curl_install.sh` |
| **TP-POMO** | `PM-DOMAIN-TEST-PLAN` (specialize) → **`RQ-DOMAIN-POMO`** ops | `tests/test_pomo_domain.sh` |
| **TP-STORAGE** | domain storage pillars (product-local) → **`RQ-DOMAIN-POMO`** §2.3 | `tests/test_pomo_domain.sh` |
| Umbrella | `PM-SHELL-CLI-SUITE-TEST-PLAN` | `tests/run.sh` |

Status: **have** = automated · **todo** = needed · **n/a** = not applicable · **optional** = gated

**Policy:** `policy-harness-id-notation` §5 — stack families portable; domain-subject family is **`TP-POMO-*`** only (not `TP-DOM-*`, not bare `TP-01`).

---

## Baseline result

| Date | Result | Notes |
|------|--------|-------|
| 2026-07-16 | PASS=181 FAIL=0 SKIP=0 | Pre–family-ID suite |
| 2026-07-24 | **PASS=211 FAIL=0 SKIP=0** | TP family labels + **TP-POMO-***; lifecycle parity gaps filled |
| 2026-07-24 | **PASS=236 FAIL=0 SKIP=1** | **TP-CURL-*** suite + **TP-POMO-12/13**; **TP-U-03** via TP-CURL-04; SKIP=TP-CURL-09 optional |

---

## TP-CLI — CLI surface (`PM-SHELL-CLI-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-CLI-01** | Syntax + companion Shape A | **have** | `sh -n`; `pomo.sha256` match |
| **TP-CLI-02** | Version human + JSON | **have** | version exit/app/version |
| **TP-CLI-03** | Help Type 0 + domain surface | **have** | install/self-*; domain verbs; no CHECKSUM |
| **TP-CLI-04** | Help/about JSON purity | **have** | help/about JSON; about no CHECKSUM |
| **TP-CLI-05** | About shell storage resolve | **n/a** | domain owns storage (**TP-STORAGE-***) |
| **TP-CLI-06** | Unknown command | **have** | human + JSON `out_error` |
| **TP-CLI-07** | Quiet mode | **have** | `--quiet` and `-q` |
| **TP-CLI-08** | `env -u HOME` under set -u | **have** | also **TP-U-01** |
| **TP-CLI-09** | Zero-arg bad channel | **have** | non-zero; not silent; no binary |
| **TP-CLI-10** | bashrc+sdkman under set -u | **n/a** | No product sdkman/source path |
| **TP-CLI-11** | self-uninstall refuse without force | **have** | `confirm_required`; binary remains |
| **TP-CLI-12** | `out_json` string-key escape | **have** | harness; `@key` raw n/a (product string-escapes all pairs) |

---

## TP-LC — Install lifecycle (`PM-INSTALL-LIFECYCLE-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-LC-01** | Empty-argv ensure (first + already local/global) | **have** | lifecycle suite |
| **TP-LC-02** | Payload `install` | **n/a** | Type O CLI — no domain payload project |
| **TP-LC-03** | Payload uninstall | **n/a** | No payload surface |
| **TP-LC-04** | About installed + version-check JSON | **have** | local/remote/is_latest |
| **TP-LC-05** | self-update already-latest | **have** | success message |
| **TP-LC-05b** | self-update when remote newer | **have** | upgrades VERSION |
| **TP-LC-06** | Force reinstall companion transparency | **have** | link/expected/actual/PASS |
| **TP-LC-07** | self-uninstall refuse / force + PATH cleanup | **have** | refuse + force remove |
| **TP-LC-08** | Downgrade refuse / force | **have** | `downgrade_blocked` |
| **TP-LC-09** | Bad channel empty argv | **have** | same class as **TP-CLI-09** |
| **TP-LC-10** | Idempotent re-install | **have** | “already installed” |
| **TP-LC-11** | version-check network failure | **have** | `network_error` |
| **TP-LC-12** | Explicit `install --json` | **have** | first install path |

---

## TP-CSUM — Checksum (`PM-CHECKSUM-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-CSUM-01** | Companion matches ship unit | **have** | CLI |
| **TP-CSUM-02** | Human force reinstall transparency | **have** | lifecycle |
| **TP-CSUM-03** | Shape B pin mismatch | **have** | lifecycle |
| **TP-CSUM-04** | Shape B pin match | **have** | lifecycle |
| **TP-CSUM-05** | Help/about hide CHECKSUM | **have** | CLI |

---

## TP-U — set -u (`PM-SET-U-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-U-01** | HOME unset | **have** | TP-CLI-08 |
| **TP-U-02** | Defaults on zero-arg fail path | **have** | TP-CLI-09 |
| **TP-U-03** | HOME with bashrc stub | **have** | **TP-CURL-04** direct version |
| **TP-U-04** | bashrc via pipe | **n/a** / partial | product does not source bashrc on pipe |
| **TP-U-05** | Safe external source helper | **n/a** | no bare product sdkman source path |

---

## TP-CURL — curl\|sh (`PM-ONLINE-CURL-INSTALL-TEST-PLAN`)

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-CURL-01** | Channel probe | **have** | local HTTP ship + companion |
| **TP-CURL-02** | First `curl \| sh` | **have** | binary at USER_BIN; not silent |
| **TP-CURL-03** | Second pipe | **have** | already-installed messaging |
| **TP-CURL-04** | Hostile HOME / bashrc | **have** | version under stub bashrc (**TP-U-03**) |
| **TP-CURL-05** | Bad URL curl | **have** | not silent |
| **TP-CURL-06** | curl\|sh when bash required | **n/a** | product supports `/bin/sh` |
| **TP-CURL-07** | `sh -s -- version` | **have** | pipe version |
| **TP-CURL-08** | Unreachable SCRIPT_URL | **have** | non-zero; no binary |
| **TP-CURL-09** | Public online channel | **optional** | `RUN_ONLINE_CURL_TESTS=1` |

---

## TP-POMO — Domain-subject family (`RQ-DOMAIN-POMO`)

Domain product cases use **`TP-POMO-*`** (subject = `pomo`), **not** portable **`TP-DOM-*`**, **not** bare numeric `TP-01`.  
Proof mold **`PM-DOMAIN-TEST-PLAN`** is a design aid only; Type O-P payload tokens **`TP-PAYLOAD-*`** are **n/a**.  
Law: **`RQ-DOMAIN-POMO`** (`requirement-domain-pomo.md`). Policy: `policy-harness-id-notation` §5.

| TP-ID | Intent | Status | Evidence |
|-------|--------|--------|----------|
| **TP-POMO-01** | Help lists domain verbs/flags | **have** | start/status/watch/skip/stop/kill/list/stats/theme/--persist/--break |
| **TP-POMO-02** | start / status / list / stop human (+ minutes) | **have** | `test_pomo_domain.sh` |
| **TP-POMO-03** | already-running start fails | **have** | domain suite |
| **TP-POMO-04** | JSON start/status/list/stop + phase/minutes | **have** | domain suite |
| **TP-POMO-05** | `no_pomodoro` error code | **have** | domain suite |
| **TP-POMO-06** | kill / skip phase transitions | **have** | domain suite |
| **TP-POMO-07** | `invalid_name` / `invalid_duration` | **have** | domain suite |
| **TP-POMO-09** | stats + theme list/set/next/prev | **have** | domain suite |
| **TP-POMO-10** | watch rejects `--json` | **have** | domain suite |
| **TP-POMO-11** | stop `--force` not counted | **have** | domain suite |
| **TP-PAYLOAD-*** | Type O-P payload scaffold (mold) | **n/a** | not a Type O-P payload product |

---

## TP-STORAGE — Domain storage family (`RQ-DOMAIN-POMO` § storage)

Product-local family for **resolve / persist / state integrity** (not portable stack).  
Extracted from domain storage pillars formerly labeled **TP-POMO-08 / 12 / 13**.  
Ops verbs stay **TP-POMO-***; storage path modes and file integrity are **TP-STORAGE-***.

| TP-ID | Intent | Status | Evidence | Legacy |
|-------|--------|--------|----------|--------|
| **TP-STORAGE-01** | Volatile storage path resolve | **have** | `/dev/shm\|tmp/${APP}_${USER}_${name}` | was **TP-POMO-12** |
| **TP-STORAGE-02** | `--persist` start/list/status/stop | **have** | domain suite under isolated HOME | was **TP-POMO-08** |
| **TP-STORAGE-03** | Corrupted state → `corrupted_data` | **have** | empty state file → non-zero + code | was **TP-POMO-13** |

---

## Static proof (finding lock-in)

| TP-ID | Intent | Status | Notes |
|-------|--------|--------|-------|
| **TP-CITE-01** | Ship unit ALIGNMENT cites live REQs | **have** | header comments |
| **TP-ID-01** | `APP_NAME` hard-assign / Config SSOT | **have** | ship unit pomo |
| **TP-DOC-01** | README pin not frozen stale hash | **have** | closed 2026-07-16 (was TP-21) |
| **TP-DOC-02** | README bootstrap claim disk-honest | **have** | closed 2026-07-16 (was TP-22) |
| **TP-HYG-01** | Ship unit header APP_NAME default | **have** | closed 2026-07-16 (was TP-23) |

---

## Legacy map (retired → family)

| Legacy | Now |
|--------|-----|
| TP-01 | **TP-CLI-01** |
| TP-02 | **TP-CLI-01** / **TP-CSUM-01** |
| TP-03 | **TP-CLI-02** / **TP-CLI-04** |
| TP-04 | **TP-CLI-03** / **TP-POMO-01** |
| TP-05 | **TP-CSUM-05** |
| TP-06 | **TP-CLI-06** |
| TP-07 | **TP-CLI-09** / **TP-LC-01** / **TP-LC-09** |
| TP-08 | **TP-LC-10** |
| TP-09 | **TP-LC-04** / **TP-LC-05** |
| TP-10 | **TP-LC-06** / **TP-CSUM-02** |
| TP-11 | **TP-CSUM-03** / **TP-CSUM-04** |
| TP-12 | **TP-CLI-11** / **TP-LC-07** |
| TP-13 | **TP-LC-08** |
| TP-14 | **TP-POMO-02**…**06** |
| TP-15 | **TP-POMO-09** |
| TP-16 | **TP-POMO-07** |
| TP-17 | **TP-POMO-03** / **TP-POMO-05** |
| TP-18 | **TP-POMO-10** |
| TP-19 | **TP-STORAGE-02** (was TP-POMO-08) |
| TP-20 | **TP-POMO-11** |
| TP-POMO-08 | **TP-STORAGE-02** |
| TP-POMO-12 | **TP-STORAGE-01** |
| TP-POMO-13 | **TP-STORAGE-03** |
| TP-21 | **TP-DOC-01** (closed) |
| TP-22 | **TP-DOC-02** (closed) |
| TP-23 | **TP-HYG-01** (closed) |

---

## Rules

1. Closing a **bug** finding updates the matching TP to **have** (or supersedes with a new test).  
2. Do not mark TP **have** without a suite assertion (or documented static fix).  
3. Domain product: keep domain suite green; primary domain family is **`TP-POMO-*`**.  
4. Primary citation uses **TP-IDs** / **`RQ-*`**; suite path / basename secondary (`policy-harness-id-notation`).  
5. Versioned requirements list TP + `tests/*` + `reviews/*` only — never `docs/templates/**`.  
