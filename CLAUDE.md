# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A single self-contained HTML file (`NewGen_Team_Interactive.html`) — a bilingual (Chinese UI) interactive team task board for the NewGen Growth Ecosystem. No build step, no package manager, no server. Open the file directly in any browser.

## Running it

```bash
open NewGen_Team_Interactive.html   # macOS
```

Or drag the file into a browser window.

## Architecture

Everything lives in one file with three layers:

**Data layer** — `DEF` is the hardcoded default state (departments → members → todos). On load, `loadData()` hydrates from `localStorage` key `ng-plan`; every mutation calls `save()` to persist back. Reset wipes localStorage and re-clones `DEF`.

**Render layer** — Pure string-template functions: `rPage()` → `rLeads()` + `rDept()` → `rMember()` → `rTodo()` / `rKeyTask()`. Full re-render only happens on `rPage()` (initial load and reset). Incremental DOM mutations (add/delete items) are done surgically without re-rendering the whole page.

**Event layer** — Three delegated listeners on `document` (`click`, `blur`, `keydown`). All interactivity is dispatched via `data-act` attributes on elements:
- `chk` — toggle todo done
- `cyc` — cycle priority through `PO` order
- `del` / `delkt` — delete todo / key task
- `addtodo` / `addkt` — add new todo / key task
- `etxt` / `ekt` — save contenteditable text on blur
- `reset` — restore defaults

**Drag-and-drop** — SortableJS (`group:'tasks'`) enables cross-member task reassignment. Each `.todo-list[data-mid]` gets its own Sortable instance stored in `_sortables`. After a cross-list drag the task is spliced out of `fm.todos` and into `tm.todos` and `save()` is called.

## Key constants

| Constant | Purpose |
|----------|---------|
| `PRI` | Priority definitions: `urgent`, `week`, `ongoing`, `asneeded` — each has label, bg color, text color |
| `PO` | Priority cycle order array |
| `META` | Per-department visual theme (color, light bg, border, icon letter) for `overall`, `tech`, `marketing`, `backoffice` |
| `DEF` | Default full data tree — edit this to change shipped defaults |

## External CDN dependencies

- **SortableJS 1.15.0** — drag-and-drop
- **Google Fonts** — Playfair Display (headings), DM Sans (body)

Both are loaded from CDN; the file requires internet access to render correctly. For offline use, inline or self-host these resources.
