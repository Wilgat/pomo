# Requirements

Authoritative product and engineering requirements for this project live here.

**Current state (2026-09-10 — Git Bash `/c/` + storage):** **Fourteen** live requirements registered in `index.md` with primary **Requirement-IDs (`RQ-*`)**. Class **`RQ-CLASS-SOFTWARE-DEV`**, coding-style **`RQ-SHELL-SCRIPT-CODING`**, ten Type 0 shell REQs (including **`RQ-SHELL-GIT-BASH`** and **`RQ-SHELL-CLI-STORAGE`**), plus domain SSOT **`RQ-DOMAIN-POMO`** (`requirement-domain-pomo.md`; Area **`domain`**). Live header Status is **Active**. Each file declares **`Requirement-ID`**, **§1.1 Human-facing**, and a **Design-time verification** table (**TP-*** + `tests/*` + `reviews/*` only — never `docs/templates/**`). Type 0 lifecycle is composition of shell REQs; **pomodoro specialty** is **`RQ-DOMAIN-POMO`** / family **`TP-POMO`**. Domain product law **MUST** use the `requirement-domain-*` basename prefix. **Review scope:** treat **registry rows** as this product’s law; list/confirm unregistered files before assuming they apply.

## Purpose

- **Plan mode** designs work by reading and **updating** these docs — not only the session `plan.md`.
- **Implement** delivers code and docs that **trace** to **`RQ-*`** (primary) and basenames (secondary).
- **Review** verifies delivery against requirements **and** defensive (CIAO) checklists (`skill-requirement-review` Step −1: registry inventory first).
- **Primary citation:** `RQ-*` on product surfaces (reviews, tests comments, DTV). Never freeze product `RQ-*` into portable templates/skills/terminologies (`policy-harness-id-notation`).
- Test cases use **`TP-*`**; skills **`SK-*`**; law molds **`LM-*`**; proof molds **`PM-*-TEST-PLAN`**.

## Layout

| Path | Role |
|------|------|
| `docs/requirements/index.md` | **Registry SSOT** — `RQ-*`, keys, Area, Status, Path |
| `docs/requirements/requirement-*.md` | **Live product law** (flat basenames + declared **Requirement-ID**) |

**Live basename rules:**

| Kind | Prefix / pattern | Requirement-ID pattern | Registry Area |
|------|------------------|------------------------|---------------|
| Software-development class | `requirement-class-software-dev` | `RQ-CLASS-SOFTWARE-DEV` | `class` |
| Type 0 / shell lifecycle + coding-style | `requirement-shell-*` | `RQ-SHELL-*` | `shell` |
| Domain product law | `requirement-domain-*` | `RQ-DOMAIN-<SUBJECT>` | `domain` |

Optional nested `docs/requirements/<area>/REQ-…` trees are **not** used by this product’s current registry. Prefer flat `requirement-*` + `index.md` rows.

## Live Requirement-IDs (see index.md)

Authoritative list is always **`index.md`**. Active IDs:

| Requirement-ID | Key |
|----------------|-----|
| `RQ-CLASS-SOFTWARE-DEV` | requirement-class-software-dev |
| `RQ-SHELL-SCRIPT-CODING` | requirement-shell-script-coding |
| `RQ-SHELL-AUTOMATIC-CHECKSUM` | requirement-shell-automatic-checksum |
| `RQ-SHELL-CLI-INTERFACE` | requirement-shell-cli-interface |
| `RQ-SHELL-CLI-ZERO-ARGUMENTS` | requirement-shell-cli-zero-arguments |
| `RQ-SHELL-CLI-DEFAULT-INTERACTION` | requirement-shell-cli-default-interaction |
| `RQ-SHELL-IDEMPOTENCY` | requirement-shell-idempotency |
| `RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE` | requirement-shell-interactive-vs-noninteractive |
| `RQ-SHELL-MODULAR-FUNCTION-DESIGN` | requirement-shell-modular-function-design |
| `RQ-SHELL-OUTPUT-REQUIREMENTS` | requirement-shell-output-requirements |
| `RQ-SHELL-SELF-MANAGEMENT` | requirement-shell-self-management |
| `RQ-SHELL-GIT-BASH` | requirement-shell-git-bash |
| `RQ-SHELL-CLI-STORAGE` | requirement-shell-cli-storage |
| `RQ-DOMAIN-POMO` | requirement-domain-pomo |

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
5. Session plan must list affected **`RQ-*`** / keys and whether each is create / update / no-change.
6. Do not implement against unstated intent — if behavior is required, it belongs in a requirement file.
7. **Design-time verification** lists TP-IDs + `tests/*` + `reviews/*` only — never `docs/templates/**` paths.

## Implementation rules

- Every non-trivial PR/change set cites one or more **registered** **`RQ-*`** (or basenames) when requirements exist.
- Do not invent requirements only in code comments; promote durable intent here.
- **No placeholders** in requirement files: no `TBD`/`TODO` acceptance criteria, hollow sections, or stub “later” text (no-placeholder / dual-policy hygiene; deliver complete criteria or explicit deferred ownership).
- Product source comments cite only **live** registered requirements (basename and/or `RQ-*`) — never invent basenames; never cite `template-*` / `skill-*` as law.

## Review rules

- Requirements changes and code/docs delivery use the project’s plan/implement/code-review/security checklist process.
- Empty registry is valid for genesis; do not invent requirements to “fill” the index.
- On “review requirements”: run registry vs disk inventory first; confirm foreign/unregistered files before treating them as law (`skill-requirement-review` Step −1).
- Gate **id-notation**: every Active REQ has **`Requirement-ID`**, registry row, and DTV with **TP-*** (or honest n/a/todo).
