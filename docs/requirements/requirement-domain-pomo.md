**file**: docs/requirements/requirement-domain-pomo.md  
**Requirement-ID**: `RQ-DOMAIN-POMO`  
**Status**: Active (Version 1.1.0 – CIAO v2.10.2 Principles 1/4/5/17/18/19/20)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for the **pomodoro domain surface** of the pomo POSIX `/bin/sh` Type 0 CLI: named work/break timers, storage modes, themes, statistics, path-safe names, phase transitions, and stable machine error codes.

It **does not** re-own Type 0 install/self-management, empty-argv install-ensure, output SSOT primitives, or automatic checksum — those remain under peer `requirement-shell-*.md` files. Domain commands are still **Type 0 invoker privilege** (not Type 1 host bootstrap, not Type 2 system-user app ops).

**Scope:** Domain commands (`start`, `status`, `watch`, `skip`, `stop`, `kill`, `list`, `stats`, `theme`), domain flags (`--persist`, `--break`), state format, storage resolution, themes, daily stats, path-safe names, domain JSON codes, **domain help items**, **domain about items**.  
**Out of scope:** Install channel, self-update/uninstall, companion digest, global quiet/json contracts (cited from peers).

**Bootstrap note:** Architecture lineage from **countdown** (A → B only). Domain specialty from **pomo 1.7.0** oracle. An in-tree `./countdown` bootstrap ship unit is **optional** (present only if that file exists on disk — never invent or assume it).

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Domain command surface (portable shape)

A pomodoro domain CLI **MUST** expose the following ops (names may match this project’s table in Implementation Notes):

| Concern | Rule |
|---------|------|
| **Start** | Create a named work phase with work duration and optional break duration |
| **Status** | Inspect remaining time / phase without requiring stop |
| **List** | Enumerate running timers for the invoker |
| **Stop** | End a work session; **MUST** count toward daily stats when work phase and not force-discard |
| **Kill / force-stop** | Discard without counting toward stats |
| **Skip** | Advance phase (work→break or break→work); work skip **MUST** count completed work minutes |
| **Watch** | Live refresh of status; **MUST NOT** support pure `--json` / `--quiet` as primary UX |
| **Stats** | Report daily completed count and total minutes |
| **Theme** | List / set / cycle visual themes with persistent preference |

All domain user messages **MUST** go through the product output SSOT (`out_*` per `requirement-shell-output-requirements.md`).

### 2.2 State model (portable)

1. **Per-user isolation:** Timer state files **MUST** be scoped to the invoking user (and product `APP_NAME`) so concurrent users do not collide.  
2. **Named timers:** Default name **MUST** be `default` when omitted.  
3. **Phases:** At least **work** and **break**.  
4. **Durations:** Work and break durations **MUST** be stored with the running timer so phase transitions use the original start contract.  
5. **Already running:** Starting when a state file already exists for that name+mode **MUST** fail closed (non-zero); **MUST NOT** silently overwrite.  
6. **Missing timer:** Status/stop/skip/kill on a missing name **MUST** fail closed with a stable machine code.  
7. **Corruption:** Unreadable/partial state **MUST** fail closed (and should remove or refuse the bad file); **MUST NOT** invent silent success.

### 2.3 Storage modes (portable)

| Mode | Intent | Rule |
|------|--------|------|
| **Volatile** (default) | Fast, reboot-ephemeral | Prefer RAM tmpfs when writable; **MUST** fall back to writable temp with clear warn when primary missing |
| **Persistent** | Survives reboot | Prefer XDG/cache under `$HOME`; **MUST** fail closed or use documented fallback when no writable home |

Domain **MUST** resolve storage via a single resolver family (project: `pomo_resolve_base_dir` / `pomo_get_file`) — no parallel ad-hoc paths for the same mode.

### 2.4 Path-safe names (portable)

Names that become path segments **MUST** be validated **before** I/O:

1. Reject path separators, `..`, and shell-dangerous metacharacters claimed by the product.  
2. Invalid names **MUST** exit non-zero.  
3. Under `--json`, code **MUST** be stable (`invalid_name` for this product).  
4. Behavior **MUST** be safe under `/bin/sh` (dash) — no bash-only character classes that silently accept bad names.

### 2.5 Phase transitions (portable)

1. When **work** remaining reaches ≤0, status/watch paths **MUST** transition to **break** using stored break duration (or complete session if break is zero/absent under documented policy).  
2. When **break** remaining reaches ≤0, session **MUST** end cleanly (remove state; success/expired signal).  
3. Terminal bell on natural phase end **MAY** be used for human TTY UX; **MUST NOT** break JSON purity on stdout.  
4. `skip` **MUST** preserve work/break duration pair across the new phase.

### 2.6 Statistics (portable)

1. Completing a **work** phase via `stop` (without force) or via `skip` from work **MUST** increment daily completed count and total minutes.  
2. `kill` / force-discard **MUST NOT** count.  
3. Stats storage **MUST** use persistent-mode resolution (survive reboot for the day).  
4. Missing stats file **MUST** mean zero counts (success), not hard failure.

### 2.7 Themes (portable)

1. Product **MUST** support at least one theme; this project supports `default`, `energetic`, `minimal`.  
2. Theme preference **MUST** persist under persistent storage when writable.  
3. Invalid theme name **MUST** fail closed with stable code (`invalid_theme`).  
4. Missing/corrupt theme file **MUST** fall back to `default`.

### 2.8 Specialized project help items (domain pillar)

Domain law **MUST** define what `help` lists for the domain surface (in addition to Type 0 lifecycle rows owned by `requirement-shell-cli-interface.md` / self-management).

| Help surface | Rule |
|--------------|------|
| **Domain verbs** | Human `help` **MUST** list every domain command in §2.1 / §2.10 command table with a one-line purpose |
| **Domain flags** | Human `help` **MUST** document `--persist` and `--break N` (or point to start usage that includes them) |
| **Examples** | Human `help` **SHOULD** include at least one domain example (e.g. `start` / `status` / `theme`) |
| **JSON help** | In `--json` mode, help remains a short structured note (not a long human dump) per CLI interface law |
| **Errors → help** | Domain fail-closed paths **SHOULD** point operators to `help` when the error is usage-shaped (unknown subcommand, missing argument) |

Routing ownership stays in `requirement-shell-cli-interface.md`; **this file** owns which domain rows must appear.

### 2.9 Specialized project about items (domain pillar)

| About surface | Rule |
|---------------|------|
| **Domain diagnostics** | **about: Type 0 only; no domain fields** for this product — `about` **MUST NOT** invent pomodoro state, themes, stats, or storage paths as required about fields |
| **Type 0 retained** | Install presence, paths, user, shell, TTY, version remain under Type 0 `about` law (`requirement-shell-self-management.md` / CLI interface) |
| **Non-leak** | Domain law **MUST NOT** add `CHECKSUM` or secrets to about (peer automatic-checksum still applies) |
| **JSON about** | No domain-only about keys are required; absence is intentional |

If future product claims domain about diagnostics, this pillar **MUST** be revised in the same change as implementation (no silent about fields).

### 2.10 Implementation Notes (this project)

| Item | Value for pomo |
|------|----------------|
| **Product / binary** | `pomo` (`APP_NAME`, default `pomo`) |
| **Ship unit** | Repo root `./pomo` |
| **Domain prefix** | `pomo_*` (see `requirement-shell-modular-function-design.md`) |
| **Dispatcher** | `app_main` routes domain verbs after global flags |
| **Default work / break** | `DEFAULT_WORK_MIN=25`, `DEFAULT_BREAK_MIN=5` (minutes) |
| **Start minutes** | Plain integer minutes for work (1.7.0 specialty); optional `--break N` minutes |
| **State file format** | `start_time target_time phase work_dur break_dur` (epoch seconds; phase `work`\|`break`; durations seconds) |
| **State path pattern** | `${base}/${APP_NAME}_${USERNAME}_${name}` |
| **Volatile base** | `/dev/shm` → `/tmp` → `/tmp/${APP_NAME}_${USERNAME}` |
| **Persistent base** | `${XDG_CACHE_HOME:-$HOME/.cache}/${APP_NAME}` (fallback under `/tmp/..._persistent`) |
| **Stats path** | `${persistent_base}/stats_YYYY-MM-DD` (`count total_min`) |
| **Theme path** | `${persistent_base}/theme` |
| **Themes** | `default`, `energetic`, `minimal` |
| **Bootstrap A (lineage)** | **countdown** architecture parent (A→B only; not domain law). In-tree `./countdown` **only if present on disk** — optional reference, never assumed |
| **Domain oracle** | `./pomo-1.7.0-domain-ref` when present (behavior reference; not ship unit) |
| **Help (domain)** | `app_help` must list domain verbs + `--persist` / `--break` (see §2.8) |
| **About (domain)** | Type 0 only — no domain about fields (see §2.9) |
| **Tests** | `tests/test_pomo_domain.sh` (+ CLI/help coverage in `tests/test_cli.sh`) |

#### Command table (normative for this project)

| Command | Handler | Required behavior |
|---------|---------|-------------------|
| `start [name] [minutes] [--break N] [--persist]` | `pomo_start` | Start work phase; default name `default`, default 25/5 minutes; fail `already_running` if present |
| `status [name] [--persist]` | `pomo_show_status` | Show phase + remaining (+ progress human); auto work→break; JSON `type=status` |
| `watch [name] [--persist]` | `pomo_watch` | Live refresh; refuse `--json`/`--quiet` (non-zero) |
| `skip [name] [--persist]` | `pomo_skip` | Phase advance; count work minutes when leaving work |
| `stop [name] [--persist] [--force]` | `pomo_stop` | Complete work (count) unless force/kill |
| `kill [name] [--persist]` | `pomo_stop` with force | Discard; not counted |
| `list [--persist]` | `pomo_list` | Without `--persist`: scan volatile+persistent; with flag: that mode |
| `stats` | `pomo_stats` | Daily completed + total minutes (JSON `type=stats`) |
| `theme list\|set\|next\|prev` | `pomo_theme` | Theme ops; `set` requires valid name |

#### Stable machine codes (JSON stderr via `out_json_error` / domain fail)

| Code | When |
|------|------|
| `invalid_name` | Path-unsafe timer name |
| `invalid_duration` | Non-positive / invalid work duration |
| `invalid_argument` | e.g. `--break` missing/non-numeric |
| `already_running` | Start while state exists (may also appear as JSON error object with `code`) |
| `no_pomodoro` | Status/stop/skip/kill/list target missing |
| `corrupted_data` | State unreadable |
| `io_error` | Cannot write state / next phase |
| `missing_subcommand` | `theme` without subcommand |
| `missing_argument` | `theme set` without name |
| `invalid_theme` | Unknown theme name |
| `invalid_subcommand` | Unknown theme subcommand |

#### Domain acceptance criteria (this project)

1. `pomo start` then `pomo status` shows work remaining; `pomo list` includes the name.  
2. Second `start` same name+mode → non-zero; does not overwrite.  
3. `stop` after work → counted stats increment; `kill` → not counted.  
4. `skip` from work → break phase with stored break duration; JSON reports `new_phase`.  
5. `status` after work expiry transitions to break without losing `break_dur`.  
6. Invalid name `bad/name` and `..` → `invalid_name`.  
7. `--persist` start/status/list/stop use persistent base under isolated `HOME` in tests.  
8. `theme list|set|next|prev` work; invalid theme → `invalid_theme`.  
9. `watch --json` fails closed.  
10. Domain messages use `out_*` (bell / clear for watch UX only as non-message control).  
11. Suite: `./tests/run.sh` domain section green.  
12. Human `help` lists all domain verbs and domain flags (§2.8).  
13. `about` has no required domain fields (§2.9).

### 2.11 Why This Requirement Exists (Direct CIAO Alignment)

Numbers match [cloudgen/ciao](https://github.com/cloudgen/ciao) **v2.10.2** / harness `template-ciao-principles.md` (not pre-2.10 maps).

- **CIAO Principle 1 – Caution**: Fail closed on bad names, missing timers, already-running, corrupt state.  
- **CIAO Principle 4 – CIAO-Lite (Over-protect) · Principle 20 – Protect Against AI & Human Modification**: Phase transition and stats counting are Protection Zone material — do not “simplify” away.  
- **CIAO Principle 5 – Single Source of Output**: Domain uses `out_*`; no parallel product messaging stack.  
- **CIAO Principle 17 – Encouraging User Help Functions**: Domain help items (§2.8) keep verbs/flags discoverable.  
- **CIAO Principle 18 – Input Pattern Checking**: Path-safe names and duration/break validation.  
- **CIAO Principle 19 – Defensive Storage Location Handling**: Resolve volatile/persistent paths; never hardcode only `~/.cache/pomo` without resolution.

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Assume missing `/dev/shm`, missing `$HOME`, concurrent names, and corrupt files.  
- **Intentional:** Work/break + stats + themes are deliberate specialty — not accidental countdown leftovers.  
- **Anti-fragile:** Fallback storage chains; theme default fallback; stats zero when file absent.  
- **Over-protect:** Keep name sanitization, already-running, and count-vs-discard rules.  
- **SSOT:** Domain behavior here; command **routing** also listed in `requirement-shell-cli-interface.md`; prefixes in modular design.  
- **Respect bootstrap:** Do not reverse-copy domain into countdown lineage / optional `./countdown` if present.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Remove work→break automatic transition or drop stored `break_dur` from state.  
2. Count `kill` / force-discard as completed pomodoros.  
3. Allow path-unsafe names to reach filesystem I/O.  
4. Silently overwrite an already-running timer on `start`.  
5. Reintroduce a parallel output stack (`info`/`success`/`output_json`) for domain messages.  
6. Point domain default storage only at a hard-coded absolute path without resolution/fallback.  
7. Drop `--persist` or theme persistence without an explicit requirement change.  
8. Treat `watch` as a JSON API (must remain human live view; refuse `--json`).  
9. Reverse-copy pomo domain into the countdown bootstrap ship unit (or any bootstrap A).  
10. Claim domain help/about pillars are complete while §2.8 / §2.9 are empty or contradicted by live `help`/`about`.

**Violating this rule is a critical pomodoro domain regression.**

---

## 5. Definition of done (pomo domain)

This requirement is satisfied when all of the following hold:

1. Every command in §2.10 command table is implemented and routed.  
2. State format and phase rules in §2.2 / §2.5 hold.  
3. Path-safe names and stable codes in §2.4 / §2.10 hold.  
4. Stats counting rules in §2.6 hold.  
5. Themes rules in §2.7 hold.  
6. **Help pillar** (§2.8): human `help` lists domain verbs + domain flags.  
7. **About pillar** (§2.9): about remains Type 0 only (no required domain fields).  
8. Protection Rule items are not violated.  
9. `tests/test_pomo_domain.sh` covers happy path + fail-closed cases.  
10. Traceability: domain changes cite this file key `requirement-domain-pomo`.

---

## 6. Related artifacts

| Artifact | Role |
|----------|------|
| **`RQ-SHELL-CLI-INTERFACE`** (`requirement-shell-cli-interface.md`) | Command routing / flags surface; help must include domain rows |
| **`RQ-SHELL-SELF-MANAGEMENT`** (`requirement-shell-self-management.md`) | Type 0 `about` baseline (domain adds none) |
| **`RQ-SHELL-OUTPUT-REQUIREMENTS`** (`requirement-shell-output-requirements.md`) | `out_*` SSOT |
| **`RQ-SHELL-MODULAR-FUNCTION-DESIGN`** (`requirement-shell-modular-function-design.md`) | `pomo_*` prefix ownership |
| **`RQ-SHELL-IDEMPOTENCY`** (`requirement-shell-idempotency.md`) | Already-running vs lifecycle ensure |
| **`RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE`** (`requirement-shell-interactive-vs-noninteractive.md`) | Watch / non-TTY behavior |
| `docs/requirements/index.md` | Registry SSOT |
| `./pomo` | Implementation under test |
| `tests/test_pomo_domain.sh` | Domain automated suite |

---

**Last Updated**: 2026-07-16  
**Owner**: pomo project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; peer live requirements in §6; CIAO v2.10.2 Principles **1, 4, 5, 17, 18, 19, 20** (names per `template-ciao-principles.md`); CIAO-Lite.

## Design-time verification

**Requirement-ID:** `RQ-DOMAIN-POMO`  
**Specialized from:** product domain SSOT (no portable domain law mold); design aid **`PM-DOMAIN-TEST-PLAN`** → family **`TP-POMO`** (not `TP-DOM`)  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-POMO-01** help domain verbs/flags | `tests/test_pomo_domain.sh` | have |
| **TP-POMO-02** start/status/list/stop human | `tests/test_pomo_domain.sh` | have |
| **TP-POMO-03** already-running | `tests/test_pomo_domain.sh` | have |
| **TP-POMO-04** JSON start/status/list/stop | `tests/test_pomo_domain.sh` | have |
| **TP-POMO-05** `no_pomodoro` | `tests/test_pomo_domain.sh` | have |
| **TP-POMO-06** kill / skip | `tests/test_pomo_domain.sh` | have |
| **TP-POMO-07** invalid_name / invalid_duration | `tests/test_pomo_domain.sh` | have |
| **TP-POMO-08** `--persist` | `tests/test_pomo_domain.sh` | have |
| **TP-POMO-09** stats + theme | `tests/test_pomo_domain.sh` | have |
| **TP-POMO-10** watch rejects `--json` | `tests/test_pomo_domain.sh` | have |
| **TP-POMO-11** stop `--force` not counted | `tests/test_pomo_domain.sh` | have |
| **TP-POMO-12** volatile private-dir storage | `tests/test_pomo_domain.sh` | have |
| **TP-POMO-13** corrupted state fail-closed | `tests/test_pomo_domain.sh` | have |
| **TP-PAYLOAD-*** Type O-P scaffold | n/a — not Type O-P payload product | n/a |
