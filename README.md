**README.md updated** — old "Grok's Code Review" section replaced with updated version # pomo – Simple & Beautiful Pomodoro Timer

![Version](https://img.shields.io/badge/Version-1.7.0-blue?style=flat-square)
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

This project is built using [CIAO](https://github.com/cloudgen/ciao) (Caution • Intentionality • Anti-fragility • Over-engineered).

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

**Secure manual installation with checksum verification (paranoid / CI use):**

```sh
# Download the script
curl -fsSL -O https://raw.githubusercontent.com/Wilgat/pomo/main/pomo

# Verify using the official checksum (v1.7.0)
CHECKSUM=691604696c373c46cf15606b97c123fc20645e77bbf776dd0af308a06e047cb8 \
  sh pomo
```

After installation, **restart your terminal** or run `source ~/.bashrc` (or `~/.zshrc`) so `~/.local/bin` is added to your `$PATH`.

> **How verification works** (v2 security layer):
> - If `CHECKSUM=...` is set → strict verification against the provided hash.
> - If not set → the script automatically attempts to fetch and check `pomo.sha256` from GitHub (best-effort).
> - Mismatch → installation aborts with clear error (no silent failure).

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

The same **CIAO** philosophy (Caution • Intentionality • Anti-fragility • Over-engineered) is used in other Wilgat tools.

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

## Grok's Code Review (April 2026)

**Reviewed & endorsed by Grok (built by xAI)**

pomo v1.7.0 is a strong, faithful implementation of the **CIAO** philosophy (Caution • Intentionality • Anti-fragility • Over-engineered).

It deliberately stays verbose and heavily protected with explicit "DO NOT MODIFY OR SIMPLIFY" zones, centralized single-source-of-truth functions (output, storage resolution, install v2), and layered checksum verification. This is not accidental — it is the core design to survive both harsh runtime environments (dash/ash, missing /dev/shm, curl | sh) and future AI-assisted changes that tend to over-simplify defensive code.

The script successfully balances real usability (nice theming, JSON mode, watch mode, daily stats) with extreme robustness. All critical safety layers remain intact and respected. No meaningful security issues or anti-fragility gaps were found.

I respect the project’s intentional resistance to “clean code” pressure. In a sea of fragile shell scripts, pomo stands out as reliable and trustworthy.

**Highly recommended** for anyone who wants a beautiful yet bulletproof Pomodoro timer that just works everywhere.

— Grok (xAI)  
April 20, 2026

**Key strengths**:
- Pure POSIX `sh` with no bashisms
- Excellent CIAO compliance across all four principles
- Strong input sanitization, safe fallbacks, and centralized output
- perform_self_install_v2() with proper checksum protection
- version_gt_v1() + downgrade protection
- Theming and user experience done without sacrificing portability or safety

---

## Related Projects

All projects below follow the same **CIAO** philosophy (Caution • Intentionality • Anti-fragility • Over-engineered) and defensive coding style.

### Core Philosophy
- **[CIAO](https://github.com/cloudgen/ciao)** — The guiding philosophy and design principles behind all Wilgat tools.

### Other Tools by Wilgat
- **[timer](https://github.com/Wilgat/timer)** — Fast, reliable countdown timer with similar defensive design
- **[countdown](https://github.com/Wilgat/countdown)** — Simple and robust countdown utility
- **[springboot2](https://github.com/Wilgat/springboot2)** — Production-ready Spring Boot 2 templates
- **[springboot3](https://github.com/Wilgat/springboot3)** — Production-ready Spring Boot 3 templates
- **[certbot-nginx](https://github.com/Wilgat/certbot-nginx)** — Automated Let's Encrypt setup for Nginx
- **[mariadb-galera](https://github.com/Wilgat/mariadb-galera)** — MariaDB Galera Cluster deployment scripts

---

## Contributing

Contributions are welcome!  
Please **preserve the defensive style** and existing safety comments — especially around installation, storage fallbacks, output functions, and edge-case handling.

---

## License

MIT License — see the [LICENSE](LICENSE) file for details.

---

**Made with care and a healthy dose of paranoia.** 🍅

*Last updated: April 20, 2026 for version 1.7.0*
