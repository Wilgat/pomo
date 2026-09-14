**file**: docs/requirements/requirement-shell-git-bash.md  
**Requirement-ID**: `RQ-SHELL-GIT-BASH`  
**Status**: Active (Version 1.0.0 – `/c/` detect; default drive `/c/`; Git Bash temp parent)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **product Single Source of Truth** for **Git Bash** (Git for Windows MSYS Bash) as a **this-login** command line: how pomo **detects** that environment, that the **default Windows drive** is `/c/`, and which **temp parent** volatile storage must use.

It does **not** re-own the full volatile/persistent resolve chain (that is `requirement-shell-cli-storage.md`). It does **not** re-own command routing (`requirement-shell-cli-interface.md`) or pomodoro file format (`requirement-domain-pomo.md`).

### 1.1 Human-facing

**In one sentence:** On Git for Windows Bash, pomo treats the `C:` drive as `/c/` and writes short-lived timer files under your Windows user Temp `cache` folder — not under a Unix-style `~/.cache`.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Run `pomo` in Git Bash as yourself | `pomo start`, `pomo --json about` |
| The other role | Storage resolve walks `/c/` temp after RAM; domain names the timer file | `RQ-SHELL-CLI-STORAGE`, `RQ-DOMAIN-POMO` |
| Not this file | Timer minutes; `sudo curl` install on Linux | domain / POSIX host one-liner |

| Includes | Excludes |
|----------|----------|
| Detect Git Bash when folder `/c/` (or `/c`) exists | Treating Git Bash as GitHub or a git repo |
| Default drive `/c/`; Temp `cache` under AppData Local Temp | Persistent `--persist` XDG layout |
| This-login only; help must not recommend `sudo curl \| sh` | Termux `$PREFIX`; Windows `cmd.exe` detect body |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./pomo` | ship unit | detect + drive + temp parent |
| `pomo --json about` | command | `"target":"git-bash"` when Git Bash |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Check the target | About names Git Bash when `/c/` is present (the Windows `C:` drive as Git Bash mounts it). | `pomo --json about` |
| Start a timer | Volatile files go under `$HOME/AppData/Local/Temp/cache` or `/c/Users/<you>/AppData/Local/Temp/cache`, not `~/.cache`. | `pomo start` |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Detect Git Bash (MUST)

A POSIX CLI that claims Git Bash **MUST** treat the environment as Git Bash when **any** of the following is true (after excluding WSL):

1. **Primary filesystem probe:** directory **`/c/`** exists, or directory **`/c`** exists. That mount is the Git Bash / MSYS view of Windows drive `C:`.  
2. **Secondary env probe:** `MSYSTEM` matches `MINGW*` / `MSYS*` / `UCRT*` / `CLANG*`, or `uname -s` matches `MINGW*` / `MSYS*`.

**MUST NOT** classify WSL (`WSL_DISTRO_NAME` set) as Git Bash even if some `/c` path exists.  
**MUST NOT** classify Git Bash as Windows `cmd.exe`.  
**MUST NOT** require admin privilege or a dedicated system user because Git Bash was detected.

### 2.2 Default drive `/c/` (MUST)

When Git Bash is detected:

1. The **default drive** **MUST** be **`/c/`** (POSIX path `/c` with optional trailing slash). Config name for this product: `GIT_BASH_DRIVE`, default `/c`.  
2. Path composition for Windows-user locations **MUST** use that POSIX drive (`/c/Users/…`), **MUST NOT** use `C:\` backslash paths as the only form.  
3. If `/c/` (or `/c`) exists, `GIT_BASH_DRIVE` **MUST** resolve to `/c` unless the operator already overrode it to another existing drive mount (`/d`, `/e`, …).  
4. **MUST NOT** invent a drive letter. If the default `/c` directory is missing, skip drive-based path composition and continue the storage chain.

### 2.3 Git Bash temp folder (MUST — aligns with shell storage)

Git Bash **volatile** scratch **MUST** use the Windows user temp **`cache`** leaf, not `$HOME/.cache`.

**Parent candidates (first that exists):**

| Order | Parent (must already exist) | Cache leaf |
|-------|-----------------------------|------------|
| 1 | `$HOME/AppData/Local/Temp` | `$HOME/AppData/Local/Temp/cache` |
| 2 | `${GIT_BASH_DRIVE}/Users/${USERNAME}/AppData/Local/Temp` (default drive `/c`) | `…/cache` |
| 3 | `$TEMP` when defined and a directory | `$TEMP/cache` |
| 4 | `/tmp` when it exists | `/tmp/cache` (then `/tmp`) |

**`mkdir` of `cache` MUST NOT abort.** If create fails, continue to the next parent. Fail closed only when the **storage** chain has no writable root (`requirement-shell-cli-storage.md`).

RAM `/dev/shm` still wins when that mount exists and is usable (storage REQ). Git Bash hosts typically lack it.

**MUST NOT** use `$HOME/.cache` as the Git Bash **volatile** root when an AppData Local Temp parent exists.

### 2.4 This-login ceiling (MUST)

When Git Bash is detected:

| MUST | MUST NOT |
|------|----------|
| Keep this login only | Enable admin privilege or a dedicated system user |
| Help names Git Bash and this-login install | Recommend `sudo curl \| sh` or `/usr/local/bin` as the Git Bash path |
| Same ceiling as Termux / Windows cmd class | Invoke Termux `pkg` because Git Bash was detected |

### 2.5 Implementation Notes (this project)

| Item | Value for pomo |
|------|----------------|
| **Detect helpers** | `pomo_is_git_bash` (primary: `[ -d /c/ ]` or `[ -d /c ]`; secondary: `MSYSTEM` / `uname`); exclude WSL; `pomo_is_windows_cmd` returns false when Git Bash matches |
| **Target name** | `pomo_target_system` prints `git-bash` |
| **Default drive** | `GIT_BASH_DRIVE` default `/c`; set to `/c` when `/c/` or `/c` exists |
| **Temp parent** | `$HOME/AppData/Local/Temp` then `${GIT_BASH_DRIVE}/Users/${USERNAME}/AppData/Local/Temp` |
| **Cache leaf** | `…/cache` via `util_ensure_writable_dir` / `util_resolve_volatile_root` (storage REQ) |
| **Privilege freeze** | `pomo_apply_target_paths`: `IS_GIT_BASH=1`, `IS_ROOT=0`, `FORCE_GLOBAL=0` |
| **About** | Dual mention with CLI interface: `pomo --json about` includes `"target":"git-bash"` and `"normal_user_only":"true"` |
| **Help sample** | `pomo help` names Git Bash; **MUST NOT** list `sudo curl` |
| **Tests** | **TP-CLI-13**, **TP-TX-09**, **TP-TX-10**, **TP-TX-11**, **TP-TX-12** in `tests/test_cli.sh` |

### 2.6 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Do not assume `/dev/shm` or `$HOME/.cache` on Windows Git Bash.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): `/c/` is the named default drive; detect is a directory probe, not a guessed username.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): mkdir of `cache` is fail-soft; drive-based Temp is a fallback when `$HOME/AppData` is missing.  
- **CIAO Principle 11 – Safe temps** (https://github.com/cloudgen/ciao): Git Bash temp parent is declared; storage REQ walks the chain.  
- **CIAO Principle 13 – Multi environment** (https://github.com/cloudgen/ciao): Git Bash is first-class, not an afterthought Linux path.  
- **CIAO Principle 19 – Defensive storage location** (https://github.com/cloudgen/ciao): Align temp parents with shell storage; never a single hard-coded cache.  
- **CIAO Principle 4 / 20 – Over-protect** (https://github.com/cloudgen/ciao): Do not recommend `sudo curl \| sh` on this class.

---

## Under command line for normal user only

When `pomo` runs on Git Bash (this login only):

| MUST | MUST NOT |
|------|----------|
| Detect `/c/` or `/c` as Git Bash; default drive `/c/` | Treat missing `/c/` as Linux `/dev/shm` without walking Git Bash temp |
| Volatile temp: AppData Local Temp/`cache` then `/c/Users/<user>/AppData/Local/Temp/cache` | `$HOME/.cache` as volatile root when those parents exist |
| `mkdir` of `cache` fail-soft; storage REQ owns the rest of the chain | `out_die` because one `mkdir` failed |

**This requirement:** Git Bash detect, default drive, temp **parent**. Storage roots: `requirement-shell-cli-storage.md`. Dispatch/help: `requirement-shell-cli-interface.md`.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** `/c/` may be absent on POSIX CI; secondary `MSYSTEM` remains valid for tests; skip drive composition when `/c` is missing.  
- **Intentional:** One default drive; one temp-parent family.  
- **Anti-fragile:** Fail-soft mkdir; HOME AppData first, then `/c/Users/…`.  
- **Over-protect:** Protection Rule blocks `$HOME/.cache` and mid-chain die.

---

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

1. Drop the `/c/` (or `/c`) directory probe from Git Bash detect.  
2. Change the default drive away from `/c/` without an explicit product-law change.  
3. Use `C:\` backslash paths as the only Git Bash form.  
4. Use `$HOME/.cache` as the Git Bash volatile root when AppData Local Temp exists.  
5. Abort because `mkdir` of `cache` failed while later storage roots remain.  
6. Recommend `sudo curl \| sh` or `/usr/local/bin` as the Git Bash install path.  
7. Invoke Termux `pkg` because Git Bash was detected.  
8. Classify WSL as Git Bash.  
9. Duplicate the full storage fallback chain here instead of aligning with `requirement-shell-cli-storage.md`.

**Violating this rule is a critical Git Bash portability regression.**

---

## 5. Related artifacts

| Artifact | Role |
|----------|------|
| **`RQ-SHELL-CLI-STORAGE`** (`requirement-shell-cli-storage.md`) | Volatile/persistent **root** chain; mkdir fail-soft |
| **`RQ-SHELL-CLI-INTERFACE`** (`requirement-shell-cli-interface.md`) | Dual mention: `about` / `help` / detect helpers |
| **`RQ-DOMAIN-POMO`** (`requirement-domain-pomo.md`) | Timer file **leaf** under the resolved root |
| **`RQ-SHELL-SELF-MANAGEMENT`** (`requirement-shell-self-management.md`) | This-login install; about baseline |
| **`RQ-CLASS-SOFTWARE-DEV`** (`requirement-class-software-dev.md`) | Class residual points here for Git Bash |
| `docs/requirements/index.md` | Registry SSOT |
| `./pomo` | Implementation under test |

---

**Last Updated**: 2026-09-10  
**Owner**: pomo project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; peer live requirements in §5; CIAO Principles 1, 2, 3, 4, 11, 13, 19, 20 (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).

## Design-time verification

**Requirement-ID:** `RQ-SHELL-GIT-BASH`  
**Specialized from:** Git Bash target law (temp parents consume **`LM-SHELL-CLI-STORAGE`** / **`LM-TEMP-FILE-SYSTEM`** spirit)  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-13** Git Bash `about` / help no `sudo curl` | `tests/test_cli.sh` | have |
| **TP-TX-09** `$HOME/AppData/Local/Temp/cache` | `tests/test_cli.sh` | have |
| **TP-TX-10** mkdir `cache` fail-soft → `$TEMP/cache` | `tests/test_cli.sh` | have |
| **TP-TX-11** `/c/` directory probe in detect; live about when `/c/` exists | `tests/test_cli.sh` | have |
| **TP-TX-12** default-drive Temp `${GIT_BASH_DRIVE}/Users/<user>/AppData/Local/Temp/cache` | `tests/test_cli.sh` | have |
