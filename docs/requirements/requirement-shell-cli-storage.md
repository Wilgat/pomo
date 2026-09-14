**file**: docs/requirements/requirement-shell-cli-storage.md  
**Requirement-ID**: `RQ-SHELL-CLI-STORAGE`  
**Status**: Active (Version 1.0.0 – volatile root chain; Git Bash `/c/` temp; mkdir fail-soft)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **product Single Source of Truth** for **where volatile scratch and fallback cache roots live** for pomo: one resolver family, per-user isolation, create-before-return, and fail-closed only at the **end** of the chain.

Git Bash **detect**, **default drive `/c/`**, and the **AppData Local Temp parent** are owned by `requirement-shell-git-bash.md`. This file **consumes** those parents as storage tiers. Domain timer **leaf** names stay on `requirement-domain-pomo.md`.

### 1.1 Human-facing

**In one sentence:** pomo picks a writable folder for short-lived files (RAM if it exists, then Git Bash Windows Temp `cache`, then `$TEMP/cache`, then `/tmp/cache`) and does not stop if creating one `cache` folder fails.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Start a timer; files appear under the resolved root | `pomo start` |
| The other role | Git Bash names `/c/` and the Temp parent; domain names `pomo_<user>_<name>` | `RQ-SHELL-GIT-BASH`, `RQ-DOMAIN-POMO` |
| Not this file | Install destination `~/.local/bin`; SHA-256 companion | self-management / checksum |

| Includes | Excludes |
|----------|----------|
| Volatile root chain; mkdir fail-soft; per-user isolation under the root | `mktemp` leaf uniqueness for download staging |
| Persistent root under home cache when `--persist` | Git Bash detect algorithm (peer) |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./pomo` | ship unit | `util_resolve_volatile_root` / `util_resolve_storage` / `pomo_resolve_base_dir` |
| `pomo start` | command | writes a file under the resolved root |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Start without `--persist` | A file is created under `/dev/shm` when that exists, else Git Bash Temp `cache`, else `/tmp/cache`. | `pomo start` |
| Run on Git Bash | Same command; the root is your Windows user Temp `cache` under `/c/` when `/dev/shm` is missing. | `pomo start` |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Single resolver (MUST)

1. **MUST** expose one volatile-root helper (this product: `util_resolve_volatile_root`) and one scratch-isolation helper (`util_resolve_storage`) that **MUST** `mkdir` the isolated dir before printing the path.  
2. Domain timer bases **MUST** call that family (`pomo_resolve_base_dir` / `pomo_get_file`) — **MUST NOT** hardcode bare `/tmp/pomo` dumps.  
3. Path printed via stdout for `$(…)` capture is a **data return**, not a user banner. User-visible storage errors **MUST** go through `out_*` (`requirement-shell-output-requirements.md`).

### 2.2 Volatile root chain (MUST)

Walk in order. A parent **must exist** before `mkdir` of a `cache` leaf (except Termux `$PREFIX/tmp`, which may be created). **`mkdir` of `cache` MUST NOT abort** — continue.

```text
1. VOLATILE_DIR when it is already a usable directory
2. /dev/shm when that mount exists (default VOLATILE_DIR only; mkdir fail-soft)
3. Termux: $PREFIX/tmp (create if needed)
4. Git Bash (requirement-shell-git-bash):
     $HOME/AppData/Local/Temp/cache
     then ${GIT_BASH_DRIVE}/Users/${USERNAME}/AppData/Local/Temp/cache
     (GIT_BASH_DRIVE default /c)
5. $TEMP/cache when $TEMP is defined and the parent exists
6. $TMPDIR when set and a directory
7. /tmp/cache when /tmp exists (then /tmp)
8. Last resort: ${XDG_CACHE_HOME}/${APP_NAME} (MUST NOT be the Git Bash volatile
   root when an AppData Local Temp parent exists)
else fail closed via out_die — never a silent empty path, never /${APP_NAME}_* at /
```

Isolation under the chosen root:

| Use | Pattern |
|-----|---------|
| Scratch (`util_resolve_storage`) | `${root}/${APP_NAME}-${USERNAME}` |
| Domain volatile record | `${root}/${APP_NAME}_${USERNAME}_${name}` |

### 2.3 Persistent roots (MUST)

Prefer `${XDG_CACHE_HOME:-$HOME/.cache}/${APP_NAME}` when `$HOME` is a writable directory. Fallback: `$PREFIX/tmp/…_persistent` then `/tmp/…_persistent`. `mkdir` fail-soft; fail closed if none work.

### 2.4 Implementation Notes (this project)

| Item | Value for pomo |
|------|----------------|
| **Resolver names** | `util_resolve_volatile_root`, `util_resolve_storage`, `util_ensure_writable_dir`, `pomo_resolve_base_dir` |
| **Git Bash drive** | `GIT_BASH_DRIVE` default `/c` — owned by `RQ-SHELL-GIT-BASH`; this file uses it in tier 4 |
| **Call sites** | `pomo_apply_target_paths` (retarget `VOLATILE_DIR`); `pomo_resolve_base_dir`; `util_resolve_storage` at `app_main` → `EFFECTIVE_STORAGE_DIR` / `TMPDIR` |
| **Output on failure** | `out_die` with Next: `mkdir -p "${HOME}/AppData/Local/Temp/cache"` or `"${PREFIX}/tmp"` or `pomo start --persist` |
| **Tests** | **TP-STORAGE-01..03**, **TP-TX-08**, **TP-TX-09**, **TP-TX-10**, **TP-TX-12** |

### 2.5 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Never assume `/dev/shm` or `/tmp` are writable.  
- **CIAO Principle 11 – Safe temps** (https://github.com/cloudgen/ciao): Documented fallback; unique isolation under the root.  
- **CIAO Principle 19 – Defensive storage** (https://github.com/cloudgen/ciao): Git Bash `/c/` Temp is a named tier, not `$HOME/.cache`.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): mkdir fail-soft.  
- **CIAO Principle 5 – SSOT of output** (https://github.com/cloudgen/ciao): Storage fatals through `out_*`.

---

## Under command line for normal user only

When `pomo` runs on Termux, Git Bash, or Windows cmd:

| MUST | MUST NOT |
|------|----------|
| Use this-login writable roots only | Write under `/var` or `/etc` because the target was detected |
| Git Bash: consume `/c/` Temp parents from `RQ-SHELL-GIT-BASH` | Use `$HOME/.cache` as volatile when those parents exist |

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Probe exists + writable; mkdir is not proof alone.  
- **Intentional:** One chain; Git Bash drive is a parameter from the Git Bash REQ.  
- **Anti-fragile:** Fail-soft mkdir; fail loud at the end.  
- **Over-protect:** Ban mid-chain `out_die` and `$HOME/.cache` on Git Bash.

---

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

1. Remove per-user isolation from storage roots.  
2. Die because `mkdir` of one `cache` leaf failed.  
3. Skip Git Bash `/c/` Temp tiers when Git Bash is detected.  
4. Echo a root path without creating it.  
5. Write `/${APP_NAME}_*` at filesystem root when resolve returns empty.  
6. Use the storage resolver for `USER_BIN` / `GLOBAL_BIN` placement.  
7. Duplicate Git Bash **detect** here (that is `requirement-shell-git-bash.md`).

**Violating this rule is a critical storage regression.**

---

## 5. Related artifacts

| Artifact | Role |
|----------|------|
| **`RQ-SHELL-GIT-BASH`** (`requirement-shell-git-bash.md`) | `/c/` detect; default drive; Temp **parent** |
| **`RQ-DOMAIN-POMO`** (`requirement-domain-pomo.md`) | Timer leaf names; persist flag |
| **`RQ-SHELL-CLI-INTERFACE`** (`requirement-shell-cli-interface.md`) | `start` routing; about (no required storage fields) |
| **`RQ-SHELL-OUTPUT-REQUIREMENTS`** (`requirement-shell-output-requirements.md`) | `out_die` / `out_warn` |
| **`RQ-SHELL-MODULAR-FUNCTION-DESIGN`** (`requirement-shell-modular-function-design.md`) | `util_*` / `pomo_resolve_*` prefixes |
| `docs/requirements/index.md` | Registry SSOT |
| `./pomo` | Implementation under test |

---

**Last Updated**: 2026-09-10  
**Owner**: pomo project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; peer live requirements in §5; CIAO Principles 1, 3, 5, 11, 19, 20 (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).

## Design-time verification

**Requirement-ID:** `RQ-SHELL-CLI-STORAGE`  
**Specialized from:** `LM-SHELL-CLI-STORAGE`  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-STORAGE-01** volatile path | `tests/test_pomo_domain.sh` | have |
| **TP-STORAGE-02** `--persist` | `tests/test_pomo_domain.sh` | have |
| **TP-STORAGE-03** corrupted state | `tests/test_pomo_domain.sh` | have |
| **TP-TX-08** Termux `$PREFIX/tmp` | `tests/test_cli.sh` | have |
| **TP-TX-09** Git Bash AppData Temp/cache | `tests/test_cli.sh` | have |
| **TP-TX-10** mkdir cache fail-soft | `tests/test_cli.sh` | have |
| **TP-TX-12** `/c/` drive Temp fallback | `tests/test_cli.sh` | have |
| **TP-CLI-05** about storage fields | n/a — about has no required storage keys | n/a |
