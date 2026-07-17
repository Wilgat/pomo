# Report: full-product-fix — pomo 2.0.0

**Date:** 2026-07-16  
**Mode:** implement remediation for open product-review items  
**Status:** clean (prior open items closed)  
**Prior report:** `2026-07-16-full-product.md`  
**Tests after fix:** `./tests/run.sh` → **PASS=181 FAIL=0 SKIP=0**

---

## Summary

All open findings from the full-product review were fixed:

| ID | Fix |
|----|-----|
| **POMO-DOC-01** | README pin path now loads digest from live `pomo.sha256` channel URL (no frozen wrong hash); automatic companion remains primary story |
| **POMO-DOC-02** | Architecture blurb: countdown is lineage A→B; in-tree `./countdown` optional if present |
| **POMO-NIT-01** | Ship unit header: `APP_NAME` default **pomo** |

Companion `pomo.sha256` regenerated after ship-unit comment edit.

---

## Issues

### Issue 1 — POMO-DOC-01 — **Status: fixed**

- README optional pin uses `curl …/pomo.sha256 | awk '{print $1; exit}'`.  
- Integrity note: automatic default; pin secondary; mismatch aborts; regenerate companion on publish.

### Issue 2 — POMO-DOC-02 — **Status: fixed**

- No claim that `./countdown` is always kept in-tree.

### Issue 3 — POMO-NIT-01 — **Status: fixed**

- Comment aligns with Config default.

---

## Test-plan

| TP | Status |
|----|--------|
| TP-21 | closed |
| TP-22 | closed |
| TP-23 | closed |

---

## Verdict

**Pass** — prior **Revise** docs items remediated; suite still green.
