# Editor basics (Cursor)

Cursor uses the VS Code editor. Stay on the keyboard. Official reference: [VS Code Basic editing](https://code.visualstudio.com/docs/editing/codebasics).

Bindings below use **macOS** first, then Windows/Linux in parentheses. Open **Keyboard Shortcuts** to change any of them, or install a Vim / Sublime / Atom keymap.

## Everyday

| Action | Shortcut |
| --- | --- |
| Command Palette | `Cmd+Shift+P` (`Ctrl+Shift+P`) |
| Quick Open file | `Cmd+P` (`Ctrl+P`) |
| Save | `Cmd+S` (`Ctrl+S`) |
| Find in file | `Cmd+F` (`Ctrl+F`) |
| Replace in file | `Cmd+H` (`Ctrl+H`) |
| Search the folder | `Cmd+Shift+F` (`Ctrl+Shift+F`) |
| Go to definition | `F12` or `Cmd+Click` (`Ctrl+Click`) |
| Format file | `Shift+Option+F` (`Shift+Alt+F`) |
| Toggle word wrap | `Option+Z` (`Alt+Z`) |
| Undo / Redo | `Cmd+Z` / `Cmd+Shift+Z` |

Turn on **File → Auto Save** if you do not want to hit Save. Unsaved tabs show a dot; Cursor keeps a backup if the window dies (hot exit).

## Multi-cursor

- `Option+Click` (`Alt+Click`) adds another cursor. Each cursor edits on its own.
- `Cmd+Option+Down/Up` (`Ctrl+Alt+Down/Up`) stacks cursors on the next or previous line.
- `Cmd+D` (`Ctrl+D`) selects the next match of the current word. Skip a match with the “move selection to next find match” command if you overshoot.
- `Cmd+Shift+L` (`Ctrl+Shift+L`) selects every occurrence of the current selection.

If a GPU driver stole `Alt+Click`, switch the multi-cursor modifier in settings (`editor.multiCursorModifier`) to `Ctrl/Cmd+Click`. Go to Definition then uses the other modifier so the two gestures do not collide.

Hold `Shift+Option` (`Shift+Alt`) and drag for a column (box) selection. **Selection → Column Selection Mode** keeps that behavior on until you turn it off.

## Find, replace, search

In-file Find highlights as you type. Enable regex, match case, or whole word from the Find widget. Paste multiline text into Find; `Ctrl+Enter` inserts a newline in the box.

Folder Search sits in the sidebar. Use include/exclude globs (`*.js`, `./apps/demo`). The ignore toggle honors `.gitignore`. Expand the widget to replace across files; review the diff before Replace All.

Open **Search Editor** when you want results in a normal tab with context lines. From the Search view: **Open in editor**.

Regex replace can change case of a capture (`\u`, `\U`, `\l`, `\L` on `$1`).

## IntelliSense, format, fold

Suggestions appear while you type; `Ctrl+Space` forces them. `Tab` or `Enter` accepts. Format on save/paste/type is off until you enable it in settings.

Click the gutter chevrons to fold. `#region` / `#endregion` (or the language’s marker) still work. Indentation is auto-detected; click the status-bar spaces/tabs indicator to convert.

## Encoding, overtype, compare

The status bar shows encoding and indent. Click encoding to reopen or save as another charset.

Overtype (`OVR` in the status bar) overwrites instead of inserting. Toggle it from the Command Palette.

Compare two files: Explorer → **Select for Compare**, then **Compare with Selected**. Command Palette also has compare-with-clipboard and compare-with-saved.

## This repo

App code is under `apps/demo` and `apps/family-hearth`. Prefer folder search scoped to one of those when you are not changing the Copilot/Grok docs.
