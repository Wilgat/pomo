# Requirements

Authoritative product and engineering requirements for this project live here.

**Current state (2026-07-16 — pomo specialization from countdown bootstrap):** **Nine** live requirements registered in `index.md` — eight Type 0 `requirement-shell-*.md` (automatic-checksum, CLI interface, CLI zero-arguments, idempotency, interactive vs noninteractive, modular design, output, self-management) plus one domain SSOT **`requirement-domain-pomo.md`** (`requirement-domain-*` prefix; Area **`domain`**). Live header Status is **Active** (not the legacy council draft/approved/done vocabulary below — that table is historical/optional only). Versions per file header (e.g. `requirement-shell-cli-zero-arguments` **v1.1.1** Type O; `requirement-domain-pomo` **v1.1.0**; `requirement-shell-automatic-checksum` **v1.0.2**). Type 0 lifecycle is covered by composition (zero-arguments + CLI + checksum + self-management + interactive + idempotency + modular + output); **pomodoro specialty** is owned by `requirement-domain-pomo.md` (not only CLI routing rows). Domain product law **MUST** use the `requirement-domain-*` basename prefix. **Review scope:** treat **registry rows** as this product’s law; list/confirm unregistered or foreign-looking files before assuming they apply. Do **not** invent additional requirement paths without a real ownership gap — verify on disk and register new files in `index.md` in the same change.

## Purpose

- **Plan mode** designs work by reading and **updating** these docs — not only the session `plan.md`.
- **Implement** delivers code and docs that **trace** to requirement keys / basenames.
- **Review** verifies delivery against requirements **and** defensive (CIAO) checklists (`skill-requirement-review` Step −1: registry inventory first).

## Layout

| Path | Role |
|------|------|
| `docs/requirements/index.md` | **Registry SSOT** — keys, Area, Status, Path; keep in sync with files |
| `docs/requirements/requirement-*.md` | **Live product law** (flat basenames; primary convention for this project) |

**Live basename rules:**

| Kind | Prefix / pattern | Registry Area |
|------|------------------|---------------|
| Type 0 / shell lifecycle | `requirement-shell-*` | `shell` |
| Domain product law | `requirement-domain-*` | `domain` |

Optional nested `docs/requirements/<area>/REQ-…` trees are **not** used by this product’s current registry. Prefer flat `requirement-*` + `index.md` rows.

## Live keys (see index.md)

Authoritative list is always **`index.md`**. As of this README update, Active keys are:

- `requirement-shell-automatic-checksum`
- `requirement-shell-cli-interface`
- `requirement-shell-cli-zero-arguments`
- `requirement-shell-idempotency`
- `requirement-shell-interactive-vs-noninteractive`
- `requirement-shell-modular-function-design`
- `requirement-shell-output-requirements`
- `requirement-shell-self-management`
- `requirement-domain-pomo`

## Status values (live practice)

| Status (index + file header) | Meaning |
|------------------------------|---------|
| `Active` | Current product law — implement and review against it |
| `Superseded` | Replaced by another Active key (keep file for history if needed) |
| `Deprecated` | No longer Active; do not implement new behavior from it |

### Legacy council vocabulary (optional / unused here)

Some older harness docs mention `draft` / `approved` / `in-progress` / `done`. **This project’s registry uses `Active` (and supersede/deprecate when needed).** Do not invent dual status systems.

## Plan-mode rules (mandatory)

When planning non-trivial work:

1. Search `docs/requirements/index.md` first, then open registered files on disk.
2. List any on-disk `requirement-*.md` **not** in the registry as orphans — **do not** assume they are this product’s law until the user confirms.
3. Decide: **new requirement**, **update existing**, or **no requirements impact** (state why).
4. Apply requirement file changes **before** or as part of finishing the plan; same-change registry row for new files.
5. Session plan must list affected requirement keys and whether each is create / update / no-change.
6. Do not implement against unstated intent — if behavior is required, it belongs in a requirement file.

## Implementation rules

- Every non-trivial PR/change set cites one or more **registered** requirement keys when requirements exist.
- Do not invent requirements only in code comments; promote durable intent here.
- **No placeholders** in requirement files: no `TBD`/`TODO` acceptance criteria, hollow sections, or stub “later” text (no-placeholder / dual-policy hygiene; deliver complete criteria or explicit deferred ownership).
- Product source comments cite only **live** `requirement-*.md` files listed in the registry (never invent basenames).

## Review rules

- Requirements changes and code/docs delivery use the project’s plan/implement/code-review/security checklist process.
- Empty registry is valid for genesis; do not invent requirements to “fill” the index.
- On “review requirements”: run registry vs disk inventory first; confirm foreign/unregistered files before treating them as law (`skill-requirement-review` Step −1).
