# pomo – Simple & Beautiful Pomodoro Timer

![Version](https://img.shields.io/badge/Version-2.0.1-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--engineered)-purple.svg)](https://github.com/cloudgen/ciao)
[![Shell](https://img.shields.io/badge/Shell-POSIX%20sh-orange?style=flat-square)]()
[![Made with ❤️](https://img.shields.io/badge/Made%20with%20❤️-CIAO-00AEEF?style=flat-square)](https://github.com/cloudgen/ciao)
[![GrokRec](https://img.shields.io/badge/GrokRec-Reviewed-0A66C2?logo=ai&logoColor=white)](https://github.com/Wilgat/pomo/blob/main/RECOMMENDATION.md)
[![Stars](https://img.shields.io/github/stars/Wilgat/pomo?style=flat-square)](https://github.com/Wilgat/pomo)

Official Recommendation from [grok](https://grok.com/c/dd443680-0c83-41c4-a501-8cb0990e3e9b?rid=1063a0bb-9371-4ad3-91d6-649c3b58bc45). The review is submitted by [grokrec](https://github.com/cloudgen/grokrec). Please refers to the [downloaded copy](https://github.com/Wilgat/pomo/blob/main/RECOMMENDATION.md) .

**A lightweight, themeable Pomodoro timer for the terminal.**  
Supports named timers, volatile (RAM) or persistent storage, beautiful themes, live watch mode, daily statistics, and full self-management (install/update/uninstall).  

Zero external dependencies. Written in pure POSIX `sh` for maximum portability.

This project is built using [CIAO](https://github.com/cloudgen/ciao) **v2.10.2** (Caution • Intentional • Anti-fragile • Over-engineered) and [CIAO-Lite](https://github.com/cloudgen/ciao-lite) (Simplicity but Safety).

**Architecture (v2.0.1):** Type 0 self-management and install channel inherited from the **countdown** bootstrap lineage (A→B only — **do not reverse-copy**). An in-tree `./countdown` reference ship unit is **optional** (only if that file exists on disk; never assumed). Pomodoro domain features (work/break, themes, watch, stats) ported from **pomo 1.7.0** onto that architecture.


---

## ✨ Features

- **Per-user named pomodoros** (`default`, `focus`, `meeting`, `writing`, etc.)
- **Two storage modes**:
  - **Volatile** (default): Fast in-memory storage in `/dev/shm`
  - **Persistent** (`--persist`): Survives reboots (`~/.cache/pomo/`)
- Smart fallbacks for missing `/dev/shm`, `$HOME`, containers, and restricted environments
- **Three beautiful themes** (`default`, `energetic`, `minimal`) with custom icons, colors, and UTF-8 progress bars
- Automatic work → break phase transition with terminal bell
- `watch` mode for live refreshing view
- Daily statistics (completed pomodoros + total minutes today)
- Strict `--json` mode for scripting and status bars
- One-liner install, self-update, self-uninstall, and diagnostics
- Extremely robust across minimal shells (`dash`, BusyBox `ash`), Git Bash, Alpine, and containers

---

## 🚀 Quick Installation

**Recommended one-liner (most users):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | sh
```

**System-wide (root):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | sudo sh
```

**Optional pin install (secondary / CI — not higher trust than automatic companion):**

```sh
# Download the script
curl -fsSL -O https://raw.githubusercontent.com/Wilgat/pomo/main/pomo

# Pin to the published companion for this release (do not hard-code an old hash from docs)
CHECKSUM=$(curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo.sha256 | awk '{print $1; exit}') \
  sh pomo
```

After installation, **restart your terminal** or run `source ~/.bashrc` (or `~/.zshrc`) so `~/.local/bin` is added to your `$PATH`.

> **How verification works** (install integrity):
> - **Default (recommended one-liner):** no `CHECKSUM` → automatic companion fetch of `${SCRIPT_URL}.sha256` with transparent link / value / result (best-effort if companion missing).
> - **Optional pin:** `CHECKSUM=…` set → strict verify against that digest (secondary path; same-origin pin is **not** higher assurance than automatic companion).
> - **Mismatch** → installation aborts (no silent failure).
> - Publish rule: after changing `./pomo`, regenerate companion `pomo.sha256` so channel and pin stay aligned.

---

## 📖 Usage

### Basic Commands

```sh
pomo start                    # Start 25 min work (default)
pomo start 40                 # Custom work duration in minutes
pomo start focus 50 --break 10 --persist   # Named + custom break + persistent
```

```sh
pomo status                   # Show current status + progress bar
pomo watch                    # Live updating view (Ctrl+C to exit)
pomo skip                     # Switch to next phase (work ↔ break)
pomo stop                     # Stop and count as completed work session
pomo kill                     # Discard current pomodoro (does not count)
pomo list                     # List all running pomodoros
pomo stats                    # Daily statistics
```

### Theme Management

```sh
pomo theme list               # Show available themes and current one
pomo theme set energetic      # Change theme
pomo theme next               # Cycle to next theme
pomo theme prev               # Cycle to previous theme
```

### Maintenance & Info

```sh
pomo version
pomo version-check            # Compare with latest release
pomo self-update              # Update to latest version
pomo about                    # Full system diagnostics
pomo help
pomo self-uninstall
```

### Options

- `--persist`       Use persistent storage (`~/.cache/pomo/`)
- `--break N`       Custom break duration in minutes (only with `start`)
- `--force`         Force actions (e.g. with `stop`/`kill`)
- `--quiet`, `-q`   Suppress all non-error output
- `--json`          Machine-readable JSON output (implies `--quiet`)

**Defaults**: 25 min work • 5 min break

---

### Examples

```sh
# Named persistent pomodoro with custom durations
pomo start deep-work 55 --break 10 --persist

# Live watch mode
pomo watch

# JSON status (great for scripts, tmux, waybar, etc.)
pomo status --json

# Switch to a more energetic theme
pomo theme set energetic
```

---

## Why the Defensive Style?

This script is **intentionally verbose** and heavily commented.  
The prominent `!!! DO NOT MODIFY OR SIMPLIFY !!!` warnings exist because this tool is designed to survive harsh environments where most shell scripts break:

- `curl | sh` in non-interactive shells
- Minimal systems (`dash`, BusyBox `ash` on Alpine)
- Missing `$HOME`, no `/dev/shm`, containers, Git Bash

The same **CIAO** philosophy (Caution • Intentional • Anti-fragile • Over-engineered, **v2.10.2**) is used in other Wilgat tools.

It may look over-engineered at first, but this approach has proven extremely reliable in real-world use.

---

## Platform Compatibility

| Platform              | Shell                | Status     | Notes                              |
|-----------------------|----------------------|------------|------------------------------------|
| Alpine Linux          | BusyBox ash          | Excellent  | Primary target for minimalism      |
| Git Bash (Windows)    | Bash (MSYS2)         | Excellent  | Full fallback support              |
| Rocky / RHEL / CentOS | Bash                 | Excellent  | Enterprise environments            |
| macOS                 | Bash / zsh           | Excellent  | Fully supported                    |
| Debian / Ubuntu       | dash / bash          | Excellent  | Broad compatibility                |

---

## Grok's Code Review

**Historical endorsement (v1.7.0, April 2026)** — full text: [`RECOMMENDATION.md`](./RECOMMENDATION.md).

**Current product (v2.0.1)** keeps that defensive spirit under **[CIAO](https://github.com/cloudgen/ciao) v2.10.2** / [CIAO-Lite](https://github.com/cloudgen/ciao-lite): countdown Type 0 architecture (`out_*`, `inst_*`, `app_main`, Type O install-ensure, automatic companion checksum) plus the full pomodoro domain (work/break, themes, watch, stats).

It deliberately stays verbose and heavily protected with explicit "DO NOT MODIFY OR SIMPLIFY" zones, centralized single-source-of-truth output, defensive storage resolution, and transparent install integrity. That design survives harsh runtimes (dash/ash, missing `/dev/shm`, `curl | sh`) and resists AI-assisted over-simplification.

**Key strengths (v2.0.1)**:
- Pure POSIX `sh` with no bashisms
- CIAO v2.10.2 / CIAO-Lite compliance on lifecycle and domain paths
- Path-safe names, safe storage fallbacks, and centralized `out_*` output
- `inst_*` install with automatic companion SHA-256 + optional `CHECKSUM` pin
- `ver_gt` + downgrade protection on `self-update`
- Theming and UX without sacrificing portability or safety
- Automated suite: `./tests/run.sh` (CLI, install lifecycle, domain)

Vulnerability reporting: [`SECURITY.md`](./SECURITY.md).

---

## Related Projects

All projects below follow the same **CIAO** philosophy ([v2.10.2](https://github.com/cloudgen/ciao): Caution • Intentional • Anti-fragile • Over-engineered) and defensive coding style.

### Core Philosophy
- **[CIAO](https://github.com/cloudgen/ciao)** — Defensive programming principles (**v2.10.2**)
- **[CIAO-Lite](https://github.com/cloudgen/ciao-lite)** — Agent contract (Simplicity but Safety)

### Other Tools by Wilgat
- **[countdown](https://github.com/Wilgat/countdown)** — Bootstrap architecture for pomo 2.0.0 (named duration countdowns)
- **[timer](https://github.com/Wilgat/timer)** — Count-up elapsed timers with similar Type 0 design
- **[springboot2](https://github.com/Wilgat/springboot2)** — Production-ready Spring Boot 2 templates
- **[springboot3](https://github.com/Wilgat/springboot3)** — Production-ready Spring Boot 3 templates
- **[certbot-nginx](https://github.com/Wilgat/certbot-nginx)** — Automated Let's Encrypt setup for Nginx
- **[mariadb-galera](https://github.com/Wilgat/mariadb-galera)** — MariaDB Galera Cluster deployment scripts

---

## Contributing

Contributions are welcome!  
Please **preserve the defensive style** and existing safety comments — especially around installation, storage fallbacks, output functions, and edge-case handling.

### Tests

```sh
./tests/run.sh
```

See [`tests/README.md`](tests/README.md) for coverage (CLI surface, install lifecycle, pomodoro domain).

### Security

Vulnerability reporting and install-integrity trust bounds: [`SECURITY.md`](./SECURITY.md).

---

## License

MIT License — see [`LICENSE.md`](./LICENSE.md) for details.

---

**Made with care and a healthy dose of paranoia.** 🍅

*Last updated: 2026-07-17 for version 2.0.1 — aligned to [CIAO](https://github.com/cloudgen/ciao) **v2.10.2**.*
