# Reviews registry (pomo)

**Product:** pomo  
**Updated:** 2026-07-24  

## Plans (living)

| Artifact | Role | Status |
|----------|------|--------|
| `what-to-review.md` | Living checklist / review plan | Active |
| `test-plan.md` | Family TP-* → tests/ (**TP-POMO-*** domain) | Active |
| `lessons.md` | L-* prior failure modes | Active |
| `README.md` | Surface rules | Active |

## Reports

| Date | Scope | Path | Verdict | Open items |
|------|-------|------|---------|------------|
| 2026-07-16 | full-product | `reports/2026-07-16-full-product.md` | **Revise** → fixed same day | none (see fix note) |
| 2026-07-16 | full-product-fix | `reports/2026-07-16-full-product-fix.md` | **Pass** (docs remediated) | none |

## Open-item summary

| ID | Severity | Summary | TP | Status |
|----|----------|---------|----|--------|
| POMO-DOC-01 | **bug** (docs/trust) | README CHECKSUM example hash stale vs live companion | **TP-DOC-01** (was TP-21) | **fixed** |
| POMO-DOC-02 | **suggestion** | README claims in-tree `./countdown` while file absent | **TP-DOC-02** (was TP-22) | **fixed** |
| POMO-NIT-01 | **nit** | Ship unit header comment still says “APP NAME: countdown” | **TP-HYG-01** (was TP-23) | **fixed** |
| — | coverage | Online curl\|sh suite (`TP-CURL-*`) not yet ported | **TP-CURL-*** | **todo** |

## Rules

1. Same-change: new report file + index row.  
2. Bugs map to TP rows.  
3. No secrets. Cite live requirements only.
