# Persistent Bugs

## PB-1 — Horizontal overflow / scroll on mobile

**Recurrence count:** 2 (v15 fix didn't hold)
**Device:** Android phone, Brave browser
**Symptom:** Page scrolls horizontally; content cut off on right edge (task cards, buttons, inputs).
**Prior fixes that didn't hold:**
- v15: bumped `.cols` breakpoint from 640px to 760px — only fixed the two-column grid, root remained
**Root cause:** `html` and `body` had no `overflow-x:hidden`; any element wider than viewport silently expanded the scroll area. Also flex children without `min-width:0` can overflow their container.
**Root fix (v17):**
- `html { overflow-x: hidden }` + `body { overflow-x: hidden; max-width: 100% }`
- `.panel.active { overflow-x: hidden }` + `main { width: 100% }`
- `.add-row { width: 100% }` + `.add-input { min-width: 0 }` (flex-shrink fix)
- All row/card elements: `max-width: 100%; min-width: 0`
