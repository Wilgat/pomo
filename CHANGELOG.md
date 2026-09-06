# Changelog

All notable changes to **pomo** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.2] - 2026-09-06

### Added
- **Termux as a target system:** detect helpers `pomo_is_termux`, `pomo_is_git_bash`, `pomo_is_windows_cmd`, `pomo_is_normal_user_only_cli`; `pomo_target_system` names `termux` / `git-bash` / `windows-cmd` / `posix`.
- On Termux, install uses `$PREFIX/bin` (already on `PATH`) instead of `/usr/local/bin`; volatile storage falls back through `TMPDIR` and `$PREFIX/tmp` when `/dev/shm` is missing.
- `about` reports the target (human + JSON `target` / `normal_user_only`).
- Related shell requirements include **Under command line for normal user only** (Type 1/2 unused on Termux / Git Bash / Windows cmd).
- **TP-CLI-13:** Termux and Git Bash detect; help must not recommend `sudo curl`.

### Changed
- **Help review:** leftover “help for countdown” header removed; help names the live target; install line is this-login on Termux/Git Bash/Windows cmd; **MUST NOT** advertise `sudo curl | sh` on that class; `inst_maybe_install` uses the same ceiling.
- README Platform Compatibility lists Termux; system-wide `sudo` one-liner is POSIX-host only.

### Security
- Companion `pomo.sha256` regenerated for 2.0.2 ship-unit bytes.

### Docs (folded from post-2.0.1 Unreleased)
- Product **README** rewritten for people first (who runs what; minutes unit; automatic SHA-256 link/value/result). Grammar fix (“Please refer to”). Section order matches the product kit (Features → Quick Installation → Usage → Examples → Platform Compatibility → Related Projects → Contributing → License → Last Update). Defensive-style and historical Grok notes folded into Contributing / Related Projects.
- Every Active requirement now has **§1.1 Human-facing** (one sentence, three boxes, includes/excludes, practice). Catalog codes are no longer the only Purpose lead.
- Domain law **`RQ-DOMAIN-POMO`**: lock-in finding that CLI duration unit is **whole minutes**, shortest valid work duration is **1 minute** (not 1 second); `0` → `invalid_duration` (§2.2.1).
- Test plan and suites adopt **harness ID notation**: portable families **TP-CLI** / **TP-LC** / **TP-CSUM** / **TP-U** / **TP-CURL**, domain-subject family **`TP-POMO-*`** (retired bare `TP-01…23`).
- Lifecycle suite parity: self-update when remote newer (**TP-LC-05b**), version-check network failure (**TP-LC-11**), uninstall PATH cleanup (**TP-LC-07**).
- Requirements declare **`RQ-*` Requirement-IDs** (registry + headers), Related peers cite **`RQ-*`**, and each Active REQ has **Design-time verification** (**TP-*** → `tests/*`).

### Added
- Class law **`RQ-CLASS-SOFTWARE-DEV`** (`requirement-class-software-dev.md`): software-development residual (POSIX `/bin/sh`, no dest approver, no dest fences); coding-style **MUST** pointer.
- Coding-style **`RQ-SHELL-SCRIPT-CODING`** (`requirement-shell-script-coding.md`): specialize-in home; own-or-point to existing shell REQs.
- `reviews/requirement-test-matrix.md` — `RQ-*` → TP families; coverage report `reviews/reports/2026-09-06-readme-req-coverage.md`.
- Software-dev housekeeping (2026-08-24): H2 rematch NEW=0 UPDATE=4 (dest maps only, rebound), DEST_ONLY=3; dest-SSOT map rebind (9 Active REQs recognized); tests PASS=239 FAIL=0 SKIP=1; no product-source change so no auto-commit/push.
- Local harness H2 (2026-08-24): from RAM `GENESIS_SSOT` (NEW=58 UPDATE=176 DEST_ONLY=3), dest-SSOT map rebind (9 Active REQs recognized); no product-source change.
- Software-dev housekeeping (2026-08-19): H2 rematch NEW=0 UPDATE=4 (dest maps only, rebound), DEST_ONLY=3; dest-SSOT map rebind (9 Active REQs recognized); tests PASS=239 FAIL=0 SKIP=1; no product-source change so no auto-commit/push.
- Local harness H2 (2026-08-19): from RAM `GENESIS_SSOT` (NEW=75 UPDATE=81 DEST_ONLY=3), dest-SSOT map rebind (9 Active REQs recognized); no product-source change.
- Local harness H2 sync from genesis-template (policies, id-notation, proof molds, software-dev housekeeping skill) — gitignored Pattern A surfaces only.
- Software-dev housekeeping (2026-08-13): H2 from RAM `GENESIS_SSOT` (NEW=73 UPDATE=67 DEST_ONLY=2), dest-SSOT map rebind (9 Active REQs recognized), tests PASS=239 FAIL=0 SKIP=1; no product-source change so no auto-commit/push.
- Software-dev housekeeping (2026-08-11): re-pull portable harness from RAM `GENESIS_SSOT`, dest-SSOT map rebind (9 Active REQs recognized), H1/H2 backup ignore patterns on product `.gitignore`.
- **`tests/test_online_curl_install.sh`** — full **TP-CURL-01…09** (local channel Core; optional public via flag); **TP-U-03** via TP-CURL-04.
- Shared dual-storage family **TP-STORAGE-01..03** (volatile path, `--persist`, corrupted state) — same family on **timer/countdown/pomo** (not pomo-only); former **TP-POMO-08/12/13**.
- Tests aligned to proof molds: **TP-CURL** catalog order; **PM-DOMAIN** §4.2 **TP-STORAGE** + §4.3.3 **TP-POMO** ops.

## [2.0.1] - 2026-07-17

### Changed
- Domain product law basename: **`requirement-domain-pomo.md`** (Area **`domain`**); was mis-prefixed `requirement-shell-pomo-domain.md`; registry, peers, ship-unit ALIGNMENT, and tests map updated.
- Domain SSOT adds explicit **help** and **about** pillars (about: Type 0 only; no domain fields).
- Automatic-checksum requirement: Definition of done; CIAO v2.10.2 principle labels clarified.
- Requirements folder README aligned to live registry vocabulary (`Active`, flat `requirement-*` keys).
- README install integrity: optional pin loads live `pomo.sha256` (no stale hard-coded hash); automatic companion remains primary.
- README architecture: countdown lineage only; in-tree `./countdown` optional if present (stay-honest).
- Ship unit header: `APP_NAME` default **pomo** (not countdown residue); version **2.0.1**.

### Added
- Public product review surface under `reviews/` (what-to-review, test-plan, lessons, index, full-product report + fix report).

### Security
- Companion `pomo.sha256` regenerated for 2.0.1 ship-unit bytes; SECURITY supported-versions table updated.

## [2.0.0] - 2026-07-14

### Changed
- **Major architecture specialize:** product ship unit rebuilt from **countdown** bootstrap (A → B) with full **pomo 1.7.0** domain surface.
- Version **2.0.0**; `APP_NAME=pomo`, channel `Wilgat/pomo`, companion `pomo.sha256`.
- Output SSOT is countdown-family `out_*` (not the legacy `info` / `success` / `output_json` stack).
- Install / lifecycle is `inst_*` / Type O empty-argv install-ensure from countdown (`app_main` always runs under pipe).
- Philosophy alignment documented as **[CIAO](https://github.com/cloudgen/ciao) v2.10.2** / [CIAO-Lite](https://github.com/cloudgen/ciao-lite).

### Added (domain from 1.7.0 specialty)
- Work/break phases with automatic transition and terminal bell
- Named timers, volatile `/dev/shm` and `--persist` storage
- Themes: `default`, `energetic`, `minimal` (`theme list|set|next|prev`)
- `watch`, `skip`, `stats`, themed `status` progress bars
- Daily completed-pomodoro statistics
- Domain flags: `--break N`, `--persist` (with Type 0 `--quiet` / `--json` / `--force` / `--debug`)

### Added (product engineering surface)
- POSIX CI suite under `tests/` (`run.sh`, CLI surface, install lifecycle on local channel, pomodoro domain)
- Product-root [`SECURITY.md`](./SECURITY.md) (reporting, CIAO security principles, honest automatic-checksum trust bounds)
- Product law: nine live `docs/requirements/requirement-shell-*.md` files, including **`requirement-shell-pomo-domain`**

### Security / Defensive
- Automatic companion-digest integrity (`${SCRIPT_URL}.sha256`) with transparent link / value / result; optional `CHECKSUM` pin secondary
- Path-safe pomodoro names; fail-closed domain codes (`invalid_name`, `already_running`, `no_pomodoro`, …)
- Non-interactive uninstall requires `--force` (`confirm_required`); no silent fake cancel success
- Downgrade refuse without `--force` on `self-update`

### Preserved
- In-tree `./countdown` bootstrap ship unit (reference; not overwritten by pomo)
- Domain oracle archive: `pomo-1.7.0-domain-ref` (local reference of 1.7.0 body)

### Requirements
- Retargeted `docs/requirements/*` Implementation Notes to pomo
- CLI interface lists Type 0 + domain routing; domain semantics owned by `requirement-shell-pomo-domain.md`

## [1.7.0] - 2026-04-20

### Changed
- Bumped version to **1.7.0** (header, `VERSION` constant, references, and last reviewed date)
- Updated JSON output examples and `about` command diagnostics to reflect new version
- Minor wording and date consistency in header comments

### Security / Defensive
- All CIAO-Lite Protection Zones, checksum verification in `perform_self_install_v2()`, centralized output functions, and version awareness logic (`version_gt_v1`, `get_installed_version_v1`) remain fully intact and untouched.

**No functional or behavioral changes** — this is a clean version bump from 1.6.0.

## [1.6.0] - 2026-04-14

### Fixed
- `maybe_install()` now correctly uses `Wilgat/pomo` repository instead of leftover `cloudgen/grokrec`
- Improved logic for non-interactive installs (`curl | sh`)
- Better messaging when auto-installing in non-TTY environments

### Changed
- `maybe_install()` hardened to strictly respect `prompt_yes_no()` as single source of truth
- Minor cleanup in variable defaults and comments for consistency
- Bumped version to **1.6.0** everywhere (badge + last updated).
- Added a new **"Version Awareness (v1.6.0+)"** section explaining the improved behavior.
- Updated `version-check` description in Usage.
- Fixed repository references to `Wilgat/pomo`.
- Minor wording improvements for clarity and consistency.

## [Unreleased] / 1.5.0 (WIP)

### Added
- Full theming system with three built-in themes:
  - `default` (classic tomato style)
  - `energetic` (dynamic & motivating)
  - `minimal` (zen & clean)
- Theme commands: `pomo theme list`, `pomo theme set <name>`, `pomo theme next`, `pomo theme prev`
- Themed icons, phase-specific colors, and customizable progress bars (filled/empty characters per theme)
- Pure POSIX `version_gt()` function for correct semantic version comparison (no longer relies on string equality)
- Strong downgrade protection in `self-update` and `version-check` (prevents accidental downgrade from development versions)
- Centralized output system: `output_text()` as single source of truth for all human-readable output and `output_json()` for strict machine-readable JSON
- Much stricter and more complete `--json` mode with proper number handling, escaping, and consistent object structure
- Improved storage resolver with better fallbacks for volatile (`/dev/shm` → `/tmp`) and persistent modes
- Enhanced argument parsing for `pomo start` (better handling of name vs duration vs flags)
- Robust daily statistics with persistent storage
- `about` command with detailed diagnostics (installation status, versions, shell detection, etc.)
- Heavy defensive coding and explicit warnings to protect against over-simplification by AI assistants or future maintainers

### Changed
- `version_check()` and `self_update()` now use the new `version_gt()` function
- Output discipline significantly improved — all text and JSON now go through dedicated functions
- Better handling of edge cases (missing `$HOME`, non-writable `/dev/shm`, non-interactive shells, curl | sh installs, etc.)
- Progress bar rendering rewritten with `render_bar()` and `repeat_string()` for reliable UTF-8 support in dash/ash/busybox

### Fixed
- Version comparison logic (previously could misbehave on versions like `2.10.0` vs `2.9.99`)
- Several potential issues in storage path resolution and multi-user environments
- JSON output consistency and correctness

### Notes
- This release focuses on **reliability**, **user experience** (themes), and **machine-friendliness** (JSON).
- The script remains 100% POSIX sh compatible (works on Alpine ash, dash, Git Bash, etc.) with zero external dependencies.

## [1.4.0] - 2026 (Previous Stable)

### Initial stable release
- Lightweight per-user Pomodoro timer (volatile in RAM or persistent on disk)
- Core commands: `start`, `status`, `watch`, `skip`, `stop`, `kill`, `list`, `stats`
- Self-install, self-update, and self-uninstall support via `curl | sh`
- Basic quiet mode and JSON output
- Daily pomodoro statistics
- Designed for maximum portability across shells and environments

---

**Previous versions not documented in detail.**

For full commit history, see the [GitHub repository](https://github.com/Wilgat/pomo).