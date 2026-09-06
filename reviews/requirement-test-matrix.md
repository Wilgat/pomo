# Requirement → test matrix (pomo)

**Product:** pomo  
**Updated:** 2026-09-06  
**Map:** `reviews/test-plan.md`  
**Suite:** `./tests/run.sh`

Primary citation is **`RQ-*`** + **`TP-*`**. Paths are secondary.

| Requirement-ID | Key | TP families | Suite files | Status |
|----------------|-----|-------------|-------------|--------|
| `RQ-CLASS-SOFTWARE-DEV` | requirement-class-software-dev | **TP-CLI-01** (posix-sh syntax); residual n/a | `tests/test_cli.sh` | have / n/a residual |
| `RQ-SHELL-SCRIPT-CODING` | requirement-shell-script-coding | **TP-CLI-01**, **TP-CITE-01** | `tests/test_cli.sh` + static header | have |
| `RQ-SHELL-CLI-INTERFACE` | requirement-shell-cli-interface | **TP-CLI-01..12**, **TP-POMO-01** | `tests/test_cli.sh`, `tests/test_pomo_domain.sh` | have (05/10 n/a) |
| `RQ-SHELL-CLI-ZERO-ARGUMENTS` | requirement-shell-cli-zero-arguments | **TP-CLI-09**, **TP-LC-01/09/12**, **TP-U-02** | `tests/test_cli.sh`, `tests/test_install_lifecycle.sh` | have |
| `RQ-SHELL-OUTPUT-REQUIREMENTS` | requirement-shell-output-requirements | **TP-CLI-02/04/06/07/12**, **TP-POMO-04** | `tests/test_cli.sh`, `tests/test_pomo_domain.sh` | have |
| `RQ-SHELL-SELF-MANAGEMENT` | requirement-shell-self-management | **TP-LC-04/05/05b/07/08/11**, **TP-CLI-11** | `tests/test_install_lifecycle.sh`, `tests/test_cli.sh` | have |
| `RQ-SHELL-AUTOMATIC-CHECKSUM` | requirement-shell-automatic-checksum | **TP-CSUM-01..05**, **TP-LC-06** | `tests/test_cli.sh`, `tests/test_install_lifecycle.sh` | have |
| `RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE` | requirement-shell-interactive-vs-noninteractive | **TP-CLI-07/09/11**, **TP-LC-07**, **TP-CURL-01..08**, **TP-POMO-10** | CLI + lifecycle + curl + domain | have (**TP-CURL-09** optional) |
| `RQ-SHELL-IDEMPOTENCY` | requirement-shell-idempotency | **TP-LC-01/05/10**, **TP-POMO-03** | lifecycle + domain | have |
| `RQ-SHELL-MODULAR-FUNCTION-DESIGN` | requirement-shell-modular-function-design | **TP-CLI-01**, **TP-CITE-01**, **TP-POMO-*** | CLI + domain | have |
| `RQ-DOMAIN-POMO` | requirement-domain-pomo | **TP-POMO-01..11**, **TP-STORAGE-01..03** | `tests/test_pomo_domain.sh` | have (**TP-POMO-08** retired → **TP-STORAGE-02**) |

**Checklists (blank → filled):**

| Blank | When | This pass |
|-------|------|-----------|
| `checklist-shell-cli-test` | Suite completeness | Covered by `reviews/test-plan.md` (have/n/a/optional) |
| `checklist-online-install-script` | `curl \| sh` / companion | **TP-CURL** + **TP-CSUM** have |
| `plan-and-requirements` / `code-review` | Product-law + README review | `reviews/reports/2026-09-06-readme-req-coverage.md` |

**Honest gaps (not suite failures):**

| Item | Notes |
|------|-------|
| Class / dest approver | Residual **considered — none**; no dest `fence-test` (correct) |
| `start 0` / 1-minute minimum | **TP-POMO-07** already asserts `invalid_duration` on work `0` |
| Public **TP-CURL-09** | optional (`RUN_ONLINE_CURL_TESTS=1`) |
