# Lessons (pomo) — prior failure modes

**Mandatory:** every durable product review **MUST** re-check this table.

| ID | Failure mode | Re-check | Source |
|----|--------------|----------|--------|
| **L-01** | `$0` basename gate blocks `curl \| sh` install (`app_main` never runs) | Ship unit always ends with `app_main "$@"`; no APP_NAME basename gate for pipe | incident-20260712-001 |
| **L-02** | Product source cites `template-*` / `skill-*` or phantom `requirement-*` as law | ALIGNMENT lists only live registered `requirement-*.md` | incident-20260712-002 |
| **L-03** | README install URL / channel misaligned with Config `SCRIPT_URL` | README one-liners match `Wilgat/pomo` + `APP_NAME=pomo` | incident-20260712-003 |
| **L-04** | README too complex / primary path buried | Quick install one-liner remains primary; pin path secondary | incident-20260712-004 |
| **L-05** | Requirements registry / README dumps gitignored harness trees | `docs/requirements/index.md` = requirement rows only | incident-20260712-005 |
| **L-06** | `set -u` / missing defaults on Config vars | Defensive `: "${VAR:=…}"` defaults remain | incident-20260713-001 |
| **L-07** | Self-uninstall JSON fake cancel success | Non-interactive uninstall without `--force` → non-zero / `confirm_required` | incident-20260713-002 |
| **L-08** | Checksum self-reference / trust confusion (hash of self inside ship unit; pin as “highest” assurance) | Automatic companion `${SCRIPT_URL}.sha256`; no embed digest in ship unit; pin secondary | incident-20260713-003 |
| **L-09** | Versioned `AGENTS.md` / thick process disclosure | Root `AGENTS.md` gitignored; thin product surface | incident-20260714-001 |
| **L-10** | Reverse-copy domain into bootstrap A (countdown) | Domain only on `./pomo`; direction countdown → pomo only | specialize / reverse-copy terms |
| **L-11** | Domain law mis-prefixed as `requirement-shell-*` | Domain SSOT is `requirement-domain-pomo` Area `domain` | requirement review 2026-07-16 |
| **L-12** | Stale published CHECKSUM pin in README vs live `pomo.sha256` | README pin examples match current companion or document regenerate | product review 2026-07-16 |
| **L-13** | Docs claim in-tree `./countdown` when file absent | Stay-honest: optional if present; no invent | product review 2026-07-16 |
| **L-14** | Review only in chat /tmp without `reviews/` plan | Maintain what-to-review + test-plan + report under `reviews/` | skill-product-review |
| **L-TX-01** | Claim Termux / Git Bash support while recommending `sudo curl \| sh` or `/usr/local/bin` | Detect + user dest + about `termux`; **TP-TX-01..05** | 2026-09-08 |
| **L-TX-02** | Termux `pomo start` dies: only `/dev/shm` + `/tmp`; empty `$(resolve)` writes `/pomo_*` on RO root | `$PREFIX/tmp` then cache; refuse empty/root `APP_FILE`; **TP-TX-08** | 2026-09-08 |
| **L-GB-01** | Git Bash cache folder wrong (`$HOME/.cache`) or `mkdir` of `cache` aborts mid-chain | `$HOME/AppData/Local/Temp/cache` → `$TEMP/cache` → `/tmp/cache`; mkdir fail-soft; **TP-TX-09** / **TP-TX-10** | 2026-09-10 |
| **L-GB-02** | Git Bash detect only via `MSYSTEM`; no `/c/` drive; Temp missing when `$HOME/AppData` absent | Probe `/c/` or `/c`; `GIT_BASH_DRIVE` default `/c`; `/c/Users/<user>/AppData/Local/Temp/cache`; **TP-TX-11** / **TP-TX-12** | 2026-09-10 |
| **L-15** | Operator `pomo` on a TTY shows 2.0.3 install-ensure; PATH is stale **global** `/usr/local/bin/pomo` | Prove `command -v pomo` + `pomo version` + `about` global vs local **before** blaming the 2.1.0 menu. Non-root `self-update` cannot replace root global dest. | INC-20260908-001 |
| **L-16** | `sudo pomo` shows 2.1.0 menu; unprivileged `pomo` is `/bin/sh: 0: cannot open /usr/local/bin/pomo: Permission denied` | A `#!/bin/sh` dest needs **other-read** (0755), not execute-only 0711/0700. `sudo` success is not login proof. `chmod +x` is not 0755. Prove `ls -l $(command -v pomo)` before debugging the menu. Suite **TP-LC-23**; checklist **CL-ONLINE-INSTALL-SCRIPT** §4. | INC-20260912-001 |

## How to add a lesson

1. Stable **L-NN** id.  
2. One failure mode sentence.  
3. Concrete re-check steps.  
4. Link report or incident when available.
