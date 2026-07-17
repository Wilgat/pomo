# Product reviews (pomo)

Public, git-tracked **product review surface** (peer of `tests/`). Holds living review plans, prior lessons, test-plan lock-in, and committed run reports.

**Not product law** — behavioral authority remains `docs/requirements/` (registry + live `requirement-*.md`).  
**Not harness** — do not dump `docs/skills` / `docs/templates` inventories here.

## Layout

```text
reviews/
  README.md           # this file
  index.md            # registry of plans + reports
  what-to-review.md   # living checklist (review plan)
  test-plan.md        # TP-* → tests/
  lessons.md          # L-* prior failure modes (mandatory load)
  reports/            # durable run reports
```

## Agent rules

1. On durable product review: load **`lessons.md` first**, then **`what-to-review.md`** and **`test-plan.md`**.  
2. Write a **`reports/YYYY-MM-DD-<scope>.md`** for the run; update **`index.md`**.  
3. Map open **bugs** to **TP-*** rows (have / TODO / n/a).  
4. Fold new failure modes into **`lessons.md`**.  
5. No secrets in reports.  
6. Cite live **`requirement-*.md`** and product paths only (no harness tree dumps).  
7. Default scope = this product (`./pomo`); do not reverse-copy onto bootstrap A.

## How to run

```sh
# From product root
./tests/run.sh                    # lock-in evidence
# Then: product-review skill → update reviews/ files
```

**Skill:** `docs/skills/skill-product-review.md` (when harness is loaded)  
**Terms:** review-plan · project-reviews · project-review-folder
