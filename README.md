# NewGen 团队分工规划

Interactive team task board for the NewGen Growth Ecosystem. Tracks department key tasks and individual member todos with priority labels, drag-and-drop reassignment, and versioned HTML snapshots.

**Live:** https://lucalinkai.github.io/newgen-taskboard/

## Using the board

| Action | How |
|--------|-----|
| Enter edit mode | Press `E` or click **✏ 编辑** |
| Exit edit mode + save | Press `E` again or click **💾 完成** |
| Save to browser | `Cmd/Ctrl + S` |
| Cycle task priority | Click the priority badge |
| Reorder / reassign task | Drag the `⠿` handle |
| Export versioned snapshot | Click **↓ 导出** |
| Reset to defaults | Click **↺ 重置数据** |

## Publishing an update

Edit locally, export a snapshot, then publish in one command:

```bash
./publish.sh "NewGen_Team_Interactive_v1.0.2_20260605-150000.html"
```

This copies the exported file to `index.html`, commits, and pushes. GitHub Pages redeploys in ~60 seconds.

To publish the working file directly without exporting:

```bash
./publish.sh
```

## How versioning works

- The current version is stored inside the data object (`data.version`) and displayed in the header
- **↓ 导出** increments the patch number (`1.0.0 → 1.0.1`) and bakes the current state into `DEF` in the exported file
- Opening an exported file starts with that exact saved state — no localStorage dependency
- Each visitor on the live site gets their own isolated localStorage; the shared source of truth is whatever is in `index.html` on `main`

## Files

| File | Purpose |
|------|---------|
| `NewGen_Team_Interactive.html` | Working copy — edit this locally |
| `index.html` | Published copy served by GitHub Pages (updated by `publish.sh`) |
| `publish.sh` | One-command publish script |
| `.github/workflows/deploy.yml` | Auto-deploy to Pages on every push to `main` |
