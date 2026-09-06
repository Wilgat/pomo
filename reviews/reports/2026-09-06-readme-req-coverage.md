# Review report — README human readability + requirements / tests / checklists coverage

**Date:** 2026-09-06  
**Product:** pomo **2.0.1**  
**Ship unit:** `./pomo` (restored at repo root; unpublished `src/pomo` duplicate removed)  
**Scope:** Product README voice, requirement human-facing law, coverage vs tests/checklists  
**Verdict:** **Pass** after same-change fixes (docs/law). No ship-unit behavior change.

## Registry inventory (Step −1)

| Bucket | Result |
|--------|--------|
| Registered ∩ on disk | 11 files (was 9; added class + coding-style) |
| On disk, not in registry | none |
| In registry, missing on disk | none |
| Foreign candidates | none (countdown named only as bootstrap lineage) |

Scope: **registry-only** (all registered files in-scope).

## README human readability (product species)

| Finding | Severity | Fix |
|---------|----------|-----|
| “Please refers to” grammar | nit | “Please refer to” |
| Description led with Type 0 / Type O / A→B | high (voice) | Voice pack: one sentence, three boxes, includes/excludes, practice |
| Extra H2s (`Why the Defensive Style?`, `Grok's Code Review`) broke section order | medium | Folded into Contributing / Related Projects |
| Missing `## Last Update` heading | medium | Added |
| Install integrity already automatic-first | pass | Kept; restated link/value/result |

## Requirements human readability

| Finding | Severity | Fix |
|---------|----------|-----|
| All live REQs lacked **§1.1 Human-facing** | high | Added to every Active file |
| Purpose leads were catalog-only (Type 0 / Type O) | medium | Plain sentence first; codes cited after |

## Coverage (sufficient check, claim **C-full-product**)

| Surface | Owner | Status |
|---------|-------|--------|
| Domain verbs/flags | `RQ-DOMAIN-POMO` | ok |
| Lifecycle / empty argv / checksum / output | `RQ-SHELL-*` | ok |
| Class residual | `RQ-CLASS-SOFTWARE-DEV` | **was unowned** → added |
| Coding-style specialize-in | `RQ-SHELL-SCRIPT-CODING` | **was unowned** → added |
| Dest approver / dest fences | class residual **considered — none** | ok (not invented) |
| `reviews/requirement-test-matrix.md` | map | **was missing** → added |

## Tests vs DTV

`reviews/test-plan.md` already marked Core families **have**. Domain **TP-POMO-07** covers `start 0` → `invalid_duration` (1-minute minimum lock-in). No new Core TP required this pass.

**Suite re-run (2026-09-06):** `./tests/run.sh` → **PASS=239 FAIL=0 SKIP=1** (`TP-CURL-09` optional).

## Checklists

Filled housekeeping checklists under `docs/checklists/` are harness-sync evidence, not product-law coverage. Product coverage this pass: `reviews/test-plan.md` + new RTM + this report (tracked). Blank `checklist-shell-cli-test` items match the have/n/a/optional map.

## Least privilege / ID notation

- Privilege law: **N/A** (no Type 1 dest / LPU). Domain and lifecycle run as the invoking login.  
- ID notation: `RQ-*` unique; DTV uses `TP-*`; no harness path dump added to versioned requirements.

## Open items

none for this scope.
