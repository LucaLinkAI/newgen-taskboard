# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A single self-contained HTML file (`NewGen_Team_Interactive.html`) — a bilingual (Chinese UI) interactive team task board for the NewGen Growth Ecosystem. No build step, no package manager, no server. Open the file directly in any browser.

## Running it

```bash
open NewGen_Team_Interactive.html   # macOS
```

## Publishing to GitHub Pages

```bash
./publish.sh "NewGen_Team_Interactive_v1.0.2_TIMESTAMP.html"  # from an export
./publish.sh                                                   # from working file directly
```

`publish.sh` copies the file to `index.html`, commits, and pushes. The GitHub Actions workflow (`.github/workflows/deploy.yml`) deploys to Pages automatically on every push to `main`. Live URL: https://lucalinkai.github.io/newgen-taskboard/

## Architecture

Everything lives in one file with three layers:

**Data layer** — `DEF` is the hardcoded default state (departments → members → todos), wrapped in `/*DEF_START*/` / `/*DEF_END*/` sentinel comments. On load, `loadData()` hydrates from `localStorage` key `ng-plan`; every mutation calls `save()`, which also stamps `data.lastUpdated` and updates the header meta line. `data.version` tracks the current version string (e.g. `"1.0.1"`). Reset wipes localStorage and re-clones `DEF`.

**Render layer** — Pure string-template functions: `rPage()` → `rLeads()` + `rDept()` → `rMember()` → `rTodo()` / `rKeyTask()`. Full re-render only on `rPage()` (initial load and reset); incremental DOM mutations for add/delete. `rPage()` calls `applyEditMode()` at the end to restore edit state after re-render.

**Event layer** — Three delegated listeners on `document` (`click`, `blur`, `keydown`). All interactivity dispatched via `data-act` attributes:
- `editToggle` — toggle edit mode (`setEditMode`)
- `exportHtml` — export versioned snapshot (`exportHtml`)
- `chk` — toggle todo done
- `cyc` — cycle priority through `PO` order
- `del` / `delkt` — delete todo / key task
- `addtodo` / `addkt` — add new todo / key task
- `etxt` / `ekt` — save contenteditable text on blur
- `reset` — restore defaults

## Edit mode

`isEditMode` (default `false`) controls whether the board is editable:
- **View mode**: `.todo-text` and `.keytask-text` have `pointer-events:none`; add/delete/drag buttons hidden via CSS (`body:not(.edit-mode)` selectors)
- **Edit mode**: `contenteditable="true"` added to all text elements; controls shown; body gets class `edit-mode`
- `setEditMode(on)` toggles state, calls `applyEditMode()`, and auto-saves + shows toast on exit
- `E` key or `✏ 编辑` button to toggle; `Cmd/Ctrl+S` saves to localStorage without exiting edit mode

## Export mechanics

`exportHtml()`:
1. Bumps `data.version` patch (`bumpVersion`), calls `save()`
2. Temporarily clears `#app.innerHTML`, serializes `document.documentElement.outerHTML`, restores — produces clean HTML with empty `<div id="app"></div>`
3. Replaces `/*DEF_START*/…/*DEF_END*/` block with `const DEF = <current data as JSON>;`
4. Uses `showSaveFilePicker` (Chrome/Edge) with suggested filename `NewGen_Team_Interactive_v<version>_<timestamp>.html`; falls back to blob download

## Key constants

| Constant | Purpose |
|----------|---------|
| `PRI` | Priority definitions: `urgent`, `week`, `ongoing`, `asneeded` — each has label, bg color, text color |
| `PO` | Priority cycle order array |
| `META` | Per-department visual theme (color, light bg, border, icon letter) for `overall`, `tech`, `marketing`, `backoffice` |
| `DEF` | Default full data tree — edit this to change shipped defaults |

## File roles

| File | Purpose |
|------|---------|
| `NewGen_Team_Interactive.html` | Working copy — edit locally |
| `index.html` | Published copy for GitHub Pages (managed by `publish.sh`) |
| `publish.sh` | Copies working/exported file → `index.html`, commits, pushes |
| `.github/workflows/deploy.yml` | GitHub Actions: deploy to Pages on push to `main` |

## External CDN dependencies

- **SortableJS 1.15.0** — drag-and-drop
- **Google Fonts** — Playfair Display (headings), DM Sans (body)

Both loaded from CDN; the file requires internet access to render correctly.
