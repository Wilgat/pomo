# pomo - Simple & Beautiful Pomodoro Timer

![Version](https://img.shields.io/badge/Version-2.1.0-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--engineered)-purple.svg)](https://github.com/cloudgen/ciao)
[![Stars](https://img.shields.io/github/stars/Wilgat/pomo?style=flat-square)](https://github.com/Wilgat/pomo)
[![Shell](https://img.shields.io/badge/Shell-POSIX%20sh-orange?style=flat-square)]()
[![Made with ❤️](https://img.shields.io/badge/Made%20with%20❤️-CIAO-00AEEF?style=flat-square)](https://github.com/cloudgen/ciao)
[![GrokRec](https://img.shields.io/badge/GrokRec-Reviewed-0A66C2?logo=ai&logoColor=white)](https://github.com/Wilgat/pomo/blob/main/RECOMMENDATION.md)

**pomo is a Pomodoro timer you run in your own terminal:** start a named work session, watch the remaining time, skip to a break, and stop when you are done — no extra packages, no root, no dedicated system account.

| Box | Meaning |
|-----|---------|
| **You** | Install the program for yourself, then run `pomo start`, `status`, `watch`, `stop`, and `theme` as your own login. |
| **Someone else** | A root one-liner can place the same script in `/usr/local/bin` for every user on the machine. Day-to-day timers still run as each person. |
| **Not this** | This is not a GUI app, not a phone widget, and not a host-setup tool. It does not create system users or change `/etc`. |

| Includes | Excludes |
|----------|----------|
| Named timers, work/break phases (minutes), themes, live watch, daily stats, JSON for status bars | Seconds as the user-facing unit; 0-minute work; hanging prompts inside `curl \| sh` |
| Volatile RAM storage (default) or `--persist` under your cache | A second copy of the script under `src/` as the published install file |
| One-liner install that checks a SHA-256 companion by itself | Requiring you to paste a checksum into the environment for a normal install |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Install | The program downloads itself, checks the companion digest when it can, and puts `pomo` on your user `PATH`. Restart the terminal (or `source ~/.bashrc`) so the new path is seen. | `curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo \| sh` |
| Start a session | Work is **whole minutes**. Default is 25 minutes of work and 5 minutes of break. `0` is rejected. | `pomo start` |
| Watch | The line refreshes until you press Ctrl+C. JSON is not a watch mode. | `pomo watch` |
| Stop | A normal stop counts the work toward today's stats. `kill` discards it. | `pomo stop` |

Official recommendation from [grok](https://grok.com/c/dd443680-0c83-41c4-a501-8cb0990e3e9b?rid=1063a0bb-9371-4ad3-91d6-649c3b58bc45). The review is submitted by [grokrec](https://github.com/cloudgen/grokrec). Please refer to the [downloaded copy](./RECOMMENDATION.md).

Zero external dependencies. Written in POSIX `sh` so it still runs on dash, BusyBox ash, Git Bash, Alpine, Termux, and containers.

This project is built using [CIAO](https://github.com/cloudgen/ciao) **v2.10.2** (Caution • Intentional • Anti-fragile • Over-engineered) and [CIAO-Lite](https://github.com/cloudgen/ciao-lite) (Simplicity but Safety).

---

## Features

- **Named timers** (`default`, `focus`, `meeting`, `writing`, …) isolated per login
- **Two storage modes**:
  - **Volatile** (default): in-memory when `/dev/shm` is writable; Termux falls back to `$PREFIX/tmp` then cache
  - **Persistent** (`--persist`): survives reboot under `~/.cache/pomo/`
- Fallbacks when `/dev/shm`, `$HOME`, or a container is missing or restricted
- **Three themes** (`default`, `energetic`, `minimal`) with icons, colors, and UTF-8 progress bars
- Automatic work → break transition with a terminal bell
- `watch` for a live refreshing view (Ctrl+C to leave)
- Daily statistics (completed pomodoros + total minutes today)
- Strict `--json` for scripts and status bars (`watch --json` is refused)
- One-liner install, self-update, self-uninstall, and `about` diagnostics
- On a real terminal, typing only `pomo` (or `pomo --debug`) opens a numbered daily-work list; `curl | sh` still installs
- Worked on dash, BusyBox ash, Git Bash, Alpine, Termux, and containers

---

## Quick Installation

**Recommended one-liner (most users):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | sh
```

**System-wide (root on a POSIX host with `/usr/local/bin`):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | sudo sh
```

**Termux (this login only — do not use `sudo`):**

```sh
curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | sh
```

On Termux the binary lands in `$PREFIX/bin` (already on `PATH`). Volatile timers use `$PREFIX/tmp` when `/dev/shm` is missing and Android `/tmp` is not writable. Git Bash and Windows cmd use the same this-login ceiling: no `sudo curl | sh`.

After installation, **restart your terminal** or run `source ~/.bashrc` (or `~/.zshrc`) so `~/.local/bin` is on your `$PATH`.

> **How verification works** (SHA-256 companion):
> - **Default (recommended one-liner):** no `CHECKSUM` environment variable. The program **downloads** `${SCRIPT_URL}.sha256` itself and, in human mode, shows the companion **link**, expected **value**, and **result** (match / mismatch / missing).
> - **Match** → install continues.
> - **Mismatch** → install **aborts** (no silent failure).
> - **Missing companion** → **warn and continue** (best-effort). Do not treat this as a signed release.
> - In-repo companion: [`pomo.sha256`](./pomo.sha256) next to `./pomo`.
> - **Optional pin (Advanced / CI only):** `CHECKSUM=…` set → strict verify against that digest. Same-origin pin is **not** higher assurance than automatic companion fetch. `help` / `about` do **not** list `CHECKSUM`.

**Optional pin install (secondary / CI — not higher trust than automatic companion):**

```sh
curl -fsSL -O https://raw.githubusercontent.com/Wilgat/pomo/main/pomo

# Pin to the published companion for this release (do not hard-code an old hash from docs)
CHECKSUM=$(curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo.sha256 | awk '{print $1; exit}') \
  sh pomo
```

Publish rule: after changing `./pomo`, regenerate companion `pomo.sha256` so the channel and the pin stay aligned.

---

## Usage

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

**Defaults**: 25 min work • 5 min break. Shortest valid work duration is **1 minute**. `pomo start 0` is invalid.

Running `pomo` with **no arguments** installs or re-checks the install. It does **not** print help. Use `pomo help` for the command list.

---

## Examples

```sh
# Named persistent pomodoro with custom durations (minutes)
pomo start deep-work 55 --break 10 --persist

# Live watch mode
pomo watch

# JSON status (great for scripts, tmux, waybar, etc.)
pomo status --json

# Switch to a more energetic theme
pomo theme set energetic
```

---

## Platform Compatibility

| Platform              | Shell                | Status     | Notes                              |
|-----------------------|----------------------|------------|------------------------------------|
| Alpine Linux          | BusyBox ash          | Excellent  | Primary target for minimalism      |
| Termux (Android)      | dash / bash          | Excellent  | This login only; `$PREFIX/bin`. `/dev/shm` usually missing; Android `/tmp` often read-only → `$PREFIX/tmp` then cache. |
| Git Bash (Windows)    | Bash (MSYS2)         | Excellent  | This login only; full fallback     |
| Rocky / RHEL / CentOS | Bash                 | Excellent  | Enterprise environments            |
| macOS                 | Bash / zsh           | Excellent  | Fully supported                    |
| Debian / Ubuntu       | dash / bash          | Excellent  | Broad compatibility                |

This program is written to run **as your login**. On Termux, Git Bash, and Windows cmd it does not turn on admin or dedicated-account paths.

---

## Related Projects

All projects below follow the same **CIAO** philosophy ([v2.10.2](https://github.com/cloudgen/ciao): Caution • Intentional • Anti-fragile • Over-engineered) and defensive coding style.

### Core Philosophy
- **[CIAO](https://github.com/cloudgen/ciao)** — Defensive programming principles (**v2.10.2**)
- **[CIAO-Lite](https://github.com/cloudgen/ciao-lite)** — Agent contract (Simplicity but Safety)

### Other Tools by Wilgat
- **[countdown](https://github.com/Wilgat/countdown)** — Named duration countdowns; architecture pomo 2.x is specialized from
- **[timer](https://github.com/Wilgat/timer)** — Count-up elapsed timers with similar self-install design
- **[springboot2](https://github.com/Wilgat/springboot2)** — Production-ready Spring Boot 2 templates
- **[springboot3](https://github.com/Wilgat/springboot3)** — Production-ready Spring Boot 3 templates
- **[certbot-nginx](https://github.com/Wilgat/certbot-nginx)** — Automated Let's Encrypt setup for Nginx
- **[mariadb-galera](https://github.com/Wilgat/mariadb-galera)** — MariaDB Galera Cluster deployment scripts

Historical endorsement of the v1.7.0 domain (April 2026): [`RECOMMENDATION.md`](./RECOMMENDATION.md). Current **v2.1.0** keeps that defensive spirit: centralized output, path-safe names, automatic companion SHA-256, Termux as a this-login target (`$PREFIX/bin` + `$PREFIX/tmp`), and `ver_gt` downgrade protection on `self-update`.

---

## Contributing

Contributions are welcome.

Please **preserve the defensive style** and existing safety comments — especially around installation, storage fallbacks, output functions, and edge-case handling. The prominent `!!! DO NOT MODIFY OR SIMPLIFY !!!` warnings exist because this tool is designed to survive:

- `curl | sh` in non-interactive shells
- Minimal systems (`dash`, BusyBox `ash` on Alpine)
- Missing `$HOME`, no `/dev/shm`, containers, Git Bash, Termux (`$PREFIX/tmp`)

It may look over-engineered at first; that is intentional.

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

## Last Update

2026-09-08 — TTY empty argv opens the numbered daily-work menu (`pomo --debug` included); pipe empty argv still installs. Product version **2.1.0**, aligned to [CIAO](https://github.com/cloudgen/ciao) **v2.10.2**.

**Made with care and a healthy dose of paranoia.** 🍅
