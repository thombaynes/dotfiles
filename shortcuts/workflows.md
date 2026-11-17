# Workflows

How to get common things done with the shortcuts in this repo. Unlike the other sheets in this folder this one is written by hand (there is no `src/workflows.txt`), so `generate.sh` leaves it alone.

## Review everything that changed (Neovim + fugitive)

Use this before committing, or to check over what an agent did.

1. In Neovim, run `:Git difftool -y`. Every changed file opens in its own tab, already in diff mode: the version from git on one side, your working file on the other.
2. Move between tabs with `gt` / `gT` (or `{n}gt`), and between changes inside a file with `]c` / `[c`.
3. Edit the working-file side as normal. `do` pulls the old text into your side and `dp` pushes yours out.
4. When you are done, go back to the tab you want to keep (`1gt`) and run `:tabonly` to close all the others. If that tab is still in diff mode run `:diffoff! | only` too.

Notes:

- `:Git difftool` (without `-y`) fills the quickfix list with the changed files instead of opening tabs. Step through them with `:cnext` / `:cprev`, and hide the list with `:cclose`.
- The git side is a read-only `fugitive://` buffer, so closing it never loses anything. Only your working file can have unsaved changes.
- `:tabclose` closes a single tab (both splits at once). `:qa` quits everything, and refuses if a file is unsaved.

### Alternative: one file at a time, inline

If you only want to look at the file you are already in, skip the tabs:

| Key          | Action                                                                  |
| ------------ | ----------------------------------------------------------------------- |
| `<leader>hD` | Toggle the deleted lines inline for every hunk in the file (press again to hide) |
| `<leader>hd` | Side-by-side diff of the file against the index                         |
| `<leader>hu` | Preview just the hunk under the cursor, inline                          |

`<leader>hD` is the quick option: the old lines appear in place, so there is no split or tab to close afterwards. Use `:Git difftool -y` when you want to go through many files.
