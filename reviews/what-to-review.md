# What to review (pomo) — living checklist

**Product:** pomo v2.0.1  
**Ship unit:** `./pomo`  
**Domain SSOT:** `docs/requirements/requirement-domain-pomo.md`  
**Domain TP family:** **`TP-POMO-*`** (not `TP-DOM-*`; policy-harness-id-notation §5)  
**Bootstrap lineage:** countdown (A) → pomo (B); **no reverse-copy**

Load **`lessons.md`** before every run. This file is the **review plan** surface checklist (term: review-plan).

---

## Pre-flight

- [ ] Load `reviews/lessons.md` (L-01…L-14)  
- [ ] Load `docs/requirements/index.md` (registry-only law; confirm no foreign orphans)  
- [ ] Confirm scope: full product / domain / Type 0 / docs / origin  
- [ ] Note ship unit version (`VERSION` in `./pomo`) vs README badge  
- [ ] Run or cite latest `./tests/run.sh` result  

---

## Product law surfaces

| Surface | Check |
|---------|--------|
| Registry | 9 Active rows; Area `shell` vs `domain` correct |
| Type 0 REQs | CLI, zero-arg Type O, output, self-mgmt, checksum, interactive, idempotency, modular |
| Domain REQ | Four pillars: subcommands, features, help, about; basename `requirement-domain-*` |
| ALIGNMENT | Ship unit cites only registered requirement basenames |

---

## Ship unit high-risk paths

| Path / concern | Lesson | Check |
|----------------|--------|--------|
| Entry / pipe install | L-01 | `app_main "$@"` always; no basename gate |
| Output SSOT | — | User messages via `out_*` |
| Install + self-update integrity | L-08 | Automatic companion; pin secondary; no self-hash in body |
| CHECKSUM not in help/about | L-08 | Help Environment / about JSON free of CHECKSUM |
| Type O empty argv | — | Not installed → install-ensure; already installed → no-op not help |
| Uninstall non-interactive | L-07 | Without `--force` → fail closed |
| Domain path-safe names | — | `/` and `..` → `invalid_name` |
| Domain already-running | — | Second start same name → non-zero |
| Domain stats count rules | — | stop counts; kill does not |
| Watch vs JSON | — | `watch --json` non-zero |
| Reverse-copy | L-10 | No domain write-back to countdown |

---

## User / security docs

| Doc | Check |
|-----|--------|
| README install one-liner | Matches channel SSOT (L-03, L-04) |
| README CHECKSUM example | Matches live `pomo.sha256` or clearly “regenerate” (L-12) |
| README integrity story | Automatic primary; pin secondary (not “highest”) |
| README bootstrap claim | `./countdown` only if present (L-13) |
| SECURITY.md | Honest trust bounds for companion digest |
| LICENSE / author-email | Present when specialized |

---

## Tests lock-in

- [ ] `./tests/run.sh` PASS with FAIL=0 (or documented environment block)  
- [ ] Suites: `test_cli.sh` (**TP-CLI**), `test_install_lifecycle.sh` (**TP-LC** / **TP-CSUM**), `test_pomo_domain.sh` (**TP-POMO-***)  
- [ ] Assert labels include primary **TP-IDs** (id-notation)  
- [ ] Open bugs mapped in `test-plan.md` (family TP-*)  
- [ ] Residual: **TP-CURL-*** suite still **todo** (parity with countdown/timer)  

---

## Origin / chain (when in scope)

- [ ] Direction A→B only  
- [ ] Optional in-tree countdown: disk-truth only  
- [ ] Domain oracle `pomo-1.7.0-domain-ref` is reference, not ship unit  

---

## Publish steps (after run)

1. Write `reports/YYYY-MM-DD-<scope>.md`  
2. Update `index.md`  
3. Merge new modes into `lessons.md`  
4. Update `test-plan.md` TP rows  
5. Adjust this file if a permanent surface appeared  
