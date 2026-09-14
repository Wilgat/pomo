**file**: docs/requirements/requirement-shell-cli-zero-arguments.md  
**Requirement-ID**: `RQ-SHELL-CLI-ZERO-ARGUMENTS`  
**Status**: Active (Version 1.2.0 – TTY menu / off-TTY Type O; `--json` JSON help)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for **zero-argument (empty argv) dispatcher behavior** of the pomo POSIX `/bin/sh` CLI.

### 1.0 Product type (template dual-model)

| Field | Value for pomo |
|-------|------------------------|
| **Empty-argv type** | **Type O-S — Online script-alone** (off-TTY) **plus** TTY numbered menu |
| **Rationale** | Product advertises `curl … \| sh`; pipe empty argv is install-ensure. A real terminal keeps the daily-work menu. |

**Empty argv** means **no command token** after global-flag parse. Overlay switches (`--debug`, `--quiet`/`-q`, `--force`) **do not** disqualify empty argv. `pomo --debug` **MUST** follow the same empty-argv law as `pomo` and as `DEBUG=1 pomo`. `$# -eq 0` at entry is **sufficient** but **not necessary**.

Type N (non-online-install → empty argv = help) does **not** apply to this product.

It defines what happens when the tool is invoked with **no command token**, including the classic one-liner:

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | /bin/sh
```

Empty argv means **install-ensure** for three detect cases:

| Case | Meaning |
|------|---------|
| **Not installed** | No managed binary at the resolved install path(s) |
| **Installed (local)** | Managed binary at the user path (`USER_BIN` / `${HOME}/.local/bin/pomo`) |
| **Installed (global)** | Managed binary at the global path (`GLOBAL_BIN` / `/usr/local/bin/pomo`) |

**Scope:** Empty-argv routing, detect cases (global / local / absent), messages, force boundary, exit status, interaction with TTY / quiet / json.  
**Out of scope (own requirements):** Full command catalog (`requirement-shell-cli-interface.md`); download/checksum detail (`requirement-shell-automatic-checksum.md`); full self-update/uninstall lifecycle (`requirement-shell-self-management.md`); output function catalog (`requirement-shell-output-requirements.md`); general idempotency matrix beyond empty-argv rows (`requirement-shell-idempotency.md`).

### 1.1 Human-facing

**In one sentence:** Typing only `pomo` at a prompt shows the top menu (timer / self-management); piping the script (`curl | sh`) installs or reports already installed. `pomo --json` is JSON help.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Type `pomo` or `pomo --debug` at a prompt | numbered list |
| The other role | `curl \| sh` / a script with no command | install-ensure, not help |
| Not this file | Menu row labels | Default-interaction requirement |

| Includes | Excludes |
|----------|----------|
| TTY empty argv (including overlay switches) = numbered list; off-TTY = install-ensure | Help on a pipe; a hanging menu in a script; help because `--debug` was present |
| Termux: same split; dest is this login; no `sudo curl` | Root dest on Termux |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./pomo` | ship unit | empty argv branch |
| `curl … \| sh` | one-liner | first install |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Pipe the script | Install-ensure | `curl -fsSL …/pomo \| sh` |
| Start at a prompt | Numbered list | `pomo` then `1` |
| Ask for JSON usage | JSON help (empty argv special case) | `pomo --json` |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Definitions (portable + project)

| Term | Definition for pomo |
|------|----------------------------|
| **Type O** | Online-install empty-argv product type: off-TTY empty argv = install-ensure (this product). |
| **Type N** | Non-online-install empty-argv type: empty argv = help — **out of scope** for pomo. |
| **Empty argv / zero-arg** | After global-flag parse, **no command token**. Overlay `--debug` / `--quiet` / `--force` still empty argv. `$# -eq 0` is one form. |
| **Install-ensure** | Converge to “managed `pomo` binary present”; either perform install or success no-op. |
| **Not installed** | `inst_is_installed` returns false (`inst_get_version` → `not installed`). |
| **Installed (local)** | Executable at `${USER_BIN}/pomo` (default `USER_BIN=${HOME}/.local/bin`) observed by install-detect SSOT. |
| **Installed (global)** | Executable at `${GLOBAL_BIN}/pomo` (default `GLOBAL_BIN=/usr/local/bin`) observed by install-detect SSOT. |
| **Force / reinstall** | `FORCE_REINSTALL=1` from `--force` (and related force wiring in `app_main`). Required only for deliberate replace, not for ensure. |

### 2.2 Split meaning of empty argv

1. **Empty argv** is: after global-flag parse, **no command token** was present. `$# -eq 0` at entry to `app_main` is one form. Flags-only overlay argv (`pomo --debug`, `pomo --quiet`, `pomo --force`) is the same form.  
2. **Interactive** (`TTY=1`): route to `app_default` (numbered start list). **MUST NOT** install-ensure. **MUST NOT** print the help dump.  
3. **Not interactive** (`TTY=0`): **Type O install-ensure**. **MUST NOT** print help. **MUST NOT** draw the numbered list. **MUST NOT** prompt. Not installed → download from `SCRIPT_URL` and place. Already installed → success no-op (no `--force` required). `--force` re-downloads.  
4. Overlay switches with no command token **MUST** follow rules 2–3. `pomo --debug` **MUST** match `DEBUG=1 pomo`.  
5. **`--json` special case:** `--json` with no command token **is** empty argv. Outcome **MUST** be JSON help on **TTY and off-TTY**. **MUST NOT** the numbered list. **MUST NOT** Type O ensure. `pomo menu --json` on a TTY remains the list (`requirement-shell-cli-default-interaction`).  
6. Explicit `pomo help` remains full usage.  
7. Explicit `pomo install` remains ensure.  
8. Explicit `pomo menu` / `main` remain the numbered list (TTY) / help (off-TTY).  
9. Script entry **MUST** always call `app_main "$@"` (no basename gate). Pipe-safe.  
10. The dispatcher **MUST** decide empty argv **after** flag parse. **MUST NOT** use only `$# -eq 0` before parse so overlay flags fall through to default `COMMAND=help`.

### 2.3 Normative case matrix

| Case | Detect condition (project) | Empty argv, `FORCE_REINSTALL=0` | Empty argv / install with force |
|------|----------------------------|--------------------------------|---------------------------------|
| **A. Not installed** | `inst_is_installed` false | Install into privilege-correct path (§2.4) | Same first-time install |
| **B. Installed — local** | User binary present via detect SSOT | Success no-op: already installed; no re-download; **no help** | `inst_perform_install` re-download/replace (user path when non-root) |
| **C. Installed — global** | Global binary present via detect SSOT | Success no-op: already installed; no re-download; **no help** | Re-download/replace (global path when root / global binary policy) |

**Already-installed rules (Cases B and C, force off):**

1. Exit status **MUST** be `0`.  
2. Human mode **MUST** use `out_success` with an **already installed** message (via `inst_perform_install` no-op path).  
3. Human mode **MAY** add `out_info` tips that `--force` / `self-update` are for **deliberate** reinstall or upgrade — **MUST NOT** imply force is required for a normal one-liner re-run.  
4. JSON mode **MUST** use structured success (`out_json` success type) with already-installed message — **MUST NOT** emit help JSON.  
5. Detect **MUST** treat either global or local managed binary as installed when that is how `inst_is_installed` / `inst_get_version` resolve paths (project SSOT today prefers global when executable there, else user path).

### 2.4 Case A — not installed (modes) — **off-TTY empty argv only**

TTY empty argv is the numbered list (§2.2), not this table.

| Mode | Required empty-argv behavior |
|------|------------------------------|
| **Non-interactive** (non-TTY / `curl \| sh`) | Auto-install message + `inst_perform_install` (via `inst_maybe_install` non-TTY branch) |
| **Quiet** (off-TTY, no `--json`) | `inst_perform_install` directly (no prompt) |
| **`--json` with no command** | Empty argv **special case** (§2.2): JSON help on TTY **and** off-TTY — **MUST NOT** this Case A install |
| **Failure** (network, checksum, I/O) | Non-zero exit; no fake success; no help-only output |

**Placement privilege:**

| Invoker | Target |
|---------|--------|
| root (`id -u` 0), e.g. `curl … \| sudo sh` | `${GLOBAL_BIN}/pomo` → `/usr/local/bin/pomo` |
| non-root | `${USER_BIN}/pomo` → `${HOME}/.local/bin/pomo` |

### 2.5 Equivalence to explicit `install`

| Invocation | Contract |
|------------|----------|
| Empty argv | Same ensure semantics as `install` for Cases A/B/C |
| `install` | Explicit ensure; same detect / no-op / force |
| `install --force` | Deliberate reinstall |
| `help` | Usage only — **not** empty-argv default |

### 2.6 Forbidden empty-argv outcomes

1. Dump full help when Case B or C applies.  
2. Silent success when Case A should install (or when Case B/C should acknowledge already installed).  
3. Require `--force` solely because detect says installed.  
4. Blind re-download every empty-argv run without force.  
5. Basename-gate main so `curl \| sh` never hits the empty-argv branch.  
6. Detect only one of global/local incorrectly so a present local install is treated as Case A (or the reverse) contrary to `inst_*` SSOT.

### 2.7 Implementation Notes (this project)

| Item | Value for pomo |
|------|------------------------|
| **Empty-argv type** | **Type O — Online-install** (install-ensure; not Type N help-default) |
| **Product / binary** | `pomo` (`APP_NAME`) |
| **Ship unit** | Repo root `./pomo` |
| **Dispatcher** | `app_main` — empty-argv block **before** flag/command parse default help |
| **Install ensure** | `inst_perform_install` (quiet/json and already-installed no-op) |
| **Friendly first install** | `inst_maybe_install` (TTY confirm / non-TTY auto) when not installed and not quiet/json |
| **Detect SSOT** | `inst_is_installed` ← `inst_get_version` |
| **Global path** | `GLOBAL_BIN` default `/usr/local/bin` |
| **Local path** | `USER_BIN` default `${HOME}/.local/bin` |
| **Force wiring** | `--force` → `FORCE=1` and `FORCE_REINSTALL=1` in `app_main` |
| **Output SSOT** | `out_success` / `out_info` / `out_json` / errors via `out_*` |
| **Channel** | `SCRIPT_URL` (compose from `REPO_USER` / `REPO_NAME` / `APP_NAME`) for download path inside install |
| **Tests** | `tests/test_cli.sh` (Case A failure when not installed); `tests/test_install_lifecycle.sh` (Case B local + Case C global already-installed → not help) |

#### Dispatcher algorithm (normative sketch)

```text
app_main:
  if [ $# -eq 0 ]; then
    if JSON or QUIET:
      inst_perform_install; exit $?
    elif inst_is_installed:
      inst_perform_install   # Case B/C success no-op
      exit $?
    else
      inst_maybe_install     # Case A
      exit $?
    fi
  fi
  # else parse flags/commands; default COMMAND=help only when argv non-empty and command is help/absent token rules
```

#### Message contract (already installed, human)

- Success: `${APP_NAME} is already installed.` (or equivalent via `out_success`)  
- Optional info: force / `self-update` only for deliberate reinstall or upgrade  
- **MUST NOT** print the full `app_help` usage body on this path

### 2.8 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): One-liner re-runs must not look like broken install or force unnecessary reinstall.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): Empty argv has one meaning for not-installed, local, and global.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): Dual install paths + `curl \| sh` + TTY.  
- **CIAO Principle 6 – Single Point of entry** (https://github.com/cloudgen/ciao): `app_main` owns empty-argv before help default.  
- **CIAO Principle 16 – Interactive vs non-interactive** (https://github.com/cloudgen/ciao): Case A auto under pipe; optional TTY confirm.  
- **CIAO Principle 4 / CIAO-Lite O · Principle 20 – Over-protect / Protect Against AI** (https://github.com/cloudgen/ciao): Protection Rule against help-fallback regression.

---

## Under command line for normal user only

When `pomo` runs on Termux, Git Bash, Windows cmd, or the same class (this login only):

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| Empty-argv install-ensure as this login; recommended one-liner is `curl \| sh` (no sudo) | In-tool `sudo`; wrap `apt`/`dnf`; create a dedicated system user; recommend `sudo curl \| sh` |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or Windows cmd was detected |

Helpers (this product): `pomo_is_termux`, `pomo_is_git_bash`, `pomo_is_windows_cmd`, `pomo_is_normal_user_only_cli`. Dual mention: `requirement-shell-cli-interface`.

**This requirement:** off-TTY empty argv still means install-ensure on this class; TTY empty argv is the daily-work list. `inst_maybe_install` must not print a sudo one-liner.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Real failures non-zero; healthy re-runs success with clear text.  
- **Intentional:** Help is never the empty-argv default for this install CLI.  
- **Anti-fragile:** Global and local detect; idempotent second one-liner.  
- **Over-protect:** Do not “simplify” empty-argv back to `COMMAND:=help` after first install.  
- **SSOT:** `inst_is_installed` / `inst_perform_install` / `inst_maybe_install` / `out_*`.  
- **Idempotent ensure:** Case B/C force off → already installed, exit 0.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Route empty argv to `app_help` when Case B or C applies (or when Case A should install).  
2. Require `--force` for a healthy already-installed empty-argv re-run (local or global).  
3. Handle only Case A and leave B/C as accidental help fallthrough.  
4. Break dual-path detect so local or global installs are misclassified.  
5. Blindly reinstall on every empty-argv run without `FORCE_REINSTALL`.  
6. Exit 0 with no install and no already-installed acknowledgment when detect says installed.  
7. Reintroduce a basename-only gate that skips `app_main` under `curl \| sh`.  
8. Bypass `out_*` for empty-argv user messages.  
9. Contradict this file in peer requirements by documenting “already installed → help” as normative empty-argv behavior.

**Violating this rule is a critical zero-arg / online-install regression.**

---

## 5. Definition of done

This requirement is satisfied when all of the following hold:

1. Empty argv + not installed → Case A install path (TTY may confirm; non-TTY / quiet / json auto).  
2. Empty argv + local install present + force off → already-installed success; not help; no re-download.  
3. Empty argv + global install present + force off → already-installed success; not help; no re-download.  
4. Empty argv + install failure → non-zero exit.  
5. `--force` only for deliberate reinstall; not required for ensure.  
6. `help` works when invoked explicitly.  
7. Tests cover Case A failure (not installed, bad channel) and already-installed not-help for local (Case B) and global (Case C).  
8. Changes cite `requirement-shell-cli-zero-arguments`.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| **`RQ-SHELL-CLI-INTERFACE`** (`requirement-shell-cli-interface.md`) | Full command surface; empty-argv row must match this SSOT |
| **`RQ-SHELL-IDEMPOTENCY`** (`requirement-shell-idempotency.md`) | Ensure re-run / force boundary |
| **`RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE`** (`requirement-shell-interactive-vs-noninteractive.md`) | TTY vs pipe for Case A |
| **`RQ-SHELL-SELF-MANAGEMENT`** (`requirement-shell-self-management.md`) | self-update / uninstall (not empty-argv default) |
| **`RQ-SHELL-OUTPUT-REQUIREMENTS`** (`requirement-shell-output-requirements.md`) | out_* / JSON purity |
| **`RQ-SHELL-AUTOMATIC-CHECKSUM`** (`requirement-shell-automatic-checksum.md`) | Integrity on install download path |
| **`RQ-SHELL-CLI-DEFAULT-INTERACTION`** | TTY numbered list for empty argv |
| Repo root `./pomo` | Implementation (`app_main`, `inst_*`) |
| `tests/test_cli.sh`, `tests/test_install_lifecycle.sh` | Regression coverage |

---

## 7. Revision history

| Date | Change | Author / agent |
|------|--------|----------------|
| 2026-07-14 | Initial Active v1.0.0: empty argv = install-ensure for not-installed / local / global; forbid help fallthrough | Grok (owner request) |
| 2026-07-14 | v1.1.0: Classify product as Type O (online-install) under dual-type empty-argv template model | Grok |

## Design-time verification

**Requirement-ID:** `RQ-SHELL-CLI-ZERO-ARGUMENTS`  
**Specialized from:** `LM-SHELL-CLI-ZERO-ARGUMENTS` (or portable zero-arg mold when named)  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-09** / **TP-LC-09** / **TP-U-02** zero-arg bad channel | `tests/test_cli.sh` | have |
| **TP-LC-01** empty-argv ensure first + already local/global | `tests/test_install_lifecycle.sh` | have |
| **TP-LC-12** explicit `install --json` | `tests/test_install_lifecycle.sh` | have |
| **TP-TX-03** Termux empty-argv recommend has no `sudo curl` | `tests/test_cli.sh` | have |
| **TP-CLI-29** overlay `--debug` / `--quiet` / `--json` follow empty argv | `tests/test_cli.sh` | have |
| **TP-CLI-17** TTY empty argv numbered list (peer of default-interaction) | `tests/test_cli.sh` | have |
