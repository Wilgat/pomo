# Tests (pomo)

POSIX `/bin/sh` CI suite for the Type 0 + pomodoro domain ship unit `./pomo`.

Bootstrap architecture matches the countdown Type 0 harness; this suite is specialized for `APP_NAME=pomo` and covers **pomodoro domain** (work/break, themes, watch, stats, skip).

**Product map:** `reviews/test-plan.md` (mold columns + status)  
**Proof molds:** `PM-SHELL-CLI-TEST-PLAN`, `PM-INSTALL-LIFECYCLE-TEST-PLAN`, `PM-CHECKSUM-TEST-PLAN`, `PM-SET-U-TEST-PLAN`, `PM-ONLINE-CURL-INSTALL-TEST-PLAN`, `PM-DOMAIN-TEST-PLAN` §4.2.3, umbrella `PM-SHELL-CLI-SUITE-TEST-PLAN`  
**ID notation:** stack **TP-CLI / TP-LC / TP-CSUM / TP-U / TP-CURL**; domain ops **TP-POMO-***; storage **TP-STORAGE-*** → **RQ-DOMAIN-POMO**

## Run locally

```sh
./tests/run.sh
```

Requires: `sh`, `curl`, `python3` (local HTTP channel), `sha256sum`, `grep`, `date`.

Optional:

```sh
APP_NAME=pomo ./tests/run.sh
RUN_ONLINE_CURL_TESTS=1 ./tests/run.sh   # optional public-channel smoke (TP-CURL-09)
```

## What is covered

| Suite | File | TP families | Focus |
|-------|------|-------------|--------|
| CLI surface | `test_cli.sh` | **TP-CLI**, **TP-CSUM-01/05**, **TP-U-01/02** | syntax, companion, version/help/about, domain help rows, quiet, uninstall refuse, zero-arg fail |
| Install lifecycle | `test_install_lifecycle.sh` | **TP-LC**, **TP-CSUM-02..04** | local channel install, Type O ensure, self-update, pin, downgrade, PATH cleanup |
| Online curl\|sh | `test_online_curl_install.sh` | **TP-CURL**, **TP-U-03** | local `curl\|sh` first/second pipe, hostile HOME, bad URL, pipe version |
| Pomo domain | `test_pomo_domain.sh` | **TP-POMO-01..11**, **TP-STORAGE-01..03** | ops/verbs/theme/stats; storage path, `--persist`, corrupted state |

## Mapping (product law)

Type 0 cases map to **`RQ-SHELL-*`**. Domain cases map to **`RQ-DOMAIN-POMO`**. Proof molds: `PM-SHELL-CLI-TEST-PLAN`, `PM-INSTALL-LIFECYCLE-TEST-PLAN`, `PM-CHECKSUM-TEST-PLAN`, `PM-SET-U-TEST-PLAN`, `PM-ONLINE-CURL-INSTALL-TEST-PLAN`, `PM-DOMAIN-TEST-PLAN` (design aid → **TP-POMO**).

## Network / safety

- No secrets and no root.
- Install lifecycle + curl suite serve the checkout over `127.0.0.1` (no public raw GitHub required for Core).
- Domain tests use isolated `HOME` for persistent storage and clean volatile pomo private dirs after the suite.
