# Neovim

Leader is `Space`. Plugins: lazy.nvim, fugitive, gitsigns, fzf, neo-tree, which-key, lualine, tmux-navigator, neotest, blink.cmp, conform, render-markdown, markdown-preview, built-in LSP.

## Files & Navigation

| Key         | Action               | Key         | Action                                |
| ----------- | -------------------- | ----------- | ------------------------------------- |
| `<leader>p` | Find files (fzf-lua) | `<leader>o` | Find symbols / classes (fzf-lua, LSP) |
| `<leader>e` | Toggle file tree     | `<leader>?` | Show buffer keymaps                   |
| `<leader>-` | Maximise window      | `<leader>=` | Equalise windows                      |

## Render

| Key          | Action                                                                                   | Key          | Action                                                              |
| ------------ | ---------------------------------------------------------------------------------------- | ------------ | ------------------------------------------------------------------- |
| `<leader>rm` | Toggle in-buffer markdown preview (render-markdown)                                      | `<leader>rb` | Open / close live markdown preview in the browser (renders mermaid) |
| `<leader>rh` | Render the Helm chart template in a split (yaml; prompts for a values-*.yaml if several) | `<leader>rp` | Render the mermaid block under the cursor (or a .mmd file) with mmdc and open it in Preview |

## Tabs

| Key          | Action                            | Key         | Action                              |
| ------------ | --------------------------------- | ----------- | ----------------------------------- |
| `gt`         | Next tab                          | `gT`        | Previous tab                        |
| `{n}gt`      | Go to tab number n                | `:tabnew`   | New empty tab                       |
| `:tabe file` | Open file in a new tab            | `<C-w>T`    | Move current split into its own tab |
| `:tabclose`  | Close current tab                 | `:tabonly`  | Close all other tabs                |
| `:tabs`      | List tabs and the windows in them | `:tabm {n}` | Move tab to position n              |

## Editing

| Key       | Action                                          | Key          | Action             |
| --------- | ----------------------------------------------- | ------------ | ------------------ |
| `Y`       | Yank to end of line                             | `<leader>ss` | Toggle spell check |
| `*` / `#` | Visual mode: search for the selection (default) |              |                    |

## LSP

| Key         | Action                 | Key         | Action                |
| ----------- | ---------------------- | ----------- | --------------------- |
| `gd`        | Go to definition       | `gD`        | Go to type definition |
| `K`         | Hover docs             | `grn`       | Rename                |
| `gra`       | Code action            | `grr`       | References            |
| `gri`       | Implementation         | `gO`        | Document symbols      |
| `[d` / `]d` | Prev / next diagnostic | `<leader>d` | Line diagnostics      |

## Git (gitsigns)

| Key          | Action                                  | Key          | Action             |
| ------------ | --------------------------------------- | ------------ | ------------------ |
| `]c` / `[c`  | Next / prev hunk                        | `<leader>hp` | Preview hunk       |
| `<leader>hu` | Preview hunk inline                     | `<leader>hs` | Stage hunk         |
| `<leader>hr` | Reset hunk                              | `<leader>hd` | Diff against index |
| `<leader>hD` | Toggle deleted lines inline (all hunks) | `<leader>hb` | Toggle line blame  |
| `<leader>hB` | Full blame for line                     |              |                    |

## Completion (blink.cmp) and formatting

| Key               | Action                               | Key         | Action                                              |
| ----------------- | ------------------------------------ | ----------- | --------------------------------------------------- |
| `<leader>c`       | Toggle autocomplete (off by default) | `<C-space>` | Open completion menu by hand                        |
| `<C-n>` / `<C-p>` | Select next / prev item              | `<C-y>`     | Accept item                                         |
| `<C-e>`           | Hide menu                            | `<leader>f` | Format file (prettier, if the project has a config) |

## Testing (neotest)

| Key         | Action           | Key         | Action              |
| ----------- | ---------------- | ----------- | ------------------- |
| `<leader>t` | Run spec file    | `<leader>s` | Run nearest spec    |
| `<leader>l` | Run last spec    | `<leader>a` | Run all specs       |
| `<leader>R` | Show spec output | `<leader>S` | Toggle spec summary |

