# Report: full-product — pomo 2.0.0

**Date:** 2026-07-16  
**Mode:** full product review with review plans (`skill-product-review`)  
**Status:** open items (docs) → **remediated** in `2026-07-16-full-product-fix.md`  
**Ship unit:** `./pomo` (`VERSION=2.0.0`)  
**Tests:** `./tests/run.sh` → **PASS=181 FAIL=0 SKIP=0**  
**Lessons loaded:** L-01…L-14 (file created this run; seeded from incidents + prior requirement review)

---

## Summary

Pomo’s **Type 0 + pomodoro domain** implementation is in strong shape: automated suite is fully green, domain verbs appear in `help`, `CHECKSUM` is absent from help/about, companion digest matches the ship unit body, and product law is registered (eight shell REQs + `requirement-domain-pomo`).

The **`reviews/`** surface did not exist; this run **creates** the living review plan (`what-to-review.md`, `test-plan.md`, `lessons.md`) and this report.

Primary defects are **user-doc honesty / integrity examples**, not runtime suite failures:

1. README still embeds a **stale CHECKSUM pin** (does not match live `pomo.sha256`).  
2. README claims bootstrap kept **in-tree as `./countdown`**, but that file is **absent**.  

Verdict: **Revise** (fix docs) — not Block on ship-unit behavior given green suite.

---

## Scope covered

| Area | Result |
|------|--------|
| Lessons re-check | See § Lessons |
| Registry product law | 9 Active; domain prefix OK |
| Ship unit Type 0 + domain smoke | help/about/version OK; suite green |
| README / SECURITY install story | Findings POMO-DOC-01/02 |
| Tests lock-in | TP-01…TP-20 **have**; TP-21/22 **TODO** |
| Bootstrap reverse-copy | No evidence of domain write-back to A |

---

## Lessons re-check

| ID | Result |
|----|--------|
| L-01 pipe/bootstrap entry | **Pass** — `app_main` always; tests cover install path |
| L-02 phantom law cites | **Pass** — ship unit ALIGNMENT lists live REQs only |
| L-03 channel URL | **Pass** — README one-liner matches Wilgat/pomo |
| L-04 primary install path | **Pass** — curl\|sh first; pin section secondary (wording still improvable) |
| L-05 registry harness dump | **Pass** — index is requirement rows only |
| L-06 set -u defaults | **Pass** — suite green; defaults present in Config |
| L-07 uninstall fake success | **Pass** — suite covers refuse / force |
| L-08 checksum trust model | **Pass** runtime/suite; **Fail docs** on stale pin example (→ L-12) |
| L-09 AGENTS exposure | **Pass** — AGENTS gitignored pattern |
| L-10 reverse-copy | **Pass** — no countdown overwrite |
| L-11 domain prefix | **Pass** — `requirement-domain-pomo` |
| L-12 stale README pin | **Fail** — see Issue 1 |
| L-13 countdown disk honesty | **Fail** — see Issue 2 |
| L-14 reviews surface missing | **Closed this run** — tree created |

---

## Strengths

1. **181 automated tests** covering CLI, install lifecycle (local channel), and domain.  
2. **Domain help** lists start/status/watch/skip/stop/kill/list/stats/theme + flags.  
3. **Integrity model** in code: automatic companion + secondary pin; CHECKSUM not in help/about.  
4. **Domain law** has four pillars after 2026-07-16 requirement follow-ups.  
5. **Registry discipline** for product law is clean (no orphans).  

---

## Issues

### Issue 1 — Severity: **bug** (docs / operator trust)

- **ID:** POMO-DOC-01  
- **File:** `README.md` (Secure manual installation / CHECKSUM example)  
- **Description:** Example pin uses hash `94ea2077…` while live companion `pomo.sha256` is `fe9b8611…` (matches current `./pomo`). Operators following the README pin will get a **mismatch abort** after regenerating ship unit without updating the doc.  
- **Suggestion:** Update pin to current companion **or** remove hard-coded pin and document “use value from `pomo.sha256` / release assets”; prefer automatic companion as primary story.  
- **Lesson:** L-12  
- **Test:** TP-21  
- **Status:** **fixed** (2026-07-16-full-product-fix)  

### Issue 2 — Severity: **suggestion** (stay-honest)

- **ID:** POMO-DOC-02  
- **File:** `README.md` (Architecture blurb ~line 20)  
- **Description:** States countdown is “kept in-tree as `./countdown` for reference,” but `./countdown` is **not present** on disk.  
- **Suggestion:** Align with domain REQ wording: lineage countdown A→B; in-tree copy optional if present.  
- **Lesson:** L-13  
- **Test:** TP-22  
- **Status:** **fixed** (2026-07-16-full-product-fix)  

### Issue 3 — Severity: **nit**

- **ID:** POMO-NIT-01  
- **File:** `pomo` header comment (~line 27)  
- **Description:** Comment still says “APP NAME: countdown via APP_NAME” though default is `pomo`.  
- **Suggestion:** Fix comment to match Config SSOT.  
- **Lesson:** —  
- **Test:** TP-23 (n/a)  
- **Status:** **fixed** (2026-07-16-full-product-fix)  

---

## Non-findings (explicit)

| Topic | Note |
|-------|------|
| Runtime suite | Green; no FAIL cases this run |
| Domain prefix in law | Already `requirement-domain-pomo` |
| Help CHECKSUM leak | Not present |
| Self-hash inside ship unit | Not present |

---

## Test-plan deltas

| TP | Action |
|----|--------|
| TP-01…TP-20 | Confirmed **have** via suite |
| TP-21 | **TODO** — README pin vs companion |
| TP-22 | **TODO** — countdown disk honesty |
| TP-23 | **n/a** — comment nit |

---

## Remediation order

1. **POMO-DOC-01** — fix README CHECKSUM example / story (trust)  
2. **POMO-DOC-02** — fix architecture bootstrap wording  
3. **POMO-NIT-01** — header comment  

---

## Verdict

**Revise** — ship unit + automated tests **Pass**; product **docs** need honesty fixes before claiming install-docs complete.

**Edits this run:** created `reviews/**` plan surface + this report only (no product code/README fix unless follow-up authorized).
