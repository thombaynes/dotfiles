# Session 93ddfbe7-703b-4c80-b360-960412533279

## You

`! pwd`

## Claude

You ran `pwd` and it printed `/Users/tbaynes/tdot`, the dotfiles repo root. What would you like to do next?

## You

The ~/home_repo local-k8s has a make doctor command. I feel like that might make sense here. Perhaps something that checks each module and tells me what each one needs? Do we have anything like that already? Tell me other ideas on what make doctor could do

## Claude

Let me check what exists here and how the other repo does it.

**Short answer:** partly. `make status` already exists, but it answers a different question from `doctor`.

**What we have**
- `make status` runs each `setup.sh` in a dry run (`scripts/status.sh`) and reports "in sync", "N changes", or "skipped by profile". `make status-<module>` lists the individual changes.
- It only reports drift, meaning what `setup.sh` would change. It says nothing about whether the machine is healthy. The `macos` module isn't covered at all.

**How local-k8s does it**
- `doctor` there is a read-only prerequisites check (`scripts/doctor.sh`), separate from `status`. The split is the same one I'd use here: `status` is "what would setup change?" and `doctor` is "is this machine actually working, and what do I still need to do by hand?"

**What `make doctor` could do here**

*Per-module needs (your idea).* Each module could ship an optional `doctor.sh`, next to `setup.sh`, and the Makefile would loop over them. That keeps the checks beside the thing they check. Each one would print a pass or fail line plus the fix. Examples:
- **zsh:** login shell is zsh, and `fzf`, `rg` and `zsh-autosuggestions` are on the path.
- **git:** the SSH signing key exists and is loaded in the agent, `~/.gitconfig-local` is present, and `git config user.email` matches the profile.
- **tmux:** tpm is cloned and the plugins are installed (the `prefix + I` step is manual and easy to forget).
- **nvim:** `nvim --headless "+Lazy! check"` shows no missing plugins, and `:checkhealth` is clean.
- **key-mappings:** the LaunchAgent is loaded (`launchctl list`), not just symlinked.
- **hammerspoon:** it's running and has Accessibility permission.
- **packages:** `brew bundle check`, plus `brew doctor` and leftover packages that aren't in the Brewfile (`brew bundle cleanup` without `--force`).

*Manual steps the repo can't automate.* Right now these live in your head or in `AGENTS.md`:
- Caps Lock is set to Ctrl in System Settings.
- Terminal-specific setup: the Nerd Font is installed, and iTerm2 is reading prefs from the repo.
- Full Disk Access or Accessibility permissions are granted.

*Repo-level checks.*
- A profile is linked and valid. Every key a profile defines exists in all profiles (the "a new value goes in every profile" rule).
- Every `setup.sh` calls `profile_guard` and is in `MODULES`. A new folder in `modules/` that isn't in the Makefile fails the check.
- Every module folder has a row in the `AGENTS.md` table.
- Broken symlinks in `~`, `~/.config` and `~/.local/bin`, which `clear_broken_symlinks` only partly covers.
- Shell scripts pass `shellcheck`.
- Every `setup.sh` uses the dry-run helpers, so a plain command can't run for real during `make status`. A grep for non-helper `ln`, `mkdir`, `defaults write` and similar would catch that.
- `abbreviations.list` has no duplicate or conflicting entries, and the shortcuts sheets are stale compared with their sources (`make shortcuts` would change them).

*Environment sanity.*
- Command Line Tools are installed, and Homebrew or MacPorts matches the profile's `PACKAGE_MANAGER`.
- The two laptops' profiles haven't drifted apart.
- The shell starts quickly. Time `zsh -i -c exit` and warn above a threshold, which catches slow-startup regressions.

**How I'd build it**
- Make it read-only, like `status`.
- Have it exit non-zero if anything fails.
- Give each check three states, ✓ ok, ⚠ warn (optional or manual), and ✗ fail, each with a one-line fix hint.
- Add a `make doctor-<module>` target to match `status-<module>`.
- Optionally fold `status` into `doctor` as its first section.

If you want me to build it, I'd start with a shared `check` helper in `scripts/functions.sh`, `scripts/doctor.sh`, and `doctor.sh` files in the modules with the most manual steps: git, tmux, key-mappings and zsh. Should I go ahead, or trim the list first?

