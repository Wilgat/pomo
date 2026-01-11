# pomo - Simple & Beautiful Pomodoro Timer

Lightweight, themeable Pomodoro-style CLI timer written in **pure POSIX shell**.

Focus-friendly with colors, themes, progress bars, terminal bell and persistent stats!

## Features

- Classic 25/5 Pomodoro (customizable durations)
- Three beautiful themes: `default`, `energetic`, `minimal`
- Switch themes easily (`pomo theme set energetic`, `next`/`prev`)
- Persistent theme & daily stats (~/.cache/pomo/)
- Nice unicode icons & colored progress bar
- Terminal bell on phase end
- Zero dependencies — works with dash/sh/ash
- Very similar UX to `timer` (start/status/stop/kill/list/…)

### Main commands overview

| Command                          | Description                                          | Example                              |
|----------------------------------|------------------------------------------------------|--------------------------------------|
| `start [minutes]`                | Start new pomodoro (default 25 min)                  | `pomo start 40 --persist`            |
| `status`                         | Show remaining time + nice progress bar              | `pomo status`                        |
| `skip`                           | Jump to next phase (work → break or reverse)         | `pomo skip`                          |
| `stop [--force]`                 | Stop & count pomodoro (or discard)                   | `pomo stop`                          |
| `kill`                           | Alias for `stop --force`                             | `pomo kill`                          |
| `list [--persist]`               | Show currently running pomodoros                     | `pomo list`                          |
| `stats [today]`                  | Show completed pomodoros today                       | `pomo stats`                         |
| `theme list`                     | Show available themes + current                      | `pomo theme list`                    |
| `theme set <name>`               | Change visual theme                                  | `pomo theme set energetic`           |
| `theme next` / `theme prev`      | Cycle between themes                                 | `pomo theme next`                    |
| `version`                        | Show version                                         | `pomo version`                       |
| `help`                           | Show this help                                       | `pomo help`                          |

**Default durations**: 25 min work • 5 min break

## Installation

```bash
# Recommended (global install)
curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | sh

# With sudo if needed (when permission denied)
sudo curl -fsSL https://raw.githubusercontent.com/Wilgat/pomo/main/pomo | sudo sh
```

## Usage examples

```bash
# Classic pomodoro
pomo start

# 50 min deep work + 10 min break
pomo start 50 --break 10 --persist

# Check progress
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
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  42%

**minimal** (zen & clean)  
⏳ Work phase   18:42 remaining  
■■■■■■■■■■■■■■■■■■□□□□□□□□□□□□□□  42%

## Requirements

- POSIX shell (`/bin/sh`, dash, ash, etc.)
- Basic utilities: `date`, `id`, `mkdir`, `rm`, `sleep`

## Contributing

Ideas & PRs welcome:

- Long break after 4 cycles
- Multiple concurrent pomodoros (like `timer`)
- Optional desktop notification (`notify-send`)
- Better weekly/monthly stats
- Pause/resume functionality

## License

MIT

Enjoy your focused sessions! 🍅☕✨
