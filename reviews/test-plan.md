# Test plan (pomo) — TP-* lock-in

Maps product-law risks and review findings to automated cases under `tests/`.

**Runner:** `./tests/run.sh`  
**Last suite evidence:** 2026-07-16 — PASS=181 FAIL=0 SKIP=0  

---

## Baseline coverage (have)

| TP ID | Area | Maps to | Suite / case | Status |
|-------|------|---------|--------------|--------|
| **TP-01** | Syntax | modular / ship unit | `test_cli.sh` `sh -n` | **have** |
| **TP-02** | Companion digest file present | automatic-checksum | `test_cli.sh` companion | **have** |
| **TP-03** | version / help / about human+JSON | CLI interface | `test_cli.sh` | **have** |
| **TP-04** | Domain verbs in help | domain help pillar + CLI | `test_cli.sh` domain verbs | **have** |
| **TP-05** | CHECKSUM not on help/about | automatic-checksum | `test_cli.sh` | **have** |
| **TP-06** | Unknown command fail-closed | CLI interface | `test_cli.sh` | **have** |
| **TP-07** | Type O zero-arg install-ensure | zero-arguments | `test_install_lifecycle.sh` | **have** |
| **TP-08** | Install idempotent / already installed | idempotency | `test_install_lifecycle.sh` | **have** |
| **TP-09** | version-check / self-update already-latest | self-management | `test_install_lifecycle.sh` | **have** |
| **TP-10** | Integrity transparency human | automatic-checksum | `test_install_lifecycle.sh` | **have** |
| **TP-11** | CHECKSUM pin match/mismatch | automatic-checksum | `test_install_lifecycle.sh` | **have** |
| **TP-12** | Uninstall refuse / `--force` | interactive + self-mgmt | `test_install_lifecycle.sh` | **have** |
| **TP-13** | Downgrade refuse / `--force` | self-management | `test_install_lifecycle.sh` | **have** |
| **TP-14** | Domain start/status/list/stop/kill/skip | domain-pomo | `test_pomo_domain.sh` | **have** |
| **TP-15** | Domain stats + theme | domain-pomo | `test_pomo_domain.sh` | **have** |
| **TP-16** | Path-safe invalid_name | domain-pomo | `test_pomo_domain.sh` | **have** |
| **TP-17** | already_running / no_pomodoro | domain-pomo | `test_pomo_domain.sh` | **have** |
| **TP-18** | watch rejects --json | domain-pomo | `test_pomo_domain.sh` | **have** |
| **TP-19** | --persist storage mode | domain-pomo | `test_pomo_domain.sh` | **have** |
| **TP-20** | stop --force not counted | domain-pomo | `test_pomo_domain.sh` | **have** |

---

## Findings → TP rows (2026-07-16 full product review)

| TP ID | Finding | Automated? | Status | Notes |
|-------|---------|------------|--------|-------|
| **TP-21** | README CHECKSUM pin stale vs live `pomo.sha256` (L-12) | Doc check | **closed** | Fixed 2026-07-16: pin example fetches live companion first field (no frozen doc hash) |
| **TP-22** | README claims in-tree `./countdown` when absent (L-13) | Doc check | **closed** | Fixed 2026-07-16: optional if present; lineage-only wording |
| **TP-23** | Ship unit header “APP NAME: countdown” residue | Comment hygiene | **closed** | Fixed 2026-07-16: header says APP_NAME default pomo |

---

## Open item owners

| Item | Owner | Target |
|------|-------|--------|
| — | — | No open TP remediation owners |

Closing a **bug** updates this table and preferably adds a suite case under `tests/`.
