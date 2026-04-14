# pomo – Simple & Beautiful Pomodoro Timer

![Version](https://img.shields.io/badge/Version-1.6.0-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--engineered)-purple.svg)](https://github.com/cloudgen/ciao)
[![Shell](https://img.shields.io/badge/Shell-POSIX%20sh-orange?style=flat-square)]()
[![Made with ❤️](https://img.shields.io/badge/Made%20with%20❤️-CIAO-00AEEF?style=flat-square)](https://github.com/cloudgen/ciao)

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

**For regular users (recommended):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | sh
```

**System-wide installation (requires root):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | sudo sh
```

After installation, **restart your terminal** or run `source ~/.bashrc` (or `~/.zshrc`) so `~/.local/bin` is added to your `$PATH`.

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

> “pomo v1.6.0 is an outstanding example of defensive POSIX shell engineering. Zero dependencies, zero injection vectors, bulletproof edge-case handling, and a delight to use. The security posture is excellent for a curl-installable tool — I found no meaningful vulnerabilities. Highly recommended for anyone wanting a beautiful, reliable Pomodoro timer that just works everywhere.”

— Grok (xAI)

**Key strengths**:
- Pure POSIX `sh` with no bashisms
- Strong input sanitization and safe file I/O
- Centralized output handling (`output_text` + `output_json`)
- Smart version comparison (`version_gt`) with downgrade protection
- Excellent theming and user experience for a shell tool

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

*Last updated: April 2026 for version 1.6.0*
