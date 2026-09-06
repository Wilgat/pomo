**file**: docs/requirements/requirement-class-software-dev.md  
**Requirement-ID**: `RQ-CLASS-SOFTWARE-DEV`  
**Status**: Active (Version 1.0.0 – class residual; coding-style MUST; no dest approver)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

Declare this workspace as a **software-development** project and hold residual software-engineering facts that are not owned by a more specific Active requirement: primary language, toolchain, package/test tools, and class membership.

This file is **class law + residual SSOT**. It is not a second copy of the pomodoro domain, install lifecycle, or the coding-style related requirement (that file **MUST** exist: `requirement-shell-script-coding` / `RQ-SHELL-SCRIPT-CODING`).

### 1.1 Human-facing

**In one sentence:** This project is shipped software (a terminal program), not a blank seed and not a server-ops playbook; this file records the language and tools unless a more specific file already owns them.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Build and run `pomo` as a program | `./pomo`, `./tests/run.sh` |
| The other role | Peer requirements that own install, timers, output | `RQ-DOMAIN-POMO`, `RQ-SHELL-*` |
| Not this file | Server allowlists, genesis empty law, dest approval queues | no dest approver on this product |

| Includes | Excludes |
|----------|----------|
| Class membership; POSIX `/bin/sh`; test runner `./tests/run.sh` | Full timer command table; checksum algorithm |
| Pointer to coding-style REQ | Treating coding skills as product law |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./pomo` | ship unit | language/runtime truth |
| `docs/requirements/index.md` | registry | Active rows |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Confirm class | Software-development: there is exactly one class file. | (read this file + index row) |
| Run tests | POSIX `sh` suite; no extra language toolchain. | `./tests/run.sh` |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.0 Project class membership

1. **MUST** treat this workspace as **software-development**, not genesis-template and not server-maintenance.  
2. **MUST** use basename **`requirement-class-software-dev.md`** as the sole Active class-law file.  
3. **MUST NOT** register an Active `requirement-class-server-maintenance.md` while class is software-development.  
4. **MUST** keep specialized product knowledge in this file and peer `requirement-*.md` files.  
5. **MUST NOT** invent hollow product docs solely to look specialized.

### 2.1 Residual collection principle

6. **MUST** treat this file as the default home for software-stack facts **not owned** by another Active requirement.  
7. **MUST NOT** duplicate full normative tables that already live in a more specific Active requirement. Prefer a one-line pointer.  
8. When a new specialized requirement takes ownership of a residual topic, **MUST** update this file in the same change.  
9. **MUST NOT** leave contradictory stack facts across this file and peer requirements.

### 2.2 Programming language(s)

10. **MUST** declare at least one primary programming language.  
11. **MUST** state whether the product is primarily interpreted, compiled, polyglot, or package-multi-language.  
12. **MUST NOT** freeze a marketing product name as if it were the language name.

### 2.3 Compilers, interpreters, and toolchains

13. **MUST** declare the target toolchain class.  
14. **MUST** state version policy as unconstrained, minimum, range, or pinned.  
15. **MUST** fail closed in CI/docs claims: do not claim “supports all compilers” without tests or explicit unconstrained policy.

### 2.4 Project / package / build tools

16. **MUST** declare the primary project or package tool.  
17. **MUST** declare lockfile policy when the ecosystem supports lockfiles.  
18. **MUST NOT** require a secret token or private registry password in this file.

### 2.5 Runtime and platform (residual)

19. **MUST** declare the intended primary runtime/OS family when not fully owned by another architecture requirement.  
20. **MUST** separate developer-machine toolchain requirements from end-user runtime when they differ.

### 2.6 No-hardcode / dual policy (class file)

21. **MUST NOT** hard-code a single product/app brand, one org’s production hostname, or personal owner identity as universal core law.  
22. **MUST** put live product name, repo slug, and concrete versions in **Implementation Notes**.  
23. **MUST NOT** store secrets, PATs, or toy credentials in this file.

### 2.8 Actor / role / subject / approver (consider)

24. Every software-development project **MUST** consider an actor / role / subject / approver requirement — even if there is no dest approver.  
25. **MUST** either publish Active `requirement-actor-role-subject-approver`, **or** record in this residual: **considered — no dest approver and no approval subject**.  
26. **MUST NOT** skip the consider. **MUST NOT** invent an approver so the table looks complete.

### 2.9 Dest fence conditions (review)

27. Every software-development project **MUST review** whether any dest fencing conditions exist.  
28. If none: record in this residual **considered — no dest fence conditions**.  
29. **MUST NOT** skip the review. **MUST NOT** invent a dest fence so the set looks complete.

### 2.10 Coding-style related requirement (MUST have)

30. Every software-development project **MUST** have an Active coding-style related requirement matching the primary language.  
31. **Intention:** without that REQ, agents bring portable learned lessons **raw** and treat them as this product’s law. That REQ is the specialize-in home.  
32. This class file **MUST point** at that REQ. **MUST NOT** keep the full coding-style body here. Honest residual **none** is **not** valid.

### 2.11 Implementation Notes (this project)

| Field | Value (this project) |
|-------|----------------------|
| **Project display name** | pomo |
| **Project class** | software-development |
| **Class requirement basename** | `requirement-class-software-dev.md` |
| **Primary language(s)** | posix-sh (`/bin/sh`) |
| **Language role** | primary only |
| **Toolchain / interpreter** | system `/bin/sh` (dash, BusyBox ash, bash-as-sh); no compile step |
| **Toolchain version policy** | unconstrained — any POSIX `sh` that passes `./tests/run.sh` |
| **Cross-compile in scope?** | no |
| **Primary project/package tool** | none (single-file script; no lockfile) |
| **Lockfile policy** | not used |
| **Test runner** | `./tests/run.sh` (POSIX `sh`) |
| **Linter/formatter** | `sh -n` in **TP-CLI-01**; no separate formatter law |
| **Primary runtime / OS family** | POSIX Linux (Alpine/dash primary); macOS sh; Git Bash; **Termux** (this login only) |
| **Architectures supported** | any userspace that has `/bin/sh` (not ISA-pinned) |
| **Git surface** | used for product publish (`Wilgat/pomo`) |
| **Ship unit / install** | `./pomo` at repo root (online-installable; `curl \| sh`) |
| **In-tool sudo** | none — operator `sudo` only on the documented root one-liner / global uninstall warning |

**Residual ownership table:**

| Topic | Owner | Notes |
|-------|-------|-------|
| Project class membership | **this file** | Fixed |
| Primary language / toolchain / package tool | **this file** | POSIX `/bin/sh`; no lockfile |
| Online install / self-management | `requirement-shell-self-management` / zero-arguments / automatic-checksum | Do not duplicate |
| CLI surface | `requirement-shell-cli-interface` | Do not duplicate |
| Domain features / help / about | `requirement-domain-pomo` | Do not duplicate |
| Output SSOT | `requirement-shell-output-requirements` | Do not duplicate |
| Modular prefixes | `requirement-shell-modular-function-design` | Do not duplicate |
| Interactive vs pipe | `requirement-shell-interactive-vs-noninteractive` | Do not duplicate |
| Idempotency | `requirement-shell-idempotency` | Do not duplicate |
| Coding-style related REQ | `requirement-shell-script-coding` / **`RQ-SHELL-SCRIPT-CODING`** | **MUST**; residual **points** only |
| Actor / role / subject / approver | **considered — no dest approver and no approval subject** | No dest review product |
| Dest fence conditions | **considered — no dest fence conditions** | No dest JSON queue |
| Termux / Git Bash / Windows cmd | `requirement-shell-cli-interface` (detect) + peers | Class residual **points**; Type 1/2 unused on that class |

## Under command line for normal user only

When `pomo` runs on Termux, Git Bash, Windows cmd, or the same class (this login only):

| MUST | MUST NOT |
|------|----------|
| Keep **normal user privilege** only | Enable **admin privilege** or **dedicated system user privilege** |
| Point detect and help at CLI-interface | In-tool `sudo`; wrap `apt`/`dnf`; create a dedicated system user; recommend `sudo curl \| sh` |
| Git Bash / Windows cmd: same ceiling | Invoke Termux `pkg` because Git Bash or Windows cmd was detected |

**This requirement:** class residual. Termux is a supported runtime family; privilege freeze lives on CLI-interface and peers.

## 3. Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 2 – Intentional**: Class and stack choices are explicit.  
- **CIAO Principle 5 – SSOT**: Residual stack facts have one home until specialized requirements take ownership.  
- **CIAO Principle 1 – Caution**: Toolchain policy is declared; agents do not invent compilers.  
- **CIAO Principle 21 / dual policies**: Portable core; filled Implementation Notes.

## 4. Design Principles (CIAO / CIAO-Lite)

- **Caution**: Assume `/bin/sh` is dash until proven otherwise; do not rely on bashisms.  
- **Intentional**: Residual collection is deliberate — not a dump of every possible tool.  
- **Anti-fragile**: Unconstrained POSIX `sh` plus a real suite.  
- **Over-protect**: Protection rule prevents dual stack SSOTs and invented dest approvers.

## 5. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

- Create this file (or any requirement) while the workspace is genesis-template.  
- Rename the specialized basename away from `requirement-class-software-dev.md` without an explicit class-model change.  
- Hard-code one product’s host/secret into core rules as universal law.  
- Duplicate full peer requirement bodies into this residual section.  
- Leave Implementation Notes as hollow `TBD` when Status claims Active/done.  
- Treat this file as server-maintenance allowlist law.  
- Skip the actor / role / subject / approver consider, or invent an approver so the table looks complete.  
- Skip dest-fence review, or invent a dest fence so the set looks complete.  
- Skip the coding-style related REQ, or treat coding skills/molds as product law.

**Violating any of these is considered a critical regression.**

## 6. Acceptance criteria

| ID | Criterion |
|----|-----------|
| AC-1 | Active registered `requirement-class-software-dev.md` matches software-development class |
| AC-2 | Primary language + toolchain policy + package tool declared in Implementation Notes |
| AC-3 | Residual ownership table honest: no silent dual SSOT with peer REQs |
| AC-4 | Core rules remain free of frozen host/secret hardcodes |
| AC-5 | No class file conflict with `requirement-class-server-maintenance` |
| AC-6 | Actor / role / subject / approver considered (residual **None**) |
| AC-7 | Dest fence conditions reviewed (residual **none**) |
| AC-8 | Coding-style related REQ Active (`requirement-shell-script-coding`); class residual **points** |

## 7. Related requirements

| Key | Relationship |
|-----|--------------|
| `requirement-shell-script-coding` / `RQ-SHELL-SCRIPT-CODING` | Coding-style related REQ (**MUST**) |
| `requirement-domain-pomo` / `RQ-DOMAIN-POMO` | Domain feature law |
| `requirement-shell-cli-interface` / `RQ-SHELL-CLI-INTERFACE` | Command surface |
| Other Active `requirement-shell-*` | Type 0 lifecycle / output / checksum |

## Design-time verification

**Requirement-ID:** `RQ-CLASS-SOFTWARE-DEV`  
**Map:** `reviews/test-plan.md`

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| Class residual (no dest / coding-style pointer) | n/a — residual + registry honesty | n/a (proven by this file + index) |
| **TP-CLI-01** ship unit syntax | `tests/test_cli.sh` | have (language = posix-sh) |

## 8. Status history

| Date | Status | Note |
|------|--------|------|
| 2026-09-06 | Active | Specialized class residual; coding-style MUST; dest approver/fences considered none |

---

**Last Updated**: 2026-09-06  
**Owner**: Wilgat Wong
