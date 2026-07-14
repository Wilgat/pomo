# Tests (pomo)

POSIX `/bin/sh` CI suite for the Type 0 + pomodoro domain ship unit `./pomo`.

Bootstrap architecture matches the countdown Type 0 harness; this suite is specialized for `APP_NAME=pomo` and covers **pomodoro domain** (work/break, themes, watch, stats, skip).

## Run locally

```sh
./tests/run.sh
```

Requires: `sh`, `curl`, `python3` (local HTTP channel), `sha256sum`, `grep`, `date`.

Optional override:

```sh
APP_NAME=pomo ./tests/run.sh
```

## What is covered

| Suite | File | Focus |
|-------|------|--------|
| CLI surface | `test_cli.sh` | `sh -n`, companion digest, `version` / `help` / `about` (human + JSON), domain verbs in help (`start`/`status`/`watch`/`skip`/`stop`/`kill`/`list`/`stats`/`theme`), unknown command, quiet, `CHECKSUM` not on help/about, `env -u HOME`, zero-arg install failure exit, uninstall fail-closed JSON |
| Install lifecycle | `test_install_lifecycle.sh` | Isolated `HOME`/`USER_BIN`, local channel install, idempotent re-install, **Type O** zero-arg already-installed (local + global, not help), version-check JSON keys, self-update already-latest, human integrity transparency, uninstall refuse / `--force`, `CHECKSUM` pin match/mismatch, downgrade refuse / `--force` |
| Pomo domain | `test_pomo_domain.sh` | `start` / `status` / `list` / `stop` / `kill` / `skip`, `stats`, `theme`, `--json`, `--persist`, `--break`, invalid name path-safe, already-running, `no_pomodoro`, watch rejects `--json` |

## Mapping (product law)

Type 0 cases map to live `docs/requirements/requirement-shell-*.md` (CLI interface, zero-arguments, output, interactive, idempotency, self-management, automatic-checksum, modular design). Domain cases map to **`requirement-shell-pomo-domain.md`** (work/break, themes, stats, path-safe names, storage).

## Network / safety

- No secrets and no root.
- Install lifecycle serves the checkout over `127.0.0.1` (does not require public raw GitHub).
- Domain tests use isolated `HOME` for persistent storage and clean volatile pomo files for the current user after the suite.
