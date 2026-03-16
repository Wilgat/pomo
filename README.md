<div align="center">

<img src="https://img.shields.io/badge/Version-1.3.8-blue?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Version 1.3.8">   
<img src="https://img.shields.io/badge/sh-POSIX-green?style=for-the-badge&logo=gnubash&logoColor=white" alt="POSIX sh">  
<img src="https://img.shields.io/badge/License-MIT-brightgreen?style=for-the-badge&logo=opensourceinitiative&logoColor=white" alt="License MIT"> 

**pomo** — the simplest, most beautiful Pomodoro timer in pure POSIX shell 🌿

</div>

Lightweight, themeable Pomodoro-style CLI timer written in **pure POSIX shell** .

Focus-friendly with colors, themes, progress bars, terminal bell and persistent stats!

## Features

- Classic 25/5 Pomodoro (customizable durations)
- Three beautiful themes: `default`, `energetic`, `minimal`
- Switch themes easily (`pomo theme set energetic`, `next`/`prev`)
- Persistent theme & daily stats (`~/.cache/pomo/`)
- Nice unicode icons & colored progress bar
- Terminal bell on phase end
- **Live watch mode** — continuously refreshing status every second
- Zero dependencies — works with dash/sh/ash
- Very similar UX to `timer` (start/status/stop/kill/list/…)

### Main commands overview

| Command                          | Description                                                  | Example                              |
|----------------------------------|--------------------------------------------------------------|--------------------------------------|
| `start [minutes]`                | Start new pomodoro (default 25 min)                          | `pomo start 40 --persist`            |
| `watch [--persist]`              | Live view - refreshes status every second (Ctrl+C to exit)   | `pomo watch`                         |
| `status`                         | Show remaining time + nice progress bar                      | `pomo status`                        |
| `skip`                           | Jump to next phase (work → break or reverse)                 | `pomo skip`                          |
| `stop [--force]`                 | Stop & count pomodoro (or discard)                           | `pomo stop`                          |
| `kill`                           | Alias for `stop --force`                                     | `pomo kill`                          |
| `list [--persist]`               | Show currently running pomodoros                             | `pomo list`                          |
| `stats`                          | Show completed pomodoros today                               | `pomo stats`                         |
| `theme list`                     | Show available themes + current                              | `pomo theme list`                    |
| `theme set <name>`               | Change visual theme                                          | `pomo theme set energetic`           |
| `theme next` / `theme prev`      | Cycle between themes                                         | `pomo theme next`                    |
| `version`                        | Show version                                                 | `pomo version`                       |
| `help`                           | Show this help                                               | `pomo help`                          |

**Default durations**: 25 min work • 5 min break

## Requirement Analysis

This section covers key design decisions for portability, safety, and usability .

- **Shell**: `#!/bin/sh` (POSIX/dash/ash compatible). No bashisms/SDKMAN needed (unlike Java tools ); runs on Linux/macOS/BSD/Alpine/busybox.
- **User privileges**: Auto-detect root vs normal (install: `/usr/local/bin` root, `~/.local/bin` user-local) .
- **Installability**: Curl|sh one-liner friendly (non-interactive auto-install); sudo variant; atomic temp→mv; auto-add `~/.local/bin` to `~/.bashrc` (idempotent, w/ reload guidance) .
- **Key variables**: Hard-coded `APP_NAME="pomo"`, `APP_VER="1.3.8"`, GitHub `SCRIPT_URL`; `VOLATILE_DIR="/tmp"` (portable timer files), `PERSISTENT_DIR="~/.cache/pomo"` (XDG-safe stats/theme) .
- **File safety**: mkdir -p dirs; temp downloads mv atomic; per-user files (`pomo_${USER}_work/break`) .
- **Installation check**: Smart — root: global only; user: global OR local (exist+x) .
- **Other**: Unicode icons (UTF-8 safe); tty-safe clear/colors; background sleep (no subshells leak); explicit errors (no `set -e`); main() modularity .

## Pseudo-code overview

High-level plan before implementation — for readability/debugging .

| Step | Function/Module                | Purpose / Main logic                                                                 |
|------|--------------------------------|--------------------------------------------------------------------------------------|
| 1    | (top)                          | Header/curl examples; colors; constants (APP_NAME/VER/URLs/DIRS/DEFAULTS)  |
| 2    | detect_install_locations       | mkdir dirs; set IS_ROOT/INSTALL_DIR/PATH                                 |
| 3    | utils (get_icon/bar/repeat)    | Reload theme; icons/colors/bar; per-user files; today/stats               |
| 4    | is_installed/in_path/add_bashrc| Smart check; PATH guidance (user-local preferred)                         |
| 5    | perform_self_install           | Curl temp → chmod+x → mv atomic → success                                 |
| 6    | maybe_install                  | !installed? → tty prompt/non-tty auto → install + PATH fix                |
| 7    | cmd_*                          | Modular: start (bg sleep cycle/bell); status (progress); watch (loop refresh); theme/stats/stop/skip/list  |
| 8    | parse_args                     | Flags (--persist/force/break) → COMMAND → subargs (WORK_MIN=$1 numeric)               |
| 9    | main                           | Setup/reload → parse → maybe_install → dispatch                           |

## Installation

```bash
# User-local (recommended, no sudo)
curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | sh

# Global (if needed)
sudo curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | sudo sh
```

## Usage examples

```bash
# Classic pomodoro
pomo start

# Watch progress live (updates every second, Ctrl+C to quit)
pomo watch

# Start persistent session and watch it
pomo start 50 --persist
pomo watch --persist

# Custom duration + break
pomo start 50 --break 10 --persist

# Check progress (single view)
pomo status

# Finish early or switch phase
pomo skip

# When done — count it
pomo stop

# Cleanup forgotten session
pomo kill

# See beautiful stats
pomo stats

# Try different look
pomo theme set energetic
pomo theme next
```

## Themes preview (approximate look)

**default** (classic tomato style)  
🍅 Work phase   18:42 remaining  
█████████████████████░░░░░░░░░░░░░░░  42%

**energetic** (dynamic & motivating)  
⚡ Work phase   18:42 remaining  
███████████████████████████████░░░░░  42%

**minimal** (zen & clean)  
⏳ Work phase   18:42 remaining  
███████████████□□□□□□□□□□□□□□□□□□□□  42%

## Requirements

- POSIX shell (`/bin/sh`, dash, ash, etc.)
- Basic utils: `date`, `id`, `sleep`, `curl` (install only)
- UTF-8 locale (for icons; graceful fallback)

## Contributing

Ideas & PRs welcome :

- Long break after 4 cycles
- Multiple concurrent pomodoros (like `timer`)
- Optional desktop notification (`notify-send`)
- Better weekly/monthly stats
- Pause/resume functionality
- Randomized motivational quotes 

## License

MIT

Enjoy your focused sessions! 🍅☕✨
