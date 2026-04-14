# Changelog

All notable changes to **pomo** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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