# Persistent Bugs

## PB-1 — Content off-screen + dead version-history FAB on mobile

**Recurrence count:** 4 (v15, v17, v18 fixes didn't hold) → TRUE root found v20
**Device:** Android phone, Brave browser
**Symptom:** (a) content cut off on right edge — page wider than viewport; (b) version-history FAB cannot be tapped / popup never appears.

**Prior fixes that didn't hold (all symptom-patches):**
- v15: bumped `.cols` breakpoint 640→760px — only the grid, root remained
- v17: `overflow-x:hidden` on html/body + `min-width:0` on rows — masked scroll, didn't shrink content; clip can break fixed positioning
- v18: `overflow-x:clip` + `box-sizing` everywhere + overlay-based popup close — still off-screen, FAB still dead

**TRUE root cause (two independent bugs, found v20 by reading the init path, not guessing CSS):**
1. **Dead FAB = script-order bug.** The `#ver-fab`/`#ver-popup`/`#ver-overlay` markup was placed AFTER the `</script>` init block. So `renderVersions()` ran `getElementById("ver-list").innerHTML=…` on a `null` → threw → (i) FAB click-listener never attached, (ii) every init line after it — `renderDietTab/Wardrobe/Schedule/Finances` AND `initSupabase()` — never executed. The "can't click history" was a thrown exception, not CSS. **Fix:** move the markup BEFORE the script.
2. **Width blowout = grid `1fr` min-content floor.** `grid-template-columns:1fr …` has an implicit `min-width:auto`, so a long unbreakable string (e.g. the `https://vivamokykla.lt/kontaktai-2/` task URL in an `<input>`) forces the track wider than the viewport. **Fix:** `minmax(0,1fr)` + global `input,select,textarea{min-width:0;max-width:100%}`.

**Diagnostic left in (v20):** `#diag` red banner reports `innerWidth` vs `scrollWidth` and lists the top overflowing elements on-screen (tap to dismiss). Remove once owner confirms width is clean on-device.

**Lesson:** three CSS-guessing rounds failed because one symptom (dead FAB) was a JS exception and the other (width) needed the actual offending element identified, not blanket `overflow:hidden`. Reading the render path + on-screen instrumentation found both in one pass.
