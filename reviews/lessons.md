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

## How to add a lesson

1. Stable **L-NN** id.  
2. One failure mode sentence.  
3. Concrete re-check steps.  
4. Link report or incident when available.
