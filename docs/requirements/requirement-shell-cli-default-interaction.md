**file**: docs/requirements/requirement-shell-cli-default-interaction.md  
**Requirement-ID**: `RQ-SHELL-CLI-DEFAULT-INTERACTION`  
**Status**: Active (Version 1.0.0 – TTY numbered daily-work list; running-pomo pick)  
**Area**: shell  
**Key**: `requirement-shell-cli-default-interaction`  
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **product Single Source of Truth** for pomo’s **default interaction**: a **short numbered main menu** of daily pomodoro work. pomo has `requirement-shell-cli-zero-arguments` (**case 3**): that REQ **defers TTY empty argv** to this menu and **owns off-TTY empty argv as Type O ensure**. The menu **MUST** also be the command **`menu`**. **`main` MAY** be accepted as the same handler.

On a **real terminal**, empty argv (no command token — overlay switches such as `--debug` allowed) and `pomo menu` (or `main`) **MUST** show the main menu. `menu`/`main` **MUST ignore `--json`**. Off-TTY, **`menu`/`main` MUST** print **help**, following `--json`. Off-TTY **empty argv** is **not** this file — it is channel ensure. Command rows **MUST** be `command: what it does`.

Empty-argv type and the TTY vs off-TTY split for **no command token** stay on `requirement-shell-cli-zero-arguments`. Confirm / no-hang stays on `requirement-shell-interactive-vs-noninteractive`. Live command inventory stays dispatcher truth (`requirement-shell-cli-interface`). Domain start/stop semantics stay on `requirement-domain-pomo`.

Actor/role: **considered** — no dest approver (Type 0 this-login only). Dest fences: **considered — none**.

### 1.1 Human-facing

**In one sentence:** Typing only `pomo` at a real terminal shows a numbered list of start/status/watch/skip/stop/kill/list/stats/theme; in a script, bare `pomo` still installs.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Type `pomo` or `pomo --debug` at a prompt | Pick `1` then a name; pick `5` then a running pomodoro |
| The other role | CI / pipe | Empty argv ensures install; `pomo --json` prints JSON help |
| Not this file | How a pomodoro file is stored | Domain requirement |

| Includes | Excludes |
|----------|----------|
| TTY empty argv numbered list; `menu`/`main`; Exit **99** | Off-TTY empty argv (Type O); install/version/about/help as rows |
| Default CLI main menu style (bold name, italic version, gray italic explain) | A menu that hangs a pipeline; help because `--debug` was present |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./pomo` | ship unit | TTY list / pipe ensure |
| `pomo menu` | command | same list on a TTY |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Start daily work at a prompt | Numbered list; **start** is **1**; then name (Enter = `default`) | `pomo` then `1` then Enter |
| Stop a running pomodoro | After **5**, numbered running sessions; **0** leaves | `pomo` then `5` then `1` |
| Same list with diagnostics | Same list; `[DEBUG]` on stderr | `pomo --debug` |
| Ask for machine-readable usage | JSON help (empty argv **special case**) | `pomo --json` |
| Open the list by name | Same list as empty argv on a TTY | `pomo menu` |
| First install from the channel | Pipe places the binary | `curl -fsSL …/pomo \| sh` |

---

## 2. Core Rules (Mandatory)

### 2.1 Claim and case

pomo **claims** a default function. **Case 3** applies: `requirement-shell-cli-zero-arguments` exists. That REQ **defers TTY empty argv** to this menu. Off-TTY empty argv is Type O ensure on that REQ — **this file MUST NOT** print help for bare off-TTY empty argv. Off-TTY **`menu`/`main`** still print help.

### 2.2 Routed verb `menu` / `main` and TTY empty argv

| Token | Role |
|-------|------|
| empty argv (no command token; overlay `--debug` / `--quiet` allowed) | Same handler as `menu` when TTY=1; Type O ensure when TTY=0 (owned by zero-arguments; **not** `app_default`) |
| `menu` | Primary named command for this default |
| `main` | Same handler (alias) |

After flag parse, when the command token is `menu` or `main`, **or** when no command token was present and `--json` is off (zero-arguments routes `COMMAND=menu` on a TTY — including `pomo --debug`), pomo **MUST** branch (`TTY` measured in the main process, **not** inside helpers):

| # | Condition | MUST | MUST NOT |
|---|-----------|------|----------|
| 1 | Interactive (`TTY=1`) | **Main menu** (§2.3). For `menu`/`main`, **ignore `--json`** even if `JSON=1` | JSON help; hang |
| 2 | Not interactive (`TTY=0`) and `JSON=0` | **Human help screen** — `app_help` (not JSON) | Menu; silent return; hang |
| 3 | Not interactive (`TTY=0`) and `JSON=1` | **JSON help** — `app_help` in JSON mode | Menu; human banners; hang |

`--quiet` without a TTY on **`menu`/`main`** still takes the **help screen** path (do not swallow `menu` help). Flags-only `--json` **is** empty argv on `requirement-shell-cli-zero-arguments`; **special case** = JSON help **even on a TTY** (this file **MUST NOT** steal it onto the numbered list). Overlay flags-only (`--debug`, `--quiet` with no command) follow the ordinary empty-argv path on that REQ. `pomo menu --json` on a TTY still ignores `--json` (rule 1).

### 2.3 Main menu

1. Print a **numbered list** of daily pomodoro verbs, then **Exit**.  
2. **MUST NOT** list **install / setup**, **self-managed** commands (`install`, `self-uninstall`, `self-update`, `version-check`), **diagnostics** (`version`, `about`), or **test-purpose** verbs.  
3. Command-row text **MUST** be `command: what it does`. The numbered list **MUST** follow **default CLI main menu style**: header as in rule 8; each numbered row `command: what it does` with the number and command name **unstyled**; on a TTY the **explain** text after `: ` **MUST** be *italic* **and** light gray (SGR **3** + **37**, CSI `ESC[3;37m` … `ESC[0m` via `out_menu_choice`). Off-TTY: plain. **MUST NOT** print explain unstyled on a TTY.  
4. **MUST NOT** list `help` or `menu`/`main` on the **main** list.  
5. Command rows **N = 9**. Exit **MUST** be **99**. Unused integers **10** through **98** are omitted.  
6. Accept a **number** or a **listed verb**. **99** / `exit` / `quit` returns 0.  
7. The choice **MUST** be read in the **current shell**. **MUST NOT** `$()` / backticks a helper whose body contains `read` (do-not-capture-read; current-shell `PROMPT_ASK_VALUE` or a direct `read` in `app_default`).  
8. **Header (mandatory):** the first human line that names the program **MUST** be live **`APP_NAME(VERSION)`** with **bold** name and *italic* version, then the product short description. Typical: `out_info "$(util_app_ident) — ${SHORT_DESCRIPTION}"`. TTY: SGR 1 / SGR 3. Off-TTY: plain. **MUST NOT** a bare `APP_NAME` on that header.  
9. Extra fields on a TTY (JSON=0 / QUIET=0; ignore `--json` for the field; restore after). Persist overlay already parsed (`--persist`) **MUST** still apply. **MUST NOT** `$()` `prompt_ask` / any `read` helper. **MUST NOT** hang off-TTY asking for a name or a running-session pick.  
    - **start:** **MUST** prompt for the pomodoro name (`prompt_ask "Pomodoro name" "default"` in the current shell; value is **`PROMPT_ASK_VALUE`**). Empty answer / Enter **MUST** use `default` (same as omitting the operand on the CLI).  
    - **status** / **watch** / **skip** / **stop** / **kill:** **MUST** show a **numbered list of running pomodoros** in the current storage mode (rows `N. name: <phase> M min S sec remaining` via `out_menu_choice`). Accept a **number** or a **listed name**. Cancel **MUST** be **0** / `exit` / `quit` / empty — **MUST NOT** number cancel as **99** (row 99 can be a session). If none are running, print `No running pomodoros found.` and return — **MUST NOT** prompt for a free-typed name.  
    - **list** / **stats:** **MUST NOT** prompt and **MUST NOT** show a second pick list.  
    - **theme:** **MUST NOT** prompt; run **`theme list`**.

Normative **main** order:

| # | Token | Label |
|---|-------|-------|
| *(header)* | — | `**APP_NAME**(*VERSION*) — Simple & Beautiful Pomodoro Timer (volatile or persistent, themed)` |
| 1 | `start` | `start: Start a work phase` |
| 2 | `status` | `status: Show themed status and progress` |
| 3 | `watch` | `watch: Live refresh every second` |
| 4 | `skip` | `skip: Skip the current phase` |
| 5 | `stop` | `stop: Complete work (counts toward stats)` |
| 6 | `kill` | `kill: Discard without counting` |
| 7 | `list` | `list: List running pomodoros` |
| 8 | `stats` | `stats: Daily completed count and minutes` |
| 9 | `theme` | `theme: List available themes` |
| **99** | **Exit** | leave the menu |

### 2.4 Implementation Notes (this project)

| Item | Value |
|------|--------|
| **Product** | pomo |
| **Ship unit** | `./pomo` |
| **Claimed** | yes |
| **Case** | **3** (zero-argument REQ exists; that REQ defers TTY empty argv here; off-TTY empty argv is Type O, not this file) |
| **Empty argv** | TTY → this menu; off-TTY → Type O ensure (`requirement-shell-cli-zero-arguments`; not this handler) |
| **Verb** | `menu` (alias `main`); TTY empty argv (including `--debug` with no command) sets `COMMAND=menu` |
| **Handler** | `app_default` (`menu` / `main` / TTY empty argv); `app_default_print_menu` / `app_default_print_running` / `app_default_map_running_pick` / `app_default_run_pick`; start name via current-shell `prompt_ask` + `PROMPT_ASK_VALUE` |
| **Label source** | `reviews/cli-routed-verb-table.md` **human-readable** for command rows |
| **Interactive + `--json`** | Ignore json on `menu`/`main`; still the menu |
| **Non-interactive `menu`/`main`** | `app_help` (human; `--quiet` still prints help) |
| **Look** | **default CLI main menu style** — header `APP_NAME(VERSION)`; TTY explain *italic* + light gray (SGR 3+37) via `out_menu_choice` |
| **Honesty** | **Implemented.** TTY empty argv (including `--debug` with no command) draws this menu. Off-TTY empty argv is Type O ensure. `--json` with no command is JSON help even on a TTY. TTY menu **start** prompts for the name (Enter = `default`); **status** / **watch** / **skip** / **stop** / **kill** pick from a numbered running list (0 leaves); **list** / **stats** / **theme** do not prompt. |
| **Actor/role** | Considered — no dest approver |
| **Invocation samples** | `pomo` · `pomo --debug` · `pomo --json` · `pomo menu` · `pomo main` |

### 2.5 Why this requirement exists (CIAO)

- **Intentional**: Daily pomodoro verbs are the start list; install stays off it.  
- **Caution**: Scripts never hang; `--json` with no command is JSON help, not the list.  
- **Anti-fragile**: Overlay `--debug` is still empty argv, not a third meaning.  
- **Over-protect**: Exit is **99** (N=9), not **10**; do-not-capture-read on the pick.

---

## Under command line for normal user only

When `pomo` runs on Termux, Git Bash, Windows cmd, or the same class (this login only):

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| Same nine domain rows on Termux | Hide start/stop because Android has no `/dev/shm` |
| Off-TTY empty argv stays this-login install-ensure | Enable admin privilege from the menu; recommend `sudo curl \| sh` |

**This requirement:** the numbered list is this-login daily work. It **MUST NOT** add sudo/apt rows or recommend `sudo curl | sh`.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution**: No menu on a pipe.  
- **Intentional**: Help is `help` / `--json` with no command, not `--debug` with no command.  
- **Anti-fragile**: Off-TTY `menu` prints help; never hangs.  
- **Over-protect**: Do not `$()` a `read` helper for the choice.

---

## 4. Protection Rule (Sacred)

**Future AI assistants or maintainers MUST NOT**:

1. Draw the numbered menu on off-TTY empty argv, or hang a pipe.  
2. Put install / self-update / version / about / help / `menu` itself on the numbered list.  
3. Number Exit as **10** (N+1) instead of **99**.  
4. Capture the menu choice with `$()` of a `read` helper.  
5. Steal flags-only `--json` onto the numbered list.  
6. Treat overlay `--debug` with no command as help.  
7. Print a bare `APP_NAME` header without live `VERSION`, or unstyled explain on a TTY.  
8. Skip the TTY name prompt for **start**, or skip the numbered running list for **status** / **watch** / **skip** / **stop** / **kill**.  
9. Prompt for a free-typed name on **status** / **watch** / **skip** / **stop** / **kill** / **list** / **stats** / **theme**.  
10. Hang off-TTY asking for a pomodoro name or a running-session pick.  
11. Number cancel as **99** on the running-session list (cancel is **0**).

**Violating this rule is a critical dispatcher / menu regression.**

---

## 5. Related artifacts (versioned surface only)

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry |
| `docs/requirements/requirement-shell-cli-zero-arguments.md` | Empty argv owner; defers TTY here |
| `docs/requirements/requirement-shell-cli-interface.md` | Dual mention of `menu` / `main` |
| `docs/requirements/requirement-domain-pomo.md` | Domain verb behavior |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_menu_choice` / `out_*` |
| `./pomo` | Implementation |

## Design-time verification

**Requirement-ID:** `RQ-SHELL-CLI-DEFAULT-INTERACTION`  
**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-CLI-16** no `$()` of `prompt_*` | `tests/test_cli.sh` | have |
| **TP-CLI-17** header nametag + gray italic explain; off-TTY `menu` is help | `tests/test_cli.sh` | have |
| **TP-CLI-29** overlay `--debug` / `--quiet` follow empty argv | `tests/test_cli.sh` | have |
| **TP-CLI-30** TTY menu start name prompt; status/stop numbered running list | `tests/test_cli.sh` | have |

**Last Updated**: 2026-09-08  
**Owner**: pomo project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; CIAO (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
