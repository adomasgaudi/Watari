# AI schema

Events, hooks, and permissions that govern this project. Rules → [CLAUDE.md](CLAUDE.md).

---

## Events

`*CLAUDE Hardcoded:*` = built-in, unchangeable. `*watari:*` = this project's hook.

## **SessionStart**

chat opens/resumes; stdout injected.

### *CLAUDE Hardcoded:*
- read [CLAUDE.md](CLAUDE.md)
- read `.claude/settings`\*
- read env block
- read git status
- read skills / agents / MCP

* *watari:* none.

## **UserPromptSubmit** — your msg, before AI reads it; exit `2` blocks.

### *CLAUDE Hardcoded:*
- `<system-reminder>` notes + recalled memory.

* *watari:* `rule_schema_reminder.py` → rule-add/change prompt → injects hook-vs-context framework.
* *watari:* `ui_design_reminder.py` → UI/design prompt → injects [UI.md](UI.md) rubric + tells the AI to ask the owner for a screenshot via AskUserQuestion first.
* *watari:* `debug_reminder.py` → debug tag → injects debug-mode instructions.

## **PreToolUse** — before a tool runs; can block/deny.

### *CLAUDE Hardcoded:*
- permission prompt + IDE diff on Edit/Write.

* *watari:* `commit_message_check.py` → `git commit` → warns if the subject misses the house format `vN CODE-NN | desc | n sp` (non-blocking).
* *watari:* `guard_main_push.py` → warns a *desktop* session committing/pushing to main (web exempt). `require_main_push.py` → `git push` to a *non-main* branch → warns to move the work to main (REPO-01, non-blocking).

## **PostToolUse** — after a tool finishes.

### *CLAUDE Hardcoded:*
- "file changed since read" + linter notes; todo nudge.

* *watari:* `version_reminder.py` → edit `template.html` → badge/SP/rebuild reminder.

## **Notification** — needs input/permission, or idle.

### *CLAUDE Hardcoded:*
- permission popup / idle ping.

* *watari:* none.

## **Stop** — main agent finishes; exit `2` forces continue.

### *CLAUDE Hardcoded:*
- none.

* *watari:* `save_reminder.py` → at end of turn, if the tree is dirty or `main` has unpushed commits → reminds to commit + push main (REPO-01, non-blocking).

## **SubagentStop** — subagent (Task) finishes; exit `2` forces continue.

### *CLAUDE Hardcoded:*
- none.

* *watari:* none.

## **PreCompact** — before context is compacted.

### *CLAUDE Hardcoded:*
- none.

* *watari:* none.

## **SessionEnd** — session ends (quit, `/clear`).

### *CLAUDE Hardcoded:*
- none.

* *watari:* none.

---

## Settings files

| File | Scope | Holds |
| --- | --- | --- |
| [`.claude/settings.json`](.claude/settings.json) | watari only | hooks |

**Hooks** (all non-blocking, in watari):
- **SessionStart** → sets git user + `core.hooksPath .githooks`
- **UserPromptSubmit** → `ui_design_reminder.py`, `rule_schema_reminder.py`, `debug_reminder.py`
- **PreToolUse** (`Bash`) → `guard_main_push.py`, `require_main_push.py`, `commit_message_check.py`
- **PostToolUse** (`Edit|Write`) → `version_reminder.py`
- **Stop** → `save_reminder.py`

---

## Claude inner — hardcoded, not hooks

Can't change these — only attach hooks alongside.
- **Memory** — loads CLAUDE.md (hook runs code; memory loads text).
- **System reminders** — `<system-reminder>` notes + todo nudge, auto-injected.
- **Permissions** — the `permissions.allow` list, checked before each tool.

---

# hooks vs context

Two mechanisms change behaviour; every other label is just text.

## The two mechanisms

- **Hook** — code that runs on an event (SessionStart · UserPromptSubmit · PreToolUse · PostToolUse · Stop).
  - We use it as **aggressive, conditional context** — detects a condition, injects the right reminder.
  - Trigger is deterministic; the AI's response stays its own. Lives in `.claude/settings.json`.
  - Can hard-block, but we don't — it informs, never force-blocks or auto-fixes.
- **Context** — text injected into the window (this file, CLAUDE.md, tool output).
  - Read, not run → influences only, probabilistically. Can be forgotten.
  - Effect decays with length and mid-document position. Naming it "rule" changes nothing.

Real split isn't hard-vs-soft — both inform. It's **always-on vs. fired-on-condition**:
- Plain Context is always in the window, and decays.
- A hook fires only on its trigger — lands sharp, costs nothing when irrelevant.

## Three ways to put text in front of the model

Pick per rule, by when and whether it loads:
- **Plain Context** — lives in CLAUDE.md, always loaded. For short, always-relevant rules.
- **`@import`** — `@other.md` in CLAUDE.md, always loaded, whole file. For a whole reference doc.
- **Hook-injected Context** — a hook prints `additionalContext`, loaded only when its condition fires.
  - Zero cost when irrelevant; lands at the right moment; only as reliable as its trigger.
  - Our default for any rule a program can detect.

Quick pick:
- short + always-relevant → plain Context
- big doc + always-relevant → `@import`
- only-sometimes-relevant + program-detectable → hook-injected Context

## The hook test

Can a program detect when it's relevant — binary, no judgment?
- **Yes → hook-injected reminder.** Fires when it applies; detection is the verifiable part.
- **No → plain Context.** Always-on, advisory, read with judgment.

Corollary: nothing here force-blocks. A bad trigger gets sharper, not a harder gate.

## Behaviours a program can detect (→ hook injects context, not a block)

Each line is a *trigger → what the hook reminds*, on the named event.
- (PostToolUse) template changed, badge not bumped → remind to bump.
- (PostToolUse) new history entry missing its SP value → remind to add.
- (Stop) tree not clean or `main` not pushed → remind to save.
- (SessionStart) git user + hooksPath configured automatically.

## Behaviours that can only be Context (judgment → advisory, never a hook)

- is the SP estimate fair? (effort vs value)
- is the design compact / on-brand? (taste)
- fixed the whole bug *class*, not just the shown case?
- merge conflicts resolved feature-by-feature, never one side wholesale?

## Adding a behaviour

- One line → apply the hook test → **Hook** (build it) or **Context** (advisory).
- A behaviour isn't enforced until its hook exists. The name never enforces anything.
