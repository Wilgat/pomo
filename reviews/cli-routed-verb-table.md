# CLI routed-verb table — pomo

Human-readable column is **`command: what it does`**. Menu labels **MUST** match this column.

**Last update:** 2026-09-14

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
| menu | `app_default` | you (Type 0) | 2026-09-14 | `menu: Show the top menu of live boards` |
| main | `app_default` | you (Type 0) | 2026-09-08 | `main: Same as menu` |
| timer | `app_default` | you (Type 0) | 2026-09-14 | `timer: Daily pomodoro work` |
| self-management | `app_default` | you (Type 0) | 2026-09-14 | `self-management: Install, update, and remove this program` |
| install | `inst_perform_install` | you (Type 0) | 2026-07-14 | `install: Place the program for this login` |
| version | `app_version` | you (Type 0) | 2026-07-14 | *(off main menu — diagnostics)* |
| about | `app_about` | you (Type 0) | 2026-07-14 | *(off main menu — diagnostics)* |
| help | `app_help` | you (Type 0) | 2026-07-14 | *(off main menu)* |
| version-check | `ver_check` | you (Type 0) | 2026-07-14 | `version-check: Compare local vs remote version` |
| self-update | `inst_self_update` | you (Type 0) | 2026-07-14 | `self-update: Update to a newer remote version` |
| self-uninstall | `inst_self_uninstall` | you (Type 0) | 2026-07-14 | `self-uninstall: Remove this program` |

Top menu lists **1 timer**, **8 self-management**, **Exit 9**. Timer board lists **11…19** (start … theme) then **Back 0**. Self-management board lists **81…84** then **Back 0**. **MUST NOT** restart a submenu at **1**. **MUST NOT** list version / about / help / menu / main as numbered rows.
