**file**: docs/requirements/requirement-shell-script-coding.md  
**Requirement-ID**: `RQ-SHELL-SCRIPT-CODING`  
**Status**: Active (Version 1.0.0 – specialize-in home; own-or-point)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **specialize-in home** for POSIX `/bin/sh` coding lessons on pomo. **Without this file, agents bring portable learned lessons raw** and treat them as this product’s law.

It owns coding rules that are **not** already owned by a peer requirement. Slices already owned by peers are **pointers**, not duplicated bodies.

### 1.1 Human-facing

**In one sentence:** Write `./pomo` as one POSIX `sh` file that still runs on dash and BusyBox ash; do not invent a second language or split the published script.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Run and edit the one ship unit | `./pomo`, `sh -n ./pomo` |
| The other role | Peer REQs that already own output, prefixes, TTY, install | `RQ-SHELL-OUTPUT-REQUIREMENTS`, … |
| Not this file | Timer minutes; SHA-256 companion algorithm | domain / automatic-checksum peers |

| Includes | Excludes |
|----------|----------|
| Shebang, `set -u`, no bashisms, single-file ship, Protection Zones | Full `out_*` catalog (peer); full prefix table (peer) |
| Adopt / point / refuse for portable lessons | Treating a coding skill as product law |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./pomo` | ship unit | coding target |
| `./tests/run.sh` | suite | `sh -n` + behavior |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Syntax check | POSIX parse; no bash-only arrays. | `sh -n ./pomo` |
| Change a function | Keep the prefix and the Protection Zone comments. | (edit `./pomo`; then `./tests/run.sh`) |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Specialize-in intention (MUST)

1. **MUST** treat this file as the only product-law home for shell coding style on this project.  
2. **MUST NOT** tell implementers to follow a portable coding skill or law mold as if it were this product’s requirement.  
3. When a portable lesson is needed: **adopt** it here, **point** at a peer REQ that already owns it, or **refuse** it in Implementation Notes with a reason.

### 2.2 Own-or-point (no duplicated peer bodies)

| Slice | Owner on this product | This file |
|-------|----------------------|-----------|
| User-facing output (`out_*`, JSON purity, quiet) | `requirement-shell-output-requirements` / `RQ-SHELL-OUTPUT-REQUIREMENTS` | **point** |
| Function prefixes / Protection Zones / single-file modularity | `requirement-shell-modular-function-design` / `RQ-SHELL-MODULAR-FUNCTION-DESIGN` | **point** |
| Interactive vs pipe / `TTY` measured outside functions | `requirement-shell-interactive-vs-noninteractive` / `RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE` | **point** |
| Install / update / uninstall lifecycle | `requirement-shell-self-management` + zero-arguments + checksum peers | **point** |
| Domain ops (`pomo_*`) | `requirement-domain-pomo` / `RQ-DOMAIN-POMO` | **point** |
| Shebang, `set -u`, no bashisms, no `set -e` global, no in-tool sudo wrapper | **this file** | **own** |

### 2.3 POSIX ship-unit rules (owned here)

4. **MUST** use `#!/bin/sh` (or equivalent POSIX shebang) on `./pomo`.  
5. **MUST** enable `set -u`. **MUST NOT** enable global `set -e`; fail through explicit `out_die` / checked status.  
6. **MUST NOT** use bashisms (arrays, `[[ ]]`, `source` in place of `.`, process substitution) on the ship-unit path that `curl | sh` runs.  
7. **MUST** ship as **one** installable file at repo root `./pomo` (the published channel). **MUST NOT** make `src/pomo` the install URL.  
8. **MUST** keep CIAO Protection Zones and “DO NOT MODIFY OR SIMPLIFY” comments on critical helpers.  
9. **MUST** give every new function a documented prefix from the modular-function peer (do not invent a parallel naming scheme here).  
10. **MUST NOT** add an in-tool `sudo` wrapper unless a dedicated sudo-command requirement is registered in the same change. Current product: **no in-tool sudo** (operator `sudo` only on the documented root one-liner).  
11. Blocking human errors **MUST** say what happened and what to type next; they **MUST NOT** be only catalog codes (Type 0 / euid / F6).

### 2.4 Implementation Notes (this project)

| Field | Value |
|-------|--------|
| Ship unit | `./pomo` (VERSION 2.1.0) |
| **Termux / Git Bash / Windows cmd** | Same ceiling as § Under command line for normal user only |
| Interpreter | `/bin/sh` |
| `set -u` | yes (with HOME/USER safe defaults) |
| `set -e` | no (global) |
| In-tool sudo | none |
| Test proof | **TP-CLI-01** `sh -n` |

## 3. Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 2 – Intentional**: Coding lessons have a specialize-in home; they do not arrive raw.  
- **CIAO Principle 13 – Multi environment**: dash/ash/Git Bash/Termux are first-class.  
- **CIAO Principle 20 / Over-protect**: Protection Zones stay; do not “simplify” them away.

## Under command line for normal user only

When `pomo` runs on Termux, Git Bash, Windows cmd, or the same class (this login only):

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| POSIX `/bin/sh` detect helpers; no bashisms | In-tool `sudo`; wrap `apt`/`dnf`; create a dedicated system user; recommend `sudo curl \| sh` |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or Windows cmd was detected |

Helpers (this product): `pomo_is_termux`, `pomo_is_git_bash`, `pomo_is_windows_cmd`, `pomo_is_normal_user_only_cli`. Dual mention: `requirement-shell-cli-interface`.

**This requirement:** coding of detect helpers. Do not add an in-tool sudo wrapper because Termux was detected.

## 4. Design Principles (CIAO / CIAO-Lite)

- **Caution**: Assume dash.  
- **Intentional**: Own-or-point table is the reason this file is short.  
- **Anti-fragile**: Single-file `curl | sh`.  
- **Over-protect**: Do not strip Protection Zones for brevity.

## 5. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

- Delete this file while the workspace remains software-development.  
- Duplicate full output / prefix / TTY / install bodies here.  
- Treat a coding skill or mold as product law because this file is “only a pointer.”  
- Reintroduce bashisms or global `set -e`.  
- Move the published ship unit off `./pomo` without an authorized channel change.  
- Add in-tool `sudo` without a dedicated requirement.

## 6. Acceptance criteria

| ID | Criterion |
|----|-----------|
| AC-1 | Purpose states specialize-in intention (without this file, lessons arrive raw) |
| AC-2 | Own-or-point table complete; no duplicated peer bodies |
| AC-3 | POSIX shebang + `set -u` + no bashisms on `./pomo` |
| AC-4 | **TP-CLI-01** `sh -n` have |

## 7. Related requirements

| Key | Relationship |
|-----|--------------|
| `requirement-class-software-dev` / `RQ-CLASS-SOFTWARE-DEV` | Class residual **points** here |
| `requirement-shell-modular-function-design` | Prefix / zone SSOT |
| `requirement-shell-output-requirements` | `out_*` SSOT |
| `requirement-shell-interactive-vs-noninteractive` | `TTY` SSOT |

## Design-time verification

**Requirement-ID:** `RQ-SHELL-SCRIPT-CODING`  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-01** `sh -n` + companion | `tests/test_cli.sh` | have |
| **TP-CITE-01** ALIGNMENT cites live REQs | static (`./pomo` headers) | have |
| **TP-TX-01** off-Termux detect | `tests/test_cli.sh` | have |
| **TP-TX-02** Termux PREFIX detect | `tests/test_cli.sh` | have |
| **TP-TX-03** no `sudo curl` on Termux | `tests/test_cli.sh` | have |
| **TP-TX-04** `$PREFIX/bin` dest | `tests/test_cli.sh` | have |
| **TP-TX-05** `pkg` not invoked | `tests/test_cli.sh` | have |
| **TP-TX-08** Termux `$PREFIX/tmp` volatile records | `tests/test_cli.sh` | have |

## 8. Status history

| Date | Status | Note |
|------|--------|------|
| 2026-09-06 | Active | Specialize-in home; own-or-point to existing shell REQs |

---

**Last Updated**: 2026-09-06  
**Owner**: Wilgat Wong
