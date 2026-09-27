**file**: docs/requirements/requirement-shell-cli-storage.md  
**Requirement-ID**: `RQ-SHELL-CLI-STORAGE`  
**Status**: Active (Version 1.1.0 – cache folder per login and process; persistence under `~/.local`)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **product Single Source of Truth** for **where scratch and durable folders live** for pomo.

| Class | Role | Survives the next command | Survives reboot |
|-------|------|---------------------------|-----------------|
| **Cache folder** | Scratch and `mktemp` | No (`$$` is this process) | No |
| **Domain volatile records** | Named timer files the next `pomo status` must open | Yes | No (RAM / temp) |
| **Persistence storage** | `--persist`, theme, daily stats | Yes | Yes |

A skipped **cache** tier is silent. No warning and no error because a higher cache folder was not used. An error is only when every cache tier for this host failed.

The cache directory name carries `$$`. Scratch files inside that directory stay `mktemp` names. They do not use a `$$` file name.

Volatile cache tiers (`/dev/shm` and `/tmp`) include the login so two logins do not share one leaf. Home cache tiers omit the login because `$HOME` is already that login.

### 1.1 Human-facing

**In one sentence:** scratch goes in a per-process cache folder; a running timer stays in a stable folder the next command can open; `--persist` keeps that timer under this login’s home.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | `about` shows the cache folder that was created, plus persistence | `pomo about` |
| The other role | Domain names the timer file; Git Bash detect stays on its own requirement | `pomo start` |
| Not this file | Install destination `~/.local/bin`; SHA-256 companion | self-management |

| Includes | Excludes |
|----------|----------|
| Cache folder chain; silent skip; persistence `${HOME}/.local/${APP_NAME}` | Install binary placement |
| Domain volatile root so a later command finds the timer | Companion checksum |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./pomo` | ship unit | `util_resolve_storage`, `util_resolve_persistent_storage`, `pomo_resolve_base_dir` |
| `pomo about` | command | cache folder lines and persistence |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Inspect storage | about shows Cache folder used, preferred, 1st fallback, 2nd fallback when this host has one, and Persistence storage. A skipped tier prints nothing | `pomo about` |
| Start a timer | The timer file is **not** inside the `$$` cache folder | `pomo start` |
| Keep it across reboot | The file is under persistence storage | `pomo start --persist` |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Cache folder (MUST)

`${login}` is `id -un` as one path segment. `$$` is this process id. **MUST NOT** hardcode either.

| Host | Preferred | 1st fallback | 2nd fallback |
|------|-----------|--------------|--------------|
| Linux (and Termux, and any host that is not Git Bash or Mac) | `/dev/shm/cache/cache-${APP_NAME}-${login}-$$` | `/tmp/cache/cache-${APP_NAME}-${login}-$$` | `${HOME}/.cache/cache-${APP_NAME}-$$` |
| Git Bash (`MSYSTEM`, or `uname -s` `MINGW*` / `MSYS*`) | `/tmp/cache/cache-${APP_NAME}-${login}-$$` | `${HOME}/AppData/Local/Temp/cache-${APP_NAME}-$$` | none |
| Mac (`uname -s` `Darwin`) | `/tmp/cache/cache-${APP_NAME}-${login}-$$` | `${HOME}/Library/Caches/cache-${APP_NAME}-$$` | `${HOME}/cache/cache-${APP_NAME}-$$` |

| Helper | Path |
|--------|------|
| `util_preferred_cache_dir` | preferred |
| `util_fallback_cache_dir` | 1st fallback |
| `util_fallback2_cache_dir` | 2nd fallback (empty on Git Bash) |
| `util_resolve_storage` | the tier that was created |

**Parent:** for `/dev/shm/cache` and `/tmp/cache` the resolver **MUST** create that parent (prefer mode **1777** when creating). The **leaf** **MUST** be mode **0700**.

**Create before return.** First directory that can be created and is writable wins. If create fails, try the next tier **with no message**. If none work, fail closed. **MUST NOT** return a path without creating it.

**MUST NOT** use these as the cache folder:

| Forbidden cache path | Why |
|----------------------|-----|
| `/dev/shm/${APP_NAME}` or `/dev/shm/${APP_NAME}-${login}` | Looks like a ram-drive project folder |
| `/dev/shm` or `/tmp` as a dump | No app-named cache leaf |
| `${HOME}/.local/bin` | Install directory |
| Persistence storage | Durable data is not scratch |
| One shared `cache-${APP_NAME}` leaf | Two logins would share it |

On Termux the chosen cache folder is scratch only (it may be `noexec`). Termux uses the **Linux** chain. **MUST NOT** exec a downloaded binary from that folder.

Test seam (not a user setting): `POMO_CACHE_HOST=linux|gitbash|mac` and `POMO_CACHE_SKIP=preferred` (skip tier 1 with no message).

### 2.2 Scratch files (MUST)

1. `app_main` **MUST** set `EFFECTIVE_STORAGE_DIR=$(util_resolve_storage)` and `TMPDIR` to that directory before other work.  
2. New scratch files **MUST** use `util_mktemp` (or `mktemp` under that directory).  
3. The cache **directory** may include `$$`. Scratch **file** names **MUST NOT** (`/tmp/${APP_NAME}.$$` and `${EFFECTIVE_STORAGE_DIR}/${APP_NAME}.$$` are forbidden).

### 2.3 Persistence storage (MUST)

1. Persistence **MUST** be `${HOME}/.local/${APP_NAME}`.  
2. `util_persistent_storage_dir` prints that path. `util_resolve_persistent_storage` creates it, confirms it is writable, then prints it.  
3. **MUST NOT** use `${HOME}/.local/bin` (that is `USER_BIN`).  
4. **MUST NOT** use `${HOME}/.cache/${APP_NAME}` as persistence (that tree is not this product’s durable store; the cache 2nd fallback is a different leaf under `${HOME}/.cache`).  
5. `--persist` timer files, `theme`, and `stats_YYYY-MM-DD` **MUST** live under this directory.  
6. If `$HOME` is not a writable directory, fall back to `$PREFIX/tmp/${APP_NAME}_${login}_persistent` then `/tmp/${APP_NAME}_${login}_persistent`, then fail closed.

### 2.4 Domain volatile records (MUST)

A pomodoro file must be found by a **later** process. It **MUST NOT** live inside the `$$` cache folder.

`util_resolve_volatile_root` remains the cross-process root. `pomo_resolve_base_dir volatile` / `pomo_get_file` **MUST** use that root. Leaf: `${root}/${APP_NAME}_${login}_${name}`.

Walk (mkdir of one `cache` leaf **MUST NOT** abort):

```text
1. VOLATILE_DIR when it is already a usable directory
2. /dev/shm when that mount exists
3. Termux: $PREFIX/tmp (create if needed)
4. Git Bash temp parents from requirement-shell-git-bash.md
5. $TEMP/cache when $TEMP is defined and the parent exists
6. $TMPDIR when set and a directory
7. /tmp/cache when /tmp exists (then /tmp)
8. Last resort: persistence storage
```

**MUST NOT** write `/${APP_NAME}_*` at filesystem root. Empty resolve fails closed via `out_die`.

Git Bash **detect** and the default drive stay on `requirement-shell-git-bash.md`. This file consumes those parents for **domain volatile** records only. The **cache folder** on Git Bash is the table in §2.1 (preferred `/tmp/cache/…`, no 2nd fallback).

### 2.5 About (MUST)

Human `about` **MUST** print, in this order:

```text
Cache folder used: <tier that was created>
Cache folder (preferred): <this host’s preferred path>
Cache folder (1st fallback): <1st fallback>
Cache folder (2nd fallback): <2nd fallback>    # omit the line when this host has none
Persistence storage: ${HOME}/.local/${APP_NAME}
```

**MUST NOT** label those lines Storage (effective) or Storage (fallback). **MUST NOT** warn when the used directory is a fallback.

JSON `about` **MUST** include `cache_used`, `cache_preferred`, `cache_fallback`, `cache_fallback_2` (empty string when the host has none), `persistence_storage`, and `effective_storage` (same value as `cache_used`). `storage_dir` is the 1st fallback. **MUST NOT** include `CHECKSUM`.

Domain about **MUST NOT** add pomodoro state, theme, or stats fields. Cache and persistence lines are Type 0.

### 2.6 Implementation Notes (this project)

| Item | Value for pomo |
|------|----------------|
| **Cache resolver** | `util_resolve_storage` |
| **Persistence** | `${HOME}/.local/pomo` via `util_resolve_persistent_storage` |
| **Domain volatile** | `util_resolve_volatile_root` + `pomo_get_file` |
| **About** | `app_about` |
| **Tests** | **TP-CLI-05**, **TP-STORAGE-01..04**, **TP-TX-08**, **TP-TX-09**, **TP-TX-10**, **TP-TX-12** |

### 2.7 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Never assume `/dev/shm` is writable.  
- **CIAO Principle 11 – Safe temps** (https://github.com/cloudgen/ciao): Scratch is `mktemp` inside a per-process leaf.  
- **CIAO Principle 19 – Defensive storage** (https://github.com/cloudgen/ciao): Two logins do not share a volatile cache leaf.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): A missing tier is silent; the chain continues.  
- **CIAO Principle 5 – SSOT of output** (https://github.com/cloudgen/ciao): Storage fatals go through `out_*`.

---

## Under command line for normal user only

When `pomo` runs on Termux, Git Bash, or Windows cmd:

| MUST | MUST NOT |
|------|----------|
| Keep cache and persistence under this login | Write scratch under `/var` or `/etc` |
| Termux: Linux cache chain; scratch only | Exec a binary from the cache folder |
| Git Bash cache: `/tmp/cache` leaf, then AppData home leaf, no 2nd fallback | Warn because `/dev/shm` was skipped |

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Probe exists and writable. Create before return.  
- **Intentional:** Cache, domain volatile, and persistence are three classes.  
- **Anti-fragile:** Silent cache skip. Fail loud only when every tier failed.  
- **Over-protect:** No shared world-writable leaf. No `$$` scratch file name.

---

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

1. Put a named timer file inside the `$$` cache folder.  
2. Restore `/dev/shm/${APP_NAME}` or `/dev/shm/${APP_NAME}-${login}` as the cache folder.  
3. Warn or error only because a higher cache tier was skipped.  
4. Label about cache lines Storage (effective) or Storage (fallback).  
5. Use `${HOME}/.local/bin` or `${HOME}/.cache/${APP_NAME}` as persistence.  
6. Drop `${login}` or `$$` from a volatile cache leaf.  
7. Use a predictable `$$` scratch **file** name.  
8. Die because `mkdir` of one cache leaf failed while a later tier remains.  
9. Write `/${APP_NAME}_*` at filesystem root.  
10. Exec a downloaded binary from the cache folder on Termux.

**Violating this rule is a critical storage regression.**

---

## 5. Related artifacts

| Artifact | Role |
|----------|------|
| **`RQ-SHELL-GIT-BASH`** (`requirement-shell-git-bash.md`) | Detect; default drive; domain-volatile temp **parent** |
| **`RQ-DOMAIN-POMO`** (`requirement-domain-pomo.md`) | Timer leaf names; `--persist` |
| **`RQ-SHELL-CLI-INTERFACE`** (`requirement-shell-cli-interface.md`) | `about` routing |
| **`RQ-SHELL-OUTPUT-REQUIREMENTS`** (`requirement-shell-output-requirements.md`) | `out_die` / `out_info` |
| `docs/requirements/index.md` | Registry SSOT |
| `./pomo` | Implementation under test |

---

**Last Updated**: 2026-09-27  
**Owner**: pomo project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; peer live requirements in §5; CIAO Principles 1, 3, 5, 11, 19 (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).

## Design-time verification

**Requirement-ID:** `RQ-SHELL-CLI-STORAGE`  
**Specialized from:** `LM-SHELL-CLI-STORAGE`  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-05** about cache + persistence fields | `tests/test_cli.sh` | have |
| **TP-STORAGE-01** volatile timer path | `tests/test_pomo_domain.sh` | have |
| **TP-STORAGE-02** `--persist` under `~/.local` | `tests/test_pomo_domain.sh` | have |
| **TP-STORAGE-03** corrupted state | `tests/test_pomo_domain.sh` | have |
| **TP-STORAGE-04** cache leaf, silent skip, Git Bash, Mac | `tests/test_cli.sh` | have |
| **TP-TX-08** Termux `$PREFIX/tmp` domain volatile | `tests/test_cli.sh` | have |
| **TP-TX-09** Git Bash AppData domain volatile | `tests/test_cli.sh` | have |
| **TP-TX-10** mkdir cache fail-soft (domain volatile) | `tests/test_cli.sh` | have |
| **TP-TX-12** `/c/` drive domain volatile | `tests/test_cli.sh` | have |
