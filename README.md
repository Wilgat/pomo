# pomo – Simple & Beautiful Pomodoro Timer

![Version](https://img.shields.io/badge/Version-1.4.0-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

**Lightweight, themeable Pomodoro-style countdown timer** for the terminal.  
Per-user named timers with volatile (RAM) or persistent storage. Zero dependencies. Built with the same extremely defensive philosophy as [`timer`](https://github.com/Wilgat/timer) and other tools by Wilgat.

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

## Contributing

Contributions are welcome!  
Please **preserve the defensive style** and existing comments — especially around installation logic, storage fallbacks, output functions, and edge-case handling.

---

## License

MIT License

---

**Made with care and a healthy dose of paranoia.** 🍅

*Last updated for version 1.4.0*
