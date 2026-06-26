# Events Hooks Rules Context

Hook-vs-context framework + full events/hooks/permissions map → [Schema.md](Schema.md).

## Tags

Shorthands the owner may type. Unknown tag → search for the closest, act on it, confirm.

- **`#remember`** — persist a rule/preference durably, then confirm where saved
- **`#co-work`** — other AIs editing at once: don't camp on hot files, merge often
- **`#careful`** — risky/many-part work: split, plan first, one part per turn
- **`#senior`** — reason like the long-term owner: SSOT, invariants, root cause, blast radius
- **`#prune`** — fix the whole class, not just the shown case; sweep every sibling
- **`#debug`** — a MODE, not a strong word: ABANDON/simplify the current task, 10× the ON-SCREEN logging (fixed-position panel, version-stamped — owner has no phone devtools), smallest increments one step at a time, leave diagnostics in until the ROOT is proven (enforced by `debug_reminder.py` hook)
- **`#persistent`** / **`#repeating`** — a recurring bug; log it, fix the root not the symptom
- **`#super-persistent`** — defied many fixes: bisect history + on-screen diagnostic
- **`#max-debug`** / **`#max`** — escalate debugging effort
- **`#research`** — research best practices inline, grade each source
- **`#design`** — a look/feel choice to remember + apply everywhere (sweep siblings)
- **`#ui`** — think extra about a control's purpose/frequency/placement before building
- **`#cram`** / **`#cramp`** — make UI maximally compact; drop redundant labels
- **`#tokens`** — analyse token/model efficiency, give one recommended action
- **`#toggle`** — use pressable pills, not checkboxes/segmented rows

## Rules

Each rule = two rows: **description**, then *kind · type*. Sorted by theme, then TOP → MED → LOW → Unclear within each.

---

### Build & Git

| Rule | Description / mechanics |
| --- | --- |
| **BULD-01** Edit source | Edit `src/template.html`, never `index.html`; rebuild `python3 src/build_site.py` |
| <br /> | Context · verifiable · TOP |
| **REPO-01** Save | commit + push to `main` after every change — owner only sees the live site; then send rebuilt `index.html` |
| <br /> | Context · verifiable · TOP |
| **REPO-03** Sync first | before work, `git fetch origin main` + rebase/merge (parallel AIs edit at once) |
| <br /> | Context · verifiable · TOP |
| **BULD-02** Version badge | one continuous counter everywhere — bump the patch digit (C in vA.B.C) on **every commit/deploy**, and sync all four spots: `<title>` tag, `.nav-version` badge, `<h1> .version` badge, top `VERSIONS` entry = git commit `vN`; A/B owner-only |
| <br /> | Hook [`version_reminder.py`](.claude/hooks/version_reminder.py) · verifiable · MED |
| **BULD-03** Story points | 0.5–10 per update, effort/time not LOC; logged in `VERSIONS` array, shown via SP history modal |
| <br /> | Hook [`version_reminder.py`](.claude/hooks/version_reminder.py) · mixed · MED |
| **GIT-01** Commit format | `vN RULE-ID \| short description \| N sp` — `vN` is the patch digit only (e.g. `v3`); RULE-ID is the primary rule driving the change; sp = story points. Off-format subjects trigger a loud ⛔ reminder. |
| <br /> | Hooks [`commit_message_check.py`](.claude/hooks/commit_message_check.py) (Claude) + [`.githooks/commit-msg`](.githooks/commit-msg) (git) · verifiable · TOP |
| **HOOK-01** Scripted checks, never gates | Back every strong warning with a scripted check, but it only ever emits data — never blocks; always `exit 0`. Enforce across CLI, VS Code, Cursor and plain terminal via `.githooks/` + `core.hooksPath`. |
| <br /> | Hook [`.githooks/`](.githooks/) + SessionStart sets `core.hooksPath` · verifiable · TOP |
| **REPO-02** Branch | work from `main`; merge back immediately — never strand work on a side branch |
| <br /> | Hook [`guard_main_push.py`](.claude/hooks/guard_main_push.py) · verifiable · MED |

---

### Conversation & Response

| Rule | Description / mechanics |
| --- | --- |
| **CONV-03** Asks → AskUserQuestion | needs owner to do/check/pick → pop a question, never bury it in prose |
| <br /> | Context · judgment · TOP |
| **DATA-04** Reply format | details first (2-5w titles + 5-15w desc), summary last with one-line titles only |
| <br /> | Context · judgment · TOP |
| **CONV-02** Never claim unseen visuals | can't see the live site; say "I changed X, please check", never "it's fixed" |
| <br /> | Context · judgment · MED |
| **CONV-04** No "what's next" asks | done + nothing mid-stream → say so in one line and stop; don't manufacture a prompt |
| <br /> | Context · judgment · MED |
| **DATA-11** Severity-tagged options | every suggestion gets a code + severity (🔴🟠🟢); say when not worth doing |
| <br /> | Context · judgment · MED |

---

### Debugging & Process

| Rule | Description / mechanics |
| --- | --- |
| **DBG-01** Fix fails once → debug | stop guessing; log the whole path, smallest increments, one step at a time |
| <br /> | Context · judgment · TOP |
| **DBG-02** Debug by contrast | start from a sibling that already works; ask how the broken one differs |
| <br /> | Context · judgment · TOP |
| **DATA-25** Unknown tag → search first | grep memories/notes for the closest rule, act on that; never silently skip |
| <br /> | Context · judgment · TOP |
| **DATA-33** Super-persistent → bisect | bug surviving many fixes → git bisect + on-screen diagnostic, fix the root |
| <br /> | Context · judgment · TOP |
| **DATA-51** On-screen debug console | phones have no devtools; instrument every step of a failing flow on-screen |
| <br /> | Context · judgment · TOP |
| **PROC-01** Forgotten rule → hook it | a rule that keeps slipping gets a machine check, not more prose |
| <br /> | Context · judgment · TOP |
| **PROC-05** Fix root, not symptom | ask why the bug is possible until the design flaw; fix the whole class |
| <br /> | Context · judgment · MED |

---

### UI & Design

| Rule | Description / mechanics |
| --- | --- |
| **UI-01** Screenshot-first design | UI change → ask owner for a screenshot via AskUserQuestion, score it against the [UI.md](UI.md) rubric, then render → critique → refine (never one-shot) |
| <br /> | Hook [`ui_design_reminder.py`](.claude/hooks/ui_design_reminder.py) · judgment · TOP |
| **DATA-46** Loading states everywhere | every async op + heavy re-render shows an immediate indicator; never frozen |
| <br /> | Context · judgment · TOP |
| **DATA-16** Cram tight | match the tightest existing UI; drop redundant labels; one scrolling row |
| <br /> | Context · judgment · MED |
| **DATA-22** Small rounding | no full/pill rounding on buttons/chips/inputs; use a small-radius token |
| <br /> | Context · verifiable · MED |
| **DATA-17** Snappy clicks | a tap updates its own control instantly; defer heavy re-renders, coalesced |
| <br /> | Context · judgment · LOW |
| **DATA-27** UI layout is yours | decide size/placement yourself; don't punt it to the owner |
| <br /> | Context · judgment · LOW |

---

### Meta / AI ops

| Rule | Description / mechanics |
| --- | --- |
| **DATA-40** Model + version line | end each reply with the model and `v.x -> v.y` shift; name what changed — never a bare number |
| <br /> | Context · verifiable · TOP |
| **DATA-36** Default model | use the cheapest capable model for routine work; escalate only on failure |
| <br /> | Context · verifiable · MED |

---

# Project context

## Project idea

- Project: **Watari** — [describe the project here when the purpose is defined].
- Built by **Adomas** working under (<g@cool.lt>) account.

## Files & build

- `src/template.html` — source of all HTML/CSS/JS. **Edit this.**
- `src/build_site.py` — injects data into template → `index.html` at repo root.
- `index.html` — generated, self-contained. **The deliverable; never hand-edit.** Stays at repo root for GitHub Pages.
- Workflow: edit `src/template.html` → `python3 src/build_site.py` → commit + push `main` → send `index.html`.

## Environment

- Branches: `main` (canonical).
- GitHub Pages serves `index.html` from the repo root.
