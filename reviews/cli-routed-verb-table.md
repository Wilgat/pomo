# CLI routed-verb table — pomo

Human-readable column is **`command: what it does`**. Menu labels **MUST** match this column.

**Last update:** 2026-09-08

| Verb | Handler | Privilege | Live since | Human-readable |
|------|---------|-----------|------------|----------------|
| start | `pomo_start` | you (Type 0) | 2026-07-14 | `start: Start a work phase` |
| status | `pomo_show_status` | you (Type 0) | 2026-07-14 | `status: Show themed status and progress` |
| watch | `pomo_watch` | you (Type 0) | 2026-07-14 | `watch: Live refresh every second` |
| skip | `pomo_skip` | you (Type 0) | 2026-07-14 | `skip: Skip the current phase` |
| stop | `pomo_stop` | you (Type 0) | 2026-07-14 | `stop: Complete work (counts toward stats)` |
| kill | `pomo_stop` (force) | you (Type 0) | 2026-07-14 | `kill: Discard without counting` |
| list | `pomo_list` | you (Type 0) | 2026-07-14 | `list: List running pomodoros` |
| stats | `pomo_stats` | you (Type 0) | 2026-07-14 | `stats: Daily completed count and minutes` |
| theme | `pomo_theme` | you (Type 0) | 2026-07-14 | `theme: List available themes` |
| menu | `app_default` | you (Type 0) | 2026-09-08 | `menu: Show the numbered list of live commands` |
| main | `app_default` | you (Type 0) | 2026-09-08 | `main: Same as menu` |
| install | `inst_perform_install` | you (Type 0) | 2026-07-14 | *(off main menu — self-managed)* |
| version | `app_version` | you (Type 0) | 2026-07-14 | *(off main menu — diagnostics)* |
| about | `app_about` | you (Type 0) | 2026-07-14 | *(off main menu — diagnostics)* |
| help | `app_help` | you (Type 0) | 2026-07-14 | *(off main menu)* |
| version-check | `ver_check` | you (Type 0) | 2026-07-14 | *(off main menu — self-managed)* |
| self-update | `inst_self_update` | you (Type 0) | 2026-07-14 | *(off main menu — self-managed)* |
| self-uninstall | `inst_self_uninstall` | you (Type 0) | 2026-07-14 | *(off main menu — self-managed)* |

Main menu lists **start … theme** then **Exit 99**. **MUST NOT** list install / self-managed / version / about / help / menu / main.
