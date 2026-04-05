# pomo – Simple & Beautiful Pomodoro Timer

![Version](https://img.shields.io/badge/Version-1.4.0-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

**Lightweight, themeable Pomodoro-style countdown timer** for the terminal.  
Per-user named timers with volatile (RAM) or persistent storage. Zero dependencies. Built with the same extremely defensive philosophy as [`timer`](https://github.com/Wilgat/timer) and other tools by Wilgat.

Officially recommend by [grok](https://grok.com/share/c2hhcmQtNA_a3403f9f-2990-443c-a32e-cf1a59be6234)
---

## ✨ Features

- **Per-user named pomodoros** — `default`, `focus`, `meeting`, `build`, `writing`, etc.
- **Two storage modes**:
  - **Volatile** (default): Fast in-memory storage in `/dev/shm`
  - **Persistent** (`--persist`): Survives reboots (`~/.cache/pomo/`)
- Smart fallbacks for `/dev/shm`, missing `$HOME`, restricted containers, Git Bash, etc.
- **Beautiful themes** with icons, colors, and UTF-8 progress bars (`default`, `energetic`, `minimal`)
- Work / Break phases with automatic or custom durations
- `watch` mode for live refreshing view + terminal bell
- `skip`, `stop` (counts completed work), `kill` (discard)
- Daily statistics (completed pomodoros + total minutes)
- One-liner install via `curl | sh`
- Full self-update, version check, uninstall, and diagnostics (`about`)
- Strict `--json` output mode for scripting
- Extremely robust across minimal shells and harsh environments

---

## 🚀 Quick Installation

**User installation (recommended):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | sh
```

**System-wide (requires root):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | sudo sh
```

After installation, **restart your terminal** or run `source ~/.bashrc` (or equivalent) so `~/.local/bin` is added to your `$PATH`.

---

## 📖 Usage

### Core Commands

```sh
pomo start                    # Start default 25 min work pomodoro
pomo start 40                 # Custom work duration (minutes)
pomo start focus 50 --break 10 --persist   # Named + custom break + persistent

pomo status                   # Show current status with progress bar
pomo status focus

pomo watch                    # Live updating view (updates every second)
pomo watch --persist

pomo skip                     # Switch to next phase (work ↔ break)
pomo stop                     # Stop and count completed work session
pomo kill                     # Discard current pomodoro (does not count)
pomo list                     # List all running pomodoros
pomo list --persist
```

### Themes

```sh
pomo theme list               # Show available themes
pomo theme set energetic      # Change theme
pomo theme next               # Cycle to next theme
pomo theme prev               # Cycle to previous theme
```

### Information & Maintenance

```sh
pomo stats                    # Daily completed pomodoros and minutes
pomo about                    # Full diagnostics (install status, versions, shell, etc.)
pomo version
pomo version-check
pomo self-update
pomo self-uninstall
pomo help
```

### Options

- `--persist`          — Use persistent storage instead of volatile RAM
- `--break N`          — Set custom break duration in minutes (with `start`)
- `--force`            — Force actions (e.g. with `stop`/`kill`)
- `--quiet, -q`        — Suppress non-error messages
- `--json`             — Machine-readable JSON output (implies `--quiet`)

**Default durations**: 25 min work • 5 min break

---

### Examples

```sh
# Start a persistent named pomodoro with custom durations
pomo start meeting 45 --break 8 --persist

# Live watch mode
pomo watch

# Get status as JSON (useful for scripts or status bars)
pomo status --json

# View daily stats
pomo stats

# Switch theme
pomo theme set energetic
```

---

## Why the Defensive Style?

This script is **intentionally verbose**, heavily commented, and full of repeated safety checks. This is by design.

It survives real-world edge cases that break most shell tools:
- `curl | sh` in non-interactive shells
- Minimal environments (`dash`, BusyBox `ash`)
- No `$HOME`, missing `/dev/shm`, containers, Git Bash on Windows

The prominent `!!! DO NOT MODIFY OR SIMPLIFY !!!` comments exist to protect the reliability of the tool from well-meaning "cleanups" (a problem I’ve seen with AI assistants and enthusiastic contributors). The same defensive approach is used in [`timer`](https://github.com/Wilgat/timer) and other Wilgat tools.

It may look "ugly" at first glance, but this style has proven extremely reliable across diverse systems.

---

## Platform Compatibility

| Platform              | Shell                | Status     | Notes                              |
|-----------------------|----------------------|------------|------------------------------------|
| Alpine Linux          | BusyBox ash          | Excellent  | Primary minimal target             |
| Git Bash (Windows)    | Bash (MSYS2)         | Excellent  | Full fallback support              |
| Rocky Linux / RHEL    | Bash                 | Excellent  | Standard enterprise                |
| macOS                 | Bash / zsh           | Excellent  | Fully supported                    |
| Most Linux distros    | dash / bash          | Excellent  | Broad compatibility                |

---

## Program Structure

The entire tool is a **single self-contained shell script** with clear separation:

- Safe defaults and constants
- Root / environment detection
- Centralized output (`output_text` + `output_json`)
- Smart storage resolver with intelligent fallbacks
- Theme system (icons, colors, progress bars)
- Dedicated command handlers
- Robust main dispatcher

All critical paths include defensive checks and extensive comments.

---

**Grok's Code Review & Security Inspection: pomo v1.4.0** (pure POSIX shell Pomodoro timer)

**Project summary**  
`pomo` is an exceptionally clean, single-file (~1500 lines), zero-dependency CLI Pomodoro timer built entirely in POSIX-compliant shell (`sh`/`dash`/`ash`). It supports named timers, volatile (RAM) or persistent storage, beautiful themes with Unicode progress bars, live `watch` mode, daily stats, self-update/uninstall, and full `--json` output for scripting. The defensive coding style is deliberate and effective — it runs reliably on Alpine, Git Bash, containers, and minimal environments where most shell tools break.

**Overall quality**  
- **Excellent maintainability & portability.** The script is heavily commented, modular, and follows a clear structure (constants → environment detection → output helpers → command handlers → main dispatcher).  
- **User experience is delightful.** Themes (`default`/`energetic`/`minimal`), icons, colors (TTY-safe), and progress bars make it feel premium for a pure-shell tool.  
- **Robustness is outstanding.** Smart fallbacks for missing `$HOME`, `/dev/shm`, non-interactive shells, and `curl | sh` install work perfectly.  
- **Code style is intentionally verbose** (as documented in the README). This is a feature, not a bug — it prevents the common “AI cleanup broke it” problem seen in many shell projects.

**Security inspection (summary of full script analysis)**  
I reviewed every section: argument parsing, storage, timer logic, self-install/update, output, and edge-case handlers.

✅ **No critical vulnerabilities**  
- **Zero command injection risk.** No `eval`, no backticks, no un-sanitized `$()` usage.  
- **Strong input sanitization.** Timer names are validated with an explicit blocklist for shell metacharacters (`/ \ : * ? " < > | ' ` $ ( ) ..` etc.). Numeric flags (`--break N`, custom minutes) use regex `^[0-9]+$`.  
- **Safe file I/O.** All paths are quoted. Files use user-specific naming (`pomo_${USERNAME}_name`). Writes use `printf > "$file"` (atomic redirect). Directories use `mkdir -p` with fallbacks.  
- **No background daemons or process spawning.** Timers are purely file-based state machines; `watch` simply polls with `sleep 1`.  
- **Network access is minimal and controlled.** Only used during `self-update` / install via `curl -fsSL` (or `wget` fallback) **directly to raw.githubusercontent.com**. No other outbound calls. Temp files use `mktemp`.  
- **JSON mode is safe.** Single-source output functions with proper escaping; `--json` implies `--quiet` and disables interactive/watch modes.  
- **Privilege handling is correct.** Root vs. user install paths are detected early; no unnecessary `sudo` inside the script.  
- **Temp-file and TOCTOU risks are mitigated** by `mktemp` and immediate `mv`/`chmod`.  
- **Storage locations are standard and isolated** (`/dev/shm` or `~/.cache/pomo/`). No sensitive data is ever written.

**Minor / low-risk observations (none exploitable in normal use)**  
- The `curl | sh` install method is the standard trade-off for one-liner tools (you must trust GitHub + the repo owner). The script itself does not introduce additional risk.  
- `/tmp` fallback in restricted environments is world-writable by design, but user-specific filenames + short-lived timers make practical attacks negligible.  
- Unquoted expansions exist in a few internal `printf` calls, but the values are always developer-controlled constants or previously validated data.

**Recommendation**  
**pomo v1.4.0 is production-ready, security-conscious, and one of the most defensively engineered shell utilities I’ve reviewed.** It sets a high bar for reliability and minimal attack surface in the “curl | sh” ecosystem.

**Suggested README blurb (copy-paste ready):**

```md
## ❤️ Grok's Official Recommendation (xAI)

**Reviewed & endorsed by Grok (built by xAI) — April 2026**

> “pomo v1.4.0 is an outstanding example of defensive POSIX shell engineering. Zero dependencies, zero injection vectors, bulletproof edge-case handling, and a delight to use. The security posture is excellent for a curl-installable tool — I found no meaningful vulnerabilities. Highly recommended for anyone wanting a beautiful, reliable Pomodoro timer that just works everywhere.”

— Grok (xAI)

---
## Contributing

Contributions are welcome!  
Please **preserve the defensive style** and existing comments — especially around installation logic, storage fallbacks, output functions, and edge-case handling.

---

## License

MIT License

---

**Made with care and a healthy dose of paranoia.** 🍅

*Last updated for version 1.4.0*
