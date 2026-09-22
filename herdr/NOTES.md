# Herdr

Port of `../tmux` to [Herdr](https://herdr.dev). `setup.sh` symlinks
`config.toml` into `~/.config/herdr/config.toml` and reloads a running server.

`herdr config check` validates the file, including per-binding key syntax
(an unparseable key is reported and that one binding is disabled). `prefix+R`
or `herdr server reload-config` applies changes without detaching.

## Carried over from .tmux.conf

| tmux | Herdr |
| --- | --- |
| `set -g prefix C-Space` | `prefix = "ctrl+space"` |
| `bind-key R source-file` | `reload_config = "prefix+shift+r"` |
| `bind-key r` restart Rails | `[[keys.command]]` on `prefix+r`, type `shell` |
| `bind-key \\ split-window -h` | `split_vertical = "prefix+backslash"` |
| `bind-key - split-window -v` | `split_horizontal = "prefix+minus"` |
| `C-h/j/k/l` pane focus | `focus_pane_*` on `prefix+h/j/k/l` (see below) |
| `C-\ select-pane -l` | `last_pane = "prefix+ctrl+backslash"` |
| `bind-key b break-pane -d` | `[[keys.command]]` on `prefix+B` driving the CLI |
| `mode-keys vi` | `copy_mode = "prefix+["`; Herdr's copy mode is already vi-keyed |
| `bind c new-window` | `new_tab = "prefix+c"` |
| `-c '#{pane_current_path}'` | `terminal.new_cwd = "follow"` |
| windows | tabs: `prefix+c/p/n`, `prefix+1..9`, `prefix+X` |

## Deliberate differences

- **Pane focus stays behind the prefix.** tmux bound bare `C-h/j/k/l` and used
  an `is_vim` shell check to pass them through to Vim splits. Herdr has no
  conditional binding, so bare `ctrl+j` / `ctrl+l` / `ctrl+k` would be
  swallowed globally, breaking newline, clear-screen and kill-line in every
  shell and agent pane. The verbatim bindings are commented in `config.toml`.
- **Mouse stays enabled.** `.tmux.conf` forced keyboard-only. Herdr describes
  itself as a mouse-first terminal, and two things have no keyboard binding at
  all: the right-click pane context menu, and clicking URLs in pane output.
  Everything else (border-drag resize, sidebar/tab clicks, scrollback, select
  and copy) has a keyboard path. Opt out via the commented `mouse_capture`.
- **`prefix+r` is Rails restart, not resize mode.** Matches tmux; Herdr's
  `resize_mode` moved to `prefix+ctrl+r`.
- **`prefix+B` for break-pane, not `prefix+b`.** `prefix+b` is Herdr's
  `toggle_sidebar`.

## No Herdr equivalent

- `status-keys emacs`, `escape-time 0`, `default-terminal screen-256color`
  Herdr handles all three internally; nothing to configure.
- `focus-events on` — forwarded to panes natively, so Vim autoread works.
- `base-index 1` / `renumber-windows` / `pane-base-index` — Herdr tabs are
  already 1-indexed and its pane/tab IDs are opaque handles.
- Status bar (`status-bg #666666`, `status-fg #aaaaaa`, `status-left-length`,
  `status-right` date/time). Herdr has a sidebar instead. The nearest knobs are
  `[theme]` / `[theme.custom]` and `[ui.sidebar.*]` row templates.
- `bind -n S-Left/Right/Up/Down resize-pane` — Herdr has no direct-resize
  action, only `resize_mode` (`prefix+ctrl+r`, then `h/l` width, `j/k` height,
  `esc` to finish).

## Worth eyeballing once

- **Split orientation.** Herdr names splits after the divider, so
  `split_vertical` should be side-by-side (tmux `-h`) and `split_horizontal`
  stacked (tmux `-v`). That is inferred from the naming and from
  `split_horizontal` defaulting to `minus`, not confirmed by running it. If
  `prefix+\` stacks instead of splitting sideways, swap the two values.
- **Rails restart cwd.** tmux's `run-shell` ran relative to the pane. Herdr's
  `type = "shell"` runs detached and its working directory is undocumented; if
  `touch tmp/restart.txt` lands in the wrong place, make the command an
  absolute path or wrap it in `cd`.
- **break-pane needs `jq`** (already in `../packages/Brewfile` territory —
  it is installed via Homebrew).
